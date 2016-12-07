
## Build

```bash
docker build -t minanon/gateway .
```

## Prepare

Please create docker network bridges for external and internal networks.
You can setup by netconf.sh in scripts/.

```bash
./scripts/netconf.sh -a eth0 -b 192.168.1.2 -c 192.168.1.0/24 -d docker-external -e external -o eth1 -p 192.168.100.250 -q 192.168.1.0/24 -r docker-internal -s internal
```

### parameters

|parameter|description                                                                                       |
|:---:    |:---:                                                                                             |
|-a       |NIC name for accessing external      (e.g. eth0)                                                  |
|-b       |NIC IP for external                  (e.g. 192.168.1.2)                                           |
|-c       |Subnet for external                  (optional, e.g. 192.168.1.0/24, default: prefix 24 with -b)  |
|-d       |Virtual NIC name for external        (optional, default: docker-external)                         |
|-e       |docker network name for external     (optional, default: external)                                |
|-o       |NIC name for reciving from internal  (e.g. eth1)                                                  |
|-p       |NIC IP for internal                  (e.g. 192.168.100.250)                                       |
|-q       |Subnet for internal                  (optional, e.g. 192.168.100.0/24, default: prefix 24 with -p)|
|-r       |Virtual NIC name for internal        (optional, default: docker-internal)                         |
|-s       |docker network name for internal     (optional, default: internal)                                |


## RUN

```bash
docker run -d --name mygateway --net external --ip 192.168.1.13 --cap-add NET_ADMIN gateway
docker network connect --ip 192.168.100.254 internal mygateway
```

## client machines setting

```bash
ip r d default
ip r a default via 192.168.202.254
```
