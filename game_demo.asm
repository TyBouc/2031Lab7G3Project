ORG 0

LOADI	3
STORE	A

LOADI	5
STORE	B

MainLoop:
	LOAD	A
	OUT 	Input1
	LOAD 	B
	OUT 	Input2
	LOADI 	1
	OUT 	MultU
	IN 		results

DisplayQuestion:
	
	
ReadSwitches:
	IN    	Switches
	OUT		LEDs
	STORE	SwitchValue
	RETURN


B:		DW 0
A:		DW 0
SwitchValue:	DW 0

Switches:	EQU 000
LEDs:		EQU 001
Timer:		EQU 002
Hex0:		EQU 003
Hex1:		EQU 004
Hex2:		EQU 005
Input1:		EQU &H90
Input 2:	EQU &H91
MultU:		EQU &H92
MultS:		EQU &H93
DivU:		EQU &H94
DivS:		EQU &H95
Mod:		EQU &H96
Result:		EQU &H9F