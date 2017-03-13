#include "lib/common.h"

#include "lib/serial.h"
#include "lib/i8259.h"
#include "lib/timer.h"
#include "lib/irq.h"
//extern
static int letter_code[] = {
	30, 48, 46, 32, 18, 33, 34, 35, 23, 36,
	37, 38, 50, 49, 24, 25, 16, 19, 31, 20,
	22, 47, 17, 45, 21, 44
};
void press(int code){
	printk("code: %x\n", code);
	int i=0;
	for(;i<26;i++){
		if(letter_code[i]==code){
			printk("%c", 'a'+i);
			printk("\n");
			return;
		}
	}
}
void timer(){
	//printk("turn the speak up\n");
}
int main(){
	init_serial();
	init_timer();
	init_idt();
	init_intr();
	set_keyboard_intr_handler(press);
	set_timer_intr_handler(timer);
	enable_interrupt();
	//int i = 0;
	//char string[2000];
	//sprintf(string, "%s %s", "hello", ", world!");
	printk("Here we go!\n");
	while(1){
		//printk("We wait\n");
		wait_for_interrupt();
		disable_interrupt();
		//printk("Once up a time\n");
		enable_interrupt();
	}
	return 1;
};
