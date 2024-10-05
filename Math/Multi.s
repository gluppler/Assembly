.global _start
.align 4

_start:
    // Perform the multiplication (x0 = 5 * 3)
    mov x0, #5                 // First number
    mov x1, #3                 // Second number
    mul x0, x0, x1             // Result of multiplication in x0 (15)

    // Convert the result to an ASCII string (x0 contains the number)
    mov x2, sp                 // Prepare stack pointer for storing result
    bl int_to_ascii            // Call function to convert integer to ASCII

    // Syscall to write (syscall number 4 for write)
    mov x16, #0x4              // Syscall number for write
    mov x0, #1                 // File descriptor 1 (stdout)
    mov x1, x2                 // x1 contains the pointer to the ASCII string
    mov x2, #2                 // Length of the string (adjust if the number is longer)
    svc #0                     // Make the system call

    // Exit the program (syscall number 1 for exit)
    mov x16, #0x1              // Syscall number for exit
    mov x0, #0                 // Exit status
    svc #0                     // Make the system call

// Function to convert an integer to ASCII (x0 = integer, result in x2 as pointer to string)
int_to_ascii:
    mov x3, #10                // Divide by 10 for each digit
    mov x2, sp                 // Point to stack (we'll build the string here)

convert_loop:
    udiv x4, x0, x3            // Divide x0 by 10, result in x4
    msub x5, x4, x3, x0        // x5 = x0 - (x4 * 10), get remainder (digit)
    add x5, x5, #'0'           // Convert remainder to ASCII (digit)
    strb w5, [x2, #-1]!        // Store digit in memory, decrement pointer
    mov x0, x4                 // Update x0 with the quotient (x0 = x0 / 10)
    cbz x0, done               // If quotient is zero, we are done
    b convert_loop             // Otherwise, repeat

done:
    mov x2, x2                 // x2 now points to the string
    ret

