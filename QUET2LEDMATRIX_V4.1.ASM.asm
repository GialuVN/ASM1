;KHAI BAO
STCP BIT P1.7
OE2  BIT P1.5
OE1  BIT  P1.4
AA   BIT P1.0
BB   BIT P1.1
CC   BIT P1.2
E1   BIT P1.3
FIRST EQU  50H
COUNT DATA 30H
XLOW  DATA 31H
XHIG  DATA 32H
;MA MAU
CLX1  DATA 33H
CLX2  DATA 34H
CLX3  DATA 35H
CLX4  DATA 36H
CLX5  DATA 37H
CLX6  DATA 38H
CLX7  DATA 39H
CLX8  DATA 3AH
SLEC  DATA 3BH
;BIEN NHO
TEM1  DATA 22H
_DPH  DATA 23H
_DPL  DATA 24H
TEM5  DATA 25H
TEM6  DATA 26H
MTX1  DATA 27H
MTX2  DATA 28H
TM1   DATA 40H
TM2   DATA 41H
TM3   DATA 42H
TM4   DATA 43H
TM5   DATA 44H
S_DPL   DATA 45H
S_DPH   DATA 46H
STEP    DATA 47H
BY_DOT  DATA 48H
;CAC CO NHO
TEM   DATA 20H
FLAG  BIT TEM.0
TIME  DATA 21H
W10M  BIT  TIME.0
T50M  BIT  TIME.1
T100M BIT  TIME.2
T10M  BIT  TIME.3
T150M BIT  TEM.1
T250M BIT  TEM.2
T1S   BIT  TEM.3

VAR1  BIT  TIME.4   ;DAO ANH ( 1: DAO  0: KO DAO)
VAR2  BIT  TIME.5   ;DAO CHIEU (1: NGHICH  0: THUAN)
VAR3  BIT  TIME.6	;ENBLE/DISABLE  NAP DU LIEU TU DONG (1: E  0: D)
VAR4  BIT  TIME.7	;UP/DOWN (1:UP  0: DOWN)
VAR5  BIT  TEM.4
VAR6  BIT  TEM.5
VAR7  BIT  TEM.6
B_DOT  BIT  TEM.7
ORG 0
JMP MAIN
ORG 000BH
JMP INT_PWM
ORG 001BH
JMP INT_TIMER1
MAIN:
;===========KHOI TAO====================
	MOV TMOD,#12H
	MOV SCON,#00H
	MOV IE,#8AH		;NGAT DO TIMER0+TIMER1
	MOV DPTR,#HPNY
	MOV _DPH,DPH
	MOV _DPL,DPL
	MOV XLOW,#1
	CALL DUTY
	SETB TR0
	SETB TF0
	SETB TR1
	SETB TF1
	MOV P1,#0		;CLEAR
	CLR E1
	SETB STCP
	CALL REST
	MOV TM1,#0
	MOV TM2,#0
	MOV TM3,#0
	MOV TM4,#0
	MOV TM5,#0
	CLR VAR1
	CLR VAR2
	SETB VAR3
	SETB VAR4
;======BAT DAU CHUONG TRINH CHINH=======
	
BEGIN:
		CLR VAR1
		SETB VAR2
		CLR VAR3
		MOV DPTR,#TIM
		CALL W_DATA
		CALL COPY
		MOV DPTR,#SANG
		CALL W_DATA
		MOV SLEC,#1    ;1
		CALL LOAD_CL
		CALL X_DOT
		CLR T1S
RE_PEAT1:
		CALL DISPLAY
		JNB T1S,RE_PEAT1
		MOV DPTR,#CUOI
		CALL W_DATA
		CALL COPY
		MOV DPTR,#SANG
		CALL W_DATA
		MOV SLEC,#6     ;6
		CALL LOAD_CL
		CALL X_DOT
		CLR T1S
RE_PEAT2:
		CALL DISPLAY
		JNB T1S,RE_PEAT2
		MOV R6,#3
RE_PEAT3:
		CALL DISPLAY
		JNB T250M,RE_PEAT3
		CLR T250M
		CALL LEFT
		DJNZ R6,RE_PEAT3
		MOV R6,#18
RE_PEAT4:
		CALL DISPLAY
		JNB T100M,RE_PEAT4
		CLR T100M
		CALL RIGHT
		DJNZ R6,RE_PEAT4
		MOV DPTR,#HPNY
		SETB VAR3
		CLR VAR2
		MOV SLEC,#2
		CALL LOAD_CL
		MOV R6,#160
