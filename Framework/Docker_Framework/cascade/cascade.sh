#!/bin/bash

# this is customized and then copied to the machine that will run the docker 
# containers. 
#
# It is used to tear down and set up the running containers (which is messy
# enough that you don't want to be typing it )

#CUSTOMISE THIS
name=cascade         # repo name - used as root for container names
subnet_base=172.105 # unique to the docker instance
namespace=grahamsw/ # your docker namespace here

# SHOULDN't NEED TO CUSTOMIZE UNLESS YOU'RE DOING SOMETHING DIFFERENT
subnet_mask=$subnet_base".0.0/16"
ip=$subnet_base".0.5"
repo=$namespace$name
network_name=$name"_network"

sc_name=$name"_sc"
py_name=$name"_py"

# uncomment to sanity check
# echo $repo $subnet_mask $network_name $sc_name $py_name

# uncomment to remove ALL running docker containers & networks
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