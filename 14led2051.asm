ORG 0
PP1	EQU	25H
PP2	EQU	26H

MAIN:

	
CALL ROT_R





JMP MAIN


ROT_R:
	MOV PP1,#255
	MOV PP2,#255
	MOV A,#11111010B
L_ROT_R:
	MOV PP1,A
	MOV PP2,A
	CALL OUT_PP
	CALL DELAY
	RL A
	JMP L_ROT_R
	
	
	RET

OUT_PP:
		MOV P1,PP1
		MOV P3,PP2
		SETB P3.7
		RET


DELAY:
	MOV 30H,#100
L_DELAY:
	MOV 31H,#255
	DJNZ 31H,$
	DJNZ 30H,L_DELAY
	RET
	
	
	
	END