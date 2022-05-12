# RTKit - "Realtime Kit"

## RTBuddy2

## Commands

As documented in `m1n1`

```c
struct rtkit_message {
    u8 ep;
    u64 msg;
};

struct rtkit_buffer {
    void *bfr;
    u64 dva;
    size_t sz;
};
```

* `rtkit_dev_t *rtkit_init(const char *name, asc_dev_t *asc, dart_dev_t *dart,
  iova_domain_t *dart_iovad, sart_dev_t *sart);`
* `bool rtkit_sleep(rtkit_dev_t *rtk);`
* `bool rtkit_hibernate(rtkit_dev_t *rtk);`
* `bool rtkit_start_ep(rtkit_dev_t *rtk, u8 ep);`
* `bool rtkit_boot(rtkit_dev_t *rtk);`
* `int rtkit_recv(rtkit_dev_t *rtk, struct rtkit_message *msg);`
* `bool rtkit_send(rtkit_dev_t *rtk, const struct rtkit_message *msg);`
* `bool rtkit_map(rtkit_dev_t *rtk, void *phys, size_t sz, u64 *dva);`
* `bool rtkit_unmap(rtkit_dev_t *rtk, u64 dva, size_t sz);`
* `bool rtkit_alloc_buffer(rtkit_dev_t *rtk, struct rtkit_buffer *bfr, size_t sz);`
* `bool rtkit_free_buffer(rtkit_dev_t *rtk, struct rtkit_buffer *bfr);`

### Service: RTKIT_EP_MGMT

#### MGMT_MSG_HELLO / MGMT_MSG_HELLO_ACK

#### MGMT_MSG_HELLO_MINVER / MGMT_MSG_HELLO_MAXVER

#### MGMT_MSG_IOP_PWR_STATE / MGMT_MSG_IOP_PWR_STATE_ACK

#### MGMT_MSG_EPMAP / MGMT_MSG_EPMAP_DONE / MGMT_MSG_EPMAP_BASE / MGMT_MSG_EPMAP_BITMAP

#### MGMT_MSG_EPMAP_REPLY / MGMT_MSG_EPMAP_REPLY_DONE / MGMT_MSG_EPMAP_REPLY_MORE

### Service: RTKIT_EP_CRASHLOG

### Service: RTKIT_EP_SYSLOG

#### MSG_SYSLOG_INIT / MSG_SYSLOG_INIT_ENTRYSIZE / MSG_SYSLOG_INIT_COUNT

#### MSG_SYSLOG_LOG

#### MSG_SYSLOG_LOG_INDEX

### Service: RTKIT_EP_DEBUG

### Service: RTKIT_EP_IOREPORT

### Service: RTKIT_EP_OSLOG

#### MSG_OSLOG_INIT

#### MSG_OSLOG_ACK

## Mach-O Binary Structure

### _rtk_boot

### _rtk_mtab

### _fp_context

Floating point context

### _hb_context

Hibernate context, used to restore device from a power-off state.  Wakeup resume flag of `0xfeed1b00`

## FTAB

FTAB is a linear filesystem like region

## MTAB