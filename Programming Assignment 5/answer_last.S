	.data
	.type	v, %object
	.size	v, 10
c:
	.float	1.0, 2.0, 3.0, 4.0, 5.0, 6.5, 7.25, 8.0, 9.5, 10.0    //Vector 1

c1:
	.float	1.5, 2.5, 3.5, 4.5, 5.0, 6.0, 7.5, 8.25, 9.0, 1.0      //Vector 2

	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function

main:

	// for (i=0; i<3; i++)
	ADRP	X0, c
	ADD		X0, X0, :lo12:c
	ADRP	X27, c1
	ADD		X27, X27, :lo12:c1
	MOV		X6, #0			// sum = 0
	MOV		X3, #0			// X3=i = 0
for:
	SUB		X2, X3, #10			//i-10
	CBZ		X2, Continue			// if i=0 break
	//LSL X7,X3,#3
	SUBS X14,X3,#3
	B.GT GT3
	MOV X13,X3
	B Resume
GT3:
	SUBS X14,X3,#7
	B.GT GT7
	SUB X13,X3,#4        // If i>3 --> X13 = i - 4
	B Resume
GT7:
	SUB X13,X3,#8		// If i>7 --> X13 = i - 8
Resume:
	MOV X8,#4
	MUL X7,X3,X8
	ADD	X5, X0, X7	// *v[i]
	ADD X10,X27,X7
	LDUR X1, [X5, #0]
	LDUR X2, [X10, #0]
	/* Store the elements of the array in the register */
	SUBS X9,X13,#0
	B.NE Case1
	MOV V1.2S[0],w1
	MOV V2.2S[0],w2
	B Break
Case1:
	SUBS X9,X13,#1
	B.NE Case2
	MOV V1.2S[1],w1
	MOV V2.2S[1],w2
	B Break
Case2:
	SUBS X9,X13,#2
	B.NE Case3
	MOV V1.2S[2],w1
	MOV V2.2S[2],w2
	B Break
Case3:
	MOV V1.2S[3],w1
	MOV V2.2S[3],w2
Break:
	ADD	X3, X3, #1			// i++ (x3++)
	SUBS X11,X3,#4
	B.EQ MUL1
	SUBS X12,X3,#8
	B.EQ MUL2
	B	for
MUL1:
	FMUL V3.2S,V1.2S,V2.2S    	// Result Mul vector [0...3]
	B for
MUL2:
	FMUL V4.2S,V1.2S,V2.2S		// Result Mul vector [4...7]
	B for

Continue:
	MOV w1,#0
	MOV w2,#0
	MOV V1.2S[2],w1
	MOV V2.2S[2],w2
	MOV V1.2S[3],w1
	MOV V2.2S[3],w2
	FMUL V5.2S,V1.2S,V2.2S       // Result Mul vector [8...9]
	ADD V6.2S,V3.2S,V4.2S
	ADD V0.2S,V6.2S,V5.2S     //Result

Exit:

