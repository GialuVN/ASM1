ORG 0
SETB P1.0
SETB P1.1
SETB P1.2
CLR P3.7
MAIN:
	MOV SCON,#0
LOOPZ:	
	CALL ADC
	CALL SEND
	CALL DELAY
	JMP LOOPZ
	
	

ADC:
	CLR P1.2
	MOV R1,#0
REP_ADC:
	JNB P3.6,END_ADC
	INC R1
	CJNE R1,#255,REP_ADC
END_ADC:
	MOV A,R1
	SETB P1.2
	RET
	
	
SEND:
	MOV SBUF,A
	JNB TI,$
	CLR TI
	SETB P3.7
	CLR P3.7
	RET
	
DELAY:
	MOV R2,#10
LOOP2:
	MOV R0,#50
LOOP:
	MOV R3,#100
	DJNZ R3,$
	DJNZ R0,LOOP
	DJNZ R2,LOOP2
	RET
	END