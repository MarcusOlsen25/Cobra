.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
Node_descriptor:
.text
Node:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx			# Push heap pointer
	movq $0, %rax			# Put a number in %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	movq $0, %rax			# Put a number in %rax
	movq %rax, 24(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
inorder_traversal:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	cmp $0, %rax			# Check the condition
	je end_0			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call inorder_traversal			# Call the inorder_traversal function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq 32(%rax), %rax		# Move value into %rax
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
	movq 24(%rax), %rax		# Traverse static link once
	movq 32(%rax), %rax		# Move value into %rax
	movq 24(%rax), %rax		# Move value into %rax
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call inorder_traversal			# Call the inorder_traversal function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
end_then_0:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	addq $16, %rsp			# Remove dummy spaces
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_0			# Skip the else
end_0:
end_inorder_traversal:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $56, %rsp			# Allocate space for local variables on the stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	movq $3, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -24(%rbp)			# Move initialized value into space on stack
	movq $4, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -32(%rbp)			# Move initialized value into space on stack
	movq $5, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -32(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -40(%rbp)			# Move initialized value into space on stack
	movq $6, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -40(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $32, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq Node_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	pushq %rcx			# Push heap pointer
	call Node			# Call Node constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -48(%rbp)			# Move initialized value into space on stack
	movq $7, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -48(%rax), %rax		# Move value into %rax
	movq %rdx, 8(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq %rdx, 16(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq %rdx, 16(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -32(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq %rdx, 24(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -40(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq 24(%rax), %rax		# Move value into %rax
	movq %rdx, 24(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -48(%rax), %rax		# Move value into %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	movq %rdx, 24(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq %rax, -56(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	pushq %rax		# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Add dummy space
	call inorder_traversal			# Call the inorder_traversal function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	addq $56, %rsp			# Deallocate space for local variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
