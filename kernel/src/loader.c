#include "common.h"
#include "memory.h"
#include "process.h"

#include "inc/elf.h"
#include "inc/disk.h"
#include "inc/types.h"
#include "inc/mmu.h"
#include "inc/memlayout.h"
#include "pmap.h"

#define ELFADDR 0x0
uint8_t elf_t[1000];
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  //uint32_t p = PADDR(pcb -> pgdir);
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
    pa = (unsigned char*)ph->paddr; 

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
  //mm_alloc(pcb->pgdir, USTACKTOP - USTACKSIZE, USTACKSIZE);  
  //printk("%s\n", "Here we go!");

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, USTACKTOP-0x1FF, entry, 3);
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));

  //switch_pcb(pcb);
  
  //printk("e\n");
};

void empty_loader(PCB* pcb, void (*ptr)(void)){

  lcr3(PADDR(pcb -> pgdir));
  entry = (uint32_t)ptr;
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x1FF, entry, 0);
  lcr3(PADDR(kern_pgdir));

};