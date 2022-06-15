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

You can then use the generated wheel in `pyodide`. Put your wheel at some URL and then load the wheel in `pyodide` with
```
import pyodide_js
await pyodide_js.loadPackage(["https://URL/OF/YOUR/WHEEL.whl"])
```
Note that because at the time of writing, `pyodide` does not resolve and load dependencies when loading a wheel from a URL, you need to explicitly load any dependencies that you need. E.g., if you need `numpy` in the wheel, do
```
await pyodide_js.loadPackage(["numpy","https://URL/OF/YOUR/WHEEL.whl"])
```

Also see the [Advanced examples](#Advanced-examples) below.

## Inputs

All inputs are optional.

### `meta-yaml-path`
    
Path of the meta.yaml file (default: "meta.yaml").

### `pyodide-tag`

Pyodide tag/branch/SHA to use (default: "0.20.0"). Because caching is done based on `pyodide-tag`, using `main` is not recommended, because the cache will not be updated for changes to `main`. 

### `output-dir`

Directory for output package wheel( default: "wheelhouse").

### `all-wheels-output-dir`

Directory for all built wheels, includes dependencies and their dependencies and so on (default: "wheelhouse-all").

### `package-name`

Name of the package being built (default: repository name; needs to be set when building a URL).

### `build-tag`

When building the current repository, name of the branch/tag/SHA to build (default: commit's SHA); set either this or build-url (neither defaults to current SHA).

### `build-url`

URL of package to build (e.g., https://github.com/jobovy/galpy/archive/main.tar.gz); set either this or build-tag (neither defaults to current SHA).

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

### Building multiple packages

This action is set up to build a single package that is not already contained in `pyodide` (either a new package or an updated version of a package that already exists within `pyodide`). However, the action is composed of a set of simple individual steps and if you want to build multiple packages, you can do this by running the steps yourself and adding additional packages that you want to use.

This action has the following basic steps:
- Build `pyodide` using `jobovy/pyodide-buildpackage-action/actions/build-pyodide@main`: this checks out the `pyodide` repository and build all of the basic tools to build packages
- Create the new packages's `meta.yaml` file with `jobovy/pyodide-buildpackage-action/actions/build-meta@main`. By default, this will build the current commit of the repository that contains this action
- Build the new package with `jobovy/pyodide-buildpackage-action/actions/build-package@main`.

To build multiple packages, you can run the second step twice or more (or you can just copy the relevant `meta.yaml` into the correct `pyodide/packages/..` location). Note that you have to specify the `build-url` even if it is already in your `meta.yaml`, because it will be replaced by this action. When running the final build step, you then have to set `package-name` to a comma-separated list of all of the packages that you want to build.

Look at [the steps in action.yml](action.yml) for more details on how to run the steps and how to set up caching of the `pyodide` build.


