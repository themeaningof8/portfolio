---
name: verify-kazkiueda-com
description: "Drive kazkiueda.com (Astro static portfolio / case-study site) the way a hiring reader would — browser + HTTP. Use when proving /case-study, /about, theme toggle, or redirect behavior after UI or routing changes."
---

# Verify kazkiueda.com

Project-local verification skill. Read cold mid-task: launch the real app, exercise a mapped user path, capture evidence, then clean up. **This file is a skeleton** — Launch / Doctor / HTTP redirects are runnable; browser Drive recipes in `features/` are stubs to flesh out with `/maintain-verification-skill`.

## Surface

- **Primary:** Web UI for hiring readers — `/case-study` listing + detail, `/about`, header theme toggle.
- **Also:** HTTP redirects `/` → `/case-study`, `/portfolio` → `/case-study` (302). No auth. Search engines are suppressed (`robots`, meta, `X-Robots-Tag`); do not treat indexability as a user path.
- **Not in scope yet:** Cloudflare Pages deploy, Wrangler-only paths, Starwind demo pages under `/starwind` (if present).

## Launch

Default verification instance uses Astro’s local port **4321** and a dedicated host so it does not collide with a human’s `bun run dev`.

```bash
# from repo root, after bun install
VERIFY_HOST=127.0.0.1
VERIFY_PORT=4321
VERIFY_BASE="http://${VERIFY_HOST}:${VERIFY_PORT}"

# if something already answers on VERIFY_PORT, refuse and pick another port
curl -sf -o /dev/null --max-time 1 "$VERIFY_BASE/" && {
  echo "refusing: $VERIFY_BASE already in use; set VERIFY_PORT to a free port" >&2
  exit 1
}

bun run dev -- --host "$VERIFY_HOST" --port "$VERIFY_PORT"
```

**Ready when:** `curl -sf -o /dev/null "$VERIFY_BASE/case-study"` returns HTTP 200 (or follow redirects from `/` and land on `/case-study`).

**Teardown:** kill only the Astro/Vite process you started for this run (record PID at launch). Never `pkill -f astro` / `pkill -f vite`.

**Isolate:** Two agents can run side by side if each uses a different `VERIFY_PORT`. Theme preference lives in `localStorage` key `kazkiueda-theme` — use a fresh browser profile / context per run so you do not inherit the user’s theme.

Optional static path (closer to production): `bun run build && bun run preview -- --host "$VERIFY_HOST" --port "$VERIFY_PORT"`. Prefer `dev` for day-to-day UI proofs unless the change is build/redirect specific.

## Doctor

Run before driving, or whenever the instance looks wrong:

```bash
bash .cursor/skills/verify-kazkiueda-com/helpers/doctor.sh
# or: VERIFY_BASE=http://127.0.0.1:4321 bash .cursor/skills/verify-kazkiueda-com/helpers/doctor.sh
```

Expect exit `0` and lines confirming `/case-study` is 200 and `/` / `/portfolio` redirect toward `/case-study`. If doctor fails, do not drive — fix launch first.

## Drive

Harness (skeleton):

1. **HTTP** — `curl -sI` / `curl -sf` for redirects and status codes (no browser required).
2. **Browser** — Cursor `computerUse` subagent, or Playwright via the `webapp-testing` skill when available. Prefer stable handles:
   - Skip link: `a[href="#main-content"]` (“本文へスキップ”)
   - Main: `#main-content`
   - Listing heading: `#case-studies-heading`
   - Theme toggle: `[data-theme-toggle]` (aria-label toggles between ライト/ダーク)
   - About nav: header link to `/about` (label from props, often `About`)
   - Detail TOC: `nav[aria-label="このページのセクション"]` and `a[data-toc-anchor]`
   - Case cards: `article[aria-labelledby^="case-"]` with links to `/case-study/<id>`

Read `features/README.md`, then the feature file for the path under test. Do not invent entry points that are not in the map.

## Evidence

Store proofs under `.cursor/skills/verify-kazkiueda-com/artifacts/<feature-id>/` (gitignored). Keep artifacts after cleanup.

Proof standards:

- Exercise the real user path (URL / click / keyboard), not internal Astro APIs.
- Capture **action + resulting state** (e.g. click theme toggle + `html` class / screenshot), not only the final screen.
- For redirects: save response headers (`Location`, status) as text.
- For UI: screenshot (and ARIA snapshot when the harness supports it) showing page identity (`#main-content` or brand in header).
- Mocks: none expected for this static site.

## Cleanup

1. Stop only the verification server PID you started.
2. Remove scratch browser profiles / temp dirs created for the run.
3. **Do not** delete `artifacts/` — proofs must survive teardown.

## Helpers

| Helper | Invocation |
|--------|------------|
| Doctor | `bash .cursor/skills/verify-kazkiueda-com/helpers/doctor.sh` |

Browser control CLI is **not** shipped yet — use `computerUse` / Playwright until a thin wrapper is added.

## Feature map

See [`features/README.md`](./features/README.md). Skeleton coverage: redirects, listing, detail, about, theme toggle.
