ORG 00
MOV P2,#00H
MOV P1,#0FFH
SETB P2.4
SETB P2.5
MAIN:
		MOV C,P2.0
		ORL C,P2.4
		JNC LED0
		MOV C,P2.1
		ORL C,P2.4
		JNC LED1
		JMP MAIN
LED0:
		MOV P1,#00H
		RET
LED1:
		MOV P1,#0FFH
		RET
DELAY:
		MOV R0,#20
LOOP0:
		MOV TMOD,#01H
		MOV TL0,#LOW(-1000)
		MOV TH0,#HIGH(-1000)
		SETB TR0
		JNB TF0,$
		DJNZ R0,LOOP0
		END