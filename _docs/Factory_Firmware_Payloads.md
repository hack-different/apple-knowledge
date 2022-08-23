# Contents of `Hardware` iBoot Volume

Several of these files seem to exist at once.  The format is as such:

`[mandev-|mansta-]<FIRMWARE_4CC>-<COMPONENT_SERIAL_NUMBER>`

* `FSCl`
* `HmCA` - bare, mandev versions. Serial is Ambient Light Sensor
* `NvMR` - bare, mandev, mansta versions.  Serial is Display Panel
* `appv` - bare, mandev, mansta versions.  Serial is `<CPID>-<ECID>`
* `dCfg`
* `fCfg` - bare, mandev, mansta versions.  Serial is `<CPID>-<ECID>`
* `tCfg` - bare, mansta version.  Serial is Touch Controller
* `hop0`
* `lcrt`

The following occur without any mandev/mansta versions

* `pcrt` - Serial is `<CPID>-<ECID>`
* `scrt` - Serial is `<CPID>-<ECID>`
* `seal` - Serial is `<CPID>-<ECID>`, is FDR "seal"

The following are non-serial based

* `trustobject-current`
* `trustobject-<HASH>`
