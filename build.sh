#!/bin/sh

set -e

# Force root
if [ $EUID -ne 0 ]; then
  echo "You must be root"
  exit 1
fi

TOOLCHAIN_VERSION=20110716
PREFIX=/usr/local/msp430-uniarch-$TOOLCHAIN_VERSION
PACKAGE_ROOT=package/PackageRoot

# Add new gcc to path
export PATH=$PREFIX/bin:$PATH

: <<ENDREM
Use these to wrap around code you want to comment out, in case some
step failed and you want to resume execution at some point.
ENDREM

# Download mspgcc4 patches
wget http://downloads.sourceforge.net/project/mspgcc/mspgcc/mspgcc-$TOOLCHAIN_VERSION.tar.bz2
tar xjf mspgcc-$TOOLCHAIN_VERSION.tar.bz2

# Install binutils
wget ftp://ftp.gnu.org/pub/gnu/binutils/binutils-2.21.1.tar.bz2
tar xjf binutils-2.21.1.tar.bz2
cd binutils-2.21.1
patch -p1 < ../mspgcc-$TOOLCHAIN_VERSION/msp430-binutils-2.21.1-20110716.patch 
cd ..
mkdir -p BUILD/binutils
cd BUILD/binutils
../../binutils-2.21.1/configure \
  --target=msp430 \
  --prefix=$PREFIX
make
make install
cd ../..


# Install gcc
wget ftp://ftp.gnu.org/pub/gnu/gcc/gcc-4.5.3/gcc-4.5.3.tar.bz2
tar xjf gcc-4.5.3.tar.bz2
cd gcc-4.5.3 
patch -p1 < ../mspgcc-$TOOLCHAIN_VERSION/msp430-gcc-4.5.3-20110706.patch
cd ..
mkdir -p BUILD/gcc
cd BUILD/gcc
../../gcc-4.5.3/configure \
  --target=msp430 \
  --enable-languages=c,c++ \
  --prefix=$PREFIX
make
make install
cd ../..

# Install gdb
wget ftp://ftp.gnu.org/pub/gnu/gdb/gdb-7.2a.tar.gz
tar xzf gdb-7.2a.tar.gz
cd gdb-7.2 
patch -p1 < ../mspgcc-$TOOLCHAIN_VERSION/msp430-gdb-7.2-20110103.patch
cd ..
mkdir -p BUILD/gdb
cd BUILD/gdb
../../gdb-7.2/configure \
  --target=msp430 \
  --prefix=$PREFIX
make
make install
cd ../..

# Install mcu
MCU_VERSION=`cat mspgcc-$TOOLCHAIN_VERSION/msp430mcu.version`
wget http://sourceforge.net/projects/mspgcc/files/msp430mcu/msp430mcu-$MCU_VERSION.tar.bz2
tar xjf msp430mcu-$MCU_VERSION.tar.bz2
cd msp430mcu-$MCU_VERSION
export MSP430MCU_ROOT=`pwd`
sh scripts/install.sh $PREFIX
cd ..

# Install libc
LIBC_VERSION=`cat mspgcc-$TOOLCHAIN_VERSION/msp430-libc.version`
wget http://sourceforge.net/projects/mspgcc/files/msp430-libc/msp430-libc-$LIBC_VERSION.tar.bz2
tar xjf msp430-libc-$LIBC_VERSION.tar.bz2
cd msp430-libc-$LIBC_VERSION/src
rm -rf Build
make PREFIX=$PREFIX
make PREFIX=$PREFIX install
cd ../..

# Install mspdebug
wget http://downloads.sourceforge.net/project/mspdebug/mspdebug-0.17.tar.gz
tar xvf mspdebug-0.17.tar.gz
cd mspdebug-0.17
patch -p1 < ../mspdebug-0.17.patch
make
make install

## Create package

# Toolchain
rm -rf $PACKAGE_ROOT
mkdir $PACKAGE_ROOT
mkdir -p $PACKAGE_ROOT/$PREFIX
cp -a $PREFIX/ $PACKAGE_ROOT/$PREFIX

# Mspdebug
mkdir -p $PACKAGE_ROOT/usr/local/bin
mkdir -p $PACKAGE_ROOT/usr/local/share/man/man1
cp -p /usr/local/bin/mspdebug $PACKAGE_ROOT/usr/local/bin
cp -p /usr/local/share/man/man1/mspdebug.1 $PACKAGE_ROOT/usr/local/share/man/man1

# Libs
mkdir -p $PACKAGE_ROOT/usr/local/lib
for i in charset.alias libelf* libgmp* libiconv* libmpc* libmpfr* libnet* libusb*
do
  cp -p /usr/local/lib/$i $PACKAGE_ROOT/usr/local/lib
done

# Paths
mkdir -p $PACKAGE_ROOT/private/etc/paths.d
mkdir -p $PACKAGE_ROOT/private/etc/manpaths.d
echo "/usr/local/msp430-toolchain/bin" >$PACKAGE_ROOT/private/etc/paths.d/msp430-toolchain
echo "/usr/local/msp430-toolchain/share/man" >$PACKAGE_ROOT/private/etc/manpaths.d/msp430-toolchain

# Symlink
ln -s $PREFIX $PACKAGE_ROOT/usr/local/msp430-toolchain

# Perms
chown -R root:wheel $PACKAGE_ROOT

