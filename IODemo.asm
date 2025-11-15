ORG 0

Begin:
Call Delay
;Unsigned Mult (72C)
LOADI 34
OUT Ain
LOADI 54
OUT Bin
OUT UMult
IN Result
Out Hex0

Call Delay

;Signed multiplication (FF10)
LOADI -30
OUT Ain
LOADI 8
OUT Bin
OUT SMult
IN Result
Out Hex0

Call Delay

;Unsigned Divison (2)
LOADI 100
OUT Ain
LOADI 50
OUT Bin
OUT FDiv
IN Result
Out Hex0

Call Delay

;Signed Division (FFF6) FFF6
LOADI -100
OUT Ain
LOADI 10
OUT Bin
OUT SFDiv
IN Result
Out Hex0

Call Delay

;Unsigned Modulus (0x26)
LOADI 200
OUT Ain
LOADI 54
OUT Bin
OUT UMod
IN Result
Out Hex0

Call Delay

;Signed Modulus (FFF1)
LOADI 127
OUT Ain
LOADI -4
OUT Bin
OUT SMod
IN Result
Out Hex0

Call Delay

;ABS (0x0022) 
LOADI -34 
OUT Ain
OUT ABS
IN Result
Out Hex0

Call Delay

;Sqaure Root (0x000F)
LOADI 240
OUT Ain
OUT SqRoot
IN Result
Out Hex0

Call Delay

;Exponentiation (0x0157) 
LOADI 7
OUT Ain
LOADI 3
OUT Bin
OUT Exp
IN Result
Out Hex0

Call Delay

Call Begin
	


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