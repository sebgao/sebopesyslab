
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

c0100044 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0100044:	55                   	push   %ebp
c0100045:	89 e5                	mov    %esp,%ebp
c0100047:	83 ec 10             	sub    $0x10,%esp
c010004a:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100051:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100054:	89 c2                	mov    %eax,%edx
c0100056:	ec                   	in     (%dx),%al
c0100057:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010005a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010005e:	0f b6 c0             	movzbl %al,%eax
c0100061:	83 e0 20             	and    $0x20,%eax
c0100064:	85 c0                	test   %eax,%eax
c0100066:	0f 95 c0             	setne  %al
c0100069:	0f b6 c0             	movzbl %al,%eax
}
c010006c:	c9                   	leave  
c010006d:	c3                   	ret    

c010006e <serial_printc>:

static inline
void serial_printc(char ch) {
c010006e:	55                   	push   %ebp
c010006f:	89 e5                	mov    %esp,%ebp
c0100071:	83 ec 14             	sub    $0x14,%esp
c0100074:	8b 45 08             	mov    0x8(%ebp),%eax
c0100077:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010007a:	90                   	nop
c010007b:	e8 c4 ff ff ff       	call   c0100044 <serial_idle>
c0100080:	85 c0                	test   %eax,%eax
c0100082:	74 f7                	je     c010007b <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0100084:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100088:	0f b6 c0             	movzbl %al,%eax
c010008b:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0100092:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100095:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100099:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010009c:	ee                   	out    %al,(%dx)
}
c010009d:	c9                   	leave  
c010009e:	c3                   	ret    

c010009f <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010009f:	55                   	push   %ebp
c01000a0:	89 e5                	mov    %esp,%ebp
c01000a2:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01000a5:	8d 45 0c             	lea    0xc(%ebp),%eax
c01000a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ae:	83 ec 04             	sub    $0x4,%esp
c01000b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01000b4:	50                   	push   %eax
c01000b5:	68 6e 00 10 c0       	push   $0xc010006e
c01000ba:	e8 c0 1d 00 00       	call   c0101e7f <vfprintf>
c01000bf:	83 c4 10             	add    $0x10,%esp
}
c01000c2:	c9                   	leave  
c01000c3:	c3                   	ret    

c01000c4 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c01000c4:	55                   	push   %ebp
c01000c5:	89 e5                	mov    %esp,%ebp
c01000c7:	57                   	push   %edi
c01000c8:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c01000c9:	8b 55 10             	mov    0x10(%ebp),%edx
c01000cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01000d2:	89 d1                	mov    %edx,%ecx
c01000d4:	89 df                	mov    %ebx,%edi
c01000d6:	fc                   	cld    
c01000d7:	f3 ab                	rep stos %eax,%es:(%edi)
}
c01000d9:	5b                   	pop    %ebx
c01000da:	5f                   	pop    %edi
c01000db:	5d                   	pop    %ebp
c01000dc:	c3                   	ret    

c01000dd <get_kcr3>:
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
c01000dd:	55                   	push   %ebp
c01000de:	89 e5                	mov    %esp,%ebp
	return &kcr3;
c01000e0:	b8 00 e0 10 c0       	mov    $0xc010e000,%eax
}
c01000e5:	5d                   	pop    %ebp
c01000e6:	c3                   	ret    

c01000e7 <get_kpdir>:

PDE* get_kpdir() {
c01000e7:	55                   	push   %ebp
c01000e8:	89 e5                	mov    %esp,%ebp
	return kpdir;
c01000ea:	b8 00 f0 10 c0       	mov    $0xc010f000,%eax
}
c01000ef:	5d                   	pop    %ebp
c01000f0:	c3                   	ret    

c01000f1 <get_kptable>:

PTE* get_kptable() {
c01000f1:	55                   	push   %ebp
c01000f2:	89 e5                	mov    %esp,%ebp
	return kptable;
c01000f4:	b8 00 00 11 c0       	mov    $0xc0110000,%eax
}
c01000f9:	5d                   	pop    %ebp
c01000fa:	c3                   	ret    

c01000fb <init_page>:

/* Build a page table for the kernel */
void
init_page(void) {
c01000fb:	55                   	push   %ebp
c01000fc:	89 e5                	mov    %esp,%ebp
c01000fe:	83 ec 08             	sub    $0x8,%esp
	page_init();
c0100101:	e8 8c 05 00 00       	call   c0100692 <page_init>
}
c0100106:	c9                   	leave  
c0100107:	c3                   	ret    

c0100108 <set_tss>:

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
c0100108:	55                   	push   %ebp
c0100109:	89 e5                	mov    %esp,%ebp
c010010b:	83 ec 10             	sub    $0x10,%esp
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
c010010e:	c7 05 08 00 13 c0 10 	movl   $0x10,0xc0130008
c0100115:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100118:	c7 45 fc 00 00 13 c0 	movl   $0xc0130000,-0x4(%ebp)
	uint32_t limit = sizeof(TSS) - 1;
c010011f:	c7 45 f8 63 00 00 00 	movl   $0x63,-0x8(%ebp)
	ptr->limit_15_0  = limit & 0xffff;
c0100126:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100129:	89 c2                	mov    %eax,%edx
c010012b:	8b 45 08             	mov    0x8(%ebp),%eax
c010012e:	66 89 10             	mov    %dx,(%eax)
	ptr->base_15_0   = base & 0xffff;
c0100131:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100134:	89 c2                	mov    %eax,%edx
c0100136:	8b 45 08             	mov    0x8(%ebp),%eax
c0100139:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->base_23_16  = (base >> 16) & 0xff;
c010013d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100140:	c1 e8 10             	shr    $0x10,%eax
c0100143:	89 c2                	mov    %eax,%edx
c0100145:	8b 45 08             	mov    0x8(%ebp),%eax
c0100148:	88 50 04             	mov    %dl,0x4(%eax)
	ptr->type = SEG_TSS_32BIT;
c010014b:	8b 45 08             	mov    0x8(%ebp),%eax
c010014e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100152:	83 e2 f0             	and    $0xfffffff0,%edx
c0100155:	83 ca 09             	or     $0x9,%edx
c0100158:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 0;
c010015b:	8b 45 08             	mov    0x8(%ebp),%eax
c010015e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100162:	83 e2 ef             	and    $0xffffffef,%edx
c0100165:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = DPL_USER;
c0100168:	8b 45 08             	mov    0x8(%ebp),%eax
c010016b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010016f:	83 ca 60             	or     $0x60,%edx
c0100172:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100175:	8b 45 08             	mov    0x8(%ebp),%eax
c0100178:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010017c:	83 ca 80             	or     $0xffffff80,%edx
c010017f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = limit >> 16;
c0100182:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100185:	c1 e8 10             	shr    $0x10,%eax
c0100188:	83 e0 0f             	and    $0xf,%eax
c010018b:	89 c2                	mov    %eax,%edx
c010018d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100190:	89 d1                	mov    %edx,%ecx
c0100192:	83 e1 0f             	and    $0xf,%ecx
c0100195:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100199:	83 e2 f0             	and    $0xfffffff0,%edx
c010019c:	09 ca                	or     %ecx,%edx
c010019e:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c01001a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01001a4:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001a8:	83 e2 ef             	and    $0xffffffef,%edx
c01001ab:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c01001ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01001b1:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001b5:	83 e2 df             	and    $0xffffffdf,%edx
c01001b8:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c01001bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01001be:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001c2:	83 ca 40             	or     $0x40,%edx
c01001c5:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 0;
c01001c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01001cb:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001cf:	83 e2 7f             	and    $0x7f,%edx
c01001d2:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = base >> 24;
c01001d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01001d8:	c1 e8 18             	shr    $0x18,%eax
c01001db:	89 c2                	mov    %eax,%edx
c01001dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01001e0:	88 50 07             	mov    %dl,0x7(%eax)
}
c01001e3:	c9                   	leave  
c01001e4:	c3                   	ret    

c01001e5 <set_tss_esp0>:

static void set_tss_esp0(uint32_t esp) {
c01001e5:	55                   	push   %ebp
c01001e6:	89 e5                	mov    %esp,%ebp
	tss.esp0 = esp;
c01001e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01001eb:	a3 04 00 13 c0       	mov    %eax,0xc0130004
}
c01001f0:	5d                   	pop    %ebp
c01001f1:	c3                   	ret    

c01001f2 <set_segment>:

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
c01001f2:	55                   	push   %ebp
c01001f3:	89 e5                	mov    %esp,%ebp
	ptr->limit_15_0  = 0xFFFF;
c01001f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01001f8:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
	ptr->base_15_0   = 0x0;
c01001fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100200:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
	ptr->base_23_16  = 0x0;
c0100206:	8b 45 08             	mov    0x8(%ebp),%eax
c0100209:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = type;
c010020d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100210:	83 e0 0f             	and    $0xf,%eax
c0100213:	89 c2                	mov    %eax,%edx
c0100215:	8b 45 08             	mov    0x8(%ebp),%eax
c0100218:	89 d1                	mov    %edx,%ecx
c010021a:	83 e1 0f             	and    $0xf,%ecx
c010021d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100221:	83 e2 f0             	and    $0xfffffff0,%edx
c0100224:	09 ca                	or     %ecx,%edx
c0100226:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 1;
c0100229:	8b 45 08             	mov    0x8(%ebp),%eax
c010022c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100230:	83 ca 10             	or     $0x10,%edx
c0100233:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = pl;
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	83 e0 03             	and    $0x3,%eax
c010023c:	89 c2                	mov    %eax,%edx
c010023e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100241:	83 e2 03             	and    $0x3,%edx
c0100244:	89 d1                	mov    %edx,%ecx
c0100246:	c1 e1 05             	shl    $0x5,%ecx
c0100249:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010024d:	83 e2 9f             	and    $0xffffff9f,%edx
c0100250:	09 ca                	or     %ecx,%edx
c0100252:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100255:	8b 45 08             	mov    0x8(%ebp),%eax
c0100258:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010025c:	83 ca 80             	or     $0xffffff80,%edx
c010025f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = 0xF;
c0100262:	8b 45 08             	mov    0x8(%ebp),%eax
c0100265:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100269:	83 ca 0f             	or     $0xf,%edx
c010026c:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c010026f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100272:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100276:	83 e2 ef             	and    $0xffffffef,%edx
c0100279:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c010027c:	8b 45 08             	mov    0x8(%ebp),%eax
c010027f:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100283:	83 e2 df             	and    $0xffffffdf,%edx
c0100286:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c0100289:	8b 45 08             	mov    0x8(%ebp),%eax
c010028c:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100290:	83 ca 40             	or     $0x40,%edx
c0100293:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 1;
c0100296:	8b 45 08             	mov    0x8(%ebp),%eax
c0100299:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c010029d:	83 ca 80             	or     $0xffffff80,%edx
c01002a0:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = 0x0;
c01002a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a6:	c6 40 07 00          	movb   $0x0,0x7(%eax)
}
c01002aa:	5d                   	pop    %ebp
c01002ab:	c3                   	ret    

c01002ac <init_segment>:
/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
c01002ac:	55                   	push   %ebp
c01002ad:	89 e5                	mov    %esp,%ebp
	memset(gdt, 0, sizeof(gdt));
c01002af:	6a 30                	push   $0x30
c01002b1:	6a 00                	push   $0x0
c01002b3:	68 80 00 13 c0       	push   $0xc0130080
c01002b8:	e8 07 fe ff ff       	call   c01000c4 <memset>
c01002bd:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c01002c0:	6a 0a                	push   $0xa
c01002c2:	6a 00                	push   $0x0
c01002c4:	68 88 00 13 c0       	push   $0xc0130088
c01002c9:	e8 24 ff ff ff       	call   c01001f2 <set_segment>
c01002ce:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c01002d1:	6a 02                	push   $0x2
c01002d3:	6a 00                	push   $0x0
c01002d5:	68 90 00 13 c0       	push   $0xc0130090
c01002da:	e8 13 ff ff ff       	call   c01001f2 <set_segment>
c01002df:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c01002e2:	6a 0a                	push   $0xa
c01002e4:	6a 03                	push   $0x3
c01002e6:	68 98 00 13 c0       	push   $0xc0130098
c01002eb:	e8 02 ff ff ff       	call   c01001f2 <set_segment>
c01002f0:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c01002f3:	6a 02                	push   $0x2
c01002f5:	6a 03                	push   $0x3
c01002f7:	68 a0 00 13 c0       	push   $0xc01300a0
c01002fc:	e8 f1 fe ff ff       	call   c01001f2 <set_segment>
c0100301:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100304:	6a 30                	push   $0x30
c0100306:	68 80 00 13 c0       	push   $0xc0130080
c010030b:	e8 f0 fc ff ff       	call   c0100000 <write_gdtr>
c0100310:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100313:	68 a8 00 13 c0       	push   $0xc01300a8
c0100318:	e8 eb fd ff ff       	call   c0100108 <set_tss>
c010031d:	83 c4 04             	add    $0x4,%esp
	write_tr( SELECTOR_USER(SEG_TSS) );
c0100320:	6a 2b                	push   $0x2b
c0100322:	e8 07 fd ff ff       	call   c010002e <write_tr>
c0100327:	83 c4 04             	add    $0x4,%esp
}
c010032a:	c9                   	leave  
c010032b:	c3                   	ret    

c010032c <enter_pcb>:


void enter_pcb(PCB* pcb)
{
c010032c:	55                   	push   %ebp
c010032d:	89 e5                	mov    %esp,%ebp
c010032f:	83 ec 18             	sub    $0x18,%esp
	set_tss_esp0((uint32_t)pcb->kstack);
c0100332:	8b 45 08             	mov    0x8(%ebp),%eax
c0100335:	83 c0 0c             	add    $0xc,%eax
c0100338:	50                   	push   %eax
c0100339:	e8 a7 fe ff ff       	call   c01001e5 <set_tss_esp0>
c010033e:	83 c4 04             	add    $0x4,%esp
	struct TrapFrame *tf = pcb->tf;
c0100341:	8b 45 08             	mov    0x8(%ebp),%eax
c0100344:	8b 40 04             	mov    0x4(%eax),%eax
c0100347:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//disable_interrupt();
	//asm volatile("cli");
	//asm volatile("mov %0, %%ds" : : "r"(tf->ds));
	printk("0\n");
c010034a:	83 ec 0c             	sub    $0xc,%esp
c010034d:	68 50 21 10 c0       	push   $0xc0102150
c0100352:	e8 48 fd ff ff       	call   c010009f <printk>
c0100357:	83 c4 10             	add    $0x10,%esp
	//asm volatile("mov %0, %%es" : : "r"(tf->es));
	printk("0\n");
c010035a:	83 ec 0c             	sub    $0xc,%esp
c010035d:	68 50 21 10 c0       	push   $0xc0102150
c0100362:	e8 38 fd ff ff       	call   c010009f <printk>
c0100367:	83 c4 10             	add    $0x10,%esp
	//asm volatile("mov %0, %%fs" : : "r"(tf->fs));
	printk("0\n");
c010036a:	83 ec 0c             	sub    $0xc,%esp
c010036d:	68 50 21 10 c0       	push   $0xc0102150
c0100372:	e8 28 fd ff ff       	call   c010009f <printk>
c0100377:	83 c4 10             	add    $0x10,%esp
	//asm volatile("mov %0, %%gs" : : "r"(tf->gs));
	printk("0\n");
c010037a:	83 ec 0c             	sub    $0xc,%esp
c010037d:	68 50 21 10 c0       	push   $0xc0102150
c0100382:	e8 18 fd ff ff       	call   c010009f <printk>
c0100387:	83 c4 10             	add    $0x10,%esp
	asm volatile("pushl %0" : : "r"((uint32_t)tf->ss));
c010038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0100391:	0f b7 c0             	movzwl %ax,%eax
c0100394:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->esp));
c0100395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100398:	8b 40 44             	mov    0x44(%eax),%eax
c010039b:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eflags));
c010039c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010039f:	8b 40 40             	mov    0x40(%eax),%eax
c01003a2:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"((uint32_t)tf->cs));
c01003a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01003aa:	0f b7 c0             	movzwl %ax,%eax
c01003ad:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eip));
c01003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b1:	8b 40 38             	mov    0x38(%eax),%eax
c01003b4:	50                   	push   %eax
	asm volatile("iret"); 
c01003b5:	cf                   	iret   
}
c01003b6:	c9                   	leave  
c01003b7:	c3                   	ret    

c01003b8 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
c01003b8:	55                   	push   %ebp
c01003b9:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01003bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01003be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c01003c4:	5d                   	pop    %ebp
c01003c5:	c3                   	ret    

c01003c6 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
c01003c6:	55                   	push   %ebp
c01003c7:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01003c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01003cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c01003d2:	5d                   	pop    %ebp
c01003d3:	c3                   	ret    

