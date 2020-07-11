#!/bin/bash

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

#### Initialize swarm network and create overlay network
docker swarm init
DOCKER_SWARM_JOIN_CMD=$(docker swarm join-token worker | grep "docker swarm join")

ssh ubuntu@$WORKER_NODE1_HOSTNAME $DOCKER_SWARM_JOIN_CMD
ssh ubuntu@$WORKER_NODE2_HOSTNAME $DOCKER_SWARM_JOIN_CMD

docker network create --driver overlay --subnet=10.200.1.0/24 --attachable "$NETWORK_NAME"


#### Bringup Fabric network. Start all containers
./start_all.sh
#sleep 20
