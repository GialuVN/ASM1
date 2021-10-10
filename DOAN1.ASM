;DAY LA CHUONG TRINH THU NGHIEM TU DONG DONG DIEN TU NGUON PHU KHI NGUON CHINH BI MAT VA NGUOC LAI
ORG 00H
CB BIT P0.0
K1 BIT P0.1
K2 BIT P0.2
;===============================================
;NGAT CAC TIEP DIEM
MAIN:
		SETB K1;NGAT K1
		SETB K2;NGAT K2
		SETB CB;DAT P0.0=1
;===============================================
;KIEM TRA TRANG THAI CUA CB,K1 VA K2
KTRA:
		JB CB,TIEP;KIEM TRA CB,CO DIEN HAY CHUA
		JNB K1,KTRA;NHAY VE KIEM TRA TIEP NEU K1=0
		CALL CHT1
		JMP KTRA
TIEP:
		JNB K2,KTRA;NHAY VE KIEM TRA TIEP NEU K2=0
		CALL CHT2
		JMP KTRA
;===============================================
;CHUONG TRINH CON MO K1,DONG K2
CHT1:
		SETB K2
		CALL DELAY05
		CLR K1
		RET
;===============================================
;CHUONG TRINH CON MO K2 DOONG K1
CHT2:
		SETB K1
		CALL DELAY05
		CLR K2
		RET
;===============================================
;TAO KHOANG THOI GIAN CHUYEN MACH GIUA K2 VA K1
DELAY05:
		MOV R0,#10
		MOV TMOD,#01H
LOOP:
		MOV TL0,#LOW(-50000)
		MOV TH0,#HIGH(-50000)
		SETB TR0
		JNB TF0,$
		CLR TR0
		CLR TF0
		DJNZ R0,LOOP
		RET
;===============================================
	END
;********************01/02/2009**************************