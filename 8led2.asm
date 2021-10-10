ORG 00
MAIN:
		MOV A,#254
		MOV R0,#8
LAP:
		
		MOV P0,A
		CLR C
		RLC A
		CALL DELAY
		DJNZ R0,LAP
		JMP $














DELAY:
		MOV R2,#50
LOOP2:
		MOV R1,#50
LOOP1:
		MOV R0,#100
		DJNZ R0,$
		DJNZ R1,LOOP1
		DJNZ R2,LOOP2
		RET
		END
