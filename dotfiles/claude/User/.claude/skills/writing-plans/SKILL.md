---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans. Engineer has zero context. Document everything needed: files, code, testing, docs, how to test. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Skilled developer. Know nothing about toolset or problem domain. Know little about test design.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preference overrides this)

## Scope Check

Multiple independent subsystems? Should have broken into sub-project specs during brainstorming. If not, suggest separate plans—one per subsystem. Each plan produces working, testable software.

## File Structure

Map out files before tasks. What created/modified. What each owns. This locks decomposition decisions.

- Design units with clear boundaries, well-defined interfaces. One responsibility per file.
- Reason best about code you hold in context. Edits more reliable when focused. Small focused files beat large ones doing too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- Follow established patterns in existing codebases. Don't unilaterally restructure. If file grown unwieldy, split is reasonable.

Structure informs task decomposition. Each task produces self-contained changes, sensible independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use subagent-driven-development (recommended) or executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step has actual content. These are **plan failures**—never write:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat code—engineer may read tasks out of order)
- Steps describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step—if step changes code, show code
- Exact commands, expected output
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing complete plan, check against spec with fresh eyes. Self-review checklist—not subagent dispatch.

**1. Spec coverage:** Skim each section/requirement. Point to task implementing it? List gaps.

**2. Placeholder scan:** Search plan for red flags—patterns from "No Placeholders" section. Fix them.

**3. Type consistency:** Types, signatures, property names in later tasks match earlier tasks? Function `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 = bug.

Find issues? Fix inline. No need re-review—just fix and move on. Spec requirement with no task? Add task.

## Execution Handoff

After saving plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - Fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks this session using executing-plans, batch with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use subagent-driven-development
- Fresh subagent per task, two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use executing-plans
- Batch execution, checkpoints for review