.globl   asm_copy, asm_copy2, asm_copy3
.p2align 2

.type    asm_copy,%function
.type    asm_copy2,%function
.type    asm_copy3,%function
asm_copy:
	sub sp,sp,#32

	STR x9, [SP, #0]
	STR x10, [SP, #8]
	STR x11, [SP, #16]

	mov x10, #1			//counter
	mov x11, #0

	loop:

    	cmp x10, #10 		//x10 > x1 array_size
    	bgt restore_regv1

		LDR x9, [x0, x11] 	// load data at this address and put in x9
		STR x9, [x1, x11] 	// str data at this address and put in x1
		add x11, x11, #8  	// move 16bits to next register offset (64b register)

		add x10, x10, #1	// increment i
		b loop

restore_regv1:
	//reload data back to the registers
	LDR x9, [SP, #0]
	LDR x10, [SP, #8]
	LDR x11, [SP, #16]
	add sp,sp,#32
	mov x0, #1			//set the boolean condition to 1 i.e. True
	b exit

/*
	Definitely be overkill but good practice for using the stack
	as a temporary location to hold data

	Swapping the src to the dst in reverse order
	x0 holds our 1st pointer
	x1 holds out 2nd pointer

	#8 = 8 bytes = 64bits = 1 register
*/
asm_copy2:

	sub sp,sp,#48

	STR x9, [SP, #0]
	STR x10, [SP, #8]
	STR x11, [SP, #16]
	STR x12, [SP, #24]

	mov x9, #1 			// counter i
	mov x10, xzr		// stack pointer
	mov x11, xzr		// array index pointer

	//x12 holds array item
	push_stack:				//push array items onto stack
		add x10, x10, #-8	// get more space on the stack for next item

	    cmp x9, #10 		// x9 > x1 array_size
	    bgt pop_stack		// jmp to pop stack

	    LDR x12,[x0, x11] 	// get array element
		STR x12,[SP,x10]	// push array item onto the stack

		add x11, x11, #8	// set array index pointer to next item position
		add x9,x9, #1 		//i++

		b push_stack

	pop_stack:				// pop all items off the stack into the array
		mov x9, #1 			// reset counter to 1
		mov x11, xzr		// mov index pointer to first postion in array
		add x10, x10, #8	// move to last inserted item on the stack

		pop_loop:
	    	cmp x9, #10 		// x9 > x1 array_size
	    	bgt restore_regv2			// return to main

	   		LDR x12,[SP, x10] 	// pop item off the stack abd store in x12
			STR x12,[x1,x11]	// set the pop item into the array location i.e. x1 is the dst arr pointer

			add x10, x10, #8	// move to next item on the stack
			add x11, x11, #8	// set array index pointer to next item position

			add x9,x9, #1 		//i++
			b pop_loop

restore_regv2:
	LDR x9, [SP, #0]
	LDR x10, [SP, #8]
	LDR x11, [SP, #16]
	LDR x12, [SP, #24]
	add sp,sp,#48
	mov x0, #1			//set the boolean condition to 1 i.e. True
	b exit

asm_copy2_1:		//normal version just to match spec
	sub sp,sp, #64 	//#56 should be enough space but throws exception, 56/8 = 7 register space
					//I'm guessing the stack space can't be odd if divided by 8

	STR x9, [SP, #0]
	STR x10, [SP, #8]
	STR x11, [SP, #16]
	STR x12, [SP, #24]
	STR x13, [SP, #32]
	STR x14, [SP, #40]

	mov x9, #1				//i
	mov x13, #9				// sub -1 from array size

	mov x11, xzr			// Offset position of the 1st element in array
	mov x12, #8				// Offset counter (mul wont work with #8 so need in register)

	mul x12, x13, x12 		// last item position in array2  (gives position of last item)

	for_loop_1:
		cmp x9, x2			// if i > array.length exit (dont confuse with java indices)
		bgt restore_regv3	//uses same amount of registers as 3rd version

		LDR x14,[x0, x11]	//get 1st item
		STR x14,[x1, x12]	//set new item in last index of array 2

		add x9, x9, #1		//increment i

		add x11, x11, #8	//increment the offset for 1st array element
		sub x12, x12, #8	//decrement the offset for 2nd array starting at last element
		b for_loop_1



/*
	x0 holds pointer for src array
	x1 holds pointer for dst array
	x2 holds the size of array one
	int[] array = {0,1,2,3,4,5,6,7,8,9};
	int i = 0, j = array.length -1;

	int tmp = 0;
	while(i < array.length-1) {
		array2[j] = array[i];
		i++;
		j--;
	}
*/
asm_copy3:
	sub sp,sp, #64 	//#56 should be enough space but throws exception, 56/8 = 7 register space
					//I'm guessing the stack space can't be odd if divided by 8

	STR x9, [SP, #0]
	STR x10, [SP, #8]
	STR x11, [SP, #16]
	STR x12, [SP, #24]
	STR x13, [SP, #32]
	STR x14, [SP, #40]

	mov x9, #1				//i
	sub x13, x2, #1			// sub -1 from array size

	mov x11, xzr			// Offset position of the 1st element in array
	mov x12, #8				// Offset counter (mul wont work with #8 so need in register)

	//   vvv--------------------re-using 12 here to free up other registers
	mul x12, x13, x12 		// last item position in array2  (gives position of last item)

 	/* variables at this point in program execution
 		x9 = i = 1
		x11 holds the offset to first element in array
		x12 holds the last element in the array
	*/

	for_loop:
		cmp x9, x2				// if i > array.length exit (dont confuse with java indices)
		bgt restore_regv3

		LDR x14,[x0, x11]		//get 1st item
		STR x14,[x1, x12]		//set new item in last index of array 2

		add x9, x9, #1			//increment i

		add x11, x11, #8		//increment the offset for 1st array element
		sub x12, x12, #8		//decrement the offset for 2nd array starting at last element
		b for_loop

restore_regv3:
	LDR x9, [SP, #0]
	LDR x10, [SP, #8]
	LDR x11, [SP, #16]
	LDR x12, [SP, #24]
	LDR x13, [SP, #32]
	LDR x14, [SP, #40]

	add sp,sp, #64
	mov x0, #1			//set the boolean condition to 1 i.e. True
	b exit

exit:
	br x30				//return to main
