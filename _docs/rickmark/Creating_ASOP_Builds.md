# Creating ASOP Builds
This set of instructions tested on Pixel 3 XL (`crossbow`).  While the custom key is implemented, the device will boot either stock system (without a warning) or a custom image signed with the user key (with a warning).  This is the safest developer setup for an Android device.


## Generate Key
    # genrate private key (use semi-standard 65537 exponent)
    $ openssl genrsa -f4 -out avb_private.pem 4096
    
    # Create AVB custom key block from private key
    $ 


## Install Key to Device
1. Enter “Developer Mode” (Tap `Build number` repeatedly in Settings → About)
2. Enable “OEM unlocking” (Under Settings → System → Developer options)
3. Reboot the device into `bootloader` (Pixel 3XL, hold power and volume down)
4. 