RE_PEAT5:
		CALL DISPLAY
		JNB T100M,RE_PEAT5
		MOV STEP,#1
		CALL INC_DPTR
		CLR T100M
		DJNZ R6,RE_PEAT5
		MOV DPTR,#VDK
		MOV SLEC,#3
		CALL LOAD_CL
		MOV R6,#171
RE_PEAT6:
		CALL DISPLAY
		JNB T100M,RE_PEAT6
		MOV STEP,#1
		CALL INC_DPTR
		CLR T100M
		DJNZ R6,RE_PEAT6
		MOV DPTR,#CHIP
		MOV SLEC,#0
		CALL LOAD_CL
		MOV R6,#8
RE_PEAT7:
		CALL DISPLAY
		JNB T1S,RE_PEAT7
		CLR T1S
		INC SLEC
		CALL LOAD_CL
		DJNZ R6,RE_PEAT7
		SETB VAR4
		CLR VAR3
		MOV R6,#10
RE_PEAT8:
		CALL DISPLAY
		JNB T250M,RE_PEAT8
		CLR T250M
		CALL UP_DOWN_C
		DJNZ R6,RE_PEAT8
		JMP BEGIN
;===========KIEU CHAY 1==============
STYLE1:
		JNB T100M,EX_STYLE1
		INC DPTR
		INC TEM5
		MOV A,TEM5
		CJNE A,#232,CONAA
		CPL VAR2
		MOV DPH,_DPH
		MOV DPL,_DPL
		MOV TEM5,#0
		INC SLEC
		MOV A,SLEC
		CJNE A,#8,CONXXX
		MOV SLEC,#0
		CPL VAR1
	CONXXX: 
		CALL LOAD_CL
	CONAA:
		CLR T100M
EX_STYLE1:
		RET
;==========================================================
;==========================================================
;=============CA HIEU UNG==================================
;==============DICH LEN DICH XUONG + C=====================
;CHU DICH LEN HOAC XUONG +VAR4
;SETB VAR4 (CLR VAR4)
;CALL UP_DOWN_C
UP_DOWN_C:
		PUSH 01H
		PUSH 00H
		MOV R0,#FIRST
		MOV R1,#16       ;]]]]]]]]]]]]]]]]
RE_STEP_UP:
		MOV A,@R0
		SETB C
		JNB VAR4,SLE_UP
		RRC A
		JMP CONT_UP_DOWN
SLE_UP:
		RLC A
CONT_UP_DOWN:
		MOV @R0,A
		INC R0
		DJNZ R1,RE_STEP_UP
		POP 00H
		POP 01H
		RET
;===========DICH SANG TRAI - DICH SANG PHAI=============
LEFT:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST
		MOV R1,#FIRST+1
		MOV R2,#16          ;]]]]]]]]]]]]]]]]]]]]]]
LOOP_LEFT:
		MOV A,@R1
		MOV @R0,A
		INC R0
		INC R1
		DJNZ R2,LOOP_LEFT
		MOV R0,#FIRST+15
		MOV @R0,#255
		POP 00H
		POP 01H
		POP 02H
		RET
RIGHT:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST+15
		MOV R1,#FIRST+14
		MOV R2,#16       ;]]]]]]]]]]]]]]]]]]]]]]]
LOOP_RIGHT:
		MOV A,@R1
		MOV @R0,A
		DEC R0
		DEC R1
		DJNZ R2,LOOP_RIGHT
		MOV R0,#FIRST
		MOV @R0,#255
		POP 02H
		POP 01H
		POP 00H
		RET
;===================TAT DAN TUNG BIT======================
;CALL X_DOT
X_DOT:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		PUSH 03H
		PUSH 04H
		MOV BY_DOT,#00000001B
		MOV R4,#8
LOOP_XX_DOT:	
		JNB B_DOT,CONT_X_DOT0
		MOV R0,#FIRST
		JMP CONT_X_DOT1
CONT_X_DOT0:
		MOV R0,#FIRST+15
CONT_X_DOT1:
		MOV R2,#16               ;]]]]]]]]]]]]]]]]]]]]]]]]]
