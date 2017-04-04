#include "lib/common.h"

#include "lib/serial.h"
#include "lib/i8259.h"
#include "lib/timer.h"
#include "lib/irq.h"

extern void game_logic();

static unsigned int x = 123456789,  
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   
   
unsigned int UKISS()  
{    
    unsigned long long t, A = 698769069ULL;    
  
    x = 69069*x+12345;    
    y ^= (y<<13);   
    y ^= (y>>17);   
    y ^= (y<<5);    
      
    t = (A*z + c);  
    c = (t >> 32);  
    z = t;  
       
    return x+y+z;    
}  

int main(){
	init_serial();
	init_timer();
	init_idt();
	init_intr();

	game_logic();

	return 1;
};
