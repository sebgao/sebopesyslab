
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
c01000ba:	e8 68 2e 00 00       	call   c0102f27 <vfprintf>
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
c01000f0:	68 e8 31 10 c0       	push   $0xc01031e8
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
c0100365:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010036b:	83 ec 04             	sub    $0x4,%esp
c010036e:	50                   	push   %eax
c010036f:	6a 71                	push   $0x71
c0100371:	68 0b 32 10 c0       	push   $0xc010320b
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
c010038a:	05 20 20 00 00       	add    $0x2020,%eax
c010038f:	83 ec 0c             	sub    $0xc,%esp
c0100392:	50                   	push   %eax
c0100393:	e8 7d fe ff ff       	call   c0100215 <set_tss_esp0>
c0100398:	83 c4 10             	add    $0x10,%esp
	//printk("3\n");
	struct TrapFrame *tf = pcb->tf;
c010039b:	8b 45 08             	mov    0x8(%ebp),%eax
c010039e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
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
c0100406:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8d 00 00 00       	push   $0x8d
c0100415:	68 0b 32 10 c0       	push   $0xc010320b
c010041a:	e8 be fc ff ff       	call   c01000dd <_paddr>
c010041f:	83 c4 10             	add    $0x10,%esp
c0100422:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100428:	0f 22 d8             	mov    %eax,%cr3
	//printk("B\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c010042b:	8b 45 08             	mov    0x8(%ebp),%eax
c010042e:	05 20 20 00 00       	add    $0x2020,%eax
c0100433:	83 ec 0c             	sub    $0xc,%esp
c0100436:	50                   	push   %eax
c0100437:	e8 d9 fd ff ff       	call   c0100215 <set_tss_esp0>
c010043c:	83 c4 10             	add    $0x10,%esp
	//printk("--PID %d\n", pcb->pid);
	//printk("--NOW ESP = %x\n", pcb->tf);
	//printk("--TT %x\n", pcb->tt);
	asm volatile("mov %0, %%esp" : : "m"(pcb->tf));
c010043f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100442:	8b a0 58 20 00 00    	mov    0x2058(%eax),%esp
	asm volatile("jmp %0" : : "r"(switch_proc));
c0100448:	b8 87 2e 10 c0       	mov    $0xc0102e87,%eax
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
c0100583:	e8 9f 29 00 00       	call   c0102f27 <vfprintf>
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
c01005d6:	68 24 32 10 c0       	push   $0xc0103224
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
c010060c:	68 48 32 10 c0       	push   $0xc0103248
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
c010064e:	68 6c 32 10 c0       	push   $0xc010326c
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
c0100682:	68 8b 32 10 c0       	push   $0xc010328b
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
c010074d:	68 a1 32 10 c0       	push   $0xc01032a1
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
c01007ae:	68 a1 32 10 c0       	push   $0xc01032a1
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
c010089a:	68 bc 32 10 c0       	push   $0xc01032bc
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
c010097f:	68 a1 32 10 c0       	push   $0xc01032a1
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
c01009fb:	68 a1 32 10 c0       	push   $0xc01032a1
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
c0100b9d:	68 a1 32 10 c0       	push   $0xc01032a1
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
c0100c27:	68 a1 32 10 c0       	push   $0xc01032a1
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
c0100cd9:	68 a1 32 10 c0       	push   $0xc01032a1
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
c0100e4f:	68 a1 32 10 c0       	push   $0xc01032a1
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

c0100f11 <sem_init_kr>:
#include "semaphore.h"

Semaphore sems[NR_SEMS];

void sem_init_kr(Semaphore* sem, int count){
c0100f11:	55                   	push   %ebp
c0100f12:	89 e5                	mov    %esp,%ebp
	if(!sem->used){
c0100f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f17:	8b 00                	mov    (%eax),%eax
c0100f19:	85 c0                	test   %eax,%eax
c0100f1b:	75 12                	jne    c0100f2f <sem_init_kr+0x1e>
		sem->count = count;
c0100f1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f20:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100f23:	89 50 04             	mov    %edx,0x4(%eax)
		sem->used = 1;
c0100f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f29:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	}
	
}
c0100f2f:	5d                   	pop    %ebp
c0100f30:	c3                   	ret    

c0100f31 <sem_close_kr>:

void sem_close_kr(Semaphore* sem){
c0100f31:	55                   	push   %ebp
c0100f32:	89 e5                	mov    %esp,%ebp
	if(sem->used){
c0100f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f37:	8b 00                	mov    (%eax),%eax
c0100f39:	85 c0                	test   %eax,%eax
c0100f3b:	74 09                	je     c0100f46 <sem_close_kr+0x15>
		sem->used = 0;
c0100f3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
}
c0100f46:	5d                   	pop    %ebp
c0100f47:	c3                   	ret    

c0100f48 <sem_post_kr>:

void sem_post_kr(Semaphore* sem){
c0100f48:	55                   	push   %ebp
c0100f49:	89 e5                	mov    %esp,%ebp
c0100f4b:	83 ec 18             	sub    $0x18,%esp
	sem->count ++;
c0100f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f51:	8b 40 04             	mov    0x4(%eax),%eax
c0100f54:	8d 50 01             	lea    0x1(%eax),%edx
c0100f57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f5a:	89 50 04             	mov    %edx,0x4(%eax)
	if(sem->count<=0){
c0100f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f60:	8b 40 04             	mov    0x4(%eax),%eax
c0100f63:	85 c0                	test   %eax,%eax
c0100f65:	7f 28                	jg     c0100f8f <sem_post_kr+0x47>
		PCB* pcb = ll_pop(&sem->block_list);
c0100f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f6a:	83 c0 08             	add    $0x8,%eax
c0100f6d:	83 ec 0c             	sub    $0xc,%esp
c0100f70:	50                   	push   %eax
c0100f71:	e8 5d 13 00 00       	call   c01022d3 <ll_pop>
c0100f76:	83 c4 10             	add    $0x10,%esp
c0100f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100f7c:	83 ec 08             	sub    $0x8,%esp
c0100f7f:	ff 75 f4             	pushl  -0xc(%ebp)
c0100f82:	68 b4 50 15 c0       	push   $0xc01550b4
c0100f87:	e8 a9 13 00 00       	call   c0102335 <ll_entail>
c0100f8c:	83 c4 10             	add    $0x10,%esp
	}
}
c0100f8f:	c9                   	leave  
c0100f90:	c3                   	ret    

c0100f91 <sem_wait_kr>:

void sem_wait_kr(Semaphore* sem){
c0100f91:	55                   	push   %ebp
c0100f92:	89 e5                	mov    %esp,%ebp
c0100f94:	83 ec 18             	sub    $0x18,%esp
	sem->count --;
c0100f97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f9a:	8b 40 04             	mov    0x4(%eax),%eax
c0100f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100fa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fa3:	89 50 04             	mov    %edx,0x4(%eax)
	if(sem->count < 0){
c0100fa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fa9:	8b 40 04             	mov    0x4(%eax),%eax
c0100fac:	85 c0                	test   %eax,%eax
c0100fae:	79 2c                	jns    c0100fdc <sem_wait_kr+0x4b>
		PCB* cur = current;
c0100fb0:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0100fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&sem->block_list, cur);
c0100fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fbb:	83 c0 08             	add    $0x8,%eax
c0100fbe:	83 ec 08             	sub    $0x8,%esp
c0100fc1:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc4:	50                   	push   %eax
c0100fc5:	e8 6b 13 00 00       	call   c0102335 <ll_entail>
c0100fca:	83 c4 10             	add    $0x10,%esp
		current = NULL;
c0100fcd:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c0100fd4:	00 00 00 
		do_scheduler();
c0100fd7:	e8 3a 00 00 00       	call   c0101016 <do_scheduler>
	}
}
c0100fdc:	c9                   	leave  
c0100fdd:	c3                   	ret    

c0100fde <sem_get_kr>:

int sem_get_kr(Semaphore* sem){
c0100fde:	55                   	push   %ebp
c0100fdf:	89 e5                	mov    %esp,%ebp
	return sem->count;
c0100fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fe4:	8b 40 04             	mov    0x4(%eax),%eax
}
c0100fe7:	5d                   	pop    %ebp
c0100fe8:	c3                   	ret    

c0100fe9 <sem_open_kr>:

