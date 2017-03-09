#include "inc/mmu.h"
.code16               
                      

.set PROT_MODE_CSEG, 0x8 
.set PROT_MODE_DSEG, 0x10
.set CR0_PE_ON,      0x1 

.globl bootmain
.globl start          
start:                
  cli                 
  xorw %ax, %ax
  movw %ax, %ds 
  movw %ax, %es 
  movw %ax, %ss 

seta20.1:
  inb     $0x64,%al   
  testb   $0x2,%al
  jnz     seta20.1

  movb    $0xd1,%al   
  outb    %al,$0x64

seta20.2:
  inb     $0x64,%al   
  testb   $0x2,%al
  jnz     seta20.2

  movb    $0xdf,%al   
  outb    %al,$0x60

  mov $0x13, %ah      
  mov $0x01, %al      
  mov $0x00, %bh      
  mov $0x4F, %bl      
  mov $(end-str), %cx 
  mov $str, %dx       
  mov %dx, %bp        
  mov $0x00, %dh      
  mov $0x00, %dl      
  int $0x10           

  lgdt    gdtdesc
  movl    %cr0, %eax
  orl     $CR0_PE_ON, %eax
  movl    %eax, %cr0
  ljmp    $PROT_MODE_CSEG, $protcseg

.code32               
protcseg:

  movw    $PROT_MODE_DSEG, %ax    
  movw    %ax, %ds         
  movw    %ax, %es                
  movw    %ax, %fs                
  movw    %ax, %gs                
  movw    %ax, %ss                
  

  movl    $0x8000, %esp
  call bootmain 
                

str:                 
  .ascii "Hello, world!"
end:                


.p2align 2
gdt:
  SEG_NULL        
  SEG(STA_X|STA_R, 0x0, 0xffffffff)
  SEG(STA_W, 0x0, 0xffffffff)

gdtdesc:
  .word   0x17
  .long   gdt
