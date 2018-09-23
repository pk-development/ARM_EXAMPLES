.globl sum_of_all
.p2align 2
.type sum_of_all ,%function

/*
EL3:0x0000000080001248 : STR      x0,[x29,#0x18]
EL3:0x000000008000124C : LDR      x0,[x29,#0x18]

*/

sum_of_all:
	mov x10, #0 //counter
	mov x11, #0
	mov x13, #8
	b loop

	loop:

    cmp x10, #2 //x10 > 5
    bgt exit

	lsl x13, x13, #1

	LDR x9, [sp, x13] // load data at this address and put in x9

	add x11, x11, x9 // sum

	add x10, x10, #1
	b loop

exit:
	mov x0, x11
	br x30
