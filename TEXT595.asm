ORG	0000H
MAIN:
		CLR P2.0
		CLR P2.3
		CALL DELAY
		
		
		
		MOV A,#01010100B
		MOV R0,#8
	LAP:
		CLR C
		RRC A
		MOV P2.1,C
		SETB P2.0
		CLR P2.0
		SETB P2.3
		CLR P2.3
		CALL DELAY
		DJNZ R0,LAP
	
		JMP $
DELAY:
		MOV R2,#255
LAP2:
		MOV R3,#255
		DJNZ R3,$
		DJNZ R2,LAP2
		RET
		END