c01003d4 <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01003d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01003da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c01003e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e3:	c1 e8 0c             	shr    $0xc,%eax
c01003e6:	25 ff ff 0f 00       	and    $0xfffff,%eax
c01003eb:	89 c2                	mov    %eax,%edx
c01003ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01003f0:	89 d1                	mov    %edx,%ecx
c01003f2:	c1 e1 0c             	shl    $0xc,%ecx
c01003f5:	8b 10                	mov    (%eax),%edx
c01003f7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01003fd:	09 ca                	or     %ecx,%edx
c01003ff:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c0100401:	8b 45 08             	mov    0x8(%ebp),%eax
c0100404:	0f b6 10             	movzbl (%eax),%edx
c0100407:	83 ca 01             	or     $0x1,%edx
c010040a:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c010040c:	8b 45 08             	mov    0x8(%ebp),%eax
c010040f:	0f b6 10             	movzbl (%eax),%edx
c0100412:	83 ca 02             	or     $0x2,%edx
c0100415:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c0100417:	8b 45 08             	mov    0x8(%ebp),%eax
c010041a:	0f b6 10             	movzbl (%eax),%edx
c010041d:	83 ca 04             	or     $0x4,%edx
c0100420:	88 10                	mov    %dl,(%eax)
}
c0100422:	5d                   	pop    %ebp
c0100423:	c3                   	ret    

c0100424 <make_pte>:

void
make_pte(PTE *p, void *addr) {
c0100424:	55                   	push   %ebp
c0100425:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100427:	8b 45 08             	mov    0x8(%ebp),%eax
c010042a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c0100430:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100433:	c1 e8 0c             	shr    $0xc,%eax
c0100436:	25 ff ff 0f 00       	and    $0xfffff,%eax
c010043b:	89 c2                	mov    %eax,%edx
c010043d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100440:	89 d1                	mov    %edx,%ecx
c0100442:	c1 e1 0c             	shl    $0xc,%ecx
c0100445:	8b 10                	mov    (%eax),%edx
c0100447:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c010044d:	09 ca                	or     %ecx,%edx
c010044f:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c0100451:	8b 45 08             	mov    0x8(%ebp),%eax
c0100454:	0f b6 10             	movzbl (%eax),%edx
c0100457:	83 ca 01             	or     $0x1,%edx
c010045a:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c010045c:	8b 45 08             	mov    0x8(%ebp),%eax
c010045f:	0f b6 10             	movzbl (%eax),%edx
c0100462:	83 ca 02             	or     $0x2,%edx
c0100465:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	0f b6 10             	movzbl (%eax),%edx
c010046d:	83 ca 04             	or     $0x4,%edx
c0100470:	88 10                	mov    %dl,(%eax)
}
c0100472:	5d                   	pop    %ebp
c0100473:	c3                   	ret    

c0100474 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0100474:	55                   	push   %ebp
c0100475:	89 e5                	mov    %esp,%ebp
c0100477:	83 ec 10             	sub    $0x10,%esp
c010047a:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100481:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100484:	89 c2                	mov    %eax,%edx
c0100486:	ec                   	in     (%dx),%al
c0100487:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010048a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010048e:	0f b6 c0             	movzbl %al,%eax
c0100491:	83 e0 20             	and    $0x20,%eax
c0100494:	85 c0                	test   %eax,%eax
c0100496:	0f 95 c0             	setne  %al
c0100499:	0f b6 c0             	movzbl %al,%eax
}
c010049c:	c9                   	leave  
c010049d:	c3                   	ret    

c010049e <serial_printc>:

static inline
void serial_printc(char ch) {
c010049e:	55                   	push   %ebp
c010049f:	89 e5                	mov    %esp,%ebp
c01004a1:	83 ec 14             	sub    $0x14,%esp
c01004a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a7:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01004aa:	90                   	nop
c01004ab:	e8 c4 ff ff ff       	call   c0100474 <serial_idle>
c01004b0:	85 c0                	test   %eax,%eax
c01004b2:	74 f7                	je     c01004ab <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01004b4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01004b8:	0f b6 c0             	movzbl %al,%eax
c01004bb:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01004c2:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01004c5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01004c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004cc:	ee                   	out    %al,(%dx)
}
c01004cd:	c9                   	leave  
c01004ce:	c3                   	ret    

c01004cf <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01004cf:	55                   	push   %ebp
c01004d0:	89 e5                	mov    %esp,%ebp
c01004d2:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01004d5:	8d 45 0c             	lea    0xc(%ebp),%eax
c01004d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01004db:	8b 45 08             	mov    0x8(%ebp),%eax
c01004de:	83 ec 04             	sub    $0x4,%esp
c01004e1:	ff 75 f4             	pushl  -0xc(%ebp)
c01004e4:	50                   	push   %eax
c01004e5:	68 9e 04 10 c0       	push   $0xc010049e
c01004ea:	e8 90 19 00 00       	call   c0101e7f <vfprintf>
c01004ef:	83 c4 10             	add    $0x10,%esp
}
c01004f2:	c9                   	leave  
c01004f3:	c3                   	ret    

c01004f4 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c01004f4:	55                   	push   %ebp
c01004f5:	89 e5                	mov    %esp,%ebp
c01004f7:	57                   	push   %edi
c01004f8:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c01004f9:	8b 55 10             	mov    0x10(%ebp),%edx
c01004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0100502:	89 d1                	mov    %edx,%ecx
c0100504:	89 df                	mov    %ebx,%edi
c0100506:	fc                   	cld    
c0100507:	f3 ab                	rep stos %eax,%es:(%edi)
}
c0100509:	5b                   	pop    %ebx
c010050a:	5f                   	pop    %edi
c010050b:	5d                   	pop    %ebp
c010050c:	c3                   	ret    

c010050d <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c010050d:	55                   	push   %ebp
c010050e:	89 e5                	mov    %esp,%ebp
c0100510:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0100513:	8b 45 10             	mov    0x10(%ebp),%eax
c0100516:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c010051b:	77 16                	ja     c0100533 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c010051d:	ff 75 10             	pushl  0x10(%ebp)
c0100520:	68 54 21 10 c0       	push   $0xc0102154
c0100525:	ff 75 0c             	pushl  0xc(%ebp)
c0100528:	ff 75 08             	pushl  0x8(%ebp)
c010052b:	e8 9f ff ff ff       	call   c01004cf <printk>
c0100530:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0100533:	8b 45 10             	mov    0x10(%ebp),%eax
c0100536:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010053b:	c9                   	leave  
c010053c:	c3                   	ret    

c010053d <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c010053d:	55                   	push   %ebp
c010053e:	89 e5                	mov    %esp,%ebp
c0100540:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0100543:	8b 45 10             	mov    0x10(%ebp),%eax
c0100546:	c1 e8 0c             	shr    $0xc,%eax
c0100549:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c010054e:	76 13                	jbe    c0100563 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0100550:	83 ec 08             	sub    $0x8,%esp
c0100553:	ff 75 10             	pushl  0x10(%ebp)
c0100556:	68 78 21 10 c0       	push   $0xc0102178
c010055b:	e8 6f ff ff ff       	call   c01004cf <printk>
c0100560:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0100563:	8b 45 10             	mov    0x10(%ebp),%eax
c0100566:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010056b:	c9                   	leave  
c010056c:	c3                   	ret    

c010056d <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c010056d:	55                   	push   %ebp
c010056e:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0100570:	8b 45 08             	mov    0x8(%ebp),%eax
c0100573:	ba 00 27 17 c0       	mov    $0xc0172700,%edx
c0100578:	29 d0                	sub    %edx,%eax
c010057a:	c1 f8 03             	sar    $0x3,%eax
c010057d:	c1 e0 0c             	shl    $0xc,%eax
}
c0100580:	5d                   	pop    %ebp
c0100581:	c3                   	ret    

c0100582 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0100582:	55                   	push   %ebp
c0100583:	89 e5                	mov    %esp,%ebp
c0100585:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0100588:	8b 45 08             	mov    0x8(%ebp),%eax
c010058b:	c1 e8 0c             	shr    $0xc,%eax
c010058e:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0100593:	76 10                	jbe    c01005a5 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0100595:	83 ec 0c             	sub    $0xc,%esp
c0100598:	68 9c 21 10 c0       	push   $0xc010219c
c010059d:	e8 2d ff ff ff       	call   c01004cf <printk>
c01005a2:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c01005a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a8:	c1 e8 0c             	shr    $0xc,%eax
c01005ab:	c1 e0 03             	shl    $0x3,%eax
c01005ae:	05 00 27 17 c0       	add    $0xc0172700,%eax
}
c01005b3:	c9                   	leave  
c01005b4:	c3                   	ret    

c01005b5 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c01005b5:	55                   	push   %ebp
c01005b6:	89 e5                	mov    %esp,%ebp
c01005b8:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01005bb:	ff 75 08             	pushl  0x8(%ebp)
c01005be:	e8 aa ff ff ff       	call   c010056d <page2pa>
c01005c3:	83 c4 04             	add    $0x4,%esp
c01005c6:	83 ec 04             	sub    $0x4,%esp
c01005c9:	50                   	push   %eax
c01005ca:	6a 52                	push   $0x52
c01005cc:	68 bb 21 10 c0       	push   $0xc01021bb
c01005d1:	e8 67 ff ff ff       	call   c010053d <_kaddr>
c01005d6:	83 c4 10             	add    $0x10,%esp
}
c01005d9:	c9                   	leave  
c01005da:	c3                   	ret    

c01005db <init_kern_pgdir>:

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
c01005db:	55                   	push   %ebp
c01005dc:	89 e5                	mov    %esp,%ebp
c01005de:	53                   	push   %ebx
c01005df:	83 ec 24             	sub    $0x24,%esp
	int pdx;
	pde_t *pgdir = kpgdir;
c01005e2:	c7 45 e8 00 20 13 c0 	movl   $0xc0132000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c01005e9:	c7 45 f0 00 30 13 c0 	movl   $0xc0133000,-0x10(%ebp)

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c01005f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01005f7:	eb 3a                	jmp    c0100633 <init_kern_pgdir+0x58>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
c01005f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fc:	05 00 03 00 00       	add    $0x300,%eax
c0100601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100608:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010060b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c010060e:	83 ec 04             	sub    $0x4,%esp
c0100611:	ff 75 f0             	pushl  -0x10(%ebp)
c0100614:	6a 28                	push   $0x28
c0100616:	68 d1 21 10 c0       	push   $0xc01021d1
c010061b:	e8 ed fe ff ff       	call   c010050d <_paddr>
c0100620:	83 c4 10             	add    $0x10,%esp
c0100623:	83 c8 03             	or     $0x3,%eax
c0100626:	89 03                	mov    %eax,(%ebx)
		pgtable += NPTENTRIES;
c0100628:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c010062f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100633:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0100637:	7e c0                	jle    c01005f9 <init_kern_pgdir+0x1e>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
c0100639:	c7 45 ec 00 f0 ff 07 	movl   $0x7fff000,-0x14(%ebp)
	pgtable--;
c0100640:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100644:	eb 18                	jmp    c010065e <init_kern_pgdir+0x83>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
c0100646:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100649:	83 c8 07             	or     $0x7,%eax
c010064c:	89 c2                	mov    %eax,%edx
c010064e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100651:	89 10                	mov    %edx,(%eax)
		pgtable --;
c0100653:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100657:	81 6d ec 00 10 00 00 	subl   $0x1000,-0x14(%ebp)
c010065e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100662:	79 e2                	jns    c0100646 <init_kern_pgdir+0x6b>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
c0100664:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100667:	a3 c0 26 17 c0       	mov    %eax,0xc01726c0
	lcr3(PADDR(kern_pgdir));	
c010066c:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c0100671:	83 ec 04             	sub    $0x4,%esp
c0100674:	50                   	push   %eax
c0100675:	6a 35                	push   $0x35
c0100677:	68 d1 21 10 c0       	push   $0xc01021d1
c010067c:	e8 8c fe ff ff       	call   c010050d <_paddr>
c0100681:	83 c4 10             	add    $0x10,%esp
c0100684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0100687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010068a:	0f 22 d8             	mov    %eax,%cr3
}
c010068d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100690:	c9                   	leave  
c0100691:	c3                   	ret    

c0100692 <page_init>:
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
c0100692:	55                   	push   %ebp
c0100693:	89 e5                	mov    %esp,%ebp
c0100695:	83 ec 18             	sub    $0x18,%esp
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	
c0100698:	e8 3e ff ff ff       	call   c01005db <init_kern_pgdir>

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
c010069d:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	for (i = 0; i < base; i++) {
c01006a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01006ab:	eb 11                	jmp    c01006be <page_init+0x2c>
		pages[i].pp_ref = 1;
c01006ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b0:	66 c7 04 c5 04 27 17 	movw   $0x1,-0x3fe8d8fc(,%eax,8)
c01006b7:	c0 01 00 
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
c01006ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01006be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01006c4:	77 e7                	ja     c01006ad <page_init+0x1b>
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c01006c6:	c7 45 f4 ff 7f 00 00 	movl   $0x7fff,-0xc(%ebp)
c01006cd:	eb 31                	jmp    c0100700 <page_init+0x6e>
		pages[i].pp_ref = 0;
c01006cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d2:	66 c7 04 c5 04 27 17 	movw   $0x0,-0x3fe8d8fc(,%eax,8)
c01006d9:	c0 00 00 
		pages[i].pp_link = page_free_list;
c01006dc:	8b 15 00 10 13 c0    	mov    0xc0131000,%edx
c01006e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e5:	89 14 c5 00 27 17 c0 	mov    %edx,-0x3fe8d900(,%eax,8)
		page_free_list = &pages[i];
c01006ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ef:	c1 e0 03             	shl    $0x3,%eax
c01006f2:	05 00 27 17 c0       	add    $0xc0172700,%eax
c01006f7:	a3 00 10 13 c0       	mov    %eax,0xc0131000
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c01006fc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100700:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100703:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100706:	76 c7                	jbe    c01006cf <page_init+0x3d>
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
c0100708:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
c010070f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100712:	05 ff f9 00 00       	add    $0xf9ff,%eax
c0100717:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010071a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010071d:	ba 00 00 00 00       	mov    $0x0,%edx
c0100722:	f7 75 ec             	divl   -0x14(%ebp)
c0100725:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100728:	29 d0                	sub    %edx,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c0100731:	83 ec 0c             	sub    $0xc,%esp
c0100734:	6a 03                	push   $0x3
c0100736:	68 00 00 0a 00       	push   $0xa0000
c010073b:	52                   	push   %edx
c010073c:	68 00 00 0a 00       	push   $0xa0000
c0100741:	50                   	push   %eax
c0100742:	e8 a1 01 00 00       	call   c01008e8 <boot_map_region>
c0100747:	83 c4 20             	add    $0x20,%esp
}
c010074a:	c9                   	leave  
c010074b:	c3                   	ret    

c010074c <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
c010074c:	55                   	push   %ebp
c010074d:	89 e5                	mov    %esp,%ebp
c010074f:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	struct PageInfo *p = page_free_list;
c0100752:	a1 00 10 13 c0       	mov    0xc0131000,%eax
c0100757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL) return NULL;
c010075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010075e:	75 07                	jne    c0100767 <page_alloc+0x1b>
c0100760:	b8 00 00 00 00       	mov    $0x0,%eax
c0100765:	eb 43                	jmp    c01007aa <page_alloc+0x5e>
	if (alloc_flags & ALLOC_ZERO) {
c0100767:	8b 45 08             	mov    0x8(%ebp),%eax
c010076a:	83 e0 01             	and    $0x1,%eax
c010076d:	85 c0                	test   %eax,%eax
c010076f:	74 21                	je     c0100792 <page_alloc+0x46>
		memset(page2kva(p), 0, PGSIZE);
c0100771:	83 ec 0c             	sub    $0xc,%esp
c0100774:	ff 75 f4             	pushl  -0xc(%ebp)
c0100777:	e8 39 fe ff ff       	call   c01005b5 <page2kva>
c010077c:	83 c4 10             	add    $0x10,%esp
c010077f:	83 ec 04             	sub    $0x4,%esp
c0100782:	68 00 10 00 00       	push   $0x1000
c0100787:	6a 00                	push   $0x0
c0100789:	50                   	push   %eax
c010078a:	e8 65 fd ff ff       	call   c01004f4 <memset>
c010078f:	83 c4 10             	add    $0x10,%esp
	}
	page_free_list = page_free_list -> pp_link;
c0100792:	a1 00 10 13 c0       	mov    0xc0131000,%eax
c0100797:	8b 00                	mov    (%eax),%eax
c0100799:	a3 00 10 13 c0       	mov    %eax,0xc0131000
	p -> pp_link = NULL;
c010079e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return p;
c01007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01007aa:	c9                   	leave  
c01007ab:	c3                   	ret    

