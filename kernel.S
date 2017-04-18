
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
c0100009:	66 a3 b0 10 13 c0    	mov    %ax,0xc01310b0
	data[1] = (uint32_t)addr;
c010000f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100012:	66 a3 b2 10 13 c0    	mov    %ax,0xc01310b2
	data[2] = ((uint32_t)addr) >> 16;
c0100018:	8b 45 08             	mov    0x8(%ebp),%eax
c010001b:	c1 e8 10             	shr    $0x10,%eax
c010001e:	66 a3 b4 10 13 c0    	mov    %ax,0xc01310b4
	asm volatile("lgdt (%0)" : : "r"(data));
c0100024:	b8 b0 10 13 c0       	mov    $0xc01310b0,%eax
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
c01000ba:	e8 b0 25 00 00       	call   c010266f <vfprintf>
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
c01000f0:	68 30 29 10 c0       	push   $0xc0102930
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
c0100110:	b8 00 f0 10 c0       	mov    $0xc010f000,%eax
}
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <get_kpdir>:

PDE* get_kpdir() {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
	return kpdir;
c010011a:	b8 00 00 11 c0       	mov    $0xc0110000,%eax
}
c010011f:	5d                   	pop    %ebp
c0100120:	c3                   	ret    

c0100121 <get_kptable>:

PTE* get_kptable() {
c0100121:	55                   	push   %ebp
c0100122:	89 e5                	mov    %esp,%ebp
	return kptable;
c0100124:	b8 00 10 11 c0       	mov    $0xc0111000,%eax
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
c0100131:	e8 78 06 00 00       	call   c01007ae <page_init>
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
c010013e:	c7 05 08 10 13 c0 10 	movl   $0x10,0xc0131008
c0100145:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100148:	c7 45 fc 00 10 13 c0 	movl   $0xc0131000,-0x4(%ebp)
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
c010021b:	a3 04 10 13 c0       	mov    %eax,0xc0131004
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
c01002e3:	68 80 10 13 c0       	push   $0xc0131080
c01002e8:	e8 d7 fd ff ff       	call   c01000c4 <memset>
c01002ed:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c01002f0:	6a 0a                	push   $0xa
c01002f2:	6a 00                	push   $0x0
c01002f4:	68 88 10 13 c0       	push   $0xc0131088
c01002f9:	e8 24 ff ff ff       	call   c0100222 <set_segment>
c01002fe:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c0100301:	6a 02                	push   $0x2
c0100303:	6a 00                	push   $0x0
c0100305:	68 90 10 13 c0       	push   $0xc0131090
c010030a:	e8 13 ff ff ff       	call   c0100222 <set_segment>
c010030f:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c0100312:	6a 0a                	push   $0xa
c0100314:	6a 03                	push   $0x3
c0100316:	68 98 10 13 c0       	push   $0xc0131098
c010031b:	e8 02 ff ff ff       	call   c0100222 <set_segment>
c0100320:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c0100323:	6a 02                	push   $0x2
c0100325:	6a 03                	push   $0x3
c0100327:	68 a0 10 13 c0       	push   $0xc01310a0
c010032c:	e8 f1 fe ff ff       	call   c0100222 <set_segment>
c0100331:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100334:	6a 30                	push   $0x30
c0100336:	68 80 10 13 c0       	push   $0xc0131080
c010033b:	e8 c0 fc ff ff       	call   c0100000 <write_gdtr>
c0100340:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100343:	68 a8 10 13 c0       	push   $0xc01310a8
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
c0100365:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010036b:	83 ec 04             	sub    $0x4,%esp
c010036e:	50                   	push   %eax
c010036f:	6a 71                	push   $0x71
c0100371:	68 53 29 10 c0       	push   $0xc0102953
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
c010038a:	05 10 40 00 00       	add    $0x4010,%eax
c010038f:	83 ec 0c             	sub    $0xc,%esp
c0100392:	50                   	push   %eax
c0100393:	e8 7d fe ff ff       	call   c0100215 <set_tss_esp0>
c0100398:	83 c4 10             	add    $0x10,%esp
	//printk("3\n");
	struct TrapFrame *tf = pcb->tf;
c010039b:	8b 45 08             	mov    0x8(%ebp),%eax
c010039e:	8b 80 44 40 00 00    	mov    0x4044(%eax),%eax
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
	current = pcb;
c01003fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01003fe:	a3 b0 40 15 c0       	mov    %eax,0xc01540b0
	lcr3(PADDR(pcb->pgdir));
c0100403:	8b 45 08             	mov    0x8(%ebp),%eax
c0100406:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8b 00 00 00       	push   $0x8b
c0100415:	68 53 29 10 c0       	push   $0xc0102953
c010041a:	e8 be fc ff ff       	call   c01000dd <_paddr>
c010041f:	83 c4 10             	add    $0x10,%esp
c0100422:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100428:	0f 22 d8             	mov    %eax,%cr3
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c010042b:	8b 45 08             	mov    0x8(%ebp),%eax
c010042e:	05 10 40 00 00       	add    $0x4010,%eax
c0100433:	83 ec 0c             	sub    $0xc,%esp
c0100436:	50                   	push   %eax
c0100437:	e8 d9 fd ff ff       	call   c0100215 <set_tss_esp0>
c010043c:	83 c4 10             	add    $0x10,%esp
	asm volatile("mov %0, %%esp" : : "r"(pcb->tf));
c010043f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100442:	8b 80 44 40 00 00    	mov    0x4044(%eax),%eax
c0100448:	89 c4                	mov    %eax,%esp
	asm volatile("jmp %0" : : "r"(switch_proc));
c010044a:	b8 cf 25 10 c0       	mov    $0xc01025cf,%eax
c010044f:	ff e0                	jmp    *%eax

}
c0100451:	c9                   	leave  
c0100452:	c3                   	ret    

c0100453 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
c0100453:	55                   	push   %ebp
c0100454:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100456:	8b 45 08             	mov    0x8(%ebp),%eax
c0100459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c010045f:	5d                   	pop    %ebp
c0100460:	c3                   	ret    

c0100461 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
c0100461:	55                   	push   %ebp
c0100462:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100464:	8b 45 08             	mov    0x8(%ebp),%eax
c0100467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c010046d:	5d                   	pop    %ebp
c010046e:	c3                   	ret    

c010046f <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
c010046f:	55                   	push   %ebp
c0100470:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100472:	8b 45 08             	mov    0x8(%ebp),%eax
c0100475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	c1 e8 0c             	shr    $0xc,%eax
c0100481:	25 ff ff 0f 00       	and    $0xfffff,%eax
c0100486:	89 c2                	mov    %eax,%edx
c0100488:	8b 45 08             	mov    0x8(%ebp),%eax
c010048b:	89 d1                	mov    %edx,%ecx
c010048d:	c1 e1 0c             	shl    $0xc,%ecx
c0100490:	8b 10                	mov    (%eax),%edx
c0100492:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c0100498:	09 ca                	or     %ecx,%edx
c010049a:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	0f b6 10             	movzbl (%eax),%edx
c01004a2:	83 ca 01             	or     $0x1,%edx
c01004a5:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01004a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004aa:	0f b6 10             	movzbl (%eax),%edx
c01004ad:	83 ca 02             	or     $0x2,%edx
c01004b0:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c01004b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b5:	0f b6 10             	movzbl (%eax),%edx
c01004b8:	83 ca 04             	or     $0x4,%edx
c01004bb:	88 10                	mov    %dl,(%eax)
}
c01004bd:	5d                   	pop    %ebp
c01004be:	c3                   	ret    

c01004bf <make_pte>:

void
make_pte(PTE *p, void *addr) {
c01004bf:	55                   	push   %ebp
c01004c0:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01004c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	c1 e8 0c             	shr    $0xc,%eax
c01004d1:	25 ff ff 0f 00       	and    $0xfffff,%eax
c01004d6:	89 c2                	mov    %eax,%edx
c01004d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004db:	89 d1                	mov    %edx,%ecx
c01004dd:	c1 e1 0c             	shl    $0xc,%ecx
c01004e0:	8b 10                	mov    (%eax),%edx
c01004e2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01004e8:	09 ca                	or     %ecx,%edx
c01004ea:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c01004ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ef:	0f b6 10             	movzbl (%eax),%edx
c01004f2:	83 ca 01             	or     $0x1,%edx
c01004f5:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01004f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004fa:	0f b6 10             	movzbl (%eax),%edx
c01004fd:	83 ca 02             	or     $0x2,%edx
c0100500:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c0100502:	8b 45 08             	mov    0x8(%ebp),%eax
c0100505:	0f b6 10             	movzbl (%eax),%edx
c0100508:	83 ca 04             	or     $0x4,%edx
c010050b:	88 10                	mov    %dl,(%eax)
}
c010050d:	5d                   	pop    %ebp
c010050e:	c3                   	ret    

c010050f <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c010050f:	55                   	push   %ebp
c0100510:	89 e5                	mov    %esp,%ebp
c0100512:	83 ec 10             	sub    $0x10,%esp
c0100515:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010051c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010051f:	89 c2                	mov    %eax,%edx
c0100521:	ec                   	in     (%dx),%al
c0100522:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0100525:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0100529:	0f b6 c0             	movzbl %al,%eax
c010052c:	83 e0 20             	and    $0x20,%eax
c010052f:	85 c0                	test   %eax,%eax
c0100531:	0f 95 c0             	setne  %al
c0100534:	0f b6 c0             	movzbl %al,%eax
}
c0100537:	c9                   	leave  
c0100538:	c3                   	ret    

c0100539 <serial_printc>:

static inline
void serial_printc(char ch) {
c0100539:	55                   	push   %ebp
c010053a:	89 e5                	mov    %esp,%ebp
c010053c:	83 ec 14             	sub    $0x14,%esp
c010053f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100542:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0100545:	90                   	nop
c0100546:	e8 c4 ff ff ff       	call   c010050f <serial_idle>
c010054b:	85 c0                	test   %eax,%eax
c010054d:	74 f7                	je     c0100546 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010054f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100553:	0f b6 c0             	movzbl %al,%eax
c0100556:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010055d:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100560:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100564:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100567:	ee                   	out    %al,(%dx)
}
c0100568:	c9                   	leave  
c0100569:	c3                   	ret    

c010056a <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010056a:	55                   	push   %ebp
c010056b:	89 e5                	mov    %esp,%ebp
c010056d:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0100570:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100573:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0100576:	8b 45 08             	mov    0x8(%ebp),%eax
c0100579:	83 ec 04             	sub    $0x4,%esp
c010057c:	ff 75 f4             	pushl  -0xc(%ebp)
c010057f:	50                   	push   %eax
c0100580:	68 39 05 10 c0       	push   $0xc0100539
c0100585:	e8 e5 20 00 00       	call   c010266f <vfprintf>
c010058a:	83 c4 10             	add    $0x10,%esp
}
c010058d:	c9                   	leave  
c010058e:	c3                   	ret    

c010058f <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c010058f:	55                   	push   %ebp
c0100590:	89 e5                	mov    %esp,%ebp
c0100592:	57                   	push   %edi
c0100593:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c0100594:	8b 55 10             	mov    0x10(%ebp),%edx
c0100597:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059a:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010059d:	89 d1                	mov    %edx,%ecx
c010059f:	89 df                	mov    %ebx,%edi
c01005a1:	fc                   	cld    
c01005a2:	f3 ab                	rep stos %eax,%es:(%edi)
}
c01005a4:	5b                   	pop    %ebx
c01005a5:	5f                   	pop    %edi
c01005a6:	5d                   	pop    %ebp
c01005a7:	c3                   	ret    

c01005a8 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01005a8:	55                   	push   %ebp
c01005a9:	89 e5                	mov    %esp,%ebp
c01005ab:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01005ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b1:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01005b6:	77 16                	ja     c01005ce <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01005b8:	ff 75 10             	pushl  0x10(%ebp)
c01005bb:	68 6c 29 10 c0       	push   $0xc010296c
c01005c0:	ff 75 0c             	pushl  0xc(%ebp)
c01005c3:	ff 75 08             	pushl  0x8(%ebp)
c01005c6:	e8 9f ff ff ff       	call   c010056a <printk>
c01005cb:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01005ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d1:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01005d6:	c9                   	leave  
c01005d7:	c3                   	ret    

c01005d8 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c01005d8:	55                   	push   %ebp
c01005d9:	89 e5                	mov    %esp,%ebp
c01005db:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01005de:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e1:	c1 e8 0c             	shr    $0xc,%eax
c01005e4:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01005e9:	76 13                	jbe    c01005fe <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c01005eb:	83 ec 08             	sub    $0x8,%esp
c01005ee:	ff 75 10             	pushl  0x10(%ebp)
c01005f1:	68 90 29 10 c0       	push   $0xc0102990
c01005f6:	e8 6f ff ff ff       	call   c010056a <printk>
c01005fb:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c01005fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100601:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0100606:	c9                   	leave  
c0100607:	c3                   	ret    

c0100608 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0100608:	55                   	push   %ebp
c0100609:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c010060b:	8b 45 08             	mov    0x8(%ebp),%eax
c010060e:	ba 00 37 17 c0       	mov    $0xc0173700,%edx
c0100613:	29 d0                	sub    %edx,%eax
c0100615:	c1 f8 03             	sar    $0x3,%eax
c0100618:	c1 e0 0c             	shl    $0xc,%eax
}
c010061b:	5d                   	pop    %ebp
c010061c:	c3                   	ret    

c010061d <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c010061d:	55                   	push   %ebp
c010061e:	89 e5                	mov    %esp,%ebp
c0100620:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0100623:	8b 45 08             	mov    0x8(%ebp),%eax
c0100626:	c1 e8 0c             	shr    $0xc,%eax
c0100629:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c010062e:	76 10                	jbe    c0100640 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0100630:	83 ec 0c             	sub    $0xc,%esp
c0100633:	68 b4 29 10 c0       	push   $0xc01029b4
c0100638:	e8 2d ff ff ff       	call   c010056a <printk>
c010063d:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0100640:	8b 45 08             	mov    0x8(%ebp),%eax
c0100643:	c1 e8 0c             	shr    $0xc,%eax
c0100646:	c1 e0 03             	shl    $0x3,%eax
c0100649:	05 00 37 17 c0       	add    $0xc0173700,%eax
}
c010064e:	c9                   	leave  
c010064f:	c3                   	ret    

c0100650 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0100650:	55                   	push   %ebp
c0100651:	89 e5                	mov    %esp,%ebp
c0100653:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0100656:	ff 75 08             	pushl  0x8(%ebp)
c0100659:	e8 aa ff ff ff       	call   c0100608 <page2pa>
c010065e:	83 c4 04             	add    $0x4,%esp
c0100661:	83 ec 04             	sub    $0x4,%esp
c0100664:	50                   	push   %eax
c0100665:	6a 52                	push   $0x52
c0100667:	68 d3 29 10 c0       	push   $0xc01029d3
c010066c:	e8 67 ff ff ff       	call   c01005d8 <_kaddr>
c0100671:	83 c4 10             	add    $0x10,%esp
}
c0100674:	c9                   	leave  
c0100675:	c3                   	ret    

c0100676 <mm_alloc>:
// The 'pages' array has one 'struct PageInfo' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------

void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
c0100676:	55                   	push   %ebp
c0100677:	89 e5                	mov    %esp,%ebp
c0100679:	83 ec 28             	sub    $0x28,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
c010067c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100682:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100685:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010068a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
c010068d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0100694:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100697:	8b 45 10             	mov    0x10(%ebp),%eax
c010069a:	01 c2                	add    %eax,%edx
c010069c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	83 e8 01             	sub    $0x1,%eax
c01006a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	ba 00 00 00 00       	mov    $0x0,%edx
c01006af:	f7 75 e8             	divl   -0x18(%ebp)
c01006b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006b5:	29 d0                	sub    %edx,%eax
c01006b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01006ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01006c0:	eb 2b                	jmp    c01006ed <mm_alloc+0x77>
    p = page_alloc(0);
c01006c2:	83 ec 0c             	sub    $0xc,%esp
c01006c5:	6a 00                	push   $0x0
c01006c7:	e8 9c 01 00 00       	call   c0100868 <page_alloc>
c01006cc:	83 c4 10             	add    $0x10,%esp
c01006cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
c01006d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d5:	6a 07                	push   $0x7
c01006d7:	50                   	push   %eax
c01006d8:	ff 75 dc             	pushl  -0x24(%ebp)
c01006db:	ff 75 08             	pushl  0x8(%ebp)
c01006de:	e8 84 03 00 00       	call   c0100a67 <page_insert>
c01006e3:	83 c4 10             	add    $0x10,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01006e6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006f0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01006f3:	72 cd                	jb     c01006c2 <mm_alloc+0x4c>
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}
c01006f5:	c9                   	leave  
c01006f6:	c3                   	ret    

c01006f7 <init_kern_pgdir>:

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
c01006f7:	55                   	push   %ebp
c01006f8:	89 e5                	mov    %esp,%ebp
c01006fa:	53                   	push   %ebx
c01006fb:	83 ec 24             	sub    $0x24,%esp
	int pdx;
	pde_t *pgdir = kpgdir;
c01006fe:	c7 45 e8 00 30 13 c0 	movl   $0xc0133000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c0100705:	c7 45 f0 00 40 13 c0 	movl   $0xc0134000,-0x10(%ebp)

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c010070c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100713:	eb 3a                	jmp    c010074f <init_kern_pgdir+0x58>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
c0100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100718:	05 00 03 00 00       	add    $0x300,%eax
c010071d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100724:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100727:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c010072a:	83 ec 04             	sub    $0x4,%esp
c010072d:	ff 75 f0             	pushl  -0x10(%ebp)
c0100730:	6a 36                	push   $0x36
c0100732:	68 e9 29 10 c0       	push   $0xc01029e9
c0100737:	e8 6c fe ff ff       	call   c01005a8 <_paddr>
c010073c:	83 c4 10             	add    $0x10,%esp
c010073f:	83 c8 03             	or     $0x3,%eax
c0100742:	89 03                	mov    %eax,(%ebx)
		pgtable += NPTENTRIES;
