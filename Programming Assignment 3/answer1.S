.data
	.type	v, %object
	.size	v, 3

v:
	.xword 1, 2, 3

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:
	MOV X0,#5   // Input a
	MOV X1,#1    // Input n
	MOV X3,#2
	MOV X4,X0
	SUBS X7,X1,#0
	BNE nNeqZero
	MOV X2,#1
	B Exit
nNeqZero:
	SUBS X7,X1,#1
	BNE Loop
	MOV X2,X0
	B Exit
Loop:
	MUL X0,X0,X4
	MOV X6,X3
    ADD X3,X3,#1
    SUBS X5,X1,X6
    B.NE Loop
    MOV X2,X0
	B Exit
Exit:
