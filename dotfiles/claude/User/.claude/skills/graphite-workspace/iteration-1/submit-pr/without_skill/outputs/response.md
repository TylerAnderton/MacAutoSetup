# PR Submission Plan (without Graphite skill): metrics-anomalies/add-zscore-filter

This document shows exactly what commands would be run and what content would be generated to submit a PR for `metrics-anomalies/add-zscore-filter`, using only standard `git`, `gh`, and repo tooling — **without** the `graphite` skill.

---

## Step 1 — Determine the correct base branch (pr-base-convention)

The current branch is `metrics-anomalies/add-zscore-filter`. Per the PR base convention (from CLAUDE.md and the `pr-base-convention` skill):

- Extract project prefix: everything before the first `/` → `metrics-anomalies`
- Append `/main` → base branch is `metrics-anomalies/main`
- **Never** use `master` as the base.

---

## Step 2 — Run Gazelle (pre-flight check)

Before creating any PR, BUILD.bazel files must be in sync:

```bash
bazel run //:gazelle
```

If Gazelle modifies any files, stage and commit them on the current branch:

```bash
git add -u
git commit -m "chore: update BUILD.bazel files via gazelle"
```

---

## Step 3 — Write the handoff note

**File path written:** `.notes/handoffs/metrics-anomalies-add-zscore-filter.md`

(Slashes in the branch name are replaced with hyphens to form a valid filename, following the pattern of existing handoff files like `metrics-anomalies-mlmp-469-baseline-window-settings.md`.)

**Content that would be written:**

