ORG 0



MAIN:
MOV P1,#0
CALL DELAY
MOV P1,#255
CALL DELAY


JMP MAIN









DELAY:
		MOV R0,#1
L_DELAY:
		MOV R1,#100
		DJNZ R1,$
		DJNZ R0,L_DELAY
		RET
		
		
		
		END