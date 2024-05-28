
_main:
	MOV SP+0, #128
;lab1.c,34 :: 		void main() {
;lab1.c,35 :: 		char a = 7;
	MOV main_a_L0+0, #7
	MOV main_b_L0+0, #0
	MOV main_b_L0+1, #0
;lab1.c,36 :: 		int b = 0;
;lab1.c,38 :: 		do {
L_main0:
;lab1.c,39 :: 		a = a*2+1;
	MOV R0, #1
	MOV A, main_a_L0+0
	INC R0
	SJMP L__main10
L__main11:
	CLR C
	RLC A
L__main10:
	DJNZ R0, L__main11
	MOV R1, A
	MOV R0, #1
	MOV A, R1
	ADD A, R0
	MOV R1, A
	MOV main_a_L0+0, 1
;lab1.c,40 :: 		if(a>=255){
	CLR C
	MOV A, R1
	SUBB A, #255
	JC L_main3
;lab1.c,41 :: 		a = 1;
	MOV main_a_L0+0, #1
;lab1.c,42 :: 		}
L_main3:
;lab1.c,43 :: 		if(a>128){
	SETB C
	MOV A, main_a_L0+0
	SUBB A, #128
	JC L_main4
;lab1.c,44 :: 		b=b+1;
	MOV A, #1
	ADD A, main_b_L0+0
	MOV main_b_L0+0, A
	MOV A, #0
	ADDC A, main_b_L0+1
	MOV main_b_L0+1, A
;lab1.c,45 :: 		a=a<<1;
	MOV R0, #1
	MOV A, main_a_L0+0
	INC R0
	SJMP L__main12
L__main13:
	CLR C
	RLC A
L__main12:
	DJNZ R0, L__main13
	MOV main_a_L0+0, A
;lab1.c,46 :: 		a=a+1;
	INC main_a_L0+0
;lab1.c,47 :: 		}
	SJMP L_main5
L_main4:
;lab1.c,49 :: 		a=a<<1;
	MOV R0, #1
	MOV A, main_a_L0+0
	INC R0
	SJMP L__main14
L__main15:
	CLR C
	RLC A
L__main14:
	DJNZ R0, L__main15
	MOV main_a_L0+0, A
L_main5:
;lab1.c,51 :: 		if(b==0){
	MOV A, main_b_L0+0
	ORL A, main_b_L0+1
	JNZ L_main6
;lab1.c,52 :: 		P0 = a; }     // Turn ON diodes on PORT0
	MOV P0+0, main_a_L0+0
L_main6:
;lab1.c,53 :: 		if(b==1)
	MOV A, #1
	XRL A, main_b_L0+0
	JNZ L__main16
	MOV A, #0
	XRL A, main_b_L0+1
L__main16:
	JNZ L_main7
;lab1.c,54 :: 		P1 = a;        // Turn ON diodes on PORT1
	MOV P1+0, main_a_L0+0
L_main7:
;lab1.c,55 :: 		if(b==2)
	MOV A, #2
	XRL A, main_b_L0+0
	JNZ L__main17
	MOV A, #0
	XRL A, main_b_L0+1
L__main17:
	JNZ L_main8
;lab1.c,56 :: 		P2 = a;        // Turn ON diodes on PORT2
	MOV P2+0, main_a_L0+0
L_main8:
;lab1.c,57 :: 		if(b==3)
	MOV A, #3
	XRL A, main_b_L0+0
	JNZ L__main18
	MOV A, #0
	XRL A, main_b_L0+1
L__main18:
	JNZ L_main9
;lab1.c,59 :: 		P3 = a;
	MOV P3+0, main_a_L0+0
;lab1.c,60 :: 		b=0;        // Turn ON diodes on PORT3
	MOV main_b_L0+0, #0
	MOV main_b_L0+1, #0
;lab1.c,61 :: 		}
L_main9:
;lab1.c,63 :: 		Delay_ms(500);   // 1 second delay
	MOV R5, 4
	MOV R6, 43
	MOV R7, 157
	DJNZ R7, 
	DJNZ R6, 
	DJNZ R5, 
;lab1.c,71 :: 		} while(1);         // Endless loop
	LJMP L_main0
;lab1.c,72 :: 		}
	SJMP #254
; end of _main
