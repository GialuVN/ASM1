ORG		 00H
JMP 	MAIN
ORG		001BH
LJMP	NGAT		
MAIN:
;/////////////////KHAI BAO BIEN///////////////////////////////
;~~~~~~~~~~~~~~~ KHAI BAO BAN PHIM ~~~~~~~~~~~~~~~~~~~~~~~~
P_K12 	BIT P1.0	;Phim OFF K1/K2
P_INC	BIT P1.1	;Phim tang gia tri cua bien/ON K1/OFF K2
P_DEC	BIT P1.2	;Phim giam gia tri cua bien/OFFK1/ON K2
P_ONF	BIT P1.3	;Phim tat mo dong co
P_STA 	BIT	P1.4	;Phim de dong co
P_SET	BIT	P1.5	;Phim chon cai dat
P_SLE	BIT	P1.6	;Phim chon bien/xem trang thai cb1,cb2,cb3
P_AUT	BIT P1.7	;Phim chuyen sang che do tu dong
          
;~~~~~~~~~~~~~~~~~~~~~ BIEN XUAT DIEU KHIEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~
K1		BIT	P0.0	;CUON HUT K1
K2		BIT P0.1	;CUON HUT K2
ONF		BIT P0.2	;ON/OFF DONG CO
STA		BIT P0.3	;KHOI DONG DONG CO
CHA		BIT P0.4	;DIEU KHIEN NAP/KO NAP ACQUI
SPK		BIT	P0.5	;BAO DONG
FAL		BIT P0.6	;HIEN CHU F
LED     BIT P0.7	; HIEN THI LOI
;~~~~~~~~~~~~~~~~~~~~~ BIEN NHAN TRANG THAI HE THONG ~~~~~~~~~~~~~~~~~~
CB1		BIT P2.0	;CAM BIEN MAT/CO DIEN LUOI
CB2 	BIT P2.1	;CAM BIEN MAT/CO DIEN MAY PHAT
CB3		BIT P2.2	;CAM BIEN DONG CO CHAY HAY CHUA
HIP		BIT	P2.3	;DIEN AP ACQUI >13.5V
LOP		BIT	P2.4	;DIEN AP ACQUI <=12V
KTM		BIT P2.5	;CAM BIEN KIEM TRA DAU,NUOC
BD1		BIT P2.6	;NHAN TIN HIEU TU BIEN DONG 1
BD2		BIT	P2.7	;NHAN TIN HIEU TU BIEN DONG 2          
;~~~~~~~~~~~~~~~ BIEN DIEU KHIEN HIEN THI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
VAR1	 EQU	25H ;hang chuc va don vi
VAR2	 EQU	26H	;Led don
OUTPUT 	 EQU 	P3	;PORT xuat ra led
STATUS   BIT	P3.7;Hien thi trang thai binh thuong/cai dat
;~~~~~~~~~~~~~~~~ BIEN CAI DAT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

COU		EQU	32H		;Thu tu bien
DLF		EQU	33H		;Chong dao dong dien(mat dien tam thoi) (MIN=0s,MAX=60s)
DLO		EQU	34H		;Chong dao dong dien(co dien tam thoi)	(MIN=0s,MAX=60s)
TGD		EQU	35H		;thoi gian de							(MIN=1s,MAX=60s)
SLD		EQU	36H		;so lan de								(MIN=1lan,MAX=10lan)
TOF		EQU	37H		;Thoi gian tat may phat khi co dien lai	(MIN=1P,MAX=9P)
TON		EQU	38H		;Thoi gian tre dong dien may phat		(MIN=1s,MAX=90s)
REP		EQU	39H		;Thoi gian khoi dong lap lai may phat	(MIN=1S,MAX=90s)
DLS		EQU 3AH		;Thoi gian xac dinh may that su da chay	(MIN=1s,MAX=90s)
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
TEM14	EQU 46H	;BIEN AM THANH 2,4

;~~~~~~~~~~~~~~~~~~~~~~~~~BIT NHO DAC BIET~~~~~~~~~~~~~~~~~~~~~~~~~
TEMB 	BIT 00H		;bien dieu khien cai dat/ko cai dat


