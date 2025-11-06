; IODemo.asm
; Produces a "bouncing" animation on the LEDs, but first ensures
; that no more than two switches are raised.

ORG 0

	; Get and store the switch values
	IN Switches
	OUT LEDs
	STORE Pattern
	
	JUMP CHECK_SWITCHES ; Jump to validation routine before starting animation

Proceed: ; Label for the bouncing to start when the condition is met
	JUMP Left

; -----------------------------------------------------
; Routine to Check and Enforce <= 2 Switches
; -----------------------------------------------------
CHECK_SWITCHES:
	; --- 1. Count Set Bits ---
	LOADI 0
	STORE SwitchCount ; Initialize count to 0

	LOAD Pattern
	STORE TempSwitches ; Copy switch state for manipulation

Count_Loop:
	LOAD TempSwitches
	JNZ Count_CheckBit ; If TempSwitches is non-zero, check the next bit
	JUMP Check_Condition ; All bits checked, finished counting

Count_CheckBit:
	LOAD TempSwitches
	AND One ; Isolate the LSB (lowest switch bit)
	JNZ Count_Increment ; If LSB is 1, a switch is raised

Count_Shift:
	LOAD TempSwitches
	SHIFT -1 ; Shift right by 1 to check the next bit
	STORE TempSwitches
	JUMP Count_Loop ; Continue the loop

Count_Increment:
	LOAD SwitchCount
	ADDI 1
	STORE SwitchCount
	JUMP Count_Shift ; continue shifting/looping

; --- 2. Compare Count with 2 (Check if Count > 2) ---
Check_Condition:
	LOAD SwitchCount
	ADDI -3 ; Count - 3. 
	JNEG Proceed ; if result is Negative (Count <= 2), proceed to animation

	; --- 3. If Count > 2, enter Wait Loop ---
Wait_For_Fix:
	; Wait for the user to lower switches
	;CALL Delay 

	IN Switches ; read current switch state
	OUT LEDs ; update  LEDs to show user the current switch state
	STORE Pattern ; store new state
	
	JUMP CHECK_SWITCHES
Left:
	; Slow down the loop so humans can watch it.
	;CALL Delay

	; Check if the left place is 1 and if so, switch direction
	LOAD Pattern
	AND Bit9 ; bit mask
	JNZ Right ; bit9 is 1; go right
	
	LOAD Pattern
	SHIFT 1
	STORE Pattern
	OUT LEDs

	JUMP Left
	
Right:
	; Slow down the loop so humans can watch it.
	;CALL Delay

	; Check if the right place is 1 and if so, switch direction
	LOAD Pattern
	AND Bit0 ; bit mask
	JNZ Left ; bit0 is 1; go left
	
	LOAD Pattern
	SHIFT -1
	STORE Pattern
	OUT LEDs
	
	JUMP Right
	
; To make things happen on a human timescale, the timer is
; used to delay for half a second.
Delay:
	OUT Timer
WaitingLoop:
	IN Timer
	ADDI -5
	JNEG WaitingLoop
	RETURN

; Variables
Pattern: DW 0

; Useful values
Bit0: DW &B0000000001
Bit9: DW &B1000000000
One: DW 1 ; New mask for bit counting
SwitchCount: DW 0 ; New variable to store the count of raised switches
TempSwitches: DW 0 ; New temporary variable for bit manipulation

; IO address constants
Switches: EQU 000
LEDs: EQU 001
Timer: EQU 002
Hex0: EQU 004
Hex1: EQU 005
