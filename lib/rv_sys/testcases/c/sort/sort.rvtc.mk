sort_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=SORT

SORT_NAME:=sort
SORT_TB:=rv_uart_io_tb
SORT_ELF:=$(sort_dir)/sort.elf
SORT_GHDL_USER_ARGS:=-gUART_RX='Sorting successful'
SORT_VSIM_USER_ARGS:=-gUART_RX=\\\"Sorting\ successful\\\"
