docker-p2pool-maza
==================

p2pool-maza setup and ready to run with the latest version of mazacoind from mazaclub/mazacoind-new

## Quick Start
grab the run-p2pool-maza.sh script from the github source (if you're viewing this on docker hub!) 
or clone the whole project

Edit "PROJECT" variable in run-p2pool-maza.sh

Then, simply run that script:
<code> sh ./run-p2pool-maza.sh</code>

This will check your system for current mazacoin-new docker containers,
and if not found, will pull from our automated builds. 
It will then check for this p2pool-mazacoin image, and tag it with your PROJECT name

If you'd like to run in testnet mode, 
<code> sh ./run-p2pool-maza.sh -testnet</code>
This will override the current PROJECT name.

The run script will then start mazacoind, with associated data-containers 
for blockchain data and wallet data storage, and it will start p2pool-mazacoin

It will set --name=$PROJECT_service for each of the containers started. 

By renaming the PROJECT, you can start multiple instances of the multicontainer set. 

## This is intended to be used with our docker-mazacoin-new image. 
https://github.com/mazaclub/docker-mazacoin-new

If you'd like a standalone version, see https://github.com/mazaclub/docker-p2pool-maza-standalone
The standalone version is a single container with integrated mazacoind.
The standalone container size will grow very large with data from
mazacoind and p2pool-maza. 


Cloned from https://github.com/ShastaFarEye/p2pool, this is ready to run. 
startup script will discover rpcuser & rpcpassword for mazacoind, and wait 
a couple minutes for mazacoind to become ready.

p2pool will start automatically when this image is run.

Edit the included Makefile to define a PROJECT name 
Each PROJECT name will start a set of dockers 
 - mazacoind and associated data-containers
 - p2pool and it's associated data-container

The p2pool-maza container will be set to have access to 
the mazacoind RPCport and /home/maza/.mazacoin in the same 
PROJECT group

If the PROJECT is defined as "testnet" all the dockers will 
startup in testnet mode. 

The included Makefile will look for a "p2poolweb" directory. 
If this directory is found, with a Dockerfile, it will build 
a data-container for your p2pool data (graphs & logs) and web-static 
directory, allowing you to easily add custom web frontends to p2pool

The included run script will start all of the necessary containers for your
PROJECT group. Run it with "-testnet" option to startup in testnet mode

The included Makefile will attempt to start your docker set once it's built
If the PROJECT in the Makefile is set to "testnet" it will execute the run
script with the -testnet option for you. 

This will additionally build new images for you if you change the USER variable
and run <code> make all && sh run-p2pool-maza.sh</code> 
(but this isn't really well tested yet. Once the make file builds a p2pool image
it should start run-p2pool-maza.sh, which should check to see if you have mazacoin-new
and data-containers with the correct USER in the tags. If not, it will clone
the latest from https://github.com/mazaclub/docker-mazacoin-new and build the 
full set of containers from scratch. Then the full set will be started. 


This docker is not intended to be started without the included run script.

Why not use fig? 
 - we prefer to start our dockers with "--restart=always" in the run commands
 - fig doesn't allow for setting such options
 - the run script easily allows you to setup for testnet

Expect the docker logs to have errors until the p2pool sharechain fully syncs with mazaclub bootstrap nodes.



