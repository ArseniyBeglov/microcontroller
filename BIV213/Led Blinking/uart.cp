#line 1 "C:/Program Files (x86)/MikroElektronika/mikroC PRO for 8051/Examples/ATMEL/Development Systems/Easy8051v6/Led Blinking/uart.c"
unsigned char read();
void write(unsigned char character);

void main() {
SCON=0x50;
PCON=0;
TMOD=0x20;
TH1=0xF5;
TR1_bit=1;
while (1) {
 write(read());
}
}

unsigned char read(){
 unsigned char character;
 while(!RI_bit);
 character=SBUF;
 RI_bit=0;
 return character;
}

void write(unsigned char character){
 SBUF=character;
 while(!TI_bit);
 TI_bit=0;
}
