#include "common.h"
#include "serial.h"
#include "i8259.h"
#include "timer.h"
#include "irq.h"
#include "keyboard.h"

#include "lib/syscall.h"
#include "lib/printk.h"

extern void game_logic();


int main(){
	init_serial();
	init_timer();
	init_idt();
	init_intr();
  printf("%s\n", "Here we go!");
  enable_interrupt();
	//game_logic();
  uint32_t cur = 0;
  while(1){
    uint32_t tick = sys_get_tick();
    while(cur++<tick){

    }
    
    /*if(sys_key_down('a'))printf("%s\n", "hahahah");;
    //printf("%c", get_lastkey());
    wait_for_interrupt();
    disable_interrupt();
    enable_interrupt();*/
  };
	return 1;
};
