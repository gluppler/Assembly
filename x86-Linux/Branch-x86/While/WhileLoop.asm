section .bss
    count resq 1                ; Reserve space for a 64-bit integer (count)

section .text
    global _start               ; Entry point

_start:
    ; Initialize count to 1
    mov qword [count], 1        ; Store the value 1 in the count variable

.loop:
    ; Load count into rax
    mov rax, [count]            ; Move the value of count into rax (64-bit)

    ; Compare count with 5
    cmp rax, 5                  ; Compare rax with 5
    jg .end_loop                ; If count > 5, jump to end_loop

    ; Print the current count
    mov rdi, rax                ; Move the value of count to rdi (for syscall argument)
    call print_number           ; Call the print_number function to print it

    ; Print a newline character
    call print_newline           ; Call function to print newline

    ; Increment count
    inc qword [count]           ; Increment the count variable
    
    ; Jump back to the start of the loop
    jmp .loop                   ; Repeat the loop

.end_loop:
    ; Exit the program
    mov rax, 60                 ; Syscall number for exit (sys_exit)
    xor rdi, rdi                ; Exit code 0
    syscall                     ; Make the syscall to exit

; -------------------------------------------------------
; print_number: Prints the number in rdi
; -------------------------------------------------------
print_number:
    ; Convert the number in rdi to its ASCII value using the digit_table
    mov rax, digit_table        ; Load the base address of the digit_table into rax
    add rax, rdi                ; Add the value in rdi to get the right digit
    
    ; Syscall to write the number to stdout
    mov rdi, 1                  ; File descriptor 1 (stdout)
    mov rsi, rax                ; Move the address of the digit into rsi
    mov rdx, 1                  ; Print 1 character (just the number)
    mov rax, 1                  ; Syscall number for write (sys_write)
    syscall                     ; Make the syscall
    ret                         ; Return to the caller

; -------------------------------------------------------
; print_newline: Prints a newline character
; -------------------------------------------------------
print_newline:
    mov rax, 1                  ; Syscall number for write (sys_write)
    mov rdi, 1                  ; File descriptor 1 (stdout)
    lea rsi, [newline]          ; Load the address of newline into rsi
    mov rdx, 1                  ; Print 1 character (newline)
    syscall                     ; Make the syscall
    ret                         ; Return to the caller

section .data
    digit_table db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    newline db 10               ; Newline character
