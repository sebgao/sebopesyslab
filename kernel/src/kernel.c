#include "common.h"
#include "serial.h"
#include "i8259.h"
#include "timer.h"
#include "irq.h"
#include "keyboard.h"
#include "memory.h"
#include "process.h"

#include "lib/syscall.h"
#include "lib/printk.h"

#include "inc/elf.h"
#include "inc/disk.h"
#include "inc/types.h"
#include "inc/mmu.h"
#include "inc/memlayout.h"
#include "pmap.h"

//void loader(PCB* pcb, uint32_t offset);

extern void init_segment(void);
extern void init_page(void);
void idle(){
  uint32_t tick=0, cur=0;
  while(1){
    //if(_tick % 1000 == 999){
    //  printk("This is idle!\n");
    //}
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    cur = sys_get_tick();
    while(tick < cur){
      printf("This is idle!\n");
      tick+=50;
    }
    //enable_interrupt();
  }
}

int main(){
  init_page();
  init_segment();
	init_serial();
	init_timer();
	init_idt();
	init_intr();
  init_pcb_pool();

  PCB* pcb = pcb_create();
  PCB* pidle = pcb_create();
  loader(pcb, 102400);
  empty_loader(pidle, idle);
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));

  switch_pcb(pidle);
  //printk("haha\n");
  //PCB* pidle = pcb_create();
  //loader(pcb, 0);
  //empty_loader(pidle, idle);
  //switch_pcb(pidle);
  //printk("e\n");

	return 1;
};