c0100744:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c010074b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010074f:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0100753:	7e c0                	jle    c0100715 <init_kern_pgdir+0x1e>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
c0100755:	c7 45 ec 00 f0 ff 07 	movl   $0x7fff000,-0x14(%ebp)
	pgtable--;
c010075c:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100760:	eb 18                	jmp    c010077a <init_kern_pgdir+0x83>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
c0100762:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100765:	83 c8 07             	or     $0x7,%eax
c0100768:	89 c2                	mov    %eax,%edx
c010076a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010076d:	89 10                	mov    %edx,(%eax)
		pgtable --;
c010076f:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100773:	81 6d ec 00 10 00 00 	subl   $0x1000,-0x14(%ebp)
c010077a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010077e:	79 e2                	jns    c0100762 <init_kern_pgdir+0x6b>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
c0100780:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100783:	a3 c0 36 17 c0       	mov    %eax,0xc01736c0
	lcr3(PADDR(kern_pgdir));	
c0100788:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c010078d:	83 ec 04             	sub    $0x4,%esp
c0100790:	50                   	push   %eax
c0100791:	6a 43                	push   $0x43
c0100793:	68 e9 29 10 c0       	push   $0xc01029e9
c0100798:	e8 0b fe ff ff       	call   c01005a8 <_paddr>
c010079d:	83 c4 10             	add    $0x10,%esp
c01007a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01007a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007a6:	0f 22 d8             	mov    %eax,%cr3
}
c01007a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01007ac:	c9                   	leave  
c01007ad:	c3                   	ret    

c01007ae <page_init>:
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
c01007ae:	55                   	push   %ebp
c01007af:	89 e5                	mov    %esp,%ebp
c01007b1:	83 ec 18             	sub    $0x18,%esp
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	
c01007b4:	e8 3e ff ff ff       	call   c01006f7 <init_kern_pgdir>

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
c01007b9:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	for (i = 0; i < base; i++) {
c01007c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01007c7:	eb 11                	jmp    c01007da <page_init+0x2c>
		pages[i].pp_ref = 1;
c01007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cc:	66 c7 04 c5 04 37 17 	movw   $0x1,-0x3fe8c8fc(,%eax,8)
c01007d3:	c0 01 00 
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
c01007d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01007da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01007dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01007e0:	77 e7                	ja     c01007c9 <page_init+0x1b>
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c01007e2:	c7 45 f4 ff 7f 00 00 	movl   $0x7fff,-0xc(%ebp)
c01007e9:	eb 31                	jmp    c010081c <page_init+0x6e>
		pages[i].pp_ref = 0;
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	66 c7 04 c5 04 37 17 	movw   $0x0,-0x3fe8c8fc(,%eax,8)
c01007f5:	c0 00 00 
		pages[i].pp_link = page_free_list;
c01007f8:	8b 15 00 20 13 c0    	mov    0xc0132000,%edx
c01007fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100801:	89 14 c5 00 37 17 c0 	mov    %edx,-0x3fe8c900(,%eax,8)
		page_free_list = &pages[i];
c0100808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010080b:	c1 e0 03             	shl    $0x3,%eax
c010080e:	05 00 37 17 c0       	add    $0xc0173700,%eax
c0100813:	a3 00 20 13 c0       	mov    %eax,0xc0132000
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c0100818:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010081c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010081f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100822:	76 c7                	jbe    c01007eb <page_init+0x3d>
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
c0100824:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
c010082b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010082e:	05 ff f9 00 00       	add    $0xf9ff,%eax
c0100833:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0100836:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100839:	ba 00 00 00 00       	mov    $0x0,%edx
c010083e:	f7 75 ec             	divl   -0x14(%ebp)
c0100841:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100844:	29 d0                	sub    %edx,%eax
c0100846:	89 c2                	mov    %eax,%edx
c0100848:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c010084d:	83 ec 0c             	sub    $0xc,%esp
c0100850:	6a 03                	push   $0x3
c0100852:	68 00 00 0a 00       	push   $0xa0000
c0100857:	52                   	push   %edx
c0100858:	68 00 00 0a 00       	push   $0xa0000
c010085d:	50                   	push   %eax
c010085e:	e8 a1 01 00 00       	call   c0100a04 <boot_map_region>
c0100863:	83 c4 20             	add    $0x20,%esp
}
c0100866:	c9                   	leave  
c0100867:	c3                   	ret    

c0100868 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
c0100868:	55                   	push   %ebp
c0100869:	89 e5                	mov    %esp,%ebp
c010086b:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	struct PageInfo *p = page_free_list;
c010086e:	a1 00 20 13 c0       	mov    0xc0132000,%eax
c0100873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL) return NULL;
c0100876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010087a:	75 07                	jne    c0100883 <page_alloc+0x1b>
c010087c:	b8 00 00 00 00       	mov    $0x0,%eax
c0100881:	eb 43                	jmp    c01008c6 <page_alloc+0x5e>
	if (alloc_flags & ALLOC_ZERO) {
c0100883:	8b 45 08             	mov    0x8(%ebp),%eax
c0100886:	83 e0 01             	and    $0x1,%eax
c0100889:	85 c0                	test   %eax,%eax
c010088b:	74 21                	je     c01008ae <page_alloc+0x46>
		memset(page2kva(p), 0, PGSIZE);
c010088d:	83 ec 0c             	sub    $0xc,%esp
c0100890:	ff 75 f4             	pushl  -0xc(%ebp)
c0100893:	e8 b8 fd ff ff       	call   c0100650 <page2kva>
c0100898:	83 c4 10             	add    $0x10,%esp
c010089b:	83 ec 04             	sub    $0x4,%esp
c010089e:	68 00 10 00 00       	push   $0x1000
c01008a3:	6a 00                	push   $0x0
c01008a5:	50                   	push   %eax
c01008a6:	e8 e4 fc ff ff       	call   c010058f <memset>
c01008ab:	83 c4 10             	add    $0x10,%esp
	}
	page_free_list = page_free_list -> pp_link;
c01008ae:	a1 00 20 13 c0       	mov    0xc0132000,%eax
c01008b3:	8b 00                	mov    (%eax),%eax
c01008b5:	a3 00 20 13 c0       	mov    %eax,0xc0132000
	p -> pp_link = NULL;
c01008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return p;
c01008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01008c6:	c9                   	leave  
c01008c7:	c3                   	ret    

c01008c8 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
c01008c8:	55                   	push   %ebp
c01008c9:	89 e5                	mov    %esp,%ebp
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	//assert(pp->pp_ref == 0 && pp->pp_link == NULL);
	pp->pp_link = page_free_list;
c01008cb:	8b 15 00 20 13 c0    	mov    0xc0132000,%edx
c01008d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01008d4:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c01008d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01008d9:	a3 00 20 13 c0       	mov    %eax,0xc0132000
}
c01008de:	5d                   	pop    %ebp
c01008df:	c3                   	ret    

c01008e0 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
c01008e0:	55                   	push   %ebp
c01008e1:	89 e5                	mov    %esp,%ebp
	if (--pp->pp_ref == 0)
c01008e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01008e6:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01008ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c01008ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01008f0:	66 89 50 04          	mov    %dx,0x4(%eax)
c01008f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01008f7:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01008fb:	66 85 c0             	test   %ax,%ax
c01008fe:	75 0b                	jne    c010090b <page_decref+0x2b>
		page_free(pp);
c0100900:	ff 75 08             	pushl  0x8(%ebp)
c0100903:	e8 c0 ff ff ff       	call   c01008c8 <page_free>
c0100908:	83 c4 04             	add    $0x4,%esp
}
c010090b:	c9                   	leave  
c010090c:	c3                   	ret    

c010090d <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	53                   	push   %ebx
c0100911:	83 ec 14             	sub    $0x14,%esp
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);
c0100914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100917:	c1 e8 16             	shr    $0x16,%eax
c010091a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (pgdir[pdx] & PTE_P) {
c010091d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100920:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100927:	8b 45 08             	mov    0x8(%ebp),%eax
c010092a:	01 d0                	add    %edx,%eax
c010092c:	8b 00                	mov    (%eax),%eax
c010092e:	83 e0 01             	and    $0x1,%eax
c0100931:	85 c0                	test   %eax,%eax
c0100933:	74 31                	je     c0100966 <pgdir_walk+0x59>
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100938:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010093f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100942:	01 d0                	add    %edx,%eax
c0100944:	8b 00                	mov    (%eax),%eax
c0100946:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010094b:	83 ec 04             	sub    $0x4,%esp
c010094e:	50                   	push   %eax
c010094f:	68 bc 00 00 00       	push   $0xbc
c0100954:	68 e9 29 10 c0       	push   $0xc01029e9
c0100959:	e8 7a fc ff ff       	call   c01005d8 <_kaddr>
c010095e:	83 c4 10             	add    $0x10,%esp
c0100961:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100964:	eb 7c                	jmp    c01009e2 <pgdir_walk+0xd5>
	}
	else {
		if (create == false) return NULL;
c0100966:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010096a:	75 0a                	jne    c0100976 <pgdir_walk+0x69>
c010096c:	b8 00 00 00 00       	mov    $0x0,%eax
c0100971:	e9 89 00 00 00       	jmp    c01009ff <pgdir_walk+0xf2>

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
c0100976:	83 ec 0c             	sub    $0xc,%esp
c0100979:	6a 01                	push   $0x1
c010097b:	e8 e8 fe ff ff       	call   c0100868 <page_alloc>
c0100980:	83 c4 10             	add    $0x10,%esp
c0100983:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p == NULL) return NULL;
c0100986:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010098a:	75 07                	jne    c0100993 <pgdir_walk+0x86>
c010098c:	b8 00 00 00 00       	mov    $0x0,%eax
c0100991:	eb 6c                	jmp    c01009ff <pgdir_walk+0xf2>

		pgtable = page2kva(p);
c0100993:	83 ec 0c             	sub    $0xc,%esp
c0100996:	ff 75 ec             	pushl  -0x14(%ebp)
c0100999:	e8 b2 fc ff ff       	call   c0100650 <page2kva>
c010099e:	83 c4 10             	add    $0x10,%esp
c01009a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p -> pp_ref ++;
c01009a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009a7:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01009ab:	8d 50 01             	lea    0x1(%eax),%edx
c01009ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009b1:	66 89 50 04          	mov    %dx,0x4(%eax)

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
c01009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01009c2:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c01009c5:	83 ec 04             	sub    $0x4,%esp
c01009c8:	ff 75 f4             	pushl  -0xc(%ebp)
c01009cb:	68 c7 00 00 00       	push   $0xc7
c01009d0:	68 e9 29 10 c0       	push   $0xc01029e9
c01009d5:	e8 ce fb ff ff       	call   c01005a8 <_paddr>
c01009da:	83 c4 10             	add    $0x10,%esp
c01009dd:	83 c8 07             	or     $0x7,%eax
c01009e0:	89 03                	mov    %eax,(%ebx)
	}
	int ptx = PTX(va);
c01009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009e5:	c1 e8 0c             	shr    $0xc,%eax
c01009e8:	25 ff 03 00 00       	and    $0x3ff,%eax
c01009ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
	return &pgtable[ptx];
c01009f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fd:	01 d0                	add    %edx,%eax
}
c01009ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100a02:	c9                   	leave  
c0100a03:	c3                   	ret    

c0100a04 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
c0100a04:	55                   	push   %ebp
c0100a05:	89 e5                	mov    %esp,%ebp
c0100a07:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	int i;
	int n = size / PGSIZE;
c0100a0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100a0d:	c1 e8 0c             	shr    $0xc,%eax
c0100a10:	89 45 f0             	mov    %eax,-0x10(%ebp)

	for (i = 0; i < n; i ++) {
c0100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a1a:	eb 41                	jmp    c0100a5d <boot_map_region+0x59>
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
c0100a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a1f:	83 ec 04             	sub    $0x4,%esp
c0100a22:	6a 01                	push   $0x1
c0100a24:	50                   	push   %eax
c0100a25:	ff 75 08             	pushl  0x8(%ebp)
c0100a28:	e8 e0 fe ff ff       	call   c010090d <pgdir_walk>
c0100a2d:	83 c4 10             	add    $0x10,%esp
c0100a30:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pte == NULL) return;
c0100a33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100a37:	75 02                	jne    c0100a3b <boot_map_region+0x37>
c0100a39:	eb 2a                	jmp    c0100a65 <boot_map_region+0x61>

		*pte = pa | perm | PTE_P;
c0100a3b:	8b 45 18             	mov    0x18(%ebp),%eax
c0100a3e:	0b 45 14             	or     0x14(%ebp),%eax
c0100a41:	83 c8 01             	or     $0x1,%eax
c0100a44:	89 c2                	mov    %eax,%edx
c0100a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a49:	89 10                	mov    %edx,(%eax)

		va += PGSIZE;
c0100a4b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
		pa += PGSIZE;
c0100a52:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
c0100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100a63:	7c b7                	jl     c0100a1c <boot_map_region+0x18>
		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}
c0100a65:	c9                   	leave  
c0100a66:	c3                   	ret    

c0100a67 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
c0100a67:	55                   	push   %ebp
c0100a68:	89 e5                	mov    %esp,%ebp
c0100a6a:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, true);
c0100a6d:	83 ec 04             	sub    $0x4,%esp
c0100a70:	6a 01                	push   $0x1
c0100a72:	ff 75 10             	pushl  0x10(%ebp)
c0100a75:	ff 75 08             	pushl  0x8(%ebp)
c0100a78:	e8 90 fe ff ff       	call   c010090d <pgdir_walk>
c0100a7d:	83 c4 10             	add    $0x10,%esp
c0100a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) {
c0100a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a87:	75 07                	jne    c0100a90 <page_insert+0x29>
		return -1;
c0100a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100a8e:	eb 75                	jmp    c0100b05 <page_insert+0x9e>
//		return -E_NO_MEM;
	}

	physaddr_t pa = page2pa(pp);
c0100a90:	83 ec 0c             	sub    $0xc,%esp
c0100a93:	ff 75 0c             	pushl  0xc(%ebp)
c0100a96:	e8 6d fb ff ff       	call   c0100608 <page2pa>
c0100a9b:	83 c4 10             	add    $0x10,%esp
c0100a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (*pte & PTE_P) {
c0100aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aa4:	8b 00                	mov    (%eax),%eax
c0100aa6:	83 e0 01             	and    $0x1,%eax
c0100aa9:	85 c0                	test   %eax,%eax
c0100aab:	74 32                	je     c0100adf <page_insert+0x78>
		if (PTE_ADDR(*pte) == pa) {
c0100aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab0:	8b 00                	mov    (%eax),%eax
c0100ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100ab7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100aba:	75 12                	jne    c0100ace <page_insert+0x67>
			*pte = pa | perm | PTE_P;
c0100abc:	8b 45 14             	mov    0x14(%ebp),%eax
c0100abf:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100ac2:	83 c8 01             	or     $0x1,%eax
c0100ac5:	89 c2                	mov    %eax,%edx
c0100ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aca:	89 10                	mov    %edx,(%eax)
c0100acc:	eb 11                	jmp    c0100adf <page_insert+0x78>
		}
		else {
			page_remove(pgdir, va);
c0100ace:	83 ec 08             	sub    $0x8,%esp
c0100ad1:	ff 75 10             	pushl  0x10(%ebp)
c0100ad4:	ff 75 08             	pushl  0x8(%ebp)
c0100ad7:	e8 7a 00 00 00       	call   c0100b56 <page_remove>
c0100adc:	83 c4 10             	add    $0x10,%esp
		}
	}
	*pte = pa | perm | PTE_P;
c0100adf:	8b 45 14             	mov    0x14(%ebp),%eax
c0100ae2:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100ae5:	83 c8 01             	or     $0x1,%eax
c0100ae8:	89 c2                	mov    %eax,%edx
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	89 10                	mov    %edx,(%eax)
	pp -> pp_ref ++;
c0100aef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100af6:	8d 50 01             	lea    0x1(%eax),%edx
c0100af9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afc:	66 89 50 04          	mov    %dx,0x4(%eax)
	return 0;
c0100b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b05:	c9                   	leave  
c0100b06:	c3                   	ret    

c0100b07 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
c0100b07:	55                   	push   %ebp
c0100b08:	89 e5                	mov    %esp,%ebp
c0100b0a:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, false);
c0100b0d:	83 ec 04             	sub    $0x4,%esp
c0100b10:	6a 00                	push   $0x0
c0100b12:	ff 75 0c             	pushl  0xc(%ebp)
c0100b15:	ff 75 08             	pushl  0x8(%ebp)
c0100b18:	e8 f0 fd ff ff       	call   c010090d <pgdir_walk>
c0100b1d:	83 c4 10             	add    $0x10,%esp
c0100b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) return NULL;
c0100b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b27:	75 07                	jne    c0100b30 <page_lookup+0x29>
c0100b29:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b2e:	eb 24                	jmp    c0100b54 <page_lookup+0x4d>
	if (pte_store != NULL) *pte_store = pte;
c0100b30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100b34:	74 08                	je     c0100b3e <page_lookup+0x37>
c0100b36:	8b 45 10             	mov    0x10(%ebp),%eax
c0100b39:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b3c:	89 10                	mov    %edx,(%eax)
	return pa2page(PTE_ADDR(*pte));
c0100b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b41:	8b 00                	mov    (%eax),%eax
c0100b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b48:	83 ec 0c             	sub    $0xc,%esp
c0100b4b:	50                   	push   %eax
c0100b4c:	e8 cc fa ff ff       	call   c010061d <pa2page>
c0100b51:	83 c4 10             	add    $0x10,%esp
}
c0100b54:	c9                   	leave  
c0100b55:	c3                   	ret    

c0100b56 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
c0100b56:	55                   	push   %ebp
c0100b57:	89 e5                	mov    %esp,%ebp
c0100b59:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte;
	pte_t **pte_store = &pte;
