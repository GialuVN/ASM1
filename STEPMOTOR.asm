;CHUONG TRINH NHAP SO HIEN THI LED 7 DOAN (4 LED)+DIEU KHIEN DONG CO BUOC
;<<<<<<<<<<<<LU MINH THI>>>>>>>>>>>>>>>
;<<<<<<<<<<<<10/06/2009>>>>>>>>>>>>>>>>
;""""""""DINH NGHIA""""""""""""""""
;>>>BIEN HIEN THI<<<<<
D_DV DATA 30H	;SO HANG DON VI
D_CH DATA 31H	;SO HANG CHUC
D_TR DATA 32H	;SO HANG TRAM
D_NG DATA 33H	;SO HANG NGAN
;>>>>BIEN LUU TRU<<<<<
S_DV DATA 50H	; DON VI
S_CH DATA 51H	; CHUC
S_TR DATA 52H	; TRAM
S_NG DATA 53H	; NGAN
;>>>>BIEN DU LIEU TAM <<
T_DV DATA 54H
T_CH DATA 55H
T_TR DATA 56H
T_NG DATA 57H
;>>>>>>BIEN DEM<<<<<<<
C_DV DATA 58H
C_CH DATA 59H
C_TR DATA 5AH
C_NG DATA 5BH
;>>>>CAC BIEN TEMP<<<<
K	 DATA 20H
EN	 BIT  	 K.0	;CHO PHEP NHAP
DOT  BIT	 K.1	;DAU CHAM THAP PHAN HANG CHUC
INV  BIT	 K.2	;DAO CHIEU DONG CO
WAR	 BIT	 K.3	;BAO NGAT
OK 	 BIT	 K.4	;DA HOAN TAT
;>>>>>BIEN CHO FIX9<<<
C_AD DATA 58H	;SO LAN CONG
C_SU DATA 59H	;SO LAN TRU
;""""""""CHUONG TRINH""""""""""""""""
ORG 0
JMP MAIN
ORG 000BH
JMP INT_TIMER0
MAIN:
;****KHOI TAO*****
MOV IE,#82H					;CHO PHEP NGAT TIMER 0
MOV TMOD,#01				;BO DINH THOI 0, CHE DO 1
SETB EN						;CHO PHEP NHAP
MOV R0,#0					;<>
MOV R1,#0					;<>
MOV R3,#0
MOV R4,#0
MOV R5,#0
MOV R2,#0EFH				;
MOV P1,#0FFH				;
MOV P3,#00H					;XOA P3
CALL CLR_HT					;XOA TAT CA CAC LED
MOV DPTR,#LIST				;KHOI TAO CON TRO DU LIEU
MOV C_AD,#0
MOV C_SU,#0
CLR WAR
SETB INV
SETB OK
BEGIN:
		JNB WAR,CONT_WAR
		CALL CO_CO
CONT_WAR:
		LCALL CHE_KEY		;KIEM TRA PHIM
		LCALL DISP			;HIEN THI
		LCALL SWP_COL		;QUET COT
		MOV A,D_DV
		CJNE A,#10,CONT_BEGIN
		JMP BEGIN
CONT_BEGIN:
		SETB DOT
		JMP BEGIN
;**********PHIM CHUC NANG*************
;>>>>>>>>PHIM 0<<<<<<<<
KEY_0:	
		CALL SHIFT_L		;DICH SO SANG TRAI
		JNB EN,END_KEY_0	;KHONG CHO PHEP AN PHIM KHI DA DU 4 SO
		MOV D_DV,#0			;NHAP SO 0
END_KEY_0:
		CALL DISP			;HIEN THI
		JNB P1.0,$-3		;CHO NHA PHIM
		RET
;>>>>>>>PHIM 1<<<<<<<<<
		
KEY_1:	
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_1	;<>
		MOV D_DV,#1			;<>
END_KEY_1:
		CALL DISP			;<>
		JNB P1.0,$-3		;<>
		RET
;>>>>>>>>PHIM 2<<<<<<<<
KEY_2:
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_2	;<>
		MOV D_DV,#2			;<>
END_KEY_2:		
		CALL DISP			;<>
		JNB P1.0,$-3		;<>
		RET
;>>>>>>>PHIM 3<<<<<<<<
KEY_3:
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_3	;<>
		MOV D_DV,#3			;<>
END_KEY_3:
		CALL DISP			;<>
		JNB P1.1,$-3		;<>
		RET
;>>>>>>>>PHIM 4<<<<<<<<
KEY_4:
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_4	;<>
		MOV D_DV,#4			;<>
END_KEY_4:
		CALL DISP			;<>
		JNB P1.1,$-3		;<>
		RET
;>>>>>>>>PHIM 5<<<<<<<<
KEY_5:
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_5	;<>
		MOV D_DV,#5			;<>
END_KEY_5:
		CALL DISP			;<>
		JNB P1.1,$-3		;<>
		RET
;>>>>>>>>PHIM 6<<<<<<<<
KEY_6:	
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_6	;<>
		MOV D_DV,#6			;<>
END_KEY_6:
		CALL DISP			;<>
		JNB P1.2,$-3		;<>
		RET
;>>>>>>>>PHIM 7<<<<<<<<
KEY_7:	
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_7	;<>
		MOV D_DV,#7			;<>
END_KEY_7:
		CALL DISP			;<>
		JNB P1.2,$-3		;<>
		RET
;>>>>>>>>>PHIM 8<<<<<<<
KEY_8:	
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_8	;<>
		MOV D_DV,#8			;<>
END_KEY_8:
		CALL DISP			;<>
		JNB P1.2,$-3		;<>
		RET
;>>>>>>>>PHIM 9<<<<<<<<
KEY_9:
		CALL SHIFT_L		;<>
		JNB EN,END_KEY_9	;<>
		MOV D_DV,#9			;<>
END_KEY_9:
		CALL DISP			;<>
		JNB P1.3,$-3		;<>
		RET
;>>>>>>>>PHIM OK<<<<<<<
KEY_OK:
	
		SETB EN
		MOV A,D_DV
		CJNE A,#10,$+6				;CHI SAVE KHI DA NHAP SO
		JMP END_KEY_OK
		CALL SAVE_DATA				;SAVE DU LIEU
		PUSH DPH					;CAT CON TRO DU LIEU
		PUSH DPL					;<>
		PUSH D_DV
		PUSH D_CH
		PUSH D_TR
		PUSH D_NG
		MOV D_DV,#3
		MOV D_CH,#2
		MOV D_TR,#1
		MOV D_NG,#0
		MOV DPTR,#SAVE
		CLR DOT
		MOV R4,#30
		CALL DISP					;HIEN CHU SAVE
		DJNZ R4,$-3
		CALL CLR_HT					;XOA HIEN THI
		POP D_NG
		POP D_TR
		POP D_CH
		POP D_DV
		POP DPL
		POP DPH
END_KEY_OK:
		MOV A,S_DV
		CJNE A,#0,RUN_OK
		MOV A,S_CH
		CJNE A,#0,RUN_OK
		MOV A,S_TR
		CJNE A,#0,RUN_OK
		MOV A,S_NG
		CJNE A,#0,RUN_OK
		JMP END_OK
RUN_OK:
		SETB OK
		SETB TF0
END_OK:
		JNB P1.3,$
		RET
;>>>>PHIM DELETE<<<<<<<
KEY_DEL:
		CLR DOT
		SETB EN						;CHO PHEP NHAP
		MOV A,D_DV			
		CJNE A,#10,PER_KEY_DEL		;XOA HET THI NGUNG
		JMP EXIT_KEY_DEL
PER_KEY_DEL:
		CALL SHIFT_R				;DICH DU LIEU SANG PHAI
EXIT_KEY_DEL:
		CALL DISP					;HIEN THI
		JNB P1.3,$-3				;CHO NHA PHIM
		RET
;>>>>>>>PHIM OFF<<<<<<<<<<
KEY_INV:
		CPL INV
		CALL DISP
		JNB P1.3,$-3
		RET
