#/bin/bash
echo "Installing Xcode Commandline Tools"
xcode-select --install
echo "Installing Homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "Installing dpkg"
brew install dpkg
echo "Installing ldid"
brew install ldid
echo "Installing Theos"
echo "export THEOS=\"/opt/theos\"" >>~/.bash_profile
source ~/.bash_profile
sudo git clone https://github.com/theos/theos.git $THEOS
sudo git clone https://github.com/theos/headers.git $THEOS/Headers
sudo cp -r $THEOS/Headers/ $THEOS/include
sudo rm -rf $THEOS/Headers/
echo "Installing wget"
brew install wget
echo "Installing Reveal"
wget http://download.revealapp.com/Reveal.app.zip
unzip -XK ./Reveal.app.zip
chmod +x ./Reveal.app/Contents/MacOS/Reveal 
mv ./Reveal.app /Applications/Reveal.app
rm -rf ./Reveal.app
rm -rf ./Reveal.app.zip
echo "Installing Hopper"
sudo ./Hopper.py
unzip -XK ./Hoppper-Latest.zip
mv './Hopper Disassembler v3.app' '/Applications/Hopper Disassembler v3.app'
sudo ./debugserver.py
git clone https://github.com/nygard/class-dump.git class-dump
xcodebuild -project ./class-dump/class-dump.xcodeproj #Compile classdump
mv ./class-dump/build/Release/class-dump /usr/local/bin
rm -rf ./class-dump