c0100b5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0100b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);
c0100b62:	83 ec 04             	sub    $0x4,%esp
c0100b65:	ff 75 f4             	pushl  -0xc(%ebp)
c0100b68:	ff 75 0c             	pushl  0xc(%ebp)
c0100b6b:	ff 75 08             	pushl  0x8(%ebp)
c0100b6e:	e8 94 ff ff ff       	call   c0100b07 <page_lookup>
c0100b73:	83 c4 10             	add    $0x10,%esp
c0100b76:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (p != NULL) {
c0100b79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b7d:	74 2a                	je     c0100ba9 <page_remove+0x53>
		**pte_store = 0;
c0100b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b82:	8b 00                	mov    (%eax),%eax
c0100b84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(p);
c0100b8a:	83 ec 0c             	sub    $0xc,%esp
c0100b8d:	ff 75 f0             	pushl  -0x10(%ebp)
c0100b90:	e8 4b fd ff ff       	call   c01008e0 <page_decref>
c0100b95:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
c0100b98:	83 ec 08             	sub    $0x8,%esp
c0100b9b:	ff 75 0c             	pushl  0xc(%ebp)
c0100b9e:	ff 75 08             	pushl  0x8(%ebp)
c0100ba1:	e8 05 00 00 00       	call   c0100bab <tlb_invalidate>
c0100ba6:	83 c4 10             	add    $0x10,%esp
	}
}
c0100ba9:	c9                   	leave  
c0100baa:	c3                   	ret    

c0100bab <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
c0100bab:	55                   	push   %ebp
c0100bac:	89 e5                	mov    %esp,%ebp
c0100bae:	83 ec 10             	sub    $0x10,%esp
c0100bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
c0100bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100bba:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
c0100bbd:	c9                   	leave  
c0100bbe:	c3                   	ret    

c0100bbf <free_pgdir>:

void free_pgdir(pde_t *pgdir)
{
c0100bbf:	55                   	push   %ebp
c0100bc0:	89 e5                	mov    %esp,%ebp
c0100bc2:	83 ec 18             	sub    $0x18,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100bc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bcc:	e9 09 01 00 00       	jmp    c0100cda <free_pgdir+0x11b>
		if (pgdir[pdx] & PTE_P) {
c0100bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bde:	01 d0                	add    %edx,%eax
c0100be0:	8b 00                	mov    (%eax),%eax
c0100be2:	83 e0 01             	and    $0x1,%eax
c0100be5:	85 c0                	test   %eax,%eax
c0100be7:	0f 84 e9 00 00 00    	je     c0100cd6 <free_pgdir+0x117>
			if (kern_pgdir[pdx] & PTE_P) continue;
c0100bed:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0100bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bf5:	c1 e2 02             	shl    $0x2,%edx
c0100bf8:	01 d0                	add    %edx,%eax
c0100bfa:	8b 00                	mov    (%eax),%eax
c0100bfc:	83 e0 01             	and    $0x1,%eax
c0100bff:	85 c0                	test   %eax,%eax
c0100c01:	74 05                	je     c0100c08 <free_pgdir+0x49>
c0100c03:	e9 ce 00 00 00       	jmp    c0100cd6 <free_pgdir+0x117>
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c15:	01 d0                	add    %edx,%eax
c0100c17:	8b 00                	mov    (%eax),%eax
c0100c19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c1e:	83 ec 04             	sub    $0x4,%esp
c0100c21:	50                   	push   %eax
c0100c22:	68 5d 01 00 00       	push   $0x15d
c0100c27:	68 e9 29 10 c0       	push   $0xc01029e9
c0100c2c:	e8 a7 f9 ff ff       	call   c01005d8 <_kaddr>
c0100c31:	83 c4 10             	add    $0x10,%esp
c0100c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100c37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100c3e:	eb 4a                	jmp    c0100c8a <free_pgdir+0xcb>
				if (pgtable[ptx] & PTE_P) {
c0100c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c4d:	01 d0                	add    %edx,%eax
c0100c4f:	8b 00                	mov    (%eax),%eax
c0100c51:	83 e0 01             	and    $0x1,%eax
c0100c54:	85 c0                	test   %eax,%eax
c0100c56:	74 2e                	je     c0100c86 <free_pgdir+0xc7>
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
c0100c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c65:	01 d0                	add    %edx,%eax
c0100c67:	8b 00                	mov    (%eax),%eax
c0100c69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c6e:	83 ec 0c             	sub    $0xc,%esp
c0100c71:	50                   	push   %eax
c0100c72:	e8 a6 f9 ff ff       	call   c010061d <pa2page>
c0100c77:	83 c4 10             	add    $0x10,%esp
c0100c7a:	83 ec 0c             	sub    $0xc,%esp
c0100c7d:	50                   	push   %eax
c0100c7e:	e8 5d fc ff ff       	call   c01008e0 <page_decref>
c0100c83:	83 c4 10             	add    $0x10,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100c86:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100c8a:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100c91:	7e ad                	jle    c0100c40 <free_pgdir+0x81>
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ca0:	01 d0                	add    %edx,%eax
c0100ca2:	8b 00                	mov    (%eax),%eax
c0100ca4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100ca9:	83 ec 0c             	sub    $0xc,%esp
c0100cac:	50                   	push   %eax
c0100cad:	e8 6b f9 ff ff       	call   c010061d <pa2page>
c0100cb2:	83 c4 10             	add    $0x10,%esp
c0100cb5:	83 ec 0c             	sub    $0xc,%esp
c0100cb8:	50                   	push   %eax
c0100cb9:	e8 22 fc ff ff       	call   c01008e0 <page_decref>
c0100cbe:	83 c4 10             	add    $0x10,%esp
			pgdir[pdx] = 0;
c0100cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cce:	01 d0                	add    %edx,%eax
c0100cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100cd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cda:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100ce1:	0f 8e ea fe ff ff    	jle    c0100bd1 <free_pgdir+0x12>
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}
c0100ce7:	c9                   	leave  
c0100ce8:	c3                   	ret    

c0100ce9 <do_scheduler>:

//PCB* ready;



void do_scheduler(){
c0100ce9:	55                   	push   %ebp
c0100cea:	89 e5                	mov    %esp,%ebp
c0100cec:	83 ec 08             	sub    $0x8,%esp
	count ++;
c0100cef:	a1 04 40 15 c0       	mov    0xc0154004,%eax
c0100cf4:	83 c0 01             	add    $0x1,%eax
c0100cf7:	a3 04 40 15 c0       	mov    %eax,0xc0154004

	if(current == NULL){
c0100cfc:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d01:	85 c0                	test   %eax,%eax
c0100d03:	75 49                	jne    c0100d4e <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c0100d05:	83 ec 0c             	sub    $0xc,%esp
c0100d08:	68 b4 40 15 c0       	push   $0xc01540b4
c0100d0d:	e8 05 11 00 00       	call   c0101e17 <ll_pop>
c0100d12:	83 c4 10             	add    $0x10,%esp
c0100d15:	a3 b0 40 15 c0       	mov    %eax,0xc01540b0

		current->ts = RUNNING;
c0100d1a:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d1f:	c7 80 3c 40 00 00 01 	movl   $0x1,0x403c(%eax)
c0100d26:	00 00 00 
		current->timeslice = 0;
c0100d29:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d2e:	c7 80 40 40 00 00 00 	movl   $0x0,0x4040(%eax)
c0100d35:	00 00 00 

		scheduler_switch(current);
c0100d38:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d3d:	83 ec 0c             	sub    $0xc,%esp
c0100d40:	50                   	push   %eax
c0100d41:	e8 af f6 ff ff       	call   c01003f5 <scheduler_switch>
c0100d46:	83 c4 10             	add    $0x10,%esp
		return;
c0100d49:	e9 8c 00 00 00       	jmp    c0100dda <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c0100d4e:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d53:	8b 80 3c 40 00 00    	mov    0x403c(%eax),%eax
c0100d59:	83 f8 03             	cmp    $0x3,%eax
c0100d5c:	75 27                	jne    c0100d85 <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c0100d5e:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d63:	83 ec 08             	sub    $0x8,%esp
c0100d66:	50                   	push   %eax
c0100d67:	68 b8 40 15 c0       	push   $0xc01540b8
c0100d6c:	e8 08 11 00 00       	call   c0101e79 <ll_entail>
c0100d71:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c0100d74:	c7 05 b0 40 15 c0 00 	movl   $0x0,0xc01540b0
c0100d7b:	00 00 00 
		do_scheduler();
c0100d7e:	e8 66 ff ff ff       	call   c0100ce9 <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c0100d83:	eb 55                	jmp    c0100dda <do_scheduler+0xf1>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 3 || current->ts == STOP){
c0100d85:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d8a:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c0100d90:	83 f8 03             	cmp    $0x3,%eax
c0100d93:	77 10                	ja     c0100da5 <do_scheduler+0xbc>
c0100d95:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d9a:	8b 80 3c 40 00 00    	mov    0x403c(%eax),%eax
c0100da0:	83 f8 02             	cmp    $0x2,%eax
c0100da3:	75 35                	jne    c0100dda <do_scheduler+0xf1>

		current->ts = READY;
c0100da5:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100daa:	c7 80 3c 40 00 00 00 	movl   $0x0,0x403c(%eax)
c0100db1:	00 00 00 

		ll_entail(&ready_list, current);
c0100db4:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100db9:	83 ec 08             	sub    $0x8,%esp
c0100dbc:	50                   	push   %eax
c0100dbd:	68 b4 40 15 c0       	push   $0xc01540b4
c0100dc2:	e8 b2 10 00 00       	call   c0101e79 <ll_entail>
c0100dc7:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c0100dca:	c7 05 b0 40 15 c0 00 	movl   $0x0,0xc01540b0
c0100dd1:	00 00 00 
		do_scheduler();
c0100dd4:	e8 10 ff ff ff       	call   c0100ce9 <do_scheduler>
		//scheduler_switch(current);
		return;
c0100dd9:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0100dda:	c9                   	leave  
c0100ddb:	c3                   	ret    

c0100ddc <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0100ddc:	55                   	push   %ebp
c0100ddd:	89 e5                	mov    %esp,%ebp
c0100ddf:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c0100de2:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100de7:	8b 55 08             	mov    0x8(%ebp),%edx
c0100dea:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0100df0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100df3:	8b 40 30             	mov    0x30(%eax),%eax
c0100df6:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0100dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100dfe:	8b 40 30             	mov    0x30(%eax),%eax
c0100e01:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100e06:	75 0e                	jne    c0100e16 <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c0100e08:	83 ec 0c             	sub    $0xc,%esp
c0100e0b:	ff 75 08             	pushl  0x8(%ebp)
c0100e0e:	e8 d3 0c 00 00       	call   c0101ae6 <do_syscall>
c0100e13:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0100e16:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e19:	8b 40 30             	mov    0x30(%eax),%eax
c0100e1c:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0100e21:	75 0f                	jne    c0100e32 <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0100e23:	e8 1f 16 00 00       	call   c0102447 <do_timer>
		do_scheduler();
c0100e28:	e8 bc fe ff ff       	call   c0100ce9 <do_scheduler>
c0100e2d:	e9 83 00 00 00       	jmp    c0100eb5 <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c0100e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e35:	8b 40 30             	mov    0x30(%eax),%eax
c0100e38:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0100e3d:	75 76                	jne    c0100eb5 <irq_handle+0xd9>
c0100e3f:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0100e4f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0100e53:	0f b6 c0             	movzbl %al,%eax
c0100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100e59:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100e63:	89 c2                	mov    %eax,%edx
c0100e65:	ec                   	in     (%dx),%al
c0100e66:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0100e69:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0100e6d:	0f b6 c0             	movzbl %al,%eax
c0100e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0100e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e76:	83 c8 80             	or     $0xffffff80,%eax
c0100e79:	0f b6 c0             	movzbl %al,%eax
c0100e7c:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0100e83:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100e86:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100e8a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100e8d:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0100e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e91:	0f b6 c0             	movzbl %al,%eax
c0100e94:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0100e9b:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0100e9e:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100ea2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100ea5:	ee                   	out    %al,(%dx)
		press_key(code);
c0100ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ea9:	83 ec 0c             	sub    $0xc,%esp
c0100eac:	50                   	push   %eax
c0100ead:	e8 5a 0b 00 00       	call   c0101a0c <press_key>
c0100eb2:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
c0100eb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100eb8:	8b 40 30             	mov    0x30(%eax),%eax
c0100ebb:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100ec0:	75 1f                	jne    c0100ee1 <irq_handle+0x105>
c0100ec2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ec5:	8b 40 1c             	mov    0x1c(%eax),%eax
c0100ec8:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0100ecd:	74 0d                	je     c0100edc <irq_handle+0x100>
c0100ecf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ed2:	8b 40 1c             	mov    0x1c(%eax),%eax
c0100ed5:	3d de 05 00 00       	cmp    $0x5de,%eax
c0100eda:	75 05                	jne    c0100ee1 <irq_handle+0x105>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0100edc:	e8 08 fe ff ff       	call   c0100ce9 <do_scheduler>
	}
}
c0100ee1:	c9                   	leave  
c0100ee2:	c3                   	ret    

c0100ee3 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0100ee3:	55                   	push   %ebp
c0100ee4:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ee9:	83 e8 01             	sub    $0x1,%eax
c0100eec:	66 a3 08 40 15 c0    	mov    %ax,0xc0154008
	data[1] = (uint32_t)addr;
c0100ef2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ef5:	66 a3 0a 40 15 c0    	mov    %ax,0xc015400a
	data[2] = ((uint32_t)addr) >> 16;
c0100efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100efe:	c1 e8 10             	shr    $0x10,%eax
c0100f01:	66 a3 0c 40 15 c0    	mov    %ax,0xc015400c
	asm volatile("lidt (%0)" : : "r"(data));
c0100f07:	b8 08 40 15 c0       	mov    $0xc0154008,%eax
c0100f0c:	0f 01 18             	lidtl  (%eax)
}
c0100f0f:	5d                   	pop    %ebp
c0100f10:	c3                   	ret    

c0100f11 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100f11:	55                   	push   %ebp
c0100f12:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100f14:	8b 45 10             	mov    0x10(%ebp),%eax
c0100f17:	89 c2                	mov    %eax,%edx
c0100f19:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f1c:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100f22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f2c:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100f30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f33:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0100f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f3a:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f3e:	83 e2 f0             	and    $0xfffffff0,%edx
c0100f41:	83 ca 0e             	or     $0xe,%edx
c0100f44:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100f47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f4a:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f4e:	83 e2 ef             	and    $0xffffffef,%edx
c0100f51:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100f54:	8b 45 14             	mov    0x14(%ebp),%eax
c0100f57:	83 e0 03             	and    $0x3,%eax
c0100f5a:	89 c2                	mov    %eax,%edx
c0100f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f5f:	83 e2 03             	and    $0x3,%edx
c0100f62:	89 d1                	mov    %edx,%ecx
c0100f64:	c1 e1 05             	shl    $0x5,%ecx
c0100f67:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f6b:	83 e2 9f             	and    $0xffffff9f,%edx
c0100f6e:	09 ca                	or     %ecx,%edx
c0100f70:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100f73:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f76:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f7a:	83 ca 80             	or     $0xffffff80,%edx
c0100f7d:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100f80:	8b 45 10             	mov    0x10(%ebp),%eax
c0100f83:	c1 e8 10             	shr    $0x10,%eax
c0100f86:	89 c2                	mov    %eax,%edx
c0100f88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f8b:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100f8f:	5d                   	pop    %ebp
c0100f90:	c3                   	ret    

c0100f91 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100f91:	55                   	push   %ebp
c0100f92:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100f94:	8b 45 10             	mov    0x10(%ebp),%eax
c0100f97:	89 c2                	mov    %eax,%edx
c0100f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f9c:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100fa2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fac:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c0100fb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fba:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fbe:	83 ca 0f             	or     $0xf,%edx
c0100fc1:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fc7:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fcb:	83 e2 ef             	and    $0xffffffef,%edx
c0100fce:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100fd1:	8b 45 14             	mov    0x14(%ebp),%eax
c0100fd4:	83 e0 03             	and    $0x3,%eax
c0100fd7:	89 c2                	mov    %eax,%edx
c0100fd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fdc:	83 e2 03             	and    $0x3,%edx
c0100fdf:	89 d1                	mov    %edx,%ecx
c0100fe1:	c1 e1 05             	shl    $0x5,%ecx
c0100fe4:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fe8:	83 e2 9f             	and    $0xffffff9f,%edx
c0100feb:	09 ca                	or     %ecx,%edx
c0100fed:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100ff0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ff3:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100ff7:	83 ca 80             	or     $0xffffff80,%edx
c0100ffa:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100ffd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101000:	c1 e8 10             	shr    $0x10,%eax
c0101003:	89 c2                	mov    %eax,%edx
c0101005:	8b 45 08             	mov    0x8(%ebp),%eax
c0101008:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c010100c:	5d                   	pop    %ebp
c010100d:	c3                   	ret    

c010100e <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c010100e:	55                   	push   %ebp
c010100f:	89 e5                	mov    %esp,%ebp
c0101011:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010101b:	eb 22                	jmp    c010103f <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c010101d:	ba ad 25 10 c0       	mov    $0xc01025ad,%edx
c0101022:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101025:	c1 e0 03             	shl    $0x3,%eax
c0101028:	05 40 3a 1b c0       	add    $0xc01b3a40,%eax
c010102d:	6a 00                	push   $0x0
c010102f:	52                   	push   %edx
c0101030:	6a 01                	push   $0x1
c0101032:	50                   	push   %eax
c0101033:	e8 59 ff ff ff       	call   c0100f91 <set_trap>
c0101038:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c010103b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010103f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101046:	7e d5                	jle    c010101d <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0101048:	b8 f5 24 10 c0       	mov    $0xc01024f5,%eax
c010104d:	6a 00                	push   $0x0
c010104f:	50                   	push   %eax
c0101050:	6a 01                	push   $0x1
c0101052:	68 40 3a 1b c0       	push   $0xc01b3a40
c0101057:	e8 35 ff ff ff       	call   c0100f91 <set_trap>
c010105c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c010105f:	b8 fe 24 10 c0       	mov    $0xc01024fe,%eax
c0101064:	6a 00                	push   $0x0
c0101066:	50                   	push   %eax
c0101067:	6a 01                	push   $0x1
c0101069:	68 48 3a 1b c0       	push   $0xc01b3a48
c010106e:	e8 1e ff ff ff       	call   c0100f91 <set_trap>
c0101073:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c0101076:	b8 07 25 10 c0       	mov    $0xc0102507,%eax
c010107b:	6a 00                	push   $0x0
c010107d:	50                   	push   %eax
c010107e:	6a 01                	push   $0x1
c0101080:	68 50 3a 1b c0       	push   $0xc01b3a50
c0101085:	e8 07 ff ff ff       	call   c0100f91 <set_trap>
c010108a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c010108d:	b8 10 25 10 c0       	mov    $0xc0102510,%eax
c0101092:	6a 00                	push   $0x0
c0101094:	50                   	push   %eax
c0101095:	6a 01                	push   $0x1
c0101097:	68 58 3a 1b c0       	push   $0xc01b3a58
c010109c:	e8 f0 fe ff ff       	call   c0100f91 <set_trap>
c01010a1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c01010a4:	b8 19 25 10 c0       	mov    $0xc0102519,%eax
c01010a9:	6a 00                	push   $0x0
c01010ab:	50                   	push   %eax
c01010ac:	6a 01                	push   $0x1
c01010ae:	68 60 3a 1b c0       	push   $0xc01b3a60
c01010b3:	e8 d9 fe ff ff       	call   c0100f91 <set_trap>
c01010b8:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c01010bb:	b8 22 25 10 c0       	mov    $0xc0102522,%eax
c01010c0:	6a 00                	push   $0x0
c01010c2:	50                   	push   %eax
c01010c3:	6a 01                	push   $0x1
c01010c5:	68 68 3a 1b c0       	push   $0xc01b3a68
c01010ca:	e8 c2 fe ff ff       	call   c0100f91 <set_trap>
c01010cf:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c01010d2:	b8 2b 25 10 c0       	mov    $0xc010252b,%eax
c01010d7:	6a 00                	push   $0x0
c01010d9:	50                   	push   %eax
c01010da:	6a 01                	push   $0x1
c01010dc:	68 70 3a 1b c0       	push   $0xc01b3a70
c01010e1:	e8 ab fe ff ff       	call   c0100f91 <set_trap>
c01010e6:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c01010e9:	b8 34 25 10 c0       	mov    $0xc0102534,%eax
c01010ee:	6a 00                	push   $0x0
c01010f0:	50                   	push   %eax
c01010f1:	6a 01                	push   $0x1
c01010f3:	68 78 3a 1b c0       	push   $0xc01b3a78
c01010f8:	e8 94 fe ff ff       	call   c0100f91 <set_trap>
c01010fd:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0101100:	b8 3d 25 10 c0       	mov    $0xc010253d,%eax
c0101105:	6a 00                	push   $0x0
c0101107:	50                   	push   %eax
c0101108:	6a 01                	push   $0x1
c010110a:	68 80 3a 1b c0       	push   $0xc01b3a80
c010110f:	e8 7d fe ff ff       	call   c0100f91 <set_trap>
c0101114:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0101117:	b8 46 25 10 c0       	mov    $0xc0102546,%eax
c010111c:	6a 00                	push   $0x0
c010111e:	50                   	push   %eax
c010111f:	6a 01                	push   $0x1
c0101121:	68 88 3a 1b c0       	push   $0xc01b3a88
c0101126:	e8 66 fe ff ff       	call   c0100f91 <set_trap>
c010112b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c010112e:	b8 4f 25 10 c0       	mov    $0xc010254f,%eax
c0101133:	6a 00                	push   $0x0
c0101135:	50                   	push   %eax
c0101136:	6a 01                	push   $0x1
c0101138:	68 90 3a 1b c0       	push   $0xc01b3a90
c010113d:	e8 4f fe ff ff       	call   c0100f91 <set_trap>
c0101142:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c0101145:	b8 58 25 10 c0       	mov    $0xc0102558,%eax
c010114a:	6a 00                	push   $0x0
c010114c:	50                   	push   %eax
c010114d:	6a 01                	push   $0x1
c010114f:	68 98 3a 1b c0       	push   $0xc01b3a98
c0101154:	e8 38 fe ff ff       	call   c0100f91 <set_trap>
c0101159:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c010115c:	b8 61 25 10 c0       	mov    $0xc0102561,%eax
c0101161:	6a 00                	push   $0x0
c0101163:	50                   	push   %eax
c0101164:	6a 01                	push   $0x1
c0101166:	68 a0 3a 1b c0       	push   $0xc01b3aa0
c010116b:	e8 21 fe ff ff       	call   c0100f91 <set_trap>
c0101170:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101173:	b8 6a 25 10 c0       	mov    $0xc010256a,%eax
c0101178:	6a 00                	push   $0x0
c010117a:	50                   	push   %eax
c010117b:	6a 01                	push   $0x1
c010117d:	68 a8 3a 1b c0       	push   $0xc01b3aa8
c0101182:	e8 0a fe ff ff       	call   c0100f91 <set_trap>
c0101187:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010118a:	b8 7c 25 10 c0       	mov    $0xc010257c,%eax
c010118f:	6a 03                	push   $0x3
c0101191:	50                   	push   %eax
c0101192:	6a 01                	push   $0x1
c0101194:	68 40 3e 1b c0       	push   $0xc01b3e40
c0101199:	e8 f3 fd ff ff       	call   c0100f91 <set_trap>
c010119e:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c01011a1:	b8 89 25 10 c0       	mov    $0xc0102589,%eax
c01011a6:	6a 00                	push   $0x0
c01011a8:	50                   	push   %eax
c01011a9:	6a 01                	push   $0x1
c01011ab:	68 40 3b 1b c0       	push   $0xc01b3b40
c01011b0:	e8 5c fd ff ff       	call   c0100f11 <set_intr>
c01011b5:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c01011b8:	b8 95 25 10 c0       	mov    $0xc0102595,%eax
c01011bd:	6a 00                	push   $0x0
c01011bf:	50                   	push   %eax
c01011c0:	6a 01                	push   $0x1
c01011c2:	68 48 3b 1b c0       	push   $0xc01b3b48
c01011c7:	e8 45 fd ff ff       	call   c0100f11 <set_intr>
c01011cc:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c01011cf:	68 00 08 00 00       	push   $0x800
c01011d4:	68 40 3a 1b c0       	push   $0xc01b3a40
c01011d9:	e8 05 fd ff ff       	call   c0100ee3 <save_idt>
c01011de:	83 c4 08             	add    $0x8,%esp
}
c01011e1:	c9                   	leave  
c01011e2:	c3                   	ret    

