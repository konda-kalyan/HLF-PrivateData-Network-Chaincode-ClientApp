# sudo mkdir -p /var/mynetwork
# sudo chown -R $(whoami) /var/mynetwork
# sudo chown -R $USER:$USER /var/mynetwork
sudo rm -rf mkdir /var/mynetwork/*

sudo mkdir -p /var/mynetwork/chaincode
sudo mkdir -p /var/mynetwork/certs
sudo mkdir -p /var/mynetwork/bin
#mkdir -p /var/mynetwork/fabric-src

#git clone https://github.com/hyperledger/fabric /var/mynetwork/fabric-src/hyperledger/fabric
#cd /var/mynetwork/fabric-src/hyperledger/fabric
#git checkout release-1.4
#cd -
sudo cp -R crypto-config /var/mynetwork/certs/
sudo cp -R config /var/mynetwork/certs/
sudo cp -R ../chaincodes/* /var/mynetwork/chaincode/
sudo cp -R bin/* /var/mynetwork/bin/
