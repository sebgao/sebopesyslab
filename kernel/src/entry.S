#include "inc/mmu.h"
#include "inc/memlayout.h"
#define RELOC(x) ((x) - KERNBASE)

.text

.align 4

.globl _start
_start = entry

.globl main
.globl entry
entry:

  #movl $0x50000, %esp
  #pushl $0x0
  #pushl $0x0
  #pushl main
  #iret
  jmp main