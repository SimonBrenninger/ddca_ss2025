sdk_dir := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

PREFIX=/opt/ddca/riscv/bin/riscv32-unknown-elf


CC=${PREFIX}-gcc
AS=${PREFIX}-as
LD=${PREFIX}-ld -N --section-start=.text=0x0 -no-relax
AR=${PREFIX}-ar
OBJCOPY=${PREFIX}-objcopy

#TODO: find better solution
ELF_NAME?=$(shell basename $$(ls *.S) | rev | cut -c3- | rev)

all: $(ELF_NAME).imem.mif $(ELF_NAME).dmem.mif

.SECONDARY: $(ELF_NAME).elf

%.o: %.S
	${AS} $< -o $@

%.elf: %.o
	${LD} $^ -o $@

clean:
	rm -rf *.o *.elf *.hex *.mif

.PHONY: clean all

include $(sdk_dir)/rv_mif.mk
include $(sdk_dir)/rv_run.mk
