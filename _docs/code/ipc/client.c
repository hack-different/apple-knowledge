#include <stdio.h>
#include <stdlib.h>

#include <mach/mach.h>

#include <servers/bootstrap.h>

/* our sending message structure */
struct message_send {
    mach_msg_header_t header;   /* header; must always be at the beginning of the message */
    uint32_t x;                 /* our data */
};

int main(void) {

    kern_return_t kr;
    mach_port_t send_port;  /* this is the port exposed by our server, and where we will send our messages */

    /* we obstain the service port via launchd */
    kr = bootstrap_look_up(bootstrap_port, "test_service", &send_port);
    if (kr != KERN_SUCCESS) {
        printf("unable to find service.\n");
        return -1;
    }

    struct message_send *msg = malloc(sizeof(struct message_send)); /* allocate our sending instance */
    bzero(msg, sizeof(struct message_send));                        /* remember to always zero out your message! junk data might corrupt it. */

    /*  how to interpret the remote/local ports passed to mach_msg.
     *  The first arg of this macro specifies how we will use the remote port (MACH_MSG_TYPE_COPY_SEND).
     *  The second arg of this macro specifies how we will use the local port. We pass 0 since we don't
     *  use a local port, so behaviour is unspecified.
    */
    msg->header.msgh_bits = MACH_MSGH_BITS(MACH_MSG_TYPE_MOVE_SEND, 0);
    msg->header.msgh_remote_port = send_port;               /* where to send the message */
    msg->header.msgh_size = sizeof(struct message_send);    /* message size */
    msg->x = 1000;    /* our data */

    kr = mach_msg(
                    &(msg->header),                 /* our sending structure's header */
                    MACH_SEND_MSG,                  /* we want to send */
                    sizeof(struct message_send),    /* send size */
                    0,                              /* we are not receiving anything */
                    MACH_PORT_NULL,                 /* we are not receiving anything */
                    MACH_MSG_TIMEOUT_NONE,          /* no timeout for send */
                    MACH_PORT_NULL                  /* no notification port */
                );

    if (kr != MACH_MSG_SUCCESS) {
        printf("failed to send: %s\n", mach_error_string(kr));
        return -1;
    } else {
        printf("message sent!\n");
    }

    return 0;
}
