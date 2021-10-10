;/////////////////KHAI BAO BIEN///////////////////////////////
;~~~~~~~~~~~~~~~ KHAI BAO BAN PHIM ~~~~~~~~~~~~~~~~~~~~~~~~
NORM	BIT P1.0	;HIEN THI TRANG THAI CAI DAT
NORM2	BIT P1.1	;HTT TTHH FH
P_ONF	BIT P1.2	;Phim tat mo dong co
P_STA 	BIT	P1.3	;Phim de dong co
P_INC	BIT P1.4	;Phim tang gia tri cua bien/ON K1/OFF K2
P_DEC	BIT P1.5	;Phim giam gia tri cua bien/OFFK1/ON K2
P_SET	BIT	P1.6	;Phim chon cai dat
P_SLE	BIT	P1.7	;auto/chon bien
;~~~~~~~~~~~~~~~~~~~~~ BIEN XUAT DIEU KHIEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~

ONF		BIT P0.0	;ON/OFF DONG CO
STA		BIT P0.1	;KHOI DONG DONG CO
CHA		BIT P0.2	;DIEU KHIEN NAP/KO NAP ACQUI
K1		BIT	P0.3	;CUON HUT K1
K2		BIT P0.4	;CUON HUT K2
SPK		BIT	P0.5	;BAO DONG
FAL		BIT P0.6	;HIEN CHU F
LED     BIT P0.7	; HIEN THI LOI
;~~~~~~~~~~~~~~~~~~~~~ BIEN NHAN TRANG THAI HE THONG ~~~~~~~~~~~~~~~~~~
CB1		BIT P2.0	;CAM BIEN MAT/CO DIEN LUOI
CB2 	BIT P2.1	;CAM BIEN MAT/CO DIEN MAY PHAT
CB3		BIT P2.2	;CAM BIEN DONG CO CHAY HAY CHUA
KTM		BIT P2.3	;CAM BIEN KIEM TRA DAU,NUOC
BD1		BIT P2.4	;NHAN TIN HIEU TU BIEN DONG 1
BD2		BIT	P2.5	;NHAN TIN HIEU TU BIEN DONG 2 
HIP		BIT	P2.6	;DIEN AP ACQUI >13.5V
LOP		BIT	P2.7	;DIEN AP ACQUI <=12V         
;~~~~~~~~~~~~~~~ BIEN DIEU KHIEN HIEN THI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
VAR1	 EQU	25H ;hang chuc va don vi
VAR2	 EQU	26H	;Led don
PASW	 EQU	27H	;PASSWORD
OUTPUT 	 EQU 	P3	;PORT xuat ra led
TT	  	 BIT	P3.7;Hien thi trang thai
;~~~~~~~~~~~~~~~~ BIEN CAI DAT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

COU		EQU	32H		;Thu tu bien
DLO		EQU	33H		;thời gian đảm bảo điện lưới đã có trở lại	(MIN=0s,MAX=90s)
DLF		EQU	34H		;thời gian đảm bảo điện lưới đã mất			(MIN=0s,MAX=90s)
TGD		EQU	35H		;thời gian đề								(MIN=1s,MAX=10s)
SLD		EQU	36H		;số lần đề									(MIN=1lan,MAX=5lan)
TOF		EQU	37H		;thời gian làm mát máy phát trước khi tắt	(MIN=1P,MAX=9P)
TON		EQU	38H		;chờ điện máy phát ổn định					(MIN=1s,MAX=90s)
REP		EQU	39H		;sau khoảng thời gian này máy mới được 
					;khởi động lại lần nửa 						(MIN=0S,MAX=90s)
DLS		EQU 3AH		;sau khi đề xác định máy chạy hay chưa		(MIN=0s,MAX=90s)
F1		EQU 47H		;loi BD1			(MIN=0;MAX=90s)
F2		EQU	48H		;loi BD2			......................
F3		EQU 49H		;loi KTM			.......................
;~~~~~~~~~~~~~~~~~~~~~~~~~~CAC BIEN DIEU KHIEN THOI GIAN~~~~~~~~~~~~~~
TEM3	EQU	3BH		;bien tam thoi cho CT con DECODE
TEM4	EQU	3CH		;DLF
TEM5	EQU	3DH		;DLO
TEM6	EQU	3EH		;TGD
TEM7	EQU 3FH		;SLD
TEM8	EQU	40H		;TOF
TEM9	EQU	41H		;TON
TEM10	EQU 42H		;REP
TEM11	EQU	43H		;DLS
TEM12	EQU	45H		;=====60
TEM14	EQU 46H		;BIEN AM THANH
TEM15 	EQU 4AH		;F1
TEM16	EQU 4BH		;F2
TEM17 	EQU 4CH		;F3
COU2	EQU	4DH		;BIEN DEM THU TU LOI
RES		EQU 4EH		;GIU GIA TRI BIEN KHI RESET
TEM00	EQU 4FH		;HIEN THI SO LAN DE
TIME	EQU 50H		;DIEU CHINH TAN SO QUET
;~~~~~~~~~~~~~~~~~~~~~~~~~BIT NHO DAC BIET~~~~~~~~~~~~~~~~~~~~~~~~~
TEMB 	EQU 00H		;bien dieu khien cai dat/ko cai dat
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ORG		0000H
JMP 	MAIN
ORG		001BH
JMP		NGAT		
MAIN:
;//////////////////// CHUONG TRINH  ////////////////////////////
	MOV TMOD,#11H		;CHO PHEP HAI BO DINH THOI HOAT DONG CHE DO 1 16BIT
	MOV IE,#88H			;CHO PHEP NGAT DO BO DINH THOI 1
    MOV P1,#0FFH		;Thiet lap cac phim o trang thai cho
;++++++++++++++++++++
    MOV TIME,#30
    MOV PASW,#00H
    MOV P0,#0FFH
;~~~~~~~~~~MAT KHAU~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		CALL EFECT1
PASS:
		MOV P1,#0FFH
		CLR SPK
		CLR LED
REP_PASS1:
		CALL DELAY100MS
		JNB P_ONF,TIP1
		MOV A,P1
		CJNE A,#0FFH,END_PASS
		JMP REP_PASS1
TIP1:	
		CALL DELAY100MS
		JNB P_ONF,$-3
REP_TIP1:
		JNB P_ONF,TIP2
		JNB P_SET,TIP6
		JMP REP_TIP1
TIP2:	
		CALL DELAY100MS
		JNB P_ONF,$-3
		MOV A,PASW
		CJNE A,#03H,END_PASS
		JMP LOGIN
TIP6:	
		CALL DELAY100MS
		JNB P_SET,$-3
		INC PASW
REP_TIP6:
		JNB P_ONF,TIP2
		JNB P_INC,TIP4
		JNB P_SET,TIP8
		JNB P_DEC,TIP8
		JNB P_STA,TIP8
		JMP REP_TIP6
TIP4:	
		CALL DELAY100MS
		JNB P_INC,$-3
		INC PASW
REP_TIP4:
		JNB P_ONF,TIP2
		JNB P_SLE,TIP7
		JNB P_INC,TIP8
		JNB P_STA,TIP8
		JNB P_DEC,TIP8
		JMP REP_TIP4
TIP7:	
		CALL DELAY100MS
		JNB P_SLE,$-3
		INC PASW
REP_TIP7:
		JNB P_ONF,TIP2
		JNB P_SLE,TIP8
		JNB P_STA,TIP8
		JNB P_DEC,TIP8
		JMP REP_TIP7
TIP8:	
		INC PASW
		INC PASW
		INC PASW
		JMP TIP7
		
END_PASS:
		SETB SPK
		MOV PCON,#02H
		JMP $
;~~~~~~~~~~~~~~~~~LOGIN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~WELLCOME~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LOGIN:
	JNB P_INC,$
	CLR SPK
	CLR LED
	CALL EFECT3
	CALL EFECT1
	CALL EFECT2
	MOV A,P1
	MOV R0,#9
RERO:
	RLC A
	MOV P1,A
	MOV P3,A
	CLR C
	CPL FAL
	CPL TT
	CALL DELAY100MS
	CPL SPK
	DJNZ R0,RERO
	MOV P1,#0FFH
;~~~~~~~~~~~~BAO LUU GIA TRI CAI DAT KHI RESET~~~~~~~~~~~~~~~~~~~~
   	MOV A,RES
    CJNE A,#99,RES_SUB
    CALL RECAL	
    JMP KEYBOARD  
;~~~~~~~~~~~~~~ GAN GIA TRI MAC DINH CHO BIEN ~~~~~~~~~~~~~~~~~~~~
RES_SUB:
	MOV RES,#99			
	MOV TEM00,#1	
	MOV TEM12,#60
	CLR TEMB
	CALL DEFAULT
;~~~~~~~~~~~~~~~~~~~CHUONG TRINH CHINH~~~~~~~~~~~~~~~~~~~~~~~~~
          
KEYBOARD:	
		JNB P_SLE,$
		SETB LED		;KHONG HIEN LED
		CLR SPK			;TAT LOA
		SETB FAL		;KHONG HIEN THI CHU F
		CALL HT_CB
		CALL CHARGE
		JNB P_INC,SUBP_INC
		JNB P_DEC,SUBP_DEC
		JNB	P_ONF,SUBP_ONF
		JNB	P_STA,SUBP_STA
RETURN_SUBTEM:
		JNB P_SET,SUBP_SET
		MOV A,TEMB
		CJNE A,#0,$+6
		JMP EXIT_SET
		CJNE A,#1,$+6
		JMP SUBTEM1
		CJNE A,#2,$+6
		JMP SUBTEM2
		JMP RETURN_SUBTEM
EXIT_SET:
		JNB P_SLE,SUBP_AUT
		MOV P1,#0FFH	
		JMP KEYBOARD
;+++++++++++++++NHAY NOI TIEP++++++++++++++++++++++++++++++++
SUBP_AUT:
		JMP SUBP_AUT1
;~~~~~~~~~~~~~~CAC CHUONG TRINH SUBxxx~~~~~~~~~~~~~~~~~~~~~~~
          
;`````````````````````````OFF K2,ON K1```````````````````````
SUBP_DEC:	
		SETB K1
		JNB K1,$
		CLR TT
		CALL CONTACT
		CPL K2
		CALL DELAY10MS
		JNB P_DEC,$-3
		JMP KEYBOARD
;```````````````````````````OFF K1,ON K2```````````````````````
SUBP_INC:		
		SETB K2
		JNB K2,$
		CLR TT
		CALL CONTACT
		CPL K1
		CALL DELAY10MS
		JNB P_INC,$-3
		JMP KEYBOARD
;```````````````````````ON/OF DONG CO MAY PHAT``````````````````````````
SUBP_ONF:
		JNB P_ONF,$
		CPL ONF
		JNB ONF,EXIT1_ONF
		CLR TT
		CALL EFECT2
		JMP EXIT_ONF
EXIT1_ONF:
		CLR TT
		CALL EFECT1
EXIT_ONF:		
		CALL DELAY10MS
		JNB P_ONF,$-3
		JMP KEYBOARD
;`````````KHOI DONG MAY PHAT( CHI KHI MAY PHAT TAT)``````````````````````
SUBP_STA:	
		JNB K2,EXIT_SUBP_STA
		JNB CB3,EXIT_SUBP_STA
		CLR STA
EXIT_SUBP_STA:
		CLR TT
		CALL DELAY10MS
		JNB P_STA,$-3
		SETB STA
		JMP KEYBOARD
          
;```````DAO BIEN TEM(THIET LAP TRANG THAI CAI DAT HAY THOAT CA DAT)````````
SUBP_SET:	
		INC TEMB
		MOV A,TEMB
		CJNE A,#3,$+5
		MOV TEMB,#0
		CLR TT
		CALL EFECT4
		CALL DELAY10MS
		JNB P_SET,$-3
		JMP RETURN_SUBTEM
;~~~~~~~~CHUONG TRINH CAI DAT CAC THONG SO CHO CHE DO AUTO~~~~~~~~~~~~~~~~
          
SUBTEM1:
		JNB P_ONF,SUBTEMP_ONF
		JNB P_STA,SUBTEMP_STA
		JNB P_SLE,SUBTEMP_SLE
		JNB P_INC,SUBTEMP_INC
		JNB P_DEC,SUBTEMP_DEC
		CALL HT_VAR
		SETB FAL
		CLR LED
		CLR NORM
		LJMP RETURN_SUBTEM
          
;~~~~~~~~~~~~~~~~CHUONG TRINH SUBTEMxxx~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~DEFAULT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBTEMP_ONF:
		CLR SPK
		CALL EFECT3
		CALL DEFAULT
		JNB P_ONF,$-3
		JMP SUBTEM1
;~~~~~~~~~~~CHAY HIEU UNG/LOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUBTEMP_STA:
		CLR TT
		CALL EFECT3
		MOV P3,#0B1H
		CLR FAL
		CALL DELAY500MS
		SETB SPK
		CALL DELAY500MS
		CLR SPK
		CALL DELAY500MS
		SETB FAL
		CALL EFECT2
		MOV P3,#0B3H
		CLR FAL
		SETB SPK
		CALL DELAY500MS
		CALL DELAY500MS
		CLR SPK
		CALL EFECT1
		CALL ERO4
		CALL EFECT2
		CALL ERO5
		CALL EFECT3
		CALL ERO6
		CALL EFECT4
		CLR TT
		CALL CONTACT
		JMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~CHON LOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB2_SLE:			
		INC COU2
		MOV A,COU2
		CJNE A,#4,$+6
		MOV COU2,#1
		CALL HT_VAR2
		JNB P_SLE,$-3
		JMP SUBTEM2
SUBTEMP_DEC:
			JMP SUBTEMP1_DEC
SUBTEMP_INC:
			JMP SUBTEMP1_INC


;````````````````````CHON THU TU BIEN TU 1-6`````````````````````````
SUBTEMP_SLE:
		INC COU
		MOV A,COU
		CJNE A,#9,$+6
		MOV COU,#1
		CALL HT_VAR
		JNB P_SLE,$-3
		JMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~~~~~~GAN BIEN VAO BIEN HIEN THI~~~~~~~~~~~~~~~~~
;Tuong ung voi tung gia tri cua COU se hien thi gia tri cua bien tuong ung
INSERT_VAR:
		MOV VAR2,COU	;Hien thi thu tu bien
		MOV A,VAR2
		CJNE A,#1,$+6	
		MOV TEM3,DLF	
		CJNE A,#2,$+6	
		MOV TEM3,DLO	
		CJNE A,#3,$+6
		MOV TEM3,TGD	
		CJNE A,#4,$+6	
		MOV TEM3,SLD
		CJNE A,#5,$+6
		MOV TEM3,TOF
		CJNE A,#6,$+6
		MOV TEM3,TON
		CJNE A,#7,$+6
		MOV TEM3,REP
		CJNE A,#8,$+6
		MOV TEM3,DLS
		RET
;~~~~~~~~~~~~~~~~~TANG GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP1_INC:
		CALL RESEACH
		CALL HT_VAR
		JNB P_INC,$-3
		LJMP SUBTEM1		
;~~~~~~~~~~~~~~~~~GIAM GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP1_DEC:
		CALL RESEACH
		CALL HT_VAR
		JNB P_DEC,$-3
		LJMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~~~~~~THAM DO BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
RESEACH:
		MOV A,COU
		CJNE A,#1,$+6
		CALL F_DLF
		CJNE A,#2,$+6
		CALL F_DLO
		CJNE A,#3,$+6
		CALL F_TGD
		CJNE A,#4,$+6
		CALL F_SLD
		CJNE A,#5,$+6
		CALL F_TOF
		CJNE A,#6,$+6
		CALL F_TON
		CJNE A,#7,$+6
		CALL F_REP
		CJNE A,#8,$+6
		CALL F_DLS
		RET
;~~~~~~~~~~~~~~TANG/GIAM BIEN DLF~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_DLF:
		JB P_INC,CONT_DLF
		INC DLF
		MOV A,DLF
		CJNE A,#91,EXIT_F_DLF
		MOV DLF,#0
		JMP EXIT_F_DLF
CONT_DLF:
		DEC DLF
		MOV A,DLF
		CJNE A,#-1,$+6
		MOV DLF,#90
EXIT_F_DLF:
		RET
;~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLO~~~~~~~~~~~~~~~~~~~~~~
F_DLO:	
		JB P_INC,CONT_DLO
		INC DLO
		MOV A,DLO
		CJNE A,#91,EXIT_F_DLO
		MOV DLO,#0
		JMP EXIT_F_DLO
CONT_DLO:
		DEC DLO
		MOV A,DLO
		CJNE A,#-1,$+6
		MOV DLO,#90
EXIT_F_DLO:
		RET
;~~~~~~~~~~~~TANG/GIAM GIA RI TGD~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_TGD:
		JB P_INC,CONT_F_TGD
		INC TGD
		MOV A,TGD
		CJNE A,#11,EXIT_F_TGD
		MOV TGD,#1
		JMP EXIT_F_TGD
CONT_F_TGD:
		DEC TGD
		MOV A,TGD
		CJNE A,#0,$+6
		MOV TGD,#10
EXIT_F_TGD:
		RET
;~~~~~~~~~~~~~~~~~TANG/GIAM  GIA TRI SLD ~~~~~~~~~~~~~~~~~~
F_SLD:
		JB P_INC,CONT_F_SLD
		INC SLD
		MOV A,SLD
		CJNE A,#6,EXIT_F_SLD
		MOV SLD,#1
		JMP EXIT_F_SLD
CONT_F_SLD:
		DEC SLD
		MOV A,SLD
		CJNE A,#0,$+6
		MOV SLD,#5
EXIT_F_SLD:
		RET
