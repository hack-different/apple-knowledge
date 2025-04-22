# Securing the Pi

- Remove all kernels but kernel8.img
- Remove all DTBs but the 4
- Remove all non start4*.elf files
- Remove all non fixup4*s
- Modify config
    - arm_64bit=true
    - dtoverlay=pi3-disable-wifi
    - dtoverlay=pi3-disable-bt

