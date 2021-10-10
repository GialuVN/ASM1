;***************************************
;***         GIAO TIEP I2C           ***
;***          DS1307 RTC             ***
;***  CHUONG TRINH DUOC VIET BOI     ***
;***         LU MINH THI             ***
;***	      23/8/2009              ***
;***************************************
;DINH NGHIA
SCL BIT P3.0
SDA BIT P3.1

;CHO CHE DO R/W
D_WR EQU 0D0H
D_RD EQU 0D1H

;CO DIEU KHIEN
FLG  EQU 20H
_STOP BIT FLG.0
_XBIT BIT FLG.1
;BIEN DU LIEU NHAN
SEC 	DATA 21H
MIN		DATA 22H
HOU		DATA 23H
DAY		DATA 24H
DATE	DATA 25H
MONT	DATA 26H
YEAR	DATA 27H

;BIEN DIEU KHIEN
_DATA 	DATA 30H
_REP  	DATA 31H
_POINT  	DATA 32H
RREP	DATA 33H
RPOINT	DATA 34H

;BIEN DU LIEU TRUYEN
ADDESS	DATA 40H	;DU LIEU NAP VAO
_D1	DATA 41H		;<>
_D2	DATA 42H		;<>
_D3	DATA 43H		;<>
_D4	DATA 44H		;<>
;********************************************
;********************************************
ORG	00
MAIN:
	SETB _STOP
	SETB SCL		;SAN SANG
	SETB SDA		;<>
	CALL DELAY100MS
;************************
;GHI DU LIEU VAO RTC
;************************
	MOV _REP,#1		;(BYTE HUONG+BYTE DIA CHI)+3 BYTE DU LIEU
	MOV _POINT,#40H
	MOV _DATA,#D_WR		;BYTE HUONG
	MOV ADDESS,#7		;BYTE DIA CHI DAU 
	MOV _D1,#10H		;DATA
	MOV _D2,#10
	MOV _D3,#10H
	CALL SEND
;************************
;DOC DU LIEU TU RTC
;************************
REP_SEC:
	CALL DELAY100MS
	MOV RREP,#1
	MOV RPOINT,#24H
	MOV ADDESS,#0
	CALL READ
	MOV P2,24H
	MOV P1,24H
	MOV P0,24H
ASS:
	JNB P3.4,AS
	SETB P3.7
	JMP REP_SEC
AS:
	CLR P3.7
	JMP ASS	
;**************************************
;CHON DIA CHI BAT DAU DOC 
;(DIA CHI CAT VAO ADDESS TRUOC KHI GOI)
;**************************************
READ:
	MOV _REP,#0
	MOV _POINT,#40H
	MOV _DATA,#D_WR
	CALL SEND
	CALL DELAY5US
	MOV _REP,#-1
	MOV _DATA,#D_RD
	CLR _STOP		;KHONG CHEN DK "STOP"
	CALL SEND
	SETB _STOP
	MOV R7,RREP
LOOP_READ:
	MOV R6,#8
	MOV A,#0
	CALL DELAY5US
REPEAT0:
	SETB SCL
	CALL DELAY5US
	MOV C,SDA
	RLC A
	CLR SCL
	CALL DELAY5US
	DJNZ R6,REPEAT0
	MOV R0,RPOINT		;VI TRI GHI DU LIEU
	MOV @R0,A
	INC RPOINT
	DJNZ R7,INS_SCK
	CALL STOP
	JMP END_READ
INS_SCK:
	CALL DELAY5US
	CLR SDA
	SETB SCL
	CALL DELAY5US
	CLR SCL
	SETB SDA
	JMP LOOP_READ
END_READ:
	RET
;************************************************
;CHUONG TRINH CON NAY SE GUI DIA CHI(KHI DOC) HAY
; DIA CHI + DU LIEU (KHI GHI)CHO RTC
;************************************************	
SEND:
	CLR SDA
	CALL DELAY5US
	CLR SCL
	INC _REP
	INC _REP
	MOV R6,_REP		;SO LAN TRUYEN DU LIEU
REPEAT:
	MOV R7,#8
	MOV A,_DATA		;NAP DU LIEU
LOOP_SEND:
	RLC A
	MOV SDA,C
	SETB SCL
	CALL DELAY5US
	CLR SCL
	CLR SDA
	CALL DELAY5US
	DJNZ R7,LOOP_SEND
	SETB SCL
	CALL DELAY5US
	CLR SCL
	SETB SDA
	DJNZ R6,LOAD_DATA
	JMP END_SEND
LOAD_DATA:
	MOV R0,_POINT
	MOV _DATA,@R0
	INC _POINT
	JMP REPEAT
END_SEND:
	JNB _STOP,EXIT_SEND
	CALL STOP
EXIT_SEND:
	RET
;************************
;DIEU KIEN STOP
;************************
STOP:
	CALL DELAY5US
	CLR SDA
	SETB SCL
	CALL DELAY5US
	SETB SDA
	RET
;************************
;XUNG NHIP TRUYEN
;************************
DELAY5US:
	NOP
	NOP
	NOP
	NOP
	NOP
	RET
;************************
;DELAY 100MS
;************************
DELAY100MS:
	PUSH 0
	PUSH 1
	PUSH 2
	MOV R0,#10
LOOP0:
	MOV R1,#100
LOOP1:
	MOV R2,#100
	DJNZ R2,$
	DJNZ R1,LOOP1
	DJNZ R0,LOOP0
	POP 2
	POP 1
	POP 0
	RET
END