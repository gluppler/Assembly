//
// Examples of the ADD/MOVN instructions.
//
.global _start              // Make the _start label visible to the linker
.align 4                    // Align the following code to a 4-byte boundary

// Entry point of the program
_start:
    MOVN    W0, #2         // Load the value -2 into W0 (negative value is achieved using MOVN)
                            // W0 = 0xFFFFFFFE (which represents -2 in 32-bit two's complement)

    ADD     W0, W0, #1     // Add 1 to the value in W0
                            // W0 = W0 + 1 = -2 + 1 = -1
                            // After this operation, W0 = 0xFFFFFFFF (which represents -1 in 32-bit two's complement)

    // Prepare to print the result
    MOV     X0, #1         // File descriptor 1 is stdout
    ADR     X1, result_msg // Load the address of the result message string
    MOV     X2, #14        // Length of the message string
    MOV     X16, #4        // System call number for write
    SVC     #0x80          // Call kernel to write the message to stdout

    // Prepare to exit the program
    MOV     X16, #1        // Load the system call number for exit into X16
    SVC     #0x80          // Trigger the system call to exit the program

// String to print
result_msg:
    .asciz "Result: -1\n"  // The message to be printed, including a newline

