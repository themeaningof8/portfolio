#!/usr/bin/env bash
# Idempotent: install typesafeai-cli and wrap it for Vercel AI Gateway.
# Auth: AI_GATEWAY_API_KEY (mapped to TYPESAFE_API_KEY). Never print secrets.
set -euo pipefail

export PATH="${HOME}/.local/bin:${PATH}"

python3 -m pip install --user --upgrade 'typesafeai-cli>=0.3.3' >/dev/null

REAL_BIN="${HOME}/.local/bin/typesafe.bin"
WRAPPER="${HOME}/.local/bin/typesafe"
CURRENT="${HOME}/.local/bin/typesafe"

# Preserve the pip entrypoint once, then keep our wrapper as `typesafe`.
if [[ -x "${CURRENT}" ]] && ! grep -q 'typesafe-ai-gateway-wrapper' "${CURRENT}" 2>/dev/null; then
  mv "${CURRENT}" "${REAL_BIN}"
elif [[ ! -x "${REAL_BIN}" ]]; then
  # pip may have installed under a different layout; resolve via python
  ENTRY="$(python3 -c 'from typesafe_cli.cli import app; import typesafe_cli.cli as m; print(m.__file__)')"
  cat > "${REAL_BIN}" <<EOF
#!/usr/bin/env python3
from typesafe_cli.cli import app
if __name__ == "__main__":
    raise SystemExit(app())
EOF
  chmod +x "${REAL_BIN}"
fi

cat > "${WRAPPER}" <<'EOF'
#!/usr/bin/env bash
# typesafe-ai-gateway-wrapper
# Route TypeSafe CLI through Vercel AI Gateway. Do not echo secrets.
set -euo pipefail
export PATH="${HOME}/.local/bin:${PATH}"
export TYPESAFE_BASE_URL="${TYPESAFE_BASE_URL:-https://ai-gateway.vercel.sh/typesafe}"
export TYPESAFE_DEFAULT_MODEL="${TYPESAFE_DEFAULT_MODEL:-typesafe-ai/jev}"
if [[ -n "${AI_GATEWAY_API_KEY:-}" && -z "${TYPESAFE_API_KEY:-}" ]]; then
  export TYPESAFE_API_KEY="${AI_GATEWAY_API_KEY}"
fi
exec "${HOME}/.local/bin/typesafe.bin" "$@"
EOF
chmod +x "${WRAPPER}"

# Non-interactive shells (Cloud Agents) often skip ~/.bashrc; keep a profile snippet too.
PROFILE_SNIPPET="${HOME}/.config/typesafe/cloud-agent-profile.sh"
mkdir -p "${HOME}/.config/typesafe"
cat > "${PROFILE_SNIPPET}" <<'EOF'
# typesafe-ai-gateway (sourced by cloud-agent start when present)
export PATH="${HOME}/.local/bin:${PATH}"
export TYPESAFE_BASE_URL="${TYPESAFE_BASE_URL:-https://ai-gateway.vercel.sh/typesafe}"
export TYPESAFE_DEFAULT_MODEL="${TYPESAFE_DEFAULT_MODEL:-typesafe-ai/jev}"
if [[ -n "${AI_GATEWAY_API_KEY:-}" && -z "${TYPESAFE_API_KEY:-}" ]]; then
  export TYPESAFE_API_KEY="${AI_GATEWAY_API_KEY}"
fi
EOF

for rc in "${HOME}/.bashrc" "${HOME}/.profile"; do
  if [[ -f "${rc}" ]] && ! grep -q 'typesafe/cloud-agent-profile.sh' "${rc}" 2>/dev/null; then
    printf '\n# typesafe AI Gateway\n[ -f "$HOME/.config/typesafe/cloud-agent-profile.sh" ] && . "$HOME/.config/typesafe/cloud-agent-profile.sh"\n' >> "${rc}"
  fi
done

# Smoke: binary exists; auth may be false until AI_GATEWAY_API_KEY is set.
typesafe auth status >/dev/null
echo "typesafe gateway wrapper ready"
