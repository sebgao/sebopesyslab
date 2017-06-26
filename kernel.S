
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
c0100009:	66 a3 b0 40 13 c0    	mov    %ax,0xc01340b0
	data[1] = (uint32_t)addr;
c010000f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100012:	66 a3 b2 40 13 c0    	mov    %ax,0xc01340b2
	data[2] = ((uint32_t)addr) >> 16;
c0100018:	8b 45 08             	mov    0x8(%ebp),%eax
c010001b:	c1 e8 10             	shr    $0x10,%eax
c010001e:	66 a3 b4 40 13 c0    	mov    %ax,0xc01340b4
	asm volatile("lgdt (%0)" : : "r"(data));
c0100024:	b8 b0 40 13 c0       	mov    $0xc01340b0,%eax
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
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
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
c01000ba:	e8 f8 49 00 00       	call   c0104ab7 <vfprintf>
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
c01000f0:	68 78 4d 10 c0       	push   $0xc0104d78
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
c0100110:	b8 00 20 11 c0       	mov    $0xc0112000,%eax
}
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <get_kpdir>:

PDE* get_kpdir() {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
	return kpdir;
c010011a:	b8 00 30 11 c0       	mov    $0xc0113000,%eax
}
c010011f:	5d                   	pop    %ebp
c0100120:	c3                   	ret    

c0100121 <get_kptable>:

PTE* get_kptable() {
c0100121:	55                   	push   %ebp
c0100122:	89 e5                	mov    %esp,%ebp
	return kptable;
c0100124:	b8 00 40 11 c0       	mov    $0xc0114000,%eax
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
c010013e:	c7 05 08 40 13 c0 10 	movl   $0x10,0xc0134008
c0100145:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100148:	c7 45 fc 00 40 13 c0 	movl   $0xc0134000,-0x4(%ebp)
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
c010021b:	a3 04 40 13 c0       	mov    %eax,0xc0134004
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
c01002e3:	68 80 40 13 c0       	push   $0xc0134080
c01002e8:	e8 d7 fd ff ff       	call   c01000c4 <memset>
c01002ed:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c01002f0:	6a 0a                	push   $0xa
c01002f2:	6a 00                	push   $0x0
c01002f4:	68 88 40 13 c0       	push   $0xc0134088
c01002f9:	e8 24 ff ff ff       	call   c0100222 <set_segment>
c01002fe:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c0100301:	6a 02                	push   $0x2
c0100303:	6a 00                	push   $0x0
c0100305:	68 90 40 13 c0       	push   $0xc0134090
c010030a:	e8 13 ff ff ff       	call   c0100222 <set_segment>
c010030f:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c0100312:	6a 0a                	push   $0xa
c0100314:	6a 03                	push   $0x3
c0100316:	68 98 40 13 c0       	push   $0xc0134098
c010031b:	e8 02 ff ff ff       	call   c0100222 <set_segment>
c0100320:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c0100323:	6a 02                	push   $0x2
c0100325:	6a 03                	push   $0x3
c0100327:	68 a0 40 13 c0       	push   $0xc01340a0
c010032c:	e8 f1 fe ff ff       	call   c0100222 <set_segment>
c0100331:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100334:	6a 30                	push   $0x30
c0100336:	68 80 40 13 c0       	push   $0xc0134080
c010033b:	e8 c0 fc ff ff       	call   c0100000 <write_gdtr>
c0100340:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100343:	68 a8 40 13 c0       	push   $0xc01340a8
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
c0100371:	68 9b 4d 10 c0       	push   $0xc0104d9b
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
c01003fe:	a3 c4 74 15 c0       	mov    %eax,0xc01574c4
	//printk("A\n");
	lcr3(PADDR(pcb->pgdir));
c0100403:	8b 45 08             	mov    0x8(%ebp),%eax
c0100406:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8d 00 00 00       	push   $0x8d
c0100415:	68 9b 4d 10 c0       	push   $0xc0104d9b
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
c0100448:	b8 17 4a 10 c0       	mov    $0xc0104a17,%eax
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
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
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
c0100583:	e8 2f 45 00 00       	call   c0104ab7 <vfprintf>
c0100588:	83 c4 10             	add    $0x10,%esp
}
c010058b:	c9                   	leave  
c010058c:	c3                   	ret    

c010058d <memcpy>:

static inline void cputchar(char c) {
    serial_printc(c);
}

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
c01005d6:	68 b4 4d 10 c0       	push   $0xc0104db4
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
c010060c:	68 d8 4d 10 c0       	push   $0xc0104dd8
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
c0100629:	ba 40 6b 17 c0       	mov    $0xc0176b40,%edx
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
c010064e:	68 fc 4d 10 c0       	push   $0xc0104dfc
c0100653:	e8 10 ff ff ff       	call   c0100568 <printk>
c0100658:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c010065b:	8b 45 08             	mov    0x8(%ebp),%eax
c010065e:	c1 e8 0c             	shr    $0xc,%eax
c0100661:	c1 e0 03             	shl    $0x3,%eax
c0100664:	05 40 6b 17 c0       	add    $0xc0176b40,%eax
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
c0100682:	68 1b 4e 10 c0       	push   $0xc0104e1b
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
c0100719:	c7 45 e8 00 60 13 c0 	movl   $0xc0136000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c0100720:	c7 45 f0 00 70 13 c0 	movl   $0xc0137000,-0x10(%ebp)

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
c010074d:	68 31 4e 10 c0       	push   $0xc0104e31
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
c010079e:	a3 00 6b 17 c0       	mov    %eax,0xc0176b00
	lcr3(PADDR(kern_pgdir));	
c01007a3:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c01007a8:	83 ec 04             	sub    $0x4,%esp
c01007ab:	50                   	push   %eax
c01007ac:	6a 44                	push   $0x44
c01007ae:	68 31 4e 10 c0       	push   $0xc0104e31
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
c01007e7:	66 c7 04 c5 44 6b 17 	movw   $0x1,-0x3fe894bc(,%eax,8)
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
c0100809:	66 c7 04 c5 44 6b 17 	movw   $0x0,-0x3fe894bc(,%eax,8)
c0100810:	c0 00 00 
		pages[i].pp_link = page_free_list;
c0100813:	8b 15 00 50 13 c0    	mov    0xc0135000,%edx
c0100819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081c:	89 14 c5 40 6b 17 c0 	mov    %edx,-0x3fe894c0(,%eax,8)
		page_free_list = &pages[i];
c0100823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100826:	c1 e0 03             	shl    $0x3,%eax
c0100829:	05 40 6b 17 c0       	add    $0xc0176b40,%eax
c010082e:	a3 00 50 13 c0       	mov    %eax,0xc0135000
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
c0100863:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
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
c0100889:	a1 00 50 13 c0       	mov    0xc0135000,%eax
c010088e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL){
c0100891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100895:	75 17                	jne    c01008ae <page_alloc+0x2b>
		printk("Fatal error: page not available\n");
c0100897:	83 ec 0c             	sub    $0xc,%esp
c010089a:	68 4c 4e 10 c0       	push   $0xc0104e4c
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
c01008d9:	a1 00 50 13 c0       	mov    0xc0135000,%eax
c01008de:	8b 00                	mov    (%eax),%eax
c01008e0:	a3 00 50 13 c0       	mov    %eax,0xc0135000
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
c01008f6:	8b 15 00 50 13 c0    	mov    0xc0135000,%edx
c01008fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01008ff:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c0100901:	8b 45 08             	mov    0x8(%ebp),%eax
c0100904:	a3 00 50 13 c0       	mov    %eax,0xc0135000
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
c010097f:	68 31 4e 10 c0       	push   $0xc0104e31
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
c01009fb:	68 31 4e 10 c0       	push   $0xc0104e31
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
c0100b9d:	68 31 4e 10 c0       	push   $0xc0104e31
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
c0100c27:	68 31 4e 10 c0       	push   $0xc0104e31
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
c0100cd9:	68 31 4e 10 c0       	push   $0xc0104e31
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
c0100e15:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
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
c0100e4f:	68 31 4e 10 c0       	push   $0xc0104e31
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
c0100f34:	83 ec 18             	sub    $0x18,%esp
	if(sem->used){
c0100f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f3a:	8b 00                	mov    (%eax),%eax
c0100f3c:	85 c0                	test   %eax,%eax
c0100f3e:	74 3b                	je     c0100f7b <sem_close_kr+0x4a>
		sem->used = 0;
c0100f40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		PCB* pcb;
		while(1){
			pcb = ll_pop(&sem->block_list);
c0100f49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f4c:	83 c0 08             	add    $0x8,%eax
c0100f4f:	83 ec 0c             	sub    $0xc,%esp
c0100f52:	50                   	push   %eax
c0100f53:	e8 33 2e 00 00       	call   c0103d8b <ll_pop>
c0100f58:	83 c4 10             	add    $0x10,%esp
c0100f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(pcb == NULL) break;
c0100f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100f62:	75 02                	jne    c0100f66 <sem_close_kr+0x35>
c0100f64:	eb 15                	jmp    c0100f7b <sem_close_kr+0x4a>
			ll_entail(&ready_list, pcb);
c0100f66:	83 ec 08             	sub    $0x8,%esp
c0100f69:	ff 75 f4             	pushl  -0xc(%ebp)
c0100f6c:	68 c8 74 15 c0       	push   $0xc01574c8
c0100f71:	e8 77 2e 00 00       	call   c0103ded <ll_entail>
c0100f76:	83 c4 10             	add    $0x10,%esp
		}
c0100f79:	eb ce                	jmp    c0100f49 <sem_close_kr+0x18>
	}
}
c0100f7b:	c9                   	leave  
c0100f7c:	c3                   	ret    

c0100f7d <sem_post_kr>:

void sem_post_kr(Semaphore* sem){
c0100f7d:	55                   	push   %ebp
c0100f7e:	89 e5                	mov    %esp,%ebp
c0100f80:	83 ec 18             	sub    $0x18,%esp
	if(!sem->used)return;
c0100f83:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f86:	8b 00                	mov    (%eax),%eax
c0100f88:	85 c0                	test   %eax,%eax
c0100f8a:	75 02                	jne    c0100f8e <sem_post_kr+0x11>
c0100f8c:	eb 41                	jmp    c0100fcf <sem_post_kr+0x52>
	sem->count ++;
c0100f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f91:	8b 40 04             	mov    0x4(%eax),%eax
c0100f94:	8d 50 01             	lea    0x1(%eax),%edx
c0100f97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f9a:	89 50 04             	mov    %edx,0x4(%eax)
	if(sem->count<=0){
c0100f9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fa0:	8b 40 04             	mov    0x4(%eax),%eax
c0100fa3:	85 c0                	test   %eax,%eax
c0100fa5:	7f 28                	jg     c0100fcf <sem_post_kr+0x52>
		PCB* pcb = ll_pop(&sem->block_list);
c0100fa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100faa:	83 c0 08             	add    $0x8,%eax
c0100fad:	83 ec 0c             	sub    $0xc,%esp
c0100fb0:	50                   	push   %eax
c0100fb1:	e8 d5 2d 00 00       	call   c0103d8b <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 c8 74 15 c0       	push   $0xc01574c8
c0100fc7:	e8 21 2e 00 00       	call   c0103ded <ll_entail>
c0100fcc:	83 c4 10             	add    $0x10,%esp
	}
}
c0100fcf:	c9                   	leave  
c0100fd0:	c3                   	ret    

c0100fd1 <sem_wait_kr>:

void sem_wait_kr(Semaphore* sem){
c0100fd1:	55                   	push   %ebp
c0100fd2:	89 e5                	mov    %esp,%ebp
c0100fd4:	83 ec 18             	sub    $0x18,%esp
	if(!sem->used)return;
c0100fd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fda:	8b 00                	mov    (%eax),%eax
c0100fdc:	85 c0                	test   %eax,%eax
c0100fde:	75 02                	jne    c0100fe2 <sem_wait_kr+0x11>
c0100fe0:	eb 45                	jmp    c0101027 <sem_wait_kr+0x56>
	sem->count --;
c0100fe2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fe5:	8b 40 04             	mov    0x4(%eax),%eax
c0100fe8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100feb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fee:	89 50 04             	mov    %edx,0x4(%eax)
	if(sem->count < 0){
c0100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ff4:	8b 40 04             	mov    0x4(%eax),%eax
c0100ff7:	85 c0                	test   %eax,%eax
c0100ff9:	79 2c                	jns    c0101027 <sem_wait_kr+0x56>
		PCB* cur = current;
c0100ffb:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0101000:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&sem->block_list, cur);
c0101003:	8b 45 08             	mov    0x8(%ebp),%eax
c0101006:	83 c0 08             	add    $0x8,%eax
c0101009:	83 ec 08             	sub    $0x8,%esp
c010100c:	ff 75 f4             	pushl  -0xc(%ebp)
c010100f:	50                   	push   %eax
c0101010:	e8 d8 2d 00 00       	call   c0103ded <ll_entail>
c0101015:	83 c4 10             	add    $0x10,%esp
		current = NULL;
c0101018:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c010101f:	00 00 00 
		do_scheduler();
c0101022:	e8 84 00 00 00       	call   c01010ab <do_scheduler>
	}
}
c0101027:	c9                   	leave  
c0101028:	c3                   	ret    

c0101029 <sem_trywait_kr>:

int sem_trywait_kr(Semaphore* sem){
c0101029:	55                   	push   %ebp
c010102a:	89 e5                	mov    %esp,%ebp
	if(!sem->used)return -1;
c010102c:	8b 45 08             	mov    0x8(%ebp),%eax
c010102f:	8b 00                	mov    (%eax),%eax
c0101031:	85 c0                	test   %eax,%eax
c0101033:	75 07                	jne    c010103c <sem_trywait_kr+0x13>
c0101035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010103a:	eb 25                	jmp    c0101061 <sem_trywait_kr+0x38>
	if(sem->count <=0){
c010103c:	8b 45 08             	mov    0x8(%ebp),%eax
c010103f:	8b 40 04             	mov    0x4(%eax),%eax
c0101042:	85 c0                	test   %eax,%eax
c0101044:	7f 07                	jg     c010104d <sem_trywait_kr+0x24>
		return 0;
c0101046:	b8 00 00 00 00       	mov    $0x0,%eax
c010104b:	eb 14                	jmp    c0101061 <sem_trywait_kr+0x38>
	}
	else{
		sem->count--;
c010104d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101050:	8b 40 04             	mov    0x4(%eax),%eax
c0101053:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101056:	8b 45 08             	mov    0x8(%ebp),%eax
c0101059:	89 50 04             	mov    %edx,0x4(%eax)
		return 1;
c010105c:	b8 01 00 00 00       	mov    $0x1,%eax
	}

}
c0101061:	5d                   	pop    %ebp
c0101062:	c3                   	ret    

c0101063 <sem_get_kr>:

int sem_get_kr(Semaphore* sem){
c0101063:	55                   	push   %ebp
c0101064:	89 e5                	mov    %esp,%ebp
	if(!sem->used)return 0;
c0101066:	8b 45 08             	mov    0x8(%ebp),%eax
c0101069:	8b 00                	mov    (%eax),%eax
c010106b:	85 c0                	test   %eax,%eax
c010106d:	75 07                	jne    c0101076 <sem_get_kr+0x13>
c010106f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101074:	eb 06                	jmp    c010107c <sem_get_kr+0x19>
	return sem->count;
c0101076:	8b 45 08             	mov    0x8(%ebp),%eax
c0101079:	8b 40 04             	mov    0x4(%eax),%eax
}
c010107c:	5d                   	pop    %ebp
c010107d:	c3                   	ret    

c010107e <sem_open_kr>:

Semaphore* sem_open_kr(int index, int count){
c010107e:	55                   	push   %ebp
c010107f:	89 e5                	mov    %esp,%ebp
c0101081:	83 ec 10             	sub    $0x10,%esp
	Semaphore* sem = &sems[index];
c0101084:	8b 55 08             	mov    0x8(%ebp),%edx
c0101087:	89 d0                	mov    %edx,%eax
c0101089:	01 c0                	add    %eax,%eax
c010108b:	01 d0                	add    %edx,%eax
c010108d:	c1 e0 02             	shl    $0x2,%eax
c0101090:	05 40 6b 1b c0       	add    $0xc01b6b40,%eax
c0101095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	sem_init_kr(sem, count);
c0101098:	ff 75 0c             	pushl  0xc(%ebp)
c010109b:	ff 75 fc             	pushl  -0x4(%ebp)
c010109e:	e8 6e fe ff ff       	call   c0100f11 <sem_init_kr>
c01010a3:	83 c4 08             	add    $0x8,%esp
	return sem;
c01010a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01010a9:	c9                   	leave  
c01010aa:	c3                   	ret    

c01010ab <do_scheduler>:

//PCB* ready;



void do_scheduler(){
c01010ab:	55                   	push   %ebp
c01010ac:	89 e5                	mov    %esp,%ebp
c01010ae:	83 ec 08             	sub    $0x8,%esp
	count ++;
c01010b1:	a1 04 70 15 c0       	mov    0xc0157004,%eax
c01010b6:	83 c0 01             	add    $0x1,%eax
c01010b9:	a3 04 70 15 c0       	mov    %eax,0xc0157004

	if(current == NULL){
c01010be:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01010c3:	85 c0                	test   %eax,%eax
c01010c5:	75 49                	jne    c0101110 <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c01010c7:	83 ec 0c             	sub    $0xc,%esp
c01010ca:	68 c8 74 15 c0       	push   $0xc01574c8
c01010cf:	e8 b7 2c 00 00       	call   c0103d8b <ll_pop>
c01010d4:	83 c4 10             	add    $0x10,%esp
c01010d7:	a3 c4 74 15 c0       	mov    %eax,0xc01574c4

		current->ts = RUNNING;
c01010dc:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01010e1:	c7 80 4c 20 00 00 01 	movl   $0x1,0x204c(%eax)
c01010e8:	00 00 00 
		current->timeslice = 0;
c01010eb:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01010f0:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01010f7:	00 00 00 

		scheduler_switch(current);
c01010fa:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01010ff:	83 ec 0c             	sub    $0xc,%esp
c0101102:	50                   	push   %eax
c0101103:	e8 ed f2 ff ff       	call   c01003f5 <scheduler_switch>
c0101108:	83 c4 10             	add    $0x10,%esp
		return;
c010110b:	e9 8c 00 00 00       	jmp    c010119c <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c0101110:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0101115:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c010111b:	83 f8 03             	cmp    $0x3,%eax
c010111e:	75 27                	jne    c0101147 <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c0101120:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0101125:	83 ec 08             	sub    $0x8,%esp
c0101128:	50                   	push   %eax
c0101129:	68 cc 74 15 c0       	push   $0xc01574cc
c010112e:	e8 ba 2c 00 00       	call   c0103ded <ll_entail>
c0101133:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c0101136:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c010113d:	00 00 00 
		do_scheduler();
c0101140:	e8 66 ff ff ff       	call   c01010ab <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c0101145:	eb 55                	jmp    c010119c <do_scheduler+0xf1>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 2 || current->ts == STOP){
c0101147:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010114c:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0101152:	83 f8 02             	cmp    $0x2,%eax
c0101155:	77 10                	ja     c0101167 <do_scheduler+0xbc>
c0101157:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010115c:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c0101162:	83 f8 02             	cmp    $0x2,%eax
c0101165:	75 35                	jne    c010119c <do_scheduler+0xf1>

		current->ts = READY;
c0101167:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010116c:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0101173:	00 00 00 

		ll_entail(&ready_list, current);
c0101176:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010117b:	83 ec 08             	sub    $0x8,%esp
c010117e:	50                   	push   %eax
c010117f:	68 c8 74 15 c0       	push   $0xc01574c8
c0101184:	e8 64 2c 00 00       	call   c0103ded <ll_entail>
c0101189:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c010118c:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c0101193:	00 00 00 
		do_scheduler();
c0101196:	e8 10 ff ff ff       	call   c01010ab <do_scheduler>
		//scheduler_switch(current);
		return;
c010119b:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c010119c:	c9                   	leave  
c010119d:	c3                   	ret    

c010119e <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c010119e:	55                   	push   %ebp
c010119f:	89 e5                	mov    %esp,%ebp
c01011a1:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c01011a4:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01011a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01011ac:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c01011b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b5:	8b 40 30             	mov    0x30(%eax),%eax
c01011b8:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		else {
			//printk("IRQ::%d\n", tf->irq);
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c01011bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c0:	8b 40 30             	mov    0x30(%eax),%eax
c01011c3:	3d 80 00 00 00       	cmp    $0x80,%eax
c01011c8:	75 0e                	jne    c01011d8 <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c01011ca:	83 ec 0c             	sub    $0xc,%esp
c01011cd:	ff 75 08             	pushl  0x8(%ebp)
c01011d0:	e8 50 25 00 00       	call   c0103725 <do_syscall>
c01011d5:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c01011d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011db:	8b 40 30             	mov    0x30(%eax),%eax
c01011de:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c01011e3:	75 0f                	jne    c01011f4 <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c01011e5:	e8 a5 36 00 00       	call   c010488f <do_timer>
		do_scheduler();
c01011ea:	e8 bc fe ff ff       	call   c01010ab <do_scheduler>
c01011ef:	e9 b9 00 00 00       	jmp    c01012ad <irq_handle+0x10f>
	} else if (tf->irq == 1001) {
c01011f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f7:	8b 40 30             	mov    0x30(%eax),%eax
c01011fa:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c01011ff:	0f 85 a8 00 00 00    	jne    c01012ad <irq_handle+0x10f>
c0101205:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010120c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010120f:	89 c2                	mov    %eax,%edx
c0101211:	ec                   	in     (%dx),%al
c0101212:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0101215:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0101219:	0f b6 c0             	movzbl %al,%eax
c010121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010121f:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101229:	89 c2                	mov    %eax,%edx
c010122b:	ec                   	in     (%dx),%al
c010122c:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c010122f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0101233:	0f b6 c0             	movzbl %al,%eax
c0101236:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0101239:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010123c:	83 c8 80             	or     $0xffffff80,%eax
c010123f:	0f b6 c0             	movzbl %al,%eax
c0101242:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0101249:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010124c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101250:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101253:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0101254:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0101261:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0101264:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101268:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010126b:	ee                   	out    %al,(%dx)
		press_key(code);
c010126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010126f:	83 ec 0c             	sub    $0xc,%esp
c0101272:	50                   	push   %eax
c0101273:	e8 bd 20 00 00       	call   c0103335 <press_key>
c0101278:	83 c4 10             	add    $0x10,%esp
		if(ctrl_c() && current->tt != KERNEL){
c010127b:	e8 54 21 00 00       	call   c01033d4 <ctrl_c>
c0101280:	85 c0                	test   %eax,%eax
c0101282:	74 29                	je     c01012ad <irq_handle+0x10f>
c0101284:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0101289:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c010128f:	85 c0                	test   %eax,%eax
c0101291:	74 1a                	je     c01012ad <irq_handle+0x10f>
			tf->eax = SYS_EXIT;
c0101293:	8b 45 08             	mov    0x8(%ebp),%eax
c0101296:	c7 40 1c df 05 00 00 	movl   $0x5df,0x1c(%eax)
			do_syscall(tf);
c010129d:	83 ec 0c             	sub    $0xc,%esp
c01012a0:	ff 75 08             	pushl  0x8(%ebp)
c01012a3:	e8 7d 24 00 00       	call   c0103725 <do_syscall>
c01012a8:	83 c4 10             	add    $0x10,%esp
c01012ab:	eb 00                	jmp    c01012ad <irq_handle+0x10f>
		};
	} else {
		
	}
	//if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
	if((tf->irq == 0x80) && (tf->eax != SYS_PRINT_CHAR)){
c01012ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b0:	8b 40 30             	mov    0x30(%eax),%eax
c01012b3:	3d 80 00 00 00       	cmp    $0x80,%eax
c01012b8:	75 12                	jne    c01012cc <irq_handle+0x12e>
c01012ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01012bd:	8b 40 1c             	mov    0x1c(%eax),%eax
c01012c0:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c01012c5:	74 05                	je     c01012cc <irq_handle+0x12e>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c01012c7:	e8 df fd ff ff       	call   c01010ab <do_scheduler>
	}
}
c01012cc:	c9                   	leave  
c01012cd:	c3                   	ret    

c01012ce <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c01012ce:	55                   	push   %ebp
c01012cf:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c01012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012d4:	83 e8 01             	sub    $0x1,%eax
c01012d7:	66 a3 08 70 15 c0    	mov    %ax,0xc0157008
	data[1] = (uint32_t)addr;
c01012dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e0:	66 a3 0a 70 15 c0    	mov    %ax,0xc015700a
	data[2] = ((uint32_t)addr) >> 16;
c01012e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e9:	c1 e8 10             	shr    $0x10,%eax
c01012ec:	66 a3 0c 70 15 c0    	mov    %ax,0xc015700c
	asm volatile("lidt (%0)" : : "r"(data));
c01012f2:	b8 08 70 15 c0       	mov    $0xc0157008,%eax
c01012f7:	0f 01 18             	lidtl  (%eax)
}
c01012fa:	5d                   	pop    %ebp
c01012fb:	c3                   	ret    

c01012fc <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c01012fc:	55                   	push   %ebp
c01012fd:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c01012ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0101302:	89 c2                	mov    %eax,%edx
c0101304:	8b 45 08             	mov    0x8(%ebp),%eax
c0101307:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c010130a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010130d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101314:	8b 45 08             	mov    0x8(%ebp),%eax
c0101317:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c010131b:	8b 45 08             	mov    0x8(%ebp),%eax
c010131e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0101322:	8b 45 08             	mov    0x8(%ebp),%eax
c0101325:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101329:	83 e2 f0             	and    $0xfffffff0,%edx
c010132c:	83 ca 0e             	or     $0xe,%edx
c010132f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0101332:	8b 45 08             	mov    0x8(%ebp),%eax
c0101335:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101339:	83 e2 ef             	and    $0xffffffef,%edx
c010133c:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c010133f:	8b 45 14             	mov    0x14(%ebp),%eax
c0101342:	83 e0 03             	and    $0x3,%eax
c0101345:	89 c2                	mov    %eax,%edx
c0101347:	8b 45 08             	mov    0x8(%ebp),%eax
c010134a:	83 e2 03             	and    $0x3,%edx
c010134d:	89 d1                	mov    %edx,%ecx
c010134f:	c1 e1 05             	shl    $0x5,%ecx
c0101352:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101356:	83 e2 9f             	and    $0xffffff9f,%edx
c0101359:	09 ca                	or     %ecx,%edx
c010135b:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c010135e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101361:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101365:	83 ca 80             	or     $0xffffff80,%edx
c0101368:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c010136b:	8b 45 10             	mov    0x10(%ebp),%eax
c010136e:	c1 e8 10             	shr    $0x10,%eax
c0101371:	89 c2                	mov    %eax,%edx
c0101373:	8b 45 08             	mov    0x8(%ebp),%eax
c0101376:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c010137a:	5d                   	pop    %ebp
c010137b:	c3                   	ret    

c010137c <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c010137c:	55                   	push   %ebp
c010137d:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c010137f:	8b 45 10             	mov    0x10(%ebp),%eax
c0101382:	89 c2                	mov    %eax,%edx
c0101384:	8b 45 08             	mov    0x8(%ebp),%eax
c0101387:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c010138a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010138d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101394:	8b 45 08             	mov    0x8(%ebp),%eax
c0101397:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c010139b:	8b 45 08             	mov    0x8(%ebp),%eax
c010139e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c01013a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a5:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01013a9:	83 ca 0f             	or     $0xf,%edx
c01013ac:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c01013af:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b2:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01013b6:	83 e2 ef             	and    $0xffffffef,%edx
c01013b9:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c01013bc:	8b 45 14             	mov    0x14(%ebp),%eax
c01013bf:	83 e0 03             	and    $0x3,%eax
c01013c2:	89 c2                	mov    %eax,%edx
c01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c7:	83 e2 03             	and    $0x3,%edx
c01013ca:	89 d1                	mov    %edx,%ecx
c01013cc:	c1 e1 05             	shl    $0x5,%ecx
c01013cf:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01013d3:	83 e2 9f             	and    $0xffffff9f,%edx
c01013d6:	09 ca                	or     %ecx,%edx
c01013d8:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01013db:	8b 45 08             	mov    0x8(%ebp),%eax
c01013de:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01013e2:	83 ca 80             	or     $0xffffff80,%edx
c01013e5:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c01013e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01013eb:	c1 e8 10             	shr    $0x10,%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f3:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c01013f7:	5d                   	pop    %ebp
c01013f8:	c3                   	ret    

c01013f9 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c01013ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101406:	eb 22                	jmp    c010142a <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c0101408:	ba f5 49 10 c0       	mov    $0xc01049f5,%edx
c010140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101410:	c1 e0 03             	shl    $0x3,%eax
c0101413:	05 80 9d 1b c0       	add    $0xc01b9d80,%eax
c0101418:	6a 00                	push   $0x0
c010141a:	52                   	push   %edx
c010141b:	6a 01                	push   $0x1
c010141d:	50                   	push   %eax
c010141e:	e8 59 ff ff ff       	call   c010137c <set_trap>
c0101423:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101426:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010142a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101431:	7e d5                	jle    c0101408 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0101433:	b8 3d 49 10 c0       	mov    $0xc010493d,%eax
c0101438:	6a 00                	push   $0x0
c010143a:	50                   	push   %eax
c010143b:	6a 01                	push   $0x1
c010143d:	68 80 9d 1b c0       	push   $0xc01b9d80
c0101442:	e8 35 ff ff ff       	call   c010137c <set_trap>
c0101447:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c010144a:	b8 46 49 10 c0       	mov    $0xc0104946,%eax
c010144f:	6a 00                	push   $0x0
c0101451:	50                   	push   %eax
c0101452:	6a 01                	push   $0x1
c0101454:	68 88 9d 1b c0       	push   $0xc01b9d88
c0101459:	e8 1e ff ff ff       	call   c010137c <set_trap>
c010145e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c0101461:	b8 4f 49 10 c0       	mov    $0xc010494f,%eax
c0101466:	6a 00                	push   $0x0
c0101468:	50                   	push   %eax
c0101469:	6a 01                	push   $0x1
c010146b:	68 90 9d 1b c0       	push   $0xc01b9d90
c0101470:	e8 07 ff ff ff       	call   c010137c <set_trap>
c0101475:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101478:	b8 58 49 10 c0       	mov    $0xc0104958,%eax
c010147d:	6a 00                	push   $0x0
c010147f:	50                   	push   %eax
c0101480:	6a 01                	push   $0x1
c0101482:	68 98 9d 1b c0       	push   $0xc01b9d98
c0101487:	e8 f0 fe ff ff       	call   c010137c <set_trap>
c010148c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c010148f:	b8 61 49 10 c0       	mov    $0xc0104961,%eax
c0101494:	6a 00                	push   $0x0
c0101496:	50                   	push   %eax
c0101497:	6a 01                	push   $0x1
c0101499:	68 a0 9d 1b c0       	push   $0xc01b9da0
c010149e:	e8 d9 fe ff ff       	call   c010137c <set_trap>
c01014a3:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c01014a6:	b8 6a 49 10 c0       	mov    $0xc010496a,%eax
c01014ab:	6a 00                	push   $0x0
c01014ad:	50                   	push   %eax
c01014ae:	6a 01                	push   $0x1
c01014b0:	68 a8 9d 1b c0       	push   $0xc01b9da8
c01014b5:	e8 c2 fe ff ff       	call   c010137c <set_trap>
c01014ba:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c01014bd:	b8 73 49 10 c0       	mov    $0xc0104973,%eax
c01014c2:	6a 00                	push   $0x0
c01014c4:	50                   	push   %eax
c01014c5:	6a 01                	push   $0x1
c01014c7:	68 b0 9d 1b c0       	push   $0xc01b9db0
c01014cc:	e8 ab fe ff ff       	call   c010137c <set_trap>
c01014d1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c01014d4:	b8 7c 49 10 c0       	mov    $0xc010497c,%eax
c01014d9:	6a 00                	push   $0x0
c01014db:	50                   	push   %eax
c01014dc:	6a 01                	push   $0x1
c01014de:	68 b8 9d 1b c0       	push   $0xc01b9db8
c01014e3:	e8 94 fe ff ff       	call   c010137c <set_trap>
c01014e8:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014eb:	b8 85 49 10 c0       	mov    $0xc0104985,%eax
c01014f0:	6a 00                	push   $0x0
c01014f2:	50                   	push   %eax
c01014f3:	6a 01                	push   $0x1
c01014f5:	68 c0 9d 1b c0       	push   $0xc01b9dc0
c01014fa:	e8 7d fe ff ff       	call   c010137c <set_trap>
c01014ff:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0101502:	b8 8e 49 10 c0       	mov    $0xc010498e,%eax
c0101507:	6a 00                	push   $0x0
c0101509:	50                   	push   %eax
c010150a:	6a 01                	push   $0x1
c010150c:	68 c8 9d 1b c0       	push   $0xc01b9dc8
c0101511:	e8 66 fe ff ff       	call   c010137c <set_trap>
c0101516:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c0101519:	b8 97 49 10 c0       	mov    $0xc0104997,%eax
c010151e:	6a 00                	push   $0x0
c0101520:	50                   	push   %eax
c0101521:	6a 01                	push   $0x1
c0101523:	68 d0 9d 1b c0       	push   $0xc01b9dd0
c0101528:	e8 4f fe ff ff       	call   c010137c <set_trap>
c010152d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c0101530:	b8 a0 49 10 c0       	mov    $0xc01049a0,%eax
c0101535:	6a 00                	push   $0x0
c0101537:	50                   	push   %eax
c0101538:	6a 01                	push   $0x1
c010153a:	68 d8 9d 1b c0       	push   $0xc01b9dd8
c010153f:	e8 38 fe ff ff       	call   c010137c <set_trap>
c0101544:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101547:	b8 a9 49 10 c0       	mov    $0xc01049a9,%eax
c010154c:	6a 00                	push   $0x0
c010154e:	50                   	push   %eax
c010154f:	6a 01                	push   $0x1
c0101551:	68 e0 9d 1b c0       	push   $0xc01b9de0
c0101556:	e8 21 fe ff ff       	call   c010137c <set_trap>
c010155b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c010155e:	b8 b2 49 10 c0       	mov    $0xc01049b2,%eax
c0101563:	6a 00                	push   $0x0
c0101565:	50                   	push   %eax
c0101566:	6a 01                	push   $0x1
c0101568:	68 e8 9d 1b c0       	push   $0xc01b9de8
c010156d:	e8 0a fe ff ff       	call   c010137c <set_trap>
c0101572:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c0101575:	b8 c4 49 10 c0       	mov    $0xc01049c4,%eax
c010157a:	6a 03                	push   $0x3
c010157c:	50                   	push   %eax
c010157d:	6a 01                	push   $0x1
c010157f:	68 80 a1 1b c0       	push   $0xc01ba180
c0101584:	e8 f3 fd ff ff       	call   c010137c <set_trap>
c0101589:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c010158c:	b8 d1 49 10 c0       	mov    $0xc01049d1,%eax
c0101591:	6a 00                	push   $0x0
c0101593:	50                   	push   %eax
c0101594:	6a 01                	push   $0x1
c0101596:	68 80 9e 1b c0       	push   $0xc01b9e80
c010159b:	e8 5c fd ff ff       	call   c01012fc <set_intr>
c01015a0:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c01015a3:	b8 dd 49 10 c0       	mov    $0xc01049dd,%eax
c01015a8:	6a 00                	push   $0x0
c01015aa:	50                   	push   %eax
c01015ab:	6a 01                	push   $0x1
c01015ad:	68 88 9e 1b c0       	push   $0xc01b9e88
c01015b2:	e8 45 fd ff ff       	call   c01012fc <set_intr>
c01015b7:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c01015ba:	68 00 08 00 00       	push   $0x800
c01015bf:	68 80 9d 1b c0       	push   $0xc01b9d80
c01015c4:	e8 05 fd ff ff       	call   c01012ce <save_idt>
c01015c9:	83 c4 08             	add    $0x8,%esp
}
c01015cc:	c9                   	leave  
c01015cd:	c3                   	ret    

c01015ce <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01015ce:	55                   	push   %ebp
c01015cf:	89 e5                	mov    %esp,%ebp
c01015d1:	83 ec 10             	sub    $0x10,%esp
c01015d4:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015de:	89 c2                	mov    %eax,%edx
c01015e0:	ec                   	in     (%dx),%al
c01015e1:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01015e4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01015e8:	0f b6 c0             	movzbl %al,%eax
c01015eb:	83 e0 20             	and    $0x20,%eax
c01015ee:	85 c0                	test   %eax,%eax
c01015f0:	0f 95 c0             	setne  %al
c01015f3:	0f b6 c0             	movzbl %al,%eax
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <serial_printc>:

static inline
void serial_printc(char ch) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 14             	sub    $0x14,%esp
c01015fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101601:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101604:	90                   	nop
c0101605:	e8 c4 ff ff ff       	call   c01015ce <serial_idle>
c010160a:	85 c0                	test   %eax,%eax
c010160c:	74 f7                	je     c0101605 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010160e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101612:	0f b6 c0             	movzbl %al,%eax
c0101615:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010161c:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010161f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101623:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101626:	ee                   	out    %al,(%dx)
}
c0101627:	c9                   	leave  
c0101628:	c3                   	ret    

c0101629 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101629:	55                   	push   %ebp
c010162a:	89 e5                	mov    %esp,%ebp
c010162c:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010162f:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101635:	8b 45 08             	mov    0x8(%ebp),%eax
c0101638:	83 ec 04             	sub    $0x4,%esp
c010163b:	ff 75 f4             	pushl  -0xc(%ebp)
c010163e:	50                   	push   %eax
c010163f:	68 f8 15 10 c0       	push   $0xc01015f8
c0101644:	e8 6e 34 00 00       	call   c0104ab7 <vfprintf>
c0101649:	83 c4 10             	add    $0x10,%esp
}
c010164c:	c9                   	leave  
c010164d:	c3                   	ret    

c010164e <memcpy2>:
}

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}
static inline void memcpy2(void* dst, void* src, int len){
c010164e:	55                   	push   %ebp
c010164f:	89 e5                	mov    %esp,%ebp
c0101651:	57                   	push   %edi
c0101652:	56                   	push   %esi
c0101653:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c0101654:	8b 45 10             	mov    0x10(%ebp),%eax
c0101657:	8b 55 0c             	mov    0xc(%ebp),%edx
c010165a:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010165d:	89 c1                	mov    %eax,%ecx
c010165f:	89 d6                	mov    %edx,%esi
c0101661:	89 df                	mov    %ebx,%edi
c0101663:	fc                   	cld    
c0101664:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c0101666:	5b                   	pop    %ebx
c0101667:	5e                   	pop    %esi
c0101668:	5f                   	pop    %edi
c0101669:	5d                   	pop    %ebp
c010166a:	c3                   	ret    

c010166b <memset2>:

static inline void memset2(void* dst, uint32_t src, int len){
c010166b:	55                   	push   %ebp
c010166c:	89 e5                	mov    %esp,%ebp
c010166e:	57                   	push   %edi
c010166f:	53                   	push   %ebx
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
c0101670:	8b 55 10             	mov    0x10(%ebp),%edx
c0101673:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101676:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101679:	89 d1                	mov    %edx,%ecx
c010167b:	89 df                	mov    %ebx,%edi
c010167d:	fc                   	cld    
c010167e:	f3 aa                	rep stos %al,%es:(%edi)
}
c0101680:	5b                   	pop    %ebx
c0101681:	5f                   	pop    %edi
c0101682:	5d                   	pop    %ebp
c0101683:	c3                   	ret    

c0101684 <strcmp>:
static inline int strcmp(const char* s1, const char* s2)
{
c0101684:	55                   	push   %ebp
c0101685:	89 e5                	mov    %esp,%ebp
    while(*s1 && (*s1==*s2))
c0101687:	eb 08                	jmp    c0101691 <strcmp+0xd>
        s1++,s2++;
c0101689:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010168d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
c0101691:	8b 45 08             	mov    0x8(%ebp),%eax
c0101694:	0f b6 00             	movzbl (%eax),%eax
c0101697:	84 c0                	test   %al,%al
c0101699:	74 10                	je     c01016ab <strcmp+0x27>
c010169b:	8b 45 08             	mov    0x8(%ebp),%eax
c010169e:	0f b6 10             	movzbl (%eax),%edx
c01016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016a4:	0f b6 00             	movzbl (%eax),%eax
c01016a7:	38 c2                	cmp    %al,%dl
c01016a9:	74 de                	je     c0101689 <strcmp+0x5>
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
c01016ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ae:	0f b6 00             	movzbl (%eax),%eax
c01016b1:	0f b6 d0             	movzbl %al,%edx
c01016b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016b7:	0f b6 00             	movzbl (%eax),%eax
c01016ba:	0f b6 c0             	movzbl %al,%eax
c01016bd:	29 c2                	sub    %eax,%edx
c01016bf:	89 d0                	mov    %edx,%eax
}
c01016c1:	5d                   	pop    %ebp
c01016c2:	c3                   	ret    

c01016c3 <strcpy>:
static inline void strcpy(char* dest, const char* source) 
{
c01016c3:	55                   	push   %ebp
c01016c4:	89 e5                	mov    %esp,%ebp
c01016c6:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c01016c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c01016d0:	eb 04                	jmp    c01016d6 <strcpy+0x13>
    {
        i++;
c01016d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c01016d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01016d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016dc:	01 d0                	add    %edx,%eax
c01016de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c01016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01016e4:	01 ca                	add    %ecx,%edx
c01016e6:	0f b6 12             	movzbl (%edx),%edx
c01016e9:	88 10                	mov    %dl,(%eax)
c01016eb:	0f b6 00             	movzbl (%eax),%eax
c01016ee:	84 c0                	test   %al,%al
c01016f0:	75 e0                	jne    c01016d2 <strcpy+0xf>
    {
        i++;
    } 
}
c01016f2:	c9                   	leave  
c01016f3:	c3                   	ret    

c01016f4 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c01016f4:	55                   	push   %ebp
c01016f5:	89 e5                	mov    %esp,%ebp
c01016f7:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c01016fa:	90                   	nop
c01016fb:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101702:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101705:	89 c2                	mov    %eax,%edx
c0101707:	ec                   	in     (%dx),%al
c0101708:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010170b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010170f:	0f b6 c0             	movzbl %al,%eax
c0101712:	25 c0 00 00 00       	and    $0xc0,%eax
c0101717:	83 f8 40             	cmp    $0x40,%eax
c010171a:	75 df                	jne    c01016fb <waitdisk+0x7>
}
c010171c:	c9                   	leave  
c010171d:	c3                   	ret    

c010171e <readsect>:

static inline void
readsect(void *dst, int offset) {
c010171e:	55                   	push   %ebp
c010171f:	89 e5                	mov    %esp,%ebp
c0101721:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101724:	e8 cb ff ff ff       	call   c01016f4 <waitdisk>
c0101729:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0101730:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101734:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101738:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010173b:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c010173c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010173f:	0f b6 c0             	movzbl %al,%eax
c0101742:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101749:	88 45 ef             	mov    %al,-0x11(%ebp)
c010174c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101750:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101753:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101757:	c1 f8 08             	sar    $0x8,%eax
c010175a:	0f b6 c0             	movzbl %al,%eax
c010175d:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101764:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101767:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010176b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c010176f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101772:	c1 f8 10             	sar    $0x10,%eax
c0101775:	0f b6 c0             	movzbl %al,%eax
c0101778:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c010177f:	88 45 df             	mov    %al,-0x21(%ebp)
c0101782:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101786:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101789:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c010178a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010178d:	c1 f8 18             	sar    $0x18,%eax
c0101790:	83 c8 e0             	or     $0xffffffe0,%eax
c0101793:	0f b6 c0             	movzbl %al,%eax
c0101796:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010179d:	88 45 d7             	mov    %al,-0x29(%ebp)
c01017a0:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01017a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01017a7:	ee                   	out    %al,(%dx)
c01017a8:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c01017af:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c01017b3:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c01017b7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01017ba:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c01017bb:	e8 34 ff ff ff       	call   c01016f4 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01017c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01017c7:	eb 29                	jmp    c01017f2 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c01017c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01017d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01017d6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c01017d9:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c01017e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01017e3:	89 c2                	mov    %eax,%edx
c01017e5:	ed                   	in     (%dx),%eax
c01017e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c01017e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01017ec:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01017ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01017f2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01017f6:	7e d1                	jle    c01017c9 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c01017f8:	c9                   	leave  
c01017f9:	c3                   	ret    

c01017fa <writesect>:
static inline void
writesect(void *dst, int offset) {
c01017fa:	55                   	push   %ebp
c01017fb:	89 e5                	mov    %esp,%ebp
c01017fd:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101800:	e8 ef fe ff ff       	call   c01016f4 <waitdisk>
c0101805:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c010180c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101810:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101814:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101817:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010181b:	0f b6 c0             	movzbl %al,%eax
c010181e:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101825:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101828:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010182c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101830:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101833:	c1 f8 08             	sar    $0x8,%eax
c0101836:	0f b6 c0             	movzbl %al,%eax
c0101839:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101840:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101843:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101847:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010184a:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c010184b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010184e:	c1 f8 10             	sar    $0x10,%eax
c0101851:	0f b6 c0             	movzbl %al,%eax
c0101854:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c010185b:	88 45 df             	mov    %al,-0x21(%ebp)
c010185e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101862:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101865:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101866:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101869:	c1 f8 18             	sar    $0x18,%eax
c010186c:	83 c8 e0             	or     $0xffffffe0,%eax
c010186f:	0f b6 c0             	movzbl %al,%eax
c0101872:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101879:	88 45 d7             	mov    %al,-0x29(%ebp)
c010187c:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101880:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101883:	ee                   	out    %al,(%dx)
c0101884:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c010188b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
c010188f:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101893:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101896:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x30);

    waitdisk();
c0101897:	e8 58 fe ff ff       	call   c01016f4 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010189c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a3:	eb 26                	jmp    c01018cb <writesect+0xd1>
        outl(0x1F0, ((int *)(dst))[i]);
c01018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01018af:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b2:	01 d0                	add    %edx,%eax
c01018b4:	8b 00                	mov    (%eax),%eax
c01018b6:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)
c01018bd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
c01018c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01018c3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01018c6:	ef                   	out    %eax,(%dx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x30);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01018c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01018cf:	7e d4                	jle    c01018a5 <writesect+0xab>
        outl(0x1F0, ((int *)(dst))[i]);
    }
}
c01018d1:	c9                   	leave  
c01018d2:	c3                   	ret    

c01018d3 <readBitmap>:
struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
c01018d3:	55                   	push   %ebp
c01018d4:	89 e5                	mov    %esp,%ebp
c01018d6:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e0:	eb 22                	jmp    c0101904 <readBitmap+0x31>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e5:	c1 e0 09             	shl    $0x9,%eax
c01018e8:	8d 50 01             	lea    0x1(%eax),%edx
c01018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ee:	c1 e0 09             	shl    $0x9,%eax
c01018f1:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c01018f6:	52                   	push   %edx
c01018f7:	50                   	push   %eax
c01018f8:	e8 21 fe ff ff       	call   c010171e <readsect>
c01018fd:	83 c4 08             	add    $0x8,%esp
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c0101900:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101904:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010190b:	7e d5                	jle    c01018e2 <readBitmap+0xf>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c010190d:	c9                   	leave  
c010190e:	c3                   	ret    

c010190f <saveBitmap>:

void saveBitmap(){
c010190f:	55                   	push   %ebp
c0101910:	89 e5                	mov    %esp,%ebp
c0101912:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c0101915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010191c:	eb 22                	jmp    c0101940 <saveBitmap+0x31>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c010191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101921:	c1 e0 09             	shl    $0x9,%eax
c0101924:	8d 50 01             	lea    0x1(%eax),%edx
c0101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192a:	c1 e0 09             	shl    $0x9,%eax
c010192d:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101932:	52                   	push   %edx
c0101933:	50                   	push   %eax
c0101934:	e8 c1 fe ff ff       	call   c01017fa <writesect>
c0101939:	83 c4 08             	add    $0x8,%esp
	}
}

void saveBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c010193c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101940:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101947:	7e d5                	jle    c010191e <saveBitmap+0xf>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c0101949:	c9                   	leave  
c010194a:	c3                   	ret    

c010194b <readDir>:
void readDir(int offset){
c010194b:	55                   	push   %ebp
c010194c:	89 e5                	mov    %esp,%ebp
	readsect(dir.entries, LOC_DIR(offset));
c010194e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101951:	05 01 01 00 00       	add    $0x101,%eax
c0101956:	50                   	push   %eax
c0101957:	68 80 d7 1f c0       	push   $0xc01fd780
c010195c:	e8 bd fd ff ff       	call   c010171e <readsect>
c0101961:	83 c4 08             	add    $0x8,%esp
}
c0101964:	c9                   	leave  
c0101965:	c3                   	ret    

c0101966 <saveDir>:
void saveDir(int offset){
c0101966:	55                   	push   %ebp
c0101967:	89 e5                	mov    %esp,%ebp
	writesect(dir.entries, LOC_DIR(offset));
c0101969:	8b 45 08             	mov    0x8(%ebp),%eax
c010196c:	05 01 01 00 00       	add    $0x101,%eax
c0101971:	50                   	push   %eax
c0101972:	68 80 d7 1f c0       	push   $0xc01fd780
c0101977:	e8 7e fe ff ff       	call   c01017fa <writesect>
c010197c:	83 c4 08             	add    $0x8,%esp
}
c010197f:	c9                   	leave  
c0101980:	c3                   	ret    

c0101981 <readINode>:
void readINode(int offset){
c0101981:	55                   	push   %ebp
c0101982:	89 e5                	mov    %esp,%ebp
	readsect(inode.data_block_offsets, LOC_INODE(offset));
c0101984:	8b 45 08             	mov    0x8(%ebp),%eax
c0101987:	05 01 02 00 00       	add    $0x201,%eax
c010198c:	50                   	push   %eax
c010198d:	68 80 d9 1f c0       	push   $0xc01fd980
c0101992:	e8 87 fd ff ff       	call   c010171e <readsect>
c0101997:	83 c4 08             	add    $0x8,%esp
}
c010199a:	c9                   	leave  
c010199b:	c3                   	ret    

c010199c <saveINode>:
void saveINode(int offset){
c010199c:	55                   	push   %ebp
c010199d:	89 e5                	mov    %esp,%ebp
	writesect(inode.data_block_offsets, LOC_INODE(offset));
c010199f:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a2:	05 01 02 00 00       	add    $0x201,%eax
c01019a7:	50                   	push   %eax
c01019a8:	68 80 d9 1f c0       	push   $0xc01fd980
c01019ad:	e8 48 fe ff ff       	call   c01017fa <writesect>
c01019b2:	83 c4 08             	add    $0x8,%esp
}
c01019b5:	c9                   	leave  
c01019b6:	c3                   	ret    

c01019b7 <readData>:
void readData(int offset){
c01019b7:	55                   	push   %ebp
c01019b8:	89 e5                	mov    %esp,%ebp
	readsect(buffer, LOC_DATA(offset));
c01019ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01019bd:	05 01 03 00 00       	add    $0x301,%eax
c01019c2:	50                   	push   %eax
c01019c3:	68 80 d5 1f c0       	push   $0xc01fd580
c01019c8:	e8 51 fd ff ff       	call   c010171e <readsect>
c01019cd:	83 c4 08             	add    $0x8,%esp
}
c01019d0:	c9                   	leave  
c01019d1:	c3                   	ret    

c01019d2 <saveData>:
void saveData(int offset){
c01019d2:	55                   	push   %ebp
c01019d3:	89 e5                	mov    %esp,%ebp
	writesect(buffer, LOC_DATA(offset));
c01019d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d8:	05 01 03 00 00       	add    $0x301,%eax
c01019dd:	50                   	push   %eax
c01019de:	68 80 d5 1f c0       	push   $0xc01fd580
c01019e3:	e8 12 fe ff ff       	call   c01017fa <writesect>
c01019e8:	83 c4 08             	add    $0x8,%esp
}
c01019eb:	c9                   	leave  
c01019ec:	c3                   	ret    

