
temp.o:     file format elf32-i386


Disassembly of section .text:

c0100000 <write_gdtr>:
	asm volatile("movl %0, %%cr3" : : "r"(cr3->val));
}

/* modify the value of GDTR */
static inline void
write_gdtr(void *addr, uint32_t size) {
c0100000:	55                   	push   %ebp
c0100001:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100003:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100006:	83 e8 01             	sub    $0x1,%eax
c0100009:	66 a3 b0 00 13 c0    	mov    %ax,0xc01300b0
	data[1] = (uint32_t)addr;
c010000f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100012:	66 a3 b2 00 13 c0    	mov    %ax,0xc01300b2
	data[2] = ((uint32_t)addr) >> 16;
c0100018:	8b 45 08             	mov    0x8(%ebp),%eax
c010001b:	c1 e8 10             	shr    $0x10,%eax
c010001e:	66 a3 b4 00 13 c0    	mov    %ax,0xc01300b4
	asm volatile("lgdt (%0)" : : "r"(data));
c0100024:	b8 b0 00 13 c0       	mov    $0xc01300b0,%eax
c0100029:	0f 01 10             	lgdtl  (%eax)
}
c010002c:	5d                   	pop    %ebp
c010002d:	c3                   	ret    

c010002e <write_tr>:
	asm volatile("lidt (%0)" : : "r"(data));
}

/* write TR */
static inline void
write_tr(uint16_t selector) {
c010002e:	55                   	push   %ebp
c010002f:	89 e5                	mov    %esp,%ebp
c0100031:	83 ec 04             	sub    $0x4,%esp
c0100034:	8b 45 08             	mov    0x8(%ebp),%eax
c0100037:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	asm volatile("ltr %0" : : "r"(selector));
c010003b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010003f:	0f 00 d8             	ltr    %ax
}
c0100042:	c9                   	leave  
c0100043:	c3                   	ret    

c0100044 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c0100044:	55                   	push   %ebp
c0100045:	89 e5                	mov    %esp,%ebp
c0100047:	57                   	push   %edi
c0100048:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c0100049:	8b 55 10             	mov    0x10(%ebp),%edx
c010004c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0100052:	89 d1                	mov    %edx,%ecx
c0100054:	89 df                	mov    %ebx,%edi
c0100056:	fc                   	cld    
c0100057:	f3 ab                	rep stos %eax,%es:(%edi)
}
c0100059:	5b                   	pop    %ebx
c010005a:	5f                   	pop    %edi
c010005b:	5d                   	pop    %ebp
c010005c:	c3                   	ret    

c010005d <get_kcr3>:
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
c010005d:	55                   	push   %ebp
c010005e:	89 e5                	mov    %esp,%ebp
	return &kcr3;
c0100060:	b8 00 e0 10 c0       	mov    $0xc010e000,%eax
}
c0100065:	5d                   	pop    %ebp
c0100066:	c3                   	ret    

c0100067 <get_kpdir>:

PDE* get_kpdir() {
c0100067:	55                   	push   %ebp
c0100068:	89 e5                	mov    %esp,%ebp
	return kpdir;
c010006a:	b8 00 f0 10 c0       	mov    $0xc010f000,%eax
}
c010006f:	5d                   	pop    %ebp
c0100070:	c3                   	ret    

c0100071 <get_kptable>:

PTE* get_kptable() {
c0100071:	55                   	push   %ebp
c0100072:	89 e5                	mov    %esp,%ebp
	return kptable;
c0100074:	b8 00 00 11 c0       	mov    $0xc0110000,%eax
}
c0100079:	5d                   	pop    %ebp
c010007a:	c3                   	ret    

c010007b <init_page>:

/* Build a page table for the kernel */
void
init_page(void) {
c010007b:	55                   	push   %ebp
c010007c:	89 e5                	mov    %esp,%ebp
c010007e:	83 ec 08             	sub    $0x8,%esp
	page_init();
c0100081:	e8 6c 05 00 00       	call   c01005f2 <page_init>
}
c0100086:	c9                   	leave  
c0100087:	c3                   	ret    

c0100088 <set_tss>:

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
c0100088:	55                   	push   %ebp
c0100089:	89 e5                	mov    %esp,%ebp
c010008b:	83 ec 10             	sub    $0x10,%esp
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
c010008e:	c7 05 08 00 13 c0 10 	movl   $0x10,0xc0130008
c0100095:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100098:	c7 45 fc 00 00 13 c0 	movl   $0xc0130000,-0x4(%ebp)
	uint32_t limit = sizeof(TSS) - 1;
c010009f:	c7 45 f8 63 00 00 00 	movl   $0x63,-0x8(%ebp)
	ptr->limit_15_0  = limit & 0xffff;
c01000a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01000a9:	89 c2                	mov    %eax,%edx
c01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ae:	66 89 10             	mov    %dx,(%eax)
	ptr->base_15_0   = base & 0xffff;
c01000b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01000b4:	89 c2                	mov    %eax,%edx
c01000b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01000b9:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->base_23_16  = (base >> 16) & 0xff;
c01000bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01000c0:	c1 e8 10             	shr    $0x10,%eax
c01000c3:	89 c2                	mov    %eax,%edx
c01000c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c8:	88 50 04             	mov    %dl,0x4(%eax)
	ptr->type = SEG_TSS_32BIT;
c01000cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ce:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01000d2:	83 e2 f0             	and    $0xfffffff0,%edx
c01000d5:	83 ca 09             	or     $0x9,%edx
c01000d8:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 0;
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01000e2:	83 e2 ef             	and    $0xffffffef,%edx
c01000e5:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = DPL_USER;
c01000e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000eb:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01000ef:	83 ca 60             	or     $0x60,%edx
c01000f2:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01000f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000f8:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01000fc:	83 ca 80             	or     $0xffffff80,%edx
c01000ff:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = limit >> 16;
c0100102:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100105:	c1 e8 10             	shr    $0x10,%eax
c0100108:	83 e0 0f             	and    $0xf,%eax
c010010b:	89 c2                	mov    %eax,%edx
c010010d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100110:	89 d1                	mov    %edx,%ecx
c0100112:	83 e1 0f             	and    $0xf,%ecx
c0100115:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100119:	83 e2 f0             	and    $0xfffffff0,%edx
c010011c:	09 ca                	or     %ecx,%edx
c010011e:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c0100121:	8b 45 08             	mov    0x8(%ebp),%eax
c0100124:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100128:	83 e2 ef             	and    $0xffffffef,%edx
c010012b:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c010012e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100131:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100135:	83 e2 df             	and    $0xffffffdf,%edx
c0100138:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c010013b:	8b 45 08             	mov    0x8(%ebp),%eax
c010013e:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100142:	83 ca 40             	or     $0x40,%edx
c0100145:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 0;
c0100148:	8b 45 08             	mov    0x8(%ebp),%eax
c010014b:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c010014f:	83 e2 7f             	and    $0x7f,%edx
c0100152:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = base >> 24;
c0100155:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100158:	c1 e8 18             	shr    $0x18,%eax
c010015b:	89 c2                	mov    %eax,%edx
c010015d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100160:	88 50 07             	mov    %dl,0x7(%eax)
}
c0100163:	c9                   	leave  
c0100164:	c3                   	ret    

c0100165 <set_tss_esp0>:

static void set_tss_esp0(uint32_t esp) {
c0100165:	55                   	push   %ebp
c0100166:	89 e5                	mov    %esp,%ebp
	tss.esp0 = esp;
c0100168:	8b 45 08             	mov    0x8(%ebp),%eax
c010016b:	a3 04 00 13 c0       	mov    %eax,0xc0130004
}
c0100170:	5d                   	pop    %ebp
c0100171:	c3                   	ret    

c0100172 <set_segment>:

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
c0100172:	55                   	push   %ebp
c0100173:	89 e5                	mov    %esp,%ebp
	ptr->limit_15_0  = 0xFFFF;
c0100175:	8b 45 08             	mov    0x8(%ebp),%eax
c0100178:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
	ptr->base_15_0   = 0x0;
c010017d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100180:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
	ptr->base_23_16  = 0x0;
c0100186:	8b 45 08             	mov    0x8(%ebp),%eax
c0100189:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = type;
c010018d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100190:	83 e0 0f             	and    $0xf,%eax
c0100193:	89 c2                	mov    %eax,%edx
c0100195:	8b 45 08             	mov    0x8(%ebp),%eax
c0100198:	89 d1                	mov    %edx,%ecx
c010019a:	83 e1 0f             	and    $0xf,%ecx
c010019d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01001a1:	83 e2 f0             	and    $0xfffffff0,%edx
c01001a4:	09 ca                	or     %ecx,%edx
c01001a6:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 1;
c01001a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01001ac:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01001b0:	83 ca 10             	or     $0x10,%edx
c01001b3:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = pl;
c01001b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01001b9:	83 e0 03             	and    $0x3,%eax
c01001bc:	89 c2                	mov    %eax,%edx
c01001be:	8b 45 08             	mov    0x8(%ebp),%eax
c01001c1:	83 e2 03             	and    $0x3,%edx
c01001c4:	89 d1                	mov    %edx,%ecx
c01001c6:	c1 e1 05             	shl    $0x5,%ecx
c01001c9:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01001cd:	83 e2 9f             	and    $0xffffff9f,%edx
c01001d0:	09 ca                	or     %ecx,%edx
c01001d2:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01001d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01001d8:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01001dc:	83 ca 80             	or     $0xffffff80,%edx
c01001df:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = 0xF;
c01001e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01001e5:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001e9:	83 ca 0f             	or     $0xf,%edx
c01001ec:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c01001ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01001f2:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001f6:	83 e2 ef             	and    $0xffffffef,%edx
c01001f9:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c01001fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01001ff:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100203:	83 e2 df             	and    $0xffffffdf,%edx
c0100206:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c0100209:	8b 45 08             	mov    0x8(%ebp),%eax
c010020c:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100210:	83 ca 40             	or     $0x40,%edx
c0100213:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 1;
c0100216:	8b 45 08             	mov    0x8(%ebp),%eax
c0100219:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c010021d:	83 ca 80             	or     $0xffffff80,%edx
c0100220:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = 0x0;
c0100223:	8b 45 08             	mov    0x8(%ebp),%eax
c0100226:	c6 40 07 00          	movb   $0x0,0x7(%eax)
}
c010022a:	5d                   	pop    %ebp
c010022b:	c3                   	ret    

c010022c <init_segment>:
/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
c010022c:	55                   	push   %ebp
c010022d:	89 e5                	mov    %esp,%ebp
	memset(gdt, 0, sizeof(gdt));
c010022f:	6a 30                	push   $0x30
c0100231:	6a 00                	push   $0x0
c0100233:	68 80 00 13 c0       	push   $0xc0130080
c0100238:	e8 07 fe ff ff       	call   c0100044 <memset>
c010023d:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c0100240:	6a 0a                	push   $0xa
c0100242:	6a 00                	push   $0x0
c0100244:	68 88 00 13 c0       	push   $0xc0130088
c0100249:	e8 24 ff ff ff       	call   c0100172 <set_segment>
c010024e:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c0100251:	6a 02                	push   $0x2
c0100253:	6a 00                	push   $0x0
c0100255:	68 90 00 13 c0       	push   $0xc0130090
c010025a:	e8 13 ff ff ff       	call   c0100172 <set_segment>
c010025f:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c0100262:	6a 0a                	push   $0xa
c0100264:	6a 03                	push   $0x3
c0100266:	68 98 00 13 c0       	push   $0xc0130098
c010026b:	e8 02 ff ff ff       	call   c0100172 <set_segment>
c0100270:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c0100273:	6a 02                	push   $0x2
c0100275:	6a 03                	push   $0x3
c0100277:	68 a0 00 13 c0       	push   $0xc01300a0
c010027c:	e8 f1 fe ff ff       	call   c0100172 <set_segment>
c0100281:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100284:	6a 30                	push   $0x30
c0100286:	68 80 00 13 c0       	push   $0xc0130080
c010028b:	e8 70 fd ff ff       	call   c0100000 <write_gdtr>
c0100290:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100293:	68 a8 00 13 c0       	push   $0xc01300a8
c0100298:	e8 eb fd ff ff       	call   c0100088 <set_tss>
c010029d:	83 c4 04             	add    $0x4,%esp
	write_tr( SELECTOR_USER(SEG_TSS) );
c01002a0:	6a 2b                	push   $0x2b
c01002a2:	e8 87 fd ff ff       	call   c010002e <write_tr>
c01002a7:	83 c4 04             	add    $0x4,%esp
}
c01002aa:	c9                   	leave  
c01002ab:	c3                   	ret    

c01002ac <enter_pcb>:


void enter_pcb(PCB* pcb)
{
c01002ac:	55                   	push   %ebp
c01002ad:	89 e5                	mov    %esp,%ebp
c01002af:	83 ec 10             	sub    $0x10,%esp
	set_tss_esp0((uint32_t)pcb->kstack);
c01002b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b5:	83 c0 0c             	add    $0xc,%eax
c01002b8:	50                   	push   %eax
c01002b9:	e8 a7 fe ff ff       	call   c0100165 <set_tss_esp0>
c01002be:	83 c4 04             	add    $0x4,%esp
	struct TrapFrame *tf = pcb->tf;
c01002c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c4:	8b 40 04             	mov    0x4(%eax),%eax
c01002c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//disable_interrupt();
	//asm volatile("cli");
	asm volatile("mov %0, %%ds" : : "r"(tf->ds));
c01002ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002cd:	8b 40 2c             	mov    0x2c(%eax),%eax
c01002d0:	8e d8                	mov    %eax,%ds
	//printk("0\n");
	asm volatile("mov %0, %%es" : : "r"(tf->es));
c01002d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002d5:	8b 40 28             	mov    0x28(%eax),%eax
c01002d8:	8e c0                	mov    %eax,%es
	//printk("0\n");
	asm volatile("mov %0, %%fs" : : "r"(tf->fs));
c01002da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002dd:	8b 40 24             	mov    0x24(%eax),%eax
c01002e0:	8e e0                	mov    %eax,%fs
	//printk("0\n");
	asm volatile("mov %0, %%gs" : : "r"(tf->gs));
c01002e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002e5:	8b 40 20             	mov    0x20(%eax),%eax
c01002e8:	8e e8                	mov    %eax,%gs
	//printk("0\n");
	asm volatile("pushl %0" : : "r"((uint32_t)tf->ss));
c01002ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002ed:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01002f1:	0f b7 c0             	movzwl %ax,%eax
c01002f4:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->esp));
c01002f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002f8:	8b 40 44             	mov    0x44(%eax),%eax
c01002fb:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eflags));
c01002fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01002ff:	8b 40 40             	mov    0x40(%eax),%eax
c0100302:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"((uint32_t)tf->cs));
c0100303:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100306:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010030a:	0f b7 c0             	movzwl %ax,%eax
c010030d:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eip));
c010030e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100311:	8b 40 38             	mov    0x38(%eax),%eax
c0100314:	50                   	push   %eax
	asm volatile("iret"); 
c0100315:	cf                   	iret   
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c010031b:	8b 45 08             	mov    0x8(%ebp),%eax
c010031e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0100324:	5d                   	pop    %ebp
c0100325:	c3                   	ret    

c0100326 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
c0100326:	55                   	push   %ebp
c0100327:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0100332:	5d                   	pop    %ebp
c0100333:	c3                   	ret    

c0100334 <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
c0100334:	55                   	push   %ebp
c0100335:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100337:	8b 45 08             	mov    0x8(%ebp),%eax
c010033a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c0100340:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100343:	c1 e8 0c             	shr    $0xc,%eax
c0100346:	25 ff ff 0f 00       	and    $0xfffff,%eax
c010034b:	89 c2                	mov    %eax,%edx
c010034d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100350:	89 d1                	mov    %edx,%ecx
c0100352:	c1 e1 0c             	shl    $0xc,%ecx
c0100355:	8b 10                	mov    (%eax),%edx
c0100357:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c010035d:	09 ca                	or     %ecx,%edx
c010035f:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c0100361:	8b 45 08             	mov    0x8(%ebp),%eax
c0100364:	0f b6 10             	movzbl (%eax),%edx
c0100367:	83 ca 01             	or     $0x1,%edx
c010036a:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c010036c:	8b 45 08             	mov    0x8(%ebp),%eax
c010036f:	0f b6 10             	movzbl (%eax),%edx
c0100372:	83 ca 02             	or     $0x2,%edx
c0100375:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	0f b6 10             	movzbl (%eax),%edx
c010037d:	83 ca 04             	or     $0x4,%edx
c0100380:	88 10                	mov    %dl,(%eax)
}
c0100382:	5d                   	pop    %ebp
c0100383:	c3                   	ret    

