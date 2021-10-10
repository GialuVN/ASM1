
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
COUT DATA 		41H
COUT2 DATA		46H
COUT3 DATA		47H
COUT4	DATA	48H
SF_OF	DATA	49H
COMR	DATA 42H
COMG	DATA 43H
COMB	DATA 44H
SF_R	DATA 45H


TEM 	DATA 	20H
TEM1 	DATA	21H
TEM2	DATA	22H

OF_R	BIT TEM2.0
OF_G	BIT	TEM2.1
OF_B    BIT TEM2.2

F_R	 BIT TEM1.0
F_G  BIT TEM1.1
F_B  BIT TEM1.2

C_R	 BIT TEM1.3
C_G  BIT TEM1.4
C_B  BIT TEM1.5


FLAG BIT TEM.0
T50MS BIT TEM.1
T100MS BIT TEM.2
T500MS BIT TEM.3
T10S BIT TEM.4
T1S	  BIT TEM.5

	ORG 0
	JMP BEGIN
	ORG 001BH
	MOV TH1,#HIGH(-10000)
	MOV TL1,#LOW(-10000)
	SETB FLAG
	SETB T50MS
	CALL TIMING
	RETI
BEGIN:
	MOV TMOD,#10H	;TIMER1,CHE DO 16 BIT
	MOV IE,#88H		;CHO PHEP NGAT DO TIMER 1
	MOV COUT,#20
	MOV COUT2,#2
	MOV COUT3,#5
	MOV COUT4,#10
	SETB TR1
	SETB TF1
	SETB OUT1
	SETB OUT2
	SETB OUT3
;;;;;;;
	SETB OF_R
	SETB OF_G
	SETB OF_B
	SETB F_R
	SETB F_G
	SETB F_B
	SETB C_R
	SETB C_G
	SETB C_B
	MOV SF_OF,#0
	MOV SF_R,#0
MAIN:
	




	
	MOV CC1,#0
	MOV CC2,#128
	MOV CC3,#255
RE_LOOP:
	MOV DPTR,#CODE_COLOR
	MOV R9,#28
LOOOP:
	MOV R10,#3
LOOP4:
	MOV R8,#255
LOOOP2:
	CALL PHASE_RGB
	DJNZ R8,LOOOP2
	DJNZ R10,LOOP4	
	CALL LOAD_C
	CALL ID_RGB
	CALL SF_PHASE
	DJNZ R9,LOOOP
	CALL I_SF_PHASE
	JMP RE_LOOP
I_SF_OF:
	INC SF_OF
	MOV A,SF_OF
	CJNE A,#8,EX_I_SF_OF
	MOV SF_OF,#0
EX_I_SF_OF:
		RET
		
SF_OF_RGB:
		MOV A,SF_OF
		CJNE A,#0,L1_OF_RGB
		SETB OF_R
		SETB OF_G
		SETB OF_B
L1_OF_RGB:
		CJNE A,#1,L2_OF_RGB
		CLR OF_R
		SETB OF_G
		SETB OF_B
L2_OF_RGB:	
		CJNE A,#2,L3_OF_RGB
		SETB OF_R
		CLR OF_G
		SETB OF_B
L3_OF_RGB:
		CJNE A,#3,L4_OF_RGB
		CLR OF_R
		SETB OF_G
		SETB OF_B
L4_OF_RGB:			
		CJNE A,#4,L5_OF_RGB
		CLR OF_R
		CLR OF_G
		SETB OF_B
L5_OF_RGB:
		CJNE A,#5,L6_OF_RGB
		SETB OF_R
		SETB OF_G
		CLR OF_B
L6_OF_RGB:	
		CJNE A,#6,L7_OF_RGB
		CLR OF_R
		SETB OF_G
		CLR OF_B
L7_OF_RGB:
		CJNE A,#7,L8_OF_RGB
		CLR OF_R
		CLR OF_G
		CLR OF_B
L8_OF_RGB:
		RET
	
	
I_SF_PHASE:
		INC SF_R
		MOV A,SF_R
		CJNE A,#8,EX_I_SF_PHASE
		MOV SF_R,#0
