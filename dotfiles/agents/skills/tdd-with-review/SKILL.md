---
name: tdd-with-review
description: Use when implementing an approved plan, feature, or bugfix. Writes failing tests first and gets them reviewed in Plannotator before any implementation exists, then runs tests to green before the Plannotator code review that gates the commit.
allowed-tools: Bash(plannotator:*)
---

# TDD With Review

## Steps

1. **RED.** Write failing tests: one behavior per test, real code not mocks, no trivial pass-through tests, cover edge cases. Where `superpowers:test-driven-development` is available, follow its discipline instead of just these principles. Run the tests and confirm they fail for the right reason (feature missing, not a typo).

2. **Review the tests in Plannotator before writing any implementation:**
   ```bash
   plannotator annotate --gate --json <test-file(s)>
   ```
   Iterate until approved.

3. **Implement** the minimal code to pass, per whatever subagent-delegation preference was collected during planning.

4. **GREEN.** Run the tests. If they fail, fix the implementation — never edit the tests to force a pass.

5. **Code review.** Run `/plannotator-review` (Claude Code) or `plannotator review` (Cursor) and require it to return clean before committing, per the standard Code Review Workflow.
