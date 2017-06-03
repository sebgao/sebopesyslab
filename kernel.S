
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
c0100009:	66 a3 b0 30 13 c0    	mov    %ax,0xc01330b0
	data[1] = (uint32_t)addr;
c010000f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100012:	66 a3 b2 30 13 c0    	mov    %ax,0xc01330b2
	data[2] = ((uint32_t)addr) >> 16;
c0100018:	8b 45 08             	mov    0x8(%ebp),%eax
c010001b:	c1 e8 10             	shr    $0x10,%eax
c010001e:	66 a3 b4 30 13 c0    	mov    %ax,0xc01330b4
	asm volatile("lgdt (%0)" : : "r"(data));
c0100024:	b8 b0 30 13 c0       	mov    $0xc01330b0,%eax
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
c01000ba:	e8 18 3d 00 00       	call   c0103dd7 <vfprintf>
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
c01000f0:	68 98 40 10 c0       	push   $0xc0104098
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
c0100110:	b8 00 10 11 c0       	mov    $0xc0111000,%eax
}
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <get_kpdir>:

PDE* get_kpdir() {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
	return kpdir;
c010011a:	b8 00 20 11 c0       	mov    $0xc0112000,%eax
}
c010011f:	5d                   	pop    %ebp
c0100120:	c3                   	ret    

c0100121 <get_kptable>:

PTE* get_kptable() {
c0100121:	55                   	push   %ebp
c0100122:	89 e5                	mov    %esp,%ebp
	return kptable;
c0100124:	b8 00 30 11 c0       	mov    $0xc0113000,%eax
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
c010013e:	c7 05 08 30 13 c0 10 	movl   $0x10,0xc0133008
c0100145:	00 00 00 
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
c0100148:	c7 45 fc 00 30 13 c0 	movl   $0xc0133000,-0x4(%ebp)
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
c010021b:	a3 04 30 13 c0       	mov    %eax,0xc0133004
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
c01002e3:	68 80 30 13 c0       	push   $0xc0133080
c01002e8:	e8 d7 fd ff ff       	call   c01000c4 <memset>
c01002ed:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
c01002f0:	6a 0a                	push   $0xa
c01002f2:	6a 00                	push   $0x0
c01002f4:	68 88 30 13 c0       	push   $0xc0133088
c01002f9:	e8 24 ff ff ff       	call   c0100222 <set_segment>
c01002fe:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
c0100301:	6a 02                	push   $0x2
c0100303:	6a 00                	push   $0x0
c0100305:	68 90 30 13 c0       	push   $0xc0133090
c010030a:	e8 13 ff ff ff       	call   c0100222 <set_segment>
c010030f:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
c0100312:	6a 0a                	push   $0xa
c0100314:	6a 03                	push   $0x3
c0100316:	68 98 30 13 c0       	push   $0xc0133098
c010031b:	e8 02 ff ff ff       	call   c0100222 <set_segment>
c0100320:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
c0100323:	6a 02                	push   $0x2
c0100325:	6a 03                	push   $0x3
c0100327:	68 a0 30 13 c0       	push   $0xc01330a0
c010032c:	e8 f1 fe ff ff       	call   c0100222 <set_segment>
c0100331:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
c0100334:	6a 30                	push   $0x30
c0100336:	68 80 30 13 c0       	push   $0xc0133080
c010033b:	e8 c0 fc ff ff       	call   c0100000 <write_gdtr>
c0100340:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
c0100343:	68 a8 30 13 c0       	push   $0xc01330a8
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
c0100371:	68 bb 40 10 c0       	push   $0xc01040bb
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
c01003fe:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac
	//printk("A\n");
	lcr3(PADDR(pcb->pgdir));
c0100403:	8b 45 08             	mov    0x8(%ebp),%eax
c0100406:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8d 00 00 00       	push   $0x8d
c0100415:	68 bb 40 10 c0       	push   $0xc01040bb
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
c0100448:	b8 36 3d 10 c0       	mov    $0xc0103d36,%eax
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
c0100583:	e8 4f 38 00 00       	call   c0103dd7 <vfprintf>
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
c01005d6:	68 d4 40 10 c0       	push   $0xc01040d4
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
c010060c:	68 f8 40 10 c0       	push   $0xc01040f8
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
c0100629:	ba 00 57 17 c0       	mov    $0xc0175700,%edx
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
c010064e:	68 1c 41 10 c0       	push   $0xc010411c
c0100653:	e8 10 ff ff ff       	call   c0100568 <printk>
c0100658:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c010065b:	8b 45 08             	mov    0x8(%ebp),%eax
c010065e:	c1 e8 0c             	shr    $0xc,%eax
c0100661:	c1 e0 03             	shl    $0x3,%eax
c0100664:	05 00 57 17 c0       	add    $0xc0175700,%eax
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
c0100682:	68 3b 41 10 c0       	push   $0xc010413b
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
c0100719:	c7 45 e8 00 50 13 c0 	movl   $0xc0135000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c0100720:	c7 45 f0 00 60 13 c0 	movl   $0xc0136000,-0x10(%ebp)

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
c010074d:	68 51 41 10 c0       	push   $0xc0104151
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
c010079e:	a3 c0 56 17 c0       	mov    %eax,0xc01756c0
	lcr3(PADDR(kern_pgdir));	
c01007a3:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c01007a8:	83 ec 04             	sub    $0x4,%esp
c01007ab:	50                   	push   %eax
c01007ac:	6a 44                	push   $0x44
c01007ae:	68 51 41 10 c0       	push   $0xc0104151
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
c01007e7:	66 c7 04 c5 04 57 17 	movw   $0x1,-0x3fe8a8fc(,%eax,8)
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
c0100809:	66 c7 04 c5 04 57 17 	movw   $0x0,-0x3fe8a8fc(,%eax,8)
c0100810:	c0 00 00 
		pages[i].pp_link = page_free_list;
c0100813:	8b 15 00 40 13 c0    	mov    0xc0134000,%edx
c0100819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081c:	89 14 c5 00 57 17 c0 	mov    %edx,-0x3fe8a900(,%eax,8)
		page_free_list = &pages[i];
c0100823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100826:	c1 e0 03             	shl    $0x3,%eax
c0100829:	05 00 57 17 c0       	add    $0xc0175700,%eax
c010082e:	a3 00 40 13 c0       	mov    %eax,0xc0134000
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
c0100863:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
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
c0100889:	a1 00 40 13 c0       	mov    0xc0134000,%eax
c010088e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL){
c0100891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100895:	75 17                	jne    c01008ae <page_alloc+0x2b>
		printk("Fatal error: page not available\n");
c0100897:	83 ec 0c             	sub    $0xc,%esp
c010089a:	68 6c 41 10 c0       	push   $0xc010416c
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
c01008d9:	a1 00 40 13 c0       	mov    0xc0134000,%eax
c01008de:	8b 00                	mov    (%eax),%eax
c01008e0:	a3 00 40 13 c0       	mov    %eax,0xc0134000
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
c01008f6:	8b 15 00 40 13 c0    	mov    0xc0134000,%edx
c01008fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01008ff:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c0100901:	8b 45 08             	mov    0x8(%ebp),%eax
c0100904:	a3 00 40 13 c0       	mov    %eax,0xc0134000
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
c010097f:	68 51 41 10 c0       	push   $0xc0104151
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
c01009fb:	68 51 41 10 c0       	push   $0xc0104151
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
c0100b9d:	68 51 41 10 c0       	push   $0xc0104151
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
c0100c27:	68 51 41 10 c0       	push   $0xc0104151
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
c0100cd9:	68 51 41 10 c0       	push   $0xc0104151
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
c0100e15:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
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
c0100e4f:	68 51 41 10 c0       	push   $0xc0104151
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
c0100f53:	e8 ab 21 00 00       	call   c0103103 <ll_pop>
c0100f58:	83 c4 10             	add    $0x10,%esp
c0100f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(pcb == NULL) break;
c0100f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100f62:	75 02                	jne    c0100f66 <sem_close_kr+0x35>
c0100f64:	eb 15                	jmp    c0100f7b <sem_close_kr+0x4a>
			ll_entail(&ready_list, pcb);
c0100f66:	83 ec 08             	sub    $0x8,%esp
c0100f69:	ff 75 f4             	pushl  -0xc(%ebp)
c0100f6c:	68 b0 60 15 c0       	push   $0xc01560b0
c0100f71:	e8 ef 21 00 00       	call   c0103165 <ll_entail>
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
c0100fb1:	e8 4d 21 00 00       	call   c0103103 <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 60 15 c0       	push   $0xc01560b0
c0100fc7:	e8 99 21 00 00       	call   c0103165 <ll_entail>
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
c0100ffb:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0101000:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&sem->block_list, cur);
c0101003:	8b 45 08             	mov    0x8(%ebp),%eax
c0101006:	83 c0 08             	add    $0x8,%eax
c0101009:	83 ec 08             	sub    $0x8,%esp
c010100c:	ff 75 f4             	pushl  -0xc(%ebp)
c010100f:	50                   	push   %eax
c0101010:	e8 50 21 00 00       	call   c0103165 <ll_entail>
c0101015:	83 c4 10             	add    $0x10,%esp
		current = NULL;
