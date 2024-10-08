section .data                ; Data section for storing messages
greater_msg db 'Greater than 5', 0xA  ; Message for the "if" condition
greater_len equ $ - greater_msg         ; Length of the "greater" message

not_greater_msg db 'Not greater than 5', 0xA  ; Message for the "else" condition
not_greater_len equ $ - not_greater_msg       ; Length of the "not greater" message

section .text                ; Code section
global _start                ; Entry point for the program

_start:                      ; Function: _start
    ;------------------------
    ; Initialize the Number
    ;------------------------
    mov rax, 10              ; Load the number (10) into rax
    cmp rax, 5               ; Compare rax with 5

    ;------------------------
    ; If-Then-Else Logic
    ;------------------------
    jg greater               ; Jump to greater if rax > 5 (if condition)

    ; Else case
    mov rax, 1               ; syscall number for write (sys_write)
    mov rdi, 1               ; file descriptor 1 (stdout)
    mov rsi, not_greater_msg  ; Address of the else message
    mov rdx, not_greater_len  ; Length of the else message
    syscall                   ; Call kernel to write "Not greater than 5"
    jmp end_if               ; Jump to end_if

greater:
    mov rax, 1               ; syscall number for write (sys_write)
    mov rdi, 1               ; file descriptor 1 (stdout)
    mov rsi, greater_msg      ; Address of the if message
    mov rdx, greater_len      ; Length of the if message
    syscall                   ; Call kernel to write "Greater than 5"

end_if:
    ;------------------------
    ; Exit the Program
    ;------------------------
    mov rax, 60              ; syscall number for exit (sys_exit)
    xor rdi, rdi             ; Return 0
    syscall                   ; Call kernel to exit the program

