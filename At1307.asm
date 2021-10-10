

;* FILENAME:     DS1307.ASM
;* MC:           ATMEL AT89XXX
;* PROJECT:      RTC USING DS1307
;* DATE:         15/07/2006
;* TIMEKEEPER:   DS1307 SERIAL TIMEKEEPER I.C.

;
SCL       BIT    P3.0
SDA       BIT    P3.1
DS1307W   EQU    0D0H     ; SLAVE ADDRESS 1101 000 + 0 TO WRITE
DS1307R   EQU    0D1H     ; SLAVE ADDRESS 1101 000 + 1 TO READ
FLAGS     DATA   20H
LASTREAD  BIT    FLAGS.0
ACK       BIT    FLAGS.5
BUS_FLT   BIT    FLAGS.6
_2W_BUSY  BIT    FLAGS.7
BITCNT    DATA   21H
BYTECNT   DATA   22H
SECS      DATA   24H      ;   '   SECONDS STORAGE RAM
MINS      DATA   25H      ;   '   MINUTES   '     '
HRS       DATA   26H      ;   '   HOURS     '     '
DAY       DATA   27H      ;   '   DAY       '     '
DATE      DATA   28H      ;   '   DATE      '     '
MONTH     DATA   29H      ;   '   MONTH     '     '
YEAR      DATA   2AH      ;   '   YEAR      '     '
CONTROL   DATA   2BH      ; FOR STORAGE OF CONTROL REGISTER WHEN READ.
ALM_HOUR  DATA   2CH      ; INTERNAL (ALARM HOURS) STORAGE.
ALM_MIN   DATA   2DH      ; INTERNAL (ALARM MINUTES) STORAGE.
ALM_CNTRL DATA   2EH      ; INTERNAL STORAGE FOR ALARM (ON) TIME.
ALM_STORE EQU    08H      ; DS1307 RAM, ALARM STORAGE, BEGINNING.

                
ORG 0000H

; **********************************************************
; RESET GOES HERE TO START PROGRAM
; **********************************************************

START:
    MOV			SP,#6FH    ; dat lai stack
    MOV			IE,#0      ; xoa thanh ghi ngat
    SETB		SDA        ; chac chan P3.1 cao
    CALL		DELAY
    CALL		SCL_HIGH	; chac chan P3.2 cao
    CLR    		ACK      	; xoa co trang thai
    CLR     	BUS_FLT				
	CLR    		_2W_BUSY
    CALL		DELAY_500MS	
    CALL		OSC_CONTROL

; **********************************************************
; TIME AND DATE ROUTINE, GET & DISPLAY MONTH/DATE/YEAR
; **********************************************************
GET_TIME:
	CALL DELAY_100ms         
	CALL READ_CLOCK          ; GET TIME,DATE,ALARM DATA
    MOV R1,SECS
    CPL P3.7
    CALL DISPLAY
    SJMP GET_TIME
; **********************************************************
; SUB RISE THE SCL
; **********************************************************
SCL_HIGH:
	SETB	SCL      ; SET SCL HIGH
   	CALL	Delay
   	JNB		SCL,$    ; LOOP UNTIL STRONG 1 ON SCL
   	RET
               				
; **********************************************************
; SUB SETS THE DS1307 OSCILLATOR - ENSURE THE CLOCK TO START
; **********************************************************

OSC_CONTROL:
	ACALL   SEND_START ; GENERATE START CONDITION
    MOV     A,#DS1307W ; 1101 0000 ADDRESS + WRITE-BIT
    ACALL   SEND_BYTE  ; SEND BYTE TO 1307
    MOV     A,#00H     ; ADDRESS BYTE TO REGISTER 00H
    ACALL   SEND_BYTE  ; SECONDS REGISTER, ALWAYS LEAVE
    
    SETB	LASTREAD   ; REG 00H-BIT #7 = 0 (LOW)
    ACALL   SEND_STOP  ; IF REG 00H-BIT #7 = 1 CLOCK
    ACALL   SEND_START ; OSCILLATOR IS OFF.
    MOV     A,#DS1307R ; 1101 0001 ADDRESS + READ-BIT
    ACALL   SEND_BYTE  ;
    ACALL   READ_BYTE  ; READ A BYTE FROM THE 1307
    CLR     ACC.7      ; CLEAR REG 00H-BIT #7 TO ENABLE
