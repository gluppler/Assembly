global _start

section .text

_start:
    mov rdi, 21            ; Move 21 into the first argument register (rdi)
    call times2            ; Call the function times2 (rdi contains the argument 21)
    
    ; The result is now in rax (the return value from times2)
    ; You can use rax to pass the value to sys_exit if you want
    mov rdi, rax           ; Move the return value (42) into rdi for the exit status
    mov rax, 60            ; sys_exit (64-bit syscall number for exit)
    syscall                ; Exit the program with the return value as the exit status

;-----------------------------
; Function: times2
;-----------------------------
times2:
    ;------------------------
    ; Function Prologue
    ;------------------------
    push rbp               ; Save the base pointer
    mov rbp, rsp           ; Set up the new base pointer

    ;------------------------
    ; Function Body
    ;------------------------
    mov rax, rdi           ; Move the argument (21) from rdi into rax
    add rax, rax           ; Multiply rax by 2 (rax = rdi * 2)

    ;------------------------
    ; Function Epilogue
    ;------------------------
    mov rsp, rbp           ; Restore the original stack pointer
    pop rbp                ; Restore the base pointer
    ret                    ; Return the result in rax

