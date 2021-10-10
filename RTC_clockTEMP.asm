;DEFINE
SDA	BIT P1.1
SCL BIT P1.0
SQW BIT P1.2
;scan
l1	bit	p2.0
l2	bit	p2.1
l3	bit p2.2
l4	bit	p2.3
l5	bit	p2.4
l6	bit	p2.5
;data
O_DATA	DATA P0
WIRTE	EQU		0D0H
READ	EQU		0D1H

_SEC	DATA	30H
_MIN	DATA	31H
_HOUR	DATA	32H
_DAY	DATA	33H
_MONT	DATA	33H
_YEAR	DATA	34H
_CONT	DATA	35H

TEMP	DATA	36H
ADDR	DATA	37H
BYTES	DATA	38H
INDEX	DATA	39H

COUNT 	DATA	3AH

FLAG	DATA 20H
_FL1	BIT FLAG.0			;CO BAO 50ms
_FL2	BIT	FLAG.1			;CO BAO 1s





ORG 0
JMP BEGIN
ORG 001BH
MOV TH1,#HIGH(-49995)
MOV TL1,#LOW(-49995)
SETB _FL1
RETI


BEGIN:
	MOV TMOD,#10H	;TIMER1,CHE DO 16 BIT
	MOV IE,#88H		;CHO PHEP NGAT DO TIMER 1
	SETB TR1
	SETB TF1
	MOV COUNT,#20
	MOV 30H,#30H
	MOV 31H,#05H
	MOV 32H,#11H
	
MAIN:
	

	CALL DISPLAY
	CALL TIMING
	
	
	
	JNB _FL2,MAIN
	CLR _FL2
	MOV BYTES,#3
	MOV ADDR,#0
	MOV INDEX,#30H
	CALL MASTER_W
	
	JMP MAIN
	
	
	
DISPLAY:
		MOV A,_SEC
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L1
		CALL DELAY5M
		SETB L1
		
		MOV A,_SEC
		SWAP A
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L2
		CALL DELAY5M
		SETB L2
		
		MOV A,_MIN
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L3
		CALL DELAY5M
		SETB L3
		
		MOV A,_MIN
		SWAP A
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L4
		CALL DELAY5M
		SETB L4
		
		
		MOV A,_HOUR
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L5
		CALL DELAY5M
		SETB L5
		
		
		MOV A,_HOUR
		SWAP A
		ANL A,#0FH
		CALL DECODE
		MOV O_DATA,A
		CLR L6
		CALL DELAY5M
		SETB L6
		RET
		


DECODE:
		MOV DPTR,#MALED
		MOVC A,@A+DPTR
		RET
TIMING:
		JNB _FL1,EXT_TIMING
		CLR _FL1
		DJNZ COUNT,EXT_TIMING
		MOV COUNT,#20
		SETB _FL2
		CPL P3.7
EXT_TIMING:
		RET		
;********************************************************************
;-------------------------khoi giao tiep i2c-------------------------
;********************************************************************
;DOC DU LIEU TU DS1307 VOI CAC THAM SO: BYTES(SO BYTES DUOC DOC LIEN TIEP),INDEX(DIA CHI DICH 8051),ADDR(DIA CHI NGUON DS1307 )	
MASTER_R:
		PUSH 00H
		PUSH 07H
		CALL SELECT_ADDR
		CALL CON_S
		MOV TEMP,#READ
		CALL __BYTE_WIRTE	
		MOV R7,BYTES
		MOV R0,INDEX
__LOOP4:
		CALL ACK
		CALL __BYTE_READ
		MOV @R0,TEMP
		INC R0
		DJNZ R7,__LOOP4
		CALL N_ACK
		CALL CON_P
		POP 07H
		POP 00H
		RET
;GHI DU LIEU LEN DS1307 VOI CAC THAM SO: BYTES(SO BYTES DUOC GHI LIEN TIEP),INDEX(DIA CHI DU LIEU NGUON 8051),ADDR(DIA CHI DICH DS1307)
MASTER_W:
		PUSH 07H
		PUSH 00H
		CALL CON_S
		MOV TEMP,#WIRTE
		CALL __BYTE_WIRTE
		CALL ACK
		MOV TEMP,ADDR
		CALL __BYTE_WIRTE
		CALL ACK
		MOV R7,BYTES
		MOV R0,INDEX
LOOP3__:
		MOV A,@R0
		INC R0
		MOV TEMP,A
		CALL __BYTE_WIRTE
		CALL ACK
		DJNZ R7,LOOP3__
		CALL CON_P
		POP 00H
		POP 07H
		RET
;DINH CON TRO DU LIEU QUA ADDR		
SELECT_ADDR:
		CALL CON_S
		MOV TEMP,#WIRTE
		CALL __BYTE_WIRTE
		CALL ACK
		MOV TEMP,ADDR
		CALL __BYTE_WIRTE
		CALL ACK
		CALL CON_P
		RET
;PHAT 1BYTE DU LIEU TRONG TEMP

__BYTE_WIRTE:
		PUSH 07H
		MOV A,TEMP
		MOV R7,#8
LOOP1__:
		RLC A
		MOV SDA,C
		SETB SCL
		CALL DELAYP
		CLR SCL
		DJNZ R7,LOOP1__
		POP 07H
		RET
; NHAN 1 BYTE DU LIEU CAT VAO TEMP
__BYTE_READ:
		PUSH 07H
		MOV R7,#8
LOOP2__:	
		SETB SCL
		MOV C,SDA
		CALL DELAYP
		CLR SCL
		RLC A
		DJNZ R7,LOOP2__
		MOV TEMP,A
		POP 07H
		RET
; DIEU KIEN START
CON_S:
		SETB SDA
		SETB SCL
		CALL DELAYN
		CLR SDA
		CALL DELAYN
		CLR SCL
		RET
;DIEU KIEN STOP
CON_P:
		CLR SDA
		CLR SCL
		CALL DELAYN
		SETB SCL
		CALL DELAYN
		SETB SDA
		RET
;BAO DA NHAN/PHAT 1 BYTE
ACK:
		CLR SCL
		CLR SDA
		CALL DELAYP
		SETB SCL
		CALL DELAYP
		CLR SCL
		SETB SDA
		CALL DELAYP
		RET
;DAO CUA ACK
N_ACK:
		CLR SCL
		SETB SDA
		CALL DELAYP
		SETB SCL
		CALL DELAYP
		RET
;LONG DELAY
DELAY5M:
		PUSH 07H
		PUSH 06H
		MOV R7,#5
RE_DELAY5M:
		MOV R6,#249
		DJNZ R6,$
		DJNZ R7,RE_DELAY5M
		POP 06H
		POP 07H
		RET
		
;SHORT DELAY
DELAYP:
		NOP
		NOP
		NOP
		NOP
		NOP
		RET
DELAYN:
		PUSH 07H
		MOV R7,#5
		DJNZ R7,$
		POP 07H
		RET
MALED:
	DB 0C0H, 0F9H, 0A4H, 0B0H, 99H, 92H, 82H, 0F8H, 80H, 90H	
END