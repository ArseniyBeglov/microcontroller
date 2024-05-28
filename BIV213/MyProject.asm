
_LCDsend4bit:
;MyProject.c,26 :: 		void LCDsend4bit(char buf){
;MyProject.c,27 :: 		Delay_ms(20);
	MOV R6, 33
	MOV R7, 107
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,28 :: 		P2 = buf;
	MOV P2+0, FARG_LCDsend4bit_buf+0
;MyProject.c,29 :: 		if(comFlag == 1){
	MOV A, _flags+0
	JNB 224, L_LCDsend4bit0
	NOP
;MyProject.c,30 :: 		LCD_RS = 0;
	CLR P1_2_bit+0
;MyProject.c,31 :: 		}
	SJMP L_LCDsend4bit1
L_LCDsend4bit0:
;MyProject.c,33 :: 		LCD_RS = 1;
	SETB P1_2_bit+0
;MyProject.c,34 :: 		}
L_LCDsend4bit1:
;MyProject.c,35 :: 		Delay_ms(2);
	MOV R6, 4
	MOV R7, 60
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,36 :: 		LCD_EN = 1;
	SETB P1_5_bit+0
;MyProject.c,37 :: 		Delay_ms(2);
	MOV R6, 4
	MOV R7, 60
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,38 :: 		LCD_EN = 0;
	CLR P1_5_bit+0
;MyProject.c,39 :: 		}
	RET
; end of _LCDsend4bit

_LCDsend:
;MyProject.c,41 :: 		void LCDsend(char buf){
;MyProject.c,42 :: 		LCDsend4bit(buf&0xf0);
	MOV A, FARG_LCDsend_buf+0
	ANL A, #240
	MOV FARG_LCDsend4bit_buf+0, A
	LCALL _LCDsend4bit+0
;MyProject.c,43 :: 		LCDsend4bit(buf<<4);
	MOV R0, #4
	MOV A, FARG_LCDsend_buf+0
	INC R0
	SJMP L__LCDsend51
L__LCDsend52:
	CLR C
	RLC A
L__LCDsend51:
	DJNZ R0, L__LCDsend52
	MOV FARG_LCDsend4bit_buf+0, A
	LCALL _LCDsend4bit+0
;MyProject.c,44 :: 		}
	RET
; end of _LCDsend

_LCDsendCom:
;MyProject.c,46 :: 		void LCDsendCom(char command){
;MyProject.c,47 :: 		comFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,48 :: 		LCDsend(command);
	MOV FARG_LCDsend_buf+0, FARG_LCDsendCom_command+0
	LCALL _LCDsend+0
;MyProject.c,49 :: 		}
	RET
; end of _LCDsendCom

_LCDclear:
;MyProject.c,51 :: 		void LCDclear()
;MyProject.c,53 :: 		cursorPos = 0;
	MOV _cursorPos+0, #0
;MyProject.c,54 :: 		LCDsendCom(CLEAR);
	MOV FARG_LCDsendCom_command+0, #1
	LCALL _LCDsendCom+0
;MyProject.c,55 :: 		}
	RET
; end of _LCDclear

_LCDsendSymb:
;MyProject.c,57 :: 		void LCDsendSymb(char symbol)
;MyProject.c,59 :: 		cursorPos++;
	INC _cursorPos+0
;MyProject.c,60 :: 		comFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,61 :: 		LCDsend(symbol);
	MOV FARG_LCDsend_buf+0, FARG_LCDsendSymb_symbol+0
	LCALL _LCDsend+0
;MyProject.c,62 :: 		}
	RET
; end of _LCDsendSymb

_LCDstart:
;MyProject.c,64 :: 		void LCDstart(){
;MyProject.c,65 :: 		LCDsendCom(0x28);  //
	MOV FARG_LCDsendCom_command+0, #40
	LCALL _LCDsendCom+0
;MyProject.c,66 :: 		LCDsendCom(0x0f);  //              ,
	MOV FARG_LCDsendCom_command+0, #15
	LCALL _LCDsendCom+0
;MyProject.c,67 :: 		LCDsendCom(FIRST_ROW);
	MOV FARG_LCDsendCom_command+0, #128
	LCALL _LCDsendCom+0
;MyProject.c,68 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,69 :: 		}
	RET
; end of _LCDstart

_LCDsendData:
;MyProject.c,71 :: 		void LCDsendData(char* symbols)
;MyProject.c,73 :: 		char iter = 0;
	MOV LCDsendData_iter_L0+0, #0
