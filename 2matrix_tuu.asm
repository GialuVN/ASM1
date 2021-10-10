;KHAI BAO
STCP BIT P1.7
OE2  BIT P1.5
OE1  BIT P1.4
AA   BIT P1.0
BB   BIT P1.1
CC   BIT P1.2
E1   BIT P1.3
SECON EQU 50H+16
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
SYNC  DATA 4BH
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
TEM1   DATA 22H
TEM   DATA 20H
FLAG  BIT TEM.0
TIME  DATA 21H
W10M  BIT  TIME.0

VAR1  BIT  TIME.4   ;FREE
VAR2  BIT  TIME.5	;FREE
VAR3  BIT  TIME.6	;FREE
VAR4  BIT  TIME.7	;FREE
INV   BIT  TEM.4	; DAO ANH    INV=1 DAO, INV=0 KO DAO
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
	setb ip.1
	MOV XLOW,#1
	CALL DUTY
	SETB TR0
	SETB TF0
	SETB TR1
	SETB TF1
	MOV P1,#0		;CLEAR
	CLR E1
	SETB STCP
	MOV R7,#1
	MOV COUNT,#0
	MOV TEM1,#1
	MOV TEM5,#FIRST
	clr inv
;======BAT DAU CHUONG TRINH CHINH=======
	
BEGIN:
		MOV DPTR,#G2
		CALL LOAD_CL
		MOV DPTR,#SANG
		MOV A,#FIRST
		CALL W_DATA
		MOV DPTR,#CDT
		MOV A,#SECON
		CALL W_DATA
		CALL X_DOT
		CALL INV_CL
		MOV HOW,#255
		CALL DISP10M
		MOV DPTR,#S_08
		MOV A,#SECON
		CALL W_DATA
		CALL SHOW_L
		MOV HOW,#200
		CALL DISP10M
		MOV DPTR,#C4
		CALL LOAD_CL
		MOV R0,#2
L_LEFT:		
		MOV HOW,#10
		CALL DISP10M
		CALL LEFT
		DJNZ R0,L_LEFT
		MOV DPTR,#C2
		CALL LOAD_CL
		MOV R0,#4
R_RIGHT:
		MOV HOW,#10
		CALL DISP10M
		CALL RIGHT
		DJNZ R0,R_RIGHT
		MOV DPTR,#C6
		CALL LOAD_CL
		MOV R0,#11
L2_LEFT:
		MOV HOW,#20
		CALL DISP10M
		CALL LEFT
		DJNZ R0,L2_LEFT
		MOV DPTR,#C10
		CALL LOAD_CL
		MOV R0,#18
R2_RIGHT:
		MOV HOW,#7
		CALL DISP10M
		CALL RIGHT
		DJNZ R0,R2_RIGHT
		MOV DPTR,#G1
		CALL LOAD_CL
		MOV DPTR,#WELCOME
		MOV R0,#74
L_WC:		
		MOV A,#FIRST
		CALL W_DATA
		MOV HOW,#10
		CALL DISP10M
		MOV STEP,#1
		CALL INC_DPTR
		DJNZ R0,L_WC
		MOV DPTR,#C13
		CALL LOAD_CL
		MOV DPTR,#VDK
		MOV R0,#49
D_VDK:		
		MOV A,#FIRST
		CALL W_DATA
		MOV HOW,#12
		CALL DISP10M
		MOV STEP,#1
		CALL INC_DPTR
		DJNZ R0,D_VDK
		MOV DPTR,#G2
		CALL LOAD_CL
		MOV HOW,#255
		CALL DISP10M
		MOV DPTR,#NAM
		MOV A,#SECON
		CALL W_DATA
		CALL TOP_DOWN
		MOV DPTR,#G1
		CALL LOAD_CL
		MOV HOW,#255
		CALL DISP10M
		MOV HOW,#255
		CALL DISP10M
		MOV DPTR,#G1
		CALL LOAD_CL
		MOV R0,#16
