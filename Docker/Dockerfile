FROM debian:jessie

RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  mkdir -p '/home/vagrant/.CodeEnigma/ce-vm/cache' && \
  mv '/var/cache/apt' '/home/vagrant/.CodeEnigma/ce-vm/cache/' && \
  echo 'Dir{Cache /home/vagrant/.CodeEnigma/ce-vm/cache/apt}' > /etc/apt/apt.conf.d/90ce-vm-aptcache && \
  echo 'Dir::Cache /home/vagrant/.CodeEnigma/ce-vm/cache/apt;' >> /etc/apt/apt.conf.d/90ce-vm-aptcache && \
  echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' > /etc/apt/sources.list.d/ansible.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y rsync linux-headers-amd64 make dkms cpp binutils fakeroot gcc openssh-server curl sudo apt-utils ansible git apt-transport-https build-essential unzip vim software-properties-common wget && \
  useradd -s /bin/bash vagrant && \
  echo vagrant:vagrant | chpasswd -m && \
  install -m 755 -o vagrant -g vagrant -d /home/vagrant && \
  install -m 700 -o vagrant -g vagrant -d /home/vagrant/.ssh && \
  echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/vagrant/.ssh/authorized_keys \
  chmod 600 /home/vagrant/.ssh/authorized_keys && \
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys && \
  echo root:vagrant | chpasswd -m && \
  echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
  chmod 0440 /etc/sudoers.d/vagrant && \
  echo 'UseDNS no' >> /etc/ssh/sshd_config && \
  mkdir -p /var/run/sshd && \
  rm /usr/sbin/policy-rc.d && \
  rm /etc/apt/apt.conf.d/docker-clean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