c0100384 <make_pte>:

void
make_pte(PTE *p, void *addr) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100387:	8b 45 08             	mov    0x8(%ebp),%eax
c010038a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c0100390:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100393:	c1 e8 0c             	shr    $0xc,%eax
c0100396:	25 ff ff 0f 00       	and    $0xfffff,%eax
c010039b:	89 c2                	mov    %eax,%edx
c010039d:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a0:	89 d1                	mov    %edx,%ecx
c01003a2:	c1 e1 0c             	shl    $0xc,%ecx
c01003a5:	8b 10                	mov    (%eax),%edx
c01003a7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01003ad:	09 ca                	or     %ecx,%edx
c01003af:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c01003b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b4:	0f b6 10             	movzbl (%eax),%edx
c01003b7:	83 ca 01             	or     $0x1,%edx
c01003ba:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01003bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01003bf:	0f b6 10             	movzbl (%eax),%edx
c01003c2:	83 ca 02             	or     $0x2,%edx
c01003c5:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c01003c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01003ca:	0f b6 10             	movzbl (%eax),%edx
c01003cd:	83 ca 04             	or     $0x4,%edx
c01003d0:	88 10                	mov    %dl,(%eax)
}
c01003d2:	5d                   	pop    %ebp
c01003d3:	c3                   	ret    

c01003d4 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
c01003d7:	83 ec 10             	sub    $0x10,%esp
c01003da:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01003e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01003e4:	89 c2                	mov    %eax,%edx
c01003e6:	ec                   	in     (%dx),%al
c01003e7:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01003ea:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01003ee:	0f b6 c0             	movzbl %al,%eax
c01003f1:	83 e0 20             	and    $0x20,%eax
c01003f4:	85 c0                	test   %eax,%eax
c01003f6:	0f 95 c0             	setne  %al
c01003f9:	0f b6 c0             	movzbl %al,%eax
}
c01003fc:	c9                   	leave  
c01003fd:	c3                   	ret    

c01003fe <serial_printc>:

static inline
void serial_printc(char ch) {
c01003fe:	55                   	push   %ebp
c01003ff:	89 e5                	mov    %esp,%ebp
c0100401:	83 ec 14             	sub    $0x14,%esp
c0100404:	8b 45 08             	mov    0x8(%ebp),%eax
c0100407:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010040a:	90                   	nop
c010040b:	e8 c4 ff ff ff       	call   c01003d4 <serial_idle>
c0100410:	85 c0                	test   %eax,%eax
c0100412:	74 f7                	je     c010040b <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0100414:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100418:	0f b6 c0             	movzbl %al,%eax
c010041b:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0100422:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100425:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100429:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010042c:	ee                   	out    %al,(%dx)
}
c010042d:	c9                   	leave  
c010042e:	c3                   	ret    

c010042f <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010042f:	55                   	push   %ebp
c0100430:	89 e5                	mov    %esp,%ebp
c0100432:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0100435:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100438:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010043b:	8b 45 08             	mov    0x8(%ebp),%eax
c010043e:	83 ec 04             	sub    $0x4,%esp
c0100441:	ff 75 f4             	pushl  -0xc(%ebp)
c0100444:	50                   	push   %eax
c0100445:	68 fe 03 10 c0       	push   $0xc01003fe
c010044a:	e8 8c 19 00 00       	call   c0101ddb <vfprintf>
c010044f:	83 c4 10             	add    $0x10,%esp
}
c0100452:	c9                   	leave  
c0100453:	c3                   	ret    

c0100454 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c0100454:	55                   	push   %ebp
c0100455:	89 e5                	mov    %esp,%ebp
c0100457:	57                   	push   %edi
c0100458:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c0100459:	8b 55 10             	mov    0x10(%ebp),%edx
c010045c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010045f:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0100462:	89 d1                	mov    %edx,%ecx
c0100464:	89 df                	mov    %ebx,%edi
c0100466:	fc                   	cld    
c0100467:	f3 ab                	rep stos %eax,%es:(%edi)
}
c0100469:	5b                   	pop    %ebx
c010046a:	5f                   	pop    %edi
c010046b:	5d                   	pop    %ebp
c010046c:	c3                   	ret    

c010046d <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c010046d:	55                   	push   %ebp
c010046e:	89 e5                	mov    %esp,%ebp
c0100470:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0100473:	8b 45 10             	mov    0x10(%ebp),%eax
c0100476:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c010047b:	77 16                	ja     c0100493 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c010047d:	ff 75 10             	pushl  0x10(%ebp)
c0100480:	68 9c 20 10 c0       	push   $0xc010209c
c0100485:	ff 75 0c             	pushl  0xc(%ebp)
c0100488:	ff 75 08             	pushl  0x8(%ebp)
c010048b:	e8 9f ff ff ff       	call   c010042f <printk>
c0100490:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0100493:	8b 45 10             	mov    0x10(%ebp),%eax
c0100496:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010049b:	c9                   	leave  
c010049c:	c3                   	ret    

c010049d <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c010049d:	55                   	push   %ebp
c010049e:	89 e5                	mov    %esp,%ebp
c01004a0:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01004a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a6:	c1 e8 0c             	shr    $0xc,%eax
c01004a9:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01004ae:	76 13                	jbe    c01004c3 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c01004b0:	83 ec 08             	sub    $0x8,%esp
c01004b3:	ff 75 10             	pushl  0x10(%ebp)
c01004b6:	68 c0 20 10 c0       	push   $0xc01020c0
c01004bb:	e8 6f ff ff ff       	call   c010042f <printk>
c01004c0:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c01004c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01004cb:	c9                   	leave  
c01004cc:	c3                   	ret    

c01004cd <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c01004cd:	55                   	push   %ebp
c01004ce:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c01004d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01004d3:	ba 00 27 17 c0       	mov    $0xc0172700,%edx
c01004d8:	29 d0                	sub    %edx,%eax
c01004da:	c1 f8 03             	sar    $0x3,%eax
c01004dd:	c1 e0 0c             	shl    $0xc,%eax
}
c01004e0:	5d                   	pop    %ebp
c01004e1:	c3                   	ret    

c01004e2 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c01004e2:	55                   	push   %ebp
c01004e3:	89 e5                	mov    %esp,%ebp
c01004e5:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01004e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004eb:	c1 e8 0c             	shr    $0xc,%eax
c01004ee:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01004f3:	76 10                	jbe    c0100505 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c01004f5:	83 ec 0c             	sub    $0xc,%esp
c01004f8:	68 e4 20 10 c0       	push   $0xc01020e4
c01004fd:	e8 2d ff ff ff       	call   c010042f <printk>
c0100502:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0100505:	8b 45 08             	mov    0x8(%ebp),%eax
c0100508:	c1 e8 0c             	shr    $0xc,%eax
c010050b:	c1 e0 03             	shl    $0x3,%eax
c010050e:	05 00 27 17 c0       	add    $0xc0172700,%eax
}
c0100513:	c9                   	leave  
c0100514:	c3                   	ret    

c0100515 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0100515:	55                   	push   %ebp
c0100516:	89 e5                	mov    %esp,%ebp
c0100518:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c010051b:	ff 75 08             	pushl  0x8(%ebp)
c010051e:	e8 aa ff ff ff       	call   c01004cd <page2pa>
c0100523:	83 c4 04             	add    $0x4,%esp
c0100526:	83 ec 04             	sub    $0x4,%esp
c0100529:	50                   	push   %eax
c010052a:	6a 52                	push   $0x52
c010052c:	68 03 21 10 c0       	push   $0xc0102103
c0100531:	e8 67 ff ff ff       	call   c010049d <_kaddr>
c0100536:	83 c4 10             	add    $0x10,%esp
}
c0100539:	c9                   	leave  
c010053a:	c3                   	ret    

c010053b <init_kern_pgdir>:

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
c010053b:	55                   	push   %ebp
c010053c:	89 e5                	mov    %esp,%ebp
c010053e:	53                   	push   %ebx
c010053f:	83 ec 24             	sub    $0x24,%esp
	int pdx;
	pde_t *pgdir = kpgdir;
c0100542:	c7 45 e8 00 20 13 c0 	movl   $0xc0132000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c0100549:	c7 45 f0 00 30 13 c0 	movl   $0xc0133000,-0x10(%ebp)

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c0100550:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100557:	eb 3a                	jmp    c0100593 <init_kern_pgdir+0x58>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
c0100559:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010055c:	05 00 03 00 00       	add    $0x300,%eax
c0100561:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100568:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010056b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c010056e:	83 ec 04             	sub    $0x4,%esp
c0100571:	ff 75 f0             	pushl  -0x10(%ebp)
c0100574:	6a 28                	push   $0x28
c0100576:	68 19 21 10 c0       	push   $0xc0102119
c010057b:	e8 ed fe ff ff       	call   c010046d <_paddr>
c0100580:	83 c4 10             	add    $0x10,%esp
c0100583:	83 c8 03             	or     $0x3,%eax
c0100586:	89 03                	mov    %eax,(%ebx)
		pgtable += NPTENTRIES;
c0100588:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c010058f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100593:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0100597:	7e c0                	jle    c0100559 <init_kern_pgdir+0x1e>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
c0100599:	c7 45 ec 00 f0 ff 07 	movl   $0x7fff000,-0x14(%ebp)
	pgtable--;
c01005a0:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c01005a4:	eb 18                	jmp    c01005be <init_kern_pgdir+0x83>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
c01005a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005a9:	83 c8 07             	or     $0x7,%eax
c01005ac:	89 c2                	mov    %eax,%edx
c01005ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b1:	89 10                	mov    %edx,(%eax)
		pgtable --;
c01005b3:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c01005b7:	81 6d ec 00 10 00 00 	subl   $0x1000,-0x14(%ebp)
c01005be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01005c2:	79 e2                	jns    c01005a6 <init_kern_pgdir+0x6b>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
c01005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c7:	a3 c0 26 17 c0       	mov    %eax,0xc01726c0
	lcr3(PADDR(kern_pgdir));	
c01005cc:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c01005d1:	83 ec 04             	sub    $0x4,%esp
c01005d4:	50                   	push   %eax
c01005d5:	6a 35                	push   $0x35
c01005d7:	68 19 21 10 c0       	push   $0xc0102119
c01005dc:	e8 8c fe ff ff       	call   c010046d <_paddr>
c01005e1:	83 c4 10             	add    $0x10,%esp
c01005e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01005e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005ea:	0f 22 d8             	mov    %eax,%cr3
}
c01005ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01005f0:	c9                   	leave  
c01005f1:	c3                   	ret    

c01005f2 <page_init>:
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
c01005f2:	55                   	push   %ebp
c01005f3:	89 e5                	mov    %esp,%ebp
c01005f5:	83 ec 18             	sub    $0x18,%esp
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	
c01005f8:	e8 3e ff ff ff       	call   c010053b <init_kern_pgdir>

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
c01005fd:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	for (i = 0; i < base; i++) {
c0100604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010060b:	eb 11                	jmp    c010061e <page_init+0x2c>
		pages[i].pp_ref = 1;
c010060d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100610:	66 c7 04 c5 04 27 17 	movw   $0x1,-0x3fe8d8fc(,%eax,8)
c0100617:	c0 01 00 
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
c010061a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010061e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100621:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100624:	77 e7                	ja     c010060d <page_init+0x1b>
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c0100626:	c7 45 f4 ff 7f 00 00 	movl   $0x7fff,-0xc(%ebp)
c010062d:	eb 31                	jmp    c0100660 <page_init+0x6e>
		pages[i].pp_ref = 0;
c010062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100632:	66 c7 04 c5 04 27 17 	movw   $0x0,-0x3fe8d8fc(,%eax,8)
c0100639:	c0 00 00 
		pages[i].pp_link = page_free_list;
c010063c:	8b 15 00 10 13 c0    	mov    0xc0131000,%edx
c0100642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100645:	89 14 c5 00 27 17 c0 	mov    %edx,-0x3fe8d900(,%eax,8)
		page_free_list = &pages[i];
c010064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064f:	c1 e0 03             	shl    $0x3,%eax
c0100652:	05 00 27 17 c0       	add    $0xc0172700,%eax
c0100657:	a3 00 10 13 c0       	mov    %eax,0xc0131000
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c010065c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100660:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100663:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100666:	76 c7                	jbe    c010062f <page_init+0x3d>
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
c0100668:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
c010066f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100672:	05 ff f9 00 00       	add    $0xf9ff,%eax
c0100677:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010067a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067d:	ba 00 00 00 00       	mov    $0x0,%edx
c0100682:	f7 75 ec             	divl   -0x14(%ebp)
c0100685:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100688:	29 d0                	sub    %edx,%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c0100691:	83 ec 0c             	sub    $0xc,%esp
c0100694:	6a 03                	push   $0x3
c0100696:	68 00 00 0a 00       	push   $0xa0000
c010069b:	52                   	push   %edx
c010069c:	68 00 00 0a 00       	push   $0xa0000
c01006a1:	50                   	push   %eax
c01006a2:	e8 a1 01 00 00       	call   c0100848 <boot_map_region>
c01006a7:	83 c4 20             	add    $0x20,%esp
}
c01006aa:	c9                   	leave  
c01006ab:	c3                   	ret    

c01006ac <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
c01006ac:	55                   	push   %ebp
c01006ad:	89 e5                	mov    %esp,%ebp
c01006af:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	struct PageInfo *p = page_free_list;
c01006b2:	a1 00 10 13 c0       	mov    0xc0131000,%eax
c01006b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL) return NULL;
c01006ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01006be:	75 07                	jne    c01006c7 <page_alloc+0x1b>
c01006c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01006c5:	eb 43                	jmp    c010070a <page_alloc+0x5e>
	if (alloc_flags & ALLOC_ZERO) {
c01006c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ca:	83 e0 01             	and    $0x1,%eax
c01006cd:	85 c0                	test   %eax,%eax
c01006cf:	74 21                	je     c01006f2 <page_alloc+0x46>
		memset(page2kva(p), 0, PGSIZE);
c01006d1:	83 ec 0c             	sub    $0xc,%esp
c01006d4:	ff 75 f4             	pushl  -0xc(%ebp)
c01006d7:	e8 39 fe ff ff       	call   c0100515 <page2kva>
c01006dc:	83 c4 10             	add    $0x10,%esp
c01006df:	83 ec 04             	sub    $0x4,%esp
c01006e2:	68 00 10 00 00       	push   $0x1000
c01006e7:	6a 00                	push   $0x0
c01006e9:	50                   	push   %eax
c01006ea:	e8 65 fd ff ff       	call   c0100454 <memset>
c01006ef:	83 c4 10             	add    $0x10,%esp
	}
	page_free_list = page_free_list -> pp_link;
c01006f2:	a1 00 10 13 c0       	mov    0xc0131000,%eax
c01006f7:	8b 00                	mov    (%eax),%eax
c01006f9:	a3 00 10 13 c0       	mov    %eax,0xc0131000
	p -> pp_link = NULL;
c01006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return p;
c0100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010070a:	c9                   	leave  
c010070b:	c3                   	ret    

c010070c <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
c010070c:	55                   	push   %ebp
c010070d:	89 e5                	mov    %esp,%ebp
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	//assert(pp->pp_ref == 0 && pp->pp_link == NULL);
	pp->pp_link = page_free_list;
c010070f:	8b 15 00 10 13 c0    	mov    0xc0131000,%edx
c0100715:	8b 45 08             	mov    0x8(%ebp),%eax
c0100718:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c010071a:	8b 45 08             	mov    0x8(%ebp),%eax
c010071d:	a3 00 10 13 c0       	mov    %eax,0xc0131000
}
c0100722:	5d                   	pop    %ebp
c0100723:	c3                   	ret    

c0100724 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
c0100724:	55                   	push   %ebp
c0100725:	89 e5                	mov    %esp,%ebp
	if (--pp->pp_ref == 0)
c0100727:	8b 45 08             	mov    0x8(%ebp),%eax
c010072a:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010072e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100731:	8b 45 08             	mov    0x8(%ebp),%eax
c0100734:	66 89 50 04          	mov    %dx,0x4(%eax)
c0100738:	8b 45 08             	mov    0x8(%ebp),%eax
c010073b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010073f:	66 85 c0             	test   %ax,%ax
c0100742:	75 0b                	jne    c010074f <page_decref+0x2b>
		page_free(pp);
