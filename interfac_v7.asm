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
DLS		EQU 3AH		;Co dien ap ra hay chua						(MIN=0s,MAX=90s)
KIP		EQU 52H		;tri hoan sau khi de						(MIN=0S,MAX=30S)
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
TEM13	EQU	53H		;KIP
TEM12	EQU	45H		;=====60
TEM14	EQU 46H		;BIEN AM THANH
TEM15 	EQU 4AH		;F1
TEM16	EQU 4BH		;F2
TEM17 	EQU 4CH		;F3
COU2	EQU	4DH		;BIEN DEM THU TU LOI
RES		EQU 4EH		;GIU GIA TRI BIEN KHI RESET
TEM00	EQU 4FH		;HIEN THI SO LAN DE
TIME	EQU 50H		;DIEU CHINH TAN SO QUET
WAITX	EQU	51H		;CHO MAY CHAY
;~~~~~~~~~~~~~~~~~~~~~~~~~BIT NHO DAC BIET~~~~~~~~~~~~~~~~~~~~~~~~~
TEMB 	equ 00H		;bien dieu khien cai dat/ko cai dat
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
    MOV TIME,#30		;tan so quet led mac dinh
    MOV PASW,#00H		;xoa bien pass
    MOV P0,#0FFH		;tat tat ca  cac relay dk
;~~~~~~~~~~MAT KHAU~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		CALL EFECT1				;goi hieu ung 1	
PASS:
		MOV P1,#0FFH			;ko cho hien thi led
		CLR SPK					;tat loa
		CLR LED					;che do sang den khi an phim
REP_PASS1:
		CALL DELAY100MS			;goi tre 100ms
		JNB P_ONF,TIP1			;co an phim on/off khong?
		MOV A,P1				;co an phim nao khac phim on/off khong?
		CJNE A,#0FFH,END_PASS	;<>
		JMP REP_PASS1			;lap lai qua trinh kiem tra phim on/off
TIP1:	
		CALL DELAY100MS			;goi tre 100ms
		JNB P_ONF,$-3			;cho nha phim 0n/off
REP_TIP1:
		JNB P_SET,TIP6			;nhan phim set cho qua!		
		JNB P_ONF,TIP2			;kiem tra dung pass chua.	
		JNB P_INC,TIP8			;cac phim con lai lam sai bien pass
		JNB P_DEC,TIP8			;<>
		JNB P_STA,TIP8			;<>
		JMP REP_TIP1			;quet tiep
TIP2:	
		CALL DELAY100MS			;goi tre 100ms
		JNB P_ONF,$-3			;cho nha phim on/off
		MOV A,PASW				;so sanh so lan an dung
		CJNE A,#03H,END_PASS	;bang 3 hay khong?.
		JMP LOGIN				;neu dung bang 3 thi cho phep login
TIP6:						
		CALL DELAY100MS			;goi tre 100ms
		JNB P_SET,$-3			;cho nha phim set
		INC PASW				;tang so lan an len 1
REP_TIP6:
		JNB P_ONF,TIP2			;kiem tra dung pass chua
		JNB P_INC,TIP4			;nhan phim inc cho qua!
		JNB P_SET,TIP8			;cac phim con lai lam sai pass
		JNB P_DEC,TIP8			;<>
		JNB P_STA,TIP8			;<>
		JMP REP_TIP6			;quet tiep
TIP4:	
		CALL DELAY100MS			;goi tre 100ms
		JNB P_INC,$-3			;cho nha phim inc
		INC PASW				;tang gia tri bien pass len 1
REP_TIP4:						
		JNB P_ONF,TIP2			;kiem tra dung pass chua.
		JNB P_SLE,TIP7			;nhan phim nay cho qua.
		JNB P_INC,TIP8			;an cac phim con lai lam sai bien pass
		JNB P_STA,TIP8			;<>
		JNB P_DEC,TIP8			;<>
		JMP REP_TIP4			;quet tiep
TIP7:	
		CALL DELAY100MS			;tre 100ms
		JNB P_SLE,$-3			;cho nha phim sle
		INC PASW				;tang bien pass len 1
REP_TIP7:
		JNB P_ONF,TIP2			;kiem tra pass.
		JNB P_INC,TIP8			;cac phim con lai lam sai pass
		JNB P_SLE,TIP8			;<>
		JNB P_STA,TIP8			;<>
		JNB P_DEC,TIP8			;<>
		JMP REP_TIP7			;quet tiep
TIP8:	
		INC PASW				;lam sai pass
		INC PASW				;<>
		INC PASW				;<>
		JMP TIP7				;tro ve kiem tra tiep!
		
END_PASS:
		SETB SPK				;bat loa khi pass bi sai
		MOV PCON,#02H			;chuyen sang che do nguon giam
		JMP $					;kho lam gi ca!
;~~~~~~~~~~~~~~~~~LOGIN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~WELLCOME~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

LOGIN:
	JNB P_INC,$					;cho nha phim inc
	CLR SPK						;tat loa
	CLR LED						;cho phep led sang
	CALL EFECT1					;<>
	CALL EFECT2					;<>
	MOV A,P1					;cho p1 vao a
	MOV R0,#9					;dat r0 bang 9
RERO:		
	RLC A						;quay trai a
	MOV P1,A					;hien thi ra p1(led don)
	MOV P3,A					;hien thi ra p3(led 7 doan)
	CLR C						;xoa co
	CPL FAL						;hien thi chu F
	CPL TT						;chop tat led trang thai
	CALL DELAY100MS				;tri hoat 100ms
	CPL SPK						;bat loa
	DJNZ R0,RERO				;quay du 9 lan thi thoi!
	MOV P1,#0FFH				;cac phim sang san
;~~~~~~~~~~~~BAO LUU GIA TRI CAI DAT KHI RESET~~~~~~~~~~~~~~~~~~~~
   	MOV A,RES					;so sanh bien bao luu
    CJNE A,#99,RES_SUB			;<>
    CALL RECAL					;neu bang 99 thi goi lai cac bien da dat
    JMP KEYBOARD  				;nhay den che do bang tay
;~~~~~~~~~~~~~~ GAN GIA TRI MAC DINH CHO BIEN ~~~~~~~~~~~~~~~~~~~~
RES_SUB:
	MOV RES,#99					;dat bien res bang 99
	MOV TEM00,#1				;bien luu so lam de bang=1
	MOV TEM12,#60				;bien dem 60 giay
	CLR TEMB					;xoa bien trang thai ban phim
	CALL EFECT1					;goi hieu ung
	CALL DEFAULT				;goi cac gia tri mac dinh
;~~~~~~~~~~~~~~~~~~~CHUONG TRINH CHINH~~~~~~~~~~~~~~~~~~~~~~~~~
          
KEYBOARD:
		CALL HT_CB
		JNB P_SLE,KEYBOARD			;cho nha phim sle
KEYBOARD_A:
		SETB LED				;ko cho hien thi led khi an phim
		CLR SPK					;tat loa
		SETB FAL				;tat chu F
		CALL HT_CB				;goi hien thi CB1,2,3
		CALL CHARGE				;goi chuong trinh sac AQUI
		JNB P_INC,SUBP_INC		;kiem tra co an phim khong?
		JNB P_DEC,SUBP_DEC		;<>
		JNB	P_ONF,SUBP_ONF		;<>
		JNB	P_STA,SUBP_STA		;<>
RETURN_SUBTEM:					
		JNB P_SET,SUBP_SET		;co an phim set ko?
		MOV A,TEMB				;kiem tra ban phim o che do nao?
		CJNE A,#0,$+6			;0 (binh thuong)
		JMP EXIT_SET			;quet tiep
		CJNE A,#1,$+6			;1 (cai dat thong so)
		JMP SUBTEM1				;nhay ve cho do 1
		CJNE A,#2,$+6			;2 (cai dat loi)
		JMP SUBTEM2				;nhay ve che do 2
		JMP RETURN_SUBTEM		;quet tiep cho an phim set
EXIT_SET:
		JNB P_SLE,SUBP_AUT		;nhay den che do auto
		MOV P1,#0FFH			;ban phim san sang
		JMP KEYBOARD_A			;quet tiep
;+++++++++++++++NHAY NOI TIEP++++++++++++++++++++++++++++++++
SUBP_AUT:
		JMP SUBP_AUT1
;~~~~~~~~~~~~~~CAC CHUONG TRINH SUBxxx~~~~~~~~~~~~~~~~~~~~~~~
          
;`````````````````````````OFF K2,ON K1```````````````````````
SUBP_DEC:	
		SETB K1					;tat k1
		JNB K1,$				;cho k1 that su tat
		CLR TT					;bao da tat k1
		CALL CONTACT			;goi hieu ung contact
		CPL K2					;bat /tat k2 
		CALL DELAY10MS			;goi tre 10ms
		JNB P_DEC,$-3			;cho nha phim dec
		JMP KEYBOARD
;```````````````````````````OFF K1,ON K2```````````````````````
SUBP_INC:		
		SETB K2					;tat k2
		JNB K2,$				;cho k2 that su tat
		CLR TT					;bao da tat k2
		CALL CONTACT			;goi hieu ung
		CPL K1					;bat/tat k1
		CALL DELAY10MS			;goi tre 10ms
		JNB P_INC,$-3			;cho nha phim inc
		JMP KEYBOARD
;```````````````````````ON/OF DONG CO MAY PHAT``````````````````````````
SUBP_ONF:
		JNB P_ONF,$				;cho nha phim onf
		CPL ONF					;dao bit onf
		JNB ONF,EXIT1_ONF		;kiem tra onf la 0 or 1
		CLR TT					;bao onf da tac dong
		CALL EFECT2				;goi hieu ung 2
		JMP EXIT_ONF			;thoat phim onf
EXIT1_ONF:	
		CLR TT					;bao onf da tac dong
		CALL EFECT1				;goi hieu ung 1
EXIT_ONF:		
		CALL DELAY10MS			;goi tre 10ms
		JNB P_ONF,$-3			;cho nha phim onf
		JMP KEYBOARD			;tro ve che do 0
;`````````KHOI DONG MAY PHAT( CHI KHI MAY PHAT TAT)``````````````````````
SUBP_STA:	
		JNB K2,EXIT_SUBP_STA	;k2 co tac dong ko?
		JNB CB3,EXIT_SUBP_STA	;may chay chua?
		CLR STA					;thoa hai dk tren thi cho phep khoi dong
EXIT_SUBP_STA:	
		CLR TT					;bao khoi dong co hieu luc
		CALL CONTACT
		JNB P_STA,$-3			;cho nha phim sta
		SETB STA				;ngung de
		JMP KEYBOARD			;tro ve che do 0
          