;//////////////////// CHUONG TRINH ////////////////////////////
          
	MOV TMOD,#11H		;CHO PHEP HAI BO DINH THOI HOAT DONG CHE DO 1 16BIT
	MOV IE,#88H			;CHO PHEP NGAT DO BO DINH THOI 1
          
;~~~~~~~~~~~~~~~~~~~ GAN GIA TRI MAC DINH CHO BIEN ~~~~~~~~~~~~~~~~~~
	MOV TEM12,#60
	CLR TEMB
	MOV COU,#1
	MOV DLF,#10
	MOV DLO,#10
	MOV TGD,#2
	MOV SLD,#2
	MOV TOF,#1
	MOV TON,#5
	MOV REP,#30
	MOV DLS,#5
	MOV P1,#0FFH		;Thiet lap cac phim o trang thai cho
			
;~~~~~~~~~~~~~~~~~~~CHUONG TRINH CHINH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
KEYBOARD:	
			SETB LED
			SETB SPK
			SETB FAL
			LCALL CHARGE
			JNB P_K12,SUBP_K12
			JNB P_INC,SUBP_INC
			JNB P_DEC,SUBP_DEC
			JNB	P_ONF,SUBP_ONF
			JNB	P_STA,SUBP_STA
			JNB P_SLE,SUBP_SLE
RETURN_SUBTEM:
			JNB P_SET,SUBP_SET
			JB 	TEMB,	SUBTEM
			SETB STATUS
			JNB P_AUT,SUBP_AUT
			MOV P3,#0F0H		;Khong cho phep hien thi LED	
			JMP KEYBOARD
;+++++++++++++++NHAY NOI TIEP+++++++++++++++++++++++++=
SUBTEM:
			LJMP SUBTEM1
SUBP_AUT:
			LJMP SUBP_AUT1
;~~~~~~~~~~~~~~~~~~~CAC CHUONG TRINH SUBxxx~~~~~~~~~~~~~~~~~~~~~~~
          
;````````````````````````OFF K1,K2```````````````````````````````
SUBP_K12:	
			SETB K1
			SETB K2
			JNB K1,$
			JNB K2,$
			JNB P_K12,$
			JMP KEYBOARD
;`````````````````````````OFF K1,ON K2```````````````````````
SUBP_INC:	
			SETB K1
			JNB K1,$
			CALL DELAY10MS
			CLR K2
			JNB P_INC,$
			JMP KEYBOARD
;```````````````````````````OFF K2,ON K1````````````````````
SUBP_DEC:		
			SETB K2
			JNB K2,$
			CALL DELAY10MS
			CLR K1
			JNB P_DEC,$
			JMP KEYBOARD
;```````````````````````ON/OF DONG CO MAY PHAT`````````````
SUBP_ONF:
			CPL ONF
			JNB P_ONF,$
			JMP KEYBOARD
;```````````````KHOI DONG MAY PHAT( CHI KHI MAY PHAT TAT)`
SUBP_STA:	
			JNB CB3,EXIT_SUBP_STA
			CLR STA
			JNB P_STA,$
			SETB STA
EXIT_SUBP_STA:
			JMP KEYBOARD
          
;````````````DAO BIEN TEM(THIET LAP TRANG THAI CAI DAT HAY THOAT CA DAT)````````
SUBP_SET:
			CPL TEMB
			JNB P_SET,$
			JMP RETURN_SUBTEM
;```````````````KIEM TRA TRANG THAI CUA CB1,CB2,CB3(TAT DONG THI XUAT 1 NGUOC LAI 0)```
SUBP_SLE:	
			PUSH PSW
			PUSH 00H
			MOV R0,#50
REPEAT_SUBP_SLE:
			CALL DELAY10MS
			DJNZ R0,CONT_R0			
			;+++++++++++++++++++++++
			JMP EXITSUBP_SLE
