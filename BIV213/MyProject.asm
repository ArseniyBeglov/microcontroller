
_LCDsend4bit:
;MyProject.c,40 :: 		void LCDsend4bit(char buf){
;MyProject.c,41 :: 		P2 = buf;
	MOV P2+0, FARG_LCDsend4bit_buf+0
;MyProject.c,42 :: 		if(comFlag == 1){
	MOV A, _flags+0
	JNB 224, L_LCDsend4bit0
	NOP
;MyProject.c,43 :: 		LCD_RS = 0;
	CLR P1_2_bit+0
;MyProject.c,44 :: 		}
	SJMP L_LCDsend4bit1
L_LCDsend4bit0:
;MyProject.c,46 :: 		LCD_RS = 1;
	SETB P1_2_bit+0
;MyProject.c,47 :: 		}
L_LCDsend4bit1:
;MyProject.c,48 :: 		LCD_EN = 1;
	SETB P1_5_bit+0
;MyProject.c,49 :: 		LCD_EN = 0;
	CLR P1_5_bit+0
;MyProject.c,50 :: 		}
	RET
; end of _LCDsend4bit

_LCDsend:
;MyProject.c,52 :: 		void LCDsend(char buf){
;MyProject.c,53 :: 		Delay_ms(1);
	MOV R6, 2
	MOV R7, 157
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,54 :: 		LCDsend4bit(buf&0xf0);
	MOV A, FARG_LCDsend_buf+0
	ANL A, #240
	MOV FARG_LCDsend4bit_buf+0, A
	LCALL _LCDsend4bit+0
;MyProject.c,55 :: 		LCDsend4bit(buf<<4);
	MOV R0, #4
	MOV A, FARG_LCDsend_buf+0
	INC R0
	SJMP L__LCDsend83
L__LCDsend84:
	CLR C
	RLC A
L__LCDsend83:
	DJNZ R0, L__LCDsend84
	MOV FARG_LCDsend4bit_buf+0, A
	LCALL _LCDsend4bit+0
;MyProject.c,56 :: 		}
	RET
; end of _LCDsend

_LCDSendCom:
;MyProject.c,58 :: 		void LCDSendCom(char command){
;MyProject.c,59 :: 		comFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,60 :: 		LCDsend(command);
	MOV FARG_LCDsend_buf+0, FARG_LCDSendCom_command+0
	LCALL _LCDsend+0
;MyProject.c,61 :: 		}
	RET
; end of _LCDSendCom

_LCDclear:
;MyProject.c,63 :: 		void LCDclear()
;MyProject.c,66 :: 		LCDSendCom(CLEAR);
	MOV FARG_LCDSendCom_command+0, #1
	LCALL _LCDSendCom+0
;MyProject.c,67 :: 		}
	RET
; end of _LCDclear

_LCDsendSymb:
;MyProject.c,69 :: 		void LCDsendSymb(char symbol)
;MyProject.c,74 :: 		comFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,75 :: 		LCDsend(symbol);
	MOV FARG_LCDsend_buf+0, FARG_LCDsendSymb_symbol+0
	LCALL _LCDsend+0
;MyProject.c,76 :: 		}
	RET
; end of _LCDsendSymb

_LCDstart:
;MyProject.c,78 :: 		void LCDstart(){
;MyProject.c,79 :: 		LCDSendCom(0x02);  // 4-х битный режим
	MOV FARG_LCDSendCom_command+0, #2
	LCALL _LCDSendCom+0
;MyProject.c,80 :: 		LCDSendCom(0x28);  //16*2 в 4-х битном режиме
	MOV FARG_LCDSendCom_command+0, #40
	LCALL _LCDSendCom+0
;MyProject.c,81 :: 		LCDSendCom(0x0f);  //дисплей включен, курсор мигает
	MOV FARG_LCDSendCom_command+0, #15
	LCALL _LCDSendCom+0
;MyProject.c,82 :: 		LCDSendCom(FIRST_ROW);
	MOV FARG_LCDSendCom_command+0, #128
	LCALL _LCDSendCom+0
;MyProject.c,83 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,84 :: 		}
	RET
; end of _LCDstart

_LCDsendData:
;MyProject.c,86 :: 		void LCDsendData(char* symbols)
;MyProject.c,88 :: 		char iter = 0;
	MOV LCDsendData_iter_L0+0, #0
;MyProject.c,89 :: 		while(*(symbols+iter) != 0)
L_LCDsendData2:
	MOV A, FARG_LCDsendData_symbols+0
	ADD A, LCDsendData_iter_L0+0
	MOV R0, A
	MOV 1, @R0
	MOV A, R1
	JZ L_LCDsendData3
;MyProject.c,91 :: 		LCDsendSymb(*(symbols+iter));
	MOV A, FARG_LCDsendData_symbols+0
	ADD A, LCDsendData_iter_L0+0
	MOV R0, A
	MOV FARG_LCDsendSymb_symbol+0, @R0
	LCALL _LCDsendSymb+0
;MyProject.c,92 :: 		iter++;
	INC LCDsendData_iter_L0+0
;MyProject.c,93 :: 		}
	SJMP L_LCDsendData2
L_LCDsendData3:
;MyProject.c,94 :: 		}
	RET
; end of _LCDsendData

_numToSymb:
;MyProject.c,96 :: 		void numToSymb(int number, char* symbols)
;MyProject.c,98 :: 		char* iter = symbols;
	MOV numToSymb_iter_L0+0, FARG_numToSymb_symbols+0
;MyProject.c,100 :: 		int value = number;
	MOV numToSymb_value_L0+0, FARG_numToSymb_number+0
	MOV numToSymb_value_L0+1, FARG_numToSymb_number+1
;MyProject.c,101 :: 		int rank = -1;
	MOV numToSymb_rank_L0+0, #255
	MOV numToSymb_rank_L0+1, #255
	MOV numToSymb_digit_L0+0, #0
	MOV numToSymb_digit_L0+1, #0
;MyProject.c,102 :: 		int digit = 0;
;MyProject.c,104 :: 		do{
L_numToSymb4:
;MyProject.c,105 :: 		digit = value % 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, numToSymb_value_L0+0
	MOV R1, numToSymb_value_L0+1
	LCALL _Div_16x16_S+0
	MOV R0, 4
	MOV R1, 5
	MOV numToSymb_digit_L0+0, 0
	MOV numToSymb_digit_L0+1, 1
;MyProject.c,106 :: 		value /= 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, numToSymb_value_L0+0
	MOV R1, numToSymb_value_L0+1
	LCALL _Div_16x16_S+0
	MOV numToSymb_value_L0+0, 0
	MOV numToSymb_value_L0+1, 1
;MyProject.c,107 :: 		rank++;
	MOV A, #1
	ADD A, numToSymb_rank_L0+0
	MOV numToSymb_rank_L0+0, A
	MOV A, #0
	ADDC A, numToSymb_rank_L0+1
	MOV numToSymb_rank_L0+1, A
;MyProject.c,108 :: 		temp[rank] = digits[digit];
	MOV A, #numToSymb_temp_L0+0
	ADD A, numToSymb_rank_L0+0
	MOV R0, A
	MOV A, #_digits+0
	ADD A, numToSymb_digit_L0+0
	MOV R1, A
	MOV A, @R1
	MOV @R0, A
;MyProject.c,110 :: 		}while(value>0);
	SETB C
	MOV A, numToSymb_value_L0+0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R0, A
	MOV A, numToSymb_value_L0+1
	XRL A, #128
	SUBB A, R0
	JNC L_numToSymb4
;MyProject.c,112 :: 		for(i = 0; rank >= 0; rank--, i++)
	MOV numToSymb_i_L0+0, #0
	MOV numToSymb_i_L0+1, #0
L_numToSymb7:
	CLR C
	MOV A, numToSymb_rank_L0+0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R0, A
	MOV A, numToSymb_rank_L0+1
	XRL A, #128
	SUBB A, R0
	JC L_numToSymb8
;MyProject.c,114 :: 		temp1[i] = temp[rank];
	MOV A, #numToSymb_temp1_L0+0
	ADD A, numToSymb_i_L0+0
	MOV R0, A
	MOV A, #numToSymb_temp_L0+0
	ADD A, numToSymb_rank_L0+0
	MOV R1, A
	MOV A, @R1
	MOV @R0, A
;MyProject.c,115 :: 		*iter = temp[rank];
	MOV A, #numToSymb_temp_L0+0
	ADD A, numToSymb_rank_L0+0
	MOV R0, A
	MOV R1, numToSymb_iter_L0+0
	MOV A, @R0
	MOV @R1, A
;MyProject.c,116 :: 		iter++;
	INC numToSymb_iter_L0+0
;MyProject.c,112 :: 		for(i = 0; rank >= 0; rank--, i++)
	CLR C
	MOV A, numToSymb_rank_L0+0
	SUBB A, #1
	MOV numToSymb_rank_L0+0, A
	MOV A, numToSymb_rank_L0+1
	SUBB A, #0
	MOV numToSymb_rank_L0+1, A
	MOV A, #1
	ADD A, numToSymb_i_L0+0
	MOV numToSymb_i_L0+0, A
	MOV A, #0
	ADDC A, numToSymb_i_L0+1
	MOV numToSymb_i_L0+1, A
;MyProject.c,117 :: 		}
	SJMP L_numToSymb7
L_numToSymb8:
;MyProject.c,118 :: 		temp1[i] = 0;
	MOV A, #numToSymb_temp1_L0+0
	ADD A, numToSymb_i_L0+0
	MOV R0, A
	MOV @R0, #0
;MyProject.c,119 :: 		*iter = 0;
	MOV R0, numToSymb_iter_L0+0
	MOV @R0, #0
;MyProject.c,120 :: 		}
	RET
; end of _numToSymb

