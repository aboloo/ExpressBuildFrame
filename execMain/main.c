/*
 * example for Express Build Frame
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alib/goToEast.h>
#include <blib/goToWest.h>


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
        printf("Main executive file, by robertluojh.\n");
        ret = showEast();
        sleep(3);
        ret = showWest();
        sleep(1);
    }

    return ret;
}

