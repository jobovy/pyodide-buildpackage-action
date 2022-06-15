#!/bin/sh

# Parse inputs 
if [ "$1" = "None" ]; then
    PACKAGE_NAME=${GITHUB_REPOSITORY#*/}
else
    PACKAGE_NAME=$1
fi
OUTPUT_DIR=`realpath $2`
ALL_WHEELS_OUTPUT_DIR=`realpath $3`

# Get pyodide and setup pyodide tools (done in build-pyodide)
cd pyodide
# Need to make sure emcc gets installed again
rm -f emsdk/emsdk/.complete
make

# Build and copy output to output directory
python -m pyodide_build buildall --only "$PACKAGE_NAME" packages $ALL_WHEELS_OUTPUT_DIR
echo "Build log"
cat packages/$PACKAGE_NAME/build.log

# Copy wheel to output dir
mkdir -v -p $OUTPUT_DIR
cp -v $ALL_WHEELS_OUTPUT_DIR/*$PACKAGE_NAME* $OUTPUT_DIR