Semaphore* sem_open_kr(int index, int count){
c0100fe9:	55                   	push   %ebp
c0100fea:	89 e5                	mov    %esp,%ebp
c0100fec:	83 ec 10             	sub    $0x10,%esp
	Semaphore* sem = &sems[index];
c0100fef:	8b 55 08             	mov    0x8(%ebp),%edx
c0100ff2:	89 d0                	mov    %edx,%eax
c0100ff4:	01 c0                	add    %eax,%eax
c0100ff6:	01 d0                	add    %edx,%eax
c0100ff8:	c1 e0 02             	shl    $0x2,%eax
c0100ffb:	05 00 47 1b c0       	add    $0xc01b4700,%eax
c0101000:	89 45 fc             	mov    %eax,-0x4(%ebp)
	sem_init_kr(sem, count);
c0101003:	ff 75 0c             	pushl  0xc(%ebp)
c0101006:	ff 75 fc             	pushl  -0x4(%ebp)
c0101009:	e8 03 ff ff ff       	call   c0100f11 <sem_init_kr>
c010100e:	83 c4 08             	add    $0x8,%esp
	return sem;
c0101011:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101014:	c9                   	leave  
c0101015:	c3                   	ret    

c0101016 <do_scheduler>:

//PCB* ready;



void do_scheduler(){
c0101016:	55                   	push   %ebp
c0101017:	89 e5                	mov    %esp,%ebp
c0101019:	83 ec 08             	sub    $0x8,%esp
	count ++;
c010101c:	a1 04 50 15 c0       	mov    0xc0155004,%eax
c0101021:	83 c0 01             	add    $0x1,%eax
c0101024:	a3 04 50 15 c0       	mov    %eax,0xc0155004

	if(current == NULL){
c0101029:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010102e:	85 c0                	test   %eax,%eax
c0101030:	75 49                	jne    c010107b <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c0101032:	83 ec 0c             	sub    $0xc,%esp
c0101035:	68 b4 50 15 c0       	push   $0xc01550b4
c010103a:	e8 94 12 00 00       	call   c01022d3 <ll_pop>
c010103f:	83 c4 10             	add    $0x10,%esp
c0101042:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0

		current->ts = RUNNING;
c0101047:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010104c:	c7 80 4c 20 00 00 01 	movl   $0x1,0x204c(%eax)
c0101053:	00 00 00 
		current->timeslice = 0;
c0101056:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010105b:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0101062:	00 00 00 

		scheduler_switch(current);
c0101065:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010106a:	83 ec 0c             	sub    $0xc,%esp
c010106d:	50                   	push   %eax
c010106e:	e8 82 f3 ff ff       	call   c01003f5 <scheduler_switch>
c0101073:	83 c4 10             	add    $0x10,%esp
		return;
c0101076:	e9 8c 00 00 00       	jmp    c0101107 <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c010107b:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101080:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c0101086:	83 f8 03             	cmp    $0x3,%eax
c0101089:	75 27                	jne    c01010b2 <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c010108b:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101090:	83 ec 08             	sub    $0x8,%esp
c0101093:	50                   	push   %eax
c0101094:	68 b8 50 15 c0       	push   $0xc01550b8
c0101099:	e8 97 12 00 00       	call   c0102335 <ll_entail>
c010109e:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c01010a1:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c01010a8:	00 00 00 
		do_scheduler();
c01010ab:	e8 66 ff ff ff       	call   c0101016 <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c01010b0:	eb 55                	jmp    c0101107 <do_scheduler+0xf1>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 3 || current->ts == STOP){
c01010b2:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01010b7:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c01010bd:	83 f8 03             	cmp    $0x3,%eax
c01010c0:	77 10                	ja     c01010d2 <do_scheduler+0xbc>
c01010c2:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01010c7:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c01010cd:	83 f8 02             	cmp    $0x2,%eax
c01010d0:	75 35                	jne    c0101107 <do_scheduler+0xf1>

		current->ts = READY;
c01010d2:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01010d7:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c01010de:	00 00 00 

		ll_entail(&ready_list, current);
c01010e1:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01010e6:	83 ec 08             	sub    $0x8,%esp
c01010e9:	50                   	push   %eax
c01010ea:	68 b4 50 15 c0       	push   $0xc01550b4
c01010ef:	e8 41 12 00 00       	call   c0102335 <ll_entail>
c01010f4:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c01010f7:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c01010fe:	00 00 00 
		do_scheduler();
c0101101:	e8 10 ff ff ff       	call   c0101016 <do_scheduler>
		//scheduler_switch(current);
		return;
c0101106:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0101107:	c9                   	leave  
c0101108:	c3                   	ret    

c0101109 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0101109:	55                   	push   %ebp
c010110a:	89 e5                	mov    %esp,%ebp
c010110c:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c010110f:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0101114:	8b 55 08             	mov    0x8(%ebp),%edx
c0101117:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c010111d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101120:	8b 40 30             	mov    0x30(%eax),%eax
c0101123:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		else {
			//printk("IRQ::%d\n", tf->irq);
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0101128:	8b 45 08             	mov    0x8(%ebp),%eax
c010112b:	8b 40 30             	mov    0x30(%eax),%eax
c010112e:	3d 80 00 00 00       	cmp    $0x80,%eax
c0101133:	75 0e                	jne    c0101143 <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c0101135:	83 ec 0c             	sub    $0xc,%esp
c0101138:	ff 75 08             	pushl  0x8(%ebp)
c010113b:	e8 d6 0c 00 00       	call   c0101e16 <do_syscall>
c0101140:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0101143:	8b 45 08             	mov    0x8(%ebp),%eax
c0101146:	8b 40 30             	mov    0x30(%eax),%eax
c0101149:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c010114e:	75 0f                	jne    c010115f <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0101150:	e8 aa 1b 00 00       	call   c0102cff <do_timer>
		do_scheduler();
c0101155:	e8 bc fe ff ff       	call   c0101016 <do_scheduler>
c010115a:	e9 83 00 00 00       	jmp    c01011e2 <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c010115f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101162:	8b 40 30             	mov    0x30(%eax),%eax
c0101165:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c010116a:	75 76                	jne    c01011e2 <irq_handle+0xd9>
c010116c:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101173:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101176:	89 c2                	mov    %eax,%edx
c0101178:	ec                   	in     (%dx),%al
c0101179:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c010117c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0101180:	0f b6 c0             	movzbl %al,%eax
c0101183:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101186:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010118d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101190:	89 c2                	mov    %eax,%edx
c0101192:	ec                   	in     (%dx),%al
c0101193:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0101196:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c010119a:	0f b6 c0             	movzbl %al,%eax
c010119d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c01011a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01011a3:	83 c8 80             	or     $0xffffff80,%eax
c01011a6:	0f b6 c0             	movzbl %al,%eax
c01011a9:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c01011b0:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01011b3:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01011b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01011ba:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c01011bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01011be:	0f b6 c0             	movzbl %al,%eax
c01011c1:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c01011c8:	88 45 d3             	mov    %al,-0x2d(%ebp)
c01011cb:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01011cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01011d2:	ee                   	out    %al,(%dx)
		press_key(code);
c01011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01011d6:	83 ec 0c             	sub    $0xc,%esp
c01011d9:	50                   	push   %eax
c01011da:	e8 5d 0b 00 00       	call   c0101d3c <press_key>
c01011df:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
c01011e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e5:	8b 40 30             	mov    0x30(%eax),%eax
c01011e8:	3d 80 00 00 00       	cmp    $0x80,%eax
c01011ed:	75 1f                	jne    c010120e <irq_handle+0x105>
c01011ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01011f5:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01011fa:	74 0d                	je     c0101209 <irq_handle+0x100>
c01011fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ff:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101202:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101207:	75 05                	jne    c010120e <irq_handle+0x105>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0101209:	e8 08 fe ff ff       	call   c0101016 <do_scheduler>
	}
}
c010120e:	c9                   	leave  
c010120f:	c3                   	ret    

c0101210 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0101210:	55                   	push   %ebp
c0101211:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0101213:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101216:	83 e8 01             	sub    $0x1,%eax
c0101219:	66 a3 08 50 15 c0    	mov    %ax,0xc0155008
	data[1] = (uint32_t)addr;
c010121f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101222:	66 a3 0a 50 15 c0    	mov    %ax,0xc015500a
	data[2] = ((uint32_t)addr) >> 16;
c0101228:	8b 45 08             	mov    0x8(%ebp),%eax
c010122b:	c1 e8 10             	shr    $0x10,%eax
c010122e:	66 a3 0c 50 15 c0    	mov    %ax,0xc015500c
	asm volatile("lidt (%0)" : : "r"(data));
c0101234:	b8 08 50 15 c0       	mov    $0xc0155008,%eax
c0101239:	0f 01 18             	lidtl  (%eax)
}
c010123c:	5d                   	pop    %ebp
c010123d:	c3                   	ret    

c010123e <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c010123e:	55                   	push   %ebp
c010123f:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0101241:	8b 45 10             	mov    0x10(%ebp),%eax
c0101244:	89 c2                	mov    %eax,%edx
c0101246:	8b 45 08             	mov    0x8(%ebp),%eax
c0101249:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c010124c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010124f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101256:	8b 45 08             	mov    0x8(%ebp),%eax
c0101259:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c010125d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101260:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0101264:	8b 45 08             	mov    0x8(%ebp),%eax
c0101267:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010126b:	83 e2 f0             	and    $0xfffffff0,%edx
c010126e:	83 ca 0e             	or     $0xe,%edx
c0101271:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0101274:	8b 45 08             	mov    0x8(%ebp),%eax
c0101277:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010127b:	83 e2 ef             	and    $0xffffffef,%edx
c010127e:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0101281:	8b 45 14             	mov    0x14(%ebp),%eax
c0101284:	83 e0 03             	and    $0x3,%eax
c0101287:	89 c2                	mov    %eax,%edx
c0101289:	8b 45 08             	mov    0x8(%ebp),%eax
c010128c:	83 e2 03             	and    $0x3,%edx
c010128f:	89 d1                	mov    %edx,%ecx
c0101291:	c1 e1 05             	shl    $0x5,%ecx
c0101294:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101298:	83 e2 9f             	and    $0xffffff9f,%edx
c010129b:	09 ca                	or     %ecx,%edx
c010129d:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01012a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01012a3:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012a7:	83 ca 80             	or     $0xffffff80,%edx
c01012aa:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c01012ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01012b0:	c1 e8 10             	shr    $0x10,%eax
c01012b3:	89 c2                	mov    %eax,%edx
c01012b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b8:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c01012bc:	5d                   	pop    %ebp
c01012bd:	c3                   	ret    

c01012be <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c01012be:	55                   	push   %ebp
c01012bf:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c01012c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01012c4:	89 c2                	mov    %eax,%edx
c01012c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012c9:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c01012cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01012d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d9:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c01012dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e0:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c01012e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e7:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012eb:	83 ca 0f             	or     $0xf,%edx
c01012ee:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c01012f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012f4:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012f8:	83 e2 ef             	and    $0xffffffef,%edx
c01012fb:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c01012fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0101301:	83 e0 03             	and    $0x3,%eax
c0101304:	89 c2                	mov    %eax,%edx
c0101306:	8b 45 08             	mov    0x8(%ebp),%eax
c0101309:	83 e2 03             	and    $0x3,%edx
c010130c:	89 d1                	mov    %edx,%ecx
c010130e:	c1 e1 05             	shl    $0x5,%ecx
c0101311:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101315:	83 e2 9f             	and    $0xffffff9f,%edx
c0101318:	09 ca                	or     %ecx,%edx
c010131a:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c010131d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101320:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101324:	83 ca 80             	or     $0xffffff80,%edx
c0101327:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c010132a:	8b 45 10             	mov    0x10(%ebp),%eax
c010132d:	c1 e8 10             	shr    $0x10,%eax
c0101330:	89 c2                	mov    %eax,%edx
c0101332:	8b 45 08             	mov    0x8(%ebp),%eax
c0101335:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101339:	5d                   	pop    %ebp
c010133a:	c3                   	ret    

c010133b <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c010133b:	55                   	push   %ebp
c010133c:	89 e5                	mov    %esp,%ebp
c010133e:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101348:	eb 22                	jmp    c010136c <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c010134a:	ba 65 2e 10 c0       	mov    $0xc0102e65,%edx
c010134f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101352:	c1 e0 03             	shl    $0x3,%eax
c0101355:	05 40 79 1b c0       	add    $0xc01b7940,%eax
c010135a:	6a 00                	push   $0x0
c010135c:	52                   	push   %edx
c010135d:	6a 01                	push   $0x1
c010135f:	50                   	push   %eax
c0101360:	e8 59 ff ff ff       	call   c01012be <set_trap>
c0101365:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101368:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010136c:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101373:	7e d5                	jle    c010134a <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0101375:	b8 ad 2d 10 c0       	mov    $0xc0102dad,%eax
c010137a:	6a 00                	push   $0x0
c010137c:	50                   	push   %eax
c010137d:	6a 01                	push   $0x1
c010137f:	68 40 79 1b c0       	push   $0xc01b7940
c0101384:	e8 35 ff ff ff       	call   c01012be <set_trap>
c0101389:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c010138c:	b8 b6 2d 10 c0       	mov    $0xc0102db6,%eax
c0101391:	6a 00                	push   $0x0
c0101393:	50                   	push   %eax
c0101394:	6a 01                	push   $0x1
c0101396:	68 48 79 1b c0       	push   $0xc01b7948
c010139b:	e8 1e ff ff ff       	call   c01012be <set_trap>
c01013a0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c01013a3:	b8 bf 2d 10 c0       	mov    $0xc0102dbf,%eax
c01013a8:	6a 00                	push   $0x0
c01013aa:	50                   	push   %eax
c01013ab:	6a 01                	push   $0x1
c01013ad:	68 50 79 1b c0       	push   $0xc01b7950
c01013b2:	e8 07 ff ff ff       	call   c01012be <set_trap>
c01013b7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c01013ba:	b8 c8 2d 10 c0       	mov    $0xc0102dc8,%eax
c01013bf:	6a 00                	push   $0x0
c01013c1:	50                   	push   %eax
c01013c2:	6a 01                	push   $0x1
c01013c4:	68 58 79 1b c0       	push   $0xc01b7958
c01013c9:	e8 f0 fe ff ff       	call   c01012be <set_trap>
c01013ce:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c01013d1:	b8 d1 2d 10 c0       	mov    $0xc0102dd1,%eax
c01013d6:	6a 00                	push   $0x0
c01013d8:	50                   	push   %eax
c01013d9:	6a 01                	push   $0x1
c01013db:	68 60 79 1b c0       	push   $0xc01b7960
c01013e0:	e8 d9 fe ff ff       	call   c01012be <set_trap>
c01013e5:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c01013e8:	b8 da 2d 10 c0       	mov    $0xc0102dda,%eax
c01013ed:	6a 00                	push   $0x0
c01013ef:	50                   	push   %eax
c01013f0:	6a 01                	push   $0x1
c01013f2:	68 68 79 1b c0       	push   $0xc01b7968
c01013f7:	e8 c2 fe ff ff       	call   c01012be <set_trap>
c01013fc:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c01013ff:	b8 e3 2d 10 c0       	mov    $0xc0102de3,%eax
c0101404:	6a 00                	push   $0x0
c0101406:	50                   	push   %eax
c0101407:	6a 01                	push   $0x1
c0101409:	68 70 79 1b c0       	push   $0xc01b7970
c010140e:	e8 ab fe ff ff       	call   c01012be <set_trap>
c0101413:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0101416:	b8 ec 2d 10 c0       	mov    $0xc0102dec,%eax
c010141b:	6a 00                	push   $0x0
c010141d:	50                   	push   %eax
c010141e:	6a 01                	push   $0x1
c0101420:	68 78 79 1b c0       	push   $0xc01b7978
c0101425:	e8 94 fe ff ff       	call   c01012be <set_trap>
c010142a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c010142d:	b8 f5 2d 10 c0       	mov    $0xc0102df5,%eax
c0101432:	6a 00                	push   $0x0
c0101434:	50                   	push   %eax
c0101435:	6a 01                	push   $0x1
c0101437:	68 80 79 1b c0       	push   $0xc01b7980
c010143c:	e8 7d fe ff ff       	call   c01012be <set_trap>
c0101441:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0101444:	b8 fe 2d 10 c0       	mov    $0xc0102dfe,%eax
c0101449:	6a 00                	push   $0x0
c010144b:	50                   	push   %eax
c010144c:	6a 01                	push   $0x1
c010144e:	68 88 79 1b c0       	push   $0xc01b7988
c0101453:	e8 66 fe ff ff       	call   c01012be <set_trap>
c0101458:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c010145b:	b8 07 2e 10 c0       	mov    $0xc0102e07,%eax
c0101460:	6a 00                	push   $0x0
c0101462:	50                   	push   %eax
c0101463:	6a 01                	push   $0x1
c0101465:	68 90 79 1b c0       	push   $0xc01b7990
c010146a:	e8 4f fe ff ff       	call   c01012be <set_trap>
c010146f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c0101472:	b8 10 2e 10 c0       	mov    $0xc0102e10,%eax
c0101477:	6a 00                	push   $0x0
c0101479:	50                   	push   %eax
c010147a:	6a 01                	push   $0x1
c010147c:	68 98 79 1b c0       	push   $0xc01b7998
c0101481:	e8 38 fe ff ff       	call   c01012be <set_trap>
c0101486:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101489:	b8 19 2e 10 c0       	mov    $0xc0102e19,%eax
c010148e:	6a 00                	push   $0x0
c0101490:	50                   	push   %eax
c0101491:	6a 01                	push   $0x1
c0101493:	68 a0 79 1b c0       	push   $0xc01b79a0
c0101498:	e8 21 fe ff ff       	call   c01012be <set_trap>
c010149d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c01014a0:	b8 22 2e 10 c0       	mov    $0xc0102e22,%eax
c01014a5:	6a 00                	push   $0x0
c01014a7:	50                   	push   %eax
c01014a8:	6a 01                	push   $0x1
c01014aa:	68 a8 79 1b c0       	push   $0xc01b79a8
c01014af:	e8 0a fe ff ff       	call   c01012be <set_trap>
c01014b4:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c01014b7:	b8 34 2e 10 c0       	mov    $0xc0102e34,%eax
c01014bc:	6a 03                	push   $0x3
c01014be:	50                   	push   %eax
c01014bf:	6a 01                	push   $0x1
c01014c1:	68 40 7d 1b c0       	push   $0xc01b7d40
c01014c6:	e8 f3 fd ff ff       	call   c01012be <set_trap>
c01014cb:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c01014ce:	b8 41 2e 10 c0       	mov    $0xc0102e41,%eax
c01014d3:	6a 00                	push   $0x0
c01014d5:	50                   	push   %eax
c01014d6:	6a 01                	push   $0x1
c01014d8:	68 40 7a 1b c0       	push   $0xc01b7a40
c01014dd:	e8 5c fd ff ff       	call   c010123e <set_intr>
c01014e2:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c01014e5:	b8 4d 2e 10 c0       	mov    $0xc0102e4d,%eax
c01014ea:	6a 00                	push   $0x0
c01014ec:	50                   	push   %eax
c01014ed:	6a 01                	push   $0x1
c01014ef:	68 48 7a 1b c0       	push   $0xc01b7a48
c01014f4:	e8 45 fd ff ff       	call   c010123e <set_intr>
c01014f9:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c01014fc:	68 00 08 00 00       	push   $0x800
c0101501:	68 40 79 1b c0       	push   $0xc01b7940
c0101506:	e8 05 fd ff ff       	call   c0101210 <save_idt>
c010150b:	83 c4 08             	add    $0x8,%esp
}
c010150e:	c9                   	leave  
c010150f:	c3                   	ret    

c0101510 <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c0101510:	55                   	push   %ebp
c0101511:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c0101513:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0101518:	cd 80                	int    $0x80
}
c010151a:	5d                   	pop    %ebp
c010151b:	c3                   	ret    

c010151c <sys_exit>:
static inline void sys_exit(){
c010151c:	55                   	push   %ebp
c010151d:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c010151f:	b8 df 05 00 00       	mov    $0x5df,%eax
c0101524:	cd 80                	int    $0x80
}
c0101526:	5d                   	pop    %ebp
c0101527:	c3                   	ret    

c0101528 <sys_fork>:
static inline uint32_t sys_fork(){
c0101528:	55                   	push   %ebp
c0101529:	89 e5                	mov    %esp,%ebp
c010152b:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c010152e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c0101535:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c010153a:	cd 80                	int    $0x80
c010153c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c010153f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101542:	c9                   	leave  
c0101543:	c3                   	ret    

c0101544 <sys_pid>:
static inline uint32_t sys_pid(){
c0101544:	55                   	push   %ebp
c0101545:	89 e5                	mov    %esp,%ebp
c0101547:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c010154a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c0101551:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0101556:	cd 80                	int    $0x80
c0101558:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c010155b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010155e:	c9                   	leave  
c010155f:	c3                   	ret    

c0101560 <sys_ppid>:
static inline uint32_t sys_ppid(){
c0101560:	55                   	push   %ebp
c0101561:	89 e5                	mov    %esp,%ebp
c0101563:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101566:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c010156d:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c0101572:	cd 80                	int    $0x80
c0101574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101577:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010157a:	c9                   	leave  
c010157b:	c3                   	ret    

c010157c <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c010157c:	55                   	push   %ebp
c010157d:	89 e5                	mov    %esp,%ebp
c010157f:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c0101580:	b8 de 05 00 00       	mov    $0x5de,%eax
c0101585:	8b 55 08             	mov    0x8(%ebp),%edx
c0101588:	89 d3                	mov    %edx,%ebx
c010158a:	cd 80                	int    $0x80
}
c010158c:	5b                   	pop    %ebx
c010158d:	5d                   	pop    %ebp
c010158e:	c3                   	ret    

c010158f <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010158f:	55                   	push   %ebp
c0101590:	89 e5                	mov    %esp,%ebp
c0101592:	83 ec 40             	sub    $0x40,%esp
c0101595:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c010159c:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01015a0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01015a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01015a7:	ee                   	out    %al,(%dx)
c01015a8:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c01015af:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c01015b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01015ba:	ee                   	out    %al,(%dx)
c01015bb:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c01015c2:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c01015c6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01015ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01015cd:	ee                   	out    %al,(%dx)
c01015ce:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c01015d5:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01015d9:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01015dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01015e0:	ee                   	out    %al,(%dx)
c01015e1:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01015e8:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01015ec:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01015f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01015f3:	ee                   	out    %al,(%dx)
c01015f4:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01015fb:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01015ff:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101603:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101606:	ee                   	out    %al,(%dx)
c0101607:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c010160e:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0101612:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101616:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101619:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c010161a:	c9                   	leave  
c010161b:	c3                   	ret    

c010161c <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c010161c:	55                   	push   %ebp
c010161d:	89 e5                	mov    %esp,%ebp
c010161f:	83 ec 70             	sub    $0x70,%esp
c0101622:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0101629:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c010162d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101631:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101634:	ee                   	out    %al,(%dx)
c0101635:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c010163c:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c0101640:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101644:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101647:	ee                   	out    %al,(%dx)
c0101648:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c010164f:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c0101653:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101657:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010165a:	ee                   	out    %al,(%dx)
c010165b:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0101662:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0101666:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010166a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010166d:	ee                   	out    %al,(%dx)
c010166e:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0101675:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0101679:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010167d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101680:	ee                   	out    %al,(%dx)
c0101681:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0101688:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010168c:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101690:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101693:	ee                   	out    %al,(%dx)
c0101694:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c010169b:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c010169f:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01016a3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01016a6:	ee                   	out    %al,(%dx)
c01016a7:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c01016ae:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c01016b2:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c01016b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01016b9:	ee                   	out    %al,(%dx)
c01016ba:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01016c1:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01016c5:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01016c9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01016cc:	ee                   	out    %al,(%dx)
c01016cd:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01016d4:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c01016d8:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c01016dc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01016df:	ee                   	out    %al,(%dx)
c01016e0:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c01016e7:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c01016eb:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c01016ef:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01016f2:	ee                   	out    %al,(%dx)
c01016f3:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c01016fa:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01016fe:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101702:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101705:	ee                   	out    %al,(%dx)
c0101706:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010170d:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0101711:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0101715:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0101718:	ee                   	out    %al,(%dx)
c0101719:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c0101720:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0101724:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0101728:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010172b:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c010172c:	c9                   	leave  
c010172d:	c3                   	ret    

c010172e <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c010172e:	55                   	push   %ebp
c010172f:	89 e5                	mov    %esp,%ebp
c0101731:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0101734:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c010173b:	0f b6 05 00 70 10 c0 	movzbl 0xc0107000,%eax
c0101742:	0f b6 c0             	movzbl %al,%eax
c0101745:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c010174c:	88 45 f7             	mov    %al,-0x9(%ebp)
c010174f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101753:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101756:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0101757:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010175a:	0f b6 c0             	movzbl %al,%eax
c010175d:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c0101764:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101767:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010176b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c010176f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101772:	c1 f8 08             	sar    $0x8,%eax
c0101775:	0f b6 c0             	movzbl %al,%eax
c0101778:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c010177f:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101782:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101786:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101789:	ee                   	out    %al,(%dx)
}
c010178a:	c9                   	leave  
c010178b:	c3                   	ret    

c010178c <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010178c:	55                   	push   %ebp
c010178d:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c010178f:	e8 7c fd ff ff       	call   c0101510 <sys_handout>
  }