DOWNZ:	
		MOV HOW,#15
		CALL DISP10M
		CALL LEFT
		CALL SHCL_DOWN
		CALL SH_DOWN
		DJNZ R0,DOWNZ
		MOV HOW,#255
		CALL DISP10M
		MOV DPTR,#G2
		CALL LOAD_CL
		MOV DPTR,#GOOD_BYE
		MOV A,#FIRST
		CALL W_DATA
		MOV R0,#88
GOOD:
		MOV HOW,#10
		CALL DISP10M
		INC DPTR
		MOV A,#FIRST
		CALL W_DATA
		CALL SHCL_UP
		CPL VAR6
		JNB VAR6,CONTVA
		CALL SH_UP
CONTVA:
		DJNZ R0,GOOD
		MOV HOW,#255
		CALL DISP10M
		
		JMP BEGIN		
;==========XUAT HIEN THI==================
;HIEN THI NOI DUNG BO NHO DEM (50H - 60H) DEM RA LED	
DISPLAY:
		MOV A,MTX2 
		CALL SEND
		MOV A,MTX1
		CALL SEND
		CLR E1
		CALL SWEP
		SETB STCP
		CLR STCP
		SETB E1
		CALL DELAY
		RET
;================PUSH + POP DPTR================================
PUSH_DP:
		MOV _DPH,DPH
		MOV _DPL,DPL
		RET
POP_DP:
		MOV DPH,_DPH
		MOV DPL,_DPL
		RET
;======================DEM DU LIEU========================
;======================DELAY+DISPLAY======================
;VD: MOV HOW,#10 |  CALL DISP1OM ==> HIEN THI KHUNG ANH TRONG 10MS
DISP10M:
		CALL DISPLAY
		JNB W10M,DISP10M
		CLR W10M
		DJNZ HOW,DISP10M
		RET
;==========================================================
;=============CAC HIEU UNG==================================
;===========DICH SANG TRAI - DICH SANG PHAI=============
;VD: CALL LEFT | CALL DISP10M ==>DICH SANG TRAI 1 COT VA HIEN THI 10MS
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
		POP 02H
		POP 01H
		POP 00H
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
;MOV DPTR,#PIC | CALL W_DATA | CALL COPY | CALL X_DOT ==> CHAY HIEU UNG
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
;VD: MOV STEP,#1 | CALL DEC_DPTR ==> GIAM CON TRO XUONG 1 DON VI		
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
;VD: MOV DPTR,#PIC | CALL W_DATA | CALL COPY ==> HIEN TU TRN XUONG 8 DONG
TOP_DOWN:
		PUSH 03H
		PUSH 02H
		PUSH 01H
		PUSH 00H
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
;=================XOA HIEN THI TU PHAI SANG===========
;MOV DPTR,#PIC1 | CALL W_DATA | CALL COPY | MOV DPTR,#PIC2 |CALL W_DATA ==> XOA PIC2 HIEN PIC1
SHOW_L:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST
		MOV R1,#FIRST+16
		MOV R2,#16
LOOP_SH:		
		MOV @R0,#0
		MOV HOW,#5
		CALL DISP10M
		MOV A,@R1
		MOV @R0,A
		INC R1
		INC R0
		DJNZ R2,LOOP_SH
		POP 02H
		POP 01H
		POP 00H
		RET
;============= XOA _HIEN THI TU TRAI SANG PHAI=============
SHOW_R:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#FIRST+15
		MOV R1,#FIRST+15+16
		MOV R2,#16
LOOP_SH2:
		MOV @R0,#0
		MOV HOW,#5
		CALL DISP10M
		MOV A,@R1
		MOV @R0,A
		DEC R0
		DEC R1
		DJNZ R2,LOOP_SH2
		POP 02H
		POP 01H
		POP 00H
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
		JNB INV,INVERT
		CPL C