c01011e3 <sys_handout>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_handout(){
c01011e3:	55                   	push   %ebp
c01011e4:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c01011e6:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01011eb:	cd 80                	int    $0x80
}
c01011ed:	5d                   	pop    %ebp
c01011ee:	c3                   	ret    

c01011ef <sys_pid>:
static inline uint32_t sys_pid(){
c01011ef:	55                   	push   %ebp
c01011f0:	89 e5                	mov    %esp,%ebp
c01011f2:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01011f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c01011fc:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0101201:	cd 80                	int    $0x80
c0101203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101206:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101209:	c9                   	leave  
c010120a:	c3                   	ret    

c010120b <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c010120b:	55                   	push   %ebp
c010120c:	89 e5                	mov    %esp,%ebp
c010120e:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c010120f:	b8 de 05 00 00       	mov    $0x5de,%eax
c0101214:	8b 55 08             	mov    0x8(%ebp),%edx
c0101217:	89 d3                	mov    %edx,%ebx
c0101219:	cd 80                	int    $0x80
}
c010121b:	5b                   	pop    %ebx
c010121c:	5d                   	pop    %ebp
c010121d:	c3                   	ret    

c010121e <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010121e:	55                   	push   %ebp
c010121f:	89 e5                	mov    %esp,%ebp
c0101221:	83 ec 40             	sub    $0x40,%esp
c0101224:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c010122b:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010122f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101233:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101236:	ee                   	out    %al,(%dx)
c0101237:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c010123e:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0101242:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101246:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101249:	ee                   	out    %al,(%dx)
c010124a:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0101251:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0101255:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101259:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010125c:	ee                   	out    %al,(%dx)
c010125d:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0101264:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0101268:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010126c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010126f:	ee                   	out    %al,(%dx)
c0101270:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c0101277:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010127b:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010127f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101282:	ee                   	out    %al,(%dx)
c0101283:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c010128a:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c010128e:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101292:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101295:	ee                   	out    %al,(%dx)
c0101296:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c010129d:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01012a1:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01012a5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01012a9:	c9                   	leave  
c01012aa:	c3                   	ret    

c01012ab <serial_idle>:

static inline
int serial_idle(void) {
c01012ab:	55                   	push   %ebp
c01012ac:	89 e5                	mov    %esp,%ebp
c01012ae:	83 ec 10             	sub    $0x10,%esp
c01012b1:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01012b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01012bb:	89 c2                	mov    %eax,%edx
c01012bd:	ec                   	in     (%dx),%al
c01012be:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01012c1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01012c5:	0f b6 c0             	movzbl %al,%eax
c01012c8:	83 e0 20             	and    $0x20,%eax
c01012cb:	85 c0                	test   %eax,%eax
c01012cd:	0f 95 c0             	setne  %al
c01012d0:	0f b6 c0             	movzbl %al,%eax
}
c01012d3:	c9                   	leave  
c01012d4:	c3                   	ret    

c01012d5 <serial_printc>:

static inline
void serial_printc(char ch) {
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 14             	sub    $0x14,%esp
c01012db:	8b 45 08             	mov    0x8(%ebp),%eax
c01012de:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01012e1:	90                   	nop
c01012e2:	e8 c4 ff ff ff       	call   c01012ab <serial_idle>
c01012e7:	85 c0                	test   %eax,%eax
c01012e9:	74 f7                	je     c01012e2 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01012eb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01012ef:	0f b6 c0             	movzbl %al,%eax
c01012f2:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01012f9:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01012fc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101300:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101303:	ee                   	out    %al,(%dx)
}
c0101304:	c9                   	leave  
c0101305:	c3                   	ret    

c0101306 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101306:	55                   	push   %ebp
c0101307:	89 e5                	mov    %esp,%ebp
c0101309:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010130c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101312:	8b 45 08             	mov    0x8(%ebp),%eax
c0101315:	83 ec 04             	sub    $0x4,%esp
c0101318:	ff 75 f4             	pushl  -0xc(%ebp)
c010131b:	50                   	push   %eax
c010131c:	68 d5 12 10 c0       	push   $0xc01012d5
c0101321:	e8 49 13 00 00       	call   c010266f <vfprintf>
c0101326:	83 c4 10             	add    $0x10,%esp
}
c0101329:	c9                   	leave  
c010132a:	c3                   	ret    

c010132b <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c010132b:	55                   	push   %ebp
c010132c:	89 e5                	mov    %esp,%ebp
c010132e:	83 ec 70             	sub    $0x70,%esp
c0101331:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0101338:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c010133c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101340:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101343:	ee                   	out    %al,(%dx)
c0101344:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c010134b:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c010134f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101353:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101356:	ee                   	out    %al,(%dx)
c0101357:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c010135e:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c0101362:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101366:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101369:	ee                   	out    %al,(%dx)
c010136a:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0101371:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0101375:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101379:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010137c:	ee                   	out    %al,(%dx)
c010137d:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0101384:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0101388:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010138c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010138f:	ee                   	out    %al,(%dx)
c0101390:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0101397:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010139b:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c010139f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01013a2:	ee                   	out    %al,(%dx)
c01013a3:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c01013aa:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c01013ae:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01013b2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01013b5:	ee                   	out    %al,(%dx)
c01013b6:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c01013bd:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c01013c1:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c01013c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01013c8:	ee                   	out    %al,(%dx)
c01013c9:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01013d0:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01013d4:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01013d8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01013db:	ee                   	out    %al,(%dx)
c01013dc:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01013e3:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c01013e7:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c01013eb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01013ee:	ee                   	out    %al,(%dx)
c01013ef:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c01013f6:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c01013fa:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c01013fe:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101401:	ee                   	out    %al,(%dx)
c0101402:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0101409:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c010140d:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101411:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101414:	ee                   	out    %al,(%dx)
c0101415:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010141c:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0101420:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0101424:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0101427:	ee                   	out    %al,(%dx)
c0101428:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c010142f:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0101433:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0101437:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010143a:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c010143b:	c9                   	leave  
c010143c:	c3                   	ret    

c010143d <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c010143d:	55                   	push   %ebp
c010143e:	89 e5                	mov    %esp,%ebp
c0101440:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0101443:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c010144a:	0f b6 05 00 60 10 c0 	movzbl 0xc0106000,%eax
c0101451:	0f b6 c0             	movzbl %al,%eax
c0101454:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c010145b:	88 45 f7             	mov    %al,-0x9(%ebp)
c010145e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101462:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101465:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0101466:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101469:	0f b6 c0             	movzbl %al,%eax
c010146c:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c0101473:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101476:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010147a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010147d:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c010147e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101481:	c1 f8 08             	sar    $0x8,%eax
c0101484:	0f b6 c0             	movzbl %al,%eax
c0101487:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c010148e:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101491:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101495:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101498:	ee                   	out    %al,(%dx)
}
c0101499:	c9                   	leave  
c010149a:	c3                   	ret    

c010149b <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010149b:	55                   	push   %ebp
c010149c:	89 e5                	mov    %esp,%ebp
  while(1){
    sys_handout();
c010149e:	e8 40 fd ff ff       	call   c01011e3 <sys_handout>
  }
c01014a3:	eb f9                	jmp    c010149e <idle+0x3>

c01014a5 <busy>:
}
void busy(){
c01014a5:	55                   	push   %ebp
c01014a6:	89 e5                	mov    %esp,%ebp
c01014a8:	83 ec 18             	sub    $0x18,%esp
  uint32_t tick=0;
c01014ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    //cur = sys_get_tick();
    //while(tick < cur){
      printf("This is busy! Sleep %ds! Recall %d times\n", sys_pid(), tick);
c01014b2:	e8 38 fd ff ff       	call   c01011ef <sys_pid>
c01014b7:	83 ec 04             	sub    $0x4,%esp
c01014ba:	ff 75 f4             	pushl  -0xc(%ebp)
c01014bd:	50                   	push   %eax
c01014be:	68 04 2a 10 c0       	push   $0xc0102a04
c01014c3:	e8 41 14 00 00       	call   c0102909 <printf>
c01014c8:	83 c4 10             	add    $0x10,%esp
      tick++;
c01014cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    //}

    //printf("1 %x\n", _tick);
    //printf("2 %x\n", _tick);
    //sys_handout();
    sys_sleep(sys_pid()*200);
c01014cf:	e8 1b fd ff ff       	call   c01011ef <sys_pid>
c01014d4:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
c01014da:	83 ec 0c             	sub    $0xc,%esp
c01014dd:	50                   	push   %eax
c01014de:	e8 28 fd ff ff       	call   c010120b <sys_sleep>
c01014e3:	83 c4 10             	add    $0x10,%esp
    //sys_handout();
    //printf("3 %x\n", _tick);
    //enable_interrupt();
  }
c01014e6:	eb ca                	jmp    c01014b2 <busy+0xd>

c01014e8 <main>:
}
void do_scheduler();
int main(){
c01014e8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c01014ec:	83 e4 f0             	and    $0xfffffff0,%esp
c01014ef:	ff 71 fc             	pushl  -0x4(%ecx)
c01014f2:	55                   	push   %ebp
c01014f3:	89 e5                	mov    %esp,%ebp
c01014f5:	51                   	push   %ecx
c01014f6:	83 ec 14             	sub    $0x14,%esp
  init_page();
c01014f9:	e8 2d ec ff ff       	call   c010012b <init_page>
  init_segment();
c01014fe:	e8 d9 ed ff ff       	call   c01002dc <init_segment>
	init_serial();
c0101503:	e8 16 fd ff ff       	call   c010121e <init_serial>
	init_timer();
c0101508:	e8 30 ff ff ff       	call   c010143d <init_timer>
	init_idt();
c010150d:	e8 fc fa ff ff       	call   c010100e <init_idt>
	init_intr();
c0101512:	e8 14 fe ff ff       	call   c010132b <init_intr>
  init_pcb_pool();
c0101517:	e8 38 0a 00 00       	call   c0101f54 <init_pcb_pool>

  PCB* pidle = pcb_create();
c010151c:	e8 8b 0b 00 00       	call   c01020ac <pcb_create>
c0101521:	89 45 f0             	mov    %eax,-0x10(%ebp)
 // loader(pcb, 102400);
  empty_loader(pidle, idle);
c0101524:	83 ec 08             	sub    $0x8,%esp
c0101527:	68 9b 14 10 c0       	push   $0xc010149b
c010152c:	ff 75 f0             	pushl  -0x10(%ebp)
c010152f:	e8 3c 04 00 00       	call   c0101970 <empty_loader>
c0101534:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c0101537:	e8 70 0b 00 00       	call   c01020ac <pcb_create>
c010153c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(pcb, 102400);
c010153f:	83 ec 08             	sub    $0x8,%esp
c0101542:	68 00 90 01 00       	push   $0x19000
c0101547:	ff 75 ec             	pushl  -0x14(%ebp)
c010154a:	e8 ac 02 00 00       	call   c01017fb <loader>
c010154f:	83 c4 10             	add    $0x10,%esp

 // loader(pcc, 102400);
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));
  printk("haha\n");
c0101552:	83 ec 0c             	sub    $0xc,%esp
c0101555:	68 2e 2a 10 c0       	push   $0xc0102a2e
c010155a:	e8 a7 fd ff ff       	call   c0101306 <printk>
c010155f:	83 c4 10             	add    $0x10,%esp
  //enable_interrupt();
  printk("haha\n");
c0101562:	83 ec 0c             	sub    $0xc,%esp
c0101565:	68 2e 2a 10 c0       	push   $0xc0102a2e
c010156a:	e8 97 fd ff ff       	call   c0101306 <printk>
c010156f:	83 c4 10             	add    $0x10,%esp
  //asm volatile("int $0x0");
  //switch_pcb(pidle);
  printk("haha\n");
