Compressing manually (script needs file path approval):

---
name: Python worktrees mandatory — testing requires workaround
description: Worktrees for parallel dev include Python; uv editable installs break test run only, not dev
type: feedback
---

Worktrees mandatory for Python parallel dev. uv editable install limit only affect **test/app runs** inside worktree, not dev.

**Why:** uv editable installs resolve paths relative main checkout. Tests direct inside Python worktree may fail or pick wrong source. Dev (write code, read files) works.

**How to apply:** Python worktrees: always dev in worktree. Need run tests → use skill `testing-worktree-uv`.