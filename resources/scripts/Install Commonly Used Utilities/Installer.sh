#/bin/bash
echo "Installing Xcode Commandline Tools"
xcode-select --install
if ! type "brew" > /dev/null; then
  	# install Homebrew
  	echo "Installing Homebrew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Homebrew already installed"
fi

if ! type "dpkg" > /dev/null; then
  	# install dpkg
  	echo "Installing dpkg"
	brew install dpkg
else
	echo "dpkg already installed"
fi

if ! type "ldid" > /dev/null; then
  	# install ldid
  	echo "Installing ldid"
	brew install ldid
else
	echo "ldid already installed"
fi

export THEOS=/opt/theos
if [ ! -d "$THEOS" ]; then
  	# Theos isn't existe
  	echo "Installing Theos"
	echo "export THEOS=/opt/theos" >>~/.bash_profile
	source ~/.bash_profile
	sudo git clone  --recursive https://github.com/theos/theos.git $THEOS
	sudo git clone https://github.com/theos/headers.git $THEOS/Headers
	sudo cp -r $THEOS/Headers/ $THEOS/include
	sudo rm -rf $THEOS/Headers/
else
	# Theos existe
	echo "Theos already installed"
fi

if ! type "wget" > /dev/null; then
  	# install wget
  	echo "Installing wget"
	brew install wget
else
	echo "wget already installed"
fi

if [ ! -d "/Applications/Reveal.app" ]; then
  	# Reveal app isn't existe
  	echo "Installing Reveal"
	wget http://download.revealapp.com/Reveal.app.zip
	unzip -XK ./Reveal.app.zip
	chmod +x ./Reveal.app/Contents/MacOS/Reveal 
	mv ./Reveal.app /Applications/Reveal.app
	rm -rf ./Reveal.app
	rm -rf ./Reveal.app.zip
else
	echo "Reveal app already installed"
fi

if [ ! -d "/Applications/Hopper Disassembler v3.app" ]; then
  	# Hopper app isn't existe
  	echo "Installing Hopper"
	sudo ./Hopper.py
	unzip -XK ./Hoppper-Latest.zip
	mv './Hopper Disassembler v3.app' '/Applications/Hopper Disassembler v3.app'
else
	echo "Hopper app already installed"
fi


sudo ./debugserver.py
git clone https://github.com/nygard/class-dump.git class-dump
xcodebuild -project ./class-dump/class-dump.xcodeproj #Compile classdump
mv ./class-dump/build/Release/class-dump /usr/local/bin
rm -rf ./class-dump
