#!/bin/sh
#
# (Re)build a Docker base box for ce-vm.
#

usage(){
  cat << EOF
usage:

Export a base CodeEnigma image.
$0 <versiontag>

EOF
}

# Quick check we have args.
if [ -z $1 ]; then
  usage
  exit 1;
fi

# Keep current dir in mind to know where to move back when done.
OWN=$(readlink "$0");
if [ -z "$OWN" ]; then
 OWN="$0"
fi
OWN_DIR=$( cd "$( dirname "$OWN" )" && pwd -P)

# Build all images recursively.
# @param $1
# Base image to use.
# @param $2
# Array of images to build.
# @param $3
# Version tag.
build_images(){
  BASE=$1
  IMAGES=$2
  VERSION=$3
  for IMAGE in $IMAGES; do
    docker image pull "pmce/$BASE:$VERSION"
    echo "1. Building the image"
    docker image build --compress --label=ce-vm-$IMAGE:$VERSION --no-cache=true -t "pmce/ce-vm-$IMAGE:$VERSION" "$OWN_DIR/derivatives" --build-arg playBook=$IMAGE.yml --build-arg versionTag=$VERSION || exit 1
    echo "Publishing the image with docker image push pmce/ce-vm-$IMAGE:$VERSION"
    docker image push "pmce/ce-vm-$IMAGE:$VERSION"
  done
}

# Ensure we have a fresh image to start with.
docker image pull debian:stretch

# Build base image.
echo "1. Building the image"
docker image build --compress --label=ce-vm:$1 --no-cache=true -t "pmce/ce-vm:$1" "$OWN_DIR/base" || exit 1
echo "Publishing the image with docker image push pmce/ce-vm:$1"
docker image push "pmce/ce-vm:$1"

# Images built from the base.
IMAGES="base-php log memcached mkdocs mysql solr"
build_images 'ce-vm' "$IMAGES" "$1"

IMAGES="base-cli fpm"
# Derivatives.
build_images 'ce-vm-base-php' "$IMAGES" "$1"