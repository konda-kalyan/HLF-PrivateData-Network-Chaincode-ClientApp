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

#copy artifacts to Worker nodes
scp -r config crypto-config ubuntu@$WORKER_NODE1_HOSTNAME:~/HLF-PrivateData-Network-Chaincode-ClientApp/network
scp -r config crypto-config ubuntu@$WORKER_NODE2_HOSTNAME:~/HLF-PrivateData-Network-Chaincode-ClientApp/network

#On Workder nodes, copy artifacts to command dir (/var/mynetwork/)
ssh ubuntu@$WORKER_NODE1_HOSTNAME 'cd ~/HLF-PrivateData-Network-Chaincode-ClientApp/network; ./copy_crypto.sh'
ssh ubuntu@$WORKER_NODE2_HOSTNAME 'cd ~/HLF-PrivateData-Network-Chaincode-ClientApp/network; ./copy_crypto.sh'
