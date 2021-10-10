; dinh nghia port
SEG 	DATA P1

LM1		BIT P3.3
LM2 	BIT	P3.2
LH1 	BIT	P3.1
LH2 	BIT	P3.0

KEY1	BIT P3.4
KEY2	BIT P3.5
LAMP	BIT P3.7

;DINH NGIA BIEN BYTE



HOR		DATA	30H
MIN		DATA	31H
SEC		DATA	32H

SEC1	DATA	33H
SEC2 	DATA	34H

MIN1	DATA	35H
MIN2	DATA	36H

HOR1	DATA	37H
HOR2	DATA	38H

HOR12	DATA	39H

C250MS	DATA	3AH
C500MS 	DATA	3BH
C1S		DATA	3CH
C10S	DATA	3DH

DL1 	DATA 	3EH
DL2		DATA 	3FH

LED1	DATA	40H
LED2	DATA	41H
LED3	DATA	42H
LED4	DATA	43H

C100MS	DATA	44H
COUX	DATA	45H
;DINH NGHIA BIT
TEM1  DATA 20H
T50MS  BIT  TEM1.0
T250MS BIT  TEM1.1
T500MS BIT  TEM1.2
T1S	   BIT  TEM1.3
T10S   BIT  TEM1.4
T100MS BIT	TEM1.5

TEM2	DATA 21H
EN_D1	BIT TEM2.0			;EN =1
EN_D23	BIT TEM2.1

EN_HOR	BIT TEM2.2
EN_MIN	BIT TEM2.3

AM_PM	BIT TEM2.4			;1 AM/ 0 PM
H24_H12	BIT	TEM2.5			;1 H24/ 0 H12
NEW_MIN	BIT	TEM2.6
NEW_HOR	BIT	TEM2.7


TEM3	DATA	22H
EN_1	BIT		TEM3.0
EN_2	BIT		TEM3.1
EN_3	BIT		TEM3.2
EN_4	BIT		TEM3.3
EN_ALL	BIT		TEM3.4

;~~~~~~~~BEGIN~~~~~~~~
ORG		0000H
JMP		BEGIN
ORG		0001BH
MOV TH1,#HIGH(-49995)
MOV TL1,#LOW (-49995)
CLR TF1
SETB T50MS
RETI

BEGIN:
MOV DPTR,#CODE_7
MOV IE,#88H				;CHO PHEP NGAT DO BO DINH THOI 1
MOV TMOD,#10H			; TIMER 1 CHE DO 16BIT
SETB TF1
SETB TR1
MOV C100MS,#2
MOV C250MS,#5
MOV C500MS,#2
MOV C1S,#2
MOV C10S,#10
SETB LAMP
MOV HOR,#0
MOV MIN,#0
MOV SEC,#0

SETB KEY1
SETB KEY2

SETB EN_1
SETB EN_2
SETB EN_3
SETB EN_4
CLR EN_ALL
MOV COUX,#4

CLR EN_HOR
CLR EN_MIN
SETB H24_H12			;CHON 24H
MOV R1,#3
CALL EFF1
MOV R1,#3
CALL EFF2
MOV R1,#3
CALL EFF3
MOV R1,#3
CALL EFF4
MOV R1,#3
CALL EFF5
MOV R1,#3
CALL EFF6
MAIN:
		CALL ALL
		CALL KEY
		CALL NEW_TIME
		CALL EFFX
		JMP MAIN
						;XU LY PHIM
KEY:
		JNB KEY1,WORK1
		JNB KEY2,WORK2
		JMP EX_KEY
WORK2:
		MOV R7,#50
L7:
		CALL ALL
		JB KEY2,L8
		DJNZ R7,L7
		CPL LAMP
L9:
		CALL ALL
		JNB KEY2,L9
		JMP L10
L8:		
		CPL H24_H12
L10:
		JMP KEY
		
		
		
WORK1:	
		MOV R7,#10	
L1:
		CALL ALL
		JNB KEY1,WORK1
		DJNZ R7,L1
		SETB EN_MIN
		CLR EN_HOR
		CALL REFRESH
L2:		
		JNB KEY1,WORK3
		JNB KEY2,WORK4
		CALL ALL
		JNB T10S,L2
		CLR EN_HOR
		CLR EN_MIN
		JMP KEY
WORK4:
		MOV C500MS,#2
		CLR T500MS
		CALL INC_MIN
		MOV R7,#50
L21:		
		CLR EN_MIN
		CALL ALL
		JB KEY2,L22
		DJNZ R7,L21
L23:		
		CALL SPEED
		CALL INC_MIN
		JNB KEY2,L23
L22:
		CALL REFRESH
		SETB EN_MIN
		JMP L2
WORK3:
		MOV R7,#10	
L3:
		CALL ALL
		JNB KEY1,WORK3
		DJNZ R7,L3
		CLR EN_MIN
		SETB EN_HOR
		CALL REFRESH
L4:
		JNB KEY1,WORK5
		JNB KEY2,WORK6
		CALL ALL
		JNB T10S,L4
WORK5:	
		MOV R7,#10	
L5:
		CALL ALL
		JNB KEY1,WORK5
		DJNZ R7,L5
		CLR EN_HOR
		CLR EN_MIN
		JMP KEY
WORK6:
		MOV C500MS,#2
		CLR T500MS
		CALL INC_HOR
		MOV R7,#50
L51:
		CLR EN_HOR
		CALL ALL
		JB KEY2,L52
		DJNZ R7,L51
L53:		
		CALL SPEED
		CALL INC_HOR
		JNB KEY2,L53
L52:
		CALL REFRESH
		SETB EN_HOR
		JMP L4	
EX_KEY:
		RET
		
;TOC DO TANG
SPEED:
		PUSH 06H
		MOV R6,#9
L_SPEED:
		CALL ALL
		DJNZ R6,L_SPEED
		POP 06H
		RET
;LAM TUOI DONG HO DEM 10S
REFRESH:
		SETB EN_1
		SETB EN_2
		SETB EN_3
		SETB EN_4
		CLR T10S
		MOV C10S,#10
		RET
;LOI "CORE" CUA CHUONG TRINH DONG HO
ALL:
		CALL TIMING
		CALL CLOCK
		CALL DISP
		RET
;TANG PHUT	
INC_MIN:
		INC MIN
		MOV A,MIN
		CJNE A,#60,EX_INC_MIN
		MOV MIN,#0
EX_INC_MIN:
		CALL APM
		CALL DECODE_DIS
		RET	
;TANG GIO			
INC_HOR:
		INC HOR
		MOV A,HOR
		CJNE A,#24,EX_INC_HOR
		MOV HOR,#0
EX_INC_HOR:
		CALL APM
		CALL DECODE_DIS
		RET	
;CHUONG TRINH HIEN THI SO	
DISP:
		JNB EN_MIN,CON_ENMIN		;EN_MIN = 1 ,CHOP CHOP
		JNB T500MS,CON_ENMIN
		CALL DELAY1M
		CALL DELAY1M
		JMP CON_LMIN
CON_ENMIN:	
		MOV A,MIN1
		MOVC A,@A+DPTR
		JNB H24_H12,CON_DOT0		;H24_H12 =1 ;CHOP CHOP	
		JNB T250MS,TIP_DOT1
		CLR ACC.7
		JMP TIP_DOT1
CON_DOT0:
		JNB AM_PM,TIP_AM			; AM = SANG, PM =TAT (DOT)
		CLR ACC.7
		JMP TIP_DOT1
TIP_AM:
		SETB ACC.7
TIP_DOT1:
		MOV SEG,#255
		JNB EN_1,CON_EN_1	
		MOV SEG,A
CON_EN_1:
		CLR LM1
		CALL DELAY1M
		SETB LM1
		MOV A,MIN2
		MOVC A,@A+DPTR
		JNB T500MS,CON_DOT1
		CLR ACC.7
