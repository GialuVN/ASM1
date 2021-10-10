;KHAI BAO CHAN SU DUNG




BA	  BIT P1.0
BB    BIT P1.1
BC    BIT P1.2
OEE	  BIT P1.3
ST_CP BIT P1.4	 ;XUNG XUAT 8BIT RA NGOAI CAO - THAP
SH_CP BIT P1.5   ;XUNG CK CAO - THAP
_DS   BIT P1.6   ;NGO RA DU LIEU NOI TIEP



;KHAI BAO BIEN SU DUNG
_DPH EQU 30H    
_DPL EQU 31H
FDPH EQU 32H
FDPL EQU 33H
D_1  EQU 34H  
D_2  EQU 35H  ;SO DONG THIET KE (CO DINH =8)
D_3  EQU 36H  ;SO COT THIET KE  (THAY DOI TU 8 - 64)
D_4  EQU 37H
D_5	 EQU 38H
D_6  EQU 39H
D_7  EQU 3AH
STEP DATA 40H  ;BUOC TANG/GIAM DPTR (0 - 255)

;BAT DAU CHUONG TRINH
ORG 0
JMP MAIN
ORG 000BH
;JMP INT_TIMER0
MAIN:
;KHOI TAO
	MOV P1,#0
	
	
	MOV DPTR,#DULIEU
LOOP_MAIN:
	MOV R1,#255
LOOP_MAIN1:
	CALL DICH
	MOV STEP,#2
	CALL INC_DPTR
	DJNZ R1,LOOP_MAIN1
	MOV R1,#255
LOOP_MAIN2:
	CALL DICH
	MOV STEP,#2
	CALL DEC_DPTR
	DJNZ R1,LOOP_MAIN2
	JMP MAIN
;CHUONG TRINH CON HIEN THI DU LIEU TU [DPTR->DPTR+D_3]



DICH:
	PUSH 00H
	MOV R0,#3
LOOP_DICH:
	CALL HIEN_THI
	DJNZ R0,LOOP_DICH
	POP 00H
	RET
	
HIEN_THI:
		MOV _DPH,DPH
		MOV _DPL,DPL
		MOV D_5,#0
		MOV D_1,#1
		MOV D_2,#8
LOOP_HT:
		INC DPTR
		MOV D_3,#32
LOOP_HT2:	
		MOV A,#0
		MOVC A,@A+DPTR
		MOV B,D_1
		DIV AB
		MOV C,ACC.0
		MOV _DS,C
		SETB  SH_CP
		CLR   SH_CP
		INC DPTR
		INC DPTR
		DJNZ D_3,LOOP_HT2
		MOV DPH,_DPH
		MOV DPL,_DPL
		MOV D_3,#32
LOOP_HT1:	
		MOV A,#0
		MOVC A,@A+DPTR
		MOV B,D_1
		DIV AB
		MOV C,ACC.0
		MOV _DS,C
		SETB  SH_CP
		CLR   SH_CP
		INC DPTR
		INC DPTR
		DJNZ D_3,LOOP_HT1
		MOV DPH,_DPH
		MOV DPL,_DPL
		CLR OEE
		SETB ST_CP
		CLR  ST_CP
		MOV A,D_5
		MOV C,ACC.0
		MOV BA,C
		MOV C,ACC.1
		MOV BB,C
		MOV C,ACC.2
		MOV BC,C
		SETB OEE
		CALL DELAY
		INC D_5
		MOV A,D_1
		RL A
		MOV D_1,A
		DJNZ D_2,LOOP_HT
		RET
		
		
		
		
		
DELAY:
		PUSH 00H
		PUSH 01H
		MOV R0,#5
LOOP_DELAY:
		MOV R1,#200
		DJNZ R1,$
		DJNZ R0,LOOP_DELAY
		POP 01H
		POP 00H
		RET
		
;GIAM DPTR [DPTR-STEP]
DEC_DPTR:
		CLR C
		MOV A,DPL
		SUBB A,STEP
		MOV DPL,A
		MOV A,DPH
		SUBB A,#0
		MOV DPH,A
		RET
;TANG DPTR [DPTR+STEP]
INC_DPTR:
		MOV A,DPL
		ADD A,STEP
		MOV DPL,A
		MOV A,DPH
		ADDC A,#0
		MOV DPH,A
		RET
		