;MyProject.c,74 :: 		while(*(symbols+iter) != 0)
L_LCDsendData2:
	MOV A, FARG_LCDsendData_symbols+0
	ADD A, LCDsendData_iter_L0+0
	MOV R0, A
	MOV 1, @R0
	MOV A, R1
	JZ L_LCDsendData3
;MyProject.c,76 :: 		LCDsendSymb(*(symbols+iter));
	MOV A, FARG_LCDsendData_symbols+0
	ADD A, LCDsendData_iter_L0+0
	MOV R0, A
	MOV FARG_LCDsendSymb_symbol+0, @R0
	LCALL _LCDsendSymb+0
;MyProject.c,77 :: 		iter++;
	INC LCDsendData_iter_L0+0
;MyProject.c,78 :: 		if(cursorPos==16)
	MOV A, _cursorPos+0
	XRL A, #16
	JNZ L_LCDsendData4
;MyProject.c,79 :: 		LCDsendCom(SECOND_ROW);
	MOV FARG_LCDsendCom_command+0, #192
	LCALL _LCDsendCom+0
L_LCDsendData4:
;MyProject.c,80 :: 		}
	SJMP L_LCDsendData2
L_LCDsendData3:
;MyProject.c,81 :: 		}
	RET
; end of _LCDsendData

_LCDsendMsg:
;MyProject.c,83 :: 		void LCDsendMsg(char* msg)
;MyProject.c,85 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,86 :: 		LCDsendData(msg);
	MOV FARG_LCDsendData_symbols+0, FARG_LCDsendMsg_msg+0
	LCALL _LCDsendData+0
;MyProject.c,87 :: 		}
	RET
; end of _LCDsendMsg

_digToSymb:
;MyProject.c,89 :: 		void digToSymb(int value, char* symbols)
;MyProject.c,92 :: 		int rank = -1;
	MOV digToSymb_rank_L0+0, #255
	MOV digToSymb_rank_L0+1, #255
	MOV digToSymb_digit_L0+0, #0
	MOV digToSymb_digit_L0+1, #0
;MyProject.c,93 :: 		int digit = 0;
;MyProject.c,95 :: 		do{
L_digToSymb5:
;MyProject.c,96 :: 		digit = value % 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, FARG_digToSymb_value+0
	MOV R1, FARG_digToSymb_value+1
	LCALL _Div_16x16_S+0
	MOV R0, 4
	MOV R1, 5
	MOV digToSymb_digit_L0+0, 0
	MOV digToSymb_digit_L0+1, 1
;MyProject.c,97 :: 		value /= 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, FARG_digToSymb_value+0
	MOV R1, FARG_digToSymb_value+1
	LCALL _Div_16x16_S+0
	MOV FARG_digToSymb_value+0, 0
	MOV FARG_digToSymb_value+1, 1
;MyProject.c,98 :: 		rank++;
	MOV A, #1
	ADD A, digToSymb_rank_L0+0
	MOV digToSymb_rank_L0+0, A
	MOV A, #0
	ADDC A, digToSymb_rank_L0+1
	MOV digToSymb_rank_L0+1, A
;MyProject.c,99 :: 		temp[rank] = '0' + digit;
	MOV A, #digToSymb_temp_L0+0
	ADD A, digToSymb_rank_L0+0
	MOV R0, A
	MOV A, #48
	ADD A, digToSymb_digit_L0+0
	MOV R1, A
	MOV @R0, 1
;MyProject.c,100 :: 		}while(value>0);
	SETB C
	MOV A, FARG_digToSymb_value+0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R0, A
	MOV A, FARG_digToSymb_value+1
	XRL A, #128
	SUBB A, R0
	JNC L_digToSymb5
;MyProject.c,102 :: 		for(i = 0; rank >= 0; rank--, i++)
	MOV digToSymb_i_L0+0, #0
	MOV digToSymb_i_L0+1, #0
L_digToSymb8:
	CLR C
	MOV A, digToSymb_rank_L0+0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R0, A
	MOV A, digToSymb_rank_L0+1
	XRL A, #128
	SUBB A, R0
	JC L_digToSymb9
;MyProject.c,104 :: 		*(symbols+i) = temp[rank];
	MOV A, FARG_digToSymb_symbols+0
	ADD A, digToSymb_i_L0+0
	MOV R0, A
	MOV A, #digToSymb_temp_L0+0
	ADD A, digToSymb_rank_L0+0
	MOV R1, A
	MOV A, @R1
	MOV @R0, A
