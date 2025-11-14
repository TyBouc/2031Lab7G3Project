ORG 0

;Signed Modulus (00F8)
LOADI 120
OUT Ain
LOADI -54
OUT Bin
OUT SMod
IN Result
Out Hex0

Call Delay


;Sqaure Root (0x000A) 
LOADI 100
OUT Ain
OUT SqRoot
IN Result
Out Hex0

Call Delay

Finish:
	LOADI &HAA
	OUT Hex0
	Call Delay
	LOADI &HBB
	OUT Hex0
	Call Delay
	JUMP Finish
	

Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -30
	JNEG   WaitingLoop
	RETURN

; IO address constants
Switches:  EQU 000
LEDS:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Ain:       EQU 144    ; 0x90 - 8-bit input A
Bin:       EQU 145    ; 0x91 - 8-bit input B  
UMult:     EQU 146    ; 0x92 - Trigger unsigned multiply
SMult: 	   EQU 147	  ; 0x93 - Signed multiplication
FDiv:	   EQU 148	  ; 0x94 - Floor Division
SFDiv: 	   EQU 149    ; 0x95 - Signed Floor Division
UMod: 	   EQU 150    ; 0x96 - Unsigned Modulus 
SMod: 	   EQU 151    ; 0x97 - Signed Modulus
ABS:       EQU 152    ; 0x98 - ABS Value
SqRoot:    EQU 153    ; 0x99 - Truncated Sqaure Root
Exp:       EQU 154    ; 0x9A - Exponentiation




Result:    EQU 159    ; 0x9F - Read 16-bit result