// AArch64 Assembly Code
// Programming with 64-Bit ARM Assembly Language
// Chapter #4: Exercise #2 (Page 81)
// Jeff Rosengarden 08/27/20

//
// Create assembly code to emulate a switch/case statement

// REGISTERS USED IN CODE
// w11 	- 	holds switch variable (1 thru 3 for this case statement)
// w12 	-	holds the exit value that can be queried at the OS level with: echo $?
//			NOTE:  w12 is transferred to w0 just before program exit so the
//				   user can query the value with $?
// w13 	-	work register used during calculation of message length

// X0 - X2  hold parameters for Darwin/kernel system call
// X0	-	holds FD (file device) for output (stdout in this case)
// X1	-	holds address of message
// X2 	-	holds length of message

// X16	-	used to hold Darwin/Kernel system call ID
// X9	-	holds calculated length of message

.global _start	 							// Provide program starting address
.align 4

_start:		// this is the switch portion of the case statement
			// branching to select1, select2, select3 or default
			// labels based on value in w11


			// set "select" value (1 thru 3) in w11

			mov w12, 0xff	// Prepare for error case
			cmp x0, #2	// Make sure we have precisely two arguments
			bne endit	// If it is not: exit
			ldr x11, [x1, #8]	// Get the pointer at x1 + 8
			ldrb w11, [x11]	// Load the Byte pointed to by that pointer into w11
			sub w11, w11, #'0' // Subtract the ASCII value for '0'

			cmp w11, #1			// Check if w11 is equal to 1
			b.eq select1		// If equal, branch to select1
			cmp w11, #2			// Check if w11 is equal to 2
			b.eq select2		// If equal, branch to select2
			cmp w11, #3			// Check if w11 is equal to 3
			b.eq select3		// If equal, branch to select3

			// if w11 contains anything other than 1 thru 3 the program
			// will fall thru to the default label here

			// each label is a switch/case target based on the above select code

default:	mov w12, #99					// Use 99 return code for os query ($?)
			b break							// same as switch/case break statement

select1:	mov w12, #1						// Use 1 return code for os query ($?)
			b break							// same as switch/case break statement

select2:	mov w12, #2						// Use 2 return code for os query ($?)
			b break							// same as switch/case break statement

select3:	mov w12, #3						// Use 3 return code for os query ($?)
											// b break not necessary here as it will
											// fall thru when done executing the
											// select3: case

break:		nop								// nop here just to prove we actually
											// wind up here from each case statement
											// when debugging with lldb

											// code after the select/case would go
											// here

			ADRP	X1, mesg@PAGE 			// Load the address of the message into X1
			ADD	X1, X1, mesg@PAGEOFF		// Complete the address of the message

			// calculate length of message (store it in x9)

			mov x9, #0						// Zero out x9 before starting
cloop:
			ldrb w13, [x1,x9]				// Get the next byte in message
			cmp  w13, #255					// Is it equal to 255 (0xFF)?
			b.eq  cend						// Yes - jump to cend
			add x9, x9, #1					// No - increase x9 count by 1
			b cloop							// Do it again
cend:

											// Setup the parameters to print string
											// and then call Darwin/kernel to do it.
			MOV	X0, #1	    				// 1 = StdOut

			MOV	X2, X9	    				// Length of our string
			MOV	X16, #4	    				// Darwin write system call
			SVC	#0x80 	    				// Call Darwin/kernel to output the string


// Setup the parameters to exit the program
// and then call the kernel to do it.
endit:
			mov		W0, W12					// Move return code into X0 so it can be
											// queried at OS level
    		MOV     X16, #1     			// System call number 1 terminates this program
    		SVC     #0x80           		// Call Darwin/kernel to terminate the program

			// return 0

// You can check the exit status after running your program by using:
// $ ./my_program <input>
// Replace <input> with 1, 2, or 3. Then use:
// $ echo $?
// This will show the return code set in the program.

// Message Data Section
.data
mesg:	.byte 0x1B												// Clear screen
		.byte 'c'												// Start msg at
		.byte 0													// Top of screen
		.asciz	"Chapter 4; Exercise #2\n"						// First message line
		.asciz	" - Emulate switch/case in assembly code\n\n"	// Second message line
		.asciz	" - By Jeff Rosengarden\n"						// Author line
		.asciz	" - Created on Apple DTK\n\n" 					// Creation line
		.asciz	" Use: echo to see the result of the program\n" // Instructions
		.asciz	"\n\n\n"										// 3 additional blank lines
		.byte	255	// End of message

