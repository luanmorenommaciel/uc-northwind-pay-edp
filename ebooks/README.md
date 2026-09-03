# Ebooks — the method kits

The three kits the Nights **park** on and **return** from: Converge,
SeamWise, Task-Spec. Until Night 4 they lived in `presentation/` as HTML
decks (`cvg-aut-systems-spine-steps.html`, `seamwise.html`,
`task-spec.html`). Those decks were moved here, rendered to books, and the
HTML was dropped from git (`f06e5c5`). What remains is the brief source and
the rendered book.

| Kit | Brief source (tracked) | Rendered book | Pass |
|---|---|---|---|
| Converge | [`brf-converge.md`](brf-converge.md) | [`ebook-converge.pdf`](ebook-converge.pdf) | the spine, 0–8, one human barrier |
| SeamWise | [`brf-seamwise.md`](brf-seamwise.md) | [`ebook-seamwise.pdf`](ebook-seamwise.pdf) | Pass 3 · Decompose |
| Task-Spec | [`brf-task-spec.md`](brf-task-spec.md) | `ebook-task-spec.pdf` — **gitignored** (111 MB); build locally | Pass 5 · Tasking. Mesh is **not** inside it |

`brief-converge-trv.src.html` + `build-brief-converge-trv.py` render the
Converge travel reference; intermediates land in `ebooks/build/` and the
`*-trv.pdf` output is gitignored.

The `brf-*.md` headers still name `presentation/*.html` as their **target
deck** and an absolute path as their canonical product source. Those are
the construction briefs as authored on 2026-08-26; the target decks no
longer exist in this repo.

These are manuals, not the Night clock. Leave the Night HUD, teach the
kit, **return** to the numbered beat in [`run/`](../run/README.md). Do not
paste Pass 3 or Pass 5 execute from inside a kit. Papers go to
[`docs/`](../docs/README.md).
