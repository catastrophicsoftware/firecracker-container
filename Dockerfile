FROM alpine:3.9
WORKDIR /vm

ENV FIRECRACKER_VERSION v0.24.5
ENV MICROVM_IP 172.20.0.2
#MICROVM_SSH_PORT is the ssh port that will be mapped into the MicroVM host container, to be forwarded to <microvm ip>:22

RUN apk update && apk add iputils iproute2

#Install firecracker
RUN cd /tmp && wget https://github.com/firecracker-microvm/firecracker/releases/download/${FIRECRACKER_VERSION}/firecracker-${FIRECRACKER_VERSION}-x86_64.tgz
RUN tar -zxf /tmp/firecracker-${FIRECRACKER_VERSION}-x86_64.tgz && \
  cd release-${FIRECRACKER_VERSION} && \
  chmod +x firecracker-${FIRECRACKER_VERSION}-x86_64 && \
  mv firecracker-${FIRECRACKER_VERSION}-x86_64 /usr/bin/firecracker && \
  rm /tmp/firecracker-${FIRECRACKER_VERSION}-x86_64.tgz

COPY entrypoint.sh /

ENTRYPOINT ["sh", "/entrypoint.sh"]