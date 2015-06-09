# Purpose #

The purpose of this project is to simplify the installation of the development tools for the MSP430 LaunchPad platform on Mac OS X.

![http://3.bp.blogspot.com/_R7brKp_tgio/TNDI9i0CWZI/AAAAAAAAAOQ/3gHUC_9uIjk/s1600/Captura+de+pantalla+2010-11-03+a+las+03.28.33.png](http://3.bp.blogspot.com/_R7brKp_tgio/TNDI9i0CWZI/AAAAAAAAAOQ/3gHUC_9uIjk/s1600/Captura+de+pantalla+2010-11-03+a+las+03.28.33.png)

# What's included in the package #

  * gcc-4.5.3 GNU C/C++ Compiler
  * binutils-2.21.1 GNU binutils
  * gdb-7.2a GNU Debugger
  * msp430-libc-20110612 MSP430 standard C library
  * msp430mcu-20110613 MSP430 specs
  * mspdebug 0.17 and libusb

# How to install #

  * Get the latest toolchain from the [downloads area](http://code.google.com/p/osx-launchpad/downloads/list).
  * Get the VCP/CDC driver (also from the downloads area).
  * Unzip the two files (Safari on Lion will do that for you).
  * Double click on the mspgcc toolchain package to install.
  * Double click on the VCP/CDC driver package to install (and reboot when asked so).

# Upgrading from previous versions #

Just follow the above instructions.

The new toolchain (20111001) will coexist peacefully with the older one (20101006). A symbolic link named /usr/local/msp430-toolchain switches between versions and will point to the 20111001 toolchain after installation.

The older ez430rf2500 driver needs to be removed for the new VCP/CDC driver to work properly. The 20111001 toolchain package will take care of that automatically.

# Changes in the new GCC 4.5.3 compiler #

There are some changes in the interrupt declaration syntax as well as the headers that need to be included. For a brief summary, please check this review on the subject:

http://justinstech.org/2011/07/msp430-different-interrupts-for-different-compilers/

# Supported platforms #

I have tested this package on Snow Leopard (10.6.8) and Lion (10.7.2) on 64-bit CPUs.

32-bit users: Sorry, this package is 64-bits only. Please see the "Hacking / Building your own package" below if you are interested in building this on a 32-bit system. It will probably involve compiling the toolchain with the -m32 option, but the homebrew libraries need to be compiled as 32-bits, too.

# Testing the toolchain #

  * Download the breathing led demo from the downloads area. Unzip it (Safari/Lion will do that for you).
  * Connect the LaunchPad
  * Open the terminal and do:

```
Mac-de-javi:~ javi$ cd Downloads/
Mac-de-javi:Downloads javi$ cd demo-breathing-led-gcc-4.5.3
Mac-de-javi:demo-breathing-led-gcc-4.5.3 javi$ ./build-msp430g2231.sh 
```

  * Enter your password (mspdebug requires root privileges).
  * See the LED breath!

A script named `build-msp430g2452.sh` will compile and upload the code for the MSP430G2452, if your LaunchPad has that chip instead.

# Hacking / building your own package #

My day job prevents me from upgrading this package as regularly as I would like to.

If you want to build your own package with a newer version of the toolchain, instructions are provided in the [source area](http://code.google.com/p/osx-launchpad/source/checkout). You need Xcode, homebrew and a few libraries installed beforehand (read the README file). After that, a script named "build.sh" takes care of downloading all the necessary files and compiling gcc, binutils, gdb and mspdebug. A PackageMaker project is also included to generate the final .pkg.

Feel free to clone the Mercurial repository and fork your own changes. Contributions are welcome and will be integrated in the original repository.

# Stay up to date #

Latest news on the project's blog:

http://osx-launchpad.blogspot.com/