.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
tiger_descriptor:
	.quad one_tiger
	.quad two_tiger
.text
print:			# Default procedure
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi				# Passing %rax (2. argument)
	movq $0, %rax				# No floating point registers used
	testq $15, %rsp				# Test for 16 byte alignment
	jz print_align				# Jump if aligned
	addq $-8, %rsp				# 16 byte aligning
	callq printf@plt			# Call printf
	addq $8, %rsp				# Reverting alignment
	jmp end_print
print_align:
	callq printf@plt			# Call printf
end_print:
	ret							# Return from the procedure
tiger:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $2, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
one_tiger:			# Method
	subq $8, %rsp			# Add dummy base pointer
	movq 8(%rax), %rax		# Move value into %rax
	call print				# Call the print procedure
end_one_tiger:
	addq $8, %rsp			# Remove dummy base pointer
	ret						# Return from the method
two_tiger:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 32(%rbp), %rax		# Access variable
	movq 8(%rax), %rax		# Move value into %rax
	call print				# Call the print procedure
end_two_tiger:
	popq %rbp				# Restore base pointer
	ret						# Return from the method
.globl main
main:
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq tiger_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	pushq %rbp				# Push simple static link
	pushq %rcx				# Push heap pointer
	call tiger			# Call tiger constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $16, %rsp			# Deallocate heap pointer and static link
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq -16(%rbp), %rax		# Access variable
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	movq -16(%rbp), %rax		# Access variable
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	pushq %rbp				# Push simple static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $24, %rsp			# Deallocate dummy space, static link and arguments
	addq $16, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
