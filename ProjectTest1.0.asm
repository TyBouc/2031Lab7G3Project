; ProjectTest1.0.asm

ORG 0
	LOADI &B0000010000000101
    Store Temp
    OUT Mult
    IN Result
    STORE Ans
    OUT HEX0
	 LOADI 4
	 OUT HEX1
	



Temp: DW 0
Ans: DW 0

Mult: EQU &H090
Result: EQU &H096
Hex1: EQU 005
Hex0: EQU 004