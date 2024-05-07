#!/bin/bash
echo "***Configuring IoT Edge Runtime***"
cat <<EOF > /etc/aziot/config.toml
[provisioning]
source = "manual"
connection_string = "$connectionString"

[agent]
name = "edgeAgent"
type = "docker"

[agent.config]
image = "mcr.microsoft.com/azureiotedge-agent:1.5"
createOptions = { HostConfig = { Binds = ["/iotedge/storage:/iotedge/storage"] } }

[connect]
workload_uri = "unix:///var/run/iotedge/workload.sock"
management_uri = "unix:///var/run/iotedge/mgmt.sock"

[listen]
workload_uri = "fd://aziot-edged.workload.socket"
management_uri = "fd://aziot-edged.mgmt.socket"

[moby_runtime]
uri = "unix:///var/run/docker.sock"
network = "azure-iot-edge"
EOF
mkdir -p /iotedge/storage

echo "***Starting systemd***"
exec /lib/systemd/systemd --log-level=info
