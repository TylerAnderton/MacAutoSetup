#!/usr/bin/env bash
# Block git commit until plannotator review has completed.
# Mirrors Claude Code PreToolUse hook in ~/.claude/settings.json.
set -euo pipefail

input=$(cat)
command=$(echo "$input" | jq -r '.command // empty')

if echo "$command" | grep -qE '\bgit\s+commit\b'; then
  if [ ! -f /tmp/.plannotator-reviewed ]; then
    cat <<'EOF'
{
  "permission": "deny",
  "user_message": "Code review required before committing. Invoke plannotator-review, address any feedback, then retry the commit.",
  "agent_message": "Run the plannotator-review skill first. After approval, the post-review hook sets /tmp/.plannotator-reviewed and unlocks git commit."
}
EOF
    exit 0
  fi
  rm -f /tmp/.plannotator-reviewed
fi

echo '{"permission": "allow"}'
exit 0
