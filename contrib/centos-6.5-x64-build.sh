#!/bin/sh
#
# CandyCoin build helper script for CentOS 6.5 x64
# The goal of this script is to setup a complete build environment for candycoind
#
# (C) 2014 The CandyCoin Developers
#

temp=/tmp
openssl=openssl-1.0.1g
source=/tmp/candycoin/src

grep -q '6.5' /etc/centos-release
REV=$?
uname -m | grep -q x86_64
MACH=$?

if [ \( $REV -eq 1 \) -o \( $MACH -eq 1 \) ]; then
echo "This script is for Centos 6.5 x64 only, it won't work properly on other systems"
else

echo "Setting up build environemnt..."
#assume that if there is no symbolic link to libboost_thread-mt.so that this step has not yet been completed
if [ ! -L /usr/lib64/libboost_thread-mt.so ]; then
yum groupinstall "Development Tools" -y
yum install kernel-devel zlib-devel db4-devel boost-devel boost boost-thread boost-system boost-filesystem boost-program-options leveldb-devel -y
cd /usr/lib64 && ln -s libboost_thread-mt.so libboost_thread.so
else
echo "Skipped"
fi

echo "Installing $openssl..."
#skip this step if openssl exists
if [ ! -d $temp/$openssl ]; then
yum remove openssl-devel -y
cd $temp
wget http://www.openssl.org/source/$openssl.tar.gz
tar zxvf $openssl.tar.gz && cd $temp/$openssl
./config
make
else
echo "Skipped"
fi

echo "Clone CandyCoin source from GitHub..."
if [ ! -d $temp/candycoin ]; then
cd $temp
git clone -b master https://github.com/eatsweetmoney/candycoin-official.git candycoin
else
echo "Skipped"
fi

grep -q "DSSL =" $source/makefile.unix
if [ $? -eq 0 ]; then
#already patched? update openssl path in case it's different.
echo "Updating openssl directives in $source/makefile.unix..."
sed -i "s|DSSL =.*|DSSL = $temp\/$openssl\/$openssl|" $source/makefile.unix
else
echo "Patching $source/makefile.unix..."
sed -i "4aDSSL = $temp\/$openssl\/$openssl\nISSL = \$(DSSL)/include\nOPENSSL_LIB_PATH = \$(DSSL)\nOPENSSL_INCLUDE_PATH = \$(ISSL)\n" $source/makefile.unix
fi

echo "Complete. To compile candycoind:\ncd $source && make -f makefile.unix USE_UPNP=-"
fi

