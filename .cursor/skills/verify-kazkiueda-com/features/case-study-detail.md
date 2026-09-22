# Case-study detail

A detail page presents one study as a readable article, with optional TOC navigation and related links.

## Sub-features

- `detail-load` — `/case-study/<slug>` shows `#main-content` and lead heading `#case-study-lead`.
- `detail-toc` — TOC nav (`aria-label="このページのセクション"`) links via `a[data-toc-anchor]` when headings exist.
- `detail-back` — back control returns toward the listing (`/case-study`).
- `detail-related` — related studies (when rendered) link to other `/case-study/<id>` paths.

## How to get to it (user POV)

- From the listing, open a case-study card/link.
- Open a known slug URL directly (e.g. `/case-study/ooui`).

## Driving it with browser/HTTP

Preconditions:

- Doctor OK.
- Pick a real slug from `src/content/case-studies/` (default stub: `ooui`).

- **Load.** Open `$VERIFY_BASE/case-study/ooui`. Observable: `#main-content`, `#case-study-lead`.
- **TOC (when present).** Click an `a[data-toc-anchor]`. Observable: URL hash matches; target heading `id` in view / `aria-current="location"` on the active TOC link after scroll spy.
- **Back.** Activate the header back control (`aria-label` typically `戻る`). Observable: listing URL `/case-study`.
- **Proof (stub).** Screenshot article chrome into `artifacts/case-study-detail/detail.png`.

## Gotchas

- Not every article may expose a rich TOC — if no `data-toc-anchor`, skip TOC sub-feature and report why.
- Shared-element / view transitions can delay paint; wait for `#case-study-lead`, not a fixed sleep alone.
- Skeleton: precise harness commands TBD.
