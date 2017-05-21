
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
c0100009:	66 a3 b0 20 13 c0    	mov    %ax,0xc01320b0
	data[1] = (uint32_t)addr;
c010000f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100012:	66 a3 b2 20 13 c0    	mov    %ax,0xc01320b2
	data[2] = ((uint32_t)addr) >> 16;
c0100018:	8b 45 08             	mov    0x8(%ebp),%eax
c010001b:	c1 e8 10             	shr    $0x10,%eax
c010001e:	66 a3 b4 20 13 c0    	mov    %ax,0xc01320b4
	asm volatile("lgdt (%0)" : : "r"(data));
c0100024:	b8 b0 20 13 c0       	mov    $0xc01320b0,%eax
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
c01000ba:	e8 c8 2b 00 00       	call   c0102c87 <vfprintf>
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

c01000dd <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01000dd:	55                   	push   %ebp
c01000de:	89 e5                	mov    %esp,%ebp
c01000e0:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01000e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01000e6:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01000eb:	77 16                	ja     c0100103 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01000ed:	ff 75 10             	pushl  0x10(%ebp)
c01000f0:	68 48 2f 10 c0       	push   $0xc0102f48
c01000f5:	ff 75 0c             	pushl  0xc(%ebp)
c01000f8:	ff 75 08             	pushl  0x8(%ebp)
c01000fb:	e8 9f ff ff ff       	call   c010009f <printk>
c0100100:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0100103:	8b 45 10             	mov    0x10(%ebp),%eax
c0100106:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010010b:	c9                   	leave  
c010010c:	c3                   	ret    

c010010d <get_kcr3>:
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
c010010d:	55                   	push   %ebp
c010010e:	89 e5                	mov    %esp,%ebp
	return &kcr3;
c0100110:	b8 00 00 11 c0       	mov    $0xc0110000,%eax
}
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <get_kpdir>:

PDE* get_kpdir() {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
	return kpdir;
c010011a:	b8 00 10 11 c0       	mov    $0xc0111000,%eax
}
c010011f:	5d                   	pop    %ebp
c0100120:	c3                   	ret    

c0100121 <get_kptable>:

PTE* get_kptable() {
c0100121:	55                   	push   %ebp
c0100122:	89 e5                	mov    %esp,%ebp
	return kptable;
c0100124:	b8 00 20 11 c0       	mov    $0xc0112000,%eax
}
c0100129:	5d                   	pop    %ebp
c010012a:	c3                   	ret    

c010012b <init_page>:

/* Build a page table for the kernel */
void
init_page(void) {
c010012b:	55                   	push   %ebp
c010012c:	89 e5                	mov    %esp,%ebp
c010012e:	83 ec 08             	sub    $0x8,%esp
	page_init();
c0100131:	e8 93 06 00 00       	call   c01007c9 <page_init>
}
c0100136:	c9                   	leave  
c0100137:	c3                   	ret    

c0100138 <set_tss>:

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
c0100138:	55                   	push   %ebp
c0100139:	89 e5                	mov    %esp,%ebp
c010013b:	83 ec 10             	sub    $0x10,%esp
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
c010013e:	c7 05 08 20 13 c0 10 	movl   $0x10,0xc0132008
c0100145:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100148:	c7 45 fc 00 20 13 c0 	movl   $0xc0132000,-0x4(%ebp)
	uint32_t limit = sizeof(TSS) - 1;
c010014f:	c7 45 f8 63 00 00 00 	movl   $0x63,-0x8(%ebp)
	ptr->limit_15_0  = limit & 0xffff;
c0100156:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100159:	89 c2                	mov    %eax,%edx
c010015b:	8b 45 08             	mov    0x8(%ebp),%eax
c010015e:	66 89 10             	mov    %dx,(%eax)
	ptr->base_15_0   = base & 0xffff;
c0100161:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100164:	89 c2                	mov    %eax,%edx
c0100166:	8b 45 08             	mov    0x8(%ebp),%eax
c0100169:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->base_23_16  = (base >> 16) & 0xff;
c010016d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100170:	c1 e8 10             	shr    $0x10,%eax
c0100173:	89 c2                	mov    %eax,%edx
c0100175:	8b 45 08             	mov    0x8(%ebp),%eax
c0100178:	88 50 04             	mov    %dl,0x4(%eax)
	ptr->type = SEG_TSS_32BIT;
c010017b:	8b 45 08             	mov    0x8(%ebp),%eax
c010017e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100182:	83 e2 f0             	and    $0xfffffff0,%edx
c0100185:	83 ca 09             	or     $0x9,%edx
c0100188:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 0;
c010018b:	8b 45 08             	mov    0x8(%ebp),%eax
c010018e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100192:	83 e2 ef             	and    $0xffffffef,%edx
c0100195:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = DPL_USER;
c0100198:	8b 45 08             	mov    0x8(%ebp),%eax
c010019b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010019f:	83 ca 60             	or     $0x60,%edx
c01001a2:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01001a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01001a8:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01001ac:	83 ca 80             	or     $0xffffff80,%edx
c01001af:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = limit >> 16;
c01001b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01001b5:	c1 e8 10             	shr    $0x10,%eax
c01001b8:	83 e0 0f             	and    $0xf,%eax
c01001bb:	89 c2                	mov    %eax,%edx
c01001bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01001c0:	89 d1                	mov    %edx,%ecx
c01001c2:	83 e1 0f             	and    $0xf,%ecx
c01001c5:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001c9:	83 e2 f0             	and    $0xfffffff0,%edx
c01001cc:	09 ca                	or     %ecx,%edx
c01001ce:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c01001d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01001d4:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001d8:	83 e2 ef             	and    $0xffffffef,%edx
c01001db:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c01001de:	8b 45 08             	mov    0x8(%ebp),%eax
c01001e1:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001e5:	83 e2 df             	and    $0xffffffdf,%edx
c01001e8:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c01001eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01001ee:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001f2:	83 ca 40             	or     $0x40,%edx
c01001f5:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 0;
c01001f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01001fb:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01001ff:	83 e2 7f             	and    $0x7f,%edx
c0100202:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = base >> 24;
c0100205:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100208:	c1 e8 18             	shr    $0x18,%eax
c010020b:	89 c2                	mov    %eax,%edx
c010020d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100210:	88 50 07             	mov    %dl,0x7(%eax)
}
c0100213:	c9                   	leave  
c0100214:	c3                   	ret    

c0100215 <set_tss_esp0>:

void set_tss_esp0(uint32_t esp) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
	tss.esp0 = esp;
c0100218:	8b 45 08             	mov    0x8(%ebp),%eax
c010021b:	a3 04 20 13 c0       	mov    %eax,0xc0132004
}
c0100220:	5d                   	pop    %ebp
c0100221:	c3                   	ret    

c0100222 <set_segment>:

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
c0100222:	55                   	push   %ebp
c0100223:	89 e5                	mov    %esp,%ebp
	ptr->limit_15_0  = 0xFFFF;
c0100225:	8b 45 08             	mov    0x8(%ebp),%eax
c0100228:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
	ptr->base_15_0   = 0x0;
c010022d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100230:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
	ptr->base_23_16  = 0x0;
c0100236:	8b 45 08             	mov    0x8(%ebp),%eax
c0100239:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = type;
c010023d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100240:	83 e0 0f             	and    $0xf,%eax
c0100243:	89 c2                	mov    %eax,%edx
c0100245:	8b 45 08             	mov    0x8(%ebp),%eax
c0100248:	89 d1                	mov    %edx,%ecx
c010024a:	83 e1 0f             	and    $0xf,%ecx
c010024d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100251:	83 e2 f0             	and    $0xfffffff0,%edx
c0100254:	09 ca                	or     %ecx,%edx
c0100256:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 1;
c0100259:	8b 45 08             	mov    0x8(%ebp),%eax
c010025c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100260:	83 ca 10             	or     $0x10,%edx
c0100263:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = pl;
c0100266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100269:	83 e0 03             	and    $0x3,%eax
c010026c:	89 c2                	mov    %eax,%edx
c010026e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100271:	83 e2 03             	and    $0x3,%edx
c0100274:	89 d1                	mov    %edx,%ecx
c0100276:	c1 e1 05             	shl    $0x5,%ecx
c0100279:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010027d:	83 e2 9f             	and    $0xffffff9f,%edx
c0100280:	09 ca                	or     %ecx,%edx
c0100282:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100285:	8b 45 08             	mov    0x8(%ebp),%eax
c0100288:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010028c:	83 ca 80             	or     $0xffffff80,%edx
c010028f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = 0xF;
c0100292:	8b 45 08             	mov    0x8(%ebp),%eax
c0100295:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c0100299:	83 ca 0f             	or     $0xf,%edx
c010029c:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
c010029f:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a2:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01002a6:	83 e2 ef             	and    $0xffffffef,%edx
c01002a9:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
c01002ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01002af:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01002b3:	83 e2 df             	and    $0xffffffdf,%edx
c01002b6:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
c01002b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bc:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01002c0:	83 ca 40             	or     $0x40,%edx
c01002c3:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 1;
c01002c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c9:	0f b6 50 06          	movzbl 0x6(%eax),%edx
c01002cd:	83 ca 80             	or     $0xffffff80,%edx
c01002d0:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = 0x0;
c01002d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d6:	c6 40 07 00          	movb   $0x0,0x7(%eax)
}
c01002da:	5d                   	pop    %ebp
c01002db:	c3                   	ret    

c01002dc <init_segment>:
/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
c01002dc:	55                   	push   %ebp
c01002dd:	89 e5                	mov    %esp,%ebp
	memset(gdt, 0, sizeof(gdt));
c01002df:	6a 30                	push   $0x30
c01002e1:	6a 00                	push   $0x0
c01002e3:	68 80 20 13 c0       	push   $0xc0132080
c01002e8:	e8 d7 fd ff ff       	call   c01000c4 <memset>
c01002ed:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c01002f0:	6a 0a                	push   $0xa
c01002f2:	6a 00                	push   $0x0
c01002f4:	68 88 20 13 c0       	push   $0xc0132088
c01002f9:	e8 24 ff ff ff       	call   c0100222 <set_segment>
c01002fe:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c0100301:	6a 02                	push   $0x2
c0100303:	6a 00                	push   $0x0
c0100305:	68 90 20 13 c0       	push   $0xc0132090
c010030a:	e8 13 ff ff ff       	call   c0100222 <set_segment>
c010030f:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c0100312:	6a 0a                	push   $0xa
c0100314:	6a 03                	push   $0x3
c0100316:	68 98 20 13 c0       	push   $0xc0132098
c010031b:	e8 02 ff ff ff       	call   c0100222 <set_segment>
c0100320:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c0100323:	6a 02                	push   $0x2
c0100325:	6a 03                	push   $0x3
c0100327:	68 a0 20 13 c0       	push   $0xc01320a0
c010032c:	e8 f1 fe ff ff       	call   c0100222 <set_segment>
c0100331:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100334:	6a 30                	push   $0x30
c0100336:	68 80 20 13 c0       	push   $0xc0132080
c010033b:	e8 c0 fc ff ff       	call   c0100000 <write_gdtr>
c0100340:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100343:	68 a8 20 13 c0       	push   $0xc01320a8
c0100348:	e8 eb fd ff ff       	call   c0100138 <set_tss>
c010034d:	83 c4 04             	add    $0x4,%esp
	write_tr( SELECTOR_USER(SEG_TSS) );
c0100350:	6a 2b                	push   $0x2b
c0100352:	e8 d7 fc ff ff       	call   c010002e <write_tr>
c0100357:	83 c4 04             	add    $0x4,%esp
}
c010035a:	c9                   	leave  
c010035b:	c3                   	ret    

c010035c <enter_pcb>:


void enter_pcb(PCB* pcb)
{
c010035c:	55                   	push   %ebp
c010035d:	89 e5                	mov    %esp,%ebp
c010035f:	83 ec 18             	sub    $0x18,%esp
	lcr3(PADDR(pcb->pgdir));
c0100362:	8b 45 08             	mov    0x8(%ebp),%eax
c0100365:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c010036b:	83 ec 04             	sub    $0x4,%esp
c010036e:	50                   	push   %eax
c010036f:	6a 71                	push   $0x71
c0100371:	68 6b 2f 10 c0       	push   $0xc0102f6b
c0100376:	e8 62 fd ff ff       	call   c01000dd <_paddr>
c010037b:	83 c4 10             	add    $0x10,%esp
c010037e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0100381:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100384:	0f 22 d8             	mov    %eax,%cr3
	//printk("2\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c0100387:	8b 45 08             	mov    0x8(%ebp),%eax
c010038a:	05 20 40 00 00       	add    $0x4020,%eax
c010038f:	83 ec 0c             	sub    $0xc,%esp
c0100392:	50                   	push   %eax
c0100393:	e8 7d fe ff ff       	call   c0100215 <set_tss_esp0>
c0100398:	83 c4 10             	add    $0x10,%esp
	//printk("3\n");
	struct TrapFrame *tf = pcb->tf;
c010039b:	8b 45 08             	mov    0x8(%ebp),%eax
c010039e:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01003a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//disable_interrupt();
	//asm volatile("cli");
	asm volatile("mov %0, %%ds" : : "r"(tf->ds));
c01003a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003aa:	8b 40 2c             	mov    0x2c(%eax),%eax
c01003ad:	8e d8                	mov    %eax,%ds
	//printk("0\n");
	asm volatile("mov %0, %%es" : : "r"(tf->es));
c01003af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b2:	8b 40 28             	mov    0x28(%eax),%eax
c01003b5:	8e c0                	mov    %eax,%es
	//printk("0\n");
	asm volatile("mov %0, %%fs" : : "r"(tf->fs));
c01003b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ba:	8b 40 24             	mov    0x24(%eax),%eax
c01003bd:	8e e0                	mov    %eax,%fs
	//printk("0\n");
	asm volatile("mov %0, %%gs" : : "r"(tf->gs));
c01003bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c2:	8b 40 20             	mov    0x20(%eax),%eax
c01003c5:	8e e8                	mov    %eax,%gs
	//printk("0\n");
	asm volatile("pushl %0" : : "r"((uint32_t)tf->ss));
c01003c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ca:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01003ce:	0f b7 c0             	movzwl %ax,%eax
c01003d1:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->esp));
c01003d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d5:	8b 40 44             	mov    0x44(%eax),%eax
c01003d8:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eflags));
c01003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003dc:	8b 40 40             	mov    0x40(%eax),%eax
c01003df:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"((uint32_t)tf->cs));
c01003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01003e7:	0f b7 c0             	movzwl %ax,%eax
c01003ea:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eip));
c01003eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ee:	8b 40 38             	mov    0x38(%eax),%eax
c01003f1:	50                   	push   %eax
	asm volatile("iret"); 
c01003f2:	cf                   	iret   
}
c01003f3:	c9                   	leave  
c01003f4:	c3                   	ret    

c01003f5 <scheduler_switch>:
void switch_proc();
extern PCB* current;
void scheduler_switch(PCB* pcb){
c01003f5:	55                   	push   %ebp
c01003f6:	89 e5                	mov    %esp,%ebp
c01003f8:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	current = pcb;
c01003fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01003fe:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
	//printk("A\n");
	lcr3(PADDR(pcb->pgdir));
c0100403:	8b 45 08             	mov    0x8(%ebp),%eax
c0100406:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8d 00 00 00       	push   $0x8d
c0100415:	68 6b 2f 10 c0       	push   $0xc0102f6b
c010041a:	e8 be fc ff ff       	call   c01000dd <_paddr>
c010041f:	83 c4 10             	add    $0x10,%esp
c0100422:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100428:	0f 22 d8             	mov    %eax,%cr3
	//printk("B\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c010042b:	8b 45 08             	mov    0x8(%ebp),%eax
c010042e:	05 20 40 00 00       	add    $0x4020,%eax
c0100433:	83 ec 0c             	sub    $0xc,%esp
c0100436:	50                   	push   %eax
c0100437:	e8 d9 fd ff ff       	call   c0100215 <set_tss_esp0>
c010043c:	83 c4 10             	add    $0x10,%esp
	//printk("--PID %d\n", pcb->pid);
	//printk("--NOW ESP = %x\n", pcb->tf);
	//printk("--TT %x\n", pcb->tt);
	asm volatile("mov %0, %%esp" : : "m"(pcb->tf));
c010043f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100442:	8b a0 58 40 00 00    	mov    0x4058(%eax),%esp
	asm volatile("jmp %0" : : "r"(switch_proc));
c0100448:	b8 e7 2b 10 c0       	mov    $0xc0102be7,%eax
c010044d:	ff e0                	jmp    *%eax

}
c010044f:	c9                   	leave  
c0100450:	c3                   	ret    

c0100451 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
c0100451:	55                   	push   %ebp
c0100452:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100454:	8b 45 08             	mov    0x8(%ebp),%eax
c0100457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c010045d:	5d                   	pop    %ebp
c010045e:	c3                   	ret    

c010045f <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
c010045f:	55                   	push   %ebp
c0100460:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100462:	8b 45 08             	mov    0x8(%ebp),%eax
c0100465:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c010046b:	5d                   	pop    %ebp
c010046c:	c3                   	ret    

c010046d <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
c010046d:	55                   	push   %ebp
c010046e:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100470:	8b 45 08             	mov    0x8(%ebp),%eax
c0100473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c0100479:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047c:	c1 e8 0c             	shr    $0xc,%eax
c010047f:	25 ff ff 0f 00       	and    $0xfffff,%eax
c0100484:	89 c2                	mov    %eax,%edx
c0100486:	8b 45 08             	mov    0x8(%ebp),%eax
c0100489:	89 d1                	mov    %edx,%ecx
c010048b:	c1 e1 0c             	shl    $0xc,%ecx
c010048e:	8b 10                	mov    (%eax),%edx
c0100490:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c0100496:	09 ca                	or     %ecx,%edx
c0100498:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c010049a:	8b 45 08             	mov    0x8(%ebp),%eax
c010049d:	0f b6 10             	movzbl (%eax),%edx
c01004a0:	83 ca 01             	or     $0x1,%edx
c01004a3:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01004a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a8:	0f b6 10             	movzbl (%eax),%edx
c01004ab:	83 ca 02             	or     $0x2,%edx
c01004ae:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c01004b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b3:	0f b6 10             	movzbl (%eax),%edx
c01004b6:	83 ca 04             	or     $0x4,%edx
c01004b9:	88 10                	mov    %dl,(%eax)
}
c01004bb:	5d                   	pop    %ebp
c01004bc:	c3                   	ret    

c01004bd <make_pte>:

void
make_pte(PTE *p, void *addr) {
c01004bd:	55                   	push   %ebp
c01004be:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01004c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c01004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004cc:	c1 e8 0c             	shr    $0xc,%eax
c01004cf:	25 ff ff 0f 00       	and    $0xfffff,%eax
c01004d4:	89 c2                	mov    %eax,%edx
c01004d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004d9:	89 d1                	mov    %edx,%ecx
c01004db:	c1 e1 0c             	shl    $0xc,%ecx
c01004de:	8b 10                	mov    (%eax),%edx
c01004e0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01004e6:	09 ca                	or     %ecx,%edx
c01004e8:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c01004ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ed:	0f b6 10             	movzbl (%eax),%edx
c01004f0:	83 ca 01             	or     $0x1,%edx
c01004f3:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01004f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01004f8:	0f b6 10             	movzbl (%eax),%edx
c01004fb:	83 ca 02             	or     $0x2,%edx
c01004fe:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c0100500:	8b 45 08             	mov    0x8(%ebp),%eax
c0100503:	0f b6 10             	movzbl (%eax),%edx
c0100506:	83 ca 04             	or     $0x4,%edx
c0100509:	88 10                	mov    %dl,(%eax)
}
c010050b:	5d                   	pop    %ebp
c010050c:	c3                   	ret    

c010050d <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c010050d:	55                   	push   %ebp
c010050e:	89 e5                	mov    %esp,%ebp
c0100510:	83 ec 10             	sub    $0x10,%esp
c0100513:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010051a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010051d:	89 c2                	mov    %eax,%edx
c010051f:	ec                   	in     (%dx),%al
c0100520:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0100523:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0100527:	0f b6 c0             	movzbl %al,%eax
c010052a:	83 e0 20             	and    $0x20,%eax
c010052d:	85 c0                	test   %eax,%eax
c010052f:	0f 95 c0             	setne  %al
c0100532:	0f b6 c0             	movzbl %al,%eax
}
c0100535:	c9                   	leave  
c0100536:	c3                   	ret    

c0100537 <serial_printc>:

static inline
void serial_printc(char ch) {
c0100537:	55                   	push   %ebp
c0100538:	89 e5                	mov    %esp,%ebp
c010053a:	83 ec 14             	sub    $0x14,%esp
c010053d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100540:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0100543:	90                   	nop
c0100544:	e8 c4 ff ff ff       	call   c010050d <serial_idle>
c0100549:	85 c0                	test   %eax,%eax
c010054b:	74 f7                	je     c0100544 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010054d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100551:	0f b6 c0             	movzbl %al,%eax
c0100554:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010055b:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010055e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100562:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100565:	ee                   	out    %al,(%dx)
}
c0100566:	c9                   	leave  
c0100567:	c3                   	ret    

c0100568 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0100568:	55                   	push   %ebp
c0100569:	89 e5                	mov    %esp,%ebp
c010056b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010056e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0100574:	8b 45 08             	mov    0x8(%ebp),%eax
c0100577:	83 ec 04             	sub    $0x4,%esp
c010057a:	ff 75 f4             	pushl  -0xc(%ebp)
c010057d:	50                   	push   %eax
c010057e:	68 37 05 10 c0       	push   $0xc0100537
c0100583:	e8 ff 26 00 00       	call   c0102c87 <vfprintf>
c0100588:	83 c4 10             	add    $0x10,%esp
}
c010058b:	c9                   	leave  
c010058c:	c3                   	ret    

c010058d <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c010058d:	55                   	push   %ebp
c010058e:	89 e5                	mov    %esp,%ebp
c0100590:	57                   	push   %edi
c0100591:	56                   	push   %esi
c0100592:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0100593:	8b 45 10             	mov    0x10(%ebp),%eax
c0100596:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100599:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010059c:	89 c1                	mov    %eax,%ecx
c010059e:	89 d6                	mov    %edx,%esi
c01005a0:	89 df                	mov    %ebx,%edi
c01005a2:	fc                   	cld    
c01005a3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c01005a5:	5b                   	pop    %ebx
c01005a6:	5e                   	pop    %esi
c01005a7:	5f                   	pop    %edi
c01005a8:	5d                   	pop    %ebp
c01005a9:	c3                   	ret    

