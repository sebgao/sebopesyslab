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


#define elf   ((struct ELFHeader *) 0x20000)

extern void init_segment(void);
extern void init_page(void);
int main_after_you();

int main(){

  init_segment();
	init_serial();
	init_timer();
	init_idt();
	init_intr();

  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);

  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph ++) {
    pa = (unsigned char*)ph->paddr; 
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }

  printk("%s\n", "Here we go!");

  init_pcb_pool();

  PCB* pcb = pcb_create();
  init_pcb(pcb, USTACKTOP, elf->entry);
  switch_pcb(pcb);


	return 1;
};
