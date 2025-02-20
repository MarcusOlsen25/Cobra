.section .data
    message: .asciz "Hello, World!\n"  # Define the string with a newline character

.section .text
    .global _start

_start:
    # sys_write system call
    mov $1, %rax                # syscall number (1 = sys_write)
    mov $1, %rdi                # file descriptor (1 = stdout)
    lea message(%rip), %rsi     # address of the message
    mov $14, %rdx               # message length (14 bytes)
    syscall                     # invoke the syscall

    # sys_exit system call
    mov $60, %rax               # syscall number (60 = sys_exit)
    xor %rdi, %rdi              # exit status code (0)
    syscall                     # invoke the syscall