c01019ed <INodeAlloc>:
int INodeAlloc(){
c01019ed:	55                   	push   %ebp
c01019ee:	89 e5                	mov    %esp,%ebp
c01019f0:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c01019f3:	e8 db fe ff ff       	call   c01018d3 <readBitmap>
	int i = 0;
c01019f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_INODE; i++){
c01019ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a06:	eb 69                	jmp    c0101a71 <INodeAlloc+0x84>
		int sec = LOC_INODE(i);
c0101a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0b:	05 01 02 00 00       	add    $0x201,%eax
c0101a10:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c0101a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a16:	c1 f8 03             	sar    $0x3,%eax
c0101a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a1f:	83 e0 07             	and    $0x7,%eax
c0101a22:	ba 01 00 00 00       	mov    $0x1,%edx
c0101a27:	89 c1                	mov    %eax,%ecx
c0101a29:	d3 e2                	shl    %cl,%edx
c0101a2b:	89 d0                	mov    %edx,%eax
c0101a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a33:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a38:	0f b6 00             	movzbl (%eax),%eax
c0101a3b:	0f b6 c0             	movzbl %al,%eax
c0101a3e:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a41:	85 c0                	test   %eax,%eax
c0101a43:	75 28                	jne    c0101a6d <INodeAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a48:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a4d:	0f b6 00             	movzbl (%eax),%eax
c0101a50:	89 c2                	mov    %eax,%edx
c0101a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a55:	09 d0                	or     %edx,%eax
c0101a57:	89 c2                	mov    %eax,%edx
c0101a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a5c:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a61:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101a63:	e8 a7 fe ff ff       	call   c010190f <saveBitmap>
			return i;
c0101a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a6b:	eb 12                	jmp    c0101a7f <INodeAlloc+0x92>
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
c0101a6d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a71:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a78:	7e 8e                	jle    c0101a08 <INodeAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101a7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101a7f:	c9                   	leave  
c0101a80:	c3                   	ret    

c0101a81 <dataAlloc>:
int dataAlloc(){
c0101a81:	55                   	push   %ebp
c0101a82:	89 e5                	mov    %esp,%ebp
c0101a84:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c0101a87:	e8 47 fe ff ff       	call   c01018d3 <readBitmap>
	int i = 0;
c0101a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_DATA; i++){
c0101a93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a9a:	eb 69                	jmp    c0101b05 <dataAlloc+0x84>
		int sec = LOC_DATA(i);
c0101a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a9f:	05 01 03 00 00       	add    $0x301,%eax
c0101aa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c0101aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101aaa:	c1 f8 03             	sar    $0x3,%eax
c0101aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101ab0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ab3:	83 e0 07             	and    $0x7,%eax
c0101ab6:	ba 01 00 00 00       	mov    $0x1,%edx
c0101abb:	89 c1                	mov    %eax,%ecx
c0101abd:	d3 e2                	shl    %cl,%edx
c0101abf:	89 d0                	mov    %edx,%eax
c0101ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ac7:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101acc:	0f b6 00             	movzbl (%eax),%eax
c0101acf:	0f b6 c0             	movzbl %al,%eax
c0101ad2:	23 45 f0             	and    -0x10(%ebp),%eax
c0101ad5:	85 c0                	test   %eax,%eax
c0101ad7:	75 28                	jne    c0101b01 <dataAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101adc:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101ae1:	0f b6 00             	movzbl (%eax),%eax
c0101ae4:	89 c2                	mov    %eax,%edx
c0101ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ae9:	09 d0                	or     %edx,%eax
c0101aeb:	89 c2                	mov    %eax,%edx
c0101aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101af0:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101af5:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101af7:	e8 13 fe ff ff       	call   c010190f <saveBitmap>
			return i;
c0101afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aff:	eb 12                	jmp    c0101b13 <dataAlloc+0x92>
	return -1;
}
int dataAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
c0101b01:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b05:	81 7d fc ff 7f 00 00 	cmpl   $0x7fff,-0x4(%ebp)
c0101b0c:	7e 8e                	jle    c0101a9c <dataAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101b0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101b13:	c9                   	leave  
c0101b14:	c3                   	ret    

c0101b15 <fs_open_kr>:

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
c0101b15:	55                   	push   %ebp
c0101b16:	89 e5                	mov    %esp,%ebp
c0101b18:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0101b1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0101b29:	eb 4c                	jmp    c0101b77 <fs_open_kr+0x62>
		readDir(dir_offset);
c0101b2b:	ff 75 fc             	pushl  -0x4(%ebp)
c0101b2e:	e8 18 fe ff ff       	call   c010194b <readDir>
c0101b33:	83 c4 04             	add    $0x4,%esp

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101b3d:	eb 2c                	jmp    c0101b6b <fs_open_kr+0x56>
			//printk("%d %d", dir_offset, entry_offset);
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
c0101b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b42:	c1 e0 05             	shl    $0x5,%eax
c0101b45:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101b4a:	ff 75 08             	pushl  0x8(%ebp)
c0101b4d:	50                   	push   %eax
c0101b4e:	e8 31 fb ff ff       	call   c0101684 <strcmp>
c0101b53:	83 c4 08             	add    $0x8,%esp
c0101b56:	85 c0                	test   %eax,%eax
c0101b58:	75 0d                	jne    c0101b67 <fs_open_kr+0x52>
				goto OUT_OF_LOOP;
c0101b5a:	90                   	nop
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b62:	e9 2f 01 00 00       	jmp    c0101c96 <fs_open_kr+0x181>
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b67:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101b6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b6e:	83 f8 0f             	cmp    $0xf,%eax
c0101b71:	76 cc                	jbe    c0101b3f <fs_open_kr+0x2a>
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
c0101b73:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0101b77:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101b7e:	7e ab                	jle    c0101b2b <fs_open_kr+0x16>
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
c0101b80:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101b86:	e9 1d 01 00 00       	jmp    c0101ca8 <fs_open_kr+0x193>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b8e:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b94:	05 20 02 00 00       	add    $0x220,%eax
c0101b99:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101b9e:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0101ba2:	84 c0                	test   %al,%al
c0101ba4:	0f 85 e8 00 00 00    	jne    c0101c92 <fs_open_kr+0x17d>
			fs[i].used = 1;
c0101baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bad:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101bb3:	05 20 02 00 00       	add    $0x220,%eax
c0101bb8:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101bbd:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101bc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bc4:	c1 e0 05             	shl    $0x5,%eax
c0101bc7:	83 c0 10             	add    $0x10,%eax
c0101bca:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101bcf:	8b 40 08             	mov    0x8(%eax),%eax
c0101bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bd5:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101bdb:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101be1:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101be7:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bed:	c1 e0 05             	shl    $0x5,%eax
c0101bf0:	8d 90 80 d7 1f c0    	lea    -0x3fe02880(%eax),%edx
c0101bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf9:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101bff:	05 10 02 00 00       	add    $0x210,%eax
c0101c04:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101c09:	83 c0 04             	add    $0x4,%eax
c0101c0c:	52                   	push   %edx
c0101c0d:	50                   	push   %eax
c0101c0e:	e8 b0 fa ff ff       	call   c01016c3 <strcpy>
c0101c13:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101c16:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c19:	c1 e0 05             	shl    $0x5,%eax
c0101c1c:	83 c0 10             	add    $0x10,%eax
c0101c1f:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101c24:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c2a:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c30:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c36:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c3c:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("$%d %d$\n", fs[i].file_size, fs[i].inode_offset);
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c42:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c48:	05 00 02 00 00       	add    $0x200,%eax
c0101c4d:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0101c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c5e:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c64:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c6a:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c70:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0101c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c79:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c7f:	81 c2 10 02 00 00    	add    $0x210,%edx
c0101c85:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c8b:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c90:	eb 16                	jmp    c0101ca8 <fs_open_kr+0x193>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101c92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c96:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0101c9d:	0f 8e e8 fe ff ff    	jle    c0101b8b <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101ca8:	c9                   	leave  
c0101ca9:	c3                   	ret    

c0101caa <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101caa:	55                   	push   %ebp
c0101cab:	89 e5                	mov    %esp,%ebp
c0101cad:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb3:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101cb9:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101cbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101cc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cc4:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101cca:	50                   	push   %eax
c0101ccb:	e8 b1 fc ff ff       	call   c0101981 <readINode>
c0101cd0:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101cd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101cda:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cdd:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ce3:	c1 e8 09             	shr    $0x9,%eax
c0101ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cec:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cf2:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101cfa:	8b 55 10             	mov    0x10(%ebp),%edx
c0101cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d00:	01 d0                	add    %edx,%eax
c0101d02:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101d07:	0f 86 2d 01 00 00    	jbe    c0101e3a <fs_read_base_kr+0x190>
		readData(inode.data_block_offsets[D]);
c0101d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d10:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101d17:	50                   	push   %eax
c0101d18:	e8 9a fc ff ff       	call   c01019b7 <readData>
c0101d1d:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101d20:	b8 00 02 00 00       	mov    $0x200,%eax
c0101d25:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d28:	89 c2                	mov    %eax,%edx
c0101d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d2d:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101d32:	52                   	push   %edx
c0101d33:	50                   	push   %eax
c0101d34:	ff 75 0c             	pushl  0xc(%ebp)
c0101d37:	e8 12 f9 ff ff       	call   c010164e <memcpy2>
c0101d3c:	83 c4 0c             	add    $0xc,%esp
		f->offset += BLOCK_SIZE-R;
c0101d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d42:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d48:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d4b:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d51:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d54:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d5d:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d60:	05 00 02 00 00       	add    $0x200,%eax
c0101d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101d68:	8b 55 10             	mov    0x10(%ebp),%edx
c0101d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d6e:	01 d0                	add    %edx,%eax
c0101d70:	2d 00 02 00 00       	sub    $0x200,%eax
c0101d75:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d78:	eb 63                	jmp    c0101ddd <fs_read_base_kr+0x133>
			D = f->offset >> 9;
c0101d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d7d:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d83:	c1 e8 09             	shr    $0x9,%eax
c0101d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
c0101d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d8c:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101d93:	50                   	push   %eax
c0101d94:	e8 1e fc ff ff       	call   c01019b7 <readData>
c0101d99:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101da2:	01 d0                	add    %edx,%eax
c0101da4:	68 00 02 00 00       	push   $0x200
c0101da9:	68 80 d5 1f c0       	push   $0xc01fd580
c0101dae:	50                   	push   %eax
c0101daf:	e8 9a f8 ff ff       	call   c010164e <memcpy2>
c0101db4:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101db7:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dc1:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101dc7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dd0:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101dd6:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101ddd:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101de4:	7f 94                	jg     c0101d7a <fs_read_base_kr+0xd0>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101de9:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101def:	c1 e8 09             	shr    $0x9,%eax
c0101df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101df8:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101dff:	50                   	push   %eax
c0101e00:	e8 b2 fb ff ff       	call   c01019b7 <readData>
c0101e05:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101e08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e0e:	01 d0                	add    %edx,%eax
c0101e10:	ff 75 10             	pushl  0x10(%ebp)
c0101e13:	68 80 d5 1f c0       	push   $0xc01fd580
c0101e18:	50                   	push   %eax
c0101e19:	e8 30 f8 ff ff       	call   c010164e <memcpy2>
c0101e1e:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e24:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e2d:	01 c2                	add    %eax,%edx
c0101e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e32:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101e38:	eb 41                	jmp    c0101e7b <fs_read_base_kr+0x1d1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e3d:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101e44:	50                   	push   %eax
c0101e45:	e8 6d fb ff ff       	call   c01019b7 <readData>
c0101e4a:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e50:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101e55:	ff 75 10             	pushl  0x10(%ebp)
c0101e58:	50                   	push   %eax
c0101e59:	ff 75 0c             	pushl  0xc(%ebp)
c0101e5c:	e8 ed f7 ff ff       	call   c010164e <memcpy2>
c0101e61:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e67:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e6d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e70:	01 c2                	add    %eax,%edx
c0101e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e75:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101e7b:	c9                   	leave  
c0101e7c:	c3                   	ret    

c0101e7d <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101e7d:	55                   	push   %ebp
c0101e7e:	89 e5                	mov    %esp,%ebp
c0101e80:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e86:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101e8c:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e97:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e9d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ea0:	01 c2                	add    %eax,%edx
c0101ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ea5:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101eab:	39 c2                	cmp    %eax,%edx
c0101ead:	72 19                	jb     c0101ec8 <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101eb2:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ebb:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ec1:	29 c2                	sub    %eax,%edx
c0101ec3:	89 d0                	mov    %edx,%eax
c0101ec5:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	if(len == 0)
c0101ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0101ecc:	75 07                	jne    c0101ed5 <fs_read_kr+0x58>
		return -1;
c0101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101ed3:	eb 14                	jmp    c0101ee9 <fs_read_kr+0x6c>
	fs_read_base_kr(fd, buf, len);
c0101ed5:	ff 75 10             	pushl  0x10(%ebp)
c0101ed8:	ff 75 0c             	pushl  0xc(%ebp)
c0101edb:	ff 75 08             	pushl  0x8(%ebp)
c0101ede:	e8 c7 fd ff ff       	call   c0101caa <fs_read_base_kr>
c0101ee3:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101ee6:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101ee9:	c9                   	leave  
c0101eea:	c3                   	ret    

c0101eeb <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101eeb:	55                   	push   %ebp
c0101eec:	89 e5                	mov    %esp,%ebp
c0101eee:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef4:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101efa:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101eff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101f02:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f05:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101f0b:	50                   	push   %eax
c0101f0c:	e8 70 fa ff ff       	call   c0101981 <readINode>
c0101f11:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101f14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f1e:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f24:	c1 e8 09             	shr    $0x9,%eax
c0101f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101f2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f2d:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f33:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101f3b:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f41:	01 d0                	add    %edx,%eax
c0101f43:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f48:	0f 86 53 01 00 00    	jbe    c01020a1 <fs_write_base_kr+0x1b6>
		readData(inode.data_block_offsets[D]);
c0101f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f51:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101f58:	50                   	push   %eax
c0101f59:	e8 59 fa ff ff       	call   c01019b7 <readData>
c0101f5e:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101f61:	b8 00 02 00 00       	mov    $0x200,%eax
c0101f66:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f69:	89 c2                	mov    %eax,%edx
c0101f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f6e:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101f73:	52                   	push   %edx
c0101f74:	ff 75 0c             	pushl  0xc(%ebp)
c0101f77:	50                   	push   %eax
c0101f78:	e8 d1 f6 ff ff       	call   c010164e <memcpy2>
c0101f7d:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f83:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101f8a:	50                   	push   %eax
c0101f8b:	e8 42 fa ff ff       	call   c01019d2 <saveData>
c0101f90:	83 c4 04             	add    $0x4,%esp
		f->offset += BLOCK_SIZE-R;
c0101f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f96:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f9c:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f9f:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fa8:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fb1:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101fb4:	05 00 02 00 00       	add    $0x200,%eax
c0101fb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101fbc:	8b 55 10             	mov    0x10(%ebp),%edx
c0101fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101fc2:	01 d0                	add    %edx,%eax
c0101fc4:	2d 00 02 00 00       	sub    $0x200,%eax
c0101fc9:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101fcc:	eb 63                	jmp    c0102031 <fs_write_base_kr+0x146>
			D = f->offset >> 9;
c0101fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fd1:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101fd7:	c1 e8 09             	shr    $0x9,%eax
c0101fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fe3:	01 d0                	add    %edx,%eax
c0101fe5:	68 00 02 00 00       	push   $0x200
c0101fea:	50                   	push   %eax
c0101feb:	68 80 d5 1f c0       	push   $0xc01fd580
c0101ff0:	e8 59 f6 ff ff       	call   c010164e <memcpy2>
c0101ff5:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ffb:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0102002:	50                   	push   %eax
c0102003:	e8 ca f9 ff ff       	call   c01019d2 <saveData>
c0102008:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c010200b:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0102012:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102015:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c010201b:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0102021:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102024:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c010202a:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0102031:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0102038:	7f 94                	jg     c0101fce <fs_write_base_kr+0xe3>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c010203a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010203d:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0102043:	c1 e8 09             	shr    $0x9,%eax
c0102046:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0102049:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010204c:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0102053:	50                   	push   %eax
c0102054:	e8 5e f9 ff ff       	call   c01019b7 <readData>
c0102059:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c010205c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010205f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102062:	01 d0                	add    %edx,%eax
c0102064:	ff 75 10             	pushl  0x10(%ebp)
c0102067:	50                   	push   %eax
c0102068:	68 80 d5 1f c0       	push   $0xc01fd580
c010206d:	e8 dc f5 ff ff       	call   c010164e <memcpy2>
c0102072:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102075:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102078:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c010207f:	50                   	push   %eax
c0102080:	e8 4d f9 ff ff       	call   c01019d2 <saveData>
c0102085:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0102088:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010208b:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102091:	8b 45 10             	mov    0x10(%ebp),%eax
c0102094:	01 c2                	add    %eax,%edx
c0102096:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102099:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c010209f:	eb 54                	jmp    c01020f5 <fs_write_base_kr+0x20a>
	}else{
		readData(inode.data_block_offsets[D]);
c01020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020a4:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c01020ab:	50                   	push   %eax
c01020ac:	e8 06 f9 ff ff       	call   c01019b7 <readData>
c01020b1:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c01020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01020b7:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c01020bc:	ff 75 10             	pushl  0x10(%ebp)
c01020bf:	ff 75 0c             	pushl  0xc(%ebp)
c01020c2:	50                   	push   %eax
c01020c3:	e8 86 f5 ff ff       	call   c010164e <memcpy2>
c01020c8:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c01020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020ce:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c01020d5:	50                   	push   %eax
c01020d6:	e8 f7 f8 ff ff       	call   c01019d2 <saveData>
c01020db:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c01020de:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020e1:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01020ea:	01 c2                	add    %eax,%edx
c01020ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020ef:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c01020f5:	c9                   	leave  
c01020f6:	c3                   	ret    

c01020f7 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c01020f7:	55                   	push   %ebp
c01020f8:	89 e5                	mov    %esp,%ebp
c01020fa:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01020fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102100:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102106:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c010210b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	if(f->file_size == 0){
c010210e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102111:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102117:	85 c0                	test   %eax,%eax
c0102119:	75 48                	jne    c0102163 <fs_write_kr+0x6c>
		readINode(f->inode_offset);
c010211b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010211e:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102124:	50                   	push   %eax
c0102125:	e8 57 f8 ff ff       	call   c0101981 <readINode>
c010212a:	83 c4 04             	add    $0x4,%esp
		inode.data_block_offsets[0] = dataAlloc();
c010212d:	e8 4f f9 ff ff       	call   c0101a81 <dataAlloc>
c0102132:	a3 80 d9 1f c0       	mov    %eax,0xc01fd980
		saveINode(f->inode_offset);
c0102137:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010213a:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102140:	50                   	push   %eax
c0102141:	e8 56 f8 ff ff       	call   c010199c <saveINode>
c0102146:	83 c4 04             	add    $0x4,%esp
		f->file_size = len>512?512:len;
c0102149:	8b 45 10             	mov    0x10(%ebp),%eax
c010214c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0102151:	7e 05                	jle    c0102158 <fs_write_kr+0x61>
c0102153:	b8 00 02 00 00       	mov    $0x200,%eax
c0102158:	89 c2                	mov    %eax,%edx
c010215a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010215d:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
		//printk("legal high %d\n", f->file_size);
	}
	
	if(f->offset + len > f->file_size){
c0102163:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102166:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c010216c:	8b 45 10             	mov    0x10(%ebp),%eax
c010216f:	01 c2                	add    %eax,%edx
c0102171:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102174:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c010217a:	39 c2                	cmp    %eax,%edx
c010217c:	0f 86 81 00 00 00    	jbe    c0102203 <fs_write_kr+0x10c>
		readINode(f->inode_offset);
c0102182:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102185:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010218b:	50                   	push   %eax
c010218c:	e8 f0 f7 ff ff       	call   c0101981 <readINode>
c0102191:	83 c4 04             	add    $0x4,%esp
		D1 = f->offset >> 9;
c0102194:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102197:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c010219d:	c1 e8 09             	shr    $0x9,%eax
c01021a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
		D2 = (f->offset + len) >> 9;
c01021a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021a6:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01021ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01021af:	01 d0                	add    %edx,%eax
c01021b1:	c1 e8 09             	shr    $0x9,%eax
c01021b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		D1 += 1;
c01021b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
		while(D1<=D2){
c01021bb:	eb 15                	jmp    c01021d2 <fs_write_kr+0xdb>
			inode.data_block_offsets[D1] = dataAlloc();
c01021bd:	e8 bf f8 ff ff       	call   c0101a81 <dataAlloc>
c01021c2:	89 c2                	mov    %eax,%edx
c01021c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c7:	89 14 85 80 d9 1f c0 	mov    %edx,-0x3fe02680(,%eax,4)
			D1 ++;
c01021ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	if(f->offset + len > f->file_size){
		readINode(f->inode_offset);
		D1 = f->offset >> 9;
		D2 = (f->offset + len) >> 9;
		D1 += 1;
		while(D1<=D2){
c01021d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01021d8:	7e e3                	jle    c01021bd <fs_write_kr+0xc6>
			inode.data_block_offsets[D1] = dataAlloc();
			D1 ++;
		}
		saveINode(f->inode_offset);
c01021da:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021dd:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01021e3:	50                   	push   %eax
c01021e4:	e8 b3 f7 ff ff       	call   c010199c <saveINode>
c01021e9:	83 c4 04             	add    $0x4,%esp
		f->file_size = f->offset + len;
c01021ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021ef:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01021f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01021f8:	01 c2                	add    %eax,%edx
c01021fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021fd:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	};
	readDir(f->dir_offset);
c0102203:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102206:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c010220c:	50                   	push   %eax
c010220d:	e8 39 f7 ff ff       	call   c010194b <readDir>
c0102212:	83 c4 04             	add    $0x4,%esp
	dir.entries[f->entry_offset].file_size = f->file_size;
c0102215:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102218:	8b 90 10 02 00 00    	mov    0x210(%eax),%edx
c010221e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102221:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102227:	c1 e2 05             	shl    $0x5,%edx
c010222a:	83 c2 10             	add    $0x10,%edx
c010222d:	81 c2 80 d7 1f c0    	add    $0xc01fd780,%edx
c0102233:	89 42 08             	mov    %eax,0x8(%edx)
	saveDir(f->dir_offset);
c0102236:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102239:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c010223f:	50                   	push   %eax
c0102240:	e8 21 f7 ff ff       	call   c0101966 <saveDir>
c0102245:	83 c4 04             	add    $0x4,%esp
	fs_write_base_kr(fd, buf, len);
c0102248:	ff 75 10             	pushl  0x10(%ebp)
c010224b:	ff 75 0c             	pushl  0xc(%ebp)
c010224e:	ff 75 08             	pushl  0x8(%ebp)
c0102251:	e8 95 fc ff ff       	call   c0101eeb <fs_write_base_kr>
c0102256:	83 c4 0c             	add    $0xc,%esp
	return len;
c0102259:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c010225c:	c9                   	leave  
c010225d:	c3                   	ret    

c010225e <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c010225e:	55                   	push   %ebp
c010225f:	89 e5                	mov    %esp,%ebp
c0102261:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102264:	8b 45 08             	mov    0x8(%ebp),%eax
c0102267:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010226d:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102272:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c0102275:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102278:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010227b:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c0102281:	c9                   	leave  
c0102282:	c3                   	ret    

c0102283 <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c0102283:	55                   	push   %ebp
c0102284:	89 e5                	mov    %esp,%ebp
c0102286:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102289:	8b 45 08             	mov    0x8(%ebp),%eax
c010228c:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102292:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c010229a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229d:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
	}
c01022a3:	c9                   	leave  
c01022a4:	c3                   	ret    

c01022a5 <fs_close_kr>:
int fs_close_kr(int fd){
c01022a5:	55                   	push   %ebp
c01022a6:	89 e5                	mov    %esp,%ebp
c01022a8:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01022ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ae:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01022b4:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01022b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->used){
c01022bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022bf:	0f b6 80 2c 02 00 00 	movzbl 0x22c(%eax),%eax
c01022c6:	84 c0                	test   %al,%al
c01022c8:	74 11                	je     c01022db <fs_close_kr+0x36>
		f->used = 0;
c01022ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022cd:	c6 80 2c 02 00 00 00 	movb   $0x0,0x22c(%eax)
		return 0;
c01022d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01022d9:	eb 05                	jmp    c01022e0 <fs_close_kr+0x3b>
	}else
		return 1;
c01022db:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01022e0:	c9                   	leave  
c01022e1:	c3                   	ret    

c01022e2 <some>:
void some(){
c01022e2:	55                   	push   %ebp
c01022e3:	89 e5                	mov    %esp,%ebp

}
c01022e5:	5d                   	pop    %ebp
c01022e6:	c3                   	ret    

c01022e7 <fs_create_kr>:
int fs_create_kr(char* name){
c01022e7:	55                   	push   %ebp
c01022e8:	89 e5                	mov    %esp,%ebp
c01022ea:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c01022ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01022f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c01022fb:	e9 d8 00 00 00       	jmp    c01023d8 <fs_create_kr+0xf1>
		readDir(dir_offset);
c0102300:	ff 75 fc             	pushl  -0x4(%ebp)
c0102303:	e8 43 f6 ff ff       	call   c010194b <readDir>
c0102308:	83 c4 04             	add    $0x4,%esp
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c010230b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0102312:	e9 b1 00 00 00       	jmp    c01023c8 <fs_create_kr+0xe1>
			if(dir.entries[entry_offset].inode_offset == -1)
c0102317:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010231a:	c1 e0 05             	shl    $0x5,%eax
c010231d:	83 c0 10             	add    $0x10,%eax
c0102320:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102325:	8b 40 0c             	mov    0xc(%eax),%eax
c0102328:	83 f8 ff             	cmp    $0xffffffff,%eax
c010232b:	0f 85 93 00 00 00    	jne    c01023c4 <fs_create_kr+0xdd>
				goto OUT_OF_LOOP;
c0102331:	90                   	nop
	
	//FILE_STREAM *f;
	int i=0;

	OUT_OF_LOOP:
	some();
c0102332:	e8 ab ff ff ff       	call   c01022e2 <some>
	//printk("##%d\n", entry_offset);
	int index_inode = INodeAlloc();
c0102337:	e8 b1 f6 ff ff       	call   c01019ed <INodeAlloc>
c010233c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//printk("##%d\n", index_inode);
	dir.entries[entry_offset].inode_offset = index_inode;
c010233f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102342:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102345:	c1 e2 05             	shl    $0x5,%edx
c0102348:	83 c2 10             	add    $0x10,%edx
c010234b:	81 c2 80 d7 1f c0    	add    $0xc01fd780,%edx
c0102351:	89 42 0c             	mov    %eax,0xc(%edx)
	strcpy(dir.entries[entry_offset].filename, name);
c0102354:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102357:	c1 e0 05             	shl    $0x5,%eax
c010235a:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c010235f:	ff 75 08             	pushl  0x8(%ebp)
c0102362:	50                   	push   %eax
c0102363:	e8 5b f3 ff ff       	call   c01016c3 <strcpy>
c0102368:	83 c4 08             	add    $0x8,%esp
	//printk("##%s\n", name);
	//printk("##%s\n", dir.entries[entry_offset].filename);
	dir.entries[entry_offset].file_size = 0;
c010236b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010236e:	c1 e0 05             	shl    $0x5,%eax
c0102371:	83 c0 10             	add    $0x10,%eax
c0102374:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102379:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
	saveDir(dir_offset);
c0102380:	ff 75 fc             	pushl  -0x4(%ebp)
c0102383:	e8 de f5 ff ff       	call   c0101966 <saveDir>
c0102388:	83 c4 04             	add    $0x4,%esp

	readINode(index_inode);
c010238b:	ff 75 f0             	pushl  -0x10(%ebp)
c010238e:	e8 ee f5 ff ff       	call   c0101981 <readINode>
c0102393:	83 c4 04             	add    $0x4,%esp
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
c0102396:	68 00 02 00 00       	push   $0x200
c010239b:	68 ff 00 00 00       	push   $0xff
c01023a0:	68 80 d9 1f c0       	push   $0xc01fd980
c01023a5:	e8 c1 f2 ff ff       	call   c010166b <memset2>
c01023aa:	83 c4 0c             	add    $0xc,%esp
	saveINode(index_inode);
c01023ad:	ff 75 f0             	pushl  -0x10(%ebp)
c01023b0:	e8 e7 f5 ff ff       	call   c010199c <saveINode>
c01023b5:	83 c4 04             	add    $0x4,%esp
	for(i=0; i<NR_FILE_STREAM; i++){
c01023b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023bf:	e9 37 01 00 00       	jmp    c01024fb <fs_create_kr+0x214>
}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c01023c4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01023c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01023cb:	83 f8 0f             	cmp    $0xf,%eax
c01023ce:	0f 86 43 ff ff ff    	jbe    c0102317 <fs_create_kr+0x30>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
c01023d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
void some(){

}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c01023d8:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01023df:	0f 8e 1b ff ff ff    	jle    c0102300 <fs_create_kr+0x19>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
	}
	goto FAILURE;
c01023e5:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c01023e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01023eb:	e9 1d 01 00 00       	jmp    c010250d <fs_create_kr+0x226>

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c01023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023f3:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023f9:	05 20 02 00 00       	add    $0x220,%eax
c01023fe:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102403:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0102407:	84 c0                	test   %al,%al
c0102409:	0f 85 e8 00 00 00    	jne    c01024f7 <fs_create_kr+0x210>
			fs[i].used = 1;
c010240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102412:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102418:	05 20 02 00 00       	add    $0x220,%eax
c010241d:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102422:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0102426:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102429:	c1 e0 05             	shl    $0x5,%eax
c010242c:	83 c0 10             	add    $0x10,%eax
c010242f:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102434:	8b 40 08             	mov    0x8(%eax),%eax
c0102437:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010243a:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0102440:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102446:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c010244c:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c010244f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102452:	c1 e0 05             	shl    $0x5,%eax
c0102455:	8d 90 80 d7 1f c0    	lea    -0x3fe02880(%eax),%edx
c010245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010245e:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102464:	05 10 02 00 00       	add    $0x210,%eax
c0102469:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c010246e:	83 c0 04             	add    $0x4,%eax
c0102471:	52                   	push   %edx
c0102472:	50                   	push   %eax
c0102473:	e8 4b f2 ff ff       	call   c01016c3 <strcpy>
c0102478:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c010247b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010247e:	c1 e0 05             	shl    $0x5,%eax
c0102481:	83 c0 10             	add    $0x10,%eax
c0102484:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102489:	8b 40 0c             	mov    0xc(%eax),%eax
c010248c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010248f:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0102495:	81 c2 00 02 00 00    	add    $0x200,%edx
c010249b:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c01024a1:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c01024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024a7:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01024ad:	05 00 02 00 00       	add    $0x200,%eax
c01024b2:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01024b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c01024bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01024c3:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c01024c9:	81 c2 00 02 00 00    	add    $0x200,%edx
c01024cf:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c01024d5:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c01024d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024db:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01024de:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c01024e4:	81 c2 10 02 00 00    	add    $0x210,%edx
c01024ea:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c01024f0:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c01024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024f5:	eb 16                	jmp    c010250d <fs_create_kr+0x226>
	saveDir(dir_offset);

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
c01024f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024fb:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0102502:	0f 8e e8 fe ff ff    	jle    c01023f0 <fs_create_kr+0x109>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0102508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c010250d:	c9                   	leave  
c010250e:	c3                   	ret    

c010250f <fs_open_md>:

int fs_open_md(char *pathname, int flags){
c010250f:	55                   	push   %ebp
c0102510:	89 e5                	mov    %esp,%ebp
c0102512:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_kr(pathname);
c0102515:	ff 75 08             	pushl  0x8(%ebp)
c0102518:	e8 f8 f5 ff ff       	call   c0101b15 <fs_open_kr>
c010251d:	83 c4 04             	add    $0x4,%esp
c0102520:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(fd == -1 && flags >= 1 ){
c0102523:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
c0102527:	75 14                	jne    c010253d <fs_open_md+0x2e>
c0102529:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010252d:	7e 0e                	jle    c010253d <fs_open_md+0x2e>
		fd = fs_create_kr(pathname);
c010252f:	ff 75 08             	pushl  0x8(%ebp)
c0102532:	e8 b0 fd ff ff       	call   c01022e7 <fs_create_kr>
c0102537:	83 c4 04             	add    $0x4,%esp
c010253a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	};
	if(flags == 2){
c010253d:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
c0102541:	75 1a                	jne    c010255d <fs_open_md+0x4e>
		fs[fd].file_size = 0;
c0102543:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102546:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010254c:	05 00 02 00 00       	add    $0x200,%eax
c0102551:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102556:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	//printk("step 1\n");
	return fd;
c010255d:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c0102560:	c9                   	leave  
c0102561:	c3                   	ret    

c0102562 <fs_read_md>:
int fs_read_md(int fd, void *buf, int len){
c0102562:	55                   	push   %ebp
c0102563:	89 e5                	mov    %esp,%ebp
	return fs_read_kr(fd, buf, len);
c0102565:	ff 75 10             	pushl  0x10(%ebp)
c0102568:	ff 75 0c             	pushl  0xc(%ebp)
c010256b:	ff 75 08             	pushl  0x8(%ebp)
c010256e:	e8 0a f9 ff ff       	call   c0101e7d <fs_read_kr>
c0102573:	83 c4 0c             	add    $0xc,%esp
};
c0102576:	c9                   	leave  
c0102577:	c3                   	ret    

c0102578 <fs_write_md>:
int fs_write_md(int fd, void *buf, int len){
c0102578:	55                   	push   %ebp
c0102579:	89 e5                	mov    %esp,%ebp
	return fs_write_kr(fd, buf, len);
c010257b:	ff 75 10             	pushl  0x10(%ebp)
c010257e:	ff 75 0c             	pushl  0xc(%ebp)
c0102581:	ff 75 08             	pushl  0x8(%ebp)
c0102584:	e8 6e fb ff ff       	call   c01020f7 <fs_write_kr>
c0102589:	83 c4 0c             	add    $0xc,%esp
};
c010258c:	c9                   	leave  
c010258d:	c3                   	ret    

c010258e <fs_lseek_md>:
int fs_lseek_md(int fd, int offset, int whence){
c010258e:	55                   	push   %ebp
c010258f:	89 e5                	mov    %esp,%ebp
c0102591:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102594:	8b 45 08             	mov    0x8(%ebp),%eax
c0102597:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010259d:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01025a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t index = 0;
c01025a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	if(whence == 0){
c01025ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01025b0:	75 08                	jne    c01025ba <fs_lseek_md+0x2c>
		index = offset;
c01025b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01025b8:	eb 30                	jmp    c01025ea <fs_lseek_md+0x5c>
	}else if(whence == 1){
c01025ba:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
c01025be:	75 13                	jne    c01025d3 <fs_lseek_md+0x45>
		index = f->offset + offset;
c01025c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025c3:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01025c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025cc:	01 d0                	add    %edx,%eax
c01025ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01025d1:	eb 17                	jmp    c01025ea <fs_lseek_md+0x5c>
	}else if(whence == 2){
c01025d3:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
c01025d7:	75 11                	jne    c01025ea <fs_lseek_md+0x5c>
		index = f->file_size + offset;
c01025d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025dc:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c01025e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025e5:	01 d0                	add    %edx,%eax
c01025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
	fs_lseek_kr(fd, index);
c01025ea:	ff 75 fc             	pushl  -0x4(%ebp)
c01025ed:	ff 75 08             	pushl  0x8(%ebp)
c01025f0:	e8 69 fc ff ff       	call   c010225e <fs_lseek_kr>
c01025f5:	83 c4 08             	add    $0x8,%esp
	return index;
c01025f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c01025fb:	c9                   	leave  
c01025fc:	c3                   	ret    

c01025fd <fs_close_md>:
int fs_close_md(int fd){
c01025fd:	55                   	push   %ebp
c01025fe:	89 e5                	mov    %esp,%ebp
	return fs_close_kr(fd);
c0102600:	ff 75 08             	pushl  0x8(%ebp)
c0102603:	e8 9d fc ff ff       	call   c01022a5 <fs_close_kr>
c0102608:	83 c4 04             	add    $0x4,%esp
};
c010260b:	c9                   	leave  
c010260c:	c3                   	ret    

c010260d <fs_open_port>:

int fs_open_port(char *pathname, int flags){
c010260d:	55                   	push   %ebp
c010260e:	89 e5                	mov    %esp,%ebp
c0102610:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_md(pathname, flags);
c0102613:	ff 75 0c             	pushl  0xc(%ebp)
c0102616:	ff 75 08             	pushl  0x8(%ebp)
c0102619:	e8 f1 fe ff ff       	call   c010250f <fs_open_md>
c010261e:	83 c4 08             	add    $0x8,%esp
c0102621:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(fd == -1)
c0102624:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
c0102628:	75 07                	jne    c0102631 <fs_open_port+0x24>
		return -1;
c010262a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010262f:	eb 4c                	jmp    c010267d <fs_open_port+0x70>
	int i = 0;
c0102631:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i<FCBMAX; i++){
c0102638:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010263f:	eb 1c                	jmp    c010265d <fs_open_port+0x50>
		if(current->fcb[i].fd_kr == -1)
c0102641:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0102646:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102649:	81 c2 18 08 00 00    	add    $0x818,%edx
c010264f:	8b 04 90             	mov    (%eax,%edx,4),%eax
c0102652:	83 f8 ff             	cmp    $0xffffffff,%eax
c0102655:	75 02                	jne    c0102659 <fs_open_port+0x4c>
			break;
c0102657:	eb 0d                	jmp    c0102666 <fs_open_port+0x59>
int fs_open_port(char *pathname, int flags){
	int fd = fs_open_md(pathname, flags);
	if(fd == -1)
		return -1;
	int i = 0;
	for(i = 0; i<FCBMAX; i++){
c0102659:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010265d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102664:	7e db                	jle    c0102641 <fs_open_port+0x34>
		if(current->fcb[i].fd_kr == -1)
			break;
	}
	current->fcb[i].fd_kr = fd;
c0102666:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010266b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010266e:	8d 8a 18 08 00 00    	lea    0x818(%edx),%ecx
c0102674:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102677:	89 14 88             	mov    %edx,(%eax,%ecx,4)
	return i;
c010267a:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c010267d:	c9                   	leave  
c010267e:	c3                   	ret    

c010267f <fs_read_port>:
int fs_read_port(int fd, void *buf, int len){
c010267f:	55                   	push   %ebp
c0102680:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c0102682:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102686:	75 07                	jne    c010268f <fs_read_port+0x10>
		return -1;
c0102688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010268d:	eb 20                	jmp    c01026af <fs_read_port+0x30>
	return fs_read_md(current->fcb[fd].fd_kr, buf, len);
c010268f:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0102694:	8b 55 08             	mov    0x8(%ebp),%edx
c0102697:	81 c2 18 08 00 00    	add    $0x818,%edx
c010269d:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01026a0:	ff 75 10             	pushl  0x10(%ebp)
c01026a3:	ff 75 0c             	pushl  0xc(%ebp)
c01026a6:	50                   	push   %eax
c01026a7:	e8 b6 fe ff ff       	call   c0102562 <fs_read_md>
c01026ac:	83 c4 0c             	add    $0xc,%esp
};
c01026af:	c9                   	leave  
c01026b0:	c3                   	ret    

c01026b1 <fs_write_port>:
int fs_write_port(int fd, void *buf, int len){
c01026b1:	55                   	push   %ebp
c01026b2:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c01026b4:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c01026b8:	75 07                	jne    c01026c1 <fs_write_port+0x10>
		return -1;
c01026ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01026bf:	eb 20                	jmp    c01026e1 <fs_write_port+0x30>
	return fs_write_md(current->fcb[fd].fd_kr, buf, len);
c01026c1:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01026c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01026c9:	81 c2 18 08 00 00    	add    $0x818,%edx
c01026cf:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01026d2:	ff 75 10             	pushl  0x10(%ebp)
c01026d5:	ff 75 0c             	pushl  0xc(%ebp)
c01026d8:	50                   	push   %eax
c01026d9:	e8 9a fe ff ff       	call   c0102578 <fs_write_md>
c01026de:	83 c4 0c             	add    $0xc,%esp
};
c01026e1:	c9                   	leave  
c01026e2:	c3                   	ret    

c01026e3 <fs_lseek_port>:
int fs_lseek_port(int fd, int offset, int whence){
c01026e3:	55                   	push   %ebp
c01026e4:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c01026e6:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c01026ea:	75 07                	jne    c01026f3 <fs_lseek_port+0x10>
		return -1;
c01026ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01026f1:	eb 20                	jmp    c0102713 <fs_lseek_port+0x30>
	return fs_lseek_md(current->fcb[fd].fd_kr, offset, whence);
c01026f3:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01026f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01026fb:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102701:	8b 04 90             	mov    (%eax,%edx,4),%eax
c0102704:	ff 75 10             	pushl  0x10(%ebp)
c0102707:	ff 75 0c             	pushl  0xc(%ebp)
c010270a:	50                   	push   %eax
c010270b:	e8 7e fe ff ff       	call   c010258e <fs_lseek_md>
c0102710:	83 c4 0c             	add    $0xc,%esp
};
c0102713:	c9                   	leave  
c0102714:	c3                   	ret    

c0102715 <fs_close_port>:
int fs_close_port(int fd){
c0102715:	55                   	push   %ebp
c0102716:	89 e5                	mov    %esp,%ebp
c0102718:	83 ec 10             	sub    $0x10,%esp
	if(fd == -1)
c010271b:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c010271f:	75 07                	jne    c0102728 <fs_close_port+0x13>
		return -1;
c0102721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102726:	eb 35                	jmp    c010275d <fs_close_port+0x48>
	int ret = fs_close_md(current->fcb[fd].fd_kr);
c0102728:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010272d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102730:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102736:	8b 04 90             	mov    (%eax,%edx,4),%eax
c0102739:	50                   	push   %eax
c010273a:	e8 be fe ff ff       	call   c01025fd <fs_close_md>
c010273f:	83 c4 04             	add    $0x4,%esp
c0102742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	current->fcb[fd].fd_kr = -1;
c0102745:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010274a:	8b 55 08             	mov    0x8(%ebp),%edx
c010274d:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102753:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	return ret;
c010275a:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c010275d:	c9                   	leave  
c010275e:	c3                   	ret    

c010275f <fs_ls_kr>:

void fs_ls_kr(uint32_t mask){
c010275f:	55                   	push   %ebp
c0102760:	89 e5                	mov    %esp,%ebp
c0102762:	83 ec 18             	sub    $0x18,%esp
	int dir_offset = 0, entry_offset = 0;
c0102765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010276c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while(dir_offset < SC_DIR){
c0102773:	e9 47 01 00 00       	jmp    c01028bf <fs_ls_kr+0x160>
		readDir(dir_offset);
c0102778:	ff 75 f4             	pushl  -0xc(%ebp)
c010277b:	e8 cb f1 ff ff       	call   c010194b <readDir>
c0102780:	83 c4 04             	add    $0x4,%esp
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0102783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010278a:	e9 20 01 00 00       	jmp    c01028af <fs_ls_kr+0x150>
			if(dir.entries[entry_offset].inode_offset != -1){
c010278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102792:	c1 e0 05             	shl    $0x5,%eax
c0102795:	83 c0 10             	add    $0x10,%eax
c0102798:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c010279d:	8b 40 0c             	mov    0xc(%eax),%eax
c01027a0:	83 f8 ff             	cmp    $0xffffffff,%eax
c01027a3:	0f 84 02 01 00 00    	je     c01028ab <fs_ls_kr+0x14c>
				struct dirent *entry = &dir.entries[entry_offset];
c01027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01027ac:	c1 e0 05             	shl    $0x5,%eax
c01027af:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c01027b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if((mask & 0x02) == 0 && entry->filename[0] == '.')continue;
c01027b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ba:	83 e0 02             	and    $0x2,%eax
c01027bd:	85 c0                	test   %eax,%eax
c01027bf:	75 0f                	jne    c01027d0 <fs_ls_kr+0x71>
c01027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01027c4:	0f b6 00             	movzbl (%eax),%eax
c01027c7:	3c 2e                	cmp    $0x2e,%al
c01027c9:	75 05                	jne    c01027d0 <fs_ls_kr+0x71>
c01027cb:	e9 db 00 00 00       	jmp    c01028ab <fs_ls_kr+0x14c>
				if((mask & 0x01) == 0){
c01027d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d3:	83 e0 01             	and    $0x1,%eax
c01027d6:	85 c0                	test   %eax,%eax
c01027d8:	75 19                	jne    c01027f3 <fs_ls_kr+0x94>
					printk("%s\n", entry->filename);
c01027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01027dd:	83 ec 08             	sub    $0x8,%esp
c01027e0:	50                   	push   %eax
c01027e1:	68 6d 4e 10 c0       	push   $0xc0104e6d
c01027e6:	e8 3e ee ff ff       	call   c0101629 <printk>
c01027eb:	83 c4 10             	add    $0x10,%esp
c01027ee:	e9 b8 00 00 00       	jmp    c01028ab <fs_ls_kr+0x14c>
				}
				else{
					//printk("%d %d\n", mask, mask&0x04);
					if((mask & 0x04) != 0){
c01027f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f6:	83 e0 04             	and    $0x4,%eax
c01027f9:	85 c0                	test   %eax,%eax
c01027fb:	0f 84 8f 00 00 00    	je     c0102890 <fs_ls_kr+0x131>
						//printk("miaomiaomiao");
						int size = entry->file_size;
c0102801:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102804:	8b 40 18             	mov    0x18(%eax),%eax
c0102807:	89 45 e8             	mov    %eax,-0x18(%ebp)
						if(size < 1024){
c010280a:	81 7d e8 ff 03 00 00 	cmpl   $0x3ff,-0x18(%ebp)
c0102811:	7f 19                	jg     c010282c <fs_ls_kr+0xcd>
							//printk("b!");
							printk("%d\t%s\n", size, entry->filename);
c0102813:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102816:	83 ec 04             	sub    $0x4,%esp
c0102819:	50                   	push   %eax
c010281a:	ff 75 e8             	pushl  -0x18(%ebp)
c010281d:	68 71 4e 10 c0       	push   $0xc0104e71
c0102822:	e8 02 ee ff ff       	call   c0101629 <printk>
c0102827:	83 c4 10             	add    $0x10,%esp
							continue;
c010282a:	eb 7f                	jmp    c01028ab <fs_ls_kr+0x14c>
						}
						size /= 1024;
c010282c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010282f:	99                   	cltd   
c0102830:	c1 ea 16             	shr    $0x16,%edx
c0102833:	01 d0                	add    %edx,%eax
c0102835:	c1 f8 0a             	sar    $0xa,%eax
c0102838:	89 45 e8             	mov    %eax,-0x18(%ebp)
						if(size < 1024){
c010283b:	81 7d e8 ff 03 00 00 	cmpl   $0x3ff,-0x18(%ebp)
c0102842:	7f 19                	jg     c010285d <fs_ls_kr+0xfe>
							//printk("k!");
							printk("%dK\t%s\n", size, entry->filename);
c0102844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102847:	83 ec 04             	sub    $0x4,%esp
c010284a:	50                   	push   %eax
c010284b:	ff 75 e8             	pushl  -0x18(%ebp)
c010284e:	68 78 4e 10 c0       	push   $0xc0104e78
c0102853:	e8 d1 ed ff ff       	call   c0101629 <printk>
c0102858:	83 c4 10             	add    $0x10,%esp
							continue;
c010285b:	eb 4e                	jmp    c01028ab <fs_ls_kr+0x14c>
						}
						size /= 1024;
c010285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102860:	99                   	cltd   
c0102861:	c1 ea 16             	shr    $0x16,%edx
c0102864:	01 d0                	add    %edx,%eax
c0102866:	c1 f8 0a             	sar    $0xa,%eax
c0102869:	89 45 e8             	mov    %eax,-0x18(%ebp)
						if(size < 1024){
c010286c:	81 7d e8 ff 03 00 00 	cmpl   $0x3ff,-0x18(%ebp)
c0102873:	7f 19                	jg     c010288e <fs_ls_kr+0x12f>
							//printk("m!");
							printk("%dM\t%s\n", size, entry->filename);
c0102875:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102878:	83 ec 04             	sub    $0x4,%esp
c010287b:	50                   	push   %eax
c010287c:	ff 75 e8             	pushl  -0x18(%ebp)
c010287f:	68 80 4e 10 c0       	push   $0xc0104e80
c0102884:	e8 a0 ed ff ff       	call   c0101629 <printk>
c0102889:	83 c4 10             	add    $0x10,%esp
							continue;
c010288c:	eb 1d                	jmp    c01028ab <fs_ls_kr+0x14c>
c010288e:	eb 1b                	jmp    c01028ab <fs_ls_kr+0x14c>
						}
					}else{
						printk("%d\t%s\n", entry->file_size, entry->filename);
c0102890:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102893:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102896:	8b 40 18             	mov    0x18(%eax),%eax
c0102899:	83 ec 04             	sub    $0x4,%esp
c010289c:	52                   	push   %edx
c010289d:	50                   	push   %eax
c010289e:	68 71 4e 10 c0       	push   $0xc0104e71
c01028a3:	e8 81 ed ff ff       	call   c0101629 <printk>
c01028a8:	83 c4 10             	add    $0x10,%esp

void fs_ls_kr(uint32_t mask){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c01028ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01028b2:	83 f8 0f             	cmp    $0xf,%eax
c01028b5:	0f 86 d4 fe ff ff    	jbe    c010278f <fs_ls_kr+0x30>
						printk("%d\t%s\n", entry->file_size, entry->filename);
					}
				}
			}
		}
		dir_offset ++;
c01028bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
	return ret;
};

void fs_ls_kr(uint32_t mask){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c01028bf:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c01028c6:	0f 8e ac fe ff ff    	jle    c0102778 <fs_ls_kr+0x19>
				}
			}
		}
		dir_offset ++;
	}
}
c01028cc:	c9                   	leave  
c01028cd:	c3                   	ret    

c01028ce <init_fs>:

void init_fs(){
c01028ce:	55                   	push   %ebp
c01028cf:	89 e5                	mov    %esp,%ebp
c01028d1:	83 ec 68             	sub    $0x68,%esp
	//readDir(0);
	int i=0;
c01028d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c01028db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01028e2:	eb 1b                	jmp    c01028ff <init_fs+0x31>
		fs[i].used = 0;
c01028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028e7:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01028ed:	05 20 02 00 00       	add    $0x220,%eax
c01028f2:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01028f7:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
}

void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c01028fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01028ff:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0102906:	7e dc                	jle    c01028e4 <init_fs+0x16>
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
c0102908:	68 88 4e 10 c0       	push   $0xc0104e88
c010290d:	e8 03 f2 ff ff       	call   c0101b15 <fs_open_kr>
c0102912:	83 c4 04             	add    $0x4,%esp
c0102915:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char magic[80];
	
	fs_read_kr(fd, magic, 80);
c0102918:	6a 50                	push   $0x50
c010291a:	8d 45 a0             	lea    -0x60(%ebp),%eax
c010291d:	50                   	push   %eax
c010291e:	ff 75 f0             	pushl  -0x10(%ebp)
c0102921:	e8 57 f5 ff ff       	call   c0101e7d <fs_read_kr>
c0102926:	83 c4 0c             	add    $0xc,%esp
	fs_close_kr(fd);
c0102929:	ff 75 f0             	pushl  -0x10(%ebp)
c010292c:	e8 74 f9 ff ff       	call   c01022a5 <fs_close_kr>
c0102931:	83 c4 04             	add    $0x4,%esp
	printk("%s\n", magic);
c0102934:	83 ec 08             	sub    $0x8,%esp
c0102937:	8d 45 a0             	lea    -0x60(%ebp),%eax
c010293a:	50                   	push   %eax
c010293b:	68 6d 4e 10 c0       	push   $0xc0104e6d
c0102940:	e8 e4 ec ff ff       	call   c0101629 <printk>
c0102945:	83 c4 10             	add    $0x10,%esp
c0102948:	c9                   	leave  
c0102949:	c3                   	ret    

c010294a <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c010294a:	55                   	push   %ebp
c010294b:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c010294d:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0102952:	cd 80                	int    $0x80
}
c0102954:	5d                   	pop    %ebp
c0102955:	c3                   	ret    

c0102956 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c0102956:	55                   	push   %ebp
c0102957:	89 e5                	mov    %esp,%ebp
c0102959:	83 ec 40             	sub    $0x40,%esp
c010295c:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0102963:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102967:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010296b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010296e:	ee                   	out    %al,(%dx)
c010296f:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0102976:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c010297a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010297e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102981:	ee                   	out    %al,(%dx)
c0102982:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0102989:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c010298d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102991:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102994:	ee                   	out    %al,(%dx)
c0102995:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c010299c:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01029a0:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01029a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029a7:	ee                   	out    %al,(%dx)
c01029a8:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01029af:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01029b3:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01029b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01029ba:	ee                   	out    %al,(%dx)
c01029bb:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01029c2:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01029c6:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01029ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029cd:	ee                   	out    %al,(%dx)
c01029ce:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c01029d5:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01029d9:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01029dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029e0:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01029e1:	c9                   	leave  
c01029e2:	c3                   	ret    

c01029e3 <serial_idle>:

static inline
int serial_idle(void) {
c01029e3:	55                   	push   %ebp
c01029e4:	89 e5                	mov    %esp,%ebp
c01029e6:	83 ec 10             	sub    $0x10,%esp
c01029e9:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01029f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029f3:	89 c2                	mov    %eax,%edx
c01029f5:	ec                   	in     (%dx),%al
c01029f6:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01029f9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01029fd:	0f b6 c0             	movzbl %al,%eax
c0102a00:	83 e0 20             	and    $0x20,%eax
c0102a03:	85 c0                	test   %eax,%eax
c0102a05:	0f 95 c0             	setne  %al
c0102a08:	0f b6 c0             	movzbl %al,%eax
}
c0102a0b:	c9                   	leave  
c0102a0c:	c3                   	ret    

c0102a0d <serial_printc>:

static inline
void serial_printc(char ch) {
c0102a0d:	55                   	push   %ebp
c0102a0e:	89 e5                	mov    %esp,%ebp
c0102a10:	83 ec 14             	sub    $0x14,%esp
c0102a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a16:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102a19:	90                   	nop
c0102a1a:	e8 c4 ff ff ff       	call   c01029e3 <serial_idle>
c0102a1f:	85 c0                	test   %eax,%eax
c0102a21:	74 f7                	je     c0102a1a <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102a23:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102a27:	0f b6 c0             	movzbl %al,%eax
c0102a2a:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102a31:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102a34:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102a38:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a3b:	ee                   	out    %al,(%dx)
}
c0102a3c:	c9                   	leave  
c0102a3d:	c3                   	ret    

c0102a3e <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102a3e:	55                   	push   %ebp
c0102a3f:	89 e5                	mov    %esp,%ebp
c0102a41:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102a44:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4d:	83 ec 04             	sub    $0x4,%esp
c0102a50:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a53:	50                   	push   %eax
c0102a54:	68 0d 2a 10 c0       	push   $0xc0102a0d
c0102a59:	e8 59 20 00 00       	call   c0104ab7 <vfprintf>
c0102a5e:	83 c4 10             	add    $0x10,%esp
}
c0102a61:	c9                   	leave  
c0102a62:	c3                   	ret    

c0102a63 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c0102a63:	55                   	push   %ebp
c0102a64:	89 e5                	mov    %esp,%ebp
c0102a66:	83 ec 70             	sub    $0x70,%esp
c0102a69:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0102a70:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c0102a74:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102a78:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a7b:	ee                   	out    %al,(%dx)
c0102a7c:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c0102a83:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c0102a87:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102a8e:	ee                   	out    %al,(%dx)
c0102a8f:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c0102a96:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c0102a9a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102a9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102aa1:	ee                   	out    %al,(%dx)
c0102aa2:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0102aa9:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0102aad:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ab4:	ee                   	out    %al,(%dx)
c0102ab5:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0102abc:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0102ac0:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102ac4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ac7:	ee                   	out    %al,(%dx)
c0102ac8:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0102acf:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c0102ad3:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102ad7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ada:	ee                   	out    %al,(%dx)
c0102adb:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0102ae2:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0102ae6:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102aea:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102aed:	ee                   	out    %al,(%dx)
c0102aee:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0102af5:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0102af9:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0102afd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b00:	ee                   	out    %al,(%dx)
c0102b01:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0102b08:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0102b0c:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c0102b10:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b13:	ee                   	out    %al,(%dx)
c0102b14:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0102b1b:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c0102b1f:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c0102b23:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b26:	ee                   	out    %al,(%dx)
c0102b27:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0102b2e:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0102b32:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0102b36:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102b39:	ee                   	out    %al,(%dx)
c0102b3a:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0102b41:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c0102b45:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0102b49:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102b4c:	ee                   	out    %al,(%dx)
c0102b4d:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c0102b54:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0102b58:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0102b5c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102b5f:	ee                   	out    %al,(%dx)
c0102b60:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c0102b67:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0102b6b:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0102b6f:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102b72:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c0102b73:	c9                   	leave  
c0102b74:	c3                   	ret    

c0102b75 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0102b75:	55                   	push   %ebp
c0102b76:	89 e5                	mov    %esp,%ebp
c0102b78:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0102b7b:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c0102b82:	0f b6 05 00 90 10 c0 	movzbl 0xc0109000,%eax
c0102b89:	0f b6 c0             	movzbl %al,%eax
c0102b8c:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c0102b93:	88 45 f7             	mov    %al,-0x9(%ebp)
c0102b96:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102b9a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102b9d:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0102b9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ba1:	0f b6 c0             	movzbl %al,%eax
c0102ba4:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c0102bab:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102bae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102bb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102bb5:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c0102bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102bb9:	c1 f8 08             	sar    $0x8,%eax
c0102bbc:	0f b6 c0             	movzbl %al,%eax
c0102bbf:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0102bc6:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102bc9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102bcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102bd0:	ee                   	out    %al,(%dx)
}
c0102bd1:	c9                   	leave  
c0102bd2:	c3                   	ret    

c0102bd3 <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c0102bd3:	55                   	push   %ebp
c0102bd4:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c0102bd6:	e8 6f fd ff ff       	call   c010294a <sys_handout>
  }
c0102bdb:	eb f9                	jmp    c0102bd6 <idle+0x3>

c0102bdd <main>:
}


void do_scheduler();
int main(){
c0102bdd:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0102be1:	83 e4 f0             	and    $0xfffffff0,%esp
c0102be4:	ff 71 fc             	pushl  -0x4(%ecx)
c0102be7:	55                   	push   %ebp
c0102be8:	89 e5                	mov    %esp,%ebp
c0102bea:	51                   	push   %ecx
c0102beb:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0102bee:	e8 38 d5 ff ff       	call   c010012b <init_page>
  init_segment();
c0102bf3:	e8 e4 d6 ff ff       	call   c01002dc <init_segment>
	init_serial();
c0102bf8:	e8 59 fd ff ff       	call   c0102956 <init_serial>
	init_timer();
c0102bfd:	e8 73 ff ff ff       	call   c0102b75 <init_timer>
	init_idt();
c0102c02:	e8 f2 e7 ff ff       	call   c01013f9 <init_idt>
	init_intr();
c0102c07:	e8 57 fe ff ff       	call   c0102a63 <init_intr>
  init_fs();
c0102c0c:	e8 bd fc ff ff       	call   c01028ce <init_fs>
  init_pcb_pool();
c0102c11:	e8 b2 12 00 00       	call   c0103ec8 <init_pcb_pool>
  
  printk("This is kernel!\n");
c0102c16:	83 ec 0c             	sub    $0xc,%esp
c0102c19:	68 91 4e 10 c0       	push   $0xc0104e91
c0102c1e:	e8 1b fe ff ff       	call   c0102a3e <printk>
c0102c23:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c0102c26:	e8 08 14 00 00       	call   c0104033 <pcb_create>
c0102c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0102c2e:	83 ec 08             	sub    $0x8,%esp
c0102c31:	68 d3 2b 10 c0       	push   $0xc0102bd3
c0102c36:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c39:	e8 b7 05 00 00       	call   c01031f5 <empty_loader>
c0102c3e:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c0102c41:	83 ec 0c             	sub    $0xc,%esp
c0102c44:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c47:	e8 10 15 00 00       	call   c010415c <enready_pcb>
c0102c4c:	83 c4 10             	add    $0x10,%esp
  */
  /*PCB* pcb = pcb_create();
  loader_file(pcb, "game");
  enready_pcb(pcb);*/
    
  PCB* pshell = pcb_create();
c0102c4f:	e8 df 13 00 00       	call   c0104033 <pcb_create>
c0102c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader_file(pshell, "cshell");
c0102c57:	83 ec 08             	sub    $0x8,%esp
c0102c5a:	68 a2 4e 10 c0       	push   $0xc0104ea2
c0102c5f:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c62:	e8 c3 03 00 00       	call   c010302a <loader_file>
c0102c67:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pshell);
c0102c6a:	83 ec 0c             	sub    $0xc,%esp
c0102c6d:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c70:	e8 e7 14 00 00       	call   c010415c <enready_pcb>
c0102c75:	83 c4 10             	add    $0x10,%esp

  /*PCB* app = pcb_create();
  loader_file(app, "app");
  enready_pcb(app);*/

  do_scheduler();
c0102c78:	e8 2e e4 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c0102c7d:	eb fe                	jmp    c0102c7d <main+0xa0>

c0102c7f <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102c7f:	55                   	push   %ebp
c0102c80:	89 e5                	mov    %esp,%ebp
c0102c82:	83 ec 10             	sub    $0x10,%esp
c0102c85:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c8f:	89 c2                	mov    %eax,%edx
c0102c91:	ec                   	in     (%dx),%al
c0102c92:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102c95:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102c99:	0f b6 c0             	movzbl %al,%eax
c0102c9c:	83 e0 20             	and    $0x20,%eax
c0102c9f:	85 c0                	test   %eax,%eax
c0102ca1:	0f 95 c0             	setne  %al
c0102ca4:	0f b6 c0             	movzbl %al,%eax
}
c0102ca7:	c9                   	leave  
c0102ca8:	c3                   	ret    

