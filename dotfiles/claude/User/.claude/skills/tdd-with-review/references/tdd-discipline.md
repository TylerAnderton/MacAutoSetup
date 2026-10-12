# TDD discipline

Adapted from the `test-driven-development` skill of the superpowers plugin (MIT; see `LICENSE-superpowers.md`). Modified for this workflow: Python and pytest examples, the RED tests are reviewed by the user before any implementation exists, and nothing here depends on other plugins.

## Core principle

Write the test first. Watch it fail. Write minimal code to pass. If you did not watch the test fail, you do not know it tests the right thing. Following the letter of these rules is following their spirit.

## When it applies

Always: new features, bug fixes, refactoring, behavior changes. Exceptions need the user's say-so: throwaway prototypes, generated code, configuration files. Thinking "skip TDD just this once" is rationalization.

## The iron law

No production code without a failing test first. If code was written before its test, delete it and implement fresh from the tests. Do not keep it as reference, adapt it, or look at it.

## Red, green, refactor

### RED: write one failing test

One behavior, a clear name, real code with no mocks unless unavoidable.

Good:

```python
def test_retries_failed_operation_three_times():
    attempts = 0

    def operation():
        nonlocal attempts
        attempts += 1
        if attempts < 3:
            raise RuntimeError("fail")
        return "success"

    assert retry_operation(operation) == "success"
    assert attempts == 3
```

Bad: a vague name such as `test_retry_works` whose assertion is on a `Mock`'s call count, so it tests the mock and not the code.

### Verify RED: mandatory

Run the test. Confirm it fails (not errors), with the expected message, because the feature is missing and not because of a typo. A test that passes is testing existing behavior; fix the test. A test that errors gets fixed and re-run until it fails correctly.

In this workflow the RED tests are then reviewed by the user, and no implementation is written until they are approved.

### GREEN: minimal code

Write the simplest code that passes. Do not add options, features, or refactoring beyond the test.

### Verify GREEN: mandatory

Confirm the test passes, other tests still pass, and the output has no errors or warnings. If the test fails, fix the code, never the test.

"Other tests" means the project's whole suite. Before calling the change done, run the project's test command even when the task named one file. Any failure that run shows, including one you did not cause, goes in your report by name.

### REFACTOR: after green only

Remove duplication, improve names, extract helpers. Keep the tests green and add no behavior.

## Common rationalizations

| Excuse | Reality |
|---|---|
| "Too simple to test" | Simple code breaks. The test takes 30 seconds. |
| "I'll test after" | Tests written after pass immediately, which proves nothing. They answer "what does this do?", not "what should this do?" |
| "Already manually tested" | Manual testing is ad hoc: no record, no re-run, cases get forgotten. |
| "Deleting this is wasteful" | Sunk cost. Keeping code you cannot trust is the real waste. |
| "Keep it as reference" | You will adapt it. That is testing after. |
| "Need to explore first" | Fine. Throw the exploration away, then start with a test. |
| "The test is hard to write" | Hard to test means hard to use. Simplify the design. |
| "Existing code has no tests" | You are changing it, so add tests for what you touch. |

## Red flags: stop and start over

Code before a test; a test that passes immediately; being unable to explain why a test failed; tests added "later"; "just this once"; "it is about spirit, not ritual"; "this is different because...".

## When stuck

| Problem | Solution |
|---|---|
| Do not know how to test it | Write the wished-for API and the assertion first, then ask the user |
| Test is too complicated | The design is too complicated; simplify the interface |
| Must mock everything | The code is too coupled; use dependency injection |
| Test setup is huge | Extract helpers; if it is still complex, simplify the design |

## Bugs

Write a failing test that reproduces the bug, then follow the cycle. The test proves the fix and prevents a regression. Never fix a bug without a test.

## Checklist before finishing

- [ ] Every new function or method has a test
- [ ] Each test was watched failing, for the expected reason
- [ ] Minimal code was written to pass each test
- [ ] The whole suite passes with clean output
- [ ] Tests use real code, with mocks only where unavoidable
- [ ] Edge cases and error paths are covered

For rules on what makes a test worth having, see `writing-good-tests.md`.
