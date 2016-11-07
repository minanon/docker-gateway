# external phisycal dev
external_dev=ens36
# external gateway ip
external_gateway=192.168.1.12
# external subnet
external_subnet=192.168.1.0/24

external_bridge_name=docker1
external_network_name=external

# internal phisycal dev
internal_dev=ens33
# internal gateway ip
internal_gateway=192.168.202.254
# internal subnet
internal_subnet=192.168.202.0/24

internal_bridge_name=docker2
internal_network_name=internal

$(docker network inspect ${external_network_name} > /dev/null 2>&1) || {
    brctl addif ${external_bridge_name} ${external_dev}
    docker network create --driver bridge --subnet=${external_subnet} --gateway=${external_gateway} --opt "com.docker.network.bridge.name"="${external_bridge_name}" ${external_network_name}
}

$(docker network inspect ${internal_network_name} > /dev/null 2>&1) || {
    brctl addif ${internal_bridge_name} ${internal_dev}
    docker network create --driver bridge --subnet=${internal_subnet} --gateway=${internal_gateway} --opt "com.docker.network.bridge.name"="${internal_bridge_name}" ${internal_network_name}
}
