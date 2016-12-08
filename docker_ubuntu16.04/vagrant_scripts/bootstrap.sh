#!/bin/bash
VHOST_IP=$1
COUNTRY=$2
# echo arguments
echo ">>>-----------------------------<<<"
echo "       vhost ip: ${VHOST_IP}"
echo "        country: ${COUNTRY}"
echo ">>>-----------------------------<<<"

# Setting hosts
echo "
${VHOST_IP} vhost
" >> /etc/hosts

# proxy settings
if [ $COUNTRY == 'china' ]
then
  # enviroment
  echo '
export http_proxy="http://vhost:3128/"
export https_proxy="http://vhost:3128/"
' >> /home/vagrant/.profile
  # apt
  echo '
Acquire::ftp::proxy "ftp://vhost:3128/";
Acquire::http::proxy "http://vhost:3128/";
Acquire::https::proxy "https://vhost:3128/";
Acquire::ftp::proxy::mirrors.aliyun.com "DIRECT";
Acquire::http::proxy::mirrors.aliyun.com "DIRECT";
Acquire::https::proxy::mirrors.aliyun.com "DIRECT";
' > /etc/apt/apt.conf
  # proxy env
  export http_proxy="http://vhost:3128/"
  export https_proxy="http://vhost:3128/"
fi
# install require libs
echo ">>>-----------------------------<<<"
echo "   Install Additional Packages"
echo ">>>-----------------------------<<<"
apt-get update
apt-get -y install apt-transport-https ca-certificates
# add gpg key
apt-key adv \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# add docker repo
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" \
  | tee /etc/apt/sources.list.d/docker.list
apt-get update
# install Extra kernel packages
apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

# install docker
echo ">>>-----------------------------<<<"
echo "   Install Docker Packages"
echo ">>>-----------------------------<<<"
apt-get -y install docker-engine
service docker start
apt-get -y autoremove
gpasswd -a ubuntu docker

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
