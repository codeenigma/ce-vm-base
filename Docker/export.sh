#!/bin/sh
#
# (Re)build a Docker base box.
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

echo "1. Building the image"
docker image build --compress --label=jessie64 --no-cache=true -t pmce/jessie64:$1 "$OWN_DIR" || exit 1

echo "Image is ready to be published with 'docker image push pmce/jessie64'"
echo "Do not forget to increment the version tag"
exit