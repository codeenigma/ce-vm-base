ARG versionTag
ARG baseImage
FROM pmce/${baseImage}:$versionTag

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
  rm -rf /tmp/* && \
  apt-get clean

EXPOSE 22
CMD ["/bin/sh", "/opt/ce-vm-start.sh", "1000", "1000"]