---
name: Never submit final Graphite PR without explicit permission
description: CRITICAL: Orchestrator must never call gt submit --draft for final PR submission without user's explicit "submit" or "create PR" command
type: feedback
---

**Rule:** NEVER submit final Graphite PRs autonomously. EVER.

**Why:** Final PR submission is a deliberate, visible action that initiates review and changes workflow state. Submitting without permission breaks the user's intended development rhythm and can cause irreversible state changes (PRs merged, branches locked, reviews started unexpectedly).

**How to apply:**
- Even if all tests pass and code is ready, wait for explicit user command
- User must say "submit PR" / "create PR" / "submit to Graphite" or equivalent
- If code is ready but user hasn't asked for PR: report status and ask "ready to submit?"
- WIP PRs (`--draft`) on feature branches need user approval too, but less critical than final submission
- When uncertain: ask before submitting anything to GitHub

**Exception:** None. This rule has no exceptions.

**Additional:** T6-T9 also need code review via WIP PRs before being submitted as final. Don't mark tasks complete or assume readiness without user sign-off.
