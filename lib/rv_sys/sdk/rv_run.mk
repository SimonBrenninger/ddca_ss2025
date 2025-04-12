

run:
	d=$$(pwd) && cd $(sdk_dir) && quartus_stp -t bootloader.tcl $$d/$(ELF_NAME).dmem.mif $$d/$(ELF_NAME).imem.mif


remote_run:
	rpa_shell --scp $(ELF_NAME).dmem.mif .rpa_shell/dmem
	rpa_shell --scp $(ELF_NAME).imem.mif .rpa_shell/imem
	rpa_shell --scp $(sdk_dir)/bootloader.tcl .rpa_shell
	rpa_shell --scp $(sdk_dir)/quartus.ini .rpa_shell
	rpa_shell "\"cd .rpa_shell && quartus_stp -t bootloader.tcl dmem imem\""
