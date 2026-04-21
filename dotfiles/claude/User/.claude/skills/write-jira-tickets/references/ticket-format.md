# Ticket Format

Structure reflects validated format for this repo:

```
**Summary**: `[Type] Short imperative description`

**Issue type**: Task | Story
**Epic link**: <epic name>
**Blocked by**: T_n, T_m  (or "none — root ticket")
**Blocks**: T_n, T_m

---

**Context**

Why this ticket exists. What problem it solves. What the current state is and why it needs to change. Reference specific function names, file paths, and existing field names so the implementer knows exactly what they're working with.

**What to Build**

Concrete implementation instructions. Include:
- Which functions to modify or create
- New data structures with example JSON/Python/code where helpful
- How to derive new values from existing ones
- Ordering constraints within the ticket (e.g. "only write this file after X succeeds")

**Acceptance Criteria**

Bulleted, testable checklist. Each item must be verifiable by reading the code or running a test. Avoid vague criteria like "works correctly."

**What NOT to Do**

Explicit list of out-of-scope work and footguns. Always include:
- "Do not edit any files outside of <directory>"
- Anything the implementer might plausibly do that would be wrong
- Scope creep items (e.g. "do not update the UI — that belongs to T8")

**Relevant Files**

Comma-separated list of file paths that will be created or modified.
```
