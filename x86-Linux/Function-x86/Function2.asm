global _start

section .text

_start:
    call func              ; Function call
    mov rax, 60            ; sys_exit (64-bit syscall number for exit)
    xor rdi, rdi           ; exit status 0
    syscall                ; make the syscall (program ends here)

;-----------------------------
; Function: func
;-----------------------------
func:
    ;------------------------
    ; Function Prologue
    ;------------------------
    mov rbp, rsp           ; Save the current stack pointer (start of prologue)
    sub rsp, 8             ; Allocate 8 bytes on the stack (alignment for 64-bit)

    ;------------------------
    ; Function Body
    ;------------------------
    mov byte [rsp], 'H'    ; Store 'H' at the new top of the stack
    mov byte [rsp+1], 'i'  ; Store 'i' at the next byte

    mov rax, 1             ; sys_write (64-bit syscall number for write)
    mov rdi, 1             ; file descriptor 1 (stdout)
    mov rsi, rsp           ; pointer to the buffer (our 'Hi' string)
    mov rdx, 2             ; length of the string (2 bytes)
    syscall                ; make the syscall (write "Hi" to stdout)

    ;------------------------
    ; Function Epilogue
    ;------------------------
    pop rax                ; Pop the top value from the stack (restores original `rsp`)
    mov rsp, rbp           ; Restore the original stack pointer (end of epilogue)
    ret                    ; Return to the caller

