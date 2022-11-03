	.data
	.type	v, %object
	.size	v, 3

v:
	.xword 1, 2, 3

	.text
	.global main
	.arch armv8-a+fp16+simd
	.type main, %function

//Number1:
	//Half precision floating point number: 15 bit
	//sign: bit 15
	//exponent: bit 14 - bit 10
	//fraction: bit 9 - bit 0

main:
	BL splithf
    	B Mulhf
Return:
    	B Addhf

splithf:
	/*********************Number 1*****************************/
	MOV X1,#52
	SCVTF H1,X1     	// Covert 52 to Floating Point Half precision
	STUR H1,[SP,#0]		// Store H1 to Stack Pointer
	LDUR X1,[SP,#0]		// Load Floating Point to X1
	LSR X3,X1,#15 		//Sign = X3 = Shift Right Floating Point X1 15 bits
	LSR X4,X1,#10		//Shift Right 10 bits
	AND X4,X4,#0x1f     // AND bit. X4 and binary number 11111
	//MOV X11,#0xf
	//SUB X4,X4,X11         // X4 = X4-15
	MOV X12,#0x3ff
	AND X6,X1,X12		// AND bit. X1 and binary number 1111111111
    	MOV X13,#0x400
	ORR X6,X6,X13
/***********************Number 2***************************/
	MOV X2,#1356
	SCVTF H2,X2			// Covert 1356 to Floating Point Half precision
	STUR H2,[SP,#0]		// Store H2 to Stack Pointer
	LDUR X2,[SP,#0]		// Load Floating Point to X2
	LSR X7,X2,#15 		//Sign = X7 = Shift Right Floating Point X2 15 bits
	LSR X8,X2,#10		//Shift Right 10 bits
	AND X8,X8,#0x1f     // AND bit. X8 and binary number 11111
	//MOV X11,#0xf
	//SUB X8,X8,X11         // X8 = X8-15
	MOV X12,#0x3ff
	AND X9,X2,X12		// AND bit. X2 and binary number 1111111111
    	MOV X13,#0x400
	ORR X9,X9,X13
	BR X30

/******************* MULTIPLE ***********************/
Mulhf:
	ADD X10,X8,X4       // Add Exponent number 1 and number 2
	MOV X11,#0xf
	SUB X10,X10,X11
/********************Mul1tiple Mantissa***********************/
    	MUL X15,X6,X9
    	LSR X15,X15,#10
/*****************************Sign****************************/
	SUBS X16,X3,X7
	B.EQ Positive
	MOV X0,#1
	B Normalize1
Positive:
	MOV X0,#0
Normalize1:
	STUR X4,[SP,#16]	//Push X4
	STUR X9,[SP,#8] //Push X9
	STUR X5,[SP,#0] //Push X5
	MOV X9,X15
	SUBS X5,X15,#0
	B.NE NotEQ
	B Result_Multiple
	NotEQ:
	SUBS X4,X15,#0x3ff     // Compare Mantissa with 0x3ff
	B.HI GrT
	Loop1:
	LSR X13,X9,#10
	LSL X9,X9,#1
	SUBS X4,X13,#1
	B.EQ NEXT
	ADD X12,X12,#1
	B Loop1
	NEXT:
	SUB X10,X10,X12
	B Result_Multiple
	GrT:
	LSR X13,X9,#15   //Find bit 15 of Mantissa
	LSL X9,X9,#1     ////Shift Left Mantissa 15 bits
	SUBS X4,X13,#1
	B.EQ NEXT2    //Compare bit 15 with 1
	ADD X14,X14,#1
	B GrT
	NEXT2: MOV X11,#5
	SUB X12,X11,X14   // Find number Shift of exponent
	ADD X10,X10,X12
	LSR X15,X15,X12
	LDUR X5,[SP,#0]	    //Pop X5
	LDUR X9,[SP,#8]   //Pop X9
	LDUR X4,[SP,#16]	//Pop X4
	B Result_Multiple

Result_Multiple:
	LSL X0,X0,#15		//Shift Left X0 15 bits
	LSL X10,X10,#10     // Shift Left X10 10 bits
	ORR X5,X0,X10     	// OR bit. X5 = X0 | X10
	MOV X14,#0x3ff
	AND X15,X15,X14		//AND bit. X15 = X15 & 0x3ff
	ORR X5,X5,X15		// OR bit. X5 = X5 | X15 ---> Result Multiple
	B Return			//Return Main function

/*************************Adding**************************/
Addhf:
	SUBS X11,X4,X8
	B.NE NoEQ
	ADD X18,X4,X8
	ADD X19,X6,X9
	SUBS X11,X6,X9
	B.HI Fr1GTFr2
	MOV X17,X3
	B Normalize
	Fr1GTFr2:
	MOV X17,X7
	B Normalize
	NoEQ:
	SUBS X11,X4,X8
	B.HI N1GTN2
	SUB X11,X8,X4   //Number Shift
	LSR X6,X6,X11
	ADD X19,X6,X9
	MOV X18,X8
	MOV X17,X7
	B Normalize
	N1GTN2:
	SUBS X11,X4,X8
	B.HI N1GTN2
	SUB X11,X8,X4   //Number Shift
	LSR X9,X9,X11
	ADD X19,X6,X9
	MOV X18,X4
	MOV X17,X3
	B Normalize

Normalize:
	STUR X4,[SP,#16] //Push X4
	STUR X9,[SP,#8] //Push X9
	STUR X20,[SP,#0] //Push X20
	MOV X9,X19
	SUBS X20,X19,#0
	B.NE NotEQ1
	B Result_Adding
NotEQ1:
	SUBS X4,X19,#0x3ff     // Compare Mantissa with 0x3ff
	B.HI GrT1
LoopAdd:
	LSR X13,X9,#10
	LSL X9,X9,#1
	SUBS X4,X13,#1
	B.EQ NEXT1
	ADD X12,X12,#1
	B LoopAdd
NEXT1:
	SUB X18,X18,X12
	B Result_Adding
GrT1:
	LSR X13,X9,#15   //Find bit 15 of Mantissa
	LSL X9,X9,#1     ////Shift Left Mantissa 15 bits
	SUBS X4,X13,#1
	B.EQ NEXTAdd    //Compare bit 15 with 1
	ADD X14,X14,#1
	B GrT1
NEXTAdd:
	MOV X11,#5
	SUB X12,X11,X14   // Find number Shift of exponent
	ADD X18,X18,X12
	LSR X19,X15,X12
	LDUR X20,[SP,#0]	//Pop X20
	LDUR X9,[SP,#8] //Pop X9
	LDUR X4,[SP,#16]	//Pop X4
Result_Adding:
	LSL X17,X17,#15		//Shift Left X0 15 bits
	LSL X18,X18,#10     // Shift Left X10 10 bits
	ORR X20,X17,X18     	// OR bit. X20 = X17 | X18
	MOV X14,#0x3ff
	AND X19,X19,X14		//AND bit. X19 = X19 & 0x3ff
	ORR X20,X20,X19		// OR bit. X20 = X20 | X15 ---> Result
Exit:
