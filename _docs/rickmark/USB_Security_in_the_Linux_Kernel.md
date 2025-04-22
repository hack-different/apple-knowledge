# USB Security in the Linux Kernel
Dropbox not only works to ensure that our product is worthy of trust, but we look up and down the entire stack of components for risk and areas of improvement.  Like many companies, we employ Linux servers to power the Dropbox product.  We perform regular patching, secure configuration and performance and security logging, but at times we have to go deeper.


# When USB Was New

Much of the Linux kernel core code is about two decades old, and much of it written by Linus himself and predating the modern computer security industry.  At the time, USB was new, and malicious devices were not part of the threat model, so the code is extremely relaxed to try to accommodate compatibly and reliability over security.  Because of the fact this code is shared across Android phones, Chromebooks, Linux desktops, laptops and servers, its security is paramount in this age.


# Lack of Defensive Programming

Code written during this era predates the modern security practice of defensive coding.  To ensure that mistakes in the code are not exploitable, especially with regard to untrusted input from devices, defensive programming tactics like length validation, canonicalization, and removing overly permissive cases must be employed.  As many of these strategies came into vogue after the initial versions of core USB code, safety conscious revisions are necessary.


## Examples of Potentially Exploitable Code


## Unvalidated Length from Device
![](https://paper-attachments.dropbox.com/s_848B01F014E8BFB84374AC8362E81C8D03D9E184AEAEDFF47C33B172DEE5F69F_1557968770373_image+1.png)


Patch as submitted 5/14/2019
https://marc.info/?l=linux-usb&m=155780009303416&w=2

    ---
     drivers/usb/core/config.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++
     1 file changed, 67 insertions(+)
    
    diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
    index 7b5cb28ff..8cb9a136e 100644
    --- a/drivers/usb/core/config.c
    +++ b/drivers/usb/core/config.c
    @@ -33,6 +33,13 @@ static int find_next_descriptor(unsigned char
    *buffer, int size,
    
      /* Find the next descriptor of type dt1 or dt2 */
      while (size > 0) {
    +     if (size < sizeof(struct usb_descriptor_header)) {
    +         printk( KERN_ERR "usb config: find_next_descriptor "
    +                          "with size %d not sizeof("
    +                          "struct usb_descriptor_header)", size );
    +         break;
    +     }
    +
      h = (struct usb_descriptor_header *) buffer;
      if (h->bDescriptorType == dt1 || h->bDescriptorType == dt2)
      break;
    @@ -58,6 +65,13 @@ static void
    usb_parse_ssp_isoc_endpoint_companion(struct device *ddev,
      * The SuperSpeedPlus Isoc endpoint companion descriptor immediately
      * follows the SuperSpeed Endpoint Companion descriptor
      */
    + if (size < sizeof(struct usb_ssp_isoc_ep_comp_descriptor)) {
    +        dev_warn(ddev, "Invalid size %d for SuperSpeedPlus isoc
    endpoint companion"
    +                       "for config %d interface %d altsetting %d ep %d.\n",
    +                 size, cfgno, inum, asnum, ep->desc.bEndpointAddress);
    +        return;
    + }
    +
      desc = (struct usb_ssp_isoc_ep_comp_descriptor *) buffer;
      if (desc->bDescriptorType != USB_DT_SSP_ISOC_ENDPOINT_COMP ||
          size < USB_DT_SSP_ISOC_EP_COMP_SIZE) {
    @@ -76,6 +90,14 @@ static void usb_parse_ss_endpoint_companion(struct
    device *ddev, int cfgno,
      struct usb_ss_ep_comp_descriptor *desc;
      int max_tx;
    
    + if (size < sizeof(struct usb_ss_ep_comp_descriptor)) {
    +        dev_warn(ddev, "Invalid size %d of SuperSpeed endpoint"
    +                       " companion for config %d "
    +                       " interface %d altsetting %d: "
    +                       "using minimum values\n",
    +                 size, cfgno, inum, asnum);
    +        return;
    + }
      /* The SuperSpeed endpoint companion descriptor is supposed to
      * be the first thing immediately following the endpoint descriptor.
      */
    @@ -103,6 +125,16 @@ static void
    usb_parse_ss_endpoint_companion(struct device *ddev, int cfgno,
      ep->desc.wMaxPacketSize;
      return;
      }
    +
    + if ((size - desc->bLength) < 0 ||
    +     size < USB_DT_SS_EP_COMP_SIZE) {
    +        dev_warn(ddev, "Control endpoint with bMaxBurst = %d in "
    +                       "config %d interface %d altsetting %d ep %d: "
    +                       "has invalid bLength %d vs size %d\n", desc->bMaxBurst,
    +                 cfgno, inum, asnum, ep->desc.bEndpointAddress,
    desc->bLength, size);
    +        return;
    + }
    +
      buffer += desc->bLength;
      size -= desc->bLength;
      memcpy(&ep->ss_ep_comp, desc, USB_DT_SS_EP_COMP_SIZE);
    @@ -214,7 +246,24 @@ static int usb_parse_endpoint(struct device
    *ddev, int cfgno, int inum,
      unsigned int maxp;
      const unsigned short *maxpacket_maxes;
    
    + if (size < sizeof(struct usb_endpoint_descriptor)) {
    +        dev_warn(ddev, "config %d interface %d altsetting %d has an "
    +                       "size %d smaller then endpoint descriptor, skipping\n",
    +                 cfgno, inum, asnum, size);
    +
    +        return -EINVAL;
    + }
    +
      d = (struct usb_endpoint_descriptor *) buffer;
    +
    + if ((size - d->bLength) < 0) {
    +        dev_warn(ddev, "config %d interface %d altsetting %d has an "
    +                       "invalid endpoint descriptor of length %d, skipping\n",
    +                 cfgno, inum, asnum, d->bLength);
    +
    +        return -EINVAL;
    + }
    +
      buffer += d->bLength;
      size -= d->bLength;
    
    @@ -446,7 +495,18 @@ static int usb_parse_interface(struct device
    *ddev, int cfgno,
      int len, retval;
      int num_ep, num_ep_orig;
    
    + if (size < sizeof(struct usb_interface_descriptor)) {
    +        dev_err(ddev, "config %d interface %d has an "
    +                       "invalid endpoint descriptor of length %d, skipping\n",
    +                 cfgno, inum, size);
    +    }
      d = (struct usb_interface_descriptor *) buffer;
    +
    + if ((size - d->bLength) < 0) {
    +        dev_err(ddev, "config %d interface %d has an "
    +                       "invalid endpoint descriptor of length %d, skipping\n",
    +                 cfgno, inum, d->bLength);
    + }
      buffer += d->bLength;
      size -= d->bLength;
    
    @@ -514,6 +574,13 @@ static int usb_parse_interface(struct device
    *ddev, int cfgno,
      /* Parse all the endpoint descriptors */
      n = 0;
      while (size > 0) {
    +     if (size < sizeof(struct usb_descriptor_header)) {
    +            dev_err(ddev, "config %d interface %d has an "
    +                           "invalid endpoint descriptor of length %d,
    skipping\n",
    +                     cfgno, inum, size);
    +            return -EINVAL;
    +     }
    +
      if (((struct usb_descriptor_header *) buffer)->bDescriptorType
           == USB_DT_INTERFACE)
      break;
    -- 
    2.11.0

