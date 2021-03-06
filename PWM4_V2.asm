OUT	DATA 21H

OUT1 BIT OUT.0
OUT2 BIT OUT.1
OUT3 BIT OUT.2
OUT4 BIT OUT.3

C1_ DATA 30H
C1	DATA 31H

C2_ DATA 32H
C2	DATA 33H

C3_	DATA 34H
C3	DATA 35H

C4_ DATA 36H
C4	DATA 37H

CC1	EQU 47H		;CH1
CC2 EQU 48H		;CH2
CC3	EQU 49H		;CH3
CC4 EQU 4AH		;CH4



;TAM///////////////////////////////
R8	DATA 39H
R9	DATA 3AH
R10	DATA 3BH
R11	DATA 3CH
R12 DATA 3DH
R13	DATA 3EH
R14	DATA 3FH
R15	DATA 40H


C1S		EQU	41H
C100MS 	EQU 42H
C250MS 	EQU 43H
C500MS 	EQU 44H

TEM    DATA 20H
FLAG   BIT TEM.0
T50MS  BIT TEM.1
T100MS BIT TEM.2
T250MS BIT TEM.3
T500MS BIT TEM.4
T1S	   BIT TEM.5

	ORG 0
	JMP BEGIN
	ORG 001BH
	MOV TH1,#HIGH(-49995)
	MOV TL1,#LOW(-49995)
	SETB FLAG
	CPL T50MS
	RETI

BEGIN:

	MOV TMOD,#10H	;TIMER1,CHE DO 16 BIT
	MOV IE,#88H		;CHO PHEP NGAT DO TIMER 1
	MOV C100MS,#2
	MOV C250MS,#5
	MOV C500MS,#2
	MOV C1S,#2
	SETB TR1
	SETB TF1
MOV P3,#255
mov OUT,#11110000B
SETB OUT1
SETB OUT2
SETB OUT3
SETB OUT4

MOV CC1,#250
MOV CC2,#125
MOV CC3,#40
MOV CC4,#5
CALL DECODE_C

MAIN:



CALL MOD_PWM
CALL TIMING


JNB T100MS,MAIN
CLR T100MS
MOV P3,#255
CALL QUAY_P
CALL DECODE_C




JMP MAIN




QUAY_T:
		
		MOV R3,CC1
		MOV R0,#CC2
		MOV R1,#CC1
L_QUAY_T:		
		MOV A,@R0
		MOV @R1,A
		INC R1
		INC R0
		CJNE R0,#CC4+1,L_QUAY_T
		MOV CC4,R3
		RET


QUAY_P:
		
		MOV R3,CC4
		MOV R0,#CC3
		MOV R1,#CC4
L_QUAY_P:		
		MOV A,@R0
		MOV @R1,A
		DEC R1
		DEC R0
		CJNE R0,#CC1-1,L_QUAY_P
		MOV CC1,R3
		RET



MOD_PWM:
		DJNZ R4,CH_1
		CPL OUT1
		JB OUT1,CH_1_1
		MOV R4,C1_
		JMP CH_1
CH_1_1:
		MOV R4,C1	
CH_1:
		
		DJNZ R5,CH_2
		CPL OUT2
		JB OUT2,CH_2_2
		MOV R5,C2_
		JMP CH_2
CH_2_2:
		MOV R5,C2	
CH_2:		
				
		DJNZ R6,CH_3
		CPL OUT3
		JB OUT3,CH_3_3
		MOV R6,C3_
		JMP CH_3
CH_3_3:
		MOV R6,C3	
CH_3:		
		DJNZ R7,CH_4
		CPL OUT4
		JB OUT4,CH_4_4
		MOV R7,C4_
		JMP CH_4
CH_4_4:
		MOV R7,C4	
CH_4:
		MOV P3,OUT
		RET
		
		
		
DECODE_C:
		MOV C1,CC1
		MOV A,#255
		CLR C
		SUBB A,CC1
		MOV C1_,A
		
		MOV C2,CC2
		MOV A,#255
		CLR C
		SUBB A,CC2
		MOV C2_,A
		
		MOV C3,CC3
		MOV A,#255
		CLR C
		SUBB A,CC3
		MOV C3_,A
		
		MOV C4,CC4
		MOV A,#255
		CLR C
		SUBB A,CC4
		MOV C4_,A

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
		JNB FLAG,EX_TIMING
		CLR FLAG
		DJNZ C100MS,EX_100MS
		CPL T100MS
		MOV C100MS,#2
EX_100MS:
		DJNZ C250MS,EX_TIMING
		CPL T250MS
		MOV C250MS,#5
		DJNZ C500MS,EX_TIMING
		CPL T500MS
		MOV C500MS,#2
		DJNZ C1S,EX_TIMING
		CPL T1S
		MOV C1S,#2
EX_TIMING:
		RET	
						
END
		
		
		
		
		
		
		
		
		