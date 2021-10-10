;KHAI BAO
STCP BIT P1.7
OE2  BIT P1.5
OE1  BIT P1.4
AA   BIT P1.0
BB   BIT P1.1
CC   BIT P1.2
E1   BIT P1.3
FIRST EQU  50H
COUNT DATA 30H
XLOW  DATA 31H
XHIG  DATA 32H
;MA MAU
F_CL  EQU 33H
CLX1  DATA 33H
CLX2  DATA 34H
CLX3  DATA 35H
CLX4  DATA 36H
CLX5  DATA 37H
CLX6  DATA 38H
CLX7  DATA 39H
CLX8  DATA 3AH
SYNC  DATA 3BH
;BIEN NHO
_DPH  DATA 23H
_DPL  DATA 24H
TEM5  DATA 25H
TEM6  DATA 26H
MTX1  DATA 27H
MTX2  DATA 28H
S_DPL   DATA 45H
S_DPH   DATA 46H
STEP    DATA 47H
BY_DOT  DATA 48H
HOW     DATA 49H
;CAC CO NHO
TEM1  DATA 22H
TEM   DATA 20H
FLAG  BIT TEM.0
TIME  DATA 21H
W10M  BIT  TIME.0

VAR1  BIT  TIME.4   ;FREE
VAR2  BIT  TIME.5	;FREE
VAR3  BIT  TIME.6	;FREE
VAR4  BIT  TIME.7	;FREE
VAR5  BIT  TEM.4	;FREE
VAR6  BIT  TEM.5	;FREE
VAR7  BIT  TEM.6	;FREE
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
	MOV XLOW,#1
	CALL DUTY
	SETB TR0
	SETB TF0
	SETB TR1
	SETB TF1
	MOV P1,#0		;CLEAR
	CLR E1
	SETB STCP
	MOV COUNT,#0
	MOV TEM1,#1
;======BAT DAU CHUONG TRINH CHINH=======
	
BEGIN:
		MOV DPTR,#COLOR3
		CALL LOAD_CL
		MOV DPTR,#PIC1
		CALL W_DATA
		MOV R2,#8
LOOP_B1:
		CALL DISPLAY
		DJNZ R2,LOOP_B1
		MOV DPTR,#COLOR4
		CALL LOAD_CL
		MOV DPTR,#PIC2
		CALL W_DATA
		MOV R2,#8
LOOP_B2:
		CALL DISPLAY
		DJNZ R2,LOOP_B2
		JMP BEGIN
;==========XUAT HIEN THI==================
;HIEN THI NOI DUNG BO NHO DEM (50H - 60H) DEM RA LED	
DISPLAY:
		MOV A,MTX2 
		CALL SEND
		MOV A,MTX1
		CALL SEND
		SETB STCP
		CLR STCP
		CALL SWEP
		SETB E1
		CALL DELAY
		CLR E1
		RET
;======================DEM DU LIEU========================
;======================DELAY+DISPLAY======================
DISP10M:
		PUSH 1
		MOV R1,HOW
RE_DISP10M:
		CALL DISPLAY
		JNB W10M,RE_DISP10M
		CLR W10M
		DJNZ R1,RE_DISP10M
		POP 1
		RET
;====================NAP COT=============================
COLUME:
		MOV R0,#FIRST
BLANK:
		MOV @R0,#255
		INC R0
		CJNE R0,#FIRST+16,BLANK
		MOV A,#16
		ADD A,TEM5
		MOV R0,TEM5
		MOV R1,A
		MOV A,@R1
		MOV @R0,A
		INC TEM5
		CJNE R0,#FIRST+15,EX_COLUME
		MOV TEM5,#FIRST
EX_CLUME:
		RET
		
;==========================================================
;=============CA HIEU UNG==================================
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
		MOV HOW,#5
		CALL DISP10M
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
		JNB B_DOT,CONT_X_DOT2
		INC R0
		JMP CONT_X_DOT3
CONT_X_DOT2:
		DEC R0
CONT_X_DOT3:
		CALL DISPLAY   ;@@@@@@@@@@@@@@
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
;=============HIEN TU TU TREN XUONG======================
TOP_DOWN:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		PUSH 03H
		MOV R3,#8
LOOP_TOP:
		MOV R0,#FIRST
		MOV R1,#FIRST+16
		MOV R2,#16
LOOP_TOP_DOWN:
		MOV A,@R1
		SETB C
		RLC A
		MOV @R1,A
		MOV A,@R0
		RLC A
		MOV @R0,A
		INC R0
		INC R1
		DJNZ R2,LOOP_TOP_DOWN
		MOV HOW,#10
		CALL DISP10M
		DJNZ R3,LOOP_TOP
		POP 00H
		POP 01H
		POP 02H
		POP 03H
		RET
;=================XOA HIEN TU PHAI SANG===========
SHOW_L:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST
		MOV R1,#FIRST+16
		MOV @R0,#0
		MOV R2,#16
LOOP_SH:
		MOV HOW,#25
		CALL DISP10M
		MOV A,@R1
		MOV @R0,A
		INC R1
		INC R0
		DJNZ R2,LOOP_SH
		POP 00H
		POP 01H
		POP 02H
		RET
