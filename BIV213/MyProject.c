
#define FIRST_ROW 0x80
#define SECOND_ROW 0xC0
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

char a[] = {0b11111110, 0b11111101,0b11111011};
char btns[] = {'1','2','3','4','5','6','7','8','9','*','0','#'};
char digits[] = {'0','1','2','3','4','5','6','7','8','9'};
char errorMsg[] = "Error";
char endMsg[] = "End";

int number1= -1;
int number2;
int timerStep;
int timerVal;
char timerValRank;
char num1Symb[4];
char num2Symb[4];
char timerStepSymb[5];
char timerValSymb[4];
int timer0Count=0;
char THstart=0;
char TLstart=0;

void LCDsend4bit(char buf){
     P2 = buf;
     if(comFlag == 1){
          LCD_RS = 0;
     }
     else{
          LCD_RS = 1;
     }
     LCD_EN = 1;
     LCD_EN = 0;
}

void LCDsend(char buf){
    Delay_ms(1);
    LCDsend4bit(buf&0xf0);
    LCDsend4bit(buf<<4);
}

void LCDSendCom(char command){
    comFlag = 1;
    LCDsend(command);
}

void LCDclear()
{
     LCDSendCom(0x01);
     LCDSendCom(FIRST_ROW);
}

void LCDsendSymb(char symbol)
{   
    comFlag = 0;
    LCDsend(symbol);
}

void LCDstart(){
    LCDSendCom(0x02);  // 4-õ áèòíûé ðåæèì
    LCDSendCom(0x28);  //16*2 â 4-õ áèòíîì ðåæèìå

    LCDSendCom(FIRST_ROW);
    LCDclear();
}

void LCDsendData(char* symbols)
{
     char iter = 0;
     while(*(symbols+iter) != 0)
     {
      LCDsendSymb(*(symbols+iter));
      iter++;
     }
}

void numToSymb(int number, char* symbols)
{
     char* iter = symbols;
     char temp[4], temp1[5];
     int value = number;
     int rank = -1;
     int digit = 0;
     int i;
     do{
        digit = value % 10;
        value /= 10;
        rank++;
        temp[rank] = digits[digit];

     }while(value>0);

     for(i = 0; rank >= 0; rank--, i++)
     {
         temp1[i] = temp[rank];
         *iter = temp[rank];
         iter++;
     }
     temp1[i] = 0;
     *iter = 0;
}

void LCDsendMsg(char* msg)
{
     LCDclear();
     LCDsendData(msg);
}

int insertNumber1()
{
int value1 = 0;
char digitCount = 0;
char i = 0;
char btnNum = 0;
cicleFlag = 1;
LCDclear();
do {
  if(P0_7_bit && P0_6_bit && P0_5_bit && P0_4_bit){
      kbFlag = 0;
         do{
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

         if(btnNum==9 && digitCount>0)
         {
            digitCount--;
            value1 = value1/10;
            LCDclear();
            if(value1>0){
                numToSymb(value1, num1Symb);
                LCDsendData(num1Symb);
            }
         }
         else if(btnNum==11)
         {
            if(digitCount < 1){
               LCDsendMsg(errorMsg);
            }
            else
               cicleFlag = 0;
         }
         else
         {
            digitCount++;
            if(digitCount>3){
               LCDsendMsg(errorMsg);
               digitCount = 0;
               value1 = 0;
            }
            else{
               value1 = value1*10 + (btns[btnNum]-'0');
               LCDclear();
               numToSymb(value1, num1Symb);
               LCDsendData(num1Symb);
            }
         }
      }
  } while(cicleFlag);
  P0 = 255;
  return value1;
}

void UART1start(){
  TMOD = 0b00100000;
  TH1 = 0xF5;
  SCON = 0b01010000;
  TR1_bit = 1;

}

char UART1read(){
  return SBUF;
}

int insertUART(int max)
{
     char digit;
     char uartRd;
     int value=0;

        while (1) {
            if (RI_bit) {
                RI_bit=0;
                uartRd = UART1read();
                digit = uartRd - '0';
                if(digit >=0 && digit <=9){
                   LCDSendSymb(uartRd);
                    if(value > max){
                                         number2 = -1;
                     timerStep = -1;
                        return -1;
                    }
                    value = value * 10 + digit;
                }
                else if(uartRd == ' ' && value<=max && value>0){
                    return value;
                }
                else {
                     number2 = -1;
                     timerStep = -1;
                     return -1;
                }
        }
    }
}

void LCDSendTimerStart(){
    int temp = number1;
    LCDclear();
    LCDSendCom(FIRST_ROW);
    LCDSendData(num1Symb);
    LCDSendSymb(' ');
    LCDSendData(num2Symb);
    LCDSendSymb(' ');
    LCDSendData(timerStepSymb);
    LCDSendCom(SECOND_ROW);
    LCDSendData("   ");
    LCDSendData(timerValSymb);
    timerValRank = 0;
    do{
        temp = temp / 10;
        timerValRank++;
    }while(temp > 0);
    LCDSendCom(0x0c);  // îòêëþ÷åíèå êóðñîðà
}

void LCDSendTimerValue(int timerVal){
    int i,temp,temp1;
    temp = timerVal;
    if((timerVal == 10 && timerValRank == 1) || (timerVal == 100 && timerValRank == 2)){
        timerValRank++;
    }
    for(i=timerValRank;i>0;i--){
        temp1 = temp % 10;
        LCDSendCom(194+i);  // Ïåðåâîä êóðñîðà íà èçìåíèâøèéñÿ ñèìâîë îòñ÷åòà òàéìåðà
        LCDSendSymb(digits[temp1]);
        if(temp1 != 0){
            return;
        }
        temp = temp / 10;
    }
}

void timer0Init(){       //int íå ìîæåò áûòü áîëüøå 32768, áåðåì long
     long temp, temp1;
     TMOD = TMOD | 0b00000001;
     temp = timerStep * 1000L;
     timer0Count = temp / 65536L;
     temp1 = temp - 65536 * (long)timer0Count;
     temp = 65535 - temp1;
     THstart = temp / 256;
     TLstart = temp % 256;
}

void timer0Step(){
    int i;
    TL0 = TLstart;
    TH0 = THstart;
    TR0_bit = 1;
    for(i=0;i<timer0Count;i++){
        while(!TF0_bit);
        TF0_bit = 0;
    }
}

void insertNumbers(){

    if(number1==-1)
        number1 = insertNumber1();
        
        LCDclear();
        LCDSendData(num1Symb);
        LCDSendSymb(' ');
        number2 = insertUART(999);
        LCDSendSymb(' ');
        timerStep = insertUART(9999);
        LCDSendSymb('a');
}

void main() {
int i;
    LCDstart();
    UART1start();

   while(1){
      LCDSendCom(0x0f);  //äèñïëåé âêëþ÷åí, êóðñîð ìèãàåò
      insertNumbers();
      if(number2!=-1 && timerStep!=-1 && number1<=number2){
        timerVal = number1;
        numToSymb(number1, num1Symb);
        numToSymb(number2, num2Symb);
        numToSymb(timerStep, timerStepSymb);
        numToSymb(timerVal, timerValSymb);
        LCDSendTimerStart();
        timer0Init();
        for(;timerVal<=number2;timerVal++){
            LCDSendTimerValue(timerVal);
            timer0Step();
        }
        number1=-1;
        LCDSendMsg(endMsg);
      }
      else
        LCDSendMsg(errorMsg);
      for(i=0;i<32000;i++)
      {
      SBUF=0;
      if (RI_bit) {
                RI_bit=0;}
      }
      ;
    }
  }
