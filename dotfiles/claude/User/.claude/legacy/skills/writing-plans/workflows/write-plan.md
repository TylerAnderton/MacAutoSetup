# Write Plan Workflow

## Scope Check

Multiple independent subsystems? Should have broken into sub-project specs during brainstorming. If not, suggest separate plans—one per subsystem. Each plan produces working, testable software.

## File Structure

Map out files before tasks. What created/modified. What each owns. This locks decomposition decisions.

- Design units with clear boundaries, well-defined interfaces. One responsibility per file.
- Reason best about code you hold in context. Edits more reliable when focused. Small focused files beat large ones doing too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- Follow established patterns in existing codebases. Don't unilaterally restructure. If file grown unwieldy, split is reasonable.

Structure informs task decomposition. Each task produces self-contained changes, sensible independently.

## Task Structure

### Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

### Task Template

```markdown
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

Run: `bazel test //path/to/tests:test_name`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bazel test //path/to/tests:test_name`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
gt modify -m "feat: add specific feature"
```
```

## No Placeholder Rules

Every step has actual content. These are **plan failures**—never write:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat code—engineer may read tasks out of order)
- Steps describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Self-Review Checklist

After writing complete plan, check against spec with fresh eyes. Self-review checklist—not subagent dispatch.

**1. Spec coverage:** Skim each section/requirement. Point to task implementing it? List gaps.

**2. Placeholder scan:** Search plan for red flags—patterns from "No Placeholders" section. Fix them.

**3. Type consistency:** Types, signatures, property names in later tasks match earlier tasks? Function `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 = bug.

Find issues? Fix inline. No need re-review—just fix and move on. Spec requirement with no task? Add task.

## Execution Handoff

After saving plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - Fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks this session, batch with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use subagent-dev
- Fresh subagent per task, two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use subagent-dev
- Batch execution, checkpoints for review
