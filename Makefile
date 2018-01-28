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
LIB_LIST=alib blib


# autoconfig
ifeq (${LIB_LIST},)
LIB_LIST=$(shell find . -type d)
endif
ROOT_DIR=$(shell pwd)
LOG_FILE := ${ROOT_DIR}/build.log
OUTPUT_DIR=${ROOT_DIR}/build
CORE_NUM := $(shell grep processor /proc/cpuinfo | wc -l)
SUB_LIST=$(LIB_LIST) $(BIN_LIST)
LIB_DIR=${OUTPUT_DIR}/lib
BIN_DIR=${OUTPUT_DIR}/bin
INCLUDE_DIR=${OUTPUT_DIR}/include

MAKE_LIST=$(foreach i, ${SUB_LIST}, cd ${ROOT_DIR}/$(i); make -j$(CORE_NUM) 2>&1 | tee -a $(LOG_FILE);)
CLEAN_LIST=$(foreach i, ${SUB_LIST}, cd ${ROOT_DIR}/$(i); make clean;)
ifeq ($(shared), on)
LIB_TYPE=so
else
LIB_TYPE=a
endif
MOVE_LIB_LIST=$(foreach i, ${LIB_LIST}, mv -f ${ROOT_DIR}/$(i)/lib$(i).${LIB_TYPE} ${LIB_DIR};)
COPY_LIB_LIST=$(foreach i, ${LIB_LIST}, cp -f ${ROOT_DIR}/$(i)/lib$(i).${LIB_TYPE} ${LIB_DIR};)
COPY_BIN_LIST=$(foreach i, ${BIN_LIST}, cp -f ${ROOT_DIR}/$(i)/$(i) ${BIN_DIR};)

.PHONY:help
help:
	@echo "EBF: Express Build Frame, v1.0"
	@echo "-------------------------------------------------------------"
	@echo "Usage: make <function> [option]"
	@echo "  function: "
	@echo "    help         : help info"
	@echo "    all          : build all library and executive"
	@echo "    clean        : remove build target dir and files"
	@echo "  option:"
	@echo "    shared=on    : link to shared library objects"

.PHONY: all
all:
	@echo "" > $(LOG_FILE)
	@echo " ********* Build Start Time: $(shell date) *********" | tee -a $(LOG_FILE)
	@echo " CPU Cores: $(CORE_NUM)" | tee -a $(LOG_FILE)
	@$(MAKE_LIST)
	@if [ ! -d ${OUTPUT_DIR} ]; then mkdir -p ${LIB_DIR} ${BIN_DIR} ${INCLUDE_DIR}; fi
	@$(COPY_LIB_LIST)
	@$(COPY_BIN_LIST)
	@now=`date`; echo " ********* Build End Time: $${now} *********" | tee -a $(LOG_FILE)

.PHONY: clean
clean:
	-rm -rf $(OUTPUT_DIR)
	$(CLEAN_LIST)

