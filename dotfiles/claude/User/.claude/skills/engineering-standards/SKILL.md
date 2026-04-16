---
name: engineering-standards
description: "Core architectural and behavioral standards for the Tractian AI repo. Use during planning, implementation, or refactoring. Trigger on: 'new feature', 'refactor', 'how to edit', 'testing', or 'parallelization'."
---

# Engineering Standards

## Standards

- **Behavior:** Ask clarifying questions before significant changes.
- **Logic:** DRY, modularity, prefer reusable abstractions.
- **TDD:** `tester` writes failing tests before implementation; verifies after.
- **Tooling Constraint:** Never use Bash to edit files — Read, Edit, Write tools only.
- **Parallelization:** Default is parallel. Dispatch independent tasks simultaneously. See `subagent-dev`.
- **Worktrees:** Use `worktree-setup` for isolated development. Use `tester` (not raw pytest) for running tests.
