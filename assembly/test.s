.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
banan_descriptor:
	.quad one_banan
agurk_descriptor:
.text
banan:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $7, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
one_banan:			# Method
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq 8(%rax), %rax		# Move value into %rax
end_one_banan:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the method
agurk:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq banan_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call banan			# Call banan constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
f:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
	jmp end_f
end_f:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq banan_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call banan			# Call banan constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq agurk_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call agurk			# Call agurk constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
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
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	pushq %rax			# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax		# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_1		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_1
print_align_1:
	callq printf@plt		# Call printf
end_print_1:
			# End print statement
	addq $16, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
