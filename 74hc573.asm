org 0

main:
clr p3.0
clr p3.1
lap4:
mov a,#10000000b
mov r4,#8
lap2:
mov p1,a
setb p3.0
clr p3.0
rr a
call delay
djnz r4,lap2

mov p1,#0
setb p3.0
clr p3.0

mov a,#10000000b
mov r4,#8
lap3:
	mov p1,a
	setb p3.1
	clr p3.1
	rr a
	call delay
	djnz r4,lap3
	mov p1,#0
	setb p3.1
	clr p3.1
	jmp lap4














delay:
	mov 30h,#255
l_delay:
	mov 32h,#255
	djnz 32h,$
	djnz 30h,l_delay
	ret
	
	
	end