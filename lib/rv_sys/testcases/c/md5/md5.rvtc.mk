md5_dir:=$(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

RV_TESTCASES+=MD5

MD5_NAME=md5
MD5_TB=rv_uart_io_tb
MD5_ELF=$(md5_dir)/md5.elf
MD5_GHDL_USER_ARGS=-gUART_RX='md5 successful'
MD5_VSIM_USER_ARGS=-gUART_RX=\\\"md5\ successful\\\"
