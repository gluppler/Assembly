section .data
    prompt db "shell> ", 0                            ; Prompt string
    error_msg db "Command failed.\n", 0               ; Error message
    exit_msg db "Exiting the shell. Goodbye!\n", 0    ; Exit message
    ls_command db "/bin/ls", 0                         ; Command for ls
    pwd_command db "/bin/pwd", 0                       ; Command for pwd
    exit_command db "exit", 0                          ; Exit command string

section .bss
    input resb 128                                     ; Reserve space for user input

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1                                         ; syscall: write
    mov rdi, 1                                         ; file descriptor: stdout
    mov rsi, prompt                                    ; pointer to prompt string
    mov rdx, 8                                         ; length of prompt
    syscall

    ; Read user input
    mov rax, 0                                         ; syscall: read
    mov rdi, 0                                         ; file descriptor: stdin
    mov rsi, input                                     ; pointer to input buffer
    mov rdx, 128                                       ; number of bytes to read
    syscall

    ; Null-terminate the input string
    mov byte [input + rax - 1], 0                     ; null-terminate

    ; Check for exit command
    cmp byte [input], 'e'                              ; Check for 'e' (start of "exit")
    je .exec_exit

    cmp byte [input], 'q'                              ; Check for 'q'
    je .exec_exit

    ; Check for ls command
    cmp byte [input], 'l'                              ; Check for 'l' (start of "ls")
    je .exec_ls

    ; Check for pwd command
    cmp byte [input], 'p'                              ; Check for 'p' (start of "pwd")
    je .exec_pwd

    ; If unrecognized command, print error message
    jmp print_error

.exec_exit:
    ; Print exit message
    mov rax, 1                                         ; syscall: write
    mov rdi, 1                                         ; file descriptor: stdout
    mov rsi, exit_msg                                  ; pointer to exit message
    mov rdx, 30                                        ; length of exit message
    syscall

    ; Exit the shell
    mov rax, 60                                        ; syscall: exit
    xor rdi, rdi                                       ; exit code 0
    syscall

.exec_ls:
    ; Execute ls command
    mov rax, 59                                        ; syscall number for execve
    lea rdi, [ls_command]                              ; Load address of the ls command
    xor rsi, rsi                                       ; No arguments
    xor rdx, rdx                                       ; No environment variables
    syscall                                            ; Call kernel

    ; If execve fails, print error message
    jmp print_error

.exec_pwd:
    ; Execute pwd command
    mov rax, 59                                        ; syscall number for execve
    lea rdi, [pwd_command]                             ; Load address of the pwd command
    xor rsi, rsi                                       ; No arguments
    xor rdx, rdx                                       ; No environment variables
    syscall                                            ; Call kernel

    ; If execve fails, print error message
    jmp print_error

print_error:
    ; Print error message
    mov rax, 1                                         ; syscall: write
    mov rdi, 1                                         ; file descriptor: stdout
    mov rsi, error_msg                                 ; pointer to error message
    mov rdx, 15                                        ; length of error message
    syscall

    ; Return to the start to read input again
    jmp _start                                         ; Loop back to the start