c0100744:	ff 75 08             	pushl  0x8(%ebp)
c0100747:	e8 c0 ff ff ff       	call   c010070c <page_free>
c010074c:	83 c4 04             	add    $0x4,%esp
}
c010074f:	c9                   	leave  
c0100750:	c3                   	ret    

c0100751 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
c0100751:	55                   	push   %ebp
c0100752:	89 e5                	mov    %esp,%ebp
c0100754:	53                   	push   %ebx
c0100755:	83 ec 14             	sub    $0x14,%esp
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);
c0100758:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075b:	c1 e8 16             	shr    $0x16,%eax
c010075e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (pgdir[pdx] & PTE_P) {
c0100761:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010076b:	8b 45 08             	mov    0x8(%ebp),%eax
c010076e:	01 d0                	add    %edx,%eax
c0100770:	8b 00                	mov    (%eax),%eax
c0100772:	83 e0 01             	and    $0x1,%eax
c0100775:	85 c0                	test   %eax,%eax
c0100777:	74 31                	je     c01007aa <pgdir_walk+0x59>
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100779:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010077c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100783:	8b 45 08             	mov    0x8(%ebp),%eax
c0100786:	01 d0                	add    %edx,%eax
c0100788:	8b 00                	mov    (%eax),%eax
c010078a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010078f:	83 ec 04             	sub    $0x4,%esp
c0100792:	50                   	push   %eax
c0100793:	68 ae 00 00 00       	push   $0xae
c0100798:	68 19 21 10 c0       	push   $0xc0102119
c010079d:	e8 fb fc ff ff       	call   c010049d <_kaddr>
c01007a2:	83 c4 10             	add    $0x10,%esp
c01007a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01007a8:	eb 7c                	jmp    c0100826 <pgdir_walk+0xd5>
	}
	else {
		if (create == false) return NULL;
c01007aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01007ae:	75 0a                	jne    c01007ba <pgdir_walk+0x69>
c01007b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01007b5:	e9 89 00 00 00       	jmp    c0100843 <pgdir_walk+0xf2>

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
c01007ba:	83 ec 0c             	sub    $0xc,%esp
c01007bd:	6a 01                	push   $0x1
c01007bf:	e8 e8 fe ff ff       	call   c01006ac <page_alloc>
c01007c4:	83 c4 10             	add    $0x10,%esp
c01007c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p == NULL) return NULL;
c01007ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01007ce:	75 07                	jne    c01007d7 <pgdir_walk+0x86>
c01007d0:	b8 00 00 00 00       	mov    $0x0,%eax
c01007d5:	eb 6c                	jmp    c0100843 <pgdir_walk+0xf2>

		pgtable = page2kva(p);
c01007d7:	83 ec 0c             	sub    $0xc,%esp
c01007da:	ff 75 ec             	pushl  -0x14(%ebp)
c01007dd:	e8 33 fd ff ff       	call   c0100515 <page2kva>
c01007e2:	83 c4 10             	add    $0x10,%esp
c01007e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p -> pp_ref ++;
c01007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007eb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01007ef:	8d 50 01             	lea    0x1(%eax),%edx
c01007f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f5:	66 89 50 04          	mov    %dx,0x4(%eax)

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
c01007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01007fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100803:	8b 45 08             	mov    0x8(%ebp),%eax
c0100806:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c0100809:	83 ec 04             	sub    $0x4,%esp
c010080c:	ff 75 f4             	pushl  -0xc(%ebp)
c010080f:	68 b9 00 00 00       	push   $0xb9
c0100814:	68 19 21 10 c0       	push   $0xc0102119
c0100819:	e8 4f fc ff ff       	call   c010046d <_paddr>
c010081e:	83 c4 10             	add    $0x10,%esp
c0100821:	83 c8 07             	or     $0x7,%eax
c0100824:	89 03                	mov    %eax,(%ebx)
	}
	int ptx = PTX(va);
c0100826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100829:	c1 e8 0c             	shr    $0xc,%eax
c010082c:	25 ff 03 00 00       	and    $0x3ff,%eax
c0100831:	89 45 e8             	mov    %eax,-0x18(%ebp)
	return &pgtable[ptx];
c0100834:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100837:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010083e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100841:	01 d0                	add    %edx,%eax
}
c0100843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100846:	c9                   	leave  
c0100847:	c3                   	ret    

c0100848 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
c0100848:	55                   	push   %ebp
c0100849:	89 e5                	mov    %esp,%ebp
c010084b:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	int i;
	int n = size / PGSIZE;
c010084e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100851:	c1 e8 0c             	shr    $0xc,%eax
c0100854:	89 45 f0             	mov    %eax,-0x10(%ebp)

	for (i = 0; i < n; i ++) {
c0100857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010085e:	eb 41                	jmp    c01008a1 <boot_map_region+0x59>
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
c0100860:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100863:	83 ec 04             	sub    $0x4,%esp
c0100866:	6a 01                	push   $0x1
c0100868:	50                   	push   %eax
c0100869:	ff 75 08             	pushl  0x8(%ebp)
c010086c:	e8 e0 fe ff ff       	call   c0100751 <pgdir_walk>
c0100871:	83 c4 10             	add    $0x10,%esp
c0100874:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pte == NULL) return;
c0100877:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010087b:	75 02                	jne    c010087f <boot_map_region+0x37>
c010087d:	eb 2a                	jmp    c01008a9 <boot_map_region+0x61>

		*pte = pa | perm | PTE_P;
c010087f:	8b 45 18             	mov    0x18(%ebp),%eax
c0100882:	0b 45 14             	or     0x14(%ebp),%eax
c0100885:	83 c8 01             	or     $0x1,%eax
c0100888:	89 c2                	mov    %eax,%edx
c010088a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088d:	89 10                	mov    %edx,(%eax)

		va += PGSIZE;
c010088f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
		pa += PGSIZE;
c0100896:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
c010089d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01008a7:	7c b7                	jl     c0100860 <boot_map_region+0x18>
		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}
c01008a9:	c9                   	leave  
c01008aa:	c3                   	ret    

c01008ab <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
c01008ab:	55                   	push   %ebp
c01008ac:	89 e5                	mov    %esp,%ebp
c01008ae:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, true);
c01008b1:	83 ec 04             	sub    $0x4,%esp
c01008b4:	6a 01                	push   $0x1
c01008b6:	ff 75 10             	pushl  0x10(%ebp)
c01008b9:	ff 75 08             	pushl  0x8(%ebp)
c01008bc:	e8 90 fe ff ff       	call   c0100751 <pgdir_walk>
c01008c1:	83 c4 10             	add    $0x10,%esp
c01008c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) {
c01008c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01008cb:	75 07                	jne    c01008d4 <page_insert+0x29>
		return -1;
c01008cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01008d2:	eb 75                	jmp    c0100949 <page_insert+0x9e>
//		return -E_NO_MEM;
	}

	physaddr_t pa = page2pa(pp);
c01008d4:	83 ec 0c             	sub    $0xc,%esp
c01008d7:	ff 75 0c             	pushl  0xc(%ebp)
c01008da:	e8 ee fb ff ff       	call   c01004cd <page2pa>
c01008df:	83 c4 10             	add    $0x10,%esp
c01008e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (*pte & PTE_P) {
c01008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e8:	8b 00                	mov    (%eax),%eax
c01008ea:	83 e0 01             	and    $0x1,%eax
c01008ed:	85 c0                	test   %eax,%eax
c01008ef:	74 32                	je     c0100923 <page_insert+0x78>
		if (PTE_ADDR(*pte) == pa) {
c01008f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f4:	8b 00                	mov    (%eax),%eax
c01008f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01008fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01008fe:	75 12                	jne    c0100912 <page_insert+0x67>
			*pte = pa | perm | PTE_P;
c0100900:	8b 45 14             	mov    0x14(%ebp),%eax
c0100903:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100906:	83 c8 01             	or     $0x1,%eax
c0100909:	89 c2                	mov    %eax,%edx
c010090b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010090e:	89 10                	mov    %edx,(%eax)
c0100910:	eb 11                	jmp    c0100923 <page_insert+0x78>
		}
		else {
			page_remove(pgdir, va);
c0100912:	83 ec 08             	sub    $0x8,%esp
c0100915:	ff 75 10             	pushl  0x10(%ebp)
c0100918:	ff 75 08             	pushl  0x8(%ebp)
c010091b:	e8 7a 00 00 00       	call   c010099a <page_remove>
c0100920:	83 c4 10             	add    $0x10,%esp
		}
	}
	*pte = pa | perm | PTE_P;
c0100923:	8b 45 14             	mov    0x14(%ebp),%eax
c0100926:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100929:	83 c8 01             	or     $0x1,%eax
c010092c:	89 c2                	mov    %eax,%edx
c010092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100931:	89 10                	mov    %edx,(%eax)
	pp -> pp_ref ++;
c0100933:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100936:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010093a:	8d 50 01             	lea    0x1(%eax),%edx
c010093d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100940:	66 89 50 04          	mov    %dx,0x4(%eax)
	return 0;
c0100944:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100949:	c9                   	leave  
c010094a:	c3                   	ret    

c010094b <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
c010094b:	55                   	push   %ebp
c010094c:	89 e5                	mov    %esp,%ebp
c010094e:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, false);
c0100951:	83 ec 04             	sub    $0x4,%esp
c0100954:	6a 00                	push   $0x0
c0100956:	ff 75 0c             	pushl  0xc(%ebp)
c0100959:	ff 75 08             	pushl  0x8(%ebp)
c010095c:	e8 f0 fd ff ff       	call   c0100751 <pgdir_walk>
c0100961:	83 c4 10             	add    $0x10,%esp
c0100964:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) return NULL;
c0100967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010096b:	75 07                	jne    c0100974 <page_lookup+0x29>
c010096d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100972:	eb 24                	jmp    c0100998 <page_lookup+0x4d>
	if (pte_store != NULL) *pte_store = pte;
c0100974:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100978:	74 08                	je     c0100982 <page_lookup+0x37>
c010097a:	8b 45 10             	mov    0x10(%ebp),%eax
c010097d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100980:	89 10                	mov    %edx,(%eax)
	return pa2page(PTE_ADDR(*pte));
c0100982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100985:	8b 00                	mov    (%eax),%eax
c0100987:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010098c:	83 ec 0c             	sub    $0xc,%esp
c010098f:	50                   	push   %eax
c0100990:	e8 4d fb ff ff       	call   c01004e2 <pa2page>
c0100995:	83 c4 10             	add    $0x10,%esp
}
c0100998:	c9                   	leave  
c0100999:	c3                   	ret    

c010099a <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
c010099a:	55                   	push   %ebp
c010099b:	89 e5                	mov    %esp,%ebp
c010099d:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte;
	pte_t **pte_store = &pte;
c01009a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);
c01009a6:	83 ec 04             	sub    $0x4,%esp
c01009a9:	ff 75 f4             	pushl  -0xc(%ebp)
c01009ac:	ff 75 0c             	pushl  0xc(%ebp)
c01009af:	ff 75 08             	pushl  0x8(%ebp)
c01009b2:	e8 94 ff ff ff       	call   c010094b <page_lookup>
c01009b7:	83 c4 10             	add    $0x10,%esp
c01009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (p != NULL) {
c01009bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01009c1:	74 2a                	je     c01009ed <page_remove+0x53>
		**pte_store = 0;
c01009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009c6:	8b 00                	mov    (%eax),%eax
c01009c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(p);
c01009ce:	83 ec 0c             	sub    $0xc,%esp
c01009d1:	ff 75 f0             	pushl  -0x10(%ebp)
c01009d4:	e8 4b fd ff ff       	call   c0100724 <page_decref>
c01009d9:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
c01009dc:	83 ec 08             	sub    $0x8,%esp
c01009df:	ff 75 0c             	pushl  0xc(%ebp)
c01009e2:	ff 75 08             	pushl  0x8(%ebp)
c01009e5:	e8 05 00 00 00       	call   c01009ef <tlb_invalidate>
c01009ea:	83 c4 10             	add    $0x10,%esp
	}
}
c01009ed:	c9                   	leave  
c01009ee:	c3                   	ret    

c01009ef <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
c01009ef:	55                   	push   %ebp
c01009f0:	89 e5                	mov    %esp,%ebp
c01009f2:	83 ec 10             	sub    $0x10,%esp
c01009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
c01009fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01009fe:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
c0100a01:	c9                   	leave  
c0100a02:	c3                   	ret    

c0100a03 <free_pgdir>:

void free_pgdir(pde_t *pgdir)
{
c0100a03:	55                   	push   %ebp
c0100a04:	89 e5                	mov    %esp,%ebp
c0100a06:	83 ec 18             	sub    $0x18,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100a09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a10:	e9 09 01 00 00       	jmp    c0100b1e <free_pgdir+0x11b>
		if (pgdir[pdx] & PTE_P) {
c0100a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a22:	01 d0                	add    %edx,%eax
c0100a24:	8b 00                	mov    (%eax),%eax
c0100a26:	83 e0 01             	and    $0x1,%eax
c0100a29:	85 c0                	test   %eax,%eax
c0100a2b:	0f 84 e9 00 00 00    	je     c0100b1a <free_pgdir+0x117>
			if (kern_pgdir[pdx] & PTE_P) continue;
c0100a31:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c0100a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a39:	c1 e2 02             	shl    $0x2,%edx
c0100a3c:	01 d0                	add    %edx,%eax
c0100a3e:	8b 00                	mov    (%eax),%eax
c0100a40:	83 e0 01             	and    $0x1,%eax
c0100a43:	85 c0                	test   %eax,%eax
c0100a45:	74 05                	je     c0100a4c <free_pgdir+0x49>
c0100a47:	e9 ce 00 00 00       	jmp    c0100b1a <free_pgdir+0x117>
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a59:	01 d0                	add    %edx,%eax
c0100a5b:	8b 00                	mov    (%eax),%eax
c0100a5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100a62:	83 ec 04             	sub    $0x4,%esp
c0100a65:	50                   	push   %eax
c0100a66:	68 4f 01 00 00       	push   $0x14f
c0100a6b:	68 19 21 10 c0       	push   $0xc0102119
c0100a70:	e8 28 fa ff ff       	call   c010049d <_kaddr>
c0100a75:	83 c4 10             	add    $0x10,%esp
c0100a78:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100a7b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100a82:	eb 4a                	jmp    c0100ace <free_pgdir+0xcb>
				if (pgtable[ptx] & PTE_P) {
c0100a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a91:	01 d0                	add    %edx,%eax
c0100a93:	8b 00                	mov    (%eax),%eax
c0100a95:	83 e0 01             	and    $0x1,%eax
c0100a98:	85 c0                	test   %eax,%eax
c0100a9a:	74 2e                	je     c0100aca <free_pgdir+0xc7>
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
c0100a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100aa9:	01 d0                	add    %edx,%eax
c0100aab:	8b 00                	mov    (%eax),%eax
c0100aad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100ab2:	83 ec 0c             	sub    $0xc,%esp
c0100ab5:	50                   	push   %eax
c0100ab6:	e8 27 fa ff ff       	call   c01004e2 <pa2page>
c0100abb:	83 c4 10             	add    $0x10,%esp
c0100abe:	83 ec 0c             	sub    $0xc,%esp
c0100ac1:	50                   	push   %eax
c0100ac2:	e8 5d fc ff ff       	call   c0100724 <page_decref>
c0100ac7:	83 c4 10             	add    $0x10,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100aca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100ace:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100ad5:	7e ad                	jle    c0100a84 <free_pgdir+0x81>
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
c0100ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae4:	01 d0                	add    %edx,%eax
c0100ae6:	8b 00                	mov    (%eax),%eax
c0100ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100aed:	83 ec 0c             	sub    $0xc,%esp
c0100af0:	50                   	push   %eax
c0100af1:	e8 ec f9 ff ff       	call   c01004e2 <pa2page>
c0100af6:	83 c4 10             	add    $0x10,%esp
c0100af9:	83 ec 0c             	sub    $0xc,%esp
c0100afc:	50                   	push   %eax
c0100afd:	e8 22 fc ff ff       	call   c0100724 <page_decref>
c0100b02:	83 c4 10             	add    $0x10,%esp
			pgdir[pdx] = 0;
c0100b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b12:	01 d0                	add    %edx,%eax
c0100b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100b1a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b1e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100b25:	0f 8e ea fe ff ff    	jle    c0100a15 <free_pgdir+0x12>
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}
c0100b2b:	c9                   	leave  
c0100b2c:	c3                   	ret    

c0100b2d <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void
irq_handle(struct TrapFrame *tf) {
c0100b2d:	55                   	push   %ebp
c0100b2e:	89 e5                	mov    %esp,%ebp
c0100b30:	83 ec 38             	sub    $0x38,%esp
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0100b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b36:	8b 40 30             	mov    0x30(%eax),%eax
c0100b39:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b41:	8b 40 30             	mov    0x30(%eax),%eax
c0100b44:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100b49:	75 0e                	jne    c0100b59 <irq_handle+0x2c>
		//printk("ha");
		do_syscall(tf);
c0100b4b:	83 ec 0c             	sub    $0xc,%esp
c0100b4e:	ff 75 08             	pushl  0x8(%ebp)
c0100b51:	e8 3b 0b 00 00       	call   c0101691 <do_syscall>
c0100b56:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0100b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5c:	8b 40 30             	mov    0x30(%eax),%eax
c0100b5f:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0100b64:	75 0a                	jne    c0100b70 <irq_handle+0x43>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0100b66:	e8 dc 10 00 00       	call   c0101c47 <do_timer>
c0100b6b:	e9 83 00 00 00       	jmp    c0100bf3 <irq_handle+0xc6>
	} else if (tf->irq == 1001) {
c0100b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b73:	8b 40 30             	mov    0x30(%eax),%eax
c0100b76:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0100b7b:	75 76                	jne    c0100bf3 <irq_handle+0xc6>
c0100b7d:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100b87:	89 c2                	mov    %eax,%edx
c0100b89:	ec                   	in     (%dx),%al
c0100b8a:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0100b8d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0100b91:	0f b6 c0             	movzbl %al,%eax
c0100b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b97:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ba1:	89 c2                	mov    %eax,%edx
c0100ba3:	ec                   	in     (%dx),%al
c0100ba4:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0100ba7:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0100bab:	0f b6 c0             	movzbl %al,%eax
c0100bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0100bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100bb4:	83 c8 80             	or     $0xffffff80,%eax
c0100bb7:	0f b6 c0             	movzbl %al,%eax
c0100bba:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0100bc1:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100bc4:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100bc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100bcb:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0100bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100bcf:	0f b6 c0             	movzbl %al,%eax
c0100bd2:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0100bd9:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0100bdc:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100be0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100be3:	ee                   	out    %al,(%dx)
		press_key(code);
c0100be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be7:	83 ec 0c             	sub    $0xc,%esp
c0100bea:	50                   	push   %eax
c0100beb:	e8 c7 09 00 00       	call   c01015b7 <press_key>
c0100bf0:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
}
c0100bf3:	c9                   	leave  
c0100bf4:	c3                   	ret    

c0100bf5 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0100bf5:	55                   	push   %ebp
c0100bf6:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bfb:	83 e8 01             	sub    $0x1,%eax
c0100bfe:	66 a3 00 30 15 c0    	mov    %ax,0xc0153000
	data[1] = (uint32_t)addr;
c0100c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c07:	66 a3 02 30 15 c0    	mov    %ax,0xc0153002
	data[2] = ((uint32_t)addr) >> 16;
c0100c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c10:	c1 e8 10             	shr    $0x10,%eax
c0100c13:	66 a3 04 30 15 c0    	mov    %ax,0xc0153004
	asm volatile("lidt (%0)" : : "r"(data));
c0100c19:	b8 00 30 15 c0       	mov    $0xc0153000,%eax
c0100c1e:	0f 01 18             	lidtl  (%eax)
}
c0100c21:	5d                   	pop    %ebp
c0100c22:	c3                   	ret    

c0100c23 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100c23:	55                   	push   %ebp
c0100c24:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100c26:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c29:	89 c2                	mov    %eax,%edx
c0100c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2e:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100c31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c34:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3e:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100c42:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c45:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0100c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100c50:	83 e2 f0             	and    $0xfffffff0,%edx
c0100c53:	83 ca 0e             	or     $0xe,%edx
c0100c56:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c5c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100c60:	83 e2 ef             	and    $0xffffffef,%edx
c0100c63:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100c66:	8b 45 14             	mov    0x14(%ebp),%eax
c0100c69:	83 e0 03             	and    $0x3,%eax
c0100c6c:	89 c2                	mov    %eax,%edx
c0100c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c71:	83 e2 03             	and    $0x3,%edx
c0100c74:	89 d1                	mov    %edx,%ecx
c0100c76:	c1 e1 05             	shl    $0x5,%ecx
c0100c79:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100c7d:	83 e2 9f             	and    $0xffffff9f,%edx
c0100c80:	09 ca                	or     %ecx,%edx
c0100c82:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c88:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100c8c:	83 ca 80             	or     $0xffffff80,%edx
c0100c8f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100c92:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c95:	c1 e8 10             	shr    $0x10,%eax
c0100c98:	89 c2                	mov    %eax,%edx
c0100c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c9d:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100ca1:	5d                   	pop    %ebp
c0100ca2:	c3                   	ret    

c0100ca3 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100ca3:	55                   	push   %ebp
c0100ca4:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100ca6:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ca9:	89 c2                	mov    %eax,%edx
c0100cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cae:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cb4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cbe:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cc5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c0100cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ccc:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100cd0:	83 ca 0f             	or     $0xf,%edx
c0100cd3:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cd9:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100cdd:	83 e2 ef             	and    $0xffffffef,%edx
c0100ce0:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100ce3:	8b 45 14             	mov    0x14(%ebp),%eax
c0100ce6:	83 e0 03             	and    $0x3,%eax
c0100ce9:	89 c2                	mov    %eax,%edx
c0100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cee:	83 e2 03             	and    $0x3,%edx
c0100cf1:	89 d1                	mov    %edx,%ecx
c0100cf3:	c1 e1 05             	shl    $0x5,%ecx
c0100cf6:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100cfa:	83 e2 9f             	and    $0xffffff9f,%edx
c0100cfd:	09 ca                	or     %ecx,%edx
c0100cff:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d05:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d09:	83 ca 80             	or     $0xffffff80,%edx
c0100d0c:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d12:	c1 e8 10             	shr    $0x10,%eax
c0100d15:	89 c2                	mov    %eax,%edx
c0100d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1a:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100d1e:	5d                   	pop    %ebp
c0100d1f:	c3                   	ret    

c0100d20 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0100d20:	55                   	push   %ebp
c0100d21:	89 e5                	mov    %esp,%ebp
c0100d23:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100d26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100d2d:	eb 22                	jmp    c0100d51 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c0100d2f:	ba 1a 1d 10 c0       	mov    $0xc0101d1a,%edx
c0100d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d37:	c1 e0 03             	shl    $0x3,%eax
c0100d3a:	05 40 2a 1b c0       	add    $0xc01b2a40,%eax
c0100d3f:	6a 00                	push   $0x0
c0100d41:	52                   	push   %edx
c0100d42:	6a 01                	push   $0x1
c0100d44:	50                   	push   %eax
c0100d45:	e8 59 ff ff ff       	call   c0100ca3 <set_trap>
c0100d4a:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100d4d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100d51:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0100d58:	7e d5                	jle    c0100d2f <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0100d5a:	b8 63 1c 10 c0       	mov    $0xc0101c63,%eax
c0100d5f:	6a 00                	push   $0x0
c0100d61:	50                   	push   %eax
c0100d62:	6a 01                	push   $0x1
c0100d64:	68 40 2a 1b c0       	push   $0xc01b2a40
c0100d69:	e8 35 ff ff ff       	call   c0100ca3 <set_trap>
c0100d6e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0100d71:	b8 6c 1c 10 c0       	mov    $0xc0101c6c,%eax
c0100d76:	6a 00                	push   $0x0
c0100d78:	50                   	push   %eax
c0100d79:	6a 01                	push   $0x1
c0100d7b:	68 48 2a 1b c0       	push   $0xc01b2a48
c0100d80:	e8 1e ff ff ff       	call   c0100ca3 <set_trap>
c0100d85:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c0100d88:	b8 75 1c 10 c0       	mov    $0xc0101c75,%eax
c0100d8d:	6a 00                	push   $0x0
c0100d8f:	50                   	push   %eax
c0100d90:	6a 01                	push   $0x1
c0100d92:	68 50 2a 1b c0       	push   $0xc01b2a50
c0100d97:	e8 07 ff ff ff       	call   c0100ca3 <set_trap>
c0100d9c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0100d9f:	b8 7e 1c 10 c0       	mov    $0xc0101c7e,%eax
c0100da4:	6a 00                	push   $0x0
c0100da6:	50                   	push   %eax
c0100da7:	6a 01                	push   $0x1
c0100da9:	68 58 2a 1b c0       	push   $0xc01b2a58
c0100dae:	e8 f0 fe ff ff       	call   c0100ca3 <set_trap>
c0100db3:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0100db6:	b8 87 1c 10 c0       	mov    $0xc0101c87,%eax
c0100dbb:	6a 00                	push   $0x0
c0100dbd:	50                   	push   %eax
c0100dbe:	6a 01                	push   $0x1
c0100dc0:	68 60 2a 1b c0       	push   $0xc01b2a60
c0100dc5:	e8 d9 fe ff ff       	call   c0100ca3 <set_trap>
c0100dca:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0100dcd:	b8 90 1c 10 c0       	mov    $0xc0101c90,%eax
c0100dd2:	6a 00                	push   $0x0
c0100dd4:	50                   	push   %eax
c0100dd5:	6a 01                	push   $0x1
c0100dd7:	68 68 2a 1b c0       	push   $0xc01b2a68
c0100ddc:	e8 c2 fe ff ff       	call   c0100ca3 <set_trap>
c0100de1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0100de4:	b8 99 1c 10 c0       	mov    $0xc0101c99,%eax
c0100de9:	6a 00                	push   $0x0
c0100deb:	50                   	push   %eax
c0100dec:	6a 01                	push   $0x1
c0100dee:	68 70 2a 1b c0       	push   $0xc01b2a70
c0100df3:	e8 ab fe ff ff       	call   c0100ca3 <set_trap>
c0100df8:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0100dfb:	b8 a2 1c 10 c0       	mov    $0xc0101ca2,%eax
c0100e00:	6a 00                	push   $0x0
c0100e02:	50                   	push   %eax
c0100e03:	6a 01                	push   $0x1
c0100e05:	68 78 2a 1b c0       	push   $0xc01b2a78
c0100e0a:	e8 94 fe ff ff       	call   c0100ca3 <set_trap>
c0100e0f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0100e12:	b8 ab 1c 10 c0       	mov    $0xc0101cab,%eax
c0100e17:	6a 00                	push   $0x0
c0100e19:	50                   	push   %eax
c0100e1a:	6a 01                	push   $0x1
c0100e1c:	68 80 2a 1b c0       	push   $0xc01b2a80
c0100e21:	e8 7d fe ff ff       	call   c0100ca3 <set_trap>
c0100e26:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0100e29:	b8 b4 1c 10 c0       	mov    $0xc0101cb4,%eax
c0100e2e:	6a 00                	push   $0x0
c0100e30:	50                   	push   %eax
c0100e31:	6a 01                	push   $0x1
c0100e33:	68 88 2a 1b c0       	push   $0xc01b2a88
c0100e38:	e8 66 fe ff ff       	call   c0100ca3 <set_trap>
c0100e3d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c0100e40:	b8 bd 1c 10 c0       	mov    $0xc0101cbd,%eax
c0100e45:	6a 00                	push   $0x0
c0100e47:	50                   	push   %eax
c0100e48:	6a 01                	push   $0x1
c0100e4a:	68 90 2a 1b c0       	push   $0xc01b2a90
c0100e4f:	e8 4f fe ff ff       	call   c0100ca3 <set_trap>
c0100e54:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c0100e57:	b8 c6 1c 10 c0       	mov    $0xc0101cc6,%eax
c0100e5c:	6a 00                	push   $0x0
c0100e5e:	50                   	push   %eax
c0100e5f:	6a 01                	push   $0x1
c0100e61:	68 98 2a 1b c0       	push   $0xc01b2a98
c0100e66:	e8 38 fe ff ff       	call   c0100ca3 <set_trap>
c0100e6b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0100e6e:	b8 cf 1c 10 c0       	mov    $0xc0101ccf,%eax
c0100e73:	6a 00                	push   $0x0
c0100e75:	50                   	push   %eax
c0100e76:	6a 01                	push   $0x1
c0100e78:	68 a0 2a 1b c0       	push   $0xc01b2aa0
c0100e7d:	e8 21 fe ff ff       	call   c0100ca3 <set_trap>
c0100e82:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0100e85:	b8 d8 1c 10 c0       	mov    $0xc0101cd8,%eax
c0100e8a:	6a 00                	push   $0x0
c0100e8c:	50                   	push   %eax
c0100e8d:	6a 01                	push   $0x1
c0100e8f:	68 a8 2a 1b c0       	push   $0xc01b2aa8
c0100e94:	e8 0a fe ff ff       	call   c0100ca3 <set_trap>
c0100e99:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c0100e9c:	b8 ea 1c 10 c0       	mov    $0xc0101cea,%eax
c0100ea1:	6a 03                	push   $0x3
c0100ea3:	50                   	push   %eax
c0100ea4:	6a 01                	push   $0x1
c0100ea6:	68 40 2e 1b c0       	push   $0xc01b2e40
c0100eab:	e8 f3 fd ff ff       	call   c0100ca3 <set_trap>
c0100eb0:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0100eb3:	b8 f6 1c 10 c0       	mov    $0xc0101cf6,%eax
c0100eb8:	6a 00                	push   $0x0
c0100eba:	50                   	push   %eax
c0100ebb:	6a 01                	push   $0x1
c0100ebd:	68 40 2b 1b c0       	push   $0xc01b2b40
c0100ec2:	e8 5c fd ff ff       	call   c0100c23 <set_intr>
c0100ec7:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c0100eca:	b8 02 1d 10 c0       	mov    $0xc0101d02,%eax
c0100ecf:	6a 00                	push   $0x0
c0100ed1:	50                   	push   %eax
c0100ed2:	6a 01                	push   $0x1
c0100ed4:	68 48 2b 1b c0       	push   $0xc01b2b48
c0100ed9:	e8 45 fd ff ff       	call   c0100c23 <set_intr>
c0100ede:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0100ee1:	68 00 08 00 00       	push   $0x800
c0100ee6:	68 40 2a 1b c0       	push   $0xc01b2a40
c0100eeb:	e8 05 fd ff ff       	call   c0100bf5 <save_idt>
c0100ef0:	83 c4 08             	add    $0x8,%esp
}
c0100ef3:	c9                   	leave  
c0100ef4:	c3                   	ret    

c0100ef5 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c0100ef5:	55                   	push   %ebp
c0100ef6:	89 e5                	mov    %esp,%ebp
c0100ef8:	83 ec 40             	sub    $0x40,%esp
c0100efb:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0100f02:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100f06:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100f0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100f0d:	ee                   	out    %al,(%dx)
c0100f0e:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0100f15:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0100f19:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0100f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
c0100f21:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0100f28:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0100f2c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100f30:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100f33:	ee                   	out    %al,(%dx)
c0100f34:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0100f3b:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0100f3f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0100f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100f46:	ee                   	out    %al,(%dx)
c0100f47:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c0100f4e:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0100f52:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f56:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100f59:	ee                   	out    %al,(%dx)
c0100f5a:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c0100f61:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0100f65:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100f69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100f6c:	ee                   	out    %al,(%dx)
c0100f6d:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0100f74:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0100f78:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0100f7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c0100f80:	c9                   	leave  
c0100f81:	c3                   	ret    

c0100f82 <serial_idle>:

static inline
int serial_idle(void) {
c0100f82:	55                   	push   %ebp
c0100f83:	89 e5                	mov    %esp,%ebp
c0100f85:	83 ec 10             	sub    $0x10,%esp
c0100f88:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f92:	89 c2                	mov    %eax,%edx
c0100f94:	ec                   	in     (%dx),%al
c0100f95:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0100f98:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0100f9c:	0f b6 c0             	movzbl %al,%eax
c0100f9f:	83 e0 20             	and    $0x20,%eax
c0100fa2:	85 c0                	test   %eax,%eax
c0100fa4:	0f 95 c0             	setne  %al
c0100fa7:	0f b6 c0             	movzbl %al,%eax
}
c0100faa:	c9                   	leave  
c0100fab:	c3                   	ret    

c0100fac <serial_printc>:

static inline
void serial_printc(char ch) {
c0100fac:	55                   	push   %ebp
c0100fad:	89 e5                	mov    %esp,%ebp
c0100faf:	83 ec 14             	sub    $0x14,%esp
c0100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb5:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0100fb8:	90                   	nop
c0100fb9:	e8 c4 ff ff ff       	call   c0100f82 <serial_idle>
c0100fbe:	85 c0                	test   %eax,%eax
c0100fc0:	74 f7                	je     c0100fb9 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0100fc2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100fc6:	0f b6 c0             	movzbl %al,%eax
c0100fc9:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0100fd0:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100fd3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
}
c0100fdb:	c9                   	leave  
c0100fdc:	c3                   	ret    

c0100fdd <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0100fdd:	55                   	push   %ebp
c0100fde:	89 e5                	mov    %esp,%ebp
c0100fe0:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0100fe3:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fec:	83 ec 04             	sub    $0x4,%esp
c0100fef:	ff 75 f4             	pushl  -0xc(%ebp)
c0100ff2:	50                   	push   %eax
c0100ff3:	68 ac 0f 10 c0       	push   $0xc0100fac
c0100ff8:	e8 de 0d 00 00       	call   c0101ddb <vfprintf>
c0100ffd:	83 c4 10             	add    $0x10,%esp
}
c0101000:	c9                   	leave  
c0101001:	c3                   	ret    

c0101002 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c0101002:	55                   	push   %ebp
c0101003:	89 e5                	mov    %esp,%ebp
c0101005:	83 ec 70             	sub    $0x70,%esp
c0101008:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c010100f:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c0101013:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101017:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010101a:	ee                   	out    %al,(%dx)
c010101b:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c0101022:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c0101026:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010102d:	ee                   	out    %al,(%dx)
c010102e:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c0101035:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c0101039:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010103d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101040:	ee                   	out    %al,(%dx)
c0101041:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0101048:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c010104c:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101050:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101053:	ee                   	out    %al,(%dx)
c0101054:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c010105b:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c010105f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101063:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101066:	ee                   	out    %al,(%dx)
c0101067:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010106e:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c0101072:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101076:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101079:	ee                   	out    %al,(%dx)
c010107a:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0101081:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0101085:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101089:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010108c:	ee                   	out    %al,(%dx)
c010108d:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0101094:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101098:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c010109c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
c01010a0:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01010a7:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01010ab:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01010af:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01010b2:	ee                   	out    %al,(%dx)
c01010b3:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01010ba:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c01010be:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c01010c2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01010c5:	ee                   	out    %al,(%dx)
c01010c6:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c01010cd:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c01010d1:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c01010d5:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01010d8:	ee                   	out    %al,(%dx)
c01010d9:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c01010e0:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01010e4:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c01010e8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01010eb:	ee                   	out    %al,(%dx)
c01010ec:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c01010f3:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c01010f7:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c01010fb:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01010fe:	ee                   	out    %al,(%dx)
c01010ff:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c0101106:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c010110a:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c010110e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0101111:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c0101112:	c9                   	leave  
c0101113:	c3                   	ret    

c0101114 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0101114:	55                   	push   %ebp
c0101115:	89 e5                	mov    %esp,%ebp
c0101117:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c010111a:	c7 45 fc 9b 2e 00 00 	movl   $0x2e9b,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c0101121:	0f b6 05 00 50 10 c0 	movzbl 0xc0105000,%eax
c0101128:	0f b6 c0             	movzbl %al,%eax
c010112b:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c0101132:	88 45 f7             	mov    %al,-0x9(%ebp)
c0101135:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101139:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010113c:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c010113d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101140:	0f b6 c0             	movzbl %al,%eax
c0101143:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c010114a:	88 45 ef             	mov    %al,-0x11(%ebp)
c010114d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101151:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101154:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c0101155:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101158:	c1 f8 08             	sar    $0x8,%eax
c010115b:	0f b6 c0             	movzbl %al,%eax
c010115e:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0101165:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101168:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010116c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010116f:	ee                   	out    %al,(%dx)
}
c0101170:	c9                   	leave  
c0101171:	c3                   	ret    

c0101172 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101172:	55                   	push   %ebp
c0101173:	89 e5                	mov    %esp,%ebp
c0101175:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101178:	90                   	nop
c0101179:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101180:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	ec                   	in     (%dx),%al
c0101186:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101189:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010118d:	0f b6 c0             	movzbl %al,%eax
c0101190:	25 c0 00 00 00       	and    $0xc0,%eax
c0101195:	83 f8 40             	cmp    $0x40,%eax
c0101198:	75 df                	jne    c0101179 <waitdisk+0x7>
}
c010119a:	c9                   	leave  
c010119b:	c3                   	ret    

c010119c <readsect>:

static inline void
readsect(void *dst, int offset) {
c010119c:	55                   	push   %ebp
c010119d:	89 e5                	mov    %esp,%ebp
c010119f:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01011a2:	e8 cb ff ff ff       	call   c0101172 <waitdisk>
c01011a7:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01011ae:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01011b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01011b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01011b9:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011bd:	0f b6 c0             	movzbl %al,%eax
c01011c0:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01011c7:	88 45 ef             	mov    %al,-0x11(%ebp)
c01011ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01011ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01011d1:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011d5:	c1 f8 08             	sar    $0x8,%eax
c01011d8:	0f b6 c0             	movzbl %al,%eax
c01011db:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01011e2:	88 45 e7             	mov    %al,-0x19(%ebp)
c01011e5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01011e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01011ec:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011f0:	c1 f8 10             	sar    $0x10,%eax
c01011f3:	0f b6 c0             	movzbl %al,%eax
c01011f6:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01011fd:	88 45 df             	mov    %al,-0x21(%ebp)
c0101200:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101204:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101207:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101208:	8b 45 0c             	mov    0xc(%ebp),%eax
c010120b:	c1 f8 18             	sar    $0x18,%eax
c010120e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101211:	0f b6 c0             	movzbl %al,%eax
c0101214:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010121b:	88 45 d7             	mov    %al,-0x29(%ebp)
c010121e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101222:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101225:	ee                   	out    %al,(%dx)
c0101226:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c010122d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101231:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101235:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101238:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101239:	e8 34 ff ff ff       	call   c0101172 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010123e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101245:	eb 29                	jmp    c0101270 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101247:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010124a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101251:	8b 45 08             	mov    0x8(%ebp),%eax
c0101254:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101257:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c010125e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101261:	89 c2                	mov    %eax,%edx
c0101263:	ed                   	in     (%dx),%eax
c0101264:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101267:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010126a:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010126c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101270:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101274:	7e d1                	jle    c0101247 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101276:	c9                   	leave  
c0101277:	c3                   	ret    

c0101278 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101278:	55                   	push   %ebp
c0101279:	89 e5                	mov    %esp,%ebp
c010127b:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c010127e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101281:	8b 45 08             	mov    0x8(%ebp),%eax
c0101284:	01 d0                	add    %edx,%eax
c0101286:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101289:	8b 45 10             	mov    0x10(%ebp),%eax
c010128c:	99                   	cltd   
c010128d:	c1 ea 17             	shr    $0x17,%edx
c0101290:	01 d0                	add    %edx,%eax
c0101292:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101297:	29 d0                	sub    %edx,%eax
c0101299:	f7 d8                	neg    %eax
c010129b:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c010129e:	8b 45 10             	mov    0x10(%ebp),%eax
c01012a1:	99                   	cltd   
c01012a2:	c1 ea 17             	shr    $0x17,%edx
c01012a5:	01 d0                	add    %edx,%eax
c01012a7:	c1 f8 09             	sar    $0x9,%eax
c01012aa:	83 c0 01             	add    $0x1,%eax
c01012ad:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01012b0:	eb 19                	jmp    c01012cb <readseg+0x53>
        readsect(pa, offset);
c01012b2:	ff 75 10             	pushl  0x10(%ebp)
c01012b5:	ff 75 08             	pushl  0x8(%ebp)
c01012b8:	e8 df fe ff ff       	call   c010119c <readsect>
c01012bd:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01012c0:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c01012c7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01012cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01012d1:	72 df                	jb     c01012b2 <readseg+0x3a>
        readsect(pa, offset);
c01012d3:	c9                   	leave  
c01012d4:	c3                   	ret    

c01012d5 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01012db:	8b 45 10             	mov    0x10(%ebp),%eax
c01012de:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01012e3:	77 16                	ja     c01012fb <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01012e5:	ff 75 10             	pushl  0x10(%ebp)
c01012e8:	68 34 21 10 c0       	push   $0xc0102134
c01012ed:	ff 75 0c             	pushl  0xc(%ebp)
c01012f0:	ff 75 08             	pushl  0x8(%ebp)
c01012f3:	e8 e5 fc ff ff       	call   c0100fdd <printk>
c01012f8:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01012fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01012fe:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101303:	c9                   	leave  
c0101304:	c3                   	ret    

c0101305 <mm_alloc>:
extern void init_segment(void);
extern void init_page(void);
int main_after_you();
int a=0;
void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
c0101305:	55                   	push   %ebp
c0101306:	89 e5                	mov    %esp,%ebp
c0101308:	83 ec 28             	sub    $0x28,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
c010130b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010130e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101311:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101314:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0101319:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
c010131c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0101323:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101326:	8b 45 10             	mov    0x10(%ebp),%eax
c0101329:	01 c2                	add    %eax,%edx
c010132b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010132e:	01 d0                	add    %edx,%eax
c0101330:	83 e8 01             	sub    $0x1,%eax
c0101333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0101336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101339:	ba 00 00 00 00       	mov    $0x0,%edx
c010133e:	f7 75 e8             	divl   -0x18(%ebp)
c0101341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101344:	29 d0                	sub    %edx,%eax
c0101346:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c0101349:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010134c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010134f:	eb 2b                	jmp    c010137c <mm_alloc+0x77>
    p = page_alloc(0);
c0101351:	83 ec 0c             	sub    $0xc,%esp
c0101354:	6a 00                	push   $0x0
c0101356:	e8 51 f3 ff ff       	call   c01006ac <page_alloc>
c010135b:	83 c4 10             	add    $0x10,%esp
c010135e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
c0101361:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101364:	6a 07                	push   $0x7
c0101366:	50                   	push   %eax
c0101367:	ff 75 dc             	pushl  -0x24(%ebp)
c010136a:	ff 75 08             	pushl  0x8(%ebp)
c010136d:	e8 39 f5 ff ff       	call   c01008ab <page_insert>
c0101372:	83 c4 10             	add    $0x10,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c0101375:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010137c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010137f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0101382:	72 cd                	jb     c0101351 <mm_alloc+0x4c>
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}
c0101384:	c9                   	leave  
c0101385:	c3                   	ret    

c0101386 <main>:

uint32_t entry;

int main(){
c0101386:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c010138a:	83 e4 f0             	and    $0xfffffff0,%esp
c010138d:	ff 71 fc             	pushl  -0x4(%ecx)
c0101390:	55                   	push   %ebp
c0101391:	89 e5                	mov    %esp,%ebp
c0101393:	51                   	push   %ecx
c0101394:	83 ec 24             	sub    $0x24,%esp
  init_page();
c0101397:	e8 df ec ff ff       	call   c010007b <init_page>
  init_segment();
c010139c:	e8 8b ee ff ff       	call   c010022c <init_segment>
  
	init_serial();
c01013a1:	e8 4f fb ff ff       	call   c0100ef5 <init_serial>
	init_timer();
c01013a6:	e8 69 fd ff ff       	call   c0101114 <init_timer>
	init_idt();
c01013ab:	e8 70 f9 ff ff       	call   c0100d20 <init_idt>
	init_intr();
c01013b0:	e8 4d fc ff ff       	call   c0101002 <init_intr>
  init_pcb_pool();
c01013b5:	e8 26 05 00 00       	call   c01018e0 <init_pcb_pool>
  PCB* pcb = pcb_create();
c01013ba:	e8 b7 05 00 00       	call   c0101976 <pcb_create>
c01013bf:	89 45 ec             	mov    %eax,-0x14(%ebp)


  printk("a\n");
c01013c2:	83 ec 0c             	sub    $0xc,%esp
c01013c5:	68 57 21 10 c0       	push   $0xc0102157
c01013ca:	e8 0e fc ff ff       	call   c0100fdd <printk>
c01013cf:	83 c4 10             	add    $0x10,%esp
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);
c01013d2:	83 ec 04             	sub    $0x4,%esp
c01013d5:	68 00 90 01 00       	push   $0x19000
c01013da:	68 00 10 00 00       	push   $0x1000
c01013df:	68 40 32 1b c0       	push   $0xc01b3240
c01013e4:	e8 8f fe ff ff       	call   c0101278 <readseg>
c01013e9:	83 c4 10             	add    $0x10,%esp
  printk("b\n");
