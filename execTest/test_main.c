/*
 * example for Express Build Frame
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


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

    /* main loop */
    while(1) {
        printf("Test executive file, by robertluojh.\n");
        ret = showEast();
        sleep(1);
    }

    return ret;
}