;~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI TOF~~~~~~~~~~~~~~~~~~~~~~~
F_TOF:	
		JB P_INC,CONT_F_TOF
		INC TOF
		MOV A,TOF
		CJNE A,#11,EXIT_F_TOF
		MOV TOF,#1
		JMP EXIT_F_TOF
CONT_F_TOF:
		DEC TOF
		MOV A,TOF
		CJNE A,#0,$+6
		MOV TOF,#9
EXIT_F_TOF:
		RET
;~~~~~~~~~~~~~~~~TANG/GIAM GAI TRI TON~~~~~~~~~~~~~~~~~~~~~~~
F_TON:
		JB P_INC,CONT_F_TON
		INC TON
		MOV A,TON
		CJNE A,#91,EXIT_F_TON
		MOV TON,#1
		JMP EXIT_F_TON
CONT_F_TON:
		DEC TON
		MOV A,TON
		CJNE A,#0,$+6
		MOV TON,#90
EXIT_F_TON:
		RET
;~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI REP~~~~~~~~~~~~~~~~~~~~~
F_REP:
		JB P_INC,CONT_F_REP
		INC REP
		MOV A,REP
		CJNE A,#91,EXIT_F_REP
		MOV REP,#0
		JMP EXIT_F_REP
CONT_F_REP:
		DEC REP
		MOV A,REP
		CJNE A,#-1,$+6
		MOV REP,#90
EXIT_F_REP:
		RET
;~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI DLS~~~~~~~~~~~~~~~~~
F_DLS:
		JB P_INC,CONT_F_DLS
		INC DLS
		MOV A,DLS
		CJNE A,#91,EXIT_F_DLS
		MOV DLS,#0
		JMP EXIT_F_DLS
CONT_F_DLS:
		DEC DLS
		MOV A,DLS
		CJNE A,#-1,$+6
		MOV DLS,#90
EXIT_F_DLS:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~CAI DAT LOI~~~~~~~~~~~~~~~~~~~~
SUBTEM2:
		JNB P_ONF,SUB2_ONF
		JNB P_STA,SUB2_STA
		JNB P_SLE,SUB22_SLE
		JNB P_INC,SUB2_INC
		JNB P_DEC,SUB2_DEC
		CLR LED
		CLR NORM
		CLR NORM2
		CALL HT_VAR2
		CLR FAL
		JMP RETURN_SUBTEM
;~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB2_DEC:
		JMP SUB21_DEC
SUB2_INC:
		JMP SUB21_INC
SUB22_SLE:
		JMP SUB2_SLE

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~GIAM TAN SO QUET~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB2_ONF:
			MOV A,TIME
			ADD A,#5
			MOV TIME,A
			CJNE A,#255,EXIT_SUBTEMP_ONF
			MOV TIME,#30
	EXIT_SUBTEMP_ONF:
			CALL HT_VAR2
			JNB P_ONF,$-3
			JMP SUBTEM2
;~~~~~~~~~~~~~~~~~TANG TAN SO QUET~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB2_STA:
			MOV A,TIME
			SUBB A,#5
			MOV TIME,A
			CJNE A,#0,EXIT_SUBTEMP_STA
			MOV TIME,#30
	EXIT_SUBTEMP_STA:
			CALL HT_VAR2
			JNB P_STA,$-3
			JMP SUBTEM2

;~~~~~~~~~~~~~~CHEN BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INST2:			
		MOV VAR2,COU2	;Hien thi thu tu bien
		MOV A,VAR2
		CJNE A,#1,$+6	
		MOV TEM3,F1	
		CJNE A,#2,$+6	
		MOV TEM3,F2	
		CJNE A,#3,$+6
		MOV TEM3,F3	
		RET
;~~~~~~~~~~~~~~~~THAM DO BIEN LOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RESEACH2:
		MOV A,COU2
		CJNE A,#1,$+6
		CALL F_F1
		CJNE A,#2,$+6
		CALL F_F2
		CJNE A,#3,$+6
		CALL F_F3
		RET
;~~~~~~~~~~~~~~~~~~TANG~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB21_INC:
		CALL RESEACH2
		CALL HT_VAR2
		JNB P_INC,$-3
		LJMP SUBTEM2		
;~~~~~~~~~~~~~~~~~~GIAM~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB21_DEC:
		CALL RESEACH2
		CALL HT_VAR2
		JNB P_DEC,$-3
		LJMP SUBTEM2
;~~~~~~~~~~~~~~~~~~	TANG GIAM F1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_F1:
		JB P_INC,CONT_F1
		INC F1
		MOV A,F1
		CJNE A,#91,EXIT_F1
		MOV F1,#0
		JMP EXIT_F1
CONT_F1:
		DEC F1
		MOV A,F1
		CJNE A,#-1,$+6
		MOV F1,#90
EXIT_F1:
		RET		
;~~~~~~~~~~~~~~~~~~TANG GIAM F2~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
	F_F2:
		JB P_INC,CONT_F2
		INC F2
		MOV A,F2
		CJNE A,#91,EXIT_F2
		MOV F2,#0
		JMP EXIT_F2
CONT_F2:
		DEC F2
		MOV A,F2
		CJNE A,#-1,$+6
		MOV F2,#90
EXIT_F2:
		RET				
			
;~~~~~~~~~~~~~~~~~~TANG GIAM F3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	F_F3:
		JB P_INC,CONT_F3
		INC F3
		MOV A,F3
		CJNE A,#91,EXIT_F3
		MOV F3,#0
		JMP EXIT_F3
CONT_F3:
		DEC F3
		MOV A,F1
		CJNE A,#-1,$+6
		MOV F3,#90
EXIT_F3:
		RET							
;/////////////~CHUONG TRINH CHE DO TU DONG~/////////////////////

          
SUBP_AUT1:
		MOV TEM4,DLF
		MOV TEM5,DLO
		MOV TEM6,TGD
		MOV TEM7,SLD
		MOV TEM8,TOF
		MOV TEM9,TON
		MOV TEM10,REP
		MOV TEM11,DLS
		MOV TEM12,#60
		MOV TEM15,F1
		MOV TEM16,F2
		MOV TEM17,F3
		MOV TEM00,#1
