//
// Example of 128-Bit addition with the ADD/ADC instructions.
//
.global _start               // Provide program starting address to linker
.align 4                     // Align the following data to a 4-byte boundary

// Load the registers with some data
// First 64-bit number is 0x0000000000000003FFFFFFFFFFFFFFFF
_start:
    MOV	X2, #0x0000000000000003      // Load lower part of the first number (0x0000000000000003) into X2
    MOV	X3, #0xFFFFFFFFFFFFFFFF      // Load upper part of the first number (0xFFFFFFFFFFFFFFFF) into X3
// Second 64-bit number is 0x00000000000000050000000000000001
    MOV	X4, #0x0000000000000005      // Load lower part of the second number (0x0000000000000005) into X4
    MOV	X5, #0x0000000000000001      // Load upper part of the second number (0x0000000000000001) into X5

    ADDS	X1, X3, X5	// Add lower order words: X3 + X5 (0xFFFFFFFFFFFFFFFF + 0x0000000000000001)
    ADC	X0, X2, X4	// Add higher order words with carry: X2 + X4 + carry from the previous addition

// Setup the parameters to exit the program
// and then call the kernel to do it.
// R0 is the return code and will be what we calculated above.
    MOV     X16, #1             // Load system call number 1 into X16 (exit)
    SVC     #0x80               // Call kernel to terminate the program

