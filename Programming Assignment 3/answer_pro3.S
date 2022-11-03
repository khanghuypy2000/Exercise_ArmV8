   .data
  # .type	v, %object

c:
	.float	5.0, 9.0, 32.0

d:
	.float 72.5

    .text
    .global main
    .arch armv8-a+fp+simd
  #  .type main, %function


main:
	MOV X10,#5       //Input n(max) = 5
	MOV X0,#45       //Input x
	MOV X8,#0        //Start: n = 0
	B power			// Find a^0 and 0!
NEXT1:
	SUBS X12,X8,#0      //If n=0 --> Jump to power
	B.NE Continue
	B power
Continue:
	SUBS X13,X10,X8           //If N = 5 --> End program
	B.NE Continue1
	B Exit
Continue1:
	/*Find Modulo X8:2*/
	MOV X15,#2
	UDIV X14,X8,X15
	MUL X16,X14,X15
	SUBS X17,X8,X16      //If modulo: X8 % 2 = 1 --> (-1)^n = -1 else 0 --> (-1)^n = 0
	B.NE ODD
	ADD D2,D2,D3
	ADD X8,X8,#1
	B power
ODD:
	SUB D2,D2,D3
	ADD X8,X8,#1
	B power
power:     //Find x^(2n)
	MOV X15,#2
	MUL X1,X8,X15    // 2*n
	MOV X3,#2
	MOV X4,X0
	SUBS X7,X1,#0     //If 2*n = 0 --> x^(2n) = 1
 	BNE nNeqZero
	MOV X2,#1
	B factorial
nNeqZero:
	SUBS X7,X1,#1
	BNE Loop
	MOV X2,X0
	B factorial
Loop:					// If 2n >1 --> find x^2n
	MUL X0,X0,X4
	MOV X6,X3
    ADD X3,X3,#1
    SUBS X5,X1,X6
    B.NE Loop
    MOV X2,X0
    MOV X0,X4
	B factorial      //Next, Jump to Factorial to find (2n)!

factorial:   //Find (2n)!
	MOV X18,X1
	MOV X3,#1    // Include i
  	MOV X9,#1
  	ADD X18,X18,#1
  	SUBS X7,X1,#0
  	BNE nNeqZero1
  	MOV X9,#1
  	B cosine
nNeqZero1:
  	SUBS X7,X0,#1
  	BNE Loop1
  	MOV X9,#1
  	B cosine
Loop1:
	MUL X9,X9,X3
  	ADD X3,X3,#1
  	SUBS X4,X18,X3
  	B.NE Loop1
  	B cosine

cosine:         // Find: (x^(2n))/((2n)!)
	STUR X2, [SP, #0]     	// Store x^(2n) --> Stack Pointer
	STUR X9, [SP, #8]    	// Store (2n)! --> Stack Pointer
	LDUR D0, [SP, #0]    	// Load x^(2n) --> D0
	LDUR D1, [SP, #8]    	// Load (2n)! --> D1
	FDIV D3,D0,D1
	B Continue
Exit:
