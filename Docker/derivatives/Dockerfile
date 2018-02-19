ARG versionTag
FROM pmce/ce-vm:$versionTag

ARG playBook
COPY ./${playBook} /tmp/
COPY ./roles /tmp/
RUN \
  set -x && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get dist-upgrade -y -o Dpkg::Options::="--force-confnew" && \
  ansible-playbook /tmp/${playBook} && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

