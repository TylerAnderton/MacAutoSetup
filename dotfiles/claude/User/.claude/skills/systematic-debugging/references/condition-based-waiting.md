---
name: condition-based-waiting
description: Replace arbitrary timeouts with condition polling
---

# Condition-Based Waiting

**Replace arbitrary timeouts with condition polling.**

## The Problem

Arbitrary sleep(time) calls are:
- Too short: flakiness and intermittent failures
- Too long: slow tests and wasted time

## The Technique

1. **Define success condition** clearly
2. **Poll for condition** with timeout
3. **Fail fast** when timeout exceeded

## Example

**Before (arbitrary timeout):**
```python
time.sleep(5)  # Hope it's ready in 5 seconds
result = do_something()
```

**After (condition polling):**
```python
def wait_for_condition(condition_fn, timeout=30, interval=0.5):
    """Poll until condition is true or timeout reached."""
    start = time.time()
    while time.time() - start < timeout:
        if condition_fn():
            return True
        time.sleep(interval)
    return False

# Usage
while not wait_for_condition(lambda: service.is_ready()):
    time.sleep(0.5)

result = do_something()
```

## Benefits

- **Reliable**: Waits exactly as long as needed
- **Fast**: Completes as soon as condition met
- **Clear**: Timeout makes intent obvious
- **Debuggable**: Can log state on timeout

## Key Principle

**Wait for readiness, not time.**
