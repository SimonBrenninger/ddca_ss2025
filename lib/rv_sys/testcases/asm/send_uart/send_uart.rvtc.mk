send_uart_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=SEND_UART

SEND_UART_NAME:=send_uart
SEND_UART_TB:=send_uart_tb
SEND_UART_ELF:=$(send_uart_dir)/send_uart.elf

SEND_UART_VHDL_FILES:=$(send_uart_dir)/send_uart_tb.vhd