c0101018:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
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
c0101090:	05 00 57 1b c0       	add    $0xc01b5700,%eax
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
c01010b1:	a1 04 60 15 c0       	mov    0xc0156004,%eax
c01010b6:	83 c0 01             	add    $0x1,%eax
c01010b9:	a3 04 60 15 c0       	mov    %eax,0xc0156004

	if(current == NULL){
c01010be:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01010c3:	85 c0                	test   %eax,%eax
c01010c5:	75 49                	jne    c0101110 <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c01010c7:	83 ec 0c             	sub    $0xc,%esp
c01010ca:	68 b0 60 15 c0       	push   $0xc01560b0
c01010cf:	e8 2f 20 00 00       	call   c0103103 <ll_pop>
c01010d4:	83 c4 10             	add    $0x10,%esp
c01010d7:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac

		current->ts = RUNNING;
c01010dc:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01010e1:	c7 80 4c 20 00 00 01 	movl   $0x1,0x204c(%eax)
c01010e8:	00 00 00 
		current->timeslice = 0;
c01010eb:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01010f0:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01010f7:	00 00 00 

		scheduler_switch(current);
c01010fa:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01010ff:	83 ec 0c             	sub    $0xc,%esp
c0101102:	50                   	push   %eax
c0101103:	e8 ed f2 ff ff       	call   c01003f5 <scheduler_switch>
c0101108:	83 c4 10             	add    $0x10,%esp
		return;
c010110b:	e9 8c 00 00 00       	jmp    c010119c <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c0101110:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0101115:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c010111b:	83 f8 03             	cmp    $0x3,%eax
c010111e:	75 27                	jne    c0101147 <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c0101120:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0101125:	83 ec 08             	sub    $0x8,%esp
c0101128:	50                   	push   %eax
c0101129:	68 b4 60 15 c0       	push   $0xc01560b4
c010112e:	e8 32 20 00 00       	call   c0103165 <ll_entail>
c0101133:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c0101136:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
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
c0101147:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010114c:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0101152:	83 f8 02             	cmp    $0x2,%eax
c0101155:	77 10                	ja     c0101167 <do_scheduler+0xbc>
c0101157:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010115c:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c0101162:	83 f8 02             	cmp    $0x2,%eax
c0101165:	75 35                	jne    c010119c <do_scheduler+0xf1>

		current->ts = READY;
c0101167:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010116c:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0101173:	00 00 00 

		ll_entail(&ready_list, current);
c0101176:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010117b:	83 ec 08             	sub    $0x8,%esp
c010117e:	50                   	push   %eax
c010117f:	68 b0 60 15 c0       	push   $0xc01560b0
c0101184:	e8 dc 1f 00 00       	call   c0103165 <ll_entail>
c0101189:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c010118c:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
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
c01011a4:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
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
c01011d0:	e8 38 1a 00 00       	call   c0102c0d <do_syscall>
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
c01011e5:	e8 c4 29 00 00       	call   c0103bae <do_timer>
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
c010126f:	e8 bf 18 00 00       	call   c0102b33 <press_key>
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
c01012a1:	66 a3 08 60 15 c0    	mov    %ax,0xc0156008
	data[1] = (uint32_t)addr;
c01012a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01012aa:	66 a3 0a 60 15 c0    	mov    %ax,0xc015600a
	data[2] = ((uint32_t)addr) >> 16;
c01012b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b3:	c1 e8 10             	shr    $0x10,%eax
c01012b6:	66 a3 0c 60 15 c0    	mov    %ax,0xc015600c
	asm volatile("lidt (%0)" : : "r"(data));
c01012bc:	b8 08 60 15 c0       	mov    $0xc0156008,%eax
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
c01013d2:	ba 14 3d 10 c0       	mov    $0xc0103d14,%edx
c01013d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01013da:	c1 e0 03             	shl    $0x3,%eax
c01013dd:	05 40 89 1b c0       	add    $0xc01b8940,%eax
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
c01013fd:	b8 5c 3c 10 c0       	mov    $0xc0103c5c,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 40 89 1b c0       	push   $0xc01b8940
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 65 3c 10 c0       	mov    $0xc0103c65,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 48 89 1b c0       	push   $0xc01b8948
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 6e 3c 10 c0       	mov    $0xc0103c6e,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 50 89 1b c0       	push   $0xc01b8950
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 77 3c 10 c0       	mov    $0xc0103c77,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 58 89 1b c0       	push   $0xc01b8958
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 80 3c 10 c0       	mov    $0xc0103c80,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 60 89 1b c0       	push   $0xc01b8960
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 89 3c 10 c0       	mov    $0xc0103c89,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 68 89 1b c0       	push   $0xc01b8968
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 92 3c 10 c0       	mov    $0xc0103c92,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 70 89 1b c0       	push   $0xc01b8970
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 9b 3c 10 c0       	mov    $0xc0103c9b,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 78 89 1b c0       	push   $0xc01b8978
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 a4 3c 10 c0       	mov    $0xc0103ca4,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 80 89 1b c0       	push   $0xc01b8980
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 ad 3c 10 c0       	mov    $0xc0103cad,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 88 89 1b c0       	push   $0xc01b8988
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 b6 3c 10 c0       	mov    $0xc0103cb6,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 90 89 1b c0       	push   $0xc01b8990
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 bf 3c 10 c0       	mov    $0xc0103cbf,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 98 89 1b c0       	push   $0xc01b8998
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 c8 3c 10 c0       	mov    $0xc0103cc8,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 a0 89 1b c0       	push   $0xc01b89a0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 d1 3c 10 c0       	mov    $0xc0103cd1,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 a8 89 1b c0       	push   $0xc01b89a8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 e3 3c 10 c0       	mov    $0xc0103ce3,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 40 8d 1b c0       	push   $0xc01b8d40
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 f0 3c 10 c0       	mov    $0xc0103cf0,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 40 8a 1b c0       	push   $0xc01b8a40
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 fc 3c 10 c0       	mov    $0xc0103cfc,%eax
c0101572:	6a 00                	push   $0x0
c0101574:	50                   	push   %eax
c0101575:	6a 01                	push   $0x1
c0101577:	68 48 8a 1b c0       	push   $0xc01b8a48
c010157c:	e8 45 fd ff ff       	call   c01012c6 <set_intr>
c0101581:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101584:	68 00 08 00 00       	push   $0x800
c0101589:	68 40 89 1b c0       	push   $0xc01b8940
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
c010160e:	e8 c4 27 00 00       	call   c0103dd7 <vfprintf>
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
		readsect((uint8_t*)bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018af:	c1 e0 09             	shl    $0x9,%eax
c01018b2:	8d 50 01             	lea    0x1(%eax),%edx
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	c1 e0 09             	shl    $0x9,%eax
c01018bb:	05 40 91 1b c0       	add    $0xc01b9140,%eax
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
		readsect((uint8_t*)bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
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
		writesect((uint8_t*)bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	c1 e0 09             	shl    $0x9,%eax
c01018ee:	8d 50 01             	lea    0x1(%eax),%edx
c01018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f4:	c1 e0 09             	shl    $0x9,%eax
c01018f7:	05 40 91 1b c0       	add    $0xc01b9140,%eax
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
		writesect((uint8_t*)bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
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
c0101921:	68 40 bb 21 c0       	push   $0xc021bb40
c0101926:	e8 bd fd ff ff       	call   c01016e8 <readsect>
c010192b:	83 c4 08             	add    $0x8,%esp
}
c010192e:	c9                   	leave  
c010192f:	c3                   	ret    

c0101930 <saveDir>:
void saveDir(int offset){
c0101930:	55                   	push   %ebp
c0101931:	89 e5                	mov    %esp,%ebp
	writesect((uint8_t*)dir.entries, LOC_DIR(offset));
c0101933:	8b 45 08             	mov    0x8(%ebp),%eax
c0101936:	05 01 01 00 00       	add    $0x101,%eax
c010193b:	50                   	push   %eax
c010193c:	68 40 bb 21 c0       	push   $0xc021bb40
c0101941:	e8 7e fe ff ff       	call   c01017c4 <writesect>
c0101946:	83 c4 08             	add    $0x8,%esp
}
c0101949:	c9                   	leave  
c010194a:	c3                   	ret    

c010194b <readINode>:
void readINode(int offset){
c010194b:	55                   	push   %ebp
c010194c:	89 e5                	mov    %esp,%ebp
	readsect((uint8_t*)inode.data_block_offsets, LOC_INODE(offset));
c010194e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101951:	05 01 02 00 00       	add    $0x201,%eax
c0101956:	50                   	push   %eax
c0101957:	68 40 bd 21 c0       	push   $0xc021bd40
c010195c:	e8 87 fd ff ff       	call   c01016e8 <readsect>
c0101961:	83 c4 08             	add    $0x8,%esp
}
c0101964:	c9                   	leave  
c0101965:	c3                   	ret    

c0101966 <saveINode>:
void saveINode(int offset){
c0101966:	55                   	push   %ebp
c0101967:	89 e5                	mov    %esp,%ebp
	writesect((uint8_t*)inode.data_block_offsets, LOC_INODE(offset));
c0101969:	8b 45 08             	mov    0x8(%ebp),%eax
c010196c:	05 01 02 00 00       	add    $0x201,%eax
c0101971:	50                   	push   %eax
c0101972:	68 40 bd 21 c0       	push   $0xc021bd40
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
c010198d:	68 40 b9 21 c0       	push   $0xc021b940
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
c01019a8:	68 40 b9 21 c0       	push   $0xc021b940
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
	int i = 0;
c01019bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_INODE; i++){
c01019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019cb:	eb 69                	jmp    c0101a36 <INodeAlloc+0x7f>
		int sec = LOC_INODE(i);
c01019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d0:	05 01 02 00 00       	add    $0x201,%eax
c01019d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c01019d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019db:	c1 f8 03             	sar    $0x3,%eax
c01019de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c01019e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019e4:	83 e0 07             	and    $0x7,%eax
c01019e7:	ba 01 00 00 00       	mov    $0x1,%edx
c01019ec:	89 c1                	mov    %eax,%ecx
c01019ee:	d3 e2                	shl    %cl,%edx
c01019f0:	89 d0                	mov    %edx,%eax
c01019f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c01019f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f8:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01019fd:	0f b6 00             	movzbl (%eax),%eax
c0101a00:	0f b6 c0             	movzbl %al,%eax
c0101a03:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a06:	85 c0                	test   %eax,%eax
c0101a08:	75 28                	jne    c0101a32 <INodeAlloc+0x7b>
			bitmap.mask[secN] |= secR;
c0101a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a0d:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a12:	0f b6 00             	movzbl (%eax),%eax
c0101a15:	89 c2                	mov    %eax,%edx
c0101a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a1a:	09 d0                	or     %edx,%eax
c0101a1c:	89 c2                	mov    %eax,%edx
c0101a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a21:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a26:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101a28:	e8 ac fe ff ff       	call   c01018d9 <saveBitmap>
			return i;
c0101a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a30:	eb 12                	jmp    c0101a44 <INodeAlloc+0x8d>
void saveData(int offset){
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
c0101a32:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a36:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a3d:	7e 8e                	jle    c01019cd <INodeAlloc+0x16>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101a44:	c9                   	leave  
c0101a45:	c3                   	ret    

c0101a46 <dataAlloc>:
int dataAlloc(){
c0101a46:	55                   	push   %ebp
c0101a47:	89 e5                	mov    %esp,%ebp
c0101a49:	83 ec 10             	sub    $0x10,%esp
	int i = 0;
c0101a4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_DATA; i++){
c0101a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a5a:	eb 69                	jmp    c0101ac5 <dataAlloc+0x7f>
		int sec = LOC_DATA(i);
c0101a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5f:	05 01 03 00 00       	add    $0x301,%eax
c0101a64:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c0101a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a6a:	c1 f8 03             	sar    $0x3,%eax
c0101a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a73:	83 e0 07             	and    $0x7,%eax
c0101a76:	ba 01 00 00 00       	mov    $0x1,%edx
c0101a7b:	89 c1                	mov    %eax,%ecx
c0101a7d:	d3 e2                	shl    %cl,%edx
c0101a7f:	89 d0                	mov    %edx,%eax
c0101a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a87:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a8c:	0f b6 00             	movzbl (%eax),%eax
c0101a8f:	0f b6 c0             	movzbl %al,%eax
c0101a92:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a95:	85 c0                	test   %eax,%eax
c0101a97:	75 28                	jne    c0101ac1 <dataAlloc+0x7b>
			bitmap.mask[secN] |= secR;
c0101a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a9c:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101aa1:	0f b6 00             	movzbl (%eax),%eax
c0101aa4:	89 c2                	mov    %eax,%edx
c0101aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101aa9:	09 d0                	or     %edx,%eax
c0101aab:	89 c2                	mov    %eax,%edx
c0101aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ab0:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101ab5:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101ab7:	e8 1d fe ff ff       	call   c01018d9 <saveBitmap>
			return i;
c0101abc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101abf:	eb 12                	jmp    c0101ad3 <dataAlloc+0x8d>
	}
	return -1;
}
int dataAlloc(){
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
c0101ac1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ac5:	81 7d fc ff 7f 00 00 	cmpl   $0x7fff,-0x4(%ebp)
c0101acc:	7e 8e                	jle    c0101a5c <dataAlloc+0x16>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101ace:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101ad3:	c9                   	leave  
c0101ad4:	c3                   	ret    

c0101ad5 <fs_open_kr>:

FILE_STREAM fs[NR_FILE_STREAM];
int fs_open_kr(char* filename){
c0101ad5:	55                   	push   %ebp
c0101ad6:	89 e5                	mov    %esp,%ebp
c0101ad8:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0101adb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101ae2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0101ae9:	eb 4c                	jmp    c0101b37 <fs_open_kr+0x62>
		readDir(dir_offset);
c0101aeb:	ff 75 fc             	pushl  -0x4(%ebp)
c0101aee:	e8 22 fe ff ff       	call   c0101915 <readDir>
c0101af3:	83 c4 04             	add    $0x4,%esp

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101af6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101afd:	eb 2c                	jmp    c0101b2b <fs_open_kr+0x56>
			//printk("%d %d", dir_offset, entry_offset);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
c0101aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b02:	c1 e0 05             	shl    $0x5,%eax
c0101b05:	05 40 bb 21 c0       	add    $0xc021bb40,%eax
c0101b0a:	ff 75 08             	pushl  0x8(%ebp)
c0101b0d:	50                   	push   %eax
c0101b0e:	e8 3b fb ff ff       	call   c010164e <strcmp>
c0101b13:	83 c4 08             	add    $0x8,%esp
c0101b16:	85 c0                	test   %eax,%eax
c0101b18:	75 0d                	jne    c0101b27 <fs_open_kr+0x52>
				goto OUT_OF_LOOP;
c0101b1a:	90                   	nop
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b22:	e9 fa 00 00 00       	jmp    c0101c21 <fs_open_kr+0x14c>
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b27:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101b2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b2e:	83 f8 0f             	cmp    $0xf,%eax
c0101b31:	76 cc                	jbe    c0101aff <fs_open_kr+0x2a>
			//printk("%d %d", dir_offset, entry_offset);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
c0101b33:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

FILE_STREAM fs[NR_FILE_STREAM];
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0101b37:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101b3e:	7e ab                	jle    c0101aeb <fs_open_kr+0x16>
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
c0101b40:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0101b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101b46:	e9 e8 00 00 00       	jmp    c0101c33 <fs_open_kr+0x15e>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b4e:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101b54:	05 20 04 00 00       	add    $0x420,%eax
c0101b59:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b5e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0101b62:	84 c0                	test   %al,%al
c0101b64:	0f 85 b3 00 00 00    	jne    c0101c1d <fs_open_kr+0x148>
			fs[i].used = 1;
c0101b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b6d:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101b73:	05 20 04 00 00       	add    $0x420,%eax
c0101b78:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b7d:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101b81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b84:	c1 e0 05             	shl    $0x5,%eax
c0101b87:	83 c0 10             	add    $0x10,%eax
c0101b8a:	05 40 bb 21 c0       	add    $0xc021bb40,%eax
c0101b8f:	8b 40 08             	mov    0x8(%eax),%eax
c0101b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b95:	69 d2 28 04 00 00    	imul   $0x428,%edx,%edx
c0101b9b:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101ba1:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101ba7:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bad:	c1 e0 05             	shl    $0x5,%eax
c0101bb0:	8d 90 40 bb 21 c0    	lea    -0x3fde44c0(%eax),%edx
c0101bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb9:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101bbf:	05 00 02 00 00       	add    $0x200,%eax
c0101bc4:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101bc9:	83 c0 0c             	add    $0xc,%eax
c0101bcc:	52                   	push   %edx
c0101bcd:	50                   	push   %eax
c0101bce:	e8 ba fa ff ff       	call   c010168d <strcpy>
c0101bd3:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bd9:	c1 e0 05             	shl    $0x5,%eax
c0101bdc:	83 c0 10             	add    $0x10,%eax
c0101bdf:	05 40 bb 21 c0       	add    $0xc021bb40,%eax
c0101be4:	8b 40 0c             	mov    0xc(%eax),%eax
c0101be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bea:	69 d2 28 04 00 00    	imul   $0x428,%edx,%edx
c0101bf0:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101bf6:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101bfc:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c02:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101c08:	05 00 02 00 00       	add    $0x200,%eax
c0101c0d:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c1b:	eb 16                	jmp    c0101c33 <fs_open_kr+0x15e>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101c1d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c21:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0101c28:	0f 8e 1d ff ff ff    	jle    c0101b4b <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101c33:	c9                   	leave  
c0101c34:	c3                   	ret    

c0101c35 <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101c35:	55                   	push   %ebp
c0101c36:	89 e5                	mov    %esp,%ebp
c0101c38:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101c44:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c4f:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101c55:	50                   	push   %eax
c0101c56:	e8 f0 fc ff ff       	call   c010194b <readINode>
c0101c5b:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c68:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c6e:	c1 e8 09             	shr    $0x9,%eax
c0101c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101c74:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c77:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c7d:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101c85:	8b 55 10             	mov    0x10(%ebp),%edx
c0101c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c8b:	01 d0                	add    %edx,%eax
c0101c8d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c92:	0f 86 24 01 00 00    	jbe    c0101dbc <fs_read_base_kr+0x187>
		readData(inode.data_block_offsets[D]);
c0101c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c9b:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101ca2:	50                   	push   %eax
c0101ca3:	e8 d9 fc ff ff       	call   c0101981 <readData>
c0101ca8:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101cab:	b8 00 02 00 00       	mov    $0x200,%eax
c0101cb0:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cb3:	89 c2                	mov    %eax,%edx
c0101cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb8:	05 40 b9 21 c0       	add    $0xc021b940,%eax
c0101cbd:	52                   	push   %edx
c0101cbe:	50                   	push   %eax
c0101cbf:	ff 75 0c             	pushl  0xc(%ebp)
c0101cc2:	e8 51 f9 ff ff       	call   c0101618 <memcpy2>
c0101cc7:	83 c4 0c             	add    $0xc,%esp
		fs->offset += BLOCK_SIZE-R;
c0101cca:	a1 40 93 1d c0       	mov    0xc01d9340,%eax
c0101ccf:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cd2:	05 00 02 00 00       	add    $0x200,%eax
c0101cd7:	a3 40 93 1d c0       	mov    %eax,0xc01d9340
		offset += BLOCK_SIZE-R;
c0101cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101cdf:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101ce2:	05 00 02 00 00       	add    $0x200,%eax
c0101ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101cea:	8b 55 10             	mov    0x10(%ebp),%edx
c0101ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cf0:	01 d0                	add    %edx,%eax
c0101cf2:	2d 00 02 00 00       	sub    $0x200,%eax
c0101cf7:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101cfa:	eb 63                	jmp    c0101d5f <fs_read_base_kr+0x12a>
			D = f->offset >> 9;
c0101cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cff:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d05:	c1 e8 09             	shr    $0x9,%eax
c0101d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
			readData(inode.data_block_offsets[D]);
c0101d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d0e:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101d15:	50                   	push   %eax
c0101d16:	e8 66 fc ff ff       	call   c0101981 <readData>
c0101d1b:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d24:	01 d0                	add    %edx,%eax
c0101d26:	68 00 02 00 00       	push   $0x200
c0101d2b:	68 40 b9 21 c0       	push   $0xc021b940
c0101d30:	50                   	push   %eax
c0101d31:	e8 e2 f8 ff ff       	call   c0101618 <memcpy2>
c0101d36:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101d39:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101d40:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d43:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d49:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d52:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101d58:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		fs->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d5f:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101d66:	7f 94                	jg     c0101cfc <fs_read_base_kr+0xc7>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d6b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d71:	c1 e8 09             	shr    $0x9,%eax
c0101d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d7a:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101d81:	50                   	push   %eax
c0101d82:	e8 fa fb ff ff       	call   c0101981 <readData>
c0101d87:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d90:	01 d0                	add    %edx,%eax
c0101d92:	ff 75 10             	pushl  0x10(%ebp)
c0101d95:	68 40 b9 21 c0       	push   $0xc021b940
c0101d9a:	50                   	push   %eax
c0101d9b:	e8 78 f8 ff ff       	call   c0101618 <memcpy2>
c0101da0:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101da6:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101dac:	8b 45 10             	mov    0x10(%ebp),%eax
c0101daf:	01 c2                	add    %eax,%edx
c0101db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101db4:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101dba:	eb 3a                	jmp    c0101df6 <fs_read_base_kr+0x1c1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dbf:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101dc6:	50                   	push   %eax
c0101dc7:	e8 b5 fb ff ff       	call   c0101981 <readData>
c0101dcc:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101dd2:	05 40 b9 21 c0       	add    $0xc021b940,%eax
c0101dd7:	ff 75 10             	pushl  0x10(%ebp)
c0101dda:	50                   	push   %eax
c0101ddb:	ff 75 0c             	pushl  0xc(%ebp)
c0101dde:	e8 35 f8 ff ff       	call   c0101618 <memcpy2>
c0101de3:	83 c4 0c             	add    $0xc,%esp
		fs->offset += len;
c0101de6:	8b 15 40 93 1d c0    	mov    0xc01d9340,%edx
c0101dec:	8b 45 10             	mov    0x10(%ebp),%eax
c0101def:	01 d0                	add    %edx,%eax
c0101df1:	a3 40 93 1d c0       	mov    %eax,0xc01d9340
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101df6:	c9                   	leave  
c0101df7:	c3                   	ret    

c0101df8 <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101df8:	55                   	push   %ebp
c0101df9:	89 e5                	mov    %esp,%ebp
c0101dfb:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e01:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101e07:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e12:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e18:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e1b:	01 c2                	add    %eax,%edx
c0101e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e20:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101e26:	39 c2                	cmp    %eax,%edx
c0101e28:	72 19                	jb     c0101e43 <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e2d:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e36:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e3c:	29 c2                	sub    %eax,%edx
c0101e3e:	89 d0                	mov    %edx,%eax
c0101e40:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	fs_read_base_kr(fd, buf, len);
c0101e43:	ff 75 10             	pushl  0x10(%ebp)
c0101e46:	ff 75 0c             	pushl  0xc(%ebp)
c0101e49:	ff 75 08             	pushl  0x8(%ebp)
c0101e4c:	e8 e4 fd ff ff       	call   c0101c35 <fs_read_base_kr>
c0101e51:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101e54:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101e57:	c9                   	leave  
c0101e58:	c3                   	ret    

c0101e59 <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101e59:	55                   	push   %ebp
c0101e5a:	89 e5                	mov    %esp,%ebp
c0101e5c:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e62:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0101e68:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101e70:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e73:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101e79:	50                   	push   %eax
c0101e7a:	e8 cc fa ff ff       	call   c010194b <readINode>
c0101e7f:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101e82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101e89:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e8c:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e92:	c1 e8 09             	shr    $0x9,%eax
c0101e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e9b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ea1:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101ea9:	8b 55 10             	mov    0x10(%ebp),%edx
c0101eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101eaf:	01 d0                	add    %edx,%eax
c0101eb1:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101eb6:	0f 86 4a 01 00 00    	jbe    c0102006 <fs_write_base_kr+0x1ad>
		readData(inode.data_block_offsets[D]);
c0101ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ebf:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101ec6:	50                   	push   %eax
c0101ec7:	e8 b5 fa ff ff       	call   c0101981 <readData>
c0101ecc:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101ecf:	b8 00 02 00 00       	mov    $0x200,%eax
c0101ed4:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101ed7:	89 c2                	mov    %eax,%edx
c0101ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101edc:	05 40 b9 21 c0       	add    $0xc021b940,%eax
c0101ee1:	52                   	push   %edx
c0101ee2:	ff 75 0c             	pushl  0xc(%ebp)
c0101ee5:	50                   	push   %eax
c0101ee6:	e8 2d f7 ff ff       	call   c0101618 <memcpy2>
c0101eeb:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ef1:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101ef8:	50                   	push   %eax
c0101ef9:	e8 9e fa ff ff       	call   c010199c <saveData>
c0101efe:	83 c4 04             	add    $0x4,%esp
		fs->offset += BLOCK_SIZE-R;
c0101f01:	a1 40 93 1d c0       	mov    0xc01d9340,%eax
c0101f06:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f09:	05 00 02 00 00       	add    $0x200,%eax
c0101f0e:	a3 40 93 1d c0       	mov    %eax,0xc01d9340
		offset += BLOCK_SIZE-R;
c0101f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f16:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f19:	05 00 02 00 00       	add    $0x200,%eax
c0101f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101f21:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f27:	01 d0                	add    %edx,%eax
c0101f29:	2d 00 02 00 00       	sub    $0x200,%eax
c0101f2e:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f31:	eb 63                	jmp    c0101f96 <fs_write_base_kr+0x13d>
			D = f->offset >> 9;
c0101f33:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f36:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f3c:	c1 e8 09             	shr    $0x9,%eax
c0101f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101f42:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f48:	01 d0                	add    %edx,%eax
c0101f4a:	68 00 02 00 00       	push   $0x200
c0101f4f:	50                   	push   %eax
c0101f50:	68 40 b9 21 c0       	push   $0xc021b940
c0101f55:	e8 be f6 ff ff       	call   c0101618 <memcpy2>
c0101f5a:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f60:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101f67:	50                   	push   %eax
c0101f68:	e8 2f fa ff ff       	call   c010199c <saveData>
c0101f6d:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c0101f70:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f7a:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f80:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f89:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101f8f:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		fs->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f96:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101f9d:	7f 94                	jg     c0101f33 <fs_write_base_kr+0xda>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fa2:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101fa8:	c1 e8 09             	shr    $0x9,%eax
c0101fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fb1:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101fb8:	50                   	push   %eax
c0101fb9:	e8 c3 f9 ff ff       	call   c0101981 <readData>
c0101fbe:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c0101fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101fc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fc7:	01 d0                	add    %edx,%eax
c0101fc9:	ff 75 10             	pushl  0x10(%ebp)
c0101fcc:	50                   	push   %eax
c0101fcd:	68 40 b9 21 c0       	push   $0xc021b940
c0101fd2:	e8 41 f6 ff ff       	call   c0101618 <memcpy2>
c0101fd7:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fdd:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0101fe4:	50                   	push   %eax
c0101fe5:	e8 b2 f9 ff ff       	call   c010199c <saveData>
c0101fea:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0101fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ff0:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101ff6:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ff9:	01 c2                	add    %eax,%edx
c0101ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ffe:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0102004:	eb 4d                	jmp    c0102053 <fs_write_base_kr+0x1fa>
	}else{
		readData(inode.data_block_offsets[D]);
c0102006:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102009:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c0102010:	50                   	push   %eax
c0102011:	e8 6b f9 ff ff       	call   c0101981 <readData>
c0102016:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c0102019:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010201c:	05 40 b9 21 c0       	add    $0xc021b940,%eax
c0102021:	ff 75 10             	pushl  0x10(%ebp)
c0102024:	ff 75 0c             	pushl  0xc(%ebp)
c0102027:	50                   	push   %eax
c0102028:	e8 eb f5 ff ff       	call   c0101618 <memcpy2>
c010202d:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102030:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102033:	8b 04 85 40 bd 21 c0 	mov    -0x3fde42c0(,%eax,4),%eax
c010203a:	50                   	push   %eax
c010203b:	e8 5c f9 ff ff       	call   c010199c <saveData>
c0102040:	83 c4 04             	add    $0x4,%esp
		fs->offset += len;
c0102043:	8b 15 40 93 1d c0    	mov    0xc01d9340,%edx
c0102049:	8b 45 10             	mov    0x10(%ebp),%eax
c010204c:	01 d0                	add    %edx,%eax
c010204e:	a3 40 93 1d c0       	mov    %eax,0xc01d9340
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0102053:	c9                   	leave  
c0102054:	c3                   	ret    

c0102055 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c0102055:	55                   	push   %ebp
c0102056:	89 e5                	mov    %esp,%ebp
c0102058:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c010205b:	8b 45 08             	mov    0x8(%ebp),%eax
c010205e:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0102064:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102069:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	readINode(f->inode_offset);
c010206c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010206f:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102075:	50                   	push   %eax
c0102076:	e8 d0 f8 ff ff       	call   c010194b <readINode>
c010207b:	83 c4 04             	add    $0x4,%esp
	D1 = f->offset >> 9;
c010207e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102081:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0102087:	c1 e8 09             	shr    $0x9,%eax
c010208a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	D2 = (f->offset + len) >> 9;
c010208d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102090:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102096:	8b 45 10             	mov    0x10(%ebp),%eax
c0102099:	01 d0                	add    %edx,%eax
c010209b:	c1 e8 09             	shr    $0x9,%eax
c010209e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	D1 += 1;
c01020a1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	while(D1<=D2){
c01020a5:	eb 15                	jmp    c01020bc <fs_write_kr+0x67>
		inode.data_block_offsets[D1] = dataAlloc();
c01020a7:	e8 9a f9 ff ff       	call   c0101a46 <dataAlloc>
c01020ac:	89 c2                	mov    %eax,%edx
c01020ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020b1:	89 14 85 40 bd 21 c0 	mov    %edx,-0x3fde42c0(,%eax,4)
		D1 ++;
c01020b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	int32_t D1, D2;
	readINode(f->inode_offset);
	D1 = f->offset >> 9;
	D2 = (f->offset + len) >> 9;
	D1 += 1;
	while(D1<=D2){
c01020bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01020c2:	7e e3                	jle    c01020a7 <fs_write_kr+0x52>
		inode.data_block_offsets[D1] = dataAlloc();
		D1 ++;
	}
	saveINode(f->inode_offset);
c01020c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020c7:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020cd:	50                   	push   %eax
c01020ce:	e8 93 f8 ff ff       	call   c0101966 <saveINode>
c01020d3:	83 c4 04             	add    $0x4,%esp
	if(f->offset + len> f->file_size)
c01020d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020d9:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020df:	8b 45 10             	mov    0x10(%ebp),%eax
c01020e2:	01 c2                	add    %eax,%edx
c01020e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020e7:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01020ed:	39 c2                	cmp    %eax,%edx
c01020ef:	76 17                	jbe    c0102108 <fs_write_kr+0xb3>
		f->file_size = f->offset + len;
c01020f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020f4:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01020fd:	01 c2                	add    %eax,%edx
c01020ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102102:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	fs_write_base_kr(fd, buf, len);
c0102108:	ff 75 10             	pushl  0x10(%ebp)
c010210b:	ff 75 0c             	pushl  0xc(%ebp)
c010210e:	ff 75 08             	pushl  0x8(%ebp)
c0102111:	e8 43 fd ff ff       	call   c0101e59 <fs_write_base_kr>
c0102116:	83 c4 0c             	add    $0xc,%esp
	return len;
c0102119:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c010211c:	c9                   	leave  
c010211d:	c3                   	ret    

c010211e <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c010211e:	55                   	push   %ebp
c010211f:	89 e5                	mov    %esp,%ebp
c0102121:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102124:	8b 45 08             	mov    0x8(%ebp),%eax
c0102127:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c010212d:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102132:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c0102135:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102138:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213b:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c0102141:	c9                   	leave  
c0102142:	c3                   	ret    

c0102143 <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c0102143:	55                   	push   %ebp
c0102144:	89 e5                	mov    %esp,%ebp
c0102146:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102149:	8b 45 08             	mov    0x8(%ebp),%eax
c010214c:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c0102152:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102157:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c010215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215d:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
}
c0102163:	c9                   	leave  
c0102164:	c3                   	ret    

c0102165 <init_fs>:
void init_fs(){
c0102165:	55                   	push   %ebp
c0102166:	89 e5                	mov    %esp,%ebp
c0102168:	81 ec 28 08 00 00    	sub    $0x828,%esp
	readBitmap();
c010216e:	e8 2a f7 ff ff       	call   c010189d <readBitmap>
	//readDir(0);
	int i=0;
c0102173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c010217a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102181:	eb 1b                	jmp    c010219e <init_fs+0x39>
		fs[i].used = 0;
c0102183:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102186:	69 c0 28 04 00 00    	imul   $0x428,%eax,%eax
c010218c:	05 20 04 00 00       	add    $0x420,%eax
c0102191:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102196:	c6 40 04 00          	movb   $0x0,0x4(%eax)
}
void init_fs(){
	readBitmap();
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c010219a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010219e:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c01021a5:	7e dc                	jle    c0102183 <init_fs+0x1e>
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
c01021a7:	68 8d 41 10 c0       	push   $0xc010418d
c01021ac:	e8 24 f9 ff ff       	call   c0101ad5 <fs_open_kr>
c01021b1:	83 c4 04             	add    $0x4,%esp
c01021b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char woc[1024];
	fs_read_kr(fd, woc, 1024);
c01021b7:	68 00 04 00 00       	push   $0x400
c01021bc:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
c01021c2:	50                   	push   %eax
c01021c3:	ff 75 f0             	pushl  -0x10(%ebp)
c01021c6:	e8 2d fc ff ff       	call   c0101df8 <fs_read_kr>
c01021cb:	83 c4 0c             	add    $0xc,%esp
	printk("%s\n", woc);
c01021ce:	83 ec 08             	sub    $0x8,%esp
c01021d1:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
c01021d7:	50                   	push   %eax
c01021d8:	68 96 41 10 c0       	push   $0xc0104196
c01021dd:	e8 11 f4 ff ff       	call   c01015f3 <printk>
c01021e2:	83 c4 10             	add    $0x10,%esp
	char buf[1024];
	fs_lseek_kr(fd, 0);
c01021e5:	83 ec 08             	sub    $0x8,%esp
c01021e8:	6a 00                	push   $0x0
c01021ea:	ff 75 f0             	pushl  -0x10(%ebp)
c01021ed:	e8 2c ff ff ff       	call   c010211e <fs_lseek_kr>
c01021f2:	83 c4 10             	add    $0x10,%esp
	//for(i=0; i<2000; i+=6){
	memset2(buf, 0x4F, 1024);
c01021f5:	83 ec 04             	sub    $0x4,%esp
c01021f8:	68 00 04 00 00       	push   $0x400
c01021fd:	6a 4f                	push   $0x4f
c01021ff:	8d 85 f0 f7 ff ff    	lea    -0x810(%ebp),%eax
c0102205:	50                   	push   %eax
c0102206:	e8 2a f4 ff ff       	call   c0101635 <memset2>
c010220b:	83 c4 10             	add    $0x10,%esp
	fs_write_kr(fd, buf, 1024);
c010220e:	83 ec 04             	sub    $0x4,%esp
c0102211:	68 00 04 00 00       	push   $0x400
c0102216:	8d 85 f0 f7 ff ff    	lea    -0x810(%ebp),%eax
c010221c:	50                   	push   %eax
c010221d:	ff 75 f0             	pushl  -0x10(%ebp)
c0102220:	e8 30 fe ff ff       	call   c0102055 <fs_write_kr>
c0102225:	83 c4 10             	add    $0x10,%esp
	fs_lseek_kr(fd, 1010);
c0102228:	83 ec 08             	sub    $0x8,%esp
c010222b:	68 f2 03 00 00       	push   $0x3f2
c0102230:	ff 75 f0             	pushl  -0x10(%ebp)
c0102233:	e8 e6 fe ff ff       	call   c010211e <fs_lseek_kr>
c0102238:	83 c4 10             	add    $0x10,%esp
	char fsc[20];
	fs_read_kr(fd, fsc, 10);
c010223b:	83 ec 04             	sub    $0x4,%esp
c010223e:	6a 0a                	push   $0xa
c0102240:	8d 85 dc f7 ff ff    	lea    -0x824(%ebp),%eax
c0102246:	50                   	push   %eax
c0102247:	ff 75 f0             	pushl  -0x10(%ebp)
c010224a:	e8 a9 fb ff ff       	call   c0101df8 <fs_read_kr>
c010224f:	83 c4 10             	add    $0x10,%esp
	printk("%s\n", fsc);
c0102252:	83 ec 08             	sub    $0x8,%esp
c0102255:	8d 85 dc f7 ff ff    	lea    -0x824(%ebp),%eax
c010225b:	50                   	push   %eax
c010225c:	68 96 41 10 c0       	push   $0xc0104196
c0102261:	e8 8d f3 ff ff       	call   c01015f3 <printk>
c0102266:	83 c4 10             	add    $0x10,%esp
	/*for(i=0; i<NR_ENTRIES; i++){
		printk("%x\n", dir.entries[i].file_size);
		printk("%x\n", dir.entries[i].inode_offset);
		printk("%s\n", dir.entries[i].filename);
	}*/
c0102269:	c9                   	leave  
c010226a:	c3                   	ret    

c010226b <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
c010226b:	55                   	push   %ebp
c010226c:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c010226e:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0102273:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c0102275:	b8 df 05 00 00       	mov    $0x5df,%eax
c010227a:	cd 80                	int    $0x80
}
c010227c:	5d                   	pop    %ebp
c010227d:	c3                   	ret    

c010227e <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c010227e:	55                   	push   %ebp
c010227f:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c0102281:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0102286:	cd 80                	int    $0x80
}
c0102288:	5d                   	pop    %ebp
c0102289:	c3                   	ret    

c010228a <sys_fork>:
static inline uint32_t sys_fork(){
c010228a:	55                   	push   %ebp
c010228b:	89 e5                	mov    %esp,%ebp
c010228d:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c0102297:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c010229c:	cd 80                	int    $0x80
c010229e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c01022a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01022a4:	c9                   	leave  
c01022a5:	c3                   	ret    

c01022a6 <sys_pid>:
static inline uint32_t sys_pid(){
c01022a6:	55                   	push   %ebp
c01022a7:	89 e5                	mov    %esp,%ebp
c01022a9:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01022ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c01022b3:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c01022b8:	cd 80                	int    $0x80
c01022ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c01022bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01022c0:	c9                   	leave  
c01022c1:	c3                   	ret    

c01022c2 <sys_ppid>:
static inline uint32_t sys_ppid(){
c01022c2:	55                   	push   %ebp
c01022c3:	89 e5                	mov    %esp,%ebp
c01022c5:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01022c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c01022cf:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c01022d4:	cd 80                	int    $0x80
c01022d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c01022d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01022dc:	c9                   	leave  
c01022dd:	c3                   	ret    

c01022de <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c01022de:	55                   	push   %ebp
c01022df:	89 e5                	mov    %esp,%ebp
c01022e1:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c01022e2:	b8 de 05 00 00       	mov    $0x5de,%eax
c01022e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01022ea:	89 d3                	mov    %edx,%ebx
c01022ec:	cd 80                	int    $0x80
}
c01022ee:	5b                   	pop    %ebx
c01022ef:	5d                   	pop    %ebp
c01022f0:	c3                   	ret    

c01022f1 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c01022f1:	55                   	push   %ebp
c01022f2:	89 e5                	mov    %esp,%ebp
c01022f4:	83 ec 40             	sub    $0x40,%esp
c01022f7:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c01022fe:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102302:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102306:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102309:	ee                   	out    %al,(%dx)
c010230a:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0102311:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0102315:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102319:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010231c:	ee                   	out    %al,(%dx)
c010231d:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0102324:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0102328:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010232c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010232f:	ee                   	out    %al,(%dx)
c0102330:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0102337:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c010233b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010233f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102342:	ee                   	out    %al,(%dx)
c0102343:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c010234a:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010234e:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102352:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102355:	ee                   	out    %al,(%dx)
c0102356:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c010235d:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0102361:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102365:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102368:	ee                   	out    %al,(%dx)
c0102369:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0102370:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0102374:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102378:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010237b:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c010237c:	c9                   	leave  
c010237d:	c3                   	ret    

c010237e <serial_idle>:

static inline
int serial_idle(void) {
c010237e:	55                   	push   %ebp
c010237f:	89 e5                	mov    %esp,%ebp
c0102381:	83 ec 10             	sub    $0x10,%esp
c0102384:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010238b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010238e:	89 c2                	mov    %eax,%edx
c0102390:	ec                   	in     (%dx),%al
c0102391:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102394:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102398:	0f b6 c0             	movzbl %al,%eax
c010239b:	83 e0 20             	and    $0x20,%eax
c010239e:	85 c0                	test   %eax,%eax
c01023a0:	0f 95 c0             	setne  %al
c01023a3:	0f b6 c0             	movzbl %al,%eax
}
c01023a6:	c9                   	leave  
c01023a7:	c3                   	ret    

c01023a8 <serial_printc>:

static inline
void serial_printc(char ch) {
c01023a8:	55                   	push   %ebp
c01023a9:	89 e5                	mov    %esp,%ebp
c01023ab:	83 ec 14             	sub    $0x14,%esp
c01023ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b1:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01023b4:	90                   	nop
c01023b5:	e8 c4 ff ff ff       	call   c010237e <serial_idle>
c01023ba:	85 c0                	test   %eax,%eax
c01023bc:	74 f7                	je     c01023b5 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01023be:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01023c2:	0f b6 c0             	movzbl %al,%eax
c01023c5:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01023cc:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01023cf:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01023d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023d6:	ee                   	out    %al,(%dx)
}
c01023d7:	c9                   	leave  
c01023d8:	c3                   	ret    

c01023d9 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01023d9:	55                   	push   %ebp
c01023da:	89 e5                	mov    %esp,%ebp
c01023dc:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01023df:	8d 45 0c             	lea    0xc(%ebp),%eax
c01023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01023e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e8:	83 ec 04             	sub    $0x4,%esp
c01023eb:	ff 75 f4             	pushl  -0xc(%ebp)
c01023ee:	50                   	push   %eax
c01023ef:	68 a8 23 10 c0       	push   $0xc01023a8
c01023f4:	e8 de 19 00 00       	call   c0103dd7 <vfprintf>
c01023f9:	83 c4 10             	add    $0x10,%esp
}
c01023fc:	c9                   	leave  
c01023fd:	c3                   	ret    

c01023fe <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c01023fe:	55                   	push   %ebp
c01023ff:	89 e5                	mov    %esp,%ebp
c0102401:	83 ec 70             	sub    $0x70,%esp
c0102404:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c010240b:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c010240f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102413:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102416:	ee                   	out    %al,(%dx)
c0102417:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c010241e:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c0102422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102426:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102429:	ee                   	out    %al,(%dx)
c010242a:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c0102431:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c0102435:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102439:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010243c:	ee                   	out    %al,(%dx)
c010243d:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0102444:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0102448:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010244c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010244f:	ee                   	out    %al,(%dx)
c0102450:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0102457:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c010245b:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010245f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102462:	ee                   	out    %al,(%dx)
c0102463:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010246a:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010246e:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102472:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102475:	ee                   	out    %al,(%dx)
c0102476:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c010247d:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0102481:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102485:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102488:	ee                   	out    %al,(%dx)
c0102489:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0102490:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0102494:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0102498:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010249b:	ee                   	out    %al,(%dx)
c010249c:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01024a3:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01024a7:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01024ab:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01024ae:	ee                   	out    %al,(%dx)
c01024af:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01024b6:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c01024ba:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c01024be:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01024c1:	ee                   	out    %al,(%dx)
c01024c2:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c01024c9:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c01024cd:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c01024d1:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01024d4:	ee                   	out    %al,(%dx)
c01024d5:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c01024dc:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01024e0:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c01024e4:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01024e7:	ee                   	out    %al,(%dx)
c01024e8:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c01024ef:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c01024f3:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c01024f7:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01024fa:	ee                   	out    %al,(%dx)
c01024fb:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c0102502:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0102506:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c010250a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010250d:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c010250e:	c9                   	leave  
c010250f:	c3                   	ret    

c0102510 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0102510:	55                   	push   %ebp
c0102511:	89 e5                	mov    %esp,%ebp
c0102513:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0102516:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c010251d:	0f b6 05 00 80 10 c0 	movzbl 0xc0108000,%eax
c0102524:	0f b6 c0             	movzbl %al,%eax
c0102527:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c010252e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0102531:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102535:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102538:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0102539:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010253c:	0f b6 c0             	movzbl %al,%eax
c010253f:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c0102546:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102549:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010254d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102550:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c0102551:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102554:	c1 f8 08             	sar    $0x8,%eax
c0102557:	0f b6 c0             	movzbl %al,%eax
c010255a:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0102561:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102564:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102568:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010256b:	ee                   	out    %al,(%dx)
}
c010256c:	c9                   	leave  
c010256d:	c3                   	ret    

c010256e <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010256e:	55                   	push   %ebp
c010256f:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c0102571:	e8 08 fd ff ff       	call   c010227e <sys_handout>
  }
c0102576:	eb f9                	jmp    c0102571 <idle+0x3>

c0102578 <busy>:
}
void busy(){
c0102578:	55                   	push   %ebp
c0102579:	89 e5                	mov    %esp,%ebp
c010257b:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c010257e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c0102585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c010258c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102593:	eb 11                	jmp    c01025a6 <busy+0x2e>
    if(fork()!=0){
c0102595:	e8 f0 fc ff ff       	call   c010228a <sys_fork>
c010259a:	85 c0                	test   %eax,%eax
c010259c:	74 04                	je     c01025a2 <busy+0x2a>
        j++;
c010259e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c01025a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01025a6:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c01025aa:	76 e9                	jbe    c0102595 <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c01025ac:	e8 f5 fc ff ff       	call   c01022a6 <sys_pid>
c01025b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c01025b4:	e8 09 fd ff ff       	call   c01022c2 <sys_ppid>
c01025b9:	ff 75 f0             	pushl  -0x10(%ebp)
c01025bc:	50                   	push   %eax
c01025bd:	ff 75 e8             	pushl  -0x18(%ebp)
c01025c0:	68 9c 41 10 c0       	push   $0xc010419c
c01025c5:	e8 a7 1a 00 00       	call   c0104071 <printf>
c01025ca:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c01025cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c01025d4:	e8 a5 fc ff ff       	call   c010227e <sys_handout>
    sleep(pid);
c01025d9:	83 ec 0c             	sub    $0xc,%esp
c01025dc:	ff 75 e8             	pushl  -0x18(%ebp)
c01025df:	e8 fa fc ff ff       	call   c01022de <sys_sleep>
c01025e4:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c01025e7:	ff 75 ec             	pushl  -0x14(%ebp)
c01025ea:	ff 75 e8             	pushl  -0x18(%ebp)
c01025ed:	ff 75 e8             	pushl  -0x18(%ebp)
c01025f0:	68 dc 41 10 c0       	push   $0xc01041dc
c01025f5:	e8 77 1a 00 00       	call   c0104071 <printf>
c01025fa:	83 c4 10             	add    $0x10,%esp
    times++;
c01025fd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c0102601:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0102605:	76 15                	jbe    c010261c <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0102607:	83 ec 0c             	sub    $0xc,%esp
c010260a:	68 00 42 10 c0       	push   $0xc0104200
c010260f:	e8 5d 1a 00 00       	call   c0104071 <printf>
c0102614:	83 c4 10             	add    $0x10,%esp
      exit();
c0102617:	e8 4f fc ff ff       	call   c010226b <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c010261c:	eb b6                	jmp    c01025d4 <busy+0x5c>

c010261e <main>:
}
void do_scheduler();
int main(){
c010261e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0102622:	83 e4 f0             	and    $0xfffffff0,%esp
c0102625:	ff 71 fc             	pushl  -0x4(%ecx)
c0102628:	55                   	push   %ebp
c0102629:	89 e5                	mov    %esp,%ebp
c010262b:	51                   	push   %ecx
c010262c:	83 ec 14             	sub    $0x14,%esp
  init_page();
c010262f:	e8 f7 da ff ff       	call   c010012b <init_page>
  init_segment();
c0102634:	e8 a3 dc ff ff       	call   c01002dc <init_segment>
	init_serial();
c0102639:	e8 b3 fc ff ff       	call   c01022f1 <init_serial>
	init_timer();
c010263e:	e8 cd fe ff ff       	call   c0102510 <init_timer>
	init_idt();
c0102643:	e8 7b ed ff ff       	call   c01013c3 <init_idt>
	init_intr();
c0102648:	e8 b1 fd ff ff       	call   c01023fe <init_intr>
  init_fs();
c010264d:	e8 13 fb ff ff       	call   c0102165 <init_fs>
  init_pcb_pool();
c0102652:	e8 e9 0b 00 00       	call   c0103240 <init_pcb_pool>
  printk("This is kernel!\n");
c0102657:	83 ec 0c             	sub    $0xc,%esp
c010265a:	68 1e 42 10 c0       	push   $0xc010421e
c010265f:	e8 75 fd ff ff       	call   c01023d9 <printk>
c0102664:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c0102667:	e8 3f 0d 00 00       	call   c01033ab <pcb_create>
c010266c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c010266f:	83 ec 08             	sub    $0x8,%esp
c0102672:	68 6e 25 10 c0       	push   $0xc010256e
c0102677:	ff 75 f4             	pushl  -0xc(%ebp)
c010267a:	e8 15 04 00 00       	call   c0102a94 <empty_loader>
c010267f:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c0102682:	e8 24 0d 00 00       	call   c01033ab <pcb_create>
c0102687:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c010268a:	83 ec 08             	sub    $0x8,%esp
c010268d:	68 00 90 01 00       	push   $0x19000
c0102692:	ff 75 f0             	pushl  -0x10(%ebp)
c0102695:	e8 62 02 00 00       	call   c01028fc <loader>
c010269a:	83 c4 10             	add    $0x10,%esp

  enready_pcb(pidle);
c010269d:	83 ec 0c             	sub    $0xc,%esp
c01026a0:	ff 75 f4             	pushl  -0xc(%ebp)
c01026a3:	e8 03 0e 00 00       	call   c01034ab <enready_pcb>
c01026a8:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c01026ab:	83 ec 0c             	sub    $0xc,%esp
c01026ae:	ff 75 f0             	pushl  -0x10(%ebp)
c01026b1:	e8 f5 0d 00 00       	call   c01034ab <enready_pcb>
c01026b6:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c01026b9:	e8 ed 0c 00 00       	call   c01033ab <pcb_create>
c01026be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(app, 2*102400);
c01026c1:	83 ec 08             	sub    $0x8,%esp
c01026c4:	68 00 20 03 00       	push   $0x32000
c01026c9:	ff 75 ec             	pushl  -0x14(%ebp)
c01026cc:	e8 2b 02 00 00       	call   c01028fc <loader>
c01026d1:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c01026d4:	83 ec 0c             	sub    $0xc,%esp
c01026d7:	ff 75 ec             	pushl  -0x14(%ebp)
c01026da:	e8 cc 0d 00 00       	call   c01034ab <enready_pcb>
c01026df:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c01026e2:	e8 c4 e9 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c01026e7:	eb fe                	jmp    c01026e7 <main+0xc9>

c01026e9 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01026e9:	55                   	push   %ebp
c01026ea:	89 e5                	mov    %esp,%ebp
c01026ec:	83 ec 10             	sub    $0x10,%esp
c01026ef:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01026f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026f9:	89 c2                	mov    %eax,%edx
c01026fb:	ec                   	in     (%dx),%al
c01026fc:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01026ff:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102703:	0f b6 c0             	movzbl %al,%eax
c0102706:	83 e0 20             	and    $0x20,%eax
c0102709:	85 c0                	test   %eax,%eax
c010270b:	0f 95 c0             	setne  %al
c010270e:	0f b6 c0             	movzbl %al,%eax
}
c0102711:	c9                   	leave  
c0102712:	c3                   	ret    

c0102713 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102713:	55                   	push   %ebp
c0102714:	89 e5                	mov    %esp,%ebp
c0102716:	83 ec 14             	sub    $0x14,%esp
c0102719:	8b 45 08             	mov    0x8(%ebp),%eax
c010271c:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010271f:	90                   	nop
c0102720:	e8 c4 ff ff ff       	call   c01026e9 <serial_idle>
c0102725:	85 c0                	test   %eax,%eax
c0102727:	74 f7                	je     c0102720 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102729:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010272d:	0f b6 c0             	movzbl %al,%eax
c0102730:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102737:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010273a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010273e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102741:	ee                   	out    %al,(%dx)
}
c0102742:	c9                   	leave  
c0102743:	c3                   	ret    

c0102744 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102744:	55                   	push   %ebp
c0102745:	89 e5                	mov    %esp,%ebp
c0102747:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010274a:	8d 45 0c             	lea    0xc(%ebp),%eax
c010274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102750:	8b 45 08             	mov    0x8(%ebp),%eax
c0102753:	83 ec 04             	sub    $0x4,%esp
c0102756:	ff 75 f4             	pushl  -0xc(%ebp)
c0102759:	50                   	push   %eax
c010275a:	68 13 27 10 c0       	push   $0xc0102713
c010275f:	e8 73 16 00 00       	call   c0103dd7 <vfprintf>
c0102764:	83 c4 10             	add    $0x10,%esp
}
c0102767:	c9                   	leave  
c0102768:	c3                   	ret    

c0102769 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0102769:	55                   	push   %ebp
c010276a:	89 e5                	mov    %esp,%ebp
c010276c:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c010276f:	90                   	nop
c0102770:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102777:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010277a:	89 c2                	mov    %eax,%edx
c010277c:	ec                   	in     (%dx),%al
c010277d:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102780:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102784:	0f b6 c0             	movzbl %al,%eax
c0102787:	25 c0 00 00 00       	and    $0xc0,%eax
c010278c:	83 f8 40             	cmp    $0x40,%eax
c010278f:	75 df                	jne    c0102770 <waitdisk+0x7>
}
c0102791:	c9                   	leave  
c0102792:	c3                   	ret    

c0102793 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102793:	55                   	push   %ebp
c0102794:	89 e5                	mov    %esp,%ebp
c0102796:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0102799:	e8 cb ff ff ff       	call   c0102769 <waitdisk>
c010279e:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01027a5:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01027a9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01027ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01027b0:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01027b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027b4:	0f b6 c0             	movzbl %al,%eax
c01027b7:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01027be:	88 45 ef             	mov    %al,-0x11(%ebp)
c01027c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01027c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01027c8:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01027c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027cc:	c1 f8 08             	sar    $0x8,%eax
c01027cf:	0f b6 c0             	movzbl %al,%eax
c01027d2:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01027d9:	88 45 e7             	mov    %al,-0x19(%ebp)
c01027dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01027e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01027e3:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01027e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027e7:	c1 f8 10             	sar    $0x10,%eax
c01027ea:	0f b6 c0             	movzbl %al,%eax
c01027ed:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01027f4:	88 45 df             	mov    %al,-0x21(%ebp)
c01027f7:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01027fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01027fe:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01027ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102802:	c1 f8 18             	sar    $0x18,%eax
c0102805:	83 c8 e0             	or     $0xffffffe0,%eax
c0102808:	0f b6 c0             	movzbl %al,%eax
c010280b:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0102812:	88 45 d7             	mov    %al,-0x29(%ebp)
c0102815:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0102819:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010281c:	ee                   	out    %al,(%dx)
c010281d:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0102824:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0102828:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c010282c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010282f:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0102830:	e8 34 ff ff ff       	call   c0102769 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010283c:	eb 29                	jmp    c0102867 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c010283e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102841:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102848:	8b 45 08             	mov    0x8(%ebp),%eax
c010284b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c010284e:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102855:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102858:	89 c2                	mov    %eax,%edx
c010285a:	ed                   	in     (%dx),%eax
c010285b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c010285e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102861:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102863:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102867:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010286b:	7e d1                	jle    c010283e <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c010286d:	c9                   	leave  
c010286e:	c3                   	ret    

c010286f <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c010286f:	55                   	push   %ebp
c0102870:	89 e5                	mov    %esp,%ebp
c0102872:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102875:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102878:	8b 45 08             	mov    0x8(%ebp),%eax
c010287b:	01 d0                	add    %edx,%eax
c010287d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102880:	8b 45 10             	mov    0x10(%ebp),%eax
c0102883:	99                   	cltd   
c0102884:	c1 ea 17             	shr    $0x17,%edx
c0102887:	01 d0                	add    %edx,%eax
c0102889:	25 ff 01 00 00       	and    $0x1ff,%eax
c010288e:	29 d0                	sub    %edx,%eax
c0102890:	f7 d8                	neg    %eax
c0102892:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102895:	8b 45 10             	mov    0x10(%ebp),%eax
c0102898:	99                   	cltd   
c0102899:	c1 ea 17             	shr    $0x17,%edx
c010289c:	01 d0                	add    %edx,%eax
c010289e:	c1 f8 09             	sar    $0x9,%eax
c01028a1:	83 c0 01             	add    $0x1,%eax
c01028a4:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01028a7:	eb 19                	jmp    c01028c2 <readseg+0x53>
        readsect(pa, offset);
c01028a9:	ff 75 10             	pushl  0x10(%ebp)
c01028ac:	ff 75 08             	pushl  0x8(%ebp)
c01028af:	e8 df fe ff ff       	call   c0102793 <readsect>
c01028b4:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01028b7:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c01028be:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01028c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01028c8:	72 df                	jb     c01028a9 <readseg+0x3a>
        readsect(pa, offset);
c01028ca:	c9                   	leave  
c01028cb:	c3                   	ret    

c01028cc <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01028cc:	55                   	push   %ebp
c01028cd:	89 e5                	mov    %esp,%ebp
c01028cf:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01028d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01028d5:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01028da:	77 16                	ja     c01028f2 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01028dc:	ff 75 10             	pushl  0x10(%ebp)
c01028df:	68 30 42 10 c0       	push   $0xc0104230
c01028e4:	ff 75 0c             	pushl  0xc(%ebp)
c01028e7:	ff 75 08             	pushl  0x8(%ebp)
c01028ea:	e8 55 fe ff ff       	call   c0102744 <printk>
c01028ef:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01028f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01028f5:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01028fa:	c9                   	leave  
c01028fb:	c3                   	ret    

c01028fc <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c01028fc:	55                   	push   %ebp
c01028fd:	89 e5                	mov    %esp,%ebp
c01028ff:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102902:	8b 45 08             	mov    0x8(%ebp),%eax
c0102905:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010290b:	83 ec 04             	sub    $0x4,%esp
c010290e:	50                   	push   %eax
c010290f:	6a 17                	push   $0x17
c0102911:	68 53 42 10 c0       	push   $0xc0104253
c0102916:	e8 b1 ff ff ff       	call   c01028cc <_paddr>
c010291b:	83 c4 10             	add    $0x10,%esp
c010291e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102924:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102927:	8b 45 08             	mov    0x8(%ebp),%eax
c010292a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102930:	83 ec 04             	sub    $0x4,%esp
c0102933:	68 00 10 00 00       	push   $0x1000
c0102938:	6a 00                	push   $0x0
c010293a:	50                   	push   %eax
c010293b:	e8 51 dd ff ff       	call   c0100691 <mm_alloc>
c0102940:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102943:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102946:	83 ec 04             	sub    $0x4,%esp
c0102949:	50                   	push   %eax
c010294a:	68 00 10 00 00       	push   $0x1000
c010294f:	6a 00                	push   $0x0
c0102951:	e8 19 ff ff ff       	call   c010286f <readseg>
c0102956:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102959:	b8 00 00 00 00       	mov    $0x0,%eax
c010295e:	8b 00                	mov    (%eax),%eax
c0102960:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102965:	0f 94 c0             	sete   %al
c0102968:	0f b6 c0             	movzbl %al,%eax
c010296b:	83 ec 08             	sub    $0x8,%esp
c010296e:	50                   	push   %eax
c010296f:	68 67 42 10 c0       	push   $0xc0104267
c0102974:	e8 cb fd ff ff       	call   c0102744 <printk>
c0102979:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c010297c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102981:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102984:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102987:	b8 00 00 00 00       	mov    $0x0,%eax
c010298c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102990:	0f b7 c0             	movzwl %ax,%eax
c0102993:	c1 e0 05             	shl    $0x5,%eax
c0102996:	89 c2                	mov    %eax,%edx
c0102998:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299b:	01 d0                	add    %edx,%eax
c010299d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01029a0:	eb 7f                	jmp    c0102a21 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c01029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a5:	8b 40 0c             	mov    0xc(%eax),%eax
c01029a8:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c01029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ae:	8b 48 14             	mov    0x14(%eax),%ecx
c01029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b4:	8b 50 08             	mov    0x8(%eax),%edx
c01029b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ba:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01029c0:	83 ec 04             	sub    $0x4,%esp
c01029c3:	51                   	push   %ecx
c01029c4:	52                   	push   %edx
c01029c5:	50                   	push   %eax
c01029c6:	e8 c6 dc ff ff       	call   c0100691 <mm_alloc>
c01029cb:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c01029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d1:	8b 50 04             	mov    0x4(%eax),%edx
c01029d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029d7:	01 d0                	add    %edx,%eax
c01029d9:	89 c2                	mov    %eax,%edx
c01029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029de:	8b 40 10             	mov    0x10(%eax),%eax
c01029e1:	83 ec 04             	sub    $0x4,%esp
c01029e4:	52                   	push   %edx
c01029e5:	50                   	push   %eax
c01029e6:	ff 75 e8             	pushl  -0x18(%ebp)
c01029e9:	e8 81 fe ff ff       	call   c010286f <readseg>
c01029ee:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c01029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f4:	8b 50 10             	mov    0x10(%eax),%edx
c01029f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029fa:	01 d0                	add    %edx,%eax
c01029fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01029ff:	eb 0c                	jmp    c0102a0d <loader+0x111>
c0102a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a04:	8d 50 01             	lea    0x1(%eax),%edx
c0102a07:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102a0a:	c6 00 00             	movb   $0x0,(%eax)
c0102a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a10:	8b 50 14             	mov    0x14(%eax),%edx
c0102a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a16:	01 d0                	add    %edx,%eax
c0102a18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102a1b:	77 e4                	ja     c0102a01 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102a1d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102a27:	0f 82 75 ff ff ff    	jb     c01029a2 <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0102a2d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a32:	8b 40 18             	mov    0x18(%eax),%eax
c0102a35:	a3 50 3d 10 c0       	mov    %eax,0xc0103d50

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a43:	83 ec 04             	sub    $0x4,%esp
c0102a46:	68 00 80 00 00       	push   $0x8000
c0102a4b:	68 00 60 bf be       	push   $0xbebf6000
c0102a50:	50                   	push   %eax
c0102a51:	e8 3b dc ff ff       	call   c0100691 <mm_alloc>
c0102a56:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102a59:	a1 50 3d 10 c0       	mov    0xc0103d50,%eax
c0102a5e:	6a 03                	push   $0x3
c0102a60:	50                   	push   %eax
c0102a61:	68 80 df bf be       	push   $0xbebfdf80
c0102a66:	ff 75 08             	pushl  0x8(%ebp)
c0102a69:	e8 09 08 00 00       	call   c0103277 <init_pcb>
c0102a6e:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102a71:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102a76:	83 ec 04             	sub    $0x4,%esp
c0102a79:	50                   	push   %eax
c0102a7a:	6a 39                	push   $0x39
c0102a7c:	68 53 42 10 c0       	push   $0xc0104253
c0102a81:	e8 46 fe ff ff       	call   c01028cc <_paddr>
c0102a86:	83 c4 10             	add    $0x10,%esp
c0102a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a8f:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102a92:	c9                   	leave  
c0102a93:	c3                   	ret    

c0102a94 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0102a94:	55                   	push   %ebp
c0102a95:	89 e5                	mov    %esp,%ebp
c0102a97:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102aa3:	83 ec 04             	sub    $0x4,%esp
c0102aa6:	50                   	push   %eax
c0102aa7:	6a 42                	push   $0x42
c0102aa9:	68 53 42 10 c0       	push   $0xc0104253
c0102aae:	e8 19 fe ff ff       	call   c01028cc <_paddr>
c0102ab3:	83 c4 10             	add    $0x10,%esp
c0102ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abc:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0102abf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ac2:	a3 50 3d 10 c0       	mov    %eax,0xc0103d50
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c0102ac7:	a1 50 3d 10 c0       	mov    0xc0103d50,%eax
c0102acc:	8b 55 08             	mov    0x8(%ebp),%edx
c0102acf:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0102ad5:	83 c2 80             	add    $0xffffff80,%edx
c0102ad8:	6a 00                	push   $0x0
c0102ada:	50                   	push   %eax
c0102adb:	52                   	push   %edx
c0102adc:	ff 75 08             	pushl  0x8(%ebp)
c0102adf:	e8 93 07 00 00       	call   c0103277 <init_pcb>
c0102ae4:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0102ae7:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102aec:	83 ec 04             	sub    $0x4,%esp
c0102aef:	50                   	push   %eax
c0102af0:	6a 46                	push   $0x46
c0102af2:	68 53 42 10 c0       	push   $0xc0104253
c0102af7:	e8 d0 fd ff ff       	call   c01028cc <_paddr>
c0102afc:	83 c4 10             	add    $0x10,%esp
c0102aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b05:	0f 22 d8             	mov    %eax,%cr3

c0102b08:	c9                   	leave  
c0102b09:	c3                   	ret    

c0102b0a <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0102b0a:	55                   	push   %ebp
c0102b0b:	89 e5                	mov    %esp,%ebp
c0102b0d:	83 ec 04             	sub    $0x4,%esp
c0102b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b13:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0102b16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0102b1a:	83 e8 61             	sub    $0x61,%eax
c0102b1d:	8b 04 85 40 60 15 c0 	mov    -0x3fea9fc0(,%eax,4),%eax
}
c0102b24:	c9                   	leave  
c0102b25:	c3                   	ret    

c0102b26 <get_lastkey>:
int8_t get_lastkey(){
c0102b26:	55                   	push   %ebp
c0102b27:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0102b29:	a1 a8 60 15 c0       	mov    0xc01560a8,%eax
c0102b2e:	83 c0 61             	add    $0x61,%eax
}
c0102b31:	5d                   	pop    %ebp
c0102b32:	c3                   	ret    

c0102b33 <press_key>:
void press_key(int code){
c0102b33:	55                   	push   %ebp
c0102b34:	89 e5                	mov    %esp,%ebp
c0102b36:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0102b39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0102b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b43:	25 80 00 00 00       	and    $0x80,%eax
c0102b48:	85 c0                	test   %eax,%eax
c0102b4a:	75 35                	jne    c0102b81 <press_key+0x4e>
		for(;i<26;i++){
c0102b4c:	eb 2b                	jmp    c0102b79 <press_key+0x46>
			if(letter[i]==code){
c0102b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b51:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0102b58:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b5b:	75 18                	jne    c0102b75 <press_key+0x42>
				keydown[i] = 1;
c0102b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b60:	c7 04 85 40 60 15 c0 	movl   $0x1,-0x3fea9fc0(,%eax,4)
c0102b67:	01 00 00 00 
				lastkey = i;
c0102b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b6e:	a3 a8 60 15 c0       	mov    %eax,0xc01560a8
				return;
c0102b73:	eb 3b                	jmp    c0102bb0 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0102b75:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102b79:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0102b7d:	7e cf                	jle    c0102b4e <press_key+0x1b>
c0102b7f:	eb 2f                	jmp    c0102bb0 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0102b81:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0102b85:	eb 23                	jmp    c0102baa <press_key+0x77>
			if(letter[i]==code){
c0102b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b8a:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0102b91:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b94:	75 10                	jne    c0102ba6 <press_key+0x73>
				keydown[i] = 0;
c0102b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b99:	c7 04 85 40 60 15 c0 	movl   $0x0,-0x3fea9fc0(,%eax,4)
c0102ba0:	00 00 00 00 
				return;
c0102ba4:	eb 0a                	jmp    c0102bb0 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0102ba6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102baa:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0102bae:	7e d7                	jle    c0102b87 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0102bb0:	c9                   	leave  
c0102bb1:	c3                   	ret    

c0102bb2 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102bb2:	55                   	push   %ebp
c0102bb3:	89 e5                	mov    %esp,%ebp
c0102bb5:	83 ec 10             	sub    $0x10,%esp
c0102bb8:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102bbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102bc2:	89 c2                	mov    %eax,%edx
c0102bc4:	ec                   	in     (%dx),%al
c0102bc5:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102bc8:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102bcc:	0f b6 c0             	movzbl %al,%eax
c0102bcf:	83 e0 20             	and    $0x20,%eax
c0102bd2:	85 c0                	test   %eax,%eax
c0102bd4:	0f 95 c0             	setne  %al
c0102bd7:	0f b6 c0             	movzbl %al,%eax
}
c0102bda:	c9                   	leave  
c0102bdb:	c3                   	ret    

c0102bdc <serial_printc>:

static inline
void serial_printc(char ch) {
c0102bdc:	55                   	push   %ebp
c0102bdd:	89 e5                	mov    %esp,%ebp
c0102bdf:	83 ec 14             	sub    $0x14,%esp
c0102be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102be5:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102be8:	90                   	nop
c0102be9:	e8 c4 ff ff ff       	call   c0102bb2 <serial_idle>
c0102bee:	85 c0                	test   %eax,%eax
c0102bf0:	74 f7                	je     c0102be9 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102bf2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102bf6:	0f b6 c0             	movzbl %al,%eax
c0102bf9:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102c00:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102c03:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102c07:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102c0a:	ee                   	out    %al,(%dx)
}
c0102c0b:	c9                   	leave  
c0102c0c:	c3                   	ret    

c0102c0d <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0102c0d:	55                   	push   %ebp
c0102c0e:	89 e5                	mov    %esp,%ebp
c0102c10:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0102c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c16:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102c19:	3d df 05 00 00       	cmp    $0x5df,%eax
c0102c1e:	0f 84 a6 02 00 00    	je     c0102eca <do_syscall+0x2bd>
c0102c24:	3d df 05 00 00       	cmp    $0x5df,%eax
c0102c29:	0f 87 97 00 00 00    	ja     c0102cc6 <do_syscall+0xb9>
c0102c2f:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0102c34:	0f 84 d5 02 00 00    	je     c0102f0f <do_syscall+0x302>
c0102c3a:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0102c3f:	77 3d                	ja     c0102c7e <do_syscall+0x71>
c0102c41:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0102c46:	0f 84 a9 02 00 00    	je     c0102ef5 <do_syscall+0x2e8>
c0102c4c:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0102c51:	77 10                	ja     c0102c63 <do_syscall+0x56>
c0102c53:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0102c58:	0f 84 80 02 00 00    	je     c0102ede <do_syscall+0x2d1>
c0102c5e:	e9 01 03 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102c63:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0102c68:	0f 84 8e 02 00 00    	je     c0102efc <do_syscall+0x2ef>
c0102c6e:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0102c73:	0f 84 8a 02 00 00    	je     c0102f03 <do_syscall+0x2f6>
c0102c79:	e9 e6 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102c7e:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0102c83:	0f 84 2d 02 00 00    	je     c0102eb6 <do_syscall+0x2a9>
c0102c89:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0102c8e:	77 1b                	ja     c0102cab <do_syscall+0x9e>
c0102c90:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0102c95:	0f 84 9b 02 00 00    	je     c0102f36 <do_syscall+0x329>
c0102c9b:	3d 15 05 00 00       	cmp    $0x515,%eax
c0102ca0:	0f 84 b0 02 00 00    	je     c0102f56 <do_syscall+0x349>
c0102ca6:	e9 b9 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102cab:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0102cb0:	0f 84 a9 01 00 00    	je     c0102e5f <do_syscall+0x252>
c0102cb6:	3d de 05 00 00       	cmp    $0x5de,%eax
c0102cbb:	0f 84 ca 01 00 00    	je     c0102e8b <do_syscall+0x27e>
c0102cc1:	e9 9e 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102cc6:	3d 41 06 00 00       	cmp    $0x641,%eax
c0102ccb:	0f 84 a7 00 00 00    	je     c0102d78 <do_syscall+0x16b>
c0102cd1:	3d 41 06 00 00       	cmp    $0x641,%eax
c0102cd6:	77 44                	ja     c0102d1c <do_syscall+0x10f>
c0102cd8:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0102cdd:	0f 84 65 01 00 00    	je     c0102e48 <do_syscall+0x23b>
c0102ce3:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0102ce8:	77 1b                	ja     c0102d05 <do_syscall+0xf8>
c0102cea:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c0102cef:	0f 84 df 01 00 00    	je     c0102ed4 <do_syscall+0x2c7>
c0102cf5:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0102cfa:	0f 84 75 01 00 00    	je     c0102e75 <do_syscall+0x268>
c0102d00:	e9 5f 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102d05:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0102d0a:	0f 84 13 01 00 00    	je     c0102e23 <do_syscall+0x216>
c0102d10:	3d 40 06 00 00       	cmp    $0x640,%eax
c0102d15:	74 41                	je     c0102d58 <do_syscall+0x14b>
c0102d17:	e9 48 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102d1c:	3d 44 06 00 00       	cmp    $0x644,%eax
c0102d21:	0f 84 c6 00 00 00    	je     c0102ded <do_syscall+0x1e0>
c0102d27:	3d 44 06 00 00       	cmp    $0x644,%eax
c0102d2c:	77 13                	ja     c0102d41 <do_syscall+0x134>
c0102d2e:	3d 42 06 00 00       	cmp    $0x642,%eax
c0102d33:	74 6b                	je     c0102da0 <do_syscall+0x193>
c0102d35:	3d 43 06 00 00       	cmp    $0x643,%eax
c0102d3a:	74 7b                	je     c0102db7 <do_syscall+0x1aa>
c0102d3c:	e9 23 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
c0102d41:	3d 45 06 00 00       	cmp    $0x645,%eax
c0102d46:	0f 84 b8 00 00 00    	je     c0102e04 <do_syscall+0x1f7>
c0102d4c:	3d 46 06 00 00       	cmp    $0x646,%eax
c0102d51:	74 7b                	je     c0102dce <do_syscall+0x1c1>
c0102d53:	e9 0c 02 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0102d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5b:	8b 40 18             	mov    0x18(%eax),%eax
c0102d5e:	89 c2                	mov    %eax,%edx
c0102d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d63:	8b 40 10             	mov    0x10(%eax),%eax
c0102d66:	83 ec 08             	sub    $0x8,%esp
c0102d69:	52                   	push   %edx
c0102d6a:	50                   	push   %eax
c0102d6b:	e8 a1 e1 ff ff       	call   c0100f11 <sem_init_kr>
c0102d70:	83 c4 10             	add    $0x10,%esp
		break;
c0102d73:	e9 ec 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0102d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7b:	8b 40 18             	mov    0x18(%eax),%eax
c0102d7e:	89 c2                	mov    %eax,%edx
c0102d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d83:	8b 40 10             	mov    0x10(%eax),%eax
c0102d86:	83 ec 08             	sub    $0x8,%esp
c0102d89:	52                   	push   %edx
c0102d8a:	50                   	push   %eax
c0102d8b:	e8 ee e2 ff ff       	call   c010107e <sem_open_kr>
c0102d90:	83 c4 10             	add    $0x10,%esp
c0102d93:	89 c2                	mov    %eax,%edx
c0102d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d98:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102d9b:	e9 c4 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0102da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da3:	8b 40 10             	mov    0x10(%eax),%eax
c0102da6:	83 ec 0c             	sub    $0xc,%esp
c0102da9:	50                   	push   %eax
c0102daa:	e8 ce e1 ff ff       	call   c0100f7d <sem_post_kr>
c0102daf:	83 c4 10             	add    $0x10,%esp
		break;
c0102db2:	e9 ad 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c0102db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dba:	8b 40 10             	mov    0x10(%eax),%eax
c0102dbd:	83 ec 0c             	sub    $0xc,%esp
c0102dc0:	50                   	push   %eax
c0102dc1:	e8 0b e2 ff ff       	call   c0100fd1 <sem_wait_kr>
c0102dc6:	83 c4 10             	add    $0x10,%esp
		break;
c0102dc9:	e9 96 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c0102dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dd1:	8b 40 10             	mov    0x10(%eax),%eax
c0102dd4:	83 ec 0c             	sub    $0xc,%esp
c0102dd7:	50                   	push   %eax
c0102dd8:	e8 4c e2 ff ff       	call   c0101029 <sem_trywait_kr>
c0102ddd:	83 c4 10             	add    $0x10,%esp
c0102de0:	89 c2                	mov    %eax,%edx
c0102de2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de5:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102de8:	e9 77 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0102ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df0:	8b 40 10             	mov    0x10(%eax),%eax
c0102df3:	83 ec 0c             	sub    $0xc,%esp
c0102df6:	50                   	push   %eax
c0102df7:	e8 35 e1 ff ff       	call   c0100f31 <sem_close_kr>
c0102dfc:	83 c4 10             	add    $0x10,%esp
		break;
c0102dff:	e9 60 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0102e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e07:	8b 40 10             	mov    0x10(%eax),%eax
c0102e0a:	83 ec 0c             	sub    $0xc,%esp
c0102e0d:	50                   	push   %eax
c0102e0e:	e8 50 e2 ff ff       	call   c0101063 <sem_get_kr>
c0102e13:	83 c4 10             	add    $0x10,%esp
c0102e16:	89 c2                	mov    %eax,%edx
c0102e18:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1b:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102e1e:	e9 41 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c0102e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e26:	8b 48 14             	mov    0x14(%eax),%ecx
c0102e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e2c:	8b 50 18             	mov    0x18(%eax),%edx
c0102e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e32:	8b 40 10             	mov    0x10(%eax),%eax
c0102e35:	83 ec 04             	sub    $0x4,%esp
c0102e38:	51                   	push   %ecx
c0102e39:	52                   	push   %edx
c0102e3a:	50                   	push   %eax
c0102e3b:	e8 ec 08 00 00       	call   c010372c <thread_current>
c0102e40:	83 c4 10             	add    $0x10,%esp
		break;
c0102e43:	e9 1c 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_JOIN:
			join_current(tf->ebx);
c0102e48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4b:	8b 40 10             	mov    0x10(%eax),%eax
c0102e4e:	83 ec 0c             	sub    $0xc,%esp
c0102e51:	50                   	push   %eax
c0102e52:	e8 b3 0a 00 00       	call   c010390a <join_current>
c0102e57:	83 c4 10             	add    $0x10,%esp
		break;
c0102e5a:	e9 05 01 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_PID:
			tf->eax = current->pid;
c0102e5f:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102e64:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102e70:	e9 ef 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_PPID:
			tf->eax = current->ppid;
c0102e75:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102e7a:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c0102e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e83:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102e86:	e9 d9 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0102e8b:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102e90:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c0102e97:	00 00 00 
			current->timeslice = tf->ebx*200;
c0102e9a:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102e9f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ea2:	8b 52 10             	mov    0x10(%edx),%edx
c0102ea5:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0102eab:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c0102eb1:	e9 ae 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_HANDOUT:
			current->ts = STOP;
c0102eb6:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102ebb:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c0102ec2:	00 00 00 
		break;
c0102ec5:	e9 9a 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_EXIT:
			exit_current();
c0102eca:	e8 ce 09 00 00       	call   c010389d <exit_current>
		break;
c0102ecf:	e9 90 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_FORK:
			fork_current();
c0102ed4:	e8 e1 07 00 00       	call   c01036ba <fork_current>
		break;
c0102ed9:	e9 86 00 00 00       	jmp    c0102f64 <do_syscall+0x357>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0102ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ee1:	8b 40 10             	mov    0x10(%eax),%eax
c0102ee4:	0f be c0             	movsbl %al,%eax
c0102ee7:	83 ec 0c             	sub    $0xc,%esp
c0102eea:	50                   	push   %eax
c0102eeb:	e8 ec fc ff ff       	call   c0102bdc <serial_printc>
c0102ef0:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0102ef3:	eb 6f                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_INIT_CACHE:
			initVCache();
c0102ef5:	e8 d7 0a 00 00       	call   c01039d1 <initVCache>
		break;
c0102efa:	eb 68                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0102efc:	e8 05 0c 00 00       	call   c0103b06 <clearVRAM>
		break;
c0102f01:	eb 61                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0102f03:	e8 fe 0b 00 00       	call   c0103b06 <clearVRAM>
			flushVCache();
c0102f08:	e8 2d 0b 00 00       	call   c0103a3a <flushVCache>
		break;
c0102f0d:	eb 55                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f12:	8b 40 14             	mov    0x14(%eax),%eax
c0102f15:	0f b6 c0             	movzbl %al,%eax
c0102f18:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f1b:	8b 52 18             	mov    0x18(%edx),%edx
c0102f1e:	89 d1                	mov    %edx,%ecx
c0102f20:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f23:	8b 52 10             	mov    0x10(%edx),%edx
c0102f26:	83 ec 04             	sub    $0x4,%esp
c0102f29:	50                   	push   %eax
c0102f2a:	51                   	push   %ecx
c0102f2b:	52                   	push   %edx
c0102f2c:	e8 6e 0b 00 00       	call   c0103a9f <setPixelAt>
c0102f31:	83 c4 10             	add    $0x10,%esp
		break;
c0102f34:	eb 2e                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0102f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f39:	8b 40 10             	mov    0x10(%eax),%eax
c0102f3c:	0f be c0             	movsbl %al,%eax
c0102f3f:	83 ec 0c             	sub    $0xc,%esp
c0102f42:	50                   	push   %eax
c0102f43:	e8 c2 fb ff ff       	call   c0102b0a <get_key>
c0102f48:	83 c4 10             	add    $0x10,%esp
c0102f4b:	0f be d0             	movsbl %al,%edx
c0102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f51:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102f54:	eb 0e                	jmp    c0102f64 <do_syscall+0x357>
		case SYS_GET_TICK:
			tf->eax = tick();
c0102f56:	e8 f7 0c 00 00       	call   c0103c52 <tick>
c0102f5b:	89 c2                	mov    %eax,%edx
c0102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f60:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0102f63:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0102f64:	c9                   	leave  
c0102f65:	c3                   	ret    

c0102f66 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102f66:	55                   	push   %ebp
c0102f67:	89 e5                	mov    %esp,%ebp
c0102f69:	83 ec 10             	sub    $0x10,%esp
c0102f6c:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102f76:	89 c2                	mov    %eax,%edx
c0102f78:	ec                   	in     (%dx),%al
c0102f79:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102f7c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102f80:	0f b6 c0             	movzbl %al,%eax
c0102f83:	83 e0 20             	and    $0x20,%eax
c0102f86:	85 c0                	test   %eax,%eax
c0102f88:	0f 95 c0             	setne  %al
c0102f8b:	0f b6 c0             	movzbl %al,%eax
}
c0102f8e:	c9                   	leave  
c0102f8f:	c3                   	ret    

c0102f90 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102f90:	55                   	push   %ebp
c0102f91:	89 e5                	mov    %esp,%ebp
c0102f93:	83 ec 14             	sub    $0x14,%esp
c0102f96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f99:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102f9c:	90                   	nop
c0102f9d:	e8 c4 ff ff ff       	call   c0102f66 <serial_idle>
c0102fa2:	85 c0                	test   %eax,%eax
c0102fa4:	74 f7                	je     c0102f9d <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102fa6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102faa:	0f b6 c0             	movzbl %al,%eax
c0102fad:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102fb4:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102fb7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102fbe:	ee                   	out    %al,(%dx)
}
c0102fbf:	c9                   	leave  
c0102fc0:	c3                   	ret    

c0102fc1 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102fc1:	55                   	push   %ebp
c0102fc2:	89 e5                	mov    %esp,%ebp
c0102fc4:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102fc7:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102fcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fd0:	83 ec 04             	sub    $0x4,%esp
c0102fd3:	ff 75 f4             	pushl  -0xc(%ebp)
c0102fd6:	50                   	push   %eax
c0102fd7:	68 90 2f 10 c0       	push   $0xc0102f90
c0102fdc:	e8 f6 0d 00 00       	call   c0103dd7 <vfprintf>
c0102fe1:	83 c4 10             	add    $0x10,%esp
}
c0102fe4:	c9                   	leave  
c0102fe5:	c3                   	ret    

c0102fe6 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0102fe6:	55                   	push   %ebp
c0102fe7:	89 e5                	mov    %esp,%ebp
c0102fe9:	57                   	push   %edi
c0102fea:	56                   	push   %esi
c0102feb:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102fec:	8b 45 10             	mov    0x10(%ebp),%eax
c0102fef:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ff2:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102ff5:	89 c1                	mov    %eax,%ecx
c0102ff7:	89 d6                	mov    %edx,%esi
c0102ff9:	89 df                	mov    %ebx,%edi
c0102ffb:	fc                   	cld    
c0102ffc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102ffe:	5b                   	pop    %ebx
c0102fff:	5e                   	pop    %esi
c0103000:	5f                   	pop    %edi
c0103001:	5d                   	pop    %ebp
c0103002:	c3                   	ret    

c0103003 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103003:	55                   	push   %ebp
c0103004:	89 e5                	mov    %esp,%ebp
c0103006:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0103009:	8b 45 10             	mov    0x10(%ebp),%eax
c010300c:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0103011:	77 16                	ja     c0103029 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0103013:	ff 75 10             	pushl  0x10(%ebp)
c0103016:	68 7c 42 10 c0       	push   $0xc010427c
c010301b:	ff 75 0c             	pushl  0xc(%ebp)
c010301e:	ff 75 08             	pushl  0x8(%ebp)
c0103021:	e8 9b ff ff ff       	call   c0102fc1 <printk>
c0103026:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0103029:	8b 45 10             	mov    0x10(%ebp),%eax
c010302c:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0103031:	c9                   	leave  
c0103032:	c3                   	ret    

c0103033 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0103033:	55                   	push   %ebp
c0103034:	89 e5                	mov    %esp,%ebp
c0103036:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103039:	8b 45 10             	mov    0x10(%ebp),%eax
c010303c:	c1 e8 0c             	shr    $0xc,%eax
c010303f:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103044:	76 13                	jbe    c0103059 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0103046:	83 ec 08             	sub    $0x8,%esp
c0103049:	ff 75 10             	pushl  0x10(%ebp)
c010304c:	68 a0 42 10 c0       	push   $0xc01042a0
c0103051:	e8 6b ff ff ff       	call   c0102fc1 <printk>
c0103056:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0103059:	8b 45 10             	mov    0x10(%ebp),%eax
c010305c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103061:	c9                   	leave  
c0103062:	c3                   	ret    

c0103063 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0103063:	55                   	push   %ebp
c0103064:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0103066:	8b 45 08             	mov    0x8(%ebp),%eax
c0103069:	ba 00 57 17 c0       	mov    $0xc0175700,%edx
c010306e:	29 d0                	sub    %edx,%eax
c0103070:	c1 f8 03             	sar    $0x3,%eax
c0103073:	c1 e0 0c             	shl    $0xc,%eax
}
c0103076:	5d                   	pop    %ebp
c0103077:	c3                   	ret    

