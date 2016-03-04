#!/bin/bash
#######################################################################
#
#  Project......: build_xpwn.sh
#  Creator......: matteyeux
#  Description..: Script to install XPwn tools
#
######################################################################
# Language :
#               bash
# Version : 0.3

if [[ "$(whoami)" != "root" ]]; then
    echo "Please run this script as root"
    exit 1
fi

if [[ $(uname) != 'Linux' ]]; then
  echo "This script is only for Linux"
  exit 1
fi

apt-get -y install binutils
apt-get -y install p7zip-full
apt-get -y install git
apt-get -y install build-essential
apt-get -y install make
apt-get -y install cmake
apt-get -y install openssl
apt-get -y install libcrypto++-dev:q
apt-get -y install bsdiff
apt-get -y install libbz2-dev
apt-get -y install libpng3
apt-get -y install libusb-1.0.0
apt-get -y install libusb-1.0.0-dev
apt-get -y install libssl-dev
apt-get -y install libcurl3
apt-get -y install python-pip
cd ~
git clone https://github.com/xerub/xpwn.git
mkdir ~/build
cd ~/build 
cmake ~/xpwn
make
make package
tar xvjf XPwn-0.5.8-Linux.tar.bz2

cd XPwn-0.5.8-Linux
cp dmg hdutil hfsplus ipsw ticket xpwntool validate /usr/local/bin/

echo "XPwn binaries installed to /usr/local/bin/"