;```````CHON CHE DO BAN PHIM``````````````````````````````````````
SUBP_SET:	
		INC TEMB				;chon che do tiep theo
		MOV A,TEMB				;tro ve che do 0 neu bien temb>3
		CJNE A,#3,$+5			;<>
		MOV TEMB,#0				;<>
		CLR TT					;bao dan an phim
		CALL EFECT4				;goi hieu ung 4
		CALL DELAY10MS			;goi tre 10ms
		JNB P_SET,$-3			;cho nha phim set
		JMP RETURN_SUBTEM		;tro ve quet ban phim
;~~~~~~~~CHUONG TRINH CAI DAT CAC THONG SO CHO CHE DO AUTO( che do 1)~~~~~~~~
          
SUBTEM1:
		JNB P_ONF,SUBTEMP_ONF	;phim goi che do mac dinh
		JNB P_STA,SUBTEMP_STA	;phim hien thi cac loi
		JNB P_SLE,SUBTEMP_SLE	;chon thu tu bien
		JNB P_INC,SUBTEMP_INC	;tang gia tri bien
		JNB P_DEC,SUBTEMP_DEC	;giam gia tri bien
		CALL HT_VAR				;goi chuong tri hien thi cac bien
		SETB FAL				;tat chu F
		CLR LED					;sang le khi an phim
		CLR NORM				;1 led sang
		LJMP RETURN_SUBTEM		;tro ve kiem tra trang thai
          
;~~~~~~~~~~~~~~~~CHUONG TRINH SUBTEMxxx~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~DEFAULT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBTEMP_ONF:					
		CLR SPK					;tat loa
		CALL DEFAULT			;tra cac bien ve mac dinh
		CALL EFECT3				;goi hieu ung 3
		JNB P_ONF,$-3			;cho nha phim onf
		JMP SUBTEM1				;tro ve kt tiep
;~~~~~~~~~~~CHAY HIEU UNG/LOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUBTEMP_STA:
		CLR TT					;bao da chon phim
		CALL EFECT3				;goi hieu ung 3
		MOV P3,#0B1H			;loi F1
		CLR FAL					;hien thi chu F
		CALL DELAY500MS			;tri hoan 0.5s
		SETB SPK				;bat loa
		CALL DELAY500MS			;tri hoan 0.5s
		CLR SPK					;tat loa
		CALL DELAY500MS			;tri hoan 0.5s
		SETB FAL				;tat chu f
		CALL EFECT2				; goi hieu ung 2
		MOV P3,#0B3H			;loi F3
		CLR FAL					;hien thi chu F
		SETB SPK				;bat loa
		CALL DELAY500MS			;tri hoan 1s
		CALL DELAY500MS			;<>
		CLR SPK					;tat loa
		CALL EFECT1				;goi hieu ung 1
		CALL ERO4				;goi loi F4
		CALL EFECT2				;goi hieu ung 2
		CALL ERO5				;goi loi F5
		CALL EFECT3				;goi hieu ung 3
		CALL ERO6				;goi loi F6
		CALL EFECT4				;goi hieu ung 4
		CLR TT					;bat trang thai
		CALL CONTACT			;goi hieu ung contact
		JMP SUBTEM1				;tro ve kiem tra trang thai phim
;~~~~~~~~~~~~~~~~~~~~CHON LOI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB2_SLE:			
		INC COU2				;tang thu thu bien LOI
		MOV A,COU2				;kiem tra thu tu bien
		CJNE A,#4,$+6			;<>
		MOV COU2,#1				;neu bang 4 thi tro ve 1
		CALL HT_VAR2			;goi chuong trinh hien thi
		JNB P_SLE,$-3			;cho nha phim sle
		JMP SUBTEM2				;tro ve kiem tra trang thai phim
;~~~~~~~~~~~~~~~NHAY TIEP SUC~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUBTEMP_DEC:
			JMP SUBTEMP1_DEC	
SUBTEMP_INC:
			JMP SUBTEMP1_INC

;````````````````````CHON THU TU BIEN TU 1-6`````````````````````````
SUBTEMP_SLE:	
		INC COU					;tang thu tu bien cai dat
		MOV A,COU				;kiem tra thu tu bien
		CJNE A,#10,$+6			;<>
		MOV COU,#1				;neu bang 10 thi tro ve 1
		CALL HT_VAR				;hien thi
		JNB P_SLE,$-3			;cho nha phim sle
		JMP SUBTEM1				;tro ve kiem tra trang thai phim
;~~~~~~~~~~~~~~~~~~~~~~~~~GAN BIEN VAO BIEN HIEN THI~~~~~~~~~~~~~~~~~
;Tuong ung voi tung gia tri cua COU se hien thi gia tri cua bien tuong ung
INSERT_VAR:
		MOV VAR2,COU	;chuyen thu tu bien cai dat vao bien hien thi
		MOV A,VAR2		;tuong ung voi thu tu bien co duoc gia tri cua bien do
		CJNE A,#1,$+6	;<>
		MOV TEM3,DLF	;<>
		CJNE A,#2,$+6	;<>
		MOV TEM3,DLO	;<>
		CJNE A,#3,$+6	;<>
		MOV TEM3,TGD	;<>
		CJNE A,#4,$+6	;<>
		MOV TEM3,SLD	;<>
		CJNE A,#5,$+6	;<>
		MOV TEM3,TOF	;<>
		CJNE A,#6,$+6	;<>
		MOV TEM3,TON	;<>
		CJNE A,#7,$+6	;<>
		MOV TEM3,REP	;<>
		CJNE A,#8,$+6	;<>
		MOV TEM3,DLS	;<>
		CJNE A,#9,$+6	;<>
		MOV TEM3,KIP	;<>
		RET				; ket thuc
;~~~~~~~~~~~~~~~~~TANG GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP1_INC:
		CALL RESEACH	;gọi chương trình thăm dò biến
		CALL HT_VAR		;hiển thị biến
		JNB P_INC,$-3	;chờ nhả phím inc
		LJMP SUBTEM1	;trở về quét tiếp
;~~~~~~~~~~~~~~~~~GIAM GIA TRI CUA BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~
          
SUBTEMP1_DEC:
		CALL RESEACH	;goi chuong trinh tham do bien
		CALL HT_VAR		;hien thi bien
		JNB P_DEC,$-3	;cho nha phim dec
		LJMP SUBTEM1	;nhay vw quet tiep
;~~~~~~~~~~~~~~~~~~~~~~~~~THAM DO BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          
RESEACH:
		MOV A,COU		;tu thu tu bien suy ra gia tri tuong ung
		CJNE A,#1,$+6	;<>
		CALL F_DLF		;bien 1 DLF
		CJNE A,#2,$+6	
		CALL F_DLO		;bien 2 DLO
		CJNE A,#3,$+6
		CALL F_TGD		;bien 3 TGD
		CJNE A,#4,$+6
		CALL F_SLD		;bien 4 SLD
		CJNE A,#5,$+6
		CALL F_TOF		;bien 5 TOF
		CJNE A,#6,$+6
		CALL F_TON		;bien 6 TON
		CJNE A,#7,$+6
		CALL F_REP		;bien 7 REP
		CJNE A,#8,$+6
		CALL F_DLS		;bien 8 DLS
		CJNE A,#9,$+6
		CALL F_KIP		;bien 9 KIP
		RET	
