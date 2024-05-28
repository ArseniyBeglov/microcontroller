#line 1 "C:/Program Files (x86)/MikroElektronika/mikroC PRO for 8051/Examples/ATMEL/Development Systems/Easy8051v6/Led Blinking/fin.c"
int val;
int prev;
char* str;
int ind;

void SPI_init(){
 SPR1_bit = 1;
 SPR0_bit = 1;
 MSTR_bit = 1;
 CPOL_bit = 1;
 SPIE_bit = 1;

 SPE_bit = 1;
}

void connect() {
 P2_0_bit = 0;

 SPDR = 0b00000110;
 while (SPIF_bit == 0){}
 SPDR = 0b00000000;
 while (SPIF_bit == 0){}
 P0 = SPDR << 4;
 SPDR = 0b00000000;
 while (SPIF_bit == 0){}
 P0 = (SPDR >> 4) | P0;

 P2_0_bit = 1;

}

void UART_init()
{

 ES_bit = 1;
 SCON=0x50;
 PCON=0x80;
 TMOD=0x20;
 TCLK_bit = 1;
 RCLK_bit = 1;
 EA_bit = 1;
 RCAP2H=0xFF;
 RCAP2L=0xFF - 15;
 TR2_bit=1;
}


void Uart_write_char(unsigned char character)
{

 SBUF = 0;
 SBUF=character;
 while(!TI_bit);
 TI_bit=0;

}

void main()
{
 SPI_init();
 UART_init();
 P2_0_bit = 1;


 do {
 P2_0_bit = 1;
 connect();
 Uart_write_char(P0);
 Delay_ms(1);
 } while(1);

}
