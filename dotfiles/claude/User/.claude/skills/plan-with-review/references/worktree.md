# Branch and worktree convention

Always ask the user whether to use a worktree. A worktree is not needed for every task.

## Branch name

- With a Jira ticket: `{feature|fix}/<TICKET-ID>-<CamelCaseBrief>`, for example `feature/CI-1234-AddRetryLogic`.
- Without a ticket: `{feature|fix}/<kebab-brief>`, for example `feature/workflow-skills`.

## Identifier

The identifier is the Jira ticket ID when there is one, otherwise the kebab brief (the part of the branch name after the slash).

## Worktree location

Do not use the default `worktrees/` location. Place the worktree in the main checkout's parent directory, next to the checkout root, named `<main-checkout-dir>-<identifier>`. For a checkout at `~/Repositories/MacAutoSetup` and identifier `workflow-skills`, the worktree is `~/Repositories/MacAutoSetup-workflow-skills`.

## Create it

Branch from the current HEAD of the default branch using plain git, with the branch and worktree created together:

```bash
git worktree add -b <branch> "<main-checkout-parent>/<main-checkout-dir>-<identifier>"
```

Do all work for the task in that worktree. When the session's working directory is the main checkout, use absolute paths into the worktree and `git -C <worktree>`, and pass the worktree path to the code review command.