;~~~~~~~~~~~~~~TANG/GIAM BIEN DLF~~~~~~~~~~~~~~~~~~~~~~~
F_DLF:
		JB P_INC,CONT_DLF		;cho nha phim inc
		INC DLF					;tang DLF len 1
		MOV A,DLF				;so sanh DLF vo 91
		CJNE A,#91,EXIT_F_DLF	;<>
		MOV DLF,#0				;neu DLF bang 91 thi tro ve 0
		JMP EXIT_F_DLF			;thoat-tang
CONT_DLF:
		DEC DLF					;giam DLF
		MOV A,DLF				;so sanh DLF voi -1
		CJNE A,#-1,$+6			;<>
		MOV DLF,#90				;neu DLF bang -1 thi tro ve 0
EXIT_F_DLF:
		RET
;~~~~~~~~~~~~~~~~~~~~TANG/GIAM BIEN DLO~~~~~~~~~~~~~~
F_DLO:	
		JB P_INC,CONT_DLO		;cho nha phim inc
		INC DLO					;tang DLO len 1
		MOV A,DLO				;so sanh DLF voi 91
		CJNE A,#91,EXIT_F_DLO	;<>
		MOV DLO,#0				;neu DLo bang 91 thi tro ve 0
		JMP EXIT_F_DLO			;thoat-tang
CONT_DLO:
		DEC DLO					;giam DLO xuong 1
		MOV A,DLO				;so sanh DLO voi -1
		CJNE A,#-1,$+6			;<>
		MOV DLO,#90				; neu DLO bang -1 thi tro ve 0
EXIT_F_DLO:
		RET
;~~~~~~~~~~~~TANG/GIAM GIA TRI TGD~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~TANG/GIAM  GIA TRI SLD ~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI TOF~~~~~~~~~~~~~
F_TOF:	
		JB P_INC,CONT_F_TOF
		INC TOF
		MOV A,TOF
		CJNE A,#10,EXIT_F_TOF
		MOV TOF,#0
		JMP EXIT_F_TOF
CONT_F_TOF:
		DEC TOF
		MOV A,TOF
		CJNE A,#-1,$+6
		MOV TOF,#9
EXIT_F_TOF:
		RET
;~~~~~~~~~~~~~~~~TANG/GIAM GAI TRI TON~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI REP~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI DLS~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~~~TANG/GIAM GIA TRI KIP~~~~~~~~~~~
F_KIP:
		JB P_INC,CONT_F_KIP
		INC KIP
		MOV A,KIP
		CJNE A,#31,EXIT_F_KIP
		MOV KIP,#0
		JMP EXIT_F_KIP
CONT_F_KIP:
		DEC KIP
		MOV A,KIP
		CJNE A,#-1,$+6
		MOV KIP,#30
EXIT_F_KIP:
		RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~CAI DAT LOI~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~
SUB2_DEC:
		JMP SUB21_DEC
SUB2_INC:
		JMP SUB21_INC
SUB22_SLE:
		JMP SUB2_SLE

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~GIAM TAN SO QUET~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~~TANG TAN SO QUET~~~~~~~~~~~~~~~~~
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

;~~~~~~~~~~~~~~CHEN BIEN~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
;~~~~~~~~~~~~~~~~THAM DO BIEN LOI~~~~~~~~~~~~~~~~~~
RESEACH2:
		MOV A,COU2
		CJNE A,#1,$+6
		CALL F_F1
		CJNE A,#2,$+6
		CALL F_F2
		CJNE A,#3,$+6
		CALL F_F3
		RET
;~~~~~~~~~~~~~~~~~~TANG~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB21_INC:
		CALL RESEACH2
		CALL HT_VAR2
		JNB P_INC,$-3
		LJMP SUBTEM2		
;~~~~~~~~~~~~~~GIAM~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB21_DEC:
		CALL RESEACH2
		CALL HT_VAR2
		JNB P_DEC,$-3
		LJMP SUBTEM2
;~~~~~~~~~~~~~~~~~~	TANG GIAM F1~~~~~~~~~~~~~~~~~~
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
		CALL EFECT1
		MOV TEM4,DLF
		MOV TEM5,DLO
		MOV TEM6,TGD
		MOV TEM7,SLD
		MOV TEM8,TOF
		MOV TEM9,TON
		MOV TEM10,REP
		MOV TEM11,DLS
		MOV TEM13,KIP
		MOV TEM12,#60
		MOV TEM15,F1
		MOV TEM16,F2
		MOV TEM17,F3
		MOV TEM00,#1
		MOV WAITX,#3
;~~~~~~~~THIET LAP CHE DO MAC DINH KHI BAT DAU CHE DO AUTO~~~~~~
		JB CB3,CONT_AUTO
		JB CB2,CB2_AUTO
		CALL CONTACT
		JMP MAINT_AUTO
CONT_AUTO:
		SETB K2
		CALL CONTACT
		CLR K1
;~~~~~~~~~~~~~~~~~~~~~~~~~~KIEM TRA CB1~~~~~~~~~~~~~~~~~~~~~~~~
SUB_CB1:
		JNB P_SLE,KEYBOARD22
		CLR SPK					;TAT LOA
		SETB FAL				;TAT HIEN THI CHU F
		CALL CHARGE
		JB CB1,SUB11_CB1		;Kiem tra dien luoi
		JNB BD1,SUB_BD1			;Kiem tra bien dong 1
		MOV A,DLF
		CJNE A,#0,SUB_DLF		;Kiem tra bien DLF co bang 0 chua?
		MOV DLF,TEM4
		JNB CB3,SUB_CB3			;Kiem tra may co chay khong?
		SETB K2
		CALL CONTACT
		CLR K1
		JMP SUB_CB1
;~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MAINT_AUTO:
		JMP MAINT
