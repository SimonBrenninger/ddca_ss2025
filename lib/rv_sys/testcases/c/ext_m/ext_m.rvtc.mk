ext_m_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=EXT_M

EXT_M_NAME:=ext_m
EXT_M_TB:=rv_uart_io_tb
EXT_M_ELF:=$(ext_m_dir)/ext_m.elf
EXT_M_GHDL_USER_ARGS:=-gUART_RX='ext_m checks successful'
EXT_M_VSIM_USER_ARGS:=-gUART_RX=\\\"ext_m\ checks\ successful\\\"
