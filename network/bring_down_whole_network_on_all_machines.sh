#!/bin/bash

#set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION


docker service rm $(docker service ls -q)	# this will stop all docker coninters on all 3 nodes
sleep 10

# Clean things on ORG1 first
docker swarm leave -f
#docker network rm docker_gwbridge
docker system prune -f
docker rmi $(docker images | grep "peer0.org1.example.com" | awk '{print $3}')

# Clean things on ORG2 next
ssh ubuntu@$WORKER_NODE1_HOSTNAME 'docker swarm leave -f; docker system prune -f'

# Clean things on ORG2 next
ssh ubuntu@$WORKER_NODE2_HOSTNAME 'docker swarm leave -f; docker system prune -f'
