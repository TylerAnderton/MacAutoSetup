---
name: engineering-standards
description: "Core architectural and behavioral standards for the Tractian AI repo. Use during planning, implementation, or refactoring. Trigger on: 'new feature', 'refactor', 'how to edit', 'testing', or 'parallelization'."
---

# Engineering Standards

- **Behavior:** Ask clarifying questions before starting significant changes.
- **Logic:** Follow DRY and modularity; prefer reusable abstractions.
- **TDD:** Write failing tests first via `superpowers:test-driven-development`.
- **Tooling Constraint:** NEVER use Bash to edit files. Use Read, Edit, and Write tools exclusively.
- **Testing:** Always run relevant tests (`uv run pytest <target>`) before any commit or push. Syntax/import errors are considered failures.
- **Parallelization:** Default to parallel subagents for independent tasks via `superpowers:dispatching-parallel-agents`.
- **Worktrees:** Use freely for Python development. For testing, create a temp branch and run tests from the main checkout.