CB2_AUTO:
		JMP SUB3_CB2
KEYBOARD22:
		CALL RECAL
		JMP KEYBOARD
SUB11_CB1:
		JMP SUB1_CB1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB_BD1:
		CLR FAL					;LOI F1
REPEAT_F1:
		CPL SPK
		JB BD1,EXIT2_F1			;kiem tra bien dong 1
		JNB P_SLE,KEYBOARD22	;thoat ve che do bang tay khi an phim sle
		MOV A,F1				;kiem tra thoi gian cho phep
		CJNE A,#-1,ERRO2_F1		;<>
		SETB K1					;ngat k1
		CALL RECAL				;tra lai bien
		JMP KEYBOARD			; tro ve ban phim
EXIT2_F1:
		MOV F1,TEM15			;phuc hoi gia tri bien F1
		JMP SUB_CB1				;tro ve kiem tra CB1
ERRO2_F1:
		MOV VAR2,#1				;cho hien thi thu tu bien 1
		MOV TEM3,F1				;gia tri bien 1
		CALL DELAYHTS			;hien thi
		DEC F1					;giam gt F1
		JMP REPEAT_F1			;kiem tra tiep
		
SUB_CB3:
		MOV DLS,TEM11			;tra lai gia tri bien cho DLs
		JB CB2,REPEAT_DLS1		;Neu may co chay thi kiem tra CB2 Co dien khong?
		CALL EFECT1				;goi hieu ung 1
		JMP MAINT				;NHAY DEN duy tri
SUB_DLF:
		MOV VAR2,#0FH			;tat led 7 doan cuoi
		MOV TEM3,DLF			;hien gia tri DLF
		CALL DELAYHTS			;hien thi
		DEC DLF					; giam DLF
		SETB FAL				;tat chu F
		MOV DLO,TEM5			;tra lai gia tri bien DLo
		JMP SUB_CB1				;nhay ve kt CB1
REPEAT_DLS1:
		JNB P_SLE,SUB22_CB333
		JNB CB2,SUB_CB3			;kien tra CB2
		MOV A,DLS				;dem lui DLS
		CJNE A,#0,SUB_DLS1		;<>
		MOV DLS,TEM11			;tra lai gt bien DLs
		SETB ONF				;tat diezel
		SETB K2					;ngat k2
		JMP	SUB3_CB2			;bao loi f5
SUB_DLS1:
		MOV VAR2,#0FH			;kho hien thi led cuoi
		MOV TEM3,DLS			;hien thi bien DLF
		CALL DELAYHTS			;hien thi
		DEC DLS					;giam gt bien DLF
		JMP REPEAT_DLS1			;lap lai
SUB3_CB2:	
		CALL ERO5				;LOI F5
		JNB P_SLE,KEYBOARD2		;ngay ve che do phim khi nhan sle
		JMP SUB3_CB2			;lap lai
;~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~
SUB31_CB1:
		JMP SUB_CB1
KEYBOARD2:
		JNB P_SLE,$
		CALL RECAL
		JMP SUB_CB1
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
SUB22_CB333:
		JMP SUB22_CB33
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB1_CB1:
		JNB KTM,SUBB1_KTM		;Kiem tra may(dau, nuoc)
		JNB BD2,SUBB1_BD2		;Kiem tra qua dong ?
		MOV A,DLO				;so sanh DLO co bang 0 chua
		CJNE A,#0,SUBB1_DLO		;dem
		MOV DLO,TEM5			;tra lai gt bien cho DLO
RESUB1_K2:
		JNB CB3,SUBB2_CB3		;Kt may chay hay chua?
		JNB K2,SUBB11_K2		;kiem tra K2 xem co ON chua?
		SETB K1					;ngat k1,k2
		SETB K2					;<>
		CLR ONF					;MO MAY
		CALL EFECT1				;goi hieu ung 1
REPEAT_STA:
		JNB P_SLE,SUB22_CB333
		CLR STA					;DE
		MOV A,TGD				;kiem tra thoi gian de het chua
		CJNE A,#0,SUB1_TGD		;<>
		MOV TGD,TEM6			;tra laij gt bien thoi gian de
		SETB STA				;NGUNG DE
		CALL EFECT1				;goi hieu ung 1
REP_KIP:
		JNB P_SLE,SUB22_CB33		
		MOV A,KIP				;kiem tra bien KIP bang 0 chua
		CJNE A,#0,SUB_KIP		;<>
		MOV KIP,TEM13			;tra laij gt bien KIP
		JNB CB3,SUB33_CB3		;KIEM TRA CO DIEN CHUA
		DEC SLD					;giam gt bien SLD
		JMP START				;nhay den start
SUB_KIP:
		MOV VAR2,#0FH			;khong hien thi le cuoi
		MOV TEM3,KIP			;tra lai bien KIP
		CALL DELAYHTS			;hien thi
		DEC KIP					;giam gt bien KIP
		JMP REP_KIP				;lap lai
;''''''''''''''''''''''''''''''''''''
SUB22_CB33:
		JMP SUB22_CB2
;''''''''''''''''''''''''''''''''''''
START:
		PUSH 00H				;cat R0 vao ngan xep
		CALL EFECT4				;goi hieu ung 4
		INC TEM00				;tang bien tem00
		MOV R0,#50				;nap R0=50
REDIS:	
		JNB P_SLE,SUB22_CB33
		MOV VAR2,TEM00			;hien thi tem00
		MOV VAR1,#0FFH			;tat hai le dau tien
		CALL DISPLAY			;hien thi
		DJNZ R0,REDIS			;giam R0
		POP 00H					;tra lai gt cho R0
		MOV A,SLD				;kiem tra SLD bang 0 chua
		CJNE A,#0,REPEAT_REP	;<>
		MOV SLD,TEM7			;tra lai gt bien SLD
		JMP REPEAT_ERO6			;bao loi F6