_LCDsendMsg:
;MyProject.c,122 :: 		void LCDsendMsg(char* msg)
;MyProject.c,124 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,125 :: 		LCDsendData(msg);
	MOV FARG_LCDsendData_symbols+0, FARG_LCDsendMsg_msg+0
	LCALL _LCDsendData+0
;MyProject.c,126 :: 		}
	RET
; end of _LCDsendMsg

_insertNumber1:
;MyProject.c,128 :: 		int insertNumber1()
;MyProject.c,130 :: 		int value1 = 0;
	MOV insertNumber1_value1_L0+0, #0
	MOV insertNumber1_value1_L0+1, #0
	MOV insertNumber1_digitCount_L0+0, #0
	MOV insertNumber1_i_L0+0, #0
	MOV insertNumber1_btnNum_L0+0, #0
;MyProject.c,131 :: 		char digitCount = 0;
;MyProject.c,132 :: 		char i = 0;
;MyProject.c,133 :: 		char btnNum = 0;
;MyProject.c,134 :: 		cicleFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,135 :: 		do {
L_insertNumber110:
;MyProject.c,136 :: 		if(P0_7_bit && P0_6_bit && P0_5_bit && P0_4_bit){
	JB P0_7_bit+0, #3
	NOP
	LJMP L_insertNumber115
	JB P0_6_bit+0, #3
	NOP
	LJMP L_insertNumber115
	JB P0_5_bit+0, #3
	NOP
	LJMP L_insertNumber115
	JB P0_4_bit+0, #3
	NOP
	LJMP L_insertNumber115
L__insertNumber178:
;MyProject.c,137 :: 		kbFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,138 :: 		do{
L_insertNumber116:
;MyProject.c,139 :: 		if(i==3)
	MOV A, insertNumber1_i_L0+0
	XRL A, #3
	JNZ L_insertNumber119
;MyProject.c,140 :: 		i = 0;
	MOV insertNumber1_i_L0+0, #0
L_insertNumber119:
;MyProject.c,141 :: 		P0 = a[i];
	MOV A, #_a+0
	ADD A, insertNumber1_i_L0+0
	MOV R0, A
	MOV P0+0, @R0
;MyProject.c,142 :: 		i++;
	INC insertNumber1_i_L0+0
;MyProject.c,143 :: 		if(!P0_7_bit || !P0_6_bit || !P0_5_bit || !P0_4_bit)
	JNB P0_7_bit+0, L__insertNumber177
	NOP
	JNB P0_6_bit+0, L__insertNumber177
	NOP
	JNB P0_5_bit+0, L__insertNumber177
	NOP
	JNB P0_4_bit+0, L__insertNumber177
	NOP
	SJMP L_insertNumber122
L__insertNumber177:
;MyProject.c,144 :: 		kbFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
L_insertNumber122:
;MyProject.c,145 :: 		}while(!kbFlag);
	MOV A, _flags+0
	JNB 224, L_insertNumber116
	NOP
;MyProject.c,147 :: 		if(P0<=127)
	SETB C
	MOV A, P0+0
	SUBB A, #127
	JNC L_insertNumber123
;MyProject.c,148 :: 		btnNum=9;
	MOV insertNumber1_btnNum_L0+0, #9
	SJMP L_insertNumber124
L_insertNumber123:
;MyProject.c,149 :: 		else if(P0<=191)
	SETB C
	MOV A, P0+0
	SUBB A, #191
	JNC L_insertNumber125
;MyProject.c,150 :: 		btnNum=6;
	MOV insertNumber1_btnNum_L0+0, #6
	SJMP L_insertNumber126
L_insertNumber125:
;MyProject.c,151 :: 		else if(P0<=223)
	SETB C
	MOV A, P0+0
	SUBB A, #223
	JNC L_insertNumber127
;MyProject.c,152 :: 		btnNum=3;
	MOV insertNumber1_btnNum_L0+0, #3
	SJMP L_insertNumber128
L_insertNumber127:
;MyProject.c,153 :: 		else btnNum=0;
	MOV insertNumber1_btnNum_L0+0, #0
L_insertNumber128:
L_insertNumber126:
L_insertNumber124:
;MyProject.c,155 :: 		if(!P0_1_bit)
	JB P0_1_bit+0, L_insertNumber129
	NOP
;MyProject.c,156 :: 		btnNum+=1;
	INC insertNumber1_btnNum_L0+0
	SJMP L_insertNumber130
L_insertNumber129:
;MyProject.c,157 :: 		else if(!P0_2_bit)
	JB P0_2_bit+0, L_insertNumber131
	NOP
;MyProject.c,158 :: 		btnNum+=2;
	MOV A, insertNumber1_btnNum_L0+0
	ADD A, #2
	MOV insertNumber1_btnNum_L0+0, A
L_insertNumber131:
L_insertNumber130:
;MyProject.c,160 :: 		if(btnNum==9 && digitCount>1)
	MOV A, insertNumber1_btnNum_L0+0
	XRL A, #9
	JNZ L_insertNumber134
	SETB C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #1
	JC L_insertNumber134
L__insertNumber176:
;MyProject.c,162 :: 		digitCount--;
	DEC insertNumber1_digitCount_L0+0
;MyProject.c,163 :: 		value1 = value1/10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, insertNumber1_value1_L0+0
	MOV R1, insertNumber1_value1_L0+1
	LCALL _Div_16x16_S+0
	MOV insertNumber1_value1_L0+0, 0
	MOV insertNumber1_value1_L0+1, 1
;MyProject.c,164 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,165 :: 		numToSymb(value1, num1Symb);
	MOV FARG_numToSymb_number+0, insertNumber1_value1_L0+0
	MOV FARG_numToSymb_number+1, insertNumber1_value1_L0+1
	MOV FARG_numToSymb_symbols+0, #_num1Symb+0
	LCALL _numToSymb+0
;MyProject.c,166 :: 		LCDsendData(num1Symb);
	MOV FARG_LCDsendData_symbols+0, #_num1Symb+0
	LCALL _LCDsendData+0
;MyProject.c,167 :: 		}
	LJMP L_insertNumber135
L_insertNumber134:
;MyProject.c,168 :: 		else if(btnNum==11)
	MOV A, insertNumber1_btnNum_L0+0
	XRL A, #11
	JNZ L_insertNumber136
;MyProject.c,170 :: 		if(digitCount < 1){
	CLR C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #1
	JNC L_insertNumber137
;MyProject.c,171 :: 		LCDsendMsg(errorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
;MyProject.c,172 :: 		}
	SJMP L_insertNumber138
L_insertNumber137:
;MyProject.c,174 :: 		cicleFlag = 0;
	CLR C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
L_insertNumber138:
;MyProject.c,175 :: 		}
	SJMP L_insertNumber139
L_insertNumber136:
;MyProject.c,178 :: 		digitCount++;
	INC insertNumber1_digitCount_L0+0
;MyProject.c,179 :: 		if(digitCount>3){
	SETB C
	MOV A, insertNumber1_digitCount_L0+0
	SUBB A, #3
	JC L_insertNumber140
;MyProject.c,180 :: 		LCDsendMsg(errorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
;MyProject.c,181 :: 		digitCount = 0;
	MOV insertNumber1_digitCount_L0+0, #0
;MyProject.c,182 :: 		value1 = 0;
	MOV insertNumber1_value1_L0+0, #0
	MOV insertNumber1_value1_L0+1, #0
;MyProject.c,183 :: 		}
	SJMP L_insertNumber141
L_insertNumber140:
;MyProject.c,185 :: 		value1 = value1*10 + (btns[btnNum]-'0');
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
;MyProject.c,186 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,187 :: 		numToSymb(value1, num1Symb);
	MOV FARG_numToSymb_number+0, insertNumber1_value1_L0+0
	MOV FARG_numToSymb_number+1, insertNumber1_value1_L0+1
	MOV FARG_numToSymb_symbols+0, #_num1Symb+0
	LCALL _numToSymb+0
;MyProject.c,188 :: 		LCDsendData(num1Symb);
	MOV FARG_LCDsendData_symbols+0, #_num1Symb+0
	LCALL _LCDsendData+0
;MyProject.c,189 :: 		}
L_insertNumber141:
;MyProject.c,190 :: 		}
L_insertNumber139:
L_insertNumber135:
;MyProject.c,191 :: 		}
L_insertNumber115:
;MyProject.c,192 :: 		} while(cicleFlag);
	MOV A, _flags+0
	JNB 224, #3
	NOP
	LJMP L_insertNumber110
