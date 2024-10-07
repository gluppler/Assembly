section .text
    global _start

_start:
    sub rsp, 8              ; Allocate 8 bytes on the stack (aligned for 64-bit)

    mov byte [rsp], 'H'      ; Place 'H' on the stack
    mov byte [rsp+1], 'e'    ; Place 'e' on the stack
    mov byte [rsp+2], 'y'    ; Place 'y' on the stack
    mov byte [rsp+3], '!'    ; Place '!' on the stack

    ; sys_write (64-bit)
    mov rax, 1               ; syscall number for sys_write
    mov rdi, 1               ; file descriptor (stdout)
    mov rsi, rsp             ; pointer to the message on the stack
    mov rdx, 4               ; number of bytes to write
    syscall                  ; invoke the system call

    ; sys_exit (64-bit)
    mov rax, 60              ; syscall number for sys_exit
    xor rdi, rdi             ; exit code 0
    syscall                  ; invoke the system call

