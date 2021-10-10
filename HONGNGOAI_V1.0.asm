;DINH NGHIA BIEN
COM_  DATA 30H
ADD_  DATA 31H
R8	  DATA 32H
R9    DATA 33H
R10   DATA 34H
R11   DATA 35H
FLAG  DATA 20H
SLEC  BIT  FLAG.0
EXT	  BIT  FLAG.1
OKEY  BIT  FLAG.2
ORG 00

MAIN:
	MOV TMOD,#01H    ;TIMER 0 CHE DO 16 BIT
	SETB P3.3
	MOV R9,#12
START:	
	MOV P0,COM_
	MOV P2,ADD_
	MOV COM_,#0
	MOV ADD_,#0
	CLR OKEY
LAP:
	MOV R8,#8
LAP4:	
	CALL DELAY100
	JB P3.3,LAP
	DJNZ R8,LAP4				;KIEM TRA BIT START
LAP1:
	CALL DELAY100
	JNB P3.3,LAP1         	;CHO DONG BO
	CALL DELAY100
LAP2:
	JB P3.3,LAP2			;BAT DAU NHAN BIT DAU TIEN
LAP3:
	CALL DELAY900			;
	JNB P3.3,TIP			; XAC DINH BIT NHAN DC LA "0" HAY "1"
	CALL LGIC0	
	JMP CONT_TIP
TIP:
	CALL LGIC1
CONT_TIP:
	JNB OKEY,LAP3
	JMP START
	
	
	
LGIC0:
	CLR SLEC
	CALL NAP
	JB P3.3,$
	RET
LGIC1:
	SETB SLEC
	CALL NAP
	JNB P3.3,$
	CALL DELAY100
	JB P3.3,$
	RET
;========NHAN DU LIEU================
NAP:
	JB OKEY,CON_NAP
	CALL DICH
	DJNZ R9,CON_NAP
	MOV R9,#12
	MOV R10,#4
COMPL:
	CLR SLEC
	CALL DICH
	DJNZ R10,COMPL
	SETB OKEY
CON_NAP:
	RET
;=============DICH DU LIEU===========
DICH:
		MOV A,ADD_
		MOV C,SLEC
		RRC A
		MOV ADD_,A
		MOV A,COM_
		RRC A
		MOV COM_,A
		RET
		
		
DELAY1500:
			MOV TH0,#HIGH(-1500)
			MOV TL0,#LOW(-1500)
			SETB TR0
			JNB TF0,$
			CLR TF0
			CLR TR0
			RET
			
DELAY900:
			MOV TH0,#HIGH(-900)
			MOV TL0,#LOW(-900)
			SETB TR0
			JNB TF0,$
			CLR TF0
			CLR TR0
			RET
DELAY100:
			MOV R11,#100
			DJNZ R11,$
			RET
END