EX_I_SF_PHASE:
		RET
;CHON THU TU PHA		
SF_PHASE:
		MOV A,SF_R
		CJNE A,#0,L1_SF_PHASE
		SETB F_R
		SETB F_G
		SETB F_B
L1_SF_PHASE:
		CJNE A,#1,L2_SF_PHASE
		CLR F_R
		SETB F_G
		SETB F_B
L2_SF_PHASE:	
		CJNE A,#2,L3_SF_PHASE
		SETB F_R
		CLR F_G
		SETB F_B
L3_SF_PHASE:
		CJNE A,#3,L4_SF_PHASE
		CLR F_R
		SETB F_G
		SETB F_B
L4_SF_PHASE:			
		CJNE A,#4,L5_SF_PHASE
		CLR F_R
		CLR F_G
		SETB F_B
L5_SF_PHASE:
		CJNE A,#5,L6_SF_PHASE
		SETB F_R
		SETB F_G
		CLR F_B
L6_SF_PHASE:	
		CJNE A,#6,L7_SF_PHASE
		CLR F_R
		SETB F_G
		CLR F_B
L7_SF_PHASE:
		CJNE A,#7,L8_SF_PHASE
		CLR F_R
		CLR F_G
		CLR F_B
L8_SF_PHASE:
		RET									
;PHAT 3 XUNG MAU VOI DO LECH PHA DAT TRUOC	
PHASE_RGB:
		CALL PHASE_R
		CALL PHASE_G
		CALL PHASE_B
		RET
;MA MAU TANG HOAC GIAM TOI GIA TRI LUU TRONG COMR,COMG,COMB
ID_RGB:	
		SETB C_R
		SETB C_G
		SETB C_B
L_ID_RGB:
		JNB C_R,L1_ID_RGB
		CALL PHASE_R
		MOV A,CC1
		CJNE A,COMR,L1_ID_RGB
		CLR C_R
L1_ID_RGB:
		JNB C_G,L2_ID_RGB		
		CALL PHASE_G
		MOV A,CC2
		CJNE A,COMG,L2_ID_RGB
		CLR C_G
L2_ID_RGB:
		JNB C_B,L3_ID_RGB	
		CALL PHASE_B
		MOV A,CC3
		CJNE A,COMB,L3_ID_RGB
		CLR C_B
L3_ID_RGB:
		JB C_R,L_ID_RGB
		JB C_G,L_ID_RGB
		JB C_B,L_ID_RGB		
		RET		

; KIEM TRA MA MAU, NEU CC>128 GIAM, CC=<128 TANG
CONT_F_RGB:
			MOV A,CC1
			CJNE A,#128,R_CONT_F_RGB
			SETB F_R
			JMP EX_R
R_CONT_F_RGB:
			JC R2_CONT_F_RGB
			CLR F_R
			JMP EX_R
R2_CONT_F_RGB:
			SETB F_R
	EX_R:
	
			MOV A,CC2
			CJNE A,#128,G_CONT_F_RGB
			SETB F_G
			JMP EX_G
G_CONT_F_RGB:
			JC G2_CONT_F_RGB
			CLR F_G
			JMP EX_G
G2_CONT_F_RGB:
			SETB F_G
	EX_G:
	
			MOV A,CC3
			CJNE A,#128,B_CONT_F_RGB
			SETB F_B
			JMP EX_B
B_CONT_F_RGB:
			JC B2_CONT_F_RGB
			CLR F_B
			JMP EX_B
B2_CONT_F_RGB:
			SETB F_B
	EX_B:
			RET
			
;TANG GIAM DO RONG XUNG MAU DO		
PHASE_R:
		JNB OF_R,EX_PHASE_R
		JNB F_R,L1_PHASE_R
		CALL DECODE_C
		CALL PWM_3
		INC CC1
		MOV A,CC1
		CJNE A,#255,EX_PHASE_R
		CLR F_R
		