c01005aa <memset>:

static inline void memset(void* dst, uint32_t src, int len){
c01005aa:	55                   	push   %ebp
c01005ab:	89 e5                	mov    %esp,%ebp
c01005ad:	57                   	push   %edi
c01005ae:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c01005af:	8b 55 10             	mov    0x10(%ebp),%edx
c01005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01005b8:	89 d1                	mov    %edx,%ecx
c01005ba:	89 df                	mov    %ebx,%edi
c01005bc:	fc                   	cld    
c01005bd:	f3 ab                	rep stos %eax,%es:(%edi)
}
c01005bf:	5b                   	pop    %ebx
c01005c0:	5f                   	pop    %edi
c01005c1:	5d                   	pop    %ebp
c01005c2:	c3                   	ret    

c01005c3 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01005c3:	55                   	push   %ebp
c01005c4:	89 e5                	mov    %esp,%ebp
c01005c6:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01005c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005cc:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01005d1:	77 16                	ja     c01005e9 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01005d3:	ff 75 10             	pushl  0x10(%ebp)
c01005d6:	68 84 2f 10 c0       	push   $0xc0102f84
c01005db:	ff 75 0c             	pushl  0xc(%ebp)
c01005de:	ff 75 08             	pushl  0x8(%ebp)
c01005e1:	e8 82 ff ff ff       	call   c0100568 <printk>
c01005e6:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01005e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005ec:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01005f1:	c9                   	leave  
c01005f2:	c3                   	ret    

c01005f3 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c01005f3:	55                   	push   %ebp
c01005f4:	89 e5                	mov    %esp,%ebp
c01005f6:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01005f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005fc:	c1 e8 0c             	shr    $0xc,%eax
c01005ff:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0100604:	76 13                	jbe    c0100619 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0100606:	83 ec 08             	sub    $0x8,%esp
c0100609:	ff 75 10             	pushl  0x10(%ebp)
c010060c:	68 a8 2f 10 c0       	push   $0xc0102fa8
c0100611:	e8 52 ff ff ff       	call   c0100568 <printk>
c0100616:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0100619:	8b 45 10             	mov    0x10(%ebp),%eax
c010061c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0100621:	c9                   	leave  
c0100622:	c3                   	ret    

c0100623 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0100623:	55                   	push   %ebp
c0100624:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0100626:	8b 45 08             	mov    0x8(%ebp),%eax
c0100629:	ba 00 47 17 c0       	mov    $0xc0174700,%edx
c010062e:	29 d0                	sub    %edx,%eax
c0100630:	c1 f8 03             	sar    $0x3,%eax
c0100633:	c1 e0 0c             	shl    $0xc,%eax
}
c0100636:	5d                   	pop    %ebp
c0100637:	c3                   	ret    

c0100638 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0100638:	55                   	push   %ebp
c0100639:	89 e5                	mov    %esp,%ebp
c010063b:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010063e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100641:	c1 e8 0c             	shr    $0xc,%eax
c0100644:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0100649:	76 10                	jbe    c010065b <pa2page+0x23>
		printk("pa2page called with invalid pa");
c010064b:	83 ec 0c             	sub    $0xc,%esp
c010064e:	68 cc 2f 10 c0       	push   $0xc0102fcc
c0100653:	e8 10 ff ff ff       	call   c0100568 <printk>
c0100658:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c010065b:	8b 45 08             	mov    0x8(%ebp),%eax
c010065e:	c1 e8 0c             	shr    $0xc,%eax
c0100661:	c1 e0 03             	shl    $0x3,%eax
c0100664:	05 00 47 17 c0       	add    $0xc0174700,%eax
}
c0100669:	c9                   	leave  
c010066a:	c3                   	ret    

c010066b <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c010066b:	55                   	push   %ebp
c010066c:	89 e5                	mov    %esp,%ebp
c010066e:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0100671:	ff 75 08             	pushl  0x8(%ebp)
c0100674:	e8 aa ff ff ff       	call   c0100623 <page2pa>
c0100679:	83 c4 04             	add    $0x4,%esp
c010067c:	83 ec 04             	sub    $0x4,%esp
c010067f:	50                   	push   %eax
c0100680:	6a 52                	push   $0x52
c0100682:	68 eb 2f 10 c0       	push   $0xc0102feb
c0100687:	e8 67 ff ff ff       	call   c01005f3 <_kaddr>
c010068c:	83 c4 10             	add    $0x10,%esp
}
c010068f:	c9                   	leave  
c0100690:	c3                   	ret    

c0100691 <mm_alloc>:
// The 'pages' array has one 'struct PageInfo' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------

void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
c0100691:	55                   	push   %ebp
c0100692:	89 e5                	mov    %esp,%ebp
c0100694:	83 ec 28             	sub    $0x28,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
c0100697:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01006a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
c01006a8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c01006af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01006b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01006b5:	01 c2                	add    %eax,%edx
c01006b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006ba:	01 d0                	add    %edx,%eax
c01006bc:	83 e8 01             	sub    $0x1,%eax
c01006bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01006c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c5:	ba 00 00 00 00       	mov    $0x0,%edx
c01006ca:	f7 75 e8             	divl   -0x18(%ebp)
c01006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d0:	29 d0                	sub    %edx,%eax
c01006d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01006d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01006db:	eb 2b                	jmp    c0100708 <mm_alloc+0x77>
    p = page_alloc(0);
c01006dd:	83 ec 0c             	sub    $0xc,%esp
c01006e0:	6a 00                	push   $0x0
c01006e2:	e8 9c 01 00 00       	call   c0100883 <page_alloc>
c01006e7:	83 c4 10             	add    $0x10,%esp
c01006ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
c01006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006f0:	6a 07                	push   $0x7
c01006f2:	50                   	push   %eax
c01006f3:	ff 75 dc             	pushl  -0x24(%ebp)
c01006f6:	ff 75 08             	pushl  0x8(%ebp)
c01006f9:	e8 94 03 00 00       	call   c0100a92 <page_insert>
c01006fe:	83 c4 10             	add    $0x10,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c0100701:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0100708:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010070e:	72 cd                	jb     c01006dd <mm_alloc+0x4c>
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}
c0100710:	c9                   	leave  
c0100711:	c3                   	ret    

c0100712 <init_kern_pgdir>:

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
c0100712:	55                   	push   %ebp
c0100713:	89 e5                	mov    %esp,%ebp
c0100715:	53                   	push   %ebx
c0100716:	83 ec 24             	sub    $0x24,%esp
	int pdx;
	pde_t *pgdir = kpgdir;
c0100719:	c7 45 e8 00 40 13 c0 	movl   $0xc0134000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c0100720:	c7 45 f0 00 50 13 c0 	movl   $0xc0135000,-0x10(%ebp)

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c0100727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010072e:	eb 3a                	jmp    c010076a <init_kern_pgdir+0x58>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	05 00 03 00 00       	add    $0x300,%eax
c0100738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010073f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100742:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c0100745:	83 ec 04             	sub    $0x4,%esp
c0100748:	ff 75 f0             	pushl  -0x10(%ebp)
c010074b:	6a 37                	push   $0x37
c010074d:	68 01 30 10 c0       	push   $0xc0103001
c0100752:	e8 6c fe ff ff       	call   c01005c3 <_paddr>
c0100757:	83 c4 10             	add    $0x10,%esp
c010075a:	83 c8 03             	or     $0x3,%eax
c010075d:	89 03                	mov    %eax,(%ebx)
		pgtable += NPTENTRIES;
c010075f:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c0100766:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010076a:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c010076e:	7e c0                	jle    c0100730 <init_kern_pgdir+0x1e>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
c0100770:	c7 45 ec 00 f0 ff 07 	movl   $0x7fff000,-0x14(%ebp)
	pgtable--;
c0100777:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c010077b:	eb 18                	jmp    c0100795 <init_kern_pgdir+0x83>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
c010077d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100780:	83 c8 07             	or     $0x7,%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100788:	89 10                	mov    %edx,(%eax)
		pgtable --;
c010078a:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c010078e:	81 6d ec 00 10 00 00 	subl   $0x1000,-0x14(%ebp)
c0100795:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100799:	79 e2                	jns    c010077d <init_kern_pgdir+0x6b>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
c010079b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010079e:	a3 c0 46 17 c0       	mov    %eax,0xc01746c0
	lcr3(PADDR(kern_pgdir));	
c01007a3:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c01007a8:	83 ec 04             	sub    $0x4,%esp
c01007ab:	50                   	push   %eax
c01007ac:	6a 44                	push   $0x44
c01007ae:	68 01 30 10 c0       	push   $0xc0103001
c01007b3:	e8 0b fe ff ff       	call   c01005c3 <_paddr>
c01007b8:	83 c4 10             	add    $0x10,%esp
c01007bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01007be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007c1:	0f 22 d8             	mov    %eax,%cr3
}
c01007c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01007c7:	c9                   	leave  
c01007c8:	c3                   	ret    

c01007c9 <page_init>:
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
c01007c9:	55                   	push   %ebp
c01007ca:	89 e5                	mov    %esp,%ebp
c01007cc:	83 ec 18             	sub    $0x18,%esp
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	
c01007cf:	e8 3e ff ff ff       	call   c0100712 <init_kern_pgdir>

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
c01007d4:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	for (i = 0; i < base; i++) {
c01007db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01007e2:	eb 11                	jmp    c01007f5 <page_init+0x2c>
		pages[i].pp_ref = 1;
c01007e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e7:	66 c7 04 c5 04 47 17 	movw   $0x1,-0x3fe8b8fc(,%eax,8)
c01007ee:	c0 01 00 
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
c01007f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01007f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01007fb:	77 e7                	ja     c01007e4 <page_init+0x1b>
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c01007fd:	c7 45 f4 ff 7f 00 00 	movl   $0x7fff,-0xc(%ebp)
c0100804:	eb 31                	jmp    c0100837 <page_init+0x6e>
		pages[i].pp_ref = 0;
c0100806:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100809:	66 c7 04 c5 04 47 17 	movw   $0x0,-0x3fe8b8fc(,%eax,8)
c0100810:	c0 00 00 
		pages[i].pp_link = page_free_list;
c0100813:	8b 15 00 30 13 c0    	mov    0xc0133000,%edx
c0100819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081c:	89 14 c5 00 47 17 c0 	mov    %edx,-0x3fe8b900(,%eax,8)
		page_free_list = &pages[i];
c0100823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100826:	c1 e0 03             	shl    $0x3,%eax
c0100829:	05 00 47 17 c0       	add    $0xc0174700,%eax
c010082e:	a3 00 30 13 c0       	mov    %eax,0xc0133000
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c0100833:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100837:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010083a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010083d:	76 c7                	jbe    c0100806 <page_init+0x3d>
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
c010083f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
c0100846:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100849:	05 ff f9 00 00       	add    $0xf9ff,%eax
c010084e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0100851:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100854:	ba 00 00 00 00       	mov    $0x0,%edx
c0100859:	f7 75 ec             	divl   -0x14(%ebp)
c010085c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010085f:	29 d0                	sub    %edx,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0100868:	83 ec 0c             	sub    $0xc,%esp
c010086b:	6a 03                	push   $0x3
c010086d:	68 00 00 0a 00       	push   $0xa0000
c0100872:	52                   	push   %edx
c0100873:	68 00 00 0a 00       	push   $0xa0000
c0100878:	50                   	push   %eax
c0100879:	e8 b1 01 00 00       	call   c0100a2f <boot_map_region>
c010087e:	83 c4 20             	add    $0x20,%esp
}
c0100881:	c9                   	leave  
c0100882:	c3                   	ret    

c0100883 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
c0100883:	55                   	push   %ebp
c0100884:	89 e5                	mov    %esp,%ebp
c0100886:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	struct PageInfo *p = page_free_list;
c0100889:	a1 00 30 13 c0       	mov    0xc0133000,%eax
c010088e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL){
c0100891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100895:	75 17                	jne    c01008ae <page_alloc+0x2b>
		printk("Fatal error: page not available\n");
c0100897:	83 ec 0c             	sub    $0xc,%esp
c010089a:	68 1c 30 10 c0       	push   $0xc010301c
c010089f:	e8 c4 fc ff ff       	call   c0100568 <printk>
c01008a4:	83 c4 10             	add    $0x10,%esp
		return NULL;
c01008a7:	b8 00 00 00 00       	mov    $0x0,%eax
c01008ac:	eb 43                	jmp    c01008f1 <page_alloc+0x6e>
	}
	if (alloc_flags & ALLOC_ZERO) {
c01008ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01008b1:	83 e0 01             	and    $0x1,%eax
c01008b4:	85 c0                	test   %eax,%eax
c01008b6:	74 21                	je     c01008d9 <page_alloc+0x56>
		memset(page2kva(p), 0, PGSIZE);
c01008b8:	83 ec 0c             	sub    $0xc,%esp
c01008bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01008be:	e8 a8 fd ff ff       	call   c010066b <page2kva>
c01008c3:	83 c4 10             	add    $0x10,%esp
c01008c6:	83 ec 04             	sub    $0x4,%esp
c01008c9:	68 00 10 00 00       	push   $0x1000
c01008ce:	6a 00                	push   $0x0
c01008d0:	50                   	push   %eax
c01008d1:	e8 d4 fc ff ff       	call   c01005aa <memset>
c01008d6:	83 c4 10             	add    $0x10,%esp
	}
	page_free_list = page_free_list -> pp_link;
c01008d9:	a1 00 30 13 c0       	mov    0xc0133000,%eax
c01008de:	8b 00                	mov    (%eax),%eax
c01008e0:	a3 00 30 13 c0       	mov    %eax,0xc0133000
	p -> pp_link = NULL;
c01008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return p;
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01008f1:	c9                   	leave  
c01008f2:	c3                   	ret    

c01008f3 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
c01008f3:	55                   	push   %ebp
c01008f4:	89 e5                	mov    %esp,%ebp

	pp->pp_link = page_free_list;
c01008f6:	8b 15 00 30 13 c0    	mov    0xc0133000,%edx
c01008fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01008ff:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c0100901:	8b 45 08             	mov    0x8(%ebp),%eax
c0100904:	a3 00 30 13 c0       	mov    %eax,0xc0133000
}
c0100909:	5d                   	pop    %ebp
c010090a:	c3                   	ret    

c010090b <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
c010090b:	55                   	push   %ebp
c010090c:	89 e5                	mov    %esp,%ebp
	if (--pp->pp_ref == 0)
c010090e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100911:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100915:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100918:	8b 45 08             	mov    0x8(%ebp),%eax
c010091b:	66 89 50 04          	mov    %dx,0x4(%eax)
c010091f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100922:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100926:	66 85 c0             	test   %ax,%ax
c0100929:	75 0b                	jne    c0100936 <page_decref+0x2b>
		page_free(pp);
c010092b:	ff 75 08             	pushl  0x8(%ebp)
c010092e:	e8 c0 ff ff ff       	call   c01008f3 <page_free>
c0100933:	83 c4 04             	add    $0x4,%esp
}
c0100936:	c9                   	leave  
c0100937:	c3                   	ret    

c0100938 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
c0100938:	55                   	push   %ebp
c0100939:	89 e5                	mov    %esp,%ebp
c010093b:	53                   	push   %ebx
c010093c:	83 ec 14             	sub    $0x14,%esp
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);
c010093f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100942:	c1 e8 16             	shr    $0x16,%eax
c0100945:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (pgdir[pdx] & PTE_P) {
c0100948:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010094b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100952:	8b 45 08             	mov    0x8(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	8b 00                	mov    (%eax),%eax
c0100959:	83 e0 01             	and    $0x1,%eax
c010095c:	85 c0                	test   %eax,%eax
c010095e:	74 31                	je     c0100991 <pgdir_walk+0x59>
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100960:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100963:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010096a:	8b 45 08             	mov    0x8(%ebp),%eax
c010096d:	01 d0                	add    %edx,%eax
c010096f:	8b 00                	mov    (%eax),%eax
c0100971:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100976:	83 ec 04             	sub    $0x4,%esp
c0100979:	50                   	push   %eax
c010097a:	68 bd 00 00 00       	push   $0xbd
c010097f:	68 01 30 10 c0       	push   $0xc0103001
c0100984:	e8 6a fc ff ff       	call   c01005f3 <_kaddr>
c0100989:	83 c4 10             	add    $0x10,%esp
c010098c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010098f:	eb 7c                	jmp    c0100a0d <pgdir_walk+0xd5>
	}
	else {
		if (create == false) return NULL;
c0100991:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100995:	75 0a                	jne    c01009a1 <pgdir_walk+0x69>
c0100997:	b8 00 00 00 00       	mov    $0x0,%eax
c010099c:	e9 89 00 00 00       	jmp    c0100a2a <pgdir_walk+0xf2>

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
c01009a1:	83 ec 0c             	sub    $0xc,%esp
c01009a4:	6a 01                	push   $0x1
c01009a6:	e8 d8 fe ff ff       	call   c0100883 <page_alloc>
c01009ab:	83 c4 10             	add    $0x10,%esp
c01009ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p == NULL) return NULL;
c01009b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01009b5:	75 07                	jne    c01009be <pgdir_walk+0x86>
c01009b7:	b8 00 00 00 00       	mov    $0x0,%eax
c01009bc:	eb 6c                	jmp    c0100a2a <pgdir_walk+0xf2>

		pgtable = page2kva(p);
c01009be:	83 ec 0c             	sub    $0xc,%esp
c01009c1:	ff 75 ec             	pushl  -0x14(%ebp)
c01009c4:	e8 a2 fc ff ff       	call   c010066b <page2kva>
c01009c9:	83 c4 10             	add    $0x10,%esp
c01009cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p -> pp_ref ++;
c01009cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009d2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01009d6:	8d 50 01             	lea    0x1(%eax),%edx
c01009d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009dc:	66 89 50 04          	mov    %dx,0x4(%eax)

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
c01009e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ed:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c01009f0:	83 ec 04             	sub    $0x4,%esp
c01009f3:	ff 75 f4             	pushl  -0xc(%ebp)
c01009f6:	68 c8 00 00 00       	push   $0xc8
c01009fb:	68 01 30 10 c0       	push   $0xc0103001
c0100a00:	e8 be fb ff ff       	call   c01005c3 <_paddr>
c0100a05:	83 c4 10             	add    $0x10,%esp
c0100a08:	83 c8 07             	or     $0x7,%eax
c0100a0b:	89 03                	mov    %eax,(%ebx)
	}
	int ptx = PTX(va);
c0100a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a10:	c1 e8 0c             	shr    $0xc,%eax
c0100a13:	25 ff 03 00 00       	and    $0x3ff,%eax
c0100a18:	89 45 e8             	mov    %eax,-0x18(%ebp)
	return &pgtable[ptx];
c0100a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a28:	01 d0                	add    %edx,%eax
}
c0100a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a2d:	c9                   	leave  
c0100a2e:	c3                   	ret    

c0100a2f <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
c0100a2f:	55                   	push   %ebp
c0100a30:	89 e5                	mov    %esp,%ebp
c0100a32:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	int i;
	int n = size / PGSIZE;
c0100a35:	8b 45 10             	mov    0x10(%ebp),%eax
c0100a38:	c1 e8 0c             	shr    $0xc,%eax
c0100a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	for (i = 0; i < n; i ++) {
c0100a3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a45:	eb 41                	jmp    c0100a88 <boot_map_region+0x59>
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
c0100a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a4a:	83 ec 04             	sub    $0x4,%esp
c0100a4d:	6a 01                	push   $0x1
c0100a4f:	50                   	push   %eax
c0100a50:	ff 75 08             	pushl  0x8(%ebp)
c0100a53:	e8 e0 fe ff ff       	call   c0100938 <pgdir_walk>
c0100a58:	83 c4 10             	add    $0x10,%esp
c0100a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pte == NULL) return;
c0100a5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100a62:	75 02                	jne    c0100a66 <boot_map_region+0x37>
c0100a64:	eb 2a                	jmp    c0100a90 <boot_map_region+0x61>

		*pte = pa | perm | PTE_P;
c0100a66:	8b 45 18             	mov    0x18(%ebp),%eax
c0100a69:	0b 45 14             	or     0x14(%ebp),%eax
c0100a6c:	83 c8 01             	or     $0x1,%eax
c0100a6f:	89 c2                	mov    %eax,%edx
c0100a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a74:	89 10                	mov    %edx,(%eax)

		va += PGSIZE;
c0100a76:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
		pa += PGSIZE;
c0100a7d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
c0100a84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100a8e:	7c b7                	jl     c0100a47 <boot_map_region+0x18>
		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}
c0100a90:	c9                   	leave  
c0100a91:	c3                   	ret    

c0100a92 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
c0100a92:	55                   	push   %ebp
c0100a93:	89 e5                	mov    %esp,%ebp
c0100a95:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, true);
c0100a98:	83 ec 04             	sub    $0x4,%esp
c0100a9b:	6a 01                	push   $0x1
c0100a9d:	ff 75 10             	pushl  0x10(%ebp)
c0100aa0:	ff 75 08             	pushl  0x8(%ebp)
c0100aa3:	e8 90 fe ff ff       	call   c0100938 <pgdir_walk>
c0100aa8:	83 c4 10             	add    $0x10,%esp
c0100aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) {
c0100aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ab2:	75 07                	jne    c0100abb <page_insert+0x29>
		return -1;
c0100ab4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100ab9:	eb 75                	jmp    c0100b30 <page_insert+0x9e>
	}

	physaddr_t pa = page2pa(pp);
