%*DEFINE	(DELAY(REDO,GTTL0,GTTH0)) LOCAL LOOP1
		(	MOV R0,#%REDO
			MOV TMOD,#01H
	LOOP1:
			MOV TL0,#%GTTL0
			MOV TH0,#%GTTH0
			SETB TR0
			JNB TF0,$
			CLR TR0
			CLR TF0
			DJNZ R0,LOOP1
			RET)