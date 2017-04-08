#define SEG_CODEDATA            1
#define SEG_32BIT               1
#define SEG_4KB_GRANULARITY     1
#define SEG_TSS_32BIT           0x9

#define DPL_KERNEL              0
#define DPL_USER                3

#define SEG_WRITABLE            0x2
#define SEG_READABLE            0x2
#define SEG_EXECUTABLE          0x8

#define NR_SEGMENTS             6
#define SEG_NULL                0 
#define SEG_KERNEL_CODE         1 
#define SEG_KERNEL_DATA         2
#define SEG_USER_CODE			3 
#define SEG_USER_DATA			4
#define SEG_TSS					5

#define SELECTOR_KERNEL(s)		( (s << 3) | DPL_KERNEL )
#define SELECTOR_USER(s)		( (s << 3) | DPL_USER )

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq

.globl vecsys; vecsys:  pushl $0;  pushl $0x80; jmp asm_do_irq

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq

.globl asm_do_irq
.extern irq_handle


asm_do_irq:
  cli
  pushl %ds
  pushl %es
  pushl %fs
  pushl %gs
	pushal

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
  movw %ax, %ds
  movw %ax, %es

  pushl %esp			# ???
  call irq_handle
  addl $4, %esp
  popal
  
  popl %gs
  popl %fs
  popl %es
  popl %ds
  addl $8, %esp
  sti
  iret