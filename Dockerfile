FROM alpine:3.9
RUN apk update && apk add iputils iproute2 wget htop openssh-client
RUN cd /tmp && wget https://github.com/firecracker-microvm/firecracker/releases/download/v0.23.4/firecracker-v0.23.4-x86_64.tgz
RUN tar -zxf /tmp/firecracker-v0.23.4-x86_64.tgz && cd release-v0.23.4 && chmod +x firecracker-v0.23.4-x86_64 && mv firecracker-v0.23.4-x86_64 /usr/bin/firecracker
RUN mkdir /vm
COPY entrypoint.sh /

CMD sh /entrypoint.sh