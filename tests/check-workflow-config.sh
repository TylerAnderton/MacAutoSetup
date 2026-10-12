#!/usr/bin/env bash
# Read-only validator for the Claude Code / Cursor workflow config.
#
# Default mode checks the checkout this script lives in and never consults $HOME,
# so it works in any worktree. --installed checks the live links under $HOME and
# must only be run from the main checkout once the branch is checked out there.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE="$ROOT/dotfiles/claude/User/.claude"
SKILLS="$CLAUDE/skills"
RULES="$ROOT/dotfiles/Cursor/.cursor/rules"
CUSTOM_SKILLS=(plan-with-review tdd-with-review jira-tickets)
DOCS=(README workflow skills cursor-claude-compat design-decisions)

pass=0
fail=0

check() {
  local desc="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass=$((pass + 1))
    echo "ok   $desc"
  else
    fail=$((fail + 1))
    echo "FAIL $desc"
  fi
}

has() { grep -qF -- "$2" "$1"; }
lacks() { ! grep -qF -- "$2" "$1" 2>/dev/null; }

# Frontmatter: first line ---, name equals folder, description present and <= 1024 chars.
valid_frontmatter() {
  local dir="$1" file="$1/SKILL.md"
  [ -f "$file" ] || return 1
  [ "$(head -n 1 "$file")" = "---" ] || return 1
  local name desc
  name=$(awk '/^---$/ {n++; next} n==1 && /^name:/ {sub(/^name: */, ""); print; exit}' "$file")
  desc=$(awk '/^---$/ {n++; next} n==1 && /^description:/ {sub(/^description: */, ""); print; exit}' "$file")
  [ "$name" = "$(basename "$dir")" ] || return 1
  [ -n "$desc" ] && [ "${#desc}" -le 1024 ]
}

real_dir() { [ -d "$1" ] && [ ! -L "$1" ]; }

# Files and directories that make up the active config. Missing paths are skipped
# here because their existence is asserted separately.
existing() {
  local p
  for p in "$@"; do [ -e "$p" ] && printf '%s\n' "$p"; done
}

no_match() { # extended regex, paths...
  local re="$1"
  shift
  local paths
  paths=$(existing "$@")
  [ -z "$paths" ] && return 0
  # shellcheck disable=SC2086
  ! echo "$paths" | xargs grep -rIiE -- "$re" 2>/dev/null | grep -q .
}

drift_free() {
  [ -x "$ROOT/scripts/sync-cursor-rule.sh" ] || return 1
  diff -q <("$ROOT/scripts/sync-cursor-rule.sh") "$RULES/workflow.mdc"
}

ACTIVE=(
  "$CLAUDE/settings.json" "$CLAUDE/CLAUDE.md" "$CLAUDE/WORKFLOW.md" "$CLAUDE/.gitignore"
  "$RULES" "$ROOT/bootstrap.sh" "$ROOT/README.md" "$ROOT/Brewfile"
)
for s in "${CUSTOM_SKILLS[@]}"; do ACTIVE+=("$SKILLS/$s"); done

HOME_FREE=("$CLAUDE/settings.json" "$CLAUDE/CLAUDE.md" "$CLAUDE/WORKFLOW.md" "$RULES" "$ROOT/docs")
for s in "${CUSTOM_SKILLS[@]}"; do HOME_FREE+=("$SKILLS/$s"); done

