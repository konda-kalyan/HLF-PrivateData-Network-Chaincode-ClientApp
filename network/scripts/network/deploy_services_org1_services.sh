#!/bin/bash

GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION
set -ev 

# ORG 1

docker stack deploy -c "$SERVICE_ORG1_COMPOSE_PATH" hlf_services
sleep 3
