# Puppeteer with ChromeOS

## “Headed” Chrome Testing

Recently I’ve been working on using Chrome and WebUSB to communicate with Apple iPhone/iPads which implement the `usbmuxd` protocol.  As I was working with this, developer ergonomics and testing became very important, and unlike a regular website “headless” testing was infeasible because of the reliance on WebUSB which is a full browser feature.  Moreover I really wanted to target WebUSB from a Chromebook as an ideal test case.  I settled on using `jsdom` and `webusb` from NPM for lightweight local testing, and the following to remotely drive tests via the Chrome DevTools protocol to a Pixelbook Slate.

## Big Scary - Much Danger

Because this guide is showing you how to disable security protections in ChromeOS, and that it will make the browser remotely (albeit with a generally safe SSH configuration) accessible, **I do not recommend logging into this Chrome device with your actual Google account** or using it as anything other then a test device.  Restore the ChromeOS configuration to the non-Developer version before re-using the device for any other purpose.  You have been warned.

## Entering Developer Mode and Debugging Features

Chrome devices can be put into “Developer Mode” which is a configuration which allows running the operating system that has been modified in such a way that it is no longer in the most secure configuration.  The instructions for this vary by device and I find it is just easier to refer you to Google / Chromiums instructions (here https://chromium.googlesource.com/chromiumos/docs/+/master/developer_mode.md#dev-mode).  After entering developer mode, select “**Enable debugging features**” on the first screen of the setup process and set a password (https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/debugging-features).    I’ve also noticed that updates sometimes break R/W filesystem and reset the `root` / `chronos` password.  You can always try the default of `test0000` and if that doesn’t work, powerwash and re-enable debugging features.

## Configuring a Secure SSH Connection

Now that the device is effectively “rooted” as in an Android device would be (you have a working root account and mutable filesystem), it’s time to setup the remote SSH server.  A device with Developer Mode and Debugging Features will already be running this `sshd` by default, but it uses password authentication.  If you are OK with password based auth because the network is relatively private, you can skip this step.

You can perform the following steps from a SSH connection to the device, a local VT-2 terminal (`\[ Ctrl \] [ Alt ] [ → ]`) or from a `crosh` shell prompt (`\[ Ctrl \] [ Alt ] [ T ]`).

The example below just downloads my SSH public keys from my GitHub account, but you could also have downloaded your public key in the browser or moved it to the device via a flash-drive.


    # Enable Pubkey authentication
    $ echo "\nPubkeyAuthentication yes" >> /etc/ssh/sshd_config
    
    # Disable Challenge-Response authentication
    $ echo "\nChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
    
    # The following is an example of downloading all SSH keys for a GitHub user, replace `rickmark` with your username.
    $ curl https://github.com/rickmark.keys > /root/.ssh/authorized_keys
    
    # The folowing is an example of copying a SSH key downloaded in the browser with the file name `id_rsa.pub`
    $ cp /home/chronos/user/Downloads/id_rsa.pub /root/.ssh/authorized_keys
    
    # Next we set the ownership and mode of authorized_keys
    $ chown root:root /root/.ssh/authorized_keys
    $ chmod 600 /root/.ssh/authorized_keys
    
    # Restart the SSH server to apply
    $ initctl stop openssh-server & initctl start openssh-server
## Enabling Chrome DevTools Remote

Now that we have a configured SSH to the device, the remaining steps can be completed over SSH.  In this step we add an additional flag to the chrome process start command.  Because on a ChromeOS device the browser *is* the shell, we are effectively changing the configuration of  the OS’s equivalent of KDM / GDM


    # Append the parameter to the chrome process arguments
    $ echo "--remote-debugging-port=1337" >> /etc/chrome_dev.conf
    
    # Restart the device for the settings to take effect
    $ shutdown -r now
## Running a Tunnel to Chrome

Now that the ChromeOS device is configured, run the following to use SSH to create an encrypted tunnel from the Puppeteer machine to the ChromeOS device.  This command must remain running while Puppeteer is in use, and you will start it every time you want to use the ChromeOS device with Puppeteer.  Remember to replace `<chromedevice` with the IP address or domain name of the Chrome device as well.


    $ ssh -L 1337:localhost:1337 root@<chromedevice>


## Connecting from Puppeteer Core

The following is a simple test using `puppeteer-core` on the remote Chrome machine.  Ensure you have installed `puppeteer-core` via `yarn` or `npm` before running.  We use puppeteer core because it does not download a copy of Chrome with the module but either should work just as well.


    import * as puppeteer from 'puppeteer-core'
    
    const browser = await puppeteer.connect({browserURL: 'http://localhost:1337'})
    
    const page = await browser.newPage()
    
    await page.goto('https://google.com')
    
    // If you do the following, the entire shell restarts (remember the browser is the OS)
    await browser.close()


## BONUS: How to WebUSB with an Apple Mobile Device on ChromeOS

Recent versions of ChromeOS have included copies of `mtpd` or the media transfer protocol agent to allow a ChromeOS device to copy photos, and since the iPhone implements this protocol, it can happen that the background agent refuses to give up the device leading to “Access Denied” errors when trying to drive the device via WebUSB in the browser.  Also the linux kernel itself can attempt to claim the device as a iPhone tether device as well.  I’ve filed a bug to allow for UI to let the use “eject” the MTP device from the file browser, but for now follow the following steps to disable these on a ChromeOS device you’ve already enabled debugging features on to be able to use the device without ChromeOS getting in the way:


    # Blacklist the "iPhone Ethernet" linux kernel module
    $ echo "blacklist ipheth" >> /etc/modprobe.d/blacklist.conf
    
    # Move the 'mtpd' service to the home folder so it wont be started with the operating system.  Move it back to restore
    $ mv /etc/init/mtpd.conf ~/
    
    # Restart to apply changes
    $ shutdown -r now

