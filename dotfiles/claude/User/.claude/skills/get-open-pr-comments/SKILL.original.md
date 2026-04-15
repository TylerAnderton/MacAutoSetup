---
name: get-open-pr-comments
description: "Fetch all open (non-resolved) PR review comments from GitHub. Use this skill when the user asks you to review comments and/or feedback for a particular GitHub Pull Request. Trigger on: 'code review', 'unresolved', 'non-resolved', 'open comments', 'feedback', or explicit mentions of PR review comments."
---
## Fetch Only OPEN PR Review Comments
- **Primary Source:** Always use `~/.claude/skills/get-open-pr-comments/get_open_pr_comments.sh <PR_NUMBER>` to retrieve only non-resolved comments.
- **Ignore Fallbacks:** If the script returns data, **NEVER** run manual `gh api` calls to `pulls/.../comments`. 
- **Context Handling:** The script provides a `context` field (the diff hunk) and `line`/`original_line`. Use these to locate the code. If you need more context, use `read_file` on the specific file and line provided; do not attempt to fetch comments again.
- **Truth Source:** If a comment is not in the script output, it is **RESOLVED**. Do not seek out resolved comments.
