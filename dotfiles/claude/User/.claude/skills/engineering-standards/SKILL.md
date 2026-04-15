---
name: engineering-standards
description: "Core architectural and behavioral standards for the Tractian AI repo. Use during planning, implementation, or refactoring. Trigger on: 'new feature', 'refactor', 'how to edit', 'testing', or 'parallelization'."
---

# Engineering Standards

- **Behavior:** Ask clarifying questions before significant changes.
- **Logic:** Follow DRY, modularity; prefer reusable abstractions.
- **TDD:** Write failing tests first via `test-driven-development` skill.
- **Tooling Constraint:** Never use Bash to edit files. Use Read, Edit, Write tools only.
- **Testing:** Run relevant tests (`uv run pytest <target>`) before commit/push. Syntax/import errors = failures.
- **Parallelization:** Dispatch independent tasks as parallel subagents. Use `subagent-dev` skill for plan execution.
- **Worktrees:** Use `worktree-setup` skill for isolated development. Use `testing-worktree-uv` for running Python tests from worktrees.
