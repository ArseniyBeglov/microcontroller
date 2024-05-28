#line 1 "C:/Users/Администратор/Desktop/biv213/Led Blinking/LED_Blinking.c"
#line 26 "C:/Users/Администратор/Desktop/biv213/Led Blinking/LED_Blinking.c"
void main() {
 do {
 P0 = 0x00;
 P1 = 0x00;
 P2 = 0x00;
 P3 = 0x00;
 Delay_ms(1000);

 P0 = 0xFF;
 P1 = 0xFF;
 P2 = 0xFF;
 P3 = 0xFF;
 Delay_ms(1000);

 } while(1);
}