;>>>>>>PHIM CANCEL<<<<<<<<<
KEY_CAN:
		CLR DOT
		SETB EN						;CHO PHEP NHAP
		CALL CLR_HT					;XOA HIEN THI
		CALL DISP
		JNB P1.2,$-3
		RET
;>>>>>>STOP>>>>>>>>>>>>>>>>>
KEY_STOP:
		CLR OK
		MOV C_DV,#0
		MOV C_CH,#0
		MOV C_TR,#0
		MOV C_NG,#0
		CALL DISP
		JNB P1.1,$-3
		SETB P3.6
		RET
;********LUU DU LIEU********
SAVE_DATA:
		MOV S_DV,D_DV
		MOV S_CH,D_CH
		MOV S_TR,D_TR
		MOV S_NG,D_NG
		MOV A,S_DV
;LOAI BO SO VO NGHIA (S0 10)
		CJNE A,#10,CON1_S
		MOV S_DV,#0
CON1_S:
		MOV A,S_CH
		CJNE A,#10,CON2_S
		MOV S_CH,#0
CON2_S:
		MOV A,S_TR
		CJNE A,#10,CON3_S
		MOV S_TR,#0
CON3_S:
		MOV A,S_NG
		CJNE A,#10,END_S
		MOV S_NG,#0
END_S:
		CALL T_DOT
		CALL DATA_TEM
		CALL FIX9
		RET
;********DATA-TEM************
DATA_TEM:
		MOV T_DV,S_DV
		MOV T_CH,S_CH
		MOV T_TR,S_TR
		MOV T_NG,S_NG
		RET
;*******TEM-DATA*************
TEM_DATA:
		MOV S_DV,T_DV
		MOV S_CH,T_CH
		MOV S_TR,T_TR
		MOV S_NG,T_NG
		RET

;*********CLR DU LIEU********
CLR_DATA:
		MOV S_DV,#0
		MOV S_CH,#0
		MOV S_NG,#0
		MOV S_TR,#0
		RET
;*******XOA HIEN THI*********
CLR_HT:
		MOV D_DV,#10
		MOV D_CH,#10
		MOV D_TR,#10
		MOV D_NG,#10
		RET
;*****KIEM TRA PHIM*********
CHE_KEY:
		MOV A,P1
		CJNE A,#0EEH,CONT_KEY_1		;KIEM TRA MA PHIM 0
		CALL KEY_0					;GOI CHUONG TRINH PHIM 0
		JMP EXIT
CONT_KEY_1:
		CJNE A,#0DEH ,CONT_KEY_2
		CALL KEY_1
		JMP EXIT
CONT_KEY_2:
		CJNE A,#0BEH,CONT_KEY_3
		CALL KEY_2
		JMP EXIT
CONT_KEY_3:
		CJNE A,#0EDH,CONT_KEY_4
		CALL KEY_3
		JMP EXIT
CONT_KEY_4:
		CJNE A,#0DDH,CONT_KEY_5
		CALL KEY_4
		JMP EXIT
CONT_KEY_5:
		CJNE A,#0BDH,CONT_KEY_6
		CALL KEY_5
		JMP EXIT
CONT_KEY_6:
		CJNE A,#0EBH,CONT_KEY_7
		CALL KEY_6
		JMP EXIT
CONT_KEY_7:
		CJNE A,#0DBH,CONT_KEY_8
		CALL KEY_7
		JMP EXIT
CONT_KEY_8:
		CJNE A,#0BBH,CONT_KEY_9
		CALL KEY_8
		JMP EXIT
CONT_KEY_9:
		CJNE A,#0E7H,CONT_KEY_OK
		CALL KEY_9
		JMP EXIT
CONT_KEY_OK:
		CJNE A,#0D7H,CONT_KEY_DEL
		CALL KEY_OK
		JMP EXIT
CONT_KEY_DEL:
		CJNE A,#0B7H,CONT_KEY_CAN
		CALL KEY_DEL
		JMP EXIT
