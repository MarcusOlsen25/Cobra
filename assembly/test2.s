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
gulerod:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Move heap pointer into %rcx
	pushq %rcx			# Push heap pointer
	addq $24, heap_pointer(%rip)			# Add size of object to heap pointer
	movq $8, %rax			# Put a number in %rax
	negq %rax			# Negate value
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -8(%rax), %rax		# Move value into %rax
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
melon:			# Class
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Move heap pointer into %rcx
	pushq %rcx			# Push heap pointer
	addq $24, heap_pointer(%rip)			# Add size of object to heap pointer
	movq $14, %rax			# Put a number in %rax
	pushq %rax			# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 24(%rax), %rax		# Traverse static link once
	movq -8(%rax), %rax		# Move value into %rax
	popq %rbx			# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, 8(%rcx)			# Move initialized value into space on heap
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax			# Push static link
	movq heap_pointer(%rip), %rax			# Move heap pointer into %rax
	pushq %rax			# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)			# Move initialized value into space on heap
	popq %rax			# Pop current heap pointer into %rax
	popq %rbp			# Restore base pointer
	ret				# End class
.globl main
main:
	pushq %rbp			# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $24, %rsp			# Allocate space for local variables on the stack
	movq $12, %rax			# Put a number in %rax
	movq %rax, -8(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	movq heap_pointer(%rip), %rax			# Move heap pointer into %rax
	pushq %rax			# Push heap pointer
	call gulerod			# Call gulerod constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -16(%rbp)			# Move initialized value into space on stack
	movq %rbp, %rax			# Prepare static link
	pushq %rax			# Push static link
	movq heap_pointer(%rip), %rax			# Move heap pointer into %rax
	pushq %rax			# Push heap pointer
	call melon			# Call melon constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -24(%rbp)			# Move initialized value into space on stack
	addq $24, %rsp			# Deallocate space for variables on the stack
	popq %rbp			# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
