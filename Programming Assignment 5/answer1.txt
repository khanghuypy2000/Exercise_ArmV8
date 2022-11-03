   .data
   .type	c, %object
	.size	c, 3
c:
	.float	5.0, 9.0, 3.0, 6.5
	.text
	.global main
	.arch armv8-a+fp+simd
	.type main, %function
/*c1:
	.float	1.0, 2.5, 4.0, 9.5

d:
	.float 72.5

    .text
    .global main
    .arch armv8-a+fp+simd
  #  .type main, %function */

	/*X10 :Result Answer*/
f2c:
	/*LDUR S1, [X27, #0]	 // S1 = 5.0
	LDUR S2, [X27, #4]	 // S2 = 9.0
	LDUR S3, [X27, #8]	 // S3 = 3.0
	LDUR S4, [X27, #12]	 // S4 = 6.5
	LDUR S5, [X28, #0]
	LDUR S6, [X28, #4]
	LDUR S7, [X28, #8]
	MOV X10,#12
	LDUR S8, [X28, X10] */
	for:
	SUB	X2, X3, #3			// i-3
	CBZ	X2, Exit
	MOV X10,#4			// if i=0 break
	//MUL X26,X3,X10
	//ADD	X25,X27,X26 	// *v[i]
	ADD		X5, X0, X3, LSL #3	// *v[i]
	LDUR	X1, [X5, #0]
	ADD		X6, X6, X1			// sum += v[i]

	ADD		X3, X3, #1			// i++ (x3++)
	B for
	//BR X30

main:
    // pointer to constants
    ADRP X0, c
    ADD X0, X0, :lo12:c

	/*ADRP X28, c1
    ADD X28, X28, :lo12:c1

    // pointer to data
    ADRP X0, d
    ADD X0, X0, :lo12:d*/

    BL f2c
    NOP

Exit:
