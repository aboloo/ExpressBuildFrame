#
# EBF: Express Build Frame
# by robertluojh
#    aboloo@126.com
#
# Makefile of executive binary file, that can finish to build an exec alonely
#

#
# user config
#
#LIB_LIST=

# autoconfig
CUR_DIR=$(shell pwd)

ifeq (${MAKEFILE_DIR},)
MAKEFILE_DIR=mak
endif

ifeq (${ROOT_DIR},)
ifeq ($(shell ls | grep ${MAKEFILE_DIR}), ${MAKEFILE_DIR})
ROOT_DIR=$(CUR_DIR)
endif
endif

ifeq (${LIB_LIST},)
INC_DIR=$(shell find . -type d | grep -v .git)
INC_LIST=$(INC_DIR:%=-I${ROOT_DIR}/%)
else
INC_LIST=$(LIB_LIST:%=-I${ROOT_DIR}/%)
INC_LIST+=$(BIN_LIST:%=-I${ROOT_DIR}/%)
endif

#DIR_LIST=
ifeq (${DIR_LIST},)
DIR_LIST=$(INC_DIR)
endif
#SRC_LIST=$(foreach dir, ${CUR_DIR}/${DIR_LIST}, $(wildcard ${dir}/*.c))
#TODO: mysql is temp config
SRC_LIST=$(shell find . -type f -name '*.c')
OBJ_LIST=$(SRC_LIST:.c=.o)
DEP_LIST=$(SRC_LIST:.c=.d)

MOD_NAME=$(shell basename ${CUR_DIR})
BIN_NAME=$(MOD_NAME)

ifeq ($(shell ls | grep ${MAKEFILE_DIR}), ${MAKEFILE_DIR})
-include ./${MAKEFILE_DIR}/common.mak
else ifeq ($(shell ls .. | grep ${MAKEFILE_DIR}), ${MAKEFILE_DIR})
-include ../${MAKEFILE_DIR}/common.mak
endif

#TODO: refer to #include "*.h"
CFLAGS+=-I$(ROOT_DIR) -I${CUR_DIR} ${INC_LIST}

# command line argument telling to build shared library objects
ifeq ($(shared), on)
ADD_LIB=$(LIB_LIST:%=-L${ROOT_DIR}/%) $(LIB_LIST:%=-l%)
LIB_NEED=$(foreach i, ${LIB_LIST}, ${ROOT_DIR}/$(i)/lib$(i).so)
ADD_LIB+=-lpthread
else
# sequence is important!
ADD_LIB=$(foreach i, ${LIB_LIST}, ${ROOT_DIR}/$(i)/lib$(i).a)
LIB_NEED=${ADD_LIB}
ifeq ($(shell uname -m), i686)
ADD_LIB+=/usr/lib/libpthread.a /usr/lib/libc.a
else
#ADD_LIB+=/usr/lib64/libpthread_nonshared.a /usr/lib64/libc_nonshared.a
ADD_LIB+=/usr/lib/x86_64-redhat-linux6E/lib64/libpthread.a /usr/lib/x86_64-redhat-linux6E/lib64/libc.a
endif
endif

$(BIN_NAME): ${OBJ_LIST}
ifeq ($(shell uname -m), i686)
	${LINK} $^ ${ADD_LIB} -o $@
else
	${LINK} -pie -fPIC $^ ${ADD_LIB} -o $@
endif

%.o: %.c
ifeq ($(shell uname -m), i686)
	${CC} ${CFLAGS} -c $< -o $@
else
	${CC} -fPIE -fPIC ${CFLAGS} -c $< -o $@
endif

%.d: %.c
	@set -e; rm -f $@; ${CC} ${CFLAGS} -MM $< > $@.$$$$; sed 's,\($(notdir $*)\)\.o[:]*,$*.o $@:,g' $@.$$$$ > $@; rm -f $@.$$$$


-include ${DEP_LIST}
#${BIN_NAME}: ${LIB_NEED}
$(shell echo "${BIN_NAME} ${CUR_DIR}/${BIN_NAME}.d: ${OBJ_LIST} ${LIB_NEED}" > ${BIN_NAME}.d)
-include ${BIN_NAME}.d


#TODO: enhance if used byself
.PHONY: clean
clean:
	-rm -f *.o *.d *.so *.a ${BIN_NAME}


