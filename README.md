Network topology and different components:
•	Fabric network with 3 organizations installed in 3 physical machines (or 3  VMs).
•	Kafka based ordering service with 3 Orderers (one per each organization).
•	One Fabric CA per organization
•	Couchdb as world state in each and every peer.
•	One Channel called ‘mychannel’
•	One Chaincode named ‘simple’ installed in the channel. Simple Chaincode written in ‘go’ language

Used ‘Docker Swarm’ as container orchestration tool.

Follow 'HLF_Multi_Node_Network_Setup_Using_Docker_Swarm.docx' document to setup HLF network.

IMPORTANT NOTE: This example sets up network on AWS environment. If you are using non-AWS envi then you need to remove AWS references in .env file and docker compose files, and then configure cloud/local settings accordingly


Queries - Contact at 'konda.kalyan@gmail.com'
