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
	  MOV X0,#0   // Include a
	  MOV X1,X0
	  MOV X3,#1    // Include i
	  MOV X2,#1
	  ADD X1,X1,#1
	  SUBS X7,X0,#0
	  BNE nNeqZero
	  MOV X2,#1
	  B Exit
nNeqZero:
	  SUBS X7,X0,#1
	  BNE Loop
	  MOV X2,#1
	  B Exit
Loop: MUL X2,X2,X3
      ADD X3,X3,#1
      SUBS X4,X1,X3
      B.NE Loop
	  B Exit
Exit:
