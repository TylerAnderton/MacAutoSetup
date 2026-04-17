---
name: model-select
description: "Model routing & cost optimization for Claude Code (Tractian proxy). Delegate to cheap subagents or handle direct. Switch session model when needed. Trigger: session start, before code/Q, token optimization."
---

# Model Selection — Tractian Proxy

## Available Models

| Tier | Model | Best for |
|------|-------|----------|
| **Orchestration** | `claude-sonnet-4.6` (default) | Planning, debugging, architecture, subagent routing, feedback synthesis |
| **Heavy lifting** | `claude-opus-4.6` | Large refactors when Sonnet struggling |
| **Cheap workhorse** | `minimax-m2.7` | Code generation, boilerplate, tests, config |
| **Free** | `glm-5` | Trivial completions, config/docs |

---

## Subagents (primary cost lever)

Cheap subagents output code/config. Sonnet plans, routes, reviews.

| Agent | Model | Use for |
|-------|-------|---------|
| `light-code-writer` | `minimax-m2.7` | Single-file or mechanical multi-file changes (rename, move, edit, simple fix) |
| `heavy-code-writer` | `claude-sonnet-4.6` | New multi-component logic needing coherent integration |
| `heavy-bug-fixer` | `claude-opus-4.6` | Complex bugs after 3+ attempts (pass errors, attempts, files) |
| `test-writer` | `minimax-m2.7` | Test files; verify fail before handoff |
| `config-writer` | `minimax-m2.7` | YAML, CLAUDE.md, skills, BUILD.bazel |

Use agents not direct. Skip if: iterative refinement needed from tests, or overhead > savings.

**light vs. heavy code-writer:** Default light-code-writer. Heavy only: new design patterns, multi-component tradeoffs, no existing example. Clear spec → light handles.

---

## Main Session: Manual Model Switching

Switch session model for Q&A vs subagent overhead.

| Situation | Use |
|-----------|-----|
| Complex feature / ticket work | `sonnet` (default) |
| Quick codebase Q | `minimax-m2.7` or `glm-5` |
| Review / summarize | `minimax-m2.7` |

Back to Sonnet before: planning, multi-file reasoning, subagent dispatch.

---

## Quick Reference

```bash
# Temporary model switch for Q&A
/model minimax-m2.7
/model sonnet   # switch back

# Delegate to subagents (automatic via description matching)
# light-code-writer → single-file or mechanical multi-file Python changes
# heavy-code-writer → new multi-component logic
# heavy-bug-fixer   → hard bugs after 3+ failed attempts (pass full context)
# test-writer       → test files
# config-writer     → YAML / CLAUDE.md / skill files
```
