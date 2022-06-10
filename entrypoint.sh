#!/bin/sh

# Parse inputs 
META_YAML_PATH=`realpath $1`
PYODIDE_TAG=$2
OUTPUT_DIR=`realpath $3`
if [ "$4" = "None" ]; then
    PACKAGE_NAME=${GITHUB_REPOSITORY#*/}
else
    PACKAGE_NAME=$4
fi
PACKAGE_VERSION=$5
if [ "$6" = "None" ]; then
    if [ "$7" = "None" ]; then
        PACKAGE_URL=https://github.com/GITHUB_REPOSITORY/archive/$GITHUB_SHA.tar.gz
    else
        PACKAGE_URL=$7
    fi
else
    PACKAGE_URL=https://github.com/GITHUB_REPOSITORY/archive/$6.tar.gz
fi
ALL_WHEELS_OUTPUT_DIR=`realpath $8`

# Get pyodide and setup pyodide tools
git clone https://github.com/pyodide/pyodide
cd pyodide
git checkout $2
make

# Put meta.yaml in place
mkdir -v -p packages/$PACKAGE_NAME
cp -v $META_YAML_PATH packages/$PACKAGE_NAME/meta.yaml
sed --debug -i 's@.*version:.*@  version: '"$PACKAGE_VERSION"'@' packages/$PACKAGE_NAME/meta.yaml
sed --debug -i 's@.*url:.*@  url: '"$PACKAGE_URL"'@' packages/$PACKAGE_NAME/meta.yaml
sed --debug -i '/sha256:/d' packages/$PACKAGE_NAME/meta.yaml
sed --debug -i '/md5:/d' packages/$PACKAGE_NAME/meta.yaml
cat packages/$PACKAGE_NAME/meta.yaml

# Build and copy output to output directory
python -m pyodide_build buildall --only "$PACKAGE_NAME" packages $ALL_WHEELS_OUTPUT_DIR
mkdir -v -p $OUTPUT_DIR
cp -v $ALL_WHEELS_OUTPUT_DIR/*$PACKAGE_NAME* $OUTPUT_DIR