run_default() {
  echo "== structure"
  for s in "${CUSTOM_SKILLS[@]}"; do
    check "skill $s is a real directory" real_dir "$SKILLS/$s"
    check "skill $s has valid frontmatter" valid_frontmatter "$SKILLS/$s"
  done
  check "dotfiles/agents is gone" test ! -e "$ROOT/dotfiles/agents"
  check "init-from-cursor is gone" test ! -e "$SKILLS/init-from-cursor"
  check "update-from-cursor is gone" test ! -e "$SKILLS/update-from-cursor"
  check "plan-with-review owns the worktree reference" test -f "$SKILLS/plan-with-review/references/worktree.md"

  echo "== deterministic core"
  check "WORKFLOW.md exists" test -f "$CLAUDE/WORKFLOW.md"
  check "CLAUDE.md imports WORKFLOW.md" has "$CLAUDE/CLAUDE.md" "@WORKFLOW.md"
  for n in 1 2 3 4; do
    check "CLAUDE.md keeps section $n" grep -q "^## $n\. " "$CLAUDE/CLAUDE.md"
  done
  check "CLAUDE.md drops old section 5" lacks "$CLAUDE/CLAUDE.md" "## 5. Code Review Workflow"
  check "CLAUDE.md drops old section 6" lacks "$CLAUDE/CLAUDE.md" "## 6. Planning & TDD Workflow"
  for needle in "plannotator review --diff-type unstaged" "/compact" "/summarize" "Plan mode" "worktree" "docs/" "annotate" "pyright"; do
    check "WORKFLOW.md mentions: $needle" has "$CLAUDE/WORKFLOW.md" "$needle"
  done

  echo "== cursor"
  check "workflow.mdc exists and is alwaysApply" has "$RULES/workflow.mdc" "alwaysApply: true"
  check "workflow.mdc matches sync output" drift_free
  check "old plannotator-workflow.mdc is gone" test ! -e "$RULES/plannotator-workflow.mdc"
  check "cursor hooks.json is gone" test ! -e "$ROOT/dotfiles/Cursor/.cursor/hooks.json"
  check "cursor hooks dir is gone" test ! -e "$ROOT/dotfiles/Cursor/.cursor/hooks"

  echo "== skills content"
  check "tdd-with-review runs pyright" has "$SKILLS/tdd-with-review/SKILL.md" "pyright"
  check "tdd-with-review leaves ruff to projects" lacks "$SKILLS/tdd-with-review/SKILL.md" "ruff check"
  check "tdd-with-review reviews unstaged" has "$SKILLS/tdd-with-review/SKILL.md" "--diff-type unstaged"
  check "tdd-with-review reviews docs with annotate" has "$SKILLS/tdd-with-review/SKILL.md" "plannotator annotate"
  for f in tdd-discipline writing-good-tests LICENSE-superpowers; do
    check "tdd-with-review has references/$f.md" test -f "$SKILLS/tdd-with-review/references/$f.md"
  done
  check "skills and core do not depend on superpowers" \
    no_match 'superpowers:' "$CLAUDE/WORKFLOW.md" "$CLAUDE/CLAUDE.md" "$SKILLS/plan-with-review" "$SKILLS/jira-tickets" "$SKILLS/tdd-with-review/SKILL.md"
  check "obsidian paths are asked for, not assumed" \
    no_match 'Obsidian Vault' "$CLAUDE/WORKFLOW.md" "$SKILLS/plan-with-review" "$SKILLS/jira-tickets"
  check "plan-with-review explains the compact pause" has "$SKILLS/plan-with-review/SKILL.md" "/compact"
  check "jira-tickets asks for the Tickets folder" has "$SKILLS/jira-tickets/SKILL.md" "Tickets"
  check "jira-tickets forbids plan mode" has "$SKILLS/jira-tickets/SKILL.md" "Plan mode"

  echo "== settings"
  check "settings.json parses" python3 -m json.tool "$CLAUDE/settings.json"
  check "sed write guard kept" has "$CLAUDE/settings.json" "Write operations forbidden"
  check "ruff hook runs check" has "$CLAUDE/settings.json" "ruff check"
  check "ruff hook runs format" has "$CLAUDE/settings.json" "ruff format"
  check "worktree parent dir is allowed" has "$CLAUDE/settings.json" "~/Repositories"
  check "bootstrap.sh syntax" bash -n "$ROOT/bootstrap.sh"

  echo "== banned references"
  check "no caveman / graphite / gt / uv / commit-gate flag in active config" \
    no_match 'caveman|graphite|\bgt (create|log|restack|submit)\b|\buv\b|plannotator-reviewed' "${ACTIVE[@]}"
  check "no hardcoded home paths in new config" \
    no_match '/Users/|/home/' "${HOME_FREE[@]}"

  echo "== docs"
  for d in "${DOCS[@]}"; do
    check "docs/$d.md exists" test -f "$ROOT/docs/$d.md"
    [ "$d" = README ] || check "docs/README.md indexes $d.md" has "$ROOT/docs/README.md" "$d.md"
  done
}

run_installed() {
  echo "== installed state"
  check "~/.claude resolves to this checkout" \
    test "$(cd -P "$HOME/.claude" && pwd)" = "$(cd -P "$CLAUDE" && pwd)"
  for s in "${CUSTOM_SKILLS[@]}"; do
    check "~/.claude/skills/$s/SKILL.md exists" test -f "$HOME/.claude/skills/$s/SKILL.md"
    if [ -e "$HOME/.agents/skills/$s" ]; then
      echo "WARN ~/.agents/skills/$s exists; Cursor will list $s twice"
    fi
  done
  check "~/.cursor/rules/workflow.mdc exists" test -f "$HOME/.cursor/rules/workflow.mdc"
}

case "${1:-}" in
  --installed) run_installed ;;
  "") run_default ;;
  *) echo "usage: $0 [--installed]" >&2; exit 2 ;;
esac

echo
echo "passed: $pass  failed: $fail"
[ "$fail" -eq 0 ]