LOOP_X_DOT:
		CALL DISPLAY
		JNB T50M,LOOP_X_DOT
		MOV A,@R0
		MOV R3,BY_DOT
		ORL A,R3
		MOV R3,A
		PUSH 00H
		MOV A,R0
		ADD A,#16
		MOV R0,A
		MOV A,@R0
		ANL A,R3
		POP 00H
		MOV @R0,A
		MOV @R0,A
		CLR T50M
		JNB B_DOT,CONT_X_DOT2
		INC R0
		JMP CONT_X_DOT3
CONT_X_DOT2:
		DEC R0
CONT_X_DOT3:
		CALL DISPLAY
		DJNZ R2,LOOP_X_DOT
		CPL B_DOT
		MOV A,BY_DOT
		CLR C
		RLC A
		MOV BY_DOT,A
		DJNZ R4,LOOP_XX_DOT
		POP 04H
		POP 03H
		POP 02H
		POP 01H
		POP 00H
		RET
		
;========TANG GIAM CON TRO (DICH TRAI - DICH PHAI)==========
;BUOC TANG/BUOC GIAM NHAP VAO [STEP] VA GOI [DEC_DPTR] HAY [INC DPTR]		
DEC_DPTR:
		CLR C
		MOV A,DPL
		SUBB A,STEP
		MOV DPL,A
		MOV A,DPH
		SUBB A,#0
		MOV DPH,A
		RET
INC_DPTR:
		MOV A,DPL
		ADD A,STEP
		MOV DPL,A
		MOV A,DPH
		ADDC A,#0
		MOV DPH,A
		RET
;======================AN HIEN===========================
SHOW:
		MOV R0,#FIRST
		MOV @R0,#0
LOOP_SH:
		CALL DISPLAY
		JNB T100M,LOOP_SH
		

;==========================================================
;==========================================================
;==========================================================
;=====================RESET================================
REST:
	MOV SLEC,#0
	CALL LOAD_CL
	MOV COUNT,#0
	MOV R0,#0   ;FREE
	MOV R1,#0   ;FREE
	MOV R2,#0   ;FREE
	MOV R3,#0   ;FREE
	MOV R4,#0   ;FREE
	MOV R5,#0   ;FREE
	MOV R6,#0   ;FREE
	MOV R7,#0
	MOV TEM1,#1
	MOV TEM5,#0
	RET
;===========VUNG DEM THU II================
COPY:
	MOV R0,#FIRST
	MOV R1,#FIRST+16
	MOV R2,#16
REP_COPY:
	MOV A,@R0
	MOV @R1,A
	INC R0
	INC R1
	DJNZ R2,REP_COPY
	RET
		
;==========XUAT HIEN THI==================
;HIEN THI NOI DUNG BO NHO DEM (50H - 60H) DEM RA LED	
DISPLAY:
		JNB VAR2,INV_DIM1
		MOV A,MTX1    ;
		JMP CONT_INV_DIM1
INV_DIM1:
		MOV A,MTX1
CONT_INV_DIM1:

		JNB VAR1,INV1
		CPL A
	INV1:
		CALL SEND
		JNB VAR2,INV_DIM2
		MOV A,MTX2  ;
		JMP CON_INV_DIM2
INV_DIM2:
		MOV A,MTX2
CON_INV_DIM2:
		JNB VAR1,INV2
		CPL A
	INV2:
		CALL SEND
		SETB STCP
		CLR STCP
		CALL SWEP
		SETB E1
		CALL DELAY
		CLR E1
		RET
;==========DEM DU LIEU==============
;DEM DU LIEU CHO HANG KE TIEP
BUF_ROW:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		PUSH 03H
		MOV R0,#27H
		MOV R1,#(50H+15);]]]]]]]]]]]]]]]]]]]]]]]]]]]]
		MOV R3,#2
RE_BUF_ROW1:
		MOV R2,#8
RE_BUF_ROW2:
		MOV B,TEM1
		MOV A,@R1
		DIV AB
		MOV C,ACC.0
		MOV A,@R0
		JNB VAR2,INV_DIM3
		RLC A
		JMP CONT_INV_DIM3
INV_DIM3:
		RRC A
CONT_INV_DIM3:
		MOV @R0,A
		DEC R1
		DJNZ R2,RE_BUF_ROW2
		INC R0
		DJNZ R3,RE_BUF_ROW1
		MOV B,#2
		MOV A,TEM1
		MUL AB
		INC R7
		MOV TEM1,A
		CJNE R7,#8,EX_BUF_ROW
		MOV TEM1,#1
		MOV R7,#0
