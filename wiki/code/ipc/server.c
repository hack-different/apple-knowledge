#include <stdio.h>
#include <stdlib.h>

#include <mach/mach.h>

#include <servers/bootstrap.h>

/* our receiving message structure */
struct message_recv {
    mach_msg_header_t header;   /* header; must always be at the beginning of the message */
    uint32_t x;                 /* our data */
    mach_msg_trailer_t trailer; /* kernel-added trailer */
};

int main(void) {

    kern_return_t kr;
    mach_port_t receive_port;   /* this is the port that we will be exposing to the system, and where we will receive messages */

    /* we register a service via launchd, simply for exposing our port to other tasks */
    kr = bootstrap_check_in(bootstrap_port, "test_service", &receive_port);
    if (kr != KERN_SUCCESS) {
        printf("failed to register service.\n");
        return -1;
    }

    struct message_recv *msg = malloc(sizeof(struct message_recv)); /* allocate our receiving instance */
    bzero(msg, sizeof(struct message_recv));                        /* remember to always zero out your message! junk data might corrupt it. */

    msg->header.msgh_size = sizeof(struct message_recv);    /* expected message size, it shouldn't exceed our structure */

    kr = mach_msg(
                    &(msg->header),                 /* our receiving structure's header */
                    MACH_RCV_MSG,                   /* we want to receive */
                    0,                              /* we are not sending anything */
                    sizeof(struct message_recv),    /* size to receive */
                    receive_port,                   /* where to listen and receive messages */
                    MACH_MSG_TIMEOUT_NONE,          /* we want to listen forever */
                    MACH_PORT_NULL                  /* no notification port */
                );

    if (kr != MACH_MSG_SUCCESS) {
        printf("failed to receive! %s\n", mach_error_string(kr));
        return -1;
    } else {
        printf("received: %d\n", msg->x);   /* let's print our received data */
    }

    return 0;
}
