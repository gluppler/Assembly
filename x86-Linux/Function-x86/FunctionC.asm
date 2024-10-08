global main              ; Entry point for the program
extern printf            ; External function declaration for printf

section .rodata          ; Read-only data section
msg db "Testing %i...", 0x0a, 0x00  ; Message format with newline

section .text            ; Code section
main:                   ; Function: main
    ;------------------------
    ; Function Prologue
    ;------------------------
    push rbp              ; Save the base pointer (for stack frame)
    mov rbp, rsp          ; Set up the new base pointer

    ;------------------------
    ; Stack Alignment
    ;------------------------
    sub rsp, 16           ; Align stack to 16 bytes (8 for printf's alignment, 8 for local storage)

    ;------------------------
    ; Pass Arguments to printf
    ;------------------------
    mov edi, msg          ; Argument 1: Address of the format string (msg) in rdi
    mov esi, 123          ; Argument 2: Integer value (123) in rsi

    ;------------------------
    ; Function Call
    ;------------------------
    call printf           ; Call the C function printf

    ;------------------------
    ; Function Epilogue
    ;------------------------
    mov eax, 0            ; Return value: 0 (indicating successful execution)
    leave                 ; Clean up the stack and restore the base pointer
    ret                   ; Return from main

section .note.GNU-stack  ; Explicitly indicate non-executable stack