c0102ca9 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102ca9:	55                   	push   %ebp
c0102caa:	89 e5                	mov    %esp,%ebp
c0102cac:	83 ec 14             	sub    $0x14,%esp
c0102caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb2:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102cb5:	90                   	nop
c0102cb6:	e8 c4 ff ff ff       	call   c0102c7f <serial_idle>
c0102cbb:	85 c0                	test   %eax,%eax
c0102cbd:	74 f7                	je     c0102cb6 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102cbf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102cc3:	0f b6 c0             	movzbl %al,%eax
c0102cc6:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102ccd:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102cd0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102cd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102cd7:	ee                   	out    %al,(%dx)
}
c0102cd8:	c9                   	leave  
c0102cd9:	c3                   	ret    

c0102cda <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102cda:	55                   	push   %ebp
c0102cdb:	89 e5                	mov    %esp,%ebp
c0102cdd:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102ce0:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce9:	83 ec 04             	sub    $0x4,%esp
c0102cec:	ff 75 f4             	pushl  -0xc(%ebp)
c0102cef:	50                   	push   %eax
c0102cf0:	68 a9 2c 10 c0       	push   $0xc0102ca9
c0102cf5:	e8 bd 1d 00 00       	call   c0104ab7 <vfprintf>
c0102cfa:	83 c4 10             	add    $0x10,%esp
}
c0102cfd:	c9                   	leave  
c0102cfe:	c3                   	ret    

c0102cff <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0102cff:	55                   	push   %ebp
c0102d00:	89 e5                	mov    %esp,%ebp
c0102d02:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0102d05:	90                   	nop
c0102d06:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d10:	89 c2                	mov    %eax,%edx
c0102d12:	ec                   	in     (%dx),%al
c0102d13:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102d16:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102d1a:	0f b6 c0             	movzbl %al,%eax
c0102d1d:	25 c0 00 00 00       	and    $0xc0,%eax
c0102d22:	83 f8 40             	cmp    $0x40,%eax
c0102d25:	75 df                	jne    c0102d06 <waitdisk+0x7>
}
c0102d27:	c9                   	leave  
c0102d28:	c3                   	ret    

c0102d29 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102d29:	55                   	push   %ebp
c0102d2a:	89 e5                	mov    %esp,%ebp
c0102d2c:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0102d2f:	e8 cb ff ff ff       	call   c0102cff <waitdisk>
c0102d34:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0102d3b:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102d3f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102d43:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102d46:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0102d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d4a:	0f b6 c0             	movzbl %al,%eax
c0102d4d:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0102d54:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102d57:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102d5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102d5e:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0102d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d62:	c1 f8 08             	sar    $0x8,%eax
c0102d65:	0f b6 c0             	movzbl %al,%eax
c0102d68:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0102d6f:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102d72:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102d76:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102d79:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0102d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d7d:	c1 f8 10             	sar    $0x10,%eax
c0102d80:	0f b6 c0             	movzbl %al,%eax
c0102d83:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0102d8a:	88 45 df             	mov    %al,-0x21(%ebp)
c0102d8d:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102d91:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102d94:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0102d95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d98:	c1 f8 18             	sar    $0x18,%eax
c0102d9b:	83 c8 e0             	or     $0xffffffe0,%eax
c0102d9e:	0f b6 c0             	movzbl %al,%eax
c0102da1:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0102da8:	88 45 d7             	mov    %al,-0x29(%ebp)
c0102dab:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0102daf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102db2:	ee                   	out    %al,(%dx)
c0102db3:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0102dba:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0102dbe:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0102dc2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102dc5:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0102dc6:	e8 34 ff ff ff       	call   c0102cff <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102dcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102dd2:	eb 29                	jmp    c0102dfd <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0102dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102dd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102dde:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0102de4:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102deb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102dee:	89 c2                	mov    %eax,%edx
c0102df0:	ed                   	in     (%dx),%eax
c0102df1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0102df4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102df7:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102df9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102dfd:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0102e01:	7e d1                	jle    c0102dd4 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0102e03:	c9                   	leave  
c0102e04:	c3                   	ret    

c0102e05 <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0102e05:	55                   	push   %ebp
c0102e06:	89 e5                	mov    %esp,%ebp
c0102e08:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e11:	01 d0                	add    %edx,%eax
c0102e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102e16:	8b 45 10             	mov    0x10(%ebp),%eax
c0102e19:	99                   	cltd   
c0102e1a:	c1 ea 17             	shr    $0x17,%edx
c0102e1d:	01 d0                	add    %edx,%eax
c0102e1f:	25 ff 01 00 00       	and    $0x1ff,%eax
c0102e24:	29 d0                	sub    %edx,%eax
c0102e26:	f7 d8                	neg    %eax
c0102e28:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102e2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0102e2e:	99                   	cltd   
c0102e2f:	c1 ea 17             	shr    $0x17,%edx
c0102e32:	01 d0                	add    %edx,%eax
c0102e34:	c1 f8 09             	sar    $0x9,%eax
c0102e37:	83 c0 01             	add    $0x1,%eax
c0102e3a:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102e3d:	eb 19                	jmp    c0102e58 <readseg+0x53>
        readsect(pa, offset);
