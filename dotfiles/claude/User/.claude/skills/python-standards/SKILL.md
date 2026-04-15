---
name: python-standards
description: "Authoritative standards for Python development in the Tractian AI monorepo. Use this when writing, refactoring, or reviewing Python code. Trigger on: 'new python file', 'refactor python', 'python style', 'fix linting', or 'how to write python here'."
---

# Python Standards & Patterns

All Python code must follow these standards.

## Core Directives
- **Imports:** Every file MUST start with `from __future__ import annotations`.
- **Logging:** Use `structlog` only. Never `print()` or standard `logging` for app logic.
- **Exports:** Every `__init__.py` must define explicit `__all__` list.

## Type System & Data Modeling
- **Interfaces:** Prefer `typing.Protocol` over `abc.ABC` for structural subtyping.
- **Models:** Use **Pydantic v2** for system boundaries (APIs, Configs). Always include `model_config = ConfigDict(use_attribute_docstrings=True)`.
- **Internal Data:** Use standard `@dataclass` for internal, non-serializable data structures.


```python
# Example Pattern
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
## Execution 
Use `uv run` for scripts/tools.

## Testing
```bash
uv run pytest                              # run all tests (paths from pytest.ini)
uv run pytest mle/libs/metrics_anomalies/tests                   # run tests for a specific lib
uv run pytest mle/libs/metrics_anomalies/tests/test_foo.py::test_bar_SomeCase  # single test
```

## Linting
```bash
uv run ruff check .    # lint
uv run black .         # format (line-length 88, black profile)
```
