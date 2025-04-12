sdk_dir := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef ARCH
ARCH=rv32i
endif

PREFIX=/opt/ddca/riscv/bin/riscv32-unknown-elf

AS=${PREFIX}-as
CC=${PREFIX}-gcc -march=$(ARCH)
LD=${PREFIX}-gcc -march=$(ARCH) -nostartfiles -Wl,-N,-e,_start,-Ttext=0x40000000,--section-start,.rodata=4
AR=${PREFIX}-ar
OBJCOPY=${PREFIX}-objcopy

CFLAGS=-O2

OBJ_FILES = $(patsubst %.c, %.o, $(SRC_FILES))

$(ELF_NAME): $(ELF_NAME).imem.mif $(ELF_NAME).dmem.mif
.PHONY: $(ELF_NAME)
.SECONDARY: $(ELF_NAME).elf

util.c:
	cp $(sdk_dir)/util.c .
	cp $(sdk_dir)/util.h .

crt0.S:
	cp $(sdk_dir)/crt0.S .

lib: libc.a

libc.a: util.o
	${AR} rc $@ $^

%.elf : libc.a crt0.o $(OBJ_FILES)
	${LD} $^ -L. -lc -o $@

clean:
	rm -f util.c util.h crt0.S
	rm -rf libc.a *.s *.o *.elf *.hex *.mif

.PHONY: clean all
.PRECIOUS: %.o

include $(sdk_dir)/rv_mif.mk
include $(sdk_dir)/rv_run.mk