;MyProject.c,193 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,194 :: 		P0 = 255;
	MOV P0+0, #255
;MyProject.c,195 :: 		return value1;
	MOV R0, insertNumber1_value1_L0+0
	MOV R1, insertNumber1_value1_L0+1
;MyProject.c,196 :: 		}
	RET
; end of _insertNumber1

_UART1start:
;MyProject.c,198 :: 		void UART1start(){
;MyProject.c,199 :: 		TMOD = 0x20;
	MOV TMOD+0, #32
;MyProject.c,200 :: 		TH1 = 0xF5;
	MOV TH1+0, #245
;MyProject.c,201 :: 		SCON = 0x50;
	MOV SCON+0, #80
;MyProject.c,202 :: 		TR1_bit = 1;
	SETB TR1_bit+0
;MyProject.c,203 :: 		}
	RET
; end of _UART1start

_UART1read:
;MyProject.c,205 :: 		char UART1read(){
;MyProject.c,206 :: 		return SBUF;
	MOV R0, SBUF+0
;MyProject.c,207 :: 		}
	RET
; end of _UART1read

_insertUART:
;MyProject.c,209 :: 		int insertUART(char digCount)
;MyProject.c,211 :: 		char digitCount = 0;
	MOV insertUART_digitCount_L0+0, #0
	MOV insertUART_value_L0+0, #0
	MOV insertUART_value_L0+1, #0
;MyProject.c,214 :: 		int value=0;
;MyProject.c,215 :: 		Delay_ms(100);
	MOV R6, 163
	MOV R7, 30
	DJNZ R7, 
	DJNZ R6, 
	NOP
;MyProject.c,217 :: 		while(1){
L_insertUART42:
;MyProject.c,218 :: 		cicleFlag = 1;
	SETB C
	MOV A, _flags+0
	MOV #224, C
	MOV _flags+0, A
;MyProject.c,219 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,220 :: 		while (cicleFlag) {
L_insertUART44:
	MOV A, _flags+0
	JNB 224, L_insertUART45
	NOP
;MyProject.c,221 :: 		if (RI_bit) {
	JNB RI_bit+0, L_insertUART46
	NOP
;MyProject.c,222 :: 		uartRd = UART1read();
	LCALL _UART1read+0
	MOV insertUART_uartRd_L0+0, 0
;MyProject.c,223 :: 		digit = uartRd - '0';
	CLR C
	MOV A, R0
	SUBB A, #48
	MOV R1, A
	MOV insertUART_digit_L0+0, 1
;MyProject.c,224 :: 		if(digit >=0 && digit <=9){
	CLR C
	MOV A, R1
	SUBB A, #0
	JC L_insertUART49
	SETB C
	MOV A, insertUART_digit_L0+0
	SUBB A, #9
	JNC L_insertUART49
L__insertUART79:
;MyProject.c,225 :: 		digitCount++;
	INC insertUART_digitCount_L0+0
;MyProject.c,226 :: 		LCDsendSymb(uartRd);
	MOV FARG_LCDsendSymb_symbol+0, insertUART_uartRd_L0+0
	LCALL _LCDsendSymb+0
;MyProject.c,227 :: 		if(digitCount > digCount){
	SETB C
	MOV A, insertUART_digitCount_L0+0
	SUBB A, FARG_insertUART_digCount+0
	JC L_insertUART50
;MyProject.c,228 :: 		LCDsendMsg(ErrorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
;MyProject.c,229 :: 		digitCount = 0;
	MOV insertUART_digitCount_L0+0, #0
;MyProject.c,230 :: 		}
L_insertUART50:
;MyProject.c,231 :: 		value = value * 10 + digit;
	MOV R0, insertUART_value_L0+0
	MOV R1, insertUART_value_L0+1
	MOV R4, #10
	MOV R5, #0
	LCALL _Mul_16x16+0
	MOV A, insertUART_digit_L0+0
	ADD A, R0
	MOV insertUART_value_L0+0, A
	CLR A
	ADDC A, R1
	MOV insertUART_value_L0+1, A
;MyProject.c,232 :: 		}
	SJMP L_insertUART51
L_insertUART49:
;MyProject.c,233 :: 		else if(uartRd == ' '){
	MOV A, insertUART_uartRd_L0+0
	XRL A, #32
	JNZ L_insertUART52
;MyProject.c,235 :: 		}
	SJMP L_insertUART53
L_insertUART52:
;MyProject.c,237 :: 		LCDsendMsg(ErrorMsg);
	MOV FARG_LCDsendMsg_msg+0, #_errorMsg+0
	LCALL _LCDsendMsg+0
;MyProject.c,238 :: 		}
L_insertUART53:
L_insertUART51:
;MyProject.c,239 :: 		RI_bit=0;
	CLR RI_bit+0
;MyProject.c,240 :: 		}
L_insertUART46:
;MyProject.c,241 :: 		}
	SJMP L_insertUART44
L_insertUART45:
;MyProject.c,242 :: 		}
	LJMP L_insertUART42
;MyProject.c,244 :: 		}
	RET
; end of _insertUART

_LCDSendTimerStart:
;MyProject.c,246 :: 		void LCDSendTimerStart(){
;MyProject.c,247 :: 		int temp = number1;
	MOV LCDSendTimerStart_temp_L0+0, _number1+0
	MOV LCDSendTimerStart_temp_L0+1, _number1+1
;MyProject.c,248 :: 		LCDclear();
	LCALL _LCDclear+0
;MyProject.c,249 :: 		LCDSendCom(FIRST_ROW);
	MOV FARG_LCDSendCom_command+0, #128
	LCALL _LCDSendCom+0
;MyProject.c,250 :: 		LCDSendData(num1Symb);
	MOV FARG_LCDsendData_symbols+0, #_num1Symb+0
	LCALL _LCDsendData+0
;MyProject.c,251 :: 		LCDSendSymb(' ');
	MOV FARG_LCDsendSymb_symbol+0, #32
	LCALL _LCDsendSymb+0
;MyProject.c,252 :: 		LCDSendData(num2Symb);
	MOV FARG_LCDsendData_symbols+0, #_num2Symb+0
	LCALL _LCDsendData+0
;MyProject.c,253 :: 		LCDSendSymb(' ');
	MOV FARG_LCDsendSymb_symbol+0, #32
	LCALL _LCDsendSymb+0
;MyProject.c,254 :: 		LCDSendData(timerStepSymb);
	MOV FARG_LCDsendData_symbols+0, #_timerStepSymb+0
	LCALL _LCDsendData+0
;MyProject.c,255 :: 		LCDSendCom(SECOND_ROW);
	MOV FARG_LCDSendCom_command+0, #192
	LCALL _LCDSendCom+0
;MyProject.c,256 :: 		LCDSendData("   ");
	MOV FARG_LCDsendData_symbols+0, #?lstr1_MyProject+0
	LCALL _LCDsendData+0
;MyProject.c,257 :: 		LCDSendData(timerValSymb);
	MOV FARG_LCDsendData_symbols+0, #_timerValSymb+0
	LCALL _LCDsendData+0
;MyProject.c,258 :: 		timerValRank = 0;
	MOV _timerValRank+0, #0
;MyProject.c,259 :: 		do{
L_LCDSendTimerStart54:
;MyProject.c,260 :: 		temp = temp / 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, LCDSendTimerStart_temp_L0+0
	MOV R1, LCDSendTimerStart_temp_L0+1
	LCALL _Div_16x16_S+0
	MOV LCDSendTimerStart_temp_L0+0, 0
	MOV LCDSendTimerStart_temp_L0+1, 1
;MyProject.c,261 :: 		timerValRank++;
	INC _timerValRank+0
;MyProject.c,262 :: 		}while(temp > 0);
	SETB C
	MOV A, R0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R2, A
	MOV A, R1
	XRL A, #128
	SUBB A, R2
	JNC L_LCDSendTimerStart54
;MyProject.c,263 :: 		LCDSendCom(0x0c);  // отключение курсора
	MOV FARG_LCDSendCom_command+0, #12
	LCALL _LCDSendCom+0
;MyProject.c,264 :: 		}
	RET
; end of _LCDSendTimerStart

