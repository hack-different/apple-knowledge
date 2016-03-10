#!/bin/bash
#######################################################################
#
#  Project......: libinstaller.sh
#  Creator......: matteyeux
#  Description..: Script to install libimobiledevice on OS X & Debian Distros
#  initials scripts: brew.sh & autobuild.sh by DarkMalloc
#  Type.........: Public
#
######################################################################
# Language :
#               bash
# Version : 0.2
#
#  Change Log
#  ==========
#
#   ===============================================================
#    Date     |       Who          |      What
#   ---------------------------------------------------------------
#    27/12/15 | Mathieu Hautebas   | Script creation
#   ---------------------------------------------------------------
#  	 10/03/16 | HanSheng Zhang	   | Fix Stack overflow caused by naming issues
#	---------------------------------------------------------------

function apt-get(){
	sudo apt-get install -y git
	sudo apt-get install -y build-essential
	sudo apt-get install -y make
	sudo apt-get install -y autoconf
	sudo apt-get install -y automake
	sudo apt-get install -y libtool
	sudo apt-get install -y openssl
	sudo apt-get install -y tar
	sudo apt-get install -y perl
	sudo apt-get install -y binutils
	sudo apt-get install -y gcc
	sudo apt-get install -y libstdc++6-dev
	sudo apt-get install -y libc6-dev
	sudo apt-get install -y libssl-dev
	sudo apt-get install -y libusb-1.0
	sudo apt-get install -y gcc4.2
	sudo apt-get install -y g++
	sudo apt-get install -y libcurl4-gnutls-dev
	sudo apt-get install -y fuse
	sudo apt-get install -y libxml2-dev

	sudo apt-get install -y libgfortran1
	sudo apt-get install -y libgfortran2
	sudo apt-get install -y libgfortran
	sudo apt-get install -y libgcc1
	sudo apt-get install -y libreadline-dev 
	sudo apt-get install -y libglib2.0-dev
	sudo apt-get install -y libzip-dev
	sudo apt-get install -y libclutter-1.0-dev
	sudo apt-get install -y libgtk2.0-dev
	sudo apt-get install -y libclutter-gtk-1.0-dev
	sudo apt-get install -y lib32bz2-dev
	sudo apt-get install -y libfuse-dev
 
	sudo apt-get install -y subversion
	sudo apt-get install -y cython
	sudo apt-get install -y python-2.7
	sudo apt-get install -y python2.7-numpy
	sudo apt-get install -y libncurses4 
	sudo apt-get install -y libncurses5 
	sudo apt-get install -y ncurses-base
}

function brewfunc(){
	# Install Hombrew.
	if ! type "brew" > /dev/null; then
    	echo "brew Doesn't Exist.Installing"
    	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	else
		echo "Brew Exists. Using"
	fi


	# Install command-line tools using Homebrew.

	# Ask for the administrator password upfront.
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until the script has finished.
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	echo "Make sure we’re using the latest Homebrew."
	brew update

	echo "Upgrade any already-installed formulae."
	brew upgrade

	echo "Install GNU core utilities (those that come with OS X are outdated)".
	echo "Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`".
	brew install coreutils
	sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

	echo " Install some other useful utilities like `sponge`".
	brew install moreutils
	echo "Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed".
	brew install findutils
	echo  "Install GNU `sed`, overwriting the built-in `sed`".
	brew install gnu-sed --with-default-names

	echo "Install Development Packages";
	brew install libxml2
	brew install libzip
	brew install libplist
	brew install openssl
	brew install clutter
	brew install cogl
	brew install usbmuxd


	# Install Software;
	brew install automake
	brew install cmake
	brew install colormake
	brew install autoconf
	brew install libtool
	brew install pkg-config
	brew install gcc
	brew install libusb
	brew install homebrew/fuse/ifuse
	brew install glib

	# Install Optional;
	brew install screenfetch
	brew install Caskroom/cask/osxfuse

	# Install extras;
	brew install bfg
	brew install binutils
	brew install binwalk
	brew install cifer
	brew install dex2jar
	brew install dns2tcp
	brew install fcrackzip
	brew install foremost
	brew install hashpump
	brew install hydra
	brew install john
	brew install knock
	brew install nmap
	brew install pngcheck
	brew install socat
	brew install sqlmap
	brew install tcpflow
	brew install tcpreplay
	brew install tcptrace
	brew install ucspi-tcp # `tcpserver` etc.
	brew install xz

	# Install other useful binaries.
	brew install ack
	#brew install exiv2
	brew install git
	#brew install imagemagick --with-webp
	brew install lua
	brew install lynx
	brew install p7zip
	brew install pigz

	# Install Node.js. Note: this installs `npm` too, using the recommended
	# installation method.
	brew install node

	# Remove outdated versions from the cellar.
	brew cleanup
}

function autobuild(){
	successlibs=()
	failedlibs=()
	libs=( "libplist" "libusbmuxd" "libimobiledevice" "usbmuxd" "libirecovery" \
		"ideviceinstaller" "libideviceactivation" "idevicerestore" "sbmanager" "ifuse" )

	spinner() {
		# What On Earth Is This?
	    local pid=$1
	    local delay=0.75
	    local spinstr='|/-\'
	    echo "$pid" > "/tmp/.spinner.pid"
	    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
	        local temp=${spinstr#?}
	        printf " [%c]  " "$spinstr"
	        local spinstr=$temp${spinstr%"$temp"}
	        sleep $delay
	        printf "\b\b\b\b\b\b"
	    done
	    printf "    \b\b\b\b"
	}

	buildlibs() {
		for i in "${libs[@]}"
		do
			echo -e "\033[1;32mFetching $i..."
			git clone https://github.com/libimobiledevice/${i}.git
			cd $i
			echo -e "\033[1;32mConfiguring $i..."
			./autogen.sh
			./configure
			echo -e "\033[1;32mBuilding $i..."
			make && sudo make install
			echo -e "\033[1;32mInstalling $i..."
			cd ..
		done
		echo -e "\033[0m"
	}

	function buildr {
		buildlibs
	}
	echo -e "\033[1;37mLibimobiledevice library build script - Elrhk 2015"
	buildr
}

if [[ $(uname) == 'Linux' ]]; then
  apt-get
  autobuild
  exit 1
elif [[ $(uname) == 'Darwin' ]]; then
	brewfunc
	autobuild
fi