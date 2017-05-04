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
    yield();
  }
}
void busy(){
  /*uint32_t tick=0;
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
      if(tick>2){
        sys_exit();
      }
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
  }*/
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
  while(1){
    yield();
    sleep(pid);
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
    times++;
    if(times>3){
      printf("BUSY#%d: Ready to exit! Bye!\n");
      exit();
    }
    //printk("This is %d\n", res);
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
  empty_loader(pidle, idle);

  PCB* pcb = pcb_create();
  loader(pcb, 102400);

  enready_pcb(pidle);
  enready_pcb(pcb);


  PCB* pcc = pcb_create();
  empty_loader(pcc, busy);
  enready_pcb(pcc);


  do_scheduler();

  while(1);
	return 1;
};
