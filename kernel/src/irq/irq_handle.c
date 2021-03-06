#include "common.h"
//#include "serial.h"
#include "lib/syscall.h"
#include "keyboard.h"
#include "process.h"
//static void (*do_timer)(void);
extern void press_key(int code);

timer_handler timer_handlers[TIMER_HANDLERS_MAX];

/*static void do_timer_x(){
	int i;
	for(i=0;i<TIMER_HANDLERS_MAX;i++){
		if(timer_handlers[i].used)timer_handlers[i].ptr();
	}
}*/
extern void do_timer();
extern void do_scheduler();
/*void
set_timer_intr_handler( void (*ptr)(void) ) {
	do_timer = ptr;
}*/

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
	//printk("eh\n");
	current->tf = tf;
	//printk("ha\n");
	//tf->esp = (uint32_t)tf;
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {

		if(tf->irq == -1) {
			//printk("%s, %d: Unhandled exception!\n", __FUNCTION__, __LINE__);
		}
		else {
			//printk("IRQ::%d\n", tf->irq);
			//assert(0);
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
		//printk("ha");
		do_syscall(tf);
	}
	if (tf->irq == 1000) {
		//printk("haha");
		//serial_printc('t');
		do_timer();
		do_scheduler();
	} else if (tf->irq == 1001) {
		//serial_printc('k');
		uint32_t code = inb(0x60);
		uint32_t val = inb(0x61);
		outb(0x61, val | 0x80);
		outb(0x61, val);
		press_key(code);
		if(ctrl_c() && current->tt != KERNEL){
			tf->eax = SYS_EXIT;
			do_syscall(tf);
		};
	} else {
		
	}
	//if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
	if((tf->irq == 0x80) && (tf->eax != SYS_PRINT_CHAR)){
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
	}
}