c0101572:	83 ec 0c             	sub    $0xc,%esp
c0101575:	68 2e 2a 10 c0       	push   $0xc0102a2e
c010157a:	e8 87 fd ff ff       	call   c0101306 <printk>
c010157f:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c0101582:	83 ec 0c             	sub    $0xc,%esp
c0101585:	ff 75 f0             	pushl  -0x10(%ebp)
c0101588:	e8 1f 0c 00 00       	call   c01021ac <enready_pcb>
c010158d:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c0101590:	83 ec 0c             	sub    $0xc,%esp
c0101593:	ff 75 ec             	pushl  -0x14(%ebp)
c0101596:	e8 11 0c 00 00       	call   c01021ac <enready_pcb>
c010159b:	83 c4 10             	add    $0x10,%esp
  uint32_t i = 0;
c010159e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(i=0; i<10;i++){
c01015a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01015ac:	eb 2d                	jmp    c01015db <main+0xf3>
    PCB* pcc = pcb_create();
c01015ae:	e8 f9 0a 00 00       	call   c01020ac <pcb_create>
c01015b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    empty_loader(pcc, busy);
c01015b6:	83 ec 08             	sub    $0x8,%esp
c01015b9:	68 a5 14 10 c0       	push   $0xc01014a5
c01015be:	ff 75 e8             	pushl  -0x18(%ebp)
c01015c1:	e8 aa 03 00 00       	call   c0101970 <empty_loader>
c01015c6:	83 c4 10             	add    $0x10,%esp
    enready_pcb(pcc);
c01015c9:	83 ec 0c             	sub    $0xc,%esp
c01015cc:	ff 75 e8             	pushl  -0x18(%ebp)
c01015cf:	e8 d8 0b 00 00       	call   c01021ac <enready_pcb>
c01015d4:	83 c4 10             	add    $0x10,%esp
  //switch_pcb(pidle);
  printk("haha\n");
  enready_pcb(pidle);
  enready_pcb(pcb);
  uint32_t i = 0;
  for(i=0; i<10;i++){
c01015d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01015db:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
c01015df:	76 cd                	jbe    c01015ae <main+0xc6>
    enready_pcb(pcc);
  }
  //enready_pcb(pcc);
  //enready_pcb(pidle);

  do_scheduler();
c01015e1:	e8 03 f7 ff ff       	call   c0100ce9 <do_scheduler>

  while(1);
c01015e6:	eb fe                	jmp    c01015e6 <main+0xfe>

c01015e8 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01015e8:	55                   	push   %ebp
c01015e9:	89 e5                	mov    %esp,%ebp
c01015eb:	83 ec 10             	sub    $0x10,%esp
c01015ee:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01015f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01015f8:	89 c2                	mov    %eax,%edx
c01015fa:	ec                   	in     (%dx),%al
c01015fb:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01015fe:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101602:	0f b6 c0             	movzbl %al,%eax
c0101605:	83 e0 20             	and    $0x20,%eax
c0101608:	85 c0                	test   %eax,%eax
c010160a:	0f 95 c0             	setne  %al
c010160d:	0f b6 c0             	movzbl %al,%eax
}
c0101610:	c9                   	leave  
c0101611:	c3                   	ret    

c0101612 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101612:	55                   	push   %ebp
c0101613:	89 e5                	mov    %esp,%ebp
c0101615:	83 ec 14             	sub    $0x14,%esp
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010161e:	90                   	nop
c010161f:	e8 c4 ff ff ff       	call   c01015e8 <serial_idle>
c0101624:	85 c0                	test   %eax,%eax
c0101626:	74 f7                	je     c010161f <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101628:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010162c:	0f b6 c0             	movzbl %al,%eax
c010162f:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101636:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101639:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101640:	ee                   	out    %al,(%dx)
}
c0101641:	c9                   	leave  
c0101642:	c3                   	ret    

c0101643 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101649:	8d 45 0c             	lea    0xc(%ebp),%eax
c010164c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010164f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101652:	83 ec 04             	sub    $0x4,%esp
c0101655:	ff 75 f4             	pushl  -0xc(%ebp)
c0101658:	50                   	push   %eax
c0101659:	68 12 16 10 c0       	push   $0xc0101612
c010165e:	e8 0c 10 00 00       	call   c010266f <vfprintf>
c0101663:	83 c4 10             	add    $0x10,%esp
}
c0101666:	c9                   	leave  
c0101667:	c3                   	ret    

c0101668 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101668:	55                   	push   %ebp
c0101669:	89 e5                	mov    %esp,%ebp
c010166b:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c010166e:	90                   	nop
c010166f:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101676:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101679:	89 c2                	mov    %eax,%edx
c010167b:	ec                   	in     (%dx),%al
c010167c:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010167f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101683:	0f b6 c0             	movzbl %al,%eax
c0101686:	25 c0 00 00 00       	and    $0xc0,%eax
c010168b:	83 f8 40             	cmp    $0x40,%eax
c010168e:	75 df                	jne    c010166f <waitdisk+0x7>
}
c0101690:	c9                   	leave  
c0101691:	c3                   	ret    

c0101692 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0101692:	55                   	push   %ebp
c0101693:	89 e5                	mov    %esp,%ebp
c0101695:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101698:	e8 cb ff ff ff       	call   c0101668 <waitdisk>
c010169d:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01016a4:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01016a8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01016ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01016af:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016b3:	0f b6 c0             	movzbl %al,%eax
c01016b6:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01016bd:	88 45 ef             	mov    %al,-0x11(%ebp)
c01016c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01016c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01016c7:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016cb:	c1 f8 08             	sar    $0x8,%eax
c01016ce:	0f b6 c0             	movzbl %al,%eax
c01016d1:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01016d8:	88 45 e7             	mov    %al,-0x19(%ebp)
c01016db:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016df:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01016e2:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016e6:	c1 f8 10             	sar    $0x10,%eax
c01016e9:	0f b6 c0             	movzbl %al,%eax
c01016ec:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01016f3:	88 45 df             	mov    %al,-0x21(%ebp)
c01016f6:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01016fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01016fd:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101701:	c1 f8 18             	sar    $0x18,%eax
c0101704:	83 c8 e0             	or     $0xffffffe0,%eax
c0101707:	0f b6 c0             	movzbl %al,%eax
c010170a:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101711:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101714:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101718:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010171b:	ee                   	out    %al,(%dx)
c010171c:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101723:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101727:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c010172b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010172e:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c010172f:	e8 34 ff ff ff       	call   c0101668 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010173b:	eb 29                	jmp    c0101766 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c010173d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101740:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101747:	8b 45 08             	mov    0x8(%ebp),%eax
c010174a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c010174d:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101754:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101757:	89 c2                	mov    %eax,%edx
c0101759:	ed                   	in     (%dx),%eax
c010175a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c010175d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101760:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101762:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101766:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010176a:	7e d1                	jle    c010173d <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c010176c:	c9                   	leave  
c010176d:	c3                   	ret    

c010176e <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c010176e:	55                   	push   %ebp
c010176f:	89 e5                	mov    %esp,%ebp
c0101771:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101774:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101777:	8b 45 08             	mov    0x8(%ebp),%eax
c010177a:	01 d0                	add    %edx,%eax
c010177c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c010177f:	8b 45 10             	mov    0x10(%ebp),%eax
c0101782:	99                   	cltd   
c0101783:	c1 ea 17             	shr    $0x17,%edx
c0101786:	01 d0                	add    %edx,%eax
c0101788:	25 ff 01 00 00       	and    $0x1ff,%eax
c010178d:	29 d0                	sub    %edx,%eax
c010178f:	f7 d8                	neg    %eax
c0101791:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0101794:	8b 45 10             	mov    0x10(%ebp),%eax
c0101797:	99                   	cltd   
c0101798:	c1 ea 17             	shr    $0x17,%edx
c010179b:	01 d0                	add    %edx,%eax
c010179d:	c1 f8 09             	sar    $0x9,%eax
c01017a0:	83 c0 01             	add    $0x1,%eax
c01017a3:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01017a6:	eb 19                	jmp    c01017c1 <readseg+0x53>
        readsect(pa, offset);
c01017a8:	ff 75 10             	pushl  0x10(%ebp)
c01017ab:	ff 75 08             	pushl  0x8(%ebp)
c01017ae:	e8 df fe ff ff       	call   c0101692 <readsect>
c01017b3:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01017b6:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c01017bd:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01017c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01017c7:	72 df                	jb     c01017a8 <readseg+0x3a>
        readsect(pa, offset);
c01017c9:	c9                   	leave  
c01017ca:	c3                   	ret    

c01017cb <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01017cb:	55                   	push   %ebp
c01017cc:	89 e5                	mov    %esp,%ebp
c01017ce:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01017d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01017d4:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01017d9:	77 16                	ja     c01017f1 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01017db:	ff 75 10             	pushl  0x10(%ebp)
c01017de:	68 34 2a 10 c0       	push   $0xc0102a34
c01017e3:	ff 75 0c             	pushl  0xc(%ebp)
c01017e6:	ff 75 08             	pushl  0x8(%ebp)
c01017e9:	e8 55 fe ff ff       	call   c0101643 <printk>
c01017ee:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01017f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01017f4:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01017f9:	c9                   	leave  
c01017fa:	c3                   	ret    

c01017fb <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c01017fb:	55                   	push   %ebp
c01017fc:	89 e5                	mov    %esp,%ebp
c01017fe:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0101801:	8b 45 08             	mov    0x8(%ebp),%eax
c0101804:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010180a:	83 ec 04             	sub    $0x4,%esp
c010180d:	50                   	push   %eax
c010180e:	6a 17                	push   $0x17
c0101810:	68 57 2a 10 c0       	push   $0xc0102a57
c0101815:	e8 b1 ff ff ff       	call   c01017cb <_paddr>
c010181a:	83 c4 10             	add    $0x10,%esp
c010181d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101823:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101826:	8b 45 08             	mov    0x8(%ebp),%eax
c0101829:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010182f:	83 ec 04             	sub    $0x4,%esp
c0101832:	68 00 10 00 00       	push   $0x1000
c0101837:	6a 00                	push   $0x0
c0101839:	50                   	push   %eax
c010183a:	e8 37 ee ff ff       	call   c0100676 <mm_alloc>
c010183f:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0101842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101845:	83 ec 04             	sub    $0x4,%esp
c0101848:	50                   	push   %eax
c0101849:	68 00 10 00 00       	push   $0x1000
c010184e:	6a 00                	push   $0x0
c0101850:	e8 19 ff ff ff       	call   c010176e <readseg>
c0101855:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  //printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101858:	b8 00 00 00 00       	mov    $0x0,%eax
c010185d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101863:	b8 00 00 00 00       	mov    $0x0,%eax
c0101868:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010186c:	0f b7 c0             	movzwl %ax,%eax
c010186f:	c1 e0 05             	shl    $0x5,%eax
c0101872:	89 c2                	mov    %eax,%edx
c0101874:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101877:	01 d0                	add    %edx,%eax
c0101879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c010187c:	eb 7f                	jmp    c01018fd <loader+0x102>
    pa = (unsigned char*)ph->paddr; 
c010187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101881:	8b 40 0c             	mov    0xc(%eax),%eax
c0101884:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010188a:	8b 48 14             	mov    0x14(%eax),%ecx
c010188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101890:	8b 50 08             	mov    0x8(%eax),%edx
c0101893:	8b 45 08             	mov    0x8(%ebp),%eax
c0101896:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010189c:	83 ec 04             	sub    $0x4,%esp
c010189f:	51                   	push   %ecx
c01018a0:	52                   	push   %edx
c01018a1:	50                   	push   %eax
c01018a2:	e8 cf ed ff ff       	call   c0100676 <mm_alloc>
c01018a7:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c01018aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018ad:	8b 50 04             	mov    0x4(%eax),%edx
c01018b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01018b3:	01 d0                	add    %edx,%eax
c01018b5:	89 c2                	mov    %eax,%edx
c01018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018ba:	8b 40 10             	mov    0x10(%eax),%eax
c01018bd:	83 ec 04             	sub    $0x4,%esp
c01018c0:	52                   	push   %edx
c01018c1:	50                   	push   %eax
c01018c2:	ff 75 e8             	pushl  -0x18(%ebp)
c01018c5:	e8 a4 fe ff ff       	call   c010176e <readseg>
c01018ca:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c01018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018d0:	8b 50 10             	mov    0x10(%eax),%edx
c01018d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01018d6:	01 d0                	add    %edx,%eax
c01018d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01018db:	eb 0c                	jmp    c01018e9 <loader+0xee>
c01018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018e0:	8d 50 01             	lea    0x1(%eax),%edx
c01018e3:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01018e6:	c6 00 00             	movb   $0x0,(%eax)
c01018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018ec:	8b 50 14             	mov    0x14(%eax),%edx
c01018ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01018f2:	01 d0                	add    %edx,%eax
c01018f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01018f7:	77 e4                	ja     c01018dd <loader+0xe2>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01018f9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101900:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101903:	0f 82 75 ff ff ff    	jb     c010187e <loader+0x83>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101909:	b8 00 00 00 00       	mov    $0x0,%eax
c010190e:	8b 40 18             	mov    0x18(%eax),%eax
c0101911:	a3 e8 25 10 c0       	mov    %eax,0xc01025e8

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101916:	8b 45 08             	mov    0x8(%ebp),%eax
c0101919:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010191f:	83 ec 04             	sub    $0x4,%esp
c0101922:	68 00 80 00 00       	push   $0x8000
c0101927:	68 00 60 bf be       	push   $0xbebf6000
c010192c:	50                   	push   %eax
c010192d:	e8 44 ed ff ff       	call   c0100676 <mm_alloc>
c0101932:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x1FF, entry, 3);
c0101935:	a1 e8 25 10 c0       	mov    0xc01025e8,%eax
c010193a:	6a 03                	push   $0x3
c010193c:	50                   	push   %eax
c010193d:	68 01 de bf be       	push   $0xbebfde01
c0101942:	ff 75 08             	pushl  0x8(%ebp)
c0101945:	e8 41 06 00 00       	call   c0101f8b <init_pcb>
c010194a:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c010194d:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0101952:	83 ec 04             	sub    $0x4,%esp
c0101955:	50                   	push   %eax
c0101956:	6a 39                	push   $0x39
c0101958:	68 57 2a 10 c0       	push   $0xc0102a57
c010195d:	e8 69 fe ff ff       	call   c01017cb <_paddr>
c0101962:	83 c4 10             	add    $0x10,%esp
c0101965:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101968:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010196b:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c010196e:	c9                   	leave  
c010196f:	c3                   	ret    

c0101970 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0101970:	55                   	push   %ebp
c0101971:	89 e5                	mov    %esp,%ebp
c0101973:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101976:	8b 45 08             	mov    0x8(%ebp),%eax
c0101979:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010197f:	83 ec 04             	sub    $0x4,%esp
c0101982:	50                   	push   %eax
c0101983:	6a 42                	push   $0x42
c0101985:	68 57 2a 10 c0       	push   $0xc0102a57
c010198a:	e8 3c fe ff ff       	call   c01017cb <_paddr>
c010198f:	83 c4 10             	add    $0x10,%esp
c0101992:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101995:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101998:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c010199b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010199e:	a3 e8 25 10 c0       	mov    %eax,0xc01025e8
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstack0top, entry, 0);
c01019a3:	a1 e8 25 10 c0       	mov    0xc01025e8,%eax
c01019a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01019ab:	81 c2 00 20 00 00    	add    $0x2000,%edx
c01019b1:	6a 00                	push   $0x0
c01019b3:	50                   	push   %eax
c01019b4:	52                   	push   %edx
c01019b5:	ff 75 08             	pushl  0x8(%ebp)
c01019b8:	e8 ce 05 00 00       	call   c0101f8b <init_pcb>
c01019bd:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c01019c0:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c01019c5:	83 ec 04             	sub    $0x4,%esp
c01019c8:	50                   	push   %eax
c01019c9:	6a 46                	push   $0x46
c01019cb:	68 57 2a 10 c0       	push   $0xc0102a57
c01019d0:	e8 f6 fd ff ff       	call   c01017cb <_paddr>
c01019d5:	83 c4 10             	add    $0x10,%esp
c01019d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019de:	0f 22 d8             	mov    %eax,%cr3

};
c01019e1:	c9                   	leave  
c01019e2:	c3                   	ret    

c01019e3 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c01019e3:	55                   	push   %ebp
c01019e4:	89 e5                	mov    %esp,%ebp
c01019e6:	83 ec 04             	sub    $0x4,%esp
c01019e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c01019ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c01019f3:	83 e8 61             	sub    $0x61,%eax
c01019f6:	8b 04 85 40 40 15 c0 	mov    -0x3feabfc0(,%eax,4),%eax
}
c01019fd:	c9                   	leave  
c01019fe:	c3                   	ret    

c01019ff <get_lastkey>:
int8_t get_lastkey(){
c01019ff:	55                   	push   %ebp
c0101a00:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101a02:	a1 a8 40 15 c0       	mov    0xc01540a8,%eax
c0101a07:	83 c0 61             	add    $0x61,%eax
}
c0101a0a:	5d                   	pop    %ebp
c0101a0b:	c3                   	ret    

