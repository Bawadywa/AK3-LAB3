.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define a #6
#define b #3
#define c #7

// (a-b)*3+2^c=(6-3)*3+2^7=9+128=137dec(089hex)

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
	.word __stack_start
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel
	
.section .rodata
	data: .asciz "kernel started!\n"
	final: .asciz "Value in register #3:"
	ent: .asciz "ENTER"
.section .text

__kernel_reset__:
	ldr r0, =data
	bl dbgput_line
	
// calculate
	
mov r0, a
mov r1, b
mov r2, c

//a-b
sub r0, r1

// *3
mov r1, #3
mul r0, r1 //res in r0

//2^c
mov r3, #2
sub r2, #1
lsl r3, r3, r2 //res in r3

//sum
add r3, r0

ldr r0, =final
bl dbgput
mov r0, r3
bl dbgput_num

end:
b end
