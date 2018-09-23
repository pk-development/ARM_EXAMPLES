#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "csel_test.h"  // lots of mixed methods
#include "binary_search_test.h"

int main(void) {
	long long int arr[] = {1,4,2,5,3,7,3,8,6,8,10,2,13};
	char s[] = "abcdefgABCDEFG";
	char x;
	char s2[] = {'a','b','c','d','e','\0'};
	x = s2[0];
	x = s2[1];
	x = s2[2];
	x = s2[3];
	x = s2[4];
	x = x + 2;

	string_test(s2);

	for(int i = 0; i < 7; i++) {
		printf("%c", s[i]);
	}

	//how many items in the array
	long long int arr_size = sizeof(arr) / sizeof(long);

	printf("Unsorted\n");
	for(int i = 0; i < arr_size; i++) {
		printf("%lld\t", arr[i]);
	}


	printf("\nSorted\n");
	asm_sort(arr, arr_size);
	for(int i = 0; i < arr_size; i++) {
		printf("%lld\t", arr[i]);
	}

	//------------------Swap array elements--------------
	long long int swap[] = {1,2,3,4,5,6};
	arr_size = sizeof(swap) / sizeof(long);

	printf("\nUn-swapped\n");
	for(int i = 0; i < arr_size; i++) {
		printf("%lld\t", swap[i]);
	}


	printf("\nSwapped\n");
	swap_arr(swap, arr_size);
	for(int i = 0; i < arr_size; i++) {
		printf("%lld\t", swap[i]);
	}

	//-----------------sum off all items----------------
	long long int sumOfAll = sum(swap, arr_size);
	printf("\nSum of all elements is:%lld\n", sumOfAll);

	//-------------------min and max---------------
	long long int minval = 10, maxval = 100;

	printf("\nThe min and max of %lld & %lld is min:%lld max:%lld",
			minval,maxval,
			min(minval,maxval),
			max(minval,maxval));
	long long int fact = 6;

	printf("\nThe factorial of %lld = %lld\n", 6, factorial(6));

	long long int binarr[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
	long long int key = 20;
	arr_size = sizeof(binarr) / sizeof(long);
	printf("\nArray size %lld\n", arr_size);

	printf("\nKey index %lld\n", binary_search(binarr, 0, arr_size, key));

	for(int n = 6; n >= 1; n--)
		printf("%lld ",fibA(n));
}
