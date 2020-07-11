#!/bin/bash

#set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

# ORG1
rm -rf config
rm -rf crypto-config

# ORG2
ssh ubuntu@$WORKER_NODE1_HOSTNAME 'cd ~/HLF-PrivateData-Network-Chaincode-ClientApp/network; rm -rf config; rm -rf crypto-config'

# ORG3
ssh ubuntu@$WORKER_NODE2_HOSTNAME 'cd ~/HLF-PrivateData-Network-Chaincode-ClientApp/network; rm -rf config; rm -rf crypto-config'
