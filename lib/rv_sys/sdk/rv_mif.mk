%.imem.hex: %.elf
	${OBJCOPY} -j .text -O ihex $< $@

%.dmem.hex: %.elf
	${OBJCOPY} -R .text -O ihex $< $@

%.mif: %.hex
	${sdk_dir}/hex2mif.pl < $< > $@
