#!/bin/bash
GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION

set -ev

# ORG 2
docker stack deploy -c "$PEER_ORG2_COMPOSE_PATH" hlf_peer
sleep 3

