#!/bin/sh

# Parse inputs 
META_YAML_PATH=`realpath $1`
OUTPUT_DIR=`realpath $2`
if [ "$3" = "None" ]; then
    PACKAGE_NAME=${GITHUB_REPOSITORY#*/}
else
    PACKAGE_NAME=$3
fi
if [ "$4" = "None" ]; then
    if [ "$5" = "None" ]; then
        PACKAGE_URL=https://github.com/$GITHUB_REPOSITORY/archive/$GITHUB_SHA.tar.gz
    else
        PACKAGE_URL=$5
    fi
else
    PACKAGE_URL=https://github.com/$GITHUB_REPOSITORY/archive/$4.tar.gz
fi
ALL_WHEELS_OUTPUT_DIR=`realpath $6`
BUILD_DEPS=$7

# Get pyodide and setup pyodide tools (from build-pyodide)
cd pyodide

# Put meta.yaml in place
mkdir -v -p packages/$PACKAGE_NAME
cp -v $META_YAML_PATH packages/$PACKAGE_NAME/meta.yaml
# Need to download to compute the checksum, required when using url
wget -v $PACKAGE_URL -O packages/$PACKAGE_NAME/package.tar.gz
CHECKSUM=`sha256sum packages/$PACKAGE_NAME/package.tar.gz | awk '{ print $1 }'`
# Edit meta.yaml
sed --debug -i 's@.*url:.*@  url: '"$PACKAGE_URL"'@' packages/$PACKAGE_NAME/meta.yaml
sed --debug -i 's@.*sha256:.*@  sha256: '"$CHECKSUM"'@' packages/$PACKAGE_NAME/meta.yaml
sed --debug -i '/md5:/d' packages/$PACKAGE_NAME/meta.yaml
# Need to move this to a file...
if [ "$BUILD_DEPS" = "false" ];
then
    export PACKAGE_NAME
    python -c "import os
PACKAGE_NAME=os.environ['PACKAGE_NAME']
from pathlib import Path
from ruamel.yaml import YAML
yaml= YAML()
def is_library(pkg):
    f= yaml.load(Path(f'packages/{pkg}/meta.yaml'))
    if not 'build' in f:
        return False
    if ('library' in f['build'] and f['build']['library']) \
        or ('sharedlibrary' in f['build'] and f['build']['sharedlibrary']):
        return True
    else:
        return False
f= yaml.load(Path(f'packages/{PACKAGE_NAME}/meta.yaml'))
if 'requirements' in f:
    if 'run' in f['requirements']:
        for ii in range(len(f['requirements']['run']))[::-1]:
           if not is_library(f['requirements']['run'][ii]):
               del f['requirements']['run'][ii]
yaml.dump(f,Path(f'packages/{PACKAGE_NAME}/meta_e.yaml'))"
    npx prettier -w packages/$PACKAGE_NAME/meta_e.yaml
    mv packages/$PACKAGE_NAME/meta_e.yaml packages/$PACKAGE_NAME/meta.yaml
fi;
cat packages/$PACKAGE_NAME/meta.yaml

# Build and copy output to output directory
#make
python -m pyodide_build buildall --only "$PACKAGE_NAME" packages $ALL_WHEELS_OUTPUT_DIR
echo "Build log"
cat packages/$PACKAGE_NAME/build.log

# Copy wheel to output dir
mkdir -v -p $OUTPUT_DIR
cp -v $ALL_WHEELS_OUTPUT_DIR/*$PACKAGE_NAME* $OUTPUT_DIR

