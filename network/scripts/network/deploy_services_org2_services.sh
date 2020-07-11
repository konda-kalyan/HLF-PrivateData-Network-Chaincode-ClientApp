#!/bin/bash
GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION

set -ev

docker stack deploy -c "$SERVICE_ORG2_COMPOSE_PATH" hlf_services
sleep 3