c0101794:	eb f9                	jmp    c010178f <idle+0x3>

c0101796 <busy>:
}
void busy(){
c0101796:	55                   	push   %ebp
c0101797:	89 e5                	mov    %esp,%ebp
c0101799:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c010179c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c01017a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c01017aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01017b1:	eb 11                	jmp    c01017c4 <busy+0x2e>
    if(fork()!=0){
c01017b3:	e8 70 fd ff ff       	call   c0101528 <sys_fork>
c01017b8:	85 c0                	test   %eax,%eax
c01017ba:	74 04                	je     c01017c0 <busy+0x2a>
        j++;
c01017bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c01017c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01017c4:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c01017c8:	76 e9                	jbe    c01017b3 <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c01017ca:	e8 75 fd ff ff       	call   c0101544 <sys_pid>
c01017cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c01017d2:	e8 89 fd ff ff       	call   c0101560 <sys_ppid>
c01017d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01017da:	50                   	push   %eax
c01017db:	ff 75 e8             	pushl  -0x18(%ebp)
c01017de:	68 e0 32 10 c0       	push   $0xc01032e0
c01017e3:	e8 d9 19 00 00       	call   c01031c1 <printf>
c01017e8:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c01017eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c01017f2:	e8 19 fd ff ff       	call   c0101510 <sys_handout>
    sleep(pid);
c01017f7:	83 ec 0c             	sub    $0xc,%esp
c01017fa:	ff 75 e8             	pushl  -0x18(%ebp)
c01017fd:	e8 7a fd ff ff       	call   c010157c <sys_sleep>
c0101802:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0101805:	ff 75 ec             	pushl  -0x14(%ebp)
c0101808:	ff 75 e8             	pushl  -0x18(%ebp)
c010180b:	ff 75 e8             	pushl  -0x18(%ebp)
c010180e:	68 20 33 10 c0       	push   $0xc0103320
c0101813:	e8 a9 19 00 00       	call   c01031c1 <printf>
c0101818:	83 c4 10             	add    $0x10,%esp
    times++;
c010181b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c010181f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0101823:	76 15                	jbe    c010183a <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0101825:	83 ec 0c             	sub    $0xc,%esp
c0101828:	68 44 33 10 c0       	push   $0xc0103344
c010182d:	e8 8f 19 00 00       	call   c01031c1 <printf>
c0101832:	83 c4 10             	add    $0x10,%esp
      exit();
c0101835:	e8 e2 fc ff ff       	call   c010151c <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c010183a:	eb b6                	jmp    c01017f2 <busy+0x5c>

c010183c <main>:
}
void do_scheduler();
int main(){
c010183c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0101840:	83 e4 f0             	and    $0xfffffff0,%esp
c0101843:	ff 71 fc             	pushl  -0x4(%ecx)
c0101846:	55                   	push   %ebp
c0101847:	89 e5                	mov    %esp,%ebp
c0101849:	51                   	push   %ecx
c010184a:	83 ec 14             	sub    $0x14,%esp
  init_page();
c010184d:	e8 d9 e8 ff ff       	call   c010012b <init_page>
  init_segment();
c0101852:	e8 85 ea ff ff       	call   c01002dc <init_segment>
	init_serial();
c0101857:	e8 33 fd ff ff       	call   c010158f <init_serial>
	init_timer();
c010185c:	e8 cd fe ff ff       	call   c010172e <init_timer>
	init_idt();
c0101861:	e8 d5 fa ff ff       	call   c010133b <init_idt>
	init_intr();
c0101866:	e8 b1 fd ff ff       	call   c010161c <init_intr>
  init_pcb_pool();
c010186b:	e8 a0 0b 00 00       	call   c0102410 <init_pcb_pool>

  PCB* pidle = pcb_create();
c0101870:	e8 06 0d 00 00       	call   c010257b <pcb_create>
c0101875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0101878:	83 ec 08             	sub    $0x8,%esp
c010187b:	68 8c 17 10 c0       	push   $0xc010178c
c0101880:	ff 75 f4             	pushl  -0xc(%ebp)
c0101883:	e8 15 04 00 00       	call   c0101c9d <empty_loader>
c0101888:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c010188b:	e8 eb 0c 00 00       	call   c010257b <pcb_create>
c0101890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c0101893:	83 ec 08             	sub    $0x8,%esp
c0101896:	68 00 90 01 00       	push   $0x19000
c010189b:	ff 75 f0             	pushl  -0x10(%ebp)
c010189e:	e8 62 02 00 00       	call   c0101b05 <loader>
c01018a3:	83 c4 10             	add    $0x10,%esp

  enready_pcb(pidle);
c01018a6:	83 ec 0c             	sub    $0xc,%esp
c01018a9:	ff 75 f4             	pushl  -0xc(%ebp)
c01018ac:	e8 ca 0d 00 00       	call   c010267b <enready_pcb>
c01018b1:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c01018b4:	83 ec 0c             	sub    $0xc,%esp
c01018b7:	ff 75 f0             	pushl  -0x10(%ebp)
c01018ba:	e8 bc 0d 00 00       	call   c010267b <enready_pcb>
c01018bf:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c01018c2:	e8 b4 0c 00 00       	call   c010257b <pcb_create>
c01018c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(app, 2*102400);
c01018ca:	83 ec 08             	sub    $0x8,%esp
c01018cd:	68 00 20 03 00       	push   $0x32000
c01018d2:	ff 75 ec             	pushl  -0x14(%ebp)
c01018d5:	e8 2b 02 00 00       	call   c0101b05 <loader>
c01018da:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c01018dd:	83 ec 0c             	sub    $0xc,%esp
c01018e0:	ff 75 ec             	pushl  -0x14(%ebp)
c01018e3:	e8 93 0d 00 00       	call   c010267b <enready_pcb>
c01018e8:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c01018eb:	e8 26 f7 ff ff       	call   c0101016 <do_scheduler>

  while(1);
c01018f0:	eb fe                	jmp    c01018f0 <main+0xb4>

c01018f2 <serial_idle>:

static inline
int serial_idle(void) {
c01018f2:	55                   	push   %ebp
c01018f3:	89 e5                	mov    %esp,%ebp
c01018f5:	83 ec 10             	sub    $0x10,%esp
c01018f8:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01018ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101902:	89 c2                	mov    %eax,%edx
c0101904:	ec                   	in     (%dx),%al
c0101905:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101908:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010190c:	0f b6 c0             	movzbl %al,%eax
c010190f:	83 e0 20             	and    $0x20,%eax
c0101912:	85 c0                	test   %eax,%eax
c0101914:	0f 95 c0             	setne  %al
c0101917:	0f b6 c0             	movzbl %al,%eax
}
c010191a:	c9                   	leave  
c010191b:	c3                   	ret    

c010191c <serial_printc>:

static inline
void serial_printc(char ch) {
c010191c:	55                   	push   %ebp
c010191d:	89 e5                	mov    %esp,%ebp
c010191f:	83 ec 14             	sub    $0x14,%esp
c0101922:	8b 45 08             	mov    0x8(%ebp),%eax
c0101925:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101928:	90                   	nop
c0101929:	e8 c4 ff ff ff       	call   c01018f2 <serial_idle>
c010192e:	85 c0                	test   %eax,%eax
c0101930:	74 f7                	je     c0101929 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101932:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101936:	0f b6 c0             	movzbl %al,%eax
c0101939:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101940:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101943:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101947:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010194a:	ee                   	out    %al,(%dx)
}
c010194b:	c9                   	leave  
c010194c:	c3                   	ret    

c010194d <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010194d:	55                   	push   %ebp
c010194e:	89 e5                	mov    %esp,%ebp
c0101950:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101953:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101956:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101959:	8b 45 08             	mov    0x8(%ebp),%eax
c010195c:	83 ec 04             	sub    $0x4,%esp
c010195f:	ff 75 f4             	pushl  -0xc(%ebp)
c0101962:	50                   	push   %eax
c0101963:	68 1c 19 10 c0       	push   $0xc010191c
c0101968:	e8 ba 15 00 00       	call   c0102f27 <vfprintf>
c010196d:	83 c4 10             	add    $0x10,%esp
}
c0101970:	c9                   	leave  
c0101971:	c3                   	ret    

c0101972 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101972:	55                   	push   %ebp
c0101973:	89 e5                	mov    %esp,%ebp
c0101975:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101978:	90                   	nop
c0101979:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101980:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101983:	89 c2                	mov    %eax,%edx
c0101985:	ec                   	in     (%dx),%al
c0101986:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101989:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010198d:	0f b6 c0             	movzbl %al,%eax
c0101990:	25 c0 00 00 00       	and    $0xc0,%eax
c0101995:	83 f8 40             	cmp    $0x40,%eax
c0101998:	75 df                	jne    c0101979 <waitdisk+0x7>
}
c010199a:	c9                   	leave  
c010199b:	c3                   	ret    

c010199c <readsect>:

static inline void
readsect(void *dst, int offset) {
c010199c:	55                   	push   %ebp
c010199d:	89 e5                	mov    %esp,%ebp
c010199f:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01019a2:	e8 cb ff ff ff       	call   c0101972 <waitdisk>
c01019a7:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01019ae:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01019b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01019b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01019b9:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01019bd:	0f b6 c0             	movzbl %al,%eax
c01019c0:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01019c7:	88 45 ef             	mov    %al,-0x11(%ebp)
c01019ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01019d1:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01019d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01019d5:	c1 f8 08             	sar    $0x8,%eax
c01019d8:	0f b6 c0             	movzbl %al,%eax
c01019db:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01019e2:	88 45 e7             	mov    %al,-0x19(%ebp)
c01019e5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01019e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01019ec:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01019ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01019f0:	c1 f8 10             	sar    $0x10,%eax
c01019f3:	0f b6 c0             	movzbl %al,%eax
c01019f6:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01019fd:	88 45 df             	mov    %al,-0x21(%ebp)
c0101a00:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101a04:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101a07:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101a08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a0b:	c1 f8 18             	sar    $0x18,%eax
c0101a0e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101a11:	0f b6 c0             	movzbl %al,%eax
c0101a14:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101a1b:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101a1e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101a22:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101a25:	ee                   	out    %al,(%dx)
c0101a26:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101a2d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101a31:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101a35:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101a38:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101a39:	e8 34 ff ff ff       	call   c0101972 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101a3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a45:	eb 29                	jmp    c0101a70 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a54:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101a57:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101a5e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101a61:	89 c2                	mov    %eax,%edx
c0101a63:	ed                   	in     (%dx),%eax
c0101a64:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101a67:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101a6a:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101a6c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a70:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101a74:	7e d1                	jle    c0101a47 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101a76:	c9                   	leave  
c0101a77:	c3                   	ret    

c0101a78 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101a78:	55                   	push   %ebp
c0101a79:	89 e5                	mov    %esp,%ebp
c0101a7b:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a84:	01 d0                	add    %edx,%eax
c0101a86:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101a89:	8b 45 10             	mov    0x10(%ebp),%eax
c0101a8c:	99                   	cltd   
c0101a8d:	c1 ea 17             	shr    $0x17,%edx
c0101a90:	01 d0                	add    %edx,%eax
c0101a92:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101a97:	29 d0                	sub    %edx,%eax
c0101a99:	f7 d8                	neg    %eax
c0101a9b:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0101a9e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101aa1:	99                   	cltd   
c0101aa2:	c1 ea 17             	shr    $0x17,%edx
c0101aa5:	01 d0                	add    %edx,%eax
c0101aa7:	c1 f8 09             	sar    $0x9,%eax
c0101aaa:	83 c0 01             	add    $0x1,%eax
c0101aad:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101ab0:	eb 19                	jmp    c0101acb <readseg+0x53>
        readsect(pa, offset);
c0101ab2:	ff 75 10             	pushl  0x10(%ebp)
c0101ab5:	ff 75 08             	pushl  0x8(%ebp)
c0101ab8:	e8 df fe ff ff       	call   c010199c <readsect>
c0101abd:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101ac0:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0101ac7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101ad1:	72 df                	jb     c0101ab2 <readseg+0x3a>
        readsect(pa, offset);
c0101ad3:	c9                   	leave  
c0101ad4:	c3                   	ret    

c0101ad5 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101ad5:	55                   	push   %ebp
c0101ad6:	89 e5                	mov    %esp,%ebp
c0101ad8:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101adb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ade:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101ae3:	77 16                	ja     c0101afb <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101ae5:	ff 75 10             	pushl  0x10(%ebp)
c0101ae8:	68 64 33 10 c0       	push   $0xc0103364
c0101aed:	ff 75 0c             	pushl  0xc(%ebp)
c0101af0:	ff 75 08             	pushl  0x8(%ebp)
c0101af3:	e8 55 fe ff ff       	call   c010194d <printk>
c0101af8:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101afb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101afe:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101b03:	c9                   	leave  
c0101b04:	c3                   	ret    

c0101b05 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101b05:	55                   	push   %ebp
c0101b06:	89 e5                	mov    %esp,%ebp
c0101b08:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0e:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101b14:	83 ec 04             	sub    $0x4,%esp
c0101b17:	50                   	push   %eax
c0101b18:	6a 17                	push   $0x17
c0101b1a:	68 87 33 10 c0       	push   $0xc0103387
c0101b1f:	e8 b1 ff ff ff       	call   c0101ad5 <_paddr>
c0101b24:	83 c4 10             	add    $0x10,%esp
c0101b27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101b2d:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b33:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101b39:	83 ec 04             	sub    $0x4,%esp
c0101b3c:	68 00 10 00 00       	push   $0x1000
c0101b41:	6a 00                	push   $0x0
c0101b43:	50                   	push   %eax
c0101b44:	e8 48 eb ff ff       	call   c0100691 <mm_alloc>
c0101b49:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0101b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b4f:	83 ec 04             	sub    $0x4,%esp
c0101b52:	50                   	push   %eax
c0101b53:	68 00 10 00 00       	push   $0x1000
c0101b58:	6a 00                	push   $0x0
c0101b5a:	e8 19 ff ff ff       	call   c0101a78 <readseg>
c0101b5f:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0101b62:	b8 00 00 00 00       	mov    $0x0,%eax
c0101b67:	8b 00                	mov    (%eax),%eax
c0101b69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0101b6e:	0f 94 c0             	sete   %al
c0101b71:	0f b6 c0             	movzbl %al,%eax
c0101b74:	83 ec 08             	sub    $0x8,%esp
c0101b77:	50                   	push   %eax
c0101b78:	68 9b 33 10 c0       	push   $0xc010339b
c0101b7d:	e8 cb fd ff ff       	call   c010194d <printk>
c0101b82:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101b85:	b8 00 00 00 00       	mov    $0x0,%eax
c0101b8a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101b90:	b8 00 00 00 00       	mov    $0x0,%eax
c0101b95:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b99:	0f b7 c0             	movzwl %ax,%eax
c0101b9c:	c1 e0 05             	shl    $0x5,%eax
c0101b9f:	89 c2                	mov    %eax,%edx
c0101ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba4:	01 d0                	add    %edx,%eax
c0101ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101ba9:	eb 7f                	jmp    c0101c2a <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0101bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bae:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bb1:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb7:	8b 48 14             	mov    0x14(%eax),%ecx
c0101bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bbd:	8b 50 08             	mov    0x8(%eax),%edx
c0101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc3:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101bc9:	83 ec 04             	sub    $0x4,%esp
c0101bcc:	51                   	push   %ecx
c0101bcd:	52                   	push   %edx
c0101bce:	50                   	push   %eax
c0101bcf:	e8 bd ea ff ff       	call   c0100691 <mm_alloc>
c0101bd4:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bda:	8b 50 04             	mov    0x4(%eax),%edx
c0101bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be0:	01 d0                	add    %edx,%eax
c0101be2:	89 c2                	mov    %eax,%edx
c0101be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be7:	8b 40 10             	mov    0x10(%eax),%eax
c0101bea:	83 ec 04             	sub    $0x4,%esp
c0101bed:	52                   	push   %edx
c0101bee:	50                   	push   %eax
c0101bef:	ff 75 e8             	pushl  -0x18(%ebp)
c0101bf2:	e8 81 fe ff ff       	call   c0101a78 <readseg>
c0101bf7:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0101bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bfd:	8b 50 10             	mov    0x10(%eax),%edx
c0101c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101c03:	01 d0                	add    %edx,%eax
c0101c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101c08:	eb 0c                	jmp    c0101c16 <loader+0x111>
c0101c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c0d:	8d 50 01             	lea    0x1(%eax),%edx
c0101c10:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101c13:	c6 00 00             	movb   $0x0,(%eax)
c0101c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c19:	8b 50 14             	mov    0x14(%eax),%edx
c0101c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101c1f:	01 d0                	add    %edx,%eax
c0101c21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101c24:	77 e4                	ja     c0101c0a <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101c26:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0101c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101c30:	0f 82 75 ff ff ff    	jb     c0101bab <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101c36:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c3b:	8b 40 18             	mov    0x18(%eax),%eax
c0101c3e:	a3 a0 2e 10 c0       	mov    %eax,0xc0102ea0

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c46:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101c4c:	83 ec 04             	sub    $0x4,%esp
c0101c4f:	68 00 80 00 00       	push   $0x8000
c0101c54:	68 00 60 bf be       	push   $0xbebf6000
c0101c59:	50                   	push   %eax
c0101c5a:	e8 32 ea ff ff       	call   c0100691 <mm_alloc>
c0101c5f:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x7F, entry, 3);
c0101c62:	a1 a0 2e 10 c0       	mov    0xc0102ea0,%eax
c0101c67:	6a 03                	push   $0x3
c0101c69:	50                   	push   %eax
c0101c6a:	68 81 df bf be       	push   $0xbebfdf81
c0101c6f:	ff 75 08             	pushl  0x8(%ebp)
c0101c72:	e8 d0 07 00 00       	call   c0102447 <init_pcb>
c0101c77:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0101c7a:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101c7f:	83 ec 04             	sub    $0x4,%esp
c0101c82:	50                   	push   %eax
c0101c83:	6a 39                	push   $0x39
c0101c85:	68 87 33 10 c0       	push   $0xc0103387
c0101c8a:	e8 46 fe ff ff       	call   c0101ad5 <_paddr>
c0101c8f:	83 c4 10             	add    $0x10,%esp
c0101c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101c98:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0101c9b:	c9                   	leave  
c0101c9c:	c3                   	ret    

