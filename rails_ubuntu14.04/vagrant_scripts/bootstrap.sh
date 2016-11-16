#!/bin/bash
VHOST_IP=$1
RUBY_VERSION=$2
COUNTRY=$3
# echo arguments
echo ">>>-----------------------------<<<"
echo "       vhost ip: ${VHOST_IP}"
echo "   ruby version: ${RUBY_VERSION}"
echo "        country: ${COUNTRY}"
echo ">>>-----------------------------<<<"

# Setting hosts
echo "
${VHOST_IP} vhost
" >> /etc/hosts

# Setup rbenv for vagrant
echo '
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
' >> /home/vagrant/.profile

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
apt-get -y install git build-essential libssl-dev \
  libreadline-dev \
  mysql-client \
  imagemagick \
  libncurses5-dev \
  libncursesw5-dev  \
  libmysqlclient-dev \
  imagemagick \
  libmagickwand-dev
apt-get -y autoremove

# checkout rbenv
echo ">>>-----------------------------<<<"
echo "   Setup rbenv"
echo ">>>-----------------------------<<<"
su - vagrant << EOF
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
EOF

# install ruby
su - vagrant << EOF
rbenv install ${RUBY_VERSION}
rbenv rehash
rbenv global ${RUBY_VERSION}
ruby --version
rbenv exec gem install bundler
rbenv rehash
EOF
