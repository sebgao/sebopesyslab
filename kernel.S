
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
c01000ba:	e8 fc 47 00 00       	call   c01048bb <vfprintf>
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
c01000f0:	68 7c 4b 10 c0       	push   $0xc0104b7c
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
c0100371:	68 9f 4b 10 c0       	push   $0xc0104b9f
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
c0100415:	68 9f 4b 10 c0       	push   $0xc0104b9f
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
c0100448:	b8 1b 48 10 c0       	mov    $0xc010481b,%eax
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
c0100583:	e8 33 43 00 00       	call   c01048bb <vfprintf>
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
c01005d6:	68 b8 4b 10 c0       	push   $0xc0104bb8
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
c010060c:	68 dc 4b 10 c0       	push   $0xc0104bdc
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
c010064e:	68 00 4c 10 c0       	push   $0xc0104c00
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
c0100682:	68 1f 4c 10 c0       	push   $0xc0104c1f
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
c010074d:	68 35 4c 10 c0       	push   $0xc0104c35
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
c01007ae:	68 35 4c 10 c0       	push   $0xc0104c35
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
c010089a:	68 50 4c 10 c0       	push   $0xc0104c50
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
c010097f:	68 35 4c 10 c0       	push   $0xc0104c35
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
c01009fb:	68 35 4c 10 c0       	push   $0xc0104c35
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
c0100b9d:	68 35 4c 10 c0       	push   $0xc0104c35
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
c0100c27:	68 35 4c 10 c0       	push   $0xc0104c35
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
c0100cd9:	68 35 4c 10 c0       	push   $0xc0104c35
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
c0100e4f:	68 35 4c 10 c0       	push   $0xc0104c35
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
c0100f53:	e8 44 2c 00 00       	call   c0103b9c <ll_pop>
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
c0100f71:	e8 88 2c 00 00       	call   c0103bfe <ll_entail>
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
c0100fb1:	e8 e6 2b 00 00       	call   c0103b9c <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 c8 74 15 c0       	push   $0xc01574c8
c0100fc7:	e8 32 2c 00 00       	call   c0103bfe <ll_entail>
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
c0101010:	e8 e9 2b 00 00       	call   c0103bfe <ll_entail>
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
c01010cf:	e8 c8 2a 00 00       	call   c0103b9c <ll_pop>
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
c010112e:	e8 cb 2a 00 00       	call   c0103bfe <ll_entail>
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
c0101184:	e8 75 2a 00 00       	call   c0103bfe <ll_entail>
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
c01011d0:	e8 7a 23 00 00       	call   c010354f <do_syscall>
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
c01011e5:	e8 a9 34 00 00       	call   c0104693 <do_timer>
		do_scheduler();
c01011ea:	e8 bc fe ff ff       	call   c01010ab <do_scheduler>
c01011ef:	e9 83 00 00 00       	jmp    c0101277 <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c01011f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f7:	8b 40 30             	mov    0x30(%eax),%eax
c01011fa:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c01011ff:	75 76                	jne    c0101277 <irq_handle+0xd9>
c0101201:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101208:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010120b:	89 c2                	mov    %eax,%edx
c010120d:	ec                   	in     (%dx),%al
c010120e:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0101211:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0101215:	0f b6 c0             	movzbl %al,%eax
c0101218:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010121b:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101225:	89 c2                	mov    %eax,%edx
c0101227:	ec                   	in     (%dx),%al
c0101228:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c010122b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c010122f:	0f b6 c0             	movzbl %al,%eax
c0101232:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0101235:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101238:	83 c8 80             	or     $0xffffff80,%eax
c010123b:	0f b6 c0             	movzbl %al,%eax
c010123e:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0101245:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101248:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010124c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010124f:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0101250:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101253:	0f b6 c0             	movzbl %al,%eax
c0101256:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c010125d:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0101260:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101264:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101267:	ee                   	out    %al,(%dx)
		press_key(code);
c0101268:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010126b:	83 ec 0c             	sub    $0xc,%esp
c010126e:	50                   	push   %eax
c010126f:	e8 51 1f 00 00       	call   c01031c5 <press_key>
c0101274:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	//if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
	if((tf->irq == 0x80) && (tf->eax != SYS_PRINT_CHAR)){
c0101277:	8b 45 08             	mov    0x8(%ebp),%eax
c010127a:	8b 40 30             	mov    0x30(%eax),%eax
c010127d:	3d 80 00 00 00       	cmp    $0x80,%eax
c0101282:	75 12                	jne    c0101296 <irq_handle+0xf8>
c0101284:	8b 45 08             	mov    0x8(%ebp),%eax
c0101287:	8b 40 1c             	mov    0x1c(%eax),%eax
c010128a:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c010128f:	74 05                	je     c0101296 <irq_handle+0xf8>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0101291:	e8 15 fe ff ff       	call   c01010ab <do_scheduler>
	}
}
c0101296:	c9                   	leave  
c0101297:	c3                   	ret    

c0101298 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0101298:	55                   	push   %ebp
c0101299:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c010129b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010129e:	83 e8 01             	sub    $0x1,%eax
c01012a1:	66 a3 08 70 15 c0    	mov    %ax,0xc0157008
	data[1] = (uint32_t)addr;
c01012a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01012aa:	66 a3 0a 70 15 c0    	mov    %ax,0xc015700a
	data[2] = ((uint32_t)addr) >> 16;
c01012b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b3:	c1 e8 10             	shr    $0x10,%eax
c01012b6:	66 a3 0c 70 15 c0    	mov    %ax,0xc015700c
	asm volatile("lidt (%0)" : : "r"(data));
c01012bc:	b8 08 70 15 c0       	mov    $0xc0157008,%eax
c01012c1:	0f 01 18             	lidtl  (%eax)
}
c01012c4:	5d                   	pop    %ebp
c01012c5:	c3                   	ret    

c01012c6 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c01012c6:	55                   	push   %ebp
c01012c7:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c01012c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01012cc:	89 c2                	mov    %eax,%edx
c01012ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d1:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c01012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01012de:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e1:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c01012e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e8:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c01012ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ef:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012f3:	83 e2 f0             	and    $0xfffffff0,%edx
c01012f6:	83 ca 0e             	or     $0xe,%edx
c01012f9:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c01012fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ff:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101303:	83 e2 ef             	and    $0xffffffef,%edx
c0101306:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0101309:	8b 45 14             	mov    0x14(%ebp),%eax
c010130c:	83 e0 03             	and    $0x3,%eax
c010130f:	89 c2                	mov    %eax,%edx
c0101311:	8b 45 08             	mov    0x8(%ebp),%eax
c0101314:	83 e2 03             	and    $0x3,%edx
c0101317:	89 d1                	mov    %edx,%ecx
c0101319:	c1 e1 05             	shl    $0x5,%ecx
c010131c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101320:	83 e2 9f             	and    $0xffffff9f,%edx
c0101323:	09 ca                	or     %ecx,%edx
c0101325:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0101328:	8b 45 08             	mov    0x8(%ebp),%eax
c010132b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010132f:	83 ca 80             	or     $0xffffff80,%edx
c0101332:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0101335:	8b 45 10             	mov    0x10(%ebp),%eax
c0101338:	c1 e8 10             	shr    $0x10,%eax
c010133b:	89 c2                	mov    %eax,%edx
c010133d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101340:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101344:	5d                   	pop    %ebp
c0101345:	c3                   	ret    

c0101346 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0101346:	55                   	push   %ebp
c0101347:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0101349:	8b 45 10             	mov    0x10(%ebp),%eax
c010134c:	89 c2                	mov    %eax,%edx
c010134e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101351:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0101354:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101357:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010135e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101361:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0101365:	8b 45 08             	mov    0x8(%ebp),%eax
c0101368:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c010136c:	8b 45 08             	mov    0x8(%ebp),%eax
c010136f:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101373:	83 ca 0f             	or     $0xf,%edx
c0101376:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0101379:	8b 45 08             	mov    0x8(%ebp),%eax
c010137c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101380:	83 e2 ef             	and    $0xffffffef,%edx
c0101383:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0101386:	8b 45 14             	mov    0x14(%ebp),%eax
c0101389:	83 e0 03             	and    $0x3,%eax
c010138c:	89 c2                	mov    %eax,%edx
c010138e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101391:	83 e2 03             	and    $0x3,%edx
c0101394:	89 d1                	mov    %edx,%ecx
c0101396:	c1 e1 05             	shl    $0x5,%ecx
c0101399:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010139d:	83 e2 9f             	and    $0xffffff9f,%edx
c01013a0:	09 ca                	or     %ecx,%edx
c01013a2:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01013a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a8:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01013ac:	83 ca 80             	or     $0xffffff80,%edx
c01013af:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c01013b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01013b5:	c1 e8 10             	shr    $0x10,%eax
c01013b8:	89 c2                	mov    %eax,%edx
c01013ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01013bd:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c01013c1:	5d                   	pop    %ebp
c01013c2:	c3                   	ret    

c01013c3 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c01013c3:	55                   	push   %ebp
c01013c4:	89 e5                	mov    %esp,%ebp
c01013c6:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c01013c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013d0:	eb 22                	jmp    c01013f4 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c01013d2:	ba f9 47 10 c0       	mov    $0xc01047f9,%edx
c01013d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01013da:	c1 e0 03             	shl    $0x3,%eax
c01013dd:	05 80 9d 1b c0       	add    $0xc01b9d80,%eax
c01013e2:	6a 00                	push   $0x0
c01013e4:	52                   	push   %edx
c01013e5:	6a 01                	push   $0x1
c01013e7:	50                   	push   %eax
c01013e8:	e8 59 ff ff ff       	call   c0101346 <set_trap>
c01013ed:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c01013f0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013f4:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01013fb:	7e d5                	jle    c01013d2 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c01013fd:	b8 41 47 10 c0       	mov    $0xc0104741,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 80 9d 1b c0       	push   $0xc01b9d80
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 4a 47 10 c0       	mov    $0xc010474a,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 88 9d 1b c0       	push   $0xc01b9d88
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 53 47 10 c0       	mov    $0xc0104753,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 90 9d 1b c0       	push   $0xc01b9d90
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 5c 47 10 c0       	mov    $0xc010475c,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 98 9d 1b c0       	push   $0xc01b9d98
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 65 47 10 c0       	mov    $0xc0104765,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 a0 9d 1b c0       	push   $0xc01b9da0
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 6e 47 10 c0       	mov    $0xc010476e,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 a8 9d 1b c0       	push   $0xc01b9da8
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 77 47 10 c0       	mov    $0xc0104777,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 b0 9d 1b c0       	push   $0xc01b9db0
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 80 47 10 c0       	mov    $0xc0104780,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 b8 9d 1b c0       	push   $0xc01b9db8
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 89 47 10 c0       	mov    $0xc0104789,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 c0 9d 1b c0       	push   $0xc01b9dc0
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 92 47 10 c0       	mov    $0xc0104792,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 c8 9d 1b c0       	push   $0xc01b9dc8
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 9b 47 10 c0       	mov    $0xc010479b,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 d0 9d 1b c0       	push   $0xc01b9dd0
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 a4 47 10 c0       	mov    $0xc01047a4,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 d8 9d 1b c0       	push   $0xc01b9dd8
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 ad 47 10 c0       	mov    $0xc01047ad,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 e0 9d 1b c0       	push   $0xc01b9de0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 b6 47 10 c0       	mov    $0xc01047b6,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 e8 9d 1b c0       	push   $0xc01b9de8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 c8 47 10 c0       	mov    $0xc01047c8,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 80 a1 1b c0       	push   $0xc01ba180
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 d5 47 10 c0       	mov    $0xc01047d5,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 80 9e 1b c0       	push   $0xc01b9e80
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 e1 47 10 c0       	mov    $0xc01047e1,%eax
c0101572:	6a 00                	push   $0x0
c0101574:	50                   	push   %eax
c0101575:	6a 01                	push   $0x1
c0101577:	68 88 9e 1b c0       	push   $0xc01b9e88
c010157c:	e8 45 fd ff ff       	call   c01012c6 <set_intr>
c0101581:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101584:	68 00 08 00 00       	push   $0x800
c0101589:	68 80 9d 1b c0       	push   $0xc01b9d80
c010158e:	e8 05 fd ff ff       	call   c0101298 <save_idt>
c0101593:	83 c4 08             	add    $0x8,%esp
}
c0101596:	c9                   	leave  
c0101597:	c3                   	ret    

c0101598 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101598:	55                   	push   %ebp
c0101599:	89 e5                	mov    %esp,%ebp
c010159b:	83 ec 10             	sub    $0x10,%esp
c010159e:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01015a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015a8:	89 c2                	mov    %eax,%edx
c01015aa:	ec                   	in     (%dx),%al
c01015ab:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01015ae:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01015b2:	0f b6 c0             	movzbl %al,%eax
c01015b5:	83 e0 20             	and    $0x20,%eax
c01015b8:	85 c0                	test   %eax,%eax
c01015ba:	0f 95 c0             	setne  %al
c01015bd:	0f b6 c0             	movzbl %al,%eax
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <serial_printc>:

static inline
void serial_printc(char ch) {
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 14             	sub    $0x14,%esp
c01015c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01015cb:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01015ce:	90                   	nop
c01015cf:	e8 c4 ff ff ff       	call   c0101598 <serial_idle>
c01015d4:	85 c0                	test   %eax,%eax
c01015d6:	74 f7                	je     c01015cf <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01015d8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01015dc:	0f b6 c0             	movzbl %al,%eax
c01015df:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01015e6:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01015e9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01015ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01015f0:	ee                   	out    %al,(%dx)
}
c01015f1:	c9                   	leave  
c01015f2:	c3                   	ret    

c01015f3 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01015f3:	55                   	push   %ebp
c01015f4:	89 e5                	mov    %esp,%ebp
c01015f6:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01015f9:	8d 45 0c             	lea    0xc(%ebp),%eax
c01015fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01015ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101602:	83 ec 04             	sub    $0x4,%esp
c0101605:	ff 75 f4             	pushl  -0xc(%ebp)
c0101608:	50                   	push   %eax
c0101609:	68 c2 15 10 c0       	push   $0xc01015c2
c010160e:	e8 a8 32 00 00       	call   c01048bb <vfprintf>
c0101613:	83 c4 10             	add    $0x10,%esp
}
c0101616:	c9                   	leave  
c0101617:	c3                   	ret    

c0101618 <memcpy2>:
}

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}
static inline void memcpy2(void* dst, void* src, int len){
c0101618:	55                   	push   %ebp
c0101619:	89 e5                	mov    %esp,%ebp
c010161b:	57                   	push   %edi
c010161c:	56                   	push   %esi
c010161d:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c010161e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101621:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101624:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101627:	89 c1                	mov    %eax,%ecx
c0101629:	89 d6                	mov    %edx,%esi
c010162b:	89 df                	mov    %ebx,%edi
c010162d:	fc                   	cld    
c010162e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c0101630:	5b                   	pop    %ebx
c0101631:	5e                   	pop    %esi
c0101632:	5f                   	pop    %edi
c0101633:	5d                   	pop    %ebp
c0101634:	c3                   	ret    

c0101635 <memset2>:

static inline void memset2(void* dst, uint32_t src, int len){
c0101635:	55                   	push   %ebp
c0101636:	89 e5                	mov    %esp,%ebp
c0101638:	57                   	push   %edi
c0101639:	53                   	push   %ebx
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
c010163a:	8b 55 10             	mov    0x10(%ebp),%edx
c010163d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101640:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101643:	89 d1                	mov    %edx,%ecx
c0101645:	89 df                	mov    %ebx,%edi
c0101647:	fc                   	cld    
c0101648:	f3 aa                	rep stos %al,%es:(%edi)
}
c010164a:	5b                   	pop    %ebx
c010164b:	5f                   	pop    %edi
c010164c:	5d                   	pop    %ebp
c010164d:	c3                   	ret    

c010164e <strcmp>:
static inline int strcmp(const char* s1, const char* s2)
{
c010164e:	55                   	push   %ebp
c010164f:	89 e5                	mov    %esp,%ebp
    while(*s1 && (*s1==*s2))
c0101651:	eb 08                	jmp    c010165b <strcmp+0xd>
        s1++,s2++;
c0101653:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0101657:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
c010165b:	8b 45 08             	mov    0x8(%ebp),%eax
c010165e:	0f b6 00             	movzbl (%eax),%eax
c0101661:	84 c0                	test   %al,%al
c0101663:	74 10                	je     c0101675 <strcmp+0x27>
c0101665:	8b 45 08             	mov    0x8(%ebp),%eax
c0101668:	0f b6 10             	movzbl (%eax),%edx
c010166b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010166e:	0f b6 00             	movzbl (%eax),%eax
c0101671:	38 c2                	cmp    %al,%dl
c0101673:	74 de                	je     c0101653 <strcmp+0x5>
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
c0101675:	8b 45 08             	mov    0x8(%ebp),%eax
c0101678:	0f b6 00             	movzbl (%eax),%eax
c010167b:	0f b6 d0             	movzbl %al,%edx
c010167e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101681:	0f b6 00             	movzbl (%eax),%eax
c0101684:	0f b6 c0             	movzbl %al,%eax
c0101687:	29 c2                	sub    %eax,%edx
c0101689:	89 d0                	mov    %edx,%eax
}
c010168b:	5d                   	pop    %ebp
c010168c:	c3                   	ret    

c010168d <strcpy>:
static inline void strcpy(char* dest, const char* source) 
{
c010168d:	55                   	push   %ebp
c010168e:	89 e5                	mov    %esp,%ebp
c0101690:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c0101693:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c010169a:	eb 04                	jmp    c01016a0 <strcpy+0x13>
    {
        i++;
c010169c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c01016a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01016a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a6:	01 d0                	add    %edx,%eax
c01016a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c01016ab:	8b 55 0c             	mov    0xc(%ebp),%edx
c01016ae:	01 ca                	add    %ecx,%edx
c01016b0:	0f b6 12             	movzbl (%edx),%edx
c01016b3:	88 10                	mov    %dl,(%eax)
c01016b5:	0f b6 00             	movzbl (%eax),%eax
c01016b8:	84 c0                	test   %al,%al
c01016ba:	75 e0                	jne    c010169c <strcpy+0xf>
    {
        i++;
    } 
}
c01016bc:	c9                   	leave  
c01016bd:	c3                   	ret    

c01016be <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c01016be:	55                   	push   %ebp
c01016bf:	89 e5                	mov    %esp,%ebp
c01016c1:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c01016c4:	90                   	nop
c01016c5:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01016cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016cf:	89 c2                	mov    %eax,%edx
c01016d1:	ec                   	in     (%dx),%al
c01016d2:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01016d5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016d9:	0f b6 c0             	movzbl %al,%eax
c01016dc:	25 c0 00 00 00       	and    $0xc0,%eax
c01016e1:	83 f8 40             	cmp    $0x40,%eax
c01016e4:	75 df                	jne    c01016c5 <waitdisk+0x7>
}
c01016e6:	c9                   	leave  
c01016e7:	c3                   	ret    

c01016e8 <readsect>:

static inline void
readsect(void *dst, int offset) {
c01016e8:	55                   	push   %ebp
c01016e9:	89 e5                	mov    %esp,%ebp
c01016eb:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01016ee:	e8 cb ff ff ff       	call   c01016be <waitdisk>
c01016f3:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01016fa:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01016fe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101702:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101705:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101706:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101709:	0f b6 c0             	movzbl %al,%eax
c010170c:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101713:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101716:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010171a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010171d:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c010171e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101721:	c1 f8 08             	sar    $0x8,%eax
c0101724:	0f b6 c0             	movzbl %al,%eax
c0101727:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c010172e:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101731:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101735:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101738:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010173c:	c1 f8 10             	sar    $0x10,%eax
c010173f:	0f b6 c0             	movzbl %al,%eax
c0101742:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101749:	88 45 df             	mov    %al,-0x21(%ebp)
c010174c:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101750:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101753:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101757:	c1 f8 18             	sar    $0x18,%eax
c010175a:	83 c8 e0             	or     $0xffffffe0,%eax
c010175d:	0f b6 c0             	movzbl %al,%eax
c0101760:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101767:	88 45 d7             	mov    %al,-0x29(%ebp)
c010176a:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010176e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101779:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c010177d:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101781:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101785:	e8 34 ff ff ff       	call   c01016be <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010178a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101791:	eb 29                	jmp    c01017bc <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101793:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101796:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010179d:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c01017a3:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c01017aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01017ad:	89 c2                	mov    %eax,%edx
c01017af:	ed                   	in     (%dx),%eax
c01017b0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c01017b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01017b6:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01017b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01017bc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01017c0:	7e d1                	jle    c0101793 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c01017c2:	c9                   	leave  
c01017c3:	c3                   	ret    

c01017c4 <writesect>:
static inline void
writesect(void *dst, int offset) {
c01017c4:	55                   	push   %ebp
c01017c5:	89 e5                	mov    %esp,%ebp
c01017c7:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01017ca:	e8 ef fe ff ff       	call   c01016be <waitdisk>
c01017cf:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01017d6:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01017da:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01017de:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01017e1:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017e5:	0f b6 c0             	movzbl %al,%eax
c01017e8:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01017ef:	88 45 ef             	mov    %al,-0x11(%ebp)
c01017f2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01017f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017f9:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017fd:	c1 f8 08             	sar    $0x8,%eax
c0101800:	0f b6 c0             	movzbl %al,%eax
c0101803:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c010180a:	88 45 e7             	mov    %al,-0x19(%ebp)
c010180d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101811:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101814:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101815:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101818:	c1 f8 10             	sar    $0x10,%eax
c010181b:	0f b6 c0             	movzbl %al,%eax
c010181e:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101825:	88 45 df             	mov    %al,-0x21(%ebp)
c0101828:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c010182c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101830:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101833:	c1 f8 18             	sar    $0x18,%eax
c0101836:	83 c8 e0             	or     $0xffffffe0,%eax
c0101839:	0f b6 c0             	movzbl %al,%eax
c010183c:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101843:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101846:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c010184a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010184d:	ee                   	out    %al,(%dx)
c010184e:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101855:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
c0101859:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c010185d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101860:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x30);

    waitdisk();
c0101861:	e8 58 fe ff ff       	call   c01016be <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101866:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010186d:	eb 26                	jmp    c0101895 <writesect+0xd1>
        outl(0x1F0, ((int *)(dst))[i]);
c010186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101872:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101879:	8b 45 08             	mov    0x8(%ebp),%eax
c010187c:	01 d0                	add    %edx,%eax
c010187e:	8b 00                	mov    (%eax),%eax
c0101880:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)
c0101887:	89 45 c4             	mov    %eax,-0x3c(%ebp)
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
c010188a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010188d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0101890:	ef                   	out    %eax,(%dx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x30);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101891:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101895:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101899:	7e d4                	jle    c010186f <writesect+0xab>
        outl(0x1F0, ((int *)(dst))[i]);
    }
}
c010189b:	c9                   	leave  
c010189c:	c3                   	ret    

c010189d <readBitmap>:
struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
c010189d:	55                   	push   %ebp
c010189e:	89 e5                	mov    %esp,%ebp
c01018a0:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018aa:	eb 22                	jmp    c01018ce <readBitmap+0x31>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018af:	c1 e0 09             	shl    $0x9,%eax
c01018b2:	8d 50 01             	lea    0x1(%eax),%edx
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	c1 e0 09             	shl    $0x9,%eax
c01018bb:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c01018c0:	52                   	push   %edx
c01018c1:	50                   	push   %eax
c01018c2:	e8 21 fe ff ff       	call   c01016e8 <readsect>
c01018c7:	83 c4 08             	add    $0x8,%esp
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018ce:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01018d5:	7e d5                	jle    c01018ac <readBitmap+0xf>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c01018d7:	c9                   	leave  
c01018d8:	c3                   	ret    

c01018d9 <saveBitmap>:

void saveBitmap(){
c01018d9:	55                   	push   %ebp
c01018da:	89 e5                	mov    %esp,%ebp
c01018dc:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e6:	eb 22                	jmp    c010190a <saveBitmap+0x31>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	c1 e0 09             	shl    $0x9,%eax
c01018ee:	8d 50 01             	lea    0x1(%eax),%edx
c01018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f4:	c1 e0 09             	shl    $0x9,%eax
c01018f7:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c01018fc:	52                   	push   %edx
c01018fd:	50                   	push   %eax
c01018fe:	e8 c1 fe ff ff       	call   c01017c4 <writesect>
c0101903:	83 c4 08             	add    $0x8,%esp
	}
}

void saveBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c0101906:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010190a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101911:	7e d5                	jle    c01018e8 <saveBitmap+0xf>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c0101913:	c9                   	leave  
c0101914:	c3                   	ret    

c0101915 <readDir>:
void readDir(int offset){
c0101915:	55                   	push   %ebp
c0101916:	89 e5                	mov    %esp,%ebp
	readsect(dir.entries, LOC_DIR(offset));
c0101918:	8b 45 08             	mov    0x8(%ebp),%eax
c010191b:	05 01 01 00 00       	add    $0x101,%eax
c0101920:	50                   	push   %eax
c0101921:	68 80 d7 1f c0       	push   $0xc01fd780
c0101926:	e8 bd fd ff ff       	call   c01016e8 <readsect>
c010192b:	83 c4 08             	add    $0x8,%esp
}
c010192e:	c9                   	leave  
c010192f:	c3                   	ret    

c0101930 <saveDir>:
void saveDir(int offset){
c0101930:	55                   	push   %ebp
c0101931:	89 e5                	mov    %esp,%ebp
	writesect(dir.entries, LOC_DIR(offset));
c0101933:	8b 45 08             	mov    0x8(%ebp),%eax
c0101936:	05 01 01 00 00       	add    $0x101,%eax
c010193b:	50                   	push   %eax
c010193c:	68 80 d7 1f c0       	push   $0xc01fd780
c0101941:	e8 7e fe ff ff       	call   c01017c4 <writesect>
c0101946:	83 c4 08             	add    $0x8,%esp
}
c0101949:	c9                   	leave  
c010194a:	c3                   	ret    

