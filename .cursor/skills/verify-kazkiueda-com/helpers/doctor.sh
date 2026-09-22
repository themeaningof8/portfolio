#!/usr/bin/env bash
# Read-only health check for a verify-kazkiueda-com instance.
set -euo pipefail

VERIFY_BASE="${VERIFY_BASE:-http://127.0.0.1:4321}"
VERIFY_BASE="${VERIFY_BASE%/}"

fail() {
  echo "doctor FAIL: $*" >&2
  exit 1
}

echo "doctor: VERIFY_BASE=$VERIFY_BASE"

curl -sf -o /dev/null --max-time 5 "$VERIFY_BASE/case-study" \
  || fail "/case-study did not return success"

status_case="$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$VERIFY_BASE/case-study")"
[[ "$status_case" == "200" ]] || fail "/case-study status=$status_case (want 200)"
echo "doctor: /case-study -> $status_case"

check_redirect() {
  local path="$1"
  local headers
  headers="$(curl -sI --max-time 5 "$VERIFY_BASE$path")" || fail "$path headers request failed"
  local code
  code="$(printf '%s' "$headers" | awk 'NR==1 {print $2}')"
  local loc
  loc="$(printf '%s' "$headers" | awk 'tolower($1)=="location:" {print $2}' | tr -d '\r')"
  [[ "$code" == "302" || "$code" == "301" ]] || fail "$path status=$code (want 302/301)"
  [[ "$loc" == *"/case-study"* ]] || fail "$path Location=$loc (want */case-study*)"
  echo "doctor: $path -> $code Location=$loc"
}

check_redirect "/"
check_redirect "/portfolio"

echo "doctor OK"
