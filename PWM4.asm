
OUT1 BIT P1.0
OUT2 BIT P1.1
OUT3 BIT P1.2
OUT4 BIT P1.3

C1_ DATA 30H
C1	DATA 31H

C2_ DATA 32H
C2	DATA 33H

C3_	DATA 34H
C3	DATA 35H

C4_ DATA 36H
C4	DATA 37H

CC1	DATA 47H		;CH1
CC2 DATA 48H		;CH2
CC3	DATA 49H		;CH3
CC4 DATA 4AH		;CH4

R8	DATA 39H
R9	DATA 3AH
R10	DATA 3BH
R11	DATA 3CH
R12 DATA 3DH
R13	DATA 3EH
R14	DATA 3FH
R15	DATA 40H


COUT DATA 41H
TEM  DATA 20H

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
SETB OUT4

MOV CC1,#20
MOV CC2,#92
MOV CC3,#164
MOV CC4,#254
CALL DECODE_C

MAIN:



CALL MOD_PWM

JMP MAIN




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
		RET
		
		
		
DECODE_C:
		MOV C1_,CC1
		MOV A,#255
		CLR C
		SUBB A,CC1
		MOV C1,A
		
		MOV C2_,CC2
		MOV A,#255
		CLR C
		SUBB A,CC2
		MOV C2,A
		
		MOV C3_,CC3
		MOV A,#255
		CLR C
		SUBB A,CC3
		MOV C3,A
		
		MOV C4_,CC4
		MOV A,#255
		CLR C
		SUBB A,CC4
		MOV C4,A
		
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

					
END
		
		
		
		
		
		
		
		
		