c0102e3f:	ff 75 10             	pushl  0x10(%ebp)
c0102e42:	ff 75 08             	pushl  0x8(%ebp)
c0102e45:	e8 df fe ff ff       	call   c0102d29 <readsect>
c0102e4a:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102e4d:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0102e54:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0102e58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e5b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102e5e:	72 df                	jb     c0102e3f <readseg+0x3a>
        readsect(pa, offset);
c0102e60:	c9                   	leave  
c0102e61:	c3                   	ret    

c0102e62 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0102e62:	55                   	push   %ebp
c0102e63:	89 e5                	mov    %esp,%ebp
c0102e65:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0102e68:	8b 45 10             	mov    0x10(%ebp),%eax
c0102e6b:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0102e70:	77 16                	ja     c0102e88 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102e72:	ff 75 10             	pushl  0x10(%ebp)
c0102e75:	68 ac 4e 10 c0       	push   $0xc0104eac
c0102e7a:	ff 75 0c             	pushl  0xc(%ebp)
c0102e7d:	ff 75 08             	pushl  0x8(%ebp)
c0102e80:	e8 55 fe ff ff       	call   c0102cda <printk>
c0102e85:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0102e88:	8b 45 10             	mov    0x10(%ebp),%eax
c0102e8b:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102e90:	c9                   	leave  
c0102e91:	c3                   	ret    

c0102e92 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)
#define elf_r ((char*) ELFADDR)

uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0102e92:	55                   	push   %ebp
c0102e93:	89 e5                	mov    %esp,%ebp
c0102e95:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9b:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102ea1:	83 ec 04             	sub    $0x4,%esp
c0102ea4:	50                   	push   %eax
c0102ea5:	6a 17                	push   $0x17
c0102ea7:	68 cf 4e 10 c0       	push   $0xc0104ecf
c0102eac:	e8 b1 ff ff ff       	call   c0102e62 <_paddr>
c0102eb1:	83 c4 10             	add    $0x10,%esp
c0102eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102eba:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec0:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102ec6:	83 ec 04             	sub    $0x4,%esp
c0102ec9:	68 00 10 00 00       	push   $0x1000
c0102ece:	6a 00                	push   $0x0
c0102ed0:	50                   	push   %eax
c0102ed1:	e8 bb d7 ff ff       	call   c0100691 <mm_alloc>
c0102ed6:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102edc:	83 ec 04             	sub    $0x4,%esp
c0102edf:	50                   	push   %eax
c0102ee0:	68 00 10 00 00       	push   $0x1000
c0102ee5:	6a 00                	push   $0x0
c0102ee7:	e8 19 ff ff ff       	call   c0102e05 <readseg>
c0102eec:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102eef:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ef4:	8b 00                	mov    (%eax),%eax
c0102ef6:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102efb:	0f 94 c0             	sete   %al
c0102efe:	0f b6 c0             	movzbl %al,%eax
c0102f01:	83 ec 08             	sub    $0x8,%esp
c0102f04:	50                   	push   %eax
c0102f05:	68 e3 4e 10 c0       	push   $0xc0104ee3
c0102f0a:	e8 cb fd ff ff       	call   c0102cda <printk>
c0102f0f:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102f12:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f17:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102f1d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f22:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102f26:	0f b7 c0             	movzwl %ax,%eax
c0102f29:	c1 e0 05             	shl    $0x5,%eax
c0102f2c:	89 c2                	mov    %eax,%edx
c0102f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f31:	01 d0                	add    %edx,%eax
c0102f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102f36:	eb 7f                	jmp    c0102fb7 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0102f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f3b:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f3e:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f44:	8b 48 14             	mov    0x14(%eax),%ecx
c0102f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f4a:	8b 50 08             	mov    0x8(%eax),%edx
c0102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f50:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102f56:	83 ec 04             	sub    $0x4,%esp
c0102f59:	51                   	push   %ecx
c0102f5a:	52                   	push   %edx
c0102f5b:	50                   	push   %eax
c0102f5c:	e8 30 d7 ff ff       	call   c0100691 <mm_alloc>
c0102f61:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0102f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f67:	8b 50 04             	mov    0x4(%eax),%edx
c0102f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f6d:	01 d0                	add    %edx,%eax
c0102f6f:	89 c2                	mov    %eax,%edx
c0102f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f74:	8b 40 10             	mov    0x10(%eax),%eax
c0102f77:	83 ec 04             	sub    $0x4,%esp
c0102f7a:	52                   	push   %edx
c0102f7b:	50                   	push   %eax
c0102f7c:	ff 75 e8             	pushl  -0x18(%ebp)
c0102f7f:	e8 81 fe ff ff       	call   c0102e05 <readseg>
c0102f84:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f8a:	8b 50 10             	mov    0x10(%eax),%edx
c0102f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102f90:	01 d0                	add    %edx,%eax
c0102f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f95:	eb 0c                	jmp    c0102fa3 <loader+0x111>
c0102f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f9a:	8d 50 01             	lea    0x1(%eax),%edx
c0102f9d:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102fa0:	c6 00 00             	movb   $0x0,(%eax)
c0102fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fa6:	8b 50 14             	mov    0x14(%eax),%edx
c0102fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102fac:	01 d0                	add    %edx,%eax
c0102fae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102fb1:	77 e4                	ja     c0102f97 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102fb3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102fbd:	0f 82 75 ff ff ff    	jb     c0102f38 <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0102fc3:	b8 00 00 00 00       	mov    $0x0,%eax
c0102fc8:	8b 40 18             	mov    0x18(%eax),%eax
c0102fcb:	a3 30 4a 10 c0       	mov    %eax,0xc0104a30

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102fd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fd3:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102fd9:	83 ec 04             	sub    $0x4,%esp
c0102fdc:	68 00 80 00 00       	push   $0x8000
c0102fe1:	68 00 60 bf be       	push   $0xbebf6000
c0102fe6:	50                   	push   %eax
c0102fe7:	e8 a5 d6 ff ff       	call   c0100691 <mm_alloc>
c0102fec:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102fef:	a1 30 4a 10 c0       	mov    0xc0104a30,%eax
c0102ff4:	6a 03                	push   $0x3
c0102ff6:	50                   	push   %eax
c0102ff7:	68 80 df bf be       	push   $0xbebfdf80
c0102ffc:	ff 75 08             	pushl  0x8(%ebp)
c0102fff:	e8 fb 0e 00 00       	call   c0103eff <init_pcb>
c0103004:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0103007:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c010300c:	83 ec 04             	sub    $0x4,%esp
c010300f:	50                   	push   %eax
c0103010:	6a 39                	push   $0x39
c0103012:	68 cf 4e 10 c0       	push   $0xc0104ecf
c0103017:	e8 46 fe ff ff       	call   c0102e62 <_paddr>
c010301c:	83 c4 10             	add    $0x10,%esp
c010301f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103022:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103025:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0103028:	c9                   	leave  
c0103029:	c3                   	ret    

c010302a <loader_file>:

int loader_file(PCB* pcb, char* filename){
c010302a:	55                   	push   %ebp
c010302b:	89 e5                	mov    %esp,%ebp
c010302d:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0103030:	8b 45 08             	mov    0x8(%ebp),%eax
c0103033:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103039:	83 ec 04             	sub    $0x4,%esp
c010303c:	50                   	push   %eax
c010303d:	6a 44                	push   $0x44
c010303f:	68 cf 4e 10 c0       	push   $0xc0104ecf
c0103044:	e8 19 fe ff ff       	call   c0102e62 <_paddr>
c0103049:	83 c4 10             	add    $0x10,%esp
c010304c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010304f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103052:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0103055:	8b 45 08             	mov    0x8(%ebp),%eax
c0103058:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010305e:	83 ec 04             	sub    $0x4,%esp
c0103061:	68 00 10 00 00       	push   $0x1000
c0103066:	6a 00                	push   $0x0
c0103068:	50                   	push   %eax
c0103069:	e8 23 d6 ff ff       	call   c0100691 <mm_alloc>
c010306e:	83 c4 10             	add    $0x10,%esp
  int fd = fs_open_kr(filename);
c0103071:	83 ec 0c             	sub    $0xc,%esp
c0103074:	ff 75 0c             	pushl  0xc(%ebp)
c0103077:	e8 99 ea ff ff       	call   c0101b15 <fs_open_kr>
c010307c:	83 c4 10             	add    $0x10,%esp
c010307f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fs_read_kr(fd, elf_r, 8*SECTSIZE);
c0103082:	83 ec 04             	sub    $0x4,%esp
c0103085:	68 00 10 00 00       	push   $0x1000
c010308a:	6a 00                	push   $0x0
c010308c:	ff 75 ec             	pushl  -0x14(%ebp)
c010308f:	e8 e9 ed ff ff       	call   c0101e7d <fs_read_kr>
c0103094:	83 c4 10             	add    $0x10,%esp
  //readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("%x\n", *(uint32_t *)(elf_r+7*SECTSIZE));
  if((elf->magic != 0x464C457FU))
c0103097:	b8 00 00 00 00       	mov    $0x0,%eax
c010309c:	8b 00                	mov    (%eax),%eax
c010309e:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c01030a3:	74 0a                	je     c01030af <loader_file+0x85>
    return -1;
c01030a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01030aa:	e9 44 01 00 00       	jmp    c01031f3 <loader_file+0x1c9>
  //printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c01030af:	b8 00 00 00 00       	mov    $0x0,%eax
c01030b4:	8b 40 1c             	mov    0x1c(%eax),%eax
c01030b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c01030ba:	b8 00 00 00 00       	mov    $0x0,%eax
c01030bf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01030c3:	0f b7 c0             	movzwl %ax,%eax
c01030c6:	c1 e0 05             	shl    $0x5,%eax
c01030c9:	89 c2                	mov    %eax,%edx
c01030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030ce:	01 d0                	add    %edx,%eax
c01030d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01030d3:	e9 a5 00 00 00       	jmp    c010317d <loader_file+0x153>
    pa = (unsigned char*)ph->vaddr; 
c01030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030db:	8b 40 08             	mov    0x8(%eax),%eax
c01030de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //printk("%x %x %x\n", pcb->pgdir, ph->vaddr, ph->memsz);
    if(ph->vaddr == 0 || ph->memsz == 0)break;
c01030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030e4:	8b 40 08             	mov    0x8(%eax),%eax
c01030e7:	85 c0                	test   %eax,%eax
c01030e9:	0f 84 9a 00 00 00    	je     c0103189 <loader_file+0x15f>
c01030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030f2:	8b 40 14             	mov    0x14(%eax),%eax
c01030f5:	85 c0                	test   %eax,%eax
c01030f7:	0f 84 8c 00 00 00    	je     c0103189 <loader_file+0x15f>
    //printk("a\n");
    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c01030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103100:	8b 48 14             	mov    0x14(%eax),%ecx
c0103103:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103106:	8b 50 08             	mov    0x8(%eax),%edx
c0103109:	8b 45 08             	mov    0x8(%ebp),%eax
c010310c:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103112:	83 ec 04             	sub    $0x4,%esp
c0103115:	51                   	push   %ecx
c0103116:	52                   	push   %edx
c0103117:	50                   	push   %eax
c0103118:	e8 74 d5 ff ff       	call   c0100691 <mm_alloc>
c010311d:	83 c4 10             	add    $0x10,%esp
    //printk("b\n");
    //printk("hahaha?\n");
    fs_lseek_kr(fd, ph->off);
c0103120:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103123:	8b 40 04             	mov    0x4(%eax),%eax
c0103126:	83 ec 08             	sub    $0x8,%esp
c0103129:	50                   	push   %eax
c010312a:	ff 75 ec             	pushl  -0x14(%ebp)
c010312d:	e8 2c f1 ff ff       	call   c010225e <fs_lseek_kr>
c0103132:	83 c4 10             	add    $0x10,%esp
    fs_read_kr(fd, pa, ph->filesz);
c0103135:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103138:	8b 40 10             	mov    0x10(%eax),%eax
c010313b:	83 ec 04             	sub    $0x4,%esp
c010313e:	50                   	push   %eax
c010313f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103142:	ff 75 ec             	pushl  -0x14(%ebp)
c0103145:	e8 33 ed ff ff       	call   c0101e7d <fs_read_kr>
c010314a:	83 c4 10             	add    $0x10,%esp
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c010314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103150:	8b 50 10             	mov    0x10(%eax),%edx
c0103153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103156:	01 d0                	add    %edx,%eax
c0103158:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010315b:	eb 0c                	jmp    c0103169 <loader_file+0x13f>
c010315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103160:	8d 50 01             	lea    0x1(%eax),%edx
c0103163:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0103166:	c6 00 00             	movb   $0x0,(%eax)
c0103169:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010316c:	8b 50 14             	mov    0x14(%eax),%edx
c010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103172:	01 d0                	add    %edx,%eax
c0103174:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103177:	77 e4                	ja     c010315d <loader_file+0x133>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0103179:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103180:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103183:	0f 82 4f ff ff ff    	jb     c01030d8 <loader_file+0xae>
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  //printk("c\n");
  //while(1);
  entry = elf->entry;
c0103189:	b8 00 00 00 00       	mov    $0x0,%eax
c010318e:	8b 40 18             	mov    0x18(%eax),%eax
c0103191:	a3 30 4a 10 c0       	mov    %eax,0xc0104a30
  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  //printk("e\n");
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0103196:	8b 45 08             	mov    0x8(%ebp),%eax
c0103199:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010319f:	83 ec 04             	sub    $0x4,%esp
c01031a2:	68 00 80 00 00       	push   $0x8000
c01031a7:	68 00 60 bf be       	push   $0xbebf6000
c01031ac:	50                   	push   %eax
c01031ad:	e8 df d4 ff ff       	call   c0100691 <mm_alloc>
c01031b2:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c01031b5:	a1 30 4a 10 c0       	mov    0xc0104a30,%eax
c01031ba:	6a 03                	push   $0x3
c01031bc:	50                   	push   %eax
c01031bd:	68 80 df bf be       	push   $0xbebfdf80
c01031c2:	ff 75 08             	pushl  0x8(%ebp)
c01031c5:	e8 35 0d 00 00       	call   c0103eff <init_pcb>
c01031ca:	83 c4 10             	add    $0x10,%esp
  //printk("f\n");
  //printk("%x\n", *(uint32_t*)(0x80481fd));
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c01031cd:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c01031d2:	83 ec 04             	sub    $0x4,%esp
c01031d5:	50                   	push   %eax
c01031d6:	6a 76                	push   $0x76
c01031d8:	68 cf 4e 10 c0       	push   $0xc0104ecf
c01031dd:	e8 80 fc ff ff       	call   c0102e62 <_paddr>
c01031e2:	83 c4 10             	add    $0x10,%esp
c01031e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01031e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01031eb:	0f 22 d8             	mov    %eax,%cr3
  //printk("g\n");
  //switch_pcb(pcb);
  
  //printk("e\n");
  return 0;
c01031ee:	b8 00 00 00 00       	mov    $0x0,%eax
};
c01031f3:	c9                   	leave  
c01031f4:	c3                   	ret    

c01031f5 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c01031f5:	55                   	push   %ebp
c01031f6:	89 e5                	mov    %esp,%ebp
c01031f8:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c01031fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fe:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103204:	83 ec 04             	sub    $0x4,%esp
c0103207:	50                   	push   %eax
c0103208:	68 80 00 00 00       	push   $0x80
c010320d:	68 cf 4e 10 c0       	push   $0xc0104ecf
c0103212:	e8 4b fc ff ff       	call   c0102e62 <_paddr>
c0103217:	83 c4 10             	add    $0x10,%esp
c010321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103220:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0103223:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103226:	a3 30 4a 10 c0       	mov    %eax,0xc0104a30
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c010322b:	a1 30 4a 10 c0       	mov    0xc0104a30,%eax
c0103230:	8b 55 08             	mov    0x8(%ebp),%edx
c0103233:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0103239:	83 c2 80             	add    $0xffffff80,%edx
c010323c:	6a 00                	push   $0x0
c010323e:	50                   	push   %eax
c010323f:	52                   	push   %edx
c0103240:	ff 75 08             	pushl  0x8(%ebp)
c0103243:	e8 b7 0c 00 00       	call   c0103eff <init_pcb>
c0103248:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c010324b:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c0103250:	83 ec 04             	sub    $0x4,%esp
c0103253:	50                   	push   %eax
c0103254:	68 84 00 00 00       	push   $0x84
c0103259:	68 cf 4e 10 c0       	push   $0xc0104ecf
c010325e:	e8 ff fb ff ff       	call   c0102e62 <_paddr>
c0103263:	83 c4 10             	add    $0x10,%esp
c0103266:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103269:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010326c:	0f 22 d8             	mov    %eax,%cr3

c010326f:	c9                   	leave  
c0103270:	c3                   	ret    

c0103271 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103271:	55                   	push   %ebp
c0103272:	89 e5                	mov    %esp,%ebp
c0103274:	83 ec 10             	sub    $0x10,%esp
c0103277:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010327e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103281:	89 c2                	mov    %eax,%edx
c0103283:	ec                   	in     (%dx),%al
c0103284:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103287:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010328b:	0f b6 c0             	movzbl %al,%eax
c010328e:	83 e0 20             	and    $0x20,%eax
c0103291:	85 c0                	test   %eax,%eax
c0103293:	0f 95 c0             	setne  %al
c0103296:	0f b6 c0             	movzbl %al,%eax
}
c0103299:	c9                   	leave  
c010329a:	c3                   	ret    

c010329b <serial_printc>:

static inline
void serial_printc(char ch) {
c010329b:	55                   	push   %ebp
c010329c:	89 e5                	mov    %esp,%ebp
c010329e:	83 ec 14             	sub    $0x14,%esp
c01032a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a4:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01032a7:	90                   	nop
c01032a8:	e8 c4 ff ff ff       	call   c0103271 <serial_idle>
c01032ad:	85 c0                	test   %eax,%eax
c01032af:	74 f7                	je     c01032a8 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01032b1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01032b5:	0f b6 c0             	movzbl %al,%eax
c01032b8:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01032bf:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01032c2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01032c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032c9:	ee                   	out    %al,(%dx)
}
c01032ca:	c9                   	leave  
c01032cb:	c3                   	ret    

c01032cc <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01032cc:	55                   	push   %ebp
c01032cd:	89 e5                	mov    %esp,%ebp
c01032cf:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01032d2:	8d 45 0c             	lea    0xc(%ebp),%eax
c01032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01032d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01032db:	83 ec 04             	sub    $0x4,%esp
c01032de:	ff 75 f4             	pushl  -0xc(%ebp)
c01032e1:	50                   	push   %eax
c01032e2:	68 9b 32 10 c0       	push   $0xc010329b
c01032e7:	e8 cb 17 00 00       	call   c0104ab7 <vfprintf>
c01032ec:	83 c4 10             	add    $0x10,%esp
}
c01032ef:	c9                   	leave  
c01032f0:	c3                   	ret    

c01032f1 <cputchar>:

static inline void cputchar(char c) {
c01032f1:	55                   	push   %ebp
c01032f2:	89 e5                	mov    %esp,%ebp
c01032f4:	83 ec 04             	sub    $0x4,%esp
c01032f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01032fa:	88 45 fc             	mov    %al,-0x4(%ebp)
    serial_printc(c);
c01032fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0103301:	50                   	push   %eax
c0103302:	e8 94 ff ff ff       	call   c010329b <serial_printc>
c0103307:	83 c4 04             	add    $0x4,%esp
}
c010330a:	c9                   	leave  
c010330b:	c3                   	ret    

c010330c <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c010330c:	55                   	push   %ebp
c010330d:	89 e5                	mov    %esp,%ebp
c010330f:	83 ec 04             	sub    $0x4,%esp
c0103312:	8b 45 08             	mov    0x8(%ebp),%eax
c0103315:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0103318:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c010331c:	83 e8 61             	sub    $0x61,%eax
c010331f:	8b 04 85 40 70 15 c0 	mov    -0x3fea8fc0(,%eax,4),%eax
}
c0103326:	c9                   	leave  
c0103327:	c3                   	ret    

c0103328 <get_lastkey>:
int8_t get_lastkey(){
c0103328:	55                   	push   %ebp
c0103329:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c010332b:	a1 a8 70 15 c0       	mov    0xc01570a8,%eax
c0103330:	83 c0 61             	add    $0x61,%eax
}
c0103333:	5d                   	pop    %ebp
c0103334:	c3                   	ret    

