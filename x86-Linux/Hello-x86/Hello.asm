section .data
    msg db "Hello, world!", 0x0a  ; Message to print
    len equ $ - msg                ; Length of the message

section .text
    global _start

_start:
    mov rax, 1                     ; syscall number for sys_write
    mov rdi, 1                     ; stdout file descriptor
    mov rsi, msg                   ; pointer to the message
    mov rdx, len                   ; number of bytes to write
    syscall                        ; invoke the syscall

    mov rax, 60                    ; syscall number for sys_exit
    xor rdi, rdi                   ; exit status 0
    syscall                        ; invoke the syscall

