#!/bin/bash
# setup for bundle
echo ">>>-----------------------------<<<"
echo "   Setup bundle directory"
echo ">>>-----------------------------<<<"
su - vagrant << EOF
mkdir -p ~/vendor_bundle
mkdir -p ~/rails_app/vendor/bundle
EOF
# bind to real local directory
mount -o bind /home/vagrant/vendor_bundle /home/vagrant/rails_app/vendor/bundle
