;;;;;;;;DC - AC SIN WAVE;;;;;;;;;;;
; DINH NGHIA BIEN
POS BIT P3.5      ;BAN KI DUONG
NEG BIT P3.7	  ;BAN KI AM

TEMB DATA 20H
FLAG BIT TEMB.0

ORG 0000H
JMP MAIN





MAIN:
		SETB P3.5
		SETB P3.7
		
REP_SIN:
	MOV DPTR,#SIN_POS
	MOV R1,#0
REP_POS:	
	MOV A,R1
	MOVC A,@A+DPTR
	CLR POS
	DEC A
	JNZ $-1
	INC R1
	MOV A,R1
	MOVC A,@A+DPTR
	SETB POS
	DEC A
	JNZ $-1
	INC R1
	CJNE R1,#96,REP_POS
	MOV DPTR,#SIN_NEG
	MOV R1,#0
REP_NEG:
	MOV A,R1
	MOVC A,@A+DPTR
	CLR POS
	DEC A
	JNZ $-1
	INC R1
	MOV A,R1
	MOVC A,@A+DPTR
	SETB POS
	DEC A
	JNZ $-1
	INC R1
	CJNE R1,#96,REP_NEG
	
	MOV DPTR,#SIN_POS
	MOV R1,#0
REP_POS1:	
	MOV A,R1
	MOVC A,@A+DPTR
	CLR NEG
	DEC A
	JNZ $-1
	INC R1
	MOV A,R1
	MOVC A,@A+DPTR
	SETB NEG
	DEC A
	JNZ $-1
	INC R1
	CJNE R1,#96,REP_POS1
	MOV DPTR,#SIN_NEG
	MOV R1,#0
REP_NEG1:
	MOV A,R1
	MOVC A,@A+DPTR
	CLR NEG
	DEC A
	JNZ $-1
	INC R1
	MOV A,R1
	MOVC A,@A+DPTR
	SETB NEG
	DEC A
	JNZ $-1
	INC R1
	CJNE R1,#96,REP_NEG1
	SJMP REP_SIN

SIN_POS:
DB 1,99
DB 2,98
DB 5,95
DB 7,93
DB 10,90
DB 12,88
DB 15,85
DB 17,83
DB 19,81
DB 22,78
DB 24,76
DB 26,74
DB 29,71
DB 31,69
DB 33,67
DB 35,65
DB 38,62
DB 40,60
DB 42,58
DB 44,56
DB 46,54
DB 48,52
DB 50,50
DB 51,49
DB 53,47
DB 55,45
DB 57,43
DB 58,42
DB 60,40
DB 61,39
DB 63,37
DB 64,36
DB 65,35
DB 66,34
DB 67,33
DB 68,32
DB 69,31
DB 70,30
DB 71,29
DB 72,28
DB 73,27
DB 73,27
DB 74,26
DB 74,26
DB 75,25
DB 75,25
DB 75,25
DB 75,25

SIN_NEG:
DB 75,25
DB 75,25
DB 75,25
DB 75,25
DB 74,26
DB 74,26
DB 73,27
DB 73,27
DB 72,28
DB 71,29
DB 70,30
DB 69,31
DB 68,32
DB 67,33
DB 66,34
DB 65,35
DB 64,36
DB 63,37
DB 61,39
DB 60,40
DB 58,42
DB 57,43
DB 55,45
DB 53,47
DB 51,49
DB 50,50
DB 48,52
DB 46,54
DB 44,56
DB 42,58
DB 40,60
DB 38,62
DB 35,65
DB 33,67
DB 31,69
DB 29,71
DB 26,74
DB 24,76
DB 22,78
DB 19,81
DB 17,83
DB 15,85
DB 12,88
DB 10,90
DB 7,93
DB 5,95
DB 2,98
DB 1,99

END
