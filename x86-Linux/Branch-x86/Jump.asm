section .data
    message db 'Result: ', 0     ; Buffer to hold the message (ASCIZ format)
    num_buffer db '  ', 0         ; Buffer to hold the number as a string (ASCIZ format)
    msg_len equ $ - message        ; Length of the message string

section .text
    global _start

_start:
    mov rbx, 1                    ; Start rbx at 1
    mov rcx, 4                    ; Number of iterations

label:
    add rbx, rbx                  ; rbx += rbx (double the value)
    dec rcx                       ; rcx -= 1
    cmp rcx, 0                    ; Compare rcx with 0
    jg label                      ; Jump to label if rcx > 0

    ; Convert rbx (16) to string in num_buffer
    mov rdi, rbx                  ; Move the value to convert (16)
    mov rsi, num_buffer           ; Pointer to the buffer for the number
    call itoa                     ; Convert to ASCII string

    ; Print the message "Result: "
    mov rax, 1                    ; syscall number for sys_write
    mov rdi, 1                    ; file descriptor (stdout)
    mov rsi, message              ; Pointer to the message
    mov rdx, msg_len              ; Number of bytes to write (length of "Result: ")
    syscall                       ; Print "Result: "

    ; Print the converted number
    mov rax, 1                    ; syscall number for sys_write
    mov rdi, 1                    ; file descriptor (stdout)
    mov rsi, num_buffer           ; Pointer to the converted number
    mov rdx, 2                    ; Length of the converted number string
    syscall                       ; Print the number

    ; Exit the program
    mov rax, 60                   ; syscall number for sys_exit
    xor rdi, rdi                  ; exit code 0
    syscall                       ; invoke system call

; Convert integer in rdi to string in rsi
itoa:
    mov rax, rdi                  ; Move the integer to rax
    mov rcx, 10                   ; Divisor (10)
    mov rbx, rsi                  ; Store the start of the string

    ; Zero out the buffer
    mov byte [rbx], 0             ; Set first byte to 0 for null termination

itoa_loop:
    xor rdx, rdx                  ; Clear rdx before division
    div rcx                        ; Divide rax by 10, quotient in rax, remainder in rdx
    add dl, '0'                   ; Convert remainder to ASCII
    dec rbx                       ; Move backwards in the buffer
    mov [rbx], dl                 ; Store ASCII character
    test rax, rax                 ; Check if the quotient is zero
    jnz itoa_loop                 ; Repeat until the quotient is zero

    ; Set the number string's start position
    mov rsi, rbx                  ; Set rsi to the start of the number string
    ret                           ; Return to caller