c01013ec:	83 ec 0c             	sub    $0xc,%esp
c01013ef:	68 5a 21 10 c0       	push   $0xc010215a
c01013f4:	e8 e4 fb ff ff       	call   c0100fdd <printk>
c01013f9:	83 c4 10             	add    $0x10,%esp
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c01013fc:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c0101401:	8b 00                	mov    (%eax),%eax
c0101403:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0101408:	0f 94 c0             	sete   %al
c010140b:	0f b6 c0             	movzbl %al,%eax
c010140e:	83 ec 08             	sub    $0x8,%esp
c0101411:	50                   	push   %eax
c0101412:	68 5d 21 10 c0       	push   $0xc010215d
c0101417:	e8 c1 fb ff ff       	call   c0100fdd <printk>
c010141c:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c010141f:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c0101424:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101427:	05 40 32 1b c0       	add    $0xc01b3240,%eax
c010142c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c010142f:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c0101434:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101438:	0f b7 c0             	movzwl %ax,%eax
c010143b:	c1 e0 05             	shl    $0x5,%eax
c010143e:	89 c2                	mov    %eax,%edx
c0101440:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101443:	01 d0                	add    %edx,%eax
c0101445:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //uint32_t p = PADDR(pcb -> pgdir);
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
c0101448:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010144b:	8b 40 08             	mov    0x8(%eax),%eax
c010144e:	83 ec 04             	sub    $0x4,%esp
c0101451:	50                   	push   %eax
c0101452:	6a 44                	push   $0x44
c0101454:	68 72 21 10 c0       	push   $0xc0102172
c0101459:	e8 77 fe ff ff       	call   c01012d5 <_paddr>
c010145e:	83 c4 10             	add    $0x10,%esp
c0101461:	89 45 e0             	mov    %eax,-0x20(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101464:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101467:	0f 22 d8             	mov    %eax,%cr3
  
  printk("c\n");
c010146a:	83 ec 0c             	sub    $0xc,%esp
c010146d:	68 86 21 10 c0       	push   $0xc0102186
c0101472:	e8 66 fb ff ff       	call   c0100fdd <printk>
c0101477:	83 c4 10             	add    $0x10,%esp

  for(; ph < eph; ph ++) {
c010147a:	eb 7c                	jmp    c01014f8 <main+0x172>
    pa = (unsigned char*)ph->paddr; 
c010147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010147f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101482:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101485:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101488:	8b 48 14             	mov    0x14(%eax),%ecx
c010148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010148e:	8b 50 08             	mov    0x8(%eax),%edx
c0101491:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101494:	8b 40 08             	mov    0x8(%eax),%eax
c0101497:	83 ec 04             	sub    $0x4,%esp
c010149a:	51                   	push   %ecx
c010149b:	52                   	push   %edx
c010149c:	50                   	push   %eax
c010149d:	e8 63 fe ff ff       	call   c0101305 <mm_alloc>
c01014a2:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, 102400+ph->off); 
c01014a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014a8:	8b 40 04             	mov    0x4(%eax),%eax
c01014ab:	05 00 90 01 00       	add    $0x19000,%eax
c01014b0:	89 c2                	mov    %eax,%edx
c01014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014b5:	8b 40 10             	mov    0x10(%eax),%eax
c01014b8:	83 ec 04             	sub    $0x4,%esp
c01014bb:	52                   	push   %edx
c01014bc:	50                   	push   %eax
c01014bd:	ff 75 e4             	pushl  -0x1c(%ebp)
c01014c0:	e8 b3 fd ff ff       	call   c0101278 <readseg>
c01014c5:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c01014c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014cb:	8b 50 10             	mov    0x10(%eax),%edx
c01014ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01014d1:	01 d0                	add    %edx,%eax
c01014d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01014d6:	eb 0c                	jmp    c01014e4 <main+0x15e>
c01014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014db:	8d 50 01             	lea    0x1(%eax),%edx
c01014de:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01014e1:	c6 00 00             	movb   $0x0,(%eax)
c01014e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014e7:	8b 50 14             	mov    0x14(%eax),%edx
c01014ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01014ed:	01 d0                	add    %edx,%eax
c01014ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01014f2:	77 e4                	ja     c01014d8 <main+0x152>
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
  
  printk("c\n");

  for(; ph < eph; ph ++) {
c01014f4:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01014f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01014fe:	0f 82 78 ff ff ff    	jb     c010147c <main+0xf6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101504:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c0101509:	8b 40 18             	mov    0x18(%eax),%eax
c010150c:	a3 54 1d 10 c0       	mov    %eax,0xc0101d54
  //mm_alloc(pcb->pgdir, USTACKTOP - USTACKSIZE, USTACKSIZE);  
  printk("%s\n", "Here we go!");
c0101511:	83 ec 08             	sub    $0x8,%esp
c0101514:	68 89 21 10 c0       	push   $0xc0102189
c0101519:	68 95 21 10 c0       	push   $0xc0102195
c010151e:	e8 ba fa ff ff       	call   c0100fdd <printk>
c0101523:	83 c4 10             	add    $0x10,%esp

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101526:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101529:	8b 40 08             	mov    0x8(%eax),%eax
c010152c:	83 ec 04             	sub    $0x4,%esp
c010152f:	68 00 80 00 00       	push   $0x8000
c0101534:	68 00 60 bf be       	push   $0xbebf6000
c0101539:	50                   	push   %eax
c010153a:	e8 c6 fd ff ff       	call   c0101305 <mm_alloc>
c010153f:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-8, entry);
c0101542:	a1 54 1d 10 c0       	mov    0xc0101d54,%eax
c0101547:	83 ec 04             	sub    $0x4,%esp
c010154a:	50                   	push   %eax
c010154b:	68 f8 df bf be       	push   $0xbebfdff8
c0101550:	ff 75 ec             	pushl  -0x14(%ebp)
c0101553:	e8 b7 03 00 00       	call   c010190f <init_pcb>
c0101558:	83 c4 10             	add    $0x10,%esp
  printk("%x\n", *((uint32_t*)entry));
c010155b:	a1 54 1d 10 c0       	mov    0xc0101d54,%eax
c0101560:	8b 00                	mov    (%eax),%eax
c0101562:	83 ec 08             	sub    $0x8,%esp
c0101565:	50                   	push   %eax
c0101566:	68 99 21 10 c0       	push   $0xc0102199
c010156b:	e8 6d fa ff ff       	call   c0100fdd <printk>
c0101570:	83 c4 10             	add    $0x10,%esp
  //lcr3(PADDR(pcb->pgdir));

  switch_pcb(pcb);
c0101573:	83 ec 0c             	sub    $0xc,%esp
c0101576:	ff 75 ec             	pushl  -0x14(%ebp)
c0101579:	e8 b1 04 00 00       	call   c0101a2f <switch_pcb>
c010157e:	83 c4 10             	add    $0x10,%esp
  
  //printk("e\n");

	return 1;
c0101581:	b8 01 00 00 00       	mov    $0x1,%eax
};
c0101586:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0101589:	c9                   	leave  
c010158a:	8d 61 fc             	lea    -0x4(%ecx),%esp
c010158d:	c3                   	ret    

c010158e <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c010158e:	55                   	push   %ebp
c010158f:	89 e5                	mov    %esp,%ebp
c0101591:	83 ec 04             	sub    $0x4,%esp
c0101594:	8b 45 08             	mov    0x8(%ebp),%eax
c0101597:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c010159a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c010159e:	83 e8 61             	sub    $0x61,%eax
c01015a1:	8b 04 85 40 30 15 c0 	mov    -0x3feacfc0(,%eax,4),%eax
}
c01015a8:	c9                   	leave  
c01015a9:	c3                   	ret    

c01015aa <get_lastkey>:
int8_t get_lastkey(){
c01015aa:	55                   	push   %ebp
c01015ab:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c01015ad:	a1 a8 30 15 c0       	mov    0xc01530a8,%eax
c01015b2:	83 c0 61             	add    $0x61,%eax
}
c01015b5:	5d                   	pop    %ebp
c01015b6:	c3                   	ret    

c01015b7 <press_key>:
void press_key(int code){
c01015b7:	55                   	push   %ebp
c01015b8:	89 e5                	mov    %esp,%ebp
c01015ba:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c01015bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c01015c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01015c7:	25 80 00 00 00       	and    $0x80,%eax
c01015cc:	85 c0                	test   %eax,%eax
c01015ce:	75 35                	jne    c0101605 <press_key+0x4e>
		for(;i<26;i++){
c01015d0:	eb 2b                	jmp    c01015fd <press_key+0x46>
			if(letter[i]==code){
c01015d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015d5:	8b 04 85 40 50 10 c0 	mov    -0x3fefafc0(,%eax,4),%eax
c01015dc:	3b 45 08             	cmp    0x8(%ebp),%eax
c01015df:	75 18                	jne    c01015f9 <press_key+0x42>
				keydown[i] = 1;
c01015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015e4:	c7 04 85 40 30 15 c0 	movl   $0x1,-0x3feacfc0(,%eax,4)
c01015eb:	01 00 00 00 
				lastkey = i;
c01015ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015f2:	a3 a8 30 15 c0       	mov    %eax,0xc01530a8
				return;
c01015f7:	eb 3b                	jmp    c0101634 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c01015f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01015fd:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101601:	7e cf                	jle    c01015d2 <press_key+0x1b>
c0101603:	eb 2f                	jmp    c0101634 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101605:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101609:	eb 23                	jmp    c010162e <press_key+0x77>
			if(letter[i]==code){
c010160b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010160e:	8b 04 85 40 50 10 c0 	mov    -0x3fefafc0(,%eax,4),%eax
c0101615:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101618:	75 10                	jne    c010162a <press_key+0x73>
				keydown[i] = 0;
c010161a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010161d:	c7 04 85 40 30 15 c0 	movl   $0x0,-0x3feacfc0(,%eax,4)
c0101624:	00 00 00 00 
				return;
c0101628:	eb 0a                	jmp    c0101634 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c010162a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010162e:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101632:	7e d7                	jle    c010160b <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101634:	c9                   	leave  
c0101635:	c3                   	ret    

c0101636 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101636:	55                   	push   %ebp
c0101637:	89 e5                	mov    %esp,%ebp
c0101639:	83 ec 10             	sub    $0x10,%esp
c010163c:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101643:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101646:	89 c2                	mov    %eax,%edx
c0101648:	ec                   	in     (%dx),%al
c0101649:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010164c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101650:	0f b6 c0             	movzbl %al,%eax
c0101653:	83 e0 20             	and    $0x20,%eax
c0101656:	85 c0                	test   %eax,%eax
c0101658:	0f 95 c0             	setne  %al
c010165b:	0f b6 c0             	movzbl %al,%eax
}
c010165e:	c9                   	leave  
c010165f:	c3                   	ret    

c0101660 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101660:	55                   	push   %ebp
c0101661:	89 e5                	mov    %esp,%ebp
c0101663:	83 ec 14             	sub    $0x14,%esp
c0101666:	8b 45 08             	mov    0x8(%ebp),%eax
c0101669:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010166c:	90                   	nop
c010166d:	e8 c4 ff ff ff       	call   c0101636 <serial_idle>
c0101672:	85 c0                	test   %eax,%eax
c0101674:	74 f7                	je     c010166d <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101676:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010167a:	0f b6 c0             	movzbl %al,%eax
c010167d:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101684:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101687:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010168b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010168e:	ee                   	out    %al,(%dx)
}
c010168f:	c9                   	leave  
c0101690:	c3                   	ret    

c0101691 <do_syscall>:
#include "lib/syscall.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();

void do_syscall(struct TrapFrame *tf) {
c0101691:	55                   	push   %ebp
c0101692:	89 e5                	mov    %esp,%ebp
c0101694:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c0101697:	8b 45 08             	mov    0x8(%ebp),%eax
c010169a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010169d:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c01016a2:	0f 84 85 00 00 00    	je     c010172d <do_syscall+0x9c>
c01016a8:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c01016ad:	77 1a                	ja     c01016c9 <do_syscall+0x38>
c01016af:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c01016b4:	74 63                	je     c0101719 <do_syscall+0x88>
c01016b6:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c01016bb:	77 66                	ja     c0101723 <do_syscall+0x92>
c01016bd:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c01016c2:	74 3e                	je     c0101702 <do_syscall+0x71>
c01016c4:	e9 0d 01 00 00       	jmp    c01017d6 <do_syscall+0x145>
c01016c9:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01016ce:	0f 84 8f 00 00 00    	je     c0101763 <do_syscall+0xd2>
c01016d4:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01016d9:	77 0c                	ja     c01016e7 <do_syscall+0x56>
c01016db:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c01016e0:	74 5a                	je     c010173c <do_syscall+0xab>
c01016e2:	e9 ef 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
c01016e7:	3d 14 05 00 00       	cmp    $0x514,%eax
c01016ec:	0f 84 a0 00 00 00    	je     c0101792 <do_syscall+0x101>
c01016f2:	3d 15 05 00 00       	cmp    $0x515,%eax
c01016f7:	0f 84 86 00 00 00    	je     c0101783 <do_syscall+0xf2>
c01016fd:	e9 d4 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0101702:	8b 45 08             	mov    0x8(%ebp),%eax
c0101705:	8b 40 10             	mov    0x10(%eax),%eax
c0101708:	0f be c0             	movsbl %al,%eax
c010170b:	50                   	push   %eax
c010170c:	e8 4f ff ff ff       	call   c0101660 <serial_printc>
c0101711:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
c0101714:	e9 bd 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
		case SYS_INIT_CACHE:
			initVCache();
c0101719:	e8 4c 03 00 00       	call   c0101a6a <initVCache>
		break;
c010171e:	e9 b3 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0101723:	e8 77 04 00 00       	call   c0101b9f <clearVRAM>
		break;
c0101728:	e9 a9 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c010172d:	e8 6d 04 00 00       	call   c0101b9f <clearVRAM>
			flushVCache();
c0101732:	e8 9c 03 00 00       	call   c0101ad3 <flushVCache>
		break;
c0101737:	e9 9a 00 00 00       	jmp    c01017d6 <do_syscall+0x145>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c010173c:	8b 45 08             	mov    0x8(%ebp),%eax
c010173f:	8b 40 14             	mov    0x14(%eax),%eax
c0101742:	0f b6 c0             	movzbl %al,%eax
c0101745:	8b 55 08             	mov    0x8(%ebp),%edx
c0101748:	8b 52 18             	mov    0x18(%edx),%edx
c010174b:	89 d1                	mov    %edx,%ecx
c010174d:	8b 55 08             	mov    0x8(%ebp),%edx
c0101750:	8b 52 10             	mov    0x10(%edx),%edx
c0101753:	83 ec 04             	sub    $0x4,%esp
c0101756:	50                   	push   %eax
c0101757:	51                   	push   %ecx
c0101758:	52                   	push   %edx
c0101759:	e8 da 03 00 00       	call   c0101b38 <setPixelAt>
c010175e:	83 c4 10             	add    $0x10,%esp
		break;
c0101761:	eb 73                	jmp    c01017d6 <do_syscall+0x145>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0101763:	8b 45 08             	mov    0x8(%ebp),%eax
c0101766:	8b 40 10             	mov    0x10(%eax),%eax
c0101769:	0f be c0             	movsbl %al,%eax
c010176c:	83 ec 0c             	sub    $0xc,%esp
c010176f:	50                   	push   %eax
c0101770:	e8 19 fe ff ff       	call   c010158e <get_key>
c0101775:	83 c4 10             	add    $0x10,%esp
c0101778:	0f be d0             	movsbl %al,%edx
c010177b:	8b 45 08             	mov    0x8(%ebp),%eax
c010177e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101781:	eb 53                	jmp    c01017d6 <do_syscall+0x145>
		case SYS_GET_TICK:
			tf->eax = tick();
c0101783:	e8 d1 04 00 00       	call   c0101c59 <tick>
c0101788:	89 c2                	mov    %eax,%edx
c010178a:	8b 45 08             	mov    0x8(%ebp),%eax
c010178d:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0101790:	eb 44                	jmp    c01017d6 <do_syscall+0x145>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101799:	eb 34                	jmp    c01017cf <do_syscall+0x13e>
				if(!timer_handlers[i].used){
c010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010179e:	8b 04 c5 04 27 1b c0 	mov    -0x3fe4d8fc(,%eax,8),%eax
c01017a5:	85 c0                	test   %eax,%eax
c01017a7:	75 22                	jne    c01017cb <do_syscall+0x13a>
					timer_handlers[i].ptr = (void*)tf->ebx;
c01017a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01017ac:	8b 40 10             	mov    0x10(%eax),%eax
c01017af:	89 c2                	mov    %eax,%edx
c01017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017b4:	89 14 c5 00 27 1b c0 	mov    %edx,-0x3fe4d900(,%eax,8)
					timer_handlers[i].used = 1;
c01017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017be:	c7 04 c5 04 27 1b c0 	movl   $0x1,-0x3fe4d8fc(,%eax,8)
c01017c5:	01 00 00 00 
					break;
c01017c9:	eb 0a                	jmp    c01017d5 <do_syscall+0x144>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c01017cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01017cf:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01017d3:	7e c6                	jle    c010179b <do_syscall+0x10a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c01017d5:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c01017d6:	c9                   	leave  
c01017d7:	c3                   	ret    

c01017d8 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01017d8:	55                   	push   %ebp
c01017d9:	89 e5                	mov    %esp,%ebp
c01017db:	83 ec 10             	sub    $0x10,%esp
c01017de:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01017e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e8:	89 c2                	mov    %eax,%edx
c01017ea:	ec                   	in     (%dx),%al
c01017eb:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01017ee:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01017f2:	0f b6 c0             	movzbl %al,%eax
c01017f5:	83 e0 20             	and    $0x20,%eax
c01017f8:	85 c0                	test   %eax,%eax
c01017fa:	0f 95 c0             	setne  %al
c01017fd:	0f b6 c0             	movzbl %al,%eax
}
c0101800:	c9                   	leave  
c0101801:	c3                   	ret    

c0101802 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101802:	55                   	push   %ebp
c0101803:	89 e5                	mov    %esp,%ebp
c0101805:	83 ec 14             	sub    $0x14,%esp
c0101808:	8b 45 08             	mov    0x8(%ebp),%eax
c010180b:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010180e:	90                   	nop
c010180f:	e8 c4 ff ff ff       	call   c01017d8 <serial_idle>
c0101814:	85 c0                	test   %eax,%eax
c0101816:	74 f7                	je     c010180f <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101818:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010181c:	0f b6 c0             	movzbl %al,%eax
c010181f:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101826:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101829:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010182d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101830:	ee                   	out    %al,(%dx)
}
c0101831:	c9                   	leave  
c0101832:	c3                   	ret    

c0101833 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101833:	55                   	push   %ebp
c0101834:	89 e5                	mov    %esp,%ebp
c0101836:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101839:	8d 45 0c             	lea    0xc(%ebp),%eax
c010183c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010183f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101842:	83 ec 04             	sub    $0x4,%esp
c0101845:	ff 75 f4             	pushl  -0xc(%ebp)
c0101848:	50                   	push   %eax
c0101849:	68 02 18 10 c0       	push   $0xc0101802
c010184e:	e8 88 05 00 00       	call   c0101ddb <vfprintf>
c0101853:	83 c4 10             	add    $0x10,%esp
}
c0101856:	c9                   	leave  
c0101857:	c3                   	ret    

c0101858 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101858:	55                   	push   %ebp
c0101859:	89 e5                	mov    %esp,%ebp
c010185b:	57                   	push   %edi
c010185c:	56                   	push   %esi
c010185d:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c010185e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101861:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101864:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101867:	89 c1                	mov    %eax,%ecx
c0101869:	89 d6                	mov    %edx,%esi
c010186b:	89 df                	mov    %ebx,%edi
c010186d:	fc                   	cld    
c010186e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101870:	5b                   	pop    %ebx
c0101871:	5e                   	pop    %esi
c0101872:	5f                   	pop    %edi
c0101873:	5d                   	pop    %ebp
c0101874:	c3                   	ret    

c0101875 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0101875:	55                   	push   %ebp
c0101876:	89 e5                	mov    %esp,%ebp
c0101878:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010187b:	8b 45 10             	mov    0x10(%ebp),%eax
c010187e:	c1 e8 0c             	shr    $0xc,%eax
c0101881:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0101886:	76 13                	jbe    c010189b <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0101888:	83 ec 08             	sub    $0x8,%esp
c010188b:	ff 75 10             	pushl  0x10(%ebp)
c010188e:	68 a0 21 10 c0       	push   $0xc01021a0
c0101893:	e8 9b ff ff ff       	call   c0101833 <printk>
c0101898:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c010189b:	8b 45 10             	mov    0x10(%ebp),%eax
c010189e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01018a3:	c9                   	leave  
c01018a4:	c3                   	ret    

c01018a5 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c01018a5:	55                   	push   %ebp
c01018a6:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c01018a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01018ab:	ba 00 27 17 c0       	mov    $0xc0172700,%edx
c01018b0:	29 d0                	sub    %edx,%eax
c01018b2:	c1 f8 03             	sar    $0x3,%eax
c01018b5:	c1 e0 0c             	shl    $0xc,%eax
}
c01018b8:	5d                   	pop    %ebp
c01018b9:	c3                   	ret    