c010194b <readINode>:
void readINode(int offset){
c010194b:	55                   	push   %ebp
c010194c:	89 e5                	mov    %esp,%ebp
	readsect(inode.data_block_offsets, LOC_INODE(offset));
c010194e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101951:	05 01 02 00 00       	add    $0x201,%eax
c0101956:	50                   	push   %eax
c0101957:	68 80 d9 1f c0       	push   $0xc01fd980
c010195c:	e8 87 fd ff ff       	call   c01016e8 <readsect>
c0101961:	83 c4 08             	add    $0x8,%esp
}
c0101964:	c9                   	leave  
c0101965:	c3                   	ret    

c0101966 <saveINode>:
void saveINode(int offset){
c0101966:	55                   	push   %ebp
c0101967:	89 e5                	mov    %esp,%ebp
	writesect(inode.data_block_offsets, LOC_INODE(offset));
c0101969:	8b 45 08             	mov    0x8(%ebp),%eax
c010196c:	05 01 02 00 00       	add    $0x201,%eax
c0101971:	50                   	push   %eax
c0101972:	68 80 d9 1f c0       	push   $0xc01fd980
c0101977:	e8 48 fe ff ff       	call   c01017c4 <writesect>
c010197c:	83 c4 08             	add    $0x8,%esp
}
c010197f:	c9                   	leave  
c0101980:	c3                   	ret    

c0101981 <readData>:
void readData(int offset){
c0101981:	55                   	push   %ebp
c0101982:	89 e5                	mov    %esp,%ebp
	readsect(buffer, LOC_DATA(offset));
c0101984:	8b 45 08             	mov    0x8(%ebp),%eax
c0101987:	05 01 03 00 00       	add    $0x301,%eax
c010198c:	50                   	push   %eax
c010198d:	68 80 d5 1f c0       	push   $0xc01fd580
c0101992:	e8 51 fd ff ff       	call   c01016e8 <readsect>
c0101997:	83 c4 08             	add    $0x8,%esp
}
c010199a:	c9                   	leave  
c010199b:	c3                   	ret    

c010199c <saveData>:
void saveData(int offset){
c010199c:	55                   	push   %ebp
c010199d:	89 e5                	mov    %esp,%ebp
	writesect(buffer, LOC_DATA(offset));
c010199f:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a2:	05 01 03 00 00       	add    $0x301,%eax
c01019a7:	50                   	push   %eax
c01019a8:	68 80 d5 1f c0       	push   $0xc01fd580
c01019ad:	e8 12 fe ff ff       	call   c01017c4 <writesect>
c01019b2:	83 c4 08             	add    $0x8,%esp
}
c01019b5:	c9                   	leave  
c01019b6:	c3                   	ret    

