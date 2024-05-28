
_main:
	MOV SP+0, #128
;LED_Blinking.c,26 :: 		void main() {
;LED_Blinking.c,27 :: 		do {
L_main0:
;LED_Blinking.c,28 :: 		P0 = 0x00;        // Turn ON diodes on PORT0
	MOV P0+0, #0
;LED_Blinking.c,29 :: 		P1 = 0x00;        // Turn ON diodes on PORT1
	MOV P1+0, #0
;LED_Blinking.c,30 :: 		P2 = 0x00;        // Turn ON diodes on PORT2
	MOV P2+0, #0
;LED_Blinking.c,31 :: 		P3 = 0x00;        // Turn ON diodes on PORT3
	MOV P3+0, #0
;LED_Blinking.c,32 :: 		Delay_ms(1000);   // 1 second delay
	MOV R5, 7
	MOV R6, 86
	MOV R7, 60
	DJNZ R7, 
	DJNZ R6, 
	DJNZ R5, 
;LED_Blinking.c,34 :: 		P0 = 0xFF;        // Turn OFF diodes on PORT0
	MOV P0+0, #255
;LED_Blinking.c,35 :: 		P1 = 0xFF;        // Turn OFF diodes on PORT1
	MOV P1+0, #255
;LED_Blinking.c,36 :: 		P2 = 0xFF;        // Turn OFF diodes on PORT2
	MOV P2+0, #255
;LED_Blinking.c,37 :: 		P3 = 0xFF;        // Turn OFF diodes on PORT3
	MOV P3+0, #255
;LED_Blinking.c,38 :: 		Delay_ms(1000);   // 1 second delay
	MOV R5, 7
	MOV R6, 86
	MOV R7, 60
	DJNZ R7, 
	DJNZ R6, 
	DJNZ R5, 
;LED_Blinking.c,40 :: 		} while(1);         // Endless loop
	SJMP L_main0
;LED_Blinking.c,41 :: 		}
	SJMP #254
; end of _main
