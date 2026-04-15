---
name: Workflow Preferences
description: How the user wants Claude to approach development tasks in this project
type: feedback
---

Write failing tests first, confirm failure, then implement. Invoke `superpowers:test-driven-development` skill before feature work.

**Why:** Explicit standing requirement.

**How to apply:** When implement feature or bugfix, TDD mandatory.

---

Open PR when work complete using `/commit-push-pr`. User reviews diffs in GitHub interface, not terminal. **All PRs must be opened as drafts** (`--draft` flag). Mark ready only when asked.

**Why:** Comfortable review workflow; drafts prevent premature notifications.

**How to apply:** Never stop at local commit. Push and open draft PR.

---

Keep CLAUDE.md lean. Store detailed instructions in skill files; CLAUDE.md only brief references. When patterns emerge, propose updates — ask before changing.

**Why:** Avoid CLAUDE.md bloat; skills house detailed workflow content better.

**How to apply:** Propose updates when patterns emerge; don't auto-apply.