# Start from Ubuntu for `apt-get`
FROM ubuntu:22.04

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    jq \
    net-tools \
    iptables \
    iproute2 \
    systemd && \
    rm -rf /var/lib/apt/lists/*

# Cleanup to enable systemd and systemctl commands
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Step 1: Install Microsoft package repository
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

# Step 2: Install Moby engine and Azure CLI
RUN apt-get update && apt-get install -y moby-cli moby-engine

# Step 3: Configure Docker daemon
RUN echo '{ "log-driver": "local" }' > /etc/docker/daemon.json

# Step 4: Install Azure IoT Edge
RUN apt-get install -y aziot-edge

# Clean up to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Allow services to start
VOLUME [ "/sys/fs/cgroup", "/var/lib/docker" ]

EXPOSE 2375
EXPOSE 15580
EXPOSE 15581

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY iotedge-init.service /etc/systemd/system/iotedge-init.service
COPY edge-init.sh /usr/local/bin/edge-init.sh
RUN chmod +x /usr/local/bin/edge-init.sh
RUN systemctl enable iotedge-init.service

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

