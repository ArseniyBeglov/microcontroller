#define CLEAR 0x01
#define FIRST_ROW 0x80
#define SECOND_ROW 0xC0
#define Baud_rate 0xFD
sbit LCD_RS at P1_2_bit;
sbit LCD_EN at P1_5_bit;
sbit LCD_D7 at P2_7_bit;
sbit LCD_D6 at P2_6_bit;
sbit LCD_D5 at P2_5_bit;
sbit LCD_D4 at P2_4_bit;


char flags = 0b110000000;
sbit cicleFlag at flags.b0;
sbit flagB at flags.b1;
sbit comFlag at flags.b2;
sbit kbFlag at flags.b3;

char cursorPos = 0;

char a[] = {0b11111110, 0b11111101,0b11111011};
char btns[] = {'1','2','3','4','5','6','7','8','9','*','0','#'};
char errorMsg[] = "Error, try again";
char endMsg[] = "Timer ended";

void LCDsend4bit(char buf){
     Delay_ms(20);
     P2 = buf;
     if(comFlag == 1){
          LCD_RS = 0;
     }
     else{
          LCD_RS = 1;
     }
     Delay_ms(2);
     LCD_EN = 1;
     Delay_ms(2);
     LCD_EN = 0;
}

void LCDsend(char buf){
      LCDsend4bit(buf&0xf0);
      LCDsend4bit(buf<<4);
}

void LCDsendCom(char command){
     comFlag = 1;
     LCDsend(command);
}

void LCDclear()
{
     cursorPos = 0;
     LCDsendCom(CLEAR);
}

void LCDsendSymb(char symbol)
{
     cursorPos++;
     comFlag = 0;
     LCDsend(symbol);
}

void LCDstart(){
     LCDsendCom(0x28);  //
     LCDsendCom(0x0f);  //              ,
     LCDsendCom(FIRST_ROW);
     LCDclear();
}

void LCDsendData(char* symbols)
{
     char iter = 0;
     while(*(symbols+iter) != 0)
     {
      LCDsendSymb(*(symbols+iter));
      iter++;
      if(cursorPos==16)
          LCDsendCom(SECOND_ROW);
     }
}

void LCDsendMsg(char* msg)
{
     LCDclear();
     LCDsendData(msg);
}

void digToSymb(int value, char* symbols)
{
     char temp[3];
     int rank = -1;
     int digit = 0;
     int i;
     do{
        digit = value % 10;
        value /= 10;
        rank++;
        temp[rank] = '0' + digit;
     }while(value>0);

     for(i = 0; rank >= 0; rank--, i++)
     {
         *(symbols+i) = temp[rank];
     }
     *(symbols+i) = 0;
}

void serialportInit()
{
     SCON = 0b01010000;
     PCON = 0b10000000;
}

void timer1Init()
{
     TR1_bit = 0;
     TH1 = 0xFD;
     TMOD = TMOD&0b00001111;
     TMOD = TMOD|0b00100000;
     TR1_bit = 1;
}

int insertNumber1()
{
int value1 = 0;
char val[]={'0','0','0',0};
char digitCount = 0;
char i = 0;
char btnNum = 0;
cicleFlag = 1;
  do {

  kbFlag = 0;
     do{
          Delay_ms(100);
        if(i==3)
           i = 0;
        P0 = a[i];
        i++;
        if(!P0_7_bit || !P0_6_bit || !P0_5_bit || !P0_4_bit)
           kbFlag = 1;
     }while(!kbFlag);

     if(P0<=127)
          btnNum=9;
     else if(P0<=191)
          btnNum=6;
     else if(P0<=223)
          btnNum=3;
     else btnNum=0;

     if(!P0_1_bit)
         btnNum+=1;
     else if(!P0_2_bit)
         btnNum+=2;
     LCDsendSymb(btns[btnNum]);

     if(btnNum==9 && digitCount>1)
     {
        digitCount--;
        value1 = value1/10;
     }
     else if(btnNum==11)
     {/*                          */
        if(digitCount < 1)
           LCDsendMsg(errorMsg);
        else
           cicleFlag = 0;
     }
     else
     {
        digitCount++;
        if(digitCount>3)
        {
           LCDsendMsg(errorMsg);
           digitCount = 0;
        }
        else
           value1 = value1*10 + (btns[btnNum]-'0');
           digToSymb(value1, *val);
           //LCDsendMsg(val);
     }

  } while(cicleFlag);
  LCDclear();
  P0 = 255;
  return value1;
}





int insertNumber2()
{   timer1Init();
    serialportInit();
    while(1)
    {
            if(RI_bit)
            {
                  RI_bit = 0;
                  P3 = SBUF;
                  if(TI_bit)
                  {
                        TI_bit = 0;
                        SBUF = '0';
                  }
            }
            if(UART1_Data_Ready())
                  LCDsendData(UART1_Read());
    }
}

int number1;
int number2;

void send(unsigned char *s)
{
     while(*s){
           SBUF = *s++;
           while(TI_bit==0);
           TI_bit=0;
     }

}



char uart_rd;
void main() {
      P1=255;
                                 //
                                LCDsendCom(0x02);  //
                                Delay_ms(20);      //

     LCDstart();

     LCDsendMsg("biba");
     //number1 = insertNumber1();
     //LCDsendMsg("aboba");
     //TMOD=0x20;
     //TH1=TL1=0xfd;
     //TR1_bit = 1;
     UART1_Init(9600);               // Initialize UART module at 4800 bps
     Delay_ms(200);                  // Wait for UART module to stabilize

   UART1_Write_Text("Start");
  while (1) {                     // Endless loop
    if (UART1_Data_Ready()) {     // If data is received,
      char uart_rd_str[2];
      uart_rd_str[0] = uart_rd;
      uart_rd_str[1] = '\0';
      LCDsendMsg(uart_rd_str);
      break;
          //   and send data via UART
    }
  }

     //number2 = insertNumber2();
}