c0100abb:	83 ec 0c             	sub    $0xc,%esp
c0100abe:	ff 75 0c             	pushl  0xc(%ebp)
c0100ac1:	e8 5d fb ff ff       	call   c0100623 <page2pa>
c0100ac6:	83 c4 10             	add    $0x10,%esp
c0100ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (*pte & PTE_P) {
c0100acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100acf:	8b 00                	mov    (%eax),%eax
c0100ad1:	83 e0 01             	and    $0x1,%eax
c0100ad4:	85 c0                	test   %eax,%eax
c0100ad6:	74 32                	je     c0100b0a <page_insert+0x78>
		if (PTE_ADDR(*pte) == pa) {
c0100ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100adb:	8b 00                	mov    (%eax),%eax
c0100add:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100ae2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100ae5:	75 12                	jne    c0100af9 <page_insert+0x67>
			*pte = pa | perm | PTE_P;
c0100ae7:	8b 45 14             	mov    0x14(%ebp),%eax
c0100aea:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100aed:	83 c8 01             	or     $0x1,%eax
c0100af0:	89 c2                	mov    %eax,%edx
c0100af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af5:	89 10                	mov    %edx,(%eax)
c0100af7:	eb 11                	jmp    c0100b0a <page_insert+0x78>
		}
		else {
			page_remove(pgdir, va);
c0100af9:	83 ec 08             	sub    $0x8,%esp
c0100afc:	ff 75 10             	pushl  0x10(%ebp)
c0100aff:	ff 75 08             	pushl  0x8(%ebp)
c0100b02:	e8 77 02 00 00       	call   c0100d7e <page_remove>
c0100b07:	83 c4 10             	add    $0x10,%esp
		}
	}
	*pte = pa | perm | PTE_P;
c0100b0a:	8b 45 14             	mov    0x14(%ebp),%eax
c0100b0d:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100b10:	83 c8 01             	or     $0x1,%eax
c0100b13:	89 c2                	mov    %eax,%edx
c0100b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b18:	89 10                	mov    %edx,(%eax)
	pp -> pp_ref ++;
c0100b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b1d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100b21:	8d 50 01             	lea    0x1(%eax),%edx
c0100b24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b27:	66 89 50 04          	mov    %dx,0x4(%eax)
	return 0;
c0100b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b30:	c9                   	leave  
c0100b31:	c3                   	ret    

c0100b32 <copy_pgdir>:
// Return NULL if there is no page mapped at va.
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
void copy_pgdir(pde_t *dst_dir, pde_t *src_dir)
{
c0100b32:	55                   	push   %ebp
c0100b33:	89 e5                	mov    %esp,%ebp
c0100b35:	53                   	push   %ebx
c0100b36:	83 ec 24             	sub    $0x24,%esp
	struct PageInfo *pp;
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100b39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b40:	e9 d8 01 00 00       	jmp    c0100d1d <copy_pgdir+0x1eb>
		if (src_dir[pdx] & PTE_P) {	
c0100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b52:	01 d0                	add    %edx,%eax
c0100b54:	8b 00                	mov    (%eax),%eax
c0100b56:	83 e0 01             	and    $0x1,%eax
c0100b59:	85 c0                	test   %eax,%eax
c0100b5b:	0f 84 b8 01 00 00    	je     c0100d19 <copy_pgdir+0x1e7>
			if (dst_dir[pdx] & PTE_P) continue;
c0100b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6e:	01 d0                	add    %edx,%eax
c0100b70:	8b 00                	mov    (%eax),%eax
c0100b72:	83 e0 01             	and    $0x1,%eax
c0100b75:	85 c0                	test   %eax,%eax
c0100b77:	74 05                	je     c0100b7e <copy_pgdir+0x4c>
c0100b79:	e9 9b 01 00 00       	jmp    c0100d19 <copy_pgdir+0x1e7>
			pte_t *src_table = KADDR(PTE_ADDR(src_dir[pdx]));
c0100b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b8b:	01 d0                	add    %edx,%eax
c0100b8d:	8b 00                	mov    (%eax),%eax
c0100b8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b94:	83 ec 04             	sub    $0x4,%esp
c0100b97:	50                   	push   %eax
c0100b98:	68 2c 01 00 00       	push   $0x12c
c0100b9d:	68 01 30 10 c0       	push   $0xc0103001
c0100ba2:	e8 4c fa ff ff       	call   c01005f3 <_kaddr>
c0100ba7:	83 c4 10             	add    $0x10,%esp
c0100baa:	89 45 ec             	mov    %eax,-0x14(%ebp)

			pp = page_alloc(ALLOC_ZERO);
c0100bad:	83 ec 0c             	sub    $0xc,%esp
c0100bb0:	6a 01                	push   $0x1
c0100bb2:	e8 cc fc ff ff       	call   c0100883 <page_alloc>
c0100bb7:	83 c4 10             	add    $0x10,%esp
c0100bba:	89 45 e8             	mov    %eax,-0x18(%ebp)
			pp->pp_ref ++;
c0100bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100bc0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100bc4:	8d 50 01             	lea    0x1(%eax),%edx
c0100bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100bca:	66 89 50 04          	mov    %dx,0x4(%eax)

			dst_dir[pdx] = page2pa(pp) | PTE_ATTR(src_dir[pdx]);
c0100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdb:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c0100bde:	83 ec 0c             	sub    $0xc,%esp
c0100be1:	ff 75 e8             	pushl  -0x18(%ebp)
c0100be4:	e8 3a fa ff ff       	call   c0100623 <page2pa>
c0100be9:	83 c4 10             	add    $0x10,%esp
c0100bec:	89 c1                	mov    %eax,%ecx
c0100bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bfb:	01 d0                	add    %edx,%eax
c0100bfd:	8b 00                	mov    (%eax),%eax
c0100bff:	25 ff 0f 00 00       	and    $0xfff,%eax
c0100c04:	09 c8                	or     %ecx,%eax
c0100c06:	89 03                	mov    %eax,(%ebx)

			pte_t *dst_table = KADDR(PTE_ADDR(dst_dir[pdx]));
c0100c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c15:	01 d0                	add    %edx,%eax
c0100c17:	8b 00                	mov    (%eax),%eax
c0100c19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c1e:	83 ec 04             	sub    $0x4,%esp
c0100c21:	50                   	push   %eax
c0100c22:	68 33 01 00 00       	push   $0x133
c0100c27:	68 01 30 10 c0       	push   $0xc0103001
c0100c2c:	e8 c2 f9 ff ff       	call   c01005f3 <_kaddr>
c0100c31:	83 c4 10             	add    $0x10,%esp
c0100c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100c37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100c3e:	e9 c9 00 00 00       	jmp    c0100d0c <copy_pgdir+0x1da>
				if (src_table[ptx] & PTE_P) {
c0100c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c50:	01 d0                	add    %edx,%eax
c0100c52:	8b 00                	mov    (%eax),%eax
c0100c54:	83 e0 01             	and    $0x1,%eax
c0100c57:	85 c0                	test   %eax,%eax
c0100c59:	0f 84 a9 00 00 00    	je     c0100d08 <copy_pgdir+0x1d6>
					pp = page_alloc(0);
c0100c5f:	83 ec 0c             	sub    $0xc,%esp
c0100c62:	6a 00                	push   $0x0
c0100c64:	e8 1a fc ff ff       	call   c0100883 <page_alloc>
c0100c69:	83 c4 10             	add    $0x10,%esp
c0100c6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					pp->pp_ref ++;
c0100c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100c72:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100c76:	8d 50 01             	lea    0x1(%eax),%edx
c0100c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100c7c:	66 89 50 04          	mov    %dx,0x4(%eax)

					dst_table[ptx] = page2pa(pp) | PTE_ATTR(src_table[ptx]);
c0100c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100c8d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c0100c90:	83 ec 0c             	sub    $0xc,%esp
c0100c93:	ff 75 e8             	pushl  -0x18(%ebp)
c0100c96:	e8 88 f9 ff ff       	call   c0100623 <page2pa>
c0100c9b:	83 c4 10             	add    $0x10,%esp
c0100c9e:	89 c1                	mov    %eax,%ecx
c0100ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100cad:	01 d0                	add    %edx,%eax
c0100caf:	8b 00                	mov    (%eax),%eax
c0100cb1:	25 ff 0f 00 00       	and    $0xfff,%eax
c0100cb6:	09 c8                	or     %ecx,%eax
c0100cb8:	89 03                	mov    %eax,(%ebx)
					memcpy(page2kva(pp), KADDR(PTE_ADDR(src_table[ptx])), PGSIZE);
c0100cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100cbd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100cc7:	01 d0                	add    %edx,%eax
c0100cc9:	8b 00                	mov    (%eax),%eax
c0100ccb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100cd0:	83 ec 04             	sub    $0x4,%esp
c0100cd3:	50                   	push   %eax
c0100cd4:	68 3a 01 00 00       	push   $0x13a
c0100cd9:	68 01 30 10 c0       	push   $0xc0103001
c0100cde:	e8 10 f9 ff ff       	call   c01005f3 <_kaddr>
c0100ce3:	83 c4 10             	add    $0x10,%esp
c0100ce6:	89 c3                	mov    %eax,%ebx
c0100ce8:	83 ec 0c             	sub    $0xc,%esp
c0100ceb:	ff 75 e8             	pushl  -0x18(%ebp)
c0100cee:	e8 78 f9 ff ff       	call   c010066b <page2kva>
c0100cf3:	83 c4 10             	add    $0x10,%esp
c0100cf6:	83 ec 04             	sub    $0x4,%esp
c0100cf9:	68 00 10 00 00       	push   $0x1000
c0100cfe:	53                   	push   %ebx
c0100cff:	50                   	push   %eax
c0100d00:	e8 88 f8 ff ff       	call   c010058d <memcpy>
c0100d05:	83 c4 10             	add    $0x10,%esp
			pp->pp_ref ++;

			dst_dir[pdx] = page2pa(pp) | PTE_ATTR(src_dir[pdx]);

			pte_t *dst_table = KADDR(PTE_ADDR(dst_dir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100d08:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100d0c:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100d13:	0f 8e 2a ff ff ff    	jle    c0100c43 <copy_pgdir+0x111>
//
void copy_pgdir(pde_t *dst_dir, pde_t *src_dir)
{
	struct PageInfo *pp;
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100d19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d1d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100d24:	0f 8e 1b fe ff ff    	jle    c0100b45 <copy_pgdir+0x13>
					memcpy(page2kva(pp), KADDR(PTE_ADDR(src_table[ptx])), PGSIZE);
				}
			}
		}
	}
}
c0100d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100d2d:	c9                   	leave  
c0100d2e:	c3                   	ret    

c0100d2f <page_lookup>:

struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
c0100d2f:	55                   	push   %ebp
c0100d30:	89 e5                	mov    %esp,%ebp
c0100d32:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, false);
c0100d35:	83 ec 04             	sub    $0x4,%esp
c0100d38:	6a 00                	push   $0x0
c0100d3a:	ff 75 0c             	pushl  0xc(%ebp)
c0100d3d:	ff 75 08             	pushl  0x8(%ebp)
c0100d40:	e8 f3 fb ff ff       	call   c0100938 <pgdir_walk>
c0100d45:	83 c4 10             	add    $0x10,%esp
c0100d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) return NULL;
c0100d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d4f:	75 07                	jne    c0100d58 <page_lookup+0x29>
c0100d51:	b8 00 00 00 00       	mov    $0x0,%eax
c0100d56:	eb 24                	jmp    c0100d7c <page_lookup+0x4d>
	if (pte_store != NULL) *pte_store = pte;
c0100d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100d5c:	74 08                	je     c0100d66 <page_lookup+0x37>
c0100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d64:	89 10                	mov    %edx,(%eax)
	return pa2page(PTE_ADDR(*pte));
c0100d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d69:	8b 00                	mov    (%eax),%eax
c0100d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100d70:	83 ec 0c             	sub    $0xc,%esp
c0100d73:	50                   	push   %eax
c0100d74:	e8 bf f8 ff ff       	call   c0100638 <pa2page>
c0100d79:	83 c4 10             	add    $0x10,%esp
}
c0100d7c:	c9                   	leave  
c0100d7d:	c3                   	ret    

c0100d7e <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
c0100d7e:	55                   	push   %ebp
c0100d7f:	89 e5                	mov    %esp,%ebp
c0100d81:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte;
	pte_t **pte_store = &pte;
c0100d84:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0100d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);
c0100d8a:	83 ec 04             	sub    $0x4,%esp
c0100d8d:	ff 75 f4             	pushl  -0xc(%ebp)
c0100d90:	ff 75 0c             	pushl  0xc(%ebp)
c0100d93:	ff 75 08             	pushl  0x8(%ebp)
c0100d96:	e8 94 ff ff ff       	call   c0100d2f <page_lookup>
c0100d9b:	83 c4 10             	add    $0x10,%esp
c0100d9e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (p != NULL) {
c0100da1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100da5:	74 2a                	je     c0100dd1 <page_remove+0x53>
		**pte_store = 0;
c0100da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100daa:	8b 00                	mov    (%eax),%eax
c0100dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(p);
c0100db2:	83 ec 0c             	sub    $0xc,%esp
c0100db5:	ff 75 f0             	pushl  -0x10(%ebp)
c0100db8:	e8 4e fb ff ff       	call   c010090b <page_decref>
c0100dbd:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
c0100dc0:	83 ec 08             	sub    $0x8,%esp
c0100dc3:	ff 75 0c             	pushl  0xc(%ebp)
c0100dc6:	ff 75 08             	pushl  0x8(%ebp)
c0100dc9:	e8 05 00 00 00       	call   c0100dd3 <tlb_invalidate>
c0100dce:	83 c4 10             	add    $0x10,%esp
	}
}
c0100dd1:	c9                   	leave  
c0100dd2:	c3                   	ret    

c0100dd3 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
c0100dd3:	55                   	push   %ebp
c0100dd4:	89 e5                	mov    %esp,%ebp
c0100dd6:	83 ec 10             	sub    $0x10,%esp
c0100dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
c0100ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de2:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
c0100de5:	c9                   	leave  
c0100de6:	c3                   	ret    

c0100de7 <free_pgdir>:

void free_pgdir(pde_t *pgdir)
{
c0100de7:	55                   	push   %ebp
c0100de8:	89 e5                	mov    %esp,%ebp
c0100dea:	83 ec 18             	sub    $0x18,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100df4:	e9 09 01 00 00       	jmp    c0100f02 <free_pgdir+0x11b>
		if (pgdir[pdx] & PTE_P) {
c0100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dfc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e06:	01 d0                	add    %edx,%eax
c0100e08:	8b 00                	mov    (%eax),%eax
c0100e0a:	83 e0 01             	and    $0x1,%eax
c0100e0d:	85 c0                	test   %eax,%eax
c0100e0f:	0f 84 e9 00 00 00    	je     c0100efe <free_pgdir+0x117>
			if (kern_pgdir[pdx] & PTE_P) continue;
c0100e15:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0100e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100e1d:	c1 e2 02             	shl    $0x2,%edx
c0100e20:	01 d0                	add    %edx,%eax
c0100e22:	8b 00                	mov    (%eax),%eax
c0100e24:	83 e0 01             	and    $0x1,%eax
c0100e27:	85 c0                	test   %eax,%eax
c0100e29:	74 05                	je     c0100e30 <free_pgdir+0x49>
c0100e2b:	e9 ce 00 00 00       	jmp    c0100efe <free_pgdir+0x117>
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100e3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e3d:	01 d0                	add    %edx,%eax
c0100e3f:	8b 00                	mov    (%eax),%eax
c0100e41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100e46:	83 ec 04             	sub    $0x4,%esp
c0100e49:	50                   	push   %eax
c0100e4a:	68 79 01 00 00       	push   $0x179
c0100e4f:	68 01 30 10 c0       	push   $0xc0103001
c0100e54:	e8 9a f7 ff ff       	call   c01005f3 <_kaddr>
c0100e59:	83 c4 10             	add    $0x10,%esp
c0100e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100e5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100e66:	eb 4a                	jmp    c0100eb2 <free_pgdir+0xcb>
				if (pgtable[ptx] & PTE_P) {
c0100e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100e75:	01 d0                	add    %edx,%eax
c0100e77:	8b 00                	mov    (%eax),%eax
c0100e79:	83 e0 01             	and    $0x1,%eax
c0100e7c:	85 c0                	test   %eax,%eax
c0100e7e:	74 2e                	je     c0100eae <free_pgdir+0xc7>
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
c0100e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100e8d:	01 d0                	add    %edx,%eax
c0100e8f:	8b 00                	mov    (%eax),%eax
c0100e91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100e96:	83 ec 0c             	sub    $0xc,%esp
c0100e99:	50                   	push   %eax
c0100e9a:	e8 99 f7 ff ff       	call   c0100638 <pa2page>
c0100e9f:	83 c4 10             	add    $0x10,%esp
c0100ea2:	83 ec 0c             	sub    $0xc,%esp
c0100ea5:	50                   	push   %eax
c0100ea6:	e8 60 fa ff ff       	call   c010090b <page_decref>
c0100eab:	83 c4 10             	add    $0x10,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100eae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100eb2:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100eb9:	7e ad                	jle    c0100e68 <free_pgdir+0x81>
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
c0100ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ec5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ec8:	01 d0                	add    %edx,%eax
c0100eca:	8b 00                	mov    (%eax),%eax
c0100ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100ed1:	83 ec 0c             	sub    $0xc,%esp
c0100ed4:	50                   	push   %eax
c0100ed5:	e8 5e f7 ff ff       	call   c0100638 <pa2page>
c0100eda:	83 c4 10             	add    $0x10,%esp
c0100edd:	83 ec 0c             	sub    $0xc,%esp
c0100ee0:	50                   	push   %eax
c0100ee1:	e8 25 fa ff ff       	call   c010090b <page_decref>
c0100ee6:	83 c4 10             	add    $0x10,%esp
			pgdir[pdx] = 0;
c0100ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100eec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ef3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ef6:	01 d0                	add    %edx,%eax
c0100ef8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100efe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100f02:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100f09:	0f 8e ea fe ff ff    	jle    c0100df9 <free_pgdir+0x12>
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}
c0100f0f:	c9                   	leave  
c0100f10:	c3                   	ret    

c0100f11 <do_scheduler>:

//PCB* ready;



void do_scheduler(){
c0100f11:	55                   	push   %ebp
c0100f12:	89 e5                	mov    %esp,%ebp
c0100f14:	83 ec 08             	sub    $0x8,%esp
	count ++;
c0100f17:	a1 04 50 15 c0       	mov    0xc0155004,%eax
c0100f1c:	83 c0 01             	add    $0x1,%eax
c0100f1f:	a3 04 50 15 c0       	mov    %eax,0xc0155004

	if(current == NULL){
c0100f24:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f29:	85 c0                	test   %eax,%eax
c0100f2b:	75 49                	jne    c0100f76 <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c0100f2d:	83 ec 0c             	sub    $0xc,%esp
c0100f30:	68 b4 50 15 c0       	push   $0xc01550b4
c0100f35:	e8 b6 11 00 00       	call   c01020f0 <ll_pop>
c0100f3a:	83 c4 10             	add    $0x10,%esp
c0100f3d:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0

		current->ts = RUNNING;
c0100f42:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f47:	c7 80 4c 40 00 00 01 	movl   $0x1,0x404c(%eax)
c0100f4e:	00 00 00 
		current->timeslice = 0;
c0100f51:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f56:	c7 80 54 40 00 00 00 	movl   $0x0,0x4054(%eax)
c0100f5d:	00 00 00 

		scheduler_switch(current);
c0100f60:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f65:	83 ec 0c             	sub    $0xc,%esp
c0100f68:	50                   	push   %eax
c0100f69:	e8 87 f4 ff ff       	call   c01003f5 <scheduler_switch>
c0100f6e:	83 c4 10             	add    $0x10,%esp
		return;
c0100f71:	e9 8c 00 00 00       	jmp    c0101002 <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c0100f76:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f7b:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100f81:	83 f8 03             	cmp    $0x3,%eax
c0100f84:	75 27                	jne    c0100fad <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c0100f86:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100f8b:	83 ec 08             	sub    $0x8,%esp
c0100f8e:	50                   	push   %eax
c0100f8f:	68 b8 50 15 c0       	push   $0xc01550b8
c0100f94:	e8 b9 11 00 00       	call   c0102152 <ll_entail>
c0100f99:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c0100f9c:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c0100fa3:	00 00 00 
		do_scheduler();
c0100fa6:	e8 66 ff ff ff       	call   c0100f11 <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c0100fab:	eb 55                	jmp    c0101002 <do_scheduler+0xf1>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 3 || current->ts == STOP){
c0100fad:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100fb2:	8b 80 54 40 00 00    	mov    0x4054(%eax),%eax
c0100fb8:	83 f8 03             	cmp    $0x3,%eax
c0100fbb:	77 10                	ja     c0100fcd <do_scheduler+0xbc>
c0100fbd:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100fc2:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100fc8:	83 f8 02             	cmp    $0x2,%eax
c0100fcb:	75 35                	jne    c0101002 <do_scheduler+0xf1>

		current->ts = READY;
c0100fcd:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100fd2:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0100fd9:	00 00 00 

		ll_entail(&ready_list, current);
c0100fdc:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100fe1:	83 ec 08             	sub    $0x8,%esp
c0100fe4:	50                   	push   %eax
c0100fe5:	68 b4 50 15 c0       	push   $0xc01550b4
c0100fea:	e8 63 11 00 00       	call   c0102152 <ll_entail>
c0100fef:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c0100ff2:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c0100ff9:	00 00 00 
		do_scheduler();
c0100ffc:	e8 10 ff ff ff       	call   c0100f11 <do_scheduler>
		//scheduler_switch(current);
		return;
c0101001:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0101002:	c9                   	leave  
c0101003:	c3                   	ret    

c0101004 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0101004:	55                   	push   %ebp
c0101005:	89 e5                	mov    %esp,%ebp
c0101007:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c010100a:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010100f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101012:	89 90 58 40 00 00    	mov    %edx,0x4058(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0101018:	8b 45 08             	mov    0x8(%ebp),%eax
c010101b:	8b 40 30             	mov    0x30(%eax),%eax
c010101e:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		else {
			//printk("IRQ::%d\n", tf->irq);
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0101023:	8b 45 08             	mov    0x8(%ebp),%eax
c0101026:	8b 40 30             	mov    0x30(%eax),%eax
c0101029:	3d 80 00 00 00       	cmp    $0x80,%eax
c010102e:	75 0e                	jne    c010103e <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c0101030:	83 ec 0c             	sub    $0xc,%esp
c0101033:	ff 75 08             	pushl  0x8(%ebp)
c0101036:	e8 d9 0c 00 00       	call   c0101d14 <do_syscall>
c010103b:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c010103e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101041:	8b 40 30             	mov    0x30(%eax),%eax
c0101044:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101049:	75 0f                	jne    c010105a <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c010104b:	e8 0f 1a 00 00       	call   c0102a5f <do_timer>
		do_scheduler();
c0101050:	e8 bc fe ff ff       	call   c0100f11 <do_scheduler>
c0101055:	e9 83 00 00 00       	jmp    c01010dd <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c010105a:	8b 45 08             	mov    0x8(%ebp),%eax
c010105d:	8b 40 30             	mov    0x30(%eax),%eax
c0101060:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0101065:	75 76                	jne    c01010dd <irq_handle+0xd9>
c0101067:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010106e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101071:	89 c2                	mov    %eax,%edx
c0101073:	ec                   	in     (%dx),%al
c0101074:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0101077:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c010107b:	0f b6 c0             	movzbl %al,%eax
c010107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101081:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010108b:	89 c2                	mov    %eax,%edx
c010108d:	ec                   	in     (%dx),%al
c010108e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0101091:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0101095:	0f b6 c0             	movzbl %al,%eax
c0101098:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c010109b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010109e:	83 c8 80             	or     $0xffffff80,%eax
c01010a1:	0f b6 c0             	movzbl %al,%eax
c01010a4:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c01010ab:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01010ae:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01010b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01010b5:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c01010b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01010b9:	0f b6 c0             	movzbl %al,%eax
c01010bc:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c01010c3:	88 45 d3             	mov    %al,-0x2d(%ebp)
c01010c6:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01010ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01010cd:	ee                   	out    %al,(%dx)
		press_key(code);
c01010ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01010d1:	83 ec 0c             	sub    $0xc,%esp
c01010d4:	50                   	push   %eax
c01010d5:	e8 60 0b 00 00       	call   c0101c3a <press_key>
c01010da:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
c01010dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e0:	8b 40 30             	mov    0x30(%eax),%eax
c01010e3:	3d 80 00 00 00       	cmp    $0x80,%eax
c01010e8:	75 1f                	jne    c0101109 <irq_handle+0x105>
c01010ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ed:	8b 40 1c             	mov    0x1c(%eax),%eax
c01010f0:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01010f5:	74 0d                	je     c0101104 <irq_handle+0x100>
c01010f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fa:	8b 40 1c             	mov    0x1c(%eax),%eax
c01010fd:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101102:	75 05                	jne    c0101109 <irq_handle+0x105>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0101104:	e8 08 fe ff ff       	call   c0100f11 <do_scheduler>
	}
}
c0101109:	c9                   	leave  
c010110a:	c3                   	ret    

c010110b <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c010110b:	55                   	push   %ebp
c010110c:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c010110e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101111:	83 e8 01             	sub    $0x1,%eax
c0101114:	66 a3 08 50 15 c0    	mov    %ax,0xc0155008
	data[1] = (uint32_t)addr;
c010111a:	8b 45 08             	mov    0x8(%ebp),%eax
c010111d:	66 a3 0a 50 15 c0    	mov    %ax,0xc015500a
	data[2] = ((uint32_t)addr) >> 16;
c0101123:	8b 45 08             	mov    0x8(%ebp),%eax
c0101126:	c1 e8 10             	shr    $0x10,%eax
c0101129:	66 a3 0c 50 15 c0    	mov    %ax,0xc015500c
	asm volatile("lidt (%0)" : : "r"(data));
c010112f:	b8 08 50 15 c0       	mov    $0xc0155008,%eax
c0101134:	0f 01 18             	lidtl  (%eax)
}
c0101137:	5d                   	pop    %ebp
c0101138:	c3                   	ret    

c0101139 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0101139:	55                   	push   %ebp
c010113a:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c010113c:	8b 45 10             	mov    0x10(%ebp),%eax
c010113f:	89 c2                	mov    %eax,%edx
c0101141:	8b 45 08             	mov    0x8(%ebp),%eax
c0101144:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0101147:	8b 45 0c             	mov    0xc(%ebp),%eax
c010114a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101151:	8b 45 08             	mov    0x8(%ebp),%eax
c0101154:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0101158:	8b 45 08             	mov    0x8(%ebp),%eax
c010115b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c010115f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101162:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101166:	83 e2 f0             	and    $0xfffffff0,%edx
c0101169:	83 ca 0e             	or     $0xe,%edx
c010116c:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c010116f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101172:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101176:	83 e2 ef             	and    $0xffffffef,%edx
c0101179:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c010117c:	8b 45 14             	mov    0x14(%ebp),%eax
c010117f:	83 e0 03             	and    $0x3,%eax
c0101182:	89 c2                	mov    %eax,%edx
c0101184:	8b 45 08             	mov    0x8(%ebp),%eax
c0101187:	83 e2 03             	and    $0x3,%edx
c010118a:	89 d1                	mov    %edx,%ecx
c010118c:	c1 e1 05             	shl    $0x5,%ecx
c010118f:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101193:	83 e2 9f             	and    $0xffffff9f,%edx
c0101196:	09 ca                	or     %ecx,%edx
c0101198:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c010119b:	8b 45 08             	mov    0x8(%ebp),%eax
c010119e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01011a2:	83 ca 80             	or     $0xffffff80,%edx
c01011a5:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c01011a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01011ab:	c1 e8 10             	shr    $0x10,%eax
c01011ae:	89 c2                	mov    %eax,%edx
c01011b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b3:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c01011b7:	5d                   	pop    %ebp
c01011b8:	c3                   	ret    

c01011b9 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c01011b9:	55                   	push   %ebp
c01011ba:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c01011bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01011bf:	89 c2                	mov    %eax,%edx
c01011c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c4:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c01011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d4:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c01011d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011db:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c01011df:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e2:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01011e6:	83 ca 0f             	or     $0xf,%edx
c01011e9:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c01011ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ef:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01011f3:	83 e2 ef             	and    $0xffffffef,%edx
c01011f6:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c01011f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01011fc:	83 e0 03             	and    $0x3,%eax
c01011ff:	89 c2                	mov    %eax,%edx
c0101201:	8b 45 08             	mov    0x8(%ebp),%eax
c0101204:	83 e2 03             	and    $0x3,%edx
c0101207:	89 d1                	mov    %edx,%ecx
c0101209:	c1 e1 05             	shl    $0x5,%ecx
c010120c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101210:	83 e2 9f             	and    $0xffffff9f,%edx
c0101213:	09 ca                	or     %ecx,%edx
c0101215:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0101218:	8b 45 08             	mov    0x8(%ebp),%eax
c010121b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010121f:	83 ca 80             	or     $0xffffff80,%edx
c0101222:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0101225:	8b 45 10             	mov    0x10(%ebp),%eax
c0101228:	c1 e8 10             	shr    $0x10,%eax
c010122b:	89 c2                	mov    %eax,%edx
c010122d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101230:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101234:	5d                   	pop    %ebp
c0101235:	c3                   	ret    

c0101236 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0101236:	55                   	push   %ebp
c0101237:	89 e5                	mov    %esp,%ebp
c0101239:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c010123c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101243:	eb 22                	jmp    c0101267 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c0101245:	ba c5 2b 10 c0       	mov    $0xc0102bc5,%edx
c010124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010124d:	c1 e0 03             	shl    $0x3,%eax
c0101250:	05 40 4a 1b c0       	add    $0xc01b4a40,%eax
c0101255:	6a 00                	push   $0x0
c0101257:	52                   	push   %edx
c0101258:	6a 01                	push   $0x1
c010125a:	50                   	push   %eax
c010125b:	e8 59 ff ff ff       	call   c01011b9 <set_trap>
c0101260:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101263:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101267:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010126e:	7e d5                	jle    c0101245 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0101270:	b8 0d 2b 10 c0       	mov    $0xc0102b0d,%eax
c0101275:	6a 00                	push   $0x0
c0101277:	50                   	push   %eax
c0101278:	6a 01                	push   $0x1
c010127a:	68 40 4a 1b c0       	push   $0xc01b4a40
c010127f:	e8 35 ff ff ff       	call   c01011b9 <set_trap>
c0101284:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101287:	b8 16 2b 10 c0       	mov    $0xc0102b16,%eax
c010128c:	6a 00                	push   $0x0
c010128e:	50                   	push   %eax
c010128f:	6a 01                	push   $0x1
c0101291:	68 48 4a 1b c0       	push   $0xc01b4a48
c0101296:	e8 1e ff ff ff       	call   c01011b9 <set_trap>
c010129b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010129e:	b8 1f 2b 10 c0       	mov    $0xc0102b1f,%eax
c01012a3:	6a 00                	push   $0x0
c01012a5:	50                   	push   %eax
c01012a6:	6a 01                	push   $0x1
c01012a8:	68 50 4a 1b c0       	push   $0xc01b4a50
c01012ad:	e8 07 ff ff ff       	call   c01011b9 <set_trap>
c01012b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c01012b5:	b8 28 2b 10 c0       	mov    $0xc0102b28,%eax
c01012ba:	6a 00                	push   $0x0
c01012bc:	50                   	push   %eax
c01012bd:	6a 01                	push   $0x1
c01012bf:	68 58 4a 1b c0       	push   $0xc01b4a58
c01012c4:	e8 f0 fe ff ff       	call   c01011b9 <set_trap>
c01012c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c01012cc:	b8 31 2b 10 c0       	mov    $0xc0102b31,%eax
c01012d1:	6a 00                	push   $0x0
c01012d3:	50                   	push   %eax
c01012d4:	6a 01                	push   $0x1
c01012d6:	68 60 4a 1b c0       	push   $0xc01b4a60
c01012db:	e8 d9 fe ff ff       	call   c01011b9 <set_trap>
c01012e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c01012e3:	b8 3a 2b 10 c0       	mov    $0xc0102b3a,%eax
c01012e8:	6a 00                	push   $0x0
c01012ea:	50                   	push   %eax
c01012eb:	6a 01                	push   $0x1
c01012ed:	68 68 4a 1b c0       	push   $0xc01b4a68
c01012f2:	e8 c2 fe ff ff       	call   c01011b9 <set_trap>
c01012f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c01012fa:	b8 43 2b 10 c0       	mov    $0xc0102b43,%eax
c01012ff:	6a 00                	push   $0x0
c0101301:	50                   	push   %eax
c0101302:	6a 01                	push   $0x1
c0101304:	68 70 4a 1b c0       	push   $0xc01b4a70
c0101309:	e8 ab fe ff ff       	call   c01011b9 <set_trap>
c010130e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0101311:	b8 4c 2b 10 c0       	mov    $0xc0102b4c,%eax
c0101316:	6a 00                	push   $0x0
c0101318:	50                   	push   %eax
c0101319:	6a 01                	push   $0x1
c010131b:	68 78 4a 1b c0       	push   $0xc01b4a78
c0101320:	e8 94 fe ff ff       	call   c01011b9 <set_trap>
c0101325:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0101328:	b8 55 2b 10 c0       	mov    $0xc0102b55,%eax
c010132d:	6a 00                	push   $0x0
c010132f:	50                   	push   %eax
c0101330:	6a 01                	push   $0x1
c0101332:	68 80 4a 1b c0       	push   $0xc01b4a80
c0101337:	e8 7d fe ff ff       	call   c01011b9 <set_trap>
c010133c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c010133f:	b8 5e 2b 10 c0       	mov    $0xc0102b5e,%eax
c0101344:	6a 00                	push   $0x0
c0101346:	50                   	push   %eax
c0101347:	6a 01                	push   $0x1
c0101349:	68 88 4a 1b c0       	push   $0xc01b4a88
c010134e:	e8 66 fe ff ff       	call   c01011b9 <set_trap>
c0101353:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c0101356:	b8 67 2b 10 c0       	mov    $0xc0102b67,%eax
c010135b:	6a 00                	push   $0x0
c010135d:	50                   	push   %eax
c010135e:	6a 01                	push   $0x1
c0101360:	68 90 4a 1b c0       	push   $0xc01b4a90
c0101365:	e8 4f fe ff ff       	call   c01011b9 <set_trap>
c010136a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c010136d:	b8 70 2b 10 c0       	mov    $0xc0102b70,%eax
c0101372:	6a 00                	push   $0x0
c0101374:	50                   	push   %eax
c0101375:	6a 01                	push   $0x1
c0101377:	68 98 4a 1b c0       	push   $0xc01b4a98
c010137c:	e8 38 fe ff ff       	call   c01011b9 <set_trap>
c0101381:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101384:	b8 79 2b 10 c0       	mov    $0xc0102b79,%eax
c0101389:	6a 00                	push   $0x0
c010138b:	50                   	push   %eax
c010138c:	6a 01                	push   $0x1
c010138e:	68 a0 4a 1b c0       	push   $0xc01b4aa0
c0101393:	e8 21 fe ff ff       	call   c01011b9 <set_trap>
c0101398:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c010139b:	b8 82 2b 10 c0       	mov    $0xc0102b82,%eax
c01013a0:	6a 00                	push   $0x0
c01013a2:	50                   	push   %eax
c01013a3:	6a 01                	push   $0x1
c01013a5:	68 a8 4a 1b c0       	push   $0xc01b4aa8
c01013aa:	e8 0a fe ff ff       	call   c01011b9 <set_trap>
c01013af:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c01013b2:	b8 94 2b 10 c0       	mov    $0xc0102b94,%eax
c01013b7:	6a 03                	push   $0x3
c01013b9:	50                   	push   %eax
c01013ba:	6a 01                	push   $0x1
c01013bc:	68 40 4e 1b c0       	push   $0xc01b4e40
c01013c1:	e8 f3 fd ff ff       	call   c01011b9 <set_trap>
c01013c6:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c01013c9:	b8 a1 2b 10 c0       	mov    $0xc0102ba1,%eax
c01013ce:	6a 00                	push   $0x0
c01013d0:	50                   	push   %eax
c01013d1:	6a 01                	push   $0x1
c01013d3:	68 40 4b 1b c0       	push   $0xc01b4b40
c01013d8:	e8 5c fd ff ff       	call   c0101139 <set_intr>
c01013dd:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c01013e0:	b8 ad 2b 10 c0       	mov    $0xc0102bad,%eax
c01013e5:	6a 00                	push   $0x0
c01013e7:	50                   	push   %eax
c01013e8:	6a 01                	push   $0x1
c01013ea:	68 48 4b 1b c0       	push   $0xc01b4b48
c01013ef:	e8 45 fd ff ff       	call   c0101139 <set_intr>
c01013f4:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c01013f7:	68 00 08 00 00       	push   $0x800
c01013fc:	68 40 4a 1b c0       	push   $0xc01b4a40
c0101401:	e8 05 fd ff ff       	call   c010110b <save_idt>
c0101406:	83 c4 08             	add    $0x8,%esp
}
c0101409:	c9                   	leave  
c010140a:	c3                   	ret    

c010140b <sys_handout>:

static inline void sys_thread(void* entry, uint32_t esp){
	asm volatile("int $0x80": : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
}

static inline void sys_handout(){
c010140b:	55                   	push   %ebp
c010140c:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c010140e:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0101413:	cd 80                	int    $0x80
}
c0101415:	5d                   	pop    %ebp
c0101416:	c3                   	ret    

c0101417 <sys_exit>:
static inline void sys_exit(){
c0101417:	55                   	push   %ebp
c0101418:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c010141a:	b8 df 05 00 00       	mov    $0x5df,%eax
c010141f:	cd 80                	int    $0x80
}
c0101421:	5d                   	pop    %ebp
c0101422:	c3                   	ret    

c0101423 <sys_fork>:
static inline uint32_t sys_fork(){
c0101423:	55                   	push   %ebp
c0101424:	89 e5                	mov    %esp,%ebp
c0101426:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101429:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c0101430:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c0101435:	cd 80                	int    $0x80
c0101437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c010143a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010143d:	c9                   	leave  
c010143e:	c3                   	ret    

c010143f <sys_pid>:
static inline uint32_t sys_pid(){
c010143f:	55                   	push   %ebp
c0101440:	89 e5                	mov    %esp,%ebp
c0101442:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101445:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c010144c:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0101451:	cd 80                	int    $0x80
c0101453:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101456:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101459:	c9                   	leave  
c010145a:	c3                   	ret    

c010145b <sys_ppid>:
static inline uint32_t sys_ppid(){
c010145b:	55                   	push   %ebp
c010145c:	89 e5                	mov    %esp,%ebp
c010145e:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c0101468:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c010146d:	cd 80                	int    $0x80
c010146f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101472:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101475:	c9                   	leave  
c0101476:	c3                   	ret    

c0101477 <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c0101477:	55                   	push   %ebp
c0101478:	89 e5                	mov    %esp,%ebp
c010147a:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c010147b:	b8 de 05 00 00       	mov    $0x5de,%eax
c0101480:	8b 55 08             	mov    0x8(%ebp),%edx
c0101483:	89 d3                	mov    %edx,%ebx
c0101485:	cd 80                	int    $0x80
}
c0101487:	5b                   	pop    %ebx
c0101488:	5d                   	pop    %ebp
c0101489:	c3                   	ret    

c010148a <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010148a:	55                   	push   %ebp
c010148b:	89 e5                	mov    %esp,%ebp
c010148d:	83 ec 40             	sub    $0x40,%esp
c0101490:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0101497:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010149b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010149f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01014a2:	ee                   	out    %al,(%dx)
c01014a3:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c01014aa:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c01014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01014b5:	ee                   	out    %al,(%dx)
c01014b6:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c01014bd:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c01014c1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01014c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01014c8:	ee                   	out    %al,(%dx)
c01014c9:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c01014d0:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01014d4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01014d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01014db:	ee                   	out    %al,(%dx)
c01014dc:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01014e3:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01014e7:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01014eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01014ee:	ee                   	out    %al,(%dx)
c01014ef:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01014f6:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01014fa:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01014fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101501:	ee                   	out    %al,(%dx)
c0101502:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0101509:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c010150d:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101511:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101514:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c0101515:	c9                   	leave  
c0101516:	c3                   	ret    

c0101517 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c0101517:	55                   	push   %ebp
c0101518:	89 e5                	mov    %esp,%ebp
c010151a:	83 ec 70             	sub    $0x70,%esp
c010151d:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0101524:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c0101528:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010152c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010152f:	ee                   	out    %al,(%dx)
c0101530:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c0101537:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c010153b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101542:	ee                   	out    %al,(%dx)
c0101543:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c010154a:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c010154e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101552:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101555:	ee                   	out    %al,(%dx)
c0101556:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c010155d:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0101561:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101565:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101568:	ee                   	out    %al,(%dx)
c0101569:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0101570:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0101574:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101578:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010157b:	ee                   	out    %al,(%dx)
c010157c:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0101583:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c0101587:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c010158b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010158e:	ee                   	out    %al,(%dx)
c010158f:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0101596:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c010159a:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c010159e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01015a1:	ee                   	out    %al,(%dx)
c01015a2:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c01015a9:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c01015ad:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c01015b1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01015b4:	ee                   	out    %al,(%dx)
c01015b5:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01015bc:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01015c0:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01015c4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01015c7:	ee                   	out    %al,(%dx)
c01015c8:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01015cf:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c01015d3:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c01015d7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01015da:	ee                   	out    %al,(%dx)
c01015db:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c01015e2:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c01015e6:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c01015ea:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01015ed:	ee                   	out    %al,(%dx)
c01015ee:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c01015f5:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01015f9:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c01015fd:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101600:	ee                   	out    %al,(%dx)
c0101601:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c0101608:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c010160c:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0101610:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0101613:	ee                   	out    %al,(%dx)
c0101614:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c010161b:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c010161f:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0101623:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0101626:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c0101627:	c9                   	leave  
c0101628:	c3                   	ret    

c0101629 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0101629:	55                   	push   %ebp
c010162a:	89 e5                	mov    %esp,%ebp
c010162c:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c010162f:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c0101636:	0f b6 05 00 70 10 c0 	movzbl 0xc0107000,%eax
c010163d:	0f b6 c0             	movzbl %al,%eax
c0101640:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c0101647:	88 45 f7             	mov    %al,-0x9(%ebp)
c010164a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010164e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101651:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0101652:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101655:	0f b6 c0             	movzbl %al,%eax
c0101658:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c010165f:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101662:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101666:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101669:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c010166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010166d:	c1 f8 08             	sar    $0x8,%eax
c0101670:	0f b6 c0             	movzbl %al,%eax
c0101673:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c010167a:	88 45 e7             	mov    %al,-0x19(%ebp)
c010167d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101681:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101684:	ee                   	out    %al,(%dx)
}
c0101685:	c9                   	leave  
c0101686:	c3                   	ret    

c0101687 <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c0101687:	55                   	push   %ebp
c0101688:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c010168a:	e8 7c fd ff ff       	call   c010140b <sys_handout>
  }
c010168f:	eb f9                	jmp    c010168a <idle+0x3>

c0101691 <busy>:
}
void busy(){
c0101691:	55                   	push   %ebp
c0101692:	89 e5                	mov    %esp,%ebp
c0101694:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c0101697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c010169e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c01016a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01016ac:	eb 11                	jmp    c01016bf <busy+0x2e>
    if(fork()!=0){
c01016ae:	e8 70 fd ff ff       	call   c0101423 <sys_fork>
c01016b3:	85 c0                	test   %eax,%eax
c01016b5:	74 04                	je     c01016bb <busy+0x2a>
        j++;
c01016b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c01016bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01016bf:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c01016c3:	76 e9                	jbe    c01016ae <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c01016c5:	e8 75 fd ff ff       	call   c010143f <sys_pid>
c01016ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c01016cd:	e8 89 fd ff ff       	call   c010145b <sys_ppid>
c01016d2:	ff 75 f0             	pushl  -0x10(%ebp)
c01016d5:	50                   	push   %eax
c01016d6:	ff 75 e8             	pushl  -0x18(%ebp)
c01016d9:	68 40 30 10 c0       	push   $0xc0103040
c01016de:	e8 3e 18 00 00       	call   c0102f21 <printf>
c01016e3:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c01016e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c01016ed:	e8 19 fd ff ff       	call   c010140b <sys_handout>
    sleep(pid);
c01016f2:	83 ec 0c             	sub    $0xc,%esp
c01016f5:	ff 75 e8             	pushl  -0x18(%ebp)
c01016f8:	e8 7a fd ff ff       	call   c0101477 <sys_sleep>
c01016fd:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0101700:	ff 75 ec             	pushl  -0x14(%ebp)
c0101703:	ff 75 e8             	pushl  -0x18(%ebp)
c0101706:	ff 75 e8             	pushl  -0x18(%ebp)
c0101709:	68 80 30 10 c0       	push   $0xc0103080
c010170e:	e8 0e 18 00 00       	call   c0102f21 <printf>
c0101713:	83 c4 10             	add    $0x10,%esp
    times++;
c0101716:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c010171a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010171e:	76 15                	jbe    c0101735 <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0101720:	83 ec 0c             	sub    $0xc,%esp
c0101723:	68 a4 30 10 c0       	push   $0xc01030a4
c0101728:	e8 f4 17 00 00       	call   c0102f21 <printf>
c010172d:	83 c4 10             	add    $0x10,%esp
      exit();
c0101730:	e8 e2 fc ff ff       	call   c0101417 <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c0101735:	eb b6                	jmp    c01016ed <busy+0x5c>

c0101737 <main>:
}
void do_scheduler();
int main(){
c0101737:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c010173b:	83 e4 f0             	and    $0xfffffff0,%esp
c010173e:	ff 71 fc             	pushl  -0x4(%ecx)
c0101741:	55                   	push   %ebp
c0101742:	89 e5                	mov    %esp,%ebp
c0101744:	51                   	push   %ecx
c0101745:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0101748:	e8 de e9 ff ff       	call   c010012b <init_page>
  init_segment();
c010174d:	e8 8a eb ff ff       	call   c01002dc <init_segment>
	init_serial();
c0101752:	e8 33 fd ff ff       	call   c010148a <init_serial>
	init_timer();
c0101757:	e8 cd fe ff ff       	call   c0101629 <init_timer>
	init_idt();
c010175c:	e8 d5 fa ff ff       	call   c0101236 <init_idt>
	init_intr();
c0101761:	e8 b1 fd ff ff       	call   c0101517 <init_intr>
  init_pcb_pool();
c0101766:	e8 c2 0a 00 00       	call   c010222d <init_pcb_pool>

  PCB* pidle = pcb_create();
c010176b:	e8 28 0c 00 00       	call   c0102398 <pcb_create>
c0101770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0101773:	83 ec 08             	sub    $0x8,%esp
c0101776:	68 87 16 10 c0       	push   $0xc0101687
c010177b:	ff 75 f4             	pushl  -0xc(%ebp)
c010177e:	e8 15 04 00 00       	call   c0101b98 <empty_loader>
c0101783:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c0101786:	e8 0d 0c 00 00       	call   c0102398 <pcb_create>
c010178b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c010178e:	83 ec 08             	sub    $0x8,%esp
c0101791:	68 00 90 01 00       	push   $0x19000
c0101796:	ff 75 f0             	pushl  -0x10(%ebp)
c0101799:	e8 62 02 00 00       	call   c0101a00 <loader>
c010179e:	83 c4 10             	add    $0x10,%esp

  enready_pcb(pidle);
c01017a1:	83 ec 0c             	sub    $0xc,%esp
c01017a4:	ff 75 f4             	pushl  -0xc(%ebp)
c01017a7:	e8 ec 0c 00 00       	call   c0102498 <enready_pcb>
c01017ac:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c01017af:	83 ec 0c             	sub    $0xc,%esp
c01017b2:	ff 75 f0             	pushl  -0x10(%ebp)
c01017b5:	e8 de 0c 00 00       	call   c0102498 <enready_pcb>
c01017ba:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c01017bd:	e8 d6 0b 00 00       	call   c0102398 <pcb_create>
c01017c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(app, 2*102400);
c01017c5:	83 ec 08             	sub    $0x8,%esp
c01017c8:	68 00 20 03 00       	push   $0x32000
c01017cd:	ff 75 ec             	pushl  -0x14(%ebp)
c01017d0:	e8 2b 02 00 00       	call   c0101a00 <loader>
c01017d5:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c01017d8:	83 ec 0c             	sub    $0xc,%esp
c01017db:	ff 75 ec             	pushl  -0x14(%ebp)
c01017de:	e8 b5 0c 00 00       	call   c0102498 <enready_pcb>
c01017e3:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c01017e6:	e8 26 f7 ff ff       	call   c0100f11 <do_scheduler>

  while(1);
c01017eb:	eb fe                	jmp    c01017eb <main+0xb4>

c01017ed <serial_idle>:

static inline
int serial_idle(void) {
c01017ed:	55                   	push   %ebp
c01017ee:	89 e5                	mov    %esp,%ebp
c01017f0:	83 ec 10             	sub    $0x10,%esp
c01017f3:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01017fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017fd:	89 c2                	mov    %eax,%edx
c01017ff:	ec                   	in     (%dx),%al
c0101800:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101803:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101807:	0f b6 c0             	movzbl %al,%eax
c010180a:	83 e0 20             	and    $0x20,%eax
c010180d:	85 c0                	test   %eax,%eax
c010180f:	0f 95 c0             	setne  %al
c0101812:	0f b6 c0             	movzbl %al,%eax
}
c0101815:	c9                   	leave  
c0101816:	c3                   	ret    

c0101817 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101817:	55                   	push   %ebp
c0101818:	89 e5                	mov    %esp,%ebp
c010181a:	83 ec 14             	sub    $0x14,%esp
c010181d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101820:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101823:	90                   	nop
c0101824:	e8 c4 ff ff ff       	call   c01017ed <serial_idle>
c0101829:	85 c0                	test   %eax,%eax
c010182b:	74 f7                	je     c0101824 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010182d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101831:	0f b6 c0             	movzbl %al,%eax
c0101834:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010183b:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010183e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101842:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101845:	ee                   	out    %al,(%dx)
}
c0101846:	c9                   	leave  
c0101847:	c3                   	ret    

c0101848 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101848:	55                   	push   %ebp
c0101849:	89 e5                	mov    %esp,%ebp
c010184b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010184e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101851:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101854:	8b 45 08             	mov    0x8(%ebp),%eax
c0101857:	83 ec 04             	sub    $0x4,%esp
c010185a:	ff 75 f4             	pushl  -0xc(%ebp)
c010185d:	50                   	push   %eax
c010185e:	68 17 18 10 c0       	push   $0xc0101817
c0101863:	e8 1f 14 00 00       	call   c0102c87 <vfprintf>
c0101868:	83 c4 10             	add    $0x10,%esp
}
c010186b:	c9                   	leave  
c010186c:	c3                   	ret    

c010186d <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c010186d:	55                   	push   %ebp
c010186e:	89 e5                	mov    %esp,%ebp
c0101870:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101873:	90                   	nop
c0101874:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010187b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010187e:	89 c2                	mov    %eax,%edx
c0101880:	ec                   	in     (%dx),%al
c0101881:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101884:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101888:	0f b6 c0             	movzbl %al,%eax
c010188b:	25 c0 00 00 00       	and    $0xc0,%eax
c0101890:	83 f8 40             	cmp    $0x40,%eax
c0101893:	75 df                	jne    c0101874 <waitdisk+0x7>
}
c0101895:	c9                   	leave  
c0101896:	c3                   	ret    

c0101897 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0101897:	55                   	push   %ebp
c0101898:	89 e5                	mov    %esp,%ebp
c010189a:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c010189d:	e8 cb ff ff ff       	call   c010186d <waitdisk>
c01018a2:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01018a9:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01018ad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01018b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01018b4:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01018b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01018b8:	0f b6 c0             	movzbl %al,%eax
c01018bb:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01018c2:	88 45 ef             	mov    %al,-0x11(%ebp)
c01018c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01018c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01018cc:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01018d0:	c1 f8 08             	sar    $0x8,%eax
c01018d3:	0f b6 c0             	movzbl %al,%eax
c01018d6:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01018dd:	88 45 e7             	mov    %al,-0x19(%ebp)
c01018e0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01018e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01018e7:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01018e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01018eb:	c1 f8 10             	sar    $0x10,%eax
c01018ee:	0f b6 c0             	movzbl %al,%eax
c01018f1:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01018f8:	88 45 df             	mov    %al,-0x21(%ebp)
c01018fb:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01018ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101902:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101903:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101906:	c1 f8 18             	sar    $0x18,%eax
c0101909:	83 c8 e0             	or     $0xffffffe0,%eax
c010190c:	0f b6 c0             	movzbl %al,%eax
c010190f:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101916:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101919:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010191d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101920:	ee                   	out    %al,(%dx)
c0101921:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101928:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c010192c:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101930:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101933:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101934:	e8 34 ff ff ff       	call   c010186d <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101939:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101940:	eb 29                	jmp    c010196b <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101945:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010194c:	8b 45 08             	mov    0x8(%ebp),%eax
c010194f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101952:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101959:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010195c:	89 c2                	mov    %eax,%edx
c010195e:	ed                   	in     (%dx),%eax
c010195f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101962:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101965:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101967:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010196b:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010196f:	7e d1                	jle    c0101942 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101971:	c9                   	leave  
c0101972:	c3                   	ret    

c0101973 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101973:	55                   	push   %ebp
c0101974:	89 e5                	mov    %esp,%ebp
c0101976:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101979:	8b 55 0c             	mov    0xc(%ebp),%edx
c010197c:	8b 45 08             	mov    0x8(%ebp),%eax
c010197f:	01 d0                	add    %edx,%eax
c0101981:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101984:	8b 45 10             	mov    0x10(%ebp),%eax
c0101987:	99                   	cltd   
c0101988:	c1 ea 17             	shr    $0x17,%edx
c010198b:	01 d0                	add    %edx,%eax
c010198d:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101992:	29 d0                	sub    %edx,%eax
c0101994:	f7 d8                	neg    %eax
c0101996:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0101999:	8b 45 10             	mov    0x10(%ebp),%eax
c010199c:	99                   	cltd   
c010199d:	c1 ea 17             	shr    $0x17,%edx
c01019a0:	01 d0                	add    %edx,%eax
c01019a2:	c1 f8 09             	sar    $0x9,%eax
c01019a5:	83 c0 01             	add    $0x1,%eax
c01019a8:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01019ab:	eb 19                	jmp    c01019c6 <readseg+0x53>
        readsect(pa, offset);
c01019ad:	ff 75 10             	pushl  0x10(%ebp)
c01019b0:	ff 75 08             	pushl  0x8(%ebp)
c01019b3:	e8 df fe ff ff       	call   c0101897 <readsect>
c01019b8:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01019bb:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c01019c2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01019c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01019cc:	72 df                	jb     c01019ad <readseg+0x3a>
        readsect(pa, offset);
c01019ce:	c9                   	leave  
c01019cf:	c3                   	ret    

c01019d0 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01019d0:	55                   	push   %ebp
c01019d1:	89 e5                	mov    %esp,%ebp
c01019d3:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01019d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01019d9:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01019de:	77 16                	ja     c01019f6 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01019e0:	ff 75 10             	pushl  0x10(%ebp)
c01019e3:	68 c4 30 10 c0       	push   $0xc01030c4
c01019e8:	ff 75 0c             	pushl  0xc(%ebp)
c01019eb:	ff 75 08             	pushl  0x8(%ebp)
c01019ee:	e8 55 fe ff ff       	call   c0101848 <printk>
c01019f3:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01019f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01019f9:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01019fe:	c9                   	leave  
c01019ff:	c3                   	ret    

c0101a00 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101a00:	55                   	push   %ebp
c0101a01:	89 e5                	mov    %esp,%ebp
c0101a03:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0101a06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a09:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0101a0f:	83 ec 04             	sub    $0x4,%esp
c0101a12:	50                   	push   %eax
c0101a13:	6a 17                	push   $0x17
c0101a15:	68 e7 30 10 c0       	push   $0xc01030e7
c0101a1a:	e8 b1 ff ff ff       	call   c01019d0 <_paddr>
c0101a1f:	83 c4 10             	add    $0x10,%esp
c0101a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a28:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2e:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0101a34:	83 ec 04             	sub    $0x4,%esp
c0101a37:	68 00 10 00 00       	push   $0x1000
c0101a3c:	6a 00                	push   $0x0
c0101a3e:	50                   	push   %eax
c0101a3f:	e8 4d ec ff ff       	call   c0100691 <mm_alloc>
c0101a44:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0101a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a4a:	83 ec 04             	sub    $0x4,%esp
c0101a4d:	50                   	push   %eax
c0101a4e:	68 00 10 00 00       	push   $0x1000
c0101a53:	6a 00                	push   $0x0
c0101a55:	e8 19 ff ff ff       	call   c0101973 <readseg>
c0101a5a:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0101a5d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101a62:	8b 00                	mov    (%eax),%eax
c0101a64:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0101a69:	0f 94 c0             	sete   %al
c0101a6c:	0f b6 c0             	movzbl %al,%eax
c0101a6f:	83 ec 08             	sub    $0x8,%esp
c0101a72:	50                   	push   %eax
c0101a73:	68 fb 30 10 c0       	push   $0xc01030fb
c0101a78:	e8 cb fd ff ff       	call   c0101848 <printk>
c0101a7d:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101a80:	b8 00 00 00 00       	mov    $0x0,%eax
c0101a85:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101a8b:	b8 00 00 00 00       	mov    $0x0,%eax
c0101a90:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a94:	0f b7 c0             	movzwl %ax,%eax
c0101a97:	c1 e0 05             	shl    $0x5,%eax
c0101a9a:	89 c2                	mov    %eax,%edx
c0101a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a9f:	01 d0                	add    %edx,%eax
c0101aa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101aa4:	eb 7f                	jmp    c0101b25 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0101aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aa9:	8b 40 0c             	mov    0xc(%eax),%eax
c0101aac:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ab2:	8b 48 14             	mov    0x14(%eax),%ecx
c0101ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ab8:	8b 50 08             	mov    0x8(%eax),%edx
c0101abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abe:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0101ac4:	83 ec 04             	sub    $0x4,%esp
c0101ac7:	51                   	push   %ecx
c0101ac8:	52                   	push   %edx
c0101ac9:	50                   	push   %eax
c0101aca:	e8 c2 eb ff ff       	call   c0100691 <mm_alloc>
c0101acf:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ad5:	8b 50 04             	mov    0x4(%eax),%edx
c0101ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101adb:	01 d0                	add    %edx,%eax
c0101add:	89 c2                	mov    %eax,%edx
c0101adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ae2:	8b 40 10             	mov    0x10(%eax),%eax
c0101ae5:	83 ec 04             	sub    $0x4,%esp
c0101ae8:	52                   	push   %edx
c0101ae9:	50                   	push   %eax
c0101aea:	ff 75 e8             	pushl  -0x18(%ebp)
c0101aed:	e8 81 fe ff ff       	call   c0101973 <readseg>
c0101af2:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0101af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101af8:	8b 50 10             	mov    0x10(%eax),%edx
c0101afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101afe:	01 d0                	add    %edx,%eax
c0101b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101b03:	eb 0c                	jmp    c0101b11 <loader+0x111>
c0101b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b08:	8d 50 01             	lea    0x1(%eax),%edx
c0101b0b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101b0e:	c6 00 00             	movb   $0x0,(%eax)
c0101b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b14:	8b 50 14             	mov    0x14(%eax),%edx
c0101b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101b1a:	01 d0                	add    %edx,%eax
c0101b1c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101b1f:	77 e4                	ja     c0101b05 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101b21:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101b2b:	0f 82 75 ff ff ff    	jb     c0101aa6 <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101b31:	b8 00 00 00 00       	mov    $0x0,%eax
c0101b36:	8b 40 18             	mov    0x18(%eax),%eax
c0101b39:	a3 00 2c 10 c0       	mov    %eax,0xc0102c00

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0101b47:	83 ec 04             	sub    $0x4,%esp
c0101b4a:	68 00 80 00 00       	push   $0x8000
c0101b4f:	68 00 60 bf be       	push   $0xbebf6000
c0101b54:	50                   	push   %eax
c0101b55:	e8 37 eb ff ff       	call   c0100691 <mm_alloc>
c0101b5a:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x1FF, entry, 3);
c0101b5d:	a1 00 2c 10 c0       	mov    0xc0102c00,%eax
c0101b62:	6a 03                	push   $0x3
c0101b64:	50                   	push   %eax
c0101b65:	68 01 de bf be       	push   $0xbebfde01
c0101b6a:	ff 75 08             	pushl  0x8(%ebp)
c0101b6d:	e8 f2 06 00 00       	call   c0102264 <init_pcb>
c0101b72:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0101b75:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101b7a:	83 ec 04             	sub    $0x4,%esp
c0101b7d:	50                   	push   %eax
c0101b7e:	6a 39                	push   $0x39
c0101b80:	68 e7 30 10 c0       	push   $0xc01030e7
c0101b85:	e8 46 fe ff ff       	call   c01019d0 <_paddr>
c0101b8a:	83 c4 10             	add    $0x10,%esp
c0101b8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101b93:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0101b96:	c9                   	leave  
c0101b97:	c3                   	ret    