EX_BUF_ROW:
		POP 03H
		POP 02H
		POP 01H
		POP 00H
		RET	
;=========GHI DU LIEU VAO RAM================
;GHI DU LIEU VAO RAM TU 50H - 60H TU CON TRO DU LIEU
W_DATA:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R2,#16   ;]]]]]]]]]]]]]]]]]]]]]]]]]
		MOV R1,#FIRST
		MOV R0,#0
RE_W_DATA:
		MOV A,R0
		MOVC A,@A+DPTR
		MOV @R1,A
		INC R1
		INC R0
		DJNZ R2,RE_W_DATA
		POP 02H
		POP 01H
		POP 00H
		RET
;===========DIEU CHINH DO RONG XUNG==========
DUTY:
		PUSH ACC
		MOV A,XLOW
		CPL A
		ADD A,#1
		MOV XHIG,A
		POP ACC
		RET
;=========CHON HANG QUET + MA MAU============
SWEP:
		PUSH ACC
		CALL COLOR
		MOV A,P1
		ANL A,#11111000B
		ORL A,COUNT
		MOV P1,A
		INC COUNT
		MOV A,COUNT
		CJNE A,#8,EX_SWEP
		MOV COUNT,#0
		MOV R7,#0
EX_SWEP:
		POP ACC
		RET
;============MA MAU===================
;MOI HANG TUONG UNG VOI MOT MAU - [CLX1 TO CLX8]
COLOR:
		MOV A,COUNT
		CJNE A,#0,CL1
		MOV XLOW,CLX1
		JMP EXT_CL
CL1:
		CJNE A,#1,CL2
		MOV XLOW,CLX2
		JMP EXT_CL
CL2:
		CJNE A,#2,CL3
		MOV XLOW,CLX3
		JMP EXT_CL
CL3:
		CJNE A,#3,CL4
		MOV XLOW,CLX4
		JMP EXT_CL
CL4:
		CJNE A,#4,CL5
		MOV XLOW,CLX5
		JMP EXT_CL
CL5:
		CJNE A,#5,CL6
		MOV XLOW,CLX6
		JMP EXT_CL	
CL6:
		CJNE A,#6,CL7
		MOV XLOW,CLX7
		JMP EXT_CL
CL7:
		MOV XLOW,CLX8
EXT_CL:
		CALL DUTY
		RET
;=======CHON MAU SLEC(0 - 4)============
LOAD_CL:
		PUSH 01H
		PUSH 00H
		PUSH DPL
		PUSH DPH
		MOV A,SLEC
		CJNE A,#0,S_ST1
		MOV DPTR,#GRADI
		JMP EX_LOAD_CL
S_ST1:
		CJNE A,#1,S_ST2
		MOV DPTR,#ST1
		JMP EX_LOAD_CL
S_ST2:
		CJNE A,#2,S_ST3
		MOV DPTR,#ST2
		JMP EX_LOAD_CL
S_ST3:
		CJNE A,#3,S_ST4
		MOV DPTR,#ST3
		JMP EX_LOAD_CL
S_ST4:
		CJNE A,#4,S_ST5
		MOV DPTR,#ST4
		JMP EX_LOAD_CL
S_ST5:
		CJNE A,#5,S_ST6
		MOV DPTR,#ST5
		JMP EX_LOAD_CL
S_ST6:
		CJNE A,#6,S_ST7
		MOV DPTR,#ST6
		JMP EX_LOAD_CL
S_ST7:
		MOV DPTR,#ST7
EX_LOAD_CL:
		MOV R0,#33H
		MOV R1,#8
RE_LOAD_CL:	
		MOV A,#0
		MOVC A,@A+DPTR
		MOV @R0,A
		INC R0
		INC DPTR
		DJNZ R1,RE_LOAD_CL
		POP DPH
		POP	DPL
		POP 00H
		POP 01H
		RET
;=========GUI DU LIEU RA PORT============
SEND:
		MOV SBUF,A
		JNB TI,$
		CLR TI
		RET
;==========CT DELAY 1MS==================
DELAY:
		SETB TR0
		CALL TIMING
		CALL BUF_ROW
		JNB VAR3,CONT_ENABLE
		CALL W_DATA
