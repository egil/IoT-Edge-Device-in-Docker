# IoT Edge Device in Docker
A docker image that enables running the aziot-edge 1.4 in a docker container.

## Getting started

To run an IoT Edge device locally, install a compatible Docker runtime, e.g. Docker for Windows.

Then the following is needed:

1. **Create an IoT device identity:**

```shell
az iot hub device-identity create --device-id <DEVICE_ID> --hub-name <IOT_HUB_NAME> --edge-enabled
az iot hub device-identity connection-string show --device-id <DEVICE_ID> --hub-name <IOT_HUB_NAME>
```

2. **Start the container:**

```shell
docker run -d --restart unless-stopped --privileged -it -v /var/run/docker.sock:/var/run/docker.sock -v /sys/fs/cgroup:/sys/fs/cgroup:rw -e connectionString='<IOT_EDGE_DEVICE_CONNECTION_STRING>' --hostname=edgedevice1 --name iot-edge-device egilhansen/iothub-edge-device:1.0.0-amd64 --dns 8.8.8.8 --log-driver "json-file" --log-opt "max-file=10" --log-opt "max-size=200k"
```

Or use the following docker-compose (with the edge device connection string replaced):

```
services:
  iot-edge-device:
    image: egilhansen/iothub-edge-device:1.0.0-amd64
    restart: unless-stopped
    privileged: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    environment:
      - connectionString="<IOT-EDGE-DEVICE-CONNECTION-STRING>"
    hostname: edgedevice1
    dns: 8.8.8.8
    logging:
      driver: "json-file"
      options:
        max-file: "10"
        max-size: "200k"
```

And then run: `docker compose up`.

3. **Monitor IoT edge init:**

```shell
docker exec -it iot-edge-device bash

# check init service
journalctl -u iotedge-init.service -f

# check iotedge
iotedge list
iotedge check
```