.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
banan_descriptor:
	.quad asd
.text
banan:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Move heap pointer into %rcx
	pushq %rcx			# Push heap pointer
	leaq banan_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	movq $3, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
asd:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
end_asd:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	movq heap_pointer(%rip), %rax			# Move heap pointer into %rax
	pushq %rax			# Push heap pointer
	call banan			# Call banan constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_0		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_0
print_align_0:
	callq printf@plt		# Call printf
end_print_0:
			# End print statement
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
