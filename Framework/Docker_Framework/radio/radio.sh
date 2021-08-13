#!/bin/bash
name=radio         # repo name - used as root for container names
subnet_mask=172.70.0.0/16 # unique to the docker instance
ip=172.70.0.2

namespace=grahamsw/ # your docker namespace here

repo=$namespace$name
network_name=$name"_network"

sc_name=$name"_sc"
py_name=$name"_py"

echo $repo $subnet_mask $network_name $sc_name $py_name

#docker stop $(docker ps -qa)
#docker rm $(docker ps -qa)

#docker network prune -f

docker stop $sc_name
docker stop $py_name

docker rm $sc_name
docker rm $py_name

docker network rm $network_name

docker network create --subnet $subnet_mask $network_name

docker pull $repo":sc"
docker pull $repo":py"

docker run -d --name $sc_name --network $network_name --ip $ip $repo":sc"
docker run -d --name $py_name --network $network_name --env SC_IP=$ip $repo":py"