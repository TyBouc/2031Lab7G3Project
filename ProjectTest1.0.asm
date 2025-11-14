; ProjectTest1.0.asm

ORG 0
	LOADI 5
	OUT XONE
	LOADI 12
	OUT XTWO
	OUT Mult
	IN Result
	OUT Hex0
	STORE Ans



Temp: DW 0
Ans: DW 0

Mult: EQU &H92
Result: EQU &H9F
XONE: EQU &H90
XTWO: EQU &H91


Hex1: EQU 005
Hex0: EQU 004