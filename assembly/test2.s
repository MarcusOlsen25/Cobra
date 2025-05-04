.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
banan_descriptor:
.text
banan:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Move heap pointer into %rcx
	pushq %rcx			# Push heap pointer
	leaq banan_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)		# Move class descriptor into object
	addq $24, heap_pointer(%rip)			# Add size of object to heap pointer
	movq $5, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq $1, %rax			# Put true in %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $5, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq $6, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	addq $16, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
