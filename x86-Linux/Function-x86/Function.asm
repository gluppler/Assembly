global _start

section .text

_start:
    call func             ; Call the function
    mov rax, 60           ; sys_exit (64-bit syscall number for exit)
    mov rdi, rbx          ; Move the value in rbx (42) to rdi (exit status)
    syscall               ; make the syscall

func:
    mov rbx, 42           ; Set rbx to 42
    pop rax               ; Pop return address into rax
    jmp rax               ; Jump to the return address

