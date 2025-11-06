  ; IODemo.asm
  ; Produces a "bouncing" animation on the LEDs.
  ; The LED pattern is initialized with the switch state.

  ORG 0

      ; Get and store the switch values
      IN     Switches
      STORE  InputPattern    ; save the raw switch input
      OUT    LEDs
      STORE  Pattern

  SwitchCheck:
      LOAD 0
      STORE SwitchCount ;reset count to 0

      LOAD Pattern 
      STORE TempSwitches ; copy for manipulation

  Count_Loop:
      LOAD TempSwitches
      STORE TempPattern

      JNZ CountOnes ; if TempSwitches is non-zero, check the next bit
      JUMP Check_Condition ; All bits checked, finished counting
  CountOnes:
      LOAD TempSwitches
      AND One ; Isolate the LSB (lowest switch bit)
      JNZ CountInc ; If LSB is 1, a switch is raised



  CountInc:
      LOAD SwitchCount
      ADDI 1
      STORE SwitchCount
      LOAD SwitchCount
      SHIFT -1
      STORE TempSwitches
      Jump Count_Loop ; coninue to loop


  BitLoop:
      LOAD TempPattern
      AND Bit0
      JZERO SkipAdd       ; if bit is 0
      LOAD Count
      ADD One
      STORE Count


  SkipAdd:
      LOAD TempPattern
      SHIFT -1
      STORE TempPattern
      LOAD BitCounter
      ADD NegOne
      STORE BitCounter
      JNZ BitLoop

  Left:
      ; Slow down the loop so humans can watch it.
  ;	CALL   Delay

      ; Check if the left place is 1 and if so, switch direction
      LOAD   Pattern
      AND    Bit9         ; bit mask
      JNZ    Right        ; bit9 is 1; go right

      LOAD   Pattern
      SHIFT  1
      STORE  Pattern
      OUT    LEDs

      JUMP   Left

  Right:
      ; Slow down the loop so humans can watch it.
  ;	CALL   Delay

      ; Check if the right place is 1 and if so, switch direction
      LOAD   Pattern
      AND    Bit0         ; bit mask
      JNZ    Left         ; bit0 is 1; go left

      LOAD   Pattern
      SHIFT  -1
      STORE  Pattern
      OUT    LEDs

      JUMP   Right

  ; To make things happen on a human timescale, the timer is
  ; used to delay for half a second.
  Delay:
      OUT    Timer
  WaitingLoop:
      IN     Timer
      ADDI   -5
      JNEG   WaitingLoop
      RETURN

  ; Variables
  Pattern:       DW 0
  InputPattern:  DW 0          
  TempPattern:   DW 0         
  Count:         DW 0         
  BitCounter:    DW 0         

  ; CTs
  Zero:			DW 0
  One:			DW 1
  NegOne:			DW -1
  Three:         DW 3
  Ten:           DW 10

  ; Useful values
  Bit0:          DW &B0000000001
  Bit9:          DW &B1000000000

  ; IO address constants
  Switches:  EQU 000
  LEDs:      EQU 001
  Timer:     EQU 002
  Hex0:      EQU 004
  Hex1:      EQU 005
