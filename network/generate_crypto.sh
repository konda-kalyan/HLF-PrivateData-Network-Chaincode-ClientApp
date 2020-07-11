#!/bin/bash
#
# set -ev

source ${PWD}/.env
export PATH=$PATH:${PWD}/bin
export FABRIC_CFG_PATH=${PWD}

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*
mkdir -p crypto-config config


# generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# generate genesis block for orderer
echo "SYS_CHANNEL_NAME: $SYS_CHANNEL_NAME"
configtxgen -configPath . -profile SampleMultiNodeEtcdRaft -channelID $SYS_CHANNEL_NAME -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi


# generate channel configuration transaction for My Channel
configtxgen -profile ${CHANNEL_PROFILE} -outputCreateChannelTx ./config/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer for My Channel transaction as ORG1 Org
configtxgen -profile ${CHANNEL_PROFILE} -outputAnchorPeersUpdate ./config/ORG1${ANCHOR_TX} -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

# generate anchor peer for My Channel transaction as ORG2 Org
configtxgen -profile ${CHANNEL_PROFILE} -outputAnchorPeersUpdate ./config/ORG2${ANCHOR_TX} -channelID $CHANNEL_NAME -asOrg Org2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org2MSP..."
  exit 1
fi

# generate anchor peer for My Channel transaction as ORG3 Org
configtxgen -profile ${CHANNEL_PROFILE} -outputAnchorPeersUpdate ./config/ORG3${ANCHOR_TX} -channelID $CHANNEL_NAME -asOrg Org3MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org3MSP..."
  exit 1
fi
