/*
 * Project name:
     LED_Blinking (Simple 'Hello World' project)
 * Copyright:
     (c) Mikroelektronika, 2009.
 * Revision History:
     20071210:
       - initial release;
 * Description:
     This is a simple 'Hello World' project. It turns on/off diodes connected to
     PORT0, PORT1, PORT2 and PORT3.
 * Test configuration:
     MCU:             AT89S8253
                      http://www.atmel.com/dyn/resources/prod_documents/doc3286.pdf
     dev.board:       easy8051v6 - 
                      http://www.mikroe.com/easy8051/
     Oscillator:      External Clock 10.0000 MHz
     Ext. Modules:    -
     SW:              mikroC PRO for 8051
                      http://www.mikroe.com/mikroc/8051/
 * NOTES:
     - Turn ON the PORT LEDs (SW7).
     - On Easy8051v6 LEDs are activated by logical zero
*/
  /*union un{
        int s;
        struct str{
               char a;
               char b;
               char c;
               char d;
        }
  }   */
void main() {
  char a = 7;
  int b = 0;
  //union un un1;
  do {
  a = a*2+1;
  if(a>=255){
             a = 1;
             }
if(a>128){
             b=b+1;
             a=a<<1;
             a=a+1;
             }
             else
             a=a<<1;
             
             if(b==0){
                     P0 = a; }     // Turn ON diodes on PORT0
             if(b==1)
                     P1 = a;        // Turn ON diodes on PORT1
             if(b==2)
                     P2 = a;        // Turn ON diodes on PORT2
             if(b==3)
             {
                     P3 = a;
                     b=0;        // Turn ON diodes on PORT3
             }

    Delay_ms(500);   // 1 second delay

    //P0 = 0xFF;        // Turn OFF diodes on PORT0
    //P1 = 0xFF;        // Turn OFF diodes on PORT1
    //P2 = 0xFF;        // Turn OFF diodes on PORT2
    //P3 = 0xFF;        // Turn OFF diodes on PORT3
    //Delay_ms(500);   // 1 second delay

  } while(1);         // Endless loop
}