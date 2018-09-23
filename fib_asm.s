	.globl   fib_asm
    .p2align 2
	.type    fib_asm,%function

//x0 = n
fib_asm:
	mov x9, #0	//a
	mov x10, #1 //b
	mov x11, #0	//c
	mov x12, #2 //i

	cmp x0, #0
	blt return_neg //branch less than

	cmp x0, #20
	bgt return_neg //branch greater than

	cmp x0, #2		//branch less than
	blt exit

	b fib_loop

fib_loop:
 	cmp x12, x0 		//i <= n
 	bgt return_n

	add x11,x9,x10 		//c = a + b
	mov x9, x10			//a = b
	mov x10, x11		//b = c
	add x12, x12, #1	//increment i
	b fib_loop

return_n:
	mov x0, x10
	b exit

return_neg:
	mov x0, #-1
	b exit

exit:
	br       x30           // Return by branching to the address in the link register.
