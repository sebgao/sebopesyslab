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

uint8_t elf_t[1000];
#define elf   ((struct ELFHeader *) elf_t)

extern void init_segment(void);
extern void init_page(void);
int main_after_you();
int a=0;
void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}

uint32_t entry;

int main(){
  init_page();
  init_segment();
  
	init_serial();
	init_timer();
	init_idt();
	init_intr();
  init_pcb_pool();
  PCB* pcb = pcb_create();


  printk("a\n");
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);
  printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  //uint32_t p = PADDR(pcb -> pgdir);
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
  
  printk("c\n");

  for(; ph < eph; ph ++) {
    pa = (unsigned char*)ph->paddr; 

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
  //mm_alloc(pcb->pgdir, USTACKTOP - USTACKSIZE, USTACKSIZE);  
  printk("%s\n", "Here we go!");

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, USTACKTOP-8, entry);
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));

  switch_pcb(pcb);
  
  //printk("e\n");

	return 1;
};
