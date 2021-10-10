;======definition========
COL	DATA 30H
SDH DATA 31H				;LUU CON TRO DU LIEU
SDL DATA 32H				;<>
ROW	DATA 33H
INT	BIT	 00H
SH_R BIT  01H
ORG 00H
JMP MAIN
ORG 000BH
JMP INT_0
;KHOI TAO
MAIN:		
		CLR P1.0			;OE ,CHO PHEP
		CLR	 P1.1			;ST_CP ,SAN SANG
		CLR  P1.2			;SH_CP ,SAN SANG
		MOV DPTR,#THI
		MOV SDH,DPH			;CAT CON TRO DU LIEU
		MOV SDL,DPL			;<>
		MOV TMOD,#01H		;BO DINH THOI 0 CHE DO 1
		MOV IE,#82H			;CHO PHEP NGAT DO TIMER 0
		MOV COL,#0			;
		MOV ROW,#0
		SETB TR0
		SETB TF0

DISP_X:	
		CALL COUNT_SEC		;DEM THOI GIAN CHUYEN
		CALL SWEEP_COL
		CALL CLOCK_D
		CALL LEFT
		CALL DELAY10M
		CLR P1.7
CONT_DISP_X:
		INC COL
		MOV A,COL
		CJNE A,#8,DISP_X
		MOV COL,#0
		JNB SH_R,DISP_X
		INC DPTR
		CLR SH_R
		JMP DISP_X
;quet 4 byte cua mot cot
SWEEP_COL:
		PUSH 0
		PUSH 1
		PUSH 2
		MOV R1,#43H
		MOV R2,#4
		MOV R0,COL
REP_SWEEP_COL:
		MOV A,R0
		MOVC A,@A+DPTR
		MOV @R1,A
		DEC R1
		MOV A,R0
		ADD A,#8
		MOV R0,A
		DJNZ R2,REP_SWEEP_COL
		MOV R1,#40
REP_SHIFT:
		MOV A,@R1
		CALL SHIFT_8BIT
		INC R1
		CJNE R1,#44H,REP_SHIFT
		POP 2
		POP 1
		POP 0
		RET
;dich 8 bit ra DS
SHIFT_8BIT:
		PUSH 0
		MOV R0,#8
REP_SHIFT_8BIT:
		RLC A
		MOV P1.3,C
		CALL CLOCK_W
		DJNZ R0,REP_SHIFT_8BIT
		POP 0
		RET
;=======QUET TU PHAI=======
RIGHT:
		DEC ROW
		CALL ROWS
		MOV A,ROW
		CJNE A,-1,CONT_RIGHT
		MOV ROW,#8
CONT_RIGHT:
		RET
;=======QUET TU TRAI=======
LEFT:	
		CALL ROWS
		INC ROW
		MOV A,ROW
		CJNE A,#8,CONT_LEFT
		MOV ROW,#0
CONT_LEFT:
		RET
;=====QUET TUNG COT========		
ROWS:	
		MOV A,ROW
		CJNE A,#0,ROW2
		CLR P1.4
		CLR P1.5
		CLR P1.6
		SETB P1.7
		JMP END_ROW
ROW2:
		CJNE A,#1,ROW3
		SETB P1.4
		CLR P1.5
		CLR P1.6
		SETB P1.7
		JMP END_ROW
ROW3:
		CJNE A,#2,ROW4
		CLR P1.4
		SETB P1.5
		CLR P1.6
		SETB P1.7
		JMP END_ROW
ROW4:
		CJNE A,#3,ROW5
		SETB P1.4
		SETB P1.5
		CLR P1.6
		SETB P1.7
		JMP END_ROW
ROW5:
		CJNE A,#4,ROW6
		CLR P1.4
		CLR P1.5
		SETB P1.6
		SETB P1.7
		JMP END_ROW
ROW6:
		CJNE A,#5,ROW7
		SETB P1.4
		CLR P1.5
		SETB P1.6
		SETB P1.7
		JMP END_ROW
ROW7:
		CJNE A,#6,ROW8
		CLR P1.4
		SETB P1.5
		SETB P1.6
		SETB P1.7
		JMP END_ROW
ROW8:
		CJNE A,#7,END_ROW
		SETB P1.4
		SETB P1.5
		SETB P1.6
		SETB P1.7
END_ROW:
		RET
;====XUAT DU LIEU TU IC GHI DICH=====

CLOCK_D:
		SETB P1.1
		CLR P1.1
		RET
;=====GHI DU LIEU VAO IC GHI DICH====
CLOCK_W:
		SETB P1.2
		CLR P1.2
		RET
		
;==========DEM GIAY==================
COUNT_SEC:
		JNB INT,END_FUL
		INC R7
		CJNE R7,#10,END_FUL
		MOV R7,#0
		CPL SH_R
END_FUL:
		CLR INT
		RET
;=========TAO XUNG CHUAN 50mS========
INT_0:
		MOV TH0,#HIGH(-49995)
		MOV TL0,#LOW(-49995)
		SETB INT
		RETI		
;=========DUY TRI HIEN THI===========
DELAY10M:
		PUSH 0
		PUSH 1
		MOV R0,#15
REP_DELAY10M:
		MOV R1,#100
		DJNZ R1,$
		DJNZ R0,REP_DELAY10M
		POP 1
		POP 0
		RET
THI:
db 0FFh, 0FFh, 081h, 081h, 09Fh, 09Fh, 09Fh, 0FFh    ;Ma Ma Tran

db 0FFh, 0C1h, 081h, 09Fh, 09Fh, 081h, 0C1h, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

db 0FFh, 081h, 083h, 0F7h, 0F7h, 083h, 081h, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0FFh, 081h, 081h, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

db 0FFh, 081h, 081h, 0CFh, 0F3h, 081h, 081h, 0FFh    ;Ma Ma Tran

db 0FFh, 081h, 081h, 0E7h, 0E7h, 081h, 081h, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

db 0FFh, 0F9h, 0F9h, 081h, 081h, 0F9h, 0F9h, 0FFh    ;Ma Ma Tran

db 0FFh, 081h, 081h, 0E7h, 0E7h, 081h, 081h, 0FFh    ;Ma Ma Tran

db 0FFh, 0FFh, 0FFh, 081h, 081h, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran

		END
	