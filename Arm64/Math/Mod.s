.global _start

.text
_start:
    // Set up dividend and divisor for modulo operation
    mov x0, #10                // Dividend (10)
    mov x1, #3                 // Divisor (3)

    // Perform modulo (x0 = x0 % x1)
    udiv x2, x0, x1            // x2 = dividend / divisor
    mul x2, x2, x1             // x2 = (dividend / divisor) * divisor
    sub x0, x0, x2             // x0 = dividend - (dividend / divisor) * divisor

    // Convert the result to an ASCII string
    sub sp, sp, #16            // Allocate space on the stack for string (16 bytes)
    mov x2, sp                 // Move the stack pointer to x2 for string storage
    mov x3, x0                 // Move the result to x3 for conversion

    bl int_to_ascii            // Call function to convert integer to ASCII

    // Syscall to write (syscall number for write)
    mov x16, #0x4              // Syscall number for write
    mov x0, #1                 // File descriptor 1 (stdout)
    mov x1, x2                 // Pointer to the ASCII string
    mov x2, x4                 // Length of the string
    svc #0                      // Make the system call

    // Exit the program (syscall number for exit)
    mov x16, #0x1              // Syscall number for exit
    mov x0, #0                 // Exit status
    svc #0                      // Make the system call

// Function to convert an integer to ASCII
int_to_ascii:
    mov x4, 0                   // Initialize digit count
    mov x5, 10                  // Base 10 for division

convert_loop:
    udiv x6, x0, x5             // Divide x0 by 10
    msub x7, x6, x5, x0         // x7 = x0 - (x6 * 10), get remainder (digit)
    add x7, x7, #'0'            // Convert remainder to ASCII (digit)
    strb w7, [x2, x4]           // Store digit in memory
    add x4, x4, #1              // Increment digit count
    mov x0, x6                  // Update x0 with the quotient (x0 = x0 / 10)
    cbnz x0, convert_loop       // If quotient is not zero, repeat

    // Null-terminate the string
    strb wzr, [x2, x4]          // Null-terminate the string

    // Reverse the string since we've built it backwards
    mov x0, x2                  // Start of the string
    add x1, x2, x4              // End of the string
    sub x1, x1, #1              // Move to the last character

reverse_loop:
    cmp x0, x1                  // Compare start and end pointers
    b.ge reverse_done           // If start >= end, we are done

    // Swap characters
    ldrb w2, [x0]               // Load byte from start
    ldrb w3, [x1]               // Load byte from end
    strb w3, [x0]               // Store end byte at start
    strb w2, [x1]               // Store start byte at end

    add x0, x0, #1              // Move start pointer forward
    sub x1, x1, #1              // Move end pointer backward
    b reverse_loop              // Repeat

reverse_done:
    add x4, x4, #1              // Adjust for the null terminator
    mov x0, x2                  // Pointer to the start of the string
    ret