c01019b7 <INodeAlloc>:
int INodeAlloc(){
c01019b7:	55                   	push   %ebp
c01019b8:	89 e5                	mov    %esp,%ebp
c01019ba:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c01019bd:	e8 db fe ff ff       	call   c010189d <readBitmap>
	int i = 0;
c01019c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_INODE; i++){
c01019c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019d0:	eb 69                	jmp    c0101a3b <INodeAlloc+0x84>
		int sec = LOC_INODE(i);
c01019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d5:	05 01 02 00 00       	add    $0x201,%eax
c01019da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c01019dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019e0:	c1 f8 03             	sar    $0x3,%eax
c01019e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c01019e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019e9:	83 e0 07             	and    $0x7,%eax
c01019ec:	ba 01 00 00 00       	mov    $0x1,%edx
c01019f1:	89 c1                	mov    %eax,%ecx
c01019f3:	d3 e2                	shl    %cl,%edx
c01019f5:	89 d0                	mov    %edx,%eax
c01019f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c01019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019fd:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a02:	0f b6 00             	movzbl (%eax),%eax
c0101a05:	0f b6 c0             	movzbl %al,%eax
c0101a08:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a0b:	85 c0                	test   %eax,%eax
c0101a0d:	75 28                	jne    c0101a37 <INodeAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a12:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a17:	0f b6 00             	movzbl (%eax),%eax
c0101a1a:	89 c2                	mov    %eax,%edx
c0101a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a1f:	09 d0                	or     %edx,%eax
c0101a21:	89 c2                	mov    %eax,%edx
c0101a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a26:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a2b:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101a2d:	e8 a7 fe ff ff       	call   c01018d9 <saveBitmap>
			return i;
c0101a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a35:	eb 12                	jmp    c0101a49 <INodeAlloc+0x92>
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
c0101a37:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a3b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a42:	7e 8e                	jle    c01019d2 <INodeAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101a49:	c9                   	leave  
c0101a4a:	c3                   	ret    

c0101a4b <dataAlloc>:
int dataAlloc(){
c0101a4b:	55                   	push   %ebp
c0101a4c:	89 e5                	mov    %esp,%ebp
c0101a4e:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c0101a51:	e8 47 fe ff ff       	call   c010189d <readBitmap>
	int i = 0;
c0101a56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_DATA; i++){
c0101a5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a64:	eb 69                	jmp    c0101acf <dataAlloc+0x84>
		int sec = LOC_DATA(i);
c0101a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a69:	05 01 03 00 00       	add    $0x301,%eax
c0101a6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c0101a71:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a74:	c1 f8 03             	sar    $0x3,%eax
c0101a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a7d:	83 e0 07             	and    $0x7,%eax
c0101a80:	ba 01 00 00 00       	mov    $0x1,%edx
c0101a85:	89 c1                	mov    %eax,%ecx
c0101a87:	d3 e2                	shl    %cl,%edx
c0101a89:	89 d0                	mov    %edx,%eax
c0101a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a91:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101a96:	0f b6 00             	movzbl (%eax),%eax
c0101a99:	0f b6 c0             	movzbl %al,%eax
c0101a9c:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a9f:	85 c0                	test   %eax,%eax
c0101aa1:	75 28                	jne    c0101acb <dataAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aa6:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101aab:	0f b6 00             	movzbl (%eax),%eax
c0101aae:	89 c2                	mov    %eax,%edx
c0101ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ab3:	09 d0                	or     %edx,%eax
c0101ab5:	89 c2                	mov    %eax,%edx
c0101ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aba:	05 80 a5 1b c0       	add    $0xc01ba580,%eax
c0101abf:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101ac1:	e8 13 fe ff ff       	call   c01018d9 <saveBitmap>
			return i;
c0101ac6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ac9:	eb 12                	jmp    c0101add <dataAlloc+0x92>
	return -1;
}
int dataAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
c0101acb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101acf:	81 7d fc ff 7f 00 00 	cmpl   $0x7fff,-0x4(%ebp)
c0101ad6:	7e 8e                	jle    c0101a66 <dataAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101add:	c9                   	leave  
c0101ade:	c3                   	ret    

c0101adf <fs_open_kr>:

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
c0101adf:	55                   	push   %ebp
c0101ae0:	89 e5                	mov    %esp,%ebp
c0101ae2:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0101ae5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101aec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0101af3:	eb 4c                	jmp    c0101b41 <fs_open_kr+0x62>
		readDir(dir_offset);
c0101af5:	ff 75 fc             	pushl  -0x4(%ebp)
c0101af8:	e8 18 fe ff ff       	call   c0101915 <readDir>
c0101afd:	83 c4 04             	add    $0x4,%esp

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b00:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101b07:	eb 2c                	jmp    c0101b35 <fs_open_kr+0x56>
			//printk("%d %d", dir_offset, entry_offset);
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
c0101b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b0c:	c1 e0 05             	shl    $0x5,%eax
c0101b0f:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101b14:	ff 75 08             	pushl  0x8(%ebp)
c0101b17:	50                   	push   %eax
c0101b18:	e8 31 fb ff ff       	call   c010164e <strcmp>
c0101b1d:	83 c4 08             	add    $0x8,%esp
c0101b20:	85 c0                	test   %eax,%eax
c0101b22:	75 0d                	jne    c0101b31 <fs_open_kr+0x52>
				goto OUT_OF_LOOP;
c0101b24:	90                   	nop
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b2c:	e9 2f 01 00 00       	jmp    c0101c60 <fs_open_kr+0x181>
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b31:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101b35:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b38:	83 f8 0f             	cmp    $0xf,%eax
c0101b3b:	76 cc                	jbe    c0101b09 <fs_open_kr+0x2a>
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
c0101b3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0101b41:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101b48:	7e ab                	jle    c0101af5 <fs_open_kr+0x16>
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
c0101b4a:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0101b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101b50:	e9 1d 01 00 00       	jmp    c0101c72 <fs_open_kr+0x193>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b58:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b5e:	05 20 02 00 00       	add    $0x220,%eax
c0101b63:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101b68:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0101b6c:	84 c0                	test   %al,%al
c0101b6e:	0f 85 e8 00 00 00    	jne    c0101c5c <fs_open_kr+0x17d>
			fs[i].used = 1;
c0101b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b77:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b7d:	05 20 02 00 00       	add    $0x220,%eax
c0101b82:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101b87:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b8e:	c1 e0 05             	shl    $0x5,%eax
c0101b91:	83 c0 10             	add    $0x10,%eax
c0101b94:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101b99:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b9f:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101ba5:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101bab:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101bb1:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bb7:	c1 e0 05             	shl    $0x5,%eax
c0101bba:	8d 90 80 d7 1f c0    	lea    -0x3fe02880(%eax),%edx
c0101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc3:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101bc9:	05 10 02 00 00       	add    $0x210,%eax
c0101bce:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101bd3:	83 c0 04             	add    $0x4,%eax
c0101bd6:	52                   	push   %edx
c0101bd7:	50                   	push   %eax
c0101bd8:	e8 b0 fa ff ff       	call   c010168d <strcpy>
c0101bdd:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101be0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101be3:	c1 e0 05             	shl    $0x5,%eax
c0101be6:	83 c0 10             	add    $0x10,%eax
c0101be9:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0101bee:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bf4:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101bfa:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c00:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c06:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("$%d %d$\n", fs[i].file_size, fs[i].inode_offset);
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0c:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c12:	05 00 02 00 00       	add    $0x200,%eax
c0101c17:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0101c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c28:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c2e:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c34:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c3a:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0101c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c43:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c49:	81 c2 10 02 00 00    	add    $0x210,%edx
c0101c4f:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0101c55:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c5a:	eb 16                	jmp    c0101c72 <fs_open_kr+0x193>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101c5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c60:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0101c67:	0f 8e e8 fe ff ff    	jle    c0101b55 <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101c72:	c9                   	leave  
c0101c73:	c3                   	ret    

c0101c74 <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101c74:	55                   	push   %ebp
c0101c75:	89 e5                	mov    %esp,%ebp
c0101c77:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7d:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c83:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101c88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c8e:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101c94:	50                   	push   %eax
c0101c95:	e8 b1 fc ff ff       	call   c010194b <readINode>
c0101c9a:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101c9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101ca4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ca7:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cad:	c1 e8 09             	shr    $0x9,%eax
c0101cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cb6:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cbc:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101cc4:	8b 55 10             	mov    0x10(%ebp),%edx
c0101cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cca:	01 d0                	add    %edx,%eax
c0101ccc:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101cd1:	0f 86 2d 01 00 00    	jbe    c0101e04 <fs_read_base_kr+0x190>
		readData(inode.data_block_offsets[D]);
c0101cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cda:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101ce1:	50                   	push   %eax
c0101ce2:	e8 9a fc ff ff       	call   c0101981 <readData>
c0101ce7:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101cea:	b8 00 02 00 00       	mov    $0x200,%eax
c0101cef:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cf2:	89 c2                	mov    %eax,%edx
c0101cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cf7:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101cfc:	52                   	push   %edx
c0101cfd:	50                   	push   %eax
c0101cfe:	ff 75 0c             	pushl  0xc(%ebp)
c0101d01:	e8 12 f9 ff ff       	call   c0101618 <memcpy2>
c0101d06:	83 c4 0c             	add    $0xc,%esp
		f->offset += BLOCK_SIZE-R;
c0101d09:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d0c:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d12:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d15:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d1e:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d27:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d2a:	05 00 02 00 00       	add    $0x200,%eax
c0101d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101d32:	8b 55 10             	mov    0x10(%ebp),%edx
c0101d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d38:	01 d0                	add    %edx,%eax
c0101d3a:	2d 00 02 00 00       	sub    $0x200,%eax
c0101d3f:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d42:	eb 63                	jmp    c0101da7 <fs_read_base_kr+0x133>
			D = f->offset >> 9;
c0101d44:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d47:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d4d:	c1 e8 09             	shr    $0x9,%eax
c0101d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
c0101d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d56:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101d5d:	50                   	push   %eax
c0101d5e:	e8 1e fc ff ff       	call   c0101981 <readData>
c0101d63:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101d66:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d6c:	01 d0                	add    %edx,%eax
c0101d6e:	68 00 02 00 00       	push   $0x200
c0101d73:	68 80 d5 1f c0       	push   $0xc01fd580
c0101d78:	50                   	push   %eax
c0101d79:	e8 9a f8 ff ff       	call   c0101618 <memcpy2>
c0101d7e:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101d81:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101d88:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d8b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d91:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d9a:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101da0:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101da7:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101dae:	7f 94                	jg     c0101d44 <fs_read_base_kr+0xd0>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101db0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101db3:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101db9:	c1 e8 09             	shr    $0x9,%eax
c0101dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dc2:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101dc9:	50                   	push   %eax
c0101dca:	e8 b2 fb ff ff       	call   c0101981 <readData>
c0101dcf:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dd8:	01 d0                	add    %edx,%eax
c0101dda:	ff 75 10             	pushl  0x10(%ebp)
c0101ddd:	68 80 d5 1f c0       	push   $0xc01fd580
c0101de2:	50                   	push   %eax
c0101de3:	e8 30 f8 ff ff       	call   c0101618 <memcpy2>
c0101de8:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dee:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101df4:	8b 45 10             	mov    0x10(%ebp),%eax
c0101df7:	01 c2                	add    %eax,%edx
c0101df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dfc:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101e02:	eb 41                	jmp    c0101e45 <fs_read_base_kr+0x1d1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e07:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101e0e:	50                   	push   %eax
c0101e0f:	e8 6d fb ff ff       	call   c0101981 <readData>
c0101e14:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e1a:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101e1f:	ff 75 10             	pushl  0x10(%ebp)
c0101e22:	50                   	push   %eax
c0101e23:	ff 75 0c             	pushl  0xc(%ebp)
c0101e26:	e8 ed f7 ff ff       	call   c0101618 <memcpy2>
c0101e2b:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101e2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e31:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e37:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e3a:	01 c2                	add    %eax,%edx
c0101e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e3f:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101e45:	c9                   	leave  
c0101e46:	c3                   	ret    

c0101e47 <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101e47:	55                   	push   %ebp
c0101e48:	89 e5                	mov    %esp,%ebp
c0101e4a:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e50:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101e56:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e61:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e67:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e6a:	01 c2                	add    %eax,%edx
c0101e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e6f:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101e75:	39 c2                	cmp    %eax,%edx
c0101e77:	72 19                	jb     c0101e92 <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e7c:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e85:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e8b:	29 c2                	sub    %eax,%edx
c0101e8d:	89 d0                	mov    %edx,%eax
c0101e8f:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	if(len == 0)
c0101e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0101e96:	75 07                	jne    c0101e9f <fs_read_kr+0x58>
		return -1;
c0101e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101e9d:	eb 14                	jmp    c0101eb3 <fs_read_kr+0x6c>
	fs_read_base_kr(fd, buf, len);
c0101e9f:	ff 75 10             	pushl  0x10(%ebp)
c0101ea2:	ff 75 0c             	pushl  0xc(%ebp)
c0101ea5:	ff 75 08             	pushl  0x8(%ebp)
c0101ea8:	e8 c7 fd ff ff       	call   c0101c74 <fs_read_base_kr>
c0101ead:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101eb0:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101eb3:	c9                   	leave  
c0101eb4:	c3                   	ret    

c0101eb5 <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101eb5:	55                   	push   %ebp
c0101eb6:	89 e5                	mov    %esp,%ebp
c0101eb8:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ebe:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101ec4:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0101ec9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ecf:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101ed5:	50                   	push   %eax
c0101ed6:	e8 70 fa ff ff       	call   c010194b <readINode>
c0101edb:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ee8:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101eee:	c1 e8 09             	shr    $0x9,%eax
c0101ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ef7:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101efd:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101f05:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f0b:	01 d0                	add    %edx,%eax
c0101f0d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f12:	0f 86 53 01 00 00    	jbe    c010206b <fs_write_base_kr+0x1b6>
		readData(inode.data_block_offsets[D]);
c0101f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f1b:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101f22:	50                   	push   %eax
c0101f23:	e8 59 fa ff ff       	call   c0101981 <readData>
c0101f28:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101f2b:	b8 00 02 00 00       	mov    $0x200,%eax
c0101f30:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f33:	89 c2                	mov    %eax,%edx
c0101f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f38:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0101f3d:	52                   	push   %edx
c0101f3e:	ff 75 0c             	pushl  0xc(%ebp)
c0101f41:	50                   	push   %eax
c0101f42:	e8 d1 f6 ff ff       	call   c0101618 <memcpy2>
c0101f47:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f4d:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101f54:	50                   	push   %eax
c0101f55:	e8 42 fa ff ff       	call   c010199c <saveData>
c0101f5a:	83 c4 04             	add    $0x4,%esp
		f->offset += BLOCK_SIZE-R;
c0101f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f60:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f66:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f69:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f72:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f7b:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f7e:	05 00 02 00 00       	add    $0x200,%eax
c0101f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101f86:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f8c:	01 d0                	add    %edx,%eax
c0101f8e:	2d 00 02 00 00       	sub    $0x200,%eax
c0101f93:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f96:	eb 63                	jmp    c0101ffb <fs_write_base_kr+0x146>
			D = f->offset >> 9;
c0101f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f9b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101fa1:	c1 e8 09             	shr    $0x9,%eax
c0101fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fad:	01 d0                	add    %edx,%eax
c0101faf:	68 00 02 00 00       	push   $0x200
c0101fb4:	50                   	push   %eax
c0101fb5:	68 80 d5 1f c0       	push   $0xc01fd580
c0101fba:	e8 59 f6 ff ff       	call   c0101618 <memcpy2>
c0101fbf:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fc5:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0101fcc:	50                   	push   %eax
c0101fcd:	e8 ca f9 ff ff       	call   c010199c <saveData>
c0101fd2:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c0101fd5:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101fdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fdf:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101fe5:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fee:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101ff4:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101ffb:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0102002:	7f 94                	jg     c0101f98 <fs_write_base_kr+0xe3>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0102004:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102007:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c010200d:	c1 e8 09             	shr    $0x9,%eax
c0102010:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0102013:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102016:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c010201d:	50                   	push   %eax
c010201e:	e8 5e f9 ff ff       	call   c0101981 <readData>
c0102023:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c0102026:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102029:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010202c:	01 d0                	add    %edx,%eax
c010202e:	ff 75 10             	pushl  0x10(%ebp)
c0102031:	50                   	push   %eax
c0102032:	68 80 d5 1f c0       	push   $0xc01fd580
c0102037:	e8 dc f5 ff ff       	call   c0101618 <memcpy2>
c010203c:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c010203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102042:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0102049:	50                   	push   %eax
c010204a:	e8 4d f9 ff ff       	call   c010199c <saveData>
c010204f:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0102052:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102055:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c010205b:	8b 45 10             	mov    0x10(%ebp),%eax
c010205e:	01 c2                	add    %eax,%edx
c0102060:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102063:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0102069:	eb 54                	jmp    c01020bf <fs_write_base_kr+0x20a>
	}else{
		readData(inode.data_block_offsets[D]);
c010206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010206e:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c0102075:	50                   	push   %eax
c0102076:	e8 06 f9 ff ff       	call   c0101981 <readData>
c010207b:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c010207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102081:	05 80 d5 1f c0       	add    $0xc01fd580,%eax
c0102086:	ff 75 10             	pushl  0x10(%ebp)
c0102089:	ff 75 0c             	pushl  0xc(%ebp)
c010208c:	50                   	push   %eax
c010208d:	e8 86 f5 ff ff       	call   c0101618 <memcpy2>
c0102092:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102095:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102098:	8b 04 85 80 d9 1f c0 	mov    -0x3fe02680(,%eax,4),%eax
c010209f:	50                   	push   %eax
c01020a0:	e8 f7 f8 ff ff       	call   c010199c <saveData>
c01020a5:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c01020a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020ab:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01020b4:	01 c2                	add    %eax,%edx
c01020b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020b9:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c01020bf:	c9                   	leave  
c01020c0:	c3                   	ret    

c01020c1 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c01020c1:	55                   	push   %ebp
c01020c2:	89 e5                	mov    %esp,%ebp
c01020c4:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01020c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ca:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01020d0:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01020d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	if(f->file_size == 0){
c01020d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020db:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01020e1:	85 c0                	test   %eax,%eax
c01020e3:	75 48                	jne    c010212d <fs_write_kr+0x6c>
		readINode(f->inode_offset);
c01020e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020e8:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020ee:	50                   	push   %eax
c01020ef:	e8 57 f8 ff ff       	call   c010194b <readINode>
c01020f4:	83 c4 04             	add    $0x4,%esp
		inode.data_block_offsets[0] = dataAlloc();
c01020f7:	e8 4f f9 ff ff       	call   c0101a4b <dataAlloc>
c01020fc:	a3 80 d9 1f c0       	mov    %eax,0xc01fd980
		saveINode(f->inode_offset);
c0102101:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102104:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010210a:	50                   	push   %eax
c010210b:	e8 56 f8 ff ff       	call   c0101966 <saveINode>
c0102110:	83 c4 04             	add    $0x4,%esp
		f->file_size = len>512?512:len;
c0102113:	8b 45 10             	mov    0x10(%ebp),%eax
c0102116:	3d 00 02 00 00       	cmp    $0x200,%eax
c010211b:	7e 05                	jle    c0102122 <fs_write_kr+0x61>
c010211d:	b8 00 02 00 00       	mov    $0x200,%eax
c0102122:	89 c2                	mov    %eax,%edx
c0102124:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102127:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
		//printk("legal high %d\n", f->file_size);
	}
	
	if(f->offset + len > f->file_size){
c010212d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102130:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102136:	8b 45 10             	mov    0x10(%ebp),%eax
c0102139:	01 c2                	add    %eax,%edx
c010213b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010213e:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102144:	39 c2                	cmp    %eax,%edx
c0102146:	0f 86 81 00 00 00    	jbe    c01021cd <fs_write_kr+0x10c>
		readINode(f->inode_offset);
c010214c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010214f:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102155:	50                   	push   %eax
c0102156:	e8 f0 f7 ff ff       	call   c010194b <readINode>
c010215b:	83 c4 04             	add    $0x4,%esp
		D1 = f->offset >> 9;
c010215e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102161:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0102167:	c1 e8 09             	shr    $0x9,%eax
c010216a:	89 45 fc             	mov    %eax,-0x4(%ebp)
		D2 = (f->offset + len) >> 9;
c010216d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102170:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102176:	8b 45 10             	mov    0x10(%ebp),%eax
c0102179:	01 d0                	add    %edx,%eax
c010217b:	c1 e8 09             	shr    $0x9,%eax
c010217e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		D1 += 1;
c0102181:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
		while(D1<=D2){
c0102185:	eb 15                	jmp    c010219c <fs_write_kr+0xdb>
			inode.data_block_offsets[D1] = dataAlloc();
c0102187:	e8 bf f8 ff ff       	call   c0101a4b <dataAlloc>
c010218c:	89 c2                	mov    %eax,%edx
c010218e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102191:	89 14 85 80 d9 1f c0 	mov    %edx,-0x3fe02680(,%eax,4)
			D1 ++;
c0102198:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	if(f->offset + len > f->file_size){
		readINode(f->inode_offset);
		D1 = f->offset >> 9;
		D2 = (f->offset + len) >> 9;
		D1 += 1;
		while(D1<=D2){
c010219c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010219f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01021a2:	7e e3                	jle    c0102187 <fs_write_kr+0xc6>
			inode.data_block_offsets[D1] = dataAlloc();
			D1 ++;
		}
		saveINode(f->inode_offset);
c01021a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021a7:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01021ad:	50                   	push   %eax
c01021ae:	e8 b3 f7 ff ff       	call   c0101966 <saveINode>
c01021b3:	83 c4 04             	add    $0x4,%esp
		f->file_size = f->offset + len;
c01021b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021b9:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01021bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01021c2:	01 c2                	add    %eax,%edx
c01021c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021c7:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	};
	readDir(f->dir_offset);
c01021cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021d0:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c01021d6:	50                   	push   %eax
c01021d7:	e8 39 f7 ff ff       	call   c0101915 <readDir>
c01021dc:	83 c4 04             	add    $0x4,%esp
	dir.entries[f->entry_offset].file_size = f->file_size;
c01021df:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021e2:	8b 90 10 02 00 00    	mov    0x210(%eax),%edx
c01021e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021eb:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01021f1:	c1 e2 05             	shl    $0x5,%edx
c01021f4:	83 c2 10             	add    $0x10,%edx
c01021f7:	81 c2 80 d7 1f c0    	add    $0xc01fd780,%edx
c01021fd:	89 42 08             	mov    %eax,0x8(%edx)
	saveDir(f->dir_offset);
c0102200:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102203:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c0102209:	50                   	push   %eax
c010220a:	e8 21 f7 ff ff       	call   c0101930 <saveDir>
c010220f:	83 c4 04             	add    $0x4,%esp
	fs_write_base_kr(fd, buf, len);
c0102212:	ff 75 10             	pushl  0x10(%ebp)
c0102215:	ff 75 0c             	pushl  0xc(%ebp)
c0102218:	ff 75 08             	pushl  0x8(%ebp)
c010221b:	e8 95 fc ff ff       	call   c0101eb5 <fs_write_base_kr>
c0102220:	83 c4 0c             	add    $0xc,%esp
	return len;
c0102223:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0102226:	c9                   	leave  
c0102227:	c3                   	ret    

c0102228 <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c0102228:	55                   	push   %ebp
c0102229:	89 e5                	mov    %esp,%ebp
c010222b:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c010222e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102231:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102237:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c010223c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c010223f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102242:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102245:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c010224b:	c9                   	leave  
c010224c:	c3                   	ret    

c010224d <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c010224d:	55                   	push   %ebp
c010224e:	89 e5                	mov    %esp,%ebp
c0102250:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102253:	8b 45 08             	mov    0x8(%ebp),%eax
c0102256:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010225c:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102261:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c0102264:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102267:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
	}
c010226d:	c9                   	leave  
c010226e:	c3                   	ret    

c010226f <fs_close_kr>:
int fs_close_kr(int fd){
c010226f:	55                   	push   %ebp
c0102270:	89 e5                	mov    %esp,%ebp
c0102272:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102275:	8b 45 08             	mov    0x8(%ebp),%eax
c0102278:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010227e:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102283:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->used){
c0102286:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102289:	0f b6 80 2c 02 00 00 	movzbl 0x22c(%eax),%eax
c0102290:	84 c0                	test   %al,%al
c0102292:	74 11                	je     c01022a5 <fs_close_kr+0x36>
		f->used = 0;
c0102294:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102297:	c6 80 2c 02 00 00 00 	movb   $0x0,0x22c(%eax)
		return 0;
c010229e:	b8 00 00 00 00       	mov    $0x0,%eax
c01022a3:	eb 05                	jmp    c01022aa <fs_close_kr+0x3b>
	}else
		return 1;
c01022a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01022aa:	c9                   	leave  
c01022ab:	c3                   	ret    

c01022ac <some>:
void some(){
c01022ac:	55                   	push   %ebp
c01022ad:	89 e5                	mov    %esp,%ebp

}
c01022af:	5d                   	pop    %ebp
c01022b0:	c3                   	ret    

c01022b1 <fs_create_kr>:
int fs_create_kr(char* name){
c01022b1:	55                   	push   %ebp
c01022b2:	89 e5                	mov    %esp,%ebp
c01022b4:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c01022b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01022be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c01022c5:	e9 d8 00 00 00       	jmp    c01023a2 <fs_create_kr+0xf1>
		readDir(dir_offset);
c01022ca:	ff 75 fc             	pushl  -0x4(%ebp)
c01022cd:	e8 43 f6 ff ff       	call   c0101915 <readDir>
c01022d2:	83 c4 04             	add    $0x4,%esp
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c01022d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01022dc:	e9 b1 00 00 00       	jmp    c0102392 <fs_create_kr+0xe1>
			if(dir.entries[entry_offset].inode_offset == -1)
c01022e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022e4:	c1 e0 05             	shl    $0x5,%eax
c01022e7:	83 c0 10             	add    $0x10,%eax
c01022ea:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c01022ef:	8b 40 0c             	mov    0xc(%eax),%eax
c01022f2:	83 f8 ff             	cmp    $0xffffffff,%eax
c01022f5:	0f 85 93 00 00 00    	jne    c010238e <fs_create_kr+0xdd>
				goto OUT_OF_LOOP;
c01022fb:	90                   	nop
	
	//FILE_STREAM *f;
	int i=0;

	OUT_OF_LOOP:
	some();
c01022fc:	e8 ab ff ff ff       	call   c01022ac <some>
	//printk("##%d\n", entry_offset);
	int index_inode = INodeAlloc();
c0102301:	e8 b1 f6 ff ff       	call   c01019b7 <INodeAlloc>
c0102306:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//printk("##%d\n", index_inode);
	dir.entries[entry_offset].inode_offset = index_inode;
c0102309:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010230c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010230f:	c1 e2 05             	shl    $0x5,%edx
c0102312:	83 c2 10             	add    $0x10,%edx
c0102315:	81 c2 80 d7 1f c0    	add    $0xc01fd780,%edx
c010231b:	89 42 0c             	mov    %eax,0xc(%edx)
	strcpy(dir.entries[entry_offset].filename, name);
c010231e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102321:	c1 e0 05             	shl    $0x5,%eax
c0102324:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102329:	ff 75 08             	pushl  0x8(%ebp)
c010232c:	50                   	push   %eax
c010232d:	e8 5b f3 ff ff       	call   c010168d <strcpy>
c0102332:	83 c4 08             	add    $0x8,%esp
	//printk("##%s\n", name);
	//printk("##%s\n", dir.entries[entry_offset].filename);
	dir.entries[entry_offset].file_size = 0;
c0102335:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102338:	c1 e0 05             	shl    $0x5,%eax
c010233b:	83 c0 10             	add    $0x10,%eax
c010233e:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102343:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
	saveDir(dir_offset);
c010234a:	ff 75 fc             	pushl  -0x4(%ebp)
c010234d:	e8 de f5 ff ff       	call   c0101930 <saveDir>
c0102352:	83 c4 04             	add    $0x4,%esp

	readINode(index_inode);
c0102355:	ff 75 f0             	pushl  -0x10(%ebp)
c0102358:	e8 ee f5 ff ff       	call   c010194b <readINode>
c010235d:	83 c4 04             	add    $0x4,%esp
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
c0102360:	68 00 02 00 00       	push   $0x200
c0102365:	68 ff 00 00 00       	push   $0xff
c010236a:	68 80 d9 1f c0       	push   $0xc01fd980
c010236f:	e8 c1 f2 ff ff       	call   c0101635 <memset2>
c0102374:	83 c4 0c             	add    $0xc,%esp
	saveINode(index_inode);
c0102377:	ff 75 f0             	pushl  -0x10(%ebp)
c010237a:	e8 e7 f5 ff ff       	call   c0101966 <saveINode>
c010237f:	83 c4 04             	add    $0x4,%esp
	for(i=0; i<NR_FILE_STREAM; i++){
c0102382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102389:	e9 37 01 00 00       	jmp    c01024c5 <fs_create_kr+0x214>
}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c010238e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102392:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102395:	83 f8 0f             	cmp    $0xf,%eax
c0102398:	0f 86 43 ff ff ff    	jbe    c01022e1 <fs_create_kr+0x30>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
c010239e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
void some(){

}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c01023a2:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01023a9:	0f 8e 1b ff ff ff    	jle    c01022ca <fs_create_kr+0x19>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
	}
	goto FAILURE;
c01023af:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c01023b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01023b5:	e9 1d 01 00 00       	jmp    c01024d7 <fs_create_kr+0x226>

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c01023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023bd:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023c3:	05 20 02 00 00       	add    $0x220,%eax
c01023c8:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01023cd:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c01023d1:	84 c0                	test   %al,%al
c01023d3:	0f 85 e8 00 00 00    	jne    c01024c1 <fs_create_kr+0x210>
			fs[i].used = 1;
c01023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023dc:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023e2:	05 20 02 00 00       	add    $0x220,%eax
c01023e7:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c01023ec:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c01023f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01023f3:	c1 e0 05             	shl    $0x5,%eax
c01023f6:	83 c0 10             	add    $0x10,%eax
c01023f9:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c01023fe:	8b 40 08             	mov    0x8(%eax),%eax
c0102401:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102404:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010240a:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102410:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c0102416:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0102419:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010241c:	c1 e0 05             	shl    $0x5,%eax
c010241f:	8d 90 80 d7 1f c0    	lea    -0x3fe02880(%eax),%edx
c0102425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102428:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010242e:	05 10 02 00 00       	add    $0x210,%eax
c0102433:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102438:	83 c0 04             	add    $0x4,%eax
c010243b:	52                   	push   %edx
c010243c:	50                   	push   %eax
c010243d:	e8 4b f2 ff ff       	call   c010168d <strcpy>
c0102442:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0102445:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102448:	c1 e0 05             	shl    $0x5,%eax
c010244b:	83 c0 10             	add    $0x10,%eax
c010244e:	05 80 d7 1f c0       	add    $0xc01fd780,%eax
c0102453:	8b 40 0c             	mov    0xc(%eax),%eax
c0102456:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102459:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010245f:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102465:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c010246b:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c010246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102471:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102477:	05 00 02 00 00       	add    $0x200,%eax
c010247c:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0102487:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010248a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010248d:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0102493:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102499:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c010249f:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c01024a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01024a8:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c01024ae:	81 c2 10 02 00 00    	add    $0x210,%edx
c01024b4:	81 c2 80 a5 1d c0    	add    $0xc01da580,%edx
c01024ba:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c01024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024bf:	eb 16                	jmp    c01024d7 <fs_create_kr+0x226>
	saveDir(dir_offset);

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
c01024c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024c5:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c01024cc:	0f 8e e8 fe ff ff    	jle    c01023ba <fs_create_kr+0x109>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c01024d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c01024d7:	c9                   	leave  
c01024d8:	c3                   	ret    

c01024d9 <fs_open_md>:

int fs_open_md(char *pathname, int flags){
c01024d9:	55                   	push   %ebp
c01024da:	89 e5                	mov    %esp,%ebp
c01024dc:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_kr(pathname);
c01024df:	ff 75 08             	pushl  0x8(%ebp)
c01024e2:	e8 f8 f5 ff ff       	call   c0101adf <fs_open_kr>
c01024e7:	83 c4 04             	add    $0x4,%esp
c01024ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(fd == -1 && flags == 1){
c01024ed:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
c01024f1:	75 14                	jne    c0102507 <fs_open_md+0x2e>
c01024f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01024f7:	75 0e                	jne    c0102507 <fs_open_md+0x2e>
		fd = fs_create_kr(pathname);
c01024f9:	ff 75 08             	pushl  0x8(%ebp)
c01024fc:	e8 b0 fd ff ff       	call   c01022b1 <fs_create_kr>
c0102501:	83 c4 04             	add    $0x4,%esp
c0102504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	};
	//printk("step 1\n");
	return fd;
c0102507:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c010250a:	c9                   	leave  
c010250b:	c3                   	ret    

c010250c <fs_read_md>:
int fs_read_md(int fd, void *buf, int len){
c010250c:	55                   	push   %ebp
c010250d:	89 e5                	mov    %esp,%ebp
	return fs_read_kr(fd, buf, len);
c010250f:	ff 75 10             	pushl  0x10(%ebp)
c0102512:	ff 75 0c             	pushl  0xc(%ebp)
c0102515:	ff 75 08             	pushl  0x8(%ebp)
c0102518:	e8 2a f9 ff ff       	call   c0101e47 <fs_read_kr>
c010251d:	83 c4 0c             	add    $0xc,%esp
};
c0102520:	c9                   	leave  
c0102521:	c3                   	ret    

c0102522 <fs_write_md>:
int fs_write_md(int fd, void *buf, int len){
c0102522:	55                   	push   %ebp
c0102523:	89 e5                	mov    %esp,%ebp
	return fs_write_kr(fd, buf, len);
c0102525:	ff 75 10             	pushl  0x10(%ebp)
c0102528:	ff 75 0c             	pushl  0xc(%ebp)
c010252b:	ff 75 08             	pushl  0x8(%ebp)
c010252e:	e8 8e fb ff ff       	call   c01020c1 <fs_write_kr>
c0102533:	83 c4 0c             	add    $0xc,%esp
};
c0102536:	c9                   	leave  
c0102537:	c3                   	ret    

c0102538 <fs_lseek_md>:
int fs_lseek_md(int fd, int offset, int whence){
c0102538:	55                   	push   %ebp
c0102539:	89 e5                	mov    %esp,%ebp
c010253b:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c010253e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102541:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102547:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c010254c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t index = 0;
c010254f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	if(whence == 0){
c0102556:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010255a:	75 08                	jne    c0102564 <fs_lseek_md+0x2c>
		index = offset;
c010255c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010255f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102562:	eb 30                	jmp    c0102594 <fs_lseek_md+0x5c>
	}else if(whence == 1){
c0102564:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
c0102568:	75 13                	jne    c010257d <fs_lseek_md+0x45>
		index = f->offset + offset;
c010256a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010256d:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102573:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102576:	01 d0                	add    %edx,%eax
c0102578:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010257b:	eb 17                	jmp    c0102594 <fs_lseek_md+0x5c>
	}else if(whence == 2){
c010257d:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
c0102581:	75 11                	jne    c0102594 <fs_lseek_md+0x5c>
		index = f->file_size + offset;
c0102583:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102586:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c010258c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010258f:	01 d0                	add    %edx,%eax
c0102591:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
	fs_lseek_kr(fd, index);
c0102594:	ff 75 fc             	pushl  -0x4(%ebp)
c0102597:	ff 75 08             	pushl  0x8(%ebp)
c010259a:	e8 89 fc ff ff       	call   c0102228 <fs_lseek_kr>
c010259f:	83 c4 08             	add    $0x8,%esp
	return index;
c01025a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c01025a5:	c9                   	leave  
c01025a6:	c3                   	ret    

c01025a7 <fs_close_md>:
int fs_close_md(int fd){
c01025a7:	55                   	push   %ebp
c01025a8:	89 e5                	mov    %esp,%ebp
	return fs_close_kr(fd);
c01025aa:	ff 75 08             	pushl  0x8(%ebp)
c01025ad:	e8 bd fc ff ff       	call   c010226f <fs_close_kr>
c01025b2:	83 c4 04             	add    $0x4,%esp
};
c01025b5:	c9                   	leave  
c01025b6:	c3                   	ret    

c01025b7 <fs_open_port>:

int fs_open_port(char *pathname, int flags){
c01025b7:	55                   	push   %ebp
c01025b8:	89 e5                	mov    %esp,%ebp
c01025ba:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_md(pathname, flags);
c01025bd:	ff 75 0c             	pushl  0xc(%ebp)
c01025c0:	ff 75 08             	pushl  0x8(%ebp)
c01025c3:	e8 11 ff ff ff       	call   c01024d9 <fs_open_md>
c01025c8:	83 c4 08             	add    $0x8,%esp
c01025cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(fd == -1)
c01025ce:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
c01025d2:	75 07                	jne    c01025db <fs_open_port+0x24>
		return -1;
c01025d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01025d9:	eb 4c                	jmp    c0102627 <fs_open_port+0x70>
	int i = 0;
c01025db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i<FCBMAX; i++){
c01025e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01025e9:	eb 1c                	jmp    c0102607 <fs_open_port+0x50>
		if(current->fcb[i].fd_kr == -1)
c01025eb:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01025f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01025f3:	81 c2 18 08 00 00    	add    $0x818,%edx
c01025f9:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01025fc:	83 f8 ff             	cmp    $0xffffffff,%eax
c01025ff:	75 02                	jne    c0102603 <fs_open_port+0x4c>
			break;
c0102601:	eb 0d                	jmp    c0102610 <fs_open_port+0x59>
int fs_open_port(char *pathname, int flags){
	int fd = fs_open_md(pathname, flags);
	if(fd == -1)
		return -1;
	int i = 0;
	for(i = 0; i<FCBMAX; i++){
c0102603:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102607:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010260e:	7e db                	jle    c01025eb <fs_open_port+0x34>
		if(current->fcb[i].fd_kr == -1)
			break;
	}
	current->fcb[i].fd_kr = fd;
c0102610:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0102615:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102618:	8d 8a 18 08 00 00    	lea    0x818(%edx),%ecx
c010261e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102621:	89 14 88             	mov    %edx,(%eax,%ecx,4)
	return i;
c0102624:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c0102627:	c9                   	leave  
c0102628:	c3                   	ret    

c0102629 <fs_read_port>:
int fs_read_port(int fd, void *buf, int len){
c0102629:	55                   	push   %ebp
c010262a:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c010262c:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102630:	75 07                	jne    c0102639 <fs_read_port+0x10>
		return -1;
c0102632:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102637:	eb 20                	jmp    c0102659 <fs_read_port+0x30>
	return fs_read_md(current->fcb[fd].fd_kr, buf, len);
c0102639:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010263e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102641:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102647:	8b 04 90             	mov    (%eax,%edx,4),%eax
c010264a:	ff 75 10             	pushl  0x10(%ebp)
c010264d:	ff 75 0c             	pushl  0xc(%ebp)
c0102650:	50                   	push   %eax
c0102651:	e8 b6 fe ff ff       	call   c010250c <fs_read_md>
c0102656:	83 c4 0c             	add    $0xc,%esp
};
c0102659:	c9                   	leave  
c010265a:	c3                   	ret    

c010265b <fs_write_port>:
int fs_write_port(int fd, void *buf, int len){
c010265b:	55                   	push   %ebp
c010265c:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c010265e:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102662:	75 07                	jne    c010266b <fs_write_port+0x10>
		return -1;
c0102664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102669:	eb 20                	jmp    c010268b <fs_write_port+0x30>
	return fs_write_md(current->fcb[fd].fd_kr, buf, len);
c010266b:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0102670:	8b 55 08             	mov    0x8(%ebp),%edx
c0102673:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102679:	8b 04 90             	mov    (%eax,%edx,4),%eax
c010267c:	ff 75 10             	pushl  0x10(%ebp)
c010267f:	ff 75 0c             	pushl  0xc(%ebp)
c0102682:	50                   	push   %eax
c0102683:	e8 9a fe ff ff       	call   c0102522 <fs_write_md>
c0102688:	83 c4 0c             	add    $0xc,%esp
};
c010268b:	c9                   	leave  
c010268c:	c3                   	ret    

c010268d <fs_lseek_port>:
int fs_lseek_port(int fd, int offset, int whence){
c010268d:	55                   	push   %ebp
c010268e:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c0102690:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102694:	75 07                	jne    c010269d <fs_lseek_port+0x10>
		return -1;
c0102696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010269b:	eb 20                	jmp    c01026bd <fs_lseek_port+0x30>
	return fs_lseek_md(current->fcb[fd].fd_kr, offset, whence);
c010269d:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01026a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01026a5:	81 c2 18 08 00 00    	add    $0x818,%edx
c01026ab:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01026ae:	ff 75 10             	pushl  0x10(%ebp)
c01026b1:	ff 75 0c             	pushl  0xc(%ebp)
c01026b4:	50                   	push   %eax
c01026b5:	e8 7e fe ff ff       	call   c0102538 <fs_lseek_md>
c01026ba:	83 c4 0c             	add    $0xc,%esp
};
c01026bd:	c9                   	leave  
c01026be:	c3                   	ret    

c01026bf <fs_close_port>:
int fs_close_port(int fd){
c01026bf:	55                   	push   %ebp
c01026c0:	89 e5                	mov    %esp,%ebp
c01026c2:	83 ec 10             	sub    $0x10,%esp
	if(fd == -1)
c01026c5:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c01026c9:	75 07                	jne    c01026d2 <fs_close_port+0x13>
		return -1;
c01026cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01026d0:	eb 35                	jmp    c0102707 <fs_close_port+0x48>
	int ret = fs_close_md(current->fcb[fd].fd_kr);
c01026d2:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01026d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01026da:	81 c2 18 08 00 00    	add    $0x818,%edx
c01026e0:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01026e3:	50                   	push   %eax
c01026e4:	e8 be fe ff ff       	call   c01025a7 <fs_close_md>
c01026e9:	83 c4 04             	add    $0x4,%esp
c01026ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	current->fcb[fd].fd_kr = -1;
c01026ef:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01026f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01026f7:	81 c2 18 08 00 00    	add    $0x818,%edx
c01026fd:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	return ret;
c0102704:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c0102707:	c9                   	leave  
c0102708:	c3                   	ret    

c0102709 <init_fs>:

void init_fs(){
c0102709:	55                   	push   %ebp
c010270a:	89 e5                	mov    %esp,%ebp
c010270c:	83 ec 68             	sub    $0x68,%esp
	//readDir(0);
	int i=0;
c010270f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c0102716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010271d:	eb 1b                	jmp    c010273a <init_fs+0x31>
		fs[i].used = 0;
c010271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102722:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102728:	05 20 02 00 00       	add    $0x220,%eax
c010272d:	05 80 a5 1d c0       	add    $0xc01da580,%eax
c0102732:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
};

void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c0102736:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010273a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0102741:	7e dc                	jle    c010271f <init_fs+0x16>
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
c0102743:	68 71 4c 10 c0       	push   $0xc0104c71
c0102748:	e8 92 f3 ff ff       	call   c0101adf <fs_open_kr>
c010274d:	83 c4 04             	add    $0x4,%esp
c0102750:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char magic[80];
	
	fs_read_kr(fd, magic, 80);
c0102753:	6a 50                	push   $0x50
c0102755:	8d 45 a0             	lea    -0x60(%ebp),%eax
c0102758:	50                   	push   %eax
c0102759:	ff 75 f0             	pushl  -0x10(%ebp)
c010275c:	e8 e6 f6 ff ff       	call   c0101e47 <fs_read_kr>
c0102761:	83 c4 0c             	add    $0xc,%esp
	fs_close_kr(fd);
c0102764:	ff 75 f0             	pushl  -0x10(%ebp)
c0102767:	e8 03 fb ff ff       	call   c010226f <fs_close_kr>
c010276c:	83 c4 04             	add    $0x4,%esp
	printk("%s\n", magic);
c010276f:	83 ec 08             	sub    $0x8,%esp
c0102772:	8d 45 a0             	lea    -0x60(%ebp),%eax
c0102775:	50                   	push   %eax
c0102776:	68 7a 4c 10 c0       	push   $0xc0104c7a
c010277b:	e8 73 ee ff ff       	call   c01015f3 <printk>
c0102780:	83 c4 10             	add    $0x10,%esp
	
c0102783:	c9                   	leave  
c0102784:	c3                   	ret    

c0102785 <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c0102785:	55                   	push   %ebp
c0102786:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c0102788:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c010278d:	cd 80                	int    $0x80
}
c010278f:	5d                   	pop    %ebp
c0102790:	c3                   	ret    

c0102791 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c0102791:	55                   	push   %ebp
c0102792:	89 e5                	mov    %esp,%ebp
c0102794:	83 ec 40             	sub    $0x40,%esp
c0102797:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c010279e:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01027a2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01027a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01027a9:	ee                   	out    %al,(%dx)
c01027aa:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c01027b1:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c01027b5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01027b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01027bc:	ee                   	out    %al,(%dx)
c01027bd:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c01027c4:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c01027c8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01027cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01027cf:	ee                   	out    %al,(%dx)
c01027d0:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c01027d7:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01027db:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01027df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01027e2:	ee                   	out    %al,(%dx)
c01027e3:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01027ea:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01027ee:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01027f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01027f5:	ee                   	out    %al,(%dx)
c01027f6:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01027fd:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0102801:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102805:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102808:	ee                   	out    %al,(%dx)
c0102809:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0102810:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0102814:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102818:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010281b:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c010281c:	c9                   	leave  
c010281d:	c3                   	ret    

c010281e <serial_idle>:

static inline
int serial_idle(void) {
c010281e:	55                   	push   %ebp
c010281f:	89 e5                	mov    %esp,%ebp
c0102821:	83 ec 10             	sub    $0x10,%esp
c0102824:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010282b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010282e:	89 c2                	mov    %eax,%edx
c0102830:	ec                   	in     (%dx),%al
c0102831:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102834:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102838:	0f b6 c0             	movzbl %al,%eax
c010283b:	83 e0 20             	and    $0x20,%eax
c010283e:	85 c0                	test   %eax,%eax
c0102840:	0f 95 c0             	setne  %al
c0102843:	0f b6 c0             	movzbl %al,%eax
}
c0102846:	c9                   	leave  
c0102847:	c3                   	ret    

c0102848 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102848:	55                   	push   %ebp
c0102849:	89 e5                	mov    %esp,%ebp
c010284b:	83 ec 14             	sub    $0x14,%esp
c010284e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102851:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102854:	90                   	nop
c0102855:	e8 c4 ff ff ff       	call   c010281e <serial_idle>
c010285a:	85 c0                	test   %eax,%eax
c010285c:	74 f7                	je     c0102855 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010285e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102862:	0f b6 c0             	movzbl %al,%eax
c0102865:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010286c:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010286f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102873:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102876:	ee                   	out    %al,(%dx)
}
c0102877:	c9                   	leave  
c0102878:	c3                   	ret    

c0102879 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102879:	55                   	push   %ebp
c010287a:	89 e5                	mov    %esp,%ebp
c010287c:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010287f:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102882:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102885:	8b 45 08             	mov    0x8(%ebp),%eax
c0102888:	83 ec 04             	sub    $0x4,%esp
c010288b:	ff 75 f4             	pushl  -0xc(%ebp)
c010288e:	50                   	push   %eax
c010288f:	68 48 28 10 c0       	push   $0xc0102848
c0102894:	e8 22 20 00 00       	call   c01048bb <vfprintf>
c0102899:	83 c4 10             	add    $0x10,%esp
}
c010289c:	c9                   	leave  
c010289d:	c3                   	ret    

c010289e <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c010289e:	55                   	push   %ebp
c010289f:	89 e5                	mov    %esp,%ebp
c01028a1:	83 ec 70             	sub    $0x70,%esp
c01028a4:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01028ab:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01028af:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01028b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028b6:	ee                   	out    %al,(%dx)
c01028b7:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01028be:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01028c2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01028c9:	ee                   	out    %al,(%dx)
c01028ca:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01028d1:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01028d5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01028d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01028dc:	ee                   	out    %al,(%dx)
c01028dd:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c01028e4:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01028e8:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01028ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01028ef:	ee                   	out    %al,(%dx)
c01028f0:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01028f7:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01028fb:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01028ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102902:	ee                   	out    %al,(%dx)
c0102903:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010290a:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010290e:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102912:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102915:	ee                   	out    %al,(%dx)
c0102916:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c010291d:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0102921:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102925:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102928:	ee                   	out    %al,(%dx)
c0102929:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0102930:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0102934:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0102938:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010293b:	ee                   	out    %al,(%dx)
c010293c:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0102943:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0102947:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c010294b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010294e:	ee                   	out    %al,(%dx)
c010294f:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0102956:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c010295a:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c010295e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102961:	ee                   	out    %al,(%dx)
c0102962:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0102969:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c010296d:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0102971:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102974:	ee                   	out    %al,(%dx)
c0102975:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c010297c:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c0102980:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0102984:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102987:	ee                   	out    %al,(%dx)
c0102988:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010298f:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0102993:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0102997:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010299a:	ee                   	out    %al,(%dx)
c010299b:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c01029a2:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01029a6:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01029aa:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01029ad:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01029ae:	c9                   	leave  
c01029af:	c3                   	ret    

c01029b0 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01029b0:	55                   	push   %ebp
c01029b1:	89 e5                	mov    %esp,%ebp
c01029b3:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01029b6:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01029bd:	0f b6 05 00 90 10 c0 	movzbl 0xc0109000,%eax
c01029c4:	0f b6 c0             	movzbl %al,%eax
c01029c7:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01029ce:	88 45 f7             	mov    %al,-0x9(%ebp)
c01029d1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01029d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01029d8:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01029d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029dc:	0f b6 c0             	movzbl %al,%eax
c01029df:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01029e6:	88 45 ef             	mov    %al,-0x11(%ebp)
c01029e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01029ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029f0:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01029f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029f4:	c1 f8 08             	sar    $0x8,%eax
c01029f7:	0f b6 c0             	movzbl %al,%eax
c01029fa:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0102a01:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102a04:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102a08:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102a0b:	ee                   	out    %al,(%dx)
}
c0102a0c:	c9                   	leave  
c0102a0d:	c3                   	ret    

c0102a0e <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c0102a0e:	55                   	push   %ebp
c0102a0f:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c0102a11:	e8 6f fd ff ff       	call   c0102785 <sys_handout>
  }
c0102a16:	eb f9                	jmp    c0102a11 <idle+0x3>

c0102a18 <main>:
}


void do_scheduler();
int main(){
c0102a18:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0102a1c:	83 e4 f0             	and    $0xfffffff0,%esp
c0102a1f:	ff 71 fc             	pushl  -0x4(%ecx)
c0102a22:	55                   	push   %ebp
c0102a23:	89 e5                	mov    %esp,%ebp
c0102a25:	51                   	push   %ecx
c0102a26:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0102a29:	e8 fd d6 ff ff       	call   c010012b <init_page>
  init_segment();
c0102a2e:	e8 a9 d8 ff ff       	call   c01002dc <init_segment>
	init_serial();
c0102a33:	e8 59 fd ff ff       	call   c0102791 <init_serial>
	init_timer();
c0102a38:	e8 73 ff ff ff       	call   c01029b0 <init_timer>
	init_idt();
c0102a3d:	e8 81 e9 ff ff       	call   c01013c3 <init_idt>
	init_intr();
c0102a42:	e8 57 fe ff ff       	call   c010289e <init_intr>
  init_fs();
c0102a47:	e8 bd fc ff ff       	call   c0102709 <init_fs>
  init_pcb_pool();
c0102a4c:	e8 88 12 00 00       	call   c0103cd9 <init_pcb_pool>
  

  printk("This is kernel!\n");
c0102a51:	83 ec 0c             	sub    $0xc,%esp
c0102a54:	68 7e 4c 10 c0       	push   $0xc0104c7e
c0102a59:	e8 1b fe ff ff       	call   c0102879 <printk>
c0102a5e:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c0102a61:	e8 de 13 00 00       	call   c0103e44 <pcb_create>
c0102a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0102a69:	83 ec 08             	sub    $0x8,%esp
c0102a6c:	68 0e 2a 10 c0       	push   $0xc0102a0e
c0102a71:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a74:	e8 0f 06 00 00       	call   c0103088 <empty_loader>
c0102a79:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c0102a7c:	83 ec 0c             	sub    $0xc,%esp
c0102a7f:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a82:	e8 e6 14 00 00       	call   c0103f6d <enready_pcb>
c0102a87:	83 c4 10             	add    $0x10,%esp


  PCB* pcb = pcb_create();
c0102a8a:	e8 b5 13 00 00       	call   c0103e44 <pcb_create>
c0102a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader_file(pcb, "game");
c0102a92:	83 ec 08             	sub    $0x8,%esp
c0102a95:	68 8f 4c 10 c0       	push   $0xc0104c8f
c0102a9a:	ff 75 f0             	pushl  -0x10(%ebp)
c0102a9d:	e8 15 04 00 00       	call   c0102eb7 <loader_file>
c0102aa2:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c0102aa5:	83 ec 0c             	sub    $0xc,%esp
c0102aa8:	ff 75 f0             	pushl  -0x10(%ebp)
c0102aab:	e8 bd 14 00 00       	call   c0103f6d <enready_pcb>
c0102ab0:	83 c4 10             	add    $0x10,%esp
    
  PCB* pshell = pcb_create();
c0102ab3:	e8 8c 13 00 00       	call   c0103e44 <pcb_create>
c0102ab8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader_file(pshell, "cshell");
c0102abb:	83 ec 08             	sub    $0x8,%esp
c0102abe:	68 94 4c 10 c0       	push   $0xc0104c94
c0102ac3:	ff 75 ec             	pushl  -0x14(%ebp)
c0102ac6:	e8 ec 03 00 00       	call   c0102eb7 <loader_file>
c0102acb:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pshell);
c0102ace:	83 ec 0c             	sub    $0xc,%esp
c0102ad1:	ff 75 ec             	pushl  -0x14(%ebp)
c0102ad4:	e8 94 14 00 00       	call   c0103f6d <enready_pcb>
c0102ad9:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c0102adc:	e8 63 13 00 00       	call   c0103e44 <pcb_create>
c0102ae1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  loader_file(app, "app");
c0102ae4:	83 ec 08             	sub    $0x8,%esp
c0102ae7:	68 9b 4c 10 c0       	push   $0xc0104c9b
c0102aec:	ff 75 e8             	pushl  -0x18(%ebp)
c0102aef:	e8 c3 03 00 00       	call   c0102eb7 <loader_file>
c0102af4:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c0102af7:	83 ec 0c             	sub    $0xc,%esp
c0102afa:	ff 75 e8             	pushl  -0x18(%ebp)
c0102afd:	e8 6b 14 00 00       	call   c0103f6d <enready_pcb>
c0102b02:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c0102b05:	e8 a1 e5 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c0102b0a:	eb fe                	jmp    c0102b0a <main+0xf2>

c0102b0c <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102b0c:	55                   	push   %ebp
c0102b0d:	89 e5                	mov    %esp,%ebp
c0102b0f:	83 ec 10             	sub    $0x10,%esp
c0102b12:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b1c:	89 c2                	mov    %eax,%edx
c0102b1e:	ec                   	in     (%dx),%al
c0102b1f:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102b22:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102b26:	0f b6 c0             	movzbl %al,%eax
c0102b29:	83 e0 20             	and    $0x20,%eax
c0102b2c:	85 c0                	test   %eax,%eax
c0102b2e:	0f 95 c0             	setne  %al
c0102b31:	0f b6 c0             	movzbl %al,%eax
}
c0102b34:	c9                   	leave  
c0102b35:	c3                   	ret    

c0102b36 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102b36:	55                   	push   %ebp
c0102b37:	89 e5                	mov    %esp,%ebp
c0102b39:	83 ec 14             	sub    $0x14,%esp
c0102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b3f:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102b42:	90                   	nop
c0102b43:	e8 c4 ff ff ff       	call   c0102b0c <serial_idle>
c0102b48:	85 c0                	test   %eax,%eax
c0102b4a:	74 f7                	je     c0102b43 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102b4c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102b50:	0f b6 c0             	movzbl %al,%eax
c0102b53:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102b5a:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102b5d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102b61:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102b64:	ee                   	out    %al,(%dx)
}
c0102b65:	c9                   	leave  
c0102b66:	c3                   	ret    