DULIEU:
HPNY:   ;168
;======================================================================
; Bitmap Data Created by RTB (c) 2009 Bui Viet Hoang
; 312 x 16 pixels - Monochrome
; Horizontal Scan Lines - Top to Bottom, Left to Right
;======================================================================

BitmapData:
db 0FFh,0FFh
db 0FFh,007h
db 0FEh,003h
db 0FCh,0F3h
db 0FDh,0F9h
db 0FDh,0FDh
db 0FDh,0FDh
db 0FCh,07Dh
db 0FEh,07Dh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0BDh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,087h
db 0FCh,003h
db 0FCh,0F9h
db 0FDh,0FDh
db 0F7h,0FDh
db 0E5h,0FDh
db 0ECh,001h
db 0FCh,001h
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,007h
db 0FEh,003h
db 0FCh,0F3h
db 0FDh,0F9h
db 0FDh,0FDh
db 0FDh,0FDh
db 0FCh,07Dh
db 0FEh,07Dh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FCh,001h
db 0FCh,03Dh
db 0FCh,03Fh
db 0FEh,007h
db 0FFh,087h
db 0FCh,01Fh
db 0FCh,07Fh
db 0FCh,001h
db 0FDh,001h
db 0FFh,0FDh
db 0FFh,087h
db 0FCh,003h
db 0FCh,0F9h
db 0FDh,0FDh
db 0EFh,0FDh
db 0E5h,0FDh
db 0F4h,001h
db 0FCh,001h
db 0F1h,0FFh
db 0F3h,0FFh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FCh,0FDh
db 0FEh,07Fh
db 0FFh,03Fh
db 0FFh,09Fh
db 0FDh,0CDh
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,00Fh
db 0FEh,003h
db 0FCh,0F3h
db 0FDh,0F9h
db 0FDh,0FDh
db 0FDh,0FDh
db 0FCh,0C1h
db 0FEh,041h
db 0FFh,0DDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FCh,0FDh
db 0FEh,07Fh
db 0FFh,03Fh
db 0FFh,09Fh
db 0FDh,0CDh
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FFh,0E1h
db 0FFh,085h
db 0F4h,02Fh
db 0F4h,0EFh
db 0F4h,00Fh
db 0F7h,007h
db 0FFh,0C1h
db 0FFh,0F9h
db 0FFh,0FDh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FCh,001h
db 0FCh,03Dh
db 0FCh,03Fh
db 0FEh,007h
db 0FFh,087h
db 0FCh,01Fh
db 0FCh,07Fh
db 0FCh,001h
db 0FDh,001h
db 0FFh,0FDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FCh,001h
db 0FCh,03Dh
db 0FCh,03Fh
db 0FEh,007h
db 0FFh,087h
db 0FCh,01Fh
db 0FCh,07Fh
db 0FCh,001h
db 0FDh,001h
db 0FFh,0FDh
db 0FFh,007h
db 0FEh,003h
db 0FCh,079h
db 0FCh,0FDh
db 0F4h,0FDh
db 0E4h,0FDh
db 0ECh,079h
db 0F4h,003h
db 0F3h,007h
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0F7h
db 0FFh,0F7h
db 0FFh,0F7h
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,0F9h
db 0FDh,0F1h
db 0FDh,0E5h
db 0FDh,0CDh
db 0FCh,08Dh
db 0FEh,01Dh
db 0FFh,039h
db 0FFh,0FFh
db 0FFh,007h
db 0FEh,003h
db 0FCh,0F9h
db 0FDh,0FDh
db 0FCh,0F9h
db 0FEh,003h
db 0FFh,007h
db 0FFh,0FFh
db 0FFh,0FFh
db 0FEh,0FDh
db 0FCh,0F9h
db 0FCh,001h
db 0FFh,0FDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FEh,0FDh
db 0FCh,0F9h
db 0FCh,001h
db 0FFh,0FDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FFh,0FCh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FDh,0FFh
db 0FDh,0FFh
db 0FDh,0FDh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0FFh
db 0FDh,0FFh
db 0FDh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0BDh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,0FDh
db 0FFh,0E1h
db 0FFh,085h
db 0FCh,02Fh
db 0ECh,0EFh
db 0E4h,00Fh
db 0F7h,007h
db 0FFh,0C1h
db 0FFh,0F9h
db 0FFh,0FDh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FCh,0FDh
db 0FEh,07Fh
db 0FFh,03Fh
db 0FFh,09Fh
db 0FDh,0CDh
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0BDh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FFh,0BFh
db 0FCh,001h
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,007h
db 0FEh,003h
db 0FCh,0F3h
db 0FDh,0F9h
db 0FDh,0FDh
db 0FDh,0FDh
db 0FCh,07Dh
db 0FEh,07Dh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,007h
db 0FEh,003h
db 0FCh,0F9h
db 0F5h,0FDh
db 0EDh,0FDh
db 0EDh,0FDh
db 0F4h,0F9h
db 0FEh,003h
db 0FFh,007h
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,001h
db 0FCh,001h
db 0FCh,0FDh
db 0FEh,07Fh
db 0FFh,03Fh
db 0FFh,09Fh
db 0FDh,0CDh
db 0FCh,001h
db 0FDh,0FDh
db 0FFh,0FFh
db 0FFh,00Fh
db 0FEh,003h
db 0FCh,0F3h
db 0FDh,0F9h
db 0FDh,0FDh
db 0FDh,0FDh
db 0FCh,0C1h
db 0FEh,041h
db 0FFh,0DDh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FCh,005h
db 0FCh,00Dh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
db 0FFh,0FFh
; End of BitmapData


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
db 0FFh, 0F1h, 0B1h, 0AFh, 0AFh, 081h, 0C1h, 0FFh    ;Ma Ma Tran      ;Y
db 0FFh, 081h, 081h, 0A5h, 0A5h, 0A5h, 0FFh, 0FFh    ;Ma Ma Tran      ;E
db 0FFh, 083h, 081h, 0E5h, 0E5h, 081h, 083h, 0FFh    ;Ma Ma Tran      ;A
db 0FFh, 081h, 081h, 0EDh, 0CDh, 0B3h, 0BFh, 0FFh    ;Ma Ma Tran      ;R
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
db 0FFh, 0BBh, 09Dh, 08Dh, 0A1h, 0B3h, 0FFh, 0FFh    ;Ma Ma Tran      ;2
db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran      ;0
db 0FFh, 0FFh, 0F7h, 0BBh, 081h, 081h, 0BFh, 0FFh    ;Ma Ma Tran      ;1
db 0FFh, 0FFh, 0F7h, 0BBh, 081h, 081h, 0BFh, 0FFh    ;Ma Ma Tran      ;1
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
CUOI:;16
DB     0FFH,0FFH,0FFH,0C3H,0BDH,6AH,5EH,5EH
DB    6AH,0BDH,0C3H,0FFH,0FFH,0FFH,0FFH,0FFH  
AROW:

db 0FFh, 0FFh, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h, 0C3h    ;Ma Ma Tran;DUOI MUI TEN
db 0C3h, 0C3h, 0C3h, 0C3h, 00h, 081h, 0C3h, 0E7h    ;Ma Ma Tran ;MUI TEN  (PHAI)


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
db 0FFh, 0FFh, 0BDh, 081h, 081h, 0BDh, 0FFh, 0FFh    ;Ma Ma Tran  ;I
ILY:
db 0FFh, 0F3h, 0EDh, 0DDh, 0BBh, 0DDh, 0EDh, 0F3h    ;Ma Ma Tran  ;TIM
db 0FFh, 0F3h, 0E1h, 0C1h, 083h, 0C1h, 0E1h, 0F3h    ;Ma Ma Tran  ;TIM2	
db 0FFh, 0C1h, 081h, 09Fh, 09Fh, 081h, 0C1h, 0FFh    ;Ma Ma Tran  ;U
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0C3h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran  ;0 NHO
db 0FFh, 0FFh, 081h, 0BDh, 0BDh, 081h, 0C3h, 0FFh    ;Ma Ma Tran   'D
db 0C3h, 0BDh, 042h, 05Ah, 05Ah, 042h, 0BDh, 0C3h    ;Ma Ma Tran; TIEN
TAT:
SIN:
CHIP:;16
DB     0FFH,0FFH,93H,1H,83H,1H,83H
DB     1H,83H,1H,83H,1H,83H,0FFH,0FFH,0FFH  

SANG:
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran
db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h    ;Ma Ma Tran


db 00h, 080h, 0C0h, 0E0h, 0F0h, 0F8h, 0FCh, 0FEh    ;Ma Ma Tran ,NUA TRAI
db 07Fh, 03Fh, 01Fh, 0Fh, 07h, 03h, 01h, 00h    ;Ma Ma Tran;  NUA PHAI












	END
		