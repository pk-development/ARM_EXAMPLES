################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../array_test_asm.s \
../binary_search_test.s \
../csel_test.s \
../fib_asm.s \
../stack_test.s 

C_SRCS += \
../main_class.c 

OBJS += \
./array_test_asm.o \
./binary_search_test.o \
./csel_test.o \
./fib_asm.o \
./main_class.o \
./stack_test.o 

C_DEPS += \
./main_class.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.s
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler 7.1.1 [aarch64-elf]'
	aarch64-elf-as.exe -g -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler 7.1.1 [aarch64-elf]'
	aarch64-elf-gcc.exe -O0 -g -Wall -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