c0101b98 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0101b98:	55                   	push   %ebp
c0101b99:	89 e5                	mov    %esp,%ebp
c0101b9b:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba1:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0101ba7:	83 ec 04             	sub    $0x4,%esp
c0101baa:	50                   	push   %eax
c0101bab:	6a 42                	push   $0x42
c0101bad:	68 e7 30 10 c0       	push   $0xc01030e7
c0101bb2:	e8 19 fe ff ff       	call   c01019d0 <_paddr>
c0101bb7:	83 c4 10             	add    $0x10,%esp
c0101bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc0:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0101bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc6:	a3 00 2c 10 c0       	mov    %eax,0xc0102c00
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x1FF, entry, 0);
c0101bcb:	a1 00 2c 10 c0       	mov    0xc0102c00,%eax
c0101bd0:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bd3:	81 c2 20 40 00 00    	add    $0x4020,%edx
c0101bd9:	81 ea ff 01 00 00    	sub    $0x1ff,%edx
c0101bdf:	6a 00                	push   $0x0
c0101be1:	50                   	push   %eax
c0101be2:	52                   	push   %edx
c0101be3:	ff 75 08             	pushl  0x8(%ebp)
c0101be6:	e8 79 06 00 00       	call   c0102264 <init_pcb>
c0101beb:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0101bee:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101bf3:	83 ec 04             	sub    $0x4,%esp
c0101bf6:	50                   	push   %eax
c0101bf7:	6a 46                	push   $0x46
c0101bf9:	68 e7 30 10 c0       	push   $0xc01030e7
c0101bfe:	e8 cd fd ff ff       	call   c01019d0 <_paddr>
c0101c03:	83 c4 10             	add    $0x10,%esp
c0101c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c0c:	0f 22 d8             	mov    %eax,%cr3

c0101c0f:	c9                   	leave  
c0101c10:	c3                   	ret    

c0101c11 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101c11:	55                   	push   %ebp
c0101c12:	89 e5                	mov    %esp,%ebp
c0101c14:	83 ec 04             	sub    $0x4,%esp
c0101c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101c1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101c21:	83 e8 61             	sub    $0x61,%eax
c0101c24:	8b 04 85 40 50 15 c0 	mov    -0x3feaafc0(,%eax,4),%eax
}
c0101c2b:	c9                   	leave  
c0101c2c:	c3                   	ret    

c0101c2d <get_lastkey>:
int8_t get_lastkey(){
c0101c2d:	55                   	push   %ebp
c0101c2e:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101c30:	a1 a8 50 15 c0       	mov    0xc01550a8,%eax
c0101c35:	83 c0 61             	add    $0x61,%eax
}
c0101c38:	5d                   	pop    %ebp
c0101c39:	c3                   	ret    