;MyProject.c,102 :: 		for(i = 0; rank >= 0; rank--, i++)
	CLR C
	MOV A, digToSymb_rank_L0+0
	SUBB A, #1
	MOV digToSymb_rank_L0+0, A
	MOV A, digToSymb_rank_L0+1
	SUBB A, #0
	MOV digToSymb_rank_L0+1, A
	MOV A, #1
	ADD A, digToSymb_i_L0+0
	MOV digToSymb_i_L0+0, A
	MOV A, #0
	ADDC A, digToSymb_i_L0+1
	MOV digToSymb_i_L0+1, A
;MyProject.c,105 :: 		}
	SJMP L_digToSymb8
L_digToSymb9:
;MyProject.c,106 :: 		*(symbols+i) = 0;
	MOV A, FARG_digToSymb_symbols+0
	ADD A, digToSymb_i_L0+0
	MOV R0, A
	MOV @R0, #0
;MyProject.c,107 :: 		}
	RET
; end of _digToSymb

_serialportInit:
;MyProject.c,109 :: 		void serialportInit()
;MyProject.c,111 :: 		SCON = 0b01010000;
	MOV SCON+0, #80
;MyProject.c,112 :: 		PCON = 0b10000000;
	MOV PCON+0, #128
;MyProject.c,113 :: 		}
	RET
; end of _serialportInit

_timer1Init:
;MyProject.c,115 :: 		void timer1Init()
;MyProject.c,117 :: 		TR1_bit = 0;
	CLR TR1_bit+0
;MyProject.c,118 :: 		TH1 = 0xFD;
	MOV TH1+0, #253
;MyProject.c,119 :: 		TMOD = TMOD&0b00001111;
	ANL TMOD+0, #15
;MyProject.c,120 :: 		TMOD = TMOD|0b00100000;
	ORL TMOD+0, #32
;MyProject.c,121 :: 		TR1_bit = 1;
	SETB TR1_bit+0
;MyProject.c,122 :: 		}
	RET
; end of _timer1Init

