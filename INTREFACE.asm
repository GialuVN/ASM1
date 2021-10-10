ORG 00H
;/////////////////KHAI BAO BIEN///////////////////////////////
;~~~~~~~~~~~~~~~ KHAI BAO BAN PHIM ~~~~~~~~~~~~~~~~~~~~~~~~
P_K12 	BIT P1.0	;Phim OFF K1 K2
P_INC	BIT P1.1	;Phim tang gia tri cua bien/ON K1/OFF K2
P_DEC	BIT P1.2	;Phim giam gia tri cua bien/OFFK1/ON K2
P_ONF	BIT P1.3	;Phim tat mo dong co
P_STA 	BIT	P1.4	;Phim de dong co
P_SET	BIT	P1.5	;Phim chon cai dat
P_SLE	BIT	P1.6	;Phim chon/ko chon bien
P_AUT	BIT P1.7	;Phim chuyen sang che do tu dong

;~~~~~~~~~~~~~~~~~~~~~ BIEN XUAT DIEU KHIEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~
K1		BIT	P0.0	;CUON HUT K1
K2		BIT P0.1	;CUON HUT K2
ONF		BIT P0.2	;ON/OFF DONG CO
STA		BIT P0.3	;KHOI DONG DONG CO
;~~~~~~~~~~~~~~~~~~~~~ BIEN NHAN TRANG THAI HE THONG ~~~~~~~~~~~~~~~~~~
CB1		BIT P2.0	;CAM BIEN MAT/CO DIEN LUOI
CB2 	BIT P2.1	;CAM BIEN MAT/CO DIEN MAY PHAT
CB3		BIT P2.2	;CAM BIEN DONG CO CHAY HAY CHUA
KTM		BIT P2.3	;CAM BIEN KIEM TRA DAU,NUOC

;~~~~~~~~~~~~~~~ BIEN DIEU KHIEN HIEN THI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
VAR1	 EQU	25H ;hang chuc va don vi
VAR2	 EQU	26H	;LED3
OUTPUT 	 EQU 	P3	;PORT xuat ra led
STATUS	BIT		P3.7;Hien thi trang thai binh thuong/cai dat
;~~~~~~~~~~~~~~~~ BIEN CAI DAT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TEMB 	BIT 00H		;bien dieu khien cai dat/ko cai dat
COU		EQU	32H		;Thu tu bien aa,bb,cc,...
DLF		EQU	33H		;Chong nha mat dien (MIN=0s,MAX=60s)
DLO		EQU	34H		;Chong nha co dien	(MIN=0s,MAX=60s)
TGD		EQU	35H		;thoi gian de		(MIN=1s,MAX=10s)
SLD		EQU	36H		;so lan de			(MIN=1lan,MAX=10lan)
TOF		EQU	37H		;Thoi gian tat may phat khi co dien lai	(MIN=1P,MAX=60P)
TON		EQU	38H		;Thoi gian bat may phat ke tu khi khoi dong(MIN=1s,MAX=99s)

;~~~~~~~~~~~~~~~~~~~~~~~~~~CAC BIEN DIEU KHIEN THOI GIAN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TEM1	EQU	39H		;bien den 1 cua bo dinh thoi DELAYVAR
TEM2	EQU	3AH		;,,,,,,,,,2,,,,,,,,,,,,,,,	DELAYVAR
TEM3	EQU	3BH		;bien tam thoi cho CT con DECODE
TEM4	EQU	3CH
TEM5	EQU	3DH
TEM6	EQU	3EH
;~~~~~~~~~~~~~~~~~~~~~~~~~~CAC BIEN TAM THOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
TEMB1	EQU 27H
TEMB2	EQU 28H


;~~~~~~~~~~~~~~~~~~~~~~~~~~CAC BIEN PHAT SINH TRONG CHUONG TRINH CON~~~~~~~~~~~~~~~~~~
;								nam trong khoang 50H dem 70H

;//////////////////// CHUONG TRINH ////////////////////////////

;~~~~~~~~~~~~~~~~~~~ GAN GIA TRI MAC DINH CHO BIEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	CLR TEMB
	MOV COU,#1
	MOV DLF,#1
	MOV DLO,#1
	MOV TGD,#2
	MOV SLD,#2
	MOV TOF,#5
	MOV TON,#3
	MOV P1,#0FFH		;Thiet lap cac phim o trang thai cho
			
;~~~~~~~~~~~~~~~~~~~CHUONG TRINH CHINH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KEYBOARD:	
			
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
;			JNB P_AUT,SUBP_AUT
			MOV P3,#0F0H		;Khong cho phep hien thi LED
			JMP KEYBOARD
