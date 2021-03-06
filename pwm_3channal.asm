
OUT1 BIT P1.7
OUT2 BIT P1.5
OUT3 BIT P1.6


C1_ DATA 30H
C1	DATA 31H
C2_ DATA 32H
C2	DATA 33H
C3_	DATA 34H
C3	DATA 35H
CC1	DATA 36H		;RED
CC2 DATA 37H		;GREEN
CC3	DATA 38H		;BLUE

R8	DATA 39H
R9	DATA 3AH
R10	DATA 3BH
R11	DATA 3CH
R12 DATA 3DH
R13	DATA 3EH
R14	DATA 3FH
R15	DATA 40H
COUT DATA 41H
TEM DATA 20H

FLAG BIT TEM.0


	ORG 0
	JMP BEGIN
	ORG 001BH
	MOV TH1,#HIGH(-49995)
	MOV TL1,#LOW(-49995)
	SETB FLAG
	RETI

BEGIN:

	MOV TMOD,#10H	;TIMER1,CHE DO 16 BIT
	MOV IE,#88H		;CHO PHEP NGAT DO TIMER 1
	MOV COUT,#20
	SETB TR1
	SETB TF1
	

SETB OUT1
SETB OUT2
SETB OUT3

MAIN:
	MOV DPTR,#CODE_COLOR
	MOV R11,#30
L_MAIN:
	CALL STEP_3PWM	
	CALL LOAD_C
	CALL DECODE_C
	DJNZ R11,L_MAIN
	JMP MAIN


STEP_3PWM:
		MOV R8,#5
LOOP1_STEP_3PWM:
		MOV R9,#255
LOOP2_STEP_3PWM:
		MOV R10,#255
LOOP3_STEP_3PWM:
		CALL MOD_PWM
		DJNZ R10,LOOP3_STEP_3PWM
		DJNZ R9,LOOP2_STEP_3PWM
		DJNZ R8,LOOP1_STEP_3PWM
		RET

; a moj cham dc maj baj ha!! e chep baj "phat" do heng!hjhj
MOD_PWM:
		DJNZ R5,CH_1
		CPL OUT1
		JB OUT1,CH_1_1
		MOV R5,C1_
		JMP CH_1
CH_1_1:
		MOV R5,C1	
CH_1:
		
		DJNZ R6,CH_2
		CPL OUT2
		JB OUT2,CH_2_2
		MOV R6,C2_
		JMP CH_2
CH_2_2:
		MOV R6,C2	
CH_2:		
		
		DJNZ R7,CH_3
		CPL OUT3
		JB OUT3,CH_3_3
		MOV R7,C3_
		JMP CH_3
CH_3_3:
		MOV R7,C3	
CH_3:		
		RET
		
DECODE_C:
		MOV C1_,CC1
		MOV A,#255
		SUBB A,CC1
		MOV C1,A
		
		MOV C2_,CC2
		MOV A,#255
		SUBB A,CC2
		MOV C2,A
		
		MOV C3_,CC3
		MOV A,#255
		SUBB A,CC3
		MOV C3,A
		RET
		
		
LOAD_C:
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV CC1,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV CC2,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV CC3,A
		INC DPTR
		RET
ADJUST:
		CJNE A,#0,CON_ADJUST
		INC A
		SJMP EX_ADJUST
CON_ADJUST:
		CJNE A,#255,EX_ADJUST
		DEC A
EX_ADJUST:
		RET
		
TIMING:
		JNB FLAG,EXT_TIMING
		CLR FLAG
		DJNZ COUT,EXT_TIMING
		MOV COUT,#20
EXT_TIMING:
		RET	

		
CODE_COLOR:
			DB	254,1,1
			DB	1,254,1
			DB	1,1,254
			DB	1,1,1
			DB	254,254,254
			DB	254,254,1
			DB	254,1,254
			DB	1,254,254

			DB	7FH,0FEH,01H
			DB	01H,64H,01H
			DB 01H,0FAH,9AH
			DB 0FEH,0FEH,01H
			DB 0D2H,69H,1EH
			DB	69H,59H,0CDH
			DB 9AH,0CDH,32H
			DB	0CDH,10H,76H
			DB 7DH,26H,0CDH
			
			DB	54H,0FEH,9FH
			DB 9AH,0FEH,9AH
			DB 01H,0FEH,7FH
			DB 01H,0FEH,01H
			DB 7FH,0FEH,01H
			DB 0C0H,0FEH,3EH
			DB 0CAH,0FEH,70H
			DB 0FEH,0F6H,8FH
			DB 0FEH,0ECH,8BH
			DB 0FEH,0FEH,0E0H
			DB 0FEH,0FEH,01H
			DB 0FEH,0D7H,01H
			DB 0FEH,0B9H,0FH
			
			
			
			END