CONT_KEY_CAN:
		CJNE A,#77H,CONT_KEY_INV
		CALL KEY_CAN
		JMP EXIT
CONT_KEY_INV:
		CJNE A,#7BH,CONT_KEY_STOP
		CALL KEY_INV
		JMP EXIT
CONT_KEY_STOP:
		CJNE A,#7DH,EXIT
		CALL KEY_STOP
EXIT:
		RET
;*****DICH SO SANG TRAI**********
SHIFT_L:
		MOV A,D_NG
		CJNE A,#10,EXIT_SHIFT_L		;DICH DU 4 SO CHUA
		MOV R1,#34H
		MOV R0,#D_NG
REP_SHIFT_L:
		MOV A,@R0
		MOV @R1,A
		DEC R1
		DEC R0
		CJNE R1,#2FH,REP_SHIFT_L
		JMP END_SHIFT_L
EXIT_SHIFT_L:
		CLR EN					;DU 4 SO THI KO CHO PHEP NHAP NUA	
END_SHIFT_L:
		RET
;******DICH SO SANG PHAI******
SHIFT_R:
		MOV R1,#2FH
		MOV R0,#D_DV
REP_SHIFT_R:
		MOV A,@R0
		MOV @R1,A
		INC R1
		INC R0
		CJNE R1,#34H,REP_SHIFT_R
		RET
;********QUET COT*************
SWP_COL:
		MOV P1,R2
		MOV A,R2
		RL A
		MOV R2,A
		CJNE A,#0FEH,$+6
		MOV R2,#0EFH
		RET
;******QUET LED 7 DOAN*******
DISP:	
		MOV R0,#D_DV
		MOV R1,#0F7H
REP_DISP:
		MOV A,@R0
		MOVC A,@A+DPTR		;GIAI MA LED 7 DOAN
		MOV P0,A
		MOV P2,R1
		JNB DOT,$+8
		JB P2.2,$+5
		CLR P0.7
		CALL DELAY1
		MOV P0,#0FFH		;XOA LEM
		MOV A,R1
		RR A
		MOV R1,A
		INC R0
		CJNE R0,#34H,REP_DISP
		RET
;********LAM TRON SO CHIA HET CHO 9******
FIX9:	
		INC C_AD
		MOV A,T_DV
		ADD A,T_CH
		ADD A,T_TR
		ADD A,T_NG
		MOV B,#9
		DIV AB
		MOV A,B
		CJNE A,#0,CONT1_FIX9
		JMP END1_FIX9
CONT1_FIX9:
		INC T_DV
		MOV A,T_DV
		CJNE A,#10,END_INC
		MOV T_DV,#0
		INC T_CH
		MOV A,T_CH
		CJNE A,#10,END_INC
		MOV T_CH,#0
		INC T_TR
		MOV A,T_TR
		CJNE A,#10,END_INC
		MOV T_TR,#0
		INC T_NG
		MOV A,T_NG
		CJNE A,#10,END_INC
		MOV T_DV,#9
		MOV T_CH,#9
		MOV T_TR,#9
		MOV T_NG,#9
		JMP END1_FIX9
END_INC:
		JMP FIX9
END1_FIX9:
		INC C_SU
		MOV A,S_DV
		ADD A,S_CH
		ADD A,S_TR
		ADD A,S_NG
		MOV B,#9
		DIV AB
		MOV A,B
		CJNE A,#0,CONT2_FIX9
		JMP END2_FIX9
CONT2_FIX9:
		DEC S_DV
		MOV A,S_DV
		CJNE A,#-1,END_DEC
		MOV S_DV,#9
		DEC S_CH
		MOV A,S_CH
		CJNE A,#-1,END_DEC
		MOV S_CH,#9
		DEC S_TR
		MOV A,S_TR
		CJNE A,#-1,END_DEC
		MOV S_TR,#9
		DEC S_NG
		MOV A,S_NG
		CJNE A,#-1,END_DEC
		MOV S_DV,#0
		MOV S_CH,#0
		MOV S_TR,#0
		MOV S_NG,#0
		JMP END2_FIX9
