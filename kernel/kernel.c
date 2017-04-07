#include "lib/common.h"
#include "lib/serial.h"
#include "lib/i8259.h"
#include "lib/timer.h"
#include "lib/irq.h"
#include "lib/printk.h"
#include "lib/keyboard.h"
#include "lib/syscall.h"
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
  printf("%s\n", "Here we go!");
  enable_interrupt();
	game_logic();
  while(1){
    //uint32_t tick = sys_get_tick();
    //printk("%d\n", tick);
    /*if(sys_key_down('a'))printf("%s\n", "hahahah");;
    //printf("%c", get_lastkey());
    wait_for_interrupt();
    disable_interrupt();
    enable_interrupt();*/
  };
	return 1;
};
