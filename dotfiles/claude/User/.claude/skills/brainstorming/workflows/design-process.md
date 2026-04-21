# Design Process Workflow

Full checklist for turning ideas into approved designs.

## Checklist

Complete in order:

1. **Explore project context** — check files, docs, recent commits
2. **Offer visual companion** (if topic will involve visual questions) — own message, not combined with clarifying question
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs and recommendation
5. **Present design** — sections scaled to complexity, get approval after each
6. **Write design doc** — save to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` and commit
7. **Spec self-review** — quick inline check (see below)
8. **User reviews written spec** — ask user to review before proceeding
9. **Invoke writing-plans skill** — to create implementation plan

## After Design: Writing the Spec

Write to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`

Use elements-of-style:writing-clearly-and-concisely skill if available.

Commit design document to git.

## Spec Self-Review Checklist

After writing spec, fresh eyes:

1. **Placeholder scan:** "TBD", "TODO", incomplete sections, vague requirements? Fix.
2. **Internal consistency:** Sections contradict? Architecture match feature descriptions?
3. **Scope check:** Focused enough for single plan, or needs decomposition?
4. **Ambiguity check:** Requirement two interpretations? Pick one, make explicit.

Fix inline. No re-review — fix and move.

## Question Strategy

- **One question at a time** — break if topic needs more
- **Multiple choice preferred** — easier than open-ended
- Focus: purpose, constraints, success criteria

## Presenting Design

Scale sections to complexity:
- Few sentences = straightforward
- 200-300 words = nuanced

Ask after each section if looks right. Cover: architecture, components, data flow, error handling, testing.

## Terminal State

Invoke writing-plans skill to create implementation plan. Do NOT invoke frontend-design, mcp-builder, or other implementation skills.
