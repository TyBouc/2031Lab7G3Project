ORG 0

LOADI -250      ; Load 4 (8-bit value)
OUT Ain      ; Write to A register (144)
LOADI 120     ; Load 2 (8-bit value)  
OUT Bin      ; Write to B register (145)
OUT SMod     ; Trigger multiplication (146)
IN Result    ; Read result (159)
OUT Hex0     ; Display on Hex0

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
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

Result:    EQU 159    ; 0x9F - Read 16-bit result