CONT_R0:
			JNB P_SLE,REPEAT_SUBP_SLE
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
REPEATSUBP_SLE:
			LCALL DISPLAY
			JNB P_SLE,EXITSUBP_SLE
			JMP REPEATSUBP_SLE
EXITSUBP_SLE:
			
			JNB P_SLE,$
			POP 00H
			POP PSW
			LJMP KEYBOARD
          
;~~~~~~~~~~~~~~~~~~~~CHUONG TRINH CAI DAT CAC THONG SO CHO CHE DO AUTO~~~~~~~~~~~~~~~~~~~
          
SUBTEM1:
			JNB P_SLE,SUBTEMP_SLE
RETURNP_INC:
			CALL HT_LED
			JNB P_INC,SUBTEMP_INC
RETURNP_DEC:
			JNB P_DEC,SUBTEMP_DEC
			CALL HT_VAR
			LJMP RETURN_SUBTEM
          
;~~~~~~~~~~~~~~~~CHUONG TRINH SUBTEMxxx~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;````````````````````CHON THU TU BIEN TU 1-6`````````````````````````
SUBTEMP_SLE:
			INC COU
			MOV A,COU
			CJNE A,#9,$+6
			MOV COU,#1
			CALL HT_VAR
			JNB P_SLE,$-3
			JMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GAN BIEN VAO BIEN HIEN THI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~~~~~~TANG GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP_INC:
			CALL RESEACH
			CALL HT_VAR
			JNB P_INC,$-3
			LJMP SUBTEM1		
;~~~~~~~~~~~~~~~~~~~~~~~~~~GIAM GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP_DEC:
			CALL RESEACH
			CALL HT_VAR
			JNB P_DEC,$-3
			LJMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~THAM DO BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
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
;~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA RI TGD~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_TGD:
		JB P_INC,CONT_F_TGD
		INC TGD
		MOV A,TGD
		CJNE A,#61,EXIT_F_TGD
		MOV TGD,#1
		JMP EXIT_F_TGD
CONT_F_TGD:
		DEC TGD
		MOV A,TGD
		CJNE A,#0,$+6
		MOV TGD,#60
EXIT_F_TGD:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM  GIA TRI SLD ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_SLD:
		JB P_INC,CONT_F_SLD
		INC SLD
		MOV A,SLD
		CJNE A,#11,EXIT_F_SLD
		MOV SLD,#1
		JMP EXIT_F_SLD
CONT_F_SLD:
		DEC SLD
		MOV A,SLD
		CJNE A,#0,$+6
		MOV SLD,#10
EXIT_F_SLD:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI TOF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_TOF:	
		JB P_INC,CONT_F_TOF
		INC TOF
		MOV A,TOF
		CJNE A,#10,EXIT_F_TOF
		MOV TOF,#1
		JMP EXIT_F_TOF
CONT_F_TOF:
		DEC TOF
		MOV A,TOF
		CJNE A,#0,$+6
		MOV TOF,#9
EXIT_F_TOF:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GAI TRI TON~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI REP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI DLS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		CJNE A,#0,$+6
		MOV DLS,#90
EXIT_F_DLS:
		RET
;////////////////////////~CHUONG TRINH CHE DO TU DONG~/////////////////////////////////////////////

          
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
;~~~~~~~~THIET LAP CHE DO MAC DINH KHI BAT DAU CHE DO AUTO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
		SETB K2
		CALL DELAY100MS
		CLR K1
;``````````````````````````KIEM TRA CB1````````````````````````````````````````````````````
SUB_CB1:
		CALL CHARGE
		JNB P_SLE,KEYBOARD2
		JNB CB1,SUB1_CB1		;Kiem tra dien luoi
		JNB BD1,SUB_BD1		;Kiem tra bien dong 1
		MOV A,DLF
		CJNE A,#0,SUB_DLF	;Kiem tra bien DLF co bang 0 chua?
		MOV DLF,TEM4
		JNB CB3,SUB_CB3		;Kiem tra may co chay khong?
		SETB K2
		CALL DELAY100MS
		CLR K1
		JMP SUB_CB1
SUB_BD1:
		CALL ERO1		;QUA DONG BD1
		JMP SUB_CB1
SUB_CB3:
		JNB CB2,SUB_CB2		;Neu may co chay thi kiem tra CB2 Co dien khong?
		JMP OKAY			;NHAY DEN CHUONG TRINH THU3
SUB_DLF:
		MOV VAR2,#1
		MOV TEM3,DLF
		CALL DELAYHTS
		DEC DLF
		SETB FAL
		MOV DLO,TEM5
		JMP SUB_CB1
SUB_CB2:
		CALL ERO5			;KO CO DIEN AP RA
		JNB P_SLE,KEYBOARD2
		JMP SUB_CB3
;~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD2:
		JMP KEYBOARD1
SUBB2_CB3:
		JMP SUB2_CB3
SUBB1_BD2:
		JMP SUB1_BD2
SUBB1_DLO:
		JMP SUB1_DLO
SUBB1_KTM:
		JMP SUB1_KTM
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB1_CB1:
		JNB KTM,SUBB1_KTM	;Kiem tra may(dau, nuoc)
		JNB BD2,SUBB1_BD2	;Kiem tra qua dong ?
		MOV A,DLO
		CJNE A,#0,SUBB1_DLO	;dem
		MOV DLO,TEM5
		JNB CB3,SUBB2_CB3	;Kt may chay hay chua?
		JNB K2,SUBB1_K2		;kiem tra K2 xem co dong chua?
		SETB K1
		SETB K2
		CLR ONF				;MO MAY
		CALL DELAY100MS
REPEAT_STA:
		CLR STA				;DE
		MOV A,TGD
		CJNE A,#0,SUB1_TGD
		MOV TGD,TEM6
		SETB STA			;NGUNG DE
REPEAT_DLS:
		MOV A,DLS
		CJNE A,#0,SUB_DLS
		MOV DLS,TEM11
		JNB CB3,SUB3_CB3	;KIEM TRA MAY CHAY CHUA
		DEC SLD
		MOV A,SLD
		CJNE A,#0,REPEAT_STA
REPEAT_ERO6:
		CALL ERO6			;loi KHONG KHOI DONG DUOC
		JNB P_SLE,KEYBOARD1
		JMP REPEAT_ERO6
SUB_DLS:
		MOV VAR2,#8
		MOV TEM3,DLS
		CALL DELAYHTS
		DEC DLS
		JMP REPEAT_DLS
SUB1_TGD:
		MOV VAR2,#3
		MOV TEM3,TGD
		CALL DELAYHTS
		DEC TGD
		JMP REPEAT_STA
SUB3_CB3:
		MOV SLD,TEM7
		JNB CB2,SUB4_CB2
		MOV A,TON
		CJNE A,#0,SUB1_TON
		MOV TON,TEM9
		SETB K1
		CALL DELAY100MS
		CLR K2
		JMP OKAY
SUB1_TON:
		MOV VAR2,#6
		MOV TEM3,TON
		CALL DELAYHTS
		DEC TON
		JMP SUB3_CB3
SUB4_CB2:
		CALL ERO5		;LOI KHONG CO DIENAP RA
		JNB P_SLE,KEYBOARD1
		JMP SUB4_CB2
		
SUB1_KTM:
		CALL ERO3			;THIEU DAU HOAC HET NUOC
		JMP SUB_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KEYBOARD1:
		LJMP KEYBOARD
SUBB1_K2:
		JMP SUB1_K2
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUB1_BD2:
		CALL ERO2			;dong BD2
		JMP SUB_CB1
SUB1_DLO:					;hien thi bien dem
		MOV VAR2,#2
		MOV TEM3,DLO
		CALL DELAYHTS
		DEC DLO
		SETB FAL
		MOV DLF,TEM4
		JMP SUB_CB1
SUB2_CB3:
		JNB CB2,SUB2_CB2
		SETB K1
		CALL DELAY100MS
        CLR K2
        JMP SUB_CB1
SUB2_CB2:
		CALL ERO5			;bao loi khong co dien ap ra
		JNB P_SLE,KEYBOARD1
		JMP SUB2_CB3
SUB1_K2:
		CALL ERO4			;bao loi may tu dong tat
		JNB P_SLE,KEYBOARD1
		JMP SUB1_K2
;~~~~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD3:
			LJMP KEYBOARD
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OKAY:
		SETB K1
		CALL DELAY100MS
		CLR K2
SUBF_CB1:
		JNB P_SLE,KEYBOARD3
		JNB CB1,SUB4_CB1
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
		SETB ONF		
REPEAT_REP:
		MOV A,REP
		CJNE A,#0,SUB_REP
		MOV REP,TEM10
		LJMP SUB_CB1
SUB_REP:
		MOV VAR2,#7
		MOV TEM3,REP
		CALL DELAYHTS
		DEC REP
		JMP REPEAT_REP
SUB_TEM12:
		SETB FAL
		JMP SUBF_CB1
SUB5_KTM:
		CALL ERO3
		JNB P_SLE,KEYBOARD3
		JMP SUBF_CB1		
SUB5_BD1:
		CALL ERO1			;QUA DONG BD1
		JNB P_SLE,KEYBOARD3
		JMP SUBF_CB1
SUB4_CB1:
		SETB K1
		MOV VAR2,TOF
		MOV TEM3,TEM12
		CPL LED
		MOV P1,#00H
		CALL DELAYHTS
		MOV P1,#0FFH
		CLR K2
		JNB KTM,SUB8_KTM
		JNB BD2,SUB8_BD2
		JNB CB2,SUB8_CB3
		JMP SUB8_TOF
SUB8_CB3:
 		CALL ERO5
		JNB P_SLE,KEYBOARD4
		JMP SUBF_CB1
SUB8_TOF:
		MOV TEM12,#60
		MOV TOF,TEM8
		SETB FAL
		JMP SUBF_CB1
SUB8_KTM:
		CALL ERO3			;THIEU DAU HOAC NUOC
		JNB P_SLE,KEYBOARD4
		JMP SUBF_CB1
SUB8_BD2:
		CALL ERO2			;QUA DONG BD2
		JNB P_SLE,KEYBOARD4
		JMP SUBF_CB1
;~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD4:
		LJMP KEYBOARD 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~HIEN THI THU TU BIEN BANG LED~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HT_LED:		
			CLR LED
			MOV A,COU
			CJNE A,#1,$+9
			MOV P1,#0FEH
			JMP EXIT_LED
			CJNE A,#2,$+9
			MOV P1,#0FDH
			JMP EXIT_LED
			CJNE A,#3,$+9
			MOV P1,#0FBH
			JMP EXIT_LED
			CJNE A,#4,$+9
			MOV P1,#0F7H
			JMP EXIT_LED
			CJNE A,#5,$+9
			MOV P1,#0EFH
			JMP EXIT_LED
			CJNE A,#6,$+9
			MOV P1,#0DFH
			JMP EXIT_LED
			CJNE A,#7,$+9
			MOV P1,#0BFH
			JMP EXIT_LED
			CJNE A,#8,$+9
			MOV P1,#07FH
EXIT_LED:
			CALL DELAY10MS
			MOV P1,#0FFH
			SETB LED
			RET
;~~~~~~~~~~~~~~~~~~~~~HIEN THI BIEN(COU =VAR2, TEM3=VAR1)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
HT_VAR:
			CALL INSERT_VAR
			CALL HT_NO
			RET
;~~~~~~~~~~~~~~~~~~~~~~~HT+DECODE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
HT_NO:
			CALL DECODE
			CALL DISPLAY
			RET
;~~~~~~~~~~~~~~~~~~GIAI MA HEX-DEC(0-99)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
DECODE:	
		MOV A,TEM3			;chuyen bien so HEX  vao A
		MOV DPTR,#LIST1		;lay dia chi  du lieu dau tien
		MOVC A,@A+DPTR		;lay so DEC tuong ung
		MOV VAR1,A			;luu vao bien hien thi
		RET
          
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CHUONG TRINH HIEN THI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DISPLAY:
		MOV A,VAR1
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0D0H			;chen bit chon led hang don vi
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAY10MS		;tre 1000us
		MOV OUTPUT,#0F0H	;xoa lem
		MOV A,VAR1			;gan gia tri bien1 vao A
		SWAP A				;dao 4 bit cao thanh 4bit thap
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0E0H			;chen bit chon led cho hang chuc
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAY10MS		;goi tre
		MOV OUTPUT,#0F0H	;xoa lem
		MOV A,VAR2			;gan gia tri bien2 vao a
		ANL A,#0FH			;xoa 4 bit cao
		ORL A,#0B0H			;chen bit chon chan led
		MOV OUTPUT,A		;xuat ra port P3
		CALL DELAY10MS		;goi tre
		MOV OUTPUT,#0F0H	;xoa lem		
		RET	
		
;~~~~~~~~~~~~~~~~~~CHUONG TRINH TRE TU 1-255s CO HIEN THI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
 ;~~~~~~~~~~~~~~~~~~~~DELAY 1ms~~~~~~~~~~~~~~~~~~~~~~~	
DELAY1MS:
			PUSH 00H
			PUSH 01H	
			MOV R1,#10
REPEAT1MS:
			MOV R0,#100
			DJNZ R0,$
			DJNZ R1,REPEAT1MS
			POP 01H
			POP 00H
			RET
;~~~~~~~~~~~~~DELAY 10ms~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~DELAY 100ms~~~~~~~~~~~~~~~~~~~~~~~~
DELAY100MS:
			PUSH 02H
			MOV R2,#10
REPEAT_DELAY100MS:
			CALL DELAY10MS
			DJNZ R2,REPEAT_DELAY100MS
			POP 02H
			RET
;~~~~~~~~~~~~~~~~~~~~~DELAY 500ms~~~~~~~~~~~~~~~~~~~~
DELAY500MS:
			PUSH 02H
			MOV R2,#50
REPEAT_DELAY500MS:
			CALL DELAY10MS
			DJNZ R2,REPEAT_DELAY500MS
			POP 02H
			RET
;~~~~~~~~~~~~~~~~~~~~~~~~~CHUONG TRINH NAP ACQUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CHARGE:
			JB LOP,CONT_CHARGE
			CLR CHA				;bat dau nap acqui
			JMP EXIT_CHARGE
CONT_CHARGE:
			JB HIP,EXIT_CHARGE	;Ngung nap acqui
			SETB CHA
EXIT_CHARGE:
			RET
;~~~~~~~~~~~~HIEN LOI VA BAO DONG GOM CO 6 LOI VA 6 CHUONG BAO KEM THEO~~~~~~~~~~~~~~~~~
ERO1:
	MOV P3,#0B1H
	CLR FAL
	MOV TEM14,#0
	CALL SOUND
	RET
ERO2:
	MOV P3,#0B2H
	CLR FAL
	MOV TEM14,#2
	CALL SOUND
	RET
ERO3:
	MOV P3,#0B3H
	CLR FAL
	MOV TEM14,#4
	CALL SOUND
	RET
ERO4:
	MOV P3,#0B4H
	CLR FAL
	MOV TEM14,#6
	CALL SOUND
	RET
ERO5:
	MOV P3,#0B5H
	CLR FAL
	MOV TEM14,#8
	CALL SOUND
	RET
ERO6:
	MOV P3,#0B6H
	CLR FAL
	MOV TEM14,#10
	RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~AM THANH CANH BAO (BD1(TEM14=2),DB2=4,KTM=0)~~~~~~~
SOUND:
		PUSH 02H
		SETB SPK
		MOV R2,TEM14
REPEAT_ERROR1:	
		CPL SPK
		CALL DELAY10MS
		JNB P_SLE,EXIT_SOUND
		DJNZ R2,REPEAT_ERROR1
		SETB SPK
		CALL DELAY500MS
EXIT_SOUND:
		POP 02H
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~`CHUONG TRINH NGAT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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