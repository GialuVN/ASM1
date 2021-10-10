;~~~~~~~~~~~~~~~~~khai bao~~~~~~~~~~~~~~~~~~~~
K_SLE		BIT  P3.0	;CHON
K_INC		BIT  P3.1	;TANG
K_DEC		BIT  P3.2	;GIAM

BEL			BIT  P3.4	;CHUONG
G_DV		BIT  30H	
G_CH		BIT  31H	
P_DV		BIT  32H
P_CH		BIT  33H
T_DV		BIT  34H
T_CH		BIT  35H
;~~~~~~~~~~~~~~BAT DAU~~~~~~~~~~~~~~~~~~~~~~~~
ORG 0000H
JMP MAIN
ORG 000BH
JMP TM0
ORG 0001B
JMP TM1
MAIN:
		MOV EA,#8CH		;CHO PHEP NGAT TIMER0,1
		SETB PT0		;UU TIEN NGAT TIMER0
		MOV TMOD,#11H	;CHO PHEP BO DINH THOI 0,1 16 BIT
TM0:
	MOV TL0,LOW(-50000)
	MOV TH0,HIGH(-50000)
	SETB TR0
	MOV R0,#0
	RETI
END
