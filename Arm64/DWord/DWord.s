//
// Assembler program to print a register in hex
// to stdout.
//
// X0-X2 - parameters to Linux function services
// X1 - is also the address of the byte we are writing
// X4 - register to print (in this case, it's a QWORD)
// W5 - loop index
// W6 - current character
// X8 - Linux function number
//
// Note: The term "printdword" refers to printing a double word
// (DWORD) value. In this context, we are actually printing a 64-bit
// (QWORD) value stored in the X4 register, even though the function
// might be conceptually aligned with printing 32-bit integers.

.global _start   // Provide program starting address
.align 4

_start:
    // Initialize X4 with a 64-bit value composed of multiple parts
    MOV     X4, #0x6E3A                 // Load the lower part of the number into X4
    MOVK    X4, #0x4F5D, LSL #16         // Move the next part (bits 16-31)
    MOVK    X4, #0xFEDC, LSL #32         // Move the next part (bits 32-47)
    MOVK    X4, #0x1234, LSL #48         // Move the highest part (bits 48-63)

    // Set X1 to the end of the destination string for hex output
    ADRP    X1, hexstr@PAGE              // Load the page address of hexstr
    ADD     X1, X1, hexstr@PAGEOFF       // Calculate the full address of hexstr
    ADD     X1, X1, #17                   // Move to the end of the string (space for 16 hex digits + null terminator)

    // The loop to convert the QWORD in X4 to hex
    MOV     W5, #16                       // Initialize W5 with the number of hex digits to print (16)
loop:
    AND     W6, W4, #0xf                  // Mask to get the least significant digit (4 bits)
    CMP     W6, #10                       // Compare the digit with 10 to check if it's 0-9 or A-F
    B.GE    letter                        // If W6 >= 10, branch to letter to handle A-F

    // Convert numeric digit (0-9) to ASCII character
    ADD     W6, W6, #'0'                  // Convert to ASCII by adding ASCII '0'
    B       cont                          // Go to continue to store the character

letter:
    // Handle the digits A to F (10-15)
    ADD     W6, W6, #('A' - 10)           // Convert to ASCII by adding offset for letters

cont:
    STRB    W6, [X1]                      // Store the ASCII character in the string at address in X1
    SUB     X1, X1, #1                    // Decrement address for the next character
    LSR     X4, X4, #4                    // Logical shift right by 4 to process the next hex digit

    // Decrement the loop counter and check if more digits remain
    SUBS    W5, W5, #1                    // Subtract 1 from W5 and set flags
    B.NE    loop                          // If W5 is not zero, continue the loop

    // Setup the parameters to print our hex number
    MOV     X0, #1                        // 1 = StdOut (file descriptor for standard output)
    ADRP    X1, hexstr@PAGE               // Load the page address of hexstr again
    ADD     X1, X1, hexstr@PAGEOFF        // Calculate the full address of hexstr
    MOV     X2, #19                       // Length of our string (16 hex digits + null terminator)
    MOV     X16, #4                       // Linux write system call number
    SVC     #0x80                         // Make the system call to output the string

    // Setup the parameters to exit the program
    MOV     X0, #0                        // Use 0 as return code (success)
    MOV     X16, #1                       // System call number 1 to terminate this program
    SVC     #0x80                         // Call kernel to terminate the program

.data
hexstr:      .ascii  "0x123456789ABCDEFG\n" // Message string to print

