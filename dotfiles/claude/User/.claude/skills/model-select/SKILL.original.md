---
name: model-select
description: "Model selection and cost optimization for Claude Code sessions on the Tractian proxy. Governs when to delegate tasks to cheap subagents vs handle directly, and when to manually switch the session model. Trigger on: session start, before writing substantial code, before answering a simple question, or when instructed to optimize token usage."
---

# Model Selection — Tractian Proxy

## Available Models

| Tier | Model | Best for |
|------|-------|----------|
| **Orchestration** | `claude-sonnet-4.6` (default) | Multi-step planning, complex debugging, architectural decisions, routing subagents, synthesizing PR feedback |
| **Heavy lifting** | `claude-opus-4.6` | Large refactors, only when Sonnet is visibly struggling |
| **Cheap workhorse** | `minimax-m2.7` | Focused code generation, boilerplate, test stubs, config files |
| **Free** | `glm-5` | Trivial completions, config/doc edits |

---

## Subagents (primary cost lever)

Custom subagents with cheap models handle the majority of code and config output. The orchestrator (Sonnet) plans, routes, and reviews — cheap agents write.

| Agent | Model | Use for |
|-------|-------|---------|
| `light-code-writer` | `minimax-m2.7` | Single-file changes or mechanical multi-file transformations (renames, moves, simple edits, simple bug fixes) |
| `heavy-code-writer` | `claude-sonnet-4.6` | New logic spanning multiple components that must integrate coherently |
| `heavy-bug-fixer` | `claude-opus-4.6` | Complex bugs after 3+ failed fix attempts; pass full context (errors, attempts, relevant files) |
| `test-writer` | `minimax-m2.7` | Pytest test files; verifies tests fail before handing off |
| `config-writer` | `minimax-m2.7` | YAML, CLAUDE.md, skill files, BUILD.bazel edits |

Delegate to these agents instead of writing code or config directly. Do not delegate when:
- The task requires iterative refinement based on test output
- The task is trivially small and context marshaling overhead exceeds the savings

**light vs. heavy code-writer decision rule:** Default to `light-code-writer`. Use `heavy-code-writer` only when the task requires actively reasoning about design tradeoffs across multiple components with no existing pattern to follow — new abstractions, core interface restructuring. If the orchestrator can write a clear spec, `light-code-writer` can implement it.

---

## Main Session: Manual Model Switching

For conversational tasks where spawning a subagent would be wasteful, switch the session model manually with `/model <name>` and switch back after.

| Situation | Use |
|-----------|-----|
| Complex feature work / ticket orchestration | Stay on `sonnet` (default) |
| Quick question about the codebase | `/model minimax-m2.7` or `/model glm-5` |
| Reviewing / summarizing output | `/model minimax-m2.7` |

**Always switch back to Sonnet** before planning, multi-file reasoning, or spawning subagents.

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
# test-writer       → bazel test files
# config-writer     → YAML / CLAUDE.md / skill files
```
