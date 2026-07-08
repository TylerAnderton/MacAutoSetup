#!/usr/bin/env bash
# Set review-completion flag after plannotator review completes.
# Mirrors Claude Code PostToolUse hook (matcher: Bash(plannotator:*)) — flag on
# command completion, not parsed approval text.
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.command // empty')

if echo "$command" | grep -qE '\bplannotator\s+review\b'; then
  touch /tmp/.plannotator-reviewed
fi

exit 0
