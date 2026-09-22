# About

About gives hiring readers a short career/context page and a way back to the case-study listing.

## Sub-features

- `about-load` — `/about` shows `#main-content` and career section `#about-career-heading`.
- `about-to-listing` — in-page or header navigation returns to `/case-study`.
- `about-from-header` — listing/detail header About link opens `/about`.

## How to get to it (user POV)

- Choose About in the site header from listing or detail.
- Open `/about` directly.
- Use the in-page link back to ケーススタディ when present.

## Driving it with browser/HTTP

Preconditions:

- Doctor OK; listing reachable.

- **From header.** On `/case-study`, activate About. Observable: `/about`, `#about-career-heading`.
- **Return.** Activate ケーススタディ / back toward listing. Observable: `/case-study`.
- **Direct.** `curl -sf -o /dev/null "$VERIFY_BASE/about"` succeeds (HTTP 200).
- **Proof (stub).** Screenshot `artifacts/about/about.png`.

## Gotchas

- About label is prop-driven (often English `About`) — match accessible name, not a hard-coded Japanese string.
- Skeleton: harness command lines TBD.