c0102b67 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102b67:	55                   	push   %ebp
c0102b68:	89 e5                	mov    %esp,%ebp
c0102b6a:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102b6d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b76:	83 ec 04             	sub    $0x4,%esp
c0102b79:	ff 75 f4             	pushl  -0xc(%ebp)
c0102b7c:	50                   	push   %eax
c0102b7d:	68 36 2b 10 c0       	push   $0xc0102b36
c0102b82:	e8 34 1d 00 00       	call   c01048bb <vfprintf>
c0102b87:	83 c4 10             	add    $0x10,%esp
}
c0102b8a:	c9                   	leave  
c0102b8b:	c3                   	ret    

c0102b8c <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0102b8c:	55                   	push   %ebp
c0102b8d:	89 e5                	mov    %esp,%ebp
c0102b8f:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0102b92:	90                   	nop
c0102b93:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b9d:	89 c2                	mov    %eax,%edx
c0102b9f:	ec                   	in     (%dx),%al
c0102ba0:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102ba3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102ba7:	0f b6 c0             	movzbl %al,%eax
c0102baa:	25 c0 00 00 00       	and    $0xc0,%eax
c0102baf:	83 f8 40             	cmp    $0x40,%eax
c0102bb2:	75 df                	jne    c0102b93 <waitdisk+0x7>
}
c0102bb4:	c9                   	leave  
c0102bb5:	c3                   	ret    

c0102bb6 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102bb6:	55                   	push   %ebp
c0102bb7:	89 e5                	mov    %esp,%ebp
c0102bb9:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0102bbc:	e8 cb ff ff ff       	call   c0102b8c <waitdisk>
c0102bc1:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0102bc8:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102bcc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102bd0:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102bd3:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0102bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bd7:	0f b6 c0             	movzbl %al,%eax
c0102bda:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0102be1:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102be4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102beb:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0102bec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102bef:	c1 f8 08             	sar    $0x8,%eax
c0102bf2:	0f b6 c0             	movzbl %al,%eax
c0102bf5:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0102bfc:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102bff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102c03:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102c06:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0102c07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c0a:	c1 f8 10             	sar    $0x10,%eax
c0102c0d:	0f b6 c0             	movzbl %al,%eax
c0102c10:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0102c17:	88 45 df             	mov    %al,-0x21(%ebp)
c0102c1a:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102c1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c21:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0102c22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c25:	c1 f8 18             	sar    $0x18,%eax
c0102c28:	83 c8 e0             	or     $0xffffffe0,%eax
c0102c2b:	0f b6 c0             	movzbl %al,%eax
c0102c2e:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0102c35:	88 45 d7             	mov    %al,-0x29(%ebp)
c0102c38:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0102c3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c3f:	ee                   	out    %al,(%dx)
c0102c40:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0102c47:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0102c4b:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0102c4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c52:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0102c53:	e8 34 ff ff ff       	call   c0102b8c <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102c58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102c5f:	eb 29                	jmp    c0102c8a <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0102c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0102c71:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102c78:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c7b:	89 c2                	mov    %eax,%edx
c0102c7d:	ed                   	in     (%dx),%eax
c0102c7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0102c81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c84:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102c86:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102c8a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0102c8e:	7e d1                	jle    c0102c61 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0102c90:	c9                   	leave  
c0102c91:	c3                   	ret    

c0102c92 <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0102c92:	55                   	push   %ebp
c0102c93:	89 e5                	mov    %esp,%ebp
c0102c95:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102c98:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9e:	01 d0                	add    %edx,%eax
c0102ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102ca3:	8b 45 10             	mov    0x10(%ebp),%eax
c0102ca6:	99                   	cltd   
c0102ca7:	c1 ea 17             	shr    $0x17,%edx
c0102caa:	01 d0                	add    %edx,%eax
c0102cac:	25 ff 01 00 00       	and    $0x1ff,%eax
c0102cb1:	29 d0                	sub    %edx,%eax
c0102cb3:	f7 d8                	neg    %eax
c0102cb5:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102cb8:	8b 45 10             	mov    0x10(%ebp),%eax
c0102cbb:	99                   	cltd   
c0102cbc:	c1 ea 17             	shr    $0x17,%edx
c0102cbf:	01 d0                	add    %edx,%eax
c0102cc1:	c1 f8 09             	sar    $0x9,%eax
c0102cc4:	83 c0 01             	add    $0x1,%eax
c0102cc7:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102cca:	eb 19                	jmp    c0102ce5 <readseg+0x53>
        readsect(pa, offset);
c0102ccc:	ff 75 10             	pushl  0x10(%ebp)
c0102ccf:	ff 75 08             	pushl  0x8(%ebp)
c0102cd2:	e8 df fe ff ff       	call   c0102bb6 <readsect>
c0102cd7:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102cda:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0102ce1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102ceb:	72 df                	jb     c0102ccc <readseg+0x3a>
        readsect(pa, offset);
c0102ced:	c9                   	leave  
c0102cee:	c3                   	ret    

c0102cef <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0102cef:	55                   	push   %ebp
c0102cf0:	89 e5                	mov    %esp,%ebp
c0102cf2:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0102cf5:	8b 45 10             	mov    0x10(%ebp),%eax
c0102cf8:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0102cfd:	77 16                	ja     c0102d15 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102cff:	ff 75 10             	pushl  0x10(%ebp)
c0102d02:	68 a0 4c 10 c0       	push   $0xc0104ca0
c0102d07:	ff 75 0c             	pushl  0xc(%ebp)
c0102d0a:	ff 75 08             	pushl  0x8(%ebp)
c0102d0d:	e8 55 fe ff ff       	call   c0102b67 <printk>
c0102d12:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0102d15:	8b 45 10             	mov    0x10(%ebp),%eax
c0102d18:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102d1d:	c9                   	leave  
c0102d1e:	c3                   	ret    

c0102d1f <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)
#define elf_r ((char*) ELFADDR)

uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0102d1f:	55                   	push   %ebp
c0102d20:	89 e5                	mov    %esp,%ebp
c0102d22:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d28:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d2e:	83 ec 04             	sub    $0x4,%esp
c0102d31:	50                   	push   %eax
c0102d32:	6a 17                	push   $0x17
c0102d34:	68 c3 4c 10 c0       	push   $0xc0104cc3
c0102d39:	e8 b1 ff ff ff       	call   c0102cef <_paddr>
c0102d3e:	83 c4 10             	add    $0x10,%esp
c0102d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d47:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d53:	83 ec 04             	sub    $0x4,%esp
c0102d56:	68 00 10 00 00       	push   $0x1000
c0102d5b:	6a 00                	push   $0x0
c0102d5d:	50                   	push   %eax
c0102d5e:	e8 2e d9 ff ff       	call   c0100691 <mm_alloc>
c0102d63:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102d66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d69:	83 ec 04             	sub    $0x4,%esp
c0102d6c:	50                   	push   %eax
c0102d6d:	68 00 10 00 00       	push   $0x1000
c0102d72:	6a 00                	push   $0x0
c0102d74:	e8 19 ff ff ff       	call   c0102c92 <readseg>
c0102d79:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102d7c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102d81:	8b 00                	mov    (%eax),%eax
c0102d83:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102d88:	0f 94 c0             	sete   %al
c0102d8b:	0f b6 c0             	movzbl %al,%eax
c0102d8e:	83 ec 08             	sub    $0x8,%esp
c0102d91:	50                   	push   %eax
c0102d92:	68 d7 4c 10 c0       	push   $0xc0104cd7
c0102d97:	e8 cb fd ff ff       	call   c0102b67 <printk>
c0102d9c:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102d9f:	b8 00 00 00 00       	mov    $0x0,%eax
c0102da4:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102daa:	b8 00 00 00 00       	mov    $0x0,%eax
c0102daf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102db3:	0f b7 c0             	movzwl %ax,%eax
c0102db6:	c1 e0 05             	shl    $0x5,%eax
c0102db9:	89 c2                	mov    %eax,%edx
c0102dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbe:	01 d0                	add    %edx,%eax
c0102dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102dc3:	eb 7f                	jmp    c0102e44 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0102dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc8:	8b 40 0c             	mov    0xc(%eax),%eax
c0102dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd1:	8b 48 14             	mov    0x14(%eax),%ecx
c0102dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd7:	8b 50 08             	mov    0x8(%eax),%edx
c0102dda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ddd:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102de3:	83 ec 04             	sub    $0x4,%esp
c0102de6:	51                   	push   %ecx
c0102de7:	52                   	push   %edx
c0102de8:	50                   	push   %eax
c0102de9:	e8 a3 d8 ff ff       	call   c0100691 <mm_alloc>
c0102dee:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df4:	8b 50 04             	mov    0x4(%eax),%edx
c0102df7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102dfa:	01 d0                	add    %edx,%eax
c0102dfc:	89 c2                	mov    %eax,%edx
c0102dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e01:	8b 40 10             	mov    0x10(%eax),%eax
c0102e04:	83 ec 04             	sub    $0x4,%esp
c0102e07:	52                   	push   %edx
c0102e08:	50                   	push   %eax
c0102e09:	ff 75 e8             	pushl  -0x18(%ebp)
c0102e0c:	e8 81 fe ff ff       	call   c0102c92 <readseg>
c0102e11:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e17:	8b 50 10             	mov    0x10(%eax),%edx
c0102e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e1d:	01 d0                	add    %edx,%eax
c0102e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e22:	eb 0c                	jmp    c0102e30 <loader+0x111>
c0102e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e27:	8d 50 01             	lea    0x1(%eax),%edx
c0102e2a:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102e2d:	c6 00 00             	movb   $0x0,(%eax)
c0102e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e33:	8b 50 14             	mov    0x14(%eax),%edx
c0102e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e39:	01 d0                	add    %edx,%eax
c0102e3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e3e:	77 e4                	ja     c0102e24 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102e40:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102e4a:	0f 82 75 ff ff ff    	jb     c0102dc5 <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0102e50:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e55:	8b 40 18             	mov    0x18(%eax),%eax
c0102e58:	a3 34 48 10 c0       	mov    %eax,0xc0104834

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e60:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102e66:	83 ec 04             	sub    $0x4,%esp
c0102e69:	68 00 80 00 00       	push   $0x8000
c0102e6e:	68 00 60 bf be       	push   $0xbebf6000
c0102e73:	50                   	push   %eax
c0102e74:	e8 18 d8 ff ff       	call   c0100691 <mm_alloc>
c0102e79:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102e7c:	a1 34 48 10 c0       	mov    0xc0104834,%eax
c0102e81:	6a 03                	push   $0x3
c0102e83:	50                   	push   %eax
c0102e84:	68 80 df bf be       	push   $0xbebfdf80
c0102e89:	ff 75 08             	pushl  0x8(%ebp)
c0102e8c:	e8 7f 0e 00 00       	call   c0103d10 <init_pcb>
c0102e91:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102e94:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c0102e99:	83 ec 04             	sub    $0x4,%esp
c0102e9c:	50                   	push   %eax
c0102e9d:	6a 39                	push   $0x39
c0102e9f:	68 c3 4c 10 c0       	push   $0xc0104cc3
c0102ea4:	e8 46 fe ff ff       	call   c0102cef <_paddr>
c0102ea9:	83 c4 10             	add    $0x10,%esp
c0102eac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102eb2:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102eb5:	c9                   	leave  
c0102eb6:	c3                   	ret    

c0102eb7 <loader_file>:

void loader_file(PCB* pcb, char* filename){
c0102eb7:	55                   	push   %ebp
c0102eb8:	89 e5                	mov    %esp,%ebp
c0102eba:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ec0:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102ec6:	83 ec 04             	sub    $0x4,%esp
c0102ec9:	50                   	push   %eax
c0102eca:	6a 44                	push   $0x44
c0102ecc:	68 c3 4c 10 c0       	push   $0xc0104cc3
c0102ed1:	e8 19 fe ff ff       	call   c0102cef <_paddr>
c0102ed6:	83 c4 10             	add    $0x10,%esp
c0102ed9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102edc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102edf:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102ee2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ee5:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102eeb:	83 ec 04             	sub    $0x4,%esp
c0102eee:	68 00 10 00 00       	push   $0x1000
c0102ef3:	6a 00                	push   $0x0
c0102ef5:	50                   	push   %eax
c0102ef6:	e8 96 d7 ff ff       	call   c0100691 <mm_alloc>
c0102efb:	83 c4 10             	add    $0x10,%esp
  int fd = fs_open_kr(filename);
c0102efe:	83 ec 0c             	sub    $0xc,%esp
c0102f01:	ff 75 0c             	pushl  0xc(%ebp)
c0102f04:	e8 d6 eb ff ff       	call   c0101adf <fs_open_kr>
c0102f09:	83 c4 10             	add    $0x10,%esp
c0102f0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fs_read_kr(fd, elf_r, 8*SECTSIZE);
c0102f0f:	83 ec 04             	sub    $0x4,%esp
c0102f12:	68 00 10 00 00       	push   $0x1000
c0102f17:	6a 00                	push   $0x0
c0102f19:	ff 75 ec             	pushl  -0x14(%ebp)
c0102f1c:	e8 26 ef ff ff       	call   c0101e47 <fs_read_kr>
c0102f21:	83 c4 10             	add    $0x10,%esp
  //readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("%x\n", *(uint32_t *)(elf_r+7*SECTSIZE));
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102f24:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f29:	8b 00                	mov    (%eax),%eax
c0102f2b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102f30:	0f 94 c0             	sete   %al
c0102f33:	0f b6 c0             	movzbl %al,%eax
c0102f36:	83 ec 08             	sub    $0x8,%esp
c0102f39:	50                   	push   %eax
c0102f3a:	68 d7 4c 10 c0       	push   $0xc0104cd7
c0102f3f:	e8 23 fc ff ff       	call   c0102b67 <printk>
c0102f44:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102f47:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f4c:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102f52:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f57:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102f5b:	0f b7 c0             	movzwl %ax,%eax
c0102f5e:	c1 e0 05             	shl    $0x5,%eax
c0102f61:	89 c2                	mov    %eax,%edx
c0102f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f66:	01 d0                	add    %edx,%eax
c0102f68:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102f6b:	e9 a5 00 00 00       	jmp    c0103015 <loader_file+0x15e>
    pa = (unsigned char*)ph->vaddr; 
c0102f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f73:	8b 40 08             	mov    0x8(%eax),%eax
c0102f76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //printk("%x %x %x\n", pcb->pgdir, ph->vaddr, ph->memsz);
    if(ph->vaddr == 0 || ph->memsz == 0)break;
c0102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7c:	8b 40 08             	mov    0x8(%eax),%eax
c0102f7f:	85 c0                	test   %eax,%eax
c0102f81:	0f 84 9a 00 00 00    	je     c0103021 <loader_file+0x16a>
c0102f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f8a:	8b 40 14             	mov    0x14(%eax),%eax
c0102f8d:	85 c0                	test   %eax,%eax
c0102f8f:	0f 84 8c 00 00 00    	je     c0103021 <loader_file+0x16a>
    //printk("a\n");
    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f98:	8b 48 14             	mov    0x14(%eax),%ecx
c0102f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f9e:	8b 50 08             	mov    0x8(%eax),%edx
c0102fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fa4:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102faa:	83 ec 04             	sub    $0x4,%esp
c0102fad:	51                   	push   %ecx
c0102fae:	52                   	push   %edx
c0102faf:	50                   	push   %eax
c0102fb0:	e8 dc d6 ff ff       	call   c0100691 <mm_alloc>
c0102fb5:	83 c4 10             	add    $0x10,%esp
    //printk("b\n");
    //printk("hahaha?\n");
    fs_lseek_kr(fd, ph->off);
c0102fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fbb:	8b 40 04             	mov    0x4(%eax),%eax
c0102fbe:	83 ec 08             	sub    $0x8,%esp
c0102fc1:	50                   	push   %eax
c0102fc2:	ff 75 ec             	pushl  -0x14(%ebp)
c0102fc5:	e8 5e f2 ff ff       	call   c0102228 <fs_lseek_kr>
c0102fca:	83 c4 10             	add    $0x10,%esp
    fs_read_kr(fd, pa, ph->filesz);
c0102fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fd0:	8b 40 10             	mov    0x10(%eax),%eax
c0102fd3:	83 ec 04             	sub    $0x4,%esp
c0102fd6:	50                   	push   %eax
c0102fd7:	ff 75 e4             	pushl  -0x1c(%ebp)
c0102fda:	ff 75 ec             	pushl  -0x14(%ebp)
c0102fdd:	e8 65 ee ff ff       	call   c0101e47 <fs_read_kr>
c0102fe2:	83 c4 10             	add    $0x10,%esp
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe8:	8b 50 10             	mov    0x10(%eax),%edx
c0102feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102fee:	01 d0                	add    %edx,%eax
c0102ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ff3:	eb 0c                	jmp    c0103001 <loader_file+0x14a>
c0102ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ff8:	8d 50 01             	lea    0x1(%eax),%edx
c0102ffb:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102ffe:	c6 00 00             	movb   $0x0,(%eax)
c0103001:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103004:	8b 50 14             	mov    0x14(%eax),%edx
c0103007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010300a:	01 d0                	add    %edx,%eax
c010300c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010300f:	77 e4                	ja     c0102ff5 <loader_file+0x13e>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0103011:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103015:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103018:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010301b:	0f 82 4f ff ff ff    	jb     c0102f70 <loader_file+0xb9>
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  //printk("c\n");
  //while(1);
  entry = elf->entry;
c0103021:	b8 00 00 00 00       	mov    $0x0,%eax
c0103026:	8b 40 18             	mov    0x18(%eax),%eax
c0103029:	a3 34 48 10 c0       	mov    %eax,0xc0104834
  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  //printk("e\n");
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c010302e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103031:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103037:	83 ec 04             	sub    $0x4,%esp
c010303a:	68 00 80 00 00       	push   $0x8000
c010303f:	68 00 60 bf be       	push   $0xbebf6000
c0103044:	50                   	push   %eax
c0103045:	e8 47 d6 ff ff       	call   c0100691 <mm_alloc>
c010304a:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c010304d:	a1 34 48 10 c0       	mov    0xc0104834,%eax
c0103052:	6a 03                	push   $0x3
c0103054:	50                   	push   %eax
c0103055:	68 80 df bf be       	push   $0xbebfdf80
c010305a:	ff 75 08             	pushl  0x8(%ebp)
c010305d:	e8 ae 0c 00 00       	call   c0103d10 <init_pcb>
c0103062:	83 c4 10             	add    $0x10,%esp
  //printk("f\n");
  //printk("%x\n", *(uint32_t*)(0x80481fd));
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0103065:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c010306a:	83 ec 04             	sub    $0x4,%esp
c010306d:	50                   	push   %eax
c010306e:	6a 74                	push   $0x74
c0103070:	68 c3 4c 10 c0       	push   $0xc0104cc3
c0103075:	e8 75 fc ff ff       	call   c0102cef <_paddr>
c010307a:	83 c4 10             	add    $0x10,%esp
c010307d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103080:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103083:	0f 22 d8             	mov    %eax,%cr3
  //printk("g\n");
  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0103086:	c9                   	leave  
c0103087:	c3                   	ret    

c0103088 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0103088:	55                   	push   %ebp
c0103089:	89 e5                	mov    %esp,%ebp
c010308b:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c010308e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103091:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103097:	83 ec 04             	sub    $0x4,%esp
c010309a:	50                   	push   %eax
c010309b:	6a 7d                	push   $0x7d
c010309d:	68 c3 4c 10 c0       	push   $0xc0104cc3
c01030a2:	e8 48 fc ff ff       	call   c0102cef <_paddr>
c01030a7:	83 c4 10             	add    $0x10,%esp
c01030aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030b0:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c01030b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030b6:	a3 34 48 10 c0       	mov    %eax,0xc0104834
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c01030bb:	a1 34 48 10 c0       	mov    0xc0104834,%eax
c01030c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01030c3:	81 c2 20 20 00 00    	add    $0x2020,%edx
c01030c9:	83 c2 80             	add    $0xffffff80,%edx
c01030cc:	6a 00                	push   $0x0
c01030ce:	50                   	push   %eax
c01030cf:	52                   	push   %edx
c01030d0:	ff 75 08             	pushl  0x8(%ebp)
c01030d3:	e8 38 0c 00 00       	call   c0103d10 <init_pcb>
c01030d8:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c01030db:	a1 00 6b 17 c0       	mov    0xc0176b00,%eax
c01030e0:	83 ec 04             	sub    $0x4,%esp
c01030e3:	50                   	push   %eax
c01030e4:	68 81 00 00 00       	push   $0x81
c01030e9:	68 c3 4c 10 c0       	push   $0xc0104cc3
c01030ee:	e8 fc fb ff ff       	call   c0102cef <_paddr>
c01030f3:	83 c4 10             	add    $0x10,%esp
c01030f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030fc:	0f 22 d8             	mov    %eax,%cr3

c01030ff:	c9                   	leave  
c0103100:	c3                   	ret    

c0103101 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103101:	55                   	push   %ebp
c0103102:	89 e5                	mov    %esp,%ebp
c0103104:	83 ec 10             	sub    $0x10,%esp
c0103107:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010310e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103111:	89 c2                	mov    %eax,%edx
c0103113:	ec                   	in     (%dx),%al
c0103114:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103117:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010311b:	0f b6 c0             	movzbl %al,%eax
c010311e:	83 e0 20             	and    $0x20,%eax
c0103121:	85 c0                	test   %eax,%eax
c0103123:	0f 95 c0             	setne  %al
c0103126:	0f b6 c0             	movzbl %al,%eax
}
c0103129:	c9                   	leave  
c010312a:	c3                   	ret    

