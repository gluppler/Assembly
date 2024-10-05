//
// This file contains the various code
// snippets from Chapter 2. This ensures
// they compile and gives you a chance
// to single step through them.
// They are labeled, so you can set a
// breakpoint at the one you are interested in.

.global _start                // Define _start as a global symbol, the entry point for the linker
.align 4                      // Align the next data to a 4-byte boundary

_start:
// Code snippet l1
l1:
	ADD	X0, XZR, X1           // Copy the value of X1 into X0 (X0 = X1), using XZR (zero register) for addition
	MOV	X0, X1                // Load the value of X1 into X0 (redundant in context)
	ORR	X0, XZR, X1           // Logical OR X1 with 0 and store in X0 (X0 = X1)

// Code snippet l2
l2:
	// Load X2 with the value 0x1234FEDC4F5D6E3A using MOV and MOVK
	MOV	X2, #0x6E3A           // Load the lower 16 bits of X2 with 0x6E3A
	MOVK	X2, #0x4F5D, LSL #16  // Load the next 16 bits into X2, shifting left by 16 bits
	MOVK	X2, #0xFEDC, LSL #32  // Load the next 16 bits into X2, shifting left by 32 bits
	MOVK	X2, #0x1234, LSL #48  // Load the highest 16 bits into X2, shifting left by 48 bits

// Code snippet l3
l3:
	// Perform various shifts on X2 and store the result in X1
	LSL	X1, X2, #1            // Logical shift left: X1 = X2 << 1
	LSR	X1, X2, #1            // Logical shift right: X1 = X2 >> 1
	ASR	X1, X2, #1            // Arithmetic shift right: X1 = X2 >> 1 (preserving sign bit)
	ROR	X1, X2, #1            // Rotate right: X1 = rotate(X2, 1)

// Code snippet l4 (repeats similar operations as l3)
l4:
	LSL	X1, X2, #1            // Logical shift left: X1 = X2 << 1
	LSR	X1, X2, #1            // Logical shift right: X1 = X2 >> 1
	ASR	X1, X2, #1            // Arithmetic shift right: X1 = X2 >> 1 (preserving sign bit)
	ROR	X1, X2, #1            // Rotate right: X1 = rotate(X2, 1

// Code snippet l5
l5:
	// Too big for #imm16 (immediate value)
	MOV	X1, #0xAB000000       // Load a large immediate value into X1

// Uncomment the next line if you want to see the
// Assembler error for a constant that can't be
// represented.
	// MOV	X1, #0xABCDEF11    // Uncommenting this will cause an assembler error since it's too large for a 16-bit immediate

// Code snippet l6
l6:
	// Performing additions with various immediate values
	ADD	X2, X1, #4000         // Add immediate value 4000 to X1 and store in X2
	ADD	X2, X1, #0x20, LSL #12 // Add shifted immediate value (0x20 << 12) to X1 and store in X2
	ADD	X2, X1, X0            // Add the values in X1 and X0, storing the result in X2
	ADD	X2, X1, X0, LSL 2     // Add the value in X1 and (X0 << 2) and store the result in X2
	ADD	X2, X1, W0, SXTB      // Add signed extended byte from W0 to X1, storing result in X2
	ADD	X2, X1, W0, UXTH 2     // Add zero extended halfword from W0 to (X1 << 2) and store in X2

// Code snippet l8
l8:
	ADDS	X0, X0, #1           // Increment X0 by 1, updating flags (set Z and N flags)

// Code snippet l9
l9:
	// Perform addition for lower and higher order bits of 128-bit addition
	ADDS	X1, X3, X5           // Add lower order 64-bits: X3 + X5, store result in X1 and update flags
	ADC	X0, X2, X4            // Add higher order 64-bits: X2 + X4 + carry from previous addition, store in X0

// Setup the parameters to exit the program
// and then call the kernel to do it.
	MOV     X0, #0              // Use 0 as return code
	MOV     X16, #1              // Load system call number 1 (exit) into X16
	SVC     #0x80                // Call kernel to terminate the program

.data
helloworld:	.ascii "Hello World!" // Define a null-terminated string "Hello World!"

