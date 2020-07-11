#!/bin/bash -eu
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# This script pulls docker images from the Dockerhub hyperledger repositories

set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

DOCKER_NS=hyperledger

# set of Hyperledger Fabric images
FABRIC_CORE_IMAGES=(fabric-peer fabric-orderer fabric-ca fabric-tools fabric-ccenv fabric-javaenv)
FABRIC_OTHER_IMAGES=(fabric-couchdb fabric-baseos)

for image in ${FABRIC_CORE_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${FABRIC_VERSION}"
  docker pull ${DOCKER_NS}/$image:${FABRIC_VERSION}
done

for image in ${FABRIC_OTHER_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${COUCHDB_IMAGE_VERSION}"
  docker pull ${DOCKER_NS}/$image:${COUCHDB_IMAGE_VERSION}
done
