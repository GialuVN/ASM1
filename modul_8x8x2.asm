;KHAI BAO CHAN SU DUNG




;;BA	  BIT P1.0
;BB    BIT P1.1
;BC    BIT P1.2
;OEE	  BIT P1.3

SH_CP2 BIT P1.3
ST_CP2 BIT P1.4
_DS2   BIT P1.5
SH_CP BIT P1.0   ;XUNG CK CAO - THAP
ST_CP BIT P1.1	 ;XUNG XUAT 8BIT RA NGOAI CAO - THAP
_DS   BIT P1.2   ;NGO RA DU LIEU NOI TIEP



;KHAI BAO BIEN SU DUNG
_DPH DATA 30H    
_DPL DATA 31H
FDPH DATA 32H
FDPL DATA 33H
D_1  DATA 34H  
D_2  DATA 35H  ;SO DONG THIET KE (CO DINH =8)
D_3  DATA 36H  ;SO COT THIET KE  (THAY DOI TU 8 - 64)
D_4  DATA 37H
D_5	 DATA 38H
STEP DATA 40H  ;BUOC TANG/GIAM DPTR (0 - 255)
TEMP DATA 20H
FLAG1 BIT TEMP.0

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
	MOV STEP,#1
	CALL INC_DPTR
	DJNZ R1,LOOP_MAIN1
	MOV R1,#255
LOOP_MAIN2:
	CALL DICH
	MOV STEP,#1
	CALL DEC_DPTR
	DJNZ R1,LOOP_MAIN2
	JMP MAIN
	
;CHUONG TRINH CON HIEN THI DU LIEU TU [DPTR->DPTR+D_3]
DICH:
	PUSH 00H
	MOV R0,#5
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
		MOV D_4,#01111111B
LOOP_HT:
		MOV D_3,#64
LOOP_HT1:		
		MOV A,#0
		MOVC A,@A+DPTR
		MOV B,D_1
		DIV AB
		MOV C,ACC.0
		MOV _DS,C
		MOV _DS2,C
		JMP CONT2_FLAG1
		
		CPL FLAG1
		JNB FLAG1,CONT_FLAG1
		MOV _DS,C
		JMP CONT2_FLAG1
CONT_FLAG1:		
		MOV _DS2,C
CONT2_FLAG1:	

		SETB  SH_CP
		CLR   SH_CP
		SETB  SH_CP2
		CLR   SH_CP2
		INC DPTR
		DJNZ D_3,LOOP_HT1
		MOV DPH,_DPH
		MOV DPL,_DPL
		MOV P2,#255
		
		SETB ST_CP
		CLR  ST_CP
		SETB ST_CP2
		CLR  ST_CP2
		
		MOV P2,D_4
		MOV A,D_4
		RR A
		MOV D_4,A
		
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
		MOV R0,#2
LOOP_DELAY:
		MOV R1,#20
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
		