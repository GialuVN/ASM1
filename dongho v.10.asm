ORG 00H
JMP MAIN
ORG 000BH
LJMP NGAT
MAIN:
;=================================
;HIEN DONG CHU HAPPY...
		MOV R3,#00
LOOP3:
		CPL P3.7
		MOV R2,#10
LOOP2:	
		PUSH ACC
		MOV A,R3
		MOV R1,A
		POP ACC
		MOV R0,#0DFH
LOOP1:
		MOV DPTR,#DATA2
		MOV A,R1
		MOVC A,@A+DPTR
		MOV P1,A
		MOV P0,R0
		CALL DELAY
		MOV A,R0
		RR A
		MOV R0,A
		INC R1
		CALL XDAU
		CJNE R0,#07FH,LOOP1
		DJNZ R2,LOOP2
		INC R3
		CJNE R3,#85,LOOP3
		JMP TTUC
XDAU:
		MOV P1,#00H
		MOV P0,#0FFH
		RET

;==========================================
;THIET LAP THONG SO BAN DAU
TTUC:
		SETB P3.7
		CLR P2.7
		CLR P2.6
		CLR P2.1
		CLR P2.0
		MOV TMOD,#11H
		MOV 18H,#00H
		MOV IE,#82H
;=======================================
		
;NAP DU LIEU VAO RAM		
		MOV R1,#00H
		MOV R0,#20H
LAP4:
		MOV A,R1
		MOV DPTR,#DATA1
		MOVC A,@A+DPTR
		CJNE A,#00H,NAP1
		MOV R1,#10H
LAP5:
		MOV @R1,#00H
		INC R1
		CJNE R1,#16H,LAP5
;==========================================
;THIET LAP KHI BAT NGUON MAC DINH LA 12 GIO
		MOV R7,#12
		MOV 14H,#2
		MOV 15H,#1
		JMP SETI
		
NAP1:
		MOV @R0,A
		INC R0
		INC R1
		JMP LAP4
;================================
		
;CHUONG TRINH CHINH
SETI:
		SETB TF0
		
LAP6:
		MOV R2,#0
		MOV R5,#0
		CALL COMPA
		LJMP DEM
DELAY1S:	
		LCALL HT
		CJNE R2,#20,DELAY1S
		JMP LAP6
;=================================
;CHUONG TRINH NGAT

NGAT:
		MOV TL0,#LOW(-49986)
		MOV TH0,#HIGH(-49986)
		SETB TR0
		INC R2
		RETI
;================================
;DEM GIAY
DEM:	
		CPL 7FH
		MOV A,18H
		CJNE A,#01H,$+5
		CPL P3.7
		INC 10H
		MOV A,10H
		CJNE A,#0AH,DELAY1S
		MOV 10H,#00H
		INC 11H
		MOV A,11H
		CJNE A,#06H,DELAY1S
		MOV 11H,#00H
		INC 12H
		MOV A,12H
		CJNE A,#0AH,DELAY1S
		MOV 12H,#00H
		INC 13H
		MOV A,13H
		CJNE A,#06H,DELAY1S
		MOV 13H,#00H
		INC 14H
		MOV A,14H
		INC R7
		CJNE R7,#13,LAP
		MOV R7,#01H
		MOV 14H,#01H
		MOV 15H,#00H
		LJMP DELAY1S
LAP:
		CJNE A,#0AH,DELAY1S
		MOV 14H,#00H
		INC 15H
		LJMP DELAY1S
;================================
;SO SANH GIO HEN VOI GIO HIEN TAI		
COMPA:
		MOV A,2AH
		CJNE A,10H,EXIT1
		MOV A,2BH
		CJNE A,11H,EXIT1
		MOV A,2CH
		CJNE A,12H,EXIT1
		MOV A,2DH
		CJNE A,13H,EXIT1
		MOV A,2EH
		CJNE A,14H,EXIT1
		MOV A,2FH
		CJNE A,15H,EXIT1
		CPL P3.7
		MOV R0,#2AH
CLEAR:
		MOV @R0,#00H
		INC R0
		CJNE R0,#30H,CLEAR
EXIT1:
		RET		
;==============================
;HIEN THI RA LED
HT:
		MOV R3,#0FEH
		MOV R0,#10H
LAP2:
		MOV A,@R0
		ADD A,#20H
		MOV R1,A
		MOV P1,@R1
		MOV P0,R3
		MOV A,R3
		JB 7FH,CONTINUE
		CJNE A,#0FBH,$+5
		CPL P1.7
		CJNE A,#0EFH,$+5
		CPL P1.7
CONTINUE:
		LCALL DELAY
		INC R0
		MOV A,R3
		RL A
		MOV R3,A
		JB P2.1,GIO
		JB P2.0,PHUT
		JB P2.7,DEN
		MOV P0,#0FFH
		MOV P1,#00H
		CJNE R3,#0BFH,LAP2
		RET
