#!/bin/bash -eu
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# This script get all fabric binaries from github repo

#set -ev

ENV_LOCATION=$PWD/.env
echo $ENV_LOCATION
source $ENV_LOCATION

rm -rf $PWD/bin/*	# remove old binaries

BINARY_FILE=hyperledger-fabric-linux-${FABRIC_VERSION}.tar.gz
echo "Binary file: $BINARY_FILE"
CA_BINARY_FILE=hyperledger-fabric-ca-linux-${FABRIC_CA_VERSION}.tar.gz
echo "CA Binary file: $CA_BINARY_FILE"
echo "https://github.com/hyperledger/fabric/releases/download/v${FABRIC_JUST_VERSION}/${BINARY_FILE}"

pullBinaries() {
	echo "===> Downloading version ${FABRIC_VERSION} platform specific fabric binaries"
	download "${BINARY_FILE}" "https://github.com/hyperledger/fabric/releases/download/v${FABRIC_JUST_VERSION}/${BINARY_FILE}"
	if [ $? -eq 22 ]; then
		echo
		echo "------> ${FABRIC_VERSION} platform specific fabric binary is not available to download <----"
		echo
		exit
	fi

	echo "===> Downloading version ${FABRIC_CA_VERSION} platform specific fabric-ca-client binary"
	download "${CA_BINARY_FILE}" "https://github.com/hyperledger/fabric-ca/releases/download/v${FABRIC_JUST_VERSION}/${CA_BINARY_FILE}"
	if [ $? -eq 22 ]; then
		echo
		echo "------> ${FABRIC_CA_VERSION} fabric-ca-client binary is not available to download  (Available from 1.4.4-rc1) <----"
		echo
		exit
	fi
}

# This will download the .tar.gz
download() {
    local BINARY_FILE=$1
    local URL=$2
    echo "===> Downloading: " "${URL}"
    #curl -L --retry 5 --retry-delay 3 "${URL}" 
    curl -L --retry 5 --retry-delay 3 "${URL}" | tar xz
    #curl -L --retry 5 --retry-delay 3 "${URL}" | tar xz || rc=$?

    #if [ -n "$?" ]; then
        #echo "==> There was an error downloading the binary file."
        #return 22
    #else
        #echo "==> Done."
    #fi
}

pullBinaries