CON_DOT1:
		MOV SEG,#255
		JNB EN_2,CON_EN_2	
		MOV SEG,A
CON_EN_2:		
		CLR LM2
		CALL DELAY1M
		SETB LM2
CON_LMIN:
		JNB EN_HOR,CON_ENHOR		;EN_HOR = 1 ,CHOP CHOP
		JNB T500MS,CON_ENHOR
		CALL DELAY1M
		CALL DELAY1M
		JMP CON_LHOR
CON_ENHOR:	
		MOV A,HOR1
		MOVC A,@A+DPTR
		JNB T500MS,CON_DOT2
		CLR ACC.7
CON_DOT2:
		MOV SEG,#255
		JNB EN_3,CON_EN_3
		MOV SEG,A
CON_EN_3:		
		CLR LH1
		CALL DELAY1M
		SETB LH1
		MOV A,HOR2
		MOVC A,@A+DPTR
		MOV SEG,#255
		JNB EN_4,CON_EN_4
		MOV SEG,A
CON_EN_4:
		CLR LH2
		CALL DELAY1M
		SETB LH2
CON_LHOR:
		RET
;DEM GIO PHUT GIAY
CLOCK:
		JNB T1S,EX_TIME
		CLR T1S
		INC SEC
		MOV A,SEC
		CJNE A,#60,EX_CLOCK
		MOV SEC,#0
		SETB NEW_MIN
		INC MIN
		MOV A,MIN
		CJNE A,#60,EX_CLOCK
		MOV MIN,#0
		SETB NEW_HOR
		INC HOR
		MOV A,HOR
		CJNE A,#24,EX_CLOCK
		MOV HOR,#0
EX_CLOCK:
		CALL APM
		CALL DECODE_DIS
EX_TIME:
		RET
;TACH SO DEM RA HANG CHUC VA DON VI		
DECODE_DIS:
		MOV A,MIN
		MOV B,#10
		DIV AB
		MOV MIN1,B
		MOV MIN2,A
		JNB H24_H12,CON_H12				;H24_12 =1 24H, =0 12H
		MOV A,HOR
		JMP CON_H24
CON_H12:
		MOV A,HOR12
CON_H24:
		MOV B,#10
		DIV AB
		MOV HOR1,B
		MOV HOR2,A
		RET
;AM/PM AND 24 TO 12
APM:
		MOV A,HOR
		CJNE A,#0,CON_APM
		SETB AM_PM
		JMP EX_APM
CON_APM:
		CJNE A,#12,EX_APM
		CLR AM_PM
EX_APM:
		JB AM_PM,CON_TOH12
		MOV A,HOR
		CLR C
		SUBB A,#12
		MOV HOR12,A
		JMP CON2_TOH12
CON_TOH12:
		MOV HOR12,HOR
CON2_TOH12:	
		MOV A,HOR12
		CJNE A,#0,EX_TOH12
		MOV HOR12,#12
EX_TOH12:
		RET	
;CAC TIMER
TIMING:
		JNB T50MS,EX_TIMING
		CLR T50MS
		DJNZ C100MS,EX_100MS
		CPL T100MS
		MOV C100MS,#2
EX_100MS:
		DJNZ C250MS,EX_TIMING
		CPL T250MS
		MOV C250MS,#5
		DJNZ C500MS,EX_TIMING
		CPL T500MS
		MOV C500MS,#2
		DJNZ C1S,EX_TIMING
		SETB T1S
		CLR EN_ALL
		MOV C1S,#2
		DJNZ C10S,EX_TIMING
		CPL T10S
		SETB EN_ALL
		MOV C10S,#10
EX_TIMING:
		RET
;CHUONG TRINH DELAY
DELAY1M:
		MOV DL1,#10
RE_DELAY1M:
		MOV DL2,#250
		DJNZ DL2,$
		DJNZ DL1,RE_DELAY1M
		RET