;========================================	
;DIEU CHINH PHUT NHAN 1 CAI TANG 1PHUT,NHAN GIU 0.5 GIAY TANG 10PHUT
PHUT:	
		PUSH 01H
		PUSH 02H
		CLR TR0
		MOV R2,#50
		
KT2:	
		MOV R1,#1
		JNB P2.0,T1P
		LCALL DELAY6
		DJNZ R2,KT2
		CALL SUBP
		JMP EXITP
T1P:	
		PUSH ACC
		INC 12H
		MOV A,12H
		CJNE A,#0AH,THOAT1
		MOV 12H,#00H
		INC 13H
		MOV A,13H
		CJNE A,#06H,THOAT1
		MOV 13H,#00H
THOAT1:
		POP ACC
EXITP:
		POP 02H
		POP 01H
		SETB TR0
		JB P2.0,$
		RET
;=======================================
;NHAY NOI TIEP
DEN:
	JMP DEN2
GIO:
	JMP GIO2
;=============================================
;TANG 10 PHUT
SUBP:	
		PUSH 02H
		MOV R2,#10
T1PP:	
		PUSH ACC
		INC 12H
		MOV A,12H
		CJNE A,#0AH,THOAT3
		MOV 12H,#00H
		INC 13H
		MOV A,13H
		CJNE A,#06H,THOAT3
		MOV 13H,#00H
THOAT3:
		POP ACC
		DJNZ R2,T1PP
		POP 02H
		CPL P3.7
		RET
;==================================================		
;CHINH GIO NHAN 1 CAI TANG 1 GIO,GIU 1S DEN P3.7 CHOP TAT THEO GIAY
GIO2:
		PUSH 01H
		PUSH 02H
		CLR TR0
		MOV R2,#100
GKT:
		MOV R1,#1
		JNB P2.1,GIO3
		CALL DELAY6
		DJNZ R2,GKT
		MOV 18H,#01H
		CPL P3.7
		JMP THOATG
		
GIO3:	
		PUSH ACC
		INC 14H
		MOV A,14H
		INC R7
		CJNE R7,#13,LAP9
		MOV R7,#01H
		MOV 14H,#01H
		MOV 15H,#00H
		JMP	THOAT2
LAP9:
		CJNE A,#0AH,THOAT2
		MOV 14H,#00H
		INC 15H
THOAT2:
		POP ACC
THOATG:
		JB P2.1,$
		POP 02H
		POP 01H
		SETB TR0
		RET	
;=================================
;DIEU KHIEN DEN VA NHO THOI GIAN HIEN TAI BANG CACH AN GIU PHIM P2.7 LEN CAO TRONG 2 GIAY
DEN2:	
		PUSH 02H
		PUSH 01H
		MOV 18H,#00H
		CLR TR0
		CPL P3.7
		MOV R2,#100
KT:
		MOV R1,#2
		JNB P2.7,NHAY
		CALL DELAY6
		DJNZ R2,KT
		LCALL LUU
		CPL P3.7
		INC 10H
		PUSH ACC
		MOV A,10H
		CJNE A,#0AH,NHAY2
		MOV 10H,#00H
NHAY2:	
		POP ACC			
NHAY:
		POP 01H
		POP 02H
		SETB TR0
		JB P2.7,$
		RET
;====================================
;TRE 1S
DELAY6:
LAP21:	MOV TL1,#LOW(-10000)
		MOV TH1,#HIGH(-10000)
		SETB TR1
		JNB TF1,$
		CLR TR1
		CLR TF1
		DJNZ R1,LAP21
		RET	
;==================================
;TRE 2000 MICO GIAY
DELAY:	
		PUSH 04H
		PUSH 05H
		MOV R4,#20
LAP3:
		MOV R5,#100
		DJNZ R5,$
		DJNZ R4,LAP3
		POP 05H
		POP 04H
		RET
;===================================	
;LUU GIO CAN HEN VAO BO NHO

LUU:
		MOV 2AH,10H
		MOV 2BH,11H
		MOV 2CH,12H
		MOV 2DH,13H
		MOV 2EH,14H
		MOV 2FH,15H
		RET
;===================================//////===========================================

DATA1:
	DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,00H
DATA2:
	DB 00H,00H,00H,00H,76H,77H,73H,73H,6EH,00H,37H,79H,3EH,00H,6EH,79H,77H,50H
	DB 00H,40H,00H,5BH,3FH,3FH,6FH,00H,00H,00H,00H
	DB 00H,5EH,7BH,6DH,30H,06FH,54H,00H,7CH,6EH,00H,38H,3EH,00H,31H,37H,30H
	DB 37H,76H,00H,01H,31H,76H,30H,00H,00H,00H,00H,00H,0BDH,5CH,5CH,0DEH,00H,7CH,6EH,79H,82H
	DB 01H,40H,08H,08H,40H,01H,01H,40H,08H,08H,40H,01H,01H,40H,08H,08H,40H,01H,01H,40H,08H,08H,40H,01H
END