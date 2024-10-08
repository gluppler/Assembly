section .data
    prompt db "Enter a number (1-3): ", 0        ; Prompt message
    msg1 db "You entered 1.", 10, 0              ; Message for case 1
    msg2 db "You entered 2.", 10, 0              ; Message for case 2
    msg3 db "You entered 3.", 10, 0              ; Message for case 3
    invalid db "Invalid input! Please enter a number between 1 and 3.", 10, 0  ; Invalid input message

section .bss
    num resb 1              ; Reserve space for the number
    buffer resb 4           ; Buffer to store input

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1              ; syscall number for write (1)
    mov rdi, 1              ; file descriptor for stdout (1)
    mov rsi, prompt         ; pointer to prompt message
    mov rdx, 20             ; length of the prompt message
    syscall                 ; make the system call

    ; Read input from stdin
    mov rax, 0              ; syscall number for read (0)
    mov rdi, 0              ; file descriptor for stdin (0)
    mov rsi, buffer         ; pointer to buffer to store input
    mov rdx, 4              ; number of bytes to read
    syscall                 ; make the system call

    ; Convert ASCII input to integer
    movzx rax, byte [buffer] ; Move input byte from buffer to rax (zero-extend)
    sub rax, '0'            ; Convert ASCII digit to integer

    ; Switch case to check the input value
    cmp rax, 1              ; Compare rax with 1
    je case1                ; Jump to case1 if equal
    cmp rax, 2              ; Compare rax with 2
    je case2                ; Jump to case2 if equal
    cmp rax, 3              ; Compare rax with 3
    je case3                ; Jump to case3 if equal
    jmp default_case        ; Jump to default_case if none of the above

case1:
    ; Case for input 1
    mov rax, 1              ; syscall number for write (1)
    mov rdi, 1              ; file descriptor for stdout (1)
    mov rsi, msg1           ; pointer to message 1
    mov rdx, 14             ; length of message 1
    syscall                 ; make the system call
    jmp end_switch          ; Jump to end of switch-case

case2:
    ; Case for input 2
    mov rax, 1              ; syscall number for write (1)
    mov rdi, 1              ; file descriptor for stdout (1)
    mov rsi, msg2           ; pointer to message 2
    mov rdx, 14             ; length of message 2
    syscall                 ; make the system call
    jmp end_switch          ; Jump to end of switch-case

case3:
    ; Case for input 3
    mov rax, 1              ; syscall number for write (1)
    mov rdi, 1              ; file descriptor for stdout (1)
    mov rsi, msg3           ; pointer to message 3
    mov rdx, 14             ; length of message 3
    syscall                 ; make the system call
    jmp end_switch          ; Jump to end of switch-case

default_case:
    ; Default case for invalid input
    mov rax, 1              ; syscall number for write (1)
    mov rdi, 1              ; file descriptor for stdout (1)
    mov rsi, invalid        ; pointer to invalid input message
    mov rdx, 46             ; length of invalid input message
    syscall                 ; make the system call

end_switch:
    ; Exit the program
    mov rax, 60             ; syscall number for exit (60)
    xor rdi, rdi            ; return code 0 (success)
    syscall                 ; make the system call to exit

