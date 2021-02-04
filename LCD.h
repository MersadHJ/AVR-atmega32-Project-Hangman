// YOU HAVE TO SET THE CPU FREQUENCY BECAUSE?YOU?ARE?USING
// PREDEFINED DELAY FUNCTION
//#define F_CPU=8000000UL
#include <math.h>    		// Standard AVR header
#include <io.h>    		// Standard AVR header
#include <delay.h>		// Delay header

#define	LCD_DPRT  PORTB		//LCD DATA PORT	
#define	LCD_DDDR  DDRB 		//LCD DATA DDR
#define	LCD_DPIN  PINB 		//LCD DATA PIN
#define	LCD_CPRT  PORTD 	//LCD COMMANDS PORT
#define	LCD_CDDR  DDRD 		//LCD COMMANDS DDR
#define	LCD_CPIN  PIND 		//LCD COMMANDS PIN
#define	LCD_RS  5 			//LCD RS
#define	LCD_RW  6 			//LCD RW
#define	LCD_EN  7 			//LCD EN
//*******************************************************
void lcdCommand( unsigned char cmnd )
{
  LCD_DPRT = cmnd;			//send cmnd to data port
  LCD_CPRT &= ~ (1<<LCD_RS);	//RS = 0 for command
  LCD_CPRT &= ~ (1<<LCD_RW);	//RW = 0 for write 
  LCD_CPRT |= (1<<LCD_EN);		//EN = 1 for H-to-L pulse
  delay_us(1);				//wait to make enable wide
  LCD_CPRT &= ~ (1<<LCD_EN);	//EN = 0 for H-to-L pulse
  delay_us(100);				//wait to make enable wide
}

//*******************************************************
void lcdData( unsigned char data )
{
  LCD_DPRT = data;			//send data to data port
  LCD_CPRT |= (1<<LCD_RS);		//RS = 1 for data
  LCD_CPRT &= ~ (1<<LCD_RW);	//RW = 0 for write
  LCD_CPRT |= (1<<LCD_EN);		//EN = 1 for H-to-L pulse
  delay_us(1);				//wait to make enable wide
  LCD_CPRT &= ~ (1<<LCD_EN);	//EN = 0 for H-to-L pulse
  delay_us(100);				//wait to make enable wide
}

//*******************************************************
void lcd_init()
{
  LCD_DDDR = 0xFF;
  LCD_CDDR |= 0xF0;
 
  LCD_CPRT &=~(1<<LCD_EN);		//LCD_EN = 0
//  LCD_CPRT |= (1<<7);		//LCD_EN = 0
  delay_us(2000);			//wait for init.
  lcdCommand(0x38);			//init. LCD 2 line, 5´7 matrix
  lcdCommand(0x0E);			//display on, cursor on
  lcdCommand(0x01);			//clear LCD
  delay_us(2000);			//wait
  lcdCommand(0x06);			//shift cursor right
}

//*******************************************************
void lcd_gotoxy(unsigned char x, unsigned char y)
{  
 unsigned char firstCharAdr[]={0x80,0xC0,0x94,0xD4};//table 12-5  
 lcdCommand(firstCharAdr[y-1] + x - 1);
 delay_us(100);	
}
//*******************************************************
void lcd_print( char * str )
{
  unsigned char i = 0 ;
  while(str[i]!=0)
  {
    lcdData(str[i]);
    i++ ;
  }
}
//*******************************************************

#define KEY_PRT PORTC //keyboard PORT
#define KEY_DDR DDRC
#define KEY_PIN PINC


unsigned char keypad[4][4] =//{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
{'1','2','3','A',
 '6','5','4','B',
'7','8','9','C',
 '*','0','#','D'        //non usable
};




unsigned char colloc, rowloc;
unsigned char get_key ()
{
          


    

	KEY_PRT = 0xEF;
	#asm("NOP");
	colloc = (KEY_PIN & 0x0F);
	if(colloc != 0x0F)
	{
		rowloc = 0;
	} else
    {
        KEY_PRT = 0xDF;
        #asm("NOP");
        colloc = (KEY_PIN & 0x0F);
	
        if(colloc != 0x0F)
        {
            rowloc = 1;
        } 
        else
        {
           KEY_PRT =  0xBF;
            #asm("NOP");
            colloc = (KEY_PIN & 0x0F);
            if(colloc != 0x0F)
            {
                rowloc = 2;
            } 
            else
            {
                  
                    KEY_PRT = 0x7F;
                    #asm("NOP");
                    colloc = (KEY_PIN & 0x0F);
                    rowloc = 3;
            }

        }
    }

	

	
	

	         if(colloc == 0x0E)
        return (keypad[0][rowloc]);
      else if(colloc == 0x0D)
        return (keypad[1][rowloc]);
      else if(colloc == 0x0B)
        return (keypad[2][rowloc]);
       else 
        return (keypad[3][rowloc]);


        
  
  }
  
