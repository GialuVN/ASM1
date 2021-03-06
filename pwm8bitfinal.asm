;////////////////CHUONG TRINH PHAT XUNG PWM P1.0 ///////////////////////////////////
;///////////////////////////LU MINH THI ////////////////////////////////////////////
;////////////////////////////25-02-2010/////////////////////////////////////////////
;KHAI BAO
XLOW DATA 30H
XHIG DATA 31H
TEM DATA 20H
WAR1 BIT TEM.0
ORG 0
JMP BEGIN
;PHAT XUNG PWM 3.7KHZ KENH 1
ORG 000BH
	SETB P1.6
	CLR P1.7
	JNB WAR1,SECON1
	MOV TL0,XHIG
	CLR WAR1
	RETI
SECON1:
	SETB P1.7
	CLR P1.6
	MOV TL0,XLOW
	SETB WAR1
	RETI
;KHOI TAO
BEGIN:
	MOV TMOD,#02H
	MOV IE,#82H
	SETB P1.6
	SETB P1.7
	MOV XLOW,#127
	CALL CONTROL
	SETB TR0
	SETB TF0
;CHUONG TRINH CHINH
MAIN:
	MOV R7,#255
	MOV DPTR,#SIN_TABLE
	
REPEAT1:	
	MOV A,#0
	MOVC A,@A+DPTR

	MOV XLOW,A
	CALL CONTROL

	CALL DELAY
	CALL INC_DPTR
	DJNZ R7,REPEAT1
	MOV DPTR,#SIN_TABLE+255
	MOV R7,#255
REPEAT2:
	MOV A,#0
	MOVC A,@A+DPTR

	MOV XLOW,A
	CALL CONTROL

	CALL DELAY
	CALL DEC_DPTR
	DJNZ R7,REPEAT2
	JMP MAIN
;DIEU CHINH DO RONG XUNG 1 - 255 KENH 1
CONTROL:
	MOV A,XLOW
	CPL A
	ADD A,#1
	MOV XHIG,A
	RET
;TANG - GIAM CON TRO
	
DEC_DPTR:
		CLR C
		MOV A,DPL
		SUBB A,1
		MOV DPL,A
		MOV A,DPH
		SUBB A,#0
		MOV DPH,A
		RET
INC_DPTR:
		MOV A,DPL
		ADD A,1
		MOV DPL,A
		MOV A,DPH
		ADDC A,#0
		MOV DPH,A
		RET
;DELAY
DELAY:
	MOV R0,#25
LOOP_DELAY:
	MOV R1,#24
	DJNZ R1,$
	DJNZ R0,LOOP_DELAY
	RET
SIN_TABLE:	
db 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3
db 3,3,4,4,4,4,5,5,5,6,6,7,7,7,8,8,9,9,10,10,11
db 11,12,12,13,13,14,15,15,16,16,17,18,18,19,20,20
db 21,22,22,23,24,24,25,26,27,28,28,29,30,31,32,32
db 33,34,35,36,37,38,39,40,40,41,42,43,44,45,46,47
db 48,49,50,51,52,53,54,55,57,58,59,60,61,62,63,64
db 65,66,68,69,70,71,72,73,75,76,77,78,79,81,82,83
db 84,86,87,88,89,91,92,93,94,96,97,98,99,101,102,103
db 105,106,107,109,110,111,113,114,115,117,118,119,121
db 122,123,125,126,128,129,130,132,133,134,136,137,139
db 140,141,143,144,145,147,148,150,151,152,154,155,157
db 158,159,161,162,164,165,166,168,169,170,172,173,175
db 176,177,179,180,181,183,184,186,187,188,190,191,192
db 194,195,196,198,199,200,202,203,204,206,207,208,210
db 211,212,213,215,216,217,218,220,221,222,223,225,226
db 227,228,229,231,232,233,234,235,237,238,239,240,241
db 242,243,244,246,247,248,249,250,251,252,253,254,255
END