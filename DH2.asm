;~~~~~~~~~~~~~~~~~khai bao~~~~~~~~~~~~~~~~~~~~
K_SLE		BIT  P3.0	;CHON
K_INC		BIT  P3.1	;TANG
K_DEC		BIT  P3.2	;GIAM

BEL			BIT  P3.4	;CHUONG
G_DV		EQU  30H	
G_CH		EQU  31H	
P_DV		EQU  32H
P_CH		EQU  33H
T_DV		EQU  34H
T_CH		EQU  35H
CLOCK		BIT  00H	;XUNG 1S
;~~~~~~~~~~~~~~BAT DAU~~~~~~~~~~~~~~~~~~~~~~~~
ORG 0000H
JMP MAIN
ORG 000BH
JMP TM0
;ORG 0001B
;JMP TM1
MAIN:
;~~~~~~~~~~~~~~~KHOI TAO~~~~~~~~~~~~~~~~~~~~~
		MOV R0,#0		;XOA R0
		MOV G_DV,#0
		
		MOV IE,#8BH		;CHO PHEP NGAT TIMER0,1
		SETB PT0		;UU TIEN NGAT TIMER0
		MOV TMOD,#11H	;CHO PHEP BO DINH THOI 0,1 16 BIT
		
		
TEST:
		SETB TF0
REPEAT:
		CJNE R0,#20,REPEAT2
		MOV R0,#0
		CPL CLOCK
		SETB TF0
REPEAT2:
		CALL DISP
		JNB CLOCK,REPEAT
	;CHUONG TRINH DEM
		CPL CLOCK
		JMP REPEAT
DISP:
		CLR P0.0		
		MOV P1,#07DH
		RET
		
		
		
		
		
		
		
		
		
TM0:
	MOV TL0,LOW(-50000)
	MOV TH0,HIGH(-50000)
	SETB TR0
	INC R0
	RETI
END