c0101c9d <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0101c9d:	55                   	push   %ebp
c0101c9e:	89 e5                	mov    %esp,%ebp
c0101ca0:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca6:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101cac:	83 ec 04             	sub    $0x4,%esp
c0101caf:	50                   	push   %eax
c0101cb0:	6a 42                	push   $0x42
c0101cb2:	68 87 33 10 c0       	push   $0xc0103387
c0101cb7:	e8 19 fe ff ff       	call   c0101ad5 <_paddr>
c0101cbc:	83 c4 10             	add    $0x10,%esp
c0101cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cc5:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0101cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ccb:	a3 a0 2e 10 c0       	mov    %eax,0xc0102ea0
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x7F, entry, 0);
c0101cd0:	a1 a0 2e 10 c0       	mov    0xc0102ea0,%eax
c0101cd5:	8b 55 08             	mov    0x8(%ebp),%edx
c0101cd8:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0101cde:	83 ea 7f             	sub    $0x7f,%edx
c0101ce1:	6a 00                	push   $0x0
c0101ce3:	50                   	push   %eax
c0101ce4:	52                   	push   %edx
c0101ce5:	ff 75 08             	pushl  0x8(%ebp)
c0101ce8:	e8 5a 07 00 00       	call   c0102447 <init_pcb>
c0101ced:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0101cf0:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101cf5:	83 ec 04             	sub    $0x4,%esp
c0101cf8:	50                   	push   %eax
c0101cf9:	6a 46                	push   $0x46
c0101cfb:	68 87 33 10 c0       	push   $0xc0103387
c0101d00:	e8 d0 fd ff ff       	call   c0101ad5 <_paddr>
c0101d05:	83 c4 10             	add    $0x10,%esp
c0101d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d0e:	0f 22 d8             	mov    %eax,%cr3

c0101d11:	c9                   	leave  
c0101d12:	c3                   	ret    

c0101d13 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101d13:	55                   	push   %ebp
c0101d14:	89 e5                	mov    %esp,%ebp
c0101d16:	83 ec 04             	sub    $0x4,%esp
c0101d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101d1f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101d23:	83 e8 61             	sub    $0x61,%eax
c0101d26:	8b 04 85 40 50 15 c0 	mov    -0x3feaafc0(,%eax,4),%eax
}
c0101d2d:	c9                   	leave  
c0101d2e:	c3                   	ret    

c0101d2f <get_lastkey>:
int8_t get_lastkey(){
c0101d2f:	55                   	push   %ebp
c0101d30:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101d32:	a1 a8 50 15 c0       	mov    0xc01550a8,%eax
c0101d37:	83 c0 61             	add    $0x61,%eax
}
c0101d3a:	5d                   	pop    %ebp
c0101d3b:	c3                   	ret    

c0101d3c <press_key>:
void press_key(int code){
c0101d3c:	55                   	push   %ebp
c0101d3d:	89 e5                	mov    %esp,%ebp
c0101d3f:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101d42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4c:	25 80 00 00 00       	and    $0x80,%eax
c0101d51:	85 c0                	test   %eax,%eax
c0101d53:	75 35                	jne    c0101d8a <press_key+0x4e>
		for(;i<26;i++){
c0101d55:	eb 2b                	jmp    c0101d82 <press_key+0x46>
			if(letter[i]==code){
c0101d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d5a:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101d61:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101d64:	75 18                	jne    c0101d7e <press_key+0x42>
				keydown[i] = 1;
c0101d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d69:	c7 04 85 40 50 15 c0 	movl   $0x1,-0x3feaafc0(,%eax,4)
c0101d70:	01 00 00 00 
				lastkey = i;
c0101d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d77:	a3 a8 50 15 c0       	mov    %eax,0xc01550a8
				return;
c0101d7c:	eb 3b                	jmp    c0101db9 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101d7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101d82:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101d86:	7e cf                	jle    c0101d57 <press_key+0x1b>
c0101d88:	eb 2f                	jmp    c0101db9 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101d8a:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101d8e:	eb 23                	jmp    c0101db3 <press_key+0x77>
			if(letter[i]==code){
c0101d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d93:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101d9a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101d9d:	75 10                	jne    c0101daf <press_key+0x73>
				keydown[i] = 0;
c0101d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101da2:	c7 04 85 40 50 15 c0 	movl   $0x0,-0x3feaafc0(,%eax,4)
c0101da9:	00 00 00 00 
				return;
c0101dad:	eb 0a                	jmp    c0101db9 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101daf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101db3:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101db7:	7e d7                	jle    c0101d90 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101db9:	c9                   	leave  
c0101dba:	c3                   	ret    

c0101dbb <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101dbb:	55                   	push   %ebp
c0101dbc:	89 e5                	mov    %esp,%ebp
c0101dbe:	83 ec 10             	sub    $0x10,%esp
c0101dc1:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dcb:	89 c2                	mov    %eax,%edx
c0101dcd:	ec                   	in     (%dx),%al
c0101dce:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101dd1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101dd5:	0f b6 c0             	movzbl %al,%eax
c0101dd8:	83 e0 20             	and    $0x20,%eax
c0101ddb:	85 c0                	test   %eax,%eax
c0101ddd:	0f 95 c0             	setne  %al
c0101de0:	0f b6 c0             	movzbl %al,%eax
}
c0101de3:	c9                   	leave  
c0101de4:	c3                   	ret    

c0101de5 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	83 ec 14             	sub    $0x14,%esp
c0101deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dee:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101df1:	90                   	nop
c0101df2:	e8 c4 ff ff ff       	call   c0101dbb <serial_idle>
c0101df7:	85 c0                	test   %eax,%eax
c0101df9:	74 f7                	je     c0101df2 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101dfb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101dff:	0f b6 c0             	movzbl %al,%eax
c0101e02:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101e09:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101e0c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101e10:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101e13:	ee                   	out    %al,(%dx)
}
c0101e14:	c9                   	leave  
c0101e15:	c3                   	ret    

c0101e16 <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101e16:	55                   	push   %ebp
c0101e17:	89 e5                	mov    %esp,%ebp
c0101e19:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1f:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e22:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101e27:	0f 84 6d 02 00 00    	je     c010209a <do_syscall+0x284>
c0101e2d:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101e32:	0f 87 97 00 00 00    	ja     c0101ecf <do_syscall+0xb9>
c0101e38:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101e3d:	0f 84 9c 02 00 00    	je     c01020df <do_syscall+0x2c9>
c0101e43:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101e48:	77 3d                	ja     c0101e87 <do_syscall+0x71>
c0101e4a:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101e4f:	0f 84 70 02 00 00    	je     c01020c5 <do_syscall+0x2af>
c0101e55:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101e5a:	77 10                	ja     c0101e6c <do_syscall+0x56>
c0101e5c:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101e61:	0f 84 47 02 00 00    	je     c01020ae <do_syscall+0x298>
c0101e67:	e9 c8 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101e6c:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101e71:	0f 84 55 02 00 00    	je     c01020cc <do_syscall+0x2b6>
c0101e77:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101e7c:	0f 84 51 02 00 00    	je     c01020d3 <do_syscall+0x2bd>
c0101e82:	e9 ad 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101e87:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101e8c:	0f 84 f4 01 00 00    	je     c0102086 <do_syscall+0x270>
c0101e92:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101e97:	77 1b                	ja     c0101eb4 <do_syscall+0x9e>
c0101e99:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101e9e:	0f 84 62 02 00 00    	je     c0102106 <do_syscall+0x2f0>
c0101ea4:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101ea9:	0f 84 77 02 00 00    	je     c0102126 <do_syscall+0x310>
c0101eaf:	e9 80 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101eb4:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101eb9:	0f 84 70 01 00 00    	je     c010202f <do_syscall+0x219>
c0101ebf:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101ec4:	0f 84 91 01 00 00    	je     c010205b <do_syscall+0x245>
c0101eca:	e9 65 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101ecf:	3d 40 06 00 00       	cmp    $0x640,%eax
c0101ed4:	74 78                	je     c0101f4e <do_syscall+0x138>
c0101ed6:	3d 40 06 00 00       	cmp    $0x640,%eax
c0101edb:	77 31                	ja     c0101f0e <do_syscall+0xf8>
c0101edd:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101ee2:	0f 84 5d 01 00 00    	je     c0102045 <do_syscall+0x22f>
c0101ee8:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101eed:	0f 82 b1 01 00 00    	jb     c01020a4 <do_syscall+0x28e>
c0101ef3:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0101ef8:	0f 84 1a 01 00 00    	je     c0102018 <do_syscall+0x202>
c0101efe:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0101f03:	0f 84 f1 00 00 00    	je     c0101ffa <do_syscall+0x1e4>
c0101f09:	e9 26 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101f0e:	3d 43 06 00 00       	cmp    $0x643,%eax
c0101f13:	0f 84 94 00 00 00    	je     c0101fad <do_syscall+0x197>
c0101f19:	3d 43 06 00 00       	cmp    $0x643,%eax
c0101f1e:	77 13                	ja     c0101f33 <do_syscall+0x11d>
c0101f20:	3d 41 06 00 00       	cmp    $0x641,%eax
c0101f25:	74 47                	je     c0101f6e <do_syscall+0x158>
c0101f27:	3d 42 06 00 00       	cmp    $0x642,%eax
c0101f2c:	74 68                	je     c0101f96 <do_syscall+0x180>
c0101f2e:	e9 01 02 00 00       	jmp    c0102134 <do_syscall+0x31e>
c0101f33:	3d 44 06 00 00       	cmp    $0x644,%eax
c0101f38:	0f 84 86 00 00 00    	je     c0101fc4 <do_syscall+0x1ae>
c0101f3e:	3d 45 06 00 00       	cmp    $0x645,%eax
c0101f43:	0f 84 92 00 00 00    	je     c0101fdb <do_syscall+0x1c5>
c0101f49:	e9 e6 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f51:	8b 40 18             	mov    0x18(%eax),%eax
c0101f54:	89 c2                	mov    %eax,%edx
c0101f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f59:	8b 40 10             	mov    0x10(%eax),%eax
c0101f5c:	83 ec 08             	sub    $0x8,%esp
c0101f5f:	52                   	push   %edx
c0101f60:	50                   	push   %eax
c0101f61:	e8 ab ef ff ff       	call   c0100f11 <sem_init_kr>
c0101f66:	83 c4 10             	add    $0x10,%esp
		break;
c0101f69:	e9 c6 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f71:	8b 40 18             	mov    0x18(%eax),%eax
c0101f74:	89 c2                	mov    %eax,%edx
c0101f76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f79:	8b 40 10             	mov    0x10(%eax),%eax
c0101f7c:	83 ec 08             	sub    $0x8,%esp
c0101f7f:	52                   	push   %edx
c0101f80:	50                   	push   %eax
c0101f81:	e8 63 f0 ff ff       	call   c0100fe9 <sem_open_kr>
c0101f86:	83 c4 10             	add    $0x10,%esp
c0101f89:	89 c2                	mov    %eax,%edx
c0101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101f91:	e9 9e 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0101f96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f99:	8b 40 10             	mov    0x10(%eax),%eax
c0101f9c:	83 ec 0c             	sub    $0xc,%esp
c0101f9f:	50                   	push   %eax
c0101fa0:	e8 a3 ef ff ff       	call   c0100f48 <sem_post_kr>
c0101fa5:	83 c4 10             	add    $0x10,%esp
		break;
c0101fa8:	e9 87 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c0101fad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb0:	8b 40 10             	mov    0x10(%eax),%eax
c0101fb3:	83 ec 0c             	sub    $0xc,%esp
c0101fb6:	50                   	push   %eax
c0101fb7:	e8 d5 ef ff ff       	call   c0100f91 <sem_wait_kr>
c0101fbc:	83 c4 10             	add    $0x10,%esp
		break;
c0101fbf:	e9 70 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0101fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc7:	8b 40 10             	mov    0x10(%eax),%eax
c0101fca:	83 ec 0c             	sub    $0xc,%esp
c0101fcd:	50                   	push   %eax
c0101fce:	e8 5e ef ff ff       	call   c0100f31 <sem_close_kr>
c0101fd3:	83 c4 10             	add    $0x10,%esp
		break;
c0101fd6:	e9 59 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fde:	8b 40 10             	mov    0x10(%eax),%eax
c0101fe1:	83 ec 0c             	sub    $0xc,%esp
c0101fe4:	50                   	push   %eax
c0101fe5:	e8 f4 ef ff ff       	call   c0100fde <sem_get_kr>
c0101fea:	83 c4 10             	add    $0x10,%esp
c0101fed:	89 c2                	mov    %eax,%edx
c0101fef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff2:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101ff5:	e9 3a 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx);
c0101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ffd:	8b 50 18             	mov    0x18(%eax),%edx
c0102000:	8b 45 08             	mov    0x8(%ebp),%eax
c0102003:	8b 40 10             	mov    0x10(%eax),%eax
c0102006:	83 ec 08             	sub    $0x8,%esp
c0102009:	52                   	push   %edx
c010200a:	50                   	push   %eax
c010200b:	e8 ec 08 00 00       	call   c01028fc <thread_current>
c0102010:	83 c4 10             	add    $0x10,%esp
		break;
c0102013:	e9 1c 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_JOIN:
			join_current(tf->ebx);
c0102018:	8b 45 08             	mov    0x8(%ebp),%eax
c010201b:	8b 40 10             	mov    0x10(%eax),%eax
c010201e:	83 ec 0c             	sub    $0xc,%esp
c0102021:	50                   	push   %eax
c0102022:	e8 41 0a 00 00       	call   c0102a68 <join_current>
c0102027:	83 c4 10             	add    $0x10,%esp
		break;
c010202a:	e9 05 01 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_PID:
			tf->eax = current->pid;
c010202f:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102034:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c010203a:	8b 45 08             	mov    0x8(%ebp),%eax
c010203d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102040:	e9 ef 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_PPID:
			tf->eax = current->ppid;
c0102045:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010204a:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c0102050:	8b 45 08             	mov    0x8(%ebp),%eax
c0102053:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102056:	e9 d9 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c010205b:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102060:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c0102067:	00 00 00 
			current->timeslice = tf->ebx*200;
c010206a:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010206f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102072:	8b 52 10             	mov    0x10(%edx),%edx
c0102075:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c010207b:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c0102081:	e9 ae 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_HANDOUT:
			current->ts = STOP;
c0102086:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010208b:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c0102092:	00 00 00 
		break;
c0102095:	e9 9a 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_EXIT:
			exit_current();
c010209a:	e8 47 09 00 00       	call   c01029e6 <exit_current>
		break;
c010209f:	e9 90 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_FORK:
			fork_current();
c01020a4:	e8 e1 07 00 00       	call   c010288a <fork_current>
		break;
c01020a9:	e9 86 00 00 00       	jmp    c0102134 <do_syscall+0x31e>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c01020ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b1:	8b 40 10             	mov    0x10(%eax),%eax
c01020b4:	0f be c0             	movsbl %al,%eax
c01020b7:	83 ec 0c             	sub    $0xc,%esp
c01020ba:	50                   	push   %eax
c01020bb:	e8 25 fd ff ff       	call   c0101de5 <serial_printc>
c01020c0:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c01020c3:	eb 6f                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_INIT_CACHE:
			initVCache();
c01020c5:	e8 58 0a 00 00       	call   c0102b22 <initVCache>
		break;
c01020ca:	eb 68                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c01020cc:	e8 86 0b 00 00       	call   c0102c57 <clearVRAM>
		break;
c01020d1:	eb 61                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c01020d3:	e8 7f 0b 00 00       	call   c0102c57 <clearVRAM>
			flushVCache();
c01020d8:	e8 ae 0a 00 00       	call   c0102b8b <flushVCache>
		break;
c01020dd:	eb 55                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c01020df:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e2:	8b 40 14             	mov    0x14(%eax),%eax
c01020e5:	0f b6 c0             	movzbl %al,%eax
c01020e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01020eb:	8b 52 18             	mov    0x18(%edx),%edx
c01020ee:	89 d1                	mov    %edx,%ecx
c01020f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01020f3:	8b 52 10             	mov    0x10(%edx),%edx
c01020f6:	83 ec 04             	sub    $0x4,%esp
c01020f9:	50                   	push   %eax
c01020fa:	51                   	push   %ecx
c01020fb:	52                   	push   %edx
c01020fc:	e8 ef 0a 00 00       	call   c0102bf0 <setPixelAt>
c0102101:	83 c4 10             	add    $0x10,%esp
		break;
c0102104:	eb 2e                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0102106:	8b 45 08             	mov    0x8(%ebp),%eax
c0102109:	8b 40 10             	mov    0x10(%eax),%eax
c010210c:	0f be c0             	movsbl %al,%eax
c010210f:	83 ec 0c             	sub    $0xc,%esp
c0102112:	50                   	push   %eax
c0102113:	e8 fb fb ff ff       	call   c0101d13 <get_key>
c0102118:	83 c4 10             	add    $0x10,%esp
c010211b:	0f be d0             	movsbl %al,%edx
c010211e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102121:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102124:	eb 0e                	jmp    c0102134 <do_syscall+0x31e>
		case SYS_GET_TICK:
			tf->eax = tick();
c0102126:	e8 78 0c 00 00       	call   c0102da3 <tick>
c010212b:	89 c2                	mov    %eax,%edx
c010212d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102130:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0102133:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0102134:	c9                   	leave  
c0102135:	c3                   	ret    

c0102136 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102136:	55                   	push   %ebp
c0102137:	89 e5                	mov    %esp,%ebp
c0102139:	83 ec 10             	sub    $0x10,%esp
c010213c:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102143:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102146:	89 c2                	mov    %eax,%edx
c0102148:	ec                   	in     (%dx),%al
c0102149:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010214c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102150:	0f b6 c0             	movzbl %al,%eax
c0102153:	83 e0 20             	and    $0x20,%eax
c0102156:	85 c0                	test   %eax,%eax
c0102158:	0f 95 c0             	setne  %al
c010215b:	0f b6 c0             	movzbl %al,%eax
}
c010215e:	c9                   	leave  
c010215f:	c3                   	ret    