c01018ba <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c01018ba:	55                   	push   %ebp
c01018bb:	89 e5                	mov    %esp,%ebp
c01018bd:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01018c0:	ff 75 08             	pushl  0x8(%ebp)
c01018c3:	e8 dd ff ff ff       	call   c01018a5 <page2pa>
c01018c8:	83 c4 04             	add    $0x4,%esp
c01018cb:	83 ec 04             	sub    $0x4,%esp
c01018ce:	50                   	push   %eax
c01018cf:	6a 52                	push   $0x52
c01018d1:	68 c2 21 10 c0       	push   $0xc01021c2
c01018d6:	e8 9a ff ff ff       	call   c0101875 <_kaddr>
c01018db:	83 c4 10             	add    $0x10,%esp
}
c01018de:	c9                   	leave  
c01018df:	c3                   	ret    

c01018e0 <init_pcb_pool>:
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_pcb_pool()
{
c01018e0:	55                   	push   %ebp
c01018e1:	89 e5                	mov    %esp,%ebp
c01018e3:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01018e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018ed:	eb 18                	jmp    c0101907 <init_pcb_pool+0x27>
		PCBPool[i].used = 0;
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c01018f8:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c01018fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
};*/

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101903:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101907:	83 7d fc 63          	cmpl   $0x63,-0x4(%ebp)
c010190b:	76 e2                	jbe    c01018ef <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
}
c010190d:	c9                   	leave  
c010190e:	c3                   	ret    

c010190f <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry)
{
c010190f:	55                   	push   %ebp
c0101910:	89 e5                	mov    %esp,%ebp
c0101912:	83 ec 10             	sub    $0x10,%esp
	struct TrapFrame *tf = (p->tf);
c0101915:	8b 45 08             	mov    0x8(%ebp),%eax
c0101918:	8b 40 04             	mov    0x4(%eax),%eax
c010191b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	tf->ds = GD_UD | 3;
c010191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101921:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
	tf->es = GD_UD | 3;
c0101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192b:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
	tf->ss = GD_UD | 3;
c0101932:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101935:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
	tf->fs = GD_UD | 3;
c010193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193e:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
	tf->gs = GD_UD | 3;
c0101945:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101948:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
	tf->esp = ustack;
c010194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101952:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101955:	89 50 44             	mov    %edx,0x44(%eax)
	tf->cs = GD_UT | 3;
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->eflags = 0x2 | FL_IF;
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	tf->eip = entry;
c010196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196e:	8b 55 10             	mov    0x10(%ebp),%edx
c0101971:	89 50 38             	mov    %edx,0x38(%eax)
}
c0101974:	c9                   	leave  
c0101975:	c3                   	ret    

c0101976 <pcb_create>:

