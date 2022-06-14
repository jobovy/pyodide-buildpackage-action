# pyodide-buildpackage-action

GitHub Action to build pyodide wheels

## Example

```
on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: jobovy/pyodide-buildpackage-action@main
    - uses: actions/upload-artifact@v2-preview
      with:
        name: package-wheel-pyodide
        path: wheelhouse/*.whl
```

Also see the [Advanced examples](#Advanced-examples) below.

## Inputs

All inputs are optional.

### `meta-yaml-path`
    
Path of the meta.yaml file (default: "meta.yaml")

### `pyodide-tag`

Pyodide tag or branch to use (default: "0.20.0")

### `output-dir`

Directory for output package wheel( default: "wheelhouse")

### `all-wheels-output-dir`

Directory for all built wheels, includes dependencies and their dependencies and so on (default: "wheelhouse-all")

### `package-name`

Name of the package being built (default: repository name; needs to be set when building a URL)

### `build-tag`

When building the current repository, name of the branch/tag/SHA to build (default: commit's SHA); set either this or build-url (neither defaults to current SHA)

### `build-url`

URL of package to build (e.g., https://github.com/jobovy/galpy/archive/main.tar.gz); set either this or build-tag (neither defaults to current SHA)

### `build-deps`

Whether or not to build runtime Python dependencies (True/False; default: False). If you need a Python dependency during your build (e.g., `numpy`), then you'll have to run with `build-deps: True`.

## Advanced examples

### Custom ``meta.yaml`` location

```
    - uses: jobovy/pyodide-buildpackage-action@main
      with:
        meta-yaml-path: .github/pyodide_meta.yaml
```

### Use a different ``pyodide`` tag or branch

E.g., to use the latest `main` branch

```
    - uses: jobovy/pyodide-buildpackage-action@main
      with:
        pyodide-tag: main
```

### Build from a URL

```
    - uses: jobovy/pyodide-buildpackage-action@main
      with:
        package-name: galpy
        build-url: https://github.com/jobovy/galpy/archive/main.tar.gz
```

### Build all dependencies of your package

```
    - uses: jobovy/pyodide-buildpackage-action@main
      with:
        meta-yaml-path: .github/pyodide_meta.yaml
        build-deps: True
```