c0102160 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102160:	55                   	push   %ebp
c0102161:	89 e5                	mov    %esp,%ebp
c0102163:	83 ec 14             	sub    $0x14,%esp
c0102166:	8b 45 08             	mov    0x8(%ebp),%eax
c0102169:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010216c:	90                   	nop
c010216d:	e8 c4 ff ff ff       	call   c0102136 <serial_idle>
c0102172:	85 c0                	test   %eax,%eax
c0102174:	74 f7                	je     c010216d <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102176:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010217a:	0f b6 c0             	movzbl %al,%eax
c010217d:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102184:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102187:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010218b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010218e:	ee                   	out    %al,(%dx)
}
c010218f:	c9                   	leave  
c0102190:	c3                   	ret    

c0102191 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102191:	55                   	push   %ebp
c0102192:	89 e5                	mov    %esp,%ebp
c0102194:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102197:	8d 45 0c             	lea    0xc(%ebp),%eax
c010219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010219d:	8b 45 08             	mov    0x8(%ebp),%eax
c01021a0:	83 ec 04             	sub    $0x4,%esp
c01021a3:	ff 75 f4             	pushl  -0xc(%ebp)
c01021a6:	50                   	push   %eax
c01021a7:	68 60 21 10 c0       	push   $0xc0102160
c01021ac:	e8 76 0d 00 00       	call   c0102f27 <vfprintf>
c01021b1:	83 c4 10             	add    $0x10,%esp
}
c01021b4:	c9                   	leave  
c01021b5:	c3                   	ret    

c01021b6 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c01021b6:	55                   	push   %ebp
c01021b7:	89 e5                	mov    %esp,%ebp
c01021b9:	57                   	push   %edi
c01021ba:	56                   	push   %esi
c01021bb:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c01021bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01021c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01021c5:	89 c1                	mov    %eax,%ecx
c01021c7:	89 d6                	mov    %edx,%esi
c01021c9:	89 df                	mov    %ebx,%edi
c01021cb:	fc                   	cld    
c01021cc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c01021ce:	5b                   	pop    %ebx
c01021cf:	5e                   	pop    %esi
c01021d0:	5f                   	pop    %edi
c01021d1:	5d                   	pop    %ebp
c01021d2:	c3                   	ret    

c01021d3 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01021d3:	55                   	push   %ebp
c01021d4:	89 e5                	mov    %esp,%ebp
c01021d6:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01021d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01021dc:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01021e1:	77 16                	ja     c01021f9 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01021e3:	ff 75 10             	pushl  0x10(%ebp)
c01021e6:	68 b0 33 10 c0       	push   $0xc01033b0
c01021eb:	ff 75 0c             	pushl  0xc(%ebp)
c01021ee:	ff 75 08             	pushl  0x8(%ebp)
c01021f1:	e8 9b ff ff ff       	call   c0102191 <printk>
c01021f6:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01021f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01021fc:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102201:	c9                   	leave  
c0102202:	c3                   	ret    

c0102203 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0102203:	55                   	push   %ebp
c0102204:	89 e5                	mov    %esp,%ebp
c0102206:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0102209:	8b 45 10             	mov    0x10(%ebp),%eax
c010220c:	c1 e8 0c             	shr    $0xc,%eax
c010220f:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102214:	76 13                	jbe    c0102229 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0102216:	83 ec 08             	sub    $0x8,%esp
c0102219:	ff 75 10             	pushl  0x10(%ebp)
c010221c:	68 d4 33 10 c0       	push   $0xc01033d4
c0102221:	e8 6b ff ff ff       	call   c0102191 <printk>
c0102226:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0102229:	8b 45 10             	mov    0x10(%ebp),%eax
c010222c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102231:	c9                   	leave  
c0102232:	c3                   	ret    

c0102233 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0102233:	55                   	push   %ebp
c0102234:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0102236:	8b 45 08             	mov    0x8(%ebp),%eax
c0102239:	ba 00 47 17 c0       	mov    $0xc0174700,%edx
c010223e:	29 d0                	sub    %edx,%eax
c0102240:	c1 f8 03             	sar    $0x3,%eax
c0102243:	c1 e0 0c             	shl    $0xc,%eax
}
c0102246:	5d                   	pop    %ebp
c0102247:	c3                   	ret    

c0102248 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0102248:	55                   	push   %ebp
c0102249:	89 e5                	mov    %esp,%ebp
c010224b:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010224e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102251:	c1 e8 0c             	shr    $0xc,%eax
c0102254:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102259:	76 10                	jbe    c010226b <pa2page+0x23>
		printk("pa2page called with invalid pa");
c010225b:	83 ec 0c             	sub    $0xc,%esp
c010225e:	68 f8 33 10 c0       	push   $0xc01033f8
c0102263:	e8 29 ff ff ff       	call   c0102191 <printk>
c0102268:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c010226b:	8b 45 08             	mov    0x8(%ebp),%eax
c010226e:	c1 e8 0c             	shr    $0xc,%eax
c0102271:	c1 e0 03             	shl    $0x3,%eax
c0102274:	05 00 47 17 c0       	add    $0xc0174700,%eax
}
c0102279:	c9                   	leave  
c010227a:	c3                   	ret    

c010227b <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c010227b:	55                   	push   %ebp
c010227c:	89 e5                	mov    %esp,%ebp
c010227e:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0102281:	ff 75 08             	pushl  0x8(%ebp)
c0102284:	e8 aa ff ff ff       	call   c0102233 <page2pa>
c0102289:	83 c4 04             	add    $0x4,%esp
c010228c:	83 ec 04             	sub    $0x4,%esp
c010228f:	50                   	push   %eax
c0102290:	6a 52                	push   $0x52
c0102292:	68 17 34 10 c0       	push   $0xc0103417
c0102297:	e8 67 ff ff ff       	call   c0102203 <_kaddr>
c010229c:	83 c4 10             	add    $0x10,%esp
}
c010229f:	c9                   	leave  
c01022a0:	c3                   	ret    

c01022a1 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c01022a1:	55                   	push   %ebp
c01022a2:	89 e5                	mov    %esp,%ebp
c01022a4:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c01022a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c01022ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b1:	8b 00                	mov    (%eax),%eax
c01022b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c01022b6:	eb 10                	jmp    c01022c8 <ll_len+0x27>
		p = p->next;
c01022b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022bb:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01022c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c01022c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c01022c8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01022cc:	75 ea                	jne    c01022b8 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c01022ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01022d1:	c9                   	leave  
c01022d2:	c3                   	ret    

