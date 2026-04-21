# Ticket Writing Process

## 4-Step Process

### Step 1 — Explore Codebase First

Before asking anything, read relevant source files. Understand:
- Current data model and schemas (field names, what exists)
- Current pipeline/system flow (data produced, transformed, consumed)
- Files touched by feature
- In-progress work on related branches or worktrees (`git worktree list`)

If related tickets referenced (e.g. "see PROJ-490"), read that branch or worktree — architecture there is ground truth, not main branch.

### Step 2 — Ask Clarifying Questions

Surface decisions shaping ticket breakdown. Ask one topic at a time. Key areas:

- **Scope**: Which sub-features in MVP vs later?
- **Data model**: What replaces/extends existing schemas? Old formats still supported or dropped?
- **Variants**: Multiple variants (signed/unsigned, typed/untyped, directional)? Separate entities or one entity with attribute?
- **Computation timing**: Derived values computed eagerly (write time), lazily (read time), or on-demand?
- **Configuration**: New parameters hardcoded, file-configurable, or runtime-overridable?
- **UI reactivity**: What triggers re-render vs full re-run or re-fetch?

Don't assume. Wrong assumption caught early saves entire ticket rewrite.

### Step 3 — Present Full Breakdown

Show user:
- Epic summary
- Numbered ticket list with one-line summaries
- Dependency table (blocked by / blocks)

Wait for approval or revision before proceeding.

### Step 4 — Write Tickets One at a Time

Write one ticket, stop, wait. User says "T2 please" or gives feedback. No batching.

Before each ticket, verify relevant source files match understanding — architecture changes fast, stale assumptions produce wrong tickets. If related worktree active, read from it.

## Dependency Mapping

Every ticket has `Blocked by` and `Blocks` line. Before writing any ticket, draw dependency graph explicitly. Common patterns:

- Design/definition tickets (enums, type registries, schema specs) block everything downstream — write first
- Schema/data model changes block both write path (backend) and read path (UI/eval)
- Backend changes to shared helpers block any ticket consuming those helpers
- Tests always terminal (blocked by all implementation tickets, block nothing)

Present full dependency table alongside ticket list and get user approval before writing T1.
