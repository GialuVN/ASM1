;========================================
; Irish folk song "Morning Has Broken"
; WRITE BY :  	Michael A. Covington    mcovingt@ai.uga.edu
; 					Artificial Intelligence Center
; 					The University of Georgia
; 					Athens, Georgia 30602-7415
; ADAPTED BY : CONTAX 
;========================================
T2CON			EQU		0C8H
RCAP2L		EQU		0CAH
RCAP2H		EQU		0CBH
TL2			EQU		0CCH
TH2			EQU		0CDH
TR2			EQU		T2CON.2
TF2			EQU		T2CON.7

SPEAKER		EQU		P2.0

				DSEG		AT		20H
RTCLOCK:		DS    	1     			; Data location 3FH (top byte of data memory)
                        		; will be used as a real-time clock.
				CSEG		AT		0000H
        		ORG   	0
        		LJMP  	MAIN    			; long jump to main program
			;
; Timer interrupt service routine used to keep track of
; length of each note.  Takes 3 cpu cycles every 1/8 second.

        		ORG   	02BH
ISR:    		DEC   	RTCLOCK
				CLR		TF2
        		RETI
        		;
;=================================================================
; Delays A+60 CPU cycles, including the ACALL that calls it.
; A ranges from 3 to 255 inclusive.  For timing audio frequencies.
;=================================================================
MED_WAIT:        
        		PUSH   	ACC       ; yes, push it twice
        		PUSH   	ACC
        		ANL    	A,#1      ; isolate bottom bit of A
        		JZ     	MW1       ; branch depending on whether A is even
        		POP    	ACC       ;  2 cycles   \
        		DEC    	A         ;  1 cycle     |  5 cycles if A was odd
        		SJMP   	MW2       ;  2 cycles   /
MW1:    		POP    	ACC       ;  2 cycles   \   4 cycles if A was even
        		SJMP   	MW2       ;  2 cycles   /
MW2:    		RR     	A         ;  rotate A 1 bit right thereby dividing by 2
MW3:    		DJNZ   	ACC,MW3   ;  2*(A/2) cycles
        		MOV    	A,#20
MW4:    		DJNZ   	ACC,MW4   ;  40 more cycles
        		POP    	ACC
        		RET
        ;
;================================================================
; Produces audio on P0.0, preceded by a 5-msec silence.
; Registers:
;   A     = total duration in eighths of a second, including
;             the initial silence;
;   R0    = 0 if you want silence, or
;            (duration of low half-cycle in CPU cycles) - 65
;   R1    = (duration of high half-cycle in CPU cycles) - 65
; R0, R1 range from 3 to 255 inclusive.
; Uses RTCLOCK data area and timer interrupt service
; routine elsewhere in this program.
;================================================================
SOUND_GEN:  PUSH  	ACC
        		; Set up RTCLOCK to count down from A at 1/8-sec intervals.
        		MOV   	RCAP2H,#00H
        		MOV   	RCAP2L,#00H    ; Count from 6E5AH to 10000H
        		MOV   	TH2,RCAP2H
        		MOV   	TL2,RCAP2L      ; Preload timer for first cycle
        		MOV   	RTCLOCK,A   ; Preload RTCLOCK, will count down to 0
        		MOV   	T2CON,#00
        		SETB  	IE.5         ; Enable timer 0 interrupt
        		SETB  	EA          ; Enable interrupts in general
        		SETB  	TR2          ; Start timer running
        		; Moment of silence to separate adjacent musical notes
        		MOV   	A,#238
        		ACALL 	MED_WAIT
        		ACALL 	MED_WAIT
        		ACALL 	MED_WAIT
        		ACALL 	MED_WAIT
        		; If R0=0, make silence, not sound
        MOV   	A,R0
        JNZ   	SN1
SN0:    MOV   	A,RTCLOCK   ; keep checking timer
        JZ    	SN2
        SJMP  	SN0
        ; Main loop. Check timer after every half cycle of audio.