END_DEC:
		JMP END1_FIX9
END2_FIX9:
		DEC C_SU
		DEC C_AD
		MOV A,C_AD
		CJNE A,#-1,CONT_COM
		CALL TEM_DATA
		JMP END_COM
CONT_COM:
		MOV A,C_SU
		CJNE A,#-1,END2_FIX9
END_COM:
		MOV C_AD,#0
		MOV C_SU,#0
		RET
;********KIEM TRA DAU CHAM***************
T_DOT:
		JNB DOT,CONT_T_DOT
		JMP END_T_DOT
CONT_T_DOT:
		PUSH 00H
		PUSH 01H
		MOV R1,#54H
		MOV R0,#S_NG
REP_T_DOT:
		MOV A,@R0
		MOV @R1,A
		DEC R1
		DEC R0
		CJNE R1,#4FH,REP_T_DOT
		MOV S_DV,#0
		POP 01H
		POP 00H
END_T_DOT:
		RET
		
;***************TAO TRE 1mS**************
DELAY1:
		PUSH 00H
		PUSH 01H
		MOV R0,#5
REP_DELAY1:
		MOV R1,#100
		DJNZ R1,$
		DJNZ R0,REP_DELAY1
		POP 01H
		POP 00H
		RET
;**********DEM VA SO SANH******************
CO_CO:
		MOV R6,#9
REP_CO_CO:
		INC C_DV
		MOV A,C_DV
		CJNE A,#10,EX_CO_CO
		MOV C_DV,#0
		INC C_CH
		MOV A,C_CH
		CJNE A,#10,EX_CO_CO
		MOV C_CH,#0
		INC C_TR
		MOV A,C_TR
		CJNE A,#10,EX_CO_CO
		MOV C_TR,#0
		INC C_NG
		MOV A,C_NG
		CJNE A,#10,EX_CO_CO
		MOV C_NG,#0
EX_CO_CO:		
		DJNZ R6,REP_CO_CO
		MOV A,S_DV
		CJNE A,C_DV,END_CO
		MOV A,S_CH
		CJNE A,C_CH,END_CO
		MOV A,S_TR
		CJNE A,C_TR,END_CO
		MOV A,S_NG
		CJNE A,C_NG,END_CO
		MOV C_DV,#0
		MOV C_CH,#0
		MOV C_TR,#0
		MOV C_NG,#0
		CLR OK	
END_CO:
		CLR WAR
		RET
;**********CHUONG TRINH NGAT TIMER 0*******
INT_TIMER0:
		JNB OK,OUT
		MOV TH0,#HIGH(-50000)
		MOV TL0,#LOW(-50000)
		SETB TR0
		MOV A,R3
		PUSH DPL
		PUSH DPH
		JNB INV,CONT1_INV
		MOV DPTR,#HAFT
		JMP CONT2_INV
CONT1_INV:
		MOV DPTR,#INV_HAFT
CONT2_INV:
		MOVC A,@A+DPTR
		MOV P3,A
		SETB WAR
		INC R3
		CJNE R3,#8,END_INT_TIMER0
		MOV R3,#0
END_INT_TIMER0:
		POP DPH
		POP DPL		
		RETI
OUT:
		SETB OK
		CLR TR0
		CLR WAR
		RETI
;*****MA LED 7 DOAN*******
LIST:
	DB	0C0H,0F9H,0A4H,0B0H,099H,092H,082H,0F8H,080H,090H,0FFH
SAVE:
	DB	8CH,0C7H,88H,91H
;******MA DONG CO BUOC****
HAFT:
	DB 05H,01H,09H,08H,0AH,02H,06H,04H,"0"
INV_HAFT:
	DB 04H,06H,02H,0AH,08H,09H,01H,05H,"0"
FULL:
	DB 5H,09H,0AH,6H,"0"
INV_FULL:
	DB 6H,0AH,09H,5H,"0"
;*****KET THUC CHUONG TRINH*****
END
	