#!/bin/sh

# Parse inputs 
PYODIDE_TAG=$1

# Get pyodide and setup pyodide tools
git clone https://github.com/pyodide/pyodide
cd pyodide
git checkout $PYODIDE_TAG
make