#include "common.h"
#include "serial.h"
#include "i8259.h"
#include "timer.h"
#include "irq.h"
#include "keyboard.h"

#include "lib/syscall.h"
#include "lib/printk.h"

#include "inc/elf.h"
#include "inc/disk.h"
#include "inc/types.h"

#define elf   ((struct ELFHeader *) 0x10000)

int main(){
	init_serial();
	init_timer();
	init_idt();
	init_intr();



  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);

  printf("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph ++) {
    //printf("%x %x\n", ph->paddr, ph->off);
    pa = (unsigned char*)ph->paddr; 
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }

  printf("%s\n", "Here we go!");

  //printf("%x %x\n", (int)elf->entry, *(int*)(elf->entry));
  enable_interrupt();
  ((void(*)(void))elf->entry)();
  //uint32_t cur = 0;
  while(1){
    /*uint32_t tick = sys_get_tick();
    while(cur<tick){
        printf("%d\n", cur);
        cur++;
    }
    */
    /*if(sys_key_down('a'))printf("%s\n", "hahahah");;
    //printf("%c", get_lastkey());
    wait_for_interrupt();
    disable_interrupt();
    enable_interrupt();*/
  };
	return 1;
};
