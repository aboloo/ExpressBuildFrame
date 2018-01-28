#
# EBF: Express Build Frame
# by robertluojh
#    aboloo@126.com
#
# Makefile of executive file, that can finish to build an exec alonely
#

#
# user config
#
ifeq (${NEED_LIBS},)
NEED_LIBS=alib blib
endif

# autoconfig
ifeq (${DIR_LIST},)
DIR_LIST=$(shell find . -type d)
endif
CUR_DIR=$(shell pwd)
ROOT_DIR=$(shell dirname ${CUR_DIR})
MOD_NAME=$(shell basename ${CUR_DIR})
BIN_NAME=$(MOD_NAME)

-include ../mak/common.mak

CFLAGS+=-I$(shell dirname ${CUR_DIR})

SRC_LIST=$(foreach dir, ${CUR_DIR}/${DIR_LIST}, $(wildcard ${dir}/*.c))
OBJ_LIST=$(SRC_LIST:.c=.o)
DEP_LIST=$(SRC_LIST:.c=.d)

# command line argument telling to build shared library objects
ifeq ($(shared), on)
ADD_LIB=$(NEED_LIBS:%=-L${ROOT_DIR}/%) $(NEED_LIBS:%=-l%)
LIB_LIST=$(foreach i, ${NEED_LIBS}, ${ROOT_DIR}/$(i)/lib$(i).so)
else
# sequence is important!
ADD_LIB=$(foreach i, ${NEED_LIBS}, ${ROOT_DIR}/$(i)/lib$(i).a)
LIB_LIST=${ADD_LIB}
endif

$(BIN_NAME): ${OBJ_LIST}
	${LINK} $^ ${ADD_LIB} -o $@

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

%.d: %.c
	@set -e; rm -f $@; ${CC} ${CFLAGS} -MM $< > $@.$$$$; sed 's,\($(notdir $*)\)\.o[:]*,$*.o $@:,g' $@.$$$$ > $@; rm -f $@.$$$$


-include ${DEP_LIST}
#${BIN_NAME}: ${LIB_LIST}
$(shell echo "${BIN_NAME} ${CUR_DIR}/${BIN_NAME}.d: ${OBJ_LIST} ${LIB_LIST}" > ${BIN_NAME}.d)
-include ${BIN_NAME}.d


.PHONY: clean
clean:
	-rm -f *.o *.so *.a *.d ${BIN_NAME}