c0103078 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0103078:	55                   	push   %ebp
c0103079:	89 e5                	mov    %esp,%ebp
c010307b:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010307e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103081:	c1 e8 0c             	shr    $0xc,%eax
c0103084:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103089:	76 10                	jbe    c010309b <pa2page+0x23>
		printk("pa2page called with invalid pa");
c010308b:	83 ec 0c             	sub    $0xc,%esp
c010308e:	68 c4 42 10 c0       	push   $0xc01042c4
c0103093:	e8 29 ff ff ff       	call   c0102fc1 <printk>
c0103098:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c010309b:	8b 45 08             	mov    0x8(%ebp),%eax
c010309e:	c1 e8 0c             	shr    $0xc,%eax
c01030a1:	c1 e0 03             	shl    $0x3,%eax
c01030a4:	05 00 57 17 c0       	add    $0xc0175700,%eax
}
c01030a9:	c9                   	leave  
c01030aa:	c3                   	ret    

c01030ab <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c01030ab:	55                   	push   %ebp
c01030ac:	89 e5                	mov    %esp,%ebp
c01030ae:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01030b1:	ff 75 08             	pushl  0x8(%ebp)
c01030b4:	e8 aa ff ff ff       	call   c0103063 <page2pa>
c01030b9:	83 c4 04             	add    $0x4,%esp
c01030bc:	83 ec 04             	sub    $0x4,%esp
c01030bf:	50                   	push   %eax
c01030c0:	6a 52                	push   $0x52
c01030c2:	68 e3 42 10 c0       	push   $0xc01042e3
c01030c7:	e8 67 ff ff ff       	call   c0103033 <_kaddr>
c01030cc:	83 c4 10             	add    $0x10,%esp
}
c01030cf:	c9                   	leave  
c01030d0:	c3                   	ret    

