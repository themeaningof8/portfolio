# Case-study listing

The listing is the primary surface shared with hiring managers: a calm index of case studies with links into each detail page.

## Sub-features

- `listing-load` — `/case-study` shows main content and the case-studies heading.
- `listing-cards` — each study appears as an article linking to `/case-study/<id>`.
- `listing-about` — header About link reaches `/about`.
- `listing-skip` — skip link moves focus/target to `#main-content`.

## How to get to it (user POV)

- Open `/case-study` directly.
- Follow a redirect from `/` or `/portfolio`.
- Return from a detail page or About via header/back affordances.

## Driving it with browser/HTTP

Preconditions:

- Doctor OK at `VERIFY_BASE`.
- Fresh browser context.

- **Load.** Open `$VERIFY_BASE/case-study`. Observable: `#main-content` present; `#case-studies-heading` visible.
- **Cards.** Confirm at least one `article[aria-labelledby^="case-"]` with an `a[href^="/case-study/"]` (IDs from `src/content/case-studies/`, e.g. `ooui`, `design-system`).
- **About.** Activate the header About link. Observable: URL `/about`.
- **Proof (stub).** Screenshot listing into `artifacts/case-study-listing/listing.png` showing heading + at least one card.

## Gotchas

- Card count and order come from the content collection `order` field — do not hard-code titles if asserting order; prefer presence of known `href`s.
- Auth is intentionally absent; a Basic-auth dialog is a failure.
- Skeleton: exact Playwright/`computerUse` command lines TBD.
