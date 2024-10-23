section .data
    num1 dq 0x123456789ABCDEF0     ; Example 64-bit number
    num2 dq 0xFEDCBA9876543210     ; Another 64-bit number
    result dq 0                    ; Variable to store the result
    newline db 10                  ; Newline character

section .bss
    num_str resb 21                ; Buffer to hold the string representation of the number

section .text
    global _start

_start:
    ; 1. AND (rax = num1 AND num2)
    mov rax, [num1]                ; Load num1 into rax
    and rax, [num2]                ; Perform bitwise AND with num2
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 2. OR (rax = num1 OR num2)
    mov rax, [num1]                ; Load num1 into rax
    or rax, [num2]                 ; Perform bitwise OR with num2
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 3. XOR (rax = num1 XOR num2)
    mov rax, [num1]                ; Load num1 into rax
    xor rax, [num2]                ; Perform bitwise XOR with num2
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 4. NOT (rax = NOT num1)
    mov rax, [num1]                ; Load num1 into rax
    not rax                         ; Invert all bits in rax
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 5. SHL (rax = num1 << 1) - Shift left by 1
    mov rax, [num1]                ; Load num1 into rax
    shl rax, 1                      ; Shift left by 1 bit
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 6. SHR (rax = num1 >> 1) - Shift right by 1
    mov rax, [num1]                ; Load num1 into rax
    shr rax, 1                      ; Shift right by 1 bit
    mov [result], rax              ; Store the result
    call print_number_hex           ; Print the result in hex
    call print_newline              ; Print a newline

    ; 7. Exit system call
    mov rax, 60                    ; Syscall number for exit
    xor rdi, rdi                   ; Exit code 0
    syscall

; Subroutine to convert and print the number in rax as hexadecimal
print_number_hex:
    ; Convert the number in rax to a hexadecimal string and store it in num_str
    mov rdi, num_str               ; rdi = pointer to num_str buffer
    mov rcx, 0                     ; Digit counter (used to calculate the string length)

    ; Handle zero case
    test rax, rax
    jz .zero_case

.convert_digits:
    mov rbx, 16                    ; Base for hexadecimal
    xor rdx, rdx                   ; Clear rdx for division
    div rbx                        ; Divide rax by 16, quotient in rax, remainder in rdx
    add dl, '0'                    ; Convert remainder to ASCII
    cmp dl, '9'                    ; Check if it's a digit
    jbe .store                     ; If it's a digit, store it
    add dl, 7                      ; Adjust for hex letters (A-F)

.store:
    mov [rdi], dl                  ; Store the ASCII hex digit in the buffer
    inc rdi                        ; Move the pointer forward
    inc rcx                        ; Increment the digit counter
    test rax, rax                  ; Check if quotient is 0
    jnz .convert_digits            ; If not, continue

.done_conversion:
    ; Null-terminate the string
    mov byte [rdi], 0
    call reverse_string            ; Reverse the string to correct order
    call print_string              ; Print the converted hexadecimal string
    ret

.zero_case:
    mov byte [rdi], '0'            ; If the number is zero, store '0'
    inc rdi
    mov byte [rdi], 0               ; Null-terminate the string
    call print_string               ; Print the zero case
    ret

; Subroutine to reverse the string in num_str
reverse_string:
    mov rdi, num_str               ; rdi = start of the string
    mov rsi, rdi                   ; rsi = start of the actual digits
    add rdi, rcx                   ; rdi now points to the end of the string (null terminator)
    dec rdi                        ; Move to the last digit (before null terminator)

.reverse_loop:
    cmp rsi, rdi                   ; Check if we have finished reversing
    jge .done
    ; Swap the characters at rsi and rdi
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi                        ; Move forward from the start
    dec rdi                        ; Move backward from the end
    jmp .reverse_loop              ; Repeat until done
.done:
    ret

; Subroutine to print the string pointed to by rdi
print_string:
    mov rax, 1                     ; Syscall number for write
    mov rdi, 1                     ; File descriptor (stdout)
    mov rsi, num_str               ; Pointer to the string to print
    mov rdx, rcx                   ; Number of bytes to print
    syscall
    ret

; Subroutine to print a newline
print_newline:
    mov rax, 1                     ; Syscall number for write
    mov rdi, 1                     ; File descriptor (stdout)
    mov rsi, newline               ; Pointer to newline character
    mov rdx, 1                     ; Number of bytes (1 byte for newline)
    syscall
    ret


