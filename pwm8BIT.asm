;KHAI BAO
XLOW DATA 30H
XHIG DATA 31H
TEM DATA 20H
WAR BIT TEM.0

ORG 0
JMP MAIN
ORG 000BH
SJMP INT_PWM
MAIN:
;KHOI TAO
MOV TMOD,#02H
MOV IE,#82H
SETB TR0
SETB TF0
;CT CHINH
MAINX:
	MOV XLOW,#1
	CALL CONTRO
	CALL DELAY
	MOV R0,#25
LOOPZ:
	MOV A,XLOW
	ADD A,#10
	MOV XLOW,A
	CALL CONTRO
	CALL DELAY
	DJNZ R0,LOOPZ
	MOV XLOW,#255
	CALL CONTRO
	CALL DELAY
	MOV R0,#25
LOOPX:
	MOV A,XLOW
	SUBB A,#10
	MOV XLOW,A
	CALL CONTRO
	CALL DELAY
	DJNZ R0,LOOPX
	JMP MAINX


;DIEU CHINH DO RONG XUNG 1 - 255
CONTRO:
	PUSH ACC
	MOV A,XLOW
	CPL A
	ADD A,#1
	MOV XHIG,A
	POP ACC
	RET
;PHAT XUNG PWM 3.7KHZ
INT_PWM:
	JNB WAR,SECON
	SETB P1.7
	SETB P1.4
	CLR P1.5
	CLR P1.2
	MOV TL0,XLOW
	CLR WAR
	RETI
SECON:
	SETB P1.5
	SETB P1.2
	CLR P1.7
	CLR P1.4
	MOV TL0,XHIG
	SETB WAR
	RETI
	
DELAY:
	PUSH 00H
	PUSH 01H
	MOV R0,#100
LOOP_DELAY:
	MOV R1,#255
	DJNZ R1,$
	DJNZ R0,LOOP_DELAY
	POP 01H
	POP 00H
	RET
END