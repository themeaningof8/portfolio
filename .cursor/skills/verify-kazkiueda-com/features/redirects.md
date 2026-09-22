# Redirects to case-study

Hiring readers who open `/` or the legacy `/portfolio` URL should land on the case-study listing without a password prompt.

## Sub-features

- `redirect-root` — `GET /` responds with a redirect to `/case-study`.
- `redirect-portfolio` — `GET /portfolio` responds with a redirect to `/case-study`.
- `redirect-follow` — following either redirect yields a successful `/case-study` document.

## How to get to it (user POV)

- Open `https://<host>/` (or local `VERIFY_BASE/`).
- Open `https://<host>/portfolio` (legacy share link).

## Driving it with browser/HTTP

Preconditions:

- Verification server is up; `helpers/doctor.sh` passes.
- `VERIFY_BASE` is set.

- **Root redirect.** Request headers only. Run `curl -sI "$VERIFY_BASE/"`. Status is `302` (or `301`) and `Location` contains `/case-study`.
- **Portfolio redirect.** Run `curl -sI "$VERIFY_BASE/portfolio"`. Same expectation as root.
- **Follow to document.** Run `curl -sI -L "$VERIFY_BASE/"` and confirm the final URL path is `/case-study` with a success status. (Skeleton: save headers under `artifacts/redirects/`.)
- **Proof.** Write the raw header dumps to `artifacts/redirects/root.headers.txt` and `artifacts/redirects/portfolio.headers.txt`.

## Gotchas

- Astro config uses **302**; do not require 301.
- Do not treat `wrangler pages dev` as required for this feature — `astro dev` / `preview` is enough for redirect proof.
- Browser auto-follow can hide the intermediate status; prefer `curl -sI` for the redirect itself.