c010312b <serial_printc>:

static inline
void serial_printc(char ch) {
c010312b:	55                   	push   %ebp
c010312c:	89 e5                	mov    %esp,%ebp
c010312e:	83 ec 14             	sub    $0x14,%esp
c0103131:	8b 45 08             	mov    0x8(%ebp),%eax
c0103134:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103137:	90                   	nop
c0103138:	e8 c4 ff ff ff       	call   c0103101 <serial_idle>
c010313d:	85 c0                	test   %eax,%eax
c010313f:	74 f7                	je     c0103138 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0103141:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103145:	0f b6 c0             	movzbl %al,%eax
c0103148:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010314f:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103152:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103156:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103159:	ee                   	out    %al,(%dx)
}
c010315a:	c9                   	leave  
c010315b:	c3                   	ret    

c010315c <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010315c:	55                   	push   %ebp
c010315d:	89 e5                	mov    %esp,%ebp
c010315f:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0103162:	8d 45 0c             	lea    0xc(%ebp),%eax
c0103165:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0103168:	8b 45 08             	mov    0x8(%ebp),%eax
c010316b:	83 ec 04             	sub    $0x4,%esp
c010316e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103171:	50                   	push   %eax
c0103172:	68 2b 31 10 c0       	push   $0xc010312b
c0103177:	e8 3f 17 00 00       	call   c01048bb <vfprintf>
c010317c:	83 c4 10             	add    $0x10,%esp
}
c010317f:	c9                   	leave  
c0103180:	c3                   	ret    

c0103181 <cputchar>:

static inline void cputchar(char c) {
c0103181:	55                   	push   %ebp
c0103182:	89 e5                	mov    %esp,%ebp
c0103184:	83 ec 04             	sub    $0x4,%esp
c0103187:	8b 45 08             	mov    0x8(%ebp),%eax
c010318a:	88 45 fc             	mov    %al,-0x4(%ebp)
    serial_printc(c);
c010318d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0103191:	50                   	push   %eax
c0103192:	e8 94 ff ff ff       	call   c010312b <serial_printc>
c0103197:	83 c4 04             	add    $0x4,%esp
}
c010319a:	c9                   	leave  
c010319b:	c3                   	ret    

c010319c <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c010319c:	55                   	push   %ebp
c010319d:	89 e5                	mov    %esp,%ebp
c010319f:	83 ec 04             	sub    $0x4,%esp
c01031a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01031a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c01031a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c01031ac:	83 e8 61             	sub    $0x61,%eax
c01031af:	8b 04 85 40 70 15 c0 	mov    -0x3fea8fc0(,%eax,4),%eax
}
c01031b6:	c9                   	leave  
c01031b7:	c3                   	ret    

c01031b8 <get_lastkey>:
int8_t get_lastkey(){
c01031b8:	55                   	push   %ebp
c01031b9:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c01031bb:	a1 a8 70 15 c0       	mov    0xc01570a8,%eax
c01031c0:	83 c0 61             	add    $0x61,%eax
}
c01031c3:	5d                   	pop    %ebp
c01031c4:	c3                   	ret    

