;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; chuong trinh vi dieu khien cho thang may;;;;;;
;;;;;;;;;;;;;;;;;;;;; vo thanh huy ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org	00h
	mov p0,#0ffh
main:
	jnb	p0.0,dongcua
	jnb	p0.1,mocua
	jnb	p0.2,dilen
	jnb	p0.3,dixuong
	jmp main	
dongcua:
	mov	p1,#0ffh
	clr	p1.0
	jnb p0.0,$
	jmp main
mocua:
	mov	p1,#0ffh
	clr	p1.1
	jnb p0.1,$	
	jmp main
dilen:
	mov	p1,#0ffh
	clr	p1.2
	jnb p0.2,$
	jmp main
dixuong:
	mov	p1,#0ffh
	clr	p1.3
	jnb p0.3,$
	jmp	main
end	