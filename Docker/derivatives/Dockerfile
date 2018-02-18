ARG versionTag
FROM pmce/ce-vm:$versionTag

ARG playBook
COPY ./${playBook} /tmp/
COPY ./roles /tmp/
RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  ansible-playbook /tmp/${playBook} && \
  apt-get update && \
  apt-get dist-upgrade -y -o Dpkg::Options::="--force-confnew" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