INVERT:
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
;GHI DU LIEU VAO RAM TU [A] TU CON TRO DU LIEU
W_DATA:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R2,#16   ;]]]]]]]]]]]]]]]]]]]]]]]]]
		MOV R1,A
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
		SETB TF0
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
;========NAP MA MAU============
LOAD_CL:
		PUSH 01H
		PUSH 00H
    	MOV R0,#F_CL
RE_LOAD_CL:
    	MOV A,#0
    	MOVC A,@A+DPTR
    	MOV @R0,A
    	INC DPTR
    	INC R0
     	CJNE R0,#F_CL+8,RE_LOAD_CL
    	POP 00H
    	POP 01H
    	RET
;===========DICH LEN==============
SH_UP:
		PUSH 00H
		MOV R0,#FIRST
L_SH_UP:		
		MOV A,@R0
		SETB C
		RLC A
		MOV @R0,A
		INC R0
		CJNE R0,#FIRST+16,L_SH_UP
		POP 00H
		RET
SH_DOWN:
		PUSH 00H
		MOV R0,#FIRST
L_SH_DOWN:		
		MOV A,@R0
		SETB C
		RRC A
		MOV @R0,A
		INC R0
		CJNE R0,#FIRST+16,L_SH_DOWN
		POP 00H
		RET
	
;=============DICH MAU LEN=========
SHCL_UP:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#F_CL
		MOV R1,#F_CL+1
		MOV A,@R0
		MOV R2,A
LOOP_SH_DOWN:		
		MOV A,@R1
		MOV @R0,A
		INC R0
		INC R1
		CJNE R1,#F_CL+8,LOOP_SH_DOWN
		MOV F_CL+7,R2
		POP 02H
		POP 01H
		POP 00H
		RET
;=========DICH MAU XUONG DUOI============
SHCL_DOWN:
		PUSH 00H
		PUSH 01H
		PUSH 02H
		MOV R0,#F_CL+7
		MOV R1,#F_CL+6
		MOV A,@R0
		MOV R2,A
LOOP_SH_UP:		
		MOV A,@R1
		MOV @R0,A
		DEC R0
		DEC R1
		CJNE R1,#F_CL-1,LOOP_SH_UP
		MOV F_CL,R2
		POP 02H
		POP 01H
		POP 00H
		RET
;==============DAO MAU===================
INV_CL:
		PUSH 00H
		MOV R0,#F_CL
LOOP_INV_CL:
		MOV A,@R0
		CPL A
		MOV @R0,A
		INC R0
		CJNE R0,#F_CL+8,LOOP_INV_CL
		POP 00H
		RET
;==============XUAT DU LIEU===============
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
		CLR OE2
		SETB OE1
		JNB FLAG,HAFT
		MOV Tl0,XLOW
		CLR FLAG
		RETI
HAFT:
		SETB OE2
		CLR OE1
		MOV Tl0,XHIG
		SETB FLAG
		RETI			
;==========DINH THOI=================
INT_TIMER1:
		MOV TL1,#LOW(-10000)
		MOV TH1,#HIGH(-10000)
		SETB TR1
		SETB W10M
		RETI
;=========MA MAU======================
G2:
	DB  1,33,65,97,133,166,199,255
G1:
	DB  255,199,166,133,97,65,33,1
C1:
	DB	1,255,1,255,1,255,1,255
	
C2:
	DB  1,1,1,1,1,1,1,1                 ;XANH
C3:
	DB 	32,32,32,32,32,32,32,32
C4:
	DB  64,64,64,64,64,64,64,64
C5:
	DB  96,96,96,96,96,96,96,96
C6:
    DB  127,127,127,127,127,127,127,127
C7:
	DB	159,159,159,159,159,159,159,159
C8:	
	DB  190,190,190,190,190,190,190,190
C9:
	DB  227,227,227,227,227,227,227,227
C10:
	DB 255,255,255,255,255,255,255,255     ;DO
C11:
	DB 1,1,1,255,255,1,1,1