;~~~~~~~~THIET LAP CHE DO MAC DINH KHI BAT DAU CHE DO AUTO~~~~~~
		SETB K2
		CALL CONTACT
		CLR K1
;~~~~~~~~~~~~~~~~~~~~~~~~~~KIEM TRA CB1~~~~~~~~~~~~~~~~~~~~~~~~
SUB_CB1:
		CLR SPK					;TAT LOA
		SETB FAL				;TAT HIEN THI CHU F
		CALL CHARGE
		JNB P_SLE,KEYBOARD2
		JB CB1,SUB1_CB1		;Kiem tra dien luoi
		JNB BD1,SUB_BD1			;Kiem tra bien dong 1
		MOV A,DLF
		CJNE A,#0,SUB_DLF		;Kiem tra bien DLF co bang 0 chua?
		MOV DLF,TEM4
		JNB CB3,SUB_CB3			;Kiem tra may co chay khong?
		SETB K2
		CALL CONTACT
		CLR K1
		JMP SUB_CB1
SUB_BD1:
		CLR FAL					;LOI F1
REPEAT_F1:
		CPL SPK
		JB BD1,EXIT2_F1
		JNB P_SLE,KEYBOARD2
		MOV A,F1
		CJNE A,#-1,ERRO2_F1
		SETB K1
		CALL RECAL
		JMP KEYBOARD
EXIT2_F1:
		MOV F1,TEM15
		JMP SUB_CB1
ERRO2_F1:
		MOV VAR2,#1
		MOV TEM3,F1
		CALL DELAYHTS
		DEC F1
		JMP REPEAT_F1
		
SUB_CB3:
		JB CB2,SUB_CB2			;Neu may co chay thi kiem tra CB2 Co dien khong?
		CALL EFECT1
		JMP MAINT				;NHAY DEN "CHUONG TRINH THU 3"
SUB_DLF:
		MOV VAR2,#0FH
		MOV TEM3,DLF
		CALL DELAYHTS
		DEC DLF
		SETB FAL
		MOV DLO,TEM5
		JMP SUB_CB1
SUB_CB2:
		CALL ERO5				;LOI F5
		JNB P_SLE,KEYBOARD2
		JMP SUB_CB3
;~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD2:
		CALL RECAL
		JMP KEYBOARD
SUBB2_CB3:
		JMP SUB2_CB3
SUBB1_BD2:
		JMP SUB1_BD2
SUBB1_DLO:
		JMP SUB1_DLO
SUBB1_KTM:
		JMP SUB1_KTM
SUBB11_K2:
		JMP SUBB1_K2
SUBF11_CB1:
		JMP SUBF_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB1_CB1:
		JNB KTM,SUBB1_KTM		;Kiem tra may(dau, nuoc)
		JNB BD2,SUBB1_BD2		;Kiem tra qua dong ?
		MOV A,DLO
		CJNE A,#0,SUBB1_DLO		;dem
		MOV DLO,TEM5
RESUB1_K2:
		JNB CB3,SUBB2_CB3		;Kt may chay hay chua?
		JNB K2,SUBB11_K2		;kiem tra K2 xem co ON chua?
		SETB K1
		SETB K2
		CLR ONF					;MO MAY
		CALL EFECT1
REPEAT_STA:
		CLR STA					;DE
		MOV A,TGD
		CJNE A,#0,SUB1_TGD
		MOV TGD,TEM6
		SETB STA				;NGUNG DE
REPEAT_DLS:
		MOV A,DLS
		CJNE A,#0,SUB_DLS
		MOV DLS,TEM11
		JNB CB3,SUB33_CB3		;KIEM TRA MAY CHAY CHUA
		DEC SLD
		PUSH 00H
		CALL EFECT4
		INC TEM00
		MOV R0,#50
REDIS:
		MOV VAR2,TEM00
		MOV VAR1,#0FFH
		CALL DISPLAY
		DJNZ R0,REDIS
		POP 00H
		MOV A,SLD
		CJNE A,#0,REPEAT_STA
		MOV SLD,TEM7
REPEAT_ERO6:
		CALL ERO6				; LOI F6
		JNB CB1,SUB22_CB2
		JNB P_SLE,KEYBOARD11
		JMP REPEAT_ERO6
SUB22_CB2:
		SETB ONF
		SETB K2
		CALL EFECT2
		CLR K1
		CALL RECAL
		JMP KEYBOARD
SUB_DLS:
		MOV VAR2,#0FH
		MOV TEM3,DLS
		CALL DELAYHTS
		DEC DLS
		JMP REPEAT_DLS
SUB1_TGD:
		MOV VAR2,#0FH
		MOV TEM3,TGD
		CALL DELAYHTS
		DEC TGD
		JMP REPEAT_STA
SUB33_CB3:
		CALL EFECT2
SUB3_CB3:
		MOV SLD,TEM7
		JB CB2,SUB4_CB2
		MOV A,TON
		CJNE A,#0,SUB1_TON
		MOV TON,TEM9
		CALL EFECT1
		JMP MAINT
SUB1_TON:
		MOV VAR2,#0FH
		MOV TEM3,TON
		CALL DELAYHTS
		DEC TON
		JMP SUB3_CB3
SUB4_CB2:
		CALL ERO5				;LOI F5
		JNB CB1,SUBF112_CB1
		JNB P_SLE,KEYBOARD1
		JMP SUB4_CB2
;~~~~~~~~~~~TAT MAY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD11:
		CALL RECAL
		JMP KEYBOARD
SUBF112_CB1:
		JMP SUBF_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB1_KTM:
		CLR FAL					; LOI F3
REPEAT_F3:
		SETB SPK
		JB KTM,EXIT2_F3
		JNB P_SLE,KEYBOARD1
		MOV A,F3
		CJNE A,#-1,ERRO_F3
		SETB ONF
		CALL RECAL
		JMP KEYBOARD
EXIT2_F3:
		MOV F3,TEM17
		JMP SUB_CB1
