ORG  0000H


ON1	 EQU	30H
ON2	 EQU	31H

OFF1 EQU 	32H
OFF2 EQU	33H


OUT  DATA 20H
OUT1 BIT OUT.0
OUT2 BIT OUT.1
BEGIN:


MOV OUT,#0



MAIN:






	JMP MAIN

SWEEP:
		DJNZ R0,L1
		CPL OUT1
		JNB OUT1,L11
		MOV R0,ON1
		JMP L1
L11:
		MOV R0,OFF1	
L1:		



		
L1:		DJNZ R1,L2



		CPL OUT2
L2:
		RET


COMPARE:
		JNB OUT1,C1
		MOV R0,ON1
		JMP 
C1:
		MOV R0,OFF1







	END


	