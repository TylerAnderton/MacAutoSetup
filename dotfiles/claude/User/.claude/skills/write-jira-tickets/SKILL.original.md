---
name: write-jira-tickets
description: "Use when the user asks to write, create, or generate Jira tickets for a feature, bug fix, or refactor. Covers the full process: codebase exploration, collaborative clarification, ticket decomposition, dependency mapping, and iterative one-at-a-time ticket writing with the user reviewing each before proceeding."
---

# Writing Jira Tickets

## Overview

Break a feature request into a well-scoped Epic + numbered implementation tickets, written one at a time with the user reviewing each before proceeding. The goal is tickets detailed enough that another Claude instance can implement them with minimal additional input.

## Process

### 1. Explore the codebase first

Before asking anything, read the relevant source files. Understand:
- The current data model and schemas (what fields exist, what they're named)
- The current pipeline or system flow (where data is produced, transformed, consumed)
- Which files will be touched by the feature
- Any in-progress work on related branches or worktrees (`git worktree list`)

If related tickets are referenced (e.g. "see PROJ-490"), read that branch or worktree — the architecture there is the ground truth, not the main branch.

### 2. Ask clarifying questions before writing anything

Surface the decisions that will shape the ticket breakdown. Ask one topic at a time. Key areas to resolve:

- **Scope**: Which sub-features are in MVP vs later?
- **Data model**: What replaces or extends existing schemas? Are old formats still supported or discarded?
- **Variants**: When a concept has multiple variants (e.g. signed/unsigned, typed/untyped, directional), are they separate entities or one entity with an attribute?
- **Computation timing**: Where are derived values computed — eagerly at write time, lazily at read time, or on-demand by the caller?
- **Configuration**: Are new parameters hardcoded, file-configurable, or runtime-overridable?
- **UI reactivity**: What changes trigger a re-render vs require a full re-run or re-fetch?

Do not assume. A wrong assumption caught early saves an entire ticket rewrite.

### 3. Present the full breakdown before writing any ticket

Show the user:
- The Epic summary
- A numbered ticket list with one-line summaries
- The dependency table (blocked by / blocks)

Wait for approval or revision before proceeding to individual tickets.

### 4. Write tickets one at a time

Write one ticket, then stop and wait. The user will say "T2 please" or give feedback. Do not batch.

Before writing each ticket, verify the relevant source files still match your understanding — architecture changes fast and stale assumptions produce wrong tickets. If a related worktree is active, read from it.

---

## Ticket Format

The structure below reflects the validated format for this repo:

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

**Name the concrete things.** Reference actual function names, actual field names, actual file paths. A ticket that says "update the relevant function" is useless to an implementer.

**Scope the file boundary in every ticket.** Every ticket must contain a "What NOT to Do" item that explicitly prohibits editing files outside the feature directory. This prevents implementers from making sweeping changes that break unrelated systems.

**Don't layer new fields over old ones.** When a field is being replaced, remove the old one. Don't add a new field alongside the old one "for safety" unless the user explicitly asked for it — that ambiguity creates bugs and confusion downstream.

**One ticket, one concern.** If a ticket touches both training and inference, or both backend logic and UI, split it. Tickets that own too much surface area produce vague acceptance criteria and hard-to-review PRs.

**Keep decisions consistent across tickets.** If a design choice is made in T3 (e.g. where a threshold is computed), every subsequent ticket must be written as if that decision is already final. Contradictions between tickets are bugs in the spec.

---

## Dependency Mapping

Every ticket has a `Blocked by` and `Blocks` line. Before writing any ticket, draw the dependency graph explicitly. Common patterns:

- Design/definition tickets (enums, type registries, schema specs) block everything downstream — write them first
- Schema or data model changes block both the write path (backend) and the read path (UI/eval)
- Backend changes to shared helpers block any ticket that consumes those helpers
- Tests are always terminal (blocked by all implementation tickets, block nothing)

Present the full dependency table alongside the ticket list and get user approval before writing T1.

---

## Common Mistakes

**Writing tickets before reading the current code.** The architecture in an active worktree or in-flight branch is often different from main. Always check `git worktree list` and read files from whichever branch is in-flight for the relevant feature area.

**Carrying forward removed fields.** If an earlier ticket removes a field or replaces a schema, every subsequent ticket must be written as if that change is already done. Never reference the old field name after it has been dropped.

**Letting a key design decision drift across tickets.** Resolve questions like "where is this value computed?" once, document the decision clearly in the first ticket that introduces it, and enforce it in every ticket that touches the same concern.

**Over-scoping the test ticket.** The tests ticket (typically last) should cover integration gaps between tickets — not duplicate the unit tests each implementation ticket already specifies. Write it last, after all implementation tickets are settled.

**Conflating variants with separate entities.** Before splitting a concept into multiple distinct types, ask whether a single type with an attribute covers the same ground more simply. This affects the data model, annotation schema, and UI in ways that compound across tickets.
