//
// Examples of the MOV instruction.
//
.global _start	            // Provide program starting address to linker
.align 4                    // Align the following data to a 4-byte boundary

// Load X2 with 0x1234FEDC4F5D6E3A first using MOV and MOVK
_start:
	// Loading the 128-bit value into X2 using MOV and MOVK instructions
	MOV	X2, #0x6E3A           // Load the lower 16 bits (0x6E3A) directly into X2
	MOVK	X2, #0x4F5D, LSL #16  // Load the next 16 bits (0x4F5D) into X2, shifted left by 16 bits
	MOVK	X2, #0xFEDC, LSL #32  // Load the next 16 bits (0xFEDC) into X2, shifted left by 32 bits
	MOVK	X2, #0x1234, LSL #48  // Load the highest 16 bits (0x1234) into X2, shifted left by 48 bits

// Just move W2 into W1
	MOV	W1, W2                // Copy the value of W2 into W1

// Now lets see all the shift versions of MOV
// These instructions don't work with the clang assembler
//	MOV	X1, X2, LSL #1        // Logical shift left (commented out)
//	MOV	X1, X2, LSR #1        // Logical shift right (commented out)
//	MOV	X1, X2, ASR #1        // Arithmetic shift right (commented out)
//	MOV	X1, X2, ROR #1        // Rotate right (commented out)

// Repeat the above shifts using the Assembler mnemonics.
	LSL	X1, X2, #1            // Logical shift left: X1 = X2 << 1
	LSR	X1, X2, #1            // Logical shift right: X1 = X2 >> 1
	ASR	X1, X2, #1            // Arithmetic shift right: X1 = X2 >> 1 (preserving sign bit)
	ROR	X1, X2, #1            // Rotate right: X1 = rotate(X2, 1

// Example that works with 8-bit immediate and shift
	MOV	X1, #0xAB000000       // Load a large immediate value into X1 (too big for #imm16)

// Example that can't be represented and results in an error
// Uncomment the instruction if you want to see the error
//	MOV	X1, #0xABCDEF11      // Too big for #imm16 and can’t be represented

// Example of MVN (Move Not)
	MOVN	W1, #45               // Move the bitwise NOT of 45 into W1

// Example of a MOV that the Assembler will change to MVN
	MOV	W1, #0xFFFFFFFE       // Load -2 into W1; assembler changes this to MVN (moving NOT)

// Setup the parameters to exit the program
// and then call the kernel to do it.
	MOV     X0, #0              // Use 0 return code
	MOV     X16, #1              // System call number 1 (exit) into X16
	SVC     #0x80                // Call kernel to terminate the program

