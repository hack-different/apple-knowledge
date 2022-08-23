# Apple Factory Data

## `tCfg` Test Configuration

In my experiance this is an img4 file that contains a payload that contains a `fCfg` as described later.

* ASN.1 Sequence
  * Integer magic 'fCfg' in little endian
  * Intger
  * Private Sequence `1397768537`
    * Magic (values observed `MtCl`/`TPCl`)
    * String '.'
    * Data Stream - Appears to be a "patch" to a value provided by the firmware
  * Private `1296389185`
  * Private `1296125513`

## `fCfg` Factory Config

## `scrt` - SEP Certificate

## `hop0` - H O policy 0

Contains some amount of policy involving debug IP/MAC and what operations are permitted.

### Policy `1.2.840.113635.100.6.16`

* GET/FSCl:*
* PUT/FSCl:*
* GET/NvMR:*
* PUT/NvMR:*
* GET/hop0:*
* PUT/hop0:*
* GET/ateD:*
* PUT/ateD:*

### Host `1.2.840.113635.100.6.17`

Example: `0c:4d:e9:a7:16:31/172.19.203.55`

### `1.2.840.113635.100.6.1.15`

## `lcrt` - Lynx Certificate

The Lynx (and later ocelot) are parts of the SEP.  This file is a IMG4 signed copy of that certificate. Along
with some other structured data.

## `trust-object`

Trust object (current and specified) are ASN.1 files encoding the trusted TLS certificate for when the FDR process
contacts out to the apple server to restore factory data (things like serial number etc).  A restore machine is
expected to provide a FDR proxy during the restore process, this allow the device to connect out to download data
directly to Apple.  These certificates are rooted out of `FDR-DC-SSL-ROOT`

### ASN.1 Sequence

Data file magic `secb`

Sequence staring with `trst` which is the trust object.
Sequence next is `rssl` which is the transport root
Sequence final is `rvok` which is revoked certificates
