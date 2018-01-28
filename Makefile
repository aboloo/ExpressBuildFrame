#
# EBF: Express Build Frame
# by robertluojh
#   aboloo@126.com
#
# Main Makefile, with config, UI and help
#

#
# user config
#
BIN_LIST=execMain execTest
LAZY_ONE_EXE=execTest
#LIB_LIST=


# autoconfig
ROOT_DIR=$(shell pwd)
MAKEFILE_DIR=mak
CORE_NUM := $(shell grep processor /proc/cpuinfo | wc -l)

ifeq (${LIB_LIST},)
BIN_LIST_E=$(BIN_LIST:%=-e %)
cnt=$(shell find . -type d | grep -v -e .git -e mak -e build ${BIN_LIST_E} | wc -l)
LIB_LIST:=$(shell find . -type d | grep -v -e .git -e mak -e build ${BIN_LIST_E} | cut -d/ -f2 | tail -$(shell expr $(cnt) - 1))
#LIB_LIST:=$(shell ls -l | grep ^d | cut -d' ' -f11 | grep -v -e mak -e build ${BIN_LIST_E})
endif

# need to inherit to sub module makefile
export ROOT_DIR
export MAKEFILE_DIR
export BIN_LIST
export LIB_LIST

ifneq (${BIN_LIST}, ${LAZY_ONE_EXE})
LAZY_MV_PRE=$(foreach d, ${BIN_LIST}, [ ${d} == ${LAZY_ONE_EXE} ] || mv ${d} ..;)
LAZY_MV_POST=$(foreach d, ${BIN_LIST}, [ ${d} == ${LAZY_ONE_EXE} ] || mv ../${d} .;)
endif

SUB_LIST=$(LIB_LIST) $(BIN_LIST)
LOG_FILE := ${ROOT_DIR}/build.log
OUTPUT_DIR=${ROOT_DIR}/build
LIB_DIR=${OUTPUT_DIR}/lib
BIN_DIR=${OUTPUT_DIR}/bin
INCLUDE_DIR=${OUTPUT_DIR}/include
MAKEFILE_LIB=${ROOT_DIR}/mak/library.mak
MAKEFILE_BIN=${ROOT_DIR}/mak/exec.mak

MAKE_LIB_LIST=$(foreach i, ${LIB_LIST}, cd ${ROOT_DIR}/$(i); make -j$(CORE_NUM) -f${MAKEFILE_LIB} 2>&1 | tee -a $(LOG_FILE);)
MAKE_BIN_LIST=$(foreach i, ${BIN_LIST}, cd ${ROOT_DIR}/$(i); make -j$(CORE_NUM) -f${MAKEFILE_BIN} 2>&1 | tee -a $(LOG_FILE);)
CLEAN_LIB_LIST=$(foreach i, ${LIB_LIST}, cd ${ROOT_DIR}/$(i); make -f${MAKEFILE_LIB} clean;)
CLEAN_BIN_LIST=$(foreach i, ${BIN_LIST}, cd ${ROOT_DIR}/$(i); make -f${MAKEFILE_BIN} clean;)
ifeq ($(shared), on)
LIB_TYPE=so
else
LIB_TYPE=a
endif
MOVE_LIB_LIST=$(foreach i, ${LIB_LIST}, mv -f ${ROOT_DIR}/$(i)/lib$(i).${LIB_TYPE} ${LIB_DIR};)
MOVE_BIN_LIST=$(foreach i, ${BIN_LIST}, mv -f ${ROOT_DIR}/$(i)/$(i) ${BIN_DIR};)
COPY_LIB_LIST=$(foreach i, ${LIB_LIST}, cp -f ${ROOT_DIR}/$(i)/lib$(i).${LIB_TYPE} ${LIB_DIR};)
COPY_BIN_LIST=$(foreach i, ${BIN_LIST}, cp -f ${ROOT_DIR}/$(i)/$(i) ${BIN_DIR};)
COPY_MAK_LIB_LIST=$(foreach i, ${LIB_LIST}, cp -f ${MAKEFILE_LIB} ${ROOT_DIR}/$(i)/Makefile;)
COPY_MAK_BIN_LIST=$(foreach i, ${BIN_LIST}, cp -f ${MAKEFILE_BIN} ${ROOT_DIR}/$(i)/Makefile;)
DEL_MAK_LIST=$(foreach i, ${SUB_LIST}, rm -f ${ROOT_DIR}/$(i)/Makefile;)

.PHONY:help
help:
	@echo "EBF: Express Build Frame, v1.0"
	@echo "-------------------------------------------------------------"
	@echo "Usage: make <function> [option]"
	@echo "  function: "
	@echo "    help         : help info"
	@echo "    all          : build all library and executive"
	@echo "    lazy         : build one executive"
	@echo "    clean        : remove build target dir and files"
	@echo "  option:"
	@echo "    shared=on    : link to shared library objects"

.PHONY: all
all:
	@echo "" > $(LOG_FILE)
	@echo " ********* Build Start Time: $(shell date) *********" | tee -a $(LOG_FILE)
	@echo " CPU Cores: $(CORE_NUM)" | tee -a $(LOG_FILE)
	@$(MAKE_LIB_LIST)
	@$(MAKE_BIN_LIST)
	@if [ ! -d ${OUTPUT_DIR} ]; then mkdir -p ${LIB_DIR} ${BIN_DIR} ${INCLUDE_DIR}; fi
	@$(COPY_LIB_LIST)
	@$(COPY_BIN_LIST)
	@now=`date`; echo " ********* Build End Time: $${now} *********" | tee -a $(LOG_FILE)

.PHONY: lazy
lazy:
	@echo "" > $(LOG_FILE)
	@echo " ********* Build Start Time: $(shell date) *********" | tee -a $(LOG_FILE)
	@echo " CPU Cores: $(CORE_NUM)" | tee -a $(LOG_FILE)
ifeq ($(shell uname -m), i686)
	@set -e; $(LAZY_MV_PRE) unset LIB_LIST; make -f mak/exec.mak; $(LAZY_MV_POST)
else
	@set -e; $(LAZY_MV_PRE) unset LIB_LIST; make -f mak/exec.mak shared=on; $(LAZY_MV_POST)
endif
	@now=`date`; echo " ********* Build End Time: $${now} *********" | tee -a $(LOG_FILE)

.PHONY: clean
clean:
	-rm -rf $(OUTPUT_DIR) *.d *.o $(shell basename ${ROOT_DIR})
	$(CLEAN_LIB_LIST)
	$(CLEAN_BIN_LIST)

