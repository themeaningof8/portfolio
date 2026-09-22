# Theme toggle

Readers can switch light/dark from the header; the choice persists in `localStorage` and must not follow OS changes after an explicit choice.

## Sub-features

- `theme-toggle-click` — header `[data-theme-toggle]` flips `html` between `light` and `dark` (and `color-scheme`).
- `theme-label` — button `aria-label` reflects the *next* action (ライトテーマに切り替え / ダークテーマに切り替え).
- `theme-persist` — reload keeps the stored theme from `localStorage` key `kazkiueda-theme`.

## How to get to it (user POV)

- On any portfolio layout page (listing, detail, about), use the theme button in the header.

## Driving it with browser/HTTP

Preconditions:

- Doctor OK.
- Fresh browser context (no prior `kazkiueda-theme`).

- **Initial.** Note `document.documentElement.classList` (`light` or `dark` from `prefers-color-scheme` when unset).
- **Toggle.** Click `[data-theme-toggle]`. Observable: opposite theme class on `html`; icon/`aria-label` updated.
- **Persist.** Reload. Observable: same theme as after toggle; `localStorage.kazkiueda-theme` matches.
- **Proof (stub).** Screenshots before/after in `artifacts/theme-toggle/` plus a one-line dump of `localStorage` / `html.className`.

## Gotchas

- First visit without storage follows OS preference; do not assert a fixed starting theme across machines.
- After an explicit toggle, OS preference changes must **not** override — proving that needs an OS/theme emulation step (optional; stub).
- Skeleton: exact browser automation commands TBD.