c01031c5 <press_key>:
void press_key(int code){
c01031c5:	55                   	push   %ebp
c01031c6:	89 e5                	mov    %esp,%ebp
c01031c8:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c01031cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c01031d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01031d5:	25 80 00 00 00       	and    $0x80,%eax
c01031da:	85 c0                	test   %eax,%eax
c01031dc:	75 35                	jne    c0103213 <press_key+0x4e>
		for(;i<26;i++){
c01031de:	eb 2b                	jmp    c010320b <press_key+0x46>
			if(letter[i]==code){
c01031e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031e3:	8b 04 85 40 90 10 c0 	mov    -0x3fef6fc0(,%eax,4),%eax
c01031ea:	3b 45 08             	cmp    0x8(%ebp),%eax
c01031ed:	75 18                	jne    c0103207 <press_key+0x42>
				keydown[i] = 1;
c01031ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031f2:	c7 04 85 40 70 15 c0 	movl   $0x1,-0x3fea8fc0(,%eax,4)
c01031f9:	01 00 00 00 
				lastkey = i;
c01031fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103200:	a3 a8 70 15 c0       	mov    %eax,0xc01570a8
				return;
c0103205:	eb 3b                	jmp    c0103242 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0103207:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010320b:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c010320f:	7e cf                	jle    c01031e0 <press_key+0x1b>
c0103211:	eb 2f                	jmp    c0103242 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0103213:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0103217:	eb 23                	jmp    c010323c <press_key+0x77>
			if(letter[i]==code){
c0103219:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321c:	8b 04 85 40 90 10 c0 	mov    -0x3fef6fc0(,%eax,4),%eax
c0103223:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103226:	75 10                	jne    c0103238 <press_key+0x73>
				keydown[i] = 0;
c0103228:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010322b:	c7 04 85 40 70 15 c0 	movl   $0x0,-0x3fea8fc0(,%eax,4)
c0103232:	00 00 00 00 
				return;
c0103236:	eb 0a                	jmp    c0103242 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0103238:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010323c:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0103240:	7e d7                	jle    c0103219 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0103242:	c9                   	leave  
c0103243:	c3                   	ret    

c0103244 <wait_key>:
	shiftmap,
	ctlmap,
	ctlmap
};

void wait_key(){
c0103244:	55                   	push   %ebp
c0103245:	89 e5                	mov    %esp,%ebp
c0103247:	83 ec 10             	sub    $0x10,%esp
	while(!(inb(0x64)&0x01));
c010324a:	90                   	nop
c010324b:	c7 45 fc 64 00 00 00 	movl   $0x64,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103252:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103255:	89 c2                	mov    %eax,%edx
c0103257:	ec                   	in     (%dx),%al
c0103258:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010325b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010325f:	0f b6 c0             	movzbl %al,%eax
c0103262:	83 e0 01             	and    $0x1,%eax
c0103265:	85 c0                	test   %eax,%eax
c0103267:	74 e2                	je     c010324b <wait_key+0x7>
}
c0103269:	c9                   	leave  
c010326a:	c3                   	ret    

c010326b <poll_key>:
int poll_key(){
c010326b:	55                   	push   %ebp
c010326c:	89 e5                	mov    %esp,%ebp
c010326e:	83 ec 20             	sub    $0x20,%esp
c0103271:	c7 45 f4 60 00 00 00 	movl   $0x60,-0xc(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010327b:	89 c2                	mov    %eax,%edx
c010327d:	ec                   	in     (%dx),%al
c010327e:	88 45 f3             	mov    %al,-0xd(%ebp)
	return data;
c0103281:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
	int c;
	uint8_t data;
	static uint32_t shift;

	data = inb(0x60);
c0103285:	88 45 fb             	mov    %al,-0x5(%ebp)

	while(data == 0x08)
c0103288:	eb 17                	jmp    c01032a1 <poll_key+0x36>
c010328a:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103291:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103294:	89 c2                	mov    %eax,%edx
c0103296:	ec                   	in     (%dx),%al
c0103297:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c010329a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		data = inb(0x60);
c010329e:	88 45 fb             	mov    %al,-0x5(%ebp)
	uint8_t data;
	static uint32_t shift;

	data = inb(0x60);

	while(data == 0x08)
c01032a1:	80 7d fb 08          	cmpb   $0x8,-0x5(%ebp)
c01032a5:	74 e3                	je     c010328a <poll_key+0x1f>
		data = inb(0x60);

	if (data == 0xE0) {
c01032a7:	80 7d fb e0          	cmpb   $0xe0,-0x5(%ebp)
c01032ab:	75 17                	jne    c01032c4 <poll_key+0x59>
		// E0 escape character
		shift |= E0ESC;
c01032ad:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01032b2:	83 c8 40             	or     $0x40,%eax
c01032b5:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
		return 0;
c01032ba:	b8 00 00 00 00       	mov    $0x0,%eax
c01032bf:	e9 ef 00 00 00       	jmp    c01033b3 <poll_key+0x148>
	} else if (data & 0x80) {
c01032c4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01032c8:	84 c0                	test   %al,%al
c01032ca:	79 47                	jns    c0103313 <poll_key+0xa8>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
c01032cc:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c01032d1:	83 e0 40             	and    $0x40,%eax
c01032d4:	85 c0                	test   %eax,%eax
c01032d6:	75 09                	jne    c01032e1 <poll_key+0x76>
c01032d8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01032dc:	83 e0 7f             	and    $0x7f,%eax
c01032df:	eb 04                	jmp    c01032e5 <poll_key+0x7a>
c01032e1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01032e5:	88 45 fb             	mov    %al,-0x5(%ebp)
		shift &= ~(shiftcode[data] | E0ESC);
c01032e8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01032ec:	0f b6 80 c0 90 10 c0 	movzbl -0x3fef6f40(%eax),%eax
c01032f3:	83 c8 40             	or     $0x40,%eax
c01032f6:	0f b6 c0             	movzbl %al,%eax
c01032f9:	f7 d0                	not    %eax
c01032fb:	89 c2                	mov    %eax,%edx
c01032fd:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103302:	21 d0                	and    %edx,%eax
c0103304:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
		return 0;
c0103309:	b8 00 00 00 00       	mov    $0x0,%eax
c010330e:	e9 a0 00 00 00       	jmp    c01033b3 <poll_key+0x148>
	} else if (shift & E0ESC) {
c0103313:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103318:	83 e0 40             	and    $0x40,%eax
c010331b:	85 c0                	test   %eax,%eax
c010331d:	74 11                	je     c0103330 <poll_key+0xc5>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
c010331f:	80 4d fb 80          	orb    $0x80,-0x5(%ebp)
		shift &= ~E0ESC;
c0103323:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103328:	83 e0 bf             	and    $0xffffffbf,%eax
c010332b:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
	}

	shift |= shiftcode[data];
c0103330:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103334:	0f b6 80 c0 90 10 c0 	movzbl -0x3fef6f40(%eax),%eax
c010333b:	0f b6 d0             	movzbl %al,%edx
c010333e:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103343:	09 d0                	or     %edx,%eax
c0103345:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0
	shift ^= togglecode[data];
c010334a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010334e:	0f b6 80 c0 91 10 c0 	movzbl -0x3fef6e40(%eax),%eax
c0103355:	0f b6 d0             	movzbl %al,%edx
c0103358:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c010335d:	31 d0                	xor    %edx,%eax
c010335f:	a3 c0 74 15 c0       	mov    %eax,0xc01574c0

	c = charcode[shift & (CTL | SHIFT)][data];
c0103364:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103369:	83 e0 03             	and    $0x3,%eax
c010336c:	8b 14 85 c0 95 10 c0 	mov    -0x3fef6a40(,%eax,4),%edx
c0103373:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103377:	01 d0                	add    %edx,%eax
c0103379:	0f b6 00             	movzbl (%eax),%eax
c010337c:	0f b6 c0             	movzbl %al,%eax
c010337f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (shift & CAPSLOCK) {
c0103382:	a1 c0 74 15 c0       	mov    0xc01574c0,%eax
c0103387:	83 e0 08             	and    $0x8,%eax
c010338a:	85 c0                	test   %eax,%eax
c010338c:	74 22                	je     c01033b0 <poll_key+0x145>
		if ('a' <= c && c <= 'z')
c010338e:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
c0103392:	7e 0c                	jle    c01033a0 <poll_key+0x135>
c0103394:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
c0103398:	7f 06                	jg     c01033a0 <poll_key+0x135>
			c += 'A' - 'a';
c010339a:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)
c010339e:	eb 10                	jmp    c01033b0 <poll_key+0x145>
		else if ('A' <= c && c <= 'Z')
c01033a0:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
c01033a4:	7e 0a                	jle    c01033b0 <poll_key+0x145>
c01033a6:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
c01033aa:	7f 04                	jg     c01033b0 <poll_key+0x145>
			c += 'a' - 'A';
c01033ac:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
	}
	return c;
c01033b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01033b3:	c9                   	leave  
c01033b4:	c3                   	ret    

c01033b5 <getchar>:

int getchar(void)
{
c01033b5:	55                   	push   %ebp
c01033b6:	89 e5                	mov    %esp,%ebp
c01033b8:	83 ec 10             	sub    $0x10,%esp
	int c;

	wait_key();
c01033bb:	e8 84 fe ff ff       	call   c0103244 <wait_key>
	c = poll_key();
c01033c0:	e8 a6 fe ff ff       	call   c010326b <poll_key>
c01033c5:	89 45 fc             	mov    %eax,-0x4(%ebp)

	return c;
c01033c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01033cb:	c9                   	leave  
c01033cc:	c3                   	ret    

c01033cd <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
c01033cd:	55                   	push   %ebp
c01033ce:	89 e5                	mov    %esp,%ebp
c01033d0:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
c01033d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033d7:	74 13                	je     c01033ec <readline+0x1f>
		printk("%s", prompt);
c01033d9:	83 ec 08             	sub    $0x8,%esp
c01033dc:	ff 75 08             	pushl  0x8(%ebp)
c01033df:	68 ec 4c 10 c0       	push   $0xc0104cec
c01033e4:	e8 73 fd ff ff       	call   c010315c <printk>
c01033e9:	83 c4 10             	add    $0x10,%esp

	i = 0;
c01033ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = 1;
c01033f3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	while (1) {
		c = getchar();
c01033fa:	e8 b6 ff ff ff       	call   c01033b5 <getchar>
c01033ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
c0103402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103406:	79 1d                	jns    c0103425 <readline+0x58>
			printk("read error: %e\n", c);
c0103408:	83 ec 08             	sub    $0x8,%esp
c010340b:	ff 75 ec             	pushl  -0x14(%ebp)
c010340e:	68 ef 4c 10 c0       	push   $0xc0104cef
c0103413:	e8 44 fd ff ff       	call   c010315c <printk>
c0103418:	83 c4 10             	add    $0x10,%esp
			return NULL;
c010341b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103420:	e9 9c 00 00 00       	jmp    c01034c1 <readline+0xf4>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
c0103425:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
c0103429:	74 06                	je     c0103431 <readline+0x64>
c010342b:	83 7d ec 7f          	cmpl   $0x7f,-0x14(%ebp)
c010342f:	75 1f                	jne    c0103450 <readline+0x83>
c0103431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103435:	7e 19                	jle    c0103450 <readline+0x83>
			if (echoing)
c0103437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010343b:	74 0d                	je     c010344a <readline+0x7d>
				cputchar('\b');
c010343d:	83 ec 0c             	sub    $0xc,%esp
c0103440:	6a 08                	push   $0x8
c0103442:	e8 3a fd ff ff       	call   c0103181 <cputchar>
c0103447:	83 c4 10             	add    $0x10,%esp
			i--;
c010344a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010344e:	eb 6c                	jmp    c01034bc <readline+0xef>
		} else if (c >= ' ' && i < BUFLEN-1) {
c0103450:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
c0103454:	7e 35                	jle    c010348b <readline+0xbe>
c0103456:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010345d:	7f 2c                	jg     c010348b <readline+0xbe>
			if (echoing)
c010345f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103463:	74 12                	je     c0103477 <readline+0xaa>
				cputchar(c);
c0103465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103468:	0f be c0             	movsbl %al,%eax
c010346b:	83 ec 0c             	sub    $0xc,%esp
c010346e:	50                   	push   %eax
c010346f:	e8 0d fd ff ff       	call   c0103181 <cputchar>
c0103474:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
c0103477:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347a:	8d 50 01             	lea    0x1(%eax),%edx
c010347d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0103480:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103483:	88 90 c0 70 15 c0    	mov    %dl,-0x3fea8f40(%eax)
c0103489:	eb 31                	jmp    c01034bc <readline+0xef>
		} else if (c == '\n' || c == '\r') {
c010348b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
c010348f:	74 06                	je     c0103497 <readline+0xca>
c0103491:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
c0103495:	75 25                	jne    c01034bc <readline+0xef>
			if (echoing)
c0103497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010349b:	74 0d                	je     c01034aa <readline+0xdd>
				cputchar('\n');
c010349d:	83 ec 0c             	sub    $0xc,%esp
c01034a0:	6a 0a                	push   $0xa
c01034a2:	e8 da fc ff ff       	call   c0103181 <cputchar>
c01034a7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
c01034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ad:	05 c0 70 15 c0       	add    $0xc01570c0,%eax
c01034b2:	c6 00 00             	movb   $0x0,(%eax)
			return buf;
c01034b5:	b8 c0 70 15 c0       	mov    $0xc01570c0,%eax
c01034ba:	eb 05                	jmp    c01034c1 <readline+0xf4>
		}
	}
c01034bc:	e9 39 ff ff ff       	jmp    c01033fa <readline+0x2d>
}
c01034c1:	c9                   	leave  
c01034c2:	c3                   	ret    

c01034c3 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01034c3:	55                   	push   %ebp
c01034c4:	89 e5                	mov    %esp,%ebp
c01034c6:	83 ec 10             	sub    $0x10,%esp
c01034c9:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01034d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034d3:	89 c2                	mov    %eax,%edx
c01034d5:	ec                   	in     (%dx),%al
c01034d6:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01034d9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01034dd:	0f b6 c0             	movzbl %al,%eax
c01034e0:	83 e0 20             	and    $0x20,%eax
c01034e3:	85 c0                	test   %eax,%eax
c01034e5:	0f 95 c0             	setne  %al
c01034e8:	0f b6 c0             	movzbl %al,%eax
}
c01034eb:	c9                   	leave  
c01034ec:	c3                   	ret    

c01034ed <serial_printc>:

static inline
void serial_printc(char ch) {
c01034ed:	55                   	push   %ebp
c01034ee:	89 e5                	mov    %esp,%ebp
c01034f0:	83 ec 14             	sub    $0x14,%esp
c01034f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01034f6:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01034f9:	90                   	nop
c01034fa:	e8 c4 ff ff ff       	call   c01034c3 <serial_idle>
c01034ff:	85 c0                	test   %eax,%eax
c0103501:	74 f7                	je     c01034fa <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0103503:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103507:	0f b6 c0             	movzbl %al,%eax
c010350a:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0103511:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103514:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103518:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010351b:	ee                   	out    %al,(%dx)
}
c010351c:	c9                   	leave  
c010351d:	c3                   	ret    

c010351e <strcpy>:
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
c010351e:	55                   	push   %ebp
c010351f:	89 e5                	mov    %esp,%ebp
c0103521:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c0103524:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c010352b:	eb 04                	jmp    c0103531 <strcpy+0x13>
    {
        i++;
c010352d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c0103531:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103534:	8b 45 08             	mov    0x8(%ebp),%eax
c0103537:	01 d0                	add    %edx,%eax
c0103539:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c010353c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010353f:	01 ca                	add    %ecx,%edx
c0103541:	0f b6 12             	movzbl (%edx),%edx
c0103544:	88 10                	mov    %dl,(%eax)
c0103546:	0f b6 00             	movzbl (%eax),%eax
c0103549:	84 c0                	test   %al,%al
c010354b:	75 e0                	jne    c010352d <strcpy+0xf>
    {
        i++;
    } 
}
c010354d:	c9                   	leave  
c010354e:	c3                   	ret    

c010354f <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c010354f:	55                   	push   %ebp
c0103550:	89 e5                	mov    %esp,%ebp
c0103552:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	char* str; 
	switch(tf->eax) {
c0103555:	8b 45 08             	mov    0x8(%ebp),%eax
c0103558:	8b 40 1c             	mov    0x1c(%eax),%eax
c010355b:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0103560:	0f 84 5e 03 00 00    	je     c01038c4 <do_syscall+0x375>
c0103566:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c010356b:	0f 87 ad 00 00 00    	ja     c010361e <do_syscall+0xcf>
c0103571:	3d 15 05 00 00       	cmp    $0x515,%eax
c0103576:	0f 84 56 04 00 00    	je     c01039d2 <do_syscall+0x483>
c010357c:	3d 15 05 00 00       	cmp    $0x515,%eax
c0103581:	77 53                	ja     c01035d6 <do_syscall+0x87>
c0103583:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0103588:	0f 84 ea 03 00 00    	je     c0103978 <do_syscall+0x429>
c010358e:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0103593:	77 1b                	ja     c01035b0 <do_syscall+0x61>
c0103595:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c010359a:	0f 84 ba 03 00 00    	je     c010395a <do_syscall+0x40b>
c01035a0:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c01035a5:	0f 84 c6 03 00 00    	je     c0103971 <do_syscall+0x422>
c01035ab:	e9 30 04 00 00       	jmp    c01039e0 <do_syscall+0x491>
c01035b0:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c01035b5:	0f 84 d0 03 00 00    	je     c010398b <do_syscall+0x43c>
c01035bb:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c01035c0:	0f 82 b9 03 00 00    	jb     c010397f <do_syscall+0x430>
c01035c6:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01035cb:	0f 84 e1 03 00 00    	je     c01039b2 <do_syscall+0x463>
c01035d1:	e9 0a 04 00 00       	jmp    c01039e0 <do_syscall+0x491>
c01035d6:	3d de 05 00 00       	cmp    $0x5de,%eax
c01035db:	0f 84 26 03 00 00    	je     c0103907 <do_syscall+0x3b8>
c01035e1:	3d de 05 00 00       	cmp    $0x5de,%eax
c01035e6:	77 1b                	ja     c0103603 <do_syscall+0xb4>
c01035e8:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01035ed:	0f 84 3f 03 00 00    	je     c0103932 <do_syscall+0x3e3>
c01035f3:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c01035f8:	0f 84 dd 02 00 00    	je     c01038db <do_syscall+0x38c>
c01035fe:	e9 dd 03 00 00       	jmp    c01039e0 <do_syscall+0x491>
c0103603:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c0103608:	0f 84 42 03 00 00    	je     c0103950 <do_syscall+0x401>
c010360e:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c0103613:	0f 87 d8 02 00 00    	ja     c01038f1 <do_syscall+0x3a2>
c0103619:	e9 28 03 00 00       	jmp    c0103946 <do_syscall+0x3f7>
c010361e:	3d 45 06 00 00       	cmp    $0x645,%eax
c0103623:	0f 84 57 02 00 00    	je     c0103880 <do_syscall+0x331>
c0103629:	3d 45 06 00 00       	cmp    $0x645,%eax
c010362e:	77 48                	ja     c0103678 <do_syscall+0x129>
c0103630:	3d 41 06 00 00       	cmp    $0x641,%eax
c0103635:	0f 84 b9 01 00 00    	je     c01037f4 <do_syscall+0x2a5>
c010363b:	3d 41 06 00 00       	cmp    $0x641,%eax
c0103640:	77 1b                	ja     c010365d <do_syscall+0x10e>
c0103642:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0103647:	0f 84 52 02 00 00    	je     c010389f <do_syscall+0x350>
c010364d:	3d 40 06 00 00       	cmp    $0x640,%eax
c0103652:	0f 84 7c 01 00 00    	je     c01037d4 <do_syscall+0x285>
c0103658:	e9 83 03 00 00       	jmp    c01039e0 <do_syscall+0x491>
c010365d:	3d 43 06 00 00       	cmp    $0x643,%eax
c0103662:	0f 84 cb 01 00 00    	je     c0103833 <do_syscall+0x2e4>
c0103668:	3d 43 06 00 00       	cmp    $0x643,%eax
c010366d:	0f 87 f6 01 00 00    	ja     c0103869 <do_syscall+0x31a>
c0103673:	e9 a4 01 00 00       	jmp    c010381c <do_syscall+0x2cd>
c0103678:	3d a6 06 00 00       	cmp    $0x6a6,%eax
c010367d:	0f 84 d0 00 00 00    	je     c0103753 <do_syscall+0x204>
c0103683:	3d a6 06 00 00       	cmp    $0x6a6,%eax
c0103688:	77 22                	ja     c01036ac <do_syscall+0x15d>
c010368a:	3d a4 06 00 00       	cmp    $0x6a4,%eax
c010368f:	74 69                	je     c01036fa <do_syscall+0x1ab>
c0103691:	3d a4 06 00 00       	cmp    $0x6a4,%eax
c0103696:	0f 87 86 00 00 00    	ja     c0103722 <do_syscall+0x1d3>
c010369c:	3d 46 06 00 00       	cmp    $0x646,%eax
c01036a1:	0f 84 a3 01 00 00    	je     c010384a <do_syscall+0x2fb>
c01036a7:	e9 34 03 00 00       	jmp    c01039e0 <do_syscall+0x491>
c01036ac:	3d a8 06 00 00       	cmp    $0x6a8,%eax
c01036b1:	0f 84 fe 00 00 00    	je     c01037b5 <do_syscall+0x266>
c01036b7:	3d a8 06 00 00       	cmp    $0x6a8,%eax
c01036bc:	0f 82 c2 00 00 00    	jb     c0103784 <do_syscall+0x235>
c01036c2:	3d 08 07 00 00       	cmp    $0x708,%eax
c01036c7:	0f 85 13 03 00 00    	jne    c01039e0 <do_syscall+0x491>
		case SYS_READLINE:
			str = readline("$: ");
c01036cd:	83 ec 0c             	sub    $0xc,%esp
c01036d0:	68 ff 4c 10 c0       	push   $0xc0104cff
c01036d5:	e8 f3 fc ff ff       	call   c01033cd <readline>
c01036da:	83 c4 10             	add    $0x10,%esp
c01036dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
			strcpy((char*)tf->ebx, str);
c01036e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e3:	8b 40 10             	mov    0x10(%eax),%eax
c01036e6:	83 ec 08             	sub    $0x8,%esp
c01036e9:	ff 75 f4             	pushl  -0xc(%ebp)
c01036ec:	50                   	push   %eax
c01036ed:	e8 2c fe ff ff       	call   c010351e <strcpy>
c01036f2:	83 c4 10             	add    $0x10,%esp
		break;
c01036f5:	e9 e6 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FS_OPEN:
			tf->eax = fs_open_port((char*)tf->ebx, tf->ecx);
c01036fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fd:	8b 40 18             	mov    0x18(%eax),%eax
c0103700:	89 c2                	mov    %eax,%edx
c0103702:	8b 45 08             	mov    0x8(%ebp),%eax
c0103705:	8b 40 10             	mov    0x10(%eax),%eax
c0103708:	83 ec 08             	sub    $0x8,%esp
c010370b:	52                   	push   %edx
c010370c:	50                   	push   %eax
c010370d:	e8 a5 ee ff ff       	call   c01025b7 <fs_open_port>
c0103712:	83 c4 10             	add    $0x10,%esp
c0103715:	89 c2                	mov    %eax,%edx
c0103717:	8b 45 08             	mov    0x8(%ebp),%eax
c010371a:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010371d:	e9 be 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FS_READ:
			tf->eax = fs_read_port(tf->ebx, (void*)tf->ecx, tf->edx);
c0103722:	8b 45 08             	mov    0x8(%ebp),%eax
c0103725:	8b 40 14             	mov    0x14(%eax),%eax
c0103728:	89 c1                	mov    %eax,%ecx
c010372a:	8b 45 08             	mov    0x8(%ebp),%eax
c010372d:	8b 40 18             	mov    0x18(%eax),%eax
c0103730:	89 c2                	mov    %eax,%edx
c0103732:	8b 45 08             	mov    0x8(%ebp),%eax
c0103735:	8b 40 10             	mov    0x10(%eax),%eax
c0103738:	83 ec 04             	sub    $0x4,%esp
c010373b:	51                   	push   %ecx
c010373c:	52                   	push   %edx
c010373d:	50                   	push   %eax
c010373e:	e8 e6 ee ff ff       	call   c0102629 <fs_read_port>
c0103743:	83 c4 10             	add    $0x10,%esp
c0103746:	89 c2                	mov    %eax,%edx
c0103748:	8b 45 08             	mov    0x8(%ebp),%eax
c010374b:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010374e:	e9 8d 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FS_WRITE:
			tf->eax = fs_write_port(tf->ebx, (void*)tf->ecx, tf->edx);
c0103753:	8b 45 08             	mov    0x8(%ebp),%eax
c0103756:	8b 40 14             	mov    0x14(%eax),%eax
c0103759:	89 c1                	mov    %eax,%ecx
c010375b:	8b 45 08             	mov    0x8(%ebp),%eax
c010375e:	8b 40 18             	mov    0x18(%eax),%eax
c0103761:	89 c2                	mov    %eax,%edx
c0103763:	8b 45 08             	mov    0x8(%ebp),%eax
c0103766:	8b 40 10             	mov    0x10(%eax),%eax
c0103769:	83 ec 04             	sub    $0x4,%esp
c010376c:	51                   	push   %ecx
c010376d:	52                   	push   %edx
c010376e:	50                   	push   %eax
c010376f:	e8 e7 ee ff ff       	call   c010265b <fs_write_port>
c0103774:	83 c4 10             	add    $0x10,%esp
c0103777:	89 c2                	mov    %eax,%edx
c0103779:	8b 45 08             	mov    0x8(%ebp),%eax
c010377c:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010377f:	e9 5c 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FS_LSEEK:
			tf->eax = fs_lseek_port(tf->ebx, tf->ecx, tf->edx);
c0103784:	8b 45 08             	mov    0x8(%ebp),%eax
c0103787:	8b 40 14             	mov    0x14(%eax),%eax
c010378a:	89 c1                	mov    %eax,%ecx
c010378c:	8b 45 08             	mov    0x8(%ebp),%eax
c010378f:	8b 40 18             	mov    0x18(%eax),%eax
c0103792:	89 c2                	mov    %eax,%edx
c0103794:	8b 45 08             	mov    0x8(%ebp),%eax
c0103797:	8b 40 10             	mov    0x10(%eax),%eax
c010379a:	83 ec 04             	sub    $0x4,%esp
c010379d:	51                   	push   %ecx
c010379e:	52                   	push   %edx
c010379f:	50                   	push   %eax
c01037a0:	e8 e8 ee ff ff       	call   c010268d <fs_lseek_port>
c01037a5:	83 c4 10             	add    $0x10,%esp
c01037a8:	89 c2                	mov    %eax,%edx
c01037aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ad:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01037b0:	e9 2b 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FS_CLOSE:
			tf->eax = fs_close_port(tf->ebx);
c01037b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01037b8:	8b 40 10             	mov    0x10(%eax),%eax
c01037bb:	83 ec 0c             	sub    $0xc,%esp
c01037be:	50                   	push   %eax
c01037bf:	e8 fb ee ff ff       	call   c01026bf <fs_close_port>
c01037c4:	83 c4 10             	add    $0x10,%esp
c01037c7:	89 c2                	mov    %eax,%edx
c01037c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01037cc:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01037cf:	e9 0c 02 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c01037d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d7:	8b 40 18             	mov    0x18(%eax),%eax
c01037da:	89 c2                	mov    %eax,%edx
c01037dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01037df:	8b 40 10             	mov    0x10(%eax),%eax
c01037e2:	83 ec 08             	sub    $0x8,%esp
c01037e5:	52                   	push   %edx
c01037e6:	50                   	push   %eax
c01037e7:	e8 25 d7 ff ff       	call   c0100f11 <sem_init_kr>
c01037ec:	83 c4 10             	add    $0x10,%esp
		break;
c01037ef:	e9 ec 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c01037f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037f7:	8b 40 18             	mov    0x18(%eax),%eax
c01037fa:	89 c2                	mov    %eax,%edx
c01037fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ff:	8b 40 10             	mov    0x10(%eax),%eax
c0103802:	83 ec 08             	sub    $0x8,%esp
c0103805:	52                   	push   %edx
c0103806:	50                   	push   %eax
c0103807:	e8 72 d8 ff ff       	call   c010107e <sem_open_kr>
c010380c:	83 c4 10             	add    $0x10,%esp
c010380f:	89 c2                	mov    %eax,%edx
c0103811:	8b 45 08             	mov    0x8(%ebp),%eax
c0103814:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103817:	e9 c4 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c010381c:	8b 45 08             	mov    0x8(%ebp),%eax
c010381f:	8b 40 10             	mov    0x10(%eax),%eax
c0103822:	83 ec 0c             	sub    $0xc,%esp
c0103825:	50                   	push   %eax
c0103826:	e8 52 d7 ff ff       	call   c0100f7d <sem_post_kr>
c010382b:	83 c4 10             	add    $0x10,%esp
		break;
c010382e:	e9 ad 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c0103833:	8b 45 08             	mov    0x8(%ebp),%eax
c0103836:	8b 40 10             	mov    0x10(%eax),%eax
c0103839:	83 ec 0c             	sub    $0xc,%esp
c010383c:	50                   	push   %eax
c010383d:	e8 8f d7 ff ff       	call   c0100fd1 <sem_wait_kr>
c0103842:	83 c4 10             	add    $0x10,%esp
		break;
c0103845:	e9 96 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c010384a:	8b 45 08             	mov    0x8(%ebp),%eax
c010384d:	8b 40 10             	mov    0x10(%eax),%eax
c0103850:	83 ec 0c             	sub    $0xc,%esp
c0103853:	50                   	push   %eax
c0103854:	e8 d0 d7 ff ff       	call   c0101029 <sem_trywait_kr>
c0103859:	83 c4 10             	add    $0x10,%esp
c010385c:	89 c2                	mov    %eax,%edx
c010385e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103861:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103864:	e9 77 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0103869:	8b 45 08             	mov    0x8(%ebp),%eax
c010386c:	8b 40 10             	mov    0x10(%eax),%eax
c010386f:	83 ec 0c             	sub    $0xc,%esp
c0103872:	50                   	push   %eax
c0103873:	e8 b9 d6 ff ff       	call   c0100f31 <sem_close_kr>
c0103878:	83 c4 10             	add    $0x10,%esp
		break;
c010387b:	e9 60 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0103880:	8b 45 08             	mov    0x8(%ebp),%eax
c0103883:	8b 40 10             	mov    0x10(%eax),%eax
c0103886:	83 ec 0c             	sub    $0xc,%esp
c0103889:	50                   	push   %eax
c010388a:	e8 d4 d7 ff ff       	call   c0101063 <sem_get_kr>
c010388f:	83 c4 10             	add    $0x10,%esp
c0103892:	89 c2                	mov    %eax,%edx
c0103894:	8b 45 08             	mov    0x8(%ebp),%eax
c0103897:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010389a:	e9 41 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c010389f:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a2:	8b 48 14             	mov    0x14(%eax),%ecx
c01038a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a8:	8b 50 18             	mov    0x18(%eax),%edx
c01038ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ae:	8b 40 10             	mov    0x10(%eax),%eax
c01038b1:	83 ec 04             	sub    $0x4,%esp
c01038b4:	51                   	push   %ecx
c01038b5:	52                   	push   %edx
c01038b6:	50                   	push   %eax
c01038b7:	e8 55 09 00 00       	call   c0104211 <thread_current>
c01038bc:	83 c4 10             	add    $0x10,%esp
		break;
c01038bf:	e9 1c 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_JOIN:
			join_current(tf->ebx);
c01038c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c7:	8b 40 10             	mov    0x10(%eax),%eax
c01038ca:	83 ec 0c             	sub    $0xc,%esp
c01038cd:	50                   	push   %eax
c01038ce:	e8 1c 0b 00 00       	call   c01043ef <join_current>
c01038d3:	83 c4 10             	add    $0x10,%esp
		break;
c01038d6:	e9 05 01 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_PID:
			tf->eax = current->pid;
c01038db:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01038e0:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01038e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e9:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01038ec:	e9 ef 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_PPID:
			tf->eax = current->ppid;
c01038f1:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01038f6:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c01038fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ff:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103902:	e9 d9 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0103907:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010390c:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c0103913:	00 00 00 
			current->timeslice = tf->ebx*200;
c0103916:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010391b:	8b 55 08             	mov    0x8(%ebp),%edx
c010391e:	8b 52 10             	mov    0x10(%edx),%edx
c0103921:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0103927:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c010392d:	e9 ae 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_HANDOUT:
			current->ts = STOP;
c0103932:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0103937:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c010393e:	00 00 00 
		break;
c0103941:	e9 9a 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_EXIT:
			exit_current();
c0103946:	e8 37 0a 00 00       	call   c0104382 <exit_current>
		break;
c010394b:	e9 90 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FORK:
			fork_current();
c0103950:	e8 4a 08 00 00       	call   c010419f <fork_current>
		break;
c0103955:	e9 86 00 00 00       	jmp    c01039e0 <do_syscall+0x491>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c010395a:	8b 45 08             	mov    0x8(%ebp),%eax
c010395d:	8b 40 10             	mov    0x10(%eax),%eax
c0103960:	0f be c0             	movsbl %al,%eax
c0103963:	83 ec 0c             	sub    $0xc,%esp
c0103966:	50                   	push   %eax
c0103967:	e8 81 fb ff ff       	call   c01034ed <serial_printc>
c010396c:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c010396f:	eb 6f                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_INIT_CACHE:
			initVCache();
c0103971:	e8 40 0b 00 00       	call   c01044b6 <initVCache>
		break;
c0103976:	eb 68                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0103978:	e8 6e 0c 00 00       	call   c01045eb <clearVRAM>
		break;
c010397d:	eb 61                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c010397f:	e8 67 0c 00 00       	call   c01045eb <clearVRAM>
			flushVCache();
c0103984:	e8 96 0b 00 00       	call   c010451f <flushVCache>
		break;
c0103989:	eb 55                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c010398b:	8b 45 08             	mov    0x8(%ebp),%eax
c010398e:	8b 40 14             	mov    0x14(%eax),%eax
c0103991:	0f b6 c0             	movzbl %al,%eax
c0103994:	8b 55 08             	mov    0x8(%ebp),%edx
c0103997:	8b 52 18             	mov    0x18(%edx),%edx
c010399a:	89 d1                	mov    %edx,%ecx
c010399c:	8b 55 08             	mov    0x8(%ebp),%edx
c010399f:	8b 52 10             	mov    0x10(%edx),%edx
c01039a2:	83 ec 04             	sub    $0x4,%esp
c01039a5:	50                   	push   %eax
c01039a6:	51                   	push   %ecx
c01039a7:	52                   	push   %edx
c01039a8:	e8 d7 0b 00 00       	call   c0104584 <setPixelAt>
c01039ad:	83 c4 10             	add    $0x10,%esp
		break;
c01039b0:	eb 2e                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c01039b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b5:	8b 40 10             	mov    0x10(%eax),%eax
c01039b8:	0f be c0             	movsbl %al,%eax
c01039bb:	83 ec 0c             	sub    $0xc,%esp
c01039be:	50                   	push   %eax
c01039bf:	e8 d8 f7 ff ff       	call   c010319c <get_key>
c01039c4:	83 c4 10             	add    $0x10,%esp
c01039c7:	0f be d0             	movsbl %al,%edx
c01039ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cd:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01039d0:	eb 0e                	jmp    c01039e0 <do_syscall+0x491>
		case SYS_GET_TICK:
			tf->eax = tick();
c01039d2:	e8 60 0d 00 00       	call   c0104737 <tick>
c01039d7:	89 c2                	mov    %eax,%edx
c01039d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039dc:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c01039df:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c01039e0:	c9                   	leave  
c01039e1:	c3                   	ret    

c01039e2 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01039e2:	55                   	push   %ebp
c01039e3:	89 e5                	mov    %esp,%ebp
c01039e5:	83 ec 10             	sub    $0x10,%esp
c01039e8:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01039ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01039f2:	89 c2                	mov    %eax,%edx
c01039f4:	ec                   	in     (%dx),%al
c01039f5:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01039f8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01039fc:	0f b6 c0             	movzbl %al,%eax
c01039ff:	83 e0 20             	and    $0x20,%eax
c0103a02:	85 c0                	test   %eax,%eax
c0103a04:	0f 95 c0             	setne  %al
c0103a07:	0f b6 c0             	movzbl %al,%eax
}
c0103a0a:	c9                   	leave  
c0103a0b:	c3                   	ret    

c0103a0c <serial_printc>:

static inline
void serial_printc(char ch) {
c0103a0c:	55                   	push   %ebp
c0103a0d:	89 e5                	mov    %esp,%ebp
c0103a0f:	83 ec 14             	sub    $0x14,%esp
c0103a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a15:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103a18:	90                   	nop
c0103a19:	e8 c4 ff ff ff       	call   c01039e2 <serial_idle>
c0103a1e:	85 c0                	test   %eax,%eax
c0103a20:	74 f7                	je     c0103a19 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0103a22:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103a26:	0f b6 c0             	movzbl %al,%eax
c0103a29:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0103a30:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103a33:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103a37:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103a3a:	ee                   	out    %al,(%dx)
}
c0103a3b:	c9                   	leave  
c0103a3c:	c3                   	ret    

c0103a3d <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0103a3d:	55                   	push   %ebp
c0103a3e:	89 e5                	mov    %esp,%ebp
c0103a40:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0103a43:	8d 45 0c             	lea    0xc(%ebp),%eax
c0103a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0103a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a4c:	83 ec 04             	sub    $0x4,%esp
c0103a4f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a52:	50                   	push   %eax
c0103a53:	68 0c 3a 10 c0       	push   $0xc0103a0c
c0103a58:	e8 5e 0e 00 00       	call   c01048bb <vfprintf>
c0103a5d:	83 c4 10             	add    $0x10,%esp
}
c0103a60:	c9                   	leave  
c0103a61:	c3                   	ret    

c0103a62 <memcpy>:

static inline void cputchar(char c) {
    serial_printc(c);
}

static inline void memcpy(void* dst, void* src, int len){
c0103a62:	55                   	push   %ebp
c0103a63:	89 e5                	mov    %esp,%ebp
c0103a65:	57                   	push   %edi
c0103a66:	56                   	push   %esi
c0103a67:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103a68:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103a71:	89 c1                	mov    %eax,%ecx
c0103a73:	89 d6                	mov    %edx,%esi
c0103a75:	89 df                	mov    %ebx,%edi
c0103a77:	fc                   	cld    
c0103a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0103a7a:	5b                   	pop    %ebx
c0103a7b:	5e                   	pop    %esi
c0103a7c:	5f                   	pop    %edi
c0103a7d:	5d                   	pop    %ebp
c0103a7e:	c3                   	ret    

c0103a7f <memcpy2>:

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}
static inline void memcpy2(void* dst, void* src, int len){
c0103a7f:	55                   	push   %ebp
c0103a80:	89 e5                	mov    %esp,%ebp
c0103a82:	57                   	push   %edi
c0103a83:	56                   	push   %esi
c0103a84:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c0103a85:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a88:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103a8e:	89 c1                	mov    %eax,%ecx
c0103a90:	89 d6                	mov    %edx,%esi
c0103a92:	89 df                	mov    %ebx,%edi
c0103a94:	fc                   	cld    
c0103a95:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c0103a97:	5b                   	pop    %ebx
c0103a98:	5e                   	pop    %esi
c0103a99:	5f                   	pop    %edi
c0103a9a:	5d                   	pop    %ebp
c0103a9b:	c3                   	ret    

c0103a9c <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103a9c:	55                   	push   %ebp
c0103a9d:	89 e5                	mov    %esp,%ebp
c0103a9f:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0103aa2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103aa5:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0103aaa:	77 16                	ja     c0103ac2 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0103aac:	ff 75 10             	pushl  0x10(%ebp)
c0103aaf:	68 04 4d 10 c0       	push   $0xc0104d04
c0103ab4:	ff 75 0c             	pushl  0xc(%ebp)
c0103ab7:	ff 75 08             	pushl  0x8(%ebp)
c0103aba:	e8 7e ff ff ff       	call   c0103a3d <printk>
c0103abf:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0103ac2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ac5:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0103aca:	c9                   	leave  
c0103acb:	c3                   	ret    

c0103acc <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0103acc:	55                   	push   %ebp
c0103acd:	89 e5                	mov    %esp,%ebp
c0103acf:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103ad2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ad5:	c1 e8 0c             	shr    $0xc,%eax
c0103ad8:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103add:	76 13                	jbe    c0103af2 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0103adf:	83 ec 08             	sub    $0x8,%esp
c0103ae2:	ff 75 10             	pushl  0x10(%ebp)
c0103ae5:	68 28 4d 10 c0       	push   $0xc0104d28
c0103aea:	e8 4e ff ff ff       	call   c0103a3d <printk>
c0103aef:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0103af2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103af5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103afa:	c9                   	leave  
c0103afb:	c3                   	ret    

c0103afc <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0103afc:	55                   	push   %ebp
c0103afd:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0103aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b02:	ba 40 6b 17 c0       	mov    $0xc0176b40,%edx
c0103b07:	29 d0                	sub    %edx,%eax
c0103b09:	c1 f8 03             	sar    $0x3,%eax
c0103b0c:	c1 e0 0c             	shl    $0xc,%eax
}
c0103b0f:	5d                   	pop    %ebp
c0103b10:	c3                   	ret    

c0103b11 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0103b11:	55                   	push   %ebp
c0103b12:	89 e5                	mov    %esp,%ebp
c0103b14:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1a:	c1 e8 0c             	shr    $0xc,%eax
c0103b1d:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103b22:	76 10                	jbe    c0103b34 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0103b24:	83 ec 0c             	sub    $0xc,%esp
c0103b27:	68 4c 4d 10 c0       	push   $0xc0104d4c
c0103b2c:	e8 0c ff ff ff       	call   c0103a3d <printk>
c0103b31:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0103b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b37:	c1 e8 0c             	shr    $0xc,%eax
c0103b3a:	c1 e0 03             	shl    $0x3,%eax
c0103b3d:	05 40 6b 17 c0       	add    $0xc0176b40,%eax
}
c0103b42:	c9                   	leave  
c0103b43:	c3                   	ret    

c0103b44 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0103b44:	55                   	push   %ebp
c0103b45:	89 e5                	mov    %esp,%ebp
c0103b47:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0103b4a:	ff 75 08             	pushl  0x8(%ebp)
c0103b4d:	e8 aa ff ff ff       	call   c0103afc <page2pa>
c0103b52:	83 c4 04             	add    $0x4,%esp
c0103b55:	83 ec 04             	sub    $0x4,%esp
c0103b58:	50                   	push   %eax
c0103b59:	6a 52                	push   $0x52
c0103b5b:	68 6b 4d 10 c0       	push   $0xc0104d6b
c0103b60:	e8 67 ff ff ff       	call   c0103acc <_kaddr>
c0103b65:	83 c4 10             	add    $0x10,%esp
}
c0103b68:	c9                   	leave  
c0103b69:	c3                   	ret    

c0103b6a <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0103b6a:	55                   	push   %ebp
c0103b6b:	89 e5                	mov    %esp,%ebp
c0103b6d:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0103b70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0103b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7a:	8b 00                	mov    (%eax),%eax
c0103b7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0103b7f:	eb 10                	jmp    c0103b91 <ll_len+0x27>
		p = p->next;
c0103b81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103b84:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103b8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0103b8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0103b91:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103b95:	75 ea                	jne    c0103b81 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0103b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103b9a:	c9                   	leave  
c0103b9b:	c3                   	ret    