;=======================================================
;HIEU UNG
;=======================================================
;HIEU UNG KHI PHUT THAY DOI
;HIEU UNG KHI GIO THAY DOI
NEW_TIME:
		JNB NEW_HOR,EX_NEW_MIN
		CLR NEW_HOR
		MOV R1,HOR
		CJNE R1,#0,CON_NEW_HOR
		MOV R1,#3
		CALL EFF3
		JMP EX_NEW_MIN
CON_NEW_HOR:
		MOV R1,#3		
		CALL EFF1
EX_NEW_MIN:
		JNB NEW_MIN,EX_NEW_TIME
		CLR NEW_MIN
		MOV R1,MIN1
		CJNE R1,#0,EX_NEW_MIN2
		MOV R1,#3
		CALL EFF2
		JMP EX_NEW_TIME
EX_NEW_MIN2:
		MOV R1,#3
		CALL EFF4
EX_NEW_TIME:		
		RET

		
EFFX:
		JB EN_ALL,GO_EFFX
		SETB EN_1
		SETB EN_2
		SETB EN_3
		SETB EN_4
		JMP CON_X9
GO_EFFX:
		JNB T50MS,CON_X9
		INC COUX
		MOV A,COUX
		CJNE A,#9,CON_X1
		MOV COUX,#0
		JMP CON_X9
CON_X1:
		CJNE A,#1,CON_X2
		CLR EN_1
		SETB EN_2
		SETB EN_3
		SETB EN_4
CON_X2:
		CJNE A,#2,CON_X3
		SETB EN_1
		CLR EN_2
		SETB EN_3
		SETB EN_4
CON_X3:	
		CJNE A,#3,CON_X4
		SETB EN_1
		SETB EN_2
		CLR EN_3
		SETB EN_4
CON_X4:
		CJNE A,#4,CON_X5
		SETB EN_1
		SETB EN_2
		SETB EN_3
		CLR EN_4
CON_X5:
		CJNE A,#5,CON_X6
		SETB EN_1
		SETB EN_2
		SETB EN_3
		CLR EN_4
CON_X6:
		CJNE A,#6,CON_X7
		SETB EN_1
		SETB EN_2
		CLR EN_3
		SETB EN_4
CON_X7:	
		CJNE A,#7,CON_X8
		SETB EN_1
		CLR EN_2
		SETB EN_3
		SETB EN_4
CON_X8:
		CJNE A,#8,CON_X9
		CLR EN_1
		SETB EN_2
		SETB EN_3
		SETB EN_4
CON_X9:
		RET
		
EFF1:
		MOV DPTR,#EF1
		MOV R0,#3
L2_EFF1:		
		CALL LOAD_E
L_EFF1:
		CALL DISP_E
		JNB T100MS,L_EFF1
		CLR T100MS
		DJNZ R0,L2_EFF1
		DJNZ R1,EFF1
		MOV DPTR,#CODE_7
		RET

EFF2:	
		MOV DPTR,#EF2
		MOV R0,#3
L2_EFF2:		
		CALL LOAD_E
L_EFF2:
		CALL DISP_E
		JNB T100MS,L_EFF2
		CLR T100MS
		DJNZ R0,L2_EFF2
		DJNZ R1,EFF2
		MOV DPTR,#CODE_7
		RET

EFF3:
		MOV DPTR,#EF3
		MOV R0,#12
L2_EFF3:		
		CALL LOAD_E
L_EFF3:
		CALL DISP_E
		JNB T100MS,L_EFF3
		CLR T100MS
		DJNZ R0,L2_EFF3
		DJNZ R1,EFF3
		MOV DPTR,#CODE_7
		RET
EFF4:	
		MOV DPTR,#EF4
		MOV R0,#3
L2_EFF4:		
		CALL LOAD_E
L_EFF4:
		CALL DISP_E
		JNB T100MS,L_EFF4
		CLR T100MS
		DJNZ R0,L2_EFF4
		DJNZ R1,EFF4
		MOV DPTR,#CODE_7
		RET

EFF5:	
		MOV DPTR,#EF5
		MOV R0,#3