C12:
    DB 255,255,255,1,1,255,255,255
C13:
	DB 1,1,255,255,1,1,255,255
C14:
	DB 1,255,1,255,1,255,1,255
;===============MA CHU================
CDT:
    DB     0H,7FH,7FH,8FH,57H,57H,6FH,0FDH,80H,7DH,7DH,0FDH,0B2H,6DH,6DH,9BH  
S_08:

DB     0FFH,0FFH,81H,7EH,7EH,5EH,1DH,0DFH,0FFH,81H,7EH,7EH,7EH,81H,0FFH,0FFH  
LETS:

DB     0H,7FH,7FH,8FH,57H,57H,6FH,0FDH,80H,7DH,7DH,0FDH,0B2H,6DH,6DH,9BH  
M8051:
DB     0C9H,0B6H,0B6H,0C9H,0FFH,0C1H,0BEH
DB     0BEH,0C1H,0FFH,0B0H,0B6H,0B6H,0CFH,0FDH,80H  
	
TIM:
DB     0C1H,0BFH,0BFH,0C1H,0FFH,0F3H                      ;I LOVE U
db      0E1H,0C1H,83H,0DBH,0E9H,0F3H,0FFH,0BDH,81H,0BDH   ;

PIC2:
db 0FFh, 0C3h, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran       ;O	
db 0FFh, 081h, 081h, 0E3h, 0C9h, 09Dh, 0BFh, 0FFh    ;Ma Ma Tran  		;K
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
db 0FFh, 0F1h, 0B1h, 0AFh, 0AFh, 081h, 0C1h, 0FFh    ;Ma Ma Tran     ;Y
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 083h, 081h, 0E5h, 0E5h, 081h, 083h, 0FFh    ;Ma Ma Tran      ;A
db 0FFh, 081h, 081h, 0EDh, 0CDh, 0B3h, 0BFh, 0FFh    ;Ma Ma Tran      ;R
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0BBh, 09Dh, 08Dh, 0A1h, 0B3h, 0FFh, 0FFh    ;Ma Ma Tran      ;2
db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran      ;0
db 0FFh, 0FFh, 0F7h, 0BBh, 081h, 081h, 0BFh, 0FFh    ;Ma Ma Tran      ;1
db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran      ;0

VDK:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0E1h, 0CFh, 09Fh, 09Fh, 0CFh, 0E1h, 0FFh    ;Ma Ma Tran   ,V
db 0FFh, 0E7h, 081h, 0A5h, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran   ;DD
db 0FFh, 081h, 081h, 0E3h, 0C9h, 09Dh, 0BFh, 0FFh    ;Ma Ma Tran  ;K
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
TAM:
db 0FFh, 093h, 06Dh, 06Dh, 06Dh, 093h, 0FFh, 0FFh    ;Ma Ma Tran   ;8
db 0FFh, 083h, 079h, 075h, 06Dh, 05Dh, 083h, 0FFh    ;Ma Ma Tran   ;0
NAM:
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


ILOVEU:
db 0FFh, 0FFh, 0BDh, 081h, 081h, 0BDh, 0FFh, 0FFh    ;Ma Ma Tran  ;I
db 0FFh, 0F3h, 0EDh, 0DDh, 0BBh, 0DDh, 0EDh, 0F3h    ;Ma Ma Tran  ;TIM
db 0FFh, 0F3h, 0E1h, 0C1h, 083h, 0C1h, 0E1h, 0F3h    ;Ma Ma Tran  ;TIM2	
db 0FFh, 0C1h, 081h, 09Fh, 09Fh, 081h, 0C1h, 0FFh    ;Ma Ma Tran  ;U
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
TAT:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
SANG:
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran
 
CUOI:;16
DB     0FFH,0FFH,0FFH,0C3H,0BDH,6AH,5EH,5EH
DB    6AH,0BDH,0C3H,0FFH,0FFH,0FFH,0FFH,0FFH  
	END
	