.data
heap:
	.space 1000
heap_pointer:
	.quad heap
class_descriptor:
	.space 100
form:
	.string "%d\n"
.text
one:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	jmp end_one
end_one:			# End function
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
two:			# Function
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $4, %rax			# Put a number in %rax
	jmp end_two
end_two:			# End function
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	ret				# Return from the function
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 2 to stack
	movq $4, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Dummy space
	call one			# Call the one function 
	addq $8, %rsp			# Dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $16, %rsp			# Pop the arguments pushed to the stack
	movq $6, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 2 to stack
	movq $5, %rax			# Put a number in %rax
	pushq %rax			# Push argument number 1 to stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	subq $8, %rsp			# Dummy space
	call two			# Call the two function 
	addq $8, %rsp			# Dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $16, %rsp			# Pop the arguments pushed to the stack
	addq $0, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