REPEAT_REP:
		JNB P_SLE,SUB22_CB33					
		JNB CB3,SUB33_CB3		;kiem tra may chay chua
		MOV A,REP				;kiem tr bien REP co bang )chua
		CJNE A,#0,SUB_REP		;<>
		MOV REP,TEM10			;tra lai bien REP
		JMP REPEAT_STA			;lap lai
SUB_REP:
		MOV VAR2,#0FH			;tat le cuoi
		MOV TEM3,REP			;hien thi gt bien REP
		CALL DELAYHTS			;hien thi
		DEC REP					; giam REP
		JMP REPEAT_REP			;lap lai
SUB1_TGD:
		MOV VAR2,#0FH			;tat led cuoi
		MOV TEM3,TGD			;hien thi TGD
		CALL DELAYHTS			;hien thi
		DEC TGD					;giam TGD
		JMP REPEAT_STA			;lap lai
		
REPEAT_ERO6:
		CALL ERO6				; LOI F6
		JNB CB1,SUB22_CB33		;nhay ve ban phim khi co dien lai
		JNB P_SLE,KEYBOARD11	;nhan SLE de tro ve ban phim
		JMP REPEAT_ERO6			;lap lai
SUB22_CB2:	
		SETB ONF				;tat may
		SETB K2					;ngat K2
		CALL EFECT2				;goi hieu ung
		CLR K1					;dong  K1
		CALL RECAL				;phuc hoi gia tri cua tat ca cac bien
		JMP KEYBOARD			;nhay ve che do ban phim
SUB33_CB3:						;<>
		MOV REP,TEM10			;tra lai gia tri cho bien REP
		MOV DLS,TEM11			;-------------------------DLS
		MOV SLD,TEM7			;-------------------------SLD
		CALL EFECT2				;goi hieu ung
SUB3_CB3:
		JNB P_SLE,SUB22_CB33						
		JB CB2,REPEAT_DLS		;kien tra CB2
		MOV A,TON				;So sanh bien TON
		CJNE A,#0,SUB1_TON		;<>
		MOV TON,TEM9			;tra lai gia tri cho bien TON
		CALL EFECT1				;goi hieu ung
		JMP MAINT				;nhay den chuong trinh AUTO_B
SUB1_TON:
		MOV VAR2,#0FH			;ko hien thi led cuoi
		MOV TEM3,TON			;chuyen gia tri cua bien TON vao bien HT
		CALL DELAYHTS			;hien thi
		DEC TON					;giam bien TON
		JMP SUB3_CB3			;lap lai
REPEAT_DLS:
		JNB P_SLE,SUB22_CB2
		MOV TON,TEM9			;tra lai gia tri cho bien TON
		JNB CB2,SUB33_CB3		;kiem tra CB2
		MOV A,DLS				;so sanh DLS voi 0
		CJNE A,#0,SUB_DLS		;<>
		MOV DLS,TEM11			;tra lai gia tri bien DLS
		SETB ONF				;tat may
		SETB K2					;ngat K2
		JMP	SUB4_CB2			;nhay den loi F5
SUB_DLS:
		MOV VAR2,#0FH			;ko hien thi led cuoi
		MOV TEM3,DLS			;chuyen gia tri cua bien DLS vao bien HT
		CALL DELAYHTS			;goi chuong trinh hien thi
		DEC DLS					;giam DLS
		JMP REPEAT_DLS			;lap lai
SUB4_CB2:
		CALL ERO5				;LOI F5
		JNB CB1,SUB22_CB2		;tro ve ban phim nen co dien tro lai
		JNB P_SLE,KEYBOARD1		;nhan phim P_sle de tro ve ban phim
		JMP SUB4_CB2			;lap lai
;~~~~~~~~~~~TAT MAY~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD11:
		CALL RECAL				;phuc hoi cac gia tri bien
		JMP KEYBOARD			;nhay ve che do ban phim
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB1_KTM:
		CLR FAL					; LOI F3
REPEAT_F3:
		SETB SPK				;bat loa
		JB KTM,EXIT2_F3			;kiem tra bien KTM
		JNB P_SLE,KEYBOARD1		;nhan phim Psle de tro ve ban phim
		MOV A,F3				;so sanh F3 vơi -1
		CJNE A,#-1,ERRO_F3		;<>
		SETB ONF				;tat may
		CALL RECAL				;phuc hoi tat ca cac gia tr cua bien
		JMP KEYBOARD			;nhay ve ban phim
EXIT2_F3:					
		MOV F3,TEM17			;tra lai gia tri bien F17
		JMP SUB_CB1				;nhay den chuong trinh auto_B
ERRO_F3:
		MOV VAR2,#3				;led cuoi hien so 3
		MOV TEM3,F3				;xuat gia tri F3 ra bien ht
		CALL DELAYHTS			;goi tre dong thoi co hien thi
		DEC F3					;giam F3 xuong 1
		JMP REPEAT_F3			;lap lai
;~~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~

KEYBOARD1:
		CALL RECAL				;phuc hoi lai tat ca cac gia tri cua bien
		JMP KEYBOARD			;nhay ve ban phim
SUBB1_K2:
		JMP SUB1_K2				;nhay den chuong trinh SUB1k2

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUB1_BD2:
		CLR FAL					; LOI F2
REPEAT_F2:
		CPL SPK					;tat loa
		JB BD2,EXIT2_F2			;kiem tra bien dong 2
		JNB P_SLE,KEYBOARD1		;nhay ve ban phim khi nhan phim P sle
		MOV A,F2				;so sanh F2 vo -1
		CJNE A,#-1,ERRO_F2		;<>
		SETB K2					;tat K2
		CALL RECAL				;phuc hoi bien
		JMP KEYBOARD			;nhay ve che do ban phim
EXIT2_F2:	
		MOV F2,TEM16			;tra lai gia tri cho F2
		JMP SUB_CB1				;tro ve
ERRO_F2:	
		MOV VAR2,#2				;led cuoi hien so 2
		MOV TEM3,F2				;hien thi gia tri F2
		CALL DELAYHTS			;goi tre dong thoi hien thi
		DEC F2					;giam F2
		JMP REPEAT_F2			;lap lai
