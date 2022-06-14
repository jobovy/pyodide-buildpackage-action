#!/bin/sh

# Parse inputs 
OUTPUT_DIR=`realpath $1`
ALL_WHEELS_OUTPUT_DIR=`realpath $2`

# Get pyodide and setup pyodide tools (from build-pyodide)
cd pyodide

# Build and copy output to output directory
#make
#python -m pyodide_build buildall --only "$PACKAGE_NAME" packages $ALL_WHEELS_OUTPUT_DIR
#echo "Build log"
#cat packages/$PACKAGE_NAME/build.log

# Copy wheel to output dir
#mkdir -v -p $OUTPUT_DIR
#cp -v $ALL_WHEELS_OUTPUT_DIR/*$PACKAGE_NAME* $OUTPUT_DIR

