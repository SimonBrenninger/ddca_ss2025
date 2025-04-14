	.text
	.align  2
	.globl  _start

_start:
	addi x1, x1, 0x1
	addi x2, x2, 0x1
	addi x3, x3, 0x1
	sw x1, 0x4(zero)
	sw x2, 0x8(zero)
	sw x3, 0xC(zero)

loop:
	j loop
	nop
	nop
	nop

	.end _start
	.size _start, .-_start