SUB1_DLO:						;hien thi bien dem
		MOV VAR2,#0FH			;ko hien thi led cuoi
		MOV TEM3,DLO			;hien thi gia tri DLO
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC DLO					;giam bien DLO
		SETB FAL				;tat chu F
		MOV DLF,TEM4			;tra lai gia tri cho DLF
		JMP SUB_CB1				; nhay ve
SUB2_CB3:			
		MOV DLS,TEM11			;tra lai gia tri cho DLS
		JB CB2,REPEAT_DLS2		;kiem tra CB2
		SETB K1					;tat K1
		CALL CONTACT			;goi hien thi
        CLR K2					;bat K2
        JMP SUB_CB1				;nhay ve
REPEAT_DLS2:			
		JNB CB2,SUB2_CB3		;kiem tra CB2
		MOV A,DLS				;so sanh DLS bang 0 chua
		CJNE A,#0,SUB_DLS2		;<>
		MOV DLS,TEM11			;tra laij gia tri cho DLS
		SETB ONF				;tat may
		SETB K2					;ngat K2
		JMP	SUB2_CB2			;nhay den bao loi F5
SUB_DLS2:
		MOV VAR2,#0FH			;tat LEd cuoi
		MOV TEM3,DLS			;hien thi bien DLS
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC DLS					;giam DLS
		JMP REPEAT_DLS2			;lap lai
SUB2_CB2:
		CALL ERO5				;LOI F5
		JNB CB1,KEYBOARD3		;nhay ve ban phim neu CB1= 0
		JNB P_SLE,KEYBOARD3		;nhay ve ban phim neu an phim P_SLE
		JMP SUB2_CB2			;lap lai
SUB1_K2:
		CALL ERO4				;LOI F4 
		JNB CB1,SUBF_CB1		
		JNB P_SLE,KEYBOARD3
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
		SETB FAL				;tat chu F
		CLR SPK					;bat loa
		JNB P_SLE,KEYBOARD3		;nhay ve ban phim neu an phim P_SLE
		JB CB1,SUBB4_CB1		;kiem tra CB1
		MOV DLO,TEM5			;tra lai bien cho DLO
		MOV A,DLF				;so sanh DLF voi 0
		CJNE A,#0,SUB5_DLF		;<>
		SETB K2					;ngat K2
		MOV A,TOF
		CJNE A,#0,CON_TOF
		JMP END_SUB
CON_TOF:
		MOV VAR2,TOF			;led cuoi hien thi gia tri TOF
		MOV TEM3,TEM12			;hien thi gia tri bien tem12
		CPL LED					;dao bit LEd
		MOV P1,#00H				;bat ca cac led deu sang
		CALL DELAYHTS			;goi tre dong thoi hien thi
		MOV P1,#0FFH			;tat ca cac led deu sang
		CLR K1					;dong K1
		JNB KTM,SUB5_KTM		;kiem tra KTM
		JNB BD1,SUB5_BD1		;kiem tra bien dong 1
		DJNZ TEM12,SUB_TEM12	;giam va so sanh Tem12
		MOV TEM12,#60			;tra lai gia tri cho Tem12
		DJNZ TOF,SUBF_CB1		;giam va so sanh TOF
		MOV TOF,TEM8			;tra lai gia tri cho TOF
END_SUB:
		CALL EFECT2				;goi hieu ung
		SETB FAL 				;tat chu F
		SETB K2					;ngat K2
		CALL EFECT1				;goi hieu ung
		CLR K1					;bat K1
		SETB ONF				;tat may
		CALL RECAL				;phuc hoi gia tri bien
		CALL EFECT1				;goi hieu ung
		JNB CB3,$-3				;TẮT MÁY MỚI ĐC VỀ
		JMP SUB1_CB1			;tro ve
SUB5_DLF:
		MOV VAR2,#0FH			;ko hien thi led cuoi
		MOV TEM3,DLF			;hien thi gia tri bien DLF
		CALL DELAYHTS			;goi tre dong thoi hien thi
		DEC DLF					;giam bien DLF
		SETB FAL				;tat chu F
		JMP SUBF_CB1			;tiep tuc
SUB_TEM12:
		SETB FAL				;tat chu F
		JMP SUBF_CB1			;tiep tuc
SUB5_KTM:
		CLR FAL					;F3, bat chu f
REPEAT5_F3:
		SETB SPK				;bat loa
		JB KTM,EXIT5_F3			;kien tra KTM
		JNB P_SLE,KEYBOARD44	;an phim P SLE de tro ve ban phim
		MOV A,F3				;so sanh F3 voi -1
		CJNE A,#-1,ERRO5_F3		;<>
		SETB ONF				;tat may
		CALL RECAL				;phuc hoi tat ca cac bien
		JMP KEYBOARD			;nhay ve ban phim
EXIT5_F3:
		MOV F3,TEM17			;tra lai gia tri cho F3
		JMP SUBF_CB1			;tiep tuc
ERRO5_F3:
		MOV VAR2,#3				;led cuoi hien thi so 3
		MOV TEM3,F3				;hien thi gia tri F3
		CALL DELAYHTS			;hien thi dong thoi tre
		DEC F3					;giam gia tri F3 xuong 1
		JMP	REPEAT5_F3			;lap lai
SUB5_BD1:
		CLR FAL					;LOI F1
REPEAT5_F1:
		CPL SPK					;tat loa
		JB BD1,EXIT5_F1			;kiem tra bien dong 1
		JB CB1,SUBF2_CB1		;kiem tra CB1
		JNB P_SLE,KEYBOARD44	;nhan P_sle de tro ve ban phim
		MOV A,F1				;so sang F1 voi -1
		CJNE A,#-1,ERRO5_F1		;<>
		SETB K1					;ngat K1
		CALL RECAL				;phuc hoi cacs gia tri cua bien
		JMP KEYBOARD			;nhay ve ban phim

