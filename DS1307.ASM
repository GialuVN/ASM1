SCL BIT P3.0
SDA BIT P3.1
D_WR EQU 0D0H
D_RD EQU 0D1H
FLG  EQU 20H
_STOP BIT FLG.0
_ACK  BIT FLG.1
_STA  BIT FLG.2
_LAST BIT FLG.3
SEC DATA 25H
TEM DATA 30H
ORG	00
MAIN:
;KHOI TAO
	MOV 20H,#0FFH
	SETB SCL	;NOT BUSY
	SETB SDA	;<>
	
	MOV TEM,#D_WR
	CALL SEND_STA_ACK
	MOV TEM,#0H
	CALL SEND_ACK_STOP
	
	CALL DELAY100MS
	MOV TEM,#D_RD
	CALL READ
	
	CALL DELAY100MS
	MOV TEM,#D_WR
	CALL SEND_STA_ACK
	MOV TEM,#07H
	CALL SEND_ACK
	MOV TEM,#10H
	CALL SEND_ACK_STOP
	CALL DELAY100MS
	JMP $


READ:
	CALL SEND2
	MOV R1,#8
	MOV A,#0
LOOP6:
	SETB SCL
	CALL DELAY10US
	MOV C,SDA
	RLC A
	CLR SCL
	CALL DELAY10US
	DJNZ R1,LOOP6
	MOV P2,A
	JMP $
	CALL STOP
	RET
	
	
	
	
	
	
	
	
	
	
	
	
SEND_STA_ACK:
	SETB _STA
	SETB _ACK
	CLR  _STOP
	CALL SEND
	RET
SEND_ACK:
	CLR _STA
	CLR _STOP
	SETB _ACK
	CALL SEND
	RET
SEND_ACK_STOP:
	SETB _ACK
	SETB _STOP
	CLR  _STA
	CALL SEND
	RET
	
	
SEND2:
	CALL START
	MOV R1,#8
	MOV A,TEM
LOOP8:
	RLC A
	MOV SDA,C
	SETB SCL
	CALL CLOCK
	DJNZ R1,LOOP8
	SETB SCL
	CALL DELAY10US
	CLR SCL
	CALL DELAY10US
	RET
	
	
SEND:
	JNB _STA,CONT0
	CALL START
CONT0:
	MOV R1,#8
	MOV A,TEM
LOOP4:
	RLC A
	MOV SDA,C
	SETB SCL
	CALL CLOCK
	DJNZ R1,LOOP4
	JNB _ACK,CONT1
	CALL CLOCK
CONT1:
	JNB _STOP,CONT2
	CALL STOP
CONT2:
	RET
	
START:
	CLR SDA
	CALL DELAY10US
	CLR SCL
	RET	
CLOCK:
	SETB SCL
	CALL DELAY10US
	CLR SCL
	CALL DELAY10US
	RET
STOP:
	SETB SDA
	CALL DELAY10US
	CLR SDA
	SETB SCL
	CALL DELAY10US
	SETB SDA
	RET
	
	
	
	

	

















DELAY10US:
	PUSH 0
	MOV R0,#10
	DJNZ R0,$
	POP 0
	RET
	
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