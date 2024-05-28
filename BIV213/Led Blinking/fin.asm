
_SPI_init:
;fin.c,6 :: 		void SPI_init(){
;fin.c,7 :: 		SPR1_bit = 1;
	SETB C
	MOV A, SPR1_bit+0
	MOV #224, C
	MOV SPR1_bit+0, A
;fin.c,8 :: 		SPR0_bit = 1;
	SETB C
	MOV A, SPR0_bit+0
	MOV #224, C
	MOV SPR0_bit+0, A
;fin.c,9 :: 		MSTR_bit = 1;
	SETB C
	MOV A, MSTR_bit+0
	MOV #224, C
	MOV MSTR_bit+0, A
;fin.c,10 :: 		CPOL_bit = 1;
	SETB C
	MOV A, CPOL_bit+0
	MOV #224, C
	MOV CPOL_bit+0, A
;fin.c,11 :: 		SPIE_bit = 1;
	SETB C
	MOV A, SPIE_bit+0
	MOV #224, C
	MOV SPIE_bit+0, A
;fin.c,13 :: 		SPE_bit = 1;
	SETB C
	MOV A, SPE_bit+0
	MOV #224, C
	MOV SPE_bit+0, A
;fin.c,14 :: 		}
	RET
; end of _SPI_init

_connect:
;fin.c,16 :: 		void connect() {
;fin.c,17 :: 		P2_0_bit = 0;
	CLR P2_0_bit+0
;fin.c,19 :: 		SPDR = 0b00000110;
	MOV SPDR+0, #6
;fin.c,20 :: 		while (SPIF_bit == 0){}
L_connect0:
	MOV A, SPIF_bit+0
	JB 224, L_connect1
	NOP
	SJMP L_connect0
L_connect1:
;fin.c,21 :: 		SPDR = 0b00000000;
	MOV SPDR+0, #0
;fin.c,22 :: 		while (SPIF_bit == 0){}
L_connect2:
	MOV A, SPIF_bit+0
	JB 224, L_connect3
	NOP
	SJMP L_connect2
L_connect3:
;fin.c,23 :: 		P0 = SPDR << 4;
	MOV R0, #4
	MOV A, SPDR+0
	INC R0
	SJMP L__connect11
L__connect12:
	CLR C
	RLC A
L__connect11:
	DJNZ R0, L__connect12
	MOV P0+0, A
;fin.c,24 :: 		SPDR = 0b00000000;
	MOV SPDR+0, #0
;fin.c,25 :: 		while (SPIF_bit == 0){}
L_connect4:
	MOV A, SPIF_bit+0
	JB 224, L_connect5
	NOP
	SJMP L_connect4
L_connect5:
;fin.c,26 :: 		P0 = (SPDR >> 4) | P0;
	MOV R1, #4
	MOV A, SPDR+0
	INC R1
	SJMP L__connect13
L__connect14:
	CLR C
	RRC A
L__connect13:
	DJNZ R1, L__connect14
	MOV R0, A
	ORL P0+0, A
;fin.c,28 :: 		P2_0_bit = 1;
	SETB P2_0_bit+0
;fin.c,30 :: 		}
	RET
; end of _connect

_UART_init:
;fin.c,32 :: 		void UART_init()
;fin.c,35 :: 		ES_bit = 1;
	SETB ES_bit+0
;fin.c,36 :: 		SCON=0x50;            //configure serial control register
	MOV SCON+0, #80
;fin.c,37 :: 		PCON=0x80;            //SMOD bit set
	MOV PCON+0, #128
;fin.c,38 :: 		TMOD=0x20;           //using timer1,8-bit reload mode for baudrate generation
	MOV TMOD+0, #32
;fin.c,39 :: 		TCLK_bit = 1;
	SETB TCLK_bit+0
;fin.c,40 :: 		RCLK_bit = 1;
	SETB RCLK_bit+0
;fin.c,41 :: 		EA_bit = 1;
	SETB EA_bit+0
;fin.c,42 :: 		RCAP2H=0xFF;
	MOV RCAP2H+0, #255
;fin.c,43 :: 		RCAP2L=0xFF - 15;            //19200 baudrate(16 mhz clock)
	MOV RCAP2L+0, #240
;fin.c,44 :: 		TR2_bit=1;               //start timer
	SETB TR2_bit+0
;fin.c,45 :: 		}
	RET
; end of _UART_init

_Uart_write_char:
;fin.c,48 :: 		void Uart_write_char(unsigned char character)
;fin.c,51 :: 		SBUF = 0;
	MOV SBUF+0, #0
;fin.c,52 :: 		SBUF=character;          //load the character to be transmitted in to the buffer reg
	MOV SBUF+0, FARG_Uart_write_char_character+0
;fin.c,53 :: 		while(!TI_bit);              //wait until transmission complete
L_Uart_write_char6:
	JB TI_bit+0, L_Uart_write_char7
	NOP
	SJMP L_Uart_write_char6
L_Uart_write_char7:
;fin.c,54 :: 		TI_bit=0;                    //clear flag
	CLR TI_bit+0
;fin.c,56 :: 		}
	RET
; end of _Uart_write_char

_main:
	MOV SP+0, #128
;fin.c,58 :: 		void main()
;fin.c,60 :: 		SPI_init();
	LCALL _SPI_init+0
;fin.c,61 :: 		UART_init();
	LCALL _UART_init+0
;fin.c,62 :: 		P2_0_bit = 1;
	SETB P2_0_bit+0
;fin.c,65 :: 		do {
L_main8:
;fin.c,66 :: 		P2_0_bit = 1;
	SETB P2_0_bit+0
;fin.c,67 :: 		connect();
	LCALL _connect+0
;fin.c,68 :: 		Uart_write_char(P0);
	MOV FARG_Uart_write_char_character+0, SCON+0
	LCALL _Uart_write_char+0
;fin.c,69 :: 		Delay_ms(1);
	MOV R6, 2
	MOV R7, 157
	DJNZ R7, 
	DJNZ R6, 
	NOP
;fin.c,70 :: 		} while(1);
	SJMP L_main8
;fin.c,72 :: 		}
	SJMP #254
; end of _main