c0101c3a <press_key>:
void press_key(int code){
c0101c3a:	55                   	push   %ebp
c0101c3b:	89 e5                	mov    %esp,%ebp
c0101c3d:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101c40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4a:	25 80 00 00 00       	and    $0x80,%eax
c0101c4f:	85 c0                	test   %eax,%eax
c0101c51:	75 35                	jne    c0101c88 <press_key+0x4e>
		for(;i<26;i++){
c0101c53:	eb 2b                	jmp    c0101c80 <press_key+0x46>
			if(letter[i]==code){
c0101c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c58:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101c5f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101c62:	75 18                	jne    c0101c7c <press_key+0x42>
				keydown[i] = 1;
c0101c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c67:	c7 04 85 40 50 15 c0 	movl   $0x1,-0x3feaafc0(,%eax,4)
c0101c6e:	01 00 00 00 
				lastkey = i;
c0101c72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c75:	a3 a8 50 15 c0       	mov    %eax,0xc01550a8
				return;
c0101c7a:	eb 3b                	jmp    c0101cb7 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101c7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101c80:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101c84:	7e cf                	jle    c0101c55 <press_key+0x1b>
c0101c86:	eb 2f                	jmp    c0101cb7 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101c88:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101c8c:	eb 23                	jmp    c0101cb1 <press_key+0x77>
			if(letter[i]==code){
c0101c8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c91:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101c98:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101c9b:	75 10                	jne    c0101cad <press_key+0x73>
				keydown[i] = 0;
c0101c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ca0:	c7 04 85 40 50 15 c0 	movl   $0x0,-0x3feaafc0(,%eax,4)
c0101ca7:	00 00 00 00 
				return;
c0101cab:	eb 0a                	jmp    c0101cb7 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101cad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101cb1:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101cb5:	7e d7                	jle    c0101c8e <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101cb7:	c9                   	leave  
c0101cb8:	c3                   	ret    

c0101cb9 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101cb9:	55                   	push   %ebp
c0101cba:	89 e5                	mov    %esp,%ebp
c0101cbc:	83 ec 10             	sub    $0x10,%esp
c0101cbf:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101cc9:	89 c2                	mov    %eax,%edx
c0101ccb:	ec                   	in     (%dx),%al
c0101ccc:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101ccf:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101cd3:	0f b6 c0             	movzbl %al,%eax
c0101cd6:	83 e0 20             	and    $0x20,%eax
c0101cd9:	85 c0                	test   %eax,%eax
c0101cdb:	0f 95 c0             	setne  %al
c0101cde:	0f b6 c0             	movzbl %al,%eax
}
c0101ce1:	c9                   	leave  
c0101ce2:	c3                   	ret    

c0101ce3 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101ce3:	55                   	push   %ebp
c0101ce4:	89 e5                	mov    %esp,%ebp
c0101ce6:	83 ec 14             	sub    $0x14,%esp
c0101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cec:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101cef:	90                   	nop
c0101cf0:	e8 c4 ff ff ff       	call   c0101cb9 <serial_idle>
c0101cf5:	85 c0                	test   %eax,%eax
c0101cf7:	74 f7                	je     c0101cf0 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101cf9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101cfd:	0f b6 c0             	movzbl %al,%eax
c0101d00:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101d07:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101d0a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101d0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d11:	ee                   	out    %al,(%dx)
}
c0101d12:	c9                   	leave  
c0101d13:	c3                   	ret    

c0101d14 <do_syscall>:

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101d14:	55                   	push   %ebp
c0101d15:	89 e5                	mov    %esp,%ebp
c0101d17:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d20:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101d25:	0f 84 d3 01 00 00    	je     c0101efe <do_syscall+0x1ea>
c0101d2b:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101d30:	77 5e                	ja     c0101d90 <do_syscall+0x7c>
c0101d32:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101d37:	0f 84 6b 01 00 00    	je     c0101ea8 <do_syscall+0x194>
c0101d3d:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101d42:	77 26                	ja     c0101d6a <do_syscall+0x56>
c0101d44:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101d49:	0f 84 45 01 00 00    	je     c0101e94 <do_syscall+0x180>
c0101d4f:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101d54:	0f 87 44 01 00 00    	ja     c0101e9e <do_syscall+0x18a>
c0101d5a:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101d5f:	0f 84 15 01 00 00    	je     c0101e7a <do_syscall+0x166>
c0101d65:	e9 e7 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
c0101d6a:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101d6f:	0f 84 69 01 00 00    	je     c0101ede <do_syscall+0x1ca>
c0101d75:	3d 14 05 00 00       	cmp    $0x514,%eax
c0101d7a:	0f 84 8d 01 00 00    	je     c0101f0d <do_syscall+0x1f9>
c0101d80:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101d85:	0f 84 2c 01 00 00    	je     c0101eb7 <do_syscall+0x1a3>
c0101d8b:	e9 c1 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
c0101d90:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101d95:	0f 84 cb 00 00 00    	je     c0101e66 <do_syscall+0x152>
c0101d9b:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101da0:	77 1e                	ja     c0101dc0 <do_syscall+0xac>
c0101da2:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101da7:	74 52                	je     c0101dfb <do_syscall+0xe7>
c0101da9:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101dae:	77 77                	ja     c0101e27 <do_syscall+0x113>
c0101db0:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101db5:	0f 84 97 00 00 00    	je     c0101e52 <do_syscall+0x13e>
c0101dbb:	e9 91 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
c0101dc0:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101dc5:	74 4a                	je     c0101e11 <do_syscall+0xfd>
c0101dc7:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101dcc:	0f 82 9e 00 00 00    	jb     c0101e70 <do_syscall+0x15c>
c0101dd2:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0101dd7:	0f 85 74 01 00 00    	jne    c0101f51 <do_syscall+0x23d>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx);
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	8b 50 18             	mov    0x18(%eax),%edx
c0101de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de6:	8b 40 10             	mov    0x10(%eax),%eax
c0101de9:	83 ec 08             	sub    $0x8,%esp
c0101dec:	52                   	push   %edx
c0101ded:	50                   	push   %eax
c0101dee:	e8 26 09 00 00       	call   c0102719 <thread_current>
c0101df3:	83 c4 10             	add    $0x10,%esp
		break;
c0101df6:	e9 56 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_PID:
			tf->eax = current->pid;
c0101dfb:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101e00:	8b 90 44 40 00 00    	mov    0x4044(%eax),%edx
c0101e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e09:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101e0c:	e9 40 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_PPID:
			tf->eax = current->ppid;
c0101e11:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101e16:	8b 90 48 40 00 00    	mov    0x4048(%eax),%edx
c0101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1f:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101e22:	e9 2a 01 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0101e27:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101e2c:	c7 80 4c 40 00 00 03 	movl   $0x3,0x404c(%eax)
c0101e33:	00 00 00 
			current->timeslice = tf->ebx*200;
c0101e36:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101e3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0101e3e:	8b 52 10             	mov    0x10(%edx),%edx
c0101e41:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0101e47:	89 90 54 40 00 00    	mov    %edx,0x4054(%eax)
		break;
c0101e4d:	e9 ff 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_HANDOUT:
			current->ts = STOP;
c0101e52:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101e57:	c7 80 4c 40 00 00 02 	movl   $0x2,0x404c(%eax)
c0101e5e:	00 00 00 
		break;
c0101e61:	e9 eb 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_EXIT:
			exit_current();
c0101e66:	e8 ae 09 00 00       	call   c0102819 <exit_current>
		break;
c0101e6b:	e9 e1 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_FORK:
			fork_current();
c0101e70:	e8 32 08 00 00       	call   c01026a7 <fork_current>
		break;
c0101e75:	e9 d7 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7d:	8b 40 10             	mov    0x10(%eax),%eax
c0101e80:	0f be c0             	movsbl %al,%eax
c0101e83:	83 ec 0c             	sub    $0xc,%esp
c0101e86:	50                   	push   %eax
c0101e87:	e8 57 fe ff ff       	call   c0101ce3 <serial_printc>
c0101e8c:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0101e8f:	e9 bd 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_INIT_CACHE:
			initVCache();
c0101e94:	e8 e9 09 00 00       	call   c0102882 <initVCache>
		break;
c0101e99:	e9 b3 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0101e9e:	e8 14 0b 00 00       	call   c01029b7 <clearVRAM>
		break;
c0101ea3:	e9 a9 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0101ea8:	e8 0a 0b 00 00       	call   c01029b7 <clearVRAM>
			flushVCache();
c0101ead:	e8 39 0a 00 00       	call   c01028eb <flushVCache>
		break;
c0101eb2:	e9 9a 00 00 00       	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0101eb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eba:	8b 40 14             	mov    0x14(%eax),%eax
c0101ebd:	0f b6 c0             	movzbl %al,%eax
c0101ec0:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ec3:	8b 52 18             	mov    0x18(%edx),%edx
c0101ec6:	89 d1                	mov    %edx,%ecx
c0101ec8:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ecb:	8b 52 10             	mov    0x10(%edx),%edx
c0101ece:	83 ec 04             	sub    $0x4,%esp
c0101ed1:	50                   	push   %eax
c0101ed2:	51                   	push   %ecx
c0101ed3:	52                   	push   %edx
c0101ed4:	e8 77 0a 00 00       	call   c0102950 <setPixelAt>
c0101ed9:	83 c4 10             	add    $0x10,%esp
		break;
c0101edc:	eb 73                	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0101ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee1:	8b 40 10             	mov    0x10(%eax),%eax
c0101ee4:	0f be c0             	movsbl %al,%eax
c0101ee7:	83 ec 0c             	sub    $0xc,%esp
c0101eea:	50                   	push   %eax
c0101eeb:	e8 21 fd ff ff       	call   c0101c11 <get_key>
c0101ef0:	83 c4 10             	add    $0x10,%esp
c0101ef3:	0f be d0             	movsbl %al,%edx
c0101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef9:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101efc:	eb 53                	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_GET_TICK:
			tf->eax = tick();
c0101efe:	e8 00 0c 00 00       	call   c0102b03 <tick>
c0101f03:	89 c2                	mov    %eax,%edx
c0101f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f08:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0101f0b:	eb 44                	jmp    c0101f51 <do_syscall+0x23d>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101f0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101f14:	eb 34                	jmp    c0101f4a <do_syscall+0x236>
				if(!timer_handlers[i].used){
c0101f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f19:	8b 04 c5 04 47 1b c0 	mov    -0x3fe4b8fc(,%eax,8),%eax
c0101f20:	85 c0                	test   %eax,%eax
c0101f22:	75 22                	jne    c0101f46 <do_syscall+0x232>
					timer_handlers[i].ptr = (void*)tf->ebx;
c0101f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f27:	8b 40 10             	mov    0x10(%eax),%eax
c0101f2a:	89 c2                	mov    %eax,%edx
c0101f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f2f:	89 14 c5 00 47 1b c0 	mov    %edx,-0x3fe4b900(,%eax,8)
					timer_handlers[i].used = 1;
c0101f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f39:	c7 04 c5 04 47 1b c0 	movl   $0x1,-0x3fe4b8fc(,%eax,8)
c0101f40:	01 00 00 00 
					break;
c0101f44:	eb 0a                	jmp    c0101f50 <do_syscall+0x23c>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101f46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101f4a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101f4e:	7e c6                	jle    c0101f16 <do_syscall+0x202>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c0101f50:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0101f51:	c9                   	leave  
c0101f52:	c3                   	ret    

c0101f53 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101f53:	55                   	push   %ebp
c0101f54:	89 e5                	mov    %esp,%ebp
c0101f56:	83 ec 10             	sub    $0x10,%esp
c0101f59:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f63:	89 c2                	mov    %eax,%edx
c0101f65:	ec                   	in     (%dx),%al
c0101f66:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101f69:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101f6d:	0f b6 c0             	movzbl %al,%eax
c0101f70:	83 e0 20             	and    $0x20,%eax
c0101f73:	85 c0                	test   %eax,%eax
c0101f75:	0f 95 c0             	setne  %al
c0101f78:	0f b6 c0             	movzbl %al,%eax
}
c0101f7b:	c9                   	leave  
c0101f7c:	c3                   	ret    

c0101f7d <serial_printc>:

static inline
void serial_printc(char ch) {
c0101f7d:	55                   	push   %ebp
c0101f7e:	89 e5                	mov    %esp,%ebp
c0101f80:	83 ec 14             	sub    $0x14,%esp
c0101f83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f86:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101f89:	90                   	nop
c0101f8a:	e8 c4 ff ff ff       	call   c0101f53 <serial_idle>
c0101f8f:	85 c0                	test   %eax,%eax
c0101f91:	74 f7                	je     c0101f8a <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101f93:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101f97:	0f b6 c0             	movzbl %al,%eax
c0101f9a:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101fa1:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101fa4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101fa8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101fab:	ee                   	out    %al,(%dx)
}
c0101fac:	c9                   	leave  
c0101fad:	c3                   	ret    

c0101fae <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101fae:	55                   	push   %ebp
c0101faf:	89 e5                	mov    %esp,%ebp
c0101fb1:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101fb4:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101fba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbd:	83 ec 04             	sub    $0x4,%esp
c0101fc0:	ff 75 f4             	pushl  -0xc(%ebp)
c0101fc3:	50                   	push   %eax
c0101fc4:	68 7d 1f 10 c0       	push   $0xc0101f7d
c0101fc9:	e8 b9 0c 00 00       	call   c0102c87 <vfprintf>
c0101fce:	83 c4 10             	add    $0x10,%esp
}
c0101fd1:	c9                   	leave  
c0101fd2:	c3                   	ret    

c0101fd3 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101fd3:	55                   	push   %ebp
c0101fd4:	89 e5                	mov    %esp,%ebp
c0101fd6:	57                   	push   %edi
c0101fd7:	56                   	push   %esi
c0101fd8:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101fd9:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101fdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101fe2:	89 c1                	mov    %eax,%ecx
c0101fe4:	89 d6                	mov    %edx,%esi
c0101fe6:	89 df                	mov    %ebx,%edi
c0101fe8:	fc                   	cld    
c0101fe9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101feb:	5b                   	pop    %ebx
c0101fec:	5e                   	pop    %esi
c0101fed:	5f                   	pop    %edi
c0101fee:	5d                   	pop    %ebp
c0101fef:	c3                   	ret    

c0101ff0 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101ff0:	55                   	push   %ebp
c0101ff1:	89 e5                	mov    %esp,%ebp
c0101ff3:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101ff6:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ff9:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101ffe:	77 16                	ja     c0102016 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102000:	ff 75 10             	pushl  0x10(%ebp)
c0102003:	68 10 31 10 c0       	push   $0xc0103110
c0102008:	ff 75 0c             	pushl  0xc(%ebp)
c010200b:	ff 75 08             	pushl  0x8(%ebp)
c010200e:	e8 9b ff ff ff       	call   c0101fae <printk>
c0102013:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0102016:	8b 45 10             	mov    0x10(%ebp),%eax
c0102019:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010201e:	c9                   	leave  
c010201f:	c3                   	ret    

c0102020 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0102020:	55                   	push   %ebp
c0102021:	89 e5                	mov    %esp,%ebp
c0102023:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0102026:	8b 45 10             	mov    0x10(%ebp),%eax
c0102029:	c1 e8 0c             	shr    $0xc,%eax
c010202c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102031:	76 13                	jbe    c0102046 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0102033:	83 ec 08             	sub    $0x8,%esp
c0102036:	ff 75 10             	pushl  0x10(%ebp)
c0102039:	68 34 31 10 c0       	push   $0xc0103134
c010203e:	e8 6b ff ff ff       	call   c0101fae <printk>
c0102043:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0102046:	8b 45 10             	mov    0x10(%ebp),%eax
c0102049:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010204e:	c9                   	leave  
c010204f:	c3                   	ret    

c0102050 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0102050:	55                   	push   %ebp
c0102051:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0102053:	8b 45 08             	mov    0x8(%ebp),%eax
c0102056:	ba 00 47 17 c0       	mov    $0xc0174700,%edx
c010205b:	29 d0                	sub    %edx,%eax
c010205d:	c1 f8 03             	sar    $0x3,%eax
c0102060:	c1 e0 0c             	shl    $0xc,%eax
}
c0102063:	5d                   	pop    %ebp
c0102064:	c3                   	ret    

c0102065 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0102065:	55                   	push   %ebp
c0102066:	89 e5                	mov    %esp,%ebp
c0102068:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010206b:	8b 45 08             	mov    0x8(%ebp),%eax
c010206e:	c1 e8 0c             	shr    $0xc,%eax
c0102071:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102076:	76 10                	jbe    c0102088 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0102078:	83 ec 0c             	sub    $0xc,%esp
c010207b:	68 58 31 10 c0       	push   $0xc0103158
c0102080:	e8 29 ff ff ff       	call   c0101fae <printk>
c0102085:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0102088:	8b 45 08             	mov    0x8(%ebp),%eax
c010208b:	c1 e8 0c             	shr    $0xc,%eax
c010208e:	c1 e0 03             	shl    $0x3,%eax
c0102091:	05 00 47 17 c0       	add    $0xc0174700,%eax
}
c0102096:	c9                   	leave  
c0102097:	c3                   	ret    

c0102098 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0102098:	55                   	push   %ebp
c0102099:	89 e5                	mov    %esp,%ebp
c010209b:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c010209e:	ff 75 08             	pushl  0x8(%ebp)
c01020a1:	e8 aa ff ff ff       	call   c0102050 <page2pa>
c01020a6:	83 c4 04             	add    $0x4,%esp
c01020a9:	83 ec 04             	sub    $0x4,%esp
c01020ac:	50                   	push   %eax
c01020ad:	6a 52                	push   $0x52
c01020af:	68 77 31 10 c0       	push   $0xc0103177
c01020b4:	e8 67 ff ff ff       	call   c0102020 <_kaddr>
c01020b9:	83 c4 10             	add    $0x10,%esp
}
c01020bc:	c9                   	leave  
c01020bd:	c3                   	ret    

c01020be <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c01020be:	55                   	push   %ebp
c01020bf:	89 e5                	mov    %esp,%ebp
c01020c1:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c01020c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c01020cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ce:	8b 00                	mov    (%eax),%eax
c01020d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c01020d3:	eb 10                	jmp    c01020e5 <ll_len+0x27>
		p = p->next;
c01020d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020d8:	8b 80 60 40 00 00    	mov    0x4060(%eax),%eax
c01020de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c01020e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c01020e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01020e9:	75 ea                	jne    c01020d5 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c01020eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01020ee:	c9                   	leave  
c01020ef:	c3                   	ret    

