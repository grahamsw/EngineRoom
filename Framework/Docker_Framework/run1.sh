#!/bin/bash

docker stop $(docker ps -qa)
docker rm $(docker ps -qa)

docker network prune -f

# docker network create --subnet 172.60.0.0/16 port_test_network

# docker pull grahamsw/port_test_sc:latest
# docker pull grahamsw/port_test_py:latest

# docker run -d --name port_test_sc --network port_test_network --ip 172.60.0.2 grahamsw/port_test_sc:latest
# docker run -d --name port_test_py --network port_test_network --env SC_IP=172.60.0.2  grahamsw/port_test_py:latest

docker network create --subnet 172.70.0.0/16 port_test_2_network

docker pull grahamsw/port_test_2_sc:latest
docker pull grahamsw/port_test_2_py:latest

docker run -d --name port_test_2_sc --network port_test_2_network --ip 172.70.0.2 grahamsw/port_test_2_sc:latest
docker run -d --name port_test_2_py --network port_test_2_network --env SC_IP=172.70.0.2 grahamsw/port_test_2_py:latest


docker network create --subnet 172.80.0.0/16 radio_2_network

docker pull grahamsw/sc_radio_2:latest
docker pull grahamsw/python_docker_dk2:latest

docker run -d --name radio_2_sc --network radio_2_network --ip 172.80.0.2 grahamsw/sc_radio_2:latest
docker run -d --name radio_2_py --network radio_2_network --env SC_IP=172.80.0.2 grahamsw/python_docker_dk2:latest

