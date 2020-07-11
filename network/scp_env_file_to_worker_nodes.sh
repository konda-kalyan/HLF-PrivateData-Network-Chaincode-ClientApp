#!/bin/bash -eu
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# This script pulls docker images from the Dockerhub hyperledger repositories

#set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

scp -r .env ubuntu@$WORKER_NODE1_HOSTNAME:~/HLF-PrivateData-Network-Chaincode-ClientApp/network
scp -r .env ubuntu@$WORKER_NODE2_HOSTNAME:~/HLF-PrivateData-Network-Chaincode-ClientApp/network
