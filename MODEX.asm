ORG 0
		MOV P2,#0F0H
MAIN:
		MOV P3,#0FFH
		MOV A,#0FEH
LOOP:
		MOV P0,A
		CALL DELAY
		RL A
		CJNE A,#0FEH,LOOP
		
		MOV A,#07FH
LOOP2:
		MOV P0,A
		CALL DELAY
		RR A
		CJNE A,#07FH,LOOP2
		CALL DELAY
		
		MOV A,#0FFH
LOOP3:
		CLR C
		RLC A
		MOV P0,A
		CALL DELAY
		CJNE A,#0,LOOP3
		MOV A,#00H
LOOP4:
		SETB C
		RRC A
		MOV P0,A
		CALL DELAY
		CJNE A,#0FFH,LOOP4
		MOV A,#0FFH
LOOP5:
		CLR C
		RRC A
		MOV P0,A
		CALL DELAY
		CJNE A,#0,LOOP5
		MOV A,#00H
LOOP6:
		SETB C
		RLC A
		MOV P0,A
		CALL DELAY
		CJNE A,#0FFH,LOOP6
		MOV A,#0FEH
		
		MOV P0,#0FFH
LOOP7:
		MOV P3,A
		CALL DELAY
		RL A
		CJNE A,#0FEH,LOOP7
		
		MOV A,#07FH
LOOP8:
		MOV P3,A
		CALL DELAY
		RR A
		CJNE A,#07FH,LOOP8
		CALL DELAY
		
		MOV A,#0FFH
LOOP9:
		CLR C
		RLC A
		MOV P3,A
		CALL DELAY
		CJNE A,#0,LOOP9
		MOV A,#00H
LOOP10:
		SETB C
		RRC A
		MOV P3,A
		CALL DELAY
		CJNE A,#0FFH,LOOP10
		MOV A,#0FFH
LOOP11:
		CLR C
		RRC A
		MOV P3,A
		CALL DELAY
		CJNE A,#0,LOOP11
		MOV A,#00H
LOOP12:
		SETB C
		RLC A
		MOV P3,A
		CALL DELAY
		CJNE A,#0FFH,LOOP12
		MOV A,#0FEH
LOOP13:
		MOV P0,A
		MOV P3,A
		CALL DELAY
		RL A
		CJNE A,#0FEH,LOOP13
		
		MOV A,#07FH
LOOP14:
		MOV P0,A
		MOV P3,A
		CALL DELAY
		RR A
		CJNE A,#07FH,LOOP14
		CALL DELAY
		
		MOV A,#0FFH
LOOP15:
		CLR C
		RLC A
		MOV P0,A
		MOV P3,A
		CALL DELAY
		CJNE A,#0,LOOP15
		MOV A,#00H
LOOP16:
		SETB C
		RRC A
		MOV P0,A
		MOV P3,A
		CALL DELAY
		CJNE A,#0FFH,LOOP16
		MOV A,#0FFH
LOOP17:
		CLR C
		RRC A
		MOV P0,A
		MOV P3,A
		CALL DELAY
		CJNE A,#0,LOOP17
		MOV A,#00H
LOOP18:
		SETB C
		RLC A
		MOV P0,A
		MOV P3,A
		CALL DELAY
		CJNE A,#0FFH,LOOP18
		MOV P3,#0FFH
		MOV A,#0FEH
LOOP19:
		MOV P0,A
		CALL DELAY
		RL A
		CJNE A,#0FEH,LOOP19
		MOV P0,#0FFH
		MOV A,#07FH
LOOP21:
		MOV P3,A
		CALL DELAY
		RR A
		CJNE A,#07FH,LOOP21
		MOV P3,#0FFH
		MOV A,#07FH
		
LOOP22:
		MOV P0,A
		CALL DELAY
		RR A
		CJNE A,#07FH,LOOP22
		MOV A,#0FEH
		MOV P0,#0FFH
		
LOOP20:
		MOV P3,A
		CALL DELAY
		RL A
		CJNE A,#0FEH,LOOP20
		JMP MAIN		
DELAY:
		MOV R0,#10
LAP:
		MOV R1,#100
LAP1:
		MOV R2,#100
		DJNZ R2,$
		DJNZ R1,LAP1
		DJNZ R0,LAP
		RET
		END
		