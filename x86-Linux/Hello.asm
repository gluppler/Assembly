section .data
    hello db 'Hello, World!', 0xA  ; The string and newline (0xA is the newline character)

section .text
    global _start                 ; Entry point for the linker

_start:
    ; Write the string to stdout (file descriptor 1)
    mov rax, 1                    ; sys_write system call number
    mov rdi, 1                    ; File descriptor (1 = stdout)
    mov rsi, hello                ; Address of the string to output
    mov rdx, 14                   ; Length of the string
    syscall                       ; Invoke the system call

    ; Exit the program
    mov rax, 60                   ; sys_exit system call number
    xor rdi, rdi                  ; Exit code (0)
    syscall                       ; Invoke the system call

