ORG 0
BCD	DATA	30H
HEX	DATA	31H



	MOV R3,#00H
	MOV BCD,#1H
	
MAIN:
	CALL BCD2HEX
	MOV P3,HEX
	CALL DEM
	CALL DELAY
	CALL DELAY




JMP MAIN


BCD2HEX:
		MOV A,BCD
		SWAP A
		ANL A,#00001111B
		CJNE A,#0,CONT_BCD2HEX
		MOV HEX,BCD
		JMP EX_BCD2HEX
CONT_BCD2HEX:
		MOV A,BCD
CONT3_BCD2HEX:		
		CLR C
		SUBB A,#6
		MOV HEX,A
		MOV B,#10
		DIV AB
		SWAP A
		ORL A,B
		CJNE A,BCD,CONT2_BCD2HEX
		JMP EX_BCD2HEX		
CONT2_BCD2HEX:
		MOV A,HEX
		JMP CONT3_BCD2HEX		
EX_BCD2HEX:
		RET

DEM:
		MOV A,R3
		ADD A,#1
		DA A
		MOV R3,A
		CJNE A,#99H,EX_DEM
		MOV R3,#00H
EX_DEM:
		MOV BCD,R3
		RET
		
DELAY:
		MOV R1,#255
L1:
		MOV R2,#255
		DJNZ R2,$
		DJNZ R1,L1
		RET



END