#!/bin/bash
GLOBAL_ENV_LOCATION=$PWD/scripts/.env
source $GLOBAL_ENV_LOCATION

set -ev

# ============================
# INSTALLING CHAINCODE IN ORG1
# ============================
docker exec "$CLI_NAME" peer chaincode install -l java -n "$JAVA_CC_NAME" -p "$JAVA_CC_SRC" -v v0

# ============================
# INSTALLING CHAINCODE IN ORG2
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/ch.example.com/peers/peer0.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" "$CLI_NAME" peer chaincode install -l java -n "$JAVA_CC_NAME" -p "$JAVA_CC_SRC" -v v0

# ============================
# INSTALLING CHAINCODE IN ORG3
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/ch.example.com/peers/peer0.org3.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org3.example.com:7051" "$CLI_NAME" peer chaincode install -l java -n "$JAVA_CC_NAME" -p "$JAVA_CC_SRC" -v v0

# ===========================
# INSTANTIATING THE CHAINCODE
# ===========================
# during initiation, we are creating two accounts with names 'a' and 'b' with amounts 100 and 200 respectively
docker exec "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -l java -n "$JAVA_CC_NAME" "$JAVA_CC_SRC" -v v0  -c '{"Args":["init", "a", "100", "b", "200"]}' -P "OR('Org1MSP.member', 'Org2MSP.member', 'Org3MSP.member' )" --tls --cafile $ORDERER_CA

sleep 3

# ================================
# LISTING THE CHAINCODES INSTALLED
# ================================
docker exec "$CLI_NAME" peer chaincode list --instantiated -C "$CHANNEL_NAME" --tls --cafile $ORDERER_CA

sleep 10

# ================================
# INVOKING CHAINCODE
# ================================
# transferring amount of 10 from a to b
docker exec "$CLI_NAME" peer chaincode invoke -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $JAVA_CC_NAME -c '{"Args":["invoke","a", "b", "10"]}'
#docker exec "$CLI_NAME" peer chaincode invoke -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $JAVA_CC_NAME -c '{"Args":["open","123", "1000"]}'

sleep 10

# ================================
# QUERING CHAINCODE
# ================================
# 'query/retrive' an account with account name as 'a' who should have money 90
docker exec "$CLI_NAME" peer chaincode query -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $JAVA_CC_NAME -c '{"Args":["query", "a"]}'