L2_EFF5:		
		CALL LOAD_E
L_EFF5:
		CALL DISP_E
		JNB T100MS,L_EFF5
		CLR T100MS
		DJNZ R0,L2_EFF5
		DJNZ R1,EFF5
		MOV DPTR,#CODE_7
		RET
EFF6:
		MOV DPTR,#EF6
		MOV R0,#6
L2_EFF6:		
		CALL LOAD_E
L_EFF6:
		CALL DISP_E
		JNB T100MS,L_EFF6
		CLR T100MS
		DJNZ R0,L2_EFF6
		DJNZ R1,EFF6
		MOV DPTR,#CODE_7
		RET

LOAD_E:
		MOV A,#0
		MOVC A,@A+DPTR
		MOV LED1,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		MOV LED2,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		MOV LED3,A
		INC DPTR
		MOV A,#0
		MOVC A,@A+DPTR
		MOV LED4,A
		INC DPTR
		RET

DISP_E:
		CALL TIMING
		CALL CLOCK
		MOV SEG,LED1
		CLR LM1
		CALL DELAY1M
		SETB LM1
		
		MOV SEG,LED2
		CLR LM2
		CALL DELAY1M
		SETB LM2
	
		MOV SEG,LED3
		CLR LH1
		CALL DELAY1M
		SETB LH1
	
		MOV SEG,LED4
		CLR LH2
		CALL DELAY1M
		SETB LH2
		RET
	

CODE_7:
	DB	0C0H,0F9H,0A4H,0B0H,099H,092H,082H,0F8H,080H,090H
EF1:
db 0FDh
db 0F7h 
db 0FEh 
db 0EFh 
db 0F6h 
db 0FFh 
db 0FFh 
db 0F6h 
db 0FBh 
db 0FEh 
db 0F7h 
db 0DFh 
EF2:
db 0FBh 
db 0FEh 
db 0F7h 
db 0DFh
db 0F6h 
db 0FFh 
db 0FFh 
db 0F6h 	
db 0FDh
db 0F7h 
db 0FEh 
db 0EFh
EF3:
db 0FEh
db 0FFh 
db 0FFh 
db 0FFh 
db 0FFh
db 0FEh 
db 0FFh 
db 0FFh 
db 0FFH 
db 0FFH 
db 0FEH
db 0FFH
db 0FFh 
db 0FFh 
db 0FFh 
db 0FEh 
db 0FFh 
db 0FFh 
db 0FFh 
db 0DFh 
db 0FFh 
db 0FFh 
db 0FFh 
db 0EFh 
db 0FFh 
db 0FFh 
db 0FFh 
db 0F7h 
db 0FFh 
db 0FFh
db 0F7h 
db 0FFh
db 0FFh 
db 0F7h
db 0FFh 
db 0FFh
db 0F7h 
db 0FFh
db 0FFh 
db 0FFh
db 0FBh
db 0FFh 
db 0FFh 
db 0FFh 
db 0FDh 
db 0FFh 
db 0FFh 
db 0FFh 
EF4:
db 0F6h
db 0F6h
db 0F6h
db 0F6h
db 0EDh
db 0EDh 
db 0EDh
db 0EDh 
db 0DBh 
db 0DBh
db 0DBh
db 0DBh
EF5:
db 0DBh 
db 0DBh
db 0DBh
db 0DBh
db 0EDh
db 0EDh 
db 0EDh
db 0EDh 
db 0F6h
db 0F6h
db 0F6h
db 0F6h
EF6:
db 0FEh
db 0FEh
db 0FEh
db 0FEh
db 0FDh 
db 0FDh
db 0FDh
db 0FDh
db 0FBh 
db 0FBh
db 0FBh
db 0FBh
db 0F7h 
db 0F7h
db 0F7h
db 0F7h
db 0EFh 
db 0EFh
db 0EFh
db 0EFh
db 0DFh 
db 0DFh
db 0DFh
db 0DFh
EF7:

	
	
	END