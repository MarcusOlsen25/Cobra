.data
heap:
	.space 1000
heap_pointer:
	.quad heap
form:
	.string "%d\n"
c_one_descriptor:
	.quad get_c_one
c_two_descriptor:
	.quad get_c_two
c_three_descriptor:
	.quad get_c_three
c_four_descriptor:
	.quad get_c_four
c_five_descriptor:
	.quad get_c_five
c_six_descriptor:
	.quad get_c_six
c_seven_descriptor:
	.quad get_c_seven
c_eight_descriptor:
	.quad get_c_eight
c_nine_descriptor:
	.quad get_c_nine
c_ten_descriptor:
	.quad get_c_ten
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
c_one:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $1, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_one:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 8(%rax), %rax		# Move value into %rax
	jmp end_get_c_one
end_get_c_one:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_two:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $2, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $16, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_one_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_one			# Call c_one constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_two:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_two
end_get_c_two:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_three:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $3, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_two_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_two			# Call c_two constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_three:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_three
end_get_c_three:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_four:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $4, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_three_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_three			# Call c_three constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_four:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_four
end_get_c_four:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_five:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $5, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_four_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_four			# Call c_four constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_five:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_five
end_get_c_five:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_six:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $6, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_five_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_five			# Call c_five constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_six:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_six
end_get_c_six:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_seven:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $7, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_six_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_six			# Call c_six constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_seven:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_seven
end_get_c_seven:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_eight:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $8, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_seven_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_seven			# Call c_seven constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_eight:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_eight
end_get_c_eight:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_nine:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $9, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_eight_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_eight			# Call c_eight constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_nine:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_nine
end_get_c_nine:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
c_ten:			# Class
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	movq 16(%rbp), %rcx			# Push heap pointer
	pushq %rcx				# Push heap pointer
	movq $10, %rax			# Put a number in %rax
	movq %rax, 8(%rcx)		# Move initialized value into space on heap
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_nine_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_nine			# Call c_nine constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, 16(%rcx)		# Move initialized value into space on heap
	popq %rax				# Pop current heap pointer into %rax
	popq %rbp				# Restore base pointer
	ret						# End class
