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
    docker image build --compress --label=ce-vm-$IMAGE:$VERSION --no-cache=true -t "pmce/ce-vm-$IMAGE:$VERSION" "$OWN_DIR/derivatives" --build-arg baseImage=$BASE --build-arg playBook=$IMAGE.yml --build-arg versionTag=$VERSION || exit 1
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
IMAGES="base-java base-php haproxy log memcached mkdocs mysql nginx redis solr varnish"
build_images 'ce-vm' "$IMAGES" "$1"

# NodeJS images built from the base.
IMAGES="nodejs-4.x nodejs-6.x nodejs-8.x nodejs-9.x nodejs-10.x nodejs-11.x nodejs-12.x"
build_images 'ce-vm' "$IMAGES" "$1"

# Derivatives from base-php.
IMAGES="base-cli dashboard fpm"
build_images 'ce-vm-base-php' "$IMAGES" "$1"

# Derivatives from base-java.
IMAGES="elastic-5.x elastic-6.x sonar"
build_images 'ce-vm-base-java' "$IMAGES" "$1"

# Derivatives from base-cli.
IMAGES="cli-custom cli-drupal cli-symfony3 cli-symfony4 cli-wordpress prototype"
build_images 'ce-vm-base-cli' "$IMAGES" "$1"

# Derivatives from nodejs.
IMAGES="nightwatch"
build_images 'ce-vm-nodejs-8.x' "$IMAGES" "$1"