SN1:    CLR   	P2.0        ; (1 cycle)    ; low half cycle
        MOV   	A,R0        ; (1 cycle)
        ACALL 	MED_WAIT    ; (R0+60 cycles)
        MOV   	A,RTCLOCK   ; (1 cycle)    ; bail out if time is up
        JZ    	SN2         ; (2 cycles)
        SETB  	P2.0        ; (1 cycle)    ; high half cycle
        MOV   	A,R1        ; (1 cycle)
        ACALL 	MED_WAIT    ; (R1+60 cycles)
        MOV   	A,RTCLOCK   ; (1 cycle)    ; repeat if time is not up
        JNZ   	SN1         ; (2 cycles)
SN2:    SETB  	P2.0        ; Final state of output bit is 1
        CLR   	EA          ; Note off interrupts
        CLR   	IE.5         ; Clear timer interrupt bit
        CLR   	TR2          ; Stop timer
        POP   	ACC
        RET               ; All done

;=============================================================
; Plays a NOTE by reading sets of (R0,R1,A) values beginning
; at @DPTR, in *code* memory (not data memory), until a set
; with A=0 is found.  No limit on note length.
; Calling sequence:   MOV DPH,#HIGH(MYDATA)
;                     MOV DPL,#LOW(MYDATA)
;                     ACALL TUNE
;==============================================================
PLAY_NOTE:
        CLR   	A
        MOVC  	A,@A+DPTR
        MOV   	R0,A        ; got R0
        INC   	DPTR
        CLR   	A
        MOVC  	A,@A+DPTR
        MOV   	R1,A        ; got R1
        INC   	DPTR
        CLR   	A
        MOVC  	A,@A+DPTR   ; got A
        INC 	DPTR
        JZ    	TN1         ; exit if A=0
        ACALL 	SOUND_GEN
        SJMP  	PLAY_NOTE
TN1:    RET

;====== MAIN PROGRAM =================
MAIN:   MOV   	B,#1     ; loop counter
        MOV   	DPH,#HIGH(MYTUNE)
        MOV   	DPL,#LOW(MYTUNE)
        ACALL 	PLAY_NOTE
        DJNZ  	B,MAIN  ; play it again, Sam...
        SJMP	MAIN
		  ;
MYTUNE: ; Irish folk song "Morning Has Broken"
        DB 	225,225,4  	; C, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	130,130,4  	; G, qtr note
        DB  82, 83,12 	; C', dotted half note
        DB  67, 67,12 	; D', dotted half note
        DB  91, 91,4  	; B, qtr note
        DB 	109,110,4  	; A, qtr note
        DB 	130,130,4  	; G, qtr note
        DB 	109,110,12 	; A, dotted half note
        DB 	130,130,12 	; G, dotted half note
        DB 	225,225,4  	; C, qtr note
        DB 	194,194,4  	; D, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	130,130,12  ; G, dotted half note
        DB 	109,110,12  ; A, dotted half note
        DB 	130,130,4  	; G, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	225,225,4  	; C, qtr note
        DB 	194,194,16 	; D, whole note
        DB  0,  0,4  	; half rest
        DB 	130,130,4  	; G, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	130,130,4  	; G, qtr note
        DB 	82, 83,12 	; C', dotted half note
        DB 	109,110,12 	; A, dotted half note
        DB 	130,130,4  	; G, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	225,225,4  	; C, qtr note
        DB 	225,225,12 	; C, dotted half note
        DB 	194,194,12 	; D, dotted half note
        DB 	166,166,4  	; E, qtr note
        DB 	194,194,4  	; D, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	130,130,12 	; G, dotted half note
        DB 	109,110,12 	; A, dotted half note
        DB 	194,194,4  	; D, qtr note
        DB 	166,166,4  	; E, qtr note
        DB 	194,194,4  	; D, qtr note
        DB 	225,225,16 	; C, whole note
        DB  0,0,8  		; half rest (relevant only if repeating tune)
        DB  0,0,0  		; end of tune
        END
