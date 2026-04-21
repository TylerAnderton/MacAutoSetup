---
name: python-standards
description: "Authoritative standards for Python development. Use when writing, refactoring, or reviewing Python code. Trigger on: 'new python file', 'refactor python', 'python style', 'fix linting', or 'how to write python here'."
---

<objective>
Ensure all Python code follows consistent patterns: imports, logging, type system, data modeling, testing, and linting.
</objective>

<essential_principles>
- **Imports:** Every file MUST start with `from __future__ import annotations`
- **Logging:** Use `structlog` only. Never `print()` or standard `logging` for app logic
- **Exports:** Every `__init__.py` must define explicit `__all__` list
- **Tooling Constraint:** Never use Bash to edit files — Read, Edit, Write tools only
- **Execution:** Use `uv run` for scripts and tools
</essential_principles>

<type_system>
- **Interfaces:** Prefer `typing.Protocol` over `abc.ABC` for structural subtyping
- **Models:** Use Pydantic v2 for system boundaries (APIs, Configs). Always include `model_config = ConfigDict(use_attribute_docstrings=True)`
- **Internal Data:** Use standard `@dataclass` for internal, non-serializable data structures
</type_system>

<testing>
```bash
bazel test //mle/libs/metrics_anomalies/...           # run all tests
bazel test //mle/libs/metrics_anomalies/tests:test_foo # single target
```
</testing>

<linting>
```bash
uv run ruff check .    # lint
uv run ruff format .   # format (line-length 88, black profile)
```
</linting>

<example>
```python
from __future__ import annotations
import structlog
from typing import Protocol
from pydantic import BaseModel, ConfigDict

logger = structlog.get_logger()

class MetricProcessor(Protocol):
    """Structural interface for processors."""
    def process(self, data: dict) -> bool: ...

class ProcessorConfig(BaseModel):
    model_config = ConfigDict(use_attribute_docstrings=True)

    threshold: float
    """The sensitivity threshold for anomaly detection."""
```

```python
# Internal data uses dataclass
from dataclasses import dataclass

@dataclass
class ProcessingResult:
    success: bool
    records_processed: int
    errors: list[str]
```
</example>
