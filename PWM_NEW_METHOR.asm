ORG 0


MT1	EQU 30H
MT2 EQU 31H
MT3	EQU 32H
MT4 EQU 33H
MT5	EQU 34H
MT6 EQU 35H
MT7	EQU 36H
MT8 EQU 37H

BEGIN:

MOV MT8,#10
MOV MT7,#40
MOV MT6,#70
MOV MT5,#100
MOV MT4,#130
MOV MT3,#160
MOV MT2,#200
MOV MT1,#254

MOV P3,#255

MAIN:
MOV R6,#25
L_MAIN:
CALL PWM8C
DJNZ R6,L_MAIN
CALL SHIFT

JMP MAIN








PWM8C:
		MOV R3,#255
		MOV P1,R3
LOOP_PWM:
		DJNZ R3,CONT0
		JMP EX_PWM
CONT0:
		MOV A,R3	
		CJNE A,MT1,CONT1
		CLR P1.0
CONT1:
		CJNE A,MT2,CONT2
		CLR P1.1
CONT2:
		CJNE A,MT3,CONT3
		CLR P1.2
CONT3:
		CJNE A,MT4,CONT4
		CLR P1.3
CONT4:
		CJNE A,MT5,CONT5
		CLR P1.4
CONT5:
		CJNE A,MT6,CONT6
		CLR P1.5
CONT6:
		CJNE A,MT7,CONT7
		CLR P1.6
CONT7:
		CJNE A,MT8,CONT8
		CLR P1.7
CONT8:
		JMP LOOP_PWM
EX_PWM:
		RET
		
SHIFT:
		MOV R7,MT1
		MOV R0,#MT2
		MOV R1,#MT1
LOOP_SHIFT:		
		
		MOV A,@R0
		MOV @R1,A
		INC R1
		INC R0
		CJNE R1,#MT1,LOOP_SHIFT
		MOV MT8,R7
		

		RET




DELAY:
		MOV R0,#255
L1:
		MOV R1,#255
		DJNZ R1,$
		DJNZ R0,L1
		RET




END