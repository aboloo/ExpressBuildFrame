# EBF: Express Build Frame
# by robertluojh
#    aboloo@126.com
#
# Makefile of library, that can build statical and dynamic library
#

#
# user config
#

# autoconfig
CUR_DIR=$(shell pwd)
MOD_NAME=$(shell basename ${CUR_DIR})

#DIR_LIST=
ifeq (${DIR_LIST},)
DIR_LIST=$(shell find . -type d)
endif
#SRC_LIST=$(foreach dir, ${CUR_DIR}/${DIR_LIST}, $(wildcard ${dir}/*.c))
SRC_LIST=$(shell find . -type f -name '*.c')
OBJ_LIST=$(SRC_LIST:.c=.o)
DEP_LIST=$(SRC_LIST:.c=.d)

-include ../${MAKEFILE_DIR}/common.mak

#ROOT_DIR=$(shell dirname ${CUR_DIR})
ifeq (${ROOT_DIR},)
ifeq ($(shell ls | grep ${MAKEFILE_DIR}), ${MAKEFILE_DIR})
ROOT_DIR=$(CUR_DIR)
endif
endif

INC_DIR_LIST=$(LIB_LIST:%=-I${ROOT_DIR}/%)
CFLAGS+=-I$(ROOT_DIR) -I${CUR_DIR} ${INC_DIR_LIST}
LIB_NAME=lib${MOD_NAME}

${LIB_NAME}: ${OBJ_LIST}
ifeq ($(shared), on)
	${LINK} -fPIC -shared $^ -o $@.so
else
	${AR} $@.a $^
endif

%.o: %.c
ifeq ($(shared), on)
	${CC} ${LIBFLAGS} ${CFLAGS} -c $< -o $@
else
	${CC} ${CFLAGS} -c $< -o $@
endif

%.d: %.c
	@set -e; rm -f $@; ${CC} ${CFLAGS} -MM $< > $@.$$$$; sed 's,\($(notdir $*)\)\.o[:]*,$*.o $@:,g' $@.$$$$ > $@; rm -f $@.$$$$

-include ${DEP_LIST}


.PHONY: clean
clean:
	-rm -f *.a *.so $(shell find . -type f -name "*.o") $(shell find . -type f -name "*.d")
