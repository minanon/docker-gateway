
## Build

```bash
docker build -t gateway .
```

## Prepare

Please create docker network bridges for external and internal networks.
You can setup by netconf.sh in scripts/.

```bash
./scripts/netconf.sh -o eth0 -a 192.168.1.12 -i eth1 -r 192.168.202.180 -n docker1 -m docker2 -d external -c internal
```

### parameters

|parameter|description                                                   |
|:---:    |:---:                                                         |
|-o       |NIC name for accessing external                               |
|-a       |NIC IP for external                                           |
|-i       |NIC name for reciving from internal                           |
|-r       |NIC IP for internal                                           |
|-n       |Virtual NIC name for external (optional, default: docker1)    |
|-m       |Virtual NIC name for internal (optional, default: docker2)    |
|-d       |docker network name for external (optional, default: external)|
|-c       |docker network name for internal (optional, default: internal)|


## RUN

```bash
docker run -d --name=mygateway --net external --ip 192.168.1.13 --cap-add=NET_ADMIN gateway
docker network connect --ip 192.168.202.254 internal mygateway
```

## client machines setting

```bash
ip r d default
ip r a default via 192.168.202.254
```
