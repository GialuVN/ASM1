FLAG BIT 00H		; DAT BIT CO DIA CHI 00H(BIT DAU TIEN CUA O NHO CO DIA CHI 20H) LAM BIEN
COUNT DATA 30H		; DAT BYTE CO DIA CHI 30H LAM BIEN
;---------------


ORG 0000H				;VI TRI BAT DAU CHUONG TRINH
JMP BEGIN
ORG 001BH				;VI TRI (VECTOR NGAT) SE DC NHAY DEN NEU TIMER TRAN, THAM KHAO SACH (TRANG 112,BANG 6.4)
MOV TH1,#HIGH(-50000)
MOV TL1,#LOW(-50000)
SETB TR1
SETB FLAG
RETI
BEGIN:
	MOV TMOD,#00010000B		;TIMER 1 CHE DO 16BIT, THAM KHAO SACH (TRANG 68,BANG 4.2 & 4.3)
	MOV IE,#10001000B		; CHO PHEP NGAT DO TIMER 1, THAM KHAO SACH (TRANG 107,BANG 6.1)
	MOV COUNT,#20			; DAT BIEN COUNT = 20
	CLR FLAG				;DAT BIEN FLAG =0
	SETB TF1				;SAU KHI TF1=1 THI VDK TU DONG NHAY DEN 'ORG 001BH'
MAIN:

	;----------------		;DOAN CHUONG TRINH CHINH
	;----------------
	;----------------\
	
	JMP MAIN
	
	
DEM:
	JNB FLAG,EN_DEM
	DJNZ COUNT,EX_DEM
	MOV COUNT,#20
	
	
	;---------------		;DOAN CHUONG TRINH DEM
	;---------------
	;---------------
	
	
	
	;CUOI CHUONG TRINH DEM
EX_DEM:
		CLR FLAG
EN_DEM:
		RET
		
		
		
END

	