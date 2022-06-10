#!/bin/sh
META_YAML_PATH=`realpath $1`
PYODIDE_TAG=$2
OUTPUT_DIR=`realpath $3`
PACKAGE_NAME=galpy
#${GITHUB_REPOSITORY#*/}
PACKAGE_URL=https://github.com/jobovy/galpy/archive/main.tar.gz
#https://github.com/$GITHUB_REPOSITORY/archive/$GITHUB_SHA.tar.gz

# Get pyodide and setup pyodide tools
git clone https://github.com/pyodide/pyodide
cd pyodide
git checkout $2
make

# Put meta.yaml in place
mkdir -p packages/$PACKAGE_NAME
cp $META_YML_PATH packages/$PACKAGE_NAME/meta.yaml
sed -i 's@.*url.*@  url: '"$PACKAGE_URL"'@' packages/$PACKAGE_NAME/meta.yaml
sed -i '/sha256/d' packages/$PACKAGE_NAME/meta.yaml
sed -i '/md5/d' packages/$PACKAGE_NAME/meta.yaml
cat packages/$PACKAGE_NAME/meta.yaml

# Build
python -m pyodide_build buildall --only "$PACKAGE_NAME" packages $OUTPUT_DIR

