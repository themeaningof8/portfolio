#!/usr/bin/env bash
# Cloud Agent install: Bun deps + TypeSafe CLI via Vercel AI Gateway wrapper.
# Idempotent. Do not print secrets (AI_GATEWAY_API_KEY / TYPESAFE_*).
set -euo pipefail

export PATH="${HOME}/.bun/bin:${HOME}/.local/bin:${PATH}"

BUN_VERSION="$(tr -d '[:space:]' < .bun-version 2>/dev/null || echo 1.3.5)"
if ! command -v bun >/dev/null 2>&1 || [[ "$(bun --version 2>/dev/null || true)" != "${BUN_VERSION}" ]]; then
  curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"
  export PATH="${HOME}/.bun/bin:${HOME}/.local/bin:${PATH}"
fi

bun install --frozen-lockfile
bash scripts/cloud-agent-typesafe-gateway.sh

echo "cloud-agent install complete (bun $(bun --version); typesafe wrapper ok)"
