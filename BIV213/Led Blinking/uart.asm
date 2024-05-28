
_main:
	MOV SP+0, #128
;uart.c,4 :: 		void main() {
;uart.c,5 :: 		SCON=0x50;              // Configure serial control register
	MOV SCON+0, #80
;uart.c,6 :: 		PCON=0;              // SMOD bit set
	MOV PCON+0, #0
;uart.c,7 :: 		TMOD=0x20;              // Using timer1,8-bit reload mode for baudrate generation
	MOV TMOD+0, #32
;uart.c,8 :: 		TH1=0xF5;               // 9600 baudrate(16 mhz clock)
	MOV TH1+0, #245
;uart.c,9 :: 		TR1_bit=1;                  // Start timer
	SETB TR1_bit+0
;uart.c,10 :: 		while (1) {
L_main0:
;uart.c,11 :: 		write(read());
	LCALL _read+0
	MOV FARG_write_character+0, 0
	LCALL _write+0
;uart.c,12 :: 		}
	SJMP L_main0
;uart.c,13 :: 		}
	SJMP #254
; end of _main

_read:
;uart.c,15 :: 		unsigned char read(){
;uart.c,17 :: 		while(!RI_bit);                           // Wait until character received completely
L_read2:
	JB RI_bit+0, L_read3
	NOP
	SJMP L_read2
L_read3:
;uart.c,18 :: 		character=SBUF;                       // Read the character from buffer reg
	MOV read_character_L0+0, ___DoIFC+0
;uart.c,19 :: 		RI_bit=0;                                 // Clear the flag
	CLR RI_bit+0
;uart.c,20 :: 		return character;                     // Return the received character
	MOV R0, read_character_L0+0
;uart.c,21 :: 		}
	RET
; end of _read

_write:
;uart.c,23 :: 		void write(unsigned char character){
;uart.c,24 :: 		SBUF=character;      // Load the character to be transmitted in to the buffer reg
	MOV SBUF+0, FARG_write_character+0
;uart.c,25 :: 		while(!TI_bit);          // Wait until transmission complete
L_write4:
	JB TI_bit+0, L_write5
	NOP
	SJMP L_write4
L_write5:
;uart.c,26 :: 		TI_bit=0;                // Clear flag
	CLR TI_bit+0
;uart.c,27 :: 		}
	RET
; end of _write