ERRO_F3:
		MOV VAR2,#3
		MOV TEM3,F3
		CALL DELAYHTS
		DEC F3
		JMP REPEAT_F3
;~~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~

KEYBOARD1:
		CALL RECAL
		JMP KEYBOARD
SUBB1_K2:
		JMP SUB1_K2

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUB1_BD2:
		CLR FAL				; LOI F2
REPEAT_F2:
		CPL SPK
		JB BD2,EXIT2_F2
		JNB P_SLE,KEYBOARD1
		MOV A,F2
		CJNE A,#-1,ERRO_F2
		SETB K2
		CALL RECAL
		JMP KEYBOARD
EXIT2_F2:
		MOV F2,TEM16
		JMP SUB_CB1
ERRO_F2:
		MOV VAR2,#2
		MOV TEM3,F2
		CALL DELAYHTS
		DEC F2
		JMP REPEAT_F2
SUB1_DLO:					;hien thi bien dem
		MOV VAR2,#0FH
		MOV TEM3,DLO
		CALL DELAYHTS
		DEC DLO
		SETB FAL
		MOV DLF,TEM4
		JMP SUB_CB1
SUB2_CB3:
		JB CB2,SUB2_CB2
		SETB K1
		CALL CONTACT
        CLR K2
        JMP SUB_CB1
SUB2_CB2:
		CALL ERO5			;LOI F5
		JNB CB1,SUBF_CB1
		JNB P_SLE,KEYBOARD1
		JMP SUB2_CB3
SUB1_K2:
		CALL ERO4			;LOI F4 
		JNB CB1,SUBF_CB1
		JNB P_SLE,KEYBOARD1
		JMP RESUB1_K2
;~~~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~
KEYBOARD3:	
			CALL RECAL
			JMP KEYBOARD
SUBB4_CB1:
			JMP SUB4_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MAINT:
		MOV DLF,#00H
		MOV DLO,#00H
SUBF_CB1:
		SETB FAL
		CLR SPK
		JNB P_SLE,KEYBOARD3
		JB CB1,SUBB4_CB1		
		MOV DLO,TEM5
		MOV A,DLF
		CJNE A,#0,SUB5_DLF
		SETB K2
		MOV VAR2,TOF
		MOV TEM3,TEM12
		CPL LED
		MOV P1,#00H
		CALL DELAYHTS
		MOV P1,#0FFH
		CLR K1
		JNB KTM,SUB5_KTM
		JNB BD1,SUB5_BD1
		DJNZ TEM12,SUB_TEM12
		MOV TEM12,#60
		DJNZ TOF,SUBF_CB1
		MOV TOF,TEM8
END_SUB:
		CALL EFECT2
		SETB FAL 
		SETB K2
		CALL EFECT1
		CLR K1
		SETB ONF		
REPEAT_REP:
		MOV A,REP
		CJNE A,#0,SUB_REP
		MOV REP,TEM10
		MOV DLF,TEM4
		CALL EFECT1
		CALL RECAL		;TRA LAI CAC GIA TRI CAI DAT
		JMP SUB_CB1
SUB_REP:
		MOV VAR2,#0FH
		MOV TEM3,REP
		CALL DELAYHTS
		DEC REP
		JMP REPEAT_REP
SUB5_DLF:
		MOV VAR2,#0FH
		MOV TEM3,DLF
		CALL DELAYHTS
		DEC DLF
		SETB FAL
		JMP SUBF_CB1
SUB_TEM12:
		SETB FAL
		JMP SUBF_CB1
SUB5_KTM:
		CLR FAL			;F3
REPEAT5_F3:
		SETB SPK
		JB KTM,EXIT5_F3
		JNB P_SLE,KEYBOARD44
		MOV A,F3
		CJNE A,#-1,ERRO5_F3
		SETB ONF
		CALL RECAL
		JMP KEYBOARD
EXIT5_F3:
		MOV F3,TEM17
		JMP SUBF_CB1
ERRO5_F3:
		MOV VAR2,#3
		MOV TEM3,F3
		CALL DELAYHTS
		DEC F3
		JMP	REPEAT5_F3		
SUB5_BD1:
		CLR FAL			;LOI F1
REPEAT5_F1:
		CPL SPK
		JB BD1,EXIT5_F1
		JB CB1,SUBF2_CB1
		JNB P_SLE,KEYBOARD44
		MOV A,F1
		CJNE A,#-1,ERRO5_F1
		SETB K1
		CALL RECAL
		JMP KEYBOARD

EXIT5_F1:
		MOV F1,TEM15
		JMP SUBF_CB1
ERRO5_F1:
		MOV VAR2,#1
		MOV TEM3,F1
		CALL DELAYHTS
		DEC F1
		JMP REPEAT5_F1
;~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~
END_SUB1:
			JMP END_SUB
KEYBOARD44:
		CALL RECAL
		JMP KEYBOARD
SUBF2_CB1:
		JMP SUBF_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB4_CB1:
		MOV DLF,TEM4
		MOV A,DLO
		CJNE A,#0,SUB5_DLO
		SETB K1
		CPL LED
		PUSH 00H
		CALL CONTACT
		MOV R0,#50
REPHT_CB:
		CALL HT_CB
		DJNZ R0,REPHT_CB
		POP 00H
		CLR K2
		JNB KTM,SUB8_KTM
		JNB BD2,SUB8_BD2
		JB  CB3,SUB8_CB3
		JB CB2,SUB8_CB2
SUB8_TOF:
		MOV TEM12,#60
		MOV TOF,TEM8
		SETB FAL
		JMP SUBF_CB1
SUB5_DLO:
		MOV VAR2,#0FH
		MOV TEM3,DLO
		CALL DELAYHTS
		DEC DLO
		SETB FAL
		JMP SUBF_CB1
SUB8_CB3:
		CALL ERO4				;LOI F4
		JNB CB1,END_SUB1
		JNB P_SLE,KEYBOARD4
		JNB CB3,SUB4_CB1
		JMP SUB8_CB3