CONT_ENABLE:
		PUSH 01H
		PUSH 02H
		MOV R1,#20
	RE_DELAY:
		MOV R2,#100
		DJNZ R2,$
		DJNZ R1,RE_DELAY
		POP 02H
		POP 01H
		CLR TR0
		SETB OE1
		SETB OE2
		RET
;========DIEU KHIEN DINH THOI============
TIMING:
		JNB W10M,EX_TIMING
		INC TM1
		MOV A,TM1
		CJNE A,#5,EX_TIMING    ;50MS
		MOV TM1,#0
		CPL T50M
		INC TM3
		MOV A,TM3
		CJNE A,#2,CONT_TM2    ;100MS
		MOV TM3,#0
		CPL T100M
CONT_TM2:
		INC TM5
		MOV A,TM5
		CJNE A,#3,CONT_TM222   ;150MS
		MOV TM5,#0
		CPL T150M
CONT_TM222:
		INC TM4
		MOV A,TM4
		CJNE A,#4,CONT_TM22  ;250MS
		MOV TM4,#0
		CPL T250M
CONT_TM22:
		INC TM2
		MOV A,TM2
		CJNE A,#20,EX_TIMING  ;T1S
		MOV TM2,#0
		CPL T1S
EX_TIMING:
		CLR W10M
		RET
		
;=========PHAT PWM 3.7KHZ===========
INT_PWM:
		CLR OE1
		SETB OE2
		JNB FLAG,HAFT
		MOV TL0,XLOW
		CLR FLAG
		RETI
HAFT:
		CLR OE2
		SETB OE1
		MOV TL0,XHIG
		SETB FLAG
		RETI
;==========DINH THOI=================
INT_TIMER1:
		MOV TL1,#LOW(-10000)
		MOV TH1,#HIGH(-10000)
		SETB TR1
		SETB W10M
		CPL T10M
		RETI
;=========MA MAU======================
GRADI:
	DB  1,33,65,97,133,166,199,254
ST1:
	DB  254,199,166,133,97,65,33,1
ST2:
	DB  1,1,65,65,133,133,255,255
ST3:
	DB  255,199,133,133,97,97,1,1
ST4:
	DB  1,65,97,254,254,97,65,1
ST5:
	DB  1,1,1,1,1,1,1,1
ST6:
	DB  254,254,254,254,254,254,254,254
ST7:
    DB  127,127,127,127,127,127,127,127
;===============MA CHU================
	
TIM:;16

DB     0C1H,0BFH,0BFH,0C1H,0FFH,0F3H                      ;I LOVE U
db      0E1H,0C1H,83H,0DBH,0E9H,0F3H,0FFH,0BDH,81H,0BDH   ;



HPNY:   ;168
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 081h, 081h, 0E7h, 0E7h, 081h, 081h, 0FFh    ;Ma Ma Tran     ;H
db 0FFh, 083h, 081h, 0E5h, 0E5h, 081h, 083h, 0FFh    ;Ma Ma Tran     ;A
db 0FFh, 081h, 081h, 0EDh, 0E1h, 0F3h, 0FFh, 0FFh    ;Ma Ma Tran     ;P
db 0FFh, 081h, 081h, 0EDh, 0E1h, 0F3h, 0FFh, 0FFh    ;Ma Ma Tran     ;P
db 0FFh, 0F1h, 0B1h, 0AFh, 0AFh, 081h, 0C1h, 0FFh    ;Ma Ma Tran     ;Y
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 081h, 081h, 0F3h, 0CFh, 081h, 081h, 0FFh    ;Ma Ma Tran      ;N
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 0C1h, 0BFh, 08Fh, 08Fh, 0BFh, 0C1h, 0FFh    ;Ma Ma Tran      ;W
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran  

db 0FFh, 083h, 081h, 0E5h, 0E5h, 081h, 083h, 0FFh    ;Ma Ma Tran      ;A
db 0FFh, 081h, 081h, 0EDh, 0CDh, 0B3h, 0BFh, 0FFh    ;Ma Ma Tran      ;R
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0BBh, 09Dh, 08Dh, 0A1h, 0B3h, 0FFh, 0FFh    ;Ma Ma Tran      ;2
db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran      ;0
db 0FFh, 0FFh, 0F7h, 0BBh, 081h, 081h, 0BFh, 0FFh    ;Ma Ma Tran      ;1
db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran      ;0
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
CUOI:;16
DB     0FFH,0FFH,0FFH,0C3H,0BDH,6AH,5EH,5EH
DB    6AH,0BDH,0C3H,0FFH,0FFH,0FFH,0FFH,0FFH  

