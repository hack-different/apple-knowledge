# USB-PD Condom

- Two USB-PD PHYs
- Ability to draw power from various voltages (so the devices can negotiate up from 5V)
- USB Switch (Connect FS lines, High-Z)
- MCU handles and passes PD frames
    - No USB Alt Mode
    - No VDM
- Should the MCU code be ROM?  Likely given use case, and since the an update would make the device a vector / useless.
- Button / LED for USB FS lane status