c01007ac <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
c01007ac:	55                   	push   %ebp
c01007ad:	89 e5                	mov    %esp,%ebp
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	//assert(pp->pp_ref == 0 && pp->pp_link == NULL);
	pp->pp_link = page_free_list;
c01007af:	8b 15 00 10 13 c0    	mov    0xc0131000,%edx
c01007b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01007b8:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c01007ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01007bd:	a3 00 10 13 c0       	mov    %eax,0xc0131000
}
c01007c2:	5d                   	pop    %ebp
c01007c3:	c3                   	ret    

c01007c4 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
c01007c4:	55                   	push   %ebp
c01007c5:	89 e5                	mov    %esp,%ebp
	if (--pp->pp_ref == 0)
c01007c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01007ca:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01007ce:	8d 50 ff             	lea    -0x1(%eax),%edx
c01007d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01007d4:	66 89 50 04          	mov    %dx,0x4(%eax)
c01007d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01007db:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01007df:	66 85 c0             	test   %ax,%ax
c01007e2:	75 0b                	jne    c01007ef <page_decref+0x2b>
		page_free(pp);
c01007e4:	ff 75 08             	pushl  0x8(%ebp)
c01007e7:	e8 c0 ff ff ff       	call   c01007ac <page_free>
c01007ec:	83 c4 04             	add    $0x4,%esp
}
c01007ef:	c9                   	leave  
c01007f0:	c3                   	ret    

c01007f1 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
c01007f1:	55                   	push   %ebp
c01007f2:	89 e5                	mov    %esp,%ebp
c01007f4:	53                   	push   %ebx
c01007f5:	83 ec 14             	sub    $0x14,%esp
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);
c01007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fb:	c1 e8 16             	shr    $0x16,%eax
c01007fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (pgdir[pdx] & PTE_P) {
c0100801:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100804:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	01 d0                	add    %edx,%eax
c0100810:	8b 00                	mov    (%eax),%eax
c0100812:	83 e0 01             	and    $0x1,%eax
c0100815:	85 c0                	test   %eax,%eax
c0100817:	74 31                	je     c010084a <pgdir_walk+0x59>
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010081c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100823:	8b 45 08             	mov    0x8(%ebp),%eax
c0100826:	01 d0                	add    %edx,%eax
c0100828:	8b 00                	mov    (%eax),%eax
c010082a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010082f:	83 ec 04             	sub    $0x4,%esp
c0100832:	50                   	push   %eax
c0100833:	68 ae 00 00 00       	push   $0xae
c0100838:	68 d1 21 10 c0       	push   $0xc01021d1
c010083d:	e8 fb fc ff ff       	call   c010053d <_kaddr>
c0100842:	83 c4 10             	add    $0x10,%esp
c0100845:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100848:	eb 7c                	jmp    c01008c6 <pgdir_walk+0xd5>
	}
	else {
		if (create == false) return NULL;
c010084a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010084e:	75 0a                	jne    c010085a <pgdir_walk+0x69>
c0100850:	b8 00 00 00 00       	mov    $0x0,%eax
c0100855:	e9 89 00 00 00       	jmp    c01008e3 <pgdir_walk+0xf2>

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
c010085a:	83 ec 0c             	sub    $0xc,%esp
c010085d:	6a 01                	push   $0x1
c010085f:	e8 e8 fe ff ff       	call   c010074c <page_alloc>
c0100864:	83 c4 10             	add    $0x10,%esp
c0100867:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p == NULL) return NULL;
c010086a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010086e:	75 07                	jne    c0100877 <pgdir_walk+0x86>
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
c0100875:	eb 6c                	jmp    c01008e3 <pgdir_walk+0xf2>

		pgtable = page2kva(p);
c0100877:	83 ec 0c             	sub    $0xc,%esp
c010087a:	ff 75 ec             	pushl  -0x14(%ebp)
c010087d:	e8 33 fd ff ff       	call   c01005b5 <page2kva>
c0100882:	83 c4 10             	add    $0x10,%esp
c0100885:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p -> pp_ref ++;
c0100888:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010088f:	8d 50 01             	lea    0x1(%eax),%edx
c0100892:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100895:	66 89 50 04          	mov    %dx,0x4(%eax)

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
c0100899:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010089c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01008a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01008a6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c01008a9:	83 ec 04             	sub    $0x4,%esp
c01008ac:	ff 75 f4             	pushl  -0xc(%ebp)
c01008af:	68 b9 00 00 00       	push   $0xb9
c01008b4:	68 d1 21 10 c0       	push   $0xc01021d1
c01008b9:	e8 4f fc ff ff       	call   c010050d <_paddr>
c01008be:	83 c4 10             	add    $0x10,%esp
c01008c1:	83 c8 07             	or     $0x7,%eax
c01008c4:	89 03                	mov    %eax,(%ebx)
	}
	int ptx = PTX(va);
c01008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008c9:	c1 e8 0c             	shr    $0xc,%eax
c01008cc:	25 ff 03 00 00       	and    $0x3ff,%eax
c01008d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	return &pgtable[ptx];
c01008d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e1:	01 d0                	add    %edx,%eax
}
c01008e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01008e6:	c9                   	leave  
c01008e7:	c3                   	ret    

c01008e8 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
c01008e8:	55                   	push   %ebp
c01008e9:	89 e5                	mov    %esp,%ebp
c01008eb:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	int i;
	int n = size / PGSIZE;
c01008ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01008f1:	c1 e8 0c             	shr    $0xc,%eax
c01008f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	for (i = 0; i < n; i ++) {
c01008f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01008fe:	eb 41                	jmp    c0100941 <boot_map_region+0x59>
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
c0100900:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100903:	83 ec 04             	sub    $0x4,%esp
c0100906:	6a 01                	push   $0x1
c0100908:	50                   	push   %eax
c0100909:	ff 75 08             	pushl  0x8(%ebp)
c010090c:	e8 e0 fe ff ff       	call   c01007f1 <pgdir_walk>
c0100911:	83 c4 10             	add    $0x10,%esp
c0100914:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pte == NULL) return;
c0100917:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010091b:	75 02                	jne    c010091f <boot_map_region+0x37>
c010091d:	eb 2a                	jmp    c0100949 <boot_map_region+0x61>

		*pte = pa | perm | PTE_P;
c010091f:	8b 45 18             	mov    0x18(%ebp),%eax
c0100922:	0b 45 14             	or     0x14(%ebp),%eax
c0100925:	83 c8 01             	or     $0x1,%eax
c0100928:	89 c2                	mov    %eax,%edx
c010092a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092d:	89 10                	mov    %edx,(%eax)

		va += PGSIZE;
c010092f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
		pa += PGSIZE;
c0100936:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
c010093d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100941:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100944:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100947:	7c b7                	jl     c0100900 <boot_map_region+0x18>
		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}
c0100949:	c9                   	leave  
c010094a:	c3                   	ret    

c010094b <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
c010094b:	55                   	push   %ebp
c010094c:	89 e5                	mov    %esp,%ebp
c010094e:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, true);
c0100951:	83 ec 04             	sub    $0x4,%esp
c0100954:	6a 01                	push   $0x1
c0100956:	ff 75 10             	pushl  0x10(%ebp)
c0100959:	ff 75 08             	pushl  0x8(%ebp)
c010095c:	e8 90 fe ff ff       	call   c01007f1 <pgdir_walk>
c0100961:	83 c4 10             	add    $0x10,%esp
c0100964:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) {
c0100967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010096b:	75 07                	jne    c0100974 <page_insert+0x29>
		return -1;
c010096d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100972:	eb 75                	jmp    c01009e9 <page_insert+0x9e>
//		return -E_NO_MEM;
	}

	physaddr_t pa = page2pa(pp);
c0100974:	83 ec 0c             	sub    $0xc,%esp
c0100977:	ff 75 0c             	pushl  0xc(%ebp)
c010097a:	e8 ee fb ff ff       	call   c010056d <page2pa>
c010097f:	83 c4 10             	add    $0x10,%esp
c0100982:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (*pte & PTE_P) {
c0100985:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100988:	8b 00                	mov    (%eax),%eax
c010098a:	83 e0 01             	and    $0x1,%eax
c010098d:	85 c0                	test   %eax,%eax
c010098f:	74 32                	je     c01009c3 <page_insert+0x78>
		if (PTE_ADDR(*pte) == pa) {
c0100991:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100994:	8b 00                	mov    (%eax),%eax
c0100996:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010099b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010099e:	75 12                	jne    c01009b2 <page_insert+0x67>
			*pte = pa | perm | PTE_P;
c01009a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01009a3:	0b 45 f0             	or     -0x10(%ebp),%eax
c01009a6:	83 c8 01             	or     $0x1,%eax
c01009a9:	89 c2                	mov    %eax,%edx
c01009ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009ae:	89 10                	mov    %edx,(%eax)
c01009b0:	eb 11                	jmp    c01009c3 <page_insert+0x78>
		}
		else {
			page_remove(pgdir, va);
c01009b2:	83 ec 08             	sub    $0x8,%esp
c01009b5:	ff 75 10             	pushl  0x10(%ebp)
c01009b8:	ff 75 08             	pushl  0x8(%ebp)
c01009bb:	e8 7a 00 00 00       	call   c0100a3a <page_remove>
c01009c0:	83 c4 10             	add    $0x10,%esp
		}
	}
	*pte = pa | perm | PTE_P;
c01009c3:	8b 45 14             	mov    0x14(%ebp),%eax
c01009c6:	0b 45 f0             	or     -0x10(%ebp),%eax
c01009c9:	83 c8 01             	or     $0x1,%eax
c01009cc:	89 c2                	mov    %eax,%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	89 10                	mov    %edx,(%eax)
	pp -> pp_ref ++;
c01009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009d6:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01009da:	8d 50 01             	lea    0x1(%eax),%edx
c01009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009e0:	66 89 50 04          	mov    %dx,0x4(%eax)
	return 0;
c01009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01009e9:	c9                   	leave  
c01009ea:	c3                   	ret    

c01009eb <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
c01009eb:	55                   	push   %ebp
c01009ec:	89 e5                	mov    %esp,%ebp
c01009ee:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, false);
c01009f1:	83 ec 04             	sub    $0x4,%esp
c01009f4:	6a 00                	push   $0x0
c01009f6:	ff 75 0c             	pushl  0xc(%ebp)
c01009f9:	ff 75 08             	pushl  0x8(%ebp)
c01009fc:	e8 f0 fd ff ff       	call   c01007f1 <pgdir_walk>
c0100a01:	83 c4 10             	add    $0x10,%esp
c0100a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) return NULL;
c0100a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a0b:	75 07                	jne    c0100a14 <page_lookup+0x29>
c0100a0d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100a12:	eb 24                	jmp    c0100a38 <page_lookup+0x4d>
	if (pte_store != NULL) *pte_store = pte;
c0100a14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100a18:	74 08                	je     c0100a22 <page_lookup+0x37>
c0100a1a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a20:	89 10                	mov    %edx,(%eax)
	return pa2page(PTE_ADDR(*pte));
c0100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100a2c:	83 ec 0c             	sub    $0xc,%esp
c0100a2f:	50                   	push   %eax
c0100a30:	e8 4d fb ff ff       	call   c0100582 <pa2page>
c0100a35:	83 c4 10             	add    $0x10,%esp
}
c0100a38:	c9                   	leave  
c0100a39:	c3                   	ret    

c0100a3a <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
c0100a3a:	55                   	push   %ebp
c0100a3b:	89 e5                	mov    %esp,%ebp
c0100a3d:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte;
	pte_t **pte_store = &pte;
c0100a40:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0100a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);
c0100a46:	83 ec 04             	sub    $0x4,%esp
c0100a49:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a4c:	ff 75 0c             	pushl  0xc(%ebp)
c0100a4f:	ff 75 08             	pushl  0x8(%ebp)
c0100a52:	e8 94 ff ff ff       	call   c01009eb <page_lookup>
c0100a57:	83 c4 10             	add    $0x10,%esp
c0100a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (p != NULL) {
c0100a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100a61:	74 2a                	je     c0100a8d <page_remove+0x53>
		**pte_store = 0;
c0100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a66:	8b 00                	mov    (%eax),%eax
c0100a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(p);
c0100a6e:	83 ec 0c             	sub    $0xc,%esp
c0100a71:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a74:	e8 4b fd ff ff       	call   c01007c4 <page_decref>
c0100a79:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
c0100a7c:	83 ec 08             	sub    $0x8,%esp
c0100a7f:	ff 75 0c             	pushl  0xc(%ebp)
c0100a82:	ff 75 08             	pushl  0x8(%ebp)
c0100a85:	e8 05 00 00 00       	call   c0100a8f <tlb_invalidate>
c0100a8a:	83 c4 10             	add    $0x10,%esp
	}
}
c0100a8d:	c9                   	leave  
c0100a8e:	c3                   	ret    

c0100a8f <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
c0100a8f:	55                   	push   %ebp
c0100a90:	89 e5                	mov    %esp,%ebp
c0100a92:	83 ec 10             	sub    $0x10,%esp
c0100a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
c0100a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100a9e:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
c0100aa1:	c9                   	leave  
c0100aa2:	c3                   	ret    

c0100aa3 <free_pgdir>:

void free_pgdir(pde_t *pgdir)
{
c0100aa3:	55                   	push   %ebp
c0100aa4:	89 e5                	mov    %esp,%ebp
c0100aa6:	83 ec 18             	sub    $0x18,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100aa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ab0:	e9 09 01 00 00       	jmp    c0100bbe <free_pgdir+0x11b>
		if (pgdir[pdx] & PTE_P) {
c0100ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac2:	01 d0                	add    %edx,%eax
c0100ac4:	8b 00                	mov    (%eax),%eax
c0100ac6:	83 e0 01             	and    $0x1,%eax
c0100ac9:	85 c0                	test   %eax,%eax
c0100acb:	0f 84 e9 00 00 00    	je     c0100bba <free_pgdir+0x117>
			if (kern_pgdir[pdx] & PTE_P) continue;
c0100ad1:	a1 c0 26 17 c0       	mov    0xc01726c0,%eax
c0100ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ad9:	c1 e2 02             	shl    $0x2,%edx
c0100adc:	01 d0                	add    %edx,%eax
c0100ade:	8b 00                	mov    (%eax),%eax
c0100ae0:	83 e0 01             	and    $0x1,%eax
c0100ae3:	85 c0                	test   %eax,%eax
c0100ae5:	74 05                	je     c0100aec <free_pgdir+0x49>
c0100ae7:	e9 ce 00 00 00       	jmp    c0100bba <free_pgdir+0x117>
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	01 d0                	add    %edx,%eax
c0100afb:	8b 00                	mov    (%eax),%eax
c0100afd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b02:	83 ec 04             	sub    $0x4,%esp
c0100b05:	50                   	push   %eax
c0100b06:	68 4f 01 00 00       	push   $0x14f
c0100b0b:	68 d1 21 10 c0       	push   $0xc01021d1
c0100b10:	e8 28 fa ff ff       	call   c010053d <_kaddr>
c0100b15:	83 c4 10             	add    $0x10,%esp
c0100b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100b1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100b22:	eb 4a                	jmp    c0100b6e <free_pgdir+0xcb>
				if (pgtable[ptx] & PTE_P) {
c0100b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100b31:	01 d0                	add    %edx,%eax
c0100b33:	8b 00                	mov    (%eax),%eax
c0100b35:	83 e0 01             	and    $0x1,%eax
c0100b38:	85 c0                	test   %eax,%eax
c0100b3a:	74 2e                	je     c0100b6a <free_pgdir+0xc7>
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
c0100b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100b49:	01 d0                	add    %edx,%eax
c0100b4b:	8b 00                	mov    (%eax),%eax
c0100b4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b52:	83 ec 0c             	sub    $0xc,%esp
c0100b55:	50                   	push   %eax
c0100b56:	e8 27 fa ff ff       	call   c0100582 <pa2page>
c0100b5b:	83 c4 10             	add    $0x10,%esp
c0100b5e:	83 ec 0c             	sub    $0xc,%esp
c0100b61:	50                   	push   %eax
c0100b62:	e8 5d fc ff ff       	call   c01007c4 <page_decref>
c0100b67:	83 c4 10             	add    $0x10,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100b6a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100b6e:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100b75:	7e ad                	jle    c0100b24 <free_pgdir+0x81>
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
c0100b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b84:	01 d0                	add    %edx,%eax
c0100b86:	8b 00                	mov    (%eax),%eax
c0100b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b8d:	83 ec 0c             	sub    $0xc,%esp
c0100b90:	50                   	push   %eax
c0100b91:	e8 ec f9 ff ff       	call   c0100582 <pa2page>
c0100b96:	83 c4 10             	add    $0x10,%esp
c0100b99:	83 ec 0c             	sub    $0xc,%esp
c0100b9c:	50                   	push   %eax
c0100b9d:	e8 22 fc ff ff       	call   c01007c4 <page_decref>
c0100ba2:	83 c4 10             	add    $0x10,%esp
			pgdir[pdx] = 0;
c0100ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb2:	01 d0                	add    %edx,%eax
c0100bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100bba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bbe:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100bc5:	0f 8e ea fe ff ff    	jle    c0100ab5 <free_pgdir+0x12>
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}
c0100bcb:	c9                   	leave  
c0100bcc:	c3                   	ret    

c0100bcd <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void
irq_handle(struct TrapFrame *tf) {
c0100bcd:	55                   	push   %ebp
c0100bce:	89 e5                	mov    %esp,%ebp
c0100bd0:	83 ec 38             	sub    $0x38,%esp
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0100bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd6:	8b 40 30             	mov    0x30(%eax),%eax
c0100bd9:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0100bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be1:	8b 40 30             	mov    0x30(%eax),%eax
c0100be4:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100be9:	75 0e                	jne    c0100bf9 <irq_handle+0x2c>
		//printk("ha");
		do_syscall(tf);
c0100beb:	83 ec 0c             	sub    $0xc,%esp
c0100bee:	ff 75 08             	pushl  0x8(%ebp)
c0100bf1:	e8 53 0b 00 00       	call   c0101749 <do_syscall>
c0100bf6:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0100bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bfc:	8b 40 30             	mov    0x30(%eax),%eax
c0100bff:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0100c04:	75 0a                	jne    c0100c10 <irq_handle+0x43>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0100c06:	e8 e0 10 00 00       	call   c0101ceb <do_timer>
c0100c0b:	e9 83 00 00 00       	jmp    c0100c93 <irq_handle+0xc6>
	} else if (tf->irq == 1001) {
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	8b 40 30             	mov    0x30(%eax),%eax
c0100c16:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0100c1b:	75 76                	jne    c0100c93 <irq_handle+0xc6>
c0100c1d:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c27:	89 c2                	mov    %eax,%edx
c0100c29:	ec                   	in     (%dx),%al
c0100c2a:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0100c2d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0100c31:	0f b6 c0             	movzbl %al,%eax
c0100c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c37:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100c41:	89 c2                	mov    %eax,%edx
c0100c43:	ec                   	in     (%dx),%al
c0100c44:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0100c47:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0100c4b:	0f b6 c0             	movzbl %al,%eax
c0100c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0100c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c54:	83 c8 80             	or     $0xffffff80,%eax
c0100c57:	0f b6 c0             	movzbl %al,%eax
c0100c5a:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0100c61:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100c64:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100c68:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100c6b:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0100c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c6f:	0f b6 c0             	movzbl %al,%eax
c0100c72:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0100c79:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0100c7c:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100c80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100c83:	ee                   	out    %al,(%dx)
		press_key(code);
c0100c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c87:	83 ec 0c             	sub    $0xc,%esp
c0100c8a:	50                   	push   %eax
c0100c8b:	e8 df 09 00 00       	call   c010166f <press_key>
c0100c90:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
}
c0100c93:	c9                   	leave  
c0100c94:	c3                   	ret    

c0100c95 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0100c95:	55                   	push   %ebp
c0100c96:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100c98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c9b:	83 e8 01             	sub    $0x1,%eax
c0100c9e:	66 a3 00 30 15 c0    	mov    %ax,0xc0153000
	data[1] = (uint32_t)addr;
c0100ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ca7:	66 a3 02 30 15 c0    	mov    %ax,0xc0153002
	data[2] = ((uint32_t)addr) >> 16;
c0100cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cb0:	c1 e8 10             	shr    $0x10,%eax
c0100cb3:	66 a3 04 30 15 c0    	mov    %ax,0xc0153004
	asm volatile("lidt (%0)" : : "r"(data));
c0100cb9:	b8 00 30 15 c0       	mov    $0xc0153000,%eax
c0100cbe:	0f 01 18             	lidtl  (%eax)
}
c0100cc1:	5d                   	pop    %ebp
c0100cc2:	c3                   	ret    

c0100cc3 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100cc3:	55                   	push   %ebp
c0100cc4:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100cc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cc9:	89 c2                	mov    %eax,%edx
c0100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cce:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cd4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cde:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ce5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0100ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cec:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100cf0:	83 e2 f0             	and    $0xfffffff0,%edx
c0100cf3:	83 ca 0e             	or     $0xe,%edx
c0100cf6:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfc:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d00:	83 e2 ef             	and    $0xffffffef,%edx
c0100d03:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100d06:	8b 45 14             	mov    0x14(%ebp),%eax
c0100d09:	83 e0 03             	and    $0x3,%eax
c0100d0c:	89 c2                	mov    %eax,%edx
c0100d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d11:	83 e2 03             	and    $0x3,%edx
c0100d14:	89 d1                	mov    %edx,%ecx
c0100d16:	c1 e1 05             	shl    $0x5,%ecx
c0100d19:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d1d:	83 e2 9f             	and    $0xffffff9f,%edx
c0100d20:	09 ca                	or     %ecx,%edx
c0100d22:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d28:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d2c:	83 ca 80             	or     $0xffffff80,%edx
c0100d2f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100d32:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d35:	c1 e8 10             	shr    $0x10,%eax
c0100d38:	89 c2                	mov    %eax,%edx
c0100d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3d:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100d41:	5d                   	pop    %ebp
c0100d42:	c3                   	ret    

c0100d43 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100d43:	55                   	push   %ebp
c0100d44:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100d46:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d49:	89 c2                	mov    %eax,%edx
c0100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4e:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100d51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d54:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5e:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d65:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c0100d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d6c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d70:	83 ca 0f             	or     $0xf,%edx
c0100d73:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d79:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d7d:	83 e2 ef             	and    $0xffffffef,%edx
c0100d80:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100d83:	8b 45 14             	mov    0x14(%ebp),%eax
c0100d86:	83 e0 03             	and    $0x3,%eax
c0100d89:	89 c2                	mov    %eax,%edx
c0100d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d8e:	83 e2 03             	and    $0x3,%edx
c0100d91:	89 d1                	mov    %edx,%ecx
c0100d93:	c1 e1 05             	shl    $0x5,%ecx
c0100d96:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100d9a:	83 e2 9f             	and    $0xffffff9f,%edx
c0100d9d:	09 ca                	or     %ecx,%edx
c0100d9f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100da5:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100da9:	83 ca 80             	or     $0xffffff80,%edx
c0100dac:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100daf:	8b 45 10             	mov    0x10(%ebp),%eax
c0100db2:	c1 e8 10             	shr    $0x10,%eax
c0100db5:	89 c2                	mov    %eax,%edx
c0100db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100dba:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100dbe:	5d                   	pop    %ebp
c0100dbf:	c3                   	ret    

c0100dc0 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0100dc0:	55                   	push   %ebp
c0100dc1:	89 e5                	mov    %esp,%ebp
c0100dc3:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100dc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100dcd:	eb 22                	jmp    c0100df1 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c0100dcf:	ba be 1d 10 c0       	mov    $0xc0101dbe,%edx
c0100dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd7:	c1 e0 03             	shl    $0x3,%eax
c0100dda:	05 40 2a 1b c0       	add    $0xc01b2a40,%eax
c0100ddf:	6a 00                	push   $0x0
c0100de1:	52                   	push   %edx
c0100de2:	6a 01                	push   $0x1
c0100de4:	50                   	push   %eax
c0100de5:	e8 59 ff ff ff       	call   c0100d43 <set_trap>
c0100dea:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100ded:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100df1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0100df8:	7e d5                	jle    c0100dcf <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0100dfa:	b8 07 1d 10 c0       	mov    $0xc0101d07,%eax
c0100dff:	6a 00                	push   $0x0
c0100e01:	50                   	push   %eax
c0100e02:	6a 01                	push   $0x1
c0100e04:	68 40 2a 1b c0       	push   $0xc01b2a40
c0100e09:	e8 35 ff ff ff       	call   c0100d43 <set_trap>
c0100e0e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0100e11:	b8 10 1d 10 c0       	mov    $0xc0101d10,%eax
c0100e16:	6a 00                	push   $0x0
c0100e18:	50                   	push   %eax
c0100e19:	6a 01                	push   $0x1
c0100e1b:	68 48 2a 1b c0       	push   $0xc01b2a48
c0100e20:	e8 1e ff ff ff       	call   c0100d43 <set_trap>
c0100e25:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c0100e28:	b8 19 1d 10 c0       	mov    $0xc0101d19,%eax
c0100e2d:	6a 00                	push   $0x0
c0100e2f:	50                   	push   %eax
c0100e30:	6a 01                	push   $0x1
c0100e32:	68 50 2a 1b c0       	push   $0xc01b2a50
c0100e37:	e8 07 ff ff ff       	call   c0100d43 <set_trap>
c0100e3c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0100e3f:	b8 22 1d 10 c0       	mov    $0xc0101d22,%eax
c0100e44:	6a 00                	push   $0x0
c0100e46:	50                   	push   %eax
c0100e47:	6a 01                	push   $0x1
c0100e49:	68 58 2a 1b c0       	push   $0xc01b2a58
c0100e4e:	e8 f0 fe ff ff       	call   c0100d43 <set_trap>
c0100e53:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0100e56:	b8 2b 1d 10 c0       	mov    $0xc0101d2b,%eax
c0100e5b:	6a 00                	push   $0x0
c0100e5d:	50                   	push   %eax
c0100e5e:	6a 01                	push   $0x1
c0100e60:	68 60 2a 1b c0       	push   $0xc01b2a60
c0100e65:	e8 d9 fe ff ff       	call   c0100d43 <set_trap>
c0100e6a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0100e6d:	b8 34 1d 10 c0       	mov    $0xc0101d34,%eax
c0100e72:	6a 00                	push   $0x0
c0100e74:	50                   	push   %eax
c0100e75:	6a 01                	push   $0x1
c0100e77:	68 68 2a 1b c0       	push   $0xc01b2a68
c0100e7c:	e8 c2 fe ff ff       	call   c0100d43 <set_trap>
c0100e81:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0100e84:	b8 3d 1d 10 c0       	mov    $0xc0101d3d,%eax
c0100e89:	6a 00                	push   $0x0
c0100e8b:	50                   	push   %eax
c0100e8c:	6a 01                	push   $0x1
c0100e8e:	68 70 2a 1b c0       	push   $0xc01b2a70
c0100e93:	e8 ab fe ff ff       	call   c0100d43 <set_trap>
c0100e98:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0100e9b:	b8 46 1d 10 c0       	mov    $0xc0101d46,%eax
c0100ea0:	6a 00                	push   $0x0
c0100ea2:	50                   	push   %eax
c0100ea3:	6a 01                	push   $0x1
c0100ea5:	68 78 2a 1b c0       	push   $0xc01b2a78
c0100eaa:	e8 94 fe ff ff       	call   c0100d43 <set_trap>
c0100eaf:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0100eb2:	b8 4f 1d 10 c0       	mov    $0xc0101d4f,%eax
c0100eb7:	6a 00                	push   $0x0
c0100eb9:	50                   	push   %eax
c0100eba:	6a 01                	push   $0x1
c0100ebc:	68 80 2a 1b c0       	push   $0xc01b2a80
c0100ec1:	e8 7d fe ff ff       	call   c0100d43 <set_trap>
c0100ec6:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0100ec9:	b8 58 1d 10 c0       	mov    $0xc0101d58,%eax
c0100ece:	6a 00                	push   $0x0
c0100ed0:	50                   	push   %eax
c0100ed1:	6a 01                	push   $0x1
c0100ed3:	68 88 2a 1b c0       	push   $0xc01b2a88
c0100ed8:	e8 66 fe ff ff       	call   c0100d43 <set_trap>
c0100edd:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c0100ee0:	b8 61 1d 10 c0       	mov    $0xc0101d61,%eax
c0100ee5:	6a 00                	push   $0x0
c0100ee7:	50                   	push   %eax
c0100ee8:	6a 01                	push   $0x1
c0100eea:	68 90 2a 1b c0       	push   $0xc01b2a90
c0100eef:	e8 4f fe ff ff       	call   c0100d43 <set_trap>
c0100ef4:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c0100ef7:	b8 6a 1d 10 c0       	mov    $0xc0101d6a,%eax
c0100efc:	6a 00                	push   $0x0
c0100efe:	50                   	push   %eax
c0100eff:	6a 01                	push   $0x1
c0100f01:	68 98 2a 1b c0       	push   $0xc01b2a98
c0100f06:	e8 38 fe ff ff       	call   c0100d43 <set_trap>
c0100f0b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0100f0e:	b8 73 1d 10 c0       	mov    $0xc0101d73,%eax
c0100f13:	6a 00                	push   $0x0
c0100f15:	50                   	push   %eax
c0100f16:	6a 01                	push   $0x1
c0100f18:	68 a0 2a 1b c0       	push   $0xc01b2aa0
c0100f1d:	e8 21 fe ff ff       	call   c0100d43 <set_trap>
c0100f22:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0100f25:	b8 7c 1d 10 c0       	mov    $0xc0101d7c,%eax
c0100f2a:	6a 00                	push   $0x0
c0100f2c:	50                   	push   %eax
c0100f2d:	6a 01                	push   $0x1
c0100f2f:	68 a8 2a 1b c0       	push   $0xc01b2aa8
c0100f34:	e8 0a fe ff ff       	call   c0100d43 <set_trap>
c0100f39:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c0100f3c:	b8 8e 1d 10 c0       	mov    $0xc0101d8e,%eax
c0100f41:	6a 03                	push   $0x3
c0100f43:	50                   	push   %eax
c0100f44:	6a 01                	push   $0x1
c0100f46:	68 40 2e 1b c0       	push   $0xc01b2e40
c0100f4b:	e8 f3 fd ff ff       	call   c0100d43 <set_trap>
c0100f50:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0100f53:	b8 9a 1d 10 c0       	mov    $0xc0101d9a,%eax
c0100f58:	6a 00                	push   $0x0
c0100f5a:	50                   	push   %eax
c0100f5b:	6a 01                	push   $0x1
c0100f5d:	68 40 2b 1b c0       	push   $0xc01b2b40
c0100f62:	e8 5c fd ff ff       	call   c0100cc3 <set_intr>
c0100f67:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c0100f6a:	b8 a6 1d 10 c0       	mov    $0xc0101da6,%eax
c0100f6f:	6a 00                	push   $0x0
c0100f71:	50                   	push   %eax
c0100f72:	6a 01                	push   $0x1
c0100f74:	68 48 2b 1b c0       	push   $0xc01b2b48
c0100f79:	e8 45 fd ff ff       	call   c0100cc3 <set_intr>
c0100f7e:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0100f81:	68 00 08 00 00       	push   $0x800
c0100f86:	68 40 2a 1b c0       	push   $0xc01b2a40
c0100f8b:	e8 05 fd ff ff       	call   c0100c95 <save_idt>
c0100f90:	83 c4 08             	add    $0x8,%esp
}
c0100f93:	c9                   	leave  
c0100f94:	c3                   	ret    

c0100f95 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c0100f95:	55                   	push   %ebp
c0100f96:	89 e5                	mov    %esp,%ebp
c0100f98:	83 ec 40             	sub    $0x40,%esp
c0100f9b:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0100fa2:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100fa6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100faa:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100fad:	ee                   	out    %al,(%dx)
c0100fae:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0100fb5:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0100fb9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0100fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100fc0:	ee                   	out    %al,(%dx)
c0100fc1:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0100fc8:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0100fcc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100fd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100fd3:	ee                   	out    %al,(%dx)
c0100fd4:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0100fdb:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0100fdf:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0100fe3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100fe6:	ee                   	out    %al,(%dx)
c0100fe7:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c0100fee:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0100ff2:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100ff6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100ff9:	ee                   	out    %al,(%dx)
c0100ffa:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c0101001:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0101005:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101009:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010100c:	ee                   	out    %al,(%dx)
c010100d:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0101014:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0101018:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c010101c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010101f:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c0101020:	c9                   	leave  
c0101021:	c3                   	ret    

c0101022 <serial_idle>:

static inline
int serial_idle(void) {
c0101022:	55                   	push   %ebp
c0101023:	89 e5                	mov    %esp,%ebp
c0101025:	83 ec 10             	sub    $0x10,%esp
c0101028:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010102f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101032:	89 c2                	mov    %eax,%edx
c0101034:	ec                   	in     (%dx),%al
c0101035:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101038:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010103c:	0f b6 c0             	movzbl %al,%eax
c010103f:	83 e0 20             	and    $0x20,%eax
c0101042:	85 c0                	test   %eax,%eax
c0101044:	0f 95 c0             	setne  %al
c0101047:	0f b6 c0             	movzbl %al,%eax
}
c010104a:	c9                   	leave  
c010104b:	c3                   	ret    

c010104c <serial_printc>:

static inline
void serial_printc(char ch) {
c010104c:	55                   	push   %ebp
c010104d:	89 e5                	mov    %esp,%ebp
c010104f:	83 ec 14             	sub    $0x14,%esp
c0101052:	8b 45 08             	mov    0x8(%ebp),%eax
c0101055:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101058:	90                   	nop
c0101059:	e8 c4 ff ff ff       	call   c0101022 <serial_idle>
c010105e:	85 c0                	test   %eax,%eax
c0101060:	74 f7                	je     c0101059 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101062:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101066:	0f b6 c0             	movzbl %al,%eax
c0101069:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101070:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101073:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101077:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010107a:	ee                   	out    %al,(%dx)
}
c010107b:	c9                   	leave  
c010107c:	c3                   	ret    

c010107d <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010107d:	55                   	push   %ebp
c010107e:	89 e5                	mov    %esp,%ebp
c0101080:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101083:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101086:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101089:	8b 45 08             	mov    0x8(%ebp),%eax
c010108c:	83 ec 04             	sub    $0x4,%esp
c010108f:	ff 75 f4             	pushl  -0xc(%ebp)
c0101092:	50                   	push   %eax
c0101093:	68 4c 10 10 c0       	push   $0xc010104c
c0101098:	e8 e2 0d 00 00       	call   c0101e7f <vfprintf>
c010109d:	83 c4 10             	add    $0x10,%esp
}
c01010a0:	c9                   	leave  
c01010a1:	c3                   	ret    

c01010a2 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c01010a2:	55                   	push   %ebp
c01010a3:	89 e5                	mov    %esp,%ebp
c01010a5:	83 ec 70             	sub    $0x70,%esp
c01010a8:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01010af:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01010b3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01010b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01010ba:	ee                   	out    %al,(%dx)
c01010bb:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01010c2:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01010c6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01010ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01010cd:	ee                   	out    %al,(%dx)
c01010ce:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01010d5:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01010d9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01010e0:	ee                   	out    %al,(%dx)
c01010e1:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c01010e8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01010ec:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01010f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01010f3:	ee                   	out    %al,(%dx)
c01010f4:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01010fb:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01010ff:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101103:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101106:	ee                   	out    %al,(%dx)
c0101107:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010110e:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c0101112:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101116:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101119:	ee                   	out    %al,(%dx)
c010111a:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0101121:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0101125:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101129:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010112c:	ee                   	out    %al,(%dx)
c010112d:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0101134:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101138:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c010113c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010113f:	ee                   	out    %al,(%dx)
c0101140:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0101147:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c010114b:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c010114f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0101152:	ee                   	out    %al,(%dx)
c0101153:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c010115a:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c010115e:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c0101162:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0101165:	ee                   	out    %al,(%dx)
c0101166:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c010116d:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0101171:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0101175:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101178:	ee                   	out    %al,(%dx)
c0101179:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0101180:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c0101184:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101188:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010118b:	ee                   	out    %al,(%dx)
c010118c:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c0101193:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0101197:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c010119b:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010119e:	ee                   	out    %al,(%dx)
c010119f:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c01011a6:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01011aa:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01011ae:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01011b1:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01011b2:	c9                   	leave  
c01011b3:	c3                   	ret    

c01011b4 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01011b4:	55                   	push   %ebp
c01011b5:	89 e5                	mov    %esp,%ebp
c01011b7:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01011ba:	c7 45 fc 9b 2e 00 00 	movl   $0x2e9b,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01011c1:	0f b6 05 00 50 10 c0 	movzbl 0xc0105000,%eax
c01011c8:	0f b6 c0             	movzbl %al,%eax
c01011cb:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01011d2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01011d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01011d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01011dc:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01011e0:	0f b6 c0             	movzbl %al,%eax
c01011e3:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01011ea:	88 45 ef             	mov    %al,-0x11(%ebp)
c01011ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01011f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01011f4:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01011f8:	c1 f8 08             	sar    $0x8,%eax
c01011fb:	0f b6 c0             	movzbl %al,%eax
c01011fe:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0101205:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101208:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010120c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010120f:	ee                   	out    %al,(%dx)
}
c0101210:	c9                   	leave  
c0101211:	c3                   	ret    

c0101212 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101212:	55                   	push   %ebp
c0101213:	89 e5                	mov    %esp,%ebp
c0101215:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101218:	90                   	nop
c0101219:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101220:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101223:	89 c2                	mov    %eax,%edx
c0101225:	ec                   	in     (%dx),%al
c0101226:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101229:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010122d:	0f b6 c0             	movzbl %al,%eax
c0101230:	25 c0 00 00 00       	and    $0xc0,%eax
c0101235:	83 f8 40             	cmp    $0x40,%eax
c0101238:	75 df                	jne    c0101219 <waitdisk+0x7>
}
c010123a:	c9                   	leave  
c010123b:	c3                   	ret    

c010123c <readsect>:

static inline void
readsect(void *dst, int offset) {
c010123c:	55                   	push   %ebp
c010123d:	89 e5                	mov    %esp,%ebp
c010123f:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101242:	e8 cb ff ff ff       	call   c0101212 <waitdisk>
c0101247:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c010124e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101252:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101256:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101259:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c010125a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010125d:	0f b6 c0             	movzbl %al,%eax
c0101260:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101267:	88 45 ef             	mov    %al,-0x11(%ebp)
c010126a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010126e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101271:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101272:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101275:	c1 f8 08             	sar    $0x8,%eax
c0101278:	0f b6 c0             	movzbl %al,%eax
c010127b:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101282:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101285:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101289:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010128c:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c010128d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101290:	c1 f8 10             	sar    $0x10,%eax
c0101293:	0f b6 c0             	movzbl %al,%eax
c0101296:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c010129d:	88 45 df             	mov    %al,-0x21(%ebp)
c01012a0:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01012a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01012a7:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012ab:	c1 f8 18             	sar    $0x18,%eax
c01012ae:	83 c8 e0             	or     $0xffffffe0,%eax
c01012b1:	0f b6 c0             	movzbl %al,%eax
c01012b4:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c01012bb:	88 45 d7             	mov    %al,-0x29(%ebp)
c01012be:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01012c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01012c5:	ee                   	out    %al,(%dx)
c01012c6:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c01012cd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c01012d1:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c01012d5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01012d8:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c01012d9:	e8 34 ff ff ff       	call   c0101212 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e5:	eb 29                	jmp    c0101310 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c01012e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01012ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01012f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c01012f7:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c01012fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101301:	89 c2                	mov    %eax,%edx
c0101303:	ed                   	in     (%dx),%eax
c0101304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101307:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010130a:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010130c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101310:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101314:	7e d1                	jle    c01012e7 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c010131e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101321:	8b 45 08             	mov    0x8(%ebp),%eax
c0101324:	01 d0                	add    %edx,%eax
c0101326:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101329:	8b 45 10             	mov    0x10(%ebp),%eax
c010132c:	99                   	cltd   
c010132d:	c1 ea 17             	shr    $0x17,%edx
c0101330:	01 d0                	add    %edx,%eax
c0101332:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101337:	29 d0                	sub    %edx,%eax
c0101339:	f7 d8                	neg    %eax
c010133b:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c010133e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101341:	99                   	cltd   
c0101342:	c1 ea 17             	shr    $0x17,%edx
c0101345:	01 d0                	add    %edx,%eax
c0101347:	c1 f8 09             	sar    $0x9,%eax
c010134a:	83 c0 01             	add    $0x1,%eax
c010134d:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101350:	eb 19                	jmp    c010136b <readseg+0x53>
        readsect(pa, offset);
c0101352:	ff 75 10             	pushl  0x10(%ebp)
c0101355:	ff 75 08             	pushl  0x8(%ebp)
c0101358:	e8 df fe ff ff       	call   c010123c <readsect>
c010135d:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101360:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0101367:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010136b:	8b 45 08             	mov    0x8(%ebp),%eax
c010136e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101371:	72 df                	jb     c0101352 <readseg+0x3a>
        readsect(pa, offset);
c0101373:	c9                   	leave  
c0101374:	c3                   	ret    

c0101375 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101375:	55                   	push   %ebp
c0101376:	89 e5                	mov    %esp,%ebp
c0101378:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c010137b:	8b 45 10             	mov    0x10(%ebp),%eax
c010137e:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101383:	77 16                	ja     c010139b <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101385:	ff 75 10             	pushl  0x10(%ebp)
c0101388:	68 ec 21 10 c0       	push   $0xc01021ec
c010138d:	ff 75 0c             	pushl  0xc(%ebp)
c0101390:	ff 75 08             	pushl  0x8(%ebp)
c0101393:	e8 e5 fc ff ff       	call   c010107d <printk>
c0101398:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c010139b:	8b 45 10             	mov    0x10(%ebp),%eax
c010139e:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01013a3:	c9                   	leave  
c01013a4:	c3                   	ret    

c01013a5 <mm_alloc>:
extern void init_segment(void);
extern void init_page(void);
int main_after_you();
int a=0;
void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
c01013a5:	55                   	push   %ebp
c01013a6:	89 e5                	mov    %esp,%ebp
c01013a8:	83 ec 28             	sub    $0x28,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
c01013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01013b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01013b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
c01013bc:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c01013c3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01013c9:	01 c2                	add    %eax,%edx
c01013cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01013ce:	01 d0                	add    %edx,%eax
c01013d0:	83 e8 01             	sub    $0x1,%eax
c01013d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01013d9:	ba 00 00 00 00       	mov    $0x0,%edx
c01013de:	f7 75 e8             	divl   -0x18(%ebp)
c01013e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01013e4:	29 d0                	sub    %edx,%eax
c01013e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01013e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01013ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ef:	eb 2b                	jmp    c010141c <mm_alloc+0x77>
    p = page_alloc(0);
c01013f1:	83 ec 0c             	sub    $0xc,%esp
c01013f4:	6a 00                	push   $0x0
c01013f6:	e8 51 f3 ff ff       	call   c010074c <page_alloc>
c01013fb:	83 c4 10             	add    $0x10,%esp
c01013fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
c0101401:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101404:	6a 07                	push   $0x7
c0101406:	50                   	push   %eax
c0101407:	ff 75 dc             	pushl  -0x24(%ebp)
c010140a:	ff 75 08             	pushl  0x8(%ebp)
c010140d:	e8 39 f5 ff ff       	call   c010094b <page_insert>
c0101412:	83 c4 10             	add    $0x10,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c0101415:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010141f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0101422:	72 cd                	jb     c01013f1 <mm_alloc+0x4c>
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}
c0101424:	c9                   	leave  
c0101425:	c3                   	ret    

c0101426 <main>:

uint32_t entry;

int main(){
c0101426:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c010142a:	83 e4 f0             	and    $0xfffffff0,%esp
c010142d:	ff 71 fc             	pushl  -0x4(%ecx)
c0101430:	55                   	push   %ebp
c0101431:	89 e5                	mov    %esp,%ebp
c0101433:	51                   	push   %ecx
c0101434:	83 ec 24             	sub    $0x24,%esp
  init_page();
c0101437:	e8 bf ec ff ff       	call   c01000fb <init_page>
  init_segment();
c010143c:	e8 6b ee ff ff       	call   c01002ac <init_segment>
  
	init_serial();
c0101441:	e8 4f fb ff ff       	call   c0100f95 <init_serial>
	init_timer();
c0101446:	e8 69 fd ff ff       	call   c01011b4 <init_timer>
	init_idt();
c010144b:	e8 70 f9 ff ff       	call   c0100dc0 <init_idt>
	init_intr();
c0101450:	e8 4d fc ff ff       	call   c01010a2 <init_intr>
  init_pcb_pool();
c0101455:	e8 3e 05 00 00       	call   c0101998 <init_pcb_pool>
  PCB* pcb = pcb_create();
c010145a:	e8 bb 05 00 00       	call   c0101a1a <pcb_create>
c010145f:	89 45 ec             	mov    %eax,-0x14(%ebp)


  printk("a\n");
c0101462:	83 ec 0c             	sub    $0xc,%esp
c0101465:	68 0f 22 10 c0       	push   $0xc010220f
c010146a:	e8 0e fc ff ff       	call   c010107d <printk>
c010146f:	83 c4 10             	add    $0x10,%esp
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);
c0101472:	83 ec 04             	sub    $0x4,%esp
c0101475:	68 00 90 01 00       	push   $0x19000
c010147a:	68 00 10 00 00       	push   $0x1000
c010147f:	68 40 32 1b c0       	push   $0xc01b3240
c0101484:	e8 8f fe ff ff       	call   c0101318 <readseg>
c0101489:	83 c4 10             	add    $0x10,%esp
  printk("b\n");
c010148c:	83 ec 0c             	sub    $0xc,%esp
c010148f:	68 12 22 10 c0       	push   $0xc0102212
c0101494:	e8 e4 fb ff ff       	call   c010107d <printk>
c0101499:	83 c4 10             	add    $0x10,%esp
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c010149c:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c01014a1:	8b 00                	mov    (%eax),%eax
c01014a3:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c01014a8:	0f 94 c0             	sete   %al
c01014ab:	0f b6 c0             	movzbl %al,%eax
c01014ae:	83 ec 08             	sub    $0x8,%esp
c01014b1:	50                   	push   %eax
c01014b2:	68 15 22 10 c0       	push   $0xc0102215
c01014b7:	e8 c1 fb ff ff       	call   c010107d <printk>
c01014bc:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c01014bf:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c01014c4:	8b 40 1c             	mov    0x1c(%eax),%eax
c01014c7:	05 40 32 1b c0       	add    $0xc01b3240,%eax
c01014cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c01014cf:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c01014d4:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01014d8:	0f b7 c0             	movzwl %ax,%eax
c01014db:	c1 e0 05             	shl    $0x5,%eax
c01014de:	89 c2                	mov    %eax,%edx
c01014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01014e3:	01 d0                	add    %edx,%eax
c01014e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //uint32_t p = PADDR(pcb -> pgdir);
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
c01014e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014eb:	8b 40 08             	mov    0x8(%eax),%eax
c01014ee:	83 ec 04             	sub    $0x4,%esp
c01014f1:	50                   	push   %eax
c01014f2:	6a 44                	push   $0x44
c01014f4:	68 2a 22 10 c0       	push   $0xc010222a
c01014f9:	e8 77 fe ff ff       	call   c0101375 <_paddr>
c01014fe:	83 c4 10             	add    $0x10,%esp
c0101501:	89 45 e0             	mov    %eax,-0x20(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101504:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101507:	0f 22 d8             	mov    %eax,%cr3
  
  printk("c\n");
c010150a:	83 ec 0c             	sub    $0xc,%esp
c010150d:	68 3e 22 10 c0       	push   $0xc010223e
c0101512:	e8 66 fb ff ff       	call   c010107d <printk>
c0101517:	83 c4 10             	add    $0x10,%esp

  for(; ph < eph; ph ++) {
c010151a:	eb 7c                	jmp    c0101598 <main+0x172>
    pa = (unsigned char*)ph->paddr; 
c010151c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010151f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101522:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101525:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101528:	8b 48 14             	mov    0x14(%eax),%ecx
c010152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010152e:	8b 50 08             	mov    0x8(%eax),%edx
c0101531:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101534:	8b 40 08             	mov    0x8(%eax),%eax
c0101537:	83 ec 04             	sub    $0x4,%esp
c010153a:	51                   	push   %ecx
c010153b:	52                   	push   %edx
c010153c:	50                   	push   %eax
c010153d:	e8 63 fe ff ff       	call   c01013a5 <mm_alloc>
c0101542:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, 102400+ph->off); 
c0101545:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101548:	8b 40 04             	mov    0x4(%eax),%eax
c010154b:	05 00 90 01 00       	add    $0x19000,%eax
c0101550:	89 c2                	mov    %eax,%edx
c0101552:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101555:	8b 40 10             	mov    0x10(%eax),%eax
c0101558:	83 ec 04             	sub    $0x4,%esp
c010155b:	52                   	push   %edx
c010155c:	50                   	push   %eax
c010155d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0101560:	e8 b3 fd ff ff       	call   c0101318 <readseg>
c0101565:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0101568:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010156b:	8b 50 10             	mov    0x10(%eax),%edx
c010156e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101571:	01 d0                	add    %edx,%eax
c0101573:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101576:	eb 0c                	jmp    c0101584 <main+0x15e>
c0101578:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010157b:	8d 50 01             	lea    0x1(%eax),%edx
c010157e:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101581:	c6 00 00             	movb   $0x0,(%eax)
c0101584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101587:	8b 50 14             	mov    0x14(%eax),%edx
c010158a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010158d:	01 d0                	add    %edx,%eax
c010158f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101592:	77 e4                	ja     c0101578 <main+0x152>
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
  
  printk("c\n");

  for(; ph < eph; ph ++) {
c0101594:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010159b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010159e:	0f 82 78 ff ff ff    	jb     c010151c <main+0xf6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c01015a4:	b8 40 32 1b c0       	mov    $0xc01b3240,%eax
c01015a9:	8b 40 18             	mov    0x18(%eax),%eax
c01015ac:	a3 f8 1d 10 c0       	mov    %eax,0xc0101df8
  mm_alloc(pcb->pgdir, USTACKTOP - USTACKSIZE, USTACKSIZE);  
c01015b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01015b4:	8b 40 08             	mov    0x8(%eax),%eax
c01015b7:	83 ec 04             	sub    $0x4,%esp
c01015ba:	68 00 80 00 00       	push   $0x8000
c01015bf:	68 00 60 bf be       	push   $0xbebf6000
c01015c4:	50                   	push   %eax
c01015c5:	e8 db fd ff ff       	call   c01013a5 <mm_alloc>
c01015ca:	83 c4 10             	add    $0x10,%esp
  printk("%s\n", "Here we go!");
c01015cd:	83 ec 08             	sub    $0x8,%esp
c01015d0:	68 41 22 10 c0       	push   $0xc0102241
c01015d5:	68 4d 22 10 c0       	push   $0xc010224d
c01015da:	e8 9e fa ff ff       	call   c010107d <printk>
c01015df:	83 c4 10             	add    $0x10,%esp

  //lcr3(PADDR(kern_pgdir));

  init_pcb(pcb, entry+4096, entry);
c01015e2:	a1 f8 1d 10 c0       	mov    0xc0101df8,%eax
c01015e7:	8b 15 f8 1d 10 c0    	mov    0xc0101df8,%edx
c01015ed:	81 c2 00 10 00 00    	add    $0x1000,%edx
c01015f3:	83 ec 04             	sub    $0x4,%esp
c01015f6:	50                   	push   %eax
c01015f7:	52                   	push   %edx
c01015f8:	ff 75 ec             	pushl  -0x14(%ebp)
c01015fb:	e8 c7 03 00 00       	call   c01019c7 <init_pcb>
c0101600:	83 c4 10             	add    $0x10,%esp
  printk("%x\n", *((uint32_t*)entry));
c0101603:	a1 f8 1d 10 c0       	mov    0xc0101df8,%eax
c0101608:	8b 00                	mov    (%eax),%eax
c010160a:	83 ec 08             	sub    $0x8,%esp
c010160d:	50                   	push   %eax
c010160e:	68 51 22 10 c0       	push   $0xc0102251
c0101613:	e8 65 fa ff ff       	call   c010107d <printk>
c0101618:	83 c4 10             	add    $0x10,%esp
  //lcr3(PADDR(pcb->pgdir));

  switch_pcb(pcb);
c010161b:	83 ec 0c             	sub    $0xc,%esp
c010161e:	ff 75 ec             	pushl  -0x14(%ebp)
c0101621:	e8 ad 04 00 00       	call   c0101ad3 <switch_pcb>
c0101626:	83 c4 10             	add    $0x10,%esp
  
  printk("e\n");
c0101629:	83 ec 0c             	sub    $0xc,%esp
c010162c:	68 55 22 10 c0       	push   $0xc0102255
c0101631:	e8 47 fa ff ff       	call   c010107d <printk>
c0101636:	83 c4 10             	add    $0x10,%esp

	return 1;
c0101639:	b8 01 00 00 00       	mov    $0x1,%eax
};
c010163e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0101641:	c9                   	leave  
c0101642:	8d 61 fc             	lea    -0x4(%ecx),%esp
c0101645:	c3                   	ret    

c0101646 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101646:	55                   	push   %ebp
c0101647:	89 e5                	mov    %esp,%ebp
c0101649:	83 ec 04             	sub    $0x4,%esp
c010164c:	8b 45 08             	mov    0x8(%ebp),%eax
c010164f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101652:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101656:	83 e8 61             	sub    $0x61,%eax
c0101659:	8b 04 85 40 30 15 c0 	mov    -0x3feacfc0(,%eax,4),%eax
}
c0101660:	c9                   	leave  
c0101661:	c3                   	ret    

c0101662 <get_lastkey>:
int8_t get_lastkey(){
c0101662:	55                   	push   %ebp
c0101663:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101665:	a1 a8 30 15 c0       	mov    0xc01530a8,%eax
c010166a:	83 c0 61             	add    $0x61,%eax
}
c010166d:	5d                   	pop    %ebp
c010166e:	c3                   	ret    

c010166f <press_key>:
void press_key(int code){
c010166f:	55                   	push   %ebp
c0101670:	89 e5                	mov    %esp,%ebp
c0101672:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101675:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c010167c:	8b 45 08             	mov    0x8(%ebp),%eax
c010167f:	25 80 00 00 00       	and    $0x80,%eax
c0101684:	85 c0                	test   %eax,%eax
c0101686:	75 35                	jne    c01016bd <press_key+0x4e>
		for(;i<26;i++){
c0101688:	eb 2b                	jmp    c01016b5 <press_key+0x46>
			if(letter[i]==code){
c010168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010168d:	8b 04 85 40 50 10 c0 	mov    -0x3fefafc0(,%eax,4),%eax
c0101694:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101697:	75 18                	jne    c01016b1 <press_key+0x42>
				keydown[i] = 1;
c0101699:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010169c:	c7 04 85 40 30 15 c0 	movl   $0x1,-0x3feacfc0(,%eax,4)
c01016a3:	01 00 00 00 
				lastkey = i;
c01016a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016aa:	a3 a8 30 15 c0       	mov    %eax,0xc01530a8
				return;
c01016af:	eb 3b                	jmp    c01016ec <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c01016b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01016b5:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01016b9:	7e cf                	jle    c010168a <press_key+0x1b>
c01016bb:	eb 2f                	jmp    c01016ec <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c01016bd:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c01016c1:	eb 23                	jmp    c01016e6 <press_key+0x77>
			if(letter[i]==code){
c01016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016c6:	8b 04 85 40 50 10 c0 	mov    -0x3fefafc0(,%eax,4),%eax
c01016cd:	3b 45 08             	cmp    0x8(%ebp),%eax
c01016d0:	75 10                	jne    c01016e2 <press_key+0x73>
				keydown[i] = 0;
c01016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016d5:	c7 04 85 40 30 15 c0 	movl   $0x0,-0x3feacfc0(,%eax,4)
c01016dc:	00 00 00 00 
				return;
c01016e0:	eb 0a                	jmp    c01016ec <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c01016e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01016e6:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01016ea:	7e d7                	jle    c01016c3 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c01016ec:	c9                   	leave  
c01016ed:	c3                   	ret    

c01016ee <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01016ee:	55                   	push   %ebp
c01016ef:	89 e5                	mov    %esp,%ebp
c01016f1:	83 ec 10             	sub    $0x10,%esp
c01016f4:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016fe:	89 c2                	mov    %eax,%edx
c0101700:	ec                   	in     (%dx),%al
c0101701:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101704:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101708:	0f b6 c0             	movzbl %al,%eax
c010170b:	83 e0 20             	and    $0x20,%eax
c010170e:	85 c0                	test   %eax,%eax
c0101710:	0f 95 c0             	setne  %al
c0101713:	0f b6 c0             	movzbl %al,%eax
}
c0101716:	c9                   	leave  
c0101717:	c3                   	ret    

c0101718 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101718:	55                   	push   %ebp
c0101719:	89 e5                	mov    %esp,%ebp
c010171b:	83 ec 14             	sub    $0x14,%esp
c010171e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101721:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101724:	90                   	nop
c0101725:	e8 c4 ff ff ff       	call   c01016ee <serial_idle>
c010172a:	85 c0                	test   %eax,%eax
c010172c:	74 f7                	je     c0101725 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010172e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101732:	0f b6 c0             	movzbl %al,%eax
c0101735:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010173c:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010173f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101743:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101746:	ee                   	out    %al,(%dx)
}
c0101747:	c9                   	leave  
c0101748:	c3                   	ret    

c0101749 <do_syscall>:
#include "lib/syscall.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();

void do_syscall(struct TrapFrame *tf) {
c0101749:	55                   	push   %ebp
c010174a:	89 e5                	mov    %esp,%ebp
c010174c:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c010174f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101752:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101755:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c010175a:	0f 84 85 00 00 00    	je     c01017e5 <do_syscall+0x9c>
c0101760:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101765:	77 1a                	ja     c0101781 <do_syscall+0x38>
c0101767:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c010176c:	74 63                	je     c01017d1 <do_syscall+0x88>
c010176e:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101773:	77 66                	ja     c01017db <do_syscall+0x92>
c0101775:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c010177a:	74 3e                	je     c01017ba <do_syscall+0x71>
c010177c:	e9 0d 01 00 00       	jmp    c010188e <do_syscall+0x145>
c0101781:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101786:	0f 84 8f 00 00 00    	je     c010181b <do_syscall+0xd2>
c010178c:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101791:	77 0c                	ja     c010179f <do_syscall+0x56>
c0101793:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101798:	74 5a                	je     c01017f4 <do_syscall+0xab>
c010179a:	e9 ef 00 00 00       	jmp    c010188e <do_syscall+0x145>
c010179f:	3d 14 05 00 00       	cmp    $0x514,%eax
c01017a4:	0f 84 a0 00 00 00    	je     c010184a <do_syscall+0x101>
c01017aa:	3d 15 05 00 00       	cmp    $0x515,%eax
c01017af:	0f 84 86 00 00 00    	je     c010183b <do_syscall+0xf2>
c01017b5:	e9 d4 00 00 00       	jmp    c010188e <do_syscall+0x145>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c01017ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bd:	8b 40 10             	mov    0x10(%eax),%eax
c01017c0:	0f be c0             	movsbl %al,%eax
c01017c3:	50                   	push   %eax
c01017c4:	e8 4f ff ff ff       	call   c0101718 <serial_printc>
c01017c9:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
c01017cc:	e9 bd 00 00 00       	jmp    c010188e <do_syscall+0x145>
		case SYS_INIT_CACHE:
			initVCache();
c01017d1:	e8 38 03 00 00       	call   c0101b0e <initVCache>
		break;
c01017d6:	e9 b3 00 00 00       	jmp    c010188e <do_syscall+0x145>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c01017db:	e8 63 04 00 00       	call   c0101c43 <clearVRAM>
		break;
c01017e0:	e9 a9 00 00 00       	jmp    c010188e <do_syscall+0x145>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c01017e5:	e8 59 04 00 00       	call   c0101c43 <clearVRAM>
			flushVCache();
c01017ea:	e8 88 03 00 00       	call   c0101b77 <flushVCache>
		break;
c01017ef:	e9 9a 00 00 00       	jmp    c010188e <do_syscall+0x145>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c01017f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01017f7:	8b 40 14             	mov    0x14(%eax),%eax
c01017fa:	0f b6 c0             	movzbl %al,%eax
c01017fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0101800:	8b 52 18             	mov    0x18(%edx),%edx
c0101803:	89 d1                	mov    %edx,%ecx
c0101805:	8b 55 08             	mov    0x8(%ebp),%edx
c0101808:	8b 52 10             	mov    0x10(%edx),%edx
c010180b:	83 ec 04             	sub    $0x4,%esp
c010180e:	50                   	push   %eax
c010180f:	51                   	push   %ecx
c0101810:	52                   	push   %edx
c0101811:	e8 c6 03 00 00       	call   c0101bdc <setPixelAt>
c0101816:	83 c4 10             	add    $0x10,%esp
		break;
c0101819:	eb 73                	jmp    c010188e <do_syscall+0x145>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c010181b:	8b 45 08             	mov    0x8(%ebp),%eax
c010181e:	8b 40 10             	mov    0x10(%eax),%eax
c0101821:	0f be c0             	movsbl %al,%eax
c0101824:	83 ec 0c             	sub    $0xc,%esp
c0101827:	50                   	push   %eax
c0101828:	e8 19 fe ff ff       	call   c0101646 <get_key>
c010182d:	83 c4 10             	add    $0x10,%esp
c0101830:	0f be d0             	movsbl %al,%edx
c0101833:	8b 45 08             	mov    0x8(%ebp),%eax
c0101836:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101839:	eb 53                	jmp    c010188e <do_syscall+0x145>
		case SYS_GET_TICK:
			tf->eax = tick();
c010183b:	e8 bd 04 00 00       	call   c0101cfd <tick>
c0101840:	89 c2                	mov    %eax,%edx
c0101842:	8b 45 08             	mov    0x8(%ebp),%eax
c0101845:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0101848:	eb 44                	jmp    c010188e <do_syscall+0x145>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c010184a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101851:	eb 34                	jmp    c0101887 <do_syscall+0x13e>
				if(!timer_handlers[i].used){
c0101853:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101856:	8b 04 c5 04 27 1b c0 	mov    -0x3fe4d8fc(,%eax,8),%eax
c010185d:	85 c0                	test   %eax,%eax
c010185f:	75 22                	jne    c0101883 <do_syscall+0x13a>
					timer_handlers[i].ptr = (void*)tf->ebx;
c0101861:	8b 45 08             	mov    0x8(%ebp),%eax
c0101864:	8b 40 10             	mov    0x10(%eax),%eax
c0101867:	89 c2                	mov    %eax,%edx
c0101869:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010186c:	89 14 c5 00 27 1b c0 	mov    %edx,-0x3fe4d900(,%eax,8)
					timer_handlers[i].used = 1;
c0101873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101876:	c7 04 c5 04 27 1b c0 	movl   $0x1,-0x3fe4d8fc(,%eax,8)
c010187d:	01 00 00 00 
					break;
c0101881:	eb 0a                	jmp    c010188d <do_syscall+0x144>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101883:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101887:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010188b:	7e c6                	jle    c0101853 <do_syscall+0x10a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c010188d:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c010188e:	c9                   	leave  
c010188f:	c3                   	ret    

c0101890 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101890:	55                   	push   %ebp
c0101891:	89 e5                	mov    %esp,%ebp
c0101893:	83 ec 10             	sub    $0x10,%esp
c0101896:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a0:	89 c2                	mov    %eax,%edx
c01018a2:	ec                   	in     (%dx),%al
c01018a3:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01018a6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01018aa:	0f b6 c0             	movzbl %al,%eax
c01018ad:	83 e0 20             	and    $0x20,%eax
c01018b0:	85 c0                	test   %eax,%eax
c01018b2:	0f 95 c0             	setne  %al
c01018b5:	0f b6 c0             	movzbl %al,%eax
}
c01018b8:	c9                   	leave  
c01018b9:	c3                   	ret    

c01018ba <serial_printc>:

static inline
void serial_printc(char ch) {
c01018ba:	55                   	push   %ebp
c01018bb:	89 e5                	mov    %esp,%ebp
c01018bd:	83 ec 14             	sub    $0x14,%esp
c01018c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01018c3:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01018c6:	90                   	nop
c01018c7:	e8 c4 ff ff ff       	call   c0101890 <serial_idle>
c01018cc:	85 c0                	test   %eax,%eax
c01018ce:	74 f7                	je     c01018c7 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01018d0:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01018d4:	0f b6 c0             	movzbl %al,%eax
c01018d7:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01018de:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01018e1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01018e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01018e8:	ee                   	out    %al,(%dx)
}
c01018e9:	c9                   	leave  
c01018ea:	c3                   	ret    

c01018eb <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01018eb:	55                   	push   %ebp
c01018ec:	89 e5                	mov    %esp,%ebp
c01018ee:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01018f1:	8d 45 0c             	lea    0xc(%ebp),%eax
c01018f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01018f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01018fa:	83 ec 04             	sub    $0x4,%esp
c01018fd:	ff 75 f4             	pushl  -0xc(%ebp)
c0101900:	50                   	push   %eax
c0101901:	68 ba 18 10 c0       	push   $0xc01018ba
c0101906:	e8 74 05 00 00       	call   c0101e7f <vfprintf>
c010190b:	83 c4 10             	add    $0x10,%esp
}
c010190e:	c9                   	leave  
c010190f:	c3                   	ret    

c0101910 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101910:	55                   	push   %ebp
c0101911:	89 e5                	mov    %esp,%ebp
c0101913:	57                   	push   %edi
c0101914:	56                   	push   %esi
c0101915:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101916:	8b 45 10             	mov    0x10(%ebp),%eax
c0101919:	8b 55 0c             	mov    0xc(%ebp),%edx
c010191c:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010191f:	89 c1                	mov    %eax,%ecx
c0101921:	89 d6                	mov    %edx,%esi
c0101923:	89 df                	mov    %ebx,%edi
c0101925:	fc                   	cld    
c0101926:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101928:	5b                   	pop    %ebx
c0101929:	5e                   	pop    %esi
c010192a:	5f                   	pop    %edi
c010192b:	5d                   	pop    %ebp
c010192c:	c3                   	ret    

c010192d <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c010192d:	55                   	push   %ebp
c010192e:	89 e5                	mov    %esp,%ebp
c0101930:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0101933:	8b 45 10             	mov    0x10(%ebp),%eax
c0101936:	c1 e8 0c             	shr    $0xc,%eax
c0101939:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c010193e:	76 13                	jbe    c0101953 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0101940:	83 ec 08             	sub    $0x8,%esp
c0101943:	ff 75 10             	pushl  0x10(%ebp)
c0101946:	68 58 22 10 c0       	push   $0xc0102258
c010194b:	e8 9b ff ff ff       	call   c01018eb <printk>
c0101950:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0101953:	8b 45 10             	mov    0x10(%ebp),%eax
c0101956:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010195b:	c9                   	leave  
c010195c:	c3                   	ret    

c010195d <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c010195d:	55                   	push   %ebp
c010195e:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0101960:	8b 45 08             	mov    0x8(%ebp),%eax
c0101963:	ba 00 27 17 c0       	mov    $0xc0172700,%edx
c0101968:	29 d0                	sub    %edx,%eax
c010196a:	c1 f8 03             	sar    $0x3,%eax
c010196d:	c1 e0 0c             	shl    $0xc,%eax
}
c0101970:	5d                   	pop    %ebp
c0101971:	c3                   	ret    

c0101972 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c0101972:	55                   	push   %ebp
c0101973:	89 e5                	mov    %esp,%ebp
c0101975:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0101978:	ff 75 08             	pushl  0x8(%ebp)
c010197b:	e8 dd ff ff ff       	call   c010195d <page2pa>
c0101980:	83 c4 04             	add    $0x4,%esp
c0101983:	83 ec 04             	sub    $0x4,%esp
c0101986:	50                   	push   %eax
c0101987:	6a 52                	push   $0x52
c0101989:	68 7a 22 10 c0       	push   $0xc010227a
c010198e:	e8 9a ff ff ff       	call   c010192d <_kaddr>
c0101993:	83 c4 10             	add    $0x10,%esp
}
c0101996:	c9                   	leave  
c0101997:	c3                   	ret    

