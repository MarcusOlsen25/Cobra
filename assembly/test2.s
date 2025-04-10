.data
form:
	.string "%d\n"
.text
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $64, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
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
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Assign value to %rax
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
	movq $3, %rax			# Put a number in %rax
	movq %rax, %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -8(%rax)
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_2		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_2
	print_align_2:
	callq printf@plt		# Call printf
	end_print_2:
				# End print statement
	movq $7, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	imulq %rbx, %rax		# Multiply both sides
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	subq %rbx, %rax			# Subtract both sides
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	movq %rax, -24(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_3		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_3
	print_align_3:
	callq printf@plt		# Call printf
	end_print_3:
				# End print statement
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	imulq %rbx, %rax		# Multiply both sides
	pushq %rax			# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	movq $0, %rdx			# Put a 0 in %rdx to prepare for the division
	idivq %rbx			# Divide both sides
	popq %rbx			# Pop right side into %rbx
	subq %rbx, %rax			# Subtract both sides
	movq %rax, -32(%rbp)		# Move initialized value into space on stack
	movq $15, %rax			# Put a number in %rax
	negq %rax			# Negate value
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -32(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_0			# Skip if they are not equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_0			# Skip the alternative branch
	comp_skip_0:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_0:
	cmp $0, %rax			# Check the condition
	je end_0			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $5, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_4		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_4
	print_align_4:
	callq printf@plt		# Call printf
	end_print_4:
				# End print statement
end_then_0:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_0			# Skip the else
end_0:
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_1			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_5		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_5
	print_align_5:
	callq printf@plt		# Call printf
	end_print_5:
				# End print statement
end_then_1:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_1			# Skip the else
end_1:
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je end_2			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_6		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_6
	print_align_6:
	callq printf@plt		# Call printf
	end_print_6:
				# End print statement
end_then_2:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_2			# Skip the else
end_2:
	movq $0, %rax			# Put a number in %rax
	movq %rax, -40(%rbp)		# Move initialized value into space on stack
	movq $1, %rax			# Put a number in %rax
	movq %rax, -48(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -40(%rax), %rax		# Assign value to %rax
	cmp $0, %rax			# Check the condition
	je end_3			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_7		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_7
	print_align_7:
	callq printf@plt		# Call printf
	end_print_7:
				# End print statement
end_then_3:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_3			# Skip the else
end_3:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -48(%rax), %rax		# Assign value to %rax
	cmp $0, %rax			# Check the condition
	je end_4			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $7, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_8		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_8
	print_align_8:
	callq printf@plt		# Call printf
	end_print_8:
				# End print statement
end_then_4:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_4			# Skip the else
end_4:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -40(%rax), %rax		# Assign value to %rax
	cmp $0, %rax			# Check the condition
	je else_part_5			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_9		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_9
	print_align_9:
	callq printf@plt		# Call printf
	end_print_9:
				# End print statement
end_then_5:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_5			# Skip the else
else_part_5:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $8, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_10		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_10
	print_align_10:
	callq printf@plt		# Call printf
	end_print_10:
				# End print statement
end_else_5:
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
end_5:
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -48(%rax), %rax		# Assign value to %rax
	cmp $0, %rax			# Check the condition
	je else_part_6			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $9, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_11		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_11
	print_align_11:
	callq printf@plt		# Call printf
	end_print_11:
				# End print statement
end_then_6:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_6			# Skip the else
else_part_6:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_12		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_12
	print_align_12:
	callq printf@plt		# Call printf
	end_print_12:
				# End print statement
end_else_6:
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
end_6:
	movq $1, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_7			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $9, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq $10, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_13		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_13
	print_align_13:
	callq printf@plt		# Call printf
	end_print_13:
				# End print statement
end_then_7:			# Clean up then block stack frame
	addq $16, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_7			# Skip the else
else_part_7:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $78, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_14		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_14
	print_align_14:
	callq printf@plt		# Call printf
	end_print_14:
				# End print statement
end_else_7:
	addq $8, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
end_7:
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_8			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $16, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq $0, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_15		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_15
	print_align_15:
	callq printf@plt		# Call printf
	end_print_15:
				# End print statement
end_then_8:			# Clean up then block stack frame
	addq $16, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_8			# Skip the else
else_part_8:
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $11, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_16		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_16
	print_align_16:
	callq printf@plt		# Call printf
	end_print_16:
				# End print statement
end_else_8:
	addq $8, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
end_8:
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_1			# Skip if right side is less or equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_1			# Skip the alternative branch
	comp_skip_1:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_1:
	cmp $0, %rax			# Check the condition
	je end_9			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_17		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_17
	print_align_17:
	callq printf@plt		# Call printf
	end_print_17:
				# End print statement
end_then_9:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_9			# Skip the else
end_9:
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_2			# Skip if right side is less or equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_2			# Skip the alternative branch
	comp_skip_2:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_2:
	cmp $0, %rax			# Check the condition
	je end_10			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $12, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_18		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_18
	print_align_18:
	callq printf@plt		# Call printf
	end_print_18:
				# End print statement
end_then_10:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_10			# Skip the else
end_10:
	movq $3, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_3			# Skip if right side is greater or equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_3			# Skip the alternative branch
	comp_skip_3:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_3:
	cmp $0, %rax			# Check the condition
	je end_11			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $13, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_19		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_19
	print_align_19:
	callq printf@plt		# Call printf
	end_print_19:
				# End print statement
end_then_11:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_11			# Skip the else
end_11:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_4			# Skip if right side is greater or equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_4			# Skip the alternative branch
	comp_skip_4:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_4:
	cmp $0, %rax			# Check the condition
	je end_12			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_20		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_20
	print_align_20:
	callq printf@plt		# Call printf
	end_print_20:
				# End print statement
end_then_12:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_12			# Skip the else
end_12:
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $7, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_5			# Skip if right side is greater
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_5			# Skip the alternative branch
	comp_skip_5:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_5:
	cmp $0, %rax			# Check the condition
	je end_13			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_21		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_21
	print_align_21:
	callq printf@plt		# Call printf
	end_print_21:
				# End print statement
end_then_13:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_13			# Skip the else
end_13:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $9, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_6			# Skip if right side is greater
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_6			# Skip the alternative branch
	comp_skip_6:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_6:
	cmp $0, %rax			# Check the condition
	je end_14			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $14, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_22		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_22
	print_align_22:
	callq printf@plt		# Call printf
	end_print_22:
				# End print statement
end_then_14:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_14			# Skip the else
end_14:
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $6, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jg comp_skip_7			# Skip if right side is greater
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_7			# Skip the alternative branch
	comp_skip_7:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_7:
	cmp $0, %rax			# Check the condition
	je end_15			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $15, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_23		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_23
	print_align_23:
	callq printf@plt		# Call printf
	end_print_23:
				# End print statement
end_then_15:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_15			# Skip the else
end_15:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $4, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_8			# Skip if right side is less
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_8			# Skip the alternative branch
	comp_skip_8:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_8:
	cmp $0, %rax			# Check the condition
	je end_16			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_24		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_24
	print_align_24:
	callq printf@plt		# Call printf
	end_print_24:
				# End print statement
end_then_16:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_16			# Skip the else
end_16:
	movq $4, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_9			# Skip if right side is less
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_9			# Skip the alternative branch
	comp_skip_9:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_9:
	cmp $0, %rax			# Check the condition
	je end_17			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $16, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_25		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_25
	print_align_25:
	callq printf@plt		# Call printf
	end_print_25:
				# End print statement
end_then_17:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_17			# Skip the else
end_17:
	movq $2, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $2, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_10			# Skip if right side is less
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_10			# Skip the alternative branch
	comp_skip_10:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_10:
	cmp $0, %rax			# Check the condition
	je end_18			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $17, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_26		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_26
	print_align_26:
	callq printf@plt		# Call printf
	end_print_26:
				# End print statement
end_then_18:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_18			# Skip the else
end_18:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_11			# Skip if they are not equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_11			# Skip the alternative branch
	comp_skip_11:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_11:
	cmp $0, %rax			# Check the condition
	je end_19			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $18, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_27		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_27
	print_align_27:
	callq printf@plt		# Call printf
	end_print_27:
				# End print statement
end_then_19:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_19			# Skip the else
end_19:
	movq $9, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jne comp_skip_12			# Skip if they are not equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_12			# Skip the alternative branch
	comp_skip_12:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_12:
	cmp $0, %rax			# Check the condition
	je end_20			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_28		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_28
	print_align_28:
	callq printf@plt		# Call printf
	end_print_28:
				# End print statement
end_then_20:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_20			# Skip the else
end_20:
	movq $5, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_13			# Skip if they are equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_13			# Skip the alternative branch
	comp_skip_13:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_13:
	cmp $0, %rax			# Check the condition
	je end_21			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $19, %rax			# Put a number in %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_29		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_29
	print_align_29:
	callq printf@plt		# Call printf
	end_print_29:
				# End print statement
end_then_21:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_21			# Skip the else
end_21:
	movq $8, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq $8, %rax			# Put a number in %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_14			# Skip if they are equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_14			# Skip the alternative branch
	comp_skip_14:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_14:
	cmp $0, %rax			# Check the condition
	je end_22			# Skip if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax			# Negate value
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_30		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_30
	print_align_30:
	callq printf@plt		# Call printf
	end_print_30:
				# End print statement
end_then_22:			# Clean up then block stack frame
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	jmp end_22			# Skip the else
end_22:
	movq $20, %rax			# Put a number in %rax
	movq %rax, -56(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	while_loop_0:
	movq $25, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -56(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jl comp_skip_15			# Skip if right side is less
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_15			# Skip the alternative branch
	comp_skip_15:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_15:
	cmp $0, %rax			# Check the condition
	je end_while_0			# Skip if the condition is false
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -56(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_31		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_31
	print_align_31:
	callq printf@plt		# Call printf
	end_print_31:
				# End print statement
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -56(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	movq %rax, %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq %rdx, -56(%rax)
	jmp while_loop_0		# Restart the loop
	end_while_0:
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	movq $26, %rax			# Put a number in %rax
	movq %rax, -64(%rbp)		# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Set dummy
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	while_loop_1:
	movq $55, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -56(%rax), %rax		# Assign value to %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -64(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	popq %rbx			# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	je comp_skip_16			# Skip if they are equal
	movq $1, %rax			# Put TRUE in %rax
	jmp comp_end_16			# Skip the alternative branch
	comp_skip_16:
	movq $0, %rax			# Put FALSE in %rax
	comp_end_16:
	cmp $0, %rax			# Check the condition
	je end_while_1			# Skip if the condition is false
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -64(%rax), %rax		# Assign value to %rax
				# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi			# Passing %rax (2. argument)
	movq $0, %rax			# No floating point registers used
	testq $15, %rsp			# Test for 16 byte alignment
	jz print_align_32		# Jump if aligned
	addq $-8, %rsp			# 16 byte aligning
	callq printf@plt		# Call printf
	addq $8, %rsp			# Reverting alignment
	jmp end_print_32
	print_align_32:
	callq printf@plt		# Call printf
	end_print_32:
				# End print statement
	movq $1, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq -64(%rax), %rax		# Assign value to %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Add both sides
	movq %rax, %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 16(%rax), %rax		# Traverse static link once
	movq %rdx, -64(%rax)
	jmp while_loop_1		# Restart the loop
	end_while_1:
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	addq $8, %rsp			# Remove dummy
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $64, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
