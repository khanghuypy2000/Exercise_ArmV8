.data

num1:
	.hword 0


c:
	.float 5.0, 9.0, 3.0, 6.5
c1:
	.float 5.5, 9.25, 2.5, 1.0
.text
	.global main
	.arch armv8-a+fp16+simd
	.type main, %function



main:
	// Address of num1F64		128	R/W

	ADRP X15, c
	ADD X15, X15, :lo12:c
/*	MOV X0, #5
	LDUR S0,[X15,#0]
	STUR S0,[SP,#0]
	LDUR w0,[SP,#0]
	MOV V1.2S[0], w0
	MOV V1.2S[1], w0
//	MOV W0, V1
*/
for:
	SUB		X2, X3, #3			// i-3
	CBZ		X2, fini			// if i=0 break

	ADD		X5, X15, X3, LSL #3	// *v[i]
	LDUR	X1, [X5, #0]
	ADD		X6, X6, X1			// sum += v[i]

	ADD		X3, X3, #1			// i++ (x3++)
	B		for


	MUL V2.2S, v1.2S, V1.2S
	MOV V2.8H[7],w0
	LDUR Q0,[X15]

	// create num1
	MOV X1, #52		// X1=52
	SCVTF H1, X1	// Convert X1 to H1 (half float)

	MOV X2, #57		// X1=57
	SCVTF H2, X2	// Convert X1 to H1 (half float)

	// Address of num1
	ADRP X15, num1
	ADD X15, X15, :lo12:num1
	STUR	H1,[X15]

	LDRH W1, [X15]

	// Add and save H1+H2
	FSUB H0, H1, H2
	STUR H0, [X10]


fini:
	NOP
