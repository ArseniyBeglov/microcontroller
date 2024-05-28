unsigned char read();
void write(unsigned char character);

void main() {
SCON=0x50;              // Configure serial control register
PCON=0;              // SMOD bit set
TMOD=0x20;              // Using timer1,8-bit reload mode for baudrate generation
TH1=0xF5;               // 9600 baudrate(16 mhz clock)
TR1_bit=1;                  // Start timer
while (1) {
   write(read());
}
}

unsigned char read(){
    unsigned char character;
    while(!RI_bit);                           // Wait until character received completely
    character=SBUF;                       // Read the character from buffer reg
    RI_bit=0;                                 // Clear the flag
    return character;                     // Return the received character
}

void write(unsigned char character){
    SBUF=character;      // Load the character to be transmitted in to the buffer reg
    while(!TI_bit);          // Wait until transmission complete
    TI_bit=0;                // Clear flag
}