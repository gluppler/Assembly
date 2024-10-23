section .data
    my_data dq 12345678       ; 64-bit data in memory
    my_string db 'Hello!', 0   ; Null-terminated string in memory
    newline db 10              ; Newline character

section .bss
    buffer resb 64             ; Allocate a 64-byte buffer in uninitialized data section (BSS)

section .text
    global _start

_start:
    ; 1. Register-to-Register Transfer
    mov rax, rbx               ; Copy the value of rbx into rax

    ; 2. Immediate-to-Register Transfer
    mov rax, 100               ; Load the immediate value 100 into rax

    ; 3. Memory-to-Register Transfer (64-bit)
    mov rax, [my_data]         ; Load the value at memory location my_data into rax

    ; 4. Register-to-Memory Transfer (64-bit)
    mov [my_data], rax         ; Store the value of rax into memory at location my_data

    ; 5. Immediate-to-Memory Transfer (64-bit)
    mov qword [my_data], 987654321 ; Store the immediate 64-bit value into memory

    ; 6. Memory-to-Memory Transfer (via Registers)
    mov rax, [my_data]         ; Load the value at my_data into rax
    mov [buffer], rax          ; Store the value in rax into the buffer

    ; 7. String Data Transfer
    mov rsi, my_string         ; Load address of my_string into rsi
    mov rdi, buffer            ; Load address of buffer into rdi
    mov rcx, 7                 ; Move 7 (length of 'Hello!') into rcx
    rep movsb                  ; Copy string from my_string to buffer

    ; 8. PUSH and POP (Stack Operations)
    push rax                   ; Push the value of rax onto the stack
    pop rbx                    ; Pop the top value from the stack into rbx

    ; 9. LEA (Load Effective Address)
    lea rax, [my_data]         ; Load the address of my_data into rax
    lea rbx, [buffer + 10]     ; Load the address of buffer offset by 10 bytes into rbx

    ; Print the contents of the buffer (which now holds 'Hello!')
    mov rax, 1                 ; Syscall number for write (1)
    mov rdi, 1                 ; File descriptor (stdout)
    mov rsi, buffer            ; Pointer to buffer (the string 'Hello!')
    mov rdx, 7                 ; Number of bytes to write (7 for 'Hello!\0')
    syscall                    ; Make the system call to print the string

    ; Print a newline
    mov rax, 1                 ; Syscall number for write (1)
    mov rdi, 1                 ; File descriptor (stdout)
    mov rsi, newline           ; Pointer to newline character
    mov rdx, 1                 ; Number of bytes (1 for newline)
    syscall                    ; Make the system call to print newline

    ; Exit system call
    mov rax, 60                ; Syscall number for exit (60)
    xor rdi, rdi               ; Exit code 0
    syscall

