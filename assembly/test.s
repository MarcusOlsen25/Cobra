.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
.text
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $34, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
