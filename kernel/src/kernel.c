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

PCB *current;
PCB *userpcb;


int page(){
  //init_page();
  /* After paging is enabled, we can jump to the high address to keep 
   * consistent with virtual memory, although it is not necessary. */
  //main_after_you();
  /*asm volatile (" addl %0, %%esp\n\t\
          jmp *%1": : "r"(0), "r"(main_after_you));
  */
  return 0;
}

int main(){
  //KOFFSET
  //init_page();
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
    //printf("%x %x\n", ph->paddr, ph->off);
    pa = (unsigned char*)ph->paddr; 
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }

  printk("%s\n", "Here we go!");

  //printf("%x %x\n", (int)elf->entry, *(int*)(elf->entry));
  //userpcb = pcb_create();
  //init_user_tf(userpcb, elf->entry);
  //switch_process(userpcb);
  //enable_interrupt();
  //asm volatile("mov %0, %%esp": : "i"(USTACKTOP));
  //uint32_t esp;
  //asm volatile("mov %%esp, %0" : "=a"(esp));
  //printk("%x", esp);
  //asm volatile("jmp %0" : : "m"(elf->entry));
  //enable_interrupt();
  //page();
  /*
  struct TrapFrame {
  //uint32_t esi, ebx, eax, eip, edx, error_code, eflags, ecx, cs, old_esp, edi, ebp;
  uint32_t edi, esi, ebp, old_esp, ebx, edx, ecx, eax;
  //uint32_t gs, fs, es, ds;
  int32_t irq;
  uint32_t error_code, eip, cs, eflags;
  //uint32_t esp;
};

  */
  //printk("%x\n", tss.esp0);
  struct TrapFrame tf;
  tf.ds = GD_UD | 3;
  tf.es = GD_UD | 3;
  tf.ss = GD_UD | 3;
  tf.esp = USTACKTOP;
  tf.cs = GD_UT | 3;
  tf.eflags = 0x2 | FL_IF;
  tf.eip = elf->entry;
  asm volatile("mov %0, %%ds" : : "r"(tf.ds));
  asm volatile("mov %0, %%es" : : "r"(tf.es));
  asm volatile("mov %0, %%fs" : : "r"(tf.fs));
  asm volatile("mov %0, %%gs" : : "r"(tf.gs));
  asm volatile("pushl %0" : : "r"((uint32_t)tf.ss));
  asm volatile("pushl %0" : : "r"(tf.esp));
  asm volatile("pushl %0" : : "r"(tf.eflags));
  asm volatile("pushl %0" : : "r"((uint32_t)tf.cs));
  asm volatile("pushl %0" : : "r"(tf.eip));
  asm volatile("iret"); 
  //asm volatile("push %0; push %1; push %2; push %3; push %4; push %5; push %7 ")
  /*asm volatile("\
          add $0x4, %%esp; \
          popal; \
          add $0x8, %%esp");*/

  //printk("%x %x %x\n", tf.eflags, tf.cs, tf.eip);
  //enter_user_space(&tf);
  //printk("h\n");
  //asm volatile("pushl %0" : : "r"((uint32_t)tf.ss));
  //asm volatile("pushl %0" : : "r"(tf.old_esp));
  //asm volatile("pushl %0" : : "m"(tf.eflags));
  //asm volatile("pushl %0" : : "m"((uint32_t)tf.cs));
  //asm volatile("pushl %0" : : "m"(tf.eip));
  //asm volatile("push $0xC0000000; push $0xC0000000; push $0xC0000000");
  //asm volatile("push $0xC0000000; push $0xC0000000; push $0xC0000000");
  //asm volatile("iret");
  //enable_interrupt();
  //((void(*)(void))elf->entry)();
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
