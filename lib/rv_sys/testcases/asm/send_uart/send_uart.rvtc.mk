cur_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=SEND_UART

SEND_UART_NAME:=send_uart
SEND_UART_TB:=send_uart_tb
SEND_UART_ELF:=$(cur_dir)/send_uart.elf

SEND_UART_VHDL_FILES:=$(cur_dir)/send_uart_tb.vhd
