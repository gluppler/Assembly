section .data
    addr db "yellow"          ; Define the string "yellow" in the .data section

section .text
    global _start

_start:
    mov byte [addr], 'H'      ; Replace 'y' in "yellow" with 'H'
    mov byte [addr+5], '!'    ; Replace 'w' in "yellow" with '!'

    ; sys_write (64-bit)
    mov rax, 1                ; syscall number for sys_write
    mov rdi, 1                ; file descriptor (stdout)
    mov rsi, addr             ; pointer to the string "Hello!"
    mov rdx, 6                ; number of bytes to write
    syscall                   ; perform the system call

    ; sys_exit (64-bit)
    mov rax, 60               ; syscall number for sys_exit
    xor rdi, rdi              ; exit code 0
    syscall                   ; perform the system call

