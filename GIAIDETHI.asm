ORG 0

MAIN:
	MOV 30H,#10H
	MOV A,30H
	SETB C
	RLC A
	MOV P2,A




	JMP MAIN
	
	
	
	
	END