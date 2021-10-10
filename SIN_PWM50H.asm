;////////////////CHUONG TRINH PHAT XUNG PWM P1.0 ///////////////////////////////////
;///////////////////////////LU MINH THI ////////////////////////////////////////////
;////////////////////////////25-02-2010/////////////////////////////////////////////
;KHAI BAO
XLOW DATA 30H
XHIG DATA 31H
TEM DATA 20H
WAR1 BIT TEM.0
SIN  BIT TEM.1
ORG 0
JMP BEGIN
;PHAT XUNG PWM 3.7KHZ KENH 1
ORG 000BH
	SETB P1.0
	JNB WAR1,SECON1
	MOV TH0,XLOW
	CLR WAR1
	RETI
SECON1:
	CLR P1.0
	MOV TH0,XHIG
	SETB WAR1
	RETI
;KHOI TAO
BEGIN:
	MOV TMOD,#02H
	MOV IE,#82H
	CLR SIN
	SETB P3.2
	SETB P3.3
	SETB P1.0
	MOV XLOW,#127
	CALL CONTRO
	SETB TR0
	SETB TF0
;CHUONG TRINH CHINH
MAIN:
	CALL CONTRO
	CALL DELAY
TANG:
	JNB SIN,GIAM
	MOV A,XLOW
	CJNE A,#255,CONT_TANG
	CLR SIN
	JMP MAIN
GIAM:
	MOV A,XLOW
	CJNE A,#0,CONT_GIAM
	SETB SIN
	JMP MAIN
CONT_GIAM:
	DEC XLOW
	JMP MAIN
CONT_TANG:
	INC XLOW
	JMP MAIN

;DIEU CHINH DO RONG XUNG 1 - 255 KENH 1
CONTRO:
	CLR TR0
	PUSH ACC
	MOV A,XLOW
	CPL A
	ADD A,#1
	MOV XHIG,A
	POP ACC
	SETB TR0
	RET
DELAY:
	MOV R0,#10
RE_DELAY:
	MOV R1,#100
	DJNZ R1,$
	DJNZ R0,RE_DELAY
	RET
END