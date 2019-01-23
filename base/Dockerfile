FROM debian:stretch

RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update -o Acquire::http::AllowRedirect=false && \
  apt-get dist-upgrade -y -o Acquire::http::AllowRedirect=false -o Dpkg::Options::="--force-confnew" && \
  apt-get install -y -o Dpkg::Options::="--force-confnew" \
    apt-transport-https \
    apt-utils \
    binutils \
    cron \
    curl \
    dirmngr \ 
    git \
    gnupg \
    rsync \
    openssh-server \
    postfix \
    procmail \
    python-apt \
    python-dev \
    python-pycurl \
    rsyslog \
    sshfs \
    sudo \
    unzip \
    vim \
    wget \
    zsh && \
    rm -rf /var/lib/apt/lists/* && \
  apt-get clean  && \
  rm -rf /tmp/* && \
  echo 'UseDNS no' >> /etc/ssh/sshd_config && \
  mkdir -p /var/run/sshd && \
  rm /usr/sbin/policy-rc.d

RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \  
  echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' > /etc/apt/sources.list.d/ansible.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
  apt-get update && \
  apt-get dist-upgrade -y -o Dpkg::Options::="--force-confnew" && \
  apt-get install -y -o Dpkg::Options::="--force-confnew" ansible && \
  rm -rf /tmp/* && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  curl https://www.codeenigma.com/sites/default/files/unison-2.48.4 -o /usr/local/bin/unison && \
  curl https://www.codeenigma.com/sites/default/files/unison-fsmonitor-2.48.4 -o /usr/local/bin/unison-fsmonitor && \
  rm -rf /tmp/* && \
  chmod 0655 /usr/local/bin/unison && \
  chmod 0655 /usr/local/bin/unison-fsmonitor

RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  useradd -s /bin/bash vagrant && \
  echo vagrant:vagrant | chpasswd -m && \
  install -m 755 -o vagrant -g vagrant -d /home/vagrant && \
  install -m 700 -o vagrant -g vagrant -d /home/vagrant/.ssh && \
  curl https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant -o /home/vagrant/.ssh/id_rsa && \
  curl https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys && \
  rm -rf /tmp/* && \
  chmod 600 /home/vagrant/.ssh/id_rsa && \
  chmod 600 /home/vagrant/.ssh/authorized_keys && \
  chown -R vagrant:vagrant /home/vagrant/.ssh && \
  echo root:vagrant | chpasswd -m && \
  echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
  chmod 0440 /etc/sudoers.d/vagrant

COPY ./ce-vm-start.sh /opt/
EXPOSE 22
CMD ["/bin/sh", "/opt/ce-vm-start.sh", "1000", "1000"]
  
