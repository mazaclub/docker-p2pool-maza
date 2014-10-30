#! /usr/bin/env bash
set -e


# Config


# https://gist.github.com/dergachev/8441335
# If host is running squid-deb-proxy on port 8000, populate /etc/apt/apt.conf.d/30proxy
# By default, squid-deb-proxy 403s unknown sources, so apt shouldn't proxy ppa.launchpad.net
route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt
echo "HEAD /" | nc `cat /tmp/host_ip.txt` 8000 | grep squid-deb-proxy \
	&& (echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):8000\";" > /etc/apt/apt.conf.d/30proxy) \
	&& (echo "Acquire::http::Proxy::ppa.launchpad.net DIRECT;" >> /etc/apt/apt.conf.d/30proxy) \
	|| echo "No squid-deb-proxy detected on docker host"


# Ensure package list is up to date.
apt-get update
# Install runtime dependencies.
apt-get install -y git python-twisted

# Install build dependencies.
#apt-get install -y wget bsdmainutils autoconf makepasswd libqrencode-dev libcurl4-openssl-dev automake make libdb5.1++-dev ntp git build-essential libssl-dev libdb5.1-dev libboost-all-dev 
groupadd --gid 2211 maza
adduser --uid 2211 --disabled-password --gecos p2pool --gid 2211 p2pool

# Prepare building
# Get p2pool from https://github.com/ShastaFarEye/p2pool
cp -av /tmp/etc /
chmod +x /etc/service/p2pool-maza/run
cd /
git clone https://github.com/ShastaFarEye/p2pool p2pool-maza
cd p2pool-maza
cp -av /tmp/p2pool-maza/ /
chmod ug+x start_p2pool_maza.sh
chown -R p2pool.maza /p2pool-maza
touch /p2pool-maza/.firstrun


# Clean up
apt-get autoremove -y
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
