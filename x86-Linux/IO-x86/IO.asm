section .data
    prompt_name db "Enter your name: ", 0
    prompt_age db "Enter your age: ", 0
    output_msg db "Hello, ", 0
    years_old db "You are ", 0
    years_old_suffix db " years old.", 10, 0
    name db 50 dup(0)           ; Reserve space for name
    age_input db 4 dup(0)       ; Buffer for age input (up to 3 digits + null terminator)

section .bss
    ; No uninitialized data here
    age resq 1                  ; Reserve space for age (64-bit integer)

section .text
    global _start               ; Entry point for the program

_start:
    ; Prompt for name
    mov rax, 1                  ; Syscall number for SYS_WRITE (1)
    mov rdi, 1                  ; File descriptor (1 for stdout)
    mov rsi, prompt_name        ; Address of the prompt message
    mov rdx, 17                 ; Length of the prompt message
    syscall                     ; Make the system call

    ; Read name from input (up to 50 characters)
    mov rax, 0                  ; Syscall number for SYS_READ (0)
    mov rdi, 0                  ; File descriptor (0 for stdin)
    mov rsi, name               ; Address of buffer to store input
    mov rdx, 50                 ; Number of bytes to read
    syscall                     ; Make the system call

    ; Prompt for age
    mov rax, 1                  ; Syscall number for SYS_WRITE
    mov rdi, 1                  ; File descriptor (1 for stdout)
    mov rsi, prompt_age         ; Address of the prompt message
    mov rdx, 15                 ; Length of the prompt message
    syscall                     ; Make the system call

    ; Read age input (up to 3 digits)
    mov rax, 0                  ; Syscall number for SYS_READ
    mov rdi, 0                  ; File descriptor (0 for stdin)
    mov rsi, age_input          ; Address of buffer to store input
    mov rdx, 4                  ; Read up to 4 bytes (3 digits + null terminator)
    syscall                     ; Make the system call

    ; Convert age input string to integer
    xor rax, rax                ; Clear rax (will store the resulting integer)
    xor rcx, rcx                ; Clear rcx (to use as an index)
    convert_loop:
        movzx rbx, byte [age_input + rcx]  ; Load the next character
        cmp rbx, 10                ; Check if it's a newline or null terminator
        je  done_convert           ; Exit loop if end of string
        sub rbx, '0'               ; Convert ASCII to numeric
        imul rax, rax, 10          ; Multiply accumulated result by 10
        add rax, rbx               ; Add the current digit
        inc rcx                    ; Increment index
        jmp convert_loop           ; Repeat until done
    done_convert:
    mov [age], rax                ; Store the resulting integer in 'age'

    ; Output greeting message "Hello, <name>"
    mov rax, 1                    ; Syscall number for SYS_WRITE
    mov rdi, 1                    ; File descriptor (1 for stdout)
    mov rsi, output_msg           ; Address of the "Hello, " message
    mov rdx, 7                    ; Length of the greeting message
    syscall                       ; Make the system call

    ; Output the name entered by the user
    mov rax, 1                    ; Syscall number for SYS_WRITE
    mov rdi, 1                    ; File descriptor (1 for stdout)
    mov rsi, name                 ; Address of name (input)
    mov rdx, 50                   ; Output up to 50 characters of the name
    syscall                       ; Make the system call

    ; Output "You are "
    mov rax, 1                    ; Syscall number for SYS_WRITE
    mov rdi, 1                    ; File descriptor (1 for stdout)
    mov rsi, years_old            ; Address of "You are " message
    mov rdx, 8                    ; Length of the message
    syscall                       ; Make the system call

    ; Convert and print the age
    mov rax, [age]                ; Load the age value
    call print_number             ; Call helper function to print the age

    ; Output " years old."
    mov rax, 1                    ; Syscall number for SYS_WRITE
    mov rdi, 1                    ; File descriptor (1 for stdout)
    mov rsi, years_old_suffix     ; Address of the "years old" suffix
    mov rdx, 14                   ; Length of the suffix message
    syscall                       ; Make the system call

    ; Exit the program
    mov rax, 60                   ; Syscall number for SYS_EXIT (60)
    xor rdi, rdi                  ; Exit status 0
    syscall                       ; Make the system call

; Helper function to print an integer in rax as a decimal string
print_number:
    mov rbx, 10                   ; Base 10
    xor rcx, rcx                  ; Clear rcx (digit counter)
    mov rdi, rsp                  ; Stack pointer (for temporary buffer)

    ; Loop to extract digits
    print_loop:
        xor rdx, rdx              ; Clear rdx
        div rbx                   ; Divide rax by 10, quotient in rax, remainder in rdx
        add dl, '0'               ; Convert remainder to ASCII
        dec rdi                   ; Move stack pointer down (storing digits in reverse)
        mov [rdi], dl             ; Store the ASCII character
        inc rcx                   ; Increment digit counter
        test rax, rax             ; Check if quotient is 0
        jnz print_loop            ; If not, repeat the loop

    ; Write the digits stored on the stack to stdout
    mov rax, 1                    ; Syscall number for SYS_WRITE
    mov rsi, rdi                  ; Address of the number (start of digits in stack)
    mov rdi, 1                    ; File descriptor for stdout
    mov rdx, rcx                  ; Number of digits to write
    syscall                       ; Make the system call
    ret


