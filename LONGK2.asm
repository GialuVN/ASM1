
TEMP DATA 20H
FLAG BIT TEMP.0
FLAG2 BIT TEMP.1
TANG  BIT P3.2
GIAM  BIT P3.3
ORG 0
JMP BEGIN
BEGIN:
	MOV P1,#255
	MOV P0,#255
	MOV P2,#255
	CLR P3.1
	CLR P3.0
	CLR P3.4
	SETB TANG
	SETB GIAM
	MOV R7,#0
MAIN:	
	CJNE R7,#0,TIP_K1
	MOV P0,#255
	MOV P1,#255
	MOV P2,#255
	CLR P3.4
	SETB P3.0
	CLR P3.1
	CALL K1
TIP_K1:	
	CJNE R7,#1,TIP_K2
	MOV P0,#255
	MOV P1,#255
	MOV P2,#255
	CLR P3.4
	SETB P3.0
	CLR P3.1
	CALL K2
TIP_K2:
	CJNE R7,#2,MAIN
	MOV P0,#255
	MOV P1,#255
	MOV P2,#255
	CLR P3.4
	SETB P3.0
	CLR P3.1
	CALL K3
	JMP MAIN
	
	
	
	
	
	












K1:
CALL DELAY
CLR P0.0
CALL DELAY
CLR P0.1
CALL DELAY
CLR P0.2
CALL DELAY
CLR P0.3
CALL DELAY
CLR P1.0
CALL DELAY
CLR P1.1
CALL DELAY
CLR P1.4
CALL DELAY
CLR P1.5
SETB P3.4
CLR P3.0
CLR P3.1
CALL DELAY
CLR P2.5
CALL DELAY
CLR P2.4
CALL DELAY
CLR P2.2
CALL DELAY
CLR P2.3
CALL DELAY
CLR P2.7
CALL DELAY
CLR P2.6
CALL DELAY
CLR P0.6
CALL DELAY
CLR P0.7
CALL DELAY
CALL DELAY
CALL KEY
RET

K3:
CLR FLAG2
CALL DELAY
CLR P0.0
CALL DELAY
CLR P0.1
CALL DELAY
CLR P0.4
CALL DELAY
CLR P0.5
CALL DELAY
CLR P2.0
CALL DELAY
CLR P2.1
CALL DELAY
CLR P2.4
CALL DELAY
CLR P3.4
CLR P3.0
SETB P3.1
CLR P2.5
CALL DELAY
CLR P1.5
CALL DELAY
CLR P1.4
CALL DELAY
CLR P1.2
CALL DELAY
CLR P1.3
CALL DELAY
CLR P1.6
CALL DELAY
CLR P1.7
CALL DELAY
CLR P0.6
CALL DELAY
CLR P0.7
CALL DELAY
CALL DELAY
CALL DELAY
CALL KEY
RET

K2:
CLR FLAG2
CALL DELAY
CLR P0.0
CALL DELAY
CLR P0.1
CALL DELAY
CLR P0.4
CLR P0.2
CALL DELAY
CLR P0.5
CLR P0.3
CALL DELAY
CLR P2.0
CLR P1.0
CALL DELAY
CLR P1.1
CLR P2.1
CALL DELAY
CLR P1.2
CLR P2.2
CALL DELAY
CLR P1.3
CLR P2.3
CALL DELAY
CLR P1.6
CLR P2.7
CALL DELAY
CLR P1.7
CLR P2.6
CALL DELAY
CLR P0.6
CALL DELAY
CLR P0.7
CALL DELAY
CALL KEY
RET



KEY:
	CLR FLAG
RE_KEY:
	JNB TANG,S_TANG
	JNB GIAM,S_GIAM
	JNB FLAG,RE_KEY
	RET	

	
S_GIAM:
		DEC R7
		CJNE R7,#-1,EX_INT1
		MOV R7,#0
EX_INT1:

		MOV 30H,#100
L01:
		MOV 31H,#255
L02:
		JNB GIAM,L01
		DJNZ 31H,L02
		DJNZ 30H,L01
		SETB FLAG
		JMP RE_KEY
		
S_TANG:
		INC R7
		CJNE R7,#3,EX_INT0
		MOV R7,#2
EX_INT0:
		MOV 30H,#100
L11:
		MOV 31H,#255
L22:
		JNB TANG,L11
		DJNZ 31H,L22
		DJNZ 30H,L11
		SETB FLAG
		JMP RE_KEY
		
DELAY:
		MOV R0,#8
L2:
		MOV R1,#100
L1:
		MOV R2,#249
		DJNZ R2,$
		DJNZ R1,L1
		DJNZ R0,L2
		RET

S_DELAY:
		MOV R3,#25
S1:
		MOV R4,#255
		DJNZ R4,$
		DJNZ R3,S1
		RET

END
