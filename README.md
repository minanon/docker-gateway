
## Build

docker build -t gateway .

## RUN

docker run -d --net external --ip 192.168.1.10 gateway

## your setting

ip r d default
ip r a default via 
