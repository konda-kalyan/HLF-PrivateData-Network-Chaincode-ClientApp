#!/bin/bash


./STEP2_pull_fabric_images_binaries_on_all_machines.sh

echo "**************************	STEP-2 IS COMPLETED 	*************************************"

./STEP3_generate_artifacts_and_copy_to_worker_nodes.sh

echo "**************************	STEP-3 IS COMPLETED 	*************************************"

./STEP4_init_docker_swarm_and_bringup_fabric_network.sh

echo "**************************	STEP-4 IS COMPLETED 	*************************************"

./STEP5_create_channel_then_do_chaincode_operations.sh

#echo "**************************	STEP-5 IS COMPLETED 	*************************************"