SUB8_CB2:	
 		CALL ERO5				;LOI F5
 		JNB CB1,SUBF2_CB1
		JNB P_SLE,KEYBOARD4
		JNB CB2,SUB4_CB1
		JMP SUB8_CB2

SUB8_KTM:
		CLR FAL					;LOI F3
REPEAT2_F3:
		SETB SPK
		JB KTM,EXIT4_F3
		JNB P_SLE,KEYBOARD4
		MOV A,F3
		CJNE A,#-1,ERRO4_F3
		SETB ONF
		CALL RECAL
		JMP KEYBOARD
EXIT4_F3:
		MOV F3,TEM17
		JMP SUBF_CB1
ERRO4_F3:
		MOV VAR2,#3
		MOV TEM3,F3
		CALL DELAYHTS
		DEC F3
		JMP REPEAT2_F3
SUB8_BD2:
		CLR FAL					;LOI F2
REPEAT4_F2:
		CPL SPK
		JB BD2,EXIT4_F2
		JNB CB1,SUBF22_CB1
		JNB P_SLE,KEYBOARD4
		MOV A,F2
		CJNE A,#-1,ERRO4_F2
		SETB K2
		CALL RECAL
		JMP KEYBOARD
EXIT4_F2:
		MOV F2,TEM16
		JMP SUBF_CB1
ERRO4_F2:
		MOV VAR2,#2
		MOV TEM3,F2
		CALL DELAYHTS
		DEC F2
		JMP	REPEAT4_F2
;~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD4:
		CALL RECAL
		JMP KEYBOARD
SUBF22_CB1:
		JMP SUBF_CB1 
;~~~~~~~~~~~~~~~~~~~~~THIET LAP GIA TRI BIEN~~~~~~~~~~~~~~~~~~~~~~~
RECAL:
		MOV DLF,TEM4
		MOV DLO,TEM5
		MOV TGD,TEM6
		MOV SLD,TEM7
		MOV TOF,TEM8
		MOV TON,TEM9
		MOV REP,TEM10
		MOV DLS,TEM11
		MOV TEM12,#60
		MOV F1,TEM15
		MOV F2,TEM16
		MOV F3,TEM17
		MOV TEM00,#1
		RET
;~~~~~~~~~~~TRA LAI CAC THONG SO MAC DINH~~~~~~~~~~~~~~~~~~~~~~~~~
DEFAULT:
	MOV TIME,#30
	MOV COU,#1
	MOV DLF,#2
	MOV DLO,#2
	MOV TGD,#1
	MOV SLD,#2
	MOV TOF,#5
	MOV TON,#5
	MOV REP,#15
	MOV DLS,#3
	MOV COU2,#1
	MOV F1,#5
	MOV F2,#5
	MOV F3,#10
	RET
;~~~~~~~~~~~~~HIEN THI TRANG THAI CUA CB1,CB2,CB3~~~~~~~~~~~~~~~~

HT_CB:	
		PUSH PSW
		MOV VAR1,#00H
		MOV VAR2,#00H
		MOV C,CB2
		CPL	C
		MOV 28H,C		;CB2 hien thi tren hang DV
		MOV C,CB1
		CPL C
		MOV 2CH,C		;CB1 hien thi tren hang chuc	
		MOV C,CB3		
		CPL C
		MOV 30H,C		;CB3 hien thi tren led 3
		CALL DISPLAY
		POP PSW
		RET
;~~~~~~~~~~~~~~~~~~~~~HIEN THI BIEN CAI DAT~~~~~~~~~~~~~~~~
HT_VAR:
		CALL INSERT_VAR
		CALL HT_NO
		RET
;~~~~~~~~~~~~~~~~~~~~~HT THU TU LOI~~~~~~~~~~~~~~~~~~~~~~~~
HT_VAR2:
		CALL INST2
		CALL HT_NO
		RET
;~~~~~~~~~~~~~~~~~~~~~~~HIEN THI+GIAI MA~~~~~~~~~~~~~~~~~~~
HT_NO:
		CALL DECODE
		CALL DISPLAY
		RET
;~~~~~~~~~~~~~~~~~~GIAI MA HEX-DEC(0-99)~~~~~~~~~~~~~~~~~~
          
DECODE:	
		MOV A,TEM3			;chuyen bien so HEX  vao A
		MOV DPTR,#LIST1		;lay dia chi  du lieu dau tien
		MOVC A,@A+DPTR		;lay so DEC tuong ung
		MOV VAR1,A			;luu vao bien hien thi
		RET
          
;~~~~~~~~~~~~~~~~~~~CHUONG TRINH HIEN THI~~~~~~~~~~~~~~~~~
DISPLAY:
		MOV A,VAR1
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0D0H			;chen bit chon led hang don vi
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAYVAR		;tre 1000us
		MOV OUTPUT,#0F0H	;xoa lem
		MOV A,VAR1			;gan gia tri bien1 vao A
		SWAP A				;dao 4 bit cao thanh 4bit thap
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0E0H			;chen bit chon led cho hang chuc
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAYVAR		;goi tre
		MOV OUTPUT,#0F0H	;xoa lem
		MOV A,VAR2			;gan gia tri bien2 vao a
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0B0H			;chen bit chon chan led
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAYVAR		;goi tre
		MOV OUTPUT,#0F0H	;xoa lem		
		RET	
		
;~~~~~~~~~~~~~~~~~~CHUONG TRINH TRE CO HIEN THI~~~~~~~~~~~~~~~
DELAYHTS:	
		PUSH 07H
		SETB TF1
		MOV R7,#0
REPEAT1_HTS:
		CALL HT_NO
		CJNE R7,#20,REPEAT1_HTS
		CLR TR1
		MOV TL1,#LOW(-50000)
		MOV TH1,#HIGH(-50000)
		POP 07H
		RET

 ;~~~~~~~~~~~~~~~~~~~~DELAY 2ms~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DELAYVAR:
		PUSH 00H
		PUSH 01H	
		MOV R1,TIME
REPEATVAR:
		MOV R0,#100
		DJNZ R0,$
		DJNZ R1,REPEATVAR
		POP 01H
		POP 00H
		RET
