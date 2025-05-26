.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
.text
one:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq $3, %rax			# Put a number in %rax
	jmp end_one
end_one:			# End function
	popq %rbp				# Restore base pointer
	ret						# Return from the function
.globl main
main:
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call one			# Call the one function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	popq %rbp				# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