c0101a0c <press_key>:
void press_key(int code){
c0101a0c:	55                   	push   %ebp
c0101a0d:	89 e5                	mov    %esp,%ebp
c0101a0f:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101a12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	25 80 00 00 00       	and    $0x80,%eax
c0101a21:	85 c0                	test   %eax,%eax
c0101a23:	75 35                	jne    c0101a5a <press_key+0x4e>
		for(;i<26;i++){
c0101a25:	eb 2b                	jmp    c0101a52 <press_key+0x46>
			if(letter[i]==code){
c0101a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2a:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c0101a31:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101a34:	75 18                	jne    c0101a4e <press_key+0x42>
				keydown[i] = 1;
c0101a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a39:	c7 04 85 40 40 15 c0 	movl   $0x1,-0x3feabfc0(,%eax,4)
c0101a40:	01 00 00 00 
				lastkey = i;
c0101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a47:	a3 a8 40 15 c0       	mov    %eax,0xc01540a8
				return;
c0101a4c:	eb 3b                	jmp    c0101a89 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101a4e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a52:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101a56:	7e cf                	jle    c0101a27 <press_key+0x1b>
c0101a58:	eb 2f                	jmp    c0101a89 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101a5a:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101a5e:	eb 23                	jmp    c0101a83 <press_key+0x77>
			if(letter[i]==code){
c0101a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a63:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c0101a6a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101a6d:	75 10                	jne    c0101a7f <press_key+0x73>
				keydown[i] = 0;
c0101a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a72:	c7 04 85 40 40 15 c0 	movl   $0x0,-0x3feabfc0(,%eax,4)
c0101a79:	00 00 00 00 
				return;
c0101a7d:	eb 0a                	jmp    c0101a89 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101a7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a83:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101a87:	7e d7                	jle    c0101a60 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101a89:	c9                   	leave  
c0101a8a:	c3                   	ret    

c0101a8b <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101a8b:	55                   	push   %ebp
c0101a8c:	89 e5                	mov    %esp,%ebp
c0101a8e:	83 ec 10             	sub    $0x10,%esp
c0101a91:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a9b:	89 c2                	mov    %eax,%edx
c0101a9d:	ec                   	in     (%dx),%al
c0101a9e:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101aa1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101aa5:	0f b6 c0             	movzbl %al,%eax
c0101aa8:	83 e0 20             	and    $0x20,%eax
c0101aab:	85 c0                	test   %eax,%eax
c0101aad:	0f 95 c0             	setne  %al
c0101ab0:	0f b6 c0             	movzbl %al,%eax
}
c0101ab3:	c9                   	leave  
c0101ab4:	c3                   	ret    

c0101ab5 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101ab5:	55                   	push   %ebp
c0101ab6:	89 e5                	mov    %esp,%ebp
c0101ab8:	83 ec 14             	sub    $0x14,%esp
c0101abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abe:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101ac1:	90                   	nop
c0101ac2:	e8 c4 ff ff ff       	call   c0101a8b <serial_idle>
c0101ac7:	85 c0                	test   %eax,%eax
c0101ac9:	74 f7                	je     c0101ac2 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101acb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101acf:	0f b6 c0             	movzbl %al,%eax
c0101ad2:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101ad9:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101adc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101ae0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101ae3:	ee                   	out    %al,(%dx)
}
c0101ae4:	c9                   	leave  
c0101ae5:	c3                   	ret    

c0101ae6 <do_syscall>:

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101ae6:	55                   	push   %ebp
c0101ae7:	89 e5                	mov    %esp,%ebp
c0101ae9:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c0101aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aef:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101af2:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101af7:	0f 84 3b 01 00 00    	je     c0101c38 <do_syscall+0x152>
c0101afd:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101b02:	77 48                	ja     c0101b4c <do_syscall+0x66>
c0101b04:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101b09:	0f 84 e9 00 00 00    	je     c0101bf8 <do_syscall+0x112>
c0101b0f:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101b14:	77 1b                	ja     c0101b31 <do_syscall+0x4b>
c0101b16:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101b1b:	0f 84 b6 00 00 00    	je     c0101bd7 <do_syscall+0xf1>
c0101b21:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101b26:	0f 84 c2 00 00 00    	je     c0101bee <do_syscall+0x108>
c0101b2c:	e9 7a 01 00 00       	jmp    c0101cab <do_syscall+0x1c5>
c0101b31:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101b36:	0f 84 c6 00 00 00    	je     c0101c02 <do_syscall+0x11c>
c0101b3c:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101b41:	0f 84 ca 00 00 00    	je     c0101c11 <do_syscall+0x12b>
c0101b47:	e9 5f 01 00 00       	jmp    c0101cab <do_syscall+0x1c5>
c0101b4c:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101b51:	74 70                	je     c0101bc3 <do_syscall+0xdd>
c0101b53:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101b58:	77 1b                	ja     c0101b75 <do_syscall+0x8f>
c0101b5a:	3d 14 05 00 00       	cmp    $0x514,%eax
c0101b5f:	0f 84 02 01 00 00    	je     c0101c67 <do_syscall+0x181>
c0101b65:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101b6a:	0f 84 e8 00 00 00    	je     c0101c58 <do_syscall+0x172>
c0101b70:	e9 36 01 00 00       	jmp    c0101cab <do_syscall+0x1c5>
c0101b75:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101b7a:	74 0c                	je     c0101b88 <do_syscall+0xa2>
c0101b7c:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101b81:	74 1b                	je     c0101b9e <do_syscall+0xb8>
c0101b83:	e9 23 01 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_PID:
			tf->eax = current->pid;
c0101b88:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101b8d:	8b 90 34 40 00 00    	mov    0x4034(%eax),%edx
c0101b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b96:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101b99:	e9 0d 01 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0101b9e:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101ba3:	c7 80 3c 40 00 00 03 	movl   $0x3,0x403c(%eax)
c0101baa:	00 00 00 
			current->timeslice = tf->ebx;
c0101bad:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101bb2:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bb5:	8b 52 10             	mov    0x10(%edx),%edx
c0101bb8:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)
		break;
c0101bbe:	e9 e8 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_HANDOUT:
			current->ts = STOP;
c0101bc3:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101bc8:	c7 80 3c 40 00 00 02 	movl   $0x2,0x403c(%eax)
c0101bcf:	00 00 00 
		break;
c0101bd2:	e9 d4 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bda:	8b 40 10             	mov    0x10(%eax),%eax
c0101bdd:	0f be c0             	movsbl %al,%eax
c0101be0:	50                   	push   %eax
c0101be1:	e8 cf fe ff ff       	call   c0101ab5 <serial_printc>
c0101be6:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
c0101be9:	e9 bd 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_INIT_CACHE:
			initVCache();
c0101bee:	e8 77 06 00 00       	call   c010226a <initVCache>
		break;
c0101bf3:	e9 b3 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0101bf8:	e8 a2 07 00 00       	call   c010239f <clearVRAM>
		break;
c0101bfd:	e9 a9 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0101c02:	e8 98 07 00 00       	call   c010239f <clearVRAM>
			flushVCache();
c0101c07:	e8 c7 06 00 00       	call   c01022d3 <flushVCache>
		break;
c0101c0c:	e9 9a 00 00 00       	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0101c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c14:	8b 40 14             	mov    0x14(%eax),%eax
c0101c17:	0f b6 c0             	movzbl %al,%eax
c0101c1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c1d:	8b 52 18             	mov    0x18(%edx),%edx
c0101c20:	89 d1                	mov    %edx,%ecx
c0101c22:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c25:	8b 52 10             	mov    0x10(%edx),%edx
c0101c28:	83 ec 04             	sub    $0x4,%esp
c0101c2b:	50                   	push   %eax
c0101c2c:	51                   	push   %ecx
c0101c2d:	52                   	push   %edx
c0101c2e:	e8 05 07 00 00       	call   c0102338 <setPixelAt>
c0101c33:	83 c4 10             	add    $0x10,%esp
		break;
c0101c36:	eb 73                	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0101c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3b:	8b 40 10             	mov    0x10(%eax),%eax
c0101c3e:	0f be c0             	movsbl %al,%eax
c0101c41:	83 ec 0c             	sub    $0xc,%esp
c0101c44:	50                   	push   %eax
c0101c45:	e8 99 fd ff ff       	call   c01019e3 <get_key>
c0101c4a:	83 c4 10             	add    $0x10,%esp
c0101c4d:	0f be d0             	movsbl %al,%edx
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101c56:	eb 53                	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_GET_TICK:
			tf->eax = tick();
c0101c58:	e8 8e 08 00 00       	call   c01024eb <tick>
c0101c5d:	89 c2                	mov    %eax,%edx
c0101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c62:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0101c65:	eb 44                	jmp    c0101cab <do_syscall+0x1c5>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101c67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c6e:	eb 34                	jmp    c0101ca4 <do_syscall+0x1be>
				if(!timer_handlers[i].used){
c0101c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c73:	8b 04 c5 04 37 1b c0 	mov    -0x3fe4c8fc(,%eax,8),%eax
c0101c7a:	85 c0                	test   %eax,%eax
c0101c7c:	75 22                	jne    c0101ca0 <do_syscall+0x1ba>
					timer_handlers[i].ptr = (void*)tf->ebx;
c0101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c81:	8b 40 10             	mov    0x10(%eax),%eax
c0101c84:	89 c2                	mov    %eax,%edx
c0101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c89:	89 14 c5 00 37 1b c0 	mov    %edx,-0x3fe4c900(,%eax,8)
					timer_handlers[i].used = 1;
c0101c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c93:	c7 04 c5 04 37 1b c0 	movl   $0x1,-0x3fe4c8fc(,%eax,8)
c0101c9a:	01 00 00 00 
					break;
c0101c9e:	eb 0a                	jmp    c0101caa <do_syscall+0x1c4>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ca4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101ca8:	7e c6                	jle    c0101c70 <do_syscall+0x18a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c0101caa:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0101cab:	c9                   	leave  
c0101cac:	c3                   	ret    

c0101cad <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101cad:	55                   	push   %ebp
c0101cae:	89 e5                	mov    %esp,%ebp
c0101cb0:	83 ec 10             	sub    $0x10,%esp
c0101cb3:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101cbd:	89 c2                	mov    %eax,%edx
c0101cbf:	ec                   	in     (%dx),%al
c0101cc0:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101cc3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101cc7:	0f b6 c0             	movzbl %al,%eax
c0101cca:	83 e0 20             	and    $0x20,%eax
c0101ccd:	85 c0                	test   %eax,%eax
c0101ccf:	0f 95 c0             	setne  %al
c0101cd2:	0f b6 c0             	movzbl %al,%eax
}
c0101cd5:	c9                   	leave  
c0101cd6:	c3                   	ret    

c0101cd7 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101cd7:	55                   	push   %ebp
c0101cd8:	89 e5                	mov    %esp,%ebp
c0101cda:	83 ec 14             	sub    $0x14,%esp
c0101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce0:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101ce3:	90                   	nop
c0101ce4:	e8 c4 ff ff ff       	call   c0101cad <serial_idle>
c0101ce9:	85 c0                	test   %eax,%eax
c0101ceb:	74 f7                	je     c0101ce4 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101ced:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101cf1:	0f b6 c0             	movzbl %al,%eax
c0101cf4:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101cfb:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101cfe:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101d02:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d05:	ee                   	out    %al,(%dx)
}
c0101d06:	c9                   	leave  
c0101d07:	c3                   	ret    

c0101d08 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101d08:	55                   	push   %ebp
c0101d09:	89 e5                	mov    %esp,%ebp
c0101d0b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101d0e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d17:	83 ec 04             	sub    $0x4,%esp
c0101d1a:	ff 75 f4             	pushl  -0xc(%ebp)
c0101d1d:	50                   	push   %eax
c0101d1e:	68 d7 1c 10 c0       	push   $0xc0101cd7
c0101d23:	e8 47 09 00 00       	call   c010266f <vfprintf>
c0101d28:	83 c4 10             	add    $0x10,%esp
}
c0101d2b:	c9                   	leave  
c0101d2c:	c3                   	ret    

c0101d2d <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101d2d:	55                   	push   %ebp
c0101d2e:	89 e5                	mov    %esp,%ebp
c0101d30:	57                   	push   %edi
c0101d31:	56                   	push   %esi
c0101d32:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101d33:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d36:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101d3c:	89 c1                	mov    %eax,%ecx
c0101d3e:	89 d6                	mov    %edx,%esi
c0101d40:	89 df                	mov    %ebx,%edi
c0101d42:	fc                   	cld    
c0101d43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101d45:	5b                   	pop    %ebx
c0101d46:	5e                   	pop    %esi
c0101d47:	5f                   	pop    %edi
c0101d48:	5d                   	pop    %ebp
c0101d49:	c3                   	ret    

c0101d4a <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101d4a:	55                   	push   %ebp
c0101d4b:	89 e5                	mov    %esp,%ebp
c0101d4d:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101d50:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d53:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101d58:	77 16                	ja     c0101d70 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101d5a:	ff 75 10             	pushl  0x10(%ebp)
c0101d5d:	68 6c 2a 10 c0       	push   $0xc0102a6c
c0101d62:	ff 75 0c             	pushl  0xc(%ebp)
c0101d65:	ff 75 08             	pushl  0x8(%ebp)
c0101d68:	e8 9b ff ff ff       	call   c0101d08 <printk>
c0101d6d:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101d70:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d73:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101d78:	c9                   	leave  
c0101d79:	c3                   	ret    

c0101d7a <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0101d7a:	55                   	push   %ebp
c0101d7b:	89 e5                	mov    %esp,%ebp
c0101d7d:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0101d80:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d83:	c1 e8 0c             	shr    $0xc,%eax
c0101d86:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0101d8b:	76 13                	jbe    c0101da0 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0101d8d:	83 ec 08             	sub    $0x8,%esp
c0101d90:	ff 75 10             	pushl  0x10(%ebp)
c0101d93:	68 90 2a 10 c0       	push   $0xc0102a90
c0101d98:	e8 6b ff ff ff       	call   c0101d08 <printk>
c0101d9d:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0101da0:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0101da8:	c9                   	leave  
c0101da9:	c3                   	ret    

c0101daa <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0101daa:	55                   	push   %ebp
c0101dab:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0101dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db0:	ba 00 37 17 c0       	mov    $0xc0173700,%edx
c0101db5:	29 d0                	sub    %edx,%eax
c0101db7:	c1 f8 03             	sar    $0x3,%eax
c0101dba:	c1 e0 0c             	shl    $0xc,%eax
}
c0101dbd:	5d                   	pop    %ebp
c0101dbe:	c3                   	ret    

c0101dbf <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c0101dbf:	55                   	push   %ebp
c0101dc0:	89 e5                	mov    %esp,%ebp
c0101dc2:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0101dc5:	ff 75 08             	pushl  0x8(%ebp)
c0101dc8:	e8 dd ff ff ff       	call   c0101daa <page2pa>
c0101dcd:	83 c4 04             	add    $0x4,%esp
c0101dd0:	83 ec 04             	sub    $0x4,%esp
c0101dd3:	50                   	push   %eax
c0101dd4:	6a 52                	push   $0x52
c0101dd6:	68 b2 2a 10 c0       	push   $0xc0102ab2
c0101ddb:	e8 9a ff ff ff       	call   c0101d7a <_kaddr>
c0101de0:	83 c4 10             	add    $0x10,%esp
}
c0101de3:	c9                   	leave  
c0101de4:	c3                   	ret    

c0101de5 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0101deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0101df2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df5:	8b 00                	mov    (%eax),%eax
c0101df7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0101dfa:	eb 10                	jmp    c0101e0c <ll_len+0x27>
		p = p->next;
c0101dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dff:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0101e05:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0101e08:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0101e0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0101e10:	75 ea                	jne    c0101dfc <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0101e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101e15:	c9                   	leave  
c0101e16:	c3                   	ret    