c01022d3 <ll_pop>:
PCB* ll_pop(PCB** head){
c01022d3:	55                   	push   %ebp
c01022d4:	89 e5                	mov    %esp,%ebp
c01022d6:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c01022d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022dc:	8b 00                	mov    (%eax),%eax
c01022de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c01022e1:	83 ec 08             	sub    $0x8,%esp
c01022e4:	ff 75 f4             	pushl  -0xc(%ebp)
c01022e7:	ff 75 08             	pushl  0x8(%ebp)
c01022ea:	e8 a4 00 00 00       	call   c0102393 <ll_delete>
c01022ef:	83 c4 10             	add    $0x10,%esp
	return p;
c01022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01022f5:	c9                   	leave  
c01022f6:	c3                   	ret    

c01022f7 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c01022f7:	55                   	push   %ebp
c01022f8:	89 e5                	mov    %esp,%ebp
c01022fa:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c01022fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102300:	8b 00                	mov    (%eax),%eax
c0102302:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0102305:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102309:	75 0f                	jne    c010231a <ll_push+0x23>
		*head = p;
c010230b:	8b 45 08             	mov    0x8(%ebp),%eax
c010230e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102311:	89 10                	mov    %edx,(%eax)
		return 0;
c0102313:	b8 00 00 00 00       	mov    $0x0,%eax
c0102318:	eb 19                	jmp    c0102333 <ll_push+0x3c>
	}else{
		*head = p;
c010231a:	8b 45 08             	mov    0x8(%ebp),%eax
c010231d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102320:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0102322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102325:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102328:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c010232e:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0102333:	c9                   	leave  
c0102334:	c3                   	ret    

c0102335 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0102335:	55                   	push   %ebp
c0102336:	89 e5                	mov    %esp,%ebp
c0102338:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010233b:	8b 45 08             	mov    0x8(%ebp),%eax
c010233e:	8b 00                	mov    (%eax),%eax
c0102340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0102343:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102346:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c010234d:	00 00 00 
	if(h == NULL){
c0102350:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102354:	75 0f                	jne    c0102365 <ll_entail+0x30>
		*head = p;
c0102356:	8b 45 08             	mov    0x8(%ebp),%eax
c0102359:	8b 55 0c             	mov    0xc(%ebp),%edx
c010235c:	89 10                	mov    %edx,(%eax)
		return 0;
c010235e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102363:	eb 2c                	jmp    c0102391 <ll_entail+0x5c>
	}else{
		while(h->next){
c0102365:	eb 0c                	jmp    c0102373 <ll_entail+0x3e>
			h = h->next;
c0102367:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010236a:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102370:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0102373:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102376:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c010237c:	85 c0                	test   %eax,%eax
c010237e:	75 e7                	jne    c0102367 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0102380:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102383:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102386:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c010238c:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0102391:	c9                   	leave  
c0102392:	c3                   	ret    

c0102393 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c0102393:	55                   	push   %ebp
c0102394:	89 e5                	mov    %esp,%ebp
c0102396:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c0102399:	8b 45 08             	mov    0x8(%ebp),%eax
c010239c:	8b 00                	mov    (%eax),%eax
c010239e:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01023a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c01023a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01023ac:	75 07                	jne    c01023b5 <ll_delete+0x22>
			return 0;
c01023ae:	b8 00 00 00 00       	mov    $0x0,%eax
c01023b3:	eb 59                	jmp    c010240e <ll_delete+0x7b>
		if(sleep == p)
c01023b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01023bb:	75 09                	jne    c01023c6 <ll_delete+0x33>
			break;
c01023bd:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c01023be:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01023c2:	75 26                	jne    c01023ea <ll_delete+0x57>
c01023c4:	eb 14                	jmp    c01023da <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c01023c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c01023cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023cf:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01023d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c01023d8:	eb ce                	jmp    c01023a8 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c01023da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023dd:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01023e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e6:	89 10                	mov    %edx,(%eax)
c01023e8:	eb 12                	jmp    c01023fc <ll_delete+0x69>
	else
		pre->next = sleep->next;
c01023ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023ed:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01023f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01023f6:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c01023fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023ff:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0102406:	00 00 00 
	return 1;
c0102409:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010240e:	c9                   	leave  
c010240f:	c3                   	ret    

c0102410 <init_pcb_pool>:

void init_pcb_pool()
{
c0102410:	55                   	push   %ebp
c0102411:	89 e5                	mov    %esp,%ebp
c0102413:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102416:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010241d:	eb 1d                	jmp    c010243c <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c010241f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102422:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102428:	05 40 20 00 00       	add    $0x2040,%eax
c010242d:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102438:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010243c:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0102443:	76 da                	jbe    c010241f <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0102445:	c9                   	leave  
c0102446:	c3                   	ret    

c0102447 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0102447:	55                   	push   %ebp
c0102448:	89 e5                	mov    %esp,%ebp
c010244a:	83 ec 24             	sub    $0x24,%esp
c010244d:	8b 45 14             	mov    0x14(%ebp),%eax
c0102450:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0102453:	8b 45 08             	mov    0x8(%ebp),%eax
c0102456:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010245c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c010245f:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0102463:	75 46                	jne    c01024ab <init_pcb+0x64>
		tf->ds = GD_KD;
c0102465:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102468:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c010246f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102472:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0102479:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010247c:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0102482:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102485:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c010248c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010248f:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0102496:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102499:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c010249f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024a2:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c01024a9:	eb 4a                	jmp    c01024f5 <init_pcb+0xae>
	}else
	if(pri == 3){
c01024ab:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c01024af:	75 44                	jne    c01024f5 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c01024b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024b4:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c01024bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024be:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c01024c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024c8:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c01024ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024d1:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c01024d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024db:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c01024e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024e5:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01024eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024ee:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c01024f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01024fb:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c01024fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102501:	8b 55 10             	mov    0x10(%ebp),%edx
c0102504:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0102507:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010250b:	75 59                	jne    c0102566 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c010250d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102510:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0102513:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102516:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0102519:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0102520:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102527:	eb 26                	jmp    c010254f <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0102529:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010252c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102536:	01 c2                	add    %eax,%edx
c0102538:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010253b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0102542:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102545:	01 c8                	add    %ecx,%eax
c0102547:	8b 00                	mov    (%eax),%eax
c0102549:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c010254b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102552:	c1 e8 02             	shr    $0x2,%eax
c0102555:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102558:	77 cf                	ja     c0102529 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c010255a:	8b 45 08             	mov    0x8(%ebp),%eax
c010255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102560:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c0102566:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010256a:	0f 95 c0             	setne  %al
c010256d:	0f b6 d0             	movzbl %al,%edx
c0102570:	8b 45 08             	mov    0x8(%ebp),%eax
c0102573:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0102579:	c9                   	leave  
c010257a:	c3                   	ret    

c010257b <pcb_create>:

PCB* pcb_create()
{
c010257b:	55                   	push   %ebp
c010257c:	89 e5                	mov    %esp,%ebp
c010257e:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102581:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102588:	eb 1f                	jmp    c01025a9 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c010258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010258d:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102593:	05 40 20 00 00       	add    $0x2040,%eax
c0102598:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c010259d:	8b 00                	mov    (%eax),%eax
c010259f:	85 c0                	test   %eax,%eax
c01025a1:	75 02                	jne    c01025a5 <pcb_create+0x2a>
c01025a3:	eb 0d                	jmp    c01025b2 <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01025a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01025a9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01025b0:	76 d8                	jbe    c010258a <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025b5:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01025bb:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c01025c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c01025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025c6:	6b c0 4c             	imul   $0x4c,%eax,%eax
c01025c9:	8d 90 40 85 1b c0    	lea    -0x3fe47ac0(%eax),%edx
c01025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025d2:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c01025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025db:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c01025e2:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c01025e5:	83 ec 0c             	sub    $0xc,%esp
c01025e8:	6a 01                	push   $0x1
c01025ea:	e8 94 e2 ff ff       	call   c0100883 <page_alloc>
c01025ef:	83 c4 10             	add    $0x10,%esp
c01025f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c01025f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01025f9:	75 07                	jne    c0102602 <pcb_create+0x87>
c01025fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0102600:	eb 77                	jmp    c0102679 <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c0102602:	83 ec 0c             	sub    $0xc,%esp
c0102605:	ff 75 ec             	pushl  -0x14(%ebp)
c0102608:	e8 6e fc ff ff       	call   c010227b <page2kva>
c010260d:	83 c4 10             	add    $0x10,%esp
c0102610:	89 c2                	mov    %eax,%edx
c0102612:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102615:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c010261b:	8b 15 ac 50 15 c0    	mov    0xc01550ac,%edx
c0102621:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102624:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c010262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010262d:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0102634:	00 00 00 
	//p->ts = READY;
	pid ++;
c0102637:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010263c:	83 c0 01             	add    $0x1,%eax
c010263f:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0102644:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102647:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010264b:	8d 50 01             	lea    0x1(%eax),%edx
c010264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102651:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0102655:	8b 15 c0 46 17 c0    	mov    0xc01746c0,%edx
c010265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010265e:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102664:	83 ec 04             	sub    $0x4,%esp
c0102667:	68 00 10 00 00       	push   $0x1000
c010266c:	52                   	push   %edx
c010266d:	50                   	push   %eax
c010266e:	e8 43 fb ff ff       	call   c01021b6 <memcpy>
c0102673:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0102676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102679:	c9                   	leave  
c010267a:	c3                   	ret    

c010267b <enready_pcb>:

void enready_pcb(PCB* pcb){
c010267b:	55                   	push   %ebp
c010267c:	89 e5                	mov    %esp,%ebp
c010267e:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0102681:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c0102686:	85 c0                	test   %eax,%eax
c0102688:	75 18                	jne    c01026a2 <enready_pcb+0x27>
		ready_list = pcb;
c010268a:	8b 45 08             	mov    0x8(%ebp),%eax
c010268d:	a3 b4 50 15 c0       	mov    %eax,0xc01550b4
		ready_list->tail = pcb;
c0102692:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c0102697:	8b 55 08             	mov    0x8(%ebp),%edx
c010269a:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c01026a0:	eb 32                	jmp    c01026d4 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01026a2:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01026a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01026aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ad:	a3 b4 50 15 c0       	mov    %eax,0xc01550b4
		ready_list->next = temp;
c01026b2:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01026b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01026ba:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c01026c0:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c01026c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01026c8:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c01026ce:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c01026d4:	c9                   	leave  
c01026d5:	c3                   	ret    

c01026d6 <switch_pcb>:

void switch_pcb(PCB* pcb){
c01026d6:	55                   	push   %ebp
c01026d7:	89 e5                	mov    %esp,%ebp
c01026d9:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01026dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01026df:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
	lcr3(PADDR(pcb -> pgdir));
c01026e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e7:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01026ed:	83 ec 04             	sub    $0x4,%esp
c01026f0:	50                   	push   %eax
c01026f1:	68 af 00 00 00       	push   $0xaf
c01026f6:	68 2d 34 10 c0       	push   $0xc010342d
c01026fb:	e8 d3 fa ff ff       	call   c01021d3 <_paddr>
c0102700:	83 c4 10             	add    $0x10,%esp
c0102703:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102709:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c010270c:	83 ec 0c             	sub    $0xc,%esp
c010270f:	ff 75 08             	pushl  0x8(%ebp)
c0102712:	e8 45 dc ff ff       	call   c010035c <enter_pcb>
c0102717:	83 c4 10             	add    $0x10,%esp
}
c010271a:	c9                   	leave  
c010271b:	c3                   	ret    

c010271c <free_pcb>:
void free_pcb(PCB* pcb){
c010271c:	55                   	push   %ebp
c010271d:	89 e5                	mov    %esp,%ebp
c010271f:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0102722:	8b 45 08             	mov    0x8(%ebp),%eax
c0102725:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010272b:	83 ec 0c             	sub    $0xc,%esp
c010272e:	50                   	push   %eax
c010272f:	e8 b3 e6 ff ff       	call   c0100de7 <free_pgdir>
c0102734:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0102737:	8b 45 08             	mov    0x8(%ebp),%eax
c010273a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102740:	83 ec 04             	sub    $0x4,%esp
c0102743:	50                   	push   %eax
c0102744:	68 b8 00 00 00       	push   $0xb8
c0102749:	68 2d 34 10 c0       	push   $0xc010342d
c010274e:	e8 80 fa ff ff       	call   c01021d3 <_paddr>
c0102753:	83 c4 10             	add    $0x10,%esp
c0102756:	83 ec 0c             	sub    $0xc,%esp
c0102759:	50                   	push   %eax
c010275a:	e8 e9 fa ff ff       	call   c0102248 <pa2page>
c010275f:	83 c4 10             	add    $0x10,%esp
c0102762:	83 ec 0c             	sub    $0xc,%esp
c0102765:	50                   	push   %eax
c0102766:	e8 a0 e1 ff ff       	call   c010090b <page_decref>
c010276b:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c010276e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102771:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c0102778:	00 00 00 

}
c010277b:	c9                   	leave  
c010277c:	c3                   	ret    

c010277d <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c010277d:	55                   	push   %ebp
c010277e:	89 e5                	mov    %esp,%ebp
c0102780:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0102783:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102786:	8b 45 08             	mov    0x8(%ebp),%eax
c0102789:	68 10 08 00 00       	push   $0x810
c010278e:	52                   	push   %edx
c010278f:	50                   	push   %eax
c0102790:	e8 21 fa ff ff       	call   c01021b6 <memcpy>
c0102795:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c0102798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010279b:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c01027a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a4:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c01027aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ad:	05 20 10 00 00       	add    $0x1020,%eax
c01027b2:	89 c2                	mov    %eax,%edx
c01027b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027b7:	05 20 10 00 00       	add    $0x1020,%eax
c01027bc:	29 c2                	sub    %eax,%edx
c01027be:	89 d0                	mov    %edx,%eax
c01027c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c01027c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027c6:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c01027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01027cf:	01 c2                	add    %eax,%edx
c01027d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d4:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c01027da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027dd:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c01027e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e6:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL || dst->tt == THREAD){
c01027ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ef:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c01027f5:	85 c0                	test   %eax,%eax
c01027f7:	74 0e                	je     c0102807 <copy_pcb+0x8a>
c01027f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fc:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0102802:	83 f8 02             	cmp    $0x2,%eax
c0102805:	75 62                	jne    c0102869 <copy_pcb+0xec>
		
		dst->tf->ebp += offset;
c0102807:	8b 45 08             	mov    0x8(%ebp),%eax
c010280a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102810:	8b 55 08             	mov    0x8(%ebp),%edx
c0102813:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c0102819:	8b 4a 08             	mov    0x8(%edx),%ecx
c010281c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010281f:	01 ca                	add    %ecx,%edx
c0102821:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0102824:	8b 45 08             	mov    0x8(%ebp),%eax
c0102827:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010282d:	8b 40 08             	mov    0x8(%eax),%eax
c0102830:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0102833:	eb 17                	jmp    c010284c <copy_pcb+0xcf>
			*(ptr) += offset;
c0102835:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102838:	8b 10                	mov    (%eax),%edx
c010283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010283d:	01 c2                	add    %eax,%edx
c010283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102842:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0102844:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102847:	8b 00                	mov    (%eax),%eax
c0102849:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL || dst->tt == THREAD){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c010284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010284f:	8b 00                	mov    (%eax),%eax
c0102851:	85 c0                	test   %eax,%eax
c0102853:	75 e0                	jne    c0102835 <copy_pcb+0xb8>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0102855:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102858:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c010285e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102861:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
	dst->tf = (void*)src->tf + offset;
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;

	if(dst->tt == KERNEL || dst->tt == THREAD){
c0102867:	eb 1f                	jmp    c0102888 <copy_pcb+0x10b>
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
	}else{
		copy_pgdir(dst->pgdir, src->pgdir);
c0102869:	8b 45 0c             	mov    0xc(%ebp),%eax
c010286c:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0102872:	8b 45 08             	mov    0x8(%ebp),%eax
c0102875:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010287b:	83 ec 08             	sub    $0x8,%esp
c010287e:	52                   	push   %edx
c010287f:	50                   	push   %eax
c0102880:	e8 ad e2 ff ff       	call   c0100b32 <copy_pgdir>
c0102885:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c0102888:	c9                   	leave  
c0102889:	c3                   	ret    

c010288a <fork_current>:

void switch_proc();
void fork_current(){
c010288a:	55                   	push   %ebp
c010288b:	89 e5                	mov    %esp,%ebp
c010288d:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0102890:	e8 e6 fc ff ff       	call   c010257b <pcb_create>
c0102895:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c0102898:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010289d:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028a6:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01028ac:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01028b1:	83 ec 08             	sub    $0x8,%esp
c01028b4:	50                   	push   %eax
c01028b5:	ff 75 f4             	pushl  -0xc(%ebp)
c01028b8:	e8 c0 fe ff ff       	call   c010277d <copy_pcb>
c01028bd:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c01028c0:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01028c5:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01028cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01028ce:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c01028d4:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028da:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01028e0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c01028e7:	83 ec 08             	sub    $0x8,%esp
c01028ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01028ed:	68 b4 50 15 c0       	push   $0xc01550b4
c01028f2:	e8 00 fa ff ff       	call   c01022f7 <ll_push>
c01028f7:	83 c4 10             	add    $0x10,%esp
}
c01028fa:	c9                   	leave  
c01028fb:	c3                   	ret    

c01028fc <thread_current>:

void thread_current(uint32_t entry, uint32_t esp){
c01028fc:	55                   	push   %ebp
c01028fd:	89 e5                	mov    %esp,%ebp
c01028ff:	83 ec 18             	sub    $0x18,%esp
	//printk("ahh? %x\n", entry);
	PCB* son = pcb_create();
c0102902:	e8 74 fc ff ff       	call   c010257b <pcb_create>
c0102907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	son->tt = THREAD;
c010290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010290d:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0102914:	00 00 00 



	son->ppid = current->pid;
c0102917:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010291c:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102925:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c010292b:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102930:	83 ec 08             	sub    $0x8,%esp
c0102933:	50                   	push   %eax
c0102934:	ff 75 f4             	pushl  -0xc(%ebp)
c0102937:	e8 41 fe ff ff       	call   c010277d <copy_pcb>
c010293c:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c010293f:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102944:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102953:	83 ec 04             	sub    $0x4,%esp
c0102956:	68 00 10 00 00       	push   $0x1000
c010295b:	52                   	push   %edx
c010295c:	50                   	push   %eax
c010295d:	e8 54 f8 ff ff       	call   c01021b6 <memcpy>
c0102962:	83 c4 10             	add    $0x10,%esp
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0102965:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102968:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c010296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102971:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102977:	83 ec 04             	sub    $0x4,%esp
c010297a:	68 00 20 00 00       	push   $0x2000
c010297f:	52                   	push   %edx
c0102980:	50                   	push   %eax
c0102981:	e8 0b dd ff ff       	call   c0100691 <mm_alloc>
c0102986:	83 c4 10             	add    $0x10,%esp

	son->tf->esp = esp-0x7F;
c0102989:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010298c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102992:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102995:	83 ea 7f             	sub    $0x7f,%edx
c0102998:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c010299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01029a4:	8b 55 08             	mov    0x8(%ebp),%edx
c01029a7:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c01029aa:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01029af:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01029b8:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c01029be:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029c4:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01029ca:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	ll_push(&ready_list, son);
c01029d1:	83 ec 08             	sub    $0x8,%esp
c01029d4:	ff 75 f4             	pushl  -0xc(%ebp)
c01029d7:	68 b4 50 15 c0       	push   $0xc01550b4
c01029dc:	e8 16 f9 ff ff       	call   c01022f7 <ll_push>
c01029e1:	83 c4 10             	add    $0x10,%esp
}
c01029e4:	c9                   	leave  
c01029e5:	c3                   	ret    

c01029e6 <exit_current>:

void exit_current(){
c01029e6:	55                   	push   %ebp
c01029e7:	89 e5                	mov    %esp,%ebp
c01029e9:	83 ec 18             	sub    $0x18,%esp
	free_pcb(current);
c01029ec:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01029f1:	83 ec 0c             	sub    $0xc,%esp
c01029f4:	50                   	push   %eax
c01029f5:	e8 22 fd ff ff       	call   c010271c <free_pcb>
c01029fa:	83 c4 10             	add    $0x10,%esp
	lcr3(PADDR(kern_pgdir));
c01029fd:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0102a02:	83 ec 04             	sub    $0x4,%esp
c0102a05:	50                   	push   %eax
c0102a06:	68 02 01 00 00       	push   $0x102
c0102a0b:	68 2d 34 10 c0       	push   $0xc010342d
c0102a10:	e8 be f7 ff ff       	call   c01021d3 <_paddr>
c0102a15:	83 c4 10             	add    $0x10,%esp
c0102a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a1e:	0f 22 d8             	mov    %eax,%cr3

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0102a21:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102a26:	05 68 20 00 00       	add    $0x2068,%eax
c0102a2b:	83 ec 0c             	sub    $0xc,%esp
c0102a2e:	50                   	push   %eax
c0102a2f:	e8 9f f8 ff ff       	call   c01022d3 <ll_pop>
c0102a34:	83 c4 10             	add    $0x10,%esp
c0102a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL)break;
c0102a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a3e:	75 02                	jne    c0102a42 <exit_current+0x5c>
c0102a40:	eb 15                	jmp    c0102a57 <exit_current+0x71>
		ll_entail(&ready_list, p);
c0102a42:	83 ec 08             	sub    $0x8,%esp
c0102a45:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a48:	68 b4 50 15 c0       	push   $0xc01550b4
c0102a4d:	e8 e3 f8 ff ff       	call   c0102335 <ll_entail>
c0102a52:	83 c4 10             	add    $0x10,%esp
	}
c0102a55:	eb ca                	jmp    c0102a21 <exit_current+0x3b>

	current = NULL;
c0102a57:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c0102a5e:	00 00 00 
	do_scheduler();
c0102a61:	e8 b0 e5 ff ff       	call   c0101016 <do_scheduler>
}
c0102a66:	c9                   	leave  
c0102a67:	c3                   	ret    

c0102a68 <join_current>:

void join_current(int pid){
c0102a68:	55                   	push   %ebp
c0102a69:	89 e5                	mov    %esp,%ebp
c0102a6b:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102a6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102a75:	eb 3c                	jmp    c0102ab3 <join_current+0x4b>
		if(PCBPool[i].pid == pid && PCBPool[i].used)break;
c0102a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7a:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102a80:	05 40 20 00 00       	add    $0x2040,%eax
c0102a85:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102a8a:	8b 50 04             	mov    0x4(%eax),%edx
c0102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a90:	39 c2                	cmp    %eax,%edx
c0102a92:	75 1b                	jne    c0102aaf <join_current+0x47>
c0102a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a97:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102a9d:	05 40 20 00 00       	add    $0x2040,%eax
c0102aa2:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102aa7:	8b 00                	mov    (%eax),%eax
c0102aa9:	85 c0                	test   %eax,%eax
c0102aab:	74 02                	je     c0102aaf <join_current+0x47>
c0102aad:	eb 0d                	jmp    c0102abc <join_current+0x54>
	do_scheduler();
}

void join_current(int pid){
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102aaf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102ab3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0102aba:	76 bb                	jbe    c0102a77 <join_current+0xf>
		if(PCBPool[i].pid == pid && PCBPool[i].used)break;
	}
	if(i == PCBPOOLMAX) return;
c0102abc:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0102ac3:	75 02                	jne    c0102ac7 <join_current+0x5f>
c0102ac5:	eb 3c                	jmp    c0102b03 <join_current+0x9b>

	PCB *p = &PCBPool[i];
c0102ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aca:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102ad0:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0102ad8:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102add:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0102ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ae3:	05 68 20 00 00       	add    $0x2068,%eax
c0102ae8:	ff 75 ec             	pushl  -0x14(%ebp)
c0102aeb:	50                   	push   %eax
c0102aec:	e8 44 f8 ff ff       	call   c0102335 <ll_entail>
c0102af1:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0102af4:	c7 05 b0 50 15 c0 00 	movl   $0x0,0xc01550b0
c0102afb:	00 00 00 
	do_scheduler();
c0102afe:	e8 13 e5 ff ff       	call   c0101016 <do_scheduler>
c0102b03:	c9                   	leave  
c0102b04:	c3                   	ret    

c0102b05 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0102b05:	55                   	push   %ebp
c0102b06:	89 e5                	mov    %esp,%ebp
c0102b08:	57                   	push   %edi
c0102b09:	56                   	push   %esi
c0102b0a:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102b0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0102b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102b14:	89 c1                	mov    %eax,%ecx
c0102b16:	89 d6                	mov    %edx,%esi
c0102b18:	89 df                	mov    %ebx,%edi
c0102b1a:	fc                   	cld    
c0102b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102b1d:	5b                   	pop    %ebx
c0102b1e:	5e                   	pop    %esi
c0102b1f:	5f                   	pop    %edi
c0102b20:	5d                   	pop    %ebp
c0102b21:	c3                   	ret    

c0102b22 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0102b22:	55                   	push   %ebp
c0102b23:	89 e5                	mov    %esp,%ebp
c0102b25:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102b28:	68 80 3e 00 00       	push   $0x3e80
c0102b2d:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102b32:	68 c0 50 15 c0       	push   $0xc01550c0
c0102b37:	e8 c9 ff ff ff       	call   c0102b05 <memcpy>
c0102b3c:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0102b3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102b46:	eb 0f                	jmp    c0102b57 <initVCache+0x35>
		VDIRTY[x] = 0;
c0102b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b4b:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102b50:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0102b53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102b57:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102b5e:	7e e8                	jle    c0102b48 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0102b60:	c9                   	leave  
c0102b61:	c3                   	ret    

c0102b62 <refreshVCache>:
void refreshVCache(){
c0102b62:	55                   	push   %ebp
c0102b63:	89 e5                	mov    %esp,%ebp
c0102b65:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102b68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102b6f:	eb 0f                	jmp    c0102b80 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0102b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b74:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102b79:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102b7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102b80:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102b87:	7e e8                	jle    c0102b71 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0102b89:	c9                   	leave  
c0102b8a:	c3                   	ret    

c0102b8b <flushVCache>:
void flushVCache(){
c0102b8b:	55                   	push   %ebp
c0102b8c:	89 e5                	mov    %esp,%ebp
c0102b8e:	53                   	push   %ebx
c0102b8f:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102b92:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0102b99:	eb 47                	jmp    c0102be2 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0102b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102b9e:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102ba3:	0f b6 00             	movzbl (%eax),%eax
c0102ba6:	84 c0                	test   %al,%al
c0102ba8:	74 34                	je     c0102bde <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0102baa:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102bad:	89 d0                	mov    %edx,%eax
c0102baf:	c1 e0 02             	shl    $0x2,%eax
c0102bb2:	01 d0                	add    %edx,%eax
c0102bb4:	c1 e0 06             	shl    $0x6,%eax
c0102bb7:	8d 88 c0 50 15 c0    	lea    -0x3feaaf40(%eax),%ecx
c0102bbd:	8b 1d a8 70 10 c0    	mov    0xc01070a8,%ebx
c0102bc3:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102bc6:	89 d0                	mov    %edx,%eax
c0102bc8:	c1 e0 02             	shl    $0x2,%eax
c0102bcb:	01 d0                	add    %edx,%eax
c0102bcd:	c1 e0 06             	shl    $0x6,%eax
c0102bd0:	01 d8                	add    %ebx,%eax
c0102bd2:	6a 50                	push   $0x50
c0102bd4:	51                   	push   %ecx
c0102bd5:	50                   	push   %eax
c0102bd6:	e8 2a ff ff ff       	call   c0102b05 <memcpy>
c0102bdb:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102bde:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102be2:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102be9:	7e b0                	jle    c0102b9b <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0102beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102bee:	c9                   	leave  
c0102bef:	c3                   	ret    

c0102bf0 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0102bf0:	55                   	push   %ebp
c0102bf1:	89 e5                	mov    %esp,%ebp
c0102bf3:	83 ec 04             	sub    $0x4,%esp
c0102bf6:	8b 45 10             	mov    0x10(%ebp),%eax
c0102bf9:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0102bfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c00:	78 18                	js     c0102c1a <setPixelAt+0x2a>
c0102c02:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102c09:	7f 0f                	jg     c0102c1a <setPixelAt+0x2a>
c0102c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c0f:	78 09                	js     c0102c1a <setPixelAt+0x2a>
c0102c11:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102c18:	7e 02                	jle    c0102c1c <setPixelAt+0x2c>
c0102c1a:	eb 34                	jmp    c0102c50 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0102c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c1f:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102c24:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0102c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c2a:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102c2f:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0102c32:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c35:	89 d0                	mov    %edx,%eax
c0102c37:	c1 e0 02             	shl    $0x2,%eax
c0102c3a:	01 d0                	add    %edx,%eax
c0102c3c:	c1 e0 06             	shl    $0x6,%eax
c0102c3f:	89 c2                	mov    %eax,%edx
c0102c41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c44:	01 c2                	add    %eax,%edx
c0102c46:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0102c4a:	88 82 c0 50 15 c0    	mov    %al,-0x3feaaf40(%edx)
}
c0102c50:	c9                   	leave  
c0102c51:	c3                   	ret    

c0102c52 <forceClearVRAM>:
void forceClearVRAM(){
c0102c52:	55                   	push   %ebp
c0102c53:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0102c55:	5d                   	pop    %ebp
c0102c56:	c3                   	ret    

c0102c57 <clearVRAM>:
void clearVRAM(){
c0102c57:	55                   	push   %ebp
c0102c58:	89 e5                	mov    %esp,%ebp
c0102c5a:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102c64:	eb 4e                	jmp    c0102cb4 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0102c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c69:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102c6e:	0f b6 00             	movzbl (%eax),%eax
c0102c71:	0f b6 c0             	movzbl %al,%eax
c0102c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c77:	81 c2 c0 44 17 c0    	add    $0xc01744c0,%edx
c0102c7d:	0f b6 12             	movzbl (%edx),%edx
c0102c80:	0f b6 d2             	movzbl %dl,%edx
c0102c83:	f7 d2                	not    %edx
c0102c85:	21 d0                	and    %edx,%eax
c0102c87:	85 c0                	test   %eax,%eax
c0102c89:	74 25                	je     c0102cb0 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0102c8b:	8b 0d a8 70 10 c0    	mov    0xc01070a8,%ecx
c0102c91:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c94:	89 d0                	mov    %edx,%eax
c0102c96:	c1 e0 02             	shl    $0x2,%eax
c0102c99:	01 d0                	add    %edx,%eax
c0102c9b:	c1 e0 06             	shl    $0x6,%eax
c0102c9e:	01 c8                	add    %ecx,%eax
c0102ca0:	6a 50                	push   $0x50
c0102ca2:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102ca7:	50                   	push   %eax
c0102ca8:	e8 58 fe ff ff       	call   c0102b05 <memcpy>
c0102cad:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102cb0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102cb4:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102cbb:	7e a9                	jle    c0102c66 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0102cbd:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102cc4:	83 c0 01             	add    $0x1,%eax
c0102cc7:	a2 88 46 17 c0       	mov    %al,0xc0174688
	if(stamp==30){
c0102ccc:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102cd3:	3c 1e                	cmp    $0x1e,%al
c0102cd5:	75 07                	jne    c0102cde <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0102cd7:	c6 05 88 46 17 c0 00 	movb   $0x0,0xc0174688
		//printk("What matters\n");
	}
	if(stamp==0){
c0102cde:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102ce5:	84 c0                	test   %al,%al
c0102ce7:	75 14                	jne    c0102cfd <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102ce9:	6a 32                	push   $0x32
c0102ceb:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102cf0:	68 c0 45 17 c0       	push   $0xc01745c0
c0102cf5:	e8 0b fe ff ff       	call   c0102b05 <memcpy>
c0102cfa:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0102cfd:	c9                   	leave  
c0102cfe:	c3                   	ret    

c0102cff <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0102cff:	55                   	push   %ebp
c0102d00:	89 e5                	mov    %esp,%ebp
c0102d02:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0102d05:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102d0a:	83 c0 01             	add    $0x1,%eax
c0102d0d:	a3 8c 46 17 c0       	mov    %eax,0xc017468c
	current->timeslice ++;
c0102d12:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102d17:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0102d1d:	83 c2 01             	add    $0x1,%edx
c0102d20:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c0102d26:	a1 b8 50 15 c0       	mov    0xc01550b8,%eax
c0102d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0102d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102d32:	75 02                	jne    c0102d36 <do_timer+0x37>
c0102d34:	eb 6b                	jmp    c0102da1 <do_timer+0xa2>
	 	sleep->timeslice --;
c0102d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d39:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102d3f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d45:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0102d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d54:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0102d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d60:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102d66:	85 c0                	test   %eax,%eax
c0102d68:	74 02                	je     c0102d6c <do_timer+0x6d>
c0102d6a:	eb 33                	jmp    c0102d9f <do_timer+0xa0>
	 	cur->ts = READY;
c0102d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d6f:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0102d76:	00 00 00 
		ll_delete(&sleep_list, cur);
c0102d79:	83 ec 08             	sub    $0x8,%esp
c0102d7c:	ff 75 f0             	pushl  -0x10(%ebp)
c0102d7f:	68 b8 50 15 c0       	push   $0xc01550b8
c0102d84:	e8 0a f6 ff ff       	call   c0102393 <ll_delete>
c0102d89:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0102d8c:	83 ec 08             	sub    $0x8,%esp
c0102d8f:	ff 75 f0             	pushl  -0x10(%ebp)
c0102d92:	68 b4 50 15 c0       	push   $0xc01550b4
c0102d97:	e8 99 f5 ff ff       	call   c0102335 <ll_entail>
c0102d9c:	83 c4 10             	add    $0x10,%esp
	}
c0102d9f:	eb 8d                	jmp    c0102d2e <do_timer+0x2f>
}
c0102da1:	c9                   	leave  
c0102da2:	c3                   	ret    

c0102da3 <tick>:
uint32_t tick(){
c0102da3:	55                   	push   %ebp
c0102da4:	89 e5                	mov    %esp,%ebp
	return _tick;
c0102da6:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102dab:	5d                   	pop    %ebp
c0102dac:	c3                   	ret    

c0102dad <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0102dad:	6a 00                	push   $0x0
c0102daf:	6a 00                	push   $0x0
c0102db1:	e9 b8 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102db6 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0102db6:	6a 00                	push   $0x0
c0102db8:	6a 01                	push   $0x1
c0102dba:	e9 af 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dbf <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0102dbf:	6a 00                	push   $0x0
c0102dc1:	6a 02                	push   $0x2
c0102dc3:	e9 a6 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dc8 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0102dc8:	6a 00                	push   $0x0
c0102dca:	6a 03                	push   $0x3
c0102dcc:	e9 9d 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dd1 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0102dd1:	6a 00                	push   $0x0
c0102dd3:	6a 04                	push   $0x4
c0102dd5:	e9 94 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dda <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0102dda:	6a 00                	push   $0x0
c0102ddc:	6a 05                	push   $0x5
c0102dde:	e9 8b 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102de3 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0102de3:	6a 00                	push   $0x0
c0102de5:	6a 06                	push   $0x6
c0102de7:	e9 82 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dec <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0102dec:	6a 00                	push   $0x0
c0102dee:	6a 07                	push   $0x7
c0102df0:	e9 79 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102df5 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0102df5:	6a 00                	push   $0x0
c0102df7:	6a 08                	push   $0x8
c0102df9:	e9 70 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102dfe <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0102dfe:	6a 00                	push   $0x0
c0102e00:	6a 09                	push   $0x9
c0102e02:	e9 67 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e07 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0102e07:	6a 00                	push   $0x0
c0102e09:	6a 0a                	push   $0xa
c0102e0b:	e9 5e 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e10 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0102e10:	6a 00                	push   $0x0
c0102e12:	6a 0b                	push   $0xb
c0102e14:	e9 55 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e19 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102e19:	6a 00                	push   $0x0
c0102e1b:	6a 0c                	push   $0xc
c0102e1d:	e9 4c 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e22 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0102e22:	6a 00                	push   $0x0
c0102e24:	6a 0d                	push   $0xd
c0102e26:	e9 43 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e2b <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102e2b:	6a 00                	push   $0x0
c0102e2d:	6a 0e                	push   $0xe
c0102e2f:	e9 3a 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e34 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102e34:	fa                   	cli    
c0102e35:	6a 00                	push   $0x0
c0102e37:	68 80 00 00 00       	push   $0x80
c0102e3c:	e9 2d 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e41 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102e41:	6a 00                	push   $0x0
c0102e43:	68 e8 03 00 00       	push   $0x3e8
c0102e48:	e9 21 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e4d <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102e4d:	6a 00                	push   $0x0
c0102e4f:	68 e9 03 00 00       	push   $0x3e9
c0102e54:	e9 15 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e59 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0102e59:	6a 00                	push   $0x0
c0102e5b:	68 f6 03 00 00       	push   $0x3f6
c0102e60:	e9 09 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e65 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0102e65:	6a 00                	push   $0x0
c0102e67:	6a ff                	push   $0xffffffff
c0102e69:	e9 00 00 00 00       	jmp    c0102e6e <asm_do_irq>

c0102e6e <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0102e6e:	fa                   	cli    
  pushl %ds
c0102e6f:	1e                   	push   %ds
  pushl %es
c0102e70:	06                   	push   %es
  pushl %fs
c0102e71:	0f a0                	push   %fs
  pushl %gs
c0102e73:	0f a8                	push   %gs
	pushal
c0102e75:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0102e76:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0102e7a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102e7c:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0102e7e:	54                   	push   %esp
  call irq_handle
c0102e7f:	e8 85 e2 ff ff       	call   c0101109 <irq_handle>
  addl $4, %esp
c0102e84:	83 c4 04             	add    $0x4,%esp

c0102e87 <switch_proc>:
switch_proc:
  popal
c0102e87:	61                   	popa   
  popl %gs
c0102e88:	0f a9                	pop    %gs
  popl %fs
c0102e8a:	0f a1                	pop    %fs
  popl %es
c0102e8c:	07                   	pop    %es
  popl %ds
c0102e8d:	1f                   	pop    %ds
  addl $8, %esp
c0102e8e:	83 c4 08             	add    $0x8,%esp
  sti
c0102e91:	fb                   	sti    
  iret
c0102e92:	cf                   	iret   
c0102e93:	90                   	nop
c0102e94:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0102e9a:	00 00                	add    %al,(%eax)
c0102e9c:	fe 4f 52             	decb   0x52(%edi)
c0102e9f:	e4 66                	in     $0x66,%al

c0102ea0 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0102ea0:	66 c7 05 72 04 00 00 34 12 b8 00 60 10 00 0f 22     f..r...4...`..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0102eb0:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 c3 2e 10     .. .......".....
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0102ec0:	c0 ff e0                                            ...

c0102ec3 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0102ec3:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0102ec8:	bc 00 00 11 c0       	mov    $0xc0110000,%esp

	# now to C code

	call	main
c0102ecd:	e8 6a e9 ff ff       	call   c010183c <main>

c0102ed2 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0102ed2:	eb fe                	jmp    c0102ed2 <spin>

c0102ed4 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0102ed4:	55                   	push   %ebp
c0102ed5:	89 e5                	mov    %esp,%ebp
c0102ed7:	53                   	push   %ebx
c0102ed8:	83 ec 04             	sub    $0x4,%esp
c0102edb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ede:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0102ee1:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0102ee6:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0102eea:	89 d3                	mov    %edx,%ebx
c0102eec:	cd 80                	int    $0x80
}
c0102eee:	83 c4 04             	add    $0x4,%esp
c0102ef1:	5b                   	pop    %ebx
c0102ef2:	5d                   	pop    %ebp
c0102ef3:	c3                   	ret    

c0102ef4 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0102ef4:	55                   	push   %ebp
c0102ef5:	89 e5                	mov    %esp,%ebp
c0102ef7:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0102efa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0102f00:	eb 19                	jmp    c0102f1b <printp+0x27>
		printer(cur);
c0102f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f05:	0f b6 00             	movzbl (%eax),%eax
c0102f08:	0f be c0             	movsbl %al,%eax
c0102f0b:	83 ec 0c             	sub    $0xc,%esp
c0102f0e:	50                   	push   %eax
c0102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f12:	ff d0                	call   *%eax
c0102f14:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0102f17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f1e:	0f b6 00             	movzbl (%eax),%eax
c0102f21:	84 c0                	test   %al,%al
c0102f23:	75 dd                	jne    c0102f02 <printp+0xe>
		printer(cur);
	}
}
c0102f25:	c9                   	leave  
c0102f26:	c3                   	ret    

c0102f27 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0102f27:	55                   	push   %ebp
c0102f28:	89 e5                	mov    %esp,%ebp
c0102f2a:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0102f33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0102f3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0102f41:	8b 45 10             	mov    0x10(%ebp),%eax
c0102f44:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102f47:	e9 65 02 00 00       	jmp    c01031b1 <vfprintf+0x28a>

		if(cur == '%'){
c0102f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4f:	0f b6 00             	movzbl (%eax),%eax
c0102f52:	3c 25                	cmp    $0x25,%al
c0102f54:	75 0c                	jne    c0102f62 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0102f56:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0102f5d:	e9 4b 02 00 00       	jmp    c01031ad <vfprintf+0x286>
		}
		if(type == READ){
c0102f62:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0102f66:	0f 85 26 02 00 00    	jne    c0103192 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0102f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f6f:	0f b6 00             	movzbl (%eax),%eax
c0102f72:	3c 73                	cmp    $0x73,%al
c0102f74:	75 35                	jne    c0102fab <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0102f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102f79:	8b 00                	mov    (%eax),%eax
c0102f7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0102f7e:	eb 19                	jmp    c0102f99 <vfprintf+0x72>
					printer(*p);
c0102f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f83:	0f b6 00             	movzbl (%eax),%eax
c0102f86:	0f be c0             	movsbl %al,%eax
c0102f89:	83 ec 0c             	sub    $0xc,%esp
c0102f8c:	50                   	push   %eax
c0102f8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f90:	ff d0                	call   *%eax
c0102f92:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0102f95:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0102f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f9c:	0f b6 00             	movzbl (%eax),%eax
c0102f9f:	84 c0                	test   %al,%al
c0102fa1:	75 dd                	jne    c0102f80 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0102fa3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102fa7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0102fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fae:	0f b6 00             	movzbl (%eax),%eax
c0102fb1:	3c 78                	cmp    $0x78,%al
c0102fb3:	0f 85 99 00 00 00    	jne    c0103052 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0102fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102fbc:	8b 00                	mov    (%eax),%eax
c0102fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0102fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102fc5:	75 1d                	jne    c0102fe4 <vfprintf+0xbd>
					printer('0');
c0102fc7:	83 ec 0c             	sub    $0xc,%esp
c0102fca:	6a 30                	push   $0x30
c0102fcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fcf:	ff d0                	call   *%eax
c0102fd1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102fd4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102fd8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102fdf:	e9 c9 01 00 00       	jmp    c01031ad <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0102fe4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0102feb:	eb 2d                	jmp    c010301a <vfprintf+0xf3>
					int d=(x%16);
c0102fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ff0:	83 e0 0f             	and    $0xf,%eax
c0102ff3:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0102ff6:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0102ffa:	7e 04                	jle    c0103000 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0102ffc:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0103000:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103003:	83 c0 30             	add    $0x30,%eax
c0103006:	89 c1                	mov    %eax,%ecx
c0103008:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010300b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010300e:	01 d0                	add    %edx,%eax
c0103010:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0103012:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0103016:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010301a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010301e:	75 cd                	jne    c0102fed <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0103020:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0103024:	eb 1e                	jmp    c0103044 <vfprintf+0x11d>
					printer(digits[di]);
c0103026:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103029:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010302c:	01 d0                	add    %edx,%eax
c010302e:	0f b6 00             	movzbl (%eax),%eax
c0103031:	0f be c0             	movsbl %al,%eax
c0103034:	83 ec 0c             	sub    $0xc,%esp
c0103037:	50                   	push   %eax
c0103038:	8b 45 08             	mov    0x8(%ebp),%eax
c010303b:	ff d0                	call   *%eax
c010303d:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0103040:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0103044:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103048:	79 dc                	jns    c0103026 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010304a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010304e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0103052:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103055:	0f b6 00             	movzbl (%eax),%eax
c0103058:	3c 64                	cmp    $0x64,%al
c010305a:	0f 85 02 01 00 00    	jne    c0103162 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0103060:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103063:	8b 00                	mov    (%eax),%eax
c0103065:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0103068:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c010306f:	75 23                	jne    c0103094 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0103071:	83 ec 08             	sub    $0x8,%esp
c0103074:	68 42 34 10 c0       	push   $0xc0103442
c0103079:	ff 75 08             	pushl  0x8(%ebp)
c010307c:	e8 73 fe ff ff       	call   c0102ef4 <printp>
c0103081:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103084:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103088:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c010308f:	e9 19 01 00 00       	jmp    c01031ad <vfprintf+0x286>
				}
				if(x==0){
c0103094:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103098:	75 1e                	jne    c01030b8 <vfprintf+0x191>
					printer('0');
c010309a:	83 ec 0c             	sub    $0xc,%esp
c010309d:	6a 30                	push   $0x30
c010309f:	8b 45 08             	mov    0x8(%ebp),%eax
c01030a2:	ff d0                	call   *%eax
c01030a4:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01030a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01030ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01030b2:	90                   	nop
c01030b3:	e9 f5 00 00 00       	jmp    c01031ad <vfprintf+0x286>
				}
				if(x<0){
c01030b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01030bc:	79 10                	jns    c01030ce <vfprintf+0x1a7>
					printer('-');
c01030be:	83 ec 0c             	sub    $0xc,%esp
c01030c1:	6a 2d                	push   $0x2d
c01030c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01030c6:	ff d0                	call   *%eax
c01030c8:	83 c4 10             	add    $0x10,%esp
					x=-x;
c01030cb:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c01030ce:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c01030d5:	eb 53                	jmp    c010312a <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c01030d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01030da:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01030df:	89 c8                	mov    %ecx,%eax
c01030e1:	f7 ea                	imul   %edx
c01030e3:	c1 fa 02             	sar    $0x2,%edx
c01030e6:	89 c8                	mov    %ecx,%eax
c01030e8:	c1 f8 1f             	sar    $0x1f,%eax
c01030eb:	29 c2                	sub    %eax,%edx
c01030ed:	89 d0                	mov    %edx,%eax
c01030ef:	c1 e0 02             	shl    $0x2,%eax
c01030f2:	01 d0                	add    %edx,%eax
c01030f4:	01 c0                	add    %eax,%eax
c01030f6:	29 c1                	sub    %eax,%ecx
c01030f8:	89 ca                	mov    %ecx,%edx
c01030fa:	89 d0                	mov    %edx,%eax
c01030fc:	83 c0 30             	add    $0x30,%eax
c01030ff:	89 c1                	mov    %eax,%ecx
c0103101:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103104:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103107:	01 d0                	add    %edx,%eax
c0103109:	88 08                	mov    %cl,(%eax)
					x/=10;
c010310b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010310e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0103113:	89 c8                	mov    %ecx,%eax
c0103115:	f7 ea                	imul   %edx
c0103117:	c1 fa 02             	sar    $0x2,%edx
c010311a:	89 c8                	mov    %ecx,%eax
c010311c:	c1 f8 1f             	sar    $0x1f,%eax
c010311f:	29 c2                	sub    %eax,%edx
c0103121:	89 d0                	mov    %edx,%eax
c0103123:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0103126:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010312a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010312e:	7f a7                	jg     c01030d7 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0103130:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0103134:	eb 1e                	jmp    c0103154 <vfprintf+0x22d>
					printer(digits[di]);
c0103136:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103139:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010313c:	01 d0                	add    %edx,%eax
c010313e:	0f b6 00             	movzbl (%eax),%eax
c0103141:	0f be c0             	movsbl %al,%eax
c0103144:	83 ec 0c             	sub    $0xc,%esp
c0103147:	50                   	push   %eax
c0103148:	8b 45 08             	mov    0x8(%ebp),%eax
c010314b:	ff d0                	call   *%eax
c010314d:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0103150:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0103154:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103158:	79 dc                	jns    c0103136 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010315a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010315e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0103162:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103165:	0f b6 00             	movzbl (%eax),%eax
c0103168:	3c 63                	cmp    $0x63,%al
c010316a:	75 1d                	jne    c0103189 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c010316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010316f:	0f b6 00             	movzbl (%eax),%eax
c0103172:	0f be c0             	movsbl %al,%eax
c0103175:	83 ec 0c             	sub    $0xc,%esp
c0103178:	50                   	push   %eax
c0103179:	8b 45 08             	mov    0x8(%ebp),%eax
c010317c:	ff d0                	call   *%eax
c010317e:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0103181:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103185:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0103189:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0103190:	eb 1b                	jmp    c01031ad <vfprintf+0x286>
		}
		if(type == NONE){
c0103192:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103196:	75 15                	jne    c01031ad <vfprintf+0x286>
			printer(cur);
c0103198:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010319b:	0f b6 00             	movzbl (%eax),%eax
c010319e:	0f be c0             	movsbl %al,%eax
c01031a1:	83 ec 0c             	sub    $0xc,%esp
c01031a4:	50                   	push   %eax
c01031a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01031a8:	ff d0                	call   *%eax
c01031aa:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01031ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031b4:	0f b6 00             	movzbl (%eax),%eax
c01031b7:	84 c0                	test   %al,%al
c01031b9:	0f 85 8d fd ff ff    	jne    c0102f4c <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c01031bf:	c9                   	leave  
c01031c0:	c3                   	ret    

c01031c1 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c01031c1:	55                   	push   %ebp
c01031c2:	89 e5                	mov    %esp,%ebp
c01031c4:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01031c7:	8d 45 0c             	lea    0xc(%ebp),%eax
c01031ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c01031cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01031d0:	83 ec 04             	sub    $0x4,%esp
c01031d3:	ff 75 f4             	pushl  -0xc(%ebp)
c01031d6:	50                   	push   %eax
c01031d7:	68 d4 2e 10 c0       	push   $0xc0102ed4
c01031dc:	e8 46 fd ff ff       	call   c0102f27 <vfprintf>
c01031e1:	83 c4 10             	add    $0x10,%esp
}
c01031e4:	c9                   	leave  
c01031e5:	c3                   	ret    
