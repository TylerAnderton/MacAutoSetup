---
name: Workflow Preferences
description: How the user wants Claude to approach development tasks in this project
type: feedback
---

Use Test-Driven Development: write failing tests first, confirm failure, then implement. Invoke `superpowers:test-driven-development` skill before any feature work.

**Why:** Explicitly requested as a standing workflow requirement.

**How to apply:** Any time a new feature or bugfix is being implemented, TDD is mandatory.

---

Always open a PR when work is complete using `/commit-push-pr`. User prefers reviewing git diffs in the GitHub interface rather than the terminal. **All PRs must be opened as drafts** (`--draft` flag). Only mark ready when explicitly asked.

**Why:** More comfortable review workflow; drafts prevent premature review notifications.

**How to apply:** Never leave work at just a local commit. Always push and open a draft PR.

---

Keep CLAUDE.md lean. Store detailed instructions in skill files; CLAUDE.md should only contain brief references to those skills. When new repeating patterns emerge, propose updating skills/CLAUDE.md — ask before making changes.

**Why:** Avoid CLAUDE.md bloat; skills are a better home for detailed workflow content.

**How to apply:** Propose (don't auto-apply) updates when patterns emerge.
