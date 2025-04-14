startup_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=STARTUP

STARTUP_NAME:=startup
STARTUP_TB:=startup_tb
STARTUP_ELF:=$(startup_dir)/startup.elf
STARTUP_VHDL_FILES:=$(startup_dir)/startup_tb.vhd
