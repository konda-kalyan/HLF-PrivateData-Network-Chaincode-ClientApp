./bring_down_whole_network_on_all_machines.sh
sudo rm -rf /var/mynetwork/chaincode/*; sudo cp -R ../chaincode/* /var/mynetwork/chaincode/
./STEP4_init_docker_swarm_and_bringup_fabric_network.sh
./STEP5_create_channel_then_do_chaincode_operations.sh
