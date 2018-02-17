#!/bin/sh
#
# (Re)build a Docker base box for ce-vm.
#

IMAGES="base app log db"

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

# Ensure we have a fresh image to start with.
docker image pull debian:jessie-slim
# Build all images recursively.
for IMAGE in $IMAGES; do
  echo "1. Building the image"
  docker image build --compress --label=ce-vm-$IMAGE:$1 --no-cache=true -t "pmce/ce-vm-$IMAGE:$1" "$OWN_DIR/$IMAGE" || exit 1
  echo "Publishing the image with docker image push pmce/ce-vm-$IMAGE:$1"
  docker image push "pmce/ce-vm-$IMAGE:$1"
  # Ensure we have a fresh image to start with.
  docker image pull pmce/ce-vm-base:$1
done