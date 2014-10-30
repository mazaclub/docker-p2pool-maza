#!/bin/bash
#### WORKPORT is set to 14477, p2pool peers connect on PEERPORT 14476
#### Map those on startup of the docker 
#### docker run -d -p XXXX:14476 -p YYYY:14477 -p ZZZZ:12835 mazaclub/p2pool-maza
#### Replace address below with your own, or mine to the Tribal Trust
#### Set your workers to connect to http://MZC_ADDRESS:X@docker_host:WORKPORT/
MAZADIR=/home/p2pool/.mazacoin
TESTNETDIR=${MAZADIR}/testnet3
RPCPASSWORD=`grep rpcpassword ${MAZADIR}/mazacoin.conf |awk -F\= '{print $2}'`
RPCUSER=`grep rpcuser ${MAZADIR}/mazacoin.conf |awk -F\= '{print $2}'`
NETWORK=mazacoin
P2P_PORT=12835
P2POOL_PORT=14476
WORKER_PORT=14477
RPCPORT=12832
PROJECT=`grep PROJECT /p2pool-maza/env |tr '[a-z]' '[A-Z]'|awk -F\= '{print $2}'`
#TESTNET=`grep testnet ${MAZADIR}/mazacoin.conf |awk -F\= '{print $2}'`

if [ "${PROJECT}" = "TESTNET" ] ; then
#   NETWORK=mazacoin-testnet
   RPCPORT=11832
   P2P_PORT=11835
   P2POOL_PORT=13376
   WORKER_PORT=13377
   OPTS="--testnet"
fi
MAZACOIND=`cat /p2pool-maza/env |grep ${PROJECT^^}_DAEMON | grep ${RPCPORT}| grep TCP_ADDR | awk -F\= '{print $2}'`
echo "`date` starting p2pool-maza with RPC from: ${MAZACOIND}:${RPCPORT}"
echo "`date` starting p2pool-maza with WORKER PORT: ${WORKER_PORT}"
echo "`date` starting p2pool-maza with P2POOL_PEER PORT:  ${P2POOL_PORT}"
echo "./run_p2pool.py --net ${NETWORK} ${OPTS} --bitcoind-address ${MAZACOIND} --bitcoind-rpc-port ${RPCPORT} --bitcoind-p2p-port ${P2P_PORT}  ${RPCUSER} ${RPCPASSWORD}  --give-author 0.5"

sleep 5
./run_p2pool.py --net ${NETWORK} ${OPTS} --bitcoind-address ${MAZACOIND} --bitcoind-rpc-port ${RPCPORT} --bitcoind-p2p-port ${P2P_PORT}  ${RPCUSER} ${RPCPASSWORD}  --give-author 0.5


### add the following to merge mine additional coins
# --merged http://user:password@host:rpcport/  

