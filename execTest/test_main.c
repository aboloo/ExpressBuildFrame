/*
 * example for Express Build Frame
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int g_hb_flag = 1;
int hbCnt = 0;


/*
 * pthread to check Heartbeat
 */
void *checkHB(void *arg)
{
    int hbDjCnt = 0;
    printf("check Heart Beat!\n");

    /* loop */
    for(;;)
    {
        /* send heartbeat to dj */
        if (g_hb_flag && hbCnt%2==0)
        {
            printf("ready to send heartbeat to peer!\n");
        }

        hbCnt++;
        sleep(1);
    }
    
    return(NULL);
}

/***************************************************************************
 * main
 * ------------------------------------------------------------------------
 * General:  the main function of the test application.
 * Return Value: -
 * ------------------------------------------------------------------------
 * Arguments:
 * input   : argc - number of prarmeters entered to main
 *         : argv - parameters entered to test application
 ***************************************************************************/
int main(int argc, char *argv[])
{
    int ret = 0;

    /* 新线程处理心跳 */
    pthread_t tid;
    pthread_create(&tid, NULL, checkHB, NULL);

    /* main loop */
    while(1) {
        printf("Test executive file, by robertluojh.\n");
        ret = showEast();
        sleep(1);
    }

    return ret;
}

