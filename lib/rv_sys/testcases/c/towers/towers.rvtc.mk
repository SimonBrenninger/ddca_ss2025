towers_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=TOWERS

TOWERS_NAME:=towers
TOWERS_TB:=rv_uart_io_tb
TOWERS_ELF:=$(towers_dir)/towers.elf
TOWERS_GHDL_USER_ARGS:=-gUART_RX='Towers successful'
TOWERS_VSIM_USER_ARGS:=-gUART_RX=\\\"Towers\ successful\\\"
