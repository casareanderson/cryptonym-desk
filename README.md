# Cryptonym Desk

**Name the films, anime and characters you like. The desk issues you a cryptonym,
a working alias and a field codename built out of them.**

→ **[Open it](https://casareanderson.github.io/cryptonym-desk/)**

One HTML file. No build, no dependencies, no network calls — what you type never
leaves the page.

---

## Why three names, not one

Most name generators hand you a word. Real services use different names for
different jobs, and the distinction is the interesting part:

**The cryptonym** is a two-letter digraph naming the sponsoring office, then a
word chosen to mean nothing — `AEDINOSAUR`, `QKACTIVE`, `LIENVOY`. The digraphs
in the page are real ones from declassified files. Your word is cut from the
material you gave it.

**The working alias** is a person's name, so it has to read like one. It isn't
picked from a list: the desk splits your names at their vowel groups and grafts
the front of one onto the tail of another, then shows you which two it cut
together. `Deckard` × `Kusanagi` is a different kind of object from `AEQUARRY`.

**The field codename** is ADJECTIVE NOUN, for traffic that must not name the
alias.

Plus the furniture that makes it a record rather than a word: cover job and
firm, station, directorate, clearance stamp, file reference.

## How the mashup works

```
Spiegel  ->  ["Spie", "gel"]        split at vowel groups
Kusanagi ->  ["Ku", "sa", "na", "gi"]

front of one + tail of the other  ->  "Spienagi"
```

The splitter is crude on purpose. A proper linguistic syllabifier produces
tidier seams and duller names; the ugly joins are where the good ones come from.
A tripled letter at the seam gets collapsed, so you get `Rippley`, not
`Ripppley`.

## Determinism

Records are seeded from your inputs plus a salt, so the same material and the
same file reference rebuild the same record. **Retyping the same things gives
you the same name** — "Issue new record" is what gets you variety.

## Getting good results

Full names beat single short words: more consonant clusters to cut at. Three or
four pieces of material is plenty, and mixing sources (a title, a character, a
person) gives better seams than four titles from one show.

## Run it anywhere

```bash
git clone https://github.com/casareanderson/cryptonym-desk
open cryptonym-desk/index.html
```

That's the whole deployment. It is one file and it works from `file://`.

## Licence

MIT.