c01020f0 <ll_pop>:
PCB* ll_pop(PCB** head){
c01020f0:	55                   	push   %ebp
c01020f1:	89 e5                	mov    %esp,%ebp
c01020f3:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c01020f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f9:	8b 00                	mov    (%eax),%eax
c01020fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c01020fe:	83 ec 08             	sub    $0x8,%esp
c0102101:	ff 75 f4             	pushl  -0xc(%ebp)
c0102104:	ff 75 08             	pushl  0x8(%ebp)
c0102107:	e8 a4 00 00 00       	call   c01021b0 <ll_delete>
c010210c:	83 c4 10             	add    $0x10,%esp
	return p;
c010210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102112:	c9                   	leave  
c0102113:	c3                   	ret    

c0102114 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0102114:	55                   	push   %ebp
c0102115:	89 e5                	mov    %esp,%ebp
c0102117:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010211a:	8b 45 08             	mov    0x8(%ebp),%eax
c010211d:	8b 00                	mov    (%eax),%eax
c010211f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0102122:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102126:	75 0f                	jne    c0102137 <ll_push+0x23>
		*head = p;
c0102128:	8b 45 08             	mov    0x8(%ebp),%eax
c010212b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010212e:	89 10                	mov    %edx,(%eax)
		return 0;
c0102130:	b8 00 00 00 00       	mov    $0x0,%eax
c0102135:	eb 19                	jmp    c0102150 <ll_push+0x3c>
	}else{
		*head = p;
c0102137:	8b 45 08             	mov    0x8(%ebp),%eax
c010213a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010213d:	89 10                	mov    %edx,(%eax)
		p->next = h;
c010213f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102142:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102145:	89 90 60 40 00 00    	mov    %edx,0x4060(%eax)
		return 1;
c010214b:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0102150:	c9                   	leave  
c0102151:	c3                   	ret    

c0102152 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0102152:	55                   	push   %ebp
c0102153:	89 e5                	mov    %esp,%ebp
c0102155:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0102158:	8b 45 08             	mov    0x8(%ebp),%eax
c010215b:	8b 00                	mov    (%eax),%eax
c010215d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0102160:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102163:	c7 80 60 40 00 00 00 	movl   $0x0,0x4060(%eax)
c010216a:	00 00 00 
	if(h == NULL){
c010216d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102171:	75 0f                	jne    c0102182 <ll_entail+0x30>
		*head = p;
c0102173:	8b 45 08             	mov    0x8(%ebp),%eax
c0102176:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102179:	89 10                	mov    %edx,(%eax)
		return 0;
c010217b:	b8 00 00 00 00       	mov    $0x0,%eax
c0102180:	eb 2c                	jmp    c01021ae <ll_entail+0x5c>
	}else{
		while(h->next){
c0102182:	eb 0c                	jmp    c0102190 <ll_entail+0x3e>
			h = h->next;
c0102184:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102187:	8b 80 60 40 00 00    	mov    0x4060(%eax),%eax
c010218d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	8b 80 60 40 00 00    	mov    0x4060(%eax),%eax
c0102199:	85 c0                	test   %eax,%eax
c010219b:	75 e7                	jne    c0102184 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01021a3:	89 90 60 40 00 00    	mov    %edx,0x4060(%eax)
		return 1;
c01021a9:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01021ae:	c9                   	leave  
c01021af:	c3                   	ret    

c01021b0 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c01021b0:	55                   	push   %ebp
c01021b1:	89 e5                	mov    %esp,%ebp
c01021b3:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c01021b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b9:	8b 00                	mov    (%eax),%eax
c01021bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01021be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c01021c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01021c9:	75 07                	jne    c01021d2 <ll_delete+0x22>
			return 0;
c01021cb:	b8 00 00 00 00       	mov    $0x0,%eax
c01021d0:	eb 59                	jmp    c010222b <ll_delete+0x7b>
		if(sleep == p)
c01021d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01021d8:	75 09                	jne    c01021e3 <ll_delete+0x33>
			break;
c01021da:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c01021db:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01021df:	75 26                	jne    c0102207 <ll_delete+0x57>
c01021e1:	eb 14                	jmp    c01021f7 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c01021e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c01021e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ec:	8b 80 60 40 00 00    	mov    0x4060(%eax),%eax
c01021f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c01021f5:	eb ce                	jmp    c01021c5 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c01021f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021fa:	8b 90 60 40 00 00    	mov    0x4060(%eax),%edx
c0102200:	8b 45 08             	mov    0x8(%ebp),%eax
c0102203:	89 10                	mov    %edx,(%eax)
c0102205:	eb 12                	jmp    c0102219 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0102207:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220a:	8b 90 60 40 00 00    	mov    0x4060(%eax),%edx
c0102210:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102213:	89 90 60 40 00 00    	mov    %edx,0x4060(%eax)
	sleep->next = NULL;
c0102219:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010221c:	c7 80 60 40 00 00 00 	movl   $0x0,0x4060(%eax)
c0102223:	00 00 00 
	return 1;
c0102226:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010222b:	c9                   	leave  
c010222c:	c3                   	ret    

c010222d <init_pcb_pool>:

void init_pcb_pool()
{
c010222d:	55                   	push   %ebp
c010222e:	89 e5                	mov    %esp,%ebp
c0102230:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102233:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010223a:	eb 1d                	jmp    c0102259 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c010223c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223f:	69 c0 68 40 00 00    	imul   $0x4068,%eax,%eax
c0102245:	05 40 40 00 00       	add    $0x4040,%eax
c010224a:	05 40 7f 1c c0       	add    $0xc01c7f40,%eax
c010224f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102255:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102259:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0102260:	76 da                	jbe    c010223c <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0102262:	c9                   	leave  
c0102263:	c3                   	ret    

c0102264 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0102264:	55                   	push   %ebp
c0102265:	89 e5                	mov    %esp,%ebp
c0102267:	83 ec 24             	sub    $0x24,%esp
c010226a:	8b 45 14             	mov    0x14(%ebp),%eax
c010226d:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0102270:	8b 45 08             	mov    0x8(%ebp),%eax
c0102273:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c0102279:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c010227c:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0102280:	75 46                	jne    c01022c8 <init_pcb+0x64>
		tf->ds = GD_KD;
c0102282:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102285:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c010228c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010228f:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0102296:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102299:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c010229f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022a2:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c01022a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022ac:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c01022b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022b6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01022bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022bf:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c01022c6:	eb 4a                	jmp    c0102312 <init_pcb+0xae>
	}else
	if(pri == 3){
c01022c8:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c01022cc:	75 44                	jne    c0102312 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c01022ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022d1:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c01022d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022db:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c01022e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022e5:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c01022eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022ee:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c01022f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022f8:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c01022ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102302:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0102308:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010230b:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0102312:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102315:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102318:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c010231b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010231e:	8b 55 10             	mov    0x10(%ebp),%edx
c0102321:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0102324:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0102328:	75 59                	jne    c0102383 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c010232a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0102330:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102333:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0102336:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c010233d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102344:	eb 26                	jmp    c010236c <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0102346:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102349:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102353:	01 c2                	add    %eax,%edx
c0102355:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102358:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c010235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102362:	01 c8                	add    %ecx,%eax
c0102364:	8b 00                	mov    (%eax),%eax
c0102366:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0102368:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010236c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010236f:	c1 e8 02             	shr    $0x2,%eax
c0102372:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102375:	77 cf                	ja     c0102346 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0102377:	8b 45 08             	mov    0x8(%ebp),%eax
c010237a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010237d:	89 90 58 40 00 00    	mov    %edx,0x4058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c0102383:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0102387:	0f 95 c0             	setne  %al
c010238a:	0f b6 d0             	movzbl %al,%edx
c010238d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102390:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0102396:	c9                   	leave  
c0102397:	c3                   	ret    

c0102398 <pcb_create>:

PCB* pcb_create()
{
c0102398:	55                   	push   %ebp
c0102399:	89 e5                	mov    %esp,%ebp
c010239b:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010239e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023a5:	eb 1f                	jmp    c01023c6 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c01023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023aa:	69 c0 68 40 00 00    	imul   $0x4068,%eax,%eax
c01023b0:	05 40 40 00 00       	add    $0x4040,%eax
c01023b5:	05 40 7f 1c c0       	add    $0xc01c7f40,%eax
c01023ba:	8b 00                	mov    (%eax),%eax
c01023bc:	85 c0                	test   %eax,%eax
c01023be:	75 02                	jne    c01023c2 <pcb_create+0x2a>
c01023c0:	eb 0d                	jmp    c01023cf <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01023c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023c6:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01023cd:	76 d8                	jbe    c01023a7 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023d2:	69 c0 68 40 00 00    	imul   $0x4068,%eax,%eax
c01023d8:	05 40 7f 1c c0       	add    $0xc01c7f40,%eax
c01023dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c01023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023e3:	6b c0 4c             	imul   $0x4c,%eax,%eax
c01023e6:	8d 90 40 56 1b c0    	lea    -0x3fe4a9c0(%eax),%edx
c01023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023ef:	89 90 58 40 00 00    	mov    %edx,0x4058(%eax)
	p->used = 1;
c01023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f8:	c7 80 40 40 00 00 01 	movl   $0x1,0x4040(%eax)
c01023ff:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0102402:	83 ec 0c             	sub    $0xc,%esp
c0102405:	6a 01                	push   $0x1
c0102407:	e8 77 e4 ff ff       	call   c0100883 <page_alloc>
c010240c:	83 c4 10             	add    $0x10,%esp
c010240f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0102412:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102416:	75 07                	jne    c010241f <pcb_create+0x87>
c0102418:	b8 00 00 00 00       	mov    $0x0,%eax
c010241d:	eb 77                	jmp    c0102496 <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c010241f:	83 ec 0c             	sub    $0xc,%esp
c0102422:	ff 75 ec             	pushl  -0x14(%ebp)
c0102425:	e8 6e fc ff ff       	call   c0102098 <page2kva>
c010242a:	83 c4 10             	add    $0x10,%esp
c010242d:	89 c2                	mov    %eax,%edx
c010242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102432:	89 90 5c 40 00 00    	mov    %edx,0x405c(%eax)
	p->pid = pid;
c0102438:	8b 15 ac 50 15 c0    	mov    0xc01550ac,%edx
c010243e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102441:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	p->timeslice = 0;
c0102447:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010244a:	c7 80 54 40 00 00 00 	movl   $0x0,0x4054(%eax)
c0102451:	00 00 00 
	//p->ts = READY;
	pid ++;
c0102454:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102459:	83 c0 01             	add    $0x1,%eax
c010245c:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0102461:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102464:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0102468:	8d 50 01             	lea    0x1(%eax),%edx
c010246b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010246e:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0102472:	8b 15 c0 46 17 c0    	mov    0xc01746c0,%edx
c0102478:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010247b:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0102481:	83 ec 04             	sub    $0x4,%esp
c0102484:	68 00 10 00 00       	push   $0x1000
c0102489:	52                   	push   %edx
c010248a:	50                   	push   %eax
c010248b:	e8 43 fb ff ff       	call   c0101fd3 <memcpy>
c0102490:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0102493:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102496:	c9                   	leave  
c0102497:	c3                   	ret    

c0102498 <enready_pcb>:

void enready_pcb(PCB* pcb){
c0102498:	55                   	push   %ebp
c0102499:	89 e5                	mov    %esp,%ebp
c010249b:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c010249e:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01024a3:	85 c0                	test   %eax,%eax
c01024a5:	75 18                	jne    c01024bf <enready_pcb+0x27>
		ready_list = pcb;
c01024a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024aa:	a3 b4 50 15 c0       	mov    %eax,0xc01550b4
		ready_list->tail = pcb;
c01024af:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01024b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01024b7:	89 90 64 40 00 00    	mov    %edx,0x4064(%eax)
c01024bd:	eb 32                	jmp    c01024f1 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01024bf:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01024c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01024c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ca:	a3 b4 50 15 c0       	mov    %eax,0xc01550b4
		ready_list->next = temp;
c01024cf:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01024d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01024d7:	89 90 60 40 00 00    	mov    %edx,0x4060(%eax)
		ready_list->tail = temp->tail;
c01024dd:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01024e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01024e5:	8b 92 64 40 00 00    	mov    0x4064(%edx),%edx
c01024eb:	89 90 64 40 00 00    	mov    %edx,0x4064(%eax)
	}
}
c01024f1:	c9                   	leave  
c01024f2:	c3                   	ret    

c01024f3 <switch_pcb>:

void switch_pcb(PCB* pcb){
c01024f3:	55                   	push   %ebp
c01024f4:	89 e5                	mov    %esp,%ebp
c01024f6:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01024f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fc:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
	lcr3(PADDR(pcb -> pgdir));
c0102501:	8b 45 08             	mov    0x8(%ebp),%eax
c0102504:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c010250a:	83 ec 04             	sub    $0x4,%esp
c010250d:	50                   	push   %eax
c010250e:	68 af 00 00 00       	push   $0xaf
c0102513:	68 8d 31 10 c0       	push   $0xc010318d
c0102518:	e8 d3 fa ff ff       	call   c0101ff0 <_paddr>
c010251d:	83 c4 10             	add    $0x10,%esp
c0102520:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102526:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0102529:	83 ec 0c             	sub    $0xc,%esp
c010252c:	ff 75 08             	pushl  0x8(%ebp)
c010252f:	e8 28 de ff ff       	call   c010035c <enter_pcb>
c0102534:	83 c4 10             	add    $0x10,%esp
}
c0102537:	c9                   	leave  
c0102538:	c3                   	ret    

c0102539 <free_pcb>:
void free_pcb(PCB* pcb){
c0102539:	55                   	push   %ebp
c010253a:	89 e5                	mov    %esp,%ebp
c010253c:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c010253f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102542:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0102548:	83 ec 0c             	sub    $0xc,%esp
c010254b:	50                   	push   %eax
c010254c:	e8 96 e8 ff ff       	call   c0100de7 <free_pgdir>
c0102551:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0102554:	8b 45 08             	mov    0x8(%ebp),%eax
c0102557:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c010255d:	83 ec 04             	sub    $0x4,%esp
c0102560:	50                   	push   %eax
c0102561:	68 b8 00 00 00       	push   $0xb8
c0102566:	68 8d 31 10 c0       	push   $0xc010318d
c010256b:	e8 80 fa ff ff       	call   c0101ff0 <_paddr>
c0102570:	83 c4 10             	add    $0x10,%esp
c0102573:	83 ec 0c             	sub    $0xc,%esp
c0102576:	50                   	push   %eax
c0102577:	e8 e9 fa ff ff       	call   c0102065 <pa2page>
c010257c:	83 c4 10             	add    $0x10,%esp
c010257f:	83 ec 0c             	sub    $0xc,%esp
c0102582:	50                   	push   %eax
c0102583:	e8 83 e3 ff ff       	call   c010090b <page_decref>
c0102588:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c010258b:	8b 45 08             	mov    0x8(%ebp),%eax
c010258e:	c7 80 40 40 00 00 00 	movl   $0x0,0x4040(%eax)
c0102595:	00 00 00 

}
c0102598:	c9                   	leave  
c0102599:	c3                   	ret    

c010259a <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c010259a:	55                   	push   %ebp
c010259b:	89 e5                	mov    %esp,%ebp
c010259d:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c01025a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01025a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a6:	68 10 10 00 00       	push   $0x1010
c01025ab:	52                   	push   %edx
c01025ac:	50                   	push   %eax
c01025ad:	e8 21 fa ff ff       	call   c0101fd3 <memcpy>
c01025b2:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c01025b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025b8:	8b 90 54 40 00 00    	mov    0x4054(%eax),%edx
c01025be:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c1:	89 90 54 40 00 00    	mov    %edx,0x4054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c01025c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ca:	05 20 20 00 00       	add    $0x2020,%eax
c01025cf:	89 c2                	mov    %eax,%edx
c01025d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025d4:	05 20 20 00 00       	add    $0x2020,%eax
c01025d9:	29 c2                	sub    %eax,%edx
c01025db:	89 d0                	mov    %edx,%eax
c01025dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c01025e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025e3:	8b 90 58 40 00 00    	mov    0x4058(%eax),%edx
c01025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025ec:	01 c2                	add    %eax,%edx
c01025ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f1:	89 90 58 40 00 00    	mov    %edx,0x4058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c01025f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025fa:	8b 90 50 40 00 00    	mov    0x4050(%eax),%edx
c0102600:	8b 45 08             	mov    0x8(%ebp),%eax
c0102603:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)

	if(dst->tt == KERNEL || dst->tt == THREAD){
c0102609:	8b 45 08             	mov    0x8(%ebp),%eax
c010260c:	8b 80 50 40 00 00    	mov    0x4050(%eax),%eax
c0102612:	85 c0                	test   %eax,%eax
c0102614:	74 0e                	je     c0102624 <copy_pcb+0x8a>
c0102616:	8b 45 08             	mov    0x8(%ebp),%eax
c0102619:	8b 80 50 40 00 00    	mov    0x4050(%eax),%eax
c010261f:	83 f8 02             	cmp    $0x2,%eax
c0102622:	75 62                	jne    c0102686 <copy_pcb+0xec>
		
		dst->tf->ebp += offset;
c0102624:	8b 45 08             	mov    0x8(%ebp),%eax
c0102627:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c010262d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102630:	8b 92 58 40 00 00    	mov    0x4058(%edx),%edx
c0102636:	8b 4a 08             	mov    0x8(%edx),%ecx
c0102639:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010263c:	01 ca                	add    %ecx,%edx
c010263e:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0102641:	8b 45 08             	mov    0x8(%ebp),%eax
c0102644:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c010264a:	8b 40 08             	mov    0x8(%eax),%eax
c010264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0102650:	eb 17                	jmp    c0102669 <copy_pcb+0xcf>
			*(ptr) += offset;
c0102652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102655:	8b 10                	mov    (%eax),%edx
c0102657:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010265a:	01 c2                	add    %eax,%edx
c010265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010265f:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0102661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102664:	8b 00                	mov    (%eax),%eax
c0102666:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL || dst->tt == THREAD){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0102669:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010266c:	8b 00                	mov    (%eax),%eax
c010266e:	85 c0                	test   %eax,%eax
c0102670:	75 e0                	jne    c0102652 <copy_pcb+0xb8>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0102672:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102675:	8b 90 4c 40 00 00    	mov    0x404c(%eax),%edx
c010267b:	8b 45 08             	mov    0x8(%ebp),%eax
c010267e:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
	dst->tf = (void*)src->tf + offset;
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;

	if(dst->tt == KERNEL || dst->tt == THREAD){
c0102684:	eb 1f                	jmp    c01026a5 <copy_pcb+0x10b>
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
	}else{
		copy_pgdir(dst->pgdir, src->pgdir);
c0102686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102689:	8b 90 5c 40 00 00    	mov    0x405c(%eax),%edx
c010268f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102692:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0102698:	83 ec 08             	sub    $0x8,%esp
c010269b:	52                   	push   %edx
c010269c:	50                   	push   %eax
c010269d:	e8 90 e4 ff ff       	call   c0100b32 <copy_pgdir>
c01026a2:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c01026a5:	c9                   	leave  
c01026a6:	c3                   	ret    

c01026a7 <fork_current>:

void switch_proc();
void fork_current(){
c01026a7:	55                   	push   %ebp
c01026a8:	89 e5                	mov    %esp,%ebp
c01026aa:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c01026ad:	e8 e6 fc ff ff       	call   c0102398 <pcb_create>
c01026b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c01026b5:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01026ba:	8b 90 44 40 00 00    	mov    0x4044(%eax),%edx
c01026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026c3:	89 90 48 40 00 00    	mov    %edx,0x4048(%eax)

	copy_pcb(son, current);
c01026c9:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01026ce:	83 ec 08             	sub    $0x8,%esp
c01026d1:	50                   	push   %eax
c01026d2:	ff 75 f4             	pushl  -0xc(%ebp)
c01026d5:	e8 c0 fe ff ff       	call   c010259a <copy_pcb>
c01026da:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c01026dd:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01026e2:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01026e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01026eb:	8b 92 44 40 00 00    	mov    0x4044(%edx),%edx
c01026f1:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026f7:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01026fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c0102704:	83 ec 08             	sub    $0x8,%esp
c0102707:	ff 75 f4             	pushl  -0xc(%ebp)
c010270a:	68 b4 50 15 c0       	push   $0xc01550b4
c010270f:	e8 00 fa ff ff       	call   c0102114 <ll_push>
c0102714:	83 c4 10             	add    $0x10,%esp
}
c0102717:	c9                   	leave  
c0102718:	c3                   	ret    

c0102719 <thread_current>:

void thread_current(uint32_t entry, uint32_t esp){
c0102719:	55                   	push   %ebp
c010271a:	89 e5                	mov    %esp,%ebp
c010271c:	83 ec 18             	sub    $0x18,%esp
	printk("ahh? %x\n", entry);
c010271f:	83 ec 08             	sub    $0x8,%esp
c0102722:	ff 75 08             	pushl  0x8(%ebp)
c0102725:	68 a2 31 10 c0       	push   $0xc01031a2
c010272a:	e8 7f f8 ff ff       	call   c0101fae <printk>
c010272f:	83 c4 10             	add    $0x10,%esp
	PCB* son = pcb_create();
c0102732:	e8 61 fc ff ff       	call   c0102398 <pcb_create>
c0102737:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	son->tt = THREAD;
c010273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010273d:	c7 80 50 40 00 00 02 	movl   $0x2,0x4050(%eax)
c0102744:	00 00 00 



	son->ppid = current->pid;
c0102747:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010274c:	8b 90 44 40 00 00    	mov    0x4044(%eax),%edx
c0102752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102755:	89 90 48 40 00 00    	mov    %edx,0x4048(%eax)

	copy_pcb(son, current);
c010275b:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102760:	83 ec 08             	sub    $0x8,%esp
c0102763:	50                   	push   %eax
c0102764:	ff 75 f4             	pushl  -0xc(%ebp)
c0102767:	e8 2e fe ff ff       	call   c010259a <copy_pcb>
c010276c:	83 c4 10             	add    $0x10,%esp

	memcpy(son->pgdir, current->pgdir, PGSIZE);
c010276f:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102774:	8b 90 5c 40 00 00    	mov    0x405c(%eax),%edx
c010277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010277d:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c0102783:	83 ec 04             	sub    $0x4,%esp
c0102786:	68 00 10 00 00       	push   $0x1000
c010278b:	52                   	push   %edx
c010278c:	50                   	push   %eax
c010278d:	e8 41 f8 ff ff       	call   c0101fd3 <memcpy>
c0102792:	83 c4 10             	add    $0x10,%esp
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0102795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102798:	8d 90 00 c0 ff ff    	lea    -0x4000(%eax),%edx
c010279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027a1:	8b 80 5c 40 00 00    	mov    0x405c(%eax),%eax
c01027a7:	83 ec 04             	sub    $0x4,%esp
c01027aa:	68 00 40 00 00       	push   $0x4000
c01027af:	52                   	push   %edx
c01027b0:	50                   	push   %eax
c01027b1:	e8 db de ff ff       	call   c0100691 <mm_alloc>
c01027b6:	83 c4 10             	add    $0x10,%esp
	//son->tf->esp = esp-0x1FF;
	son->tf->esp = esp-0x1FF;
c01027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027bc:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01027c5:	81 ea ff 01 00 00    	sub    $0x1ff,%edx
c01027cb:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c01027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027d1:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01027d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01027da:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c01027dd:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01027e2:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01027e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01027eb:	8b 92 44 40 00 00    	mov    0x4044(%edx),%edx
c01027f1:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027f7:	8b 80 58 40 00 00    	mov    0x4058(%eax),%eax
c01027fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	ll_push(&ready_list, son);
c0102804:	83 ec 08             	sub    $0x8,%esp
c0102807:	ff 75 f4             	pushl  -0xc(%ebp)
c010280a:	68 b4 50 15 c0       	push   $0xc01550b4
c010280f:	e8 00 f9 ff ff       	call   c0102114 <ll_push>
c0102814:	83 c4 10             	add    $0x10,%esp
}
c0102817:	c9                   	leave  
c0102818:	c3                   	ret    

c0102819 <exit_current>:

void exit_current(){
c0102819:	55                   	push   %ebp
c010281a:	89 e5                	mov    %esp,%ebp
c010281c:	83 ec 18             	sub    $0x18,%esp
	free_pcb(current);
c010281f:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102824:	83 ec 0c             	sub    $0xc,%esp
c0102827:	50                   	push   %eax
c0102828:	e8 0c fd ff ff       	call   c0102539 <free_pcb>
c010282d:	83 c4 10             	add    $0x10,%esp
	lcr3(PADDR(kern_pgdir));
c0102830:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0102835:	83 ec 04             	sub    $0x4,%esp
c0102838:	50                   	push   %eax
c0102839:	68 03 01 00 00       	push   $0x103
c010283e:	68 8d 31 10 c0       	push   $0xc010318d
c0102843:	e8 a8 f7 ff ff       	call   c0101ff0 <_paddr>
c0102848:	83 c4 10             	add    $0x10,%esp
c010284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102851:	0f 22 d8             	mov    %eax,%cr3
	current = NULL;
c0102854:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c010285b:	00 00 00 
	do_scheduler();
c010285e:	e8 ae e6 ff ff       	call   c0100f11 <do_scheduler>
c0102863:	c9                   	leave  
c0102864:	c3                   	ret    

c0102865 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0102865:	55                   	push   %ebp
c0102866:	89 e5                	mov    %esp,%ebp
c0102868:	57                   	push   %edi
c0102869:	56                   	push   %esi
c010286a:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c010286b:	8b 45 10             	mov    0x10(%ebp),%eax
c010286e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102871:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102874:	89 c1                	mov    %eax,%ecx
c0102876:	89 d6                	mov    %edx,%esi
c0102878:	89 df                	mov    %ebx,%edi
c010287a:	fc                   	cld    
c010287b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c010287d:	5b                   	pop    %ebx
c010287e:	5e                   	pop    %esi
c010287f:	5f                   	pop    %edi
c0102880:	5d                   	pop    %ebp
c0102881:	c3                   	ret    

c0102882 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0102882:	55                   	push   %ebp
c0102883:	89 e5                	mov    %esp,%ebp
c0102885:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102888:	68 80 3e 00 00       	push   $0x3e80
c010288d:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102892:	68 c0 50 15 c0       	push   $0xc01550c0
c0102897:	e8 c9 ff ff ff       	call   c0102865 <memcpy>
c010289c:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c010289f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01028a6:	eb 0f                	jmp    c01028b7 <initVCache+0x35>
		VDIRTY[x] = 0;
c01028a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ab:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c01028b0:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c01028b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01028b7:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01028be:	7e e8                	jle    c01028a8 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c01028c0:	c9                   	leave  
c01028c1:	c3                   	ret    

c01028c2 <refreshVCache>:
void refreshVCache(){
c01028c2:	55                   	push   %ebp
c01028c3:	89 e5                	mov    %esp,%ebp
c01028c5:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c01028c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01028cf:	eb 0f                	jmp    c01028e0 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c01028d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028d4:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c01028d9:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c01028dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01028e0:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01028e7:	7e e8                	jle    c01028d1 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c01028e9:	c9                   	leave  
c01028ea:	c3                   	ret    

c01028eb <flushVCache>:
void flushVCache(){
c01028eb:	55                   	push   %ebp
c01028ec:	89 e5                	mov    %esp,%ebp
c01028ee:	53                   	push   %ebx
c01028ef:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c01028f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01028f9:	eb 47                	jmp    c0102942 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c01028fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01028fe:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102903:	0f b6 00             	movzbl (%eax),%eax
c0102906:	84 c0                	test   %al,%al
c0102908:	74 34                	je     c010293e <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c010290a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010290d:	89 d0                	mov    %edx,%eax
c010290f:	c1 e0 02             	shl    $0x2,%eax
c0102912:	01 d0                	add    %edx,%eax
c0102914:	c1 e0 06             	shl    $0x6,%eax
c0102917:	8d 88 c0 50 15 c0    	lea    -0x3feaaf40(%eax),%ecx
c010291d:	8b 1d a8 70 10 c0    	mov    0xc01070a8,%ebx
c0102923:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102926:	89 d0                	mov    %edx,%eax
c0102928:	c1 e0 02             	shl    $0x2,%eax
c010292b:	01 d0                	add    %edx,%eax
c010292d:	c1 e0 06             	shl    $0x6,%eax
c0102930:	01 d8                	add    %ebx,%eax
c0102932:	6a 50                	push   $0x50
c0102934:	51                   	push   %ecx
c0102935:	50                   	push   %eax
c0102936:	e8 2a ff ff ff       	call   c0102865 <memcpy>
c010293b:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c010293e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102942:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102949:	7e b0                	jle    c01028fb <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c010294b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010294e:	c9                   	leave  
c010294f:	c3                   	ret    

c0102950 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0102950:	55                   	push   %ebp
c0102951:	89 e5                	mov    %esp,%ebp
c0102953:	83 ec 04             	sub    $0x4,%esp
c0102956:	8b 45 10             	mov    0x10(%ebp),%eax
c0102959:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c010295c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102960:	78 18                	js     c010297a <setPixelAt+0x2a>
c0102962:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102969:	7f 0f                	jg     c010297a <setPixelAt+0x2a>
c010296b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010296f:	78 09                	js     c010297a <setPixelAt+0x2a>
c0102971:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102978:	7e 02                	jle    c010297c <setPixelAt+0x2c>
c010297a:	eb 34                	jmp    c01029b0 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c010297c:	8b 45 08             	mov    0x8(%ebp),%eax
c010297f:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102984:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0102987:	8b 45 08             	mov    0x8(%ebp),%eax
c010298a:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c010298f:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0102992:	8b 55 08             	mov    0x8(%ebp),%edx
c0102995:	89 d0                	mov    %edx,%eax
c0102997:	c1 e0 02             	shl    $0x2,%eax
c010299a:	01 d0                	add    %edx,%eax
c010299c:	c1 e0 06             	shl    $0x6,%eax
c010299f:	89 c2                	mov    %eax,%edx
c01029a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029a4:	01 c2                	add    %eax,%edx
c01029a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c01029aa:	88 82 c0 50 15 c0    	mov    %al,-0x3feaaf40(%edx)
}
c01029b0:	c9                   	leave  
c01029b1:	c3                   	ret    

c01029b2 <forceClearVRAM>:
void forceClearVRAM(){
c01029b2:	55                   	push   %ebp
c01029b3:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c01029b5:	5d                   	pop    %ebp
c01029b6:	c3                   	ret    

c01029b7 <clearVRAM>:
void clearVRAM(){
c01029b7:	55                   	push   %ebp
c01029b8:	89 e5                	mov    %esp,%ebp
c01029ba:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01029bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01029c4:	eb 4e                	jmp    c0102a14 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c01029c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029c9:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c01029ce:	0f b6 00             	movzbl (%eax),%eax
c01029d1:	0f b6 c0             	movzbl %al,%eax
c01029d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029d7:	81 c2 c0 44 17 c0    	add    $0xc01744c0,%edx
c01029dd:	0f b6 12             	movzbl (%edx),%edx
c01029e0:	0f b6 d2             	movzbl %dl,%edx
c01029e3:	f7 d2                	not    %edx
c01029e5:	21 d0                	and    %edx,%eax
c01029e7:	85 c0                	test   %eax,%eax
c01029e9:	74 25                	je     c0102a10 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c01029eb:	8b 0d a8 70 10 c0    	mov    0xc01070a8,%ecx
c01029f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029f4:	89 d0                	mov    %edx,%eax
c01029f6:	c1 e0 02             	shl    $0x2,%eax
c01029f9:	01 d0                	add    %edx,%eax
c01029fb:	c1 e0 06             	shl    $0x6,%eax
c01029fe:	01 c8                	add    %ecx,%eax
c0102a00:	6a 50                	push   $0x50
c0102a02:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102a07:	50                   	push   %eax
c0102a08:	e8 58 fe ff ff       	call   c0102865 <memcpy>
c0102a0d:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102a10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102a14:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102a1b:	7e a9                	jle    c01029c6 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0102a1d:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102a24:	83 c0 01             	add    $0x1,%eax
c0102a27:	a2 88 46 17 c0       	mov    %al,0xc0174688
	if(stamp==30){
c0102a2c:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102a33:	3c 1e                	cmp    $0x1e,%al
c0102a35:	75 07                	jne    c0102a3e <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0102a37:	c6 05 88 46 17 c0 00 	movb   $0x0,0xc0174688
		//printk("What matters\n");
	}
	if(stamp==0){
c0102a3e:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102a45:	84 c0                	test   %al,%al
c0102a47:	75 14                	jne    c0102a5d <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102a49:	6a 32                	push   $0x32
c0102a4b:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102a50:	68 c0 45 17 c0       	push   $0xc01745c0
c0102a55:	e8 0b fe ff ff       	call   c0102865 <memcpy>
c0102a5a:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0102a5d:	c9                   	leave  
c0102a5e:	c3                   	ret    

c0102a5f <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0102a5f:	55                   	push   %ebp
c0102a60:	89 e5                	mov    %esp,%ebp
c0102a62:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0102a65:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102a6a:	83 c0 01             	add    $0x1,%eax
c0102a6d:	a3 8c 46 17 c0       	mov    %eax,0xc017468c
	current->timeslice ++;
c0102a72:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102a77:	8b 90 54 40 00 00    	mov    0x4054(%eax),%edx
c0102a7d:	83 c2 01             	add    $0x1,%edx
c0102a80:	89 90 54 40 00 00    	mov    %edx,0x4054(%eax)

	PCB *sleep = sleep_list, *cur;
c0102a86:	a1 b8 50 15 c0       	mov    0xc01550b8,%eax
c0102a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0102a8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a92:	75 02                	jne    c0102a96 <do_timer+0x37>
c0102a94:	eb 6b                	jmp    c0102b01 <do_timer+0xa2>
	 	sleep->timeslice --;
c0102a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a99:	8b 80 54 40 00 00    	mov    0x4054(%eax),%eax
c0102a9f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa5:	89 90 54 40 00 00    	mov    %edx,0x4054(%eax)
	 	
	 	cur = sleep;
c0102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aae:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0102ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab4:	8b 80 60 40 00 00    	mov    0x4060(%eax),%eax
c0102aba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0102abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ac0:	8b 80 54 40 00 00    	mov    0x4054(%eax),%eax
c0102ac6:	85 c0                	test   %eax,%eax
c0102ac8:	74 02                	je     c0102acc <do_timer+0x6d>
c0102aca:	eb 33                	jmp    c0102aff <do_timer+0xa0>
	 	cur->ts = READY;
c0102acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102acf:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0102ad6:	00 00 00 
		ll_delete(&sleep_list, cur);
c0102ad9:	83 ec 08             	sub    $0x8,%esp
c0102adc:	ff 75 f0             	pushl  -0x10(%ebp)
c0102adf:	68 b8 50 15 c0       	push   $0xc01550b8
c0102ae4:	e8 c7 f6 ff ff       	call   c01021b0 <ll_delete>
c0102ae9:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0102aec:	83 ec 08             	sub    $0x8,%esp
c0102aef:	ff 75 f0             	pushl  -0x10(%ebp)
c0102af2:	68 b4 50 15 c0       	push   $0xc01550b4
c0102af7:	e8 56 f6 ff ff       	call   c0102152 <ll_entail>
c0102afc:	83 c4 10             	add    $0x10,%esp
	}
c0102aff:	eb 8d                	jmp    c0102a8e <do_timer+0x2f>
}
c0102b01:	c9                   	leave  
c0102b02:	c3                   	ret    

c0102b03 <tick>:
uint32_t tick(){
c0102b03:	55                   	push   %ebp
c0102b04:	89 e5                	mov    %esp,%ebp
	return _tick;
c0102b06:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102b0b:	5d                   	pop    %ebp
c0102b0c:	c3                   	ret    

c0102b0d <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0102b0d:	6a 00                	push   $0x0
c0102b0f:	6a 00                	push   $0x0
c0102b11:	e9 b8 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b16 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0102b16:	6a 00                	push   $0x0
c0102b18:	6a 01                	push   $0x1
c0102b1a:	e9 af 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b1f <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0102b1f:	6a 00                	push   $0x0
c0102b21:	6a 02                	push   $0x2
c0102b23:	e9 a6 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b28 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0102b28:	6a 00                	push   $0x0
c0102b2a:	6a 03                	push   $0x3
c0102b2c:	e9 9d 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b31 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0102b31:	6a 00                	push   $0x0
c0102b33:	6a 04                	push   $0x4
c0102b35:	e9 94 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b3a <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0102b3a:	6a 00                	push   $0x0
c0102b3c:	6a 05                	push   $0x5
c0102b3e:	e9 8b 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b43 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0102b43:	6a 00                	push   $0x0
c0102b45:	6a 06                	push   $0x6
c0102b47:	e9 82 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b4c <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0102b4c:	6a 00                	push   $0x0
c0102b4e:	6a 07                	push   $0x7
c0102b50:	e9 79 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b55 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0102b55:	6a 00                	push   $0x0
c0102b57:	6a 08                	push   $0x8
c0102b59:	e9 70 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b5e <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0102b5e:	6a 00                	push   $0x0
c0102b60:	6a 09                	push   $0x9
c0102b62:	e9 67 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b67 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0102b67:	6a 00                	push   $0x0
c0102b69:	6a 0a                	push   $0xa
c0102b6b:	e9 5e 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b70 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0102b70:	6a 00                	push   $0x0
c0102b72:	6a 0b                	push   $0xb
c0102b74:	e9 55 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b79 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102b79:	6a 00                	push   $0x0
c0102b7b:	6a 0c                	push   $0xc
c0102b7d:	e9 4c 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b82 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0102b82:	6a 00                	push   $0x0
c0102b84:	6a 0d                	push   $0xd
c0102b86:	e9 43 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b8b <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102b8b:	6a 00                	push   $0x0
c0102b8d:	6a 0e                	push   $0xe
c0102b8f:	e9 3a 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102b94 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102b94:	fa                   	cli    
c0102b95:	6a 00                	push   $0x0
c0102b97:	68 80 00 00 00       	push   $0x80
c0102b9c:	e9 2d 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102ba1 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102ba1:	6a 00                	push   $0x0
c0102ba3:	68 e8 03 00 00       	push   $0x3e8
c0102ba8:	e9 21 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102bad <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102bad:	6a 00                	push   $0x0
c0102baf:	68 e9 03 00 00       	push   $0x3e9
c0102bb4:	e9 15 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102bb9 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0102bb9:	6a 00                	push   $0x0
c0102bbb:	68 f6 03 00 00       	push   $0x3f6
c0102bc0:	e9 09 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102bc5 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0102bc5:	6a 00                	push   $0x0
c0102bc7:	6a ff                	push   $0xffffffff
c0102bc9:	e9 00 00 00 00       	jmp    c0102bce <asm_do_irq>

c0102bce <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0102bce:	fa                   	cli    
  pushl %ds
c0102bcf:	1e                   	push   %ds
  pushl %es
c0102bd0:	06                   	push   %es
  pushl %fs
c0102bd1:	0f a0                	push   %fs
  pushl %gs
c0102bd3:	0f a8                	push   %gs
	pushal
c0102bd5:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0102bd6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0102bda:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102bdc:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0102bde:	54                   	push   %esp
  call irq_handle
c0102bdf:	e8 20 e4 ff ff       	call   c0101004 <irq_handle>
  addl $4, %esp
c0102be4:	83 c4 04             	add    $0x4,%esp

c0102be7 <switch_proc>:
switch_proc:
  popal
c0102be7:	61                   	popa   
  popl %gs
c0102be8:	0f a9                	pop    %gs
  popl %fs
c0102bea:	0f a1                	pop    %fs
  popl %es
c0102bec:	07                   	pop    %es
  popl %ds
c0102bed:	1f                   	pop    %ds
  addl $8, %esp
c0102bee:	83 c4 08             	add    $0x8,%esp
  sti
c0102bf1:	fb                   	sti    
  iret
c0102bf2:	cf                   	iret   
c0102bf3:	90                   	nop
c0102bf4:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0102bfa:	00 00                	add    %al,(%eax)
c0102bfc:	fe 4f 52             	decb   0x52(%edi)
c0102bff:	e4 66                	in     $0x66,%al

c0102c00 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0102c00:	66 c7 05 72 04 00 00 34 12 b8 00 60 10 00 0f 22     f..r...4...`..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0102c10:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 23 2c 10     .. ......."..#,.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0102c20:	c0 ff e0                                            ...

c0102c23 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0102c23:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0102c28:	bc 00 00 11 c0       	mov    $0xc0110000,%esp

	# now to C code

	call	main
c0102c2d:	e8 05 eb ff ff       	call   c0101737 <main>

c0102c32 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0102c32:	eb fe                	jmp    c0102c32 <spin>

c0102c34 <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0102c34:	55                   	push   %ebp
c0102c35:	89 e5                	mov    %esp,%ebp
c0102c37:	53                   	push   %ebx
c0102c38:	83 ec 04             	sub    $0x4,%esp
c0102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c3e:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0102c41:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0102c46:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0102c4a:	89 d3                	mov    %edx,%ebx
c0102c4c:	cd 80                	int    $0x80
}
c0102c4e:	83 c4 04             	add    $0x4,%esp
c0102c51:	5b                   	pop    %ebx
c0102c52:	5d                   	pop    %ebp
c0102c53:	c3                   	ret    

c0102c54 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0102c54:	55                   	push   %ebp
c0102c55:	89 e5                	mov    %esp,%ebp
c0102c57:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0102c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0102c60:	eb 19                	jmp    c0102c7b <printp+0x27>
		printer(cur);
c0102c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c65:	0f b6 00             	movzbl (%eax),%eax
c0102c68:	0f be c0             	movsbl %al,%eax
c0102c6b:	83 ec 0c             	sub    $0xc,%esp
c0102c6e:	50                   	push   %eax
c0102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c72:	ff d0                	call   *%eax
c0102c74:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0102c77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c7e:	0f b6 00             	movzbl (%eax),%eax
c0102c81:	84 c0                	test   %al,%al
c0102c83:	75 dd                	jne    c0102c62 <printp+0xe>
		printer(cur);
	}
}
c0102c85:	c9                   	leave  
c0102c86:	c3                   	ret    

c0102c87 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0102c87:	55                   	push   %ebp
c0102c88:	89 e5                	mov    %esp,%ebp
c0102c8a:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0102c93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0102c9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0102ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0102ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102ca7:	e9 65 02 00 00       	jmp    c0102f11 <vfprintf+0x28a>

		if(cur == '%'){
c0102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102caf:	0f b6 00             	movzbl (%eax),%eax
c0102cb2:	3c 25                	cmp    $0x25,%al
c0102cb4:	75 0c                	jne    c0102cc2 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0102cb6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0102cbd:	e9 4b 02 00 00       	jmp    c0102f0d <vfprintf+0x286>
		}
		if(type == READ){
c0102cc2:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0102cc6:	0f 85 26 02 00 00    	jne    c0102ef2 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0102ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ccf:	0f b6 00             	movzbl (%eax),%eax
c0102cd2:	3c 73                	cmp    $0x73,%al
c0102cd4:	75 35                	jne    c0102d0b <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0102cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cd9:	8b 00                	mov    (%eax),%eax
c0102cdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0102cde:	eb 19                	jmp    c0102cf9 <vfprintf+0x72>
					printer(*p);
c0102ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ce3:	0f b6 00             	movzbl (%eax),%eax
c0102ce6:	0f be c0             	movsbl %al,%eax
c0102ce9:	83 ec 0c             	sub    $0xc,%esp
c0102cec:	50                   	push   %eax
c0102ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf0:	ff d0                	call   *%eax
c0102cf2:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0102cf5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0102cf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102cfc:	0f b6 00             	movzbl (%eax),%eax
c0102cff:	84 c0                	test   %al,%al
c0102d01:	75 dd                	jne    c0102ce0 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0102d03:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102d07:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0102d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0e:	0f b6 00             	movzbl (%eax),%eax
c0102d11:	3c 78                	cmp    $0x78,%al
c0102d13:	0f 85 99 00 00 00    	jne    c0102db2 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0102d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d1c:	8b 00                	mov    (%eax),%eax
c0102d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0102d21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102d25:	75 1d                	jne    c0102d44 <vfprintf+0xbd>
					printer('0');
c0102d27:	83 ec 0c             	sub    $0xc,%esp
c0102d2a:	6a 30                	push   $0x30
c0102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2f:	ff d0                	call   *%eax
c0102d31:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102d34:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102d3f:	e9 c9 01 00 00       	jmp    c0102f0d <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0102d44:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0102d4b:	eb 2d                	jmp    c0102d7a <vfprintf+0xf3>
					int d=(x%16);
c0102d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d50:	83 e0 0f             	and    $0xf,%eax
c0102d53:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0102d56:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0102d5a:	7e 04                	jle    c0102d60 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0102d5c:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0102d60:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d63:	83 c0 30             	add    $0x30,%eax
c0102d66:	89 c1                	mov    %eax,%ecx
c0102d68:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102d6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d6e:	01 d0                	add    %edx,%eax
c0102d70:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0102d72:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0102d76:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102d7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102d7e:	75 cd                	jne    c0102d4d <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0102d80:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0102d84:	eb 1e                	jmp    c0102da4 <vfprintf+0x11d>
					printer(digits[di]);
c0102d86:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102d89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d8c:	01 d0                	add    %edx,%eax
c0102d8e:	0f b6 00             	movzbl (%eax),%eax
c0102d91:	0f be c0             	movsbl %al,%eax
c0102d94:	83 ec 0c             	sub    $0xc,%esp
c0102d97:	50                   	push   %eax
c0102d98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9b:	ff d0                	call   *%eax
c0102d9d:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0102da0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0102da4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102da8:	79 dc                	jns    c0102d86 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0102daa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102dae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0102db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db5:	0f b6 00             	movzbl (%eax),%eax
c0102db8:	3c 64                	cmp    $0x64,%al
c0102dba:	0f 85 02 01 00 00    	jne    c0102ec2 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0102dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dc3:	8b 00                	mov    (%eax),%eax
c0102dc5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0102dc8:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0102dcf:	75 23                	jne    c0102df4 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0102dd1:	83 ec 08             	sub    $0x8,%esp
c0102dd4:	68 ab 31 10 c0       	push   $0xc01031ab
c0102dd9:	ff 75 08             	pushl  0x8(%ebp)
c0102ddc:	e8 73 fe ff ff       	call   c0102c54 <printp>
c0102de1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102de4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102de8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0102def:	e9 19 01 00 00       	jmp    c0102f0d <vfprintf+0x286>
				}
				if(x==0){
c0102df4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102df8:	75 1e                	jne    c0102e18 <vfprintf+0x191>
					printer('0');
c0102dfa:	83 ec 0c             	sub    $0xc,%esp
c0102dfd:	6a 30                	push   $0x30
c0102dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e02:	ff d0                	call   *%eax
c0102e04:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102e07:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102e0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0102e12:	90                   	nop
c0102e13:	e9 f5 00 00 00       	jmp    c0102f0d <vfprintf+0x286>
				}
				if(x<0){
c0102e18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102e1c:	79 10                	jns    c0102e2e <vfprintf+0x1a7>
					printer('-');
c0102e1e:	83 ec 0c             	sub    $0xc,%esp
c0102e21:	6a 2d                	push   $0x2d
c0102e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e26:	ff d0                	call   *%eax
c0102e28:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0102e2b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0102e2e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0102e35:	eb 53                	jmp    c0102e8a <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0102e37:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102e3a:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0102e3f:	89 c8                	mov    %ecx,%eax
c0102e41:	f7 ea                	imul   %edx
c0102e43:	c1 fa 02             	sar    $0x2,%edx
c0102e46:	89 c8                	mov    %ecx,%eax
c0102e48:	c1 f8 1f             	sar    $0x1f,%eax
c0102e4b:	29 c2                	sub    %eax,%edx
c0102e4d:	89 d0                	mov    %edx,%eax
c0102e4f:	c1 e0 02             	shl    $0x2,%eax
c0102e52:	01 d0                	add    %edx,%eax
c0102e54:	01 c0                	add    %eax,%eax
c0102e56:	29 c1                	sub    %eax,%ecx
c0102e58:	89 ca                	mov    %ecx,%edx
c0102e5a:	89 d0                	mov    %edx,%eax
c0102e5c:	83 c0 30             	add    $0x30,%eax
c0102e5f:	89 c1                	mov    %eax,%ecx
c0102e61:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0102e64:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e67:	01 d0                	add    %edx,%eax
c0102e69:	88 08                	mov    %cl,(%eax)
					x/=10;
c0102e6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102e6e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0102e73:	89 c8                	mov    %ecx,%eax
c0102e75:	f7 ea                	imul   %edx
c0102e77:	c1 fa 02             	sar    $0x2,%edx
c0102e7a:	89 c8                	mov    %ecx,%eax
c0102e7c:	c1 f8 1f             	sar    $0x1f,%eax
c0102e7f:	29 c2                	sub    %eax,%edx
c0102e81:	89 d0                	mov    %edx,%eax
c0102e83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0102e86:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102e8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102e8e:	7f a7                	jg     c0102e37 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0102e90:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0102e94:	eb 1e                	jmp    c0102eb4 <vfprintf+0x22d>
					printer(digits[di]);
c0102e96:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0102e99:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e9c:	01 d0                	add    %edx,%eax
c0102e9e:	0f b6 00             	movzbl (%eax),%eax
c0102ea1:	0f be c0             	movsbl %al,%eax
c0102ea4:	83 ec 0c             	sub    $0xc,%esp
c0102ea7:	50                   	push   %eax
c0102ea8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eab:	ff d0                	call   *%eax
c0102ead:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0102eb0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0102eb4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102eb8:	79 dc                	jns    c0102e96 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0102eba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102ebe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0102ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ec5:	0f b6 00             	movzbl (%eax),%eax
c0102ec8:	3c 63                	cmp    $0x63,%al
c0102eca:	75 1d                	jne    c0102ee9 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0102ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ecf:	0f b6 00             	movzbl (%eax),%eax
c0102ed2:	0f be c0             	movsbl %al,%eax
c0102ed5:	83 ec 0c             	sub    $0xc,%esp
c0102ed8:	50                   	push   %eax
c0102ed9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102edc:	ff d0                	call   *%eax
c0102ede:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0102ee1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102ee5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0102ee9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0102ef0:	eb 1b                	jmp    c0102f0d <vfprintf+0x286>
		}
		if(type == NONE){
c0102ef2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ef6:	75 15                	jne    c0102f0d <vfprintf+0x286>
			printer(cur);
c0102ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efb:	0f b6 00             	movzbl (%eax),%eax
c0102efe:	0f be c0             	movsbl %al,%eax
c0102f01:	83 ec 0c             	sub    $0xc,%esp
c0102f04:	50                   	push   %eax
c0102f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f08:	ff d0                	call   *%eax
c0102f0a:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102f0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f14:	0f b6 00             	movzbl (%eax),%eax
c0102f17:	84 c0                	test   %al,%al
c0102f19:	0f 85 8d fd ff ff    	jne    c0102cac <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0102f1f:	c9                   	leave  
c0102f20:	c3                   	ret    

c0102f21 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0102f21:	55                   	push   %ebp
c0102f22:	89 e5                	mov    %esp,%ebp
c0102f24:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102f27:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0102f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f30:	83 ec 04             	sub    $0x4,%esp
c0102f33:	ff 75 f4             	pushl  -0xc(%ebp)
c0102f36:	50                   	push   %eax
c0102f37:	68 34 2c 10 c0       	push   $0xc0102c34
c0102f3c:	e8 46 fd ff ff       	call   c0102c87 <vfprintf>
c0102f41:	83 c4 10             	add    $0x10,%esp
}
c0102f44:	c9                   	leave  
c0102f45:	c3                   	ret    