```markdown
# Handoff: metrics-anomalies/add-zscore-filter

## What was built
Adds a z-score filter step to the metrics anomaly detection pipeline. Raw metric windows
that deviate beyond a configurable z-score threshold are flagged or excluded before being
passed to the Isolation Forest scorer, reducing false positives caused by known outlier
bursts in the raw signal.

## Jira ticket
<!-- Ticket ID and link — fill in if applicable, e.g. MLMP-XXX — https://tractian.atlassian.net/browse/MLMP-XXX -->

## Key decisions
- **Filter applied pre-scoring, not post-scoring**: Applying the z-score gate before the
  Isolation Forest step keeps the model's score distribution stable and avoids
  contaminating the training window with known gross outliers.
- **Threshold is a configurable param in the YAML config**: Follows the same pattern as
  `window_duration_minutes` and `baseline_duration_hours` — exposed as a top-level field
  under `sequential:` so it can be overridden from the CLI without touching code.
- **No change to the public interface of `score_windows`**: The filter is injected as a
  preprocessing step in the pipeline orchestrator, preserving backward compatibility for
  callers that use the scoring function directly.

## Known tradeoffs / rough edges
- Z-score is computed per-metric independently; cross-metric outlier patterns are not
  captured. A multivariate filter was considered but deferred as out of scope.
- If the threshold is set too aggressively, legitimate anomaly windows could be filtered
  out before scoring. The default threshold was chosen conservatively, but calibration
  may be needed per customer.

## Areas of concern / focus
- `unsupervised_pipeline.py` — the point where `_apply_zscore_filter` is called relative
  to window slicing. Verify that the filter sees the full window (not just one step) and
  that the resulting index alignment is preserved downstream.
- `scripts/config/*.yaml` — ensure the new `zscore_threshold` field has a sensible
  default and that omitting it from old config files does not raise a validation error
  (should fall back gracefully via Pydantic `Optional` with a default).
```

---

## Step 4 — Commit any final staged changes (if needed)

If there are uncommitted changes that belong in this PR:

```bash
git add <specific files>
git commit -m "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection"
```

If the branch is already clean (all changes committed), skip this step.

---

## Step 5 — Push the branch to GitHub

```bash
git push -u origin metrics-anomalies/add-zscore-filter
```

Expected output:
```
Enumerating objects: ...
To github.com:tractian/tractian-ai.git
 * [new branch]      metrics-anomalies/add-zscore-filter -> metrics-anomalies/add-zscore-filter
Branch 'metrics-anomalies/add-zscore-filter' set up to track remote branch 'metrics-anomalies/add-zscore-filter' from 'origin'.
```

---

## Step 6 — Create the draft PR

```bash
gh pr create \
  --base metrics-anomalies/main \
  --draft \
  --title "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection" \
  --body "$(cat <<'EOF'
## What was built
Adds a z-score filter step to the metrics anomaly detection pipeline. Raw metric windows
that deviate beyond a configurable z-score threshold are flagged or excluded before being
passed to the Isolation Forest scorer, reducing false positives caused by known outlier
bursts in the raw signal.

## Jira ticket
<!-- MLMP-XXX — https://tractian.atlassian.net/browse/MLMP-XXX -->

## Key decisions
- **Filter applied pre-scoring, not post-scoring**: Applying the z-score gate before the
  Isolation Forest step keeps the model's score distribution stable and avoids
  contaminating the training window with known gross outliers.
- **Threshold is a configurable param in the YAML config**: Follows the same pattern as
  `window_duration_minutes` and `baseline_duration_hours` — exposed as a top-level field
  under `sequential:` so it can be overridden from the CLI without touching code.
- **No change to the public interface of `score_windows`**: The filter is injected as a
  preprocessing step in the pipeline orchestrator, preserving backward compatibility for
  callers that use the scoring function directly.

## Known tradeoffs / rough edges
- Z-score is computed per-metric independently; cross-metric outlier patterns are not
  captured. A multivariate filter was considered but deferred as out of scope.
- If the threshold is set too aggressively, legitimate anomaly windows could be filtered
  out before scoring. The default threshold was chosen conservatively, but calibration
  may be needed per customer.

## Areas of concern / focus
- `unsupervised_pipeline.py` — verify that `_apply_zscore_filter` sees the full window
  and that index alignment is preserved downstream.
- `scripts/config/*.yaml` — ensure `zscore_threshold` has a sensible default and
  omitting it from old configs does not raise a validation error.

---
*🤖 Claude Code (claude-sonnet-4-6)*
EOF
)"
```

Expected output:
```
https://github.com/tractian/tractian-ai/pull/<N>
```

---

## Step 7 — Wait for the AI reviewer

After PR creation, the AI reviewer hook fires automatically. Wait for the terminal to print:

```
✅ AI review complete for PR #<N>.
```

Then read the review comments, make the necessary fixes, commit them:

```bash
git add <changed files>
git commit -m "fix(metrics-anomalies): address AI reviewer feedback"
git push origin metrics-anomalies/add-zscore-filter
```

---

## Summary of all commands in order

```bash
# 1. Pre-flight: keep BUILD.bazel files in sync
bazel run //:gazelle
# If gazelle changed files:
git add -u && git commit -m "chore: update BUILD.bazel files via gazelle"

# 2. Write handoff note to .notes/handoffs/metrics-anomalies-add-zscore-filter.md
#    (use Write tool or editor — content shown in Step 3 above)

# 3. Commit any remaining staged changes (if branch is not already clean)
git add <specific files>
git commit -m "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection"

# 4. Push the branch
git push -u origin metrics-anomalies/add-zscore-filter

# 5. Create the draft PR
gh pr create \
  --base metrics-anomalies/main \
  --draft \
  --title "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection" \
  --body "$(cat <<'EOF'
<full body as shown in Step 6 above>
EOF
)"

# 6. Wait for AI reviewer hook, address feedback, push fix commit
git add <changed files>
git commit -m "fix(metrics-anomalies): address AI reviewer feedback"
git push origin metrics-anomalies/add-zscore-filter
```

---

## Conventions applied

| Convention | Value applied |
|---|---|
| Base branch | `metrics-anomalies/main` (derived from branch prefix `metrics-anomalies`, per PR base convention) |
| Draft PR | Yes — `--draft` always used; user marks ready manually |
| Commit message format | `feat(metrics-anomalies): ...` — Conventional Commits |
| Handoff note filename | `.notes/handoffs/metrics-anomalies-add-zscore-filter.md` (slashes → hyphens) |
| AI signing line | `---\n*🤖 Claude Code (claude-sonnet-4-6)*` at end of PR body |
| Gazelle pre-flight | `bazel run //:gazelle` before pushing |
| Push command | `git push -u origin <branch>` (not `gt submit`) |
| PR creation | `gh pr create` (not `gt submit`) |
