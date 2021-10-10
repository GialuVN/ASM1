org 0

main:
MOV A,#00000001B
L1:
MOV P1,A
CALL DELAY
RL A
jmp L1





lack:
		setb p1.2
		clr p1.2
		ret

output:
		PUSH ACC
		mov 33h,#8
		clr c
loop:
		rlc a
		mov p1.1,c
		setb p1.0
		clr p1.0
		djnz 33h,loop
		POP ACC
		ret













delay:
	mov 30h,#255
l_delay:
	mov 32h,#255
	djnz 32h,$
	djnz 30h,l_delay
	ret
	
	
	end