OSC_SET:               ; OSCILLATOR.
    PUSH    ACC        ; SAVE ON STACK
    ACALL   SEND_STOP  ;
    ACALL   SEND_START ;
    MOV     A,#DS1307W ; SETUP TO WRITE
    ACALL   SEND_BYTE  ;
    MOV     A,#00H     ; REGISTER 00H ADDRESS
    ACALL   SEND_BYTE  ;
	POP     ACC    		; GET DATA TO START OSCILLATOR
    ACALL   SEND_BYTE  ; SEND IT
	ACALL   SEND_STOP
		RET         
 
				 
; **********************************************************
; SUB CONTROLS THE ALARM OUTPUT
; THE DS1307 SQW OUTPUT DRIVES THE ALARM BUZZER @ 1Hz
; **********************************************************
ALARM_CONTROL:
    ACALL   SEND_START
    MOV     A,#DS1307W
    ACALL   SEND_BYTE
    MOV     A,#07H
    ACALL   SEND_BYTE
    MOV     R1,#ALM_CNTRL
    MOV     A,@R1      ; 10H = ALARM ON AT 1HZ
    ACALL   SEND_BYTE  ; 00H = ALARM OFF & SQW OUT = GND
    ACALL   SEND_STOP
    RET


; **********************************************************
; SUB SETS THE CLOCK
; **********************************************************
SET_CLOCK:
         
    ACALL   SEND_START ; SEND 2-WIRE START CONDITION
	MOV     A,#DS1307W		 ; SEND 1307 WRITE COMMAND
    ACALL   SEND_BYTE
    MOV     A,#00H    			 ; SET DATA POINTER TO REGISTER
                       			; 00H ON THE DS1307
	ACALL   SEND_BYTE
    MOV     R1,#24H   			 ; START WITH SECONDS REGISTER
                      			 ; IN INTERNAL RAM
SEND_LOOP:
	MOV     A,@R1      			; MOVE FIRST BYTE OF DATA TO ACC
    ACALL   SEND_BYTE  			; SEND DATA ON 2-WIRE BUT
    INC     R1         			; LOOP UNTIL CLOCK DATA SENT
    CJNE    R1,#2BH,SEND_LOOP
    ACALL   SEND_STOP  			; SEND 2-WIRE STOP CONDITION
    RET
         
; **********************************************************
; THIS SUB READS ONE BYTE OF DATA FROM THE DS1307
; **********************************************************
READ_BYTE:
	MOV     BITCNT,#08H			; SET COUNTER FOR 8-BITS DATA
	MOV     A,#00H
    SETB    SDA       			; SET SDA HIGH TO ENSURE LINE
    ACALL   DELAY
                                ; FREE
READ_BITS:
    CALL	SCL_HIGH       		 ; TRANSITION SCL LOW-TO-HIGH
    MOV     C,SDA     			; MOVE DATA BIT INTO CARRY
    RLC     A          			; ROTATE CARRY-BIT INTO ACC.0
    CLR     SCL        			; TRANSITION SCL HIGH-TO-LOW
    DJNZ    BITCNT,READ_BITS
                                ; LOOP FOR 8-BITS
	JB      LASTREAD,ACKN
                                ; CHECK TO SEE IF THIS IS
                                ; THE LAST READ
    CLR     SDA        			; IF NOT LAST READ SEND ACK-BIT
ACKN:		
	CALL	SCL_HIGH       		; PULSE SCL TO TRANSMIT ACKNOWLEDGE
    CLR     SCL        			; OR NOT ACKNOWLEDGE BIT
    ACALL   DELAY
    RET

; **********************************************************
; SUB SENDS START CONDITION
; **********************************************************
SEND_START:
    SETB    _2W_BUSY   ; INDICATE THAT 2-WIRE
    CLR     ACK        ; OPERATION IS IN PROGRESS
    CLR     BUS_FLT    ; CLEAR STATUS FLAGS
    JNB     SCL,FAULT
    JNB     SDA,FAULT
    SETB    SDA        ; BEGIN START CODITION
             
    ACALL   DELAY
    CALL	SCL_HIGH
    CLR     SDA
            
    ACALL   DELAY
    CLR     SCL
    ACALL   DELAY
	RET
FAULT:
    SETB    BUS_FLT
    ACALL   DELAY
    RET

; **********************************************************
; SUB SENDS STOP CONDITION
; **********************************************************
SEND_STOP:
    CLR     SDA
    ACALL   DELAY
    CALL	SCL_HIGH
    SETB    SDA
    CLR     _2W_BUSY
    ACALL   DELAY
    RET

; **********************************************************
; THIS SUB SENDS 1 BYTE OF DATA TO THE DS1307
; CALL THIS FOR EACH REGISTER SECONDS TO YEAR
; ACC MUST CONTAIN DATA TO BE SENT TO CLOCK
; **********************************************************

SEND_BYTE:
    MOV       BITCNT,#08H  		; SET COUNTER FOR 8-BITS
SB_LOOP:
    JNB       ACC.7,NOTONE 		; CHECK TO SEE IF BIT-7 OF
    SETB      SDA        		; ACC IS A 1, AND SET SDA HIGH
    JMP       ONE	
NOTONE:
    CLR       SDA      			; CLR SDA LOW
ONE:
    CALL	DELAY
	CALL	SCL_HIGH 	 		; TRANSITION SCL LOW-TO-HIGH
    RL        A          		; ROTATE ACC LEFT 1-BIT
    CLR       SCL        		; TRANSITION SCL LOW-TO-HIGH
    DJNZ      BITCNT,SB_LOOP 	; LOOP FOR 8-BITS
    SETB      SDA        		; SET SDA HIGH TO LOOK FOR
    CALL	SCL_HIGH    		; ACKNOWLEDGE PULSE
    CLR       ACK
    JNB       SDA,SB_EX  		; CHECK FOR ACK OR NOT ACK
    SETB      ACK        		; SET ACKNOWLEDGE FLAG FOR
                           		; NOT ACK
SB_EX:
	ACALL     DELAY      		; DELAY FOR AN OPERATION
    CLR       SCL        		; TRANSITION SCL HIGH-TO-LOW
    ACALL     DELAY      		; DELAY FOR AN OPERATION
    RET

; **********************************************************
; SUB READS THE CLOCK AND WRITES IT TO THE SCRATCHPAD MEMORY
; ON RETURN FROM HERE DATE & TIME DATA WILL BE STORED IN THE
; DATE & TIME REGISTERS FROM 24H (SECS) TO 2AH (YEAR)
; ALARM SETTINGS IN REGISTERS 2CH(HRS) AND 2DH(MINUTES).
; **********************************************************

READ_CLOCK:

    MOV      R1,#24H    ; SECONDS STORAGE LOCATION
    MOV      BYTECNT,#00H
    CLR      LASTREAD
    ACALL    SEND_START
    MOV      A,#DS1307W
    ACALL    SEND_BYTE
    MOV      A,#00H
    ACALL    SEND_BYTE
    ACALL    SEND_STOP
    ACALL    SEND_START
    MOV      A,#DS1307R
    ACALL    SEND_BYTE

READ_LOOP:
    MOV      A,BYTECNT
    CJNE     A,#09H,NOT_LAST
    SETB     LASTREAD

NOT_LAST:
    ACALL    READ_BYTE
    MOV      @R1,A
    MOV      A,BYTECNT
    CJNE     A,#00H,NOT_FIRST
    MOV      A,@R1
    CLR      ACC.7      ; ENSURE OSC BIT=0 (ENABLED)
    MOV      @R1,A
NOT_FIRST:
    INC      R1
    INC      BYTECNT
    MOV      A,BYTECNT
    CJNE     A,#0AH,READ_LOOP
    ACALL    SEND_STOP
    RET

; **********************************************************
; SUB DISPLAYS IN SEVEN SEGMENTs LED
; **********************************************************
DISPLAY:
	MOV			DPTR, #NUMBER_TABLE
	MOV			A, R1
	SWAP		A
	ANL			A, #00001111B
  	MOVC		A, @A + DPTR
  	MOV			P1, A
	RET
	
; **********************************************************
; NUMBER TABLE 
; **********************************************************
NUMBER_TABLE:
db 0C0h,0F9H,0A4h,0B0h,099h,092h,082h,0F8h,080h,090h
; **********************************************************
; SUB DELAYS THE BUS
; **********************************************************
DELAY:
    MOV			R7, #50
    DJNZ		R7, $
    RET
 ;**********************************************************
Delay_100ms:
	PUSH	01
	PUSH  	02
TT0:
	MOV   	R2,#180
    MOV   	R1,#72
TT1:
	DJNZ  	R1,TT1
    DJNZ  	R2,TT1
    POP		02
	POP		01
	RET
;***********************************************************   
Delay_500ms:
	PUSH		01
	PUSH  		02
	PUSH		03	
TT2:
	MOV   	R3,#4
    MOV   	R2,#132
    MOV   	R1,#116
TT3:
	DJNZ  	R1,TT3
    DJNZ  	R2,TT3
    DJNZ  	R3,TT3
	POP			03	
	POP			02
	POP			01
    RET
      
; **********************************************************
; END OF PROGRAM
; **********************************************************
  END


