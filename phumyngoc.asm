

OU1 BIT P0.4		; SANG MUC 1
OU2 BIT P0.0
OU3 BIT  P0.1
OU4 BIT  P0.2
OU5 BIT  P0.3

LN1 BIT P0.6		;CHON MUC 0
LN2 BIT P0.7

SLE_DL EQU 30H



ORG 0



BEGIN:



	MOV P0,#255
	MOV SLE_DL,#0
	
	
MAIN:
	MOV SLE_DL,#0
	MOV R2,#20
LM1_K4:
	CALL K4
	DJNZ R2,LM1_K4
	
	SETB LN1
	CLR LN2
	CALL KK1
	
	
	SETB LN2
	CLR LN1
	CALL KK2
	
	MOV SLE_DL,#1
	MOV R2,#10
LM2_K3:
	CALL K3
	DJNZ R2,LM2_K3
	
	CLR LN1
	CLR LN2
	CALL KK1
	CALL KK2
	MOV P0,#255
	
	MOV SLE_DL,#1
	MOV R2,#5
LM3_K3:
	CALL K3
	DJNZ R2,LM3_K3
	
	CLR LN2
	CLR LN1
	MOV R2,#2
	MOV SLE_DL,#3
LM_DELAYl:
	CALL DELAY	
	DJNZ R2,LM_DELAYl
	JMP MAIN
	
	
	
	
	
K4:
	MOV P0,#255
	MOV P0,#255
	CLR LN2
	SETB LN1
	CALL DELAY
	CLR LN1
	SETB LN2
	CALL DELAY
	RET
	
K3:
	MOV P0,#255
	CLR LN2
	CLR LN1
	CALL DELAY
	SETB LN1
	SETB LN2
	CALL DELAY
	RET
	
K2:
	SETB OU5
	CALL DELAY
	CLR OU5
	SETB OU4
	CALL DELAY
	CLR OU4
	SETB OU3
	CALL DELAY
	CLR OU3
	SETB OU2
	CALL DELAY
	CLR OU2
	SETB OU1
	CALL DELAY
	CLR OU1
	RET
	
KK2:
	MOV SLE_DL,#3
	MOV R1,#2
L1_KK2:
	CALL K2
	DJNZ R1,L1_KK2
	
	MOV SLE_DL,#2
	MOV R1,#4
L2_KK2:
	CALL K2
	DJNZ R1,L2_KK2
	
	MOV SLE_DL,#1
	MOV R1,#8
L3_KK2:
	CALL K2
	DJNZ R1,L3_KK2
	
	MOV SLE_DL,#0
	MOV R1,#32
L4_KK2:
	CALL K2
	DJNZ R1,L4_KK2
	RET
		
KK1:
	MOV SLE_DL,#3
	MOV R1,#2
L1_KK1:
	CALL K1
	DJNZ R1,L1_KK1
	
	MOV SLE_DL,#2
	MOV R1,#4
L2_KK1:
	CALL K1
	DJNZ R1,L2_KK1
	
	MOV SLE_DL,#1
	MOV R1,#8
L3_KK1:
	CALL K1
	DJNZ R1,L3_KK1
	
	MOV SLE_DL,#0
	MOV R1,#32
L4_KK1:
	CALL K1
	DJNZ R1,L4_KK1
	RET
	
K1:
	SETB OU1
	CALL DELAY
	CLR OU1
	SETB OU2
	CALL DELAY
	CLR OU2
	SETB OU3
	CALL DELAY
	CLR OU3
	SETB OU4
	CALL DELAY
	CLR OU4
	SETB OU5
	CALL DELAY
	CLR OU5
	RET


DELAY:
		MOV A,SLE_DL
		CJNE A,#0,CON1_DELAY
		CALL DELAY50MS
CON1_DELAY:		
		CJNE A,#1,CON2_DELAY
		CALL DELAY100MS
CON2_DELAY:		
		CJNE A,#2,CON3_DELAY
		CALL DELAY250MS
CON3_DELAY:			
		CJNE A,#3,EX_DELAY
		CALL DELAY500MS
EX_DELAY:
		RET

DELAY500MS:
			CALL DELAY250MS
			CALL DELAY250MS
			RET
DELAY250MS:
			CALL DELAY100MS
			CALL DELAY100MS
			CALL DELAY50MS
			RET
DELAY100MS:
			CALL DELAY50MS
			CALL DELAY50MS
			RET
DELAY50MS:
			MOV TMOD,#01H
			MOV TL0,#LOW(-50000)
			MOV TH0,#HIGH(-50000)
			SETB TR0
			JNB TF0,$
			CLR TR0
			CLR TF0
			RET
			
			

			
			
	
END