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
    sudo find pyodide -type d -exec chmod 755 {} \; 
    sudo find pyodide -type f -exec chmod 755 {} \;
    cd pyodide
    . emsdk/emsdk/emsdk_env.sh
fi;
make