;+++++++++++++++NHAY NOI TIEP+++++++++++++++++++++++++=
SUBTEM:
			LJMP SUBTEM1
SUB_AUT:
			LJMP SUB_AUT1
;~~~~~~~~~~~~~~~~~~~CAC CHUONG TRINH SUBxxx~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;````````````````````````OFF K1,K2``````````````````````````````````````````````
SUBP_K12:	
			SETB K1
			SETB K2
			JNB P_K12,$
			JMP KEYBOARD
;`````````````````````````OFF K1,ON K2````````````````````````````````````````````
SUBP_INC:	
			MOV TEM1,#255
			MOV TEM2,#255
			SETB K1
			CALL DELAYVAR
			CLR K2
			JNB P_INC,$
			JMP KEYBOARD
;```````````````````````````OFF K2,ON K1`````````````````````````````````````````````
SUBP_DEC:		
			MOV TEM1,#255
			MOV TEM2,#255
			SETB K2
			CALL DELAYVAR
			CLR K1
			JNB P_DEC,$
			JMP KEYBOARD
;```````````````````````ON/OF DONG CO MAY PHAT`````````````````````````````````````````	
SUBP_ONF:
			CPL ONF
			JNB P_ONF,$
			JMP KEYBOARD
;```````````````KHOI DONG MAY PHAT( CHI KHI MAY PHAT TAT)`````````````````````
SUBP_STA:	
			JNB CB3,EXIT_SUBP_STA
			CLR STA
			JNB P_STA,$
			SETB STA
EXIT_SUBP_STA:
			JMP KEYBOARD

;````````````DAO BIEN TEM(THIET LAP TRANG THAI CAI DAT HAY THOAT CA DAT)`````````````
SUBP_SET:
			CPL TEMB
			JNB P_SET,$
			JMP RETURN_SUBTEM


;```````````````KIEM TRA TRANG THAI CUA CB1,CB2,CB3(TAT DONG THI XUAT 1 NGUOC LAI 0)``````````````````
SUBP_SLE:	
			PUSH PSW
			MOV C,CB2
			CPL	C
			MOV 28H,C		;CB2 hien thi tren hang DV
			MOV C,CB1
			CPL C
			MOV 2CH,C		;CB1 hien thi tren hang chuc	
			MOV C,CB3		
			CPL C
			MOV 30H,C		;CB3 hien thi tren led 3		
			JNB P_SLE,$
REPEATSUBP_SLE:
			CALL DISPLAY
			CLR STATUS
			JNB P_SLE,EXITSUBP_SLE
			JMP REPEATSUBP_SLE
EXITSUBP_SLE:
			
			JNB P_SLE,$
			POP PSW
			LJMP KEYBOARD

;~~~~~~~~~~~~~~~~~~~~CHUONG TRINH CAI DAT CAC THONG SO CHO CHE DO AUTO~~~~~~~~~~~~~~~~~~~

SUBTEM1:
			JNB P_SLE,SUBTEMP_SLE
RETURNP_INC:
			JNB P_INC,SUBTEMP_INC
RETURNP_DEC:
			JNB P_DEC,SUBTEMP_DEC
			CALL DISPLAY
			CALL INSERT_VAR
			MOV TEM3,VAR1
			CALL DECODE
			CLR STATUS
			LJMP RETURN_SUBTEM

;~~~~~~~~~~~~~~~~CHUONG TRINH SUBTEMxxx~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;````````````````````CHON THU TU BIEN TU 1-6`````````````````````````
SUBTEMP_SLE:
			INC COU
			MOV A,COU
			CJNE A,#7,$+6
			MOV COU,#1
			JNB P_SLE,$
			JMP SUBTEM1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GAN BIEN VAO BIEN HIEN THI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Tuong ung voi tung gia tri cua COU se hien thi gia tri cua bien tuong ung
INSERT_VAR:
			MOV VAR2,COU	;Hien thi thu tu bien
			MOV A,VAR2
			CJNE A,#1,$+6	
			MOV VAR1,DLF	
			CJNE A,#2,$+6	
			MOV VAR1,DLO	
			CJNE A,#3,$+6
			MOV VAR1,TGD	
			CJNE A,#4,$+6	
			MOV VAR1,SLD
			CJNE A,#5,$+6
			MOV VAR1,TOF
			CJNE A,#6,$+6
			MOV VAR1,TON
			RET