L1_PHASE_R:		
		CALL DECODE_C
		CALL PWM_3
		DEC CC1
		MOV A,CC1
		CJNE A,#0,EX_PHASE_R
		SETB F_R
EX_PHASE_R:		
		RET
;TANG GIAM DO RONG XUNG MAU XANH LA
PHASE_G:
		JNB OF_G,EX_PHASE_G
		JNB F_G,L1_PHASE_G
		CALL DECODE_C
		CALL PWM_3
		INC CC2
		MOV A,CC2
		CJNE A,#255,EX_PHASE_G
		CLR F_G
		
L1_PHASE_G:		
		CALL DECODE_C
		CALL PWM_3
		DEC CC2
		MOV A,CC2
		CJNE A,#0,EX_PHASE_G
		SETB F_G
EX_PHASE_G:		
		RET
;TANG GIAM DO RONG XUNG MAU XANH DUONG
PHASE_B:
		JNB OF_B,EX_PHASE_B
		JNB F_B,L1_PHASE_B
		CALL DECODE_C
		CALL PWM_3
		INC CC3
		MOV A,CC3
		CJNE A,#255,EX_PHASE_B
		CLR F_B
		
L1_PHASE_B:		
		CALL DECODE_C
		CALL PWM_3
		DEC CC3
		MOV A,CC3
		CJNE A,#0,EX_PHASE_B
		SETB F_B
EX_PHASE_B:		
		RET
;THAY DOI GIA TRIJ PWM SAU 50MS

PWM_3:
		CALL MOD_PWM
		JNB T50MS,PWM_3
		CLR T50MS
		RET


;PHAT PWM 3 KENH
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
		
;TU MA MAU-DO RONG XUNG		
DECODE_C:
		CALL ADJUST_C
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
		RET
		
;LAY MA MAU TRONG ROM		
LOAD_C:
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV COMR,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV COMG,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		CALL ADJUST
		MOV COMB,A
		INC DPTR
		RET
LOAD_RGB:
		MOV CC1,COMR
		MOV CC2,COMG
		MOV CC3,COMB
		RET
;MA MAU CHI NAM TRONG KHOANG 1-254		
ADJUST_C:
		MOV A,CC1
		CALL ADJUST
		MOV CC1,A
		MOV A,CC2
		CALL ADJUST
		MOV CC2,A
		MOV A,CC3
		CALL ADJUST
		MOV CC3,A
		RET
;HIEU CHINH SO 0-1,255-254
ADJUST:
		CJNE A,#0,CON_ADJUST
		INC A
		SJMP EX_ADJUST
CON_ADJUST:
		CJNE A,#255,EX_ADJUST
		DEC A
EX_ADJUST:
		RET
;DINH THOI 50MS, 1S	
TIMING:
		JNB FLAG,CONT4_TIMING
		CLR FLAG
		DJNZ COUT2,CONT1_TIMING
		MOV COUT2,#2
		SETB T100MS
CONT1_TIMING:
		DJNZ COUT3,CONT2_TIMING
		MOV COUT3,#5
		SETB T500MS
CONT2_TIMING:		
		DJNZ COUT,CONT3_TIMING
		MOV COUT,#20
		SETB T1S
CONT3_TIMING:		
		DJNZ COUT4,CONT4_TIMING
		MOV COUT,#10
		SETB T10S
CONT4_TIMING:
		RET	

CODE_COLOR:
		DB	0,0,0
		DB	255,0,0
		
		DB	255,255,0
		DB	0,255,0
		DB	255,0,255
		DB	0,0,255
		DB	0,255,255
		DB	255,255,255
		
		DB	0,64,128
		DB 	64,0,128
		DB 	64,128,0
		DB	0,128,64
		DB	128,0,64
		DB	128,64,0
		
		DB 	0,128,255
		DB	128,0,255
		DB	128,255,0
		DB 	0,255,128
		DB  255,0,128
		DB	255,128,0
	
		DB 0,10,128
		DB 10,0,128
		DB 10,128,0
		DB 0,128,10
		DB 128,0,10
		DB 128,10,0
		
	
			
END
		
		
		
		
		
		
		
		
		