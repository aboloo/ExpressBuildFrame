# EBF: Express Build Frame
# by robertluojh
#    aboloo@163.com
#
# Makefile of library, that can build statical and dynamic library
#

#
# user config
#
DIR_LIST=

# autoconfig
CUR_DIR=$(shell pwd)
MOD_NAME=$(shell basename ${CUR_DIR})
ifeq (${DIR_LIST},)
DIR_LIST=$(shell find . -type d)
endif

-include ../mak/common.mak

CFLAGS+=-I$(shell dirname ${CUR_DIR})

LIB_NAME=lib${MOD_NAME}
SRC_LIST=$(foreach dir, ${CUR_DIR}/${DIR_LIST}, $(wildcard ${dir}/*.c))
OBJ_LIST=$(SRC_LIST:.c=.o)
DEP_LIST=$(SRC_LIST:.c=.d)

${LIB_NAME}: ${OBJ_LIST}
ifeq ($(shared), on)
	${LINK} -fPIC -shared $^ -o $@.so
else
	${AR} $@.a $^
endif

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

%.d: %.c
	@set -e; rm -f $@; ${CC} ${CFLAGS} -MM $< > $@.$$$$; sed 's,\($(notdir $*)\)\.o[:]*,$*.o $@:,g' $@.$$$$ > $@; rm -f $@.$$$$

-include ${DEP_LIST}


.PHONY: clean
clean:
	-rm -f *.a *.so $(shell find . -type f -name "*.o") $(shell find . -type f -name "*.d")