c0101e17 <ll_pop>:
PCB* ll_pop(PCB** head){
c0101e17:	55                   	push   %ebp
c0101e18:	89 e5                	mov    %esp,%ebp
c0101e1a:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e20:	8b 00                	mov    (%eax),%eax
c0101e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c0101e25:	83 ec 08             	sub    $0x8,%esp
c0101e28:	ff 75 f4             	pushl  -0xc(%ebp)
c0101e2b:	ff 75 08             	pushl  0x8(%ebp)
c0101e2e:	e8 a4 00 00 00       	call   c0101ed7 <ll_delete>
c0101e33:	83 c4 10             	add    $0x10,%esp
	return p;
c0101e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e39:	c9                   	leave  
c0101e3a:	c3                   	ret    

c0101e3b <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0101e3b:	55                   	push   %ebp
c0101e3c:	89 e5                	mov    %esp,%ebp
c0101e3e:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0101e41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e44:	8b 00                	mov    (%eax),%eax
c0101e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0101e49:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0101e4d:	75 0f                	jne    c0101e5e <ll_push+0x23>
		*head = p;
c0101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e55:	89 10                	mov    %edx,(%eax)
		return 0;
c0101e57:	b8 00 00 00 00       	mov    $0x0,%eax
c0101e5c:	eb 19                	jmp    c0101e77 <ll_push+0x3c>
	}else{
		*head = p;
c0101e5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e61:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e64:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0101e66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e69:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101e6c:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		return 1;
c0101e72:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0101e77:	c9                   	leave  
c0101e78:	c3                   	ret    

c0101e79 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0101e79:	55                   	push   %ebp
c0101e7a:	89 e5                	mov    %esp,%ebp
c0101e7c:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e82:	8b 00                	mov    (%eax),%eax
c0101e84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0101e87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8a:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0101e91:	00 00 00 
	if(h == NULL){
c0101e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0101e98:	75 0f                	jne    c0101ea9 <ll_entail+0x30>
		*head = p;
c0101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101ea0:	89 10                	mov    %edx,(%eax)
		return 0;
c0101ea2:	b8 00 00 00 00       	mov    $0x0,%eax
c0101ea7:	eb 2c                	jmp    c0101ed5 <ll_entail+0x5c>
	}else{
		while(h->next){
c0101ea9:	eb 0c                	jmp    c0101eb7 <ll_entail+0x3e>
			h = h->next;
c0101eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101eae:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0101eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0101eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101eba:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0101ec0:	85 c0                	test   %eax,%eax
c0101ec2:	75 e7                	jne    c0101eab <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0101ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101eca:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		return 1;
c0101ed0:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0101ed5:	c9                   	leave  
c0101ed6:	c3                   	ret    

c0101ed7 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c0101ed7:	55                   	push   %ebp
c0101ed8:	89 e5                	mov    %esp,%ebp
c0101eda:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c0101edd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee0:	8b 00                	mov    (%eax),%eax
c0101ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0101ee5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c0101eec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0101ef0:	75 07                	jne    c0101ef9 <ll_delete+0x22>
			return 0;
c0101ef2:	b8 00 00 00 00       	mov    $0x0,%eax
c0101ef7:	eb 59                	jmp    c0101f52 <ll_delete+0x7b>
		if(sleep == p)
c0101ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101efc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0101eff:	75 09                	jne    c0101f0a <ll_delete+0x33>
			break;
c0101f01:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0101f02:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0101f06:	75 26                	jne    c0101f2e <ll_delete+0x57>
c0101f08:	eb 14                	jmp    c0101f1e <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0101f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0101f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f13:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0101f19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0101f1c:	eb ce                	jmp    c0101eec <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c0101f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f21:	8b 90 4c 40 00 00    	mov    0x404c(%eax),%edx
c0101f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2a:	89 10                	mov    %edx,(%eax)
c0101f2c:	eb 12                	jmp    c0101f40 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0101f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f31:	8b 90 4c 40 00 00    	mov    0x404c(%eax),%edx
c0101f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f3a:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
	sleep->next = NULL;
c0101f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f43:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0101f4a:	00 00 00 
	return 1;
c0101f4d:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0101f52:	c9                   	leave  
c0101f53:	c3                   	ret    

c0101f54 <init_pcb_pool>:

void init_pcb_pool()
{
c0101f54:	55                   	push   %ebp
c0101f55:	89 e5                	mov    %esp,%ebp
c0101f57:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101f61:	eb 1d                	jmp    c0101f80 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0101f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f66:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c0101f6c:	05 30 40 00 00       	add    $0x4030,%eax
c0101f71:	05 40 6f 1c c0       	add    $0xc01c6f40,%eax
c0101f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101f7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101f80:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0101f87:	76 da                	jbe    c0101f63 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0101f89:	c9                   	leave  
c0101f8a:	c3                   	ret    

c0101f8b <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0101f8b:	55                   	push   %ebp
c0101f8c:	89 e5                	mov    %esp,%ebp
c0101f8e:	83 ec 24             	sub    $0x24,%esp
c0101f91:	8b 45 14             	mov    0x14(%ebp),%eax
c0101f94:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0101f97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9a:	8b 80 44 40 00 00    	mov    0x4044(%eax),%eax
c0101fa0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0101fa3:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0101fa7:	75 46                	jne    c0101fef <init_pcb+0x64>
		tf->ds = GD_KD;
c0101fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fac:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0101fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fb6:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0101fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fc0:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0101fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fc9:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0101fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fd3:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0101fda:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fdd:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0101fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fe6:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0101fed:	eb 4a                	jmp    c0102039 <init_pcb+0xae>
	}else
	if(pri == 3){
c0101fef:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0101ff3:	75 44                	jne    c0102039 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0101ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ff8:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0101fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102002:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0102009:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010200c:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0102012:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102015:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c010201c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010201f:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0102026:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102029:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c010202f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102032:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0102039:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010203c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010203f:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0102042:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102045:	8b 55 10             	mov    0x10(%ebp),%edx
c0102048:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c010204b:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010204f:	75 59                	jne    c01020aa <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c0102051:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0102057:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010205a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c010205d:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0102064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010206b:	eb 26                	jmp    c0102093 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c010206d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102070:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102077:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010207a:	01 c2                	add    %eax,%edx
c010207c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010207f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0102086:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102089:	01 c8                	add    %ecx,%eax
c010208b:	8b 00                	mov    (%eax),%eax
c010208d:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c010208f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102093:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102096:	c1 e8 02             	shr    $0x2,%eax
c0102099:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010209c:	77 cf                	ja     c010206d <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c010209e:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01020a4:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	}
	//lcr3(PADDR(kern_pgdir));
}
c01020aa:	c9                   	leave  
c01020ab:	c3                   	ret    

c01020ac <pcb_create>:

PCB* pcb_create()
{
c01020ac:	55                   	push   %ebp
c01020ad:	89 e5                	mov    %esp,%ebp
c01020af:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01020b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01020b9:	eb 1f                	jmp    c01020da <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c01020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020be:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c01020c4:	05 30 40 00 00       	add    $0x4030,%eax
c01020c9:	05 40 6f 1c c0       	add    $0xc01c6f40,%eax
c01020ce:	8b 00                	mov    (%eax),%eax
c01020d0:	85 c0                	test   %eax,%eax
c01020d2:	75 02                	jne    c01020d6 <pcb_create+0x2a>
c01020d4:	eb 0d                	jmp    c01020e3 <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01020d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01020da:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01020e1:	76 d8                	jbe    c01020bb <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020e6:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c01020ec:	05 40 6f 1c c0       	add    $0xc01c6f40,%eax
c01020f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c01020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020f7:	6b c0 4c             	imul   $0x4c,%eax,%eax
c01020fa:	8d 90 40 46 1b c0    	lea    -0x3fe4b9c0(%eax),%edx
c0102100:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102103:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	p->used = 1;
c0102109:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010210c:	c7 80 30 40 00 00 01 	movl   $0x1,0x4030(%eax)
c0102113:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0102116:	83 ec 0c             	sub    $0xc,%esp
c0102119:	6a 01                	push   $0x1
c010211b:	e8 48 e7 ff ff       	call   c0100868 <page_alloc>
c0102120:	83 c4 10             	add    $0x10,%esp
c0102123:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0102126:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010212a:	75 07                	jne    c0102133 <pcb_create+0x87>
c010212c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102131:	eb 77                	jmp    c01021aa <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c0102133:	83 ec 0c             	sub    $0xc,%esp
c0102136:	ff 75 ec             	pushl  -0x14(%ebp)
c0102139:	e8 81 fc ff ff       	call   c0101dbf <page2kva>
c010213e:	83 c4 10             	add    $0x10,%esp
c0102141:	89 c2                	mov    %eax,%edx
c0102143:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102146:	89 90 48 40 00 00    	mov    %edx,0x4048(%eax)
	p->pid = pid;
c010214c:	8b 15 ac 40 15 c0    	mov    0xc01540ac,%edx
c0102152:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102155:	89 90 34 40 00 00    	mov    %edx,0x4034(%eax)
	p->timeslice = 0;
c010215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010215e:	c7 80 40 40 00 00 00 	movl   $0x0,0x4040(%eax)
c0102165:	00 00 00 
	//p->ts = READY;
	pid ++;
c0102168:	a1 ac 40 15 c0       	mov    0xc01540ac,%eax
c010216d:	83 c0 01             	add    $0x1,%eax
c0102170:	a3 ac 40 15 c0       	mov    %eax,0xc01540ac
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0102175:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102178:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010217c:	8d 50 01             	lea    0x1(%eax),%edx
c010217f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102182:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0102186:	8b 15 c0 36 17 c0    	mov    0xc01736c0,%edx
c010218c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010218f:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c0102195:	83 ec 04             	sub    $0x4,%esp
c0102198:	68 00 10 00 00       	push   $0x1000
c010219d:	52                   	push   %edx
c010219e:	50                   	push   %eax
c010219f:	e8 89 fb ff ff       	call   c0101d2d <memcpy>
c01021a4:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c01021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01021aa:	c9                   	leave  
c01021ab:	c3                   	ret    

c01021ac <enready_pcb>:

void enready_pcb(PCB* pcb){
c01021ac:	55                   	push   %ebp
c01021ad:	89 e5                	mov    %esp,%ebp
c01021af:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c01021b2:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01021b7:	85 c0                	test   %eax,%eax
c01021b9:	75 18                	jne    c01021d3 <enready_pcb+0x27>
		ready_list = pcb;
c01021bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01021be:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
		ready_list->tail = pcb;
c01021c3:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01021c8:	8b 55 08             	mov    0x8(%ebp),%edx
c01021cb:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)
c01021d1:	eb 32                	jmp    c0102205 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01021d3:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01021d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01021db:	8b 45 08             	mov    0x8(%ebp),%eax
c01021de:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
		ready_list->next = temp;
c01021e3:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01021e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01021eb:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		ready_list->tail = temp->tail;
c01021f1:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01021f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01021f9:	8b 92 50 40 00 00    	mov    0x4050(%edx),%edx
c01021ff:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)
	}
}
c0102205:	c9                   	leave  
c0102206:	c3                   	ret    

c0102207 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0102207:	55                   	push   %ebp
c0102208:	89 e5                	mov    %esp,%ebp
c010220a:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c010220d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102210:	a3 b0 40 15 c0       	mov    %eax,0xc01540b0
	lcr3(PADDR(pcb -> pgdir));
c0102215:	8b 45 08             	mov    0x8(%ebp),%eax
c0102218:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010221e:	83 ec 04             	sub    $0x4,%esp
c0102221:	50                   	push   %eax
c0102222:	68 ae 00 00 00       	push   $0xae
c0102227:	68 c8 2a 10 c0       	push   $0xc0102ac8
c010222c:	e8 19 fb ff ff       	call   c0101d4a <_paddr>
c0102231:	83 c4 10             	add    $0x10,%esp
c0102234:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102237:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010223a:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c010223d:	83 ec 0c             	sub    $0xc,%esp
c0102240:	ff 75 08             	pushl  0x8(%ebp)
c0102243:	e8 14 e1 ff ff       	call   c010035c <enter_pcb>
c0102248:	83 c4 10             	add    $0x10,%esp
}
c010224b:	c9                   	leave  
c010224c:	c3                   	ret    

c010224d <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c010224d:	55                   	push   %ebp
c010224e:	89 e5                	mov    %esp,%ebp
c0102250:	57                   	push   %edi
c0102251:	56                   	push   %esi
c0102252:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102253:	8b 45 10             	mov    0x10(%ebp),%eax
c0102256:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102259:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010225c:	89 c1                	mov    %eax,%ecx
c010225e:	89 d6                	mov    %edx,%esi
c0102260:	89 df                	mov    %ebx,%edi
c0102262:	fc                   	cld    
c0102263:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102265:	5b                   	pop    %ebx
c0102266:	5e                   	pop    %esi
c0102267:	5f                   	pop    %edi
c0102268:	5d                   	pop    %ebp
c0102269:	c3                   	ret    

c010226a <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c010226a:	55                   	push   %ebp
c010226b:	89 e5                	mov    %esp,%ebp
c010226d:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102270:	68 80 3e 00 00       	push   $0x3e80
c0102275:	68 c0 3a 16 c0       	push   $0xc0163ac0
c010227a:	68 c0 40 15 c0       	push   $0xc01540c0
c010227f:	e8 c9 ff ff ff       	call   c010224d <memcpy>
c0102284:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0102287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010228e:	eb 0f                	jmp    c010229f <initVCache+0x35>
		VDIRTY[x] = 0;
c0102290:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102293:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0102298:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c010229b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010229f:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01022a6:	7e e8                	jle    c0102290 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c01022a8:	c9                   	leave  
c01022a9:	c3                   	ret    

c01022aa <refreshVCache>:
void refreshVCache(){
c01022aa:	55                   	push   %ebp
c01022ab:	89 e5                	mov    %esp,%ebp
c01022ad:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c01022b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01022b7:	eb 0f                	jmp    c01022c8 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c01022b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022bc:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c01022c1:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c01022c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022c8:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01022cf:	7e e8                	jle    c01022b9 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c01022d1:	c9                   	leave  
c01022d2:	c3                   	ret    

c01022d3 <flushVCache>:
void flushVCache(){
c01022d3:	55                   	push   %ebp
c01022d4:	89 e5                	mov    %esp,%ebp
c01022d6:	53                   	push   %ebx
c01022d7:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c01022da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01022e1:	eb 47                	jmp    c010232a <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c01022e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022e6:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c01022eb:	0f b6 00             	movzbl (%eax),%eax
c01022ee:	84 c0                	test   %al,%al
c01022f0:	74 34                	je     c0102326 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c01022f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01022f5:	89 d0                	mov    %edx,%eax
c01022f7:	c1 e0 02             	shl    $0x2,%eax
c01022fa:	01 d0                	add    %edx,%eax
c01022fc:	c1 e0 06             	shl    $0x6,%eax
c01022ff:	8d 88 c0 40 15 c0    	lea    -0x3feabf40(%eax),%ecx
c0102305:	8b 1d a8 60 10 c0    	mov    0xc01060a8,%ebx
c010230b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010230e:	89 d0                	mov    %edx,%eax
c0102310:	c1 e0 02             	shl    $0x2,%eax
c0102313:	01 d0                	add    %edx,%eax
c0102315:	c1 e0 06             	shl    $0x6,%eax
c0102318:	01 d8                	add    %ebx,%eax
c010231a:	6a 50                	push   $0x50
c010231c:	51                   	push   %ecx
c010231d:	50                   	push   %eax
c010231e:	e8 2a ff ff ff       	call   c010224d <memcpy>
c0102323:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102326:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c010232a:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102331:	7e b0                	jle    c01022e3 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0102333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102336:	c9                   	leave  
c0102337:	c3                   	ret    

c0102338 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0102338:	55                   	push   %ebp
c0102339:	89 e5                	mov    %esp,%ebp
c010233b:	83 ec 04             	sub    $0x4,%esp
c010233e:	8b 45 10             	mov    0x10(%ebp),%eax
c0102341:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0102344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102348:	78 18                	js     c0102362 <setPixelAt+0x2a>
c010234a:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102351:	7f 0f                	jg     c0102362 <setPixelAt+0x2a>
c0102353:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102357:	78 09                	js     c0102362 <setPixelAt+0x2a>
c0102359:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102360:	7e 02                	jle    c0102364 <setPixelAt+0x2c>
c0102362:	eb 34                	jmp    c0102398 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0102364:	8b 45 08             	mov    0x8(%ebp),%eax
c0102367:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c010236c:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c010236f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102372:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c0102377:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c010237a:	8b 55 08             	mov    0x8(%ebp),%edx
c010237d:	89 d0                	mov    %edx,%eax
c010237f:	c1 e0 02             	shl    $0x2,%eax
c0102382:	01 d0                	add    %edx,%eax
c0102384:	c1 e0 06             	shl    $0x6,%eax
c0102387:	89 c2                	mov    %eax,%edx
c0102389:	8b 45 0c             	mov    0xc(%ebp),%eax
c010238c:	01 c2                	add    %eax,%edx
c010238e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0102392:	88 82 c0 40 15 c0    	mov    %al,-0x3feabf40(%edx)
}
c0102398:	c9                   	leave  
c0102399:	c3                   	ret    

c010239a <forceClearVRAM>:
void forceClearVRAM(){
c010239a:	55                   	push   %ebp
c010239b:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c010239d:	5d                   	pop    %ebp
c010239e:	c3                   	ret    

c010239f <clearVRAM>:
void clearVRAM(){
c010239f:	55                   	push   %ebp
c01023a0:	89 e5                	mov    %esp,%ebp
c01023a2:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01023a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01023ac:	eb 4e                	jmp    c01023fc <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c01023ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023b1:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c01023b6:	0f b6 00             	movzbl (%eax),%eax
c01023b9:	0f b6 c0             	movzbl %al,%eax
c01023bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023bf:	81 c2 c0 34 17 c0    	add    $0xc01734c0,%edx
c01023c5:	0f b6 12             	movzbl (%edx),%edx
c01023c8:	0f b6 d2             	movzbl %dl,%edx
c01023cb:	f7 d2                	not    %edx
c01023cd:	21 d0                	and    %edx,%eax
c01023cf:	85 c0                	test   %eax,%eax
c01023d1:	74 25                	je     c01023f8 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c01023d3:	8b 0d a8 60 10 c0    	mov    0xc01060a8,%ecx
c01023d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023dc:	89 d0                	mov    %edx,%eax
c01023de:	c1 e0 02             	shl    $0x2,%eax
c01023e1:	01 d0                	add    %edx,%eax
c01023e3:	c1 e0 06             	shl    $0x6,%eax
c01023e6:	01 c8                	add    %ecx,%eax
c01023e8:	6a 50                	push   $0x50
c01023ea:	68 c0 3a 16 c0       	push   $0xc0163ac0
c01023ef:	50                   	push   %eax
c01023f0:	e8 58 fe ff ff       	call   c010224d <memcpy>
c01023f5:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01023f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01023fc:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102403:	7e a9                	jle    c01023ae <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0102405:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c010240c:	83 c0 01             	add    $0x1,%eax
c010240f:	a2 88 36 17 c0       	mov    %al,0xc0173688
	if(stamp==30){
c0102414:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c010241b:	3c 1e                	cmp    $0x1e,%al
c010241d:	75 07                	jne    c0102426 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c010241f:	c6 05 88 36 17 c0 00 	movb   $0x0,0xc0173688
		//printk("What matters\n");
	}
	if(stamp==0){
c0102426:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c010242d:	84 c0                	test   %al,%al
c010242f:	75 14                	jne    c0102445 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102431:	6a 32                	push   $0x32
c0102433:	68 c0 3a 16 c0       	push   $0xc0163ac0
c0102438:	68 c0 35 17 c0       	push   $0xc01735c0
c010243d:	e8 0b fe ff ff       	call   c010224d <memcpy>
c0102442:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0102445:	c9                   	leave  
c0102446:	c3                   	ret    

c0102447 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0102447:	55                   	push   %ebp
c0102448:	89 e5                	mov    %esp,%ebp
c010244a:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c010244d:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c0102452:	83 c0 01             	add    $0x1,%eax
c0102455:	a3 8c 36 17 c0       	mov    %eax,0xc017368c
	current->timeslice ++;
c010245a:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c010245f:	8b 90 40 40 00 00    	mov    0x4040(%eax),%edx
c0102465:	83 c2 01             	add    $0x1,%edx
c0102468:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)

	PCB *sleep = sleep_list, *cur;
c010246e:	a1 b8 40 15 c0       	mov    0xc01540b8,%eax
c0102473:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0102476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010247a:	75 02                	jne    c010247e <do_timer+0x37>
c010247c:	eb 6b                	jmp    c01024e9 <do_timer+0xa2>
	 	sleep->timeslice --;
c010247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102481:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c0102487:	8d 50 ff             	lea    -0x1(%eax),%edx
c010248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010248d:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)
	 	
	 	cur = sleep;
c0102493:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102496:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0102499:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010249c:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c01024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c01024a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024a8:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c01024ae:	85 c0                	test   %eax,%eax
c01024b0:	74 02                	je     c01024b4 <do_timer+0x6d>
c01024b2:	eb 33                	jmp    c01024e7 <do_timer+0xa0>
	 	cur->ts = READY;
c01024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024b7:	c7 80 3c 40 00 00 00 	movl   $0x0,0x403c(%eax)
c01024be:	00 00 00 
		ll_delete(&sleep_list, cur);
c01024c1:	83 ec 08             	sub    $0x8,%esp
c01024c4:	ff 75 f0             	pushl  -0x10(%ebp)
c01024c7:	68 b8 40 15 c0       	push   $0xc01540b8
c01024cc:	e8 06 fa ff ff       	call   c0101ed7 <ll_delete>
c01024d1:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c01024d4:	83 ec 08             	sub    $0x8,%esp
c01024d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01024da:	68 b4 40 15 c0       	push   $0xc01540b4
c01024df:	e8 95 f9 ff ff       	call   c0101e79 <ll_entail>
c01024e4:	83 c4 10             	add    $0x10,%esp
	}
c01024e7:	eb 8d                	jmp    c0102476 <do_timer+0x2f>
}
c01024e9:	c9                   	leave  
c01024ea:	c3                   	ret    