c0101998 <init_pcb_pool>:
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_pcb_pool()
{
c0101998:	55                   	push   %ebp
c0101999:	89 e5                	mov    %esp,%ebp
c010199b:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010199e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019a5:	eb 18                	jmp    c01019bf <init_pcb_pool+0x27>
		PCBPool[i].used = 0;
c01019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019aa:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c01019b0:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c01019b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
};*/

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01019bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019bf:	83 7d fc 63          	cmpl   $0x63,-0x4(%ebp)
c01019c3:	76 e2                	jbe    c01019a7 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
}
c01019c5:	c9                   	leave  
c01019c6:	c3                   	ret    

c01019c7 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry)
{
c01019c7:	55                   	push   %ebp
c01019c8:	89 e5                	mov    %esp,%ebp
c01019ca:	83 ec 10             	sub    $0x10,%esp
	struct TrapFrame *tf = (p->tf);
c01019cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d0:	8b 40 04             	mov    0x4(%eax),%eax
c01019d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	tf->ds = GD_UD | 3;
c01019d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d9:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
	tf->es = GD_UD | 3;
c01019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e3:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
	tf->ss = GD_UD | 3;
c01019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ed:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
	tf->esp = ustack;
c01019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01019f9:	89 50 44             	mov    %edx,0x44(%eax)
	tf->cs = GD_UT | 3;
c01019fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ff:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->eflags = 0x2 | FL_IF;
c0101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a08:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	tf->eip = entry;
c0101a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a12:	8b 55 10             	mov    0x10(%ebp),%edx
c0101a15:	89 50 38             	mov    %edx,0x38(%eax)
}
c0101a18:	c9                   	leave  
c0101a19:	c3                   	ret    

c0101a1a <pcb_create>:

PCB* pcb_create()
{
c0101a1a:	55                   	push   %ebp
c0101a1b:	89 e5                	mov    %esp,%ebp
c0101a1d:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101a20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101a27:	eb 1a                	jmp    c0101a43 <pcb_create+0x29>
		if(!PCBPool[i].used)break;
c0101a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a2c:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c0101a32:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c0101a37:	8b 00                	mov    (%eax),%eax
c0101a39:	85 c0                	test   %eax,%eax
c0101a3b:	75 02                	jne    c0101a3f <pcb_create+0x25>
c0101a3d:	eb 0a                	jmp    c0101a49 <pcb_create+0x2f>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101a3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101a43:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101a47:	76 e0                	jbe    c0101a29 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0101a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a4c:	69 c0 0c 10 00 00    	imul   $0x100c,%eax,%eax
c0101a52:	05 40 54 1b c0       	add    $0xc01b5440,%eax
c0101a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0101a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a5d:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0101a60:	8d 90 80 36 1b c0    	lea    -0x3fe4c980(%eax),%edx
c0101a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a69:	89 50 04             	mov    %edx,0x4(%eax)

	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0101a6c:	83 ec 0c             	sub    $0xc,%esp
c0101a6f:	6a 01                	push   $0x1
c0101a71:	e8 d6 ec ff ff       	call   c010074c <page_alloc>
c0101a76:	83 c4 10             	add    $0x10,%esp
c0101a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0101a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0101a80:	75 07                	jne    c0101a89 <pcb_create+0x6f>
c0101a82:	b8 00 00 00 00       	mov    $0x0,%eax
c0101a87:	eb 48                	jmp    c0101ad1 <pcb_create+0xb7>
	p->pgdir = page2kva(pp);
c0101a89:	83 ec 0c             	sub    $0xc,%esp
c0101a8c:	ff 75 ec             	pushl  -0x14(%ebp)
c0101a8f:	e8 de fe ff ff       	call   c0101972 <page2kva>
c0101a94:	83 c4 10             	add    $0x10,%esp
c0101a97:	89 c2                	mov    %eax,%edx
c0101a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a9c:	89 50 08             	mov    %edx,0x8(%eax)
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0101a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101aa2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0101aa6:	8d 50 01             	lea    0x1(%eax),%edx
c0101aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101aac:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0101ab0:	8b 15 c0 26 17 c0    	mov    0xc01726c0,%edx
c0101ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ab9:	8b 40 08             	mov    0x8(%eax),%eax
c0101abc:	83 ec 04             	sub    $0x4,%esp
c0101abf:	68 00 10 00 00       	push   $0x1000
c0101ac4:	52                   	push   %edx
c0101ac5:	50                   	push   %eax
c0101ac6:	e8 45 fe ff ff       	call   c0101910 <memcpy>
c0101acb:	83 c4 10             	add    $0x10,%esp
	return p;
c0101ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0101ad1:	c9                   	leave  
c0101ad2:	c3                   	ret    

c0101ad3 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0101ad3:	55                   	push   %ebp
c0101ad4:	89 e5                	mov    %esp,%ebp
c0101ad6:	83 ec 08             	sub    $0x8,%esp
	current = pcb;
c0101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adc:	a3 40 36 1b c0       	mov    %eax,0xc01b3640
	enter_pcb(pcb);
c0101ae1:	83 ec 0c             	sub    $0xc,%esp
c0101ae4:	ff 75 08             	pushl  0x8(%ebp)
c0101ae7:	e8 40 e8 ff ff       	call   c010032c <enter_pcb>
c0101aec:	83 c4 10             	add    $0x10,%esp
}
c0101aef:	c9                   	leave  
c0101af0:	c3                   	ret    

c0101af1 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0101af1:	55                   	push   %ebp
c0101af2:	89 e5                	mov    %esp,%ebp
c0101af4:	57                   	push   %edi
c0101af5:	56                   	push   %esi
c0101af6:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101af7:	8b 45 10             	mov    0x10(%ebp),%eax
c0101afa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101b00:	89 c1                	mov    %eax,%ecx
c0101b02:	89 d6                	mov    %edx,%esi
c0101b04:	89 df                	mov    %ebx,%edi
c0101b06:	fc                   	cld    
c0101b07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101b09:	5b                   	pop    %ebx
c0101b0a:	5e                   	pop    %esi
c0101b0b:	5f                   	pop    %edi
c0101b0c:	5d                   	pop    %ebp
c0101b0d:	c3                   	ret    

c0101b0e <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0101b0e:	55                   	push   %ebp
c0101b0f:	89 e5                	mov    %esp,%ebp
c0101b11:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0101b14:	68 80 3e 00 00       	push   $0x3e80
c0101b19:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101b1e:	68 c0 30 15 c0       	push   $0xc01530c0
c0101b23:	e8 c9 ff ff ff       	call   c0101af1 <memcpy>
c0101b28:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0101b2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b32:	eb 0f                	jmp    c0101b43 <initVCache+0x35>
		VDIRTY[x] = 0;
c0101b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b37:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101b3c:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0101b3f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b43:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101b4a:	7e e8                	jle    c0101b34 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0101b4c:	c9                   	leave  
c0101b4d:	c3                   	ret    

