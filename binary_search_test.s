.globl binary_search
.p2align 2
.type binary_search ,%function


binary_search:
	/*

	*/
 	add x9, x1,#1   //low  <-- from index add 1 because arm
 	mov x10, x2		//high <-- to index| no need to do -1 because in arm this is last item
 	mov x11, x3		//search key
	mov x12, xzr	//mid

	mov x14, #8		//used for mul| mul wont do literals so need to add them to a register
	mov x15, #-1	//^^^ same issue above
	loop:
	cmp x9,x10
	bgt key_not_found

	add x12, x9,x10	 //mid = (low + high)
	lsr x12, x12, #1 //>>> 1 ( divide by 2) to get mid index

	mul x13, x12, x14	// each index in arm is 8 bits

	ldr x13, [x0, x13]	//mid value

	cmp x13, x11
	blt update_low
	bgt update_high
	beq found_key

	b key_not_found


update_low:
	add x9, x12, #1
    b loop

update_high:
	sub x10, x12, #1
	b loop

key_not_found:
	add x9, x9, #1
	mul x9,x9, x15
	mov x0, x9
	b exit

found_key:
 mov x0, x12

exit:
	br x30
