;DINH NGHIA BIEN
COM_  DATA 30H
ADD_  DATA 31H
FLAG  DATA 20H
SLEC  BIT  FLAG.0
EXT	  BIT  FLAG.1

ORG 00
MAIN:
	MOV TMOD,#01H    ;TIMER 0 CHE DO 16 BIT\
	CLR  P3.2
	MOV R0,#200
LOOP_Y:
	CALL DELAY2400
	DJNZ R0,LOOP_Y
LAP:
	SETB P3.2
	CALL DELAY2400
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	CALL DELAY600
	SETB P3.2
	CALL DELAY600
	CLR P3.2
	MOV R0,#200
LOOP_X:
	CALL DELAY2400
	DJNZ R0,LOOP_X
	JMP LAP
	
	


DELAY2400:
			MOV TH0,#HIGH(-2400)
			MOV TL0,#LOW(-2400)
			SETB TR0
			JNB TF0,$
			CLR TF0
			CLR TR0
			RET
DELAY600:
			MOV TH0,#HIGH(-600)
			MOV TL0,#LOW(-600)
			SETB TR0
			JNB TF0,$
			CLR TF0
			CLR TR0
			RET
END