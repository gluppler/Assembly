section .text
    global _start

_start:
    mov rcx, 101              ; Set rcx to 101
    mov rdi, 42               ; Exit status is 42
    mov rax, 60               ; syscall number for sys_exit
    cmp rcx, 100              ; Compare rcx to 100
    jl skip                   ; Jump if less than
    mov rdi, 13               ; Exit status is 13
skip:
    syscall                   ; Invoke system call

