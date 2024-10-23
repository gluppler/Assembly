section .data
    num1 dq 50                ; 64-bit number
    num2 dq 10                ; Another 64-bit number
    result dq 0               ; Variable to store the result
    newline db 10             ; Newline character

section .bss
    num_str resb 21           ; Buffer to hold the string representation of the number (20 digits max for 64-bit + null terminator)

section .text
    global _start

_start:
    ; 1. Addition (rax = num1 + num2)
    mov rax, [num1]           ; Load num1 into rax
    add rax, [num2]           ; Add num2 to rax
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 2. Subtraction (rax = num1 - num2)
    mov rax, [num1]           ; Load num1 into rax
    sub rax, [num2]           ; Subtract num2 from rax
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 3. Multiplication (rax = num1 * num2)
    mov rax, [num1]           ; Load num1 into rax
    mov rbx, [num2]           ; Load num2 into rbx
    mul rbx                   ; Multiply rax by rbx (result in rdx:rax)
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 4. Division (rax = num1 / num2)
    mov rax, [num1]           ; Load num1 into rax
    mov rbx, [num2]           ; Load num2 into rbx
    xor rdx, rdx              ; Clear rdx (needed for 64-bit division)
    div rbx                   ; Divide rax by rbx (quotient in rax)
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 5. Increment (rax = num1 + 1)
    mov rax, [num1]           ; Load num1 into rax
    inc rax                   ; Increment rax by 1
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 6. Decrement (rax = num1 - 1)
    mov rax, [num1]           ; Load num1 into rax
    dec rax                   ; Decrement rax by 1
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 7. Negation (rax = -num1)
    mov rax, [num1]           ; Load num1 into rax
    neg rax                   ; Negate rax
    mov [result], rax         ; Store the result in memory
    call print_number         ; Convert and print the result

    ; 8. Exit system call
    mov rax, 60               ; Syscall number for exit
    xor rdi, rdi              ; Exit code 0
    syscall

; Subroutine to convert and print the number in rax
print_number:
    ; Convert the number in rax to a string and store it in num_str
    mov rdi, num_str          ; rdi = pointer to num_str buffer
    call int_to_ascii         ; Call conversion routine
    call reverse_string       ; Reverse the digits in the string
    call print_string         ; Print the resulting string
    call print_newline        ; Print a newline
    ret

; Subroutine to convert integer in rax to ASCII string (stored in num_str)
int_to_ascii:
    mov rbx, 10               ; Divisor for mod 10
    mov rcx, 0                ; Digit counter (used to calculate the string length)
    mov rsi, rdi              ; Save the starting pointer

    ; Check if the number is negative
    test rax, rax
    jns .convert               ; If positive or zero, skip negation
    neg rax                    ; If negative, negate rax to make it positive
    mov byte [rdi], '-'        ; Store the negative sign in the buffer
    inc rdi                    ; Move to the next position in the buffer
    inc rcx                    ; Account for the negative sign in the length

.convert:
    ; Handle zero case
    cmp rax, 0
    jne .convert_digits
    mov byte [rdi], '0'
    inc rdi
    inc rcx                    ; Account for the '0' character
    mov byte [rdi], 0
    ret

.convert_digits:
    ; Convert digits from least significant to most significant
    .loop:
        xor rdx, rdx          ; Clear rdx for division
        div rbx               ; Divide rax by 10, quotient in rax, remainder in rdx
        add dl, '0'           ; Convert remainder (digit) to ASCII
        mov [rdi], dl         ; Store the ASCII digit in the buffer
        inc rdi               ; Move the pointer forward
        inc rcx               ; Increment the digit counter
        test rax, rax         ; Check if quotient is 0
        jnz .loop             ; If not, continue

    ; Null-terminate the string
    mov byte [rdi], 0
    ret

; Subroutine to reverse the string in num_str
reverse_string:
    ; If there’s a negative sign, skip it
    mov rdi, num_str          ; rdi = start of the string
    cmp byte [rdi], '-'       ; Check if the first character is '-'
    jne .skip_neg
    inc rdi                   ; Move past the negative sign
.skip_neg:
    mov rsi, rdi              ; rsi = start of the actual digits
    mov rdi, num_str          ; Reset rdi to point to the beginning
    add rdi, rcx              ; rdi now points to the end of the string (null terminator)
    dec rdi                   ; Move to the last digit (before null terminator)

.reverse_loop:
    cmp rsi, rdi              ; Check if we have finished reversing
    jge .done
    ; Swap the characters at rsi and rdi
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi                   ; Move forward from the start
    dec rdi                   ; Move backward from the end
    jmp .reverse_loop         ; Repeat until done
.done:
    ret

; Subroutine to print the string pointed to by rdi
print_string:
    mov rax, 1                ; Syscall number for write
    mov rdi, 1                ; File descriptor (stdout)
    mov rsi, num_str          ; Pointer to the string to print
    mov rdx, rcx              ; Number of bytes to print
    syscall
    ret

; Subroutine to print a newline
print_newline:
    mov rax, 1                ; Syscall number for write
    mov rdi, 1                ; File descriptor (stdout)
    mov rsi, newline          ; Pointer to newline character
    mov rdx, 1                ; Number of bytes (1 byte for newline)
    syscall
    ret

