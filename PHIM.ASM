ORG 00
MAIN:
		MOV P2,#0FFH
		MOV P1,#0FFH
		CLR P2.4
		CLR P2.5
LOOP1:
		JNB P2.0,LED1
		JNB P2.1,LED2
		JNB P2.2,LED3
		JNB P2.3,LED4
		JMP LOOP1
LED1:
		CLR P1.0
		RET
LED2:
		CLR P1.1
		RET
LED3:
		CLR P1.2
		RET
LED4:
		CLR P1.3
		RET
LED5:
		CLR P1.4
		RET
LED6:
		CLR P1.5
		RET
LED7:
		CLR P1.6
		RET
LED8:
		CLR P1.7
		RET
DELAY:
		MOV R0,#255
		DJNZ R0,$
		RET
		
		END