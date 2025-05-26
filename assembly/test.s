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
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
# Start if statement 0
	movq $0, %rax			# Put a number in %rax
	cmp $0, %rax			# Check the condition
	je else_part_0			# Skip to the else if the condition is false
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $3, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi				# Passing %rax (2. argument)
	movq $0, %rax				# No floating point registers used
	testq $15, %rsp				# Test for 16 byte alignment
	jz print_align_0			# Jump if aligned
	addq $-8, %rsp				# 16 byte aligning
	callq printf@plt			# Call printf
	addq $8, %rsp				# Reverting alignment
	jmp end_print_0
print_align_0:
	callq printf@plt			# Call printf
end_print_0:
			# End print statement
end_then_0:					# Clean up then block stack frame
	popq %rbp				# Restore base pointer
	addq $24, %rsp			# Deallocate dummy spaces and static link
	jmp end_0				# Skip the else
else_part_0:
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	subq $16, %rsp			# Add dummy spaces
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $8, %rax			# Put a number in %rax
			# Start print statement
	leaq form(%rip), %rdi		# Passing string address (1. argument)
	movq %rax, %rsi				# Passing %rax (2. argument)
	movq $0, %rax				# No floating point registers used
	testq $15, %rsp				# Test for 16 byte alignment
	jz print_align_1			# Jump if aligned
	addq $-8, %rsp				# 16 byte aligning
	callq printf@plt			# Call printf
	addq $8, %rsp				# Reverting alignment
	jmp end_print_1
print_align_1:
	callq printf@plt			# Call printf
end_print_1:
			# End print statement
end_else_0:
	popq %rbp				# Restore base pointer
	addq $24, %rsp			# Deallocate dummy spaces and static link
end_0:
	popq %rbp				# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
