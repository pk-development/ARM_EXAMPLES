.globl max,min,sum,asm_sort,swap_arr,factorial,fib_sum,fibA,string_test
.p2align 2

.type max,%function
.type min,%function
.type sum,%function
.type asm_sort,%function
.type swap_arr,%function
.type factorial,%function
.type fib_sum,%function
.type fibA,%function
.type string_test,%function



/*
	csel = if (cond) then ... else ...
*/
//---------------------Returns Max value---------------
max:
	cmp x0,x1
	csel x0, x0, x1, GT //x0 > x1 return x0 else x1
	b return

//---------------------Returns Min value---------------
min:
	cmp x0,x1
	csel x0, x0, x1, LT //x0 < x1 return x0 else x1
	b return

/*
 * sum all the elements passed to the array
 *	sum(long long int arr[], long long int arr_size)
 */
 //-------------------Sum of all elements in Array---------------
sum:
	mov x10, #1 //counter
	mov x11, #0
	mov x13, #0 //offset - start of first item

	loop:

    cmp x10, x1 //x10 > x1 array_size
    bgt store_result

	LDR x9, [x0, x13] 	// load data at this address and put in x9
	add x13, x13, #8  	// move 16bits to next register offset (64b register)
	add x11, x11, x9  	// sum += x9

	add x10, x10, #1	// increment i
	b loop

store_result:
	mov x0, x11
	b return			//return to main



//---------reverse items in a array ie 1,2,3,4 becomes 4,3,2,1
swap_arr:
	mov x9, #1 			// counter i
	mov x10, xzr		// stack pointer
	mov x11, xzr		// array index pointer

	//x12 holds array item
	push_stack:				//push array items onto stack
		add x10, x10, #-8	// get more space on the stack for next item

	    cmp x9, x1 			// x9 > x1 array_size
	    bgt pop_stack
	    LDR x12,[x0, x11] 	// get array element
		STR x12,[SP,x10]	// push array item onto the stack

		add x11, x11, #8	// set array index pointer to next item postion

		add x9,x9, #1 		//i++

		b push_stack

	pop_stack:				// pop all items off the stack into the array
		mov x9, #1 			// reset counter to 1
		mov x11, xzr		// mov index pointer to first postion in array
		add x10, x10, #8	// move to last inserted item on the stack

		pop_loop:
	    cmp x9, x1 			// x9 > x1 array_size
	    bgt return			// return to main

	    LDR x12,[SP, x10] 	// pop item off the stack
		STR x12,[x0,x11]	// push array item onto the stack

		add x10, x10, #8	// move to next item on the stack
		add x11, x11, #8	// set array index pointer to next item postion

		add x9,x9, #1 		//i++
		b pop_loop

//--------------Factorial---------------------------
factorial:
	mov x9, x0	//sum = x9 - start of with initial factorial
    mov x10, x0 //fact = x9

	//x0 is counter

	factloop:
    cmp x0, #1	//fact > 1
    bls exit

	sub x10, x10, #1 //fact-1
	mul x9, x9 , x10

	sub x0, x0, #1 //dec x0
	b factloop

exit:
 mov x0, x9
 br x30

//------------------Bubble sort start--------------------------
/*
	long long int tmp;

	for(int i = 0; i < sizeT-1; i++) {
		for(int j = 0; j < sizeT - i; j++) {
			if(arr[j] > arr[j+1]) {
				tmp = arr[i]; //larger
				arr[i] = arr[j+1]; //swap small with large
				arr[j+1] = tmp;	//put large in small spot
			}
		}

	}

	x0 = array address
	x1 = the length of the array
	x9 = tmp

	x10 = i
	x11 = j
	x12 = k

	x13 arr item1
	x14 arr item2
*/
asm_sort:
	mov x10, #1 	// set i to 1
	mov x15, #-8 	// left pointer
	mov x16, #0  	// item2 offset always 1 above i

	outer_loop:

	    cmp x10, x1 		//x10 > x1 array_size
	    beq return

		sub x12, x1, x10 		// for(..; j < sizeT - i; ..)
	    add x10, x10, #1 		// increment i
		mov x11, #1				// j used to loop thru address of array
		add x15, x15, #8		// move to next item position
		add x16, x15, #8		// move to next item position


		inner_loop:

			cmp x11, x12 		// if less than or equal to 0 break
			bgt outer_loop

			LDR x13, [x0, x15] // item1
			LDR x14,[x0, x16]  // item2

			cmp x13, x14		//item1 > item2
			bgt swap_elements

			current_poistion:
			add x16, x16, #8   	// move to next array item postion
			add x11, x11, #1 	// increment j
			b inner_loop



swap_elements:
		mov x9, x13 			// store higher value in tmp
		STR x14, [x0, x15] 		// store item2 in item1 position
		STR x9,[x0, x16]		// store item1 in item2 position
	b current_poistion
//--------------------Bubble sort end-----------------------------------

//An an attempt at the recursive call
fibA:
 STP      x29,x30,[sp,#-0x30]!
 MOV      x29,sp
 STR      x19,[sp,#0x10]
 STR      x0,[x29,#0x28]
 LDR      x0,[x29,#0x28]
 CMP      x0,#1
 B.GT     J1
 MOV      x0,#1		//if(n <= 1) return 1
 B        J2

J1:
  LDR      x0,[x29,#0x28]
  SUB      x0,x0,#1
  BL       fibA

  MOV      x19,x0
  LDR      x0,[x29,#0x28]
  SUB      x0,x0,#2	//fibA(n - 2)
  BL       fibA
J2:
 ADD      x0,x19,x0
 LDR      x19,[sp,#0x10]
 LDP      x29,x30,[sp],#0x30
 RET

//recursive test
fib_sum:
 STP      x29,x30,[sp,#-0x20]!
 MOV      x29,sp
 STR      x0,[x29,#0x18]
 LDR      x0,[x29,#0x18]
 CMP      x0,#1
 B.NE     b1
 MOV      x0,#1
 B        b2

b1:
 LDR      x0,[x29,#0x18]
 SUB      x0,x0,#1
 BL       fib_sum

b2:
 LDP      x29,x30,[sp],#0x20
 RET

//--------------------2 loops example----------------------------------
for_example:
	mov x10, #1 					// set i to 1
	mov x11, #1						// set j to one
	forloop1:

	    cmp x10, #10 				// x10 >= 10 array_size
	    beq return
	    //do work here if needed
		add x10, x10, #1 			// increment i,

		//fall into loop 2
		forloop2:

			cmp x11, #10 			// bgt, bge, blt, ble
			bge forloop1
			// do your work in here

			b forloop2

/*
 at the moment both loops have an iteration limit of 10 if
 you want to change
*/
//--------------end of 2 loops-----------------


string_test:
	mov x9,#1
	mov x10, #0

	lpp:
		cmp x9, #4
		bgt return

		ldr x11, [x0, x10]
		add x11,x11,#1
		str x11, [x0, x10]

		add x9,x9,#1
		add x10,x10,#8
		b  lpp
//exit app
return:
	br	x30