c0103b9c <ll_pop>:
PCB* ll_pop(PCB** head){
c0103b9c:	55                   	push   %ebp
c0103b9d:	89 e5                	mov    %esp,%ebp
c0103b9f:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0103ba2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba5:	8b 00                	mov    (%eax),%eax
c0103ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c0103baa:	83 ec 08             	sub    $0x8,%esp
c0103bad:	ff 75 f4             	pushl  -0xc(%ebp)
c0103bb0:	ff 75 08             	pushl  0x8(%ebp)
c0103bb3:	e8 a4 00 00 00       	call   c0103c5c <ll_delete>
c0103bb8:	83 c4 10             	add    $0x10,%esp
	return p;
c0103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103bbe:	c9                   	leave  
c0103bbf:	c3                   	ret    

c0103bc0 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0103bc0:	55                   	push   %ebp
c0103bc1:	89 e5                	mov    %esp,%ebp
c0103bc3:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc9:	8b 00                	mov    (%eax),%eax
c0103bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0103bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103bd2:	75 0f                	jne    c0103be3 <ll_push+0x23>
		*head = p;
c0103bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103bda:	89 10                	mov    %edx,(%eax)
		return 0;
c0103bdc:	b8 00 00 00 00       	mov    $0x0,%eax
c0103be1:	eb 19                	jmp    c0103bfc <ll_push+0x3c>
	}else{
		*head = p;
c0103be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103be9:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0103beb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103bf1:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c0103bf7:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103bfc:	c9                   	leave  
c0103bfd:	c3                   	ret    

c0103bfe <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0103bfe:	55                   	push   %ebp
c0103bff:	89 e5                	mov    %esp,%ebp
c0103c01:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c07:	8b 00                	mov    (%eax),%eax
c0103c09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0103c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c0f:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c0103c16:	00 00 00 
	if(h == NULL){
c0103c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103c1d:	75 0f                	jne    c0103c2e <ll_entail+0x30>
		*head = p;
c0103c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c25:	89 10                	mov    %edx,(%eax)
		return 0;
c0103c27:	b8 00 00 00 00       	mov    $0x0,%eax
c0103c2c:	eb 2c                	jmp    c0103c5a <ll_entail+0x5c>
	}else{
		while(h->next){
c0103c2e:	eb 0c                	jmp    c0103c3c <ll_entail+0x3e>
			h = h->next;
c0103c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c33:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0103c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c3f:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103c45:	85 c0                	test   %eax,%eax
c0103c47:	75 e7                	jne    c0103c30 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0103c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c4f:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c0103c55:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103c5a:	c9                   	leave  
c0103c5b:	c3                   	ret    

c0103c5c <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c0103c5c:	55                   	push   %ebp
c0103c5d:	89 e5                	mov    %esp,%ebp
c0103c5f:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c0103c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c65:	8b 00                	mov    (%eax),%eax
c0103c67:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0103c6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c0103c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103c75:	75 07                	jne    c0103c7e <ll_delete+0x22>
			return 0;
c0103c77:	b8 00 00 00 00       	mov    $0x0,%eax
c0103c7c:	eb 59                	jmp    c0103cd7 <ll_delete+0x7b>
		if(sleep == p)
c0103c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c81:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103c84:	75 09                	jne    c0103c8f <ll_delete+0x33>
			break;
c0103c86:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0103c87:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103c8b:	75 26                	jne    c0103cb3 <ll_delete+0x57>
c0103c8d:	eb 14                	jmp    c0103ca3 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0103c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0103c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103c98:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103c9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0103ca1:	eb ce                	jmp    c0103c71 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c0103ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ca6:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0103caf:	89 10                	mov    %edx,(%eax)
c0103cb1:	eb 12                	jmp    c0103cc5 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0103cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103cb6:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103cbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103cbf:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
	sleep->next = NULL;
c0103cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103cc8:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c0103ccf:	00 00 00 
	return 1;
c0103cd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0103cd7:	c9                   	leave  
c0103cd8:	c3                   	ret    

c0103cd9 <init_pcb_pool>:

void init_pcb_pool()
{
c0103cd9:	55                   	push   %ebp
c0103cda:	89 e5                	mov    %esp,%ebp
c0103cdc:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103ce6:	eb 1d                	jmp    c0103d05 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0103ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103ceb:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103cf1:	05 40 20 00 00       	add    $0x2040,%eax
c0103cf6:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0103cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103d01:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103d05:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0103d0c:	76 da                	jbe    c0103ce8 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0103d0e:	c9                   	leave  
c0103d0f:	c3                   	ret    

c0103d10 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0103d10:	55                   	push   %ebp
c0103d11:	89 e5                	mov    %esp,%ebp
c0103d13:	83 ec 24             	sub    $0x24,%esp
c0103d16:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d19:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0103d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1f:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103d25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0103d28:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103d2c:	75 46                	jne    c0103d74 <init_pcb+0x64>
		tf->ds = GD_KD;
c0103d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d31:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0103d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d3b:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0103d42:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d45:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0103d4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d4e:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0103d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d58:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0103d5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d62:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d6b:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0103d72:	eb 4a                	jmp    c0103dbe <init_pcb+0xae>
	}else
	if(pri == 3){
c0103d74:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0103d78:	75 44                	jne    c0103dbe <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0103d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d7d:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0103d84:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d87:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0103d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d91:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0103d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103d9a:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0103da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103da4:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0103dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103dae:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103db4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103db7:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0103dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dc4:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0103dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103dca:	8b 55 10             	mov    0x10(%ebp),%edx
c0103dcd:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0103dd0:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103dd4:	75 59                	jne    c0103e2f <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c0103dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0103ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0103de2:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103de9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103df0:	eb 26                	jmp    c0103e18 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0103df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dff:	01 c2                	add    %eax,%edx
c0103e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103e04:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e0e:	01 c8                	add    %ecx,%eax
c0103e10:	8b 00                	mov    (%eax),%eax
c0103e12:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103e14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e1b:	c1 e8 02             	shr    $0x2,%eax
c0103e1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0103e21:	77 cf                	ja     c0103df2 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0103e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e29:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c0103e2f:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103e33:	0f 95 c0             	setne  %al
c0103e36:	0f b6 d0             	movzbl %al,%edx
c0103e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e3c:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0103e42:	c9                   	leave  
c0103e43:	c3                   	ret    

c0103e44 <pcb_create>:

PCB* pcb_create()
{
c0103e44:	55                   	push   %ebp
c0103e45:	89 e5                	mov    %esp,%ebp
c0103e47:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103e4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e51:	eb 1f                	jmp    c0103e72 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0103e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e56:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103e5c:	05 40 20 00 00       	add    $0x2040,%eax
c0103e61:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0103e66:	8b 00                	mov    (%eax),%eax
c0103e68:	85 c0                	test   %eax,%eax
c0103e6a:	75 02                	jne    c0103e6e <pcb_create+0x2a>
c0103e6c:	eb 0d                	jmp    c0103e7b <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103e6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e72:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0103e79:	76 d8                	jbe    c0103e53 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0103e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e7e:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103e84:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0103e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0103e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e8f:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0103e92:	8d 90 80 df 1f c0    	lea    -0x3fe02080(%eax),%edx
c0103e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e9b:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	for(i=0; i<FCBMAX; i++){
c0103ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ea8:	eb 17                	jmp    c0103ec1 <pcb_create+0x7d>
		p->fcb[i].fd_kr = -1;
c0103eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103eb0:	81 c2 18 08 00 00    	add    $0x818,%edx
c0103eb6:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	for(i=0; i<PCBPOOLMAX; i++){
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
	p->tf = &tfPool[i];
	for(i=0; i<FCBMAX; i++){
c0103ebd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103ec1:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0103ec8:	76 e0                	jbe    c0103eaa <pcb_create+0x66>
		p->fcb[i].fd_kr = -1;
	}
	p->used = 1;
c0103eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ecd:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c0103ed4:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0103ed7:	83 ec 0c             	sub    $0xc,%esp
c0103eda:	6a 01                	push   $0x1
c0103edc:	e8 a2 c9 ff ff       	call   c0100883 <page_alloc>
c0103ee1:	83 c4 10             	add    $0x10,%esp
c0103ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0103ee7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103eeb:	75 07                	jne    c0103ef4 <pcb_create+0xb0>
c0103eed:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ef2:	eb 77                	jmp    c0103f6b <pcb_create+0x127>
	p->pgdir = page2kva(pp);
c0103ef4:	83 ec 0c             	sub    $0xc,%esp
c0103ef7:	ff 75 ec             	pushl  -0x14(%ebp)
c0103efa:	e8 45 fc ff ff       	call   c0103b44 <page2kva>
c0103eff:	83 c4 10             	add    $0x10,%esp
c0103f02:	89 c2                	mov    %eax,%edx
c0103f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f07:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c0103f0d:	8b 15 d0 95 10 c0    	mov    0xc01095d0,%edx
c0103f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f16:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c0103f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f1f:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0103f26:	00 00 00 
	//p->ts = READY;
	pid ++;
c0103f29:	a1 d0 95 10 c0       	mov    0xc01095d0,%eax
c0103f2e:	83 c0 01             	add    $0x1,%eax
c0103f31:	a3 d0 95 10 c0       	mov    %eax,0xc01095d0
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0103f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f39:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0103f3d:	8d 50 01             	lea    0x1(%eax),%edx
c0103f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f43:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0103f47:	8b 15 00 6b 17 c0    	mov    0xc0176b00,%edx
c0103f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f50:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103f56:	83 ec 04             	sub    $0x4,%esp
c0103f59:	68 00 10 00 00       	push   $0x1000
c0103f5e:	52                   	push   %edx
c0103f5f:	50                   	push   %eax
c0103f60:	e8 fd fa ff ff       	call   c0103a62 <memcpy>
c0103f65:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0103f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103f6b:	c9                   	leave  
c0103f6c:	c3                   	ret    

c0103f6d <enready_pcb>:

void enready_pcb(PCB* pcb){
c0103f6d:	55                   	push   %ebp
c0103f6e:	89 e5                	mov    %esp,%ebp
c0103f70:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0103f73:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0103f78:	85 c0                	test   %eax,%eax
c0103f7a:	75 18                	jne    c0103f94 <enready_pcb+0x27>
		ready_list = pcb;
c0103f7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f7f:	a3 c8 74 15 c0       	mov    %eax,0xc01574c8
		ready_list->tail = pcb;
c0103f84:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0103f89:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f8c:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
c0103f92:	eb 32                	jmp    c0103fc6 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c0103f94:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0103f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c0103f9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f9f:	a3 c8 74 15 c0       	mov    %eax,0xc01574c8
		ready_list->next = temp;
c0103fa4:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0103fa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103fac:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		ready_list->tail = temp->tail;
c0103fb2:	a1 c8 74 15 c0       	mov    0xc01574c8,%eax
c0103fb7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103fba:	8b 92 64 24 00 00    	mov    0x2464(%edx),%edx
c0103fc0:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
	}
}
c0103fc6:	c9                   	leave  
c0103fc7:	c3                   	ret    

c0103fc8 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0103fc8:	55                   	push   %ebp
c0103fc9:	89 e5                	mov    %esp,%ebp
c0103fcb:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c0103fce:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd1:	a3 c4 74 15 c0       	mov    %eax,0xc01574c4
	lcr3(PADDR(pcb -> pgdir));
c0103fd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd9:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103fdf:	83 ec 04             	sub    $0x4,%esp
c0103fe2:	50                   	push   %eax
c0103fe3:	68 b2 00 00 00       	push   $0xb2
c0103fe8:	68 81 4d 10 c0       	push   $0xc0104d81
c0103fed:	e8 aa fa ff ff       	call   c0103a9c <_paddr>
c0103ff2:	83 c4 10             	add    $0x10,%esp
c0103ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0103ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ffb:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0103ffe:	83 ec 0c             	sub    $0xc,%esp
c0104001:	ff 75 08             	pushl  0x8(%ebp)
c0104004:	e8 53 c3 ff ff       	call   c010035c <enter_pcb>
c0104009:	83 c4 10             	add    $0x10,%esp
}
c010400c:	c9                   	leave  
c010400d:	c3                   	ret    

c010400e <free_pcb>:
void free_pcb(PCB* pcb){
c010400e:	55                   	push   %ebp
c010400f:	89 e5                	mov    %esp,%ebp
c0104011:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0104014:	8b 45 08             	mov    0x8(%ebp),%eax
c0104017:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010401d:	83 ec 0c             	sub    $0xc,%esp
c0104020:	50                   	push   %eax
c0104021:	e8 c1 cd ff ff       	call   c0100de7 <free_pgdir>
c0104026:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0104029:	8b 45 08             	mov    0x8(%ebp),%eax
c010402c:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104032:	83 ec 04             	sub    $0x4,%esp
c0104035:	50                   	push   %eax
c0104036:	68 bb 00 00 00       	push   $0xbb
c010403b:	68 81 4d 10 c0       	push   $0xc0104d81
c0104040:	e8 57 fa ff ff       	call   c0103a9c <_paddr>
c0104045:	83 c4 10             	add    $0x10,%esp
c0104048:	83 ec 0c             	sub    $0xc,%esp
c010404b:	50                   	push   %eax
c010404c:	e8 c0 fa ff ff       	call   c0103b11 <pa2page>
c0104051:	83 c4 10             	add    $0x10,%esp
c0104054:	83 ec 0c             	sub    $0xc,%esp
c0104057:	50                   	push   %eax
c0104058:	e8 ae c8 ff ff       	call   c010090b <page_decref>
c010405d:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c0104060:	8b 45 08             	mov    0x8(%ebp),%eax
c0104063:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c010406a:	00 00 00 

}
c010406d:	c9                   	leave  
c010406e:	c3                   	ret    

c010406f <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c010406f:	55                   	push   %ebp
c0104070:	89 e5                	mov    %esp,%ebp
c0104072:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0104075:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104078:	8b 45 08             	mov    0x8(%ebp),%eax
c010407b:	68 10 08 00 00       	push   $0x810
c0104080:	52                   	push   %edx
c0104081:	50                   	push   %eax
c0104082:	e8 db f9 ff ff       	call   c0103a62 <memcpy>
c0104087:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010408d:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0104093:	8b 45 08             	mov    0x8(%ebp),%eax
c0104096:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c010409c:	8b 45 08             	mov    0x8(%ebp),%eax
c010409f:	05 20 10 00 00       	add    $0x1020,%eax
c01040a4:	89 c2                	mov    %eax,%edx
c01040a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040a9:	05 20 10 00 00       	add    $0x1020,%eax
c01040ae:	29 c2                	sub    %eax,%edx
c01040b0:	89 d0                	mov    %edx,%eax
c01040b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c01040b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040b8:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c01040be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040c1:	01 c2                	add    %eax,%edx
c01040c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01040c6:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c01040cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040cf:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c01040d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01040d8:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c01040de:	8b 45 08             	mov    0x8(%ebp),%eax
c01040e1:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c01040e7:	85 c0                	test   %eax,%eax
c01040e9:	75 62                	jne    c010414d <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c01040eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01040ee:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01040f4:	8b 55 08             	mov    0x8(%ebp),%edx
c01040f7:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c01040fd:	8b 4a 08             	mov    0x8(%edx),%ecx
c0104100:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104103:	01 ca                	add    %ecx,%edx
c0104105:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0104108:	8b 45 08             	mov    0x8(%ebp),%eax
c010410b:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0104111:	8b 40 08             	mov    0x8(%eax),%eax
c0104114:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0104117:	eb 17                	jmp    c0104130 <copy_pcb+0xc1>
			*(ptr) += offset;
c0104119:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010411c:	8b 10                	mov    (%eax),%edx
c010411e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104121:	01 c2                	add    %eax,%edx
c0104123:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104126:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0104128:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010412b:	8b 00                	mov    (%eax),%eax
c010412d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0104130:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104133:	8b 00                	mov    (%eax),%eax
c0104135:	85 c0                	test   %eax,%eax
c0104137:	75 e0                	jne    c0104119 <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0104139:	8b 45 0c             	mov    0xc(%ebp),%eax
c010413c:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0104142:	8b 45 08             	mov    0x8(%ebp),%eax
c0104145:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c010414b:	eb 2d                	jmp    c010417a <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c010414d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104150:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0104156:	83 f8 02             	cmp    $0x2,%eax
c0104159:	74 1f                	je     c010417a <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c010415b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010415e:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0104164:	8b 45 08             	mov    0x8(%ebp),%eax
c0104167:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010416d:	83 ec 08             	sub    $0x8,%esp
c0104170:	52                   	push   %edx
c0104171:	50                   	push   %eax
c0104172:	e8 bb c9 ff ff       	call   c0100b32 <copy_pgdir>
c0104177:	83 c4 10             	add    $0x10,%esp
	}
	memcpy2(dst->fcb, src->fcb, sizeof(dst->fcb));
c010417a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010417d:	8d 90 60 20 00 00    	lea    0x2060(%eax),%edx
c0104183:	8b 45 08             	mov    0x8(%ebp),%eax
c0104186:	05 60 20 00 00       	add    $0x2060,%eax
c010418b:	83 ec 04             	sub    $0x4,%esp
c010418e:	68 00 04 00 00       	push   $0x400
c0104193:	52                   	push   %edx
c0104194:	50                   	push   %eax
c0104195:	e8 e5 f8 ff ff       	call   c0103a7f <memcpy2>
c010419a:	83 c4 10             	add    $0x10,%esp
	//lcr3(PADDR(kern_pgdir));
}
c010419d:	c9                   	leave  
c010419e:	c3                   	ret    

c010419f <fork_current>:

void switch_proc();
void fork_current(){
c010419f:	55                   	push   %ebp
c01041a0:	89 e5                	mov    %esp,%ebp
c01041a2:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c01041a5:	e8 9a fc ff ff       	call   c0103e44 <pcb_create>
c01041aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c01041ad:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01041b2:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041bb:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01041c1:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01041c6:	83 ec 08             	sub    $0x8,%esp
c01041c9:	50                   	push   %eax
c01041ca:	ff 75 f4             	pushl  -0xc(%ebp)
c01041cd:	e8 9d fe ff ff       	call   c010406f <copy_pcb>
c01041d2:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c01041d5:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01041da:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01041e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01041e3:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c01041e9:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01041ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ef:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01041f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c01041fc:	83 ec 08             	sub    $0x8,%esp
c01041ff:	ff 75 f4             	pushl  -0xc(%ebp)
c0104202:	68 c8 74 15 c0       	push   $0xc01574c8
c0104207:	e8 b4 f9 ff ff       	call   c0103bc0 <ll_push>
c010420c:	83 c4 10             	add    $0x10,%esp
}
c010420f:	c9                   	leave  
c0104210:	c3                   	ret    

c0104211 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c0104211:	55                   	push   %ebp
c0104212:	89 e5                	mov    %esp,%ebp
c0104214:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c0104217:	e8 28 fc ff ff       	call   c0103e44 <pcb_create>
c010421c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c010421f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104222:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0104229:	00 00 00 
	son->ppid = current->pid;
c010422c:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104231:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0104237:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010423a:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0104240:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104245:	83 ec 08             	sub    $0x8,%esp
c0104248:	50                   	push   %eax
c0104249:	ff 75 f4             	pushl  -0xc(%ebp)
c010424c:	e8 1e fe ff ff       	call   c010406f <copy_pcb>
c0104251:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c0104254:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104259:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c010425f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104262:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104268:	83 ec 04             	sub    $0x4,%esp
c010426b:	68 00 10 00 00       	push   $0x1000
c0104270:	52                   	push   %edx
c0104271:	50                   	push   %eax
c0104272:	e8 eb f7 ff ff       	call   c0103a62 <memcpy>
c0104277:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c010427a:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0104281:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104284:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c010428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010428d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104293:	83 ec 04             	sub    $0x4,%esp
c0104296:	68 00 20 00 00       	push   $0x2000
c010429b:	52                   	push   %edx
c010429c:	50                   	push   %eax
c010429d:	e8 ef c3 ff ff       	call   c0100691 <mm_alloc>
c01042a2:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c01042a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042a8:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042b1:	83 ea 40             	sub    $0x40,%edx
c01042b4:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c01042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ba:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042c3:	83 ea 40             	sub    $0x40,%edx
c01042c6:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c01042c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042cc:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01042d5:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c01042d8:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01042dd:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01042e6:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c01042ec:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c01042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f2:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01042f8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c01042ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104302:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0104308:	83 ec 04             	sub    $0x4,%esp
c010430b:	50                   	push   %eax
c010430c:	68 ff 00 00 00       	push   $0xff
c0104311:	68 81 4d 10 c0       	push   $0xc0104d81
c0104316:	e8 81 f7 ff ff       	call   c0103a9c <_paddr>
c010431b:	83 c4 10             	add    $0x10,%esp
c010431e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104321:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104324:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c0104327:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010432a:	83 e8 40             	sub    $0x40,%eax
c010432d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c0104330:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104333:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104336:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c0104338:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433b:	8d 50 04             	lea    0x4(%eax),%edx
c010433e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104341:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c0104343:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104348:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010434e:	83 ec 04             	sub    $0x4,%esp
c0104351:	50                   	push   %eax
c0104352:	68 05 01 00 00       	push   $0x105
c0104357:	68 81 4d 10 c0       	push   $0xc0104d81
c010435c:	e8 3b f7 ff ff       	call   c0103a9c <_paddr>
c0104361:	83 c4 10             	add    $0x10,%esp
c0104364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010436a:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c010436d:	83 ec 08             	sub    $0x8,%esp
c0104370:	ff 75 f4             	pushl  -0xc(%ebp)
c0104373:	68 c8 74 15 c0       	push   $0xc01574c8
c0104378:	e8 43 f8 ff ff       	call   c0103bc0 <ll_push>
c010437d:	83 c4 10             	add    $0x10,%esp
}
c0104380:	c9                   	leave  
c0104381:	c3                   	ret    

c0104382 <exit_current>:

void exit_current(){
c0104382:	55                   	push   %ebp
c0104383:	89 e5                	mov    %esp,%ebp
c0104385:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0104388:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c010438d:	05 68 24 00 00       	add    $0x2468,%eax
c0104392:	83 ec 0c             	sub    $0xc,%esp
c0104395:	50                   	push   %eax
c0104396:	e8 01 f8 ff ff       	call   c0103b9c <ll_pop>
c010439b:	83 c4 10             	add    $0x10,%esp
c010439e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c01043a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043a5:	75 02                	jne    c01043a9 <exit_current+0x27>
c01043a7:	eb 24                	jmp    c01043cd <exit_current+0x4b>
		if(p->used == 0) continue;
c01043a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ac:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c01043b2:	85 c0                	test   %eax,%eax
c01043b4:	75 02                	jne    c01043b8 <exit_current+0x36>
c01043b6:	eb 13                	jmp    c01043cb <exit_current+0x49>
		ll_entail(&ready_list, p);
c01043b8:	83 ec 08             	sub    $0x8,%esp
c01043bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01043be:	68 c8 74 15 c0       	push   $0xc01574c8
c01043c3:	e8 36 f8 ff ff       	call   c0103bfe <ll_entail>
c01043c8:	83 c4 10             	add    $0x10,%esp
	}
c01043cb:	eb bb                	jmp    c0104388 <exit_current+0x6>
	
	free_pcb(current);
c01043cd:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01043d2:	83 ec 0c             	sub    $0xc,%esp
c01043d5:	50                   	push   %eax
c01043d6:	e8 33 fc ff ff       	call   c010400e <free_pcb>
c01043db:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c01043de:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c01043e5:	00 00 00 
	do_scheduler();
c01043e8:	e8 be cc ff ff       	call   c01010ab <do_scheduler>
}
c01043ed:	c9                   	leave  
c01043ee:	c3                   	ret    

c01043ef <join_current>:

void join_current(int pid){
c01043ef:	55                   	push   %ebp
c01043f0:	89 e5                	mov    %esp,%ebp
c01043f2:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c01043f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01043f9:	75 05                	jne    c0104400 <join_current+0x11>
c01043fb:	e9 97 00 00 00       	jmp    c0104497 <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0104400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104407:	eb 23                	jmp    c010442c <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0104409:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440c:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104412:	05 40 20 00 00       	add    $0x2040,%eax
c0104417:	05 80 08 21 c0       	add    $0xc0210880,%eax
c010441c:	8b 50 04             	mov    0x4(%eax),%edx
c010441f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104422:	39 c2                	cmp    %eax,%edx
c0104424:	75 02                	jne    c0104428 <join_current+0x39>
c0104426:	eb 0d                	jmp    c0104435 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0104428:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010442c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0104433:	76 d4                	jbe    c0104409 <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0104435:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c010443c:	75 02                	jne    c0104440 <join_current+0x51>
c010443e:	eb 57                	jmp    c0104497 <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c0104440:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104443:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104449:	05 40 20 00 00       	add    $0x2040,%eax
c010444e:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0104453:	8b 00                	mov    (%eax),%eax
c0104455:	85 c0                	test   %eax,%eax
c0104457:	75 02                	jne    c010445b <join_current+0x6c>
c0104459:	eb 3c                	jmp    c0104497 <join_current+0xa8>
	PCB *p = &PCBPool[i];
c010445b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445e:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104464:	05 80 08 21 c0       	add    $0xc0210880,%eax
c0104469:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c010446c:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c0104471:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0104474:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104477:	05 68 24 00 00       	add    $0x2468,%eax
c010447c:	ff 75 ec             	pushl  -0x14(%ebp)
c010447f:	50                   	push   %eax
c0104480:	e8 79 f7 ff ff       	call   c0103bfe <ll_entail>
c0104485:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0104488:	c7 05 c4 74 15 c0 00 	movl   $0x0,0xc01574c4
c010448f:	00 00 00 
	do_scheduler();
c0104492:	e8 14 cc ff ff       	call   c01010ab <do_scheduler>
c0104497:	c9                   	leave  
c0104498:	c3                   	ret    

c0104499 <memcpy>:

static inline void cputchar(char c) {
    serial_printc(c);
}

static inline void memcpy(void* dst, void* src, int len){
c0104499:	55                   	push   %ebp
c010449a:	89 e5                	mov    %esp,%ebp
c010449c:	57                   	push   %edi
c010449d:	56                   	push   %esi
c010449e:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c010449f:	8b 45 10             	mov    0x10(%ebp),%eax
c01044a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01044a8:	89 c1                	mov    %eax,%ecx
c01044aa:	89 d6                	mov    %edx,%esi
c01044ac:	89 df                	mov    %ebx,%edi
c01044ae:	fc                   	cld    
c01044af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c01044b1:	5b                   	pop    %ebx
c01044b2:	5e                   	pop    %esi
c01044b3:	5f                   	pop    %edi
c01044b4:	5d                   	pop    %ebp
c01044b5:	c3                   	ret    

c01044b6 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c01044b6:	55                   	push   %ebp
c01044b7:	89 e5                	mov    %esp,%ebp
c01044b9:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c01044bc:	68 80 3e 00 00       	push   $0x3e80
c01044c1:	68 00 6f 16 c0       	push   $0xc0166f00
c01044c6:	68 00 75 15 c0       	push   $0xc0157500
c01044cb:	e8 c9 ff ff ff       	call   c0104499 <memcpy>
c01044d0:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c01044d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01044da:	eb 0f                	jmp    c01044eb <initVCache+0x35>
		VDIRTY[x] = 0;
c01044dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044df:	05 00 69 17 c0       	add    $0xc0176900,%eax
c01044e4:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c01044e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01044eb:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01044f2:	7e e8                	jle    c01044dc <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c01044f4:	c9                   	leave  
c01044f5:	c3                   	ret    

c01044f6 <refreshVCache>:
void refreshVCache(){
c01044f6:	55                   	push   %ebp
c01044f7:	89 e5                	mov    %esp,%ebp
c01044f9:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c01044fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104503:	eb 0f                	jmp    c0104514 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0104505:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104508:	05 00 69 17 c0       	add    $0xc0176900,%eax
c010450d:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0104510:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104514:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c010451b:	7e e8                	jle    c0104505 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c010451d:	c9                   	leave  
c010451e:	c3                   	ret    

c010451f <flushVCache>:
void flushVCache(){
c010451f:	55                   	push   %ebp
c0104520:	89 e5                	mov    %esp,%ebp
c0104522:	53                   	push   %ebx
c0104523:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0104526:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010452d:	eb 47                	jmp    c0104576 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c010452f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104532:	05 00 69 17 c0       	add    $0xc0176900,%eax
c0104537:	0f b6 00             	movzbl (%eax),%eax
c010453a:	84 c0                	test   %al,%al
c010453c:	74 34                	je     c0104572 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c010453e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0104541:	89 d0                	mov    %edx,%eax
c0104543:	c1 e0 02             	shl    $0x2,%eax
c0104546:	01 d0                	add    %edx,%eax
c0104548:	c1 e0 06             	shl    $0x6,%eax
c010454b:	8d 88 00 75 15 c0    	lea    -0x3fea8b00(%eax),%ecx
c0104551:	8b 1d d4 95 10 c0    	mov    0xc01095d4,%ebx
c0104557:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010455a:	89 d0                	mov    %edx,%eax
c010455c:	c1 e0 02             	shl    $0x2,%eax
c010455f:	01 d0                	add    %edx,%eax
c0104561:	c1 e0 06             	shl    $0x6,%eax
c0104564:	01 d8                	add    %ebx,%eax
c0104566:	6a 50                	push   $0x50
c0104568:	51                   	push   %ecx
c0104569:	50                   	push   %eax
c010456a:	e8 2a ff ff ff       	call   c0104499 <memcpy>
c010456f:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0104572:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0104576:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c010457d:	7e b0                	jle    c010452f <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c010457f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0104582:	c9                   	leave  
c0104583:	c3                   	ret    

c0104584 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0104584:	55                   	push   %ebp
c0104585:	89 e5                	mov    %esp,%ebp
c0104587:	83 ec 04             	sub    $0x4,%esp
c010458a:	8b 45 10             	mov    0x10(%ebp),%eax
c010458d:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0104590:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104594:	78 18                	js     c01045ae <setPixelAt+0x2a>
c0104596:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c010459d:	7f 0f                	jg     c01045ae <setPixelAt+0x2a>
c010459f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01045a3:	78 09                	js     c01045ae <setPixelAt+0x2a>
c01045a5:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c01045ac:	7e 02                	jle    c01045b0 <setPixelAt+0x2c>
c01045ae:	eb 34                	jmp    c01045e4 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c01045b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b3:	05 00 69 17 c0       	add    $0xc0176900,%eax
c01045b8:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c01045bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045be:	05 00 6a 17 c0       	add    $0xc0176a00,%eax
c01045c3:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c01045c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01045c9:	89 d0                	mov    %edx,%eax
c01045cb:	c1 e0 02             	shl    $0x2,%eax
c01045ce:	01 d0                	add    %edx,%eax
c01045d0:	c1 e0 06             	shl    $0x6,%eax
c01045d3:	89 c2                	mov    %eax,%edx
c01045d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d8:	01 c2                	add    %eax,%edx
c01045da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c01045de:	88 82 00 75 15 c0    	mov    %al,-0x3fea8b00(%edx)
}
c01045e4:	c9                   	leave  
c01045e5:	c3                   	ret    

c01045e6 <forceClearVRAM>:
void forceClearVRAM(){
c01045e6:	55                   	push   %ebp
c01045e7:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c01045e9:	5d                   	pop    %ebp
c01045ea:	c3                   	ret    

c01045eb <clearVRAM>:
void clearVRAM(){
c01045eb:	55                   	push   %ebp
c01045ec:	89 e5                	mov    %esp,%ebp
c01045ee:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01045f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01045f8:	eb 4e                	jmp    c0104648 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c01045fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01045fd:	05 00 6a 17 c0       	add    $0xc0176a00,%eax
c0104602:	0f b6 00             	movzbl (%eax),%eax
c0104605:	0f b6 c0             	movzbl %al,%eax
c0104608:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010460b:	81 c2 00 69 17 c0    	add    $0xc0176900,%edx
c0104611:	0f b6 12             	movzbl (%edx),%edx
c0104614:	0f b6 d2             	movzbl %dl,%edx
c0104617:	f7 d2                	not    %edx
c0104619:	21 d0                	and    %edx,%eax
c010461b:	85 c0                	test   %eax,%eax
c010461d:	74 25                	je     c0104644 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c010461f:	8b 0d d4 95 10 c0    	mov    0xc01095d4,%ecx
c0104625:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104628:	89 d0                	mov    %edx,%eax
c010462a:	c1 e0 02             	shl    $0x2,%eax
c010462d:	01 d0                	add    %edx,%eax
c010462f:	c1 e0 06             	shl    $0x6,%eax
c0104632:	01 c8                	add    %ecx,%eax
c0104634:	6a 50                	push   $0x50
c0104636:	68 00 6f 16 c0       	push   $0xc0166f00
c010463b:	50                   	push   %eax
c010463c:	e8 58 fe ff ff       	call   c0104499 <memcpy>
c0104641:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0104644:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104648:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c010464f:	7e a9                	jle    c01045fa <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0104651:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104658:	83 c0 01             	add    $0x1,%eax
c010465b:	a2 c8 6a 17 c0       	mov    %al,0xc0176ac8
	if(stamp==30){
c0104660:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104667:	3c 1e                	cmp    $0x1e,%al
c0104669:	75 07                	jne    c0104672 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c010466b:	c6 05 c8 6a 17 c0 00 	movb   $0x0,0xc0176ac8
		//printk("What matters\n");
	}
	if(stamp==0){
c0104672:	0f b6 05 c8 6a 17 c0 	movzbl 0xc0176ac8,%eax
c0104679:	84 c0                	test   %al,%al
c010467b:	75 14                	jne    c0104691 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c010467d:	6a 32                	push   $0x32
c010467f:	68 00 6f 16 c0       	push   $0xc0166f00
c0104684:	68 00 6a 17 c0       	push   $0xc0176a00
c0104689:	e8 0b fe ff ff       	call   c0104499 <memcpy>
c010468e:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0104691:	c9                   	leave  
c0104692:	c3                   	ret    

c0104693 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0104693:	55                   	push   %ebp
c0104694:	89 e5                	mov    %esp,%ebp
c0104696:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0104699:	a1 cc 6a 17 c0       	mov    0xc0176acc,%eax
c010469e:	83 c0 01             	add    $0x1,%eax
c01046a1:	a3 cc 6a 17 c0       	mov    %eax,0xc0176acc
	current->timeslice ++;
c01046a6:	a1 c4 74 15 c0       	mov    0xc01574c4,%eax
c01046ab:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c01046b1:	83 c2 01             	add    $0x1,%edx
c01046b4:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c01046ba:	a1 cc 74 15 c0       	mov    0xc01574cc,%eax
c01046bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c01046c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046c6:	75 02                	jne    c01046ca <do_timer+0x37>
c01046c8:	eb 6b                	jmp    c0104735 <do_timer+0xa2>
	 	sleep->timeslice --;
c01046ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cd:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c01046d3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01046d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d9:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c01046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c01046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e8:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c01046ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c01046f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f4:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c01046fa:	85 c0                	test   %eax,%eax
c01046fc:	74 02                	je     c0104700 <do_timer+0x6d>
c01046fe:	eb 33                	jmp    c0104733 <do_timer+0xa0>
	 	cur->ts = READY;
c0104700:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104703:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c010470a:	00 00 00 
		ll_delete(&sleep_list, cur);
c010470d:	83 ec 08             	sub    $0x8,%esp
c0104710:	ff 75 f0             	pushl  -0x10(%ebp)
c0104713:	68 cc 74 15 c0       	push   $0xc01574cc
c0104718:	e8 3f f5 ff ff       	call   c0103c5c <ll_delete>
c010471d:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0104720:	83 ec 08             	sub    $0x8,%esp
c0104723:	ff 75 f0             	pushl  -0x10(%ebp)
c0104726:	68 c8 74 15 c0       	push   $0xc01574c8
c010472b:	e8 ce f4 ff ff       	call   c0103bfe <ll_entail>
c0104730:	83 c4 10             	add    $0x10,%esp
	}
c0104733:	eb 8d                	jmp    c01046c2 <do_timer+0x2f>
}
c0104735:	c9                   	leave  
c0104736:	c3                   	ret    

c0104737 <tick>:
uint32_t tick(){
c0104737:	55                   	push   %ebp
c0104738:	89 e5                	mov    %esp,%ebp
	return _tick;
c010473a:	a1 cc 6a 17 c0       	mov    0xc0176acc,%eax
c010473f:	5d                   	pop    %ebp
c0104740:	c3                   	ret    

c0104741 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0104741:	6a 00                	push   $0x0
c0104743:	6a 00                	push   $0x0
c0104745:	e9 b8 00 00 00       	jmp    c0104802 <asm_do_irq>

c010474a <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c010474a:	6a 00                	push   $0x0
c010474c:	6a 01                	push   $0x1
c010474e:	e9 af 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104753 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0104753:	6a 00                	push   $0x0
c0104755:	6a 02                	push   $0x2
c0104757:	e9 a6 00 00 00       	jmp    c0104802 <asm_do_irq>

c010475c <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c010475c:	6a 00                	push   $0x0
c010475e:	6a 03                	push   $0x3
c0104760:	e9 9d 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104765 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0104765:	6a 00                	push   $0x0
c0104767:	6a 04                	push   $0x4
c0104769:	e9 94 00 00 00       	jmp    c0104802 <asm_do_irq>

c010476e <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c010476e:	6a 00                	push   $0x0
c0104770:	6a 05                	push   $0x5
c0104772:	e9 8b 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104777 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0104777:	6a 00                	push   $0x0
c0104779:	6a 06                	push   $0x6
c010477b:	e9 82 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104780 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0104780:	6a 00                	push   $0x0
c0104782:	6a 07                	push   $0x7
c0104784:	e9 79 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104789 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0104789:	6a 00                	push   $0x0
c010478b:	6a 08                	push   $0x8
c010478d:	e9 70 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104792 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0104792:	6a 00                	push   $0x0
c0104794:	6a 09                	push   $0x9
c0104796:	e9 67 00 00 00       	jmp    c0104802 <asm_do_irq>

c010479b <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c010479b:	6a 00                	push   $0x0
c010479d:	6a 0a                	push   $0xa
c010479f:	e9 5e 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047a4 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c01047a4:	6a 00                	push   $0x0
c01047a6:	6a 0b                	push   $0xb
c01047a8:	e9 55 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047ad <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c01047ad:	6a 00                	push   $0x0
c01047af:	6a 0c                	push   $0xc
c01047b1:	e9 4c 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047b6 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c01047b6:	6a 00                	push   $0x0
c01047b8:	6a 0d                	push   $0xd
c01047ba:	e9 43 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047bf <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c01047bf:	6a 00                	push   $0x0
c01047c1:	6a 0e                	push   $0xe
c01047c3:	e9 3a 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047c8 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c01047c8:	fa                   	cli    
c01047c9:	6a 00                	push   $0x0
c01047cb:	68 80 00 00 00       	push   $0x80
c01047d0:	e9 2d 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047d5 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c01047d5:	6a 00                	push   $0x0
c01047d7:	68 e8 03 00 00       	push   $0x3e8
c01047dc:	e9 21 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047e1 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c01047e1:	6a 00                	push   $0x0
c01047e3:	68 e9 03 00 00       	push   $0x3e9
c01047e8:	e9 15 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047ed <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c01047ed:	6a 00                	push   $0x0
c01047ef:	68 f6 03 00 00       	push   $0x3f6
c01047f4:	e9 09 00 00 00       	jmp    c0104802 <asm_do_irq>

c01047f9 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c01047f9:	6a 00                	push   $0x0
c01047fb:	6a ff                	push   $0xffffffff
c01047fd:	e9 00 00 00 00       	jmp    c0104802 <asm_do_irq>

c0104802 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0104802:	fa                   	cli    
  pushl %ds
c0104803:	1e                   	push   %ds
  pushl %es
c0104804:	06                   	push   %es
  pushl %fs
c0104805:	0f a0                	push   %fs
  pushl %gs
c0104807:	0f a8                	push   %gs
	pushal
c0104809:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c010480a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c010480e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0104810:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0104812:	54                   	push   %esp
  call irq_handle
c0104813:	e8 86 c9 ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0104818:	83 c4 04             	add    $0x4,%esp

c010481b <switch_proc>:
switch_proc:
  popal
c010481b:	61                   	popa   
  popl %gs
c010481c:	0f a9                	pop    %gs
  popl %fs
c010481e:	0f a1                	pop    %fs
  popl %es
c0104820:	07                   	pop    %es
  popl %ds
c0104821:	1f                   	pop    %ds
  addl $8, %esp
c0104822:	83 c4 08             	add    $0x8,%esp
  sti
c0104825:	fb                   	sti    
  iret
c0104826:	cf                   	iret   
c0104827:	90                   	nop
c0104828:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c010482e:	00 00                	add    %al,(%eax)
c0104830:	fe 4f 52             	decb   0x52(%edi)
c0104833:	e4 66                	in     $0x66,%al

c0104834 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0104834:	66 c7 05 72 04 00 00 34 12 b8 00 80 10 00 0f 22     f..r...4......."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0104844:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 57 48 10     .. ......."..WH.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0104854:	c0 ff e0                                            ...

c0104857 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0104857:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c010485c:	bc 00 20 11 c0       	mov    $0xc0112000,%esp

	# now to C code

	call	main
c0104861:	e8 b2 e1 ff ff       	call   c0102a18 <main>

c0104866 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0104866:	eb fe                	jmp    c0104866 <spin>

c0104868 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0104868:	55                   	push   %ebp
c0104869:	89 e5                	mov    %esp,%ebp
c010486b:	53                   	push   %ebx
c010486c:	83 ec 04             	sub    $0x4,%esp
c010486f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104872:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0104875:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c010487a:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c010487e:	89 d3                	mov    %edx,%ebx
c0104880:	cd 80                	int    $0x80
}
c0104882:	83 c4 04             	add    $0x4,%esp
c0104885:	5b                   	pop    %ebx
c0104886:	5d                   	pop    %ebp
c0104887:	c3                   	ret    

c0104888 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0104888:	55                   	push   %ebp
c0104889:	89 e5                	mov    %esp,%ebp
c010488b:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c010488e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0104894:	eb 19                	jmp    c01048af <printp+0x27>
		printer(cur);
c0104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104899:	0f b6 00             	movzbl (%eax),%eax
c010489c:	0f be c0             	movsbl %al,%eax
c010489f:	83 ec 0c             	sub    $0xc,%esp
c01048a2:	50                   	push   %eax
c01048a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a6:	ff d0                	call   *%eax
c01048a8:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c01048ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01048af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b2:	0f b6 00             	movzbl (%eax),%eax
c01048b5:	84 c0                	test   %al,%al
c01048b7:	75 dd                	jne    c0104896 <printp+0xe>
		printer(cur);
	}
}
c01048b9:	c9                   	leave  
c01048ba:	c3                   	ret    

c01048bb <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c01048bb:	55                   	push   %ebp
c01048bc:	89 e5                	mov    %esp,%ebp
c01048be:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c01048c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c01048c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c01048ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c01048d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01048d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c01048db:	e9 65 02 00 00       	jmp    c0104b45 <vfprintf+0x28a>

		if(cur == '%'){
c01048e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e3:	0f b6 00             	movzbl (%eax),%eax
c01048e6:	3c 25                	cmp    $0x25,%al
c01048e8:	75 0c                	jne    c01048f6 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c01048ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c01048f1:	e9 4b 02 00 00       	jmp    c0104b41 <vfprintf+0x286>
		}
		if(type == READ){
c01048f6:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c01048fa:	0f 85 26 02 00 00    	jne    c0104b26 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104903:	0f b6 00             	movzbl (%eax),%eax
c0104906:	3c 73                	cmp    $0x73,%al
c0104908:	75 35                	jne    c010493f <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c010490a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010490d:	8b 00                	mov    (%eax),%eax
c010490f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0104912:	eb 19                	jmp    c010492d <vfprintf+0x72>
					printer(*p);
c0104914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104917:	0f b6 00             	movzbl (%eax),%eax
c010491a:	0f be c0             	movsbl %al,%eax
c010491d:	83 ec 0c             	sub    $0xc,%esp
c0104920:	50                   	push   %eax
c0104921:	8b 45 08             	mov    0x8(%ebp),%eax
c0104924:	ff d0                	call   *%eax
c0104926:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0104929:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c010492d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104930:	0f b6 00             	movzbl (%eax),%eax
c0104933:	84 c0                	test   %al,%al
c0104935:	75 dd                	jne    c0104914 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0104937:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010493b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c010493f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104942:	0f b6 00             	movzbl (%eax),%eax
c0104945:	3c 78                	cmp    $0x78,%al
c0104947:	0f 85 99 00 00 00    	jne    c01049e6 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c010494d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104950:	8b 00                	mov    (%eax),%eax
c0104952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0104955:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104959:	75 1d                	jne    c0104978 <vfprintf+0xbd>
					printer('0');
c010495b:	83 ec 0c             	sub    $0xc,%esp
c010495e:	6a 30                	push   $0x30
c0104960:	8b 45 08             	mov    0x8(%ebp),%eax
c0104963:	ff d0                	call   *%eax
c0104965:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104968:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010496c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104973:	e9 c9 01 00 00       	jmp    c0104b41 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0104978:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c010497f:	eb 2d                	jmp    c01049ae <vfprintf+0xf3>
					int d=(x%16);
c0104981:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104984:	83 e0 0f             	and    $0xf,%eax
c0104987:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c010498a:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c010498e:	7e 04                	jle    c0104994 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0104990:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0104994:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104997:	83 c0 30             	add    $0x30,%eax
c010499a:	89 c1                	mov    %eax,%ecx
c010499c:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010499f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01049a2:	01 d0                	add    %edx,%eax
c01049a4:	88 08                	mov    %cl,(%eax)
					x>>=4;
c01049a6:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c01049aa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c01049ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01049b2:	75 cd                	jne    c0104981 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c01049b4:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c01049b8:	eb 1e                	jmp    c01049d8 <vfprintf+0x11d>
					printer(digits[di]);
c01049ba:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c01049bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01049c0:	01 d0                	add    %edx,%eax
c01049c2:	0f b6 00             	movzbl (%eax),%eax
c01049c5:	0f be c0             	movsbl %al,%eax
c01049c8:	83 ec 0c             	sub    $0xc,%esp
c01049cb:	50                   	push   %eax
c01049cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01049cf:	ff d0                	call   *%eax
c01049d1:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c01049d4:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c01049d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01049dc:	79 dc                	jns    c01049ba <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01049de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01049e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c01049e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e9:	0f b6 00             	movzbl (%eax),%eax
c01049ec:	3c 64                	cmp    $0x64,%al
c01049ee:	0f 85 02 01 00 00    	jne    c0104af6 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c01049f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01049f7:	8b 00                	mov    (%eax),%eax
c01049f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c01049fc:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0104a03:	75 23                	jne    c0104a28 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0104a05:	83 ec 08             	sub    $0x8,%esp
c0104a08:	68 96 4d 10 c0       	push   $0xc0104d96
c0104a0d:	ff 75 08             	pushl  0x8(%ebp)
c0104a10:	e8 73 fe ff ff       	call   c0104888 <printp>
c0104a15:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104a18:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104a1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0104a23:	e9 19 01 00 00       	jmp    c0104b41 <vfprintf+0x286>
				}
				if(x==0){
c0104a28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104a2c:	75 1e                	jne    c0104a4c <vfprintf+0x191>
					printer('0');
c0104a2e:	83 ec 0c             	sub    $0xc,%esp
c0104a31:	6a 30                	push   $0x30
c0104a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a36:	ff d0                	call   *%eax
c0104a38:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104a3b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104a3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0104a46:	90                   	nop
c0104a47:	e9 f5 00 00 00       	jmp    c0104b41 <vfprintf+0x286>
				}
				if(x<0){
c0104a4c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104a50:	79 10                	jns    c0104a62 <vfprintf+0x1a7>
					printer('-');
c0104a52:	83 ec 0c             	sub    $0xc,%esp
c0104a55:	6a 2d                	push   $0x2d
c0104a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a5a:	ff d0                	call   *%eax
c0104a5c:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0104a5f:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0104a62:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0104a69:	eb 53                	jmp    c0104abe <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0104a6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104a6e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104a73:	89 c8                	mov    %ecx,%eax
c0104a75:	f7 ea                	imul   %edx
c0104a77:	c1 fa 02             	sar    $0x2,%edx
c0104a7a:	89 c8                	mov    %ecx,%eax
c0104a7c:	c1 f8 1f             	sar    $0x1f,%eax
c0104a7f:	29 c2                	sub    %eax,%edx
c0104a81:	89 d0                	mov    %edx,%eax
c0104a83:	c1 e0 02             	shl    $0x2,%eax
c0104a86:	01 d0                	add    %edx,%eax
c0104a88:	01 c0                	add    %eax,%eax
c0104a8a:	29 c1                	sub    %eax,%ecx
c0104a8c:	89 ca                	mov    %ecx,%edx
c0104a8e:	89 d0                	mov    %edx,%eax
c0104a90:	83 c0 30             	add    $0x30,%eax
c0104a93:	89 c1                	mov    %eax,%ecx
c0104a95:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104a98:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a9b:	01 d0                	add    %edx,%eax
c0104a9d:	88 08                	mov    %cl,(%eax)
					x/=10;
c0104a9f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104aa2:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104aa7:	89 c8                	mov    %ecx,%eax
c0104aa9:	f7 ea                	imul   %edx
c0104aab:	c1 fa 02             	sar    $0x2,%edx
c0104aae:	89 c8                	mov    %ecx,%eax
c0104ab0:	c1 f8 1f             	sar    $0x1f,%eax
c0104ab3:	29 c2                	sub    %eax,%edx
c0104ab5:	89 d0                	mov    %edx,%eax
c0104ab7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0104aba:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0104abe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104ac2:	7f a7                	jg     c0104a6b <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0104ac4:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0104ac8:	eb 1e                	jmp    c0104ae8 <vfprintf+0x22d>
					printer(digits[di]);
c0104aca:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104acd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ad0:	01 d0                	add    %edx,%eax
c0104ad2:	0f b6 00             	movzbl (%eax),%eax
c0104ad5:	0f be c0             	movsbl %al,%eax
c0104ad8:	83 ec 0c             	sub    $0xc,%esp
c0104adb:	50                   	push   %eax
c0104adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104adf:	ff d0                	call   *%eax
c0104ae1:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0104ae4:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104ae8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104aec:	79 dc                	jns    c0104aca <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0104aee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104af2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0104af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104af9:	0f b6 00             	movzbl (%eax),%eax
c0104afc:	3c 63                	cmp    $0x63,%al
c0104afe:	75 1d                	jne    c0104b1d <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0104b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b03:	0f b6 00             	movzbl (%eax),%eax
c0104b06:	0f be c0             	movsbl %al,%eax
c0104b09:	83 ec 0c             	sub    $0xc,%esp
c0104b0c:	50                   	push   %eax
c0104b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b10:	ff d0                	call   *%eax
c0104b12:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0104b15:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104b19:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0104b1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0104b24:	eb 1b                	jmp    c0104b41 <vfprintf+0x286>
		}
		if(type == NONE){
c0104b26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b2a:	75 15                	jne    c0104b41 <vfprintf+0x286>
			printer(cur);
c0104b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b2f:	0f b6 00             	movzbl (%eax),%eax
c0104b32:	0f be c0             	movsbl %al,%eax
c0104b35:	83 ec 0c             	sub    $0xc,%esp
c0104b38:	50                   	push   %eax
c0104b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b3c:	ff d0                	call   *%eax
c0104b3e:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0104b41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b48:	0f b6 00             	movzbl (%eax),%eax
c0104b4b:	84 c0                	test   %al,%al
c0104b4d:	0f 85 8d fd ff ff    	jne    c01048e0 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0104b53:	c9                   	leave  
c0104b54:	c3                   	ret    

c0104b55 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0104b55:	55                   	push   %ebp
c0104b56:	89 e5                	mov    %esp,%ebp
c0104b58:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0104b5b:	8d 45 0c             	lea    0xc(%ebp),%eax
c0104b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0104b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b64:	83 ec 04             	sub    $0x4,%esp
c0104b67:	ff 75 f4             	pushl  -0xc(%ebp)
c0104b6a:	50                   	push   %eax
c0104b6b:	68 68 48 10 c0       	push   $0xc0104868
c0104b70:	e8 46 fd ff ff       	call   c01048bb <vfprintf>
c0104b75:	83 c4 10             	add    $0x10,%esp
}
c0104b78:	c9                   	leave  
c0104b79:	c3                   	ret    
