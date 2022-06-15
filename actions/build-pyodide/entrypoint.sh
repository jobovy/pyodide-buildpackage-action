#!/bin/sh

# Parse inputs 
PYODIDE_TAG=$1
PYODIDE_CACHE_HIT=$2

# Get pyodide and setup pyodide tools
if [ "$PYODIDE_CACHE_HIT" != "true" ];
then
    git clone https://github.com/pyodide/pyodide
    cd pyodide
    git checkout $PYODIDE_TAG
else
    cd pyodide
    # Need to make sure emcc gets installed again when the cache is restored
    rm -f emsdk/emsdk/.complete
fi;
make