c01030d1 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c01030d1:	55                   	push   %ebp
c01030d2:	89 e5                	mov    %esp,%ebp
c01030d4:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c01030d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c01030de:	8b 45 08             	mov    0x8(%ebp),%eax
c01030e1:	8b 00                	mov    (%eax),%eax
c01030e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c01030e6:	eb 10                	jmp    c01030f8 <ll_len+0x27>
		p = p->next;
c01030e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01030eb:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01030f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c01030f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c01030f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01030fc:	75 ea                	jne    c01030e8 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c01030fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103101:	c9                   	leave  
c0103102:	c3                   	ret    

c0103103 <ll_pop>:
PCB* ll_pop(PCB** head){
c0103103:	55                   	push   %ebp
c0103104:	89 e5                	mov    %esp,%ebp
c0103106:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0103109:	8b 45 08             	mov    0x8(%ebp),%eax
c010310c:	8b 00                	mov    (%eax),%eax
c010310e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c0103111:	83 ec 08             	sub    $0x8,%esp
c0103114:	ff 75 f4             	pushl  -0xc(%ebp)
c0103117:	ff 75 08             	pushl  0x8(%ebp)
c010311a:	e8 a4 00 00 00       	call   c01031c3 <ll_delete>
c010311f:	83 c4 10             	add    $0x10,%esp
	return p;
c0103122:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103125:	c9                   	leave  
c0103126:	c3                   	ret    

c0103127 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0103127:	55                   	push   %ebp
c0103128:	89 e5                	mov    %esp,%ebp
c010312a:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010312d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103130:	8b 00                	mov    (%eax),%eax
c0103132:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0103135:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103139:	75 0f                	jne    c010314a <ll_push+0x23>
		*head = p;
c010313b:	8b 45 08             	mov    0x8(%ebp),%eax
c010313e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103141:	89 10                	mov    %edx,(%eax)
		return 0;
c0103143:	b8 00 00 00 00       	mov    $0x0,%eax
c0103148:	eb 19                	jmp    c0103163 <ll_push+0x3c>
	}else{
		*head = p;
c010314a:	8b 45 08             	mov    0x8(%ebp),%eax
c010314d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103150:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0103152:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103155:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103158:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c010315e:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103163:	c9                   	leave  
c0103164:	c3                   	ret    

c0103165 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0103165:	55                   	push   %ebp
c0103166:	89 e5                	mov    %esp,%ebp
c0103168:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010316b:	8b 45 08             	mov    0x8(%ebp),%eax
c010316e:	8b 00                	mov    (%eax),%eax
c0103170:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0103173:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103176:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c010317d:	00 00 00 
	if(h == NULL){
c0103180:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103184:	75 0f                	jne    c0103195 <ll_entail+0x30>
		*head = p;
c0103186:	8b 45 08             	mov    0x8(%ebp),%eax
c0103189:	8b 55 0c             	mov    0xc(%ebp),%edx
c010318c:	89 10                	mov    %edx,(%eax)
		return 0;
c010318e:	b8 00 00 00 00       	mov    $0x0,%eax
c0103193:	eb 2c                	jmp    c01031c1 <ll_entail+0x5c>
	}else{
		while(h->next){
c0103195:	eb 0c                	jmp    c01031a3 <ll_entail+0x3e>
			h = h->next;
c0103197:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010319a:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01031a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c01031a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031a6:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01031ac:	85 c0                	test   %eax,%eax
c01031ae:	75 e7                	jne    c0103197 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c01031b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01031b6:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c01031bc:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01031c1:	c9                   	leave  
c01031c2:	c3                   	ret    

c01031c3 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c01031c3:	55                   	push   %ebp
c01031c4:	89 e5                	mov    %esp,%ebp
c01031c6:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c01031c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01031cc:	8b 00                	mov    (%eax),%eax
c01031ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01031d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c01031d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01031dc:	75 07                	jne    c01031e5 <ll_delete+0x22>
			return 0;
c01031de:	b8 00 00 00 00       	mov    $0x0,%eax
c01031e3:	eb 59                	jmp    c010323e <ll_delete+0x7b>
		if(sleep == p)
c01031e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01031eb:	75 09                	jne    c01031f6 <ll_delete+0x33>
			break;
c01031ed:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c01031ee:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01031f2:	75 26                	jne    c010321a <ll_delete+0x57>
c01031f4:	eb 14                	jmp    c010320a <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c01031f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c01031fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031ff:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103205:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0103208:	eb ce                	jmp    c01031d8 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c010320a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010320d:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0103213:	8b 45 08             	mov    0x8(%ebp),%eax
c0103216:	89 10                	mov    %edx,(%eax)
c0103218:	eb 12                	jmp    c010322c <ll_delete+0x69>
	else
		pre->next = sleep->next;
c010321a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321d:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0103223:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103226:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c010322c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010322f:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0103236:	00 00 00 
	return 1;
c0103239:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010323e:	c9                   	leave  
c010323f:	c3                   	ret    

c0103240 <init_pcb_pool>:

void init_pcb_pool()
{
c0103240:	55                   	push   %ebp
c0103241:	89 e5                	mov    %esp,%ebp
c0103243:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103246:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010324d:	eb 1d                	jmp    c010326c <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c010324f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103252:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103258:	05 40 20 00 00       	add    $0x2040,%eax
c010325d:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c0103262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103268:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010326c:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0103273:	76 da                	jbe    c010324f <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0103275:	c9                   	leave  
c0103276:	c3                   	ret    

c0103277 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0103277:	55                   	push   %ebp
c0103278:	89 e5                	mov    %esp,%ebp
c010327a:	83 ec 24             	sub    $0x24,%esp
c010327d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103280:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0103283:	8b 45 08             	mov    0x8(%ebp),%eax
c0103286:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010328c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c010328f:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103293:	75 46                	jne    c01032db <init_pcb+0x64>
		tf->ds = GD_KD;
c0103295:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103298:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c010329f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032a2:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c01032a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032ac:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c01032b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032b5:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c01032bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032bf:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c01032c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032c9:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01032cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032d2:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c01032d9:	eb 4a                	jmp    c0103325 <init_pcb+0xae>
	}else
	if(pri == 3){
c01032db:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c01032df:	75 44                	jne    c0103325 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c01032e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032e4:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c01032eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032ee:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c01032f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01032f8:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c01032fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103301:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0103308:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010330b:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0103312:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103315:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c010331b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010331e:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0103325:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103328:	8b 55 0c             	mov    0xc(%ebp),%edx
c010332b:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c010332e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103331:	8b 55 10             	mov    0x10(%ebp),%edx
c0103334:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0103337:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010333b:	75 59                	jne    c0103396 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c010333d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103340:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0103343:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103346:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0103349:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103357:	eb 26                	jmp    c010337f <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0103359:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010335c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103363:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103366:	01 c2                	add    %eax,%edx
c0103368:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010336b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103372:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103375:	01 c8                	add    %ecx,%eax
c0103377:	8b 00                	mov    (%eax),%eax
c0103379:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c010337b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010337f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103382:	c1 e8 02             	shr    $0x2,%eax
c0103385:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0103388:	77 cf                	ja     c0103359 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c010338a:	8b 45 08             	mov    0x8(%ebp),%eax
c010338d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103390:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c0103396:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010339a:	0f 95 c0             	setne  %al
c010339d:	0f b6 d0             	movzbl %al,%edx
c01033a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a3:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c01033a9:	c9                   	leave  
c01033aa:	c3                   	ret    

c01033ab <pcb_create>:

PCB* pcb_create()
{
c01033ab:	55                   	push   %ebp
c01033ac:	89 e5                	mov    %esp,%ebp
c01033ae:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01033b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033b8:	eb 1f                	jmp    c01033d9 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c01033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033bd:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01033c3:	05 40 20 00 00       	add    $0x2040,%eax
c01033c8:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c01033cd:	8b 00                	mov    (%eax),%eax
c01033cf:	85 c0                	test   %eax,%eax
c01033d1:	75 02                	jne    c01033d5 <pcb_create+0x2a>
c01033d3:	eb 0d                	jmp    c01033e2 <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01033d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033d9:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01033e0:	76 d8                	jbe    c01033ba <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e5:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01033eb:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c01033f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c01033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f6:	6b c0 4c             	imul   $0x4c,%eax,%eax
c01033f9:	8d 90 40 c3 21 c0    	lea    -0x3fde3cc0(%eax),%edx
c01033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103402:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c0103408:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010340b:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c0103412:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0103415:	83 ec 0c             	sub    $0xc,%esp
c0103418:	6a 01                	push   $0x1
c010341a:	e8 64 d4 ff ff       	call   c0100883 <page_alloc>
c010341f:	83 c4 10             	add    $0x10,%esp
c0103422:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0103425:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103429:	75 07                	jne    c0103432 <pcb_create+0x87>
c010342b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103430:	eb 77                	jmp    c01034a9 <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c0103432:	83 ec 0c             	sub    $0xc,%esp
c0103435:	ff 75 ec             	pushl  -0x14(%ebp)
c0103438:	e8 6e fc ff ff       	call   c01030ab <page2kva>
c010343d:	83 c4 10             	add    $0x10,%esp
c0103440:	89 c2                	mov    %eax,%edx
c0103442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103445:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c010344b:	8b 15 a8 80 10 c0    	mov    0xc01080a8,%edx
c0103451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103454:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c010345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010345d:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0103464:	00 00 00 
	//p->ts = READY;
	pid ++;
c0103467:	a1 a8 80 10 c0       	mov    0xc01080a8,%eax
c010346c:	83 c0 01             	add    $0x1,%eax
c010346f:	a3 a8 80 10 c0       	mov    %eax,0xc01080a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0103474:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103477:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010347b:	8d 50 01             	lea    0x1(%eax),%edx
c010347e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103481:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0103485:	8b 15 c0 56 17 c0    	mov    0xc01756c0,%edx
c010348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010348e:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103494:	83 ec 04             	sub    $0x4,%esp
c0103497:	68 00 10 00 00       	push   $0x1000
c010349c:	52                   	push   %edx
c010349d:	50                   	push   %eax
c010349e:	e8 43 fb ff ff       	call   c0102fe6 <memcpy>
c01034a3:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c01034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01034a9:	c9                   	leave  
c01034aa:	c3                   	ret    

c01034ab <enready_pcb>:

void enready_pcb(PCB* pcb){
c01034ab:	55                   	push   %ebp
c01034ac:	89 e5                	mov    %esp,%ebp
c01034ae:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c01034b1:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01034b6:	85 c0                	test   %eax,%eax
c01034b8:	75 18                	jne    c01034d2 <enready_pcb+0x27>
		ready_list = pcb;
c01034ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01034bd:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->tail = pcb;
c01034c2:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01034c7:	8b 55 08             	mov    0x8(%ebp),%edx
c01034ca:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c01034d0:	eb 32                	jmp    c0103504 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01034d2:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01034d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01034da:	8b 45 08             	mov    0x8(%ebp),%eax
c01034dd:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->next = temp;
c01034e2:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01034e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034ea:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c01034f0:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01034f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034f8:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c01034fe:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c0103504:	c9                   	leave  
c0103505:	c3                   	ret    

c0103506 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0103506:	55                   	push   %ebp
c0103507:	89 e5                	mov    %esp,%ebp
c0103509:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c010350c:	8b 45 08             	mov    0x8(%ebp),%eax
c010350f:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac
	lcr3(PADDR(pcb -> pgdir));
c0103514:	8b 45 08             	mov    0x8(%ebp),%eax
c0103517:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010351d:	83 ec 04             	sub    $0x4,%esp
c0103520:	50                   	push   %eax
c0103521:	68 af 00 00 00       	push   $0xaf
c0103526:	68 f9 42 10 c0       	push   $0xc01042f9
c010352b:	e8 d3 fa ff ff       	call   c0103003 <_paddr>
c0103530:	83 c4 10             	add    $0x10,%esp
c0103533:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0103536:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103539:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c010353c:	83 ec 0c             	sub    $0xc,%esp
c010353f:	ff 75 08             	pushl  0x8(%ebp)
c0103542:	e8 15 ce ff ff       	call   c010035c <enter_pcb>
c0103547:	83 c4 10             	add    $0x10,%esp
}
c010354a:	c9                   	leave  
c010354b:	c3                   	ret    

c010354c <free_pcb>:
void free_pcb(PCB* pcb){
c010354c:	55                   	push   %ebp
c010354d:	89 e5                	mov    %esp,%ebp
c010354f:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0103552:	8b 45 08             	mov    0x8(%ebp),%eax
c0103555:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010355b:	83 ec 0c             	sub    $0xc,%esp
c010355e:	50                   	push   %eax
c010355f:	e8 83 d8 ff ff       	call   c0100de7 <free_pgdir>
c0103564:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0103567:	8b 45 08             	mov    0x8(%ebp),%eax
c010356a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103570:	83 ec 04             	sub    $0x4,%esp
c0103573:	50                   	push   %eax
c0103574:	68 b8 00 00 00       	push   $0xb8
c0103579:	68 f9 42 10 c0       	push   $0xc01042f9
c010357e:	e8 80 fa ff ff       	call   c0103003 <_paddr>
c0103583:	83 c4 10             	add    $0x10,%esp
c0103586:	83 ec 0c             	sub    $0xc,%esp
c0103589:	50                   	push   %eax
c010358a:	e8 e9 fa ff ff       	call   c0103078 <pa2page>
c010358f:	83 c4 10             	add    $0x10,%esp
c0103592:	83 ec 0c             	sub    $0xc,%esp
c0103595:	50                   	push   %eax
c0103596:	e8 70 d3 ff ff       	call   c010090b <page_decref>
c010359b:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c010359e:	8b 45 08             	mov    0x8(%ebp),%eax
c01035a1:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c01035a8:	00 00 00 

}
c01035ab:	c9                   	leave  
c01035ac:	c3                   	ret    

c01035ad <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c01035ad:	55                   	push   %ebp
c01035ae:	89 e5                	mov    %esp,%ebp
c01035b0:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c01035b3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01035b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01035b9:	68 10 08 00 00       	push   $0x810
c01035be:	52                   	push   %edx
c01035bf:	50                   	push   %eax
c01035c0:	e8 21 fa ff ff       	call   c0102fe6 <memcpy>
c01035c5:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c01035c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035cb:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c01035d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01035d4:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c01035da:	8b 45 08             	mov    0x8(%ebp),%eax
c01035dd:	05 20 10 00 00       	add    $0x1020,%eax
c01035e2:	89 c2                	mov    %eax,%edx
c01035e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035e7:	05 20 10 00 00       	add    $0x1020,%eax
c01035ec:	29 c2                	sub    %eax,%edx
c01035ee:	89 d0                	mov    %edx,%eax
c01035f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c01035f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035f6:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c01035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ff:	01 c2                	add    %eax,%edx
c0103601:	8b 45 08             	mov    0x8(%ebp),%eax
c0103604:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c010360a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010360d:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c0103613:	8b 45 08             	mov    0x8(%ebp),%eax
c0103616:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c010361c:	8b 45 08             	mov    0x8(%ebp),%eax
c010361f:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103625:	85 c0                	test   %eax,%eax
c0103627:	75 62                	jne    c010368b <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c0103629:	8b 45 08             	mov    0x8(%ebp),%eax
c010362c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103632:	8b 55 08             	mov    0x8(%ebp),%edx
c0103635:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c010363b:	8b 4a 08             	mov    0x8(%edx),%ecx
c010363e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103641:	01 ca                	add    %ecx,%edx
c0103643:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0103646:	8b 45 08             	mov    0x8(%ebp),%eax
c0103649:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010364f:	8b 40 08             	mov    0x8(%eax),%eax
c0103652:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0103655:	eb 17                	jmp    c010366e <copy_pcb+0xc1>
			*(ptr) += offset;
c0103657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010365a:	8b 10                	mov    (%eax),%edx
c010365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010365f:	01 c2                	add    %eax,%edx
c0103661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103664:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0103666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103669:	8b 00                	mov    (%eax),%eax
c010366b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c010366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103671:	8b 00                	mov    (%eax),%eax
c0103673:	85 c0                	test   %eax,%eax
c0103675:	75 e0                	jne    c0103657 <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0103677:	8b 45 0c             	mov    0xc(%ebp),%eax
c010367a:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0103680:	8b 45 08             	mov    0x8(%ebp),%eax
c0103683:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c0103689:	eb 2d                	jmp    c01036b8 <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c010368b:	8b 45 08             	mov    0x8(%ebp),%eax
c010368e:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103694:	83 f8 02             	cmp    $0x2,%eax
c0103697:	74 1f                	je     c01036b8 <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c0103699:	8b 45 0c             	mov    0xc(%ebp),%eax
c010369c:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c01036a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a5:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01036ab:	83 ec 08             	sub    $0x8,%esp
c01036ae:	52                   	push   %edx
c01036af:	50                   	push   %eax
c01036b0:	e8 7d d4 ff ff       	call   c0100b32 <copy_pgdir>
c01036b5:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c01036b8:	c9                   	leave  
c01036b9:	c3                   	ret    

c01036ba <fork_current>:

void switch_proc();
void fork_current(){
c01036ba:	55                   	push   %ebp
c01036bb:	89 e5                	mov    %esp,%ebp
c01036bd:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c01036c0:	e8 e6 fc ff ff       	call   c01033ab <pcb_create>
c01036c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c01036c8:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01036cd:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d6:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01036dc:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01036e1:	83 ec 08             	sub    $0x8,%esp
c01036e4:	50                   	push   %eax
c01036e5:	ff 75 f4             	pushl  -0xc(%ebp)
c01036e8:	e8 c0 fe ff ff       	call   c01035ad <copy_pcb>
c01036ed:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c01036f0:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01036f5:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01036fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036fe:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103704:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0103707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010370a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103710:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c0103717:	83 ec 08             	sub    $0x8,%esp
c010371a:	ff 75 f4             	pushl  -0xc(%ebp)
c010371d:	68 b0 60 15 c0       	push   $0xc01560b0
c0103722:	e8 00 fa ff ff       	call   c0103127 <ll_push>
c0103727:	83 c4 10             	add    $0x10,%esp
}
c010372a:	c9                   	leave  
c010372b:	c3                   	ret    

c010372c <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c010372c:	55                   	push   %ebp
c010372d:	89 e5                	mov    %esp,%ebp
c010372f:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c0103732:	e8 74 fc ff ff       	call   c01033ab <pcb_create>
c0103737:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c010373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373d:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0103744:	00 00 00 
	son->ppid = current->pid;
c0103747:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010374c:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103755:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c010375b:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103760:	83 ec 08             	sub    $0x8,%esp
c0103763:	50                   	push   %eax
c0103764:	ff 75 f4             	pushl  -0xc(%ebp)
c0103767:	e8 41 fe ff ff       	call   c01035ad <copy_pcb>
c010376c:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c010376f:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103774:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c010377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103783:	83 ec 04             	sub    $0x4,%esp
c0103786:	68 00 10 00 00       	push   $0x1000
c010378b:	52                   	push   %edx
c010378c:	50                   	push   %eax
c010378d:	e8 54 f8 ff ff       	call   c0102fe6 <memcpy>
c0103792:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c0103795:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c010379c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010379f:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c01037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01037ae:	83 ec 04             	sub    $0x4,%esp
c01037b1:	68 00 20 00 00       	push   $0x2000
c01037b6:	52                   	push   %edx
c01037b7:	50                   	push   %eax
c01037b8:	e8 d4 ce ff ff       	call   c0100691 <mm_alloc>
c01037bd:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c01037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c3:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01037cc:	83 ea 40             	sub    $0x40,%edx
c01037cf:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c01037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d5:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037db:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01037de:	83 ea 40             	sub    $0x40,%edx
c01037e1:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c01037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e7:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01037f0:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c01037f3:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01037f8:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103801:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103807:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010380d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103813:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c010381a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010381d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103823:	83 ec 04             	sub    $0x4,%esp
c0103826:	50                   	push   %eax
c0103827:	68 fb 00 00 00       	push   $0xfb
c010382c:	68 f9 42 10 c0       	push   $0xc01042f9
c0103831:	e8 cd f7 ff ff       	call   c0103003 <_paddr>
c0103836:	83 c4 10             	add    $0x10,%esp
c0103839:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010383c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010383f:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c0103842:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103845:	83 e8 40             	sub    $0x40,%eax
c0103848:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c010384b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010384e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103851:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c0103853:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103856:	8d 50 04             	lea    0x4(%eax),%edx
c0103859:	8b 45 10             	mov    0x10(%ebp),%eax
c010385c:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c010385e:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103863:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103869:	83 ec 04             	sub    $0x4,%esp
c010386c:	50                   	push   %eax
c010386d:	68 01 01 00 00       	push   $0x101
c0103872:	68 f9 42 10 c0       	push   $0xc01042f9
c0103877:	e8 87 f7 ff ff       	call   c0103003 <_paddr>
c010387c:	83 c4 10             	add    $0x10,%esp
c010387f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103885:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c0103888:	83 ec 08             	sub    $0x8,%esp
c010388b:	ff 75 f4             	pushl  -0xc(%ebp)
c010388e:	68 b0 60 15 c0       	push   $0xc01560b0
c0103893:	e8 8f f8 ff ff       	call   c0103127 <ll_push>
c0103898:	83 c4 10             	add    $0x10,%esp
}
c010389b:	c9                   	leave  
c010389c:	c3                   	ret    

c010389d <exit_current>:

void exit_current(){
c010389d:	55                   	push   %ebp
c010389e:	89 e5                	mov    %esp,%ebp
c01038a0:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c01038a3:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01038a8:	05 68 20 00 00       	add    $0x2068,%eax
c01038ad:	83 ec 0c             	sub    $0xc,%esp
c01038b0:	50                   	push   %eax
c01038b1:	e8 4d f8 ff ff       	call   c0103103 <ll_pop>
c01038b6:	83 c4 10             	add    $0x10,%esp
c01038b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c01038bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038c0:	75 02                	jne    c01038c4 <exit_current+0x27>
c01038c2:	eb 24                	jmp    c01038e8 <exit_current+0x4b>
		if(p->used == 0) continue;
c01038c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038c7:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c01038cd:	85 c0                	test   %eax,%eax
c01038cf:	75 02                	jne    c01038d3 <exit_current+0x36>
c01038d1:	eb 13                	jmp    c01038e6 <exit_current+0x49>
		ll_entail(&ready_list, p);
c01038d3:	83 ec 08             	sub    $0x8,%esp
c01038d6:	ff 75 f4             	pushl  -0xc(%ebp)
c01038d9:	68 b0 60 15 c0       	push   $0xc01560b0
c01038de:	e8 82 f8 ff ff       	call   c0103165 <ll_entail>
c01038e3:	83 c4 10             	add    $0x10,%esp
	}
c01038e6:	eb bb                	jmp    c01038a3 <exit_current+0x6>
	
	free_pcb(current);
c01038e8:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01038ed:	83 ec 0c             	sub    $0xc,%esp
c01038f0:	50                   	push   %eax
c01038f1:	e8 56 fc ff ff       	call   c010354c <free_pcb>
c01038f6:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c01038f9:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0103900:	00 00 00 
	do_scheduler();
c0103903:	e8 a3 d7 ff ff       	call   c01010ab <do_scheduler>
}
c0103908:	c9                   	leave  
c0103909:	c3                   	ret    

c010390a <join_current>:

void join_current(int pid){
c010390a:	55                   	push   %ebp
c010390b:	89 e5                	mov    %esp,%ebp
c010390d:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0103910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103914:	75 05                	jne    c010391b <join_current+0x11>
c0103916:	e9 97 00 00 00       	jmp    c01039b2 <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010391b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103922:	eb 23                	jmp    c0103947 <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0103924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103927:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c010392d:	05 40 20 00 00       	add    $0x2040,%eax
c0103932:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c0103937:	8b 50 04             	mov    0x4(%eax),%edx
c010393a:	8b 45 08             	mov    0x8(%ebp),%eax
c010393d:	39 c2                	cmp    %eax,%edx
c010393f:	75 02                	jne    c0103943 <join_current+0x39>
c0103941:	eb 0d                	jmp    c0103950 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103943:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103947:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c010394e:	76 d4                	jbe    c0103924 <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0103950:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0103957:	75 02                	jne    c010395b <join_current+0x51>
c0103959:	eb 57                	jmp    c01039b2 <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c010395b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010395e:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103964:	05 40 20 00 00       	add    $0x2040,%eax
c0103969:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c010396e:	8b 00                	mov    (%eax),%eax
c0103970:	85 c0                	test   %eax,%eax
c0103972:	75 02                	jne    c0103976 <join_current+0x6c>
c0103974:	eb 3c                	jmp    c01039b2 <join_current+0xa8>
	PCB *p = &PCBPool[i];
c0103976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103979:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c010397f:	05 40 ec 22 c0       	add    $0xc022ec40,%eax
c0103984:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0103987:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010398c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c010398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103992:	05 68 20 00 00       	add    $0x2068,%eax
c0103997:	ff 75 ec             	pushl  -0x14(%ebp)
c010399a:	50                   	push   %eax
c010399b:	e8 c5 f7 ff ff       	call   c0103165 <ll_entail>
c01039a0:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c01039a3:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c01039aa:	00 00 00 
	do_scheduler();
c01039ad:	e8 f9 d6 ff ff       	call   c01010ab <do_scheduler>
c01039b2:	c9                   	leave  
c01039b3:	c3                   	ret    

c01039b4 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c01039b4:	55                   	push   %ebp
c01039b5:	89 e5                	mov    %esp,%ebp
c01039b7:	57                   	push   %edi
c01039b8:	56                   	push   %esi
c01039b9:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c01039ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01039bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01039c3:	89 c1                	mov    %eax,%ecx
c01039c5:	89 d6                	mov    %edx,%esi
c01039c7:	89 df                	mov    %ebx,%edi
c01039c9:	fc                   	cld    
c01039ca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c01039cc:	5b                   	pop    %ebx
c01039cd:	5e                   	pop    %esi
c01039ce:	5f                   	pop    %edi
c01039cf:	5d                   	pop    %ebp
c01039d0:	c3                   	ret    

c01039d1 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c01039d1:	55                   	push   %ebp
c01039d2:	89 e5                	mov    %esp,%ebp
c01039d4:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c01039d7:	68 80 3e 00 00       	push   $0x3e80
c01039dc:	68 c0 5a 16 c0       	push   $0xc0165ac0
c01039e1:	68 c0 60 15 c0       	push   $0xc01560c0
c01039e6:	e8 c9 ff ff ff       	call   c01039b4 <memcpy>
c01039eb:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c01039ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01039f5:	eb 0f                	jmp    c0103a06 <initVCache+0x35>
		VDIRTY[x] = 0;
c01039f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01039fa:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c01039ff:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0103a02:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103a06:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103a0d:	7e e8                	jle    c01039f7 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0103a0f:	c9                   	leave  
c0103a10:	c3                   	ret    

c0103a11 <refreshVCache>:
void refreshVCache(){
c0103a11:	55                   	push   %ebp
c0103a12:	89 e5                	mov    %esp,%ebp
c0103a14:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103a17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103a1e:	eb 0f                	jmp    c0103a2f <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0103a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a23:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103a28:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103a2b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103a2f:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103a36:	7e e8                	jle    c0103a20 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0103a38:	c9                   	leave  
c0103a39:	c3                   	ret    

c0103a3a <flushVCache>:
void flushVCache(){
c0103a3a:	55                   	push   %ebp
c0103a3b:	89 e5                	mov    %esp,%ebp
c0103a3d:	53                   	push   %ebx
c0103a3e:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103a41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0103a48:	eb 47                	jmp    c0103a91 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0103a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a4d:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103a52:	0f b6 00             	movzbl (%eax),%eax
c0103a55:	84 c0                	test   %al,%al
c0103a57:	74 34                	je     c0103a8d <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0103a59:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103a5c:	89 d0                	mov    %edx,%eax
c0103a5e:	c1 e0 02             	shl    $0x2,%eax
c0103a61:	01 d0                	add    %edx,%eax
c0103a63:	c1 e0 06             	shl    $0x6,%eax
c0103a66:	8d 88 c0 60 15 c0    	lea    -0x3fea9f40(%eax),%ecx
c0103a6c:	8b 1d ac 80 10 c0    	mov    0xc01080ac,%ebx
c0103a72:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103a75:	89 d0                	mov    %edx,%eax
c0103a77:	c1 e0 02             	shl    $0x2,%eax
c0103a7a:	01 d0                	add    %edx,%eax
c0103a7c:	c1 e0 06             	shl    $0x6,%eax
c0103a7f:	01 d8                	add    %ebx,%eax
c0103a81:	6a 50                	push   $0x50
c0103a83:	51                   	push   %ecx
c0103a84:	50                   	push   %eax
c0103a85:	e8 2a ff ff ff       	call   c01039b4 <memcpy>
c0103a8a:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103a8d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0103a91:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0103a98:	7e b0                	jle    c0103a4a <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0103a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103a9d:	c9                   	leave  
c0103a9e:	c3                   	ret    

c0103a9f <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0103a9f:	55                   	push   %ebp
c0103aa0:	89 e5                	mov    %esp,%ebp
c0103aa2:	83 ec 04             	sub    $0x4,%esp
c0103aa5:	8b 45 10             	mov    0x10(%ebp),%eax
c0103aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0103aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103aaf:	78 18                	js     c0103ac9 <setPixelAt+0x2a>
c0103ab1:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0103ab8:	7f 0f                	jg     c0103ac9 <setPixelAt+0x2a>
c0103aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103abe:	78 09                	js     c0103ac9 <setPixelAt+0x2a>
c0103ac0:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0103ac7:	7e 02                	jle    c0103acb <setPixelAt+0x2c>
c0103ac9:	eb 34                	jmp    c0103aff <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0103acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ace:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103ad3:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0103ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad9:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0103ade:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0103ae1:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ae4:	89 d0                	mov    %edx,%eax
c0103ae6:	c1 e0 02             	shl    $0x2,%eax
c0103ae9:	01 d0                	add    %edx,%eax
c0103aeb:	c1 e0 06             	shl    $0x6,%eax
c0103aee:	89 c2                	mov    %eax,%edx
c0103af0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103af3:	01 c2                	add    %eax,%edx
c0103af5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0103af9:	88 82 c0 60 15 c0    	mov    %al,-0x3fea9f40(%edx)
}
c0103aff:	c9                   	leave  
c0103b00:	c3                   	ret    

c0103b01 <forceClearVRAM>:
void forceClearVRAM(){
c0103b01:	55                   	push   %ebp
c0103b02:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0103b04:	5d                   	pop    %ebp
c0103b05:	c3                   	ret    

c0103b06 <clearVRAM>:
void clearVRAM(){
c0103b06:	55                   	push   %ebp
c0103b07:	89 e5                	mov    %esp,%ebp
c0103b09:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0103b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103b13:	eb 4e                	jmp    c0103b63 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0103b15:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b18:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0103b1d:	0f b6 00             	movzbl (%eax),%eax
c0103b20:	0f b6 c0             	movzbl %al,%eax
c0103b23:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103b26:	81 c2 c0 54 17 c0    	add    $0xc01754c0,%edx
c0103b2c:	0f b6 12             	movzbl (%edx),%edx
c0103b2f:	0f b6 d2             	movzbl %dl,%edx
c0103b32:	f7 d2                	not    %edx
c0103b34:	21 d0                	and    %edx,%eax
c0103b36:	85 c0                	test   %eax,%eax
c0103b38:	74 25                	je     c0103b5f <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0103b3a:	8b 0d ac 80 10 c0    	mov    0xc01080ac,%ecx
c0103b40:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103b43:	89 d0                	mov    %edx,%eax
c0103b45:	c1 e0 02             	shl    $0x2,%eax
c0103b48:	01 d0                	add    %edx,%eax
c0103b4a:	c1 e0 06             	shl    $0x6,%eax
c0103b4d:	01 c8                	add    %ecx,%eax
c0103b4f:	6a 50                	push   $0x50
c0103b51:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103b56:	50                   	push   %eax
c0103b57:	e8 58 fe ff ff       	call   c01039b4 <memcpy>
c0103b5c:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0103b5f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103b63:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103b6a:	7e a9                	jle    c0103b15 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0103b6c:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103b73:	83 c0 01             	add    $0x1,%eax
c0103b76:	a2 88 56 17 c0       	mov    %al,0xc0175688
	if(stamp==30){
c0103b7b:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103b82:	3c 1e                	cmp    $0x1e,%al
c0103b84:	75 07                	jne    c0103b8d <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0103b86:	c6 05 88 56 17 c0 00 	movb   $0x0,0xc0175688
		//printk("What matters\n");
	}
	if(stamp==0){
c0103b8d:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103b94:	84 c0                	test   %al,%al
c0103b96:	75 14                	jne    c0103bac <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0103b98:	6a 32                	push   $0x32
c0103b9a:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103b9f:	68 c0 55 17 c0       	push   $0xc01755c0
c0103ba4:	e8 0b fe ff ff       	call   c01039b4 <memcpy>
c0103ba9:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0103bac:	c9                   	leave  
c0103bad:	c3                   	ret    

c0103bae <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0103bae:	55                   	push   %ebp
c0103baf:	89 e5                	mov    %esp,%ebp
c0103bb1:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0103bb4:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c0103bb9:	83 c0 01             	add    $0x1,%eax
c0103bbc:	a3 8c 56 17 c0       	mov    %eax,0xc017568c
	current->timeslice ++;
c0103bc1:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103bc6:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0103bcc:	83 c2 01             	add    $0x1,%edx
c0103bcf:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c0103bd5:	a1 b4 60 15 c0       	mov    0xc01560b4,%eax
c0103bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0103bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103be1:	75 02                	jne    c0103be5 <do_timer+0x37>
c0103be3:	eb 6b                	jmp    c0103c50 <do_timer+0xa2>
	 	sleep->timeslice --;
c0103be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103be8:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0103bee:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bf4:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0103bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c03:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103c09:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0103c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c0f:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0103c15:	85 c0                	test   %eax,%eax
c0103c17:	74 02                	je     c0103c1b <do_timer+0x6d>
c0103c19:	eb 33                	jmp    c0103c4e <do_timer+0xa0>
	 	cur->ts = READY;
c0103c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c1e:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0103c25:	00 00 00 
		ll_delete(&sleep_list, cur);
c0103c28:	83 ec 08             	sub    $0x8,%esp
c0103c2b:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c2e:	68 b4 60 15 c0       	push   $0xc01560b4
c0103c33:	e8 8b f5 ff ff       	call   c01031c3 <ll_delete>
c0103c38:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0103c3b:	83 ec 08             	sub    $0x8,%esp
c0103c3e:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c41:	68 b0 60 15 c0       	push   $0xc01560b0
c0103c46:	e8 1a f5 ff ff       	call   c0103165 <ll_entail>
c0103c4b:	83 c4 10             	add    $0x10,%esp
	}
c0103c4e:	eb 8d                	jmp    c0103bdd <do_timer+0x2f>
}
c0103c50:	c9                   	leave  
c0103c51:	c3                   	ret    

c0103c52 <tick>:
uint32_t tick(){
c0103c52:	55                   	push   %ebp
c0103c53:	89 e5                	mov    %esp,%ebp
	return _tick;
c0103c55:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c0103c5a:	5d                   	pop    %ebp
c0103c5b:	c3                   	ret    

c0103c5c <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0103c5c:	6a 00                	push   $0x0
c0103c5e:	6a 00                	push   $0x0
c0103c60:	e9 b8 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c65 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0103c65:	6a 00                	push   $0x0
c0103c67:	6a 01                	push   $0x1
c0103c69:	e9 af 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c6e <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0103c6e:	6a 00                	push   $0x0
c0103c70:	6a 02                	push   $0x2
c0103c72:	e9 a6 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c77 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0103c77:	6a 00                	push   $0x0
c0103c79:	6a 03                	push   $0x3
c0103c7b:	e9 9d 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c80 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0103c80:	6a 00                	push   $0x0
c0103c82:	6a 04                	push   $0x4
c0103c84:	e9 94 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c89 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0103c89:	6a 00                	push   $0x0
c0103c8b:	6a 05                	push   $0x5
c0103c8d:	e9 8b 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c92 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0103c92:	6a 00                	push   $0x0
c0103c94:	6a 06                	push   $0x6
c0103c96:	e9 82 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103c9b <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0103c9b:	6a 00                	push   $0x0
c0103c9d:	6a 07                	push   $0x7
c0103c9f:	e9 79 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103ca4 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0103ca4:	6a 00                	push   $0x0
c0103ca6:	6a 08                	push   $0x8
c0103ca8:	e9 70 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cad <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0103cad:	6a 00                	push   $0x0
c0103caf:	6a 09                	push   $0x9
c0103cb1:	e9 67 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cb6 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0103cb6:	6a 00                	push   $0x0
c0103cb8:	6a 0a                	push   $0xa
c0103cba:	e9 5e 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cbf <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0103cbf:	6a 00                	push   $0x0
c0103cc1:	6a 0b                	push   $0xb
c0103cc3:	e9 55 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cc8 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0103cc8:	6a 00                	push   $0x0
c0103cca:	6a 0c                	push   $0xc
c0103ccc:	e9 4c 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cd1 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0103cd1:	6a 00                	push   $0x0
c0103cd3:	6a 0d                	push   $0xd
c0103cd5:	e9 43 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cda <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0103cda:	6a 00                	push   $0x0
c0103cdc:	6a 0e                	push   $0xe
c0103cde:	e9 3a 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103ce3 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0103ce3:	fa                   	cli    
c0103ce4:	6a 00                	push   $0x0
c0103ce6:	68 80 00 00 00       	push   $0x80
c0103ceb:	e9 2d 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cf0 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0103cf0:	6a 00                	push   $0x0
c0103cf2:	68 e8 03 00 00       	push   $0x3e8
c0103cf7:	e9 21 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103cfc <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0103cfc:	6a 00                	push   $0x0
c0103cfe:	68 e9 03 00 00       	push   $0x3e9
c0103d03:	e9 15 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103d08 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0103d08:	6a 00                	push   $0x0
c0103d0a:	68 f6 03 00 00       	push   $0x3f6
c0103d0f:	e9 09 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103d14 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0103d14:	6a 00                	push   $0x0
c0103d16:	6a ff                	push   $0xffffffff
c0103d18:	e9 00 00 00 00       	jmp    c0103d1d <asm_do_irq>

c0103d1d <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0103d1d:	fa                   	cli    
  pushl %ds
c0103d1e:	1e                   	push   %ds
  pushl %es
c0103d1f:	06                   	push   %es
  pushl %fs
c0103d20:	0f a0                	push   %fs
  pushl %gs
c0103d22:	0f a8                	push   %gs
	pushal
c0103d24:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0103d25:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0103d29:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0103d2b:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0103d2d:	54                   	push   %esp
  call irq_handle
c0103d2e:	e8 6b d4 ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0103d33:	83 c4 04             	add    $0x4,%esp

c0103d36 <switch_proc>:
switch_proc:
  popal
c0103d36:	61                   	popa   
  popl %gs
c0103d37:	0f a9                	pop    %gs
  popl %fs
c0103d39:	0f a1                	pop    %fs
  popl %es
c0103d3b:	07                   	pop    %es
  popl %ds
c0103d3c:	1f                   	pop    %ds
  addl $8, %esp
c0103d3d:	83 c4 08             	add    $0x8,%esp
  sti
c0103d40:	fb                   	sti    
  iret
c0103d41:	cf                   	iret   
c0103d42:	66 90                	xchg   %ax,%ax
c0103d44:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0103d4a:	00 00                	add    %al,(%eax)
c0103d4c:	fe 4f 52             	decb   0x52(%edi)
c0103d4f:	e4 66                	in     $0x66,%al

c0103d50 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0103d50:	66 c7 05 72 04 00 00 34 12 b8 00 70 10 00 0f 22     f..r...4...p..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0103d60:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 73 3d 10     .. ......."..s=.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0103d70:	c0 ff e0                                            ...

c0103d73 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0103d73:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0103d78:	bc 00 10 11 c0       	mov    $0xc0111000,%esp

	# now to C code

	call	main
c0103d7d:	e8 9c e8 ff ff       	call   c010261e <main>

c0103d82 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0103d82:	eb fe                	jmp    c0103d82 <spin>

c0103d84 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0103d84:	55                   	push   %ebp
c0103d85:	89 e5                	mov    %esp,%ebp
c0103d87:	53                   	push   %ebx
c0103d88:	83 ec 04             	sub    $0x4,%esp
c0103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8e:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0103d91:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0103d96:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0103d9a:	89 d3                	mov    %edx,%ebx
c0103d9c:	cd 80                	int    $0x80
}
c0103d9e:	83 c4 04             	add    $0x4,%esp
c0103da1:	5b                   	pop    %ebx
c0103da2:	5d                   	pop    %ebp
c0103da3:	c3                   	ret    

c0103da4 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0103da4:	55                   	push   %ebp
c0103da5:	89 e5                	mov    %esp,%ebp
c0103da7:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0103daa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0103db0:	eb 19                	jmp    c0103dcb <printp+0x27>
		printer(cur);
c0103db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103db5:	0f b6 00             	movzbl (%eax),%eax
c0103db8:	0f be c0             	movsbl %al,%eax
c0103dbb:	83 ec 0c             	sub    $0xc,%esp
c0103dbe:	50                   	push   %eax
c0103dbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc2:	ff d0                	call   *%eax
c0103dc4:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0103dc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dce:	0f b6 00             	movzbl (%eax),%eax
c0103dd1:	84 c0                	test   %al,%al
c0103dd3:	75 dd                	jne    c0103db2 <printp+0xe>
		printer(cur);
	}
}
c0103dd5:	c9                   	leave  
c0103dd6:	c3                   	ret    

c0103dd7 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0103dd7:	55                   	push   %ebp
c0103dd8:	89 e5                	mov    %esp,%ebp
c0103dda:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0103ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0103de3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0103dea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0103df1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103df4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0103df7:	e9 65 02 00 00       	jmp    c0104061 <vfprintf+0x28a>

		if(cur == '%'){
c0103dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dff:	0f b6 00             	movzbl (%eax),%eax
c0103e02:	3c 25                	cmp    $0x25,%al
c0103e04:	75 0c                	jne    c0103e12 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0103e06:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0103e0d:	e9 4b 02 00 00       	jmp    c010405d <vfprintf+0x286>
		}
		if(type == READ){
c0103e12:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0103e16:	0f 85 26 02 00 00    	jne    c0104042 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0103e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e1f:	0f b6 00             	movzbl (%eax),%eax
c0103e22:	3c 73                	cmp    $0x73,%al
c0103e24:	75 35                	jne    c0103e5b <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0103e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e29:	8b 00                	mov    (%eax),%eax
c0103e2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0103e2e:	eb 19                	jmp    c0103e49 <vfprintf+0x72>
					printer(*p);
c0103e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e33:	0f b6 00             	movzbl (%eax),%eax
c0103e36:	0f be c0             	movsbl %al,%eax
c0103e39:	83 ec 0c             	sub    $0xc,%esp
c0103e3c:	50                   	push   %eax
c0103e3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e40:	ff d0                	call   *%eax
c0103e42:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0103e45:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0103e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e4c:	0f b6 00             	movzbl (%eax),%eax
c0103e4f:	84 c0                	test   %al,%al
c0103e51:	75 dd                	jne    c0103e30 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0103e53:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103e57:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0103e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e5e:	0f b6 00             	movzbl (%eax),%eax
c0103e61:	3c 78                	cmp    $0x78,%al
c0103e63:	0f 85 99 00 00 00    	jne    c0103f02 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0103e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e6c:	8b 00                	mov    (%eax),%eax
c0103e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0103e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103e75:	75 1d                	jne    c0103e94 <vfprintf+0xbd>
					printer('0');
c0103e77:	83 ec 0c             	sub    $0xc,%esp
c0103e7a:	6a 30                	push   $0x30
c0103e7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e7f:	ff d0                	call   *%eax
c0103e81:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103e84:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103e88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103e8f:	e9 c9 01 00 00       	jmp    c010405d <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0103e94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0103e9b:	eb 2d                	jmp    c0103eca <vfprintf+0xf3>
					int d=(x%16);
c0103e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ea0:	83 e0 0f             	and    $0xf,%eax
c0103ea3:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0103ea6:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0103eaa:	7e 04                	jle    c0103eb0 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0103eac:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0103eb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103eb3:	83 c0 30             	add    $0x30,%eax
c0103eb6:	89 c1                	mov    %eax,%ecx
c0103eb8:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103ebb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ebe:	01 d0                	add    %edx,%eax
c0103ec0:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0103ec2:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0103ec6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103eca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103ece:	75 cd                	jne    c0103e9d <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0103ed0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0103ed4:	eb 1e                	jmp    c0103ef4 <vfprintf+0x11d>
					printer(digits[di]);
c0103ed6:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103edc:	01 d0                	add    %edx,%eax
c0103ede:	0f b6 00             	movzbl (%eax),%eax
c0103ee1:	0f be c0             	movsbl %al,%eax
c0103ee4:	83 ec 0c             	sub    $0xc,%esp
c0103ee7:	50                   	push   %eax
c0103ee8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eeb:	ff d0                	call   *%eax
c0103eed:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0103ef0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0103ef4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103ef8:	79 dc                	jns    c0103ed6 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0103efa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103efe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0103f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f05:	0f b6 00             	movzbl (%eax),%eax
c0103f08:	3c 64                	cmp    $0x64,%al
c0103f0a:	0f 85 02 01 00 00    	jne    c0104012 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0103f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f13:	8b 00                	mov    (%eax),%eax
c0103f15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0103f18:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0103f1f:	75 23                	jne    c0103f44 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0103f21:	83 ec 08             	sub    $0x8,%esp
c0103f24:	68 0e 43 10 c0       	push   $0xc010430e
c0103f29:	ff 75 08             	pushl  0x8(%ebp)
c0103f2c:	e8 73 fe ff ff       	call   c0103da4 <printp>
c0103f31:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103f34:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103f38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0103f3f:	e9 19 01 00 00       	jmp    c010405d <vfprintf+0x286>
				}
				if(x==0){
c0103f44:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103f48:	75 1e                	jne    c0103f68 <vfprintf+0x191>
					printer('0');
c0103f4a:	83 ec 0c             	sub    $0xc,%esp
c0103f4d:	6a 30                	push   $0x30
c0103f4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f52:	ff d0                	call   *%eax
c0103f54:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103f57:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103f5b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0103f62:	90                   	nop
c0103f63:	e9 f5 00 00 00       	jmp    c010405d <vfprintf+0x286>
				}
				if(x<0){
c0103f68:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103f6c:	79 10                	jns    c0103f7e <vfprintf+0x1a7>
					printer('-');
c0103f6e:	83 ec 0c             	sub    $0xc,%esp
c0103f71:	6a 2d                	push   $0x2d
c0103f73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f76:	ff d0                	call   *%eax
c0103f78:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0103f7b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0103f7e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0103f85:	eb 53                	jmp    c0103fda <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0103f87:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103f8a:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0103f8f:	89 c8                	mov    %ecx,%eax
c0103f91:	f7 ea                	imul   %edx
c0103f93:	c1 fa 02             	sar    $0x2,%edx
c0103f96:	89 c8                	mov    %ecx,%eax
c0103f98:	c1 f8 1f             	sar    $0x1f,%eax
c0103f9b:	29 c2                	sub    %eax,%edx
c0103f9d:	89 d0                	mov    %edx,%eax
c0103f9f:	c1 e0 02             	shl    $0x2,%eax
c0103fa2:	01 d0                	add    %edx,%eax
c0103fa4:	01 c0                	add    %eax,%eax
c0103fa6:	29 c1                	sub    %eax,%ecx
c0103fa8:	89 ca                	mov    %ecx,%edx
c0103faa:	89 d0                	mov    %edx,%eax
c0103fac:	83 c0 30             	add    $0x30,%eax
c0103faf:	89 c1                	mov    %eax,%ecx
c0103fb1:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103fb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fb7:	01 d0                	add    %edx,%eax
c0103fb9:	88 08                	mov    %cl,(%eax)
					x/=10;
c0103fbb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103fbe:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0103fc3:	89 c8                	mov    %ecx,%eax
c0103fc5:	f7 ea                	imul   %edx
c0103fc7:	c1 fa 02             	sar    $0x2,%edx
c0103fca:	89 c8                	mov    %ecx,%eax
c0103fcc:	c1 f8 1f             	sar    $0x1f,%eax
c0103fcf:	29 c2                	sub    %eax,%edx
c0103fd1:	89 d0                	mov    %edx,%eax
c0103fd3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0103fd6:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103fda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103fde:	7f a7                	jg     c0103f87 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0103fe0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0103fe4:	eb 1e                	jmp    c0104004 <vfprintf+0x22d>
					printer(digits[di]);
c0103fe6:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103fe9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fec:	01 d0                	add    %edx,%eax
c0103fee:	0f b6 00             	movzbl (%eax),%eax
c0103ff1:	0f be c0             	movsbl %al,%eax
c0103ff4:	83 ec 0c             	sub    $0xc,%esp
c0103ff7:	50                   	push   %eax
c0103ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ffb:	ff d0                	call   *%eax
c0103ffd:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0104000:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104004:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104008:	79 dc                	jns    c0103fe6 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010400a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010400e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0104012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104015:	0f b6 00             	movzbl (%eax),%eax
c0104018:	3c 63                	cmp    $0x63,%al
c010401a:	75 1d                	jne    c0104039 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c010401c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010401f:	0f b6 00             	movzbl (%eax),%eax
c0104022:	0f be c0             	movsbl %al,%eax
c0104025:	83 ec 0c             	sub    $0xc,%esp
c0104028:	50                   	push   %eax
c0104029:	8b 45 08             	mov    0x8(%ebp),%eax
c010402c:	ff d0                	call   *%eax
c010402e:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0104031:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104035:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0104039:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0104040:	eb 1b                	jmp    c010405d <vfprintf+0x286>
		}
		if(type == NONE){
c0104042:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104046:	75 15                	jne    c010405d <vfprintf+0x286>
			printer(cur);
c0104048:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010404b:	0f b6 00             	movzbl (%eax),%eax
c010404e:	0f be c0             	movsbl %al,%eax
c0104051:	83 ec 0c             	sub    $0xc,%esp
c0104054:	50                   	push   %eax
c0104055:	8b 45 08             	mov    0x8(%ebp),%eax
c0104058:	ff d0                	call   *%eax
c010405a:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c010405d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104061:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104064:	0f b6 00             	movzbl (%eax),%eax
c0104067:	84 c0                	test   %al,%al
c0104069:	0f 85 8d fd ff ff    	jne    c0103dfc <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c010406f:	c9                   	leave  
c0104070:	c3                   	ret    

c0104071 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0104071:	55                   	push   %ebp
c0104072:	89 e5                	mov    %esp,%ebp
c0104074:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0104077:	8d 45 0c             	lea    0xc(%ebp),%eax
c010407a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c010407d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104080:	83 ec 04             	sub    $0x4,%esp
c0104083:	ff 75 f4             	pushl  -0xc(%ebp)
c0104086:	50                   	push   %eax
c0104087:	68 84 3d 10 c0       	push   $0xc0103d84
c010408c:	e8 46 fd ff ff       	call   c0103dd7 <vfprintf>
c0104091:	83 c4 10             	add    $0x10,%esp
}
c0104094:	c9                   	leave  
c0104095:	c3                   	ret    
