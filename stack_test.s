.globl stack_call
.p2align 2
.type stack_call ,%function

//#8 for 64 bit registers
stack_call:
	mov x9, #1
	mov x10,#2
	mov x11,#3
	mov x12,#4
	mov x13, #-8		//used as stack pointer

	STR x9,[SP,x13]
	add x13, x13, #-8
	STR x10,[SP,x13]
	add x13, x13, #-8
	STR x11,[SP,x13]
	add x13, x13, #-8
	STR x12,[SP,x13]

	LDR x0,[SP,x13]
	add x13, x13, #8
	LDR x1,[SP,x13]
	add x13, x13, #8
	LDR x2,[SP,x13]
	add x13, x13, #8
	LDR x3,[SP,x13]
	add x13, x13, #8

	b exit
exit:

	br x30
