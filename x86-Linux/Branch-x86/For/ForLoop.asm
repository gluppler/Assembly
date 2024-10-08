section .data
    prompt db "Counting from 1 to 10:", 10, 0   ; Prompt message
    newline db 10, 0                            ; Newline character

section .bss
    buffer resb 4                               ; Buffer for output (4 bytes)

section .text
    global _start                               ; Entry point for the program

_start:
    ; Print the prompt message to stdout
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, prompt                             ; Pointer to the prompt message
    mov rdx, 21                                 ; Length of the prompt message
    syscall                                     ; Invoke the syscall

    ; Initialize i to 1
    mov rbx, 1                                  ; Initialize counter to 1 (rbx will act as i)

for_loop:
    cmp rbx, 11                                 ; Compare i with 11
    jge end_loop                                ; If i >= 11, exit the loop

    ; Convert the number in rbx to an ASCII string
    mov rax, rbx                                ; Move the current number into rax
    call int_to_ascii                           ; Call the function to convert the integer

    ; Print the current number (ASCII string)
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, buffer                             ; Pointer to the buffer containing the ASCII number
    mov rdx, 1                                  ; Length of the number (1 byte for single-digit numbers)
    syscall                                     ; Invoke the syscall

    ; Print a newline after each number
    mov rax, 1                                  ; Syscall number for write
    mov rdi, 1                                  ; File descriptor (stdout)
    mov rsi, newline                            ; Pointer to the newline character
    mov rdx, 1                                  ; Length of the newline
    syscall                                     ; Invoke the syscall

    ; Increment i
    inc rbx                                     ; Increment the value in rbx (i)
    jmp for_loop                                ; Repeat the loop

end_loop:
    ; Exit the program
    mov rax, 60                                 ; Syscall number for exit
    xor rdi, rdi                                ; Return code 0
    syscall                                     ; Invoke the syscall

; Function: int_to_ascii
; Converts an integer in RAX to its ASCII representation in 'buffer'
int_to_ascii:
    add rax, '0'                                ; Convert the integer to ASCII
    mov [buffer], al                            ; Store the ASCII character in the buffer
    ret

