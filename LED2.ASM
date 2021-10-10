
ORG	30H
MAIN: JNB P2.0,LED1	;Nhay khi p2.0 =0
      JNB P2.1,LED2	;nhay khi p2.1=0
      LJMP MAIN	
      
      
LED1: JNB P2.0,LED1	;Nhay khi p2.0 =0
	  SETB P0.0
		CLR P0.1
		RET
LED2: JNB P2.1,LED2	;nhay khi p2.1=0
		SETB P0.1
		CLR P0.0
		RET
		END
		
		;
		;
		;
		;
		;
		;Chuong trinh nay dung de dieu khien dao chieu
		;		.Voi dieu kien an vao sau do nha ra thi moi thi hanh.