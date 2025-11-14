ORG 0

LOADI	3
STORE	A

LOADI	5
STORE	B

MainLoop:
	LOADI	0
	STORE	Score
	LOADI	0
	OUT		Hex1
	OUT		Hex0
	CALL   	ReadSwitches
	LOAD  	SwitchValue
	JZERO  	MainLoop
	JNZ  	Randomize

Randomize:
	LOAD  	A
	CALL  	LFSR
	AND  	Mask8
	STORE 	A

	LOAD  	B
	CALL  	LFSR
	AND  	Mask8
	STORE 	B

	CALL 	ReadSwitches
	JZERO	StartRound
	JUMP  	Randomize

StartRound:
	CALL	MultiplyQuestion
    CALL	DiviQuestion
    JUMP	InfiniteLoop

InfiniteLoop:
    JUMP	InfiniteLoop

DiviQuestion:
	LOAD	A
	OUT 	Input1
	LOAD	B
	OUT 	Input2
	LOADI 	1
	OUT 	DivU
	IN 		result
	STORE	C
    OUT		Timer
	JUMP 	DisplayQuestion

MultiplyQuestion:
	LOAD	A
	OUT 	Input1
	LOAD	B
	OUT 	Input2
	LOADI 	1
	OUT 	MultU
	IN 		result
	STORE	C
    OUT		Timer
	JUMP 	DisplayQuestion

DisplayQuestion:
	LOAD 	A
	OUT		Hex0
	LOAD 	B
	OUT 	Hex1
	CALL	ReadSwitches
	LOAD	SwitchValue
	SUB		C
	JZERO	CheckAnswers
	IN		Timer
	SUB		MaxTicks
	JPOS	CheckAnswers
	JUMP	DisplayQuestion

CheckAnswers:
	CALL	ReadSwitches
	LOAD	SwitchValue
	STORE	Answer
	LOAD	C
	SUB		Answer
	JZERO	Correct
	RETURN

Correct:
	LOAD	Score
	ADDI	1
	STORE	Score
	CALL	ShowScore
	RETURN

ShowScore:
	LOAD	Score
	OUT		Hex1
	RETURN

ReadSwitches:
	IN    	Switches
	OUT		LEDs
	STORE	SwitchValue
	RETURN

LFSR:
	STORE	LFSR_Orig
	LOAD	LFSR_Orig
	SHIFT 	1
	STORE 	LFSR_Shifted

	LOAD  	LFSR_Shifted
	AND   	Bit5Mask
	JZERO 	NoBit5
	LOADI 	1
	STORE 	LFSR_Parity
	JUMP  	CheckBit9
    
NoBit5:
	LOADI 	0
	STORE 	LFSR_Parity

CheckBit9:
	LOAD  	LFSR_Shifted
	AND  	Bit9Mask
	JZERO 	SetBit0
	LOAD  	LFSR_Parity
	XOR  	1
	STORE 	LFSR_Parity

SetBit0:
	LOAD  	LFSR_Shifted
	AND   	ClearBit0
	OR   	LFSR_Parity
	RETURN

LFSR_Orig:		DW 0
LFSR_Shifted:	DW 0
LFSR_Parity:	DW 0
Bit5Mask:   	DW 32
Bit9Mask:   	DW &B1000000000
ClearBit0:  	DW &B1111111111111110
Mask8:      	DW &B11111111

Bit0:       	DW &B0000000001
Bit9:     		DW &B1000000000

MaxTicks:		DW 100
Answer:			DW 0
B:				DW 0
A:				DW 0
C:				DW 0
SwitchValue:	DW 0
Score:			DW 0

Switches:		EQU 000
LEDs:			EQU 001
Timer:			EQU 002
Hex0:           EQU 004
Hex1:           EQU 005
Input1:			EQU &H90
Input2:			EQU &H91
MultU:			EQU &H92
MultS:			EQU &H93
DivU:			EQU &H94
DivS:			EQU &H95
Mod:			EQU &H96
Result:			EQU &H9F