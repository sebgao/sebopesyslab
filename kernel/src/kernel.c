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

//#include "console.h"

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
  while(1){
    yield();
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
  init_fs();
  init_pcb_pool();
  
  printk("This is kernel!\n");

  PCB* pidle = pcb_create();
  empty_loader(pidle, idle);
  enready_pcb(pidle);

  /*PCB* pidle2 = pcb_create();
  empty_loader(pidle2, idle);
  enready_pcb(pidle2);
  */
  /*PCB* pcb = pcb_create();
  loader_file(pcb, "game");
  enready_pcb(pcb);*/
    
  PCB* pshell = pcb_create();
  loader_file(pshell, "cshell");
  enready_pcb(pshell);


  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  /*PCB* app = pcb_create();
  loader_file(app, "app");
  enready_pcb(app);*/

  do_scheduler();

  while(1);
	return 1;
};
