minimal_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=MINIMAL

MINIMAL_NAME:=minimal
MINIMAL_TB:=rv_uart_io_tb
MINIMAL_ELF:=$(minimal_dir)/minimal.elf
MINIMAL_GHDL_USER_ARGS:=-gUART_RX='RV'
MINIMAL_VSIM_USER_ARGS:=-gUART_RX=\\\"RV\\\"