;~~~~~~~~~~~~~DELAY 10ms~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DELAY10MS:
		PUSH 00H
		PUSH 01H
		MOV R0,#50
REPEAT10MS:
		MOV R1,#200
		DJNZ R1,$
		DJNZ R0,REPEAT10MS
		POP 01H
		POP 00H
		RET
;~~~~~~~~~~~~~~~~DELAY 100ms~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DELAY100MS:
		PUSH 02H
		MOV R2,#10
REPEAT_DELAY100MS:
		CALL DELAY10MS
		DJNZ R2,REPEAT_DELAY100MS
		POP 02H
		RET
;~~~~~~~~~~~DELAY 500ms~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DELAY500MS:
		PUSH 02H
		MOV R2,#50
REPEAT_DELAY500MS:
		CALL DELAY10MS
		DJNZ R2,REPEAT_DELAY500MS
		POP 02H
		RET
;~~~~~~~~~~~~CHUONG TRINH NAP ACQUI~~~~~~~~~~~~~~~~~~~~~~~~
CHARGE:
		JB LOP,CONT_CHARGE
		CLR CHA				;bat dau nap acqui
		JMP EXIT_CHARGE
CONT_CHARGE:
		JB HIP,EXIT_CHARGE	;Ngung nap acqui
		SETB CHA
EXIT_CHARGE:
		RET
;~~~~~~~~~~~~HIEN LOI VA BAO DONG~~~~~~~~~~~~~~~~~~~~~~~~
ERO4:
		MOV P3,#0B4H
		CLR FAL
		MOV TEM14,#2
		CALL SOUND
		RET
ERO5:
		MOV P3,#0B5H
		CLR	FAL
		MOV TEM14,#6
		CALL SOUND
		RET
ERO6:
		MOV P3,#0B6H
		CLR FAL
		MOV TEM14,#12
		CALL SOUND
		RET
;~~~~~~~~~~~~~AM THANH CANH BAO~~~~~~~~~~~~~~~~~~~~~~~~
SOUND:
		PUSH 02H
		CLR SPK
		MOV R2,TEM14
REPEAT_ERROR1:	
		CPL SPK
		CPL TT
		CALL DELAY10MS
		CALL DELAY10MS
		JNB P_SLE,EXIT_SOUND
		DJNZ R2,REPEAT_ERROR1
		CLR SPK
		CALL DELAY500MS
EXIT_SOUND:
		POP 02H
		RET
;~~~~~~~~~~~~~~~~~~~~CHAY VAO~~~~~~~~~~~~~~~~~~~~~~~~~
EFECT1:
		CLR TT
		CLR LED
		MOV P1,#07EH
		CALL DELAY100MS
		MOV P1,#0BDH
		CALL DELAY100MS
		MOV P1,#0DBH
		CALL DELAY100MS
		MOV P1,#0E7H
		CALL DELAY100MS
		MOV P1,#0FFH
		SETB LED
		RET
;~~~~~~~~~~~~~~~~~~~CHAY RA~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EFECT2:
		CLR TT
		CLR LED
		MOV P1,#0E7H
		CALL DELAY100MS
		MOV P1,#0DBH
		CALL DELAY100MS
		MOV P1,#0BDH
		CALL DELAY100MS
		MOV P1,#07EH
		CALL DELAY100MS
		MOV P1,#0FFH
		SETB LED
		RET
;~~~~~~~~~~~~~~~SANG DAN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EFECT3:
		CLR LED
		MOV P1,#0FFH
		MOV A,P1
RE_EFECT3:
		CLR C
		RRC	A
		MOV P1,A
		CPL TT
		CALL DELAY100MS
		CJNE A,#0,RE_EFECT3
		SETB LED
		MOV P1,#0FFH
		RET
;~~~~~~~~~~~~~~~CHAY VAO NHANH~~~~~~~~~~~~~~~~~~~~~~~~~~
CONTACT:
		CLR TT
		CLR LED
		MOV P1,#07EH
		CALL DELAY10MS
		CALL DELAY10MS
		MOV P1,#0BDH
		CALL DELAY10MS
		CALL DELAY10MS
		MOV P1,#0DBH
		CALL DELAY10MS
		CALL DELAY10MS
		MOV P1,#0E7H
		CALL DELAY10MS
		CALL DELAY10MS
		CALL DELAY10MS
		CALL DELAY10MS
		MOV P1,#0FFH
		SETB LED
		RET
;~~~~~~~~~~~~~~~~~~~SANG DAN NHANH~~~~~~~~~~~~~~~~~~~~~~~
EFECT4:
		CLR LED
		MOV P1,#0FFH
		MOV A,P1
RE_EFECT4:
		CLR C
		RRC	A
		MOV P1,A
		CPL TT
		CALL DELAY10MS
		CALL DELAY10MS
		CJNE A,#0,RE_EFECT4
		SETB LED
		MOV P1,#0FFH
		RET
;~~~~~~~~~~~~~~~CHUONG TRINH NGAT~~~~~~~~~~~~~~~~~~~~~~~~
NGAT:
		MOV TL1,#LOW(-50000)
		MOV TH1,#HIGH(-50000)
		SETB TR1
		INC	R7
		RETI
LIST1:
	DB	00H,01H,02H,03H,04H,05H,06H,07H,08H,09H,10H,11H,12H,13H,14H,15H,16H,17H,18H
	DB	19H,20H,21H,22H,23H,24H,25H,26H,27H,28H,29H,30H,31H,32H,33H,34H,35H,36H,37H
	DB	38H,39H,40H,41H,42H,43H,44H,45H,46H,47H,48H,49H,50H,51H,52H,53H,54H,55H,56H
	DB	57H,58H,59H,60H,61H,62H,63H,64H,65H,66H,67H,68H,69H,70H,71H,72H,73H,74H,75H
	DB	76H,77H,78H,79H,80H,81H,82H,83H,84H,85H,86H,87H,88H,89H,90H,91H,92H,93H,94H
	DB	95H,96H,97H,98H,99H
END