EXIT5_F1:						
		MOV F1,TEM15			;tra lai gia tri cho F1
		JMP SUBF_CB1			;tiep tuc
ERRO5_F1:	
		MOV VAR2,#1				;led cuoi hien thi so 1
		MOV TEM3,F1				;hien thi gia tri F1
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC F1					;giam F1
		JMP REPEAT5_F1			;lap lai
;~~~~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~
END_SUB1:
			JMP END_SUB
KEYBOARD44:
		CALL RECAL
		JMP KEYBOARD
SUBF2_CB1:
		JMP SUBF_CB1
SUB22_CB3:
		CALL RECAL
		JMP SUB2_CB3
SUB88_BD2:
		JMP SUB8_BD2
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SUB4_CB1:
		MOV DLF,TEM4			;tra lai gia tri cho DLF
		MOV A,DLO				;so sanh DLO voi 0
		CJNE A,#0,SUB5_DLO		;<>
		SETB K1					;ngat K1
		CPL LED					;chop tat led
		PUSH 00H				;cat thanh ghi R0
		CALL CONTACT			;goi hieu ung
		MOV R0,#50				;nap R0 gia tri 50
REPHT_CB:			
		CALL HT_CB				;goi chuong trinh hien thi tt
		DJNZ R0,REPHT_CB		;giam R0 va so sanh
		POP 00H					;tra lai gia tri cho R0
		CLR K2					;dong K2
		JNB KTM,SUB8_KTM		;kiem tr KTM
		JNB BD2,SUB88_BD2		;kiem tr bien dong 2
		JB  CB3,SUB8_CB3		;kiem tr cam bien 3
		JB CB2,REPEAT_DLS3		;kiem tr cam bien 3
SUB8_TOF:
		MOV TEM12,#60			;tra lai gia tri cho TEM12
		MOV TOF,TEM8			;tra lai gia tri cho TOF
		SETB FAL				;tat chu F
		JMP SUBF_CB1			;tiep tuc
SUB5_DLO:				
		MOV VAR2,#0FH			;tat le cuoi
		MOV TEM3,DLO			;hien thi gia tri bien DLO
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC DLO					;giam DLO
		SETB FAL				;tat chu F
		JMP SUBF_CB1			;tiep tuc
SUB8_CB3:
		CALL ERO4				;LOI F4
		JNB CB1,END_SUB1		;kiem tr CB1
		JNB P_SLE,KEYBOARD44	;nhan P SLE de tro ve ban phim
		JNB CB3,SUB4_CB1		;kiem tr CB3
		JMP SUB8_CB3			;bao loi F5
		
REPEAT_DLS3:
		JNB CB2,SUB22_CB3		;kiem tr Cb2
		MOV A,DLS				;so sanh DLS voi 0
		CJNE A,#0,SUB_DLS3		;<>
		MOV DLS,TEM11			;tra lai gia tri cho DLS
		SETB ONF				;tat may
		SETB K2					;ngat K2
		JMP	SUB8_CB2			;loi F5
SUB_DLS3:
		MOV VAR2,#0FH			;khong hien led cuoi
		MOV TEM3,DLS			;hien thi gia tri bien TEM3
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC DLS					;gia DLs
		JMP REPEAT_DLS3			;lap lai
SUB8_CB2:	
 		CALL ERO5				;LOI F5
 		JNB CB1,KEYBOARD444		;nhay ve ban phim neu CB1=0
		JNB P_SLE,KEYBOARD4		;tro ve ban phim neu nhan phim P SLE
		JMP SUB8_CB2			;lap lai

SUB8_KTM:
		CLR FAL					;LOI F3
REPEAT2_F3:
		SETB SPK				;bat loa
		JB KTM,EXIT4_F3			;kiem tr bien KTM
		JNB P_SLE,KEYBOARD4		;nhay ve ban phim neu an phim p sle
		MOV A,F3				;so sanh F3 voi -1
		CJNE A,#-1,ERRO4_F3		;<>
		SETB ONF				;tat may
		CALL RECAL				;phuc hoi tat ca cacs gia tri bien
		JMP KEYBOARD			;nhay ve ban phim
EXIT4_F3:
		MOV F3,TEM17			;phuc hoi bien F3
		JMP SUBF_CB1			;tiep tuc
ERRO4_F3:			
		MOV VAR2,#3				;led cuoi hien thi so 3
		MOV TEM3,F3				;hien thi gia tri F3
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC F3					;gia gia tri F3
		JMP REPEAT2_F3			;lap lai
SUB8_BD2:
		CLR FAL					;LOI F2
REPEAT4_F2:
		CPL SPK					;tat loa
		JB BD2,EXIT4_F2			;kiem tra bien dong 2
		JNB CB1,SUBF22_CB1		;kiem tra CB1
		JNB P_SLE,KEYBOARD4		;an phim p sle de tro ve ban phim
		MOV A,F2				;so sanh F2 voi -1
		CJNE A,#-1,ERRO4_F2		;<>
		SETB K2					;tat K2
		CALL RECAL				;phuc hoi tat ca cac bien
		JMP KEYBOARD			;tro ve ban phim
EXIT4_F2:
		MOV F2,TEM16			;phuc hoi F2
		JMP SUBF_CB1			;tiep tuc
ERRO4_F2:
		MOV VAR2,#2				;led cuoi hien thi so 2
		MOV TEM3,F2				;hien thi gia tri F2
		CALL DELAYHTS			;tre dong thoi hien thi
		DEC F2					;giam F2
		JMP	REPEAT4_F2			;lap lai
;~~~~~~~~~~~~~~~~~~~~NHAY NOI TIEP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
KEYBOARD444:
		SETB K2
		CALL EFECT1
		CLR K1
		JMP KEYBOARD
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
		MOV KIP,TEM13
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
		MOV DLF,#5
		MOV DLO,#3
		MOV TGD,#2
		MOV SLD,#2
		MOV TOF,#1
		MOV TON,#3
		MOV REP,#5
		MOV DLS,#5
		MOV KIP,#3
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