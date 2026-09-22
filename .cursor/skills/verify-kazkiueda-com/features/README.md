# kazkiueda.com verification map

Maintained source for verifying user-facing behavior. Read this index before driving, then open the matching feature file.

**Status:** skeleton — Launch/Doctor/HTTP redirects are concrete; browser Drive steps are stubs.

## Baseline preconditions

- Launch with `bun run dev -- --host 127.0.0.1 --port $VERIFY_PORT` (default `4321`). See parent `SKILL.md` **Launch**.
- Set `VERIFY_BASE=http://127.0.0.1:$VERIFY_PORT`.
- Run `bash .cursor/skills/verify-kazkiueda-com/helpers/doctor.sh` and require exit `0`.
- Never drive an instance you did not start for this verification run.
- Use a fresh browser context so `localStorage` key `kazkiueda-theme` is not the user’s preference.

## Driving conventions

- Start every recipe from baseline unless the feature says otherwise.
- Prefer ARIA names / `data-*` handles listed in `SKILL.md` over coordinates.
- HTTP proofs use `curl`; UI proofs use `computerUse` or Playwright until a project CLI exists.
- Do not delete `artifacts/` during cleanup.

## Proof and skip reporting

- Capture action + resulting state.
- UI proof: screenshot (and ARIA snapshot when available) with page identity visible.
- Redirect proof: status + `Location` header text in `artifacts/<id>/`.
- Record feature ID and entry point with every artifact.
- Unreachable paths: report attempted step + unmet precondition; do not claim another path verified them.

## Feature entry contract

Each feature file: H1 + one paragraph, then exactly these H2s in order:

1. `Sub-features`
2. `How to get to it (user POV)`
3. `Driving it with browser/HTTP` (Preconditions + labeled action/command/result bullets)
4. `Gotchas`

## Features

- [Redirects to case-study](./redirects.md) — `/` and `/portfolio` → `/case-study`
- [Case-study listing](./case-study-listing.md) — index of studies for hiring readers
- [Case-study detail](./case-study-detail.md) — article, TOC, related links
- [About](./about.md) — profile / career page and return to listing
- [Theme toggle](./theme-toggle.md) — light/dark preference in header
