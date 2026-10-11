# Setting up Cryptonym Desk

One minute. It's a single HTML file with no build step, no dependencies and no server. The steps marked
**CI checks this** run every week on a fresh Ubuntu machine by
[`setup-check`](../.github/workflows/setup-check.yml), which opens the page in headless Chrome and checks
a full record is issued.

## What you need

A modern web browser. That's it. To host your own copy you also need somewhere that serves static files
(GitHub Pages, Cloudflare Pages, any web server).

## 1. Run it locally (CI checks this)

```bash
git clone https://github.com/casareanderson/cryptonym-desk && cd cryptonym-desk
open index.html          # macOS. Linux: xdg-open index.html. Windows: start index.html
```

It works straight from `file://`. Success is the page opening on the Cyberpunk preset with a record
already issued: a cryptonym starting with a two-letter office prefix, a working alias, a field codename,
a cover, station, directorate, clearance and file reference, plus a row of other cryptonyms on file.

## 2. Serve it (CI checks this)

Any static server works. For a quick test:

```bash
python3 -m http.server 8000      # then open http://localhost:8000
```

## 3. Host your own copy on GitHub Pages (not checked by CI)

1. Fork the repo on GitHub.
2. **Delete the `CNAME` file** in your fork. It points at the author's domain, and GitHub Pages won't
   serve your fork on its default address while it's there.
3. In your fork: **Settings → Pages → Build and deployment → Deploy from a branch**, branch `main`,
   folder `/ (root)`. Save.
4. After a minute or two it's live at `https://<your-username>.github.io/cryptonym-desk/`.

To use your own domain instead, put it in a `CNAME` file and follow GitHub's custom-domain steps.

## Make it yours

There are no settings or environment variables. Everything it draws from is a plain array at the top of
the `<script>` block in `index.html`:

| array | what it holds |
|---|---|
| `DIGRAPHS` | office prefixes for the cryptonym (real ones from declassified files) |
| `STATIONS`, `DIRECTORATES`, `CLEARANCES` | the record's furniture |
| `COVER_ROLE`, `COVER_FIRM` | cover job and the firm it's for |
| `ADJ`, `NOUN` | the two halves of the field codename |
| `PRESETS` | the six starter sets |
| `SKIP` | short words dropped before cutting names (`the`, `of`, `and` ...) |

Edit, save, reload. If you change the word banks, the same inputs will give different records from then
on. That's expected: records are seeded from the inputs plus a salt.

## Common surprises

| you see | why |
|---|---|
| typing the same names gives the same record | on purpose. Records are seeded. **Issue new record** gives you a random one. |
| the fonts look plain | the three typefaces load from Google Fonts. Offline, or with fonts blocked, the page falls back to system fonts. Everything else still works. |
| a name with `y` or accented letters cuts oddly | the splitter only treats `a e i o u` as vowels, and drops non-Latin letters. |
| your fork's Pages site shows the author's domain or a 404 | the `CNAME` file is still there (step 3). |

## Privacy

Nothing you type leaves the browser. **CI checks** the page contains no `fetch`, XHR, beacon, websocket
or event-source call. The only thing it loads from outside is the Google Fonts stylesheet.

## Updating and removing

`git pull` to update. Delete the folder (or your fork) to remove it. It stores nothing outside the page.

## What CI can't prove

CI opens the page in headless Chrome, from a file and from a server, and checks every field of the record
is filled and the cryptonym and file reference look right. It doesn't check other browsers, the copy
button (the clipboard needs a real user gesture), how the page looks, or that your GitHub Pages fork is
set up correctly.
