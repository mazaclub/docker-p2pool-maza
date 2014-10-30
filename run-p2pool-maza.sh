USER=mazaclub
PROJECT=mazabase
P2POOL=${USER}/${PROJECT}-p2pool-maza
P2POOLWEB=${USER}/${PROJECT}-p2poolweb
DAEMON=${USER}/mazacoin-new
BLOCKS=${USER}/mazablocks:empty
WALLET=${USER}/mazawallets
P2P_OUTSIDE=12835
P2P_INSIDE=12835
MZCRPC=12832
WORKER_INSIDE=14477
WORKER_OUTSIDE=14477
P2POOL_INSIDE=14476
P2POOL_INSIDE=14476
NGINX_OUTSIDE=34555
NGINX_INSIDE=80
docker images |awk '{print $1":"$2}' |grep ${BLOCKS} || docker pull ${BLOCKS} 
docker images |awk '{print $1":"$2}' |grep ${DAEMON} || docker pull ${DAEMON}
docker images |awk '{print $1":"$2}' |grep ${WALLET} || docker pull ${WALLET}

if [ "${1}" = "-testnet" ] ; then
  PROJECT=testnet
  P2P_OUTSIDE=11835
  P2P_INSIDE=11835
  MZCRPC=11832
  WORKER_INSIDE=13377
  WORKER_OUTSIDE=13377
  P2POOL_INSIDE=13376
  P2POOL_OUTSIDE=13376
  BLOCKS="${USER}/${PROJECT}-mazablocks:empty"
  docker tag ${USER}/mazablocks:empty ${BLOCKS}
  P2POOL=${USER}/${PROJECT}-p2pool-maza
  P2POOLWEB=${USER}/${PROJECT}-p2poolweb
fi


avail=`docker images |awk '{print $1":"$2}' |grep ${DAEMON}`
if [ "${avail}X" = "X" ] ; then
   git clone https://github.com/mazaclub/docker-mazacoin-new
   cd docker mazacoin-new
   sed -i 's/PROJECT\=.*/PROJECT\='${PROJECT}'/g' run-mazacoin-prebuilt.sh
   make all
fi

echo "`date` Starting ${PROJECT}_mazablocks"
mb=`docker ps -a|awk '{print $NF}'  |grep ${PROJECT}_mazablocks`
if [ "${mb}" != "${PROJECT}_mazablocks" ] ; then   
   echo "`date` mazablocks not running. Starting..." && docker run -d -v /home/maza --name="${PROJECT}_mazablocks" ${BLOCKS}
fi
echo "`date` Starting ${PROJECT}_mazawallets"
mb=`docker ps -a|awk '{print $NF}' |grep ${PROJECT}_mazawallets`
if [ "${mb}" != "${PROJECT}_mazawallets" ] ; then   
   echo "`date` mazawallets not running. Starting..." && docker run -d -v /home/wallets --name="${PROJECT}_mazawallets" ${WALLET}
fi
echo "`date` Starting ${PROJECT}_daemon"
mb=`docker ps -a|awk '{print $NF}' |grep ${PROJECT}_daemon|awk -F\, '{print $1}'`  
if [ "${mb}" != "${PROJECT}_daemon" ] ; then   
   echo "`date` ${PROJECT}_daemon  not running. Starting..." && docker run -d -p ${P2P_OUTSIDE}:${P2P_INSIDE}  --name=${PROJECT}_daemon --volumes-from=${PROJECT}_mazablocks --volumes-from=${PROJECT}_mazawallets ${DAEMON}
fi
if [ -d p2poolweb ] ; then 
   echo "`date` Starting ${PROJECT}_p2poolweb"
   mb=`docker ps -a|awk '{print $NF}' |grep ${PROJECT}_p2poolweb`  
   if [ "${mb}" != "${PROJECT}_p2poolweb" ] ; then   
      echo "`date` p2poolweb not running. Starting..." && docker run -d --name=${PROJECT}_p2poolweb -v /home/p2pool  ${P2OOLWEB}
   fi
docker run -d -e "PROJECT=${PROJECT}" --name=${PROJECT}_p2poolmaza -p ${NGINX_OUTSIDE}:${NGINX_INSIDE}  -p ${P2POOL_OUTSIDE}:${P2POOL_INSIDE} -p ${WORKER_OUTSIDE}:${WORKER_INSIDE} --volumes-from=${PROJECT}_p2poolweb --link ${PROJECT}_daemon:${PROJECT}_daemon ${P2POOL}
fi
#
docker run -d -e "PROJECT=${PROJECT}" --name=${PROJECT}_p2poolmaza -p ${NGINX_OUTSIDE}:${NGINX_INSIDE}  -p ${P2POOL_OUTSIDE}:${P2POOL_INSIDE} -p ${WORKER_OUTSIDE}:${WORKER_INSIDE} --volumes-from=${PROJECT}_daemon --link ${PROJECT}_daemon:${PROJECT}_daemon ${P2POOL}