c0103335 <press_key>:
void press_key(int code){
c0103335:	55                   	push   %ebp
c0103336:	89 e5                	mov    %esp,%ebp
c0103338:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c010333b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	
	if((code & 0x80) == 0){
c0103342:	8b 45 08             	mov    0x8(%ebp),%eax
c0103345:	25 80 00 00 00       	and    $0x80,%eax
c010334a:	85 c0                	test   %eax,%eax
c010334c:	75 45                	jne    c0103393 <press_key+0x5e>
		if(code == 0x1d){
c010334e:	83 7d 08 1d          	cmpl   $0x1d,0x8(%ebp)
c0103352:	75 0a                	jne    c010335e <press_key+0x29>
			ctrl = 1;
c0103354:	c7 05 ac 70 15 c0 01 	movl   $0x1,0xc01570ac
c010335b:	00 00 00 
		}
		for(;i<26;i++){
c010335e:	eb 2b                	jmp    c010338b <press_key+0x56>
			if(letter[i]==code){
c0103360:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103363:	8b 04 85 40 90 10 c0 	mov    -0x3fef6fc0(,%eax,4),%eax
c010336a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010336d:	75 18                	jne    c0103387 <press_key+0x52>
				keydown[i] = 1;
c010336f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103372:	c7 04 85 40 70 15 c0 	movl   $0x1,-0x3fea8fc0(,%eax,4)
c0103379:	01 00 00 00 
				lastkey = i;
c010337d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103380:	a3 a8 70 15 c0       	mov    %eax,0xc01570a8
				return;
c0103385:	eb 4b                	jmp    c01033d2 <press_key+0x9d>
	
	if((code & 0x80) == 0){
		if(code == 0x1d){
			ctrl = 1;
		}
		for(;i<26;i++){
c0103387:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010338b:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c010338f:	7e cf                	jle    c0103360 <press_key+0x2b>
c0103391:	eb 3f                	jmp    c01033d2 <press_key+0x9d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0103393:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		if(code == 0x1d){
c0103397:	83 7d 08 1d          	cmpl   $0x1d,0x8(%ebp)
c010339b:	75 0a                	jne    c01033a7 <press_key+0x72>
			ctrl = 0;
c010339d:	c7 05 ac 70 15 c0 00 	movl   $0x0,0xc01570ac
c01033a4:	00 00 00 
		}
		for(;i<26;i++){
c01033a7:	eb 23                	jmp    c01033cc <press_key+0x97>
			if(letter[i]==code){
c01033a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033ac:	8b 04 85 40 90 10 c0 	mov    -0x3fef6fc0(,%eax,4),%eax
c01033b3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033b6:	75 10                	jne    c01033c8 <press_key+0x93>
				keydown[i] = 0;
c01033b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033bb:	c7 04 85 40 70 15 c0 	movl   $0x0,-0x3fea8fc0(,%eax,4)
c01033c2:	00 00 00 00 
				return;
c01033c6:	eb 0a                	jmp    c01033d2 <press_key+0x9d>
	}else{
		code &= 0x7F;
		if(code == 0x1d){
			ctrl = 0;
		}
		for(;i<26;i++){
c01033c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01033cc:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01033d0:	7e d7                	jle    c01033a9 <press_key+0x74>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c01033d2:	c9                   	leave  
c01033d3:	c3                   	ret    

c01033d4 <ctrl_c>:

int ctrl_c(){
c01033d4:	55                   	push   %ebp
c01033d5:	89 e5                	mov    %esp,%ebp
c01033d7:	83 ec 10             	sub    $0x10,%esp
	int ctrlc = ctrl && keydown['c'-'a'];
c01033da:	a1 ac 70 15 c0       	mov    0xc01570ac,%eax
c01033df:	85 c0                	test   %eax,%eax
c01033e1:	74 10                	je     c01033f3 <ctrl_c+0x1f>
c01033e3:	a1 48 70 15 c0       	mov    0xc0157048,%eax
c01033e8:	85 c0                	test   %eax,%eax
c01033ea:	74 07                	je     c01033f3 <ctrl_c+0x1f>
c01033ec:	b8 01 00 00 00       	mov    $0x1,%eax
c01033f1:	eb 05                	jmp    c01033f8 <ctrl_c+0x24>
c01033f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01033f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(ctrlc){
c01033fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01033ff:	74 14                	je     c0103415 <ctrl_c+0x41>
		ctrl = 0;
c0103401:	c7 05 ac 70 15 c0 00 	movl   $0x0,0xc01570ac
c0103408:	00 00 00 
		keydown['c'-'a'] = 0;
c010340b:	c7 05 48 70 15 c0 00 	movl   $0x0,0xc0157048
c0103412:	00 00 00 
	}
	return ctrlc;
c0103415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103418:	c9                   	leave  
c0103419:	c3                   	ret    

c010341a <wait_key>:
	shiftmap,
	ctlmap,
	ctlmap
};

void wait_key(){
c010341a:	55                   	push   %ebp
c010341b:	89 e5                	mov    %esp,%ebp
c010341d:	83 ec 10             	sub    $0x10,%esp
	while(!(inb(0x64)&0x01));
c0103420:	90                   	nop
c0103421:	c7 45 fc 64 00 00 00 	movl   $0x64,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103428:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010342b:	89 c2                	mov    %eax,%edx
c010342d:	ec                   	in     (%dx),%al
c010342e:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103431:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103435:	0f b6 c0             	movzbl %al,%eax
c0103438:	83 e0 01             	and    $0x1,%eax
c010343b:	85 c0                	test   %eax,%eax
c010343d:	74 e2                	je     c0103421 <wait_key+0x7>
}
c010343f:	c9                   	leave  
c0103440:	c3                   	ret    

c0103441 <poll_key>:
int poll_key(){
c0103441:	55                   	push   %ebp
c0103442:	89 e5                	mov    %esp,%ebp
c0103444:	83 ec 20             	sub    $0x20,%esp
c0103447:	c7 45 f4 60 00 00 00 	movl   $0x60,-0xc(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103451:	89 c2                	mov    %eax,%edx
c0103453:	ec                   	in     (%dx),%al
c0103454:	88 45 f3             	mov    %al,-0xd(%ebp)
	return data;
c0103457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
	int c;
	uint8_t data;
	static uint32_t shift;

	data = inb(0x60);
c010345b:	88 45 fb             	mov    %al,-0x5(%ebp)

	while(data == 0x08)
c010345e:	eb 17                	jmp    c0103477 <poll_key+0x36>
c0103460:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103467:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010346a:	89 c2                	mov    %eax,%edx
c010346c:	ec                   	in     (%dx),%al
c010346d:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0103470:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		data = inb(0x60); 
c0103474:	88 45 fb             	mov    %al,-0x5(%ebp)
	uint8_t data;
	static uint32_t shift;

	data = inb(0x60);

	while(data == 0x08)
c0103477:	80 7d fb 08          	cmpb   $0x8,-0x5(%ebp)
c010347b:	74 e3                	je     c0103460 <poll_key+0x1f>
		data = inb(0x60); 

	if (data == 0xE0) {
c010347d:	80 7d fb e0          	cmpb   $0xe0,-0x5(%ebp)
c0103481:	75 17                	jne    c010349a <poll_key+0x59>
		// E0 escape character
		shift |= E0ESC;
c0103483:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103488:	83 c8 40             	or     $0x40,%eax
c010348b:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
		return 0;
c0103490:	b8 00 00 00 00       	mov    $0x0,%eax
c0103495:	e9 ef 00 00 00       	jmp    c0103589 <poll_key+0x148>
	} else if (data & 0x80) {
c010349a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010349e:	84 c0                	test   %al,%al
c01034a0:	79 47                	jns    c01034e9 <poll_key+0xa8>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
c01034a2:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01034a7:	83 e0 40             	and    $0x40,%eax
c01034aa:	85 c0                	test   %eax,%eax
c01034ac:	75 09                	jne    c01034b7 <poll_key+0x76>
c01034ae:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01034b2:	83 e0 7f             	and    $0x7f,%eax
c01034b5:	eb 04                	jmp    c01034bb <poll_key+0x7a>
c01034b7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01034bb:	88 45 fb             	mov    %al,-0x5(%ebp)
		shift &= ~(shiftcode[data] | E0ESC);
c01034be:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01034c2:	0f b6 80 c0 90 10 c0 	movzbl -0x3fef6f40(%eax),%eax
c01034c9:	83 c8 40             	or     $0x40,%eax
c01034cc:	0f b6 c0             	movzbl %al,%eax
c01034cf:	f7 d0                	not    %eax
c01034d1:	89 c2                	mov    %eax,%edx
c01034d3:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01034d8:	21 d0                	and    %edx,%eax
c01034da:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
		return 0;
c01034df:	b8 00 00 00 00       	mov    $0x0,%eax
c01034e4:	e9 a0 00 00 00       	jmp    c0103589 <poll_key+0x148>
	} else if (shift & E0ESC) {
c01034e9:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01034ee:	83 e0 40             	and    $0x40,%eax
c01034f1:	85 c0                	test   %eax,%eax
c01034f3:	74 11                	je     c0103506 <poll_key+0xc5>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
c01034f5:	80 4d fb 80          	orb    $0x80,-0x5(%ebp)
		shift &= ~E0ESC;
c01034f9:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01034fe:	83 e0 bf             	and    $0xffffffbf,%eax
c0103501:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
	}

	shift |= shiftcode[data];
c0103506:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010350a:	0f b6 80 c0 90 10 c0 	movzbl -0x3fef6f40(%eax),%eax
c0103511:	0f b6 d0             	movzbl %al,%edx
c0103514:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103519:	09 d0                	or     %edx,%eax
c010351b:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
	shift ^= togglecode[data];
c0103520:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103524:	0f b6 80 c0 91 10 c0 	movzbl -0x3fef6e40(%eax),%eax
c010352b:	0f b6 d0             	movzbl %al,%edx
c010352e:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103533:	31 d0                	xor    %edx,%eax
c0103535:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0

	c = charcode[shift & (CTL | SHIFT)][data];
c010353a:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c010353f:	83 e0 03             	and    $0x3,%eax
c0103542:	8b 14 85 c0 95 10 c0 	mov    -0x3fef6a40(,%eax,4),%edx
c0103549:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010354d:	01 d0                	add    %edx,%eax
c010354f:	0f b6 00             	movzbl (%eax),%eax
c0103552:	0f b6 c0             	movzbl %al,%eax
c0103555:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (shift & CAPSLOCK) {
c0103558:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c010355d:	83 e0 08             	and    $0x8,%eax
c0103560:	85 c0                	test   %eax,%eax
c0103562:	74 22                	je     c0103586 <poll_key+0x145>
		if ('a' <= c && c <= 'z')
c0103564:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
c0103568:	7e 0c                	jle    c0103576 <poll_key+0x135>
c010356a:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
c010356e:	7f 06                	jg     c0103576 <poll_key+0x135>
			c += 'A' - 'a';
c0103570:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)
c0103574:	eb 10                	jmp    c0103586 <poll_key+0x145>
		else if ('A' <= c && c <= 'Z')
c0103576:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
c010357a:	7e 0a                	jle    c0103586 <poll_key+0x145>
c010357c:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
c0103580:	7f 04                	jg     c0103586 <poll_key+0x145>
			c += 'a' - 'A';
c0103582:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
	}
	return c;
c0103586:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103589:	c9                   	leave  
c010358a:	c3                   	ret    

c010358b <getchar>:

int getchar(void)
{
c010358b:	55                   	push   %ebp
c010358c:	89 e5                	mov    %esp,%ebp
c010358e:	83 ec 10             	sub    $0x10,%esp
	int c;

	wait_key();
c0103591:	e8 84 fe ff ff       	call   c010341a <wait_key>
	c = poll_key();
c0103596:	e8 a6 fe ff ff       	call   c0103441 <poll_key>
c010359b:	89 45 fc             	mov    %eax,-0x4(%ebp)

	return c;
c010359e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01035a1:	c9                   	leave  
c01035a2:	c3                   	ret    

c01035a3 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
c01035a3:	55                   	push   %ebp
c01035a4:	89 e5                	mov    %esp,%ebp
c01035a6:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
c01035a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01035ad:	74 13                	je     c01035c2 <readline+0x1f>
		printk("%s", prompt);
c01035af:	83 ec 08             	sub    $0x8,%esp
c01035b2:	ff 75 08             	pushl  0x8(%ebp)
c01035b5:	68 f8 4e 10 c0       	push   $0xc0104ef8
c01035ba:	e8 0d fd ff ff       	call   c01032cc <printk>
c01035bf:	83 c4 10             	add    $0x10,%esp

	i = 0;
c01035c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = 1;
c01035c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	while (1) {
		c = getchar();
c01035d0:	e8 b6 ff ff ff       	call   c010358b <getchar>
c01035d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
c01035d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01035dc:	79 1d                	jns    c01035fb <readline+0x58>
			printk("read error: %e\n", c);
c01035de:	83 ec 08             	sub    $0x8,%esp
c01035e1:	ff 75 ec             	pushl  -0x14(%ebp)
c01035e4:	68 fb 4e 10 c0       	push   $0xc0104efb
c01035e9:	e8 de fc ff ff       	call   c01032cc <printk>
c01035ee:	83 c4 10             	add    $0x10,%esp
			return NULL;
c01035f1:	b8 00 00 00 00       	mov    $0x0,%eax
c01035f6:	e9 9c 00 00 00       	jmp    c0103697 <readline+0xf4>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
c01035fb:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
c01035ff:	74 06                	je     c0103607 <readline+0x64>
c0103601:	83 7d ec 7f          	cmpl   $0x7f,-0x14(%ebp)
c0103605:	75 1f                	jne    c0103626 <readline+0x83>
c0103607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010360b:	7e 19                	jle    c0103626 <readline+0x83>
			if (echoing)
c010360d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103611:	74 0d                	je     c0103620 <readline+0x7d>
				cputchar('\b');
c0103613:	83 ec 0c             	sub    $0xc,%esp
c0103616:	6a 08                	push   $0x8
c0103618:	e8 d4 fc ff ff       	call   c01032f1 <cputchar>
c010361d:	83 c4 10             	add    $0x10,%esp
			i--;
c0103620:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103624:	eb 6c                	jmp    c0103692 <readline+0xef>
		} else if (c >= ' ' && i < BUFLEN-1) {
c0103626:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
c010362a:	7e 35                	jle    c0103661 <readline+0xbe>
c010362c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0103633:	7f 2c                	jg     c0103661 <readline+0xbe>
			if (echoing)
c0103635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103639:	74 12                	je     c010364d <readline+0xaa>
				cputchar(c);
c010363b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010363e:	0f be c0             	movsbl %al,%eax
c0103641:	83 ec 0c             	sub    $0xc,%esp
c0103644:	50                   	push   %eax
c0103645:	e8 a7 fc ff ff       	call   c01032f1 <cputchar>
c010364a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
c010364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103650:	8d 50 01             	lea    0x1(%eax),%edx
c0103653:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0103656:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103659:	88 90 c0 70 15 c0    	mov    %dl,-0x3fea8f40(%eax)
c010365f:	eb 31                	jmp    c0103692 <readline+0xef>
		} else if (c == '\n' || c == '\r') {
c0103661:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
c0103665:	74 06                	je     c010366d <readline+0xca>
c0103667:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
c010366b:	75 25                	jne    c0103692 <readline+0xef>
			if (echoing)
c010366d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103671:	74 0d                	je     c0103680 <readline+0xdd>
				cputchar('\n');
c0103673:	83 ec 0c             	sub    $0xc,%esp
c0103676:	6a 0a                	push   $0xa
c0103678:	e8 74 fc ff ff       	call   c01032f1 <cputchar>
c010367d:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
c0103680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103683:	05 c0 70 15 c0       	add    $0xc01570c0,%eax
c0103688:	c6 00 00             	movb   $0x0,(%eax)
			return buf;
c010368b:	b8 c0 70 15 c0       	mov    $0xc01570c0,%eax
c0103690:	eb 05                	jmp    c0103697 <readline+0xf4>
		}
	}
c0103692:	e9 39 ff ff ff       	jmp    c01035d0 <readline+0x2d>
}
c0103697:	c9                   	leave  
c0103698:	c3                   	ret    

c0103699 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103699:	55                   	push   %ebp
c010369a:	89 e5                	mov    %esp,%ebp
c010369c:	83 ec 10             	sub    $0x10,%esp
c010369f:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01036a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036a9:	89 c2                	mov    %eax,%edx
c01036ab:	ec                   	in     (%dx),%al
c01036ac:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01036af:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01036b3:	0f b6 c0             	movzbl %al,%eax
c01036b6:	83 e0 20             	and    $0x20,%eax
c01036b9:	85 c0                	test   %eax,%eax
c01036bb:	0f 95 c0             	setne  %al
c01036be:	0f b6 c0             	movzbl %al,%eax
}
c01036c1:	c9                   	leave  
c01036c2:	c3                   	ret    

c01036c3 <serial_printc>:

static inline
void serial_printc(char ch) {
c01036c3:	55                   	push   %ebp
c01036c4:	89 e5                	mov    %esp,%ebp
c01036c6:	83 ec 14             	sub    $0x14,%esp
c01036c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036cc:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01036cf:	90                   	nop
c01036d0:	e8 c4 ff ff ff       	call   c0103699 <serial_idle>
c01036d5:	85 c0                	test   %eax,%eax
c01036d7:	74 f7                	je     c01036d0 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01036d9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01036dd:	0f b6 c0             	movzbl %al,%eax
c01036e0:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01036e7:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01036ea:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01036ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01036f1:	ee                   	out    %al,(%dx)
}
c01036f2:	c9                   	leave  
c01036f3:	c3                   	ret    

c01036f4 <strcpy>:
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
c01036f4:	55                   	push   %ebp
c01036f5:	89 e5                	mov    %esp,%ebp
c01036f7:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c01036fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c0103701:	eb 04                	jmp    c0103707 <strcpy+0x13>
    {
        i++;
c0103703:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c0103707:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010370a:	8b 45 08             	mov    0x8(%ebp),%eax
c010370d:	01 d0                	add    %edx,%eax
c010370f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0103712:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103715:	01 ca                	add    %ecx,%edx
c0103717:	0f b6 12             	movzbl (%edx),%edx
c010371a:	88 10                	mov    %dl,(%eax)
c010371c:	0f b6 00             	movzbl (%eax),%eax
c010371f:	84 c0                	test   %al,%al
c0103721:	75 e0                	jne    c0103703 <strcpy+0xf>
    {
        i++;
    } 
}
c0103723:	c9                   	leave  
c0103724:	c3                   	ret    

c0103725 <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0103725:	55                   	push   %ebp
c0103726:	89 e5                	mov    %esp,%ebp
c0103728:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	char* str; 
	switch(tf->eax) {
c010372b:	8b 45 08             	mov    0x8(%ebp),%eax
c010372e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103731:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0103736:	0f 84 85 03 00 00    	je     c0103ac1 <do_syscall+0x39c>
c010373c:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0103741:	0f 87 c3 00 00 00    	ja     c010380a <do_syscall+0xe5>
c0103747:	3d 15 05 00 00       	cmp    $0x515,%eax
c010374c:	0f 84 a2 04 00 00    	je     c0103bf4 <do_syscall+0x4cf>
c0103752:	3d 15 05 00 00       	cmp    $0x515,%eax
c0103757:	77 53                	ja     c01037ac <do_syscall+0x87>
c0103759:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c010375e:	0f 84 36 04 00 00    	je     c0103b9a <do_syscall+0x475>
c0103764:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0103769:	77 1b                	ja     c0103786 <do_syscall+0x61>
c010376b:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0103770:	0f 84 06 04 00 00    	je     c0103b7c <do_syscall+0x457>
c0103776:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c010377b:	0f 84 12 04 00 00    	je     c0103b93 <do_syscall+0x46e>
c0103781:	e9 7c 04 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c0103786:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c010378b:	0f 84 1c 04 00 00    	je     c0103bad <do_syscall+0x488>
c0103791:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0103796:	0f 82 05 04 00 00    	jb     c0103ba1 <do_syscall+0x47c>
c010379c:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01037a1:	0f 84 2d 04 00 00    	je     c0103bd4 <do_syscall+0x4af>
c01037a7:	e9 56 04 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c01037ac:	3d df 05 00 00       	cmp    $0x5df,%eax
c01037b1:	0f 84 b1 03 00 00    	je     c0103b68 <do_syscall+0x443>
c01037b7:	3d df 05 00 00       	cmp    $0x5df,%eax
c01037bc:	77 26                	ja     c01037e4 <do_syscall+0xbf>
c01037be:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c01037c3:	0f 84 34 03 00 00    	je     c0103afd <do_syscall+0x3d8>
c01037c9:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c01037ce:	0f 87 55 03 00 00    	ja     c0103b29 <do_syscall+0x404>
c01037d4:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01037d9:	0f 84 75 03 00 00    	je     c0103b54 <do_syscall+0x42f>
c01037df:	e9 1e 04 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c01037e4:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c01037e9:	0f 84 24 03 00 00    	je     c0103b13 <do_syscall+0x3ee>
c01037ef:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c01037f4:	0f 82 78 03 00 00    	jb     c0103b72 <do_syscall+0x44d>
c01037fa:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c01037ff:	0f 84 e1 02 00 00    	je     c0103ae6 <do_syscall+0x3c1>
c0103805:	e9 f8 03 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c010380a:	3d a4 06 00 00       	cmp    $0x6a4,%eax
c010380f:	0f 84 07 01 00 00    	je     c010391c <do_syscall+0x1f7>
c0103815:	3d a4 06 00 00       	cmp    $0x6a4,%eax
c010381a:	77 5e                	ja     c010387a <do_syscall+0x155>
c010381c:	3d 43 06 00 00       	cmp    $0x643,%eax
c0103821:	0f 84 2e 02 00 00    	je     c0103a55 <do_syscall+0x330>
c0103827:	3d 43 06 00 00       	cmp    $0x643,%eax
c010382c:	77 26                	ja     c0103854 <do_syscall+0x12f>
c010382e:	3d 41 06 00 00       	cmp    $0x641,%eax
c0103833:	0f 84 dd 01 00 00    	je     c0103a16 <do_syscall+0x2f1>
c0103839:	3d 41 06 00 00       	cmp    $0x641,%eax
c010383e:	0f 87 fa 01 00 00    	ja     c0103a3e <do_syscall+0x319>
c0103844:	3d 40 06 00 00       	cmp    $0x640,%eax
c0103849:	0f 84 a7 01 00 00    	je     c01039f6 <do_syscall+0x2d1>
c010384f:	e9 ae 03 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c0103854:	3d 45 06 00 00       	cmp    $0x645,%eax
c0103859:	0f 84 43 02 00 00    	je     c0103aa2 <do_syscall+0x37d>
c010385f:	3d 45 06 00 00       	cmp    $0x645,%eax
c0103864:	0f 82 21 02 00 00    	jb     c0103a8b <do_syscall+0x366>
c010386a:	3d 46 06 00 00       	cmp    $0x646,%eax
c010386f:	0f 84 f7 01 00 00    	je     c0103a6c <do_syscall+0x347>
c0103875:	e9 88 03 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
c010387a:	3d a8 06 00 00       	cmp    $0x6a8,%eax
c010387f:	0f 84 52 01 00 00    	je     c01039d7 <do_syscall+0x2b2>
c0103885:	3d a8 06 00 00       	cmp    $0x6a8,%eax
c010388a:	77 1b                	ja     c01038a7 <do_syscall+0x182>
c010388c:	3d a6 06 00 00       	cmp    $0x6a6,%eax
c0103891:	0f 84 de 00 00 00    	je     c0103975 <do_syscall+0x250>
c0103897:	3d a6 06 00 00       	cmp    $0x6a6,%eax
c010389c:	0f 87 04 01 00 00    	ja     c01039a6 <do_syscall+0x281>
c01038a2:	e9 9d 00 00 00       	jmp    c0103944 <do_syscall+0x21f>
c01038a7:	3d 08 07 00 00       	cmp    $0x708,%eax
c01038ac:	74 2a                	je     c01038d8 <do_syscall+0x1b3>
c01038ae:	3d 6c 07 00 00       	cmp    $0x76c,%eax
c01038b3:	74 0c                	je     c01038c1 <do_syscall+0x19c>
c01038b5:	3d a9 06 00 00       	cmp    $0x6a9,%eax
c01038ba:	74 49                	je     c0103905 <do_syscall+0x1e0>
c01038bc:	e9 41 03 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_EXEC:
			exec_current((char*)tf->ebx);
c01038c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c4:	8b 40 10             	mov    0x10(%eax),%eax
c01038c7:	83 ec 0c             	sub    $0xc,%esp
c01038ca:	50                   	push   %eax
c01038cb:	e8 69 0d 00 00       	call   c0104639 <exec_current>
c01038d0:	83 c4 10             	add    $0x10,%esp
		break;
c01038d3:	e9 2a 03 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_READLINE:
			str = readline("$> ");
c01038d8:	83 ec 0c             	sub    $0xc,%esp
c01038db:	68 0b 4f 10 c0       	push   $0xc0104f0b
c01038e0:	e8 be fc ff ff       	call   c01035a3 <readline>
c01038e5:	83 c4 10             	add    $0x10,%esp
c01038e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
			strcpy((char*)tf->ebx, str);
c01038eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ee:	8b 40 10             	mov    0x10(%eax),%eax
c01038f1:	83 ec 08             	sub    $0x8,%esp
c01038f4:	ff 75 f4             	pushl  -0xc(%ebp)
c01038f7:	50                   	push   %eax
c01038f8:	e8 f7 fd ff ff       	call   c01036f4 <strcpy>
c01038fd:	83 c4 10             	add    $0x10,%esp
		break;
c0103900:	e9 fd 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_LS:
			fs_ls_kr(tf->ebx);
c0103905:	8b 45 08             	mov    0x8(%ebp),%eax
c0103908:	8b 40 10             	mov    0x10(%eax),%eax
c010390b:	83 ec 0c             	sub    $0xc,%esp
c010390e:	50                   	push   %eax
c010390f:	e8 4b ee ff ff       	call   c010275f <fs_ls_kr>
c0103914:	83 c4 10             	add    $0x10,%esp
		break;
c0103917:	e9 e6 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_OPEN:
			tf->eax = fs_open_port((char*)tf->ebx, tf->ecx);
c010391c:	8b 45 08             	mov    0x8(%ebp),%eax
c010391f:	8b 40 18             	mov    0x18(%eax),%eax
c0103922:	89 c2                	mov    %eax,%edx
c0103924:	8b 45 08             	mov    0x8(%ebp),%eax
c0103927:	8b 40 10             	mov    0x10(%eax),%eax
c010392a:	83 ec 08             	sub    $0x8,%esp
c010392d:	52                   	push   %edx
c010392e:	50                   	push   %eax
c010392f:	e8 d9 ec ff ff       	call   c010260d <fs_open_port>
c0103934:	83 c4 10             	add    $0x10,%esp
c0103937:	89 c2                	mov    %eax,%edx
c0103939:	8b 45 08             	mov    0x8(%ebp),%eax
c010393c:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010393f:	e9 be 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_READ:
			tf->eax = fs_read_port(tf->ebx, (void*)tf->ecx, tf->edx);
c0103944:	8b 45 08             	mov    0x8(%ebp),%eax
c0103947:	8b 40 14             	mov    0x14(%eax),%eax
c010394a:	89 c1                	mov    %eax,%ecx
c010394c:	8b 45 08             	mov    0x8(%ebp),%eax
c010394f:	8b 40 18             	mov    0x18(%eax),%eax
c0103952:	89 c2                	mov    %eax,%edx
c0103954:	8b 45 08             	mov    0x8(%ebp),%eax
c0103957:	8b 40 10             	mov    0x10(%eax),%eax
c010395a:	83 ec 04             	sub    $0x4,%esp
c010395d:	51                   	push   %ecx
c010395e:	52                   	push   %edx
c010395f:	50                   	push   %eax
c0103960:	e8 1a ed ff ff       	call   c010267f <fs_read_port>
c0103965:	83 c4 10             	add    $0x10,%esp
c0103968:	89 c2                	mov    %eax,%edx
c010396a:	8b 45 08             	mov    0x8(%ebp),%eax
c010396d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103970:	e9 8d 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_WRITE:
			tf->eax = fs_write_port(tf->ebx, (void*)tf->ecx, tf->edx);
c0103975:	8b 45 08             	mov    0x8(%ebp),%eax
c0103978:	8b 40 14             	mov    0x14(%eax),%eax
c010397b:	89 c1                	mov    %eax,%ecx
c010397d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103980:	8b 40 18             	mov    0x18(%eax),%eax
c0103983:	89 c2                	mov    %eax,%edx
c0103985:	8b 45 08             	mov    0x8(%ebp),%eax
c0103988:	8b 40 10             	mov    0x10(%eax),%eax
c010398b:	83 ec 04             	sub    $0x4,%esp
c010398e:	51                   	push   %ecx
c010398f:	52                   	push   %edx
c0103990:	50                   	push   %eax
c0103991:	e8 1b ed ff ff       	call   c01026b1 <fs_write_port>
c0103996:	83 c4 10             	add    $0x10,%esp
c0103999:	89 c2                	mov    %eax,%edx
c010399b:	8b 45 08             	mov    0x8(%ebp),%eax
c010399e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01039a1:	e9 5c 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_LSEEK:
			tf->eax = fs_lseek_port(tf->ebx, tf->ecx, tf->edx);
c01039a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a9:	8b 40 14             	mov    0x14(%eax),%eax
c01039ac:	89 c1                	mov    %eax,%ecx
c01039ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b1:	8b 40 18             	mov    0x18(%eax),%eax
c01039b4:	89 c2                	mov    %eax,%edx
c01039b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b9:	8b 40 10             	mov    0x10(%eax),%eax
c01039bc:	83 ec 04             	sub    $0x4,%esp
c01039bf:	51                   	push   %ecx
c01039c0:	52                   	push   %edx
c01039c1:	50                   	push   %eax
c01039c2:	e8 1c ed ff ff       	call   c01026e3 <fs_lseek_port>
c01039c7:	83 c4 10             	add    $0x10,%esp
c01039ca:	89 c2                	mov    %eax,%edx
c01039cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cf:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01039d2:	e9 2b 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FS_CLOSE:
			tf->eax = fs_close_port(tf->ebx);
c01039d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039da:	8b 40 10             	mov    0x10(%eax),%eax
c01039dd:	83 ec 0c             	sub    $0xc,%esp
c01039e0:	50                   	push   %eax
c01039e1:	e8 2f ed ff ff       	call   c0102715 <fs_close_port>
c01039e6:	83 c4 10             	add    $0x10,%esp
c01039e9:	89 c2                	mov    %eax,%edx
c01039eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ee:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01039f1:	e9 0c 02 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c01039f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f9:	8b 40 18             	mov    0x18(%eax),%eax
c01039fc:	89 c2                	mov    %eax,%edx
c01039fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a01:	8b 40 10             	mov    0x10(%eax),%eax
c0103a04:	83 ec 08             	sub    $0x8,%esp
c0103a07:	52                   	push   %edx
c0103a08:	50                   	push   %eax
c0103a09:	e8 03 d5 ff ff       	call   c0100f11 <sem_init_kr>
c0103a0e:	83 c4 10             	add    $0x10,%esp
		break;
c0103a11:	e9 ec 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0103a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a19:	8b 40 18             	mov    0x18(%eax),%eax
c0103a1c:	89 c2                	mov    %eax,%edx
c0103a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a21:	8b 40 10             	mov    0x10(%eax),%eax
c0103a24:	83 ec 08             	sub    $0x8,%esp
c0103a27:	52                   	push   %edx
c0103a28:	50                   	push   %eax
c0103a29:	e8 50 d6 ff ff       	call   c010107e <sem_open_kr>
c0103a2e:	83 c4 10             	add    $0x10,%esp
c0103a31:	89 c2                	mov    %eax,%edx
c0103a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a36:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103a39:	e9 c4 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0103a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a41:	8b 40 10             	mov    0x10(%eax),%eax
c0103a44:	83 ec 0c             	sub    $0xc,%esp
c0103a47:	50                   	push   %eax
c0103a48:	e8 30 d5 ff ff       	call   c0100f7d <sem_post_kr>
c0103a4d:	83 c4 10             	add    $0x10,%esp
		break;
c0103a50:	e9 ad 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c0103a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a58:	8b 40 10             	mov    0x10(%eax),%eax
c0103a5b:	83 ec 0c             	sub    $0xc,%esp
c0103a5e:	50                   	push   %eax
c0103a5f:	e8 6d d5 ff ff       	call   c0100fd1 <sem_wait_kr>
c0103a64:	83 c4 10             	add    $0x10,%esp
		break;
c0103a67:	e9 96 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c0103a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6f:	8b 40 10             	mov    0x10(%eax),%eax
c0103a72:	83 ec 0c             	sub    $0xc,%esp
c0103a75:	50                   	push   %eax
c0103a76:	e8 ae d5 ff ff       	call   c0101029 <sem_trywait_kr>
c0103a7b:	83 c4 10             	add    $0x10,%esp
c0103a7e:	89 c2                	mov    %eax,%edx
c0103a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a83:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103a86:	e9 77 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0103a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8e:	8b 40 10             	mov    0x10(%eax),%eax
c0103a91:	83 ec 0c             	sub    $0xc,%esp
c0103a94:	50                   	push   %eax
c0103a95:	e8 97 d4 ff ff       	call   c0100f31 <sem_close_kr>
c0103a9a:	83 c4 10             	add    $0x10,%esp
		break;
c0103a9d:	e9 60 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0103aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa5:	8b 40 10             	mov    0x10(%eax),%eax
c0103aa8:	83 ec 0c             	sub    $0xc,%esp
c0103aab:	50                   	push   %eax
c0103aac:	e8 b2 d5 ff ff       	call   c0101063 <sem_get_kr>
c0103ab1:	83 c4 10             	add    $0x10,%esp
c0103ab4:	89 c2                	mov    %eax,%edx
c0103ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab9:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103abc:	e9 41 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c0103ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac4:	8b 48 14             	mov    0x14(%eax),%ecx
c0103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aca:	8b 50 18             	mov    0x18(%eax),%edx
c0103acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad0:	8b 40 10             	mov    0x10(%eax),%eax
c0103ad3:	83 ec 04             	sub    $0x4,%esp
c0103ad6:	51                   	push   %ecx
c0103ad7:	52                   	push   %edx
c0103ad8:	50                   	push   %eax
c0103ad9:	e8 d3 08 00 00       	call   c01043b1 <thread_current>
c0103ade:	83 c4 10             	add    $0x10,%esp
		break;
c0103ae1:	e9 1c 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_JOIN:
			join_current(tf->ebx);
c0103ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae9:	8b 40 10             	mov    0x10(%eax),%eax
c0103aec:	83 ec 0c             	sub    $0xc,%esp
c0103aef:	50                   	push   %eax
c0103af0:	e8 9a 0a 00 00       	call   c010458f <join_current>
c0103af5:	83 c4 10             	add    $0x10,%esp
		break;
c0103af8:	e9 05 01 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_PID:
			tf->eax = current->pid;
c0103afd:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103b02:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b0b:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103b0e:	e9 ef 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_PPID:
			tf->eax = current->ppid;
c0103b13:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103b18:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c0103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b21:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103b24:	e9 d9 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0103b29:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103b2e:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c0103b35:	00 00 00 
			current->timeslice = tf->ebx*200;
c0103b38:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103b3d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b40:	8b 52 10             	mov    0x10(%edx),%edx
c0103b43:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0103b49:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c0103b4f:	e9 ae 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_HANDOUT:
			current->ts = STOP;
c0103b54:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103b59:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c0103b60:	00 00 00 
		break;
c0103b63:	e9 9a 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_EXIT:
			exit_current();
c0103b68:	e8 b5 09 00 00       	call   c0104522 <exit_current>
		break;
c0103b6d:	e9 90 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FORK:
			fork_current();
c0103b72:	e8 c8 07 00 00       	call   c010433f <fork_current>
		break;
c0103b77:	e9 86 00 00 00       	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0103b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7f:	8b 40 10             	mov    0x10(%eax),%eax
c0103b82:	0f be c0             	movsbl %al,%eax
c0103b85:	83 ec 0c             	sub    $0xc,%esp
c0103b88:	50                   	push   %eax
c0103b89:	e8 35 fb ff ff       	call   c01036c3 <serial_printc>
c0103b8e:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0103b91:	eb 6f                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_INIT_CACHE:
			initVCache();
c0103b93:	e8 1a 0b 00 00       	call   c01046b2 <initVCache>
		break;
c0103b98:	eb 68                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0103b9a:	e8 48 0c 00 00       	call   c01047e7 <clearVRAM>
		break;
c0103b9f:	eb 61                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0103ba1:	e8 41 0c 00 00       	call   c01047e7 <clearVRAM>
			flushVCache();
c0103ba6:	e8 70 0b 00 00       	call   c010471b <flushVCache>
		break;
c0103bab:	eb 55                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0103bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb0:	8b 40 14             	mov    0x14(%eax),%eax
c0103bb3:	0f b6 c0             	movzbl %al,%eax
c0103bb6:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bb9:	8b 52 18             	mov    0x18(%edx),%edx
c0103bbc:	89 d1                	mov    %edx,%ecx
c0103bbe:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bc1:	8b 52 10             	mov    0x10(%edx),%edx
c0103bc4:	83 ec 04             	sub    $0x4,%esp
c0103bc7:	50                   	push   %eax
c0103bc8:	51                   	push   %ecx
c0103bc9:	52                   	push   %edx
c0103bca:	e8 b1 0b 00 00       	call   c0104780 <setPixelAt>
c0103bcf:	83 c4 10             	add    $0x10,%esp
		break;
c0103bd2:	eb 2e                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd7:	8b 40 10             	mov    0x10(%eax),%eax
c0103bda:	0f be c0             	movsbl %al,%eax
c0103bdd:	83 ec 0c             	sub    $0xc,%esp
c0103be0:	50                   	push   %eax
c0103be1:	e8 26 f7 ff ff       	call   c010330c <get_key>
c0103be6:	83 c4 10             	add    $0x10,%esp
c0103be9:	0f be d0             	movsbl %al,%edx
c0103bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bef:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103bf2:	eb 0e                	jmp    c0103c02 <do_syscall+0x4dd>
		case SYS_GET_TICK:
			tf->eax = tick();
c0103bf4:	e8 3a 0d 00 00       	call   c0104933 <tick>
c0103bf9:	89 c2                	mov    %eax,%edx
c0103bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bfe:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0103c01:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0103c02:	c9                   	leave  
c0103c03:	c3                   	ret    

c0103c04 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103c04:	55                   	push   %ebp
c0103c05:	89 e5                	mov    %esp,%ebp
c0103c07:	83 ec 10             	sub    $0x10,%esp
c0103c0a:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c14:	89 c2                	mov    %eax,%edx
c0103c16:	ec                   	in     (%dx),%al
c0103c17:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103c1a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0103c1e:	0f b6 c0             	movzbl %al,%eax
c0103c21:	83 e0 20             	and    $0x20,%eax
c0103c24:	85 c0                	test   %eax,%eax
c0103c26:	0f 95 c0             	setne  %al
c0103c29:	0f b6 c0             	movzbl %al,%eax
}
c0103c2c:	c9                   	leave  
c0103c2d:	c3                   	ret    

c0103c2e <serial_printc>:

static inline
void serial_printc(char ch) {
c0103c2e:	55                   	push   %ebp
c0103c2f:	89 e5                	mov    %esp,%ebp
c0103c31:	83 ec 14             	sub    $0x14,%esp
c0103c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c37:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103c3a:	90                   	nop
c0103c3b:	e8 c4 ff ff ff       	call   c0103c04 <serial_idle>
c0103c40:	85 c0                	test   %eax,%eax
c0103c42:	74 f7                	je     c0103c3b <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0103c44:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103c48:	0f b6 c0             	movzbl %al,%eax
c0103c4b:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0103c52:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103c55:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103c59:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103c5c:	ee                   	out    %al,(%dx)
}
c0103c5d:	c9                   	leave  
c0103c5e:	c3                   	ret    

c0103c5f <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0103c5f:	55                   	push   %ebp
c0103c60:	89 e5                	mov    %esp,%ebp
c0103c62:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0103c65:	8d 45 0c             	lea    0xc(%ebp),%eax
c0103c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6e:	83 ec 04             	sub    $0x4,%esp
c0103c71:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c74:	50                   	push   %eax
c0103c75:	68 2e 3c 10 c0       	push   $0xc0103c2e
c0103c7a:	e8 38 0e 00 00       	call   c0104ab7 <vfprintf>
c0103c7f:	83 c4 10             	add    $0x10,%esp
}
c0103c82:	c9                   	leave  
c0103c83:	c3                   	ret    

c0103c84 <memcpy>:

static inline void cputchar(char c) {
    serial_printc(c);
}

static inline void memcpy(void* dst, void* src, int len){
c0103c84:	55                   	push   %ebp
c0103c85:	89 e5                	mov    %esp,%ebp
c0103c87:	57                   	push   %edi
c0103c88:	56                   	push   %esi
c0103c89:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103c8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c90:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103c93:	89 c1                	mov    %eax,%ecx
c0103c95:	89 d6                	mov    %edx,%esi
c0103c97:	89 df                	mov    %ebx,%edi
c0103c99:	fc                   	cld    
c0103c9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0103c9c:	5b                   	pop    %ebx
c0103c9d:	5e                   	pop    %esi
c0103c9e:	5f                   	pop    %edi
c0103c9f:	5d                   	pop    %ebp
c0103ca0:	c3                   	ret    

c0103ca1 <memcpy2>:

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}
static inline void memcpy2(void* dst, void* src, int len){
c0103ca1:	55                   	push   %ebp
c0103ca2:	89 e5                	mov    %esp,%ebp
c0103ca4:	57                   	push   %edi
c0103ca5:	56                   	push   %esi
c0103ca6:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c0103ca7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103caa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cad:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103cb0:	89 c1                	mov    %eax,%ecx
c0103cb2:	89 d6                	mov    %edx,%esi
c0103cb4:	89 df                	mov    %ebx,%edi
c0103cb6:	fc                   	cld    
c0103cb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c0103cb9:	5b                   	pop    %ebx
c0103cba:	5e                   	pop    %esi
c0103cbb:	5f                   	pop    %edi
c0103cbc:	5d                   	pop    %ebp
c0103cbd:	c3                   	ret    

c0103cbe <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103cbe:	55                   	push   %ebp
c0103cbf:	89 e5                	mov    %esp,%ebp
c0103cc1:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0103cc4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cc7:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0103ccc:	77 16                	ja     c0103ce4 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0103cce:	ff 75 10             	pushl  0x10(%ebp)
c0103cd1:	68 10 4f 10 c0       	push   $0xc0104f10
c0103cd6:	ff 75 0c             	pushl  0xc(%ebp)
c0103cd9:	ff 75 08             	pushl  0x8(%ebp)
c0103cdc:	e8 7e ff ff ff       	call   c0103c5f <printk>
c0103ce1:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0103ce4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ce7:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0103cec:	c9                   	leave  
c0103ced:	c3                   	ret    

c0103cee <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0103cee:	55                   	push   %ebp
c0103cef:	89 e5                	mov    %esp,%ebp
c0103cf1:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103cf4:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cf7:	c1 e8 0c             	shr    $0xc,%eax
c0103cfa:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103cff:	76 13                	jbe    c0103d14 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0103d01:	83 ec 08             	sub    $0x8,%esp
c0103d04:	ff 75 10             	pushl  0x10(%ebp)
c0103d07:	68 34 4f 10 c0       	push   $0xc0104f34
c0103d0c:	e8 4e ff ff ff       	call   c0103c5f <printk>
c0103d11:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0103d14:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d17:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103d1c:	c9                   	leave  
c0103d1d:	c3                   	ret    

c0103d1e <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0103d1e:	55                   	push   %ebp
c0103d1f:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0103d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d24:	ba 40 6b 17 c0       	mov    $0xc0176b40,%edx
c0103d29:	29 d0                	sub    %edx,%eax
c0103d2b:	c1 f8 03             	sar    $0x3,%eax
c0103d2e:	c1 e0 0c             	shl    $0xc,%eax
}
c0103d31:	5d                   	pop    %ebp
c0103d32:	c3                   	ret    

c0103d33 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c0103d33:	55                   	push   %ebp
c0103d34:	89 e5                	mov    %esp,%ebp
c0103d36:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0103d39:	ff 75 08             	pushl  0x8(%ebp)
c0103d3c:	e8 dd ff ff ff       	call   c0103d1e <page2pa>
c0103d41:	83 c4 04             	add    $0x4,%esp
c0103d44:	83 ec 04             	sub    $0x4,%esp
c0103d47:	50                   	push   %eax
c0103d48:	6a 52                	push   $0x52
c0103d4a:	68 56 4f 10 c0       	push   $0xc0104f56
c0103d4f:	e8 9a ff ff ff       	call   c0103cee <_kaddr>
c0103d54:	83 c4 10             	add    $0x10,%esp
}
c0103d57:	c9                   	leave  
c0103d58:	c3                   	ret    

c0103d59 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0103d59:	55                   	push   %ebp
c0103d5a:	89 e5                	mov    %esp,%ebp
c0103d5c:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0103d5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0103d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d69:	8b 00                	mov    (%eax),%eax
c0103d6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0103d6e:	eb 10                	jmp    c0103d80 <ll_len+0x27>
		p = p->next;
c0103d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d73:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103d79:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0103d7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0103d80:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103d84:	75 ea                	jne    c0103d70 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0103d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103d89:	c9                   	leave  
c0103d8a:	c3                   	ret    

c0103d8b <ll_pop>:
PCB* ll_pop(PCB** head){
c0103d8b:	55                   	push   %ebp
c0103d8c:	89 e5                	mov    %esp,%ebp
c0103d8e:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0103d91:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d94:	8b 00                	mov    (%eax),%eax
c0103d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c0103d99:	83 ec 08             	sub    $0x8,%esp
c0103d9c:	ff 75 f4             	pushl  -0xc(%ebp)
c0103d9f:	ff 75 08             	pushl  0x8(%ebp)
c0103da2:	e8 a4 00 00 00       	call   c0103e4b <ll_delete>
c0103da7:	83 c4 10             	add    $0x10,%esp
	return p;
c0103daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103dad:	c9                   	leave  
c0103dae:	c3                   	ret    

c0103daf <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0103daf:	55                   	push   %ebp
c0103db0:	89 e5                	mov    %esp,%ebp
c0103db2:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db8:	8b 00                	mov    (%eax),%eax
c0103dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0103dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103dc1:	75 0f                	jne    c0103dd2 <ll_push+0x23>
		*head = p;
c0103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dc9:	89 10                	mov    %edx,(%eax)
		return 0;
c0103dcb:	b8 00 00 00 00       	mov    $0x0,%eax
c0103dd0:	eb 19                	jmp    c0103deb <ll_push+0x3c>
	}else{
		*head = p;
c0103dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dd8:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0103dda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ddd:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103de0:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c0103de6:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103deb:	c9                   	leave  
c0103dec:	c3                   	ret    

c0103ded <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0103ded:	55                   	push   %ebp
c0103dee:	89 e5                	mov    %esp,%ebp
c0103df0:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103df6:	8b 00                	mov    (%eax),%eax
c0103df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0103dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103dfe:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c0103e05:	00 00 00 
	if(h == NULL){
c0103e08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103e0c:	75 0f                	jne    c0103e1d <ll_entail+0x30>
		*head = p;
c0103e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e11:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e14:	89 10                	mov    %edx,(%eax)
		return 0;
c0103e16:	b8 00 00 00 00       	mov    $0x0,%eax
c0103e1b:	eb 2c                	jmp    c0103e49 <ll_entail+0x5c>
	}else{
		while(h->next){
c0103e1d:	eb 0c                	jmp    c0103e2b <ll_entail+0x3e>
			h = h->next;
c0103e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e22:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0103e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e2e:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103e34:	85 c0                	test   %eax,%eax
c0103e36:	75 e7                	jne    c0103e1f <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0103e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e3e:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c0103e44:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103e49:	c9                   	leave  
c0103e4a:	c3                   	ret    

c0103e4b <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c0103e4b:	55                   	push   %ebp
c0103e4c:	89 e5                	mov    %esp,%ebp
c0103e4e:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c0103e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e54:	8b 00                	mov    (%eax),%eax
c0103e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0103e59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c0103e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103e64:	75 07                	jne    c0103e6d <ll_delete+0x22>
			return 0;
c0103e66:	b8 00 00 00 00       	mov    $0x0,%eax
c0103e6b:	eb 59                	jmp    c0103ec6 <ll_delete+0x7b>
		if(sleep == p)
c0103e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e70:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e73:	75 09                	jne    c0103e7e <ll_delete+0x33>
			break;
c0103e75:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0103e76:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103e7a:	75 26                	jne    c0103ea2 <ll_delete+0x57>
c0103e7c:	eb 14                	jmp    c0103e92 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0103e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e81:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0103e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e87:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103e8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0103e90:	eb ce                	jmp    c0103e60 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c0103e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e95:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103e9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e9e:	89 10                	mov    %edx,(%eax)
c0103ea0:	eb 12                	jmp    c0103eb4 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0103ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ea5:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103eae:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
	sleep->next = NULL;
c0103eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103eb7:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c0103ebe:	00 00 00 
	return 1;
c0103ec1:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0103ec6:	c9                   	leave  
c0103ec7:	c3                   	ret    

c0103ec8 <init_pcb_pool>:

void init_pcb_pool()
{
c0103ec8:	55                   	push   %ebp
c0103ec9:	89 e5                	mov    %esp,%ebp
c0103ecb:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103ece:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103ed5:	eb 1d                	jmp    c0103ef4 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0103ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103eda:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103ee0:	05 40 20 00 00       	add    $0x2040,%eax
c0103ee5:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0103eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103ef0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103ef4:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0103efb:	76 da                	jbe    c0103ed7 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0103efd:	c9                   	leave  
c0103efe:	c3                   	ret    

c0103eff <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0103eff:	55                   	push   %ebp
c0103f00:	89 e5                	mov    %esp,%ebp
c0103f02:	83 ec 24             	sub    $0x24,%esp
c0103f05:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f08:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0103f0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f0e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0103f17:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103f1b:	75 46                	jne    c0103f63 <init_pcb+0x64>
		tf->ds = GD_KD;
c0103f1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f20:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0103f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f2a:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0103f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f34:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0103f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f3d:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0103f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f47:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0103f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f51:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f5a:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0103f61:	eb 4a                	jmp    c0103fad <init_pcb+0xae>
	}else
	if(pri == 3){
c0103f63:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0103f67:	75 44                	jne    c0103fad <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0103f69:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f6c:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0103f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f76:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0103f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f80:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0103f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f89:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0103f90:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f93:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0103f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f9d:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103fa6:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0103fad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fb3:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0103fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103fb9:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fbc:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0103fbf:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103fc3:	75 59                	jne    c010401e <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c0103fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0103fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0103fd1:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103fd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103fdf:	eb 26                	jmp    c0104007 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0103fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fee:	01 c2                	add    %eax,%edx
c0103ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ff3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ffd:	01 c8                	add    %ecx,%eax
c0103fff:	8b 00                	mov    (%eax),%eax
c0104001:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0104003:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104007:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010400a:	c1 e8 02             	shr    $0x2,%eax
c010400d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0104010:	77 cf                	ja     c0103fe1 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0104012:	8b 45 08             	mov    0x8(%ebp),%eax
c0104015:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104018:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c010401e:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0104022:	0f 95 c0             	setne  %al
c0104025:	0f b6 d0             	movzbl %al,%edx
c0104028:	8b 45 08             	mov    0x8(%ebp),%eax
c010402b:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0104031:	c9                   	leave  
c0104032:	c3                   	ret    

c0104033 <pcb_create>:

PCB* pcb_create()
{
c0104033:	55                   	push   %ebp
c0104034:	89 e5                	mov    %esp,%ebp
c0104036:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0104039:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104040:	eb 1f                	jmp    c0104061 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0104042:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104045:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c010404b:	05 40 20 00 00       	add    $0x2040,%eax
c0104050:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0104055:	8b 00                	mov    (%eax),%eax
c0104057:	85 c0                	test   %eax,%eax
c0104059:	75 02                	jne    c010405d <pcb_create+0x2a>
c010405b:	eb 0d                	jmp    c010406a <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010405d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104061:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0104068:	76 d8                	jbe    c0104042 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c010406a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010406d:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104073:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0104078:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c010407b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010407e:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0104081:	8d 90 80 df 1f c0    	lea    -0x3fe02080(%eax),%edx
c0104087:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010408a:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	for(i=0; i<FCBMAX; i++){
c0104090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104097:	eb 17                	jmp    c01040b0 <pcb_create+0x7d>
		p->fcb[i].fd_kr = -1;
c0104099:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010409c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010409f:	81 c2 18 08 00 00    	add    $0x818,%edx
c01040a5:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	for(i=0; i<PCBPOOLMAX; i++){
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
	p->tf = &tfPool[i];
	for(i=0; i<FCBMAX; i++){
c01040ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01040b0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c01040b7:	76 e0                	jbe    c0104099 <pcb_create+0x66>
		p->fcb[i].fd_kr = -1;
	}
	p->used = 1;
c01040b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040bc:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c01040c3:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c01040c6:	83 ec 0c             	sub    $0xc,%esp
c01040c9:	6a 01                	push   $0x1
c01040cb:	e8 b3 c7 ff ff       	call   c0100883 <page_alloc>
c01040d0:	83 c4 10             	add    $0x10,%esp
c01040d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c01040d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01040da:	75 07                	jne    c01040e3 <pcb_create+0xb0>
c01040dc:	b8 00 00 00 00       	mov    $0x0,%eax
c01040e1:	eb 77                	jmp    c010415a <pcb_create+0x127>
	p->pgdir = page2kva(pp);
c01040e3:	83 ec 0c             	sub    $0xc,%esp
c01040e6:	ff 75 ec             	pushl  -0x14(%ebp)
c01040e9:	e8 45 fc ff ff       	call   c0103d33 <page2kva>
c01040ee:	83 c4 10             	add    $0x10,%esp
c01040f1:	89 c2                	mov    %eax,%edx
c01040f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040f6:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c01040fc:	8b 15 d0 95 10 c0    	mov    0xc01095d0,%edx
c0104102:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104105:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c010410b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010410e:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0104115:	00 00 00 
	//p->ts = READY;
	pid ++;
c0104118:	a1 d0 95 10 c0       	mov    0xc01095d0,%eax
c010411d:	83 c0 01             	add    $0x1,%eax
c0104120:	a3 d0 95 10 c0       	mov    %eax,0xc01095d0
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0104125:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104128:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010412c:	8d 50 01             	lea    0x1(%eax),%edx
c010412f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104132:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0104136:	8b 15 00 6b 17 c0    	mov    0xc0176b00,%edx
c010413c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010413f:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104145:	83 ec 04             	sub    $0x4,%esp
c0104148:	68 00 10 00 00       	push   $0x1000
c010414d:	52                   	push   %edx
c010414e:	50                   	push   %eax
c010414f:	e8 30 fb ff ff       	call   c0103c84 <memcpy>
c0104154:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0104157:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010415a:	c9                   	leave  
c010415b:	c3                   	ret    

c010415c <enready_pcb>:

void enready_pcb(PCB* pcb){
c010415c:	55                   	push   %ebp
c010415d:	89 e5                	mov    %esp,%ebp
c010415f:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0104162:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0104167:	85 c0                	test   %eax,%eax
c0104169:	75 18                	jne    c0104183 <enready_pcb+0x27>
		ready_list = pcb;
c010416b:	8b 45 08             	mov    0x8(%ebp),%eax
c010416e:	a3 c8 74 15 c0       	mov    %eax,0xc01574c8
		ready_list->tail = pcb;
c0104173:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0104178:	8b 55 08             	mov    0x8(%ebp),%edx
c010417b:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
c0104181:	eb 32                	jmp    c01041b5 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c0104183:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0104188:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c010418b:	8b 45 08             	mov    0x8(%ebp),%eax
c010418e:	a3 c8 74 15 c0       	mov    %eax,0xc01574c8
		ready_list->next = temp;
c0104193:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0104198:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010419b:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		ready_list->tail = temp->tail;
c01041a1:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c01041a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01041a9:	8b 92 64 24 00 00    	mov    0x2464(%edx),%edx
c01041af:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
	}
}
c01041b5:	c9                   	leave  
c01041b6:	c3                   	ret    

c01041b7 <switch_pcb>:

void switch_pcb(PCB* pcb){
c01041b7:	55                   	push   %ebp
c01041b8:	89 e5                	mov    %esp,%ebp
c01041ba:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01041bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01041c0:	a3 c4 74 15 c0       	mov    %eax,0xc01574c4
	lcr3(PADDR(pcb -> pgdir));
c01041c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01041c8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01041ce:	83 ec 04             	sub    $0x4,%esp
c01041d1:	50                   	push   %eax
c01041d2:	68 b2 00 00 00       	push   $0xb2
c01041d7:	68 6c 4f 10 c0       	push   $0xc0104f6c
c01041dc:	e8 dd fa ff ff       	call   c0103cbe <_paddr>
c01041e1:	83 c4 10             	add    $0x10,%esp
c01041e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ea:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c01041ed:	83 ec 0c             	sub    $0xc,%esp
c01041f0:	ff 75 08             	pushl  0x8(%ebp)
c01041f3:	e8 64 c1 ff ff       	call   c010035c <enter_pcb>
c01041f8:	83 c4 10             	add    $0x10,%esp
}
c01041fb:	c9                   	leave  
c01041fc:	c3                   	ret    

c01041fd <free_pcb>:
void free_pcb(PCB* pcb){
c01041fd:	55                   	push   %ebp
c01041fe:	89 e5                	mov    %esp,%ebp
	//free_pgdir(pcb->pgdir);
	//page_decref(pa2page(PADDR(pcb->pgdir)));
	pcb->used = 0;
c0104200:	8b 45 08             	mov    0x8(%ebp),%eax
c0104203:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c010420a:	00 00 00 

}
c010420d:	5d                   	pop    %ebp
c010420e:	c3                   	ret    

c010420f <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c010420f:	55                   	push   %ebp
c0104210:	89 e5                	mov    %esp,%ebp
c0104212:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0104215:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104218:	8b 45 08             	mov    0x8(%ebp),%eax
c010421b:	68 10 08 00 00       	push   $0x810
c0104220:	52                   	push   %edx
c0104221:	50                   	push   %eax
c0104222:	e8 5d fa ff ff       	call   c0103c84 <memcpy>
c0104227:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c010422a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010422d:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0104233:	8b 45 08             	mov    0x8(%ebp),%eax
c0104236:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c010423c:	8b 45 08             	mov    0x8(%ebp),%eax
c010423f:	05 20 10 00 00       	add    $0x1020,%eax
c0104244:	89 c2                	mov    %eax,%edx
c0104246:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104249:	05 20 10 00 00       	add    $0x1020,%eax
c010424e:	29 c2                	sub    %eax,%edx
c0104250:	89 d0                	mov    %edx,%eax
c0104252:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c0104255:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104258:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c010425e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104261:	01 c2                	add    %eax,%edx
c0104263:	8b 45 08             	mov    0x8(%ebp),%eax
c0104266:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c010426c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010426f:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c0104275:	8b 45 08             	mov    0x8(%ebp),%eax
c0104278:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c010427e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104281:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0104287:	85 c0                	test   %eax,%eax
c0104289:	75 62                	jne    c01042ed <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c010428b:	8b 45 08             	mov    0x8(%ebp),%eax
c010428e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104294:	8b 55 08             	mov    0x8(%ebp),%edx
c0104297:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c010429d:	8b 4a 08             	mov    0x8(%edx),%ecx
c01042a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042a3:	01 ca                	add    %ecx,%edx
c01042a5:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c01042a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ab:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042b1:	8b 40 08             	mov    0x8(%eax),%eax
c01042b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c01042b7:	eb 17                	jmp    c01042d0 <copy_pcb+0xc1>
			*(ptr) += offset;
c01042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042bc:	8b 10                	mov    (%eax),%edx
c01042be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042c1:	01 c2                	add    %eax,%edx
c01042c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c6:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c01042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042cb:	8b 00                	mov    (%eax),%eax
c01042cd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c01042d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d3:	8b 00                	mov    (%eax),%eax
c01042d5:	85 c0                	test   %eax,%eax
c01042d7:	75 e0                	jne    c01042b9 <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c01042d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042dc:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c01042e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01042e5:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c01042eb:	eb 2d                	jmp    c010431a <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c01042ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01042f0:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c01042f6:	83 f8 02             	cmp    $0x2,%eax
c01042f9:	74 1f                	je     c010431a <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c01042fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fe:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0104304:	8b 45 08             	mov    0x8(%ebp),%eax
c0104307:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010430d:	83 ec 08             	sub    $0x8,%esp
c0104310:	52                   	push   %edx
c0104311:	50                   	push   %eax
c0104312:	e8 1b c8 ff ff       	call   c0100b32 <copy_pgdir>
c0104317:	83 c4 10             	add    $0x10,%esp
	}
	memcpy2(dst->fcb, src->fcb, sizeof(dst->fcb));
c010431a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010431d:	8d 90 60 20 00 00    	lea    0x2060(%eax),%edx
c0104323:	8b 45 08             	mov    0x8(%ebp),%eax
c0104326:	05 60 20 00 00       	add    $0x2060,%eax
c010432b:	83 ec 04             	sub    $0x4,%esp
c010432e:	68 00 04 00 00       	push   $0x400
c0104333:	52                   	push   %edx
c0104334:	50                   	push   %eax
c0104335:	e8 67 f9 ff ff       	call   c0103ca1 <memcpy2>
c010433a:	83 c4 10             	add    $0x10,%esp
	//lcr3(PADDR(kern_pgdir));
}
c010433d:	c9                   	leave  
c010433e:	c3                   	ret    

c010433f <fork_current>:

void switch_proc();
void fork_current(){
c010433f:	55                   	push   %ebp
c0104340:	89 e5                	mov    %esp,%ebp
c0104342:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0104345:	e8 e9 fc ff ff       	call   c0104033 <pcb_create>
c010434a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c010434d:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104352:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0104358:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010435b:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0104361:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104366:	83 ec 08             	sub    $0x8,%esp
c0104369:	50                   	push   %eax
c010436a:	ff 75 f4             	pushl  -0xc(%ebp)
c010436d:	e8 9d fe ff ff       	call   c010420f <copy_pcb>
c0104372:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0104375:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010437a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104380:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104383:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0104389:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010438c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010438f:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104395:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c010439c:	83 ec 08             	sub    $0x8,%esp
c010439f:	ff 75 f4             	pushl  -0xc(%ebp)
c01043a2:	68 c8 74 15 c0       	push   $0xc01574c8
c01043a7:	e8 03 fa ff ff       	call   c0103daf <ll_push>
c01043ac:	83 c4 10             	add    $0x10,%esp
}
c01043af:	c9                   	leave  
c01043b0:	c3                   	ret    

c01043b1 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c01043b1:	55                   	push   %ebp
c01043b2:	89 e5                	mov    %esp,%ebp
c01043b4:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c01043b7:	e8 77 fc ff ff       	call   c0104033 <pcb_create>
c01043bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c01043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c2:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c01043c9:	00 00 00 
	son->ppid = current->pid;
c01043cc:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01043d1:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01043d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043da:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01043e0:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01043e5:	83 ec 08             	sub    $0x8,%esp
c01043e8:	50                   	push   %eax
c01043e9:	ff 75 f4             	pushl  -0xc(%ebp)
c01043ec:	e8 1e fe ff ff       	call   c010420f <copy_pcb>
c01043f1:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c01043f4:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01043f9:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c01043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104402:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104408:	83 ec 04             	sub    $0x4,%esp
c010440b:	68 00 10 00 00       	push   $0x1000
c0104410:	52                   	push   %edx
c0104411:	50                   	push   %eax
c0104412:	e8 6d f8 ff ff       	call   c0103c84 <memcpy>
c0104417:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c010441a:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0104421:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104424:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c010442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104433:	83 ec 04             	sub    $0x4,%esp
c0104436:	68 00 20 00 00       	push   $0x2000
c010443b:	52                   	push   %edx
c010443c:	50                   	push   %eax
c010443d:	e8 4f c2 ff ff       	call   c0100691 <mm_alloc>
c0104442:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c0104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104448:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010444e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104451:	83 ea 40             	sub    $0x40,%edx
c0104454:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c0104457:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104463:	83 ea 40             	sub    $0x40,%edx
c0104466:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c0104469:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010446c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104472:	8b 55 08             	mov    0x8(%ebp),%edx
c0104475:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0104478:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010447d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104483:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104486:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c010448c:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104492:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104498:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c010449f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a2:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01044a8:	83 ec 04             	sub    $0x4,%esp
c01044ab:	50                   	push   %eax
c01044ac:	68 ff 00 00 00       	push   $0xff
c01044b1:	68 6c 4f 10 c0       	push   $0xc0104f6c
c01044b6:	e8 03 f8 ff ff       	call   c0103cbe <_paddr>
c01044bb:	83 c4 10             	add    $0x10,%esp
c01044be:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044c4:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c01044c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044ca:	83 e8 40             	sub    $0x40,%eax
c01044cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c01044d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044d6:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c01044d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044db:	8d 50 04             	lea    0x4(%eax),%edx
c01044de:	8b 45 10             	mov    0x10(%ebp),%eax
c01044e1:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c01044e3:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01044e8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01044ee:	83 ec 04             	sub    $0x4,%esp
c01044f1:	50                   	push   %eax
c01044f2:	68 05 01 00 00       	push   $0x105
c01044f7:	68 6c 4f 10 c0       	push   $0xc0104f6c
c01044fc:	e8 bd f7 ff ff       	call   c0103cbe <_paddr>
c0104501:	83 c4 10             	add    $0x10,%esp
c0104504:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010450a:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c010450d:	83 ec 08             	sub    $0x8,%esp
c0104510:	ff 75 f4             	pushl  -0xc(%ebp)
c0104513:	68 c8 74 15 c0       	push   $0xc01574c8
c0104518:	e8 92 f8 ff ff       	call   c0103daf <ll_push>
c010451d:	83 c4 10             	add    $0x10,%esp
}
c0104520:	c9                   	leave  
c0104521:	c3                   	ret    

c0104522 <exit_current>:

void exit_current(){
c0104522:	55                   	push   %ebp
c0104523:	89 e5                	mov    %esp,%ebp
c0104525:	83 ec 18             	sub    $0x18,%esp
	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0104528:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010452d:	05 68 24 00 00       	add    $0x2468,%eax
c0104532:	83 ec 0c             	sub    $0xc,%esp
c0104535:	50                   	push   %eax
c0104536:	e8 50 f8 ff ff       	call   c0103d8b <ll_pop>
c010453b:	83 c4 10             	add    $0x10,%esp
c010453e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0104541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104545:	75 02                	jne    c0104549 <exit_current+0x27>
c0104547:	eb 24                	jmp    c010456d <exit_current+0x4b>
		if(p->used == 0) continue;
c0104549:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454c:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0104552:	85 c0                	test   %eax,%eax
c0104554:	75 02                	jne    c0104558 <exit_current+0x36>
c0104556:	eb 13                	jmp    c010456b <exit_current+0x49>
		ll_entail(&ready_list, p);
c0104558:	83 ec 08             	sub    $0x8,%esp
c010455b:	ff 75 f4             	pushl  -0xc(%ebp)
c010455e:	68 c8 74 15 c0       	push   $0xc01574c8
c0104563:	e8 85 f8 ff ff       	call   c0103ded <ll_entail>
c0104568:	83 c4 10             	add    $0x10,%esp
	}
c010456b:	eb bb                	jmp    c0104528 <exit_current+0x6>
	
	free_pcb(current);
c010456d:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104572:	83 ec 0c             	sub    $0xc,%esp
c0104575:	50                   	push   %eax
c0104576:	e8 82 fc ff ff       	call   c01041fd <free_pcb>
c010457b:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c010457e:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c0104585:	00 00 00 
	do_scheduler();
c0104588:	e8 1e cb ff ff       	call   c01010ab <do_scheduler>
}
c010458d:	c9                   	leave  
c010458e:	c3                   	ret    

c010458f <join_current>:

void join_current(int pid){
c010458f:	55                   	push   %ebp
c0104590:	89 e5                	mov    %esp,%ebp
c0104592:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0104595:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104599:	75 05                	jne    c01045a0 <join_current+0x11>
c010459b:	e9 97 00 00 00       	jmp    c0104637 <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01045a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045a7:	eb 23                	jmp    c01045cc <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c01045a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ac:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c01045b2:	05 40 20 00 00       	add    $0x2040,%eax
c01045b7:	05 80 08 21 c0       	add    $0xc0210880,%eax
c01045bc:	8b 50 04             	mov    0x4(%eax),%edx
c01045bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c2:	39 c2                	cmp    %eax,%edx
c01045c4:	75 02                	jne    c01045c8 <join_current+0x39>
c01045c6:	eb 0d                	jmp    c01045d5 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01045c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01045cc:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01045d3:	76 d4                	jbe    c01045a9 <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c01045d5:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c01045dc:	75 02                	jne    c01045e0 <join_current+0x51>
c01045de:	eb 57                	jmp    c0104637 <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c01045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e3:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c01045e9:	05 40 20 00 00       	add    $0x2040,%eax
c01045ee:	05 80 08 21 c0       	add    $0xc0210880,%eax
c01045f3:	8b 00                	mov    (%eax),%eax
c01045f5:	85 c0                	test   %eax,%eax
c01045f7:	75 02                	jne    c01045fb <join_current+0x6c>
c01045f9:	eb 3c                	jmp    c0104637 <join_current+0xa8>
	PCB *p = &PCBPool[i];
c01045fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fe:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104604:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0104609:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c010460c:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104611:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0104614:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104617:	05 68 24 00 00       	add    $0x2468,%eax
c010461c:	ff 75 ec             	pushl  -0x14(%ebp)
c010461f:	50                   	push   %eax
c0104620:	e8 c8 f7 ff ff       	call   c0103ded <ll_entail>
c0104625:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0104628:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c010462f:	00 00 00 
	do_scheduler();
c0104632:	e8 74 ca ff ff       	call   c01010ab <do_scheduler>
}
c0104637:	c9                   	leave  
c0104638:	c3                   	ret    

c0104639 <exec_current>:
void exec_current(char* filename){
c0104639:	55                   	push   %ebp
c010463a:	89 e5                	mov    %esp,%ebp
c010463c:	83 ec 18             	sub    $0x18,%esp
	int status = loader_file(current, filename);
c010463f:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104644:	83 ec 08             	sub    $0x8,%esp
c0104647:	ff 75 08             	pushl  0x8(%ebp)
c010464a:	50                   	push   %eax
c010464b:	e8 da e9 ff ff       	call   c010302a <loader_file>
c0104650:	83 c4 10             	add    $0x10,%esp
c0104653:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(status == -1){
c0104656:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010465a:	75 12                	jne    c010466e <exec_current+0x35>
		printk("Not executable\n");
c010465c:	83 ec 0c             	sub    $0xc,%esp
c010465f:	68 81 4f 10 c0       	push   $0xc0104f81
c0104664:	e8 f6 f5 ff ff       	call   c0103c5f <printk>
c0104669:	83 c4 10             	add    $0x10,%esp
		return;
c010466c:	eb 25                	jmp    c0104693 <exec_current+0x5a>
	}
	ll_entail(&ready_list, current);
c010466e:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104673:	83 ec 08             	sub    $0x8,%esp
c0104676:	50                   	push   %eax
c0104677:	68 c8 74 15 c0       	push   $0xc01574c8
c010467c:	e8 6c f7 ff ff       	call   c0103ded <ll_entail>
c0104681:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c0104684:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c010468b:	00 00 00 
	do_scheduler();
c010468e:	e8 18 ca ff ff       	call   c01010ab <do_scheduler>
c0104693:	c9                   	leave  
c0104694:	c3                   	ret    

c0104695 <memcpy>:

static inline void cputchar(char c) {
    serial_printc(c);
}

static inline void memcpy(void* dst, void* src, int len){
c0104695:	55                   	push   %ebp
c0104696:	89 e5                	mov    %esp,%ebp
c0104698:	57                   	push   %edi
c0104699:	56                   	push   %esi
c010469a:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c010469b:	8b 45 10             	mov    0x10(%ebp),%eax
c010469e:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01046a4:	89 c1                	mov    %eax,%ecx
c01046a6:	89 d6                	mov    %edx,%esi
c01046a8:	89 df                	mov    %ebx,%edi
c01046aa:	fc                   	cld    
c01046ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c01046ad:	5b                   	pop    %ebx
c01046ae:	5e                   	pop    %esi
c01046af:	5f                   	pop    %edi
c01046b0:	5d                   	pop    %ebp
c01046b1:	c3                   	ret    

c01046b2 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c01046b2:	55                   	push   %ebp
c01046b3:	89 e5                	mov    %esp,%ebp
c01046b5:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c01046b8:	68 80 3e 00 00       	push   $0x3e80
c01046bd:	68 00 6f 16 c0       	push   $0xc0166f00
c01046c2:	68 00 75 15 c0       	push   $0xc0157500
c01046c7:	e8 c9 ff ff ff       	call   c0104695 <memcpy>
c01046cc:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c01046cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01046d6:	eb 0f                	jmp    c01046e7 <initVCache+0x35>
		VDIRTY[x] = 0;
c01046d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01046db:	05 00 69 17 c0       	add    $0xc0176900,%eax
c01046e0:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c01046e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01046e7:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01046ee:	7e e8                	jle    c01046d8 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c01046f0:	c9                   	leave  
c01046f1:	c3                   	ret    

c01046f2 <refreshVCache>:
void refreshVCache(){
c01046f2:	55                   	push   %ebp
c01046f3:	89 e5                	mov    %esp,%ebp
c01046f5:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c01046f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01046ff:	eb 0f                	jmp    c0104710 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0104701:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104704:	05 00 69 17 c0       	add    $0xc0176900,%eax
c0104709:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c010470c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104710:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0104717:	7e e8                	jle    c0104701 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0104719:	c9                   	leave  
c010471a:	c3                   	ret    

c010471b <flushVCache>:
void flushVCache(){
c010471b:	55                   	push   %ebp
c010471c:	89 e5                	mov    %esp,%ebp
c010471e:	53                   	push   %ebx
c010471f:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0104722:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0104729:	eb 47                	jmp    c0104772 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c010472b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010472e:	05 00 69 17 c0       	add    $0xc0176900,%eax
c0104733:	0f b6 00             	movzbl (%eax),%eax
c0104736:	84 c0                	test   %al,%al
c0104738:	74 34                	je     c010476e <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c010473a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010473d:	89 d0                	mov    %edx,%eax
c010473f:	c1 e0 02             	shl    $0x2,%eax
c0104742:	01 d0                	add    %edx,%eax
c0104744:	c1 e0 06             	shl    $0x6,%eax
c0104747:	8d 88 00 75 15 c0    	lea    -0x3fea8b00(%eax),%ecx
c010474d:	8b 1d d4 95 10 c0    	mov    0xc01095d4,%ebx
c0104753:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0104756:	89 d0                	mov    %edx,%eax
c0104758:	c1 e0 02             	shl    $0x2,%eax
c010475b:	01 d0                	add    %edx,%eax
c010475d:	c1 e0 06             	shl    $0x6,%eax
c0104760:	01 d8                	add    %ebx,%eax
c0104762:	6a 50                	push   $0x50
c0104764:	51                   	push   %ecx
c0104765:	50                   	push   %eax
c0104766:	e8 2a ff ff ff       	call   c0104695 <memcpy>
c010476b:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c010476e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0104772:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0104779:	7e b0                	jle    c010472b <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c010477b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010477e:	c9                   	leave  
c010477f:	c3                   	ret    

c0104780 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0104780:	55                   	push   %ebp
c0104781:	89 e5                	mov    %esp,%ebp
c0104783:	83 ec 04             	sub    $0x4,%esp
c0104786:	8b 45 10             	mov    0x10(%ebp),%eax
c0104789:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c010478c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104790:	78 18                	js     c01047aa <setPixelAt+0x2a>
c0104792:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0104799:	7f 0f                	jg     c01047aa <setPixelAt+0x2a>
c010479b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010479f:	78 09                	js     c01047aa <setPixelAt+0x2a>
c01047a1:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c01047a8:	7e 02                	jle    c01047ac <setPixelAt+0x2c>
c01047aa:	eb 34                	jmp    c01047e0 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c01047ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01047af:	05 00 69 17 c0       	add    $0xc0176900,%eax
c01047b4:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c01047b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ba:	05 00 6a 17 c0       	add    $0xc0176a00,%eax
c01047bf:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c01047c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01047c5:	89 d0                	mov    %edx,%eax
c01047c7:	c1 e0 02             	shl    $0x2,%eax
c01047ca:	01 d0                	add    %edx,%eax
c01047cc:	c1 e0 06             	shl    $0x6,%eax
c01047cf:	89 c2                	mov    %eax,%edx
c01047d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d4:	01 c2                	add    %eax,%edx
c01047d6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c01047da:	88 82 00 75 15 c0    	mov    %al,-0x3fea8b00(%edx)
}
c01047e0:	c9                   	leave  
c01047e1:	c3                   	ret    

c01047e2 <forceClearVRAM>:
void forceClearVRAM(){
c01047e2:	55                   	push   %ebp
c01047e3:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c01047e5:	5d                   	pop    %ebp
c01047e6:	c3                   	ret    

c01047e7 <clearVRAM>:
void clearVRAM(){
c01047e7:	55                   	push   %ebp
c01047e8:	89 e5                	mov    %esp,%ebp
c01047ea:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01047ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01047f4:	eb 4e                	jmp    c0104844 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c01047f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047f9:	05 00 6a 17 c0       	add    $0xc0176a00,%eax
c01047fe:	0f b6 00             	movzbl (%eax),%eax
c0104801:	0f b6 c0             	movzbl %al,%eax
c0104804:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104807:	81 c2 00 69 17 c0    	add    $0xc0176900,%edx
c010480d:	0f b6 12             	movzbl (%edx),%edx
c0104810:	0f b6 d2             	movzbl %dl,%edx
c0104813:	f7 d2                	not    %edx
c0104815:	21 d0                	and    %edx,%eax
c0104817:	85 c0                	test   %eax,%eax
c0104819:	74 25                	je     c0104840 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c010481b:	8b 0d d4 95 10 c0    	mov    0xc01095d4,%ecx
c0104821:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104824:	89 d0                	mov    %edx,%eax
c0104826:	c1 e0 02             	shl    $0x2,%eax
c0104829:	01 d0                	add    %edx,%eax
c010482b:	c1 e0 06             	shl    $0x6,%eax
c010482e:	01 c8                	add    %ecx,%eax
c0104830:	6a 50                	push   $0x50
c0104832:	68 00 6f 16 c0       	push   $0xc0166f00
c0104837:	50                   	push   %eax
c0104838:	e8 58 fe ff ff       	call   c0104695 <memcpy>
c010483d:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0104840:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104844:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c010484b:	7e a9                	jle    c01047f6 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c010484d:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104854:	83 c0 01             	add    $0x1,%eax
c0104857:	a2 c8 6a 17 c0       	mov    %al,0xc0176ac8
	if(stamp==30){
c010485c:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104863:	3c 1e                	cmp    $0x1e,%al
c0104865:	75 07                	jne    c010486e <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0104867:	c6 05 c8 6a 17 c0 00 	movb   $0x0,0xc0176ac8
		//printk("What matters\n");
	}
	if(stamp==0){
c010486e:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104875:	84 c0                	test   %al,%al
c0104877:	75 14                	jne    c010488d <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0104879:	6a 32                	push   $0x32
c010487b:	68 00 6f 16 c0       	push   $0xc0166f00
c0104880:	68 00 6a 17 c0       	push   $0xc0176a00
c0104885:	e8 0b fe ff ff       	call   c0104695 <memcpy>
c010488a:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c010488d:	c9                   	leave  
c010488e:	c3                   	ret    

c010488f <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c010488f:	55                   	push   %ebp
c0104890:	89 e5                	mov    %esp,%ebp
c0104892:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0104895:	a1 cc 6a 17 c0       	mov    0xc0176acc,%eax
c010489a:	83 c0 01             	add    $0x1,%eax
c010489d:	a3 cc 6a 17 c0       	mov    %eax,0xc0176acc
	current->timeslice ++;
c01048a2:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01048a7:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c01048ad:	83 c2 01             	add    $0x1,%edx
c01048b0:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c01048b6:	a1 cc 74 15 c0       	mov    0xc01574cc,%eax
c01048bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c01048be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048c2:	75 02                	jne    c01048c6 <do_timer+0x37>
c01048c4:	eb 6b                	jmp    c0104931 <do_timer+0xa2>
	 	sleep->timeslice --;
c01048c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c9:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c01048cf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01048d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d5:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c01048db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048de:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c01048e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e4:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c01048ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c01048ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f0:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c01048f6:	85 c0                	test   %eax,%eax
c01048f8:	74 02                	je     c01048fc <do_timer+0x6d>
c01048fa:	eb 33                	jmp    c010492f <do_timer+0xa0>
	 	cur->ts = READY;
c01048fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ff:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0104906:	00 00 00 
		ll_delete(&sleep_list, cur);
c0104909:	83 ec 08             	sub    $0x8,%esp
c010490c:	ff 75 f0             	pushl  -0x10(%ebp)
c010490f:	68 cc 74 15 c0       	push   $0xc01574cc
c0104914:	e8 32 f5 ff ff       	call   c0103e4b <ll_delete>
c0104919:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c010491c:	83 ec 08             	sub    $0x8,%esp
c010491f:	ff 75 f0             	pushl  -0x10(%ebp)
c0104922:	68 c8 74 15 c0       	push   $0xc01574c8
c0104927:	e8 c1 f4 ff ff       	call   c0103ded <ll_entail>
c010492c:	83 c4 10             	add    $0x10,%esp
	}
c010492f:	eb 8d                	jmp    c01048be <do_timer+0x2f>
}
c0104931:	c9                   	leave  
c0104932:	c3                   	ret    

c0104933 <tick>:
uint32_t tick(){
c0104933:	55                   	push   %ebp
c0104934:	89 e5                	mov    %esp,%ebp
	return _tick;
c0104936:	a1 cc 6a 17 c0       	mov    0xc0176acc,%eax
c010493b:	5d                   	pop    %ebp
c010493c:	c3                   	ret    

c010493d <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c010493d:	6a 00                	push   $0x0
c010493f:	6a 00                	push   $0x0
c0104941:	e9 b8 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104946 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0104946:	6a 00                	push   $0x0
c0104948:	6a 01                	push   $0x1
c010494a:	e9 af 00 00 00       	jmp    c01049fe <asm_do_irq>

c010494f <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c010494f:	6a 00                	push   $0x0
c0104951:	6a 02                	push   $0x2
c0104953:	e9 a6 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104958 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0104958:	6a 00                	push   $0x0
c010495a:	6a 03                	push   $0x3
c010495c:	e9 9d 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104961 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0104961:	6a 00                	push   $0x0
c0104963:	6a 04                	push   $0x4
c0104965:	e9 94 00 00 00       	jmp    c01049fe <asm_do_irq>

c010496a <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c010496a:	6a 00                	push   $0x0
c010496c:	6a 05                	push   $0x5
c010496e:	e9 8b 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104973 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0104973:	6a 00                	push   $0x0
c0104975:	6a 06                	push   $0x6
c0104977:	e9 82 00 00 00       	jmp    c01049fe <asm_do_irq>

c010497c <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c010497c:	6a 00                	push   $0x0
c010497e:	6a 07                	push   $0x7
c0104980:	e9 79 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104985 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0104985:	6a 00                	push   $0x0
c0104987:	6a 08                	push   $0x8
c0104989:	e9 70 00 00 00       	jmp    c01049fe <asm_do_irq>

c010498e <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c010498e:	6a 00                	push   $0x0
c0104990:	6a 09                	push   $0x9
c0104992:	e9 67 00 00 00       	jmp    c01049fe <asm_do_irq>

c0104997 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0104997:	6a 00                	push   $0x0
c0104999:	6a 0a                	push   $0xa
c010499b:	e9 5e 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049a0 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c01049a0:	6a 00                	push   $0x0
c01049a2:	6a 0b                	push   $0xb
c01049a4:	e9 55 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049a9 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c01049a9:	6a 00                	push   $0x0
c01049ab:	6a 0c                	push   $0xc
c01049ad:	e9 4c 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049b2 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c01049b2:	6a 00                	push   $0x0
c01049b4:	6a 0d                	push   $0xd
c01049b6:	e9 43 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049bb <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c01049bb:	6a 00                	push   $0x0
c01049bd:	6a 0e                	push   $0xe
c01049bf:	e9 3a 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049c4 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c01049c4:	fa                   	cli    
c01049c5:	6a 00                	push   $0x0
c01049c7:	68 80 00 00 00       	push   $0x80
c01049cc:	e9 2d 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049d1 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c01049d1:	6a 00                	push   $0x0
c01049d3:	68 e8 03 00 00       	push   $0x3e8
c01049d8:	e9 21 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049dd <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c01049dd:	6a 00                	push   $0x0
c01049df:	68 e9 03 00 00       	push   $0x3e9
c01049e4:	e9 15 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049e9 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c01049e9:	6a 00                	push   $0x0
c01049eb:	68 f6 03 00 00       	push   $0x3f6
c01049f0:	e9 09 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049f5 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c01049f5:	6a 00                	push   $0x0
c01049f7:	6a ff                	push   $0xffffffff
c01049f9:	e9 00 00 00 00       	jmp    c01049fe <asm_do_irq>

c01049fe <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c01049fe:	fa                   	cli    
  pushl %ds
c01049ff:	1e                   	push   %ds
  pushl %es
c0104a00:	06                   	push   %es
  pushl %fs
c0104a01:	0f a0                	push   %fs
  pushl %gs
c0104a03:	0f a8                	push   %gs
	pushal
c0104a05:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0104a06:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0104a0a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0104a0c:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0104a0e:	54                   	push   %esp
  call irq_handle
c0104a0f:	e8 8a c7 ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0104a14:	83 c4 04             	add    $0x4,%esp

c0104a17 <switch_proc>:
switch_proc:
  popal
c0104a17:	61                   	popa   
  popl %gs
c0104a18:	0f a9                	pop    %gs
  popl %fs
c0104a1a:	0f a1                	pop    %fs
  popl %es
c0104a1c:	07                   	pop    %es
  popl %ds
c0104a1d:	1f                   	pop    %ds
  addl $8, %esp
c0104a1e:	83 c4 08             	add    $0x8,%esp
  sti
c0104a21:	fb                   	sti    
  iret
c0104a22:	cf                   	iret   
c0104a23:	90                   	nop
c0104a24:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0104a2a:	00 00                	add    %al,(%eax)
c0104a2c:	fe 4f 52             	decb   0x52(%edi)
c0104a2f:	e4 66                	in     $0x66,%al

c0104a30 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0104a30:	66 c7 05 72 04 00 00 34 12 b8 00 80 10 00 0f 22     f..r...4......."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0104a40:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 53 4a 10     .. ......."..SJ.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0104a50:	c0 ff e0                                            ...

c0104a53 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0104a53:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0104a58:	bc 00 20 11 c0       	mov    $0xc0112000,%esp

	# now to C code

	call	main
c0104a5d:	e8 7b e1 ff ff       	call   c0102bdd <main>

c0104a62 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0104a62:	eb fe                	jmp    c0104a62 <spin>

c0104a64 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0104a64:	55                   	push   %ebp
c0104a65:	89 e5                	mov    %esp,%ebp
c0104a67:	53                   	push   %ebx
c0104a68:	83 ec 04             	sub    $0x4,%esp
c0104a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6e:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0104a71:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0104a76:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0104a7a:	89 d3                	mov    %edx,%ebx
c0104a7c:	cd 80                	int    $0x80
}
c0104a7e:	83 c4 04             	add    $0x4,%esp
c0104a81:	5b                   	pop    %ebx
c0104a82:	5d                   	pop    %ebp
c0104a83:	c3                   	ret    

c0104a84 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0104a84:	55                   	push   %ebp
c0104a85:	89 e5                	mov    %esp,%ebp
c0104a87:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0104a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0104a90:	eb 19                	jmp    c0104aab <printp+0x27>
		printer(cur);
c0104a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a95:	0f b6 00             	movzbl (%eax),%eax
c0104a98:	0f be c0             	movsbl %al,%eax
c0104a9b:	83 ec 0c             	sub    $0xc,%esp
c0104a9e:	50                   	push   %eax
c0104a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aa2:	ff d0                	call   *%eax
c0104aa4:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0104aa7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aae:	0f b6 00             	movzbl (%eax),%eax
c0104ab1:	84 c0                	test   %al,%al
c0104ab3:	75 dd                	jne    c0104a92 <printp+0xe>
		printer(cur);
	}
}
c0104ab5:	c9                   	leave  
c0104ab6:	c3                   	ret    

c0104ab7 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0104ab7:	55                   	push   %ebp
c0104ab8:	89 e5                	mov    %esp,%ebp
c0104aba:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0104abd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0104ac3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0104aca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0104ad1:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ad4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0104ad7:	e9 65 02 00 00       	jmp    c0104d41 <vfprintf+0x28a>

		if(cur == '%'){
c0104adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104adf:	0f b6 00             	movzbl (%eax),%eax
c0104ae2:	3c 25                	cmp    $0x25,%al
c0104ae4:	75 0c                	jne    c0104af2 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0104ae6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0104aed:	e9 4b 02 00 00       	jmp    c0104d3d <vfprintf+0x286>
		}
		if(type == READ){
c0104af2:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0104af6:	0f 85 26 02 00 00    	jne    c0104d22 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0104afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aff:	0f b6 00             	movzbl (%eax),%eax
c0104b02:	3c 73                	cmp    $0x73,%al
c0104b04:	75 35                	jne    c0104b3b <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0104b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b09:	8b 00                	mov    (%eax),%eax
c0104b0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0104b0e:	eb 19                	jmp    c0104b29 <vfprintf+0x72>
					printer(*p);
c0104b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b13:	0f b6 00             	movzbl (%eax),%eax
c0104b16:	0f be c0             	movsbl %al,%eax
c0104b19:	83 ec 0c             	sub    $0xc,%esp
c0104b1c:	50                   	push   %eax
c0104b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b20:	ff d0                	call   *%eax
c0104b22:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0104b25:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0104b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b2c:	0f b6 00             	movzbl (%eax),%eax
c0104b2f:	84 c0                	test   %al,%al
c0104b31:	75 dd                	jne    c0104b10 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0104b33:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104b37:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3e:	0f b6 00             	movzbl (%eax),%eax
c0104b41:	3c 78                	cmp    $0x78,%al
c0104b43:	0f 85 99 00 00 00    	jne    c0104be2 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0104b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b4c:	8b 00                	mov    (%eax),%eax
c0104b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0104b51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104b55:	75 1d                	jne    c0104b74 <vfprintf+0xbd>
					printer('0');
c0104b57:	83 ec 0c             	sub    $0xc,%esp
c0104b5a:	6a 30                	push   $0x30
c0104b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b5f:	ff d0                	call   *%eax
c0104b61:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104b64:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104b68:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b6f:	e9 c9 01 00 00       	jmp    c0104d3d <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0104b74:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0104b7b:	eb 2d                	jmp    c0104baa <vfprintf+0xf3>
					int d=(x%16);
c0104b7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b80:	83 e0 0f             	and    $0xf,%eax
c0104b83:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0104b86:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0104b8a:	7e 04                	jle    c0104b90 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0104b8c:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0104b90:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104b93:	83 c0 30             	add    $0x30,%eax
c0104b96:	89 c1                	mov    %eax,%ecx
c0104b98:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0104b9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b9e:	01 d0                	add    %edx,%eax
c0104ba0:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0104ba2:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0104ba6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0104baa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104bae:	75 cd                	jne    c0104b7d <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0104bb0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0104bb4:	eb 1e                	jmp    c0104bd4 <vfprintf+0x11d>
					printer(digits[di]);
c0104bb6:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0104bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bbc:	01 d0                	add    %edx,%eax
c0104bbe:	0f b6 00             	movzbl (%eax),%eax
c0104bc1:	0f be c0             	movsbl %al,%eax
c0104bc4:	83 ec 0c             	sub    $0xc,%esp
c0104bc7:	50                   	push   %eax
c0104bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bcb:	ff d0                	call   *%eax
c0104bcd:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0104bd0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0104bd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104bd8:	79 dc                	jns    c0104bb6 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0104bda:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104bde:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0104be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be5:	0f b6 00             	movzbl (%eax),%eax
c0104be8:	3c 64                	cmp    $0x64,%al
c0104bea:	0f 85 02 01 00 00    	jne    c0104cf2 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0104bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104bf3:	8b 00                	mov    (%eax),%eax
c0104bf5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0104bf8:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0104bff:	75 23                	jne    c0104c24 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0104c01:	83 ec 08             	sub    $0x8,%esp
c0104c04:	68 91 4f 10 c0       	push   $0xc0104f91
c0104c09:	ff 75 08             	pushl  0x8(%ebp)
c0104c0c:	e8 73 fe ff ff       	call   c0104a84 <printp>
c0104c11:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104c14:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104c18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0104c1f:	e9 19 01 00 00       	jmp    c0104d3d <vfprintf+0x286>
				}
				if(x==0){
c0104c24:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104c28:	75 1e                	jne    c0104c48 <vfprintf+0x191>
					printer('0');
c0104c2a:	83 ec 0c             	sub    $0xc,%esp
c0104c2d:	6a 30                	push   $0x30
c0104c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c32:	ff d0                	call   *%eax
c0104c34:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104c37:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104c3b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0104c42:	90                   	nop
c0104c43:	e9 f5 00 00 00       	jmp    c0104d3d <vfprintf+0x286>
				}
				if(x<0){
c0104c48:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104c4c:	79 10                	jns    c0104c5e <vfprintf+0x1a7>
					printer('-');
c0104c4e:	83 ec 0c             	sub    $0xc,%esp
c0104c51:	6a 2d                	push   $0x2d
c0104c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c56:	ff d0                	call   *%eax
c0104c58:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0104c5b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0104c5e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0104c65:	eb 53                	jmp    c0104cba <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0104c67:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104c6a:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104c6f:	89 c8                	mov    %ecx,%eax
c0104c71:	f7 ea                	imul   %edx
c0104c73:	c1 fa 02             	sar    $0x2,%edx
c0104c76:	89 c8                	mov    %ecx,%eax
c0104c78:	c1 f8 1f             	sar    $0x1f,%eax
c0104c7b:	29 c2                	sub    %eax,%edx
c0104c7d:	89 d0                	mov    %edx,%eax
c0104c7f:	c1 e0 02             	shl    $0x2,%eax
c0104c82:	01 d0                	add    %edx,%eax
c0104c84:	01 c0                	add    %eax,%eax
c0104c86:	29 c1                	sub    %eax,%ecx
c0104c88:	89 ca                	mov    %ecx,%edx
c0104c8a:	89 d0                	mov    %edx,%eax
c0104c8c:	83 c0 30             	add    $0x30,%eax
c0104c8f:	89 c1                	mov    %eax,%ecx
c0104c91:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104c94:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c97:	01 d0                	add    %edx,%eax
c0104c99:	88 08                	mov    %cl,(%eax)
					x/=10;
c0104c9b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104c9e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104ca3:	89 c8                	mov    %ecx,%eax
c0104ca5:	f7 ea                	imul   %edx
c0104ca7:	c1 fa 02             	sar    $0x2,%edx
c0104caa:	89 c8                	mov    %ecx,%eax
c0104cac:	c1 f8 1f             	sar    $0x1f,%eax
c0104caf:	29 c2                	sub    %eax,%edx
c0104cb1:	89 d0                	mov    %edx,%eax
c0104cb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0104cb6:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0104cba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104cbe:	7f a7                	jg     c0104c67 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0104cc0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0104cc4:	eb 1e                	jmp    c0104ce4 <vfprintf+0x22d>
					printer(digits[di]);
c0104cc6:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104cc9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ccc:	01 d0                	add    %edx,%eax
c0104cce:	0f b6 00             	movzbl (%eax),%eax
c0104cd1:	0f be c0             	movsbl %al,%eax
c0104cd4:	83 ec 0c             	sub    $0xc,%esp
c0104cd7:	50                   	push   %eax
c0104cd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cdb:	ff d0                	call   *%eax
c0104cdd:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0104ce0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104ce4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104ce8:	79 dc                	jns    c0104cc6 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0104cea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104cee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0104cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf5:	0f b6 00             	movzbl (%eax),%eax
c0104cf8:	3c 63                	cmp    $0x63,%al
c0104cfa:	75 1d                	jne    c0104d19 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0104cfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cff:	0f b6 00             	movzbl (%eax),%eax
c0104d02:	0f be c0             	movsbl %al,%eax
c0104d05:	83 ec 0c             	sub    $0xc,%esp
c0104d08:	50                   	push   %eax
c0104d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d0c:	ff d0                	call   *%eax
c0104d0e:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0104d11:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104d15:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0104d19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0104d20:	eb 1b                	jmp    c0104d3d <vfprintf+0x286>
		}
		if(type == NONE){
c0104d22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d26:	75 15                	jne    c0104d3d <vfprintf+0x286>
			printer(cur);
c0104d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d2b:	0f b6 00             	movzbl (%eax),%eax
c0104d2e:	0f be c0             	movsbl %al,%eax
c0104d31:	83 ec 0c             	sub    $0xc,%esp
c0104d34:	50                   	push   %eax
c0104d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d38:	ff d0                	call   *%eax
c0104d3a:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0104d3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d44:	0f b6 00             	movzbl (%eax),%eax
c0104d47:	84 c0                	test   %al,%al
c0104d49:	0f 85 8d fd ff ff    	jne    c0104adc <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0104d4f:	c9                   	leave  
c0104d50:	c3                   	ret    

c0104d51 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0104d51:	55                   	push   %ebp
c0104d52:	89 e5                	mov    %esp,%ebp
c0104d54:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0104d57:	8d 45 0c             	lea    0xc(%ebp),%eax
c0104d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0104d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d60:	83 ec 04             	sub    $0x4,%esp
c0104d63:	ff 75 f4             	pushl  -0xc(%ebp)
c0104d66:	50                   	push   %eax
c0104d67:	68 64 4a 10 c0       	push   $0xc0104a64
c0104d6c:	e8 46 fd ff ff       	call   c0104ab7 <vfprintf>
c0104d71:	83 c4 10             	add    $0x10,%esp
}
c0104d74:	c9                   	leave  
c0104d75:	c3                   	ret    
