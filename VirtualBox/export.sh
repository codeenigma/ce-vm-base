#!/bin/sh
#
# Export an existing VM and detach it from Puppet.
# This is to share VMs with external dev teams outside CE.
#


usage(){
  cat << EOF
usage:

Export a base CodeEnigma VM.
$0 </path/to/where/to/export/the/box>


EOF
}


# Keep current dir in mind to know where to move back when done.
OWN=$(readlink "$0");
if [ -z "$OWN" ]; then
 OWN="$0"
fi
OWN_DIR=$( cd "$( dirname "$OWN" )" && pwd -P)

# Quick check we have args.
if [ -z $1 ]; then
  usage
  exit 1;
fi

# Quick check we have destination.
if [ ! -w $1 ]; then
  echo "$1 is not a writable directory"
  exit 1;
fi

echo "1. Create a working temp dir."
PROJECT_WORK_DIR=`mktemp -d /tmp/boxce.XXXXXXXXXX`

echo "2. Copy Vagrantfile to the working directory"
cp "$OWN_DIR/Vagrantfile" "$PROJECT_WORK_DIR/"

echo "3. Bring up and provision the base box"
cd "$PROJECT_WORK_DIR"
vagrant up

echo "Machine is up, you can ssh to it and make manual amends:"
echo "cd $PROJECT_WORK_DIR && vagrant ssh"
echo "Press [ENTER] when you are done, to trigger the box package."
read PROCEED
echo "4. Cleaning up disk space."
vagrant ssh -c 'sudo umount -a'
vagrant ssh -c 'sudo rm -rf /vagrant'
vagrant ssh -c 'rm -rf ~/*'
vagrant ssh -c 'dd if=/dev/zero of=zerofile bs=1M'
vagrant ssh -c 'rm zerofile'
vagrant halt
echo "5. Creating package."
vagrant package --output "$1/jessie64.box"
echo "Base box has been created at $1/jessie64.box"
echo "Press [ENTER] to proceed and destroy the temporary VM."
read DESTROY
vagrant destroy -f
exit