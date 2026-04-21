# Common Rationalizations Table

| Excuse | Reality |
|--------|---------|
| "Too simple test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Tests after achieve same goals" | Tests-after = "what does do?" Tests-first = "what should do?" |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code = technical debt. |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete. |
| "Need explore first" | Fine. Throw away exploration, start with TDD. |
| "Test hard = design unclear" | Listen to test. Hard test = hard use. |
| "TDD will slow down" | TDD faster than debugging. Pragmatic = test-first. |
| "Manual test faster" | Manual doesn't prove edge cases. Re-test every change. |
| "Existing code has no tests" | Improving it. Add tests for existing code. |

# Why Order Matters

## "I'll write tests after to verify it works"

Tests written after pass immediately. Passing immediately proves nothing:
- Might test wrong thing
- Might test implementation, not behavior
- Might miss edge cases forgot
- Never saw it catch bug

Test-first forces see test fail, proving actually tests something.

## "I already manually tested all edge cases"

Manual testing ad-hoc. Think tested everything but:
- No record tested
- Can't re-run when code changes
- Easy forget cases under pressure
- "Worked when tried" ≠ comprehensive

Automated tests systematic. Run same way every time.

## "Deleting X hours of work is wasteful"

Sunk cost fallacy. Time already gone. Choose now:
- Delete rewrite with TDD (X more hours, high confidence)
- Keep add tests after (30 min, low confidence, likely bugs)

"Waste" = keeping code can't trust. Working code without real tests = technical debt.

## "TDD is dogmatic, being pragmatic means adapting"

TDD = pragmatic:
- Finds bugs before commit (faster than debugging after)
- Prevents regressions (tests catch breaks immediately)
- Documents behavior (tests show how use code)
- Enables refactoring (change freely, tests catch breaks)

"Pragmatic" shortcuts = debugging in production = slower.

## "Tests after achieve same goals - it's spirit not ritual"

No. Tests-after answer "What does do?" Tests-first answer "What should do?"

Tests-after biased by implementation. Test what built, not required. Verify remembered edge cases, not discovered.

Tests-first force edge case discovery before implementing. Tests-after verify remembered everything (didn't).

30 minutes tests after ≠ TDD. Get coverage, lose proof tests work.

# Good vs Bad Test Examples

## Good Test Qualities

| Quality | Good | Bad |
|---------|------|-----|
| **Minimal** | One thing. "and" in name? Split it. | `test('validates email and domain and whitespace')` |
| **Clear** | Name describes behavior | `test('test1')` |
| **Shows intent** | Demonstrates desired API | Obscures what code should do |

## Bad Test Anti-Patterns

When adding mocks or test utilities:
- Testing mock behavior instead of real behavior
- Adding test-only methods to production classes
- Mocking without understanding dependencies

Bug found? Write failing test reproducing it. Follow TDD cycle. Test proves fix prevents regression.

Never fix bugs without test.
