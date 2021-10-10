;KHAI BAO
S_ANGLE DATA 30H




ORG 00
JMP MAIN
ORG 0003H
JMP EX_INT0
ORG 000BH
JMP TIMER0_INT
MAIN:
;KHOI TAO
	MOV IE,#83H			;CHO PHEP NGAT NGOAI 0, TIMER 0
	MOV TMOD,#02H		;BO DINH THOI 0 CHE DO 2 
	SETB IT0			;NGAT KICH KHOI CANH XUONG
	SETB IP.0			;UU TIEN CHO NGAT NGOAI 0
	SETB P1.0
	SETB P1.1
	MOV S_ANGLE,#90
LOOP:
	JNB P1.0,INCR
	JNB P1.1,DECR
	JMP LOOP
INCR:
	MOV A,S_ANGLE
	CJNE A,#180,CONT_INCR
	JMP EX_INCR
CONT_INCR:
	INC S_ANGLE
EX_INCR:
	JNB P1.0,$
	JMP LOOP
DECR:
	MOV A,S_ANGLE
	CJNE A,#0,CONT_DECR
	JMP EX_DECR
CONT_DECR:
	DEC S_ANGLE
EX_DECR:
	JNB P1.1,$
	JMP LOOP
	
EX_INT0:
	CLR TR0
	MOV R7,S_ANGLE
	INC R7
	SETB TF0
	RETI
TIMER0_INT:
	MOV TH0,#(-53)
	SETB TR0
	DJNZ R7,EXIT_TIMER0
	CLR TR0
	CLR TF0
	SETB P1.2
	CALL S_DELAY
	CLR P1.2
EXIT_TIMER0:
	RETI
S_DELAY:
	MOV R1,#50
	DJNZ R1,$
	RET
	END
	