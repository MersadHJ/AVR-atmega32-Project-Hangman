// YOU HAVE TO SET THE CPU FREQUENCY BECAUSE?YOU?ARE?USING
// PREDEFINED DELAY FUNCTION
//#define F_CPU=8000000UL
#include <math.h>    		// Standard AVR header
#include <io.h>    		// Standard AVR header
#include <delay.h>		// Delay header

#define	LCD_DPRT2  PORTA		//LCD DATA PORT	
#define	LCD_DDDR2  DDRA 		//LCD DATA DDR
#define	LCD_DPIN2  PINA 		//LCD DATA PIN
#define	LCD_CPRT2  PORTD 	//LCD COMMANDS PORT
#define	LCD_CDDR2  DDRD 		//LCD COMMANDS DDR
#define	LCD_CPIN2  PIND 		//LCD COMMANDS PIN
#define	LCD_RS2  1 			//LCD RS
#define	LCD_RW2  3 			//LCD RW
#define	LCD_EN2  4 			//LCD EN
//*******************************************************
void lcdCommand2( unsigned char cmnd )
{
  LCD_DPRT2 = cmnd;            //send cmnd to data port
  LCD_CPRT2 &= ~ (1<<LCD_RS2);    //RS = 0 for command
  LCD_CPRT2 &= ~ (1<<LCD_RW2);    //RW = 0 for write 
  LCD_CPRT2 |= (1<<LCD_EN2);        //EN = 1 for H-to-L pulse
  delay_us(1);                //wait to make enable wide
  LCD_CPRT2 &= ~ (1<<LCD_EN2);    //EN = 0 for H-to-L pulse
  delay_us(100);                //wait to make enable wide
}

//*******************************************************
void lcdData2( unsigned char data )
{
  LCD_DPRT2 = data;            //send data to data port
  LCD_CPRT2 |= (1<<LCD_RS2);        //RS = 1 for data
  LCD_CPRT2 &= ~ (1<<LCD_RW2);    //RW = 0 for write
  LCD_CPRT2 |= (1<<LCD_EN2);        //EN = 1 for H-to-L pulse
  delay_us(1);                //wait to make enable wide
  LCD_CPRT2 &= ~ (1<<LCD_EN2);    //EN = 0 for H-to-L pulse
  delay_us(100);                //wait to make enable wide
}

//*******************************************************
void lcd_init2()
{
  LCD_DDDR2 = 0xFF;
  LCD_CDDR2 |= 0x0B;
 
  LCD_CPRT2 &=~(1<<LCD_EN2);        //LCD_EN2 = 0
//  LCD_CPRT2 |= (1<<7);        //LCD_EN2 = 0
  delay_us(2000);            //wait for init.
  lcdCommand2(0x38);            //init. LCD 2 line, 5´7 matrix
  lcdCommand2(0x0E);            //display on, cursor on
  lcdCommand2(0x01);            //clear LCD
  delay_us(2000);            //wait
  lcdCommand2(0x06);            //shift cursor right
}

//*******************************************************
void lcd_gotoxy2(unsigned char x, unsigned char y)
{  
 unsigned char firstCharAdr[]={0x80,0xC0,0x94,0xD4};//table 12-5  
 lcdCommand2(firstCharAdr[y-1] + x - 1);
 delay_us(100);    
}
//*******************************************************
void lcd_print2( char * str )
{
  unsigned char i = 0 ;
  while(str[i]!=0)
  {
    lcdData2(str[i]);
    i++ ;
  }
}

