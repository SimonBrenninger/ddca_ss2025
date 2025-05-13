.text
.align 2
.globl _start

_start:
	
	la x30, 0xFFFF4000       # GPIO Base ADDR
	la x31, 0xFFFF8000       # Timer Base ADDR

	# set seven-segment displays
	li x1, 0x122b0612
	sw x1, 0x8(x30)
	li x1, 0x21214608
	sw x1, 0xc(x30)

	
main_loop:
	# output upper timer bits on green leds
	lw x10, 0(x31)
	srl x10, x10, 16
	sw x10, 0x0(x30)


	j main_loop
