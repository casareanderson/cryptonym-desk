#!/usr/bin/env bash
# Opens index.html in headless Chrome, the way docs/SETUP.md says to (from file:// and from a plain
# web server), and checks a full record is issued. Also checks the page makes no network calls of its own.
# Used by .github/workflows/setup-check.yml. Set CHROME to your Chrome/Chromium binary locally.
set -euo pipefail
step() { printf '\n== %s\n' "$*"; }
CHROME=${CHROME:-google-chrome}
PORT=${PORT:-18099}

render() {   # render <url> -> the DOM after the page's script has run
  timeout 90 "$CHROME" --headless=new --no-sandbox --disable-gpu --virtual-time-budget=5000 \
    --dump-dom "$1" 2>/dev/null
}

check_record() {
  python3 -c '
import html, re, sys
s = sys.stdin.read()
def field(i):
    m = re.search(r"id=\"%s\"[^>]*>(.*?)</(?:div|span|p|h[1-6]|td|dd)>" % i, s, re.S)
    return html.unescape(re.sub(r"<[^>]+>", "", m.group(1))).strip() if m else ""
got = {i: field(i) for i in ["cryptonym", "alias", "codename", "cover", "station", "directorate", "clearance", "fileref"]}
empty = [k for k, v in got.items() if not v]
assert not empty, "empty fields: %s" % empty
assert re.match(r"^[A-Z]{2}", got["cryptonym"]), got["cryptonym"]
assert re.match(r"^[A-Z]+-\d+/\d+$", got["fileref"]), got["fileref"]
alts = s.count("class=\"alt")
assert alts >= 1, "no alternative cryptonyms"
print("record issued: %s / %s / %s (%d alternatives)" % (got["cryptonym"][:14], got["station"], got["clearance"], alts))
'
}

step "1. open from file:// (no server)"
render "file://$PWD/index.html" | check_record

step "2. serve it like GitHub Pages does"
python3 -m http.server "$PORT" --bind 127.0.0.1 >/dev/null 2>&1 & srv=$!
trap 'kill $srv 2>/dev/null || true' EXIT
for i in $(seq 1 20); do curl -sf "localhost:$PORT/index.html" >/dev/null && break; sleep 0.3; done
render "http://127.0.0.1:$PORT/index.html" | check_record

step "nothing typed leaves the browser: no fetch, XHR, beacon or websocket in the page"
if grep -nE "fetch\(|XMLHttpRequest|sendBeacon|new WebSocket|EventSource" index.html; then
  echo "FAIL: the page has a network call"; exit 1
fi
echo "none (the only external load is Google Fonts)"

printf '\nSETUP CHECK PASSED\n'