;============= XOA _HIENTU TRAI SANG PHAI=============
SHOW_R:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST+15
		MOV R1,#FIRST+15+16
		MOV @R0,#0
		MOV R2,#16
LOOP_SH2:
		MOV HOW,#25
		CALL DISP10M
		MOV A,@R1
		MOV @R0,A
		DEC R0
		DEC R1
		DJNZ R2,LOOP_SH2
		POP 00H
		POP 01H
		POP 02H
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
		

;================DEM DU LIEU CHO HANG KE TIEP=============
BUF_ROW:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		PUSH 03H
		MOV R0,#27H
		MOV R1,#(50H+15)        ;]]]]]]]]]]]]]]]]]]]]]]]]]]]]
		MOV R3,#2
RE_BUF_ROW1:
		MOV R2,#8
RE_BUF_ROW2:
		MOV B,TEM1
		MOV A,@R1
		DIV AB
		MOV C,ACC.0
		MOV A,@R0
		RRC A
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
		MOV A,R7
		JZ EX_W_DATA
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
EX_W_DATA:
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
		PUSH 00H
		PUSH ACC
		MOV A,COUNT
		JNZ CONT_SWEP
		MOV SYNC,#F_CL
CONT_SWEP:
		MOV R0,SYNC
		MOV XLOW,@R0
		CALL DUTY
		INC SYNC
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
		POP 00H
		RET
;===================NAP MA MAU============
LOAD_CL:
	  PUSH 01H
	  PUSH 00H
	  PUSH DPL
	  PUSH DPH
      MOV R0,#F_CL
      MOV R1,#8
RE_LOAD_CL:
      MOV A,#0
      MOVC A,@A+DPTR
      JNZ CHECK
      INC A
      JMP TIEP_LOAD
CHECK:
      CJNE A,#255,TIEP_LOAD
      DEC A
TIEP_LOAD:
      MOV @R0,A
      INC DPTR
      INC R0
      DJNZ R1,RE_LOAD_CL
      POP DPH
      POP DPL
      POP 00H
      POP 01H
      RET
;=======================================
SEND:
		MOV SBUF,A
		JNB TI,$
		CLR TI
		RET
;==========CT DELAY 1MS==================
DELAY:
		CALL BUF_ROW
		PUSH 01H
		PUSH 02H
		MOV R1,#10
	RE_DELAY:
		MOV R2,#100
		DJNZ R2,$
		DJNZ R1,RE_DELAY
		POP 02H
		POP 01H
		RET
;=========PHAT PWM 3.7KHZ===========
INT_PWM:
		CLR OE1
		SETB OE2
		JNB FLAG,HAFT
		MOV TH0,XLOW
		CLR FLAG
		RETI
HAFT:
		CLR OE2
		SETB OE1
		MOV TH0,XHIG
		SETB FLAG
		RETI
;==========DINH THOI=================
INT_TIMER1:
		MOV TL1,#LOW(-10000)
		MOV TH1,#HIGH(-10000)
		SETB TR1
		CPL W10M
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

DB     0FFH,0FFH,0FFH,0FFH,0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH,0FFH,0FFH,0FFH,0FFH  

DB     0C1H,0BFH,0BFH,0C1H,0FFH,0F3H                      ;I LOVE U
db      0E1H,0C1H,83H,0DBH,0E9H,0F3H,0FFH,0BDH,81H,0BDH   ;


COLOR:
	DB	1,33,66,100,132,165,200,255
COLOR2:
	DB 255,200,165,132,100,66,33,1
COLOR3:
	DB 0,0,0,0,0,0,0,0,0,0
COLOR4:
	DB 255,255,255,255,255,255,255,255
COLOR5:
	DB 33,66,100,132,165,200,255,1
COLOR6:
	DB 66,100,132,165,200,255,1,33
COLOR7:
	DB 100,132,165,200,255,1,33,66
COLOR8:
	DB 132,165,200,255,1,33,66,100
COLOR9:
	DB 165,200,255,1,33,66,100,132
COLOR10:
	DB 200,255,1,33,66,100,132,165
COLOR11:
	DB 255,1,33,66,100,132,165,200
COLOR12:
	DB 1,33,66,100,132,165,200,255
PIC2:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 081h, 081h, 0E3h, 0C9h, 09Dh, 0BFh, 0FFh    ;Ma Ma Tran  ;K

PIC1:
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran       ;O
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran	
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
ROUND:

DB     0FFH,0FFH,0FFH,0FFH,0FEH,0FDH,0FBH,0F7H,0EFH,0DFH,0BFH,7FH,0FFH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,0FFH,7FH,0BFH,0DFH,0EFH,0F7H,0FBH,0FDH,0FEH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0H,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,0FEH,0FDH,0FBH,0F7H,0H,0DFH,0BFH,7FH,0FFH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0EFH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,6FH,0AFH,0CFH,0EFH,0E7H,0EBH,0EDH,0EEH,0EFH,0FFH,0FFH,0FFH  
DB     0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0H,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH  

TAT:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
SANG:
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran


db 00h, 080h, 0C0h, 0E0h, 0F0h, 0F8h, 0FCh, 0FEh    ;Ma Ma Tran ,NUA TRAI
db 07Fh, 03Fh, 01Fh, 0Fh, 07h, 03h, 01h, 00h    ;Ma Ma Tran;  NUA PHAI

	END
	