;~~~~~~~~~~~~~~~~~~~~~~~~~TANG GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBTEMP_INC:
			CLR P_INC
			CALL RESEACH
			SETB P_INC
			JNB P_INC,$
			LJMP SUBTEM1		
;~~~~~~~~~~~~~~~~~~~~~~~~~~GIAM GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBTEMP_DEC:
			CLR P_DEC
			CALL RESEACH
			SETB P_DEC
			JNB P_DEC,$
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
		RET
;~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_DLF:
		JB P_INC,CONT_DLF
		INC DLF
		MOV A,DLF
		CJNE A,#61,EXIT_F_DLF
		MOV DLF,#0
		JMP EXIT_F_DLF
CONT_DLF:
		DEC DLF
		MOV A,DLF
		CJNE A,#-1,$+6
		MOV DLF,#60
EXIT_F_DLF:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLO~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_DLO:	
		JB P_INC,CONT_DLO
		INC DLO
		MOV A,DLO
		CJNE A,#61,EXIT_F_DLO
		MOV DLO,#0
		JMP EXIT_F_DLO
CONT_DLO:
		DEC DLO
		MOV A,DLO
		CJNE A,#-1,$+6
		MOV DLO,#60
EXIT_F_DLO:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA RI TGD~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		MOV TGD,#11
EXIT_F_TGD:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM  GIA TRI SLD ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI TOF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_TOF:	
		JB P_INC,CONT_F_TOF
		INC TOF
		MOV A,TOF
		CJNE A,#61,EXIT_F_TOF
		MOV TOF,#1
		JMP EXIT_F_TOF
CONT_F_TOF:
		DEC TOF
		MOV A,TOF
		CJNE A,#-1,$+6
		MOV TOF,#60
EXIT_F_TOF:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~TANG/GIAM GAI TRI TON~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
F_TON:
		JB P_INC,CONT_F_TON
		INC TON
		MOV A,TON
		CJNE A,#100,EXIT_F_TON
		MOV TON,#1
		JMP EXIT_F_TON
CONT_F_TON:
		DEC TON
		MOV A,TON
		CJNE A,#-1,$+6
		MOV TON,#99
EXIT_F_TON:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






































;~~~~~~~~~~~~~~~~~~GIAI MA HEX-DEC(0-90)~~~~~~~~~~~~~~~~~~~~~~~

DECODE:	
		MOV A,TEM3			;chuyen bien so HEX  vao A
		MOV DPTR,#LIST1		;lay dia chi  du lieu dau tien
		MOVC A,@A+DPTR		;do va lay so DEC tuong ung
		MOV VAR1,A			;luu vao bien hien thi
		RET

;~~~~~~~~~~~~~~~CHUONG TRINH HIEN THI~~~~~~~~~~~~~~~~~~~~
DISPLAY:
		MOV TEM1,#10
		MOV TEM2,#100
		PUSH ACC
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
		POP ACC 			
		RET	
		
;~~~~~~~~~~~~~~~~~~~~CHUONG TRINH TRI HOAN 2ms~~~~~~~~~~~~		
DELAY2000:
			PUSH 00H
			PUSH 01H	
			MOV R0,#20
REPEAT2000:
			MOV R1,#100
			DJNZ R1,$
			DJNZ R0,REPEAT2000
			POP 01H
			POP 00H
			RET
;~~~~~~~~~~~~~CHUONG TRINH TRI HOAN CO THE DIEU KHIEN DUOC (MAX 65ms)~~~~~~~~~~~~
DELAYVAR:
			PUSH	00H
			PUSH	01H
			MOV R0,TEM1
REPEATVAR:
			MOV R1,TEM2
			DJNZ R1,$
			DJNZ R0,REPEATVAR
			POP 01H
			POP 00H
			RET
LIST1:
	DB	00H,01H,02H,03H,04H,05H,06H,07H,08H,09H,10H,11H,12H,13H,14H,15H,16H,17H,18H
	DB	19H,20H,21H,22H,23H,24H,25H,26H,27H,28H,29H,30H,31H,32H,33H,34H,35H,36H,37H
	DB	38H,39H,40H,41H,42H,43H,44H,45H,46H,47H,48H,49H,50H,51H,52H,53H,54H,55H,56H
	DB	57H,58H,59H,60H,61H,62H,63H,64H,65H,66H,67H,68H,69H,70H,71H,72H,73H,74H,75H
	DB	76H,77H,78H,79H,80H,81H,82H,83H,84H,85H,86H,87H,88H,89H,90H,91H,92H,93H,94H
	DB	95H,96H,97H,98H,99H
END