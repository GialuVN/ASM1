ORG 0

MAIN:


CALL KIEU1

JMP MAIN

KIEU1:
	MOV R7,#8
	MOV R6,#10000000B
	MOV R5,#00000001B
L1_KIEU1:
	MOV P3,R6
	MOV P1,R5
	CALL DELAY
	
	MOV A,R6
	RR A
	MOV R6,A
	
	MOV A,R5
	RL A
	MOV R5,A
DJNZ R7,L1_KIEU1
RET









DELAY:
	MOV R0,#200
L_DELAY:
	MOV R1,#250
	DJNZ R1,$
	DJNZ R0,L_DELAY
	RET
	
	
	
	
	END