_LCDSendTimerValue:
;MyProject.c,266 :: 		void LCDSendTimerValue(int timerVal){
;MyProject.c,268 :: 		temp = timerVal;
	MOV LCDSendTimerValue_temp_L0+0, FARG_LCDSendTimerValue_timerVal+0
	MOV LCDSendTimerValue_temp_L0+1, FARG_LCDSendTimerValue_timerVal+1
;MyProject.c,269 :: 		if((timerVal == 10 && timerValRank == 1) || (timerVal == 100 && timerValRank == 2)){
	MOV A, #10
	XRL A, FARG_LCDSendTimerValue_timerVal+0
	JNZ L__LCDSendTimerValue85
	MOV A, #0
	XRL A, FARG_LCDSendTimerValue_timerVal+1
L__LCDSendTimerValue85:
	JNZ L__LCDSendTimerValue82
	MOV A, _timerValRank+0
	XRL A, #1
	JNZ L__LCDSendTimerValue82
	SJMP L__LCDSendTimerValue80
L__LCDSendTimerValue82:
	MOV A, #100
	XRL A, FARG_LCDSendTimerValue_timerVal+0
	JNZ L__LCDSendTimerValue86
	MOV A, #0
	XRL A, FARG_LCDSendTimerValue_timerVal+1
L__LCDSendTimerValue86:
	JNZ L__LCDSendTimerValue81
	MOV A, _timerValRank+0
	XRL A, #2
	JNZ L__LCDSendTimerValue81
	SJMP L__LCDSendTimerValue80
L__LCDSendTimerValue81:
	SJMP L_LCDSendTimerValue63
L__LCDSendTimerValue80:
;MyProject.c,270 :: 		timerValRank++;
	INC _timerValRank+0
;MyProject.c,271 :: 		}
L_LCDSendTimerValue63:
;MyProject.c,272 :: 		for(i=timerValRank;i>0;i--){
	MOV LCDSendTimerValue_i_L0+0, _timerValRank+0
	CLR A
	MOV LCDSendTimerValue_i_L0+1, A
L_LCDSendTimerValue64:
	SETB C
	MOV A, LCDSendTimerValue_i_L0+0
	SUBB A, #0
	MOV A, #0
	XRL A, #128
	MOV R0, A
	MOV A, LCDSendTimerValue_i_L0+1
	XRL A, #128
	SUBB A, R0
	JC L_LCDSendTimerValue65
;MyProject.c,273 :: 		temp1 = temp % 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, LCDSendTimerValue_temp_L0+0
	MOV R1, LCDSendTimerValue_temp_L0+1
	LCALL _Div_16x16_S+0
	MOV R0, 4
	MOV R1, 5
	MOV LCDSendTimerValue_temp1_L0+0, 0
	MOV LCDSendTimerValue_temp1_L0+1, 1
;MyProject.c,274 :: 		LCDSendCom(194+i);  // Перевод курсора на изменившийся символ отсчета таймера
	MOV A, #194
	ADD A, LCDSendTimerValue_i_L0+0
	MOV FARG_LCDSendCom_command+0, A
	LCALL _LCDSendCom+0
;MyProject.c,275 :: 		LCDSendSymb(digits[temp1]);
	MOV A, #_digits+0
	ADD A, LCDSendTimerValue_temp1_L0+0
	MOV R0, A
	MOV FARG_LCDsendSymb_symbol+0, @R0
	LCALL _LCDsendSymb+0
;MyProject.c,276 :: 		if(temp1 != 0){
	MOV A, LCDSendTimerValue_temp1_L0+0
	ORL A, LCDSendTimerValue_temp1_L0+1
	JZ L_LCDSendTimerValue67
;MyProject.c,277 :: 		return;
	RET
;MyProject.c,278 :: 		}
L_LCDSendTimerValue67:
;MyProject.c,279 :: 		temp = temp / 10;
	MOV R4, #10
	MOV R5, #0
	MOV R0, LCDSendTimerValue_temp_L0+0
	MOV R1, LCDSendTimerValue_temp_L0+1
	LCALL _Div_16x16_S+0
	MOV LCDSendTimerValue_temp_L0+0, 0
	MOV LCDSendTimerValue_temp_L0+1, 1
;MyProject.c,272 :: 		for(i=timerValRank;i>0;i--){
	CLR C
	MOV A, LCDSendTimerValue_i_L0+0
	SUBB A, #1
	MOV LCDSendTimerValue_i_L0+0, A
	MOV A, LCDSendTimerValue_i_L0+1
	SUBB A, #0
	MOV LCDSendTimerValue_i_L0+1, A
;MyProject.c,280 :: 		}
	SJMP L_LCDSendTimerValue64
L_LCDSendTimerValue65:
;MyProject.c,281 :: 		}
	RET
; end of _LCDSendTimerValue

_timer0Init:
;MyProject.c,283 :: 		void timer0Init(){       //int не может быть больше 32768, берем long
;MyProject.c,285 :: 		TMOD = TMOD | 0b00000001;
	ORL TMOD+0, #1
;MyProject.c,286 :: 		temp = timerStep * 1000L;
	MOV R0, _timerStep+0
	MOV R1, _timerStep+1
	MOV A, _timerStep+1
	RLC A
	CLR A
	SUBB A, 224
	MOV R2, A
	MOV R3, A
	MOV R4, #232
	MOV R5, #3
	MOV R6, #0
	MOV 7, #0
	LCALL _Mul_32x32+0
	MOV timer0Init_temp_L0+0, 0
	MOV timer0Init_temp_L0+1, 1
	MOV timer0Init_temp_L0+2, 2
	MOV timer0Init_temp_L0+3, 3
;MyProject.c,287 :: 		timer0Count = temp / 65536L;
	MOV R0, 2
	MOV R1, 3
	MOV A, R3
	RLC A
	CLR A
	SUBB A, 224
	MOV R2, A
	MOV R3, A
	MOV _timer0Count+0, 0
	MOV _timer0Count+1, 1
;MyProject.c,288 :: 		temp1 = temp - 65536 * (long)timer0Count;
	MOV A, R1
	RLC A
	CLR A
	SUBB A, 224
	MOV R2, A
	MOV R3, A
	MOV R3, 1
	MOV R2, 0
	MOV R0, #0
	MOV R1, #0
	CLR C
	MOV A, timer0Init_temp_L0+0
	SUBB A, R0
	MOV R0, A
	MOV A, timer0Init_temp_L0+1
	SUBB A, R1
	MOV R1, A
	MOV A, timer0Init_temp_L0+2
	SUBB A, R2
	MOV R2, A
	MOV A, timer0Init_temp_L0+3
	SUBB A, R3
	MOV R3, A
;MyProject.c,289 :: 		temp = 65535 - temp1;
	CLR C
	MOV A, #255
	SUBB A, R0
	MOV R0, A
	MOV A, #255
	SUBB A, R1
	MOV R1, A
	MOV A, #0
	SUBB A, R2
	MOV R2, A
	MOV A, #0
	SUBB A, R3
	MOV R3, A
	MOV timer0Init_temp_L0+0, 0
	MOV timer0Init_temp_L0+1, 1
	MOV timer0Init_temp_L0+2, 2
	MOV timer0Init_temp_L0+3, 3
;MyProject.c,290 :: 		THstart = temp / 256;
	MOV R0, 1
	MOV R1, 2
	MOV R2, 3
	MOV A, R3
	RLC A
	CLR A
	SUBB A, 224
	MOV R3, A
	MOV _THstart+0, 0
;MyProject.c,291 :: 		TLstart = temp % 256;
	MOV R4, #0
	MOV R5, #1
	MOV R6, #0
	MOV 7, #0
	MOV R0, timer0Init_temp_L0+0
	MOV R1, timer0Init_temp_L0+1
	MOV R2, timer0Init_temp_L0+2
	MOV R3, timer0Init_temp_L0+3
	LCALL _Div_32x32_S+0
	MOV R0, 4
	MOV R1, 5
	MOV R2, 6
	MOV R3, 7
	MOV _TLstart+0, 0
;MyProject.c,292 :: 		}
	RET
; end of _timer0Init

_timer0Step:
;MyProject.c,294 :: 		void timer0Step(){
;MyProject.c,296 :: 		TL0 = TLstart;
	MOV TL0+0, _TLstart+0
;MyProject.c,297 :: 		TH0 = THstart;
	MOV TH0+0, _THstart+0
;MyProject.c,298 :: 		TR0_bit = 1;
	SETB TR0_bit+0
;MyProject.c,299 :: 		for(i=0;i<timer0Count;i++){
	MOV timer0Step_i_L0+0, #0
	MOV timer0Step_i_L0+1, #0
L_timer0Step68:
	CLR C
	MOV A, timer0Step_i_L0+0
	SUBB A, _timer0Count+0
	MOV A, _timer0Count+1
	XRL A, #128
	MOV R0, A
	MOV A, timer0Step_i_L0+1
	XRL A, #128
	SUBB A, R0
	JNC L_timer0Step69
;MyProject.c,300 :: 		while(!TF0_bit);
L_timer0Step71:
	JB TF0_bit+0, L_timer0Step72
	NOP
	SJMP L_timer0Step71
L_timer0Step72:
;MyProject.c,301 :: 		TF0_bit = 0;
	CLR TF0_bit+0
;MyProject.c,299 :: 		for(i=0;i<timer0Count;i++){
	MOV A, #1
	ADD A, timer0Step_i_L0+0
	MOV timer0Step_i_L0+0, A
	MOV A, #0
	ADDC A, timer0Step_i_L0+1
	MOV timer0Step_i_L0+1, A
;MyProject.c,302 :: 		}
	SJMP L_timer0Step68
L_timer0Step69:
;MyProject.c,303 :: 		}
	RET
; end of _timer0Step

_main:
	MOV SP+0, #128
;MyProject.c,305 :: 		void main() {
;MyProject.c,306 :: 		LCDstart();
	LCALL _LCDstart+0
;MyProject.c,308 :: 		UART1start();
	LCALL _UART1start+0
;MyProject.c,309 :: 		timerVal = number1;
	MOV _timerVal+0, _number1+0
	MOV _timerVal+1, _number1+1
;MyProject.c,310 :: 		numToSymb(number1, num1Symb);
	MOV FARG_numToSymb_number+0, _number1+0
	MOV FARG_numToSymb_number+1, _number1+1
	MOV FARG_numToSymb_symbols+0, #_num1Symb+0
	LCALL _numToSymb+0
;MyProject.c,311 :: 		numToSymb(number2, num2Symb);
	MOV FARG_numToSymb_number+0, _number2+0
	MOV FARG_numToSymb_number+1, _number2+1
	MOV FARG_numToSymb_symbols+0, #_num2Symb+0
	LCALL _numToSymb+0
;MyProject.c,312 :: 		numToSymb(timerStep, timerStepSymb);
	MOV FARG_numToSymb_number+0, _timerStep+0
	MOV FARG_numToSymb_number+1, _timerStep+1
	MOV FARG_numToSymb_symbols+0, #_timerStepSymb+0
	LCALL _numToSymb+0
;MyProject.c,313 :: 		numToSymb(timerVal, timerValSymb);
	MOV FARG_numToSymb_number+0, _timerVal+0
	MOV FARG_numToSymb_number+1, _timerVal+1
	MOV FARG_numToSymb_symbols+0, #_timerValSymb+0
	LCALL _numToSymb+0
;MyProject.c,314 :: 		LCDSendTimerStart();
	LCALL _LCDSendTimerStart+0
;MyProject.c,315 :: 		timer0Init();
	LCALL _timer0Init+0
;MyProject.c,316 :: 		for(;timerVal<=number2;timerVal++){
L_main73:
	SETB C
	MOV A, _timerVal+0
	SUBB A, _number2+0
	MOV A, _number2+1
	XRL A, #128
	MOV R0, A
	MOV A, _timerVal+1
	XRL A, #128
	SUBB A, R0
	JNC L_main74
;MyProject.c,317 :: 		LCDSendTimerValue(timerVal);
	MOV FARG_LCDSendTimerValue_timerVal+0, _timerVal+0
	MOV FARG_LCDSendTimerValue_timerVal+1, _timerVal+1
	LCALL _LCDSendTimerValue+0
;MyProject.c,318 :: 		timer0Step();
	LCALL _timer0Step+0
;MyProject.c,316 :: 		for(;timerVal<=number2;timerVal++){
	MOV A, #1
	ADD A, _timerVal+0
	MOV _timerVal+0, A
	MOV A, #0
	ADDC A, _timerVal+1
	MOV _timerVal+1, A
;MyProject.c,319 :: 		}
	SJMP L_main73
L_main74:
;MyProject.c,320 :: 		}
	SJMP #254
; end of _main