c0101b4e <refreshVCache>:
void refreshVCache(){
c0101b4e:	55                   	push   %ebp
c0101b4f:	89 e5                	mov    %esp,%ebp
c0101b51:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101b54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b5b:	eb 0f                	jmp    c0101b6c <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0101b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b60:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101b65:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101b68:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b6c:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101b73:	7e e8                	jle    c0101b5d <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0101b75:	c9                   	leave  
c0101b76:	c3                   	ret    

c0101b77 <flushVCache>:
void flushVCache(){
c0101b77:	55                   	push   %ebp
c0101b78:	89 e5                	mov    %esp,%ebp
c0101b7a:	53                   	push   %ebx
c0101b7b:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101b7e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101b85:	eb 47                	jmp    c0101bce <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0101b87:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b8a:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101b8f:	0f b6 00             	movzbl (%eax),%eax
c0101b92:	84 c0                	test   %al,%al
c0101b94:	74 34                	je     c0101bca <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0101b96:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101b99:	89 d0                	mov    %edx,%eax
c0101b9b:	c1 e0 02             	shl    $0x2,%eax
c0101b9e:	01 d0                	add    %edx,%eax
c0101ba0:	c1 e0 06             	shl    $0x6,%eax
c0101ba3:	8d 88 c0 30 15 c0    	lea    -0x3feacf40(%eax),%ecx
c0101ba9:	8b 1d a8 50 10 c0    	mov    0xc01050a8,%ebx
c0101baf:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101bb2:	89 d0                	mov    %edx,%eax
c0101bb4:	c1 e0 02             	shl    $0x2,%eax
c0101bb7:	01 d0                	add    %edx,%eax
c0101bb9:	c1 e0 06             	shl    $0x6,%eax
c0101bbc:	01 d8                	add    %ebx,%eax
c0101bbe:	6a 50                	push   $0x50
c0101bc0:	51                   	push   %ecx
c0101bc1:	50                   	push   %eax
c0101bc2:	e8 2a ff ff ff       	call   c0101af1 <memcpy>
c0101bc7:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101bca:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101bce:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0101bd5:	7e b0                	jle    c0101b87 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0101bd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101bda:	c9                   	leave  
c0101bdb:	c3                   	ret    

c0101bdc <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0101bdc:	55                   	push   %ebp
c0101bdd:	89 e5                	mov    %esp,%ebp
c0101bdf:	83 ec 04             	sub    $0x4,%esp
c0101be2:	8b 45 10             	mov    0x10(%ebp),%eax
c0101be5:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0101be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101bec:	78 18                	js     c0101c06 <setPixelAt+0x2a>
c0101bee:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0101bf5:	7f 0f                	jg     c0101c06 <setPixelAt+0x2a>
c0101bf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101bfb:	78 09                	js     c0101c06 <setPixelAt+0x2a>
c0101bfd:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0101c04:	7e 02                	jle    c0101c08 <setPixelAt+0x2c>
c0101c06:	eb 34                	jmp    c0101c3c <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0101c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0b:	05 c0 24 17 c0       	add    $0xc01724c0,%eax
c0101c10:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0101c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c16:	05 c0 25 17 c0       	add    $0xc01725c0,%eax
c0101c1b:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0101c1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c21:	89 d0                	mov    %edx,%eax
c0101c23:	c1 e0 02             	shl    $0x2,%eax
c0101c26:	01 d0                	add    %edx,%eax
c0101c28:	c1 e0 06             	shl    $0x6,%eax
c0101c2b:	89 c2                	mov    %eax,%edx
c0101c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c30:	01 c2                	add    %eax,%edx
c0101c32:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0101c36:	88 82 c0 30 15 c0    	mov    %al,-0x3feacf40(%edx)
}
c0101c3c:	c9                   	leave  
c0101c3d:	c3                   	ret    

c0101c3e <forceClearVRAM>:
void forceClearVRAM(){
c0101c3e:	55                   	push   %ebp
c0101c3f:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0101c41:	5d                   	pop    %ebp
c0101c42:	c3                   	ret    

c0101c43 <clearVRAM>:
void clearVRAM(){
c0101c43:	55                   	push   %ebp
c0101c44:	89 e5                	mov    %esp,%ebp
c0101c46:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101c49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101c50:	eb 4e                	jmp    c0101ca0 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0101c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c55:	05 c0 25 17 c0       	add    $0xc01725c0,%eax
c0101c5a:	0f b6 00             	movzbl (%eax),%eax
c0101c5d:	0f b6 c0             	movzbl %al,%eax
c0101c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101c63:	81 c2 c0 24 17 c0    	add    $0xc01724c0,%edx
c0101c69:	0f b6 12             	movzbl (%edx),%edx
c0101c6c:	0f b6 d2             	movzbl %dl,%edx
c0101c6f:	f7 d2                	not    %edx
c0101c71:	21 d0                	and    %edx,%eax
c0101c73:	85 c0                	test   %eax,%eax
c0101c75:	74 25                	je     c0101c9c <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0101c77:	8b 0d a8 50 10 c0    	mov    0xc01050a8,%ecx
c0101c7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101c80:	89 d0                	mov    %edx,%eax
c0101c82:	c1 e0 02             	shl    $0x2,%eax
c0101c85:	01 d0                	add    %edx,%eax
c0101c87:	c1 e0 06             	shl    $0x6,%eax
c0101c8a:	01 c8                	add    %ecx,%eax
c0101c8c:	6a 50                	push   $0x50
c0101c8e:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101c93:	50                   	push   %eax
c0101c94:	e8 58 fe ff ff       	call   c0101af1 <memcpy>
c0101c99:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101c9c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ca0:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101ca7:	7e a9                	jle    c0101c52 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0101ca9:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101cb0:	83 c0 01             	add    $0x1,%eax
c0101cb3:	a2 88 26 17 c0       	mov    %al,0xc0172688
	if(stamp==30){
c0101cb8:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101cbf:	3c 1e                	cmp    $0x1e,%al
c0101cc1:	75 07                	jne    c0101cca <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0101cc3:	c6 05 88 26 17 c0 00 	movb   $0x0,0xc0172688
		//printk("What matters\n");
	}
	if(stamp==0){
c0101cca:	0f b6 05 88 26 17 c0 	movzbl 0xc0172688,%eax
c0101cd1:	84 c0                	test   %al,%al
c0101cd3:	75 14                	jne    c0101ce9 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0101cd5:	6a 32                	push   $0x32
c0101cd7:	68 c0 2a 16 c0       	push   $0xc0162ac0
c0101cdc:	68 c0 25 17 c0       	push   $0xc01725c0
c0101ce1:	e8 0b fe ff ff       	call   c0101af1 <memcpy>
c0101ce6:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0101ce9:	c9                   	leave  
c0101cea:	c3                   	ret    

c0101ceb <do_timer>:
#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
c0101ceb:	55                   	push   %ebp
c0101cec:	89 e5                	mov    %esp,%ebp
	_tick++;
c0101cee:	a1 8c 26 17 c0       	mov    0xc017268c,%eax
c0101cf3:	83 c0 01             	add    $0x1,%eax
c0101cf6:	a3 8c 26 17 c0       	mov    %eax,0xc017268c
	//printk("%x", _tick);
}
c0101cfb:	5d                   	pop    %ebp
c0101cfc:	c3                   	ret    

c0101cfd <tick>:
uint32_t tick(){
c0101cfd:	55                   	push   %ebp
c0101cfe:	89 e5                	mov    %esp,%ebp
	return _tick;
c0101d00:	a1 8c 26 17 c0       	mov    0xc017268c,%eax
c0101d05:	5d                   	pop    %ebp
c0101d06:	c3                   	ret    

c0101d07 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0101d07:	6a 00                	push   $0x0
c0101d09:	6a 00                	push   $0x0
c0101d0b:	e9 b7 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d10 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0101d10:	6a 00                	push   $0x0
c0101d12:	6a 01                	push   $0x1
c0101d14:	e9 ae 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d19 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0101d19:	6a 00                	push   $0x0
c0101d1b:	6a 02                	push   $0x2
c0101d1d:	e9 a5 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d22 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0101d22:	6a 00                	push   $0x0
c0101d24:	6a 03                	push   $0x3
c0101d26:	e9 9c 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d2b <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0101d2b:	6a 00                	push   $0x0
c0101d2d:	6a 04                	push   $0x4
c0101d2f:	e9 93 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d34 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0101d34:	6a 00                	push   $0x0
c0101d36:	6a 05                	push   $0x5
c0101d38:	e9 8a 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d3d <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0101d3d:	6a 00                	push   $0x0
c0101d3f:	6a 06                	push   $0x6
c0101d41:	e9 81 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d46 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0101d46:	6a 00                	push   $0x0
c0101d48:	6a 07                	push   $0x7
c0101d4a:	e9 78 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d4f <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0101d4f:	6a 00                	push   $0x0
c0101d51:	6a 08                	push   $0x8
c0101d53:	e9 6f 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d58 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0101d58:	6a 00                	push   $0x0
c0101d5a:	6a 09                	push   $0x9
c0101d5c:	e9 66 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d61 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0101d61:	6a 00                	push   $0x0
c0101d63:	6a 0a                	push   $0xa
c0101d65:	e9 5d 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d6a <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0101d6a:	6a 00                	push   $0x0
c0101d6c:	6a 0b                	push   $0xb
c0101d6e:	e9 54 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d73 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0101d73:	6a 00                	push   $0x0
c0101d75:	6a 0c                	push   $0xc
c0101d77:	e9 4b 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d7c <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0101d7c:	6a 00                	push   $0x0
c0101d7e:	6a 0d                	push   $0xd
c0101d80:	e9 42 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d85 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0101d85:	6a 00                	push   $0x0
c0101d87:	6a 0e                	push   $0xe
c0101d89:	e9 39 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d8e <vecsys>:

.globl vecsys; vecsys:  pushl $0;  pushl $0x80; jmp asm_do_irq
c0101d8e:	6a 00                	push   $0x0
c0101d90:	68 80 00 00 00       	push   $0x80
c0101d95:	e9 2d 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101d9a <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0101d9a:	6a 00                	push   $0x0
c0101d9c:	68 e8 03 00 00       	push   $0x3e8
c0101da1:	e9 21 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101da6 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0101da6:	6a 00                	push   $0x0
c0101da8:	68 e9 03 00 00       	push   $0x3e9
c0101dad:	e9 15 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101db2 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0101db2:	6a 00                	push   $0x0
c0101db4:	68 f6 03 00 00       	push   $0x3f6
c0101db9:	e9 09 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101dbe <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0101dbe:	6a 00                	push   $0x0
c0101dc0:	6a ff                	push   $0xffffffff
c0101dc2:	e9 00 00 00 00       	jmp    c0101dc7 <asm_do_irq>

c0101dc7 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle


asm_do_irq:
  cli
c0101dc7:	fa                   	cli    
  pushl %ds
c0101dc8:	1e                   	push   %ds
  pushl %es
c0101dc9:	06                   	push   %es
  pushl %fs
c0101dca:	0f a0                	push   %fs
  pushl %gs
c0101dcc:	0f a8                	push   %gs
	pushal
c0101dce:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0101dcf:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0101dd3:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0101dd5:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0101dd7:	54                   	push   %esp
  call irq_handle
c0101dd8:	e8 f0 ed ff ff       	call   c0100bcd <irq_handle>
  addl $4, %esp
c0101ddd:	83 c4 04             	add    $0x4,%esp
  popal
c0101de0:	61                   	popa   
  
  popl %gs
c0101de1:	0f a9                	pop    %gs
  popl %fs
c0101de3:	0f a1                	pop    %fs
  popl %es
c0101de5:	07                   	pop    %es
  popl %ds
c0101de6:	1f                   	pop    %ds
  addl $8, %esp
c0101de7:	83 c4 08             	add    $0x8,%esp
  sti
c0101dea:	fb                   	sti    
c0101deb:	cf                   	iret   
c0101dec:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0101df2:	00 00                	add    %al,(%eax)
c0101df4:	fe 4f 52             	decb   0x52(%edi)
c0101df7:	e4 66                	in     $0x66,%al

c0101df8 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0101df8:	66 c7 05 72 04 00 00 34 12 b8 00 40 10 00 0f 22     f..r...4...@..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0101e08:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 1b 1e 10     .. .......".....
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0101e18:	c0 ff e0                                            ...

c0101e1b <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0101e1b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0101e20:	bc 00 e0 10 c0       	mov    $0xc010e000,%esp

	# now to C code

	call	main
c0101e25:	e8 fc f5 ff ff       	call   c0101426 <main>

c0101e2a <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0101e2a:	eb fe                	jmp    c0101e2a <spin>

c0101e2c <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
c0101e2c:	55                   	push   %ebp
c0101e2d:	89 e5                	mov    %esp,%ebp
c0101e2f:	53                   	push   %ebx
c0101e30:	83 ec 04             	sub    $0x4,%esp
c0101e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e36:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0101e39:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0101e3e:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0101e42:	89 d3                	mov    %edx,%ebx
c0101e44:	cd 80                	int    $0x80
}
c0101e46:	83 c4 04             	add    $0x4,%esp
c0101e49:	5b                   	pop    %ebx
c0101e4a:	5d                   	pop    %ebp
c0101e4b:	c3                   	ret    

c0101e4c <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0101e4c:	55                   	push   %ebp
c0101e4d:	89 e5                	mov    %esp,%ebp
c0101e4f:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0101e52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0101e58:	eb 19                	jmp    c0101e73 <printp+0x27>
		printer(cur);
c0101e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e5d:	0f b6 00             	movzbl (%eax),%eax
c0101e60:	0f be c0             	movsbl %al,%eax
c0101e63:	83 ec 0c             	sub    $0xc,%esp
c0101e66:	50                   	push   %eax
c0101e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6a:	ff d0                	call   *%eax
c0101e6c:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0101e6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e76:	0f b6 00             	movzbl (%eax),%eax
c0101e79:	84 c0                	test   %al,%al
c0101e7b:	75 dd                	jne    c0101e5a <printp+0xe>
		printer(cur);
	}
}
c0101e7d:	c9                   	leave  
c0101e7e:	c3                   	ret    

c0101e7f <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0101e7f:	55                   	push   %ebp
c0101e80:	89 e5                	mov    %esp,%ebp
c0101e82:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
c0101e88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0101e8e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0101e95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0101e9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0101ea2:	e9 71 02 00 00       	jmp    c0102118 <vfprintf+0x299>
		if(cur == '%'){
c0101ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101eaa:	0f b6 00             	movzbl (%eax),%eax
c0101ead:	3c 25                	cmp    $0x25,%al
c0101eaf:	75 0c                	jne    c0101ebd <vfprintf+0x3e>
			type = READ;
c0101eb1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0101eb8:	e9 57 02 00 00       	jmp    c0102114 <vfprintf+0x295>
		}
		if(type == READ){
c0101ebd:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0101ec1:	0f 85 32 02 00 00    	jne    c01020f9 <vfprintf+0x27a>
			if(cur == 's'){
c0101ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101eca:	0f b6 00             	movzbl (%eax),%eax
c0101ecd:	3c 73                	cmp    $0x73,%al
c0101ecf:	75 35                	jne    c0101f06 <vfprintf+0x87>
				char* p= XGET(pointer, char*);
c0101ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101ed4:	8b 00                	mov    (%eax),%eax
c0101ed6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0101ed9:	eb 19                	jmp    c0101ef4 <vfprintf+0x75>
					printer(*p);
c0101edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101ede:	0f b6 00             	movzbl (%eax),%eax
c0101ee1:	0f be c0             	movsbl %al,%eax
c0101ee4:	83 ec 0c             	sub    $0xc,%esp
c0101ee7:	50                   	push   %eax
c0101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eeb:	ff d0                	call   *%eax
c0101eed:	83 c4 10             	add    $0x10,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0101ef0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0101ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101ef7:	0f b6 00             	movzbl (%eax),%eax
c0101efa:	84 c0                	test   %al,%al
c0101efc:	75 dd                	jne    c0101edb <vfprintf+0x5c>
					printer(*p);
				}
				XNEXT(pointer);
c0101efe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0101f02:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
c0101f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f09:	0f b6 00             	movzbl (%eax),%eax
c0101f0c:	3c 78                	cmp    $0x78,%al
c0101f0e:	0f 85 9f 00 00 00    	jne    c0101fb3 <vfprintf+0x134>
				uint32_t x = XGET(pointer, int);
c0101f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101f17:	8b 00                	mov    (%eax),%eax
c0101f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0101f1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0101f20:	75 1d                	jne    c0101f3f <vfprintf+0xc0>
					printer('0');
c0101f22:	83 ec 0c             	sub    $0xc,%esp
c0101f25:	6a 30                	push   $0x30
c0101f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2a:	ff d0                	call   *%eax
c0101f2c:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0101f2f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0101f33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101f3a:	e9 d5 01 00 00       	jmp    c0102114 <vfprintf+0x295>
					continue;
				}
				char digits[100];
				int di=0;
c0101f3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0101f46:	eb 30                	jmp    c0101f78 <vfprintf+0xf9>
					int d=(x%16);
c0101f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f4b:	83 e0 0f             	and    $0xf,%eax
c0101f4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0101f51:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0101f55:	7e 04                	jle    c0101f5b <vfprintf+0xdc>
						d+='a'-'0'-10;
c0101f57:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0101f5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101f5e:	83 c0 30             	add    $0x30,%eax
c0101f61:	89 c1                	mov    %eax,%ecx
c0101f63:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
c0101f69:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101f6c:	01 d0                	add    %edx,%eax
c0101f6e:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0101f70:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0101f74:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
c0101f78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0101f7c:	75 ca                	jne    c0101f48 <vfprintf+0xc9>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0101f7e:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0101f82:	eb 21                	jmp    c0101fa5 <vfprintf+0x126>
					printer(digits[di]);
c0101f84:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
c0101f8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101f8d:	01 d0                	add    %edx,%eax
c0101f8f:	0f b6 00             	movzbl (%eax),%eax
c0101f92:	0f be c0             	movsbl %al,%eax
c0101f95:	83 ec 0c             	sub    $0xc,%esp
c0101f98:	50                   	push   %eax
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	ff d0                	call   *%eax
c0101f9e:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0101fa1:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0101fa5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101fa9:	79 d9                	jns    c0101f84 <vfprintf+0x105>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0101fab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0101faf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
c0101fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fb6:	0f b6 00             	movzbl (%eax),%eax
c0101fb9:	3c 64                	cmp    $0x64,%al
c0101fbb:	0f 85 08 01 00 00    	jne    c01020c9 <vfprintf+0x24a>
				int x = XGET(pointer, int);
c0101fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101fc4:	8b 00                	mov    (%eax),%eax
c0101fc6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0101fc9:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0101fd0:	75 23                	jne    c0101ff5 <vfprintf+0x176>
					printp(printer, "-2147483648");
c0101fd2:	83 ec 08             	sub    $0x8,%esp
c0101fd5:	68 90 22 10 c0       	push   $0xc0102290
c0101fda:	ff 75 08             	pushl  0x8(%ebp)
c0101fdd:	e8 6a fe ff ff       	call   c0101e4c <printp>
c0101fe2:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0101fe5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0101fe9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0101ff0:	e9 1f 01 00 00       	jmp    c0102114 <vfprintf+0x295>
				}
				if(x==0){
c0101ff5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0101ff9:	75 1e                	jne    c0102019 <vfprintf+0x19a>
					printer('0');
c0101ffb:	83 ec 0c             	sub    $0xc,%esp
c0101ffe:	6a 30                	push   $0x30
c0102000:	8b 45 08             	mov    0x8(%ebp),%eax
c0102003:	ff d0                	call   *%eax
c0102005:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102008:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010200c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0102013:	90                   	nop
c0102014:	e9 fb 00 00 00       	jmp    c0102114 <vfprintf+0x295>
				}
				if(x<0){
c0102019:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010201d:	79 10                	jns    c010202f <vfprintf+0x1b0>
					printer('-');
c010201f:	83 ec 0c             	sub    $0xc,%esp
c0102022:	6a 2d                	push   $0x2d
c0102024:	8b 45 08             	mov    0x8(%ebp),%eax
c0102027:	ff d0                	call   *%eax
c0102029:	83 c4 10             	add    $0x10,%esp
					x=-x;
c010202c:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
c010202f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0102036:	eb 56                	jmp    c010208e <vfprintf+0x20f>
					digits[di] = '0'+(x%10);
c0102038:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010203b:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0102040:	89 c8                	mov    %ecx,%eax
c0102042:	f7 ea                	imul   %edx
c0102044:	c1 fa 02             	sar    $0x2,%edx
c0102047:	89 c8                	mov    %ecx,%eax
c0102049:	c1 f8 1f             	sar    $0x1f,%eax
c010204c:	29 c2                	sub    %eax,%edx
c010204e:	89 d0                	mov    %edx,%eax
c0102050:	c1 e0 02             	shl    $0x2,%eax
c0102053:	01 d0                	add    %edx,%eax
c0102055:	01 c0                	add    %eax,%eax
c0102057:	29 c1                	sub    %eax,%ecx
c0102059:	89 ca                	mov    %ecx,%edx
c010205b:	89 d0                	mov    %edx,%eax
c010205d:	83 c0 30             	add    $0x30,%eax
c0102060:	89 c1                	mov    %eax,%ecx
c0102062:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
c0102068:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010206b:	01 d0                	add    %edx,%eax
c010206d:	88 08                	mov    %cl,(%eax)
					x/=10;
c010206f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102072:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0102077:	89 c8                	mov    %ecx,%eax
c0102079:	f7 ea                	imul   %edx
c010207b:	c1 fa 02             	sar    $0x2,%edx
c010207e:	89 c8                	mov    %ecx,%eax
c0102080:	c1 f8 1f             	sar    $0x1f,%eax
c0102083:	29 c2                	sub    %eax,%edx
c0102085:	89 d0                	mov    %edx,%eax
c0102087:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010208a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
c010208e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102092:	7f a4                	jg     c0102038 <vfprintf+0x1b9>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0102094:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0102098:	eb 21                	jmp    c01020bb <vfprintf+0x23c>
					printer(digits[di]);
c010209a:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
c01020a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01020a3:	01 d0                	add    %edx,%eax
c01020a5:	0f b6 00             	movzbl (%eax),%eax
c01020a8:	0f be c0             	movsbl %al,%eax
c01020ab:	83 ec 0c             	sub    $0xc,%esp
c01020ae:	50                   	push   %eax
c01020af:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b2:	ff d0                	call   *%eax
c01020b4:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c01020b7:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c01020bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01020bf:	79 d9                	jns    c010209a <vfprintf+0x21b>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01020c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01020c5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c01020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020cc:	0f b6 00             	movzbl (%eax),%eax
c01020cf:	3c 63                	cmp    $0x63,%al
c01020d1:	75 1d                	jne    c01020f0 <vfprintf+0x271>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c01020d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01020d6:	0f b6 00             	movzbl (%eax),%eax
c01020d9:	0f be c0             	movsbl %al,%eax
c01020dc:	83 ec 0c             	sub    $0xc,%esp
c01020df:	50                   	push   %eax
c01020e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e3:	ff d0                	call   *%eax
c01020e5:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c01020e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01020ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c01020f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c01020f7:	eb 1b                	jmp    c0102114 <vfprintf+0x295>
		}
		if(type == NONE){
c01020f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01020fd:	75 15                	jne    c0102114 <vfprintf+0x295>
			printer(cur);
c01020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102102:	0f b6 00             	movzbl (%eax),%eax
c0102105:	0f be c0             	movsbl %al,%eax
c0102108:	83 ec 0c             	sub    $0xc,%esp
c010210b:	50                   	push   %eax
c010210c:	8b 45 08             	mov    0x8(%ebp),%eax
c010210f:	ff d0                	call   *%eax
c0102111:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102114:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102118:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010211b:	0f b6 00             	movzbl (%eax),%eax
c010211e:	84 c0                	test   %al,%al
c0102120:	0f 85 81 fd ff ff    	jne    c0101ea7 <vfprintf+0x28>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0102126:	c9                   	leave  
c0102127:	c3                   	ret    

c0102128 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0102128:	55                   	push   %ebp
c0102129:	89 e5                	mov    %esp,%ebp
c010212b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010212e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102131:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(sys_printch, ctl, args);
c0102134:	8b 45 08             	mov    0x8(%ebp),%eax
c0102137:	83 ec 04             	sub    $0x4,%esp
c010213a:	ff 75 f4             	pushl  -0xc(%ebp)
c010213d:	50                   	push   %eax
c010213e:	68 2c 1e 10 c0       	push   $0xc0101e2c
c0102143:	e8 37 fd ff ff       	call   c0101e7f <vfprintf>
c0102148:	83 c4 10             	add    $0x10,%esp
}
c010214b:	c9                   	leave  
c010214c:	c3                   	ret    
