#!/bin/bash

#set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

FLAG="-i"
ARCH=$(uname)
if [ "$ARCH" == "Linux" ]; then
  FLAG="-i"
elif [ "$ARCH" == "Darwin" ]; then
  FLAG="-it"
fi

# ORG1
ORG1_CA_PATH=$(ls ./crypto-config/peerOrganizations/org1.example.com/ca/ | grep "_sk")
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $LEADER_NODE_HOSTNAME/g" $ORDERER1_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $LEADER_NODE_HOSTNAME/g" $PEER_ORG1_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $LEADER_NODE_HOSTNAME/g" $SERVICE_ORG1_COMPOSE_PATH
sed "$FLAG" "s#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/.*#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/$ORG1_CA_PATH#g" $SERVICE_ORG1_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $ORDERER1_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $PEER_ORG1_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $SERVICE_ORG1_COMPOSE_PATH
sed "$FLAG" "s/fabric-orderer.*/fabric-orderer:$FABRIC_VERSION/g" $ORDERER1_COMPOSE_PATH
sed "$FLAG" "s/fabric-peer.*/fabric-peer:$FABRIC_VERSION/g" $PEER_ORG1_COMPOSE_PATH
sed "$FLAG" "s/\/fabric-ca:.*/\/fabric-ca:$FABRIC_CA_VERSION/g" $SERVICE_ORG1_COMPOSE_PATH
sed "$FLAG" "s/fabric-tools.*/fabric-tools:$FABRIC_VERSION/g" $SERVICE_ORG1_COMPOSE_PATH
sed "$FLAG" "s/fabric-couchdb.*/fabric-couchdb:$COUCHDB_IMAGE_VERSION/g" $SERVICE_ORG1_COMPOSE_PATH


# ORG2
ORG2_CA_PATH=$(ls ./crypto-config/peerOrganizations/org2.example.com/ca/ | grep "_sk")
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE1_HOSTNAME/g" $ORDERER2_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE1_HOSTNAME/g" $PEER_ORG2_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE1_HOSTNAME/g" $SERVICE_ORG2_COMPOSE_PATH
sed "$FLAG" "s#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/.*#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/$ORG2_CA_PATH#g" $SERVICE_ORG2_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $ORDERER2_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $PEER_ORG2_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $SERVICE_ORG2_COMPOSE_PATH
sed "$FLAG" "s/fabric-orderer.*/fabric-orderer:$FABRIC_VERSION/g" $ORDERER2_COMPOSE_PATH
sed "$FLAG" "s/fabric-peer.*/fabric-peer:$FABRIC_VERSION/g" $PEER_ORG2_COMPOSE_PATH
sed "$FLAG" "s/\/fabric-ca:.*/\/fabric-ca:$FABRIC_CA_VERSION/g" $SERVICE_ORG2_COMPOSE_PATH
sed "$FLAG" "s/fabric-tools.*/fabric-tools:$FABRIC_VERSION/g" $SERVICE_ORG2_COMPOSE_PATH
sed "$FLAG" "s/fabric-couchdb.*/fabric-couchdb:$COUCHDB_IMAGE_VERSION/g" $SERVICE_ORG2_COMPOSE_PATH

# ORG3
ORG3_CA_PATH=$(ls ./crypto-config/peerOrganizations/org3.example.com/ca/ | grep "_sk")
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE2_HOSTNAME/g" $ORDERER3_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE2_HOSTNAME/g" $PEER_ORG3_COMPOSE_PATH
sed "$FLAG" "s/- node.hostname == .*/- node.hostname == $WORKER_NODE2_HOSTNAME/g" $SERVICE_ORG3_COMPOSE_PATH
sed "$FLAG" "s#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/.*#- FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca-server-config/$ORG3_CA_PATH#g" $SERVICE_ORG3_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $ORDERER3_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $PEER_ORG3_COMPOSE_PATH
sed "$FLAG" "s/- engine.labels.aws.region == .*/- engine.labels.aws.region == $AWS_REGION/g" $SERVICE_ORG3_COMPOSE_PATH
sed "$FLAG" "s/fabric-orderer.*/fabric-orderer:$FABRIC_VERSION/g" $ORDERER3_COMPOSE_PATH
sed "$FLAG" "s/fabric-peer.*/fabric-peer:$FABRIC_VERSION/g" $PEER_ORG3_COMPOSE_PATH
sed "$FLAG" "s/\/fabric-ca:.*/\/fabric-ca:$FABRIC_CA_VERSION/g" $SERVICE_ORG3_COMPOSE_PATH
sed "$FLAG" "s/fabric-tools.*/fabric-tools:$FABRIC_VERSION/g" $SERVICE_ORG3_COMPOSE_PATH
sed "$FLAG" "s/fabric-couchdb.*/fabric-couchdb:$COUCHDB_IMAGE_VERSION/g" $SERVICE_ORG3_COMPOSE_PATH

if [ "$ARCH" == "Darwin" ]; then
  rm */**.ymlt
fi
