#!/bin/bash

# default
external_bridge_name=docker-external
external_network_name=external
internal_bridge_name=docker-internal
internal_network_name=internal
force_overwrite=false

# perse params
for opt in "$@"
do
  case "${opt}" in
    -a)
      external_dev=$2
      shift 2
      ;;
    -b)
      external_gateway=$2
      shift 2
      ;;
    -c)
      external_subnet=$2
      shift 2
      ;;
    -d)
      external_bridge_name=$2
      shift 2
      ;;
    -e)
      external_network_name=$2
      shift 2
      ;;

    -o)
      internal_dev=$2
      shift 2
      ;;
    -p)
      internal_gateway=$2
      shift 2
      ;;
    -q)
      internal_subnet=$2
      shift 2
      ;;
    -r)
      internal_bridge_name=$2
      shift 2
      ;;
    -s)
      internal_network_name=$2
      shift 2
      ;;
    -z)
      force_overwrite=true
      ;;
    *)
      continue
      ;;
  esac
done

# check params
if [ ! "${external_dev}" ] || [ ! "${external_gateway}" ] || [ ! "${internal_dev}" ] || [ ! "${internal_gateway}" ]
then
  echo "please set params" >&2
  exit
fi

# auto setting prefix length
[ ! "${external_subnet}" ] && external_subnet=$(echo "${external_gateway}" | sed -e 's|\.[0-9]\+$|.0/24|')
[ ! "${internal_subnet}" ] && internal_subnet=$(echo "${internal_gateway}" | sed -e 's|\.[0-9]\+$|.0/24|')


# check exists network
exists_external=$(docker network inspect ${external_network_name} > /dev/null 2>&1 && echo true || echo false)
exists_internal=$(docker network inspect ${internal_network_name} > /dev/null 2>&1 && echo true || echo false)

# overwrite network setting?
if ${force_overwrite}
then
    $exists_external && docker network rm ${external_network_name}
    $exists_internal && docker network rm ${internal_network_name}
    exists_external=false
    exists_internal=false
fi

# set docker network
${exists_external} || {
    docker network create --driver bridge --subnet=${external_subnet} --gateway=${external_gateway} --opt "com.docker.network.bridge.name"="${external_bridge_name}" ${external_network_name}
    brctl addif ${external_bridge_name} ${external_dev}
}

${exists_internal} || {
    docker network create --driver bridge --subnet=${internal_subnet} --gateway=${internal_gateway} --opt "com.docker.network.bridge.name"="${internal_bridge_name}" ${internal_network_name}
    brctl addif ${internal_bridge_name} ${internal_dev}
}
