_DQ	   BIT P2.0 ;NGA VAO DS18B20
_WAIT  EQU 30H	;BIEN DELAY

FLAG  DATA 20H
_SAVE BIT FLAG.1

;==============BIEN LUU TRU=============
RW0	EQU 40H
RW1	EQU 41H
RW2	EQU 42H
RW3	EQU 43H
RW4	EQU 44H
RW5	EQU 45H
RW6	EQU 46H
RW7	EQU 47H
RW8	EQU 48H

;======================================
ORG 0000H


BEGIN:
	MOV P2,#0
	SETB _DQ
	CALL DELAY1S
		
MAIN:
;========SETUP TH,TL AND CONFIG BIT==========
	CALL INIT_TIME
	MOV A,#0CCH
	CALL MASTER_WIRTE
	MOV A,#4EH
	CALL MASTER_WIRTE
	MOV A,#100			;TH
	CALL MASTER_WIRTE
	MOV A,#0			;TL
	CALL MASTER_WIRTE
	MOV A,#00011111B	;CONFIG
	CALL MASTER_WIRTE
	CALL INIT_TIME
	MOV A,#0CCH
	CALL MASTER_WIRTE
	MOV A,#48H
	CALL MASTER_WIRTE
	CALL DELAY1S		;COPY TO EEPROM
;=============================================
L_XX:	
;==========RECALL E2==========================
	CALL INIT_TIME
	MOV A,#0CCH
	CALL MASTER_WIRTE
	MOV A,#0B8H
	CALL MASTER_WIRTE
	JNB _DQ,$
L_YY:
;=============================================
;=============CONVERSION TEMP=================
	CALL INIT_TIME
	MOV A,#0CCH
	CALL MASTER_WIRTE
	MOV A,#44H
	CALL MASTER_WIRTE
	JNB _DQ,$
;=============================================
;===READ 9 BYTE INFOR FORM DS18B20 TO RAM=====
	CALL INIT_TIME
	MOV A,#0CCH
	CALL MASTER_WIRTE
	MOV A,#0BEH
	CALL MASTER_WIRTE
	
	MOV R0,#RW0
	MOV R1,#9
L_READ:	
	CALL MASTER_READ
	MOV @R0,A
	INC R0
	DJNZ R1,L_READ
	
	
	MOV A,RW0
	MOV P1,A
	MOV A,RW1
	MOV P3,A
	MOV A,RW4
	MOV P0,A
	
	CALL DELAY1S
	CPL P2.1
	JMP L_YY
	
	
;=========================================
;============KHOI TAO DS18B20=============
INIT_TIME:
		CLR _DQ
		MOV _WAIT,#250
		DJNZ _WAIT,$
		SETB _DQ
L1_INIT_TIME:
		MOV _WAIT,#30
		DJNZ _WAIT,$
		JNB _DQ,L1_INIT_TIME
		RET
;========================================
;=====MASTER WIRTE ONE BYTE==============
;EXAMPLE 
;MOV A,#DATA
;CALL MASTER_WIRTE
MASTER_WIRTE:
		PUSH 01H
		MOV R1,#8
REPEAT_MASTER_WB:		
		CLR _DQ
		MOV _WAIT,#7
		DJNZ _WAIT,$
		RRC A
		MOV _DQ,C	
		MOV _WAIT,#7
		DJNZ _WAIT,$
		SETB _DQ
		NOP
		DJNZ R1,REPEAT_MASTER_WB
		POP 01H
		RET	
;======================================
;============READ ONE BYTE=============
;EXAMPLE
;CALL MASTER WIRTE
;MOV [STORE],A
MASTER_READ:
		PUSH 01H
		MOV R1,#8
L_MASTER_RB:		
		CLR _DQ
		NOP
		NOP
		SETB _DQ
		MOV _WAIT,#5
		DJNZ _WAIT,$
		MOV C,_DQ
		RRC A
		MOV _WAIT,#50
		DJNZ _WAIT,$
		DJNZ R1,L_MASTER_RB
		POP 01H
		RET
;=======================================	
DELAY1S:
		PUSH 01H
		PUSH 02H
		PUSH 03H
		MOV R1,#10
L1_DELAY1S:
		MOV R2,#200
L2_DELAY1S:
		MOV R3,#250
		DJNZ R3,$
		DJNZ R2,L2_DELAY1S
		DJNZ R1,L1_DELAY1S
		POP 03H
		POP 02H
		POP 01H
		RET
END