CHIP:;16
DB     0FFH,0FFH,93H,1H,83H,1H,83H
DB     1H,83H,1H,83H,1H,83H,0FFH,0FFH,0FFH  

VDK:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0E1h, 0CFh, 09Fh, 09Fh, 0CFh, 0E1h, 0FFh    ;Ma Ma Tran   ,V
db 0FFh, 0E7h, 081h, 0A5h, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran   ;DD
db 0FFh, 081h, 081h, 0E3h, 0C9h, 09Dh, 0BFh, 0FFh    ;Ma Ma Tran  ;K
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 093h, 06Dh, 06Dh, 06Dh, 093h, 0FFh, 0FFh    ;Ma Ma Tran   ;8
db 0FFh, 083h, 079h, 075h, 06Dh, 05Dh, 083h, 0FFh    ;Ma Ma Tran   ;0
db 0FFh, 0B1h, 075h, 075h, 075h, 05h, 08Fh, 0FFh    ;Ma Ma Tran    5
db 0FFh, 0F7h, 03Bh, 01h, 01h, 03Fh, 0FFh, 0FFh    ;Ma Ma Tran     ;1
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
WELCOME:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0C1h, 0BFh, 08Fh, 08Fh, 0BFh, 0C1h, 0FFh    ;Ma Ma Tran      ;W
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 0FFh, 081h, 081h, 09Fh, 09Fh, 0FFh, 0FFh    ;Ma Ma Tran      ;L
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 0BDh, 0DBh, 0FFh    ;Ma Ma Tran      ;C
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran       ;O
db 0FFh, 081h, 081h, 0F3h, 0F3h, 081h, 081h, 0FFh    ;Ma Ma Tran      ;M
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

GOOD_BYE:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0C3h, 081h, 0BDh, 0ADh, 0CDh, 08Bh, 0FFh    ;Ma Ma Tran       ;G
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran       ;O
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran       ;O
db 0FFh, 0FFh, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran   '    ;D
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 081h, 085h, 095h, 095h, 0CBh, 0FFh, 0FFh    ;Ma Ma Tran       ;B
db 0FFh, 0F1h, 0B1h, 0AFh, 0AFh, 081h, 0C1h, 0FFh    ;Ma Ma Tran      ;Y
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 0FFh, 07Fh, 04Fh, 0C3h, 0F0h, 0FCh, 0FFh    ;Ma Ma Tran       ;!
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran






DULIEU:
db 0FFh, 0FFh, 0BDh, 081h, 081h, 0BDh, 0FFh, 0FFh    ;Ma Ma Tran  ;I
ILY:
db 0FFh, 0F3h, 0EDh, 0DDh, 0BBh, 0DDh, 0EDh, 0F3h    ;Ma Ma Tran  ;TIM
db 0FFh, 0F3h, 0E1h, 0C1h, 083h, 0C1h, 0E1h, 0F3h    ;Ma Ma Tran  ;TIM2	
db 0FFh, 0C1h, 081h, 09Fh, 09Fh, 081h, 0C1h, 0FFh    ;Ma Ma Tran  ;U
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran  ;0 NHO
db 0FFh, 0FFh, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran   'D
db 0C3h, 0BDh, 042h, 05Ah, 05Ah, 042h, 0BDh, 0C3h    ;Ma Ma Tran; TIEN
AROW: 
db 0FFh, 0FFh, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h    ;Ma Ma Tran;DUOI MUI TEN
db 0C3h, 0C3h, 0C3h, 0C3h, 00h, 081h, 0C3h, 0E7h    ;Ma Ma Tran ;MUI TEN  (PHAI)
TAT:
SIN:


SANG:
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran


db 00h, 080h, 0C0h, 0E0h, 0F0h, 0F8h, 0FCh, 0FEh    ;Ma Ma Tran ,NUA TRAI
db 07Fh, 03Fh, 01Fh, 0Fh, 07h, 03h, 01h, 00h    ;Ma Ma Tran;  NUA PHAI

	END
	