_insertNumber1:
;MyProject.c,124 :: 		int insertNumber1()
;MyProject.c,126 :: 		int value1 = 0;
	MOV 130, #?ICSinsertNumber1_value1_L0+0
	MOV 131, hi(#?ICSinsertNumber1_value1_L0+0)
	MOV R0, #insertNumber1_value1_L0+0
	MOV R1, #9
	LCALL ___CC2D+0
;MyProject.c,127 :: 		char val[]={'0','0','0',0};
;MyProject.c,128 :: 		char digitCount = 0;
;MyProject.c,129 :: 		char i = 0;
;MyProject.c,130 :: 		char btnNum = 0;
;MyProject.c,131 :: 		cicleFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,132 :: 		do {
L_insertNumber111:
;MyProject.c,134 :: 		kbFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,135 :: 		do{
L_insertNumber114:
;MyProject.c,136 :: 		Delay_ms(100);
	MOV R6, 163
	MOV R7, 30
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,137 :: 		if(i==3)
	MOV A, insertNumber1_i_L0+0
	XRL A, #3
	JNZ L_insertNumber117
;MyProject.c,138 :: 		i = 0;
	MOV insertNumber1_i_L0+0, #0
L_insertNumber117:
;MyProject.c,139 :: 		P0 = a[i];
	MOV A, #_a+0
	ADD A, insertNumber1_i_L0+0
	MOV R0, A
	MOV P0+0, @R0
;MyProject.c,140 :: 		i++;
	INC insertNumber1_i_L0+0
;MyProject.c,141 :: 		if(!P0_7_bit || !P0_6_bit || !P0_5_bit || !P0_4_bit)
	JNB P0_7_bit+0, L__insertNumber150
	NOP
	JNB P0_6_bit+0, L__insertNumber150
	NOP
	JNB P0_5_bit+0, L__insertNumber150
	NOP
	JNB P0_4_bit+0, L__insertNumber150
	NOP
	SJMP L_insertNumber120
L__insertNumber150:
;MyProject.c,142 :: 		kbFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
L_insertNumber120:
;MyProject.c,143 :: 		}while(!kbFlag);
	MOV A, _flags+0
	JNB 224, L_insertNumber114
	NOP
;MyProject.c,145 :: 		if(P0<=127)
	SETB C
	MOV A, P0+0
	SUBB A, #127
	JNC L_insertNumber121
;MyProject.c,146 :: 		btnNum=9;
	MOV insertNumber1_btnNum_L0+0, #9
	SJMP L_insertNumber122
L_insertNumber121:
;MyProject.c,147 :: 		else if(P0<=191)
	SETB C
	MOV A, P0+0
	SUBB A, #191
	JNC L_insertNumber123
;MyProject.c,148 :: 		btnNum=6;
	MOV insertNumber1_btnNum_L0+0, #6
	SJMP L_insertNumber124
L_insertNumber123:
;MyProject.c,149 :: 		else if(P0<=223)
	SETB C
	MOV A, P0+0
	SUBB A, #223
	JNC L_insertNumber125
;MyProject.c,150 :: 		btnNum=3;
	MOV insertNumber1_btnNum_L0+0, #3
	SJMP L_insertNumber126
L_insertNumber125:
;MyProject.c,151 :: 		else btnNum=0;
	MOV insertNumber1_btnNum_L0+0, #0
L_insertNumber126:
L_insertNumber124:
L_insertNumber122:
;MyProject.c,153 :: 		if(!P0_1_bit)
	JB P0_1_bit+0, L_insertNumber127
	NOP
;MyProject.c,154 :: 		btnNum+=1;
	INC insertNumber1_btnNum_L0+0
	SJMP L_insertNumber128
L_insertNumber127:
;MyProject.c,155 :: 		else if(!P0_2_bit)
	JB P0_2_bit+0, L_insertNumber129
	NOP
;MyProject.c,156 :: 		btnNum+=2;
	MOV A, insertNumber1_btnNum_L0+0
	ADD A, #2
	MOV insertNumber1_btnNum_L0+0, A
L_insertNumber129:
L_insertNumber128:
;MyProject.c,157 :: 		LCDsendSymb(btns[btnNum]);
	MOV A, #_btns+0
	ADD A, insertNumber1_btnNum_L0+0
	MOV R0, A
	MOV FARG_LCDsendSymb_symbol+0, @R0
	LCALL _LCDsendSymb+0
;MyProject.c,159 :: 		if(btnNum==9 && digitCount>1)
	MOV A, insertNumber1_btnNum_L0+0
	XRL A, #9
	JNZ L_insertNumber132
	SETB C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #1
	JC L_insertNumber132
L__insertNumber149:
;MyProject.c,161 :: 		digitCount--;
	DEC insertNumber1_digitCount_L0+0
;MyProject.c,162 :: 		value1 = value1/10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, insertNumber1_value1_L0+0
	MOV R1, insertNumber1_value1_L0+1
	LCALL _Div_16x16_S+0
	MOV insertNumber1_value1_L0+0, 0
	MOV insertNumber1_value1_L0+1, 1
;MyProject.c,163 :: 		}
	LJMP L_insertNumber133
L_insertNumber132:
;MyProject.c,164 :: 		else if(btnNum==11)
	MOV A, insertNumber1_btnNum_L0+0
	XRL A, #11
	JNZ L_insertNumber134
;MyProject.c,166 :: 		if(digitCount < 1)
	CLR C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #1
	JNC L_insertNumber135
;MyProject.c,167 :: 		LCDsendMsg(errorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
	SJMP L_insertNumber136
L_insertNumber135:
;MyProject.c,169 :: 		cicleFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
L_insertNumber136:
;MyProject.c,170 :: 		}
	SJMP L_insertNumber137
L_insertNumber134:
;MyProject.c,173 :: 		digitCount++;
	INC insertNumber1_digitCount_L0+0
;MyProject.c,174 :: 		if(digitCount>3)
	SETB C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #3
	JC L_insertNumber138
;MyProject.c,176 :: 		LCDsendMsg(errorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
;MyProject.c,177 :: 		digitCount = 0;
	MOV insertNumber1_digitCount_L0+0, #0
;MyProject.c,178 :: 		}
	SJMP L_insertNumber139
L_insertNumber138:
;MyProject.c,180 :: 		value1 = value1*10 + (btns[btnNum]-'0');
	MOV R0, insertNumber1_value1_L0+0
	MOV R1, insertNumber1_value1_L0+1
	MOV R4, #10
	MOV R5, #0
	LCALL _Mul_16x16+0
	PUSH 0
	MOV A, #_btns+0
	ADD A, insertNumber1_btnNum_L0+0
	MOV R0, A
	MOV FLOC__insertNumber1+0, 0
	MOV R0, FLOC__insertNumber1+0
	CLR C
	MOV A, @R0
	SUBB A, #48
	MOV R2, A
	CLR A
	SUBB A, #0
	MOV R3, A
	POP 0
	MOV A, R0
	ADD A, R2
	MOV insertNumber1_value1_L0+0, A
	MOV A, R1
	ADDC A, R3
	MOV insertNumber1_value1_L0+1, A
L_insertNumber139:
;MyProject.c,181 :: 		digToSymb(value1, *val);
	MOV FARG_digToSymb_value+0, insertNumber1_value1_L0+0
	MOV FARG_digToSymb_value+1, insertNumber1_value1_L0+1
	MOV FARG_digToSymb_symbols+0, insertNumber1_val_L0+0
	LCALL _digToSymb+0
;MyProject.c,183 :: 		}
L_insertNumber137:
L_insertNumber133:
;MyProject.c,185 :: 		} while(cicleFlag);
	MOV A, _flags+0
	JNB 224, #3
	NOP
	LJMP L_insertNumber111
