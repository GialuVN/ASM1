org 0
main:
setb p1.2
setb p1.3
setb p1.4
mov a,#129
cjne a,#128,k_bang
bang:
	clr p1.2		; bang
	jmp ex_ss
k_bang:
	jc nhohon	
	clr p1.3		; a>128
	
	jmp ex_ss
nhohon:
	clr p1.4		;a<128

ex_ss:
jmp $
end