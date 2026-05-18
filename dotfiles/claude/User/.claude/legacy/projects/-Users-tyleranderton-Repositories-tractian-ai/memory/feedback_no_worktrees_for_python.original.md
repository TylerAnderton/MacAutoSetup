---
name: Python worktrees are mandatory for development — testing requires a workaround
description: Worktrees are used for all parallel development including Python; uv editable installs only break test execution, not development
type: feedback
---

Worktrees are mandatory for Python parallel development. The uv + editable install limitation only affects **running tests and apps** from inside the worktree, not development itself. 

**Why:** uv editable installs resolve paths relative to the main checkout. Running tests directly inside a Python worktree may fail or pick up the wrong source. But development (writing code, reading files) works fine.

**How to apply:** For Python worktrees, always develop in a worktree. When you need to run tests, use the skill `testing-worktree-uv`. 
