#line 1 "C:/BIV213/lab1.c"
#line 34 "C:/BIV213/lab1.c"
void main() {
 char a = 7;
 int b = 0;

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
 P0 = a; }
 if(b==1)
 P1 = a;
 if(b==2)
 P2 = a;
 if(b==3)
 {
 P3 = a;
 b=0;
 }

 Delay_ms(500);







 } while(1);
}