;MyProject.c,186 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,187 :: 		P0 = 255;
	MOV P0+0, #255
;MyProject.c,188 :: 		return value1;
	MOV R0, insertNumber1_value1_L0+0
	MOV R1, insertNumber1_value1_L0+1
;MyProject.c,189 :: 		}
	RET
; end of _insertNumber1

_insertNumber2:
;MyProject.c,195 :: 		int insertNumber2()
;MyProject.c,196 :: 		{   timer1Init();
	LCALL _timer1Init+0
;MyProject.c,197 :: 		serialportInit();
	LCALL _serialportInit+0
;MyProject.c,198 :: 		while(1)
L_insertNumber240:
;MyProject.c,200 :: 		if(RI_bit)
	JNB RI_bit+0, L_insertNumber242
	NOP
;MyProject.c,202 :: 		RI_bit = 0;
	CLR RI_bit+0
;MyProject.c,203 :: 		P3 = SBUF;
	MOV P3+0, _UART1_Data_Ready+0
;MyProject.c,204 :: 		if(TI_bit)
	JNB TI_bit+0, L_insertNumber243
	NOP
;MyProject.c,206 :: 		TI_bit = 0;
	CLR TI_bit+0
;MyProject.c,207 :: 		SBUF = '0';
	MOV SBUF+0, #48
;MyProject.c,208 :: 		}
L_insertNumber243:
;MyProject.c,209 :: 		}
L_insertNumber242:
;MyProject.c,210 :: 		if(UART1_Data_Ready())
	LCALL _UART1_Data_Ready+0
	MOV A, R0
	JZ L_insertNumber244
;MyProject.c,211 :: 		LCDsendData(UART1_Read());
	LCALL _UART1_Read+0
	MOV FARG_LCDsendData_symbols+0, 0
	LCALL _LCDsendData+0
L_insertNumber244:
;MyProject.c,212 :: 		}
	SJMP L_insertNumber240
;MyProject.c,213 :: 		}
	RET
; end of _insertNumber2

_send:
;MyProject.c,218 :: 		void send(unsigned char *s)
;MyProject.c,220 :: 		while(*s){
L_send45:
	MOV R0, FARG_send_s+0
	MOV A, @R0
	JZ L_send46
;MyProject.c,221 :: 		SBUF = *s++;
	MOV R0, FARG_send_s+0
	MOV SBUF+0, @R0
	INC FARG_send_s+0
;MyProject.c,222 :: 		while(TI_bit==0);
L_send47:
	JB TI_bit+0, L_send48
	NOP
	SJMP L_send47
L_send48:
;MyProject.c,223 :: 		TI_bit=0;
	CLR TI_bit+0
;MyProject.c,224 :: 		}
	SJMP L_send45
L_send46:
;MyProject.c,226 :: 		}
	RET
; end of _send

_main:
	MOV SP+0, #128
;MyProject.c,231 :: 		void main() {
;MyProject.c,232 :: 		P1=255;
	MOV P1+0, #255
;MyProject.c,234 :: 		LCDsendCom(0x02);  //
	MOV FARG_LCDsendCom_command+0, #2
	LCALL _LCDsendCom+0
;MyProject.c,235 :: 		Delay_ms(20);      //
	MOV R6, 33
	MOV R7, 107
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,237 :: 		LCDstart();
	LCALL _LCDstart+0
;MyProject.c,239 :: 		LCDsendMsg("biba");
	MOV FARG_LCDsendMsg_msg+0, #?lstr1_MyProject+0
	LCALL _LCDsendMsg+0
;MyProject.c,245 :: 		UART1_Init(9600);               // Initialize UART module at 4800 bps
	ORL PCON+0, #128
	MOV TH1+0, #251
	MOV TL1+0, #251
	LCALL _UART1_Init+0
;MyProject.c,246 :: 		Delay_ms(200);                  // Wait for UART module to stabilize
	MOV R5, 2
	MOV R6, 69
	MOV R7, 61
	DJNZ R7, 
	DJNZ R6, 
	DJNZ R5, 
;MyProject.c,248 :: 		UART1_Write_Text("Start");
	MOV FARG_UART1_Write_Text_uart_text+0, #?lstr2_MyProject+0
	LCALL _UART1_Write_Text+0
;MyProject.c,252 :: 		}
	SJMP #254
; end of _main
