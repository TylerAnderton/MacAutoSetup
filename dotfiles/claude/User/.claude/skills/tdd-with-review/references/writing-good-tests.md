# Writing good tests

Adapted from `writing-good-tests.md` in the `test-driven-development` skill of the superpowers plugin (MIT; see `LICENSE-superpowers.md`). Modified for this workflow: Python and pytest examples, shortened, and no dependency on other plugins.

Read this when writing or changing tests, adding mocks, or adding helper or cleanup code for tests.

A test exists to catch a specific break. Two principles:

1. Every test names the break it catches.
2. Every test exercises the real thing.

## Principle 1: name the break

Before writing the test body, answer: what production change should make this test fail, and is that change a bug or a decision? A test earns its place by catching a wrong branch, a missing side effect, a wrong argument, a boundary case, or a broken contract.

**Derive expectations independently.** Use literals and hand-checked fixtures. Table-driven tests with literal expected values are the preferred shape. An expectation computed by the code under test passes no matter what that code does.

```python
# Bad: the same builder computes both sides, so this is always true
expected = build_search_query(tag="urgent")
assert build_search_query(tag="urgent") == expected

# Good: a hand-derived literal
assert build_search_query(tag="urgent") == 'tag:"urgent"'
```

**No change detectors.** If only intentional decisions can fail a test (a constant's value, exact message wording, private structure), it fires on redesign and sleeps through bugs. Not `assert MAX_RETRIES == 5`, but "a failing call is retried 5 times and the sixth attempt never happens".

**Behavior, not text.** Asserting that a script or config contains an exact line proves only that the source is the source. Run scripts against controlled inputs and assert outputs, side effects, or exit codes.

**Your code, not the framework.** Test the contract your code makes at its boundaries: the route you register, the query you emit, the payload you produce. Constructors, getters, constants, and trivial forwarding earn tests only when they validate, normalize, default, derive, enforce, or cause side effects.

Gate, before writing the test body:

- Name the production change that would make this test fail. If you cannot, redesign around an observable behavior.
- Confirm the expected value is derived without the code under test. If it reuses the code's logic or helpers, replace it with a literal.

## Principle 2: exercise the real thing

**A mock earns no assertions.** A mock assertion passes when the mock is present and fails when it is absent, which says nothing about the component. Assert the real component's behavior. If the mock is what you are checking, unmock it or delete the assertion.

**Mock at the right level.** Learn every side effect of the real method before replacing it. Mock the slow or external operation and keep what the test depends on real. When unsure, run the test against the real implementation first and observe what needs to happen.

**Make doubles specific.** When arguments, call counts, or ordering are part of the contract, assert them. A fake that accepts anything verifies nothing. Give each branch (success, error, malformed) its own fixture.

**Mirror real data completely.** Mock the whole structure as it exists in reality, not only the fields the test reads. A partial mock passes while integration breaks.

**Production classes carry production methods only.** Cleanup that only tests need belongs in test utilities, never as a method on the production class.

**Prefer real components over complex mocks.** When mock setup outgrows the test logic, switch to an integration test with real components.

Gate, before adding a mock or test helper:

- List the real method's side effects and keep real the ones the test depends on.
- Make mock responses mirror the complete real structure.
- A method only tests call lives in test utilities.
- If you are about to assert on the mock itself, unmock it or delete the assertion.

## Tests ship with the implementation

The cycle of failing test, minimal implementation, and refactor is what "complete" means. Ship the tests the behavior needs and only those. Trivial code earns none, and a test written only to satisfy process costs maintenance forever.

## The mutation check

Before finishing, mentally mutate the production code. At least one test should fail for each realistic mutation:

- a wrong constant or argument
- a wrong branch handler
- a missing state change or side effect
- an empty or default return
- missing validation for zero, empty, `None`, unauthorized, or malformed input

A mutation nothing catches marks the behavior as unprotected, or the test as tautological.

## Warning signs

- Setup and assertion share the same object, guaranteeing equality
- The test can fail only through a crash or a missing selector
- The test fails on every intentional change and never on accidental breakage
- Expected values are hidden behind loops, builders, or helpers
- The test greps source text, or asserts that a removed symbol stays removed
- The test exists for coverage and checks no side effect or outcome
- A method is called only from test files
- Mock setup is more than half the test, or you cannot explain why the mock is needed
