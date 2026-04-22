# Memory Index

- [User Profile](user_profile.md) — MLE at Tractian, Python/ML, metrics anomaly detection
- [Workflow Preferences](workflow_preferences.md) — TDD, PR-first, parallel agents, lean CLAUDE.md
- [Haiku-first orchestrator](agent_strategy.md) — Cost-optimized: Haiku primary + specialized agents (Sonnet/minimax/Gemini)
- [Always Parallelize](feedback_parallelization.md) — Default subagent-driven dev, never ask execution mode
- [No Worktrees for Python Tests](feedback_no_worktrees_for_python.md) — uv + editable installs break app in worktrees; use branches to test
- [Git/Worktree Workflow Rules](feedback_git_workflow.md) — gt create only; worktrees base on feature branch not master; subagents never create branches
- [Orchestrator Discipline](feedback_orchestrator_discipline.md) — NEVER use Bash/Edit/Write/Read/Grep for implementation; always delegate to subagents
- [Never final PR without permission](feedback_no_final_pr_without_permission.md) — CRITICAL: NEVER gt submit final PR autonomously; wait for explicit user command