c01024eb <tick>:
uint32_t tick(){
c01024eb:	55                   	push   %ebp
c01024ec:	89 e5                	mov    %esp,%ebp
	return _tick;
c01024ee:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c01024f3:	5d                   	pop    %ebp
c01024f4:	c3                   	ret    

c01024f5 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c01024f5:	6a 00                	push   $0x0
c01024f7:	6a 00                	push   $0x0
c01024f9:	e9 b8 00 00 00       	jmp    c01025b6 <asm_do_irq>

c01024fe <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c01024fe:	6a 00                	push   $0x0
c0102500:	6a 01                	push   $0x1
c0102502:	e9 af 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102507 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0102507:	6a 00                	push   $0x0
c0102509:	6a 02                	push   $0x2
c010250b:	e9 a6 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102510 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0102510:	6a 00                	push   $0x0
c0102512:	6a 03                	push   $0x3
c0102514:	e9 9d 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102519 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0102519:	6a 00                	push   $0x0
c010251b:	6a 04                	push   $0x4
c010251d:	e9 94 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102522 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0102522:	6a 00                	push   $0x0
c0102524:	6a 05                	push   $0x5
c0102526:	e9 8b 00 00 00       	jmp    c01025b6 <asm_do_irq>

c010252b <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c010252b:	6a 00                	push   $0x0
c010252d:	6a 06                	push   $0x6
c010252f:	e9 82 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102534 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0102534:	6a 00                	push   $0x0
c0102536:	6a 07                	push   $0x7
c0102538:	e9 79 00 00 00       	jmp    c01025b6 <asm_do_irq>

c010253d <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c010253d:	6a 00                	push   $0x0
c010253f:	6a 08                	push   $0x8
c0102541:	e9 70 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102546 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0102546:	6a 00                	push   $0x0
c0102548:	6a 09                	push   $0x9
c010254a:	e9 67 00 00 00       	jmp    c01025b6 <asm_do_irq>

c010254f <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c010254f:	6a 00                	push   $0x0
c0102551:	6a 0a                	push   $0xa
c0102553:	e9 5e 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102558 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0102558:	6a 00                	push   $0x0
c010255a:	6a 0b                	push   $0xb
c010255c:	e9 55 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102561 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102561:	6a 00                	push   $0x0
c0102563:	6a 0c                	push   $0xc
c0102565:	e9 4c 00 00 00       	jmp    c01025b6 <asm_do_irq>

c010256a <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c010256a:	6a 00                	push   $0x0
c010256c:	6a 0d                	push   $0xd
c010256e:	e9 43 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102573 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102573:	6a 00                	push   $0x0
c0102575:	6a 0e                	push   $0xe
c0102577:	e9 3a 00 00 00       	jmp    c01025b6 <asm_do_irq>

c010257c <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c010257c:	fa                   	cli    
c010257d:	6a 00                	push   $0x0
c010257f:	68 80 00 00 00       	push   $0x80
c0102584:	e9 2d 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102589 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102589:	6a 00                	push   $0x0
c010258b:	68 e8 03 00 00       	push   $0x3e8
c0102590:	e9 21 00 00 00       	jmp    c01025b6 <asm_do_irq>

c0102595 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102595:	6a 00                	push   $0x0
c0102597:	68 e9 03 00 00       	push   $0x3e9
c010259c:	e9 15 00 00 00       	jmp    c01025b6 <asm_do_irq>

c01025a1 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c01025a1:	6a 00                	push   $0x0
c01025a3:	68 f6 03 00 00       	push   $0x3f6
c01025a8:	e9 09 00 00 00       	jmp    c01025b6 <asm_do_irq>

c01025ad <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c01025ad:	6a 00                	push   $0x0
c01025af:	6a ff                	push   $0xffffffff
c01025b1:	e9 00 00 00 00       	jmp    c01025b6 <asm_do_irq>

c01025b6 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c01025b6:	fa                   	cli    
  pushl %ds
c01025b7:	1e                   	push   %ds
  pushl %es
c01025b8:	06                   	push   %es
  pushl %fs
c01025b9:	0f a0                	push   %fs
  pushl %gs
c01025bb:	0f a8                	push   %gs
	pushal
c01025bd:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c01025be:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c01025c2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c01025c4:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c01025c6:	54                   	push   %esp
  call irq_handle
c01025c7:	e8 10 e8 ff ff       	call   c0100ddc <irq_handle>
  addl $4, %esp
c01025cc:	83 c4 04             	add    $0x4,%esp

c01025cf <switch_proc>:
switch_proc:
  popal
c01025cf:	61                   	popa   
  popl %gs
c01025d0:	0f a9                	pop    %gs
  popl %fs
c01025d2:	0f a1                	pop    %fs
  popl %es
c01025d4:	07                   	pop    %es
  popl %ds
c01025d5:	1f                   	pop    %ds
  addl $8, %esp
c01025d6:	83 c4 08             	add    $0x8,%esp
  sti
c01025d9:	fb                   	sti    
  iret
c01025da:	cf                   	iret   
c01025db:	90                   	nop
c01025dc:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c01025e2:	00 00                	add    %al,(%eax)
c01025e4:	fe 4f 52             	decb   0x52(%edi)
c01025e7:	e4 66                	in     $0x66,%al

c01025e8 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c01025e8:	66 c7 05 72 04 00 00 34 12 b8 00 50 10 00 0f 22     f..r...4...P..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c01025f8:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 0b 26 10     .. ......."...&.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0102608:	c0 ff e0                                            ...

c010260b <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c010260b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0102610:	bc 00 f0 10 c0       	mov    $0xc010f000,%esp

	# now to C code

	call	main
c0102615:	e8 ce ee ff ff       	call   c01014e8 <main>

c010261a <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c010261a:	eb fe                	jmp    c010261a <spin>

c010261c <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c010261c:	55                   	push   %ebp
c010261d:	89 e5                	mov    %esp,%ebp
c010261f:	53                   	push   %ebx
c0102620:	83 ec 04             	sub    $0x4,%esp
c0102623:	8b 45 08             	mov    0x8(%ebp),%eax
c0102626:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0102629:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c010262e:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0102632:	89 d3                	mov    %edx,%ebx
c0102634:	cd 80                	int    $0x80
}
c0102636:	83 c4 04             	add    $0x4,%esp
c0102639:	5b                   	pop    %ebx
c010263a:	5d                   	pop    %ebp
c010263b:	c3                   	ret    

c010263c <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c010263c:	55                   	push   %ebp
c010263d:	89 e5                	mov    %esp,%ebp
c010263f:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0102642:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102645:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0102648:	eb 19                	jmp    c0102663 <printp+0x27>
		printer(cur);
c010264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010264d:	0f b6 00             	movzbl (%eax),%eax
c0102650:	0f be c0             	movsbl %al,%eax
c0102653:	83 ec 0c             	sub    $0xc,%esp
c0102656:	50                   	push   %eax
c0102657:	8b 45 08             	mov    0x8(%ebp),%eax
c010265a:	ff d0                	call   *%eax
c010265c:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c010265f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102663:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102666:	0f b6 00             	movzbl (%eax),%eax
c0102669:	84 c0                	test   %al,%al
c010266b:	75 dd                	jne    c010264a <printp+0xe>
		printer(cur);
	}
}
c010266d:	c9                   	leave  
c010266e:	c3                   	ret    

c010266f <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c010266f:	55                   	push   %ebp
c0102670:	89 e5                	mov    %esp,%ebp
c0102672:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102675:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102678:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c010267b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0102682:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0102689:	8b 45 10             	mov    0x10(%ebp),%eax
c010268c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c010268f:	e9 65 02 00 00       	jmp    c01028f9 <vfprintf+0x28a>

		if(cur == '%'){
c0102694:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102697:	0f b6 00             	movzbl (%eax),%eax
c010269a:	3c 25                	cmp    $0x25,%al
c010269c:	75 0c                	jne    c01026aa <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c010269e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c01026a5:	e9 4b 02 00 00       	jmp    c01028f5 <vfprintf+0x286>
		}
		if(type == READ){
c01026aa:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c01026ae:	0f 85 26 02 00 00    	jne    c01028da <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c01026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026b7:	0f b6 00             	movzbl (%eax),%eax
c01026ba:	3c 73                	cmp    $0x73,%al
c01026bc:	75 35                	jne    c01026f3 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c01026be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01026c1:	8b 00                	mov    (%eax),%eax
c01026c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c01026c6:	eb 19                	jmp    c01026e1 <vfprintf+0x72>
					printer(*p);
c01026c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01026cb:	0f b6 00             	movzbl (%eax),%eax
c01026ce:	0f be c0             	movsbl %al,%eax
c01026d1:	83 ec 0c             	sub    $0xc,%esp
c01026d4:	50                   	push   %eax
c01026d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d8:	ff d0                	call   *%eax
c01026da:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c01026dd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c01026e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01026e4:	0f b6 00             	movzbl (%eax),%eax
c01026e7:	84 c0                	test   %al,%al
c01026e9:	75 dd                	jne    c01026c8 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c01026eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01026ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c01026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026f6:	0f b6 00             	movzbl (%eax),%eax
c01026f9:	3c 78                	cmp    $0x78,%al
c01026fb:	0f 85 99 00 00 00    	jne    c010279a <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0102701:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102704:	8b 00                	mov    (%eax),%eax
c0102706:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0102709:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010270d:	75 1d                	jne    c010272c <vfprintf+0xbd>
					printer('0');
c010270f:	83 ec 0c             	sub    $0xc,%esp
c0102712:	6a 30                	push   $0x30
c0102714:	8b 45 08             	mov    0x8(%ebp),%eax
c0102717:	ff d0                	call   *%eax
c0102719:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c010271c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102720:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102727:	e9 c9 01 00 00       	jmp    c01028f5 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c010272c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0102733:	eb 2d                	jmp    c0102762 <vfprintf+0xf3>
					int d=(x%16);
c0102735:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102738:	83 e0 0f             	and    $0xf,%eax
c010273b:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c010273e:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0102742:	7e 04                	jle    c0102748 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0102744:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0102748:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010274b:	83 c0 30             	add    $0x30,%eax
c010274e:	89 c1                	mov    %eax,%ecx
c0102750:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102756:	01 d0                	add    %edx,%eax
c0102758:	88 08                	mov    %cl,(%eax)
					x>>=4;
c010275a:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c010275e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102762:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102766:	75 cd                	jne    c0102735 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0102768:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c010276c:	eb 1e                	jmp    c010278c <vfprintf+0x11d>
					printer(digits[di]);
c010276e:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102771:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102774:	01 d0                	add    %edx,%eax
c0102776:	0f b6 00             	movzbl (%eax),%eax
c0102779:	0f be c0             	movsbl %al,%eax
c010277c:	83 ec 0c             	sub    $0xc,%esp
c010277f:	50                   	push   %eax
c0102780:	8b 45 08             	mov    0x8(%ebp),%eax
c0102783:	ff d0                	call   *%eax
c0102785:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0102788:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c010278c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102790:	79 dc                	jns    c010276e <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0102792:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102796:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c010279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010279d:	0f b6 00             	movzbl (%eax),%eax
c01027a0:	3c 64                	cmp    $0x64,%al
c01027a2:	0f 85 02 01 00 00    	jne    c01028aa <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c01027a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01027ab:	8b 00                	mov    (%eax),%eax
c01027ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c01027b0:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c01027b7:	75 23                	jne    c01027dc <vfprintf+0x16d>
					printp(printer, "-2147483648");
c01027b9:	83 ec 08             	sub    $0x8,%esp
c01027bc:	68 dd 2a 10 c0       	push   $0xc0102add
c01027c1:	ff 75 08             	pushl  0x8(%ebp)
c01027c4:	e8 73 fe ff ff       	call   c010263c <printp>
c01027c9:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01027cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01027d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01027d7:	e9 19 01 00 00       	jmp    c01028f5 <vfprintf+0x286>
				}
				if(x==0){
c01027dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01027e0:	75 1e                	jne    c0102800 <vfprintf+0x191>
					printer('0');
c01027e2:	83 ec 0c             	sub    $0xc,%esp
c01027e5:	6a 30                	push   $0x30
c01027e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ea:	ff d0                	call   *%eax
c01027ec:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01027ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01027f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01027fa:	90                   	nop
c01027fb:	e9 f5 00 00 00       	jmp    c01028f5 <vfprintf+0x286>
				}
				if(x<0){
c0102800:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102804:	79 10                	jns    c0102816 <vfprintf+0x1a7>
					printer('-');
c0102806:	83 ec 0c             	sub    $0xc,%esp
c0102809:	6a 2d                	push   $0x2d
c010280b:	8b 45 08             	mov    0x8(%ebp),%eax
c010280e:	ff d0                	call   *%eax
c0102810:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0102813:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0102816:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c010281d:	eb 53                	jmp    c0102872 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c010281f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102822:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0102827:	89 c8                	mov    %ecx,%eax
c0102829:	f7 ea                	imul   %edx
c010282b:	c1 fa 02             	sar    $0x2,%edx
c010282e:	89 c8                	mov    %ecx,%eax
c0102830:	c1 f8 1f             	sar    $0x1f,%eax
c0102833:	29 c2                	sub    %eax,%edx
c0102835:	89 d0                	mov    %edx,%eax
c0102837:	c1 e0 02             	shl    $0x2,%eax
c010283a:	01 d0                	add    %edx,%eax
c010283c:	01 c0                	add    %eax,%eax
c010283e:	29 c1                	sub    %eax,%ecx
c0102840:	89 ca                	mov    %ecx,%edx
c0102842:	89 d0                	mov    %edx,%eax
c0102844:	83 c0 30             	add    $0x30,%eax
c0102847:	89 c1                	mov    %eax,%ecx
c0102849:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c010284c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010284f:	01 d0                	add    %edx,%eax
c0102851:	88 08                	mov    %cl,(%eax)
					x/=10;
c0102853:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102856:	ba 67 66 66 66       	mov    $0x66666667,%edx
c010285b:	89 c8                	mov    %ecx,%eax
c010285d:	f7 ea                	imul   %edx
c010285f:	c1 fa 02             	sar    $0x2,%edx
c0102862:	89 c8                	mov    %ecx,%eax
c0102864:	c1 f8 1f             	sar    $0x1f,%eax
c0102867:	29 c2                	sub    %eax,%edx
c0102869:	89 d0                	mov    %edx,%eax
c010286b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010286e:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102872:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102876:	7f a7                	jg     c010281f <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0102878:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c010287c:	eb 1e                	jmp    c010289c <vfprintf+0x22d>
					printer(digits[di]);
c010287e:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0102881:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102884:	01 d0                	add    %edx,%eax
c0102886:	0f b6 00             	movzbl (%eax),%eax
c0102889:	0f be c0             	movsbl %al,%eax
c010288c:	83 ec 0c             	sub    $0xc,%esp
c010288f:	50                   	push   %eax
c0102890:	8b 45 08             	mov    0x8(%ebp),%eax
c0102893:	ff d0                	call   *%eax
c0102895:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0102898:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c010289c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01028a0:	79 dc                	jns    c010287e <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01028a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01028a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c01028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028ad:	0f b6 00             	movzbl (%eax),%eax
c01028b0:	3c 63                	cmp    $0x63,%al
c01028b2:	75 1d                	jne    c01028d1 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c01028b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01028b7:	0f b6 00             	movzbl (%eax),%eax
c01028ba:	0f be c0             	movsbl %al,%eax
c01028bd:	83 ec 0c             	sub    $0xc,%esp
c01028c0:	50                   	push   %eax
c01028c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c4:	ff d0                	call   *%eax
c01028c6:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c01028c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01028cd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c01028d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c01028d8:	eb 1b                	jmp    c01028f5 <vfprintf+0x286>
		}
		if(type == NONE){
c01028da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01028de:	75 15                	jne    c01028f5 <vfprintf+0x286>
			printer(cur);
c01028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028e3:	0f b6 00             	movzbl (%eax),%eax
c01028e6:	0f be c0             	movsbl %al,%eax
c01028e9:	83 ec 0c             	sub    $0xc,%esp
c01028ec:	50                   	push   %eax
c01028ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f0:	ff d0                	call   *%eax
c01028f2:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01028f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028fc:	0f b6 00             	movzbl (%eax),%eax
c01028ff:	84 c0                	test   %al,%al
c0102901:	0f 85 8d fd ff ff    	jne    c0102694 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0102907:	c9                   	leave  
c0102908:	c3                   	ret    

c0102909 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0102909:	55                   	push   %ebp
c010290a:	89 e5                	mov    %esp,%ebp
c010290c:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010290f:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102912:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0102915:	8b 45 08             	mov    0x8(%ebp),%eax
c0102918:	83 ec 04             	sub    $0x4,%esp
c010291b:	ff 75 f4             	pushl  -0xc(%ebp)
c010291e:	50                   	push   %eax
c010291f:	68 1c 26 10 c0       	push   $0xc010261c
c0102924:	e8 46 fd ff ff       	call   c010266f <vfprintf>
c0102929:	83 c4 10             	add    $0x10,%esp
}
c010292c:	c9                   	leave  
c010292d:	c3                   	ret    
