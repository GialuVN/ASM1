
ORG 0

Main:
MOV DPTR,#MALED

MOV R4,#35
LOOP3:
CALL HT
DJNZ R4,LOOP3

JMP MAIN











HT:
	MOV R5,#10
LOOP2:
	MOV R7,#11111110B
	MOV R6,#0
LOOP:
	MOV A,R6
	MOVC A,@A+DPTR
	MOV P0,A
	MOV P2,R7
	CALL DELAY
	MOV P2,#255
	MOV A,R7
	RL A
	MOV R7,A
	INC R6
	CJNE A,#11111110B,LOOP
	DJNZ R5,LOOP2
	INC DPTR
	RET
	
	
DELAY:
MOV 30H,#100
RE_DELAY:
MOV 31H,#10
	DJNZ 31H,$
	DJNZ 30H,RE_DELAY
	RET
	
MALED:
db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh    ;Ma Ma Tran
	
DB     0FFH,81H,0BFH,0BFH,0DFH,0EFH,81H,0FFH  
DB     0FFH,87H,0EBH,0EDH,0EDH,0EBH,87H,0FFH  
DB     0FFH,0F9H,0F9H,81H,81H,0F9H,0F9H,0FFH  
DB     0FFH,81H,81H,0E7H,0E7H,81H,81H,0FFH  
DB     0FFH,0FFH,0FFH,81H,81H,0FFH,0FFH,0FFH  
	END



