---
name: Never mark PR ready without explicit permission
description: CRITICAL: Never run gh pr ready autonomously. gt submit --draft for dev iteration is OK, but marking a draft PR ready requires explicit user instruction.
type: feedback
---

**Rule:** NEVER run `gh pr ready` (marking a draft PR ready for review/merge) without explicit user instruction.

**Why:** Marking a PR ready is a deliberate, visible action that initiates formal review. Running it autonomously breaks the user's intended development rhythm and can cause irreversible state changes (reviews started unexpectedly, merge queues triggered).

**How to apply:**
- `gt submit --draft` for dev iteration is OK to run autonomously
- `gh pr ready <number>` requires explicit user command ("mark ready", "submit for review", "take it out of draft")
- If code is ready but user hasn't asked: report status and ask "ready to mark PR as ready?"
- When uncertain: ask before running `gh pr ready`

**Exception:** None. This rule has no exceptions for `gh pr ready`.
