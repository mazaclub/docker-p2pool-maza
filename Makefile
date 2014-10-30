#put any repo name here

USER=mazaclub
PROJECT=testnet
build:
	docker build -t ${USER}/${PROJECT}-p2pool-maza .
	if [ -d p2poolweb ] ; then  docker build -t ${USER}/${PROJECT}-p2poolweb . ; fi
all:
	docker build -t ${USER}/${PROJECT}-p2pool-maza .
	if [ -d p2poolweb ] ; then  docker build -t ${USER}/${PROJECT}-p2poolweb . ; fi
	if [ ${PROJECT} = "testnet" ] ; then sh run-p2pool-maza.sh -testnet ; else sh run-p2pool-maza.sh ; fi
.PHONY: all
