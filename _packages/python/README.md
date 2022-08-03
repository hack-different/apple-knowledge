# Apple Hardware Data

Brought to you by the [Hack Different](https://hackdifferent.com) team.

## Introduction

This is a package with data files sourced from
the [Hack Different - Apple Knowledge](https://github.com/hack-different/apple-knowledge/tree/main/_data)
repository.  Updates to that repository will automatically update this package, therefore no attempt should
be made to update the data files by any other method.

## Accessing the Data

For the time being, there is only one simple API:

```python
from apple_data import get_data

REGISERS = get_data('registers')
```

## Credits

* [Hack Different](https://hackdifferent.com)

Created and maintained as a labor of love by [`rickmark`](https://github.com/rickmark)