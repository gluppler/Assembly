section .data
    prompt db "Counting from 1 to 10:", 10, 0   ; Prompt message
    newline db 10, 0                            ; Newline character

section .bss
    num resq 1                                  ; Reserve space for current number (64-bit)
    buffer resb 4                               ; Reserve space for output buffer (ASCII)

section .text
    global _start                                ; Entry point for the program

_start:
    ; Print the prompt message to stdout
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, prompt                             ; Pointer to the prompt message
    mov rdx, 21                                 ; Length of the prompt message
    syscall                                     ; Invoke the syscall

    ; Initialize num to 1
    mov qword [num], 1                          ; Store the value 1 in num

while_loop:
    ; Load current number into rax for comparison
    mov rax, [num]                              ; Load num into rax
    cmp rax, 10                                 ; Compare num with 10
    jg end_while                                ; Jump to end_while if num > 10

    ; Convert the number to ASCII
    mov rbx, [num]                              ; Load num into rbx
    add rbx, '0'                                ; Convert the number to its ASCII equivalent

    ; Store the ASCII character in buffer
    mov [buffer], rbx                           ; Store ASCII character in buffer

    ; Print the current number (ASCII character)
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, buffer                             ; Pointer to buffer (containing ASCII character)
    mov rdx, 1                                  ; Length of the output (1 byte)
    syscall                                     ; Invoke the syscall

    ; Print a newline after each number
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, newline                            ; Pointer to newline character
    mov rdx, 1                                  ; Length of the newline
    syscall                                     ; Invoke the syscall

    ; Increment the number
    inc qword [num]                             ; Increment the value stored in num
    jmp while_loop                              ; Repeat the loop

end_while:
    ; Exit the program
    mov rax, 60                                 ; Syscall number for exit
    xor rdi, rdi                                ; Return code 0
    syscall                                     ; Invoke the syscall

