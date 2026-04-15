---
name: write-jira-tickets
description: "Use when the user asks to write, create, or generate Jira tickets for a feature, bug fix, or refactor. Covers the full process: codebase exploration, collaborative clarification, ticket decomposition, dependency mapping, and iterative one-at-a-time ticket writing with the user reviewing each before proceeding."
---

# Writing Jira Tickets

## Overview

Break feature request into well-scoped Epic + numbered implementation tickets, one at a time with user review. Goal: tickets detailed enough another Claude instance implements with minimal input.

## Process

### 1. Explore codebase first

Before asking anything, read relevant source files. Understand:
- Current data model and schemas (field names, what exists)
- Current pipeline/system flow (data produced, transformed, consumed)
- Files touched by feature
- In-progress work on related branches or worktrees (`git worktree list`)

If related tickets referenced (e.g. "see PROJ-490"), read that branch or worktree — architecture there is ground truth, not main branch.

### 2. Ask clarifying questions before writing

Surface decisions shaping ticket breakdown. Ask one topic at a time. Key areas:

- **Scope**: Which sub-features in MVP vs later?
- **Data model**: What replaces/extends existing schemas? Old formats still supported or dropped?
- **Variants**: Multiple variants (signed/unsigned, typed/untyped, directional)? Separate entities or one entity with attribute?
- **Computation timing**: Derived values computed eagerly (write time), lazily (read time), or on-demand?
- **Configuration**: New parameters hardcoded, file-configurable, or runtime-overridable?
- **UI reactivity**: What triggers re-render vs full re-run or re-fetch?

Don't assume. Wrong assumption caught early saves entire ticket rewrite.

### 3. Present full breakdown before writing any ticket

Show user:
- Epic summary
- Numbered ticket list with one-line summaries
- Dependency table (blocked by / blocks)

Wait for approval or revision before proceeding.

### 4. Write tickets one at a time

Write one ticket, stop, wait. User says "T2 please" or gives feedback. No batching.

Before each ticket, verify relevant source files match understanding — architecture changes fast, stale assumptions produce wrong tickets. If related worktree active, read from it.

---

## Ticket Format

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

---

## Style Rules

**Be direct, not defensive.** State backward compatibility decisions explicitly; avoid hedge language like "consider maintaining compatibility."

**Name concrete things.** Reference actual function names, actual field names, actual file paths. Ticket saying "update relevant function" is useless.

**Scope file boundary in every ticket.** Every ticket must contain "What NOT to Do" item explicitly prohibiting editing files outside feature directory. Prevents implementers making sweeping changes that break unrelated systems.

**Don't layer new fields over old.** When field replaced, remove old one. Don't add new field alongside old "for safety" unless user explicitly asked — ambiguity creates bugs downstream.

**One ticket, one concern.** If ticket touches training and inference, or backend logic and UI, split it. Tickets owning too much surface area produce vague acceptance criteria and hard-to-review PRs.

**Keep decisions consistent across tickets.** If design choice made in T3 (e.g. where threshold computed), every subsequent ticket written as if decision already final. Contradictions between tickets are bugs in spec.

---

## Dependency Mapping

Every ticket has `Blocked by` and `Blocks` line. Before writing any ticket, draw dependency graph explicitly. Common patterns:

- Design/definition tickets (enums, type registries, schema specs) block everything downstream — write first
- Schema/data model changes block both write path (backend) and read path (UI/eval)
- Backend changes to shared helpers block any ticket consuming those helpers
- Tests always terminal (blocked by all implementation tickets, block nothing)

Present full dependency table alongside ticket list and get user approval before writing T1.

---

## Common Mistakes

**Writing tickets before reading current code.** Architecture in active worktree or in-flight branch often differs from main. Always check `git worktree list` and read files from whichever branch in-flight for relevant feature area.

**Carrying forward removed fields.** If earlier ticket removes field or replaces schema, every subsequent ticket written as if change already done. Never reference old field name after dropped.

**Letting key design decision drift across tickets.** Resolve questions like "where is this value computed?" once, document decision clearly in first ticket introducing it, enforce in every ticket touching same concern.

**Over-scoping test ticket.** Tests ticket (typically last) covers integration gaps between tickets — not duplicate unit tests each implementation ticket already specifies. Write last, after all implementation tickets settled.

**Conflating variants with separate entities.** Before splitting concept into multiple distinct types, ask whether single type with attribute covers same ground more simply. Affects data model, annotation schema, UI in ways that compound across tickets.
