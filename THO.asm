
ORG 0
MAIN:
	CLR P1.0
	SETB P1.1                                                                                                                                                                            
	SETB P1.2
	CALL DELAY30S
	SETB P1.0
	CLR P1.1
	SETB P1.2
	CALL DELAY25S
	SETB P1.0
	SETB P1.1
	CLR P1.2
	CALL DELAY5S
	JMP MAIN

; CHUONG TRINH CON TRE 5S
 DELAY5S:
	MOV R0,#5
LAP0:
	MOV R1,#20
LAP1:
	MOV TMOD,#01H
	MOV TH0,#HIGH(-50000)
	MOV TL0,#LOW(-50000)
	SETB TR0
	JNB TF0,$
	CLR TF0
	CLR TR0
	DJNZ R1,LAP1
	DJNZ R0,LAP0
	RET


;CHUONG TRINH CON TRE 25S
DELAY25S:
	MOV R2,#5
LAP2:
	CALL DELAY5S
	DJNZ R2, LAP2
	RET



;CHUONG TRINH CON TRE 30S
DELAY30S:
	MOV R3,#6
LAP3:
	CALL DELAY5S
	DJNZ R3,LAP3
	RET

	END