PCB* pcb_create()
{
c0101976:	55                   	push   %ebp
c0101977:	89 e5                	mov    %esp,%ebp
c0101979:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010197c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101983:	eb 1a                	jmp    c010199f <pcb_create+0x29>
		if(!PCBPool[i].used)break;
c0101985:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101988:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c010198e:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c0101993:	8b 00                	mov    (%eax),%eax
c0101995:	85 c0                	test   %eax,%eax
c0101997:	75 02                	jne    c010199b <pcb_create+0x25>
c0101999:	eb 0a                	jmp    c01019a5 <pcb_create+0x2f>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010199b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010199f:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01019a3:	76 e0                	jbe    c0101985 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019a8:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c01019ae:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c01019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c01019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019b9:	6b c0 4c             	imul   $0x4c,%eax,%eax
c01019bc:	8d 90 80 36 1b c0    	lea    -0x3fe4c980(%eax),%edx
c01019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019c5:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c01019c8:	83 ec 0c             	sub    $0xc,%esp
c01019cb:	6a 01                	push   $0x1
c01019cd:	e8 da ec ff ff       	call   c01006ac <page_alloc>
c01019d2:	83 c4 10             	add    $0x10,%esp
c01019d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c01019d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01019dc:	75 07                	jne    c01019e5 <pcb_create+0x6f>
c01019de:	b8 00 00 00 00       	mov    $0x0,%eax
c01019e3:	eb 48                	jmp    c0101a2d <pcb_create+0xb7>
	p->pgdir = page2kva(pp);
c01019e5:	83 ec 0c             	sub    $0xc,%esp
c01019e8:	ff 75 ec             	pushl  -0x14(%ebp)
c01019eb:	e8 ca fe ff ff       	call   c01018ba <page2kva>
c01019f0:	83 c4 10             	add    $0x10,%esp
c01019f3:	89 c2                	mov    %eax,%edx
c01019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019f8:	89 50 08             	mov    %edx,0x8(%eax)
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c01019fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019fe:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0101a02:	8d 50 01             	lea    0x1(%eax),%edx
c0101a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a08:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0101a0c:	8b 15 c0 26 17 c0    	mov    0xc01726c0,%edx
c0101a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a15:	8b 40 08             	mov    0x8(%eax),%eax
c0101a18:	83 ec 04             	sub    $0x4,%esp
c0101a1b:	68 00 10 00 00       	push   $0x1000
c0101a20:	52                   	push   %edx
c0101a21:	50                   	push   %eax
c0101a22:	e8 31 fe ff ff       	call   c0101858 <memcpy>
c0101a27:	83 c4 10             	add    $0x10,%esp
	return p;
c0101a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0101a2d:	c9                   	leave  
c0101a2e:	c3                   	ret    

c0101a2f <switch_pcb>:

void switch_pcb(PCB* pcb){
c0101a2f:	55                   	push   %ebp
c0101a30:	89 e5                	mov    %esp,%ebp
c0101a32:	83 ec 08             	sub    $0x8,%esp
	current = pcb;
c0101a35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a38:	a3 40 36 1b c0       	mov    %eax,0xc01b3640
	enter_pcb(pcb);
c0101a3d:	83 ec 0c             	sub    $0xc,%esp
c0101a40:	ff 75 08             	pushl  0x8(%ebp)
c0101a43:	e8 64 e8 ff ff       	call   c01002ac <enter_pcb>
c0101a48:	83 c4 10             	add    $0x10,%esp
}
c0101a4b:	c9                   	leave  
c0101a4c:	c3                   	ret    

c0101a4d <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0101a4d:	55                   	push   %ebp
c0101a4e:	89 e5                	mov    %esp,%ebp
c0101a50:	57                   	push   %edi
c0101a51:	56                   	push   %esi
c0101a52:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101a53:	8b 45 10             	mov    0x10(%ebp),%eax
c0101a56:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101a5c:	89 c1                	mov    %eax,%ecx
c0101a5e:	89 d6                	mov    %edx,%esi
c0101a60:	89 df                	mov    %ebx,%edi
c0101a62:	fc                   	cld    
c0101a63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101a65:	5b                   	pop    %ebx
c0101a66:	5e                   	pop    %esi
c0101a67:	5f                   	pop    %edi
c0101a68:	5d                   	pop    %ebp
c0101a69:	c3                   	ret    

c0101a6a <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0101a6a:	55                   	push   %ebp
c0101a6b:	89 e5                	mov    %esp,%ebp
c0101a6d:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0101a70:	68 80 3e 00 00       	push   $0x3e80
c0101a75:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101a7a:	68 c0 30 15 c0       	push   $0xc01530c0
c0101a7f:	e8 c9 ff ff ff       	call   c0101a4d <memcpy>
c0101a84:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0101a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a8e:	eb 0f                	jmp    c0101a9f <initVCache+0x35>
		VDIRTY[x] = 0;
c0101a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a93:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101a98:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0101a9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a9f:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101aa6:	7e e8                	jle    c0101a90 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0101aa8:	c9                   	leave  
c0101aa9:	c3                   	ret    

c0101aaa <refreshVCache>:
void refreshVCache(){
c0101aaa:	55                   	push   %ebp
c0101aab:	89 e5                	mov    %esp,%ebp
c0101aad:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101ab0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101ab7:	eb 0f                	jmp    c0101ac8 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0101ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101abc:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101ac1:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101ac4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ac8:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101acf:	7e e8                	jle    c0101ab9 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0101ad1:	c9                   	leave  
c0101ad2:	c3                   	ret    

c0101ad3 <flushVCache>:
void flushVCache(){
c0101ad3:	55                   	push   %ebp
c0101ad4:	89 e5                	mov    %esp,%ebp
c0101ad6:	53                   	push   %ebx
c0101ad7:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101ada:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101ae1:	eb 47                	jmp    c0101b2a <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0101ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ae6:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101aeb:	0f b6 00             	movzbl (%eax),%eax
c0101aee:	84 c0                	test   %al,%al
c0101af0:	74 34                	je     c0101b26 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0101af2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101af5:	89 d0                	mov    %edx,%eax
c0101af7:	c1 e0 02             	shl    $0x2,%eax
c0101afa:	01 d0                	add    %edx,%eax
c0101afc:	c1 e0 06             	shl    $0x6,%eax
c0101aff:	8d 88 c0 30 15 c0    	lea    -0x3feacf40(%eax),%ecx
c0101b05:	8b 1d a8 50 10 c0    	mov    0xc01050a8,%ebx
c0101b0b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101b0e:	89 d0                	mov    %edx,%eax
c0101b10:	c1 e0 02             	shl    $0x2,%eax
c0101b13:	01 d0                	add    %edx,%eax
c0101b15:	c1 e0 06             	shl    $0x6,%eax
c0101b18:	01 d8                	add    %ebx,%eax
c0101b1a:	6a 50                	push   $0x50
c0101b1c:	51                   	push   %ecx
c0101b1d:	50                   	push   %eax
c0101b1e:	e8 2a ff ff ff       	call   c0101a4d <memcpy>
c0101b23:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101b26:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101b2a:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0101b31:	7e b0                	jle    c0101ae3 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0101b33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101b36:	c9                   	leave  
c0101b37:	c3                   	ret    

c0101b38 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0101b38:	55                   	push   %ebp
c0101b39:	89 e5                	mov    %esp,%ebp
c0101b3b:	83 ec 04             	sub    $0x4,%esp
c0101b3e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b41:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0101b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101b48:	78 18                	js     c0101b62 <setPixelAt+0x2a>
c0101b4a:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0101b51:	7f 0f                	jg     c0101b62 <setPixelAt+0x2a>
c0101b53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101b57:	78 09                	js     c0101b62 <setPixelAt+0x2a>
c0101b59:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0101b60:	7e 02                	jle    c0101b64 <setPixelAt+0x2c>
c0101b62:	eb 34                	jmp    c0101b98 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0101b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b67:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101b6c:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b72:	05 c0 25 17 c0       	add    $0xc01725c0,%eax
c0101b77:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0101b7a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b7d:	89 d0                	mov    %edx,%eax
c0101b7f:	c1 e0 02             	shl    $0x2,%eax
c0101b82:	01 d0                	add    %edx,%eax
c0101b84:	c1 e0 06             	shl    $0x6,%eax
c0101b87:	89 c2                	mov    %eax,%edx
c0101b89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b8c:	01 c2                	add    %eax,%edx
c0101b8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0101b92:	88 82 c0 30 15 c0    	mov    %al,-0x3feacf40(%edx)
}
c0101b98:	c9                   	leave  
c0101b99:	c3                   	ret    

c0101b9a <forceClearVRAM>:
void forceClearVRAM(){
c0101b9a:	55                   	push   %ebp
c0101b9b:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0101b9d:	5d                   	pop    %ebp
c0101b9e:	c3                   	ret    

c0101b9f <clearVRAM>:
void clearVRAM(){
c0101b9f:	55                   	push   %ebp
c0101ba0:	89 e5                	mov    %esp,%ebp
c0101ba2:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101ba5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101bac:	eb 4e                	jmp    c0101bfc <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0101bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bb1:	05 c0 25 17 c0       	add    $0xc01725c0,%eax
c0101bb6:	0f b6 00             	movzbl (%eax),%eax
c0101bb9:	0f b6 c0             	movzbl %al,%eax
c0101bbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101bbf:	81 c2 c0 24 17 c0    	add    $0xc01724c0,%edx
c0101bc5:	0f b6 12             	movzbl (%edx),%edx
c0101bc8:	0f b6 d2             	movzbl %dl,%edx
c0101bcb:	f7 d2                	not    %edx
c0101bcd:	21 d0                	and    %edx,%eax
c0101bcf:	85 c0                	test   %eax,%eax
c0101bd1:	74 25                	je     c0101bf8 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0101bd3:	8b 0d a8 50 10 c0    	mov    0xc01050a8,%ecx
c0101bd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101bdc:	89 d0                	mov    %edx,%eax
c0101bde:	c1 e0 02             	shl    $0x2,%eax
c0101be1:	01 d0                	add    %edx,%eax
c0101be3:	c1 e0 06             	shl    $0x6,%eax
c0101be6:	01 c8                	add    %ecx,%eax
c0101be8:	6a 50                	push   $0x50
c0101bea:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101bef:	50                   	push   %eax
c0101bf0:	e8 58 fe ff ff       	call   c0101a4d <memcpy>
c0101bf5:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101bf8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101bfc:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101c03:	7e a9                	jle    c0101bae <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0101c05:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101c0c:	83 c0 01             	add    $0x1,%eax
c0101c0f:	a2 88 26 17 c0       	mov    %al,0xc0172688
	if(stamp==30){
c0101c14:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101c1b:	3c 1e                	cmp    $0x1e,%al
c0101c1d:	75 07                	jne    c0101c26 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0101c1f:	c6 05 88 26 17 c0 00 	movb   $0x0,0xc0172688
		//printk("What matters\n");
	}
	if(stamp==0){
c0101c26:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101c2d:	84 c0                	test   %al,%al
c0101c2f:	75 14                	jne    c0101c45 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0101c31:	6a 32                	push   $0x32
c0101c33:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101c38:	68 c0 25 17 c0       	push   $0xc01725c0
c0101c3d:	e8 0b fe ff ff       	call   c0101a4d <memcpy>
c0101c42:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0101c45:	c9                   	leave  
c0101c46:	c3                   	ret    

c0101c47 <do_timer>:
#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
c0101c47:	55                   	push   %ebp
c0101c48:	89 e5                	mov    %esp,%ebp
	_tick++;
c0101c4a:	a1 8c 26 17 c0       	mov    0xc017268c,%eax
c0101c4f:	83 c0 01             	add    $0x1,%eax
c0101c52:	a3 8c 26 17 c0       	mov    %eax,0xc017268c
	//printk("%x", _tick);
}
c0101c57:	5d                   	pop    %ebp
c0101c58:	c3                   	ret    

c0101c59 <tick>:
uint32_t tick(){
c0101c59:	55                   	push   %ebp
c0101c5a:	89 e5                	mov    %esp,%ebp
	return _tick;
c0101c5c:	a1 8c 26 17 c0       	mov    0xc017268c,%eax
c0101c61:	5d                   	pop    %ebp
c0101c62:	c3                   	ret    

c0101c63 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0101c63:	6a 00                	push   $0x0
c0101c65:	6a 00                	push   $0x0
c0101c67:	e9 b7 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c6c <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0101c6c:	6a 00                	push   $0x0
c0101c6e:	6a 01                	push   $0x1
c0101c70:	e9 ae 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c75 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0101c75:	6a 00                	push   $0x0
c0101c77:	6a 02                	push   $0x2
c0101c79:	e9 a5 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c7e <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0101c7e:	6a 00                	push   $0x0
c0101c80:	6a 03                	push   $0x3
c0101c82:	e9 9c 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c87 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0101c87:	6a 00                	push   $0x0
c0101c89:	6a 04                	push   $0x4
c0101c8b:	e9 93 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c90 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0101c90:	6a 00                	push   $0x0
c0101c92:	6a 05                	push   $0x5
c0101c94:	e9 8a 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101c99 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0101c99:	6a 00                	push   $0x0
c0101c9b:	6a 06                	push   $0x6
c0101c9d:	e9 81 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101ca2 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0101ca2:	6a 00                	push   $0x0
c0101ca4:	6a 07                	push   $0x7
c0101ca6:	e9 78 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cab <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0101cab:	6a 00                	push   $0x0
c0101cad:	6a 08                	push   $0x8
c0101caf:	e9 6f 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cb4 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0101cb4:	6a 00                	push   $0x0
c0101cb6:	6a 09                	push   $0x9
c0101cb8:	e9 66 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cbd <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0101cbd:	6a 00                	push   $0x0
c0101cbf:	6a 0a                	push   $0xa
c0101cc1:	e9 5d 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cc6 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0101cc6:	6a 00                	push   $0x0
c0101cc8:	6a 0b                	push   $0xb
c0101cca:	e9 54 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101ccf <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0101ccf:	6a 00                	push   $0x0
c0101cd1:	6a 0c                	push   $0xc
c0101cd3:	e9 4b 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cd8 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0101cd8:	6a 00                	push   $0x0
c0101cda:	6a 0d                	push   $0xd
c0101cdc:	e9 42 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101ce1 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0101ce1:	6a 00                	push   $0x0
c0101ce3:	6a 0e                	push   $0xe
c0101ce5:	e9 39 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cea <vecsys>:

.globl vecsys; vecsys:  pushl $0;  pushl $0x80; jmp asm_do_irq
c0101cea:	6a 00                	push   $0x0
c0101cec:	68 80 00 00 00       	push   $0x80
c0101cf1:	e9 2d 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101cf6 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0101cf6:	6a 00                	push   $0x0
c0101cf8:	68 e8 03 00 00       	push   $0x3e8
c0101cfd:	e9 21 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101d02 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0101d02:	6a 00                	push   $0x0
c0101d04:	68 e9 03 00 00       	push   $0x3e9
c0101d09:	e9 15 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101d0e <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0101d0e:	6a 00                	push   $0x0
c0101d10:	68 f6 03 00 00       	push   $0x3f6
c0101d15:	e9 09 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101d1a <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0101d1a:	6a 00                	push   $0x0
c0101d1c:	6a ff                	push   $0xffffffff
c0101d1e:	e9 00 00 00 00       	jmp    c0101d23 <asm_do_irq>

c0101d23 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle


asm_do_irq:
  cli
c0101d23:	fa                   	cli    
  pushl %ds
c0101d24:	1e                   	push   %ds
  pushl %es
c0101d25:	06                   	push   %es
  pushl %fs
c0101d26:	0f a0                	push   %fs
  pushl %gs
c0101d28:	0f a8                	push   %gs
	pushal
c0101d2a:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0101d2b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0101d2f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0101d31:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0101d33:	54                   	push   %esp
  call irq_handle
c0101d34:	e8 f4 ed ff ff       	call   c0100b2d <irq_handle>
  addl $4, %esp
c0101d39:	83 c4 04             	add    $0x4,%esp
  popal
c0101d3c:	61                   	popa   
  
  popl %gs
c0101d3d:	0f a9                	pop    %gs
  popl %fs
c0101d3f:	0f a1                	pop    %fs
  popl %es
c0101d41:	07                   	pop    %es
  popl %ds
c0101d42:	1f                   	pop    %ds
  addl $8, %esp
c0101d43:	83 c4 08             	add    $0x8,%esp
  sti
c0101d46:	fb                   	sti    
c0101d47:	cf                   	iret   
c0101d48:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0101d4e:	00 00                	add    %al,(%eax)
c0101d50:	fe 4f 52             	decb   0x52(%edi)
c0101d53:	e4 66                	in     $0x66,%al

c0101d54 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0101d54:	66 c7 05 72 04 00 00 34 12 b8 00 40 10 00 0f 22     f..r...4...@..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0101d64:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 77 1d 10     .. ......."..w..
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0101d74:	c0 ff e0                                            ...

c0101d77 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0101d77:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0101d7c:	bc 00 e0 10 c0       	mov    $0xc010e000,%esp

	# now to C code

	call	main
c0101d81:	e8 00 f6 ff ff       	call   c0101386 <main>

c0101d86 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0101d86:	eb fe                	jmp    c0101d86 <spin>

c0101d88 <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
c0101d88:	55                   	push   %ebp
c0101d89:	89 e5                	mov    %esp,%ebp
c0101d8b:	53                   	push   %ebx
c0101d8c:	83 ec 04             	sub    $0x4,%esp
c0101d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d92:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0101d95:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0101d9a:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0101d9e:	89 d3                	mov    %edx,%ebx
c0101da0:	cd 80                	int    $0x80
}
c0101da2:	83 c4 04             	add    $0x4,%esp
c0101da5:	5b                   	pop    %ebx
c0101da6:	5d                   	pop    %ebp
c0101da7:	c3                   	ret    

c0101da8 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0101da8:	55                   	push   %ebp
c0101da9:	89 e5                	mov    %esp,%ebp
c0101dab:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0101dae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0101db4:	eb 19                	jmp    c0101dcf <printp+0x27>
		printer(cur);
c0101db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101db9:	0f b6 00             	movzbl (%eax),%eax
c0101dbc:	0f be c0             	movsbl %al,%eax
c0101dbf:	83 ec 0c             	sub    $0xc,%esp
c0101dc2:	50                   	push   %eax
c0101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc6:	ff d0                	call   *%eax
c0101dc8:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0101dcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dd2:	0f b6 00             	movzbl (%eax),%eax
c0101dd5:	84 c0                	test   %al,%al
c0101dd7:	75 dd                	jne    c0101db6 <printp+0xe>
		printer(cur);
	}
}
c0101dd9:	c9                   	leave  
c0101dda:	c3                   	ret    

c0101ddb <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0101ddb:	55                   	push   %ebp
c0101ddc:	89 e5                	mov    %esp,%ebp
c0101dde:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0101de1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0101de7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0101dee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0101df5:	8b 45 10             	mov    0x10(%ebp),%eax
c0101df8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0101dfb:	e9 65 02 00 00       	jmp    c0102065 <vfprintf+0x28a>

		if(cur == '%'){
c0101e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e03:	0f b6 00             	movzbl (%eax),%eax
c0101e06:	3c 25                	cmp    $0x25,%al
c0101e08:	75 0c                	jne    c0101e16 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0101e0a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0101e11:	e9 4b 02 00 00       	jmp    c0102061 <vfprintf+0x286>
		}
		if(type == READ){
c0101e16:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0101e1a:	0f 85 26 02 00 00    	jne    c0102046 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0101e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e23:	0f b6 00             	movzbl (%eax),%eax
c0101e26:	3c 73                	cmp    $0x73,%al
c0101e28:	75 35                	jne    c0101e5f <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0101e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101e2d:	8b 00                	mov    (%eax),%eax
c0101e2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0101e32:	eb 19                	jmp    c0101e4d <vfprintf+0x72>
					printer(*p);
c0101e34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101e37:	0f b6 00             	movzbl (%eax),%eax
c0101e3a:	0f be c0             	movsbl %al,%eax
c0101e3d:	83 ec 0c             	sub    $0xc,%esp
c0101e40:	50                   	push   %eax
c0101e41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e44:	ff d0                	call   *%eax
c0101e46:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0101e49:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0101e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101e50:	0f b6 00             	movzbl (%eax),%eax
c0101e53:	84 c0                	test   %al,%al
c0101e55:	75 dd                	jne    c0101e34 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0101e57:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0101e5b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0101e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e62:	0f b6 00             	movzbl (%eax),%eax
c0101e65:	3c 78                	cmp    $0x78,%al
c0101e67:	0f 85 99 00 00 00    	jne    c0101f06 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0101e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101e70:	8b 00                	mov    (%eax),%eax
c0101e72:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0101e75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0101e79:	75 1d                	jne    c0101e98 <vfprintf+0xbd>
					printer('0');
c0101e7b:	83 ec 0c             	sub    $0xc,%esp
c0101e7e:	6a 30                	push   $0x30
c0101e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e83:	ff d0                	call   *%eax
c0101e85:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0101e88:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0101e8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101e93:	e9 c9 01 00 00       	jmp    c0102061 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0101e98:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0101e9f:	eb 2d                	jmp    c0101ece <vfprintf+0xf3>
					int d=(x%16);
c0101ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101ea4:	83 e0 0f             	and    $0xf,%eax
c0101ea7:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0101eaa:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0101eae:	7e 04                	jle    c0101eb4 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0101eb0:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0101eb4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101eb7:	83 c0 30             	add    $0x30,%eax
c0101eba:	89 c1                	mov    %eax,%ecx
c0101ebc:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0101ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101ec2:	01 d0                	add    %edx,%eax
c0101ec4:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0101ec6:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0101eca:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0101ece:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0101ed2:	75 cd                	jne    c0101ea1 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0101ed4:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0101ed8:	eb 1e                	jmp    c0101ef8 <vfprintf+0x11d>
					printer(digits[di]);
c0101eda:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0101edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101ee0:	01 d0                	add    %edx,%eax
c0101ee2:	0f b6 00             	movzbl (%eax),%eax
c0101ee5:	0f be c0             	movsbl %al,%eax
c0101ee8:	83 ec 0c             	sub    $0xc,%esp
c0101eeb:	50                   	push   %eax
c0101eec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eef:	ff d0                	call   *%eax
c0101ef1:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0101ef4:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0101ef8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101efc:	79 dc                	jns    c0101eda <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0101efe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0101f02:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0101f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f09:	0f b6 00             	movzbl (%eax),%eax
c0101f0c:	3c 64                	cmp    $0x64,%al
c0101f0e:	0f 85 02 01 00 00    	jne    c0102016 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0101f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101f17:	8b 00                	mov    (%eax),%eax
c0101f19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0101f1c:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0101f23:	75 23                	jne    c0101f48 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0101f25:	83 ec 08             	sub    $0x8,%esp
c0101f28:	68 d8 21 10 c0       	push   $0xc01021d8
c0101f2d:	ff 75 08             	pushl  0x8(%ebp)
c0101f30:	e8 73 fe ff ff       	call   c0101da8 <printp>
c0101f35:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0101f38:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0101f3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0101f43:	e9 19 01 00 00       	jmp    c0102061 <vfprintf+0x286>
				}
				if(x==0){
c0101f48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0101f4c:	75 1e                	jne    c0101f6c <vfprintf+0x191>
					printer('0');
c0101f4e:	83 ec 0c             	sub    $0xc,%esp
c0101f51:	6a 30                	push   $0x30
c0101f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f56:	ff d0                	call   *%eax
c0101f58:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0101f5b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0101f5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0101f66:	90                   	nop
c0101f67:	e9 f5 00 00 00       	jmp    c0102061 <vfprintf+0x286>
				}
				if(x<0){
c0101f6c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0101f70:	79 10                	jns    c0101f82 <vfprintf+0x1a7>
					printer('-');
c0101f72:	83 ec 0c             	sub    $0xc,%esp
c0101f75:	6a 2d                	push   $0x2d
c0101f77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7a:	ff d0                	call   *%eax
c0101f7c:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0101f7f:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0101f82:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0101f89:	eb 53                	jmp    c0101fde <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0101f8b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0101f8e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0101f93:	89 c8                	mov    %ecx,%eax
c0101f95:	f7 ea                	imul   %edx
c0101f97:	c1 fa 02             	sar    $0x2,%edx
c0101f9a:	89 c8                	mov    %ecx,%eax
c0101f9c:	c1 f8 1f             	sar    $0x1f,%eax
c0101f9f:	29 c2                	sub    %eax,%edx
c0101fa1:	89 d0                	mov    %edx,%eax
c0101fa3:	c1 e0 02             	shl    $0x2,%eax
c0101fa6:	01 d0                	add    %edx,%eax
c0101fa8:	01 c0                	add    %eax,%eax
c0101faa:	29 c1                	sub    %eax,%ecx
c0101fac:	89 ca                	mov    %ecx,%edx
c0101fae:	89 d0                	mov    %edx,%eax
c0101fb0:	83 c0 30             	add    $0x30,%eax
c0101fb3:	89 c1                	mov    %eax,%ecx
c0101fb5:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0101fb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101fbb:	01 d0                	add    %edx,%eax
c0101fbd:	88 08                	mov    %cl,(%eax)
					x/=10;
c0101fbf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0101fc2:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0101fc7:	89 c8                	mov    %ecx,%eax
c0101fc9:	f7 ea                	imul   %edx
c0101fcb:	c1 fa 02             	sar    $0x2,%edx
c0101fce:	89 c8                	mov    %ecx,%eax
c0101fd0:	c1 f8 1f             	sar    $0x1f,%eax
c0101fd3:	29 c2                	sub    %eax,%edx
c0101fd5:	89 d0                	mov    %edx,%eax
c0101fd7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0101fda:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0101fde:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0101fe2:	7f a7                	jg     c0101f8b <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0101fe4:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0101fe8:	eb 1e                	jmp    c0102008 <vfprintf+0x22d>
					printer(digits[di]);
c0101fea:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0101fed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101ff0:	01 d0                	add    %edx,%eax
c0101ff2:	0f b6 00             	movzbl (%eax),%eax
c0101ff5:	0f be c0             	movsbl %al,%eax
c0101ff8:	83 ec 0c             	sub    $0xc,%esp
c0101ffb:	50                   	push   %eax
c0101ffc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fff:	ff d0                	call   *%eax
c0102001:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0102004:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0102008:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010200c:	79 dc                	jns    c0101fea <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010200e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102012:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0102016:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102019:	0f b6 00             	movzbl (%eax),%eax
c010201c:	3c 63                	cmp    $0x63,%al
c010201e:	75 1d                	jne    c010203d <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0102020:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102023:	0f b6 00             	movzbl (%eax),%eax
c0102026:	0f be c0             	movsbl %al,%eax
c0102029:	83 ec 0c             	sub    $0xc,%esp
c010202c:	50                   	push   %eax
c010202d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102030:	ff d0                	call   *%eax
c0102032:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0102035:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102039:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c010203d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0102044:	eb 1b                	jmp    c0102061 <vfprintf+0x286>
		}
		if(type == NONE){
c0102046:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010204a:	75 15                	jne    c0102061 <vfprintf+0x286>
			printer(cur);
c010204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010204f:	0f b6 00             	movzbl (%eax),%eax
c0102052:	0f be c0             	movsbl %al,%eax
c0102055:	83 ec 0c             	sub    $0xc,%esp
c0102058:	50                   	push   %eax
c0102059:	8b 45 08             	mov    0x8(%ebp),%eax
c010205c:	ff d0                	call   *%eax
c010205e:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102061:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102065:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102068:	0f b6 00             	movzbl (%eax),%eax
c010206b:	84 c0                	test   %al,%al
c010206d:	0f 85 8d fd ff ff    	jne    c0101e00 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0102073:	c9                   	leave  
c0102074:	c3                   	ret    

c0102075 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0102075:	55                   	push   %ebp
c0102076:	89 e5                	mov    %esp,%ebp
c0102078:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010207b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0102081:	8b 45 08             	mov    0x8(%ebp),%eax
c0102084:	83 ec 04             	sub    $0x4,%esp
c0102087:	ff 75 f4             	pushl  -0xc(%ebp)
c010208a:	50                   	push   %eax
c010208b:	68 88 1d 10 c0       	push   $0xc0101d88
c0102090:	e8 46 fd ff ff       	call   c0101ddb <vfprintf>
c0102095:	83 c4 10             	add    $0x10,%esp
}
c0102098:	c9                   	leave  
c0102099:	c3                   	ret    
