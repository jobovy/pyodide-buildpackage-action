#!/bin/sh
META_YML_PATH=$1
PYODIDE_TAG=$2
OUTPUT_DIR=$3
PACKAGE_NAME=galpy
#${GITHUB_REPOSITORY#*/}
PACKAGE_URL=https://github.com/jobovy/galpy/archive/main.tar.gz
#https://github.com/$GITHUB_REPOSITORY/archive/$GITHUB_SHA.tar.gz

# Put meta.yml in place
mkdir -p pyodide/packages/$PACKAGE_NAME
cp $1 pyodide/packages/$PACKAGE_NAME
cd pyodide/packages/$PACKAGE_NAME
sed -i 's@.*url.*@ url:  '"$PACKAGE_URL"'@' meta.yml
cat meta.yml
cd ../../

# Get pyodide and setup pyodide tools
git clone https://github.com/pyodide/pyodide
cd pyodide
git checkout $2
make
cd ..


# Build
python -m pyodide_build buildall --only '$PACKAGE_NAME' packages ../$OUTPUT_DIR

