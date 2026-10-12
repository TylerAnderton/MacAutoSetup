#!/usr/bin/env bash
# Generate the Cursor rule from the workflow core file.
# The .mdc format cannot import files, so the core text is inlined here instead of hand-copied.
# No arguments: print the rule to stdout. --write: update the committed rule file.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/dotfiles/claude/User/.claude/WORKFLOW.md"
DEST="$ROOT/dotfiles/Cursor/.cursor/rules/workflow.mdc"

render() {
  cat <<'EOF'
---
description: Core plan, TDD, and review workflow. Always follow.
alwaysApply: true
---

<!-- Generated from dotfiles/claude/User/.claude/WORKFLOW.md by scripts/sync-cursor-rule.sh. Do not edit. -->

EOF
  cat "$SRC"
}

case "${1:-}" in
  --write) mkdir -p "$(dirname "$DEST")" && render >"$DEST" ;;
  "") render ;;
  *) echo "usage: $0 [--write]" >&2; exit 2 ;;
esac
