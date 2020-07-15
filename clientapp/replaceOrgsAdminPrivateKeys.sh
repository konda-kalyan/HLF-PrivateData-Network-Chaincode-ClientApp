#!/bin/bash

sed -i "s#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/.*#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/$(ls /home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/ | grep "_sk")#g" network-config-tls.yaml

sed -i "s#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/.*#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/$(ls /home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/ | grep "_sk")#g" network-config-tls.yaml

sed -i "s#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/.*#/home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/$(ls /home/ubuntu/HLF-PrivateData-Network-Chaincode-ClientApp/network/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp/keystore/ | grep "_sk")#g" network-config-tls.yaml

# noticed that ^M chars are getting appended and hence below commands to get rid of them
sed -e "s/\r//g" network-config-tls.yaml > network-config-tls.yaml.modified
cp network-config-tls.yaml.modified network-config-tls.yaml