get_c_ten:			# Method
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq 32(%rax), %rax		# Move value into %rax
	movq 16(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	jmp end_get_c_ten
end_get_c_ten:
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the method
add:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
end_add:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
sub:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
end_sub:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
mult:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	imulq %rbx, %rax		# Perform multiplication
end_mult:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
div:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $0, %rsp			# Allocate space for local variables on the stack
	movq $3, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq $3, %rax			# Put a number in %rax
	popq %rbx				# Pop right side into %rbx
	movq $0, %rdx			# Put a 0 in %rdx to prepare for the division
	idivq %rbx			# Perform division
end_div:			# End function
	addq $0, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
loop:			# Function
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $8, %rsp			# Allocate space for local variables on the stack
	movq $1, %rax			# Put a number in %rax
	negq %rax				# Negate value
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
# Start while statement 2
while_loop_2:
	movq $1000, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_2			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_2			# Skip the alternative branch
comp_skip_2:
	movq $0, %rax			# Put false in %rax
comp_end_2:
	cmp $0, %rax			# Check the condition
	je end_while_2			# Skip if the condition is false
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -8(%rax)		# Move right side into location of left side of assign
	movq $1, %rax			# Put a number in %rax
	negq %rax				# Negate value
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
# Start while statement 3
while_loop_3:
	movq $1000, %rax			# Put a number in %rax
	negq %rax				# Negate value
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jge comp_skip_3			# Skip if right side is greater or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_3			# Skip the alternative branch
comp_skip_3:
	movq $0, %rax			# Put false in %rax
comp_end_3:
	cmp $0, %rax			# Check the condition
	je end_while_3			# Skip if the condition is false
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	subq %rbx, %rax			# Perform subtraction
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -16(%rax)		# Move right side into location of left side of assign
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call add			# Call the add function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call sub			# Call the sub function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call mult			# Call the mult function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	movq %rbp, %rax			# Prepare static link
	movq 24(%rax), %rax		# Traverse static link once
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call div			# Call the div function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	jmp while_loop_3		# Restart the loop
end_while_3:
	jmp while_loop_2		# Restart the loop
end_while_2:
end_loop:			# End function
	addq $8, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	ret						# Return from the function
.globl main
main:
	pushq %rbp				# Save base pointer
	movq %rsp, %rbp			# Make stack pointer new base pointer
	subq $24, %rsp			# Allocate space for local variables on the stack
	movq heap_pointer(%rip), %rcx			# Move heap pointer into %rcx
	addq $24, heap_pointer(%rip)	# Add size of object to heap pointer
	leaq c_ten_descriptor(%rip), %rax	# Move class descriptor into %rax
	movq %rax, (%rcx)			# Move class descriptor into object
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	pushq %rcx				# Push heap pointer
	call c_ten			# Call c_ten constructor
	movq 16(%rbp), %rcx			# Move potential heap pointer into %rcx
	addq $8, %rsp			# Deallocate space on stack for heap pointer
	addq $8, %rsp			# Deallocate space on stack for static link
	movq %rax, -8(%rbp)		# Move initialized value into space on stack
	movq $0, %rax			# Put a number in %rax
	movq %rax, -16(%rbp)		# Move initialized value into space on stack
	movq $0, %rax			# Put a number in %rax
	movq %rax, -24(%rbp)		# Move initialized value into space on stack
# Start while statement 0
while_loop_0:
	movq $10000, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_0			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_0			# Skip the alternative branch
comp_skip_0:
	movq $0, %rax			# Put false in %rax
comp_end_0:
	cmp $0, %rax			# Check the condition
	je end_while_0			# Skip if the condition is false
	movq $1, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -16(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -16(%rax)		# Move right side into location of left side of assign
# Start while statement 1
while_loop_1:
	movq $10000, %rax			# Put a number in %rax
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	cmp %rax, %rbx			# Compare both sides
	jle comp_skip_1			# Skip if right side is less or equal
	movq $1, %rax			# Put true in %rax
	jmp comp_end_1			# Skip the alternative branch
comp_skip_1:
	movq $0, %rax			# Put false in %rax
comp_end_1:
	cmp $0, %rax			# Check the condition
	je end_while_1			# Skip if the condition is false
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -8(%rax), %rax		# Move value into %rax
	pushq %rax				# Push heap pointer to be used as argument
	movq (%rax), %rax		# Move value into %rax
	movq 0(%rax), %rax			# Move method address into %rax
	movq %rax, %r9			# Move method address into r9
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	movq %r9, %rax			# Move heap pointer into r9
	call *%rax				# Call method
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $8, %rsp			# Pop the arguments pushed to the stack
	pushq %rax				# Push right side to stack
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	popq %rbx				# Pop right side into %rbx
	addq %rbx, %rax			# Perform addition
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -24(%rax)		# Move right side into location of left side of assign
	jmp while_loop_1		# Restart the loop
end_while_1:
	movq $0, %rax			# Put a number in %rax
	movq %rax, %rdx			# Move right side of assignment into %rdx
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq -24(%rax), %rax		# Move value into %rax
	movq %rbp, %rax			# Prepare to access variable from another scope
	movq %rdx, -24(%rax)		# Move right side into location of left side of assign
	jmp while_loop_0		# Restart the loop
end_while_0:
	movq %rbp, %rax			# Prepare static link
	pushq %rax				# Push static link
	subq $8, %rsp			# Add dummy space
	call loop			# Call the loop function
	addq $8, %rsp			# Remove dummy space
	addq $8, %rsp			# Deallocate space on stack for static link
	addq $0, %rsp			# Pop the arguments pushed to the stack
	addq $24, %rsp			# Deallocate space for local variables on the stack
	popq %rbp				# Restore base pointer
	movq $0, %rax			# End with error code 0
	ret			# Return from main
.section .note.GNU-stack
