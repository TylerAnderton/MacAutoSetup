# Style Rules

**Be direct, not defensive.** State backward compatibility decisions explicitly; avoid hedge language like "consider maintaining compatibility."

**Name concrete things.** Reference actual function names, actual field names, actual file paths. Ticket saying "update relevant function" is useless.

**Scope file boundary in every ticket.** Every ticket must contain "What NOT to Do" item explicitly prohibiting editing files outside feature directory. Prevents implementers making sweeping changes that break unrelated systems.

**Don't layer new fields over old.** When field replaced, remove old one. Don't add new field alongside old "for safety" unless user explicitly asked — ambiguity creates bugs downstream.

**One ticket, one concern.** If ticket touches training and inference, or backend logic and UI, split it. Tickets owning too much surface area produce vague acceptance criteria and hard-to-review PRs.

**Keep decisions consistent across tickets.** If design choice made in T3 (e.g. where threshold computed), every subsequent ticket written as if decision already final. Contradictions between tickets are bugs in spec.

# Dependency Mapping Guidance

Every ticket has `Blocked by` and `Blocks` line. Before writing any ticket, draw dependency graph explicitly. Common patterns:

- Design/definition tickets (enums, type registries, schema specs) block everything downstream — write first
- Schema/data model changes block both write path (backend) and read path (UI/eval)
- Backend changes to shared helpers block any ticket consuming those helpers
- Tests always terminal (blocked by all implementation tickets, block nothing)

# Common Mistakes

**Writing tickets before reading current code.** Architecture in active worktree or in-flight branch often differs from main. Always check `git worktree list` and read files from whichever branch in-flight for relevant feature area.

**Carrying forward removed fields.** If earlier ticket removes field or replaces schema, every subsequent ticket written as if change already done. Never reference old field name after dropped.

**Letting key design decision drift across tickets.** Resolve questions like "where is this value computed?" once, document decision clearly in first ticket introducing it, enforce in every ticket touching same concern.

**Over-scoping test ticket.** Tests ticket (typically last) covers integration gaps between tickets — not duplicate unit tests each implementation ticket already specifies. Write last, after all implementation tickets settled.

**Conflating variants with separate entities.** Before splitting concept into multiple distinct types, ask whether single type with attribute covers same ground more simply. Affects data model, annotation schema, UI in ways that compound across tickets.
