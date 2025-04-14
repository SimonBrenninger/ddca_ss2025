uart_loopback_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=UART_LOOPBACK

UART_LOOPBACK_NAME:=uart_loopback
UART_LOOPBACK_TB:=rv_uart_io_tb
UART_LOOPBACK_ELF:=$(uart_loopback_dir)/uart_loopback.elf
UART_LOOPBACK_GHDL_USER_ARGS:=-gUART_RX='1a5f' -gUART_TX='1a5f'
UART_LOOPBACK_VSIM_USER_ARGS:=-gUART_RX=\\\"1a5f\\\" -gUART_TX=\\\"1a5f\\\"
