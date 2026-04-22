---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

<objective>
Write test first. Watch fail. Write minimal code to pass.
</objective>

<essential_principles>
**IRON LAW:**

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before test? Delete it. Start over.

No exceptions:
- Don't keep as "reference"
- Don't "adapt" while writing tests
- Don't look at it
- Delete means delete

**Red Flags - STOP, start over:**
- Code before test
- Test after implementation
- Test passes immediately
- Can't explain why test failed
- Tests added "later"
- Rationalizing "just this once"
- "I already manually tested it"
- "Tests after achieve same purpose"
- "It's about spirit not ritual"
- "Keep as reference" or "adapt existing code"
- "Already spent X hours, deleting is wasteful"
- "TDD is dogmatic, I'm being pragmatic"
</essential_principles>

<quick_start>
**Red-Green-Refactor:**

1. **RED** - Write minimal failing test for one behavior
2. **GREEN** - Write simplest code that passes the test (no features, no refactor)
3. **REFACTOR** - Clean up after green (remove duplication, improve names)

Next feature = next failing test. Repeat.
</quick_start>

<intake>
The user wants you to implement a feature or bugfix.
</intake>

<routing>
- If intake is "implement feature" or "implement bugfix": Route to workflows/red-green-refactor.md
- If intake is "write test for existing code": Standard TDD not required — verify tests exist and pass
</routing>

<subagent_orchestration>
When TDD runs inside `subagent-dev`, the RED-GREEN-REFACTOR cycle maps to agent dispatches. The orchestrator owns all test execution via `testing-worktree-uv`. Subagents (tester, code-writers, bug-fixers) NEVER run tests themselves.

**Dispatch order per task (mandatory):**

1. **RED** → dispatch `tester` to feature worktree
   - Tester writes test files, commits with `gt modify`
   - Tester reports: files written, bazel targets, expected failure description
   - Orchestrator runs `testing-worktree-uv` to confirm FAIL
   - No implementer dispatched until orchestrator confirms RED

2. **GREEN** → dispatch implementer (`light-code-writer` or `heavy-code-writer`) to feature worktree
   - Implementer writes minimal code to pass the tests, commits with `gt modify`
   - Implementer reports DONE with bazel targets + worktree path

3. **GREEN verify** → orchestrator runs `testing-worktree-uv` to confirm PASS
   - If FAIL: orchestrator dispatches `light-bug-fixer` with failure output → fixer commits fix → orchestrator re-runs `testing-worktree-uv` (repeat until PASS)

**Serialization rule:** only one temp-test branch may exist at a time across ALL feature branches. `testing-worktree-uv` creates temp-test branches on the main checkout. Never invoke `testing-worktree-uv` while a temp-test branch exists.

**Test files belong in the worktree** alongside production code. Commit them with `gt modify` before the first temp-test run, so they appear on the feature branch tip when temp-test is created.
</subagent_orchestration>
