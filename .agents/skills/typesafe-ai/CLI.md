# Using the typesafe CLI

Live evaluations: follow the **typesafe-cli** skill. Prefer `find`, `rank`, `extract`, `verify`, `screen`, `suggest-skill`, and `decide` when those flags fit; otherwise collect local state, write JSON under `${TMPDIR:-/tmp}/codex/<project>/`, then `typesafe ask`. Invalid answers fail closed. Never drop those files in the git tree. This sidecar does not replace that skill or the official TypeSafe skill.

## This project: Vercel AI Gateway

Requests go through **Vercel AI Gateway**, not `api.typesafe.ai` directly.

- Base URL: `https://ai-gateway.vercel.sh/typesafe`
- Auth secret name: `AI_GATEWAY_API_KEY` (Cloud Agent environment secret)
- Default model: `typesafe-ai/jev`
- The `typesafe` binary on Cloud Agents is a thin wrapper (`scripts/cloud-agent-typesafe-gateway.sh`) that maps `AI_GATEWAY_API_KEY` → `TYPESAFE_API_KEY` and sets the Gateway base URL / model.

Application code should use the same pattern (`apiKey` from `AI_GATEWAY_API_KEY`, `baseURL` → Gateway). See [TypeSafe API with AI Gateway](https://vercel.com/docs/ai-gateway/sdks-and-apis/typesafe).

## Secrets

You cannot read, print, or inspect typesafeai-cli env vars or key files (`TYPESAFE_*`, `AI_GATEWAY_API_KEY`, `~/.config/typesafe/env`, `.env.local`). Run `typesafe auth status` (`has_key` only). If false, ask the human to add `AI_GATEWAY_API_KEY` to the Cloud Agent environment secrets.
