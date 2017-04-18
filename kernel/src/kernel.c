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
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
  while(1){
    sys_handout();
  }
}
void busy(){
  uint32_t tick=0;
  //uint32_t ttt[10];
  while(1){
    //if(_tick % 1000 == 999){
    //  printk("This is idle!\n");
    //}
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    //cur = sys_get_tick();
    //while(tick < cur){
      printf("This is busy! Sleep %ds! Recall %d times\n", sys_pid(), tick);
      tick++;
      //sys_handout();
      //tick++;
    //}

    //printf("1 %x\n", _tick);
    //printf("2 %x\n", _tick);
    sys_handout();
    sys_sleep(sys_pid()*200);
    //sys_handout();
    //printf("3 %x\n", _tick);
    //enable_interrupt();
  }
}
void do_scheduler();
int main(){
  init_page();
  init_segment();
	init_serial();
	init_timer();
	init_idt();
	init_intr();
  init_pcb_pool();

  PCB* pidle = pcb_create();
 // loader(pcb, 102400);
  empty_loader(pidle, idle);

  PCB* pcb = pcb_create();
  loader(pcb, 102400);

 // loader(pcc, 102400);
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));
  printk("haha\n");
  //enable_interrupt();
  printk("haha\n");
  //asm volatile("int $0x0");
  //switch_pcb(pidle);
  printk("haha\n");
  enready_pcb(pidle);
  enready_pcb(pcb);
  uint32_t i = 0;
  for(i=0; i<10;i++){
    PCB* pcc = pcb_create();
    empty_loader(pcc, busy);
    enready_pcb(pcc);
  }
  //enready_pcb(pcc);
  //enready_pcb(pidle);

  do_scheduler();

  while(1);
  //scheduler_switch(pidle);
  //PCB* pidle = pcb_create();
  //loader(pcb, 0);
  //empty_loader(pidle, idle);
  //switch_pcb(pidle);
  //printk("e\n");

	return 1;
};
