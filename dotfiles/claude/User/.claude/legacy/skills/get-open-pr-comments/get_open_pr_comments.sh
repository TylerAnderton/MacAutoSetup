#!/bin/bash
# .claude/skills/get-open-pr-comments/get_open_pr_comments.sh

PR_NUMBER=$1
REPO_FULL_NAME=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
OWNER=$(echo $REPO_FULL_NAME | cut -d'/' -f1)
REPO=$(echo $REPO_FULL_NAME | cut -d'/' -f2)

if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <pr_number>"
  exit 1
fi

gh api graphql -f query='
query($name: String!, $owner: String!, $pull: Int!) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $pull) {
      reviewThreads(first: 50) {
        nodes {
          isResolved
          path
          line
          originalLine
          comments(first: 50) {
            nodes {
              author { login }
              body
              diffHunk
            }
          }
        }
      }
    }
  }
}' -F owner="$OWNER" -F name="$REPO" -F pull="$PR_NUMBER" \
--jq '.data.repository.pullRequest.reviewThreads.nodes[] | 
      select(.isResolved == false) | 
      {
        file: .path, 
        line: .line, 
        original_line: .originalLine, 
        context: .comments.nodes[0].diffHunk, 
        thread: [.comments.nodes[] | {user: .author.login, text: .body}]
      }'
