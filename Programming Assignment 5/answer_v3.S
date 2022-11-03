	.data
	.type	v, %object
	.size	v, 10
c:
	.float	1.0, 2.0, 3.0, 4.0, 5.0

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:

	// for (i=0; i<3; i++)
	ADRP	X0, c
	ADD		X0, X0, :lo12:c
	ADD		X6, XZR, XZR			// sum = 0
	ADD		X3, XZR, XZR			// X3=i = 0
for:
	SUB		X2, X3, #3			// i-3
	CBZ		X2, Exit			// if i=0 break

	ADD		X5, X0, X3, LSL #3	// *v[i]
	LDUR	X1, [X5, #0]
	MOV V3.2S[0], w1
	MOV X4,#8
	MUL X7,X4,X3
	STUR w1,[SP,#0]
	LDUR S1,[SP,#0]

	ADD		X3, X3, #1			// i++ (x3++)
	B		for

Exit:

