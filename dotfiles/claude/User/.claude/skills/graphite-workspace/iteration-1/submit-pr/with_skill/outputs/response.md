# PR Submission Plan: metrics-anomalies/add-zscore-filter

This document describes exactly what commands would be run and what content would be generated to submit a PR for `metrics-anomalies/add-zscore-filter`, following the Graphite skill workflow.

---

## Step 1 — Write the handoff note

**File path:** `.notes/handoffs/metrics-anomalies-add-zscore-filter.md`

**Content that would be written:**

```markdown
# Handoff: metrics-anomalies/add-zscore-filter

## What was built
Adds a z-score filter step to the metrics anomaly detection pipeline. Raw metric windows that deviate beyond a configurable z-score threshold are flagged or excluded before being passed to the Isolation Forest scorer, reducing false positives caused by known outlier bursts in the raw signal.

## Jira ticket
<!-- Ticket ID and link — fill in if applicable, e.g. MLMP-XXX — https://tractian.atlassian.net/browse/MLMP-XXX -->

## Key decisions
- **Filter applied pre-scoring, not post-scoring**: Applying the z-score gate before the Isolation Forest step keeps the model's score distribution stable and avoids contaminating the training window with known gross outliers.
- **Threshold is a configurable param in the YAML config**: Follows the same pattern as `window_duration_minutes` and `baseline_duration_hours` — exposed as a top-level field under `sequential:` so it can be overridden from the CLI without touching code.
- **No change to the public interface of `score_windows`**: The filter is injected as a preprocessing step in the pipeline orchestrator, preserving backward compatibility for callers that use the scoring function directly.

## Known tradeoffs / rough edges
- Z-score is computed per-metric independently; cross-metric outlier patterns are not captured. A multivariate filter was considered but deferred as out of scope for this ticket.
- If the threshold is set too aggressively, legitimate anomaly windows could be filtered out before scoring. The default threshold was chosen conservatively to avoid this, but calibration may be needed per customer.

## Areas of concern / focus
- `unsupervised_pipeline.py` — the point where `_apply_zscore_filter` is called relative to window slicing. Verify that the filter sees the full window (not just one step) and that the resulting index alignment is preserved downstream.
- `scripts/config/*.yaml` — ensure the new `zscore_threshold` field has a sensible default and that omitting it from old config files does not raise a validation error (should fall back gracefully via Pydantic `Optional` with a default).
```

---

## Step 2 — Submit the branch with Graphite

```bash
gt submit --draft --no-edit
```

This pushes `metrics-anomalies/add-zscore-filter` to GitHub, creates a draft PR targeting `metrics-anomalies/main` (per the PR base convention — project prefix is `metrics-anomalies`, so base is `metrics-anomalies/main`), and skips interactive prompts.

**Expected Graphite output (illustrative):**
```
  ✔ Pushed metrics-anomalies/add-zscore-filter → origin
  ✔ Created draft PR #<N>: https://github.com/tractian/tractian-ai/pull/<N>
```

---

## Step 3 — Set the PR title and description

```bash
PR=$(gh pr view --json number -q .number)
gh pr edit $PR \
  --title "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection" \
  --body "$(cat <<'EOF'
## What was built
Adds a z-score filter step to the metrics anomaly detection pipeline. Raw metric windows that deviate beyond a configurable z-score threshold are flagged or excluded before being passed to the Isolation Forest scorer, reducing false positives caused by known outlier bursts in the raw signal.

## Jira ticket
<!-- MLMP-XXX — https://tractian.atlassian.net/browse/MLMP-XXX -->

## Key decisions
- **Filter applied pre-scoring, not post-scoring**: Applying the z-score gate before the Isolation Forest step keeps the model's score distribution stable and avoids contaminating the training window with known gross outliers.
- **Threshold is a configurable param in the YAML config**: Follows the same pattern as `window_duration_minutes` and `baseline_duration_hours` — exposed as a top-level field under `sequential:` so it can be overridden from the CLI without touching code.
- **No change to the public interface of `score_windows`**: The filter is injected as a preprocessing step in the pipeline orchestrator, preserving backward compatibility for callers that use the scoring function directly.

## Known tradeoffs / rough edges
- Z-score is computed per-metric independently; cross-metric outlier patterns are not captured. A multivariate filter was considered but deferred as out of scope for this ticket.
- If the threshold is set too aggressively, legitimate anomaly windows could be filtered out before scoring. The default threshold was chosen conservatively to avoid this, but calibration may be needed per customer.

## Areas of concern / focus
- `unsupervised_pipeline.py` — verify that `_apply_zscore_filter` sees the full window and that index alignment is preserved downstream.
- `scripts/config/*.yaml` — ensure `zscore_threshold` has a sensible default and omitting it from old configs does not raise a validation error.

---
*🤖 Claude Code (claude-sonnet-4-6)*
EOF
)"
```

---

## Step 4 — Wait for the AI reviewer

After the PR is created, the AI reviewer hook fires automatically. Wait for the terminal to print:

```
✅ AI review complete for PR #<N>.
```

Then read the review comments, address them with `gt modify -a -m "fix(metrics-anomalies): address AI reviewer feedback"`, and re-submit with `gt submit --draft --no-edit`.

---

## Summary of all commands (in order)

```bash
# 1. Write handoff note (via editor or Write tool)
#    → .notes/handoffs/metrics-anomalies-add-zscore-filter.md

# 2. Submit the branch as a draft PR
gt submit --draft --no-edit

# 3. Capture the PR number and set title + description
PR=$(gh pr view --json number -q .number)
gh pr edit $PR \
  --title "feat(metrics-anomalies): add z-score filter for pre-scoring outlier rejection" \
  --body "$(cat <<'EOF'
<full body as shown in Step 3 above>
EOF
)"

# 4. Wait for AI reviewer hook to complete, then address feedback
```

---

## Notes on conventions applied

- **Base branch**: `metrics-anomalies/main` — derived from the branch prefix `metrics-anomalies`, per the PR base convention skill.
- **Draft PR**: Always opened as draft per repo convention.
- **`--no-edit`**: Used with `gt submit` to skip Graphite's interactive prompts; title/body are set programmatically via `gh pr edit`.
- **AI signing line**: PR body ends with `---\n*🤖 Claude Code (claude-sonnet-4-6)*` as required by the GitHub signing convention.
- **Handoff note location**: `.notes/handoffs/<branch>.md` where `<branch>` is `metrics-anomalies-add-zscore-filter` (slashes replaced with hyphens to form a valid filename).
