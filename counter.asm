ORG 0
MAIN:
		MOV TMOD,#01100000B
		MOV TL1,#-50
		SETB TR1
LAP:
		JNB TF1,$
		CLR TF1
		CPL P1.0
		JMP MAIN
END