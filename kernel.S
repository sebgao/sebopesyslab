
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
c01000ba:	e8 c4 2e 00 00       	call   c0102f83 <vfprintf>
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
c01000f0:	68 44 32 10 c0       	push   $0xc0103244
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
c0100371:	68 67 32 10 c0       	push   $0xc0103267
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
c01003fe:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac
	//printk("A\n");
	lcr3(PADDR(pcb->pgdir));
c0100403:	8b 45 08             	mov    0x8(%ebp),%eax
c0100406:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010040c:	83 ec 04             	sub    $0x4,%esp
c010040f:	50                   	push   %eax
c0100410:	68 8d 00 00 00       	push   $0x8d
c0100415:	68 67 32 10 c0       	push   $0xc0103267
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
c0100448:	b8 e1 2e 10 c0       	mov    $0xc0102ee1,%eax
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
c0100583:	e8 fb 29 00 00       	call   c0102f83 <vfprintf>
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
c01005d6:	68 80 32 10 c0       	push   $0xc0103280
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
c010060c:	68 a4 32 10 c0       	push   $0xc01032a4
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
c010064e:	68 c8 32 10 c0       	push   $0xc01032c8
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
c0100682:	68 e7 32 10 c0       	push   $0xc01032e7
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
c010074d:	68 fd 32 10 c0       	push   $0xc01032fd
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
c01007ae:	68 fd 32 10 c0       	push   $0xc01032fd
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
c010089a:	68 18 33 10 c0       	push   $0xc0103318
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
c010097f:	68 fd 32 10 c0       	push   $0xc01032fd
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
c01009fb:	68 fd 32 10 c0       	push   $0xc01032fd
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
c0100b9d:	68 fd 32 10 c0       	push   $0xc01032fd
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
c0100c27:	68 fd 32 10 c0       	push   $0xc01032fd
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
c0100cd9:	68 fd 32 10 c0       	push   $0xc01032fd
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
c0100e4f:	68 fd 32 10 c0       	push   $0xc01032fd
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
c0100f53:	e8 dd 13 00 00       	call   c0102335 <ll_pop>
c0100f58:	83 c4 10             	add    $0x10,%esp
c0100f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			if(pcb == NULL) break;
c0100f5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100f62:	75 02                	jne    c0100f66 <sem_close_kr+0x35>
c0100f64:	eb 15                	jmp    c0100f7b <sem_close_kr+0x4a>
			ll_entail(&ready_list, pcb);
c0100f66:	83 ec 08             	sub    $0x8,%esp
c0100f69:	ff 75 f4             	pushl  -0xc(%ebp)
c0100f6c:	68 b0 50 15 c0       	push   $0xc01550b0
c0100f71:	e8 21 14 00 00       	call   c0102397 <ll_entail>
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
c0100fb1:	e8 7f 13 00 00       	call   c0102335 <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 50 15 c0       	push   $0xc01550b0
c0100fc7:	e8 cb 13 00 00       	call   c0102397 <ll_entail>
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
c0100ffb:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101000:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&sem->block_list, cur);
c0101003:	8b 45 08             	mov    0x8(%ebp),%eax
c0101006:	83 c0 08             	add    $0x8,%eax
c0101009:	83 ec 08             	sub    $0x8,%esp
c010100c:	ff 75 f4             	pushl  -0xc(%ebp)
c010100f:	50                   	push   %eax
c0101010:	e8 82 13 00 00       	call   c0102397 <ll_entail>
c0101015:	83 c4 10             	add    $0x10,%esp
		current = NULL;
c0101018:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c010101f:	00 00 00 
		do_scheduler();
c0101022:	e8 4a 00 00 00       	call   c0101071 <do_scheduler>
	}
}
c0101027:	c9                   	leave  
c0101028:	c3                   	ret    

c0101029 <sem_get_kr>:

int sem_get_kr(Semaphore* sem){
c0101029:	55                   	push   %ebp
c010102a:	89 e5                	mov    %esp,%ebp
	if(!sem->used)return 0;
c010102c:	8b 45 08             	mov    0x8(%ebp),%eax
c010102f:	8b 00                	mov    (%eax),%eax
c0101031:	85 c0                	test   %eax,%eax
c0101033:	75 07                	jne    c010103c <sem_get_kr+0x13>
c0101035:	b8 00 00 00 00       	mov    $0x0,%eax
c010103a:	eb 06                	jmp    c0101042 <sem_get_kr+0x19>
	return sem->count;
c010103c:	8b 45 08             	mov    0x8(%ebp),%eax
c010103f:	8b 40 04             	mov    0x4(%eax),%eax
}
c0101042:	5d                   	pop    %ebp
c0101043:	c3                   	ret    

c0101044 <sem_open_kr>:

Semaphore* sem_open_kr(int index, int count){
c0101044:	55                   	push   %ebp
c0101045:	89 e5                	mov    %esp,%ebp
c0101047:	83 ec 10             	sub    $0x10,%esp
	Semaphore* sem = &sems[index];
c010104a:	8b 55 08             	mov    0x8(%ebp),%edx
c010104d:	89 d0                	mov    %edx,%eax
c010104f:	01 c0                	add    %eax,%eax
c0101051:	01 d0                	add    %edx,%eax
c0101053:	c1 e0 02             	shl    $0x2,%eax
c0101056:	05 00 47 1b c0       	add    $0xc01b4700,%eax
c010105b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	sem_init_kr(sem, count);
c010105e:	ff 75 0c             	pushl  0xc(%ebp)
c0101061:	ff 75 fc             	pushl  -0x4(%ebp)
c0101064:	e8 a8 fe ff ff       	call   c0100f11 <sem_init_kr>
c0101069:	83 c4 08             	add    $0x8,%esp
	return sem;
c010106c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010106f:	c9                   	leave  
c0101070:	c3                   	ret    

c0101071 <do_scheduler>:

//PCB* ready;



void do_scheduler(){
c0101071:	55                   	push   %ebp
c0101072:	89 e5                	mov    %esp,%ebp
c0101074:	83 ec 08             	sub    $0x8,%esp
	count ++;
c0101077:	a1 04 50 15 c0       	mov    0xc0155004,%eax
c010107c:	83 c0 01             	add    $0x1,%eax
c010107f:	a3 04 50 15 c0       	mov    %eax,0xc0155004

	if(current == NULL){
c0101084:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101089:	85 c0                	test   %eax,%eax
c010108b:	75 49                	jne    c01010d6 <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c010108d:	83 ec 0c             	sub    $0xc,%esp
c0101090:	68 b0 50 15 c0       	push   $0xc01550b0
c0101095:	e8 9b 12 00 00       	call   c0102335 <ll_pop>
c010109a:	83 c4 10             	add    $0x10,%esp
c010109d:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac

		current->ts = RUNNING;
c01010a2:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010a7:	c7 80 4c 20 00 00 01 	movl   $0x1,0x204c(%eax)
c01010ae:	00 00 00 
		current->timeslice = 0;
c01010b1:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010b6:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01010bd:	00 00 00 

		scheduler_switch(current);
c01010c0:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010c5:	83 ec 0c             	sub    $0xc,%esp
c01010c8:	50                   	push   %eax
c01010c9:	e8 27 f3 ff ff       	call   c01003f5 <scheduler_switch>
c01010ce:	83 c4 10             	add    $0x10,%esp
		return;
c01010d1:	e9 8c 00 00 00       	jmp    c0101162 <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c01010d6:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010db:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c01010e1:	83 f8 03             	cmp    $0x3,%eax
c01010e4:	75 27                	jne    c010110d <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c01010e6:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010eb:	83 ec 08             	sub    $0x8,%esp
c01010ee:	50                   	push   %eax
c01010ef:	68 b4 50 15 c0       	push   $0xc01550b4
c01010f4:	e8 9e 12 00 00       	call   c0102397 <ll_entail>
c01010f9:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c01010fc:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0101103:	00 00 00 
		do_scheduler();
c0101106:	e8 66 ff ff ff       	call   c0101071 <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c010110b:	eb 55                	jmp    c0101162 <do_scheduler+0xf1>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 2 || current->ts == STOP){
c010110d:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101112:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0101118:	83 f8 02             	cmp    $0x2,%eax
c010111b:	77 10                	ja     c010112d <do_scheduler+0xbc>
c010111d:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101122:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c0101128:	83 f8 02             	cmp    $0x2,%eax
c010112b:	75 35                	jne    c0101162 <do_scheduler+0xf1>

		current->ts = READY;
c010112d:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101132:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0101139:	00 00 00 

		ll_entail(&ready_list, current);
c010113c:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101141:	83 ec 08             	sub    $0x8,%esp
c0101144:	50                   	push   %eax
c0101145:	68 b0 50 15 c0       	push   $0xc01550b0
c010114a:	e8 48 12 00 00       	call   c0102397 <ll_entail>
c010114f:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c0101152:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0101159:	00 00 00 
		do_scheduler();
c010115c:	e8 10 ff ff ff       	call   c0101071 <do_scheduler>
		//scheduler_switch(current);
		return;
c0101161:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0101162:	c9                   	leave  
c0101163:	c3                   	ret    

c0101164 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0101164:	55                   	push   %ebp
c0101165:	89 e5                	mov    %esp,%ebp
c0101167:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c010116a:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010116f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101172:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0101178:	8b 45 08             	mov    0x8(%ebp),%eax
c010117b:	8b 40 30             	mov    0x30(%eax),%eax
c010117e:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		else {
			//printk("IRQ::%d\n", tf->irq);
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0101183:	8b 45 08             	mov    0x8(%ebp),%eax
c0101186:	8b 40 30             	mov    0x30(%eax),%eax
c0101189:	3d 80 00 00 00       	cmp    $0x80,%eax
c010118e:	75 0e                	jne    c010119e <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c0101190:	83 ec 0c             	sub    $0xc,%esp
c0101193:	ff 75 08             	pushl  0x8(%ebp)
c0101196:	e8 dd 0c 00 00       	call   c0101e78 <do_syscall>
c010119b:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c010119e:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a1:	8b 40 30             	mov    0x30(%eax),%eax
c01011a4:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c01011a9:	75 0f                	jne    c01011ba <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c01011ab:	e8 a9 1b 00 00       	call   c0102d59 <do_timer>
		do_scheduler();
c01011b0:	e8 bc fe ff ff       	call   c0101071 <do_scheduler>
c01011b5:	e9 83 00 00 00       	jmp    c010123d <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c01011ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01011bd:	8b 40 30             	mov    0x30(%eax),%eax
c01011c0:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c01011c5:	75 76                	jne    c010123d <irq_handle+0xd9>
c01011c7:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01011ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01011d1:	89 c2                	mov    %eax,%edx
c01011d3:	ec                   	in     (%dx),%al
c01011d4:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c01011d7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c01011db:	0f b6 c0             	movzbl %al,%eax
c01011de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01011e1:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01011e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01011eb:	89 c2                	mov    %eax,%edx
c01011ed:	ec                   	in     (%dx),%al
c01011ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c01011f1:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c01011f5:	0f b6 c0             	movzbl %al,%eax
c01011f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c01011fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01011fe:	83 c8 80             	or     $0xffffff80,%eax
c0101201:	0f b6 c0             	movzbl %al,%eax
c0101204:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c010120b:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010120e:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101212:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101215:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0101216:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101219:	0f b6 c0             	movzbl %al,%eax
c010121c:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0101223:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0101226:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c010122a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010122d:	ee                   	out    %al,(%dx)
		press_key(code);
c010122e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101231:	83 ec 0c             	sub    $0xc,%esp
c0101234:	50                   	push   %eax
c0101235:	e8 64 0b 00 00       	call   c0101d9e <press_key>
c010123a:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
c010123d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101240:	8b 40 30             	mov    0x30(%eax),%eax
c0101243:	3d 80 00 00 00       	cmp    $0x80,%eax
c0101248:	75 1f                	jne    c0101269 <irq_handle+0x105>
c010124a:	8b 45 08             	mov    0x8(%ebp),%eax
c010124d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101250:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101255:	74 0d                	je     c0101264 <irq_handle+0x100>
c0101257:	8b 45 08             	mov    0x8(%ebp),%eax
c010125a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010125d:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101262:	75 05                	jne    c0101269 <irq_handle+0x105>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0101264:	e8 08 fe ff ff       	call   c0101071 <do_scheduler>
	}
}
c0101269:	c9                   	leave  
c010126a:	c3                   	ret    

c010126b <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c010126b:	55                   	push   %ebp
c010126c:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c010126e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101271:	83 e8 01             	sub    $0x1,%eax
c0101274:	66 a3 08 50 15 c0    	mov    %ax,0xc0155008
	data[1] = (uint32_t)addr;
c010127a:	8b 45 08             	mov    0x8(%ebp),%eax
c010127d:	66 a3 0a 50 15 c0    	mov    %ax,0xc015500a
	data[2] = ((uint32_t)addr) >> 16;
c0101283:	8b 45 08             	mov    0x8(%ebp),%eax
c0101286:	c1 e8 10             	shr    $0x10,%eax
c0101289:	66 a3 0c 50 15 c0    	mov    %ax,0xc015500c
	asm volatile("lidt (%0)" : : "r"(data));
c010128f:	b8 08 50 15 c0       	mov    $0xc0155008,%eax
c0101294:	0f 01 18             	lidtl  (%eax)
}
c0101297:	5d                   	pop    %ebp
c0101298:	c3                   	ret    

c0101299 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0101299:	55                   	push   %ebp
c010129a:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c010129c:	8b 45 10             	mov    0x10(%ebp),%eax
c010129f:	89 c2                	mov    %eax,%edx
c01012a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012a4:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c01012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01012b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b4:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c01012b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012bb:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c01012bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01012c2:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012c6:	83 e2 f0             	and    $0xfffffff0,%edx
c01012c9:	83 ca 0e             	or     $0xe,%edx
c01012cc:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c01012cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d2:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012d6:	83 e2 ef             	and    $0xffffffef,%edx
c01012d9:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c01012dc:	8b 45 14             	mov    0x14(%ebp),%eax
c01012df:	83 e0 03             	and    $0x3,%eax
c01012e2:	89 c2                	mov    %eax,%edx
c01012e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e7:	83 e2 03             	and    $0x3,%edx
c01012ea:	89 d1                	mov    %edx,%ecx
c01012ec:	c1 e1 05             	shl    $0x5,%ecx
c01012ef:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c01012f3:	83 e2 9f             	and    $0xffffff9f,%edx
c01012f6:	09 ca                	or     %ecx,%edx
c01012f8:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c01012fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01012fe:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101302:	83 ca 80             	or     $0xffffff80,%edx
c0101305:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0101308:	8b 45 10             	mov    0x10(%ebp),%eax
c010130b:	c1 e8 10             	shr    $0x10,%eax
c010130e:	89 c2                	mov    %eax,%edx
c0101310:	8b 45 08             	mov    0x8(%ebp),%eax
c0101313:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101317:	5d                   	pop    %ebp
c0101318:	c3                   	ret    

c0101319 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0101319:	55                   	push   %ebp
c010131a:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c010131c:	8b 45 10             	mov    0x10(%ebp),%eax
c010131f:	89 c2                	mov    %eax,%edx
c0101321:	8b 45 08             	mov    0x8(%ebp),%eax
c0101324:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0101327:	8b 45 0c             	mov    0xc(%ebp),%eax
c010132a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101331:	8b 45 08             	mov    0x8(%ebp),%eax
c0101334:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0101338:	8b 45 08             	mov    0x8(%ebp),%eax
c010133b:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c010133f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101342:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101346:	83 ca 0f             	or     $0xf,%edx
c0101349:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c010134c:	8b 45 08             	mov    0x8(%ebp),%eax
c010134f:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101353:	83 e2 ef             	and    $0xffffffef,%edx
c0101356:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0101359:	8b 45 14             	mov    0x14(%ebp),%eax
c010135c:	83 e0 03             	and    $0x3,%eax
c010135f:	89 c2                	mov    %eax,%edx
c0101361:	8b 45 08             	mov    0x8(%ebp),%eax
c0101364:	83 e2 03             	and    $0x3,%edx
c0101367:	89 d1                	mov    %edx,%ecx
c0101369:	c1 e1 05             	shl    $0x5,%ecx
c010136c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101370:	83 e2 9f             	and    $0xffffff9f,%edx
c0101373:	09 ca                	or     %ecx,%edx
c0101375:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0101378:	8b 45 08             	mov    0x8(%ebp),%eax
c010137b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010137f:	83 ca 80             	or     $0xffffff80,%edx
c0101382:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0101385:	8b 45 10             	mov    0x10(%ebp),%eax
c0101388:	c1 e8 10             	shr    $0x10,%eax
c010138b:	89 c2                	mov    %eax,%edx
c010138d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101390:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101394:	5d                   	pop    %ebp
c0101395:	c3                   	ret    

c0101396 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0101396:	55                   	push   %ebp
c0101397:	89 e5                	mov    %esp,%ebp
c0101399:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c010139c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013a3:	eb 22                	jmp    c01013c7 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c01013a5:	ba bf 2e 10 c0       	mov    $0xc0102ebf,%edx
c01013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01013ad:	c1 e0 03             	shl    $0x3,%eax
c01013b0:	05 40 79 1b c0       	add    $0xc01b7940,%eax
c01013b5:	6a 00                	push   $0x0
c01013b7:	52                   	push   %edx
c01013b8:	6a 01                	push   $0x1
c01013ba:	50                   	push   %eax
c01013bb:	e8 59 ff ff ff       	call   c0101319 <set_trap>
c01013c0:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c01013c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013c7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01013ce:	7e d5                	jle    c01013a5 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c01013d0:	b8 07 2e 10 c0       	mov    $0xc0102e07,%eax
c01013d5:	6a 00                	push   $0x0
c01013d7:	50                   	push   %eax
c01013d8:	6a 01                	push   $0x1
c01013da:	68 40 79 1b c0       	push   $0xc01b7940
c01013df:	e8 35 ff ff ff       	call   c0101319 <set_trap>
c01013e4:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c01013e7:	b8 10 2e 10 c0       	mov    $0xc0102e10,%eax
c01013ec:	6a 00                	push   $0x0
c01013ee:	50                   	push   %eax
c01013ef:	6a 01                	push   $0x1
c01013f1:	68 48 79 1b c0       	push   $0xc01b7948
c01013f6:	e8 1e ff ff ff       	call   c0101319 <set_trap>
c01013fb:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c01013fe:	b8 19 2e 10 c0       	mov    $0xc0102e19,%eax
c0101403:	6a 00                	push   $0x0
c0101405:	50                   	push   %eax
c0101406:	6a 01                	push   $0x1
c0101408:	68 50 79 1b c0       	push   $0xc01b7950
c010140d:	e8 07 ff ff ff       	call   c0101319 <set_trap>
c0101412:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101415:	b8 22 2e 10 c0       	mov    $0xc0102e22,%eax
c010141a:	6a 00                	push   $0x0
c010141c:	50                   	push   %eax
c010141d:	6a 01                	push   $0x1
c010141f:	68 58 79 1b c0       	push   $0xc01b7958
c0101424:	e8 f0 fe ff ff       	call   c0101319 <set_trap>
c0101429:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c010142c:	b8 2b 2e 10 c0       	mov    $0xc0102e2b,%eax
c0101431:	6a 00                	push   $0x0
c0101433:	50                   	push   %eax
c0101434:	6a 01                	push   $0x1
c0101436:	68 60 79 1b c0       	push   $0xc01b7960
c010143b:	e8 d9 fe ff ff       	call   c0101319 <set_trap>
c0101440:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101443:	b8 34 2e 10 c0       	mov    $0xc0102e34,%eax
c0101448:	6a 00                	push   $0x0
c010144a:	50                   	push   %eax
c010144b:	6a 01                	push   $0x1
c010144d:	68 68 79 1b c0       	push   $0xc01b7968
c0101452:	e8 c2 fe ff ff       	call   c0101319 <set_trap>
c0101457:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c010145a:	b8 3d 2e 10 c0       	mov    $0xc0102e3d,%eax
c010145f:	6a 00                	push   $0x0
c0101461:	50                   	push   %eax
c0101462:	6a 01                	push   $0x1
c0101464:	68 70 79 1b c0       	push   $0xc01b7970
c0101469:	e8 ab fe ff ff       	call   c0101319 <set_trap>
c010146e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0101471:	b8 46 2e 10 c0       	mov    $0xc0102e46,%eax
c0101476:	6a 00                	push   $0x0
c0101478:	50                   	push   %eax
c0101479:	6a 01                	push   $0x1
c010147b:	68 78 79 1b c0       	push   $0xc01b7978
c0101480:	e8 94 fe ff ff       	call   c0101319 <set_trap>
c0101485:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0101488:	b8 4f 2e 10 c0       	mov    $0xc0102e4f,%eax
c010148d:	6a 00                	push   $0x0
c010148f:	50                   	push   %eax
c0101490:	6a 01                	push   $0x1
c0101492:	68 80 79 1b c0       	push   $0xc01b7980
c0101497:	e8 7d fe ff ff       	call   c0101319 <set_trap>
c010149c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c010149f:	b8 58 2e 10 c0       	mov    $0xc0102e58,%eax
c01014a4:	6a 00                	push   $0x0
c01014a6:	50                   	push   %eax
c01014a7:	6a 01                	push   $0x1
c01014a9:	68 88 79 1b c0       	push   $0xc01b7988
c01014ae:	e8 66 fe ff ff       	call   c0101319 <set_trap>
c01014b3:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014b6:	b8 61 2e 10 c0       	mov    $0xc0102e61,%eax
c01014bb:	6a 00                	push   $0x0
c01014bd:	50                   	push   %eax
c01014be:	6a 01                	push   $0x1
c01014c0:	68 90 79 1b c0       	push   $0xc01b7990
c01014c5:	e8 4f fe ff ff       	call   c0101319 <set_trap>
c01014ca:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014cd:	b8 6a 2e 10 c0       	mov    $0xc0102e6a,%eax
c01014d2:	6a 00                	push   $0x0
c01014d4:	50                   	push   %eax
c01014d5:	6a 01                	push   $0x1
c01014d7:	68 98 79 1b c0       	push   $0xc01b7998
c01014dc:	e8 38 fe ff ff       	call   c0101319 <set_trap>
c01014e1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c01014e4:	b8 73 2e 10 c0       	mov    $0xc0102e73,%eax
c01014e9:	6a 00                	push   $0x0
c01014eb:	50                   	push   %eax
c01014ec:	6a 01                	push   $0x1
c01014ee:	68 a0 79 1b c0       	push   $0xc01b79a0
c01014f3:	e8 21 fe ff ff       	call   c0101319 <set_trap>
c01014f8:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c01014fb:	b8 7c 2e 10 c0       	mov    $0xc0102e7c,%eax
c0101500:	6a 00                	push   $0x0
c0101502:	50                   	push   %eax
c0101503:	6a 01                	push   $0x1
c0101505:	68 a8 79 1b c0       	push   $0xc01b79a8
c010150a:	e8 0a fe ff ff       	call   c0101319 <set_trap>
c010150f:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c0101512:	b8 8e 2e 10 c0       	mov    $0xc0102e8e,%eax
c0101517:	6a 03                	push   $0x3
c0101519:	50                   	push   %eax
c010151a:	6a 01                	push   $0x1
c010151c:	68 40 7d 1b c0       	push   $0xc01b7d40
c0101521:	e8 f3 fd ff ff       	call   c0101319 <set_trap>
c0101526:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101529:	b8 9b 2e 10 c0       	mov    $0xc0102e9b,%eax
c010152e:	6a 00                	push   $0x0
c0101530:	50                   	push   %eax
c0101531:	6a 01                	push   $0x1
c0101533:	68 40 7a 1b c0       	push   $0xc01b7a40
c0101538:	e8 5c fd ff ff       	call   c0101299 <set_intr>
c010153d:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c0101540:	b8 a7 2e 10 c0       	mov    $0xc0102ea7,%eax
c0101545:	6a 00                	push   $0x0
c0101547:	50                   	push   %eax
c0101548:	6a 01                	push   $0x1
c010154a:	68 48 7a 1b c0       	push   $0xc01b7a48
c010154f:	e8 45 fd ff ff       	call   c0101299 <set_intr>
c0101554:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101557:	68 00 08 00 00       	push   $0x800
c010155c:	68 40 79 1b c0       	push   $0xc01b7940
c0101561:	e8 05 fd ff ff       	call   c010126b <save_idt>
c0101566:	83 c4 08             	add    $0x8,%esp
}
c0101569:	c9                   	leave  
c010156a:	c3                   	ret    

c010156b <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c010156b:	55                   	push   %ebp
c010156c:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c010156e:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0101573:	cd 80                	int    $0x80
}
c0101575:	5d                   	pop    %ebp
c0101576:	c3                   	ret    

c0101577 <sys_exit>:
static inline void sys_exit(){
c0101577:	55                   	push   %ebp
c0101578:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c010157a:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c010157f:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c0101581:	b8 df 05 00 00       	mov    $0x5df,%eax
c0101586:	cd 80                	int    $0x80
}
c0101588:	5d                   	pop    %ebp
c0101589:	c3                   	ret    

c010158a <sys_fork>:
static inline uint32_t sys_fork(){
c010158a:	55                   	push   %ebp
c010158b:	89 e5                	mov    %esp,%ebp
c010158d:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c0101597:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c010159c:	cd 80                	int    $0x80
c010159e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c01015a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015a4:	c9                   	leave  
c01015a5:	c3                   	ret    

c01015a6 <sys_pid>:
static inline uint32_t sys_pid(){
c01015a6:	55                   	push   %ebp
c01015a7:	89 e5                	mov    %esp,%ebp
c01015a9:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01015ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c01015b3:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c01015b8:	cd 80                	int    $0x80
c01015ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c01015bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <sys_ppid>:
static inline uint32_t sys_ppid(){
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c01015cf:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c01015d4:	cd 80                	int    $0x80
c01015d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c01015d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015dc:	c9                   	leave  
c01015dd:	c3                   	ret    

c01015de <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c01015de:	55                   	push   %ebp
c01015df:	89 e5                	mov    %esp,%ebp
c01015e1:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c01015e2:	b8 de 05 00 00       	mov    $0x5de,%eax
c01015e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01015ea:	89 d3                	mov    %edx,%ebx
c01015ec:	cd 80                	int    $0x80
}
c01015ee:	5b                   	pop    %ebx
c01015ef:	5d                   	pop    %ebp
c01015f0:	c3                   	ret    

c01015f1 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c01015f1:	55                   	push   %ebp
c01015f2:	89 e5                	mov    %esp,%ebp
c01015f4:	83 ec 40             	sub    $0x40,%esp
c01015f7:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c01015fe:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101602:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101606:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101609:	ee                   	out    %al,(%dx)
c010160a:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0101611:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0101615:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101619:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010161c:	ee                   	out    %al,(%dx)
c010161d:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0101624:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0101628:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010162c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010162f:	ee                   	out    %al,(%dx)
c0101630:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0101637:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c010163b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010163f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101642:	ee                   	out    %al,(%dx)
c0101643:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c010164a:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010164e:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101655:	ee                   	out    %al,(%dx)
c0101656:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c010165d:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0101661:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101665:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101668:	ee                   	out    %al,(%dx)
c0101669:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0101670:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0101674:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101678:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010167b:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c010167c:	c9                   	leave  
c010167d:	c3                   	ret    

c010167e <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c010167e:	55                   	push   %ebp
c010167f:	89 e5                	mov    %esp,%ebp
c0101681:	83 ec 70             	sub    $0x70,%esp
c0101684:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c010168b:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c010168f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101693:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101696:	ee                   	out    %al,(%dx)
c0101697:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c010169e:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01016a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01016a9:	ee                   	out    %al,(%dx)
c01016aa:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01016b1:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01016b5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01016b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01016bc:	ee                   	out    %al,(%dx)
c01016bd:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c01016c4:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01016c8:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01016cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01016cf:	ee                   	out    %al,(%dx)
c01016d0:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01016d7:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01016db:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01016df:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01016e2:	ee                   	out    %al,(%dx)
c01016e3:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c01016ea:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c01016ee:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01016f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01016f5:	ee                   	out    %al,(%dx)
c01016f6:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c01016fd:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0101701:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101705:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101708:	ee                   	out    %al,(%dx)
c0101709:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0101710:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101714:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0101718:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010171b:	ee                   	out    %al,(%dx)
c010171c:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0101723:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0101727:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c010172b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010172e:	ee                   	out    %al,(%dx)
c010172f:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0101736:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c010173a:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c010173e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0101741:	ee                   	out    %al,(%dx)
c0101742:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0101749:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c010174d:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0101751:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101754:	ee                   	out    %al,(%dx)
c0101755:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c010175c:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c0101760:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101764:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101767:	ee                   	out    %al,(%dx)
c0101768:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010176f:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c0101773:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0101777:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010177a:	ee                   	out    %al,(%dx)
c010177b:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c0101782:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0101786:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c010178a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c010178e:	c9                   	leave  
c010178f:	c3                   	ret    

c0101790 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0101790:	55                   	push   %ebp
c0101791:	89 e5                	mov    %esp,%ebp
c0101793:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0101796:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c010179d:	0f b6 05 00 70 10 c0 	movzbl 0xc0107000,%eax
c01017a4:	0f b6 c0             	movzbl %al,%eax
c01017a7:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01017ae:	88 45 f7             	mov    %al,-0x9(%ebp)
c01017b1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01017b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01017b8:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01017b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017bc:	0f b6 c0             	movzbl %al,%eax
c01017bf:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01017c6:	88 45 ef             	mov    %al,-0x11(%ebp)
c01017c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01017cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017d0:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01017d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017d4:	c1 f8 08             	sar    $0x8,%eax
c01017d7:	0f b6 c0             	movzbl %al,%eax
c01017da:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c01017e1:	88 45 e7             	mov    %al,-0x19(%ebp)
c01017e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01017e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
}
c01017ec:	c9                   	leave  
c01017ed:	c3                   	ret    

c01017ee <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c01017ee:	55                   	push   %ebp
c01017ef:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c01017f1:	e8 75 fd ff ff       	call   c010156b <sys_handout>
  }
c01017f6:	eb f9                	jmp    c01017f1 <idle+0x3>

c01017f8 <busy>:
}
void busy(){
c01017f8:	55                   	push   %ebp
c01017f9:	89 e5                	mov    %esp,%ebp
c01017fb:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c01017fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c0101805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c010180c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101813:	eb 11                	jmp    c0101826 <busy+0x2e>
    if(fork()!=0){
c0101815:	e8 70 fd ff ff       	call   c010158a <sys_fork>
c010181a:	85 c0                	test   %eax,%eax
c010181c:	74 04                	je     c0101822 <busy+0x2a>
        j++;
c010181e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c0101822:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101826:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c010182a:	76 e9                	jbe    c0101815 <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c010182c:	e8 75 fd ff ff       	call   c01015a6 <sys_pid>
c0101831:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c0101834:	e8 89 fd ff ff       	call   c01015c2 <sys_ppid>
c0101839:	ff 75 f0             	pushl  -0x10(%ebp)
c010183c:	50                   	push   %eax
c010183d:	ff 75 e8             	pushl  -0x18(%ebp)
c0101840:	68 3c 33 10 c0       	push   $0xc010333c
c0101845:	e8 d3 19 00 00       	call   c010321d <printf>
c010184a:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c010184d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c0101854:	e8 12 fd ff ff       	call   c010156b <sys_handout>
    sleep(pid);
c0101859:	83 ec 0c             	sub    $0xc,%esp
c010185c:	ff 75 e8             	pushl  -0x18(%ebp)
c010185f:	e8 7a fd ff ff       	call   c01015de <sys_sleep>
c0101864:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0101867:	ff 75 ec             	pushl  -0x14(%ebp)
c010186a:	ff 75 e8             	pushl  -0x18(%ebp)
c010186d:	ff 75 e8             	pushl  -0x18(%ebp)
c0101870:	68 7c 33 10 c0       	push   $0xc010337c
c0101875:	e8 a3 19 00 00       	call   c010321d <printf>
c010187a:	83 c4 10             	add    $0x10,%esp
    times++;
c010187d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c0101881:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0101885:	76 15                	jbe    c010189c <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0101887:	83 ec 0c             	sub    $0xc,%esp
c010188a:	68 a0 33 10 c0       	push   $0xc01033a0
c010188f:	e8 89 19 00 00       	call   c010321d <printf>
c0101894:	83 c4 10             	add    $0x10,%esp
      exit();
c0101897:	e8 db fc ff ff       	call   c0101577 <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c010189c:	eb b6                	jmp    c0101854 <busy+0x5c>

c010189e <main>:
}
void do_scheduler();
int main(){
c010189e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c01018a2:	83 e4 f0             	and    $0xfffffff0,%esp
c01018a5:	ff 71 fc             	pushl  -0x4(%ecx)
c01018a8:	55                   	push   %ebp
c01018a9:	89 e5                	mov    %esp,%ebp
c01018ab:	51                   	push   %ecx
c01018ac:	83 ec 14             	sub    $0x14,%esp
  init_page();
c01018af:	e8 77 e8 ff ff       	call   c010012b <init_page>
  init_segment();
c01018b4:	e8 23 ea ff ff       	call   c01002dc <init_segment>
	init_serial();
c01018b9:	e8 33 fd ff ff       	call   c01015f1 <init_serial>
	init_timer();
c01018be:	e8 cd fe ff ff       	call   c0101790 <init_timer>
	init_idt();
c01018c3:	e8 ce fa ff ff       	call   c0101396 <init_idt>
	init_intr();
c01018c8:	e8 b1 fd ff ff       	call   c010167e <init_intr>
  init_pcb_pool();
c01018cd:	e8 a0 0b 00 00       	call   c0102472 <init_pcb_pool>

  PCB* pidle = pcb_create();
c01018d2:	e8 06 0d 00 00       	call   c01025dd <pcb_create>
c01018d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c01018da:	83 ec 08             	sub    $0x8,%esp
c01018dd:	68 ee 17 10 c0       	push   $0xc01017ee
c01018e2:	ff 75 f4             	pushl  -0xc(%ebp)
c01018e5:	e8 15 04 00 00       	call   c0101cff <empty_loader>
c01018ea:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c01018ed:	e8 eb 0c 00 00       	call   c01025dd <pcb_create>
c01018f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c01018f5:	83 ec 08             	sub    $0x8,%esp
c01018f8:	68 00 90 01 00       	push   $0x19000
c01018fd:	ff 75 f0             	pushl  -0x10(%ebp)
c0101900:	e8 62 02 00 00       	call   c0101b67 <loader>
c0101905:	83 c4 10             	add    $0x10,%esp

  enready_pcb(pidle);
c0101908:	83 ec 0c             	sub    $0xc,%esp
c010190b:	ff 75 f4             	pushl  -0xc(%ebp)
c010190e:	e8 ca 0d 00 00       	call   c01026dd <enready_pcb>
c0101913:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c0101916:	83 ec 0c             	sub    $0xc,%esp
c0101919:	ff 75 f0             	pushl  -0x10(%ebp)
c010191c:	e8 bc 0d 00 00       	call   c01026dd <enready_pcb>
c0101921:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c0101924:	e8 b4 0c 00 00       	call   c01025dd <pcb_create>
c0101929:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(app, 2*102400);
c010192c:	83 ec 08             	sub    $0x8,%esp
c010192f:	68 00 20 03 00       	push   $0x32000
c0101934:	ff 75 ec             	pushl  -0x14(%ebp)
c0101937:	e8 2b 02 00 00       	call   c0101b67 <loader>
c010193c:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c010193f:	83 ec 0c             	sub    $0xc,%esp
c0101942:	ff 75 ec             	pushl  -0x14(%ebp)
c0101945:	e8 93 0d 00 00       	call   c01026dd <enready_pcb>
c010194a:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c010194d:	e8 1f f7 ff ff       	call   c0101071 <do_scheduler>

  while(1);
c0101952:	eb fe                	jmp    c0101952 <main+0xb4>

c0101954 <serial_idle>:

static inline
int serial_idle(void) {
c0101954:	55                   	push   %ebp
c0101955:	89 e5                	mov    %esp,%ebp
c0101957:	83 ec 10             	sub    $0x10,%esp
c010195a:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101964:	89 c2                	mov    %eax,%edx
c0101966:	ec                   	in     (%dx),%al
c0101967:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010196a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010196e:	0f b6 c0             	movzbl %al,%eax
c0101971:	83 e0 20             	and    $0x20,%eax
c0101974:	85 c0                	test   %eax,%eax
c0101976:	0f 95 c0             	setne  %al
c0101979:	0f b6 c0             	movzbl %al,%eax
}
c010197c:	c9                   	leave  
c010197d:	c3                   	ret    

c010197e <serial_printc>:

static inline
void serial_printc(char ch) {
c010197e:	55                   	push   %ebp
c010197f:	89 e5                	mov    %esp,%ebp
c0101981:	83 ec 14             	sub    $0x14,%esp
c0101984:	8b 45 08             	mov    0x8(%ebp),%eax
c0101987:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010198a:	90                   	nop
c010198b:	e8 c4 ff ff ff       	call   c0101954 <serial_idle>
c0101990:	85 c0                	test   %eax,%eax
c0101992:	74 f7                	je     c010198b <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101994:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101998:	0f b6 c0             	movzbl %al,%eax
c010199b:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01019a2:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01019a5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01019ac:	ee                   	out    %al,(%dx)
}
c01019ad:	c9                   	leave  
c01019ae:	c3                   	ret    

c01019af <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01019af:	55                   	push   %ebp
c01019b0:	89 e5                	mov    %esp,%ebp
c01019b2:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01019b5:	8d 45 0c             	lea    0xc(%ebp),%eax
c01019b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01019bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019be:	83 ec 04             	sub    $0x4,%esp
c01019c1:	ff 75 f4             	pushl  -0xc(%ebp)
c01019c4:	50                   	push   %eax
c01019c5:	68 7e 19 10 c0       	push   $0xc010197e
c01019ca:	e8 b4 15 00 00       	call   c0102f83 <vfprintf>
c01019cf:	83 c4 10             	add    $0x10,%esp
}
c01019d2:	c9                   	leave  
c01019d3:	c3                   	ret    

c01019d4 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c01019d4:	55                   	push   %ebp
c01019d5:	89 e5                	mov    %esp,%ebp
c01019d7:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c01019da:	90                   	nop
c01019db:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e5:	89 c2                	mov    %eax,%edx
c01019e7:	ec                   	in     (%dx),%al
c01019e8:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01019eb:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01019ef:	0f b6 c0             	movzbl %al,%eax
c01019f2:	25 c0 00 00 00       	and    $0xc0,%eax
c01019f7:	83 f8 40             	cmp    $0x40,%eax
c01019fa:	75 df                	jne    c01019db <waitdisk+0x7>
}
c01019fc:	c9                   	leave  
c01019fd:	c3                   	ret    

c01019fe <readsect>:

static inline void
readsect(void *dst, int offset) {
c01019fe:	55                   	push   %ebp
c01019ff:	89 e5                	mov    %esp,%ebp
c0101a01:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101a04:	e8 cb ff ff ff       	call   c01019d4 <waitdisk>
c0101a09:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0101a10:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101a14:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101a18:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101a1b:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a1f:	0f b6 c0             	movzbl %al,%eax
c0101a22:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101a29:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101a2c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101a30:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101a33:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101a34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a37:	c1 f8 08             	sar    $0x8,%eax
c0101a3a:	0f b6 c0             	movzbl %al,%eax
c0101a3d:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101a44:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101a47:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101a4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101a4e:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a52:	c1 f8 10             	sar    $0x10,%eax
c0101a55:	0f b6 c0             	movzbl %al,%eax
c0101a58:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101a5f:	88 45 df             	mov    %al,-0x21(%ebp)
c0101a62:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101a66:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101a69:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a6d:	c1 f8 18             	sar    $0x18,%eax
c0101a70:	83 c8 e0             	or     $0xffffffe0,%eax
c0101a73:	0f b6 c0             	movzbl %al,%eax
c0101a76:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101a7d:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101a80:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101a84:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101a87:	ee                   	out    %al,(%dx)
c0101a88:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101a8f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101a93:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101a97:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101a9a:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101a9b:	e8 34 ff ff ff       	call   c01019d4 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101aa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101aa7:	eb 29                	jmp    c0101ad2 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101ab9:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101ac0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ac3:	89 c2                	mov    %eax,%edx
c0101ac5:	ed                   	in     (%dx),%eax
c0101ac6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101acc:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101ace:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ad2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101ad6:	7e d1                	jle    c0101aa9 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101ad8:	c9                   	leave  
c0101ad9:	c3                   	ret    

c0101ada <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101ada:	55                   	push   %ebp
c0101adb:	89 e5                	mov    %esp,%ebp
c0101add:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae6:	01 d0                	add    %edx,%eax
c0101ae8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101aeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101aee:	99                   	cltd   
c0101aef:	c1 ea 17             	shr    $0x17,%edx
c0101af2:	01 d0                	add    %edx,%eax
c0101af4:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101af9:	29 d0                	sub    %edx,%eax
c0101afb:	f7 d8                	neg    %eax
c0101afd:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0101b00:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b03:	99                   	cltd   
c0101b04:	c1 ea 17             	shr    $0x17,%edx
c0101b07:	01 d0                	add    %edx,%eax
c0101b09:	c1 f8 09             	sar    $0x9,%eax
c0101b0c:	83 c0 01             	add    $0x1,%eax
c0101b0f:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101b12:	eb 19                	jmp    c0101b2d <readseg+0x53>
        readsect(pa, offset);
c0101b14:	ff 75 10             	pushl  0x10(%ebp)
c0101b17:	ff 75 08             	pushl  0x8(%ebp)
c0101b1a:	e8 df fe ff ff       	call   c01019fe <readsect>
c0101b1f:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101b22:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0101b29:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101b33:	72 df                	jb     c0101b14 <readseg+0x3a>
        readsect(pa, offset);
c0101b35:	c9                   	leave  
c0101b36:	c3                   	ret    

c0101b37 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101b37:	55                   	push   %ebp
c0101b38:	89 e5                	mov    %esp,%ebp
c0101b3a:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101b3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b40:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101b45:	77 16                	ja     c0101b5d <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101b47:	ff 75 10             	pushl  0x10(%ebp)
c0101b4a:	68 c0 33 10 c0       	push   $0xc01033c0
c0101b4f:	ff 75 0c             	pushl  0xc(%ebp)
c0101b52:	ff 75 08             	pushl  0x8(%ebp)
c0101b55:	e8 55 fe ff ff       	call   c01019af <printk>
c0101b5a:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101b5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b60:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101b65:	c9                   	leave  
c0101b66:	c3                   	ret    

c0101b67 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101b67:	55                   	push   %ebp
c0101b68:	89 e5                	mov    %esp,%ebp
c0101b6a:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b70:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101b76:	83 ec 04             	sub    $0x4,%esp
c0101b79:	50                   	push   %eax
c0101b7a:	6a 17                	push   $0x17
c0101b7c:	68 e3 33 10 c0       	push   $0xc01033e3
c0101b81:	e8 b1 ff ff ff       	call   c0101b37 <_paddr>
c0101b86:	83 c4 10             	add    $0x10,%esp
c0101b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101b8f:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b95:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101b9b:	83 ec 04             	sub    $0x4,%esp
c0101b9e:	68 00 10 00 00       	push   $0x1000
c0101ba3:	6a 00                	push   $0x0
c0101ba5:	50                   	push   %eax
c0101ba6:	e8 e6 ea ff ff       	call   c0100691 <mm_alloc>
c0101bab:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0101bae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bb1:	83 ec 04             	sub    $0x4,%esp
c0101bb4:	50                   	push   %eax
c0101bb5:	68 00 10 00 00       	push   $0x1000
c0101bba:	6a 00                	push   $0x0
c0101bbc:	e8 19 ff ff ff       	call   c0101ada <readseg>
c0101bc1:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0101bc4:	b8 00 00 00 00       	mov    $0x0,%eax
c0101bc9:	8b 00                	mov    (%eax),%eax
c0101bcb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0101bd0:	0f 94 c0             	sete   %al
c0101bd3:	0f b6 c0             	movzbl %al,%eax
c0101bd6:	83 ec 08             	sub    $0x8,%esp
c0101bd9:	50                   	push   %eax
c0101bda:	68 f7 33 10 c0       	push   $0xc01033f7
c0101bdf:	e8 cb fd ff ff       	call   c01019af <printk>
c0101be4:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101be7:	b8 00 00 00 00       	mov    $0x0,%eax
c0101bec:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101bf2:	b8 00 00 00 00       	mov    $0x0,%eax
c0101bf7:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bfb:	0f b7 c0             	movzwl %ax,%eax
c0101bfe:	c1 e0 05             	shl    $0x5,%eax
c0101c01:	89 c2                	mov    %eax,%edx
c0101c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c06:	01 d0                	add    %edx,%eax
c0101c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101c0b:	eb 7f                	jmp    c0101c8c <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0101c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c10:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c13:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c19:	8b 48 14             	mov    0x14(%eax),%ecx
c0101c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c1f:	8b 50 08             	mov    0x8(%eax),%edx
c0101c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c25:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101c2b:	83 ec 04             	sub    $0x4,%esp
c0101c2e:	51                   	push   %ecx
c0101c2f:	52                   	push   %edx
c0101c30:	50                   	push   %eax
c0101c31:	e8 5b ea ff ff       	call   c0100691 <mm_alloc>
c0101c36:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c3c:	8b 50 04             	mov    0x4(%eax),%edx
c0101c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c42:	01 d0                	add    %edx,%eax
c0101c44:	89 c2                	mov    %eax,%edx
c0101c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c49:	8b 40 10             	mov    0x10(%eax),%eax
c0101c4c:	83 ec 04             	sub    $0x4,%esp
c0101c4f:	52                   	push   %edx
c0101c50:	50                   	push   %eax
c0101c51:	ff 75 e8             	pushl  -0x18(%ebp)
c0101c54:	e8 81 fe ff ff       	call   c0101ada <readseg>
c0101c59:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0101c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c5f:	8b 50 10             	mov    0x10(%eax),%edx
c0101c62:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101c65:	01 d0                	add    %edx,%eax
c0101c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101c6a:	eb 0c                	jmp    c0101c78 <loader+0x111>
c0101c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c6f:	8d 50 01             	lea    0x1(%eax),%edx
c0101c72:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101c75:	c6 00 00             	movb   $0x0,(%eax)
c0101c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c7b:	8b 50 14             	mov    0x14(%eax),%edx
c0101c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101c81:	01 d0                	add    %edx,%eax
c0101c83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101c86:	77 e4                	ja     c0101c6c <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101c88:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c8f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101c92:	0f 82 75 ff ff ff    	jb     c0101c0d <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101c98:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c9d:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca0:	a3 fc 2e 10 c0       	mov    %eax,0xc0102efc

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101cae:	83 ec 04             	sub    $0x4,%esp
c0101cb1:	68 00 80 00 00       	push   $0x8000
c0101cb6:	68 00 60 bf be       	push   $0xbebf6000
c0101cbb:	50                   	push   %eax
c0101cbc:	e8 d0 e9 ff ff       	call   c0100691 <mm_alloc>
c0101cc1:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x7F, entry, 3);
c0101cc4:	a1 fc 2e 10 c0       	mov    0xc0102efc,%eax
c0101cc9:	6a 03                	push   $0x3
c0101ccb:	50                   	push   %eax
c0101ccc:	68 81 df bf be       	push   $0xbebfdf81
c0101cd1:	ff 75 08             	pushl  0x8(%ebp)
c0101cd4:	e8 d0 07 00 00       	call   c01024a9 <init_pcb>
c0101cd9:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0101cdc:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101ce1:	83 ec 04             	sub    $0x4,%esp
c0101ce4:	50                   	push   %eax
c0101ce5:	6a 39                	push   $0x39
c0101ce7:	68 e3 33 10 c0       	push   $0xc01033e3
c0101cec:	e8 46 fe ff ff       	call   c0101b37 <_paddr>
c0101cf1:	83 c4 10             	add    $0x10,%esp
c0101cf4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101cfa:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0101cfd:	c9                   	leave  
c0101cfe:	c3                   	ret    

c0101cff <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0101cff:	55                   	push   %ebp
c0101d00:	89 e5                	mov    %esp,%ebp
c0101d02:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d08:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101d0e:	83 ec 04             	sub    $0x4,%esp
c0101d11:	50                   	push   %eax
c0101d12:	6a 42                	push   $0x42
c0101d14:	68 e3 33 10 c0       	push   $0xc01033e3
c0101d19:	e8 19 fe ff ff       	call   c0101b37 <_paddr>
c0101d1e:	83 c4 10             	add    $0x10,%esp
c0101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d27:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0101d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d2d:	a3 fc 2e 10 c0       	mov    %eax,0xc0102efc
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x7F, entry, 0);
c0101d32:	a1 fc 2e 10 c0       	mov    0xc0102efc,%eax
c0101d37:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d3a:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0101d40:	83 ea 7f             	sub    $0x7f,%edx
c0101d43:	6a 00                	push   $0x0
c0101d45:	50                   	push   %eax
c0101d46:	52                   	push   %edx
c0101d47:	ff 75 08             	pushl  0x8(%ebp)
c0101d4a:	e8 5a 07 00 00       	call   c01024a9 <init_pcb>
c0101d4f:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0101d52:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101d57:	83 ec 04             	sub    $0x4,%esp
c0101d5a:	50                   	push   %eax
c0101d5b:	6a 46                	push   $0x46
c0101d5d:	68 e3 33 10 c0       	push   $0xc01033e3
c0101d62:	e8 d0 fd ff ff       	call   c0101b37 <_paddr>
c0101d67:	83 c4 10             	add    $0x10,%esp
c0101d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d70:	0f 22 d8             	mov    %eax,%cr3

c0101d73:	c9                   	leave  
c0101d74:	c3                   	ret    

c0101d75 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101d75:	55                   	push   %ebp
c0101d76:	89 e5                	mov    %esp,%ebp
c0101d78:	83 ec 04             	sub    $0x4,%esp
c0101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101d81:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101d85:	83 e8 61             	sub    $0x61,%eax
c0101d88:	8b 04 85 40 50 15 c0 	mov    -0x3feaafc0(,%eax,4),%eax
}
c0101d8f:	c9                   	leave  
c0101d90:	c3                   	ret    

c0101d91 <get_lastkey>:
int8_t get_lastkey(){
c0101d91:	55                   	push   %ebp
c0101d92:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101d94:	a1 a8 50 15 c0       	mov    0xc01550a8,%eax
c0101d99:	83 c0 61             	add    $0x61,%eax
}
c0101d9c:	5d                   	pop    %ebp
c0101d9d:	c3                   	ret    

c0101d9e <press_key>:
void press_key(int code){
c0101d9e:	55                   	push   %ebp
c0101d9f:	89 e5                	mov    %esp,%ebp
c0101da1:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101dab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dae:	25 80 00 00 00       	and    $0x80,%eax
c0101db3:	85 c0                	test   %eax,%eax
c0101db5:	75 35                	jne    c0101dec <press_key+0x4e>
		for(;i<26;i++){
c0101db7:	eb 2b                	jmp    c0101de4 <press_key+0x46>
			if(letter[i]==code){
c0101db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dbc:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101dc3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101dc6:	75 18                	jne    c0101de0 <press_key+0x42>
				keydown[i] = 1;
c0101dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dcb:	c7 04 85 40 50 15 c0 	movl   $0x1,-0x3feaafc0(,%eax,4)
c0101dd2:	01 00 00 00 
				lastkey = i;
c0101dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dd9:	a3 a8 50 15 c0       	mov    %eax,0xc01550a8
				return;
c0101dde:	eb 3b                	jmp    c0101e1b <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101de0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101de4:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101de8:	7e cf                	jle    c0101db9 <press_key+0x1b>
c0101dea:	eb 2f                	jmp    c0101e1b <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101dec:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101df0:	eb 23                	jmp    c0101e15 <press_key+0x77>
			if(letter[i]==code){
c0101df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101df5:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101dfc:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101dff:	75 10                	jne    c0101e11 <press_key+0x73>
				keydown[i] = 0;
c0101e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e04:	c7 04 85 40 50 15 c0 	movl   $0x0,-0x3feaafc0(,%eax,4)
c0101e0b:	00 00 00 00 
				return;
c0101e0f:	eb 0a                	jmp    c0101e1b <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101e11:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101e15:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101e19:	7e d7                	jle    c0101df2 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101e1b:	c9                   	leave  
c0101e1c:	c3                   	ret    

c0101e1d <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101e1d:	55                   	push   %ebp
c0101e1e:	89 e5                	mov    %esp,%ebp
c0101e20:	83 ec 10             	sub    $0x10,%esp
c0101e23:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e2d:	89 c2                	mov    %eax,%edx
c0101e2f:	ec                   	in     (%dx),%al
c0101e30:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101e33:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101e37:	0f b6 c0             	movzbl %al,%eax
c0101e3a:	83 e0 20             	and    $0x20,%eax
c0101e3d:	85 c0                	test   %eax,%eax
c0101e3f:	0f 95 c0             	setne  %al
c0101e42:	0f b6 c0             	movzbl %al,%eax
}
c0101e45:	c9                   	leave  
c0101e46:	c3                   	ret    

c0101e47 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101e47:	55                   	push   %ebp
c0101e48:	89 e5                	mov    %esp,%ebp
c0101e4a:	83 ec 14             	sub    $0x14,%esp
c0101e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e50:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101e53:	90                   	nop
c0101e54:	e8 c4 ff ff ff       	call   c0101e1d <serial_idle>
c0101e59:	85 c0                	test   %eax,%eax
c0101e5b:	74 f7                	je     c0101e54 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101e5d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101e61:	0f b6 c0             	movzbl %al,%eax
c0101e64:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101e6b:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101e6e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101e72:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101e75:	ee                   	out    %al,(%dx)
}
c0101e76:	c9                   	leave  
c0101e77:	c3                   	ret    

c0101e78 <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101e78:	55                   	push   %ebp
c0101e79:	89 e5                	mov    %esp,%ebp
c0101e7b:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e81:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e84:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101e89:	0f 84 6d 02 00 00    	je     c01020fc <do_syscall+0x284>
c0101e8f:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101e94:	0f 87 97 00 00 00    	ja     c0101f31 <do_syscall+0xb9>
c0101e9a:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101e9f:	0f 84 9c 02 00 00    	je     c0102141 <do_syscall+0x2c9>
c0101ea5:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101eaa:	77 3d                	ja     c0101ee9 <do_syscall+0x71>
c0101eac:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101eb1:	0f 84 70 02 00 00    	je     c0102127 <do_syscall+0x2af>
c0101eb7:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101ebc:	77 10                	ja     c0101ece <do_syscall+0x56>
c0101ebe:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101ec3:	0f 84 47 02 00 00    	je     c0102110 <do_syscall+0x298>
c0101ec9:	e9 c8 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101ece:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101ed3:	0f 84 55 02 00 00    	je     c010212e <do_syscall+0x2b6>
c0101ed9:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101ede:	0f 84 51 02 00 00    	je     c0102135 <do_syscall+0x2bd>
c0101ee4:	e9 ad 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101ee9:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101eee:	0f 84 f4 01 00 00    	je     c01020e8 <do_syscall+0x270>
c0101ef4:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101ef9:	77 1b                	ja     c0101f16 <do_syscall+0x9e>
c0101efb:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101f00:	0f 84 62 02 00 00    	je     c0102168 <do_syscall+0x2f0>
c0101f06:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101f0b:	0f 84 77 02 00 00    	je     c0102188 <do_syscall+0x310>
c0101f11:	e9 80 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101f16:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101f1b:	0f 84 70 01 00 00    	je     c0102091 <do_syscall+0x219>
c0101f21:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101f26:	0f 84 91 01 00 00    	je     c01020bd <do_syscall+0x245>
c0101f2c:	e9 65 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101f31:	3d 40 06 00 00       	cmp    $0x640,%eax
c0101f36:	74 78                	je     c0101fb0 <do_syscall+0x138>
c0101f38:	3d 40 06 00 00       	cmp    $0x640,%eax
c0101f3d:	77 31                	ja     c0101f70 <do_syscall+0xf8>
c0101f3f:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101f44:	0f 84 5d 01 00 00    	je     c01020a7 <do_syscall+0x22f>
c0101f4a:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101f4f:	0f 82 b1 01 00 00    	jb     c0102106 <do_syscall+0x28e>
c0101f55:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0101f5a:	0f 84 1a 01 00 00    	je     c010207a <do_syscall+0x202>
c0101f60:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0101f65:	0f 84 f1 00 00 00    	je     c010205c <do_syscall+0x1e4>
c0101f6b:	e9 26 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101f70:	3d 43 06 00 00       	cmp    $0x643,%eax
c0101f75:	0f 84 94 00 00 00    	je     c010200f <do_syscall+0x197>
c0101f7b:	3d 43 06 00 00       	cmp    $0x643,%eax
c0101f80:	77 13                	ja     c0101f95 <do_syscall+0x11d>
c0101f82:	3d 41 06 00 00       	cmp    $0x641,%eax
c0101f87:	74 47                	je     c0101fd0 <do_syscall+0x158>
c0101f89:	3d 42 06 00 00       	cmp    $0x642,%eax
c0101f8e:	74 68                	je     c0101ff8 <do_syscall+0x180>
c0101f90:	e9 01 02 00 00       	jmp    c0102196 <do_syscall+0x31e>
c0101f95:	3d 44 06 00 00       	cmp    $0x644,%eax
c0101f9a:	0f 84 86 00 00 00    	je     c0102026 <do_syscall+0x1ae>
c0101fa0:	3d 45 06 00 00       	cmp    $0x645,%eax
c0101fa5:	0f 84 92 00 00 00    	je     c010203d <do_syscall+0x1c5>
c0101fab:	e9 e6 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb3:	8b 40 18             	mov    0x18(%eax),%eax
c0101fb6:	89 c2                	mov    %eax,%edx
c0101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbb:	8b 40 10             	mov    0x10(%eax),%eax
c0101fbe:	83 ec 08             	sub    $0x8,%esp
c0101fc1:	52                   	push   %edx
c0101fc2:	50                   	push   %eax
c0101fc3:	e8 49 ef ff ff       	call   c0100f11 <sem_init_kr>
c0101fc8:	83 c4 10             	add    $0x10,%esp
		break;
c0101fcb:	e9 c6 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd3:	8b 40 18             	mov    0x18(%eax),%eax
c0101fd6:	89 c2                	mov    %eax,%edx
c0101fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fdb:	8b 40 10             	mov    0x10(%eax),%eax
c0101fde:	83 ec 08             	sub    $0x8,%esp
c0101fe1:	52                   	push   %edx
c0101fe2:	50                   	push   %eax
c0101fe3:	e8 5c f0 ff ff       	call   c0101044 <sem_open_kr>
c0101fe8:	83 c4 10             	add    $0x10,%esp
c0101feb:	89 c2                	mov    %eax,%edx
c0101fed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff0:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101ff3:	e9 9e 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ffb:	8b 40 10             	mov    0x10(%eax),%eax
c0101ffe:	83 ec 0c             	sub    $0xc,%esp
c0102001:	50                   	push   %eax
c0102002:	e8 76 ef ff ff       	call   c0100f7d <sem_post_kr>
c0102007:	83 c4 10             	add    $0x10,%esp
		break;
c010200a:	e9 87 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c010200f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102012:	8b 40 10             	mov    0x10(%eax),%eax
c0102015:	83 ec 0c             	sub    $0xc,%esp
c0102018:	50                   	push   %eax
c0102019:	e8 b3 ef ff ff       	call   c0100fd1 <sem_wait_kr>
c010201e:	83 c4 10             	add    $0x10,%esp
		break;
c0102021:	e9 70 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0102026:	8b 45 08             	mov    0x8(%ebp),%eax
c0102029:	8b 40 10             	mov    0x10(%eax),%eax
c010202c:	83 ec 0c             	sub    $0xc,%esp
c010202f:	50                   	push   %eax
c0102030:	e8 fc ee ff ff       	call   c0100f31 <sem_close_kr>
c0102035:	83 c4 10             	add    $0x10,%esp
		break;
c0102038:	e9 59 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c010203d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102040:	8b 40 10             	mov    0x10(%eax),%eax
c0102043:	83 ec 0c             	sub    $0xc,%esp
c0102046:	50                   	push   %eax
c0102047:	e8 dd ef ff ff       	call   c0101029 <sem_get_kr>
c010204c:	83 c4 10             	add    $0x10,%esp
c010204f:	89 c2                	mov    %eax,%edx
c0102051:	8b 45 08             	mov    0x8(%ebp),%eax
c0102054:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102057:	e9 3a 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx);
c010205c:	8b 45 08             	mov    0x8(%ebp),%eax
c010205f:	8b 50 18             	mov    0x18(%eax),%edx
c0102062:	8b 45 08             	mov    0x8(%ebp),%eax
c0102065:	8b 40 10             	mov    0x10(%eax),%eax
c0102068:	83 ec 08             	sub    $0x8,%esp
c010206b:	52                   	push   %edx
c010206c:	50                   	push   %eax
c010206d:	e8 ec 08 00 00       	call   c010295e <thread_current>
c0102072:	83 c4 10             	add    $0x10,%esp
		break;
c0102075:	e9 1c 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_JOIN:
			join_current(tf->ebx);
c010207a:	8b 45 08             	mov    0x8(%ebp),%eax
c010207d:	8b 40 10             	mov    0x10(%eax),%eax
c0102080:	83 ec 0c             	sub    $0xc,%esp
c0102083:	50                   	push   %eax
c0102084:	e8 2c 0a 00 00       	call   c0102ab5 <join_current>
c0102089:	83 c4 10             	add    $0x10,%esp
		break;
c010208c:	e9 05 01 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_PID:
			tf->eax = current->pid;
c0102091:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102096:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c010209c:	8b 45 08             	mov    0x8(%ebp),%eax
c010209f:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01020a2:	e9 ef 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_PPID:
			tf->eax = current->ppid;
c01020a7:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01020ac:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c01020b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b5:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01020b8:	e9 d9 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c01020bd:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01020c2:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c01020c9:	00 00 00 
			current->timeslice = tf->ebx*200;
c01020cc:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01020d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01020d4:	8b 52 10             	mov    0x10(%edx),%edx
c01020d7:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c01020dd:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c01020e3:	e9 ae 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_HANDOUT:
			current->ts = STOP;
c01020e8:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01020ed:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c01020f4:	00 00 00 
		break;
c01020f7:	e9 9a 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_EXIT:
			exit_current();
c01020fc:	e8 47 09 00 00       	call   c0102a48 <exit_current>
		break;
c0102101:	e9 90 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_FORK:
			fork_current();
c0102106:	e8 e1 07 00 00       	call   c01028ec <fork_current>
		break;
c010210b:	e9 86 00 00 00       	jmp    c0102196 <do_syscall+0x31e>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0102110:	8b 45 08             	mov    0x8(%ebp),%eax
c0102113:	8b 40 10             	mov    0x10(%eax),%eax
c0102116:	0f be c0             	movsbl %al,%eax
c0102119:	83 ec 0c             	sub    $0xc,%esp
c010211c:	50                   	push   %eax
c010211d:	e8 25 fd ff ff       	call   c0101e47 <serial_printc>
c0102122:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0102125:	eb 6f                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_INIT_CACHE:
			initVCache();
c0102127:	e8 50 0a 00 00       	call   c0102b7c <initVCache>
		break;
c010212c:	eb 68                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c010212e:	e8 7e 0b 00 00       	call   c0102cb1 <clearVRAM>
		break;
c0102133:	eb 61                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0102135:	e8 77 0b 00 00       	call   c0102cb1 <clearVRAM>
			flushVCache();
c010213a:	e8 a6 0a 00 00       	call   c0102be5 <flushVCache>
		break;
c010213f:	eb 55                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0102141:	8b 45 08             	mov    0x8(%ebp),%eax
c0102144:	8b 40 14             	mov    0x14(%eax),%eax
c0102147:	0f b6 c0             	movzbl %al,%eax
c010214a:	8b 55 08             	mov    0x8(%ebp),%edx
c010214d:	8b 52 18             	mov    0x18(%edx),%edx
c0102150:	89 d1                	mov    %edx,%ecx
c0102152:	8b 55 08             	mov    0x8(%ebp),%edx
c0102155:	8b 52 10             	mov    0x10(%edx),%edx
c0102158:	83 ec 04             	sub    $0x4,%esp
c010215b:	50                   	push   %eax
c010215c:	51                   	push   %ecx
c010215d:	52                   	push   %edx
c010215e:	e8 e7 0a 00 00       	call   c0102c4a <setPixelAt>
c0102163:	83 c4 10             	add    $0x10,%esp
		break;
c0102166:	eb 2e                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0102168:	8b 45 08             	mov    0x8(%ebp),%eax
c010216b:	8b 40 10             	mov    0x10(%eax),%eax
c010216e:	0f be c0             	movsbl %al,%eax
c0102171:	83 ec 0c             	sub    $0xc,%esp
c0102174:	50                   	push   %eax
c0102175:	e8 fb fb ff ff       	call   c0101d75 <get_key>
c010217a:	83 c4 10             	add    $0x10,%esp
c010217d:	0f be d0             	movsbl %al,%edx
c0102180:	8b 45 08             	mov    0x8(%ebp),%eax
c0102183:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102186:	eb 0e                	jmp    c0102196 <do_syscall+0x31e>
		case SYS_GET_TICK:
			tf->eax = tick();
c0102188:	e8 70 0c 00 00       	call   c0102dfd <tick>
c010218d:	89 c2                	mov    %eax,%edx
c010218f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102192:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0102195:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0102196:	c9                   	leave  
c0102197:	c3                   	ret    

c0102198 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102198:	55                   	push   %ebp
c0102199:	89 e5                	mov    %esp,%ebp
c010219b:	83 ec 10             	sub    $0x10,%esp
c010219e:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	89 c2                	mov    %eax,%edx
c01021aa:	ec                   	in     (%dx),%al
c01021ab:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01021ae:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01021b2:	0f b6 c0             	movzbl %al,%eax
c01021b5:	83 e0 20             	and    $0x20,%eax
c01021b8:	85 c0                	test   %eax,%eax
c01021ba:	0f 95 c0             	setne  %al
c01021bd:	0f b6 c0             	movzbl %al,%eax
}
c01021c0:	c9                   	leave  
c01021c1:	c3                   	ret    

c01021c2 <serial_printc>:

static inline
void serial_printc(char ch) {
c01021c2:	55                   	push   %ebp
c01021c3:	89 e5                	mov    %esp,%ebp
c01021c5:	83 ec 14             	sub    $0x14,%esp
c01021c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01021cb:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01021ce:	90                   	nop
c01021cf:	e8 c4 ff ff ff       	call   c0102198 <serial_idle>
c01021d4:	85 c0                	test   %eax,%eax
c01021d6:	74 f7                	je     c01021cf <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01021d8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01021dc:	0f b6 c0             	movzbl %al,%eax
c01021df:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01021e6:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01021e9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01021ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01021f0:	ee                   	out    %al,(%dx)
}
c01021f1:	c9                   	leave  
c01021f2:	c3                   	ret    

c01021f3 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01021f3:	55                   	push   %ebp
c01021f4:	89 e5                	mov    %esp,%ebp
c01021f6:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01021f9:	8d 45 0c             	lea    0xc(%ebp),%eax
c01021fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01021ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102202:	83 ec 04             	sub    $0x4,%esp
c0102205:	ff 75 f4             	pushl  -0xc(%ebp)
c0102208:	50                   	push   %eax
c0102209:	68 c2 21 10 c0       	push   $0xc01021c2
c010220e:	e8 70 0d 00 00       	call   c0102f83 <vfprintf>
c0102213:	83 c4 10             	add    $0x10,%esp
}
c0102216:	c9                   	leave  
c0102217:	c3                   	ret    

c0102218 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0102218:	55                   	push   %ebp
c0102219:	89 e5                	mov    %esp,%ebp
c010221b:	57                   	push   %edi
c010221c:	56                   	push   %esi
c010221d:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c010221e:	8b 45 10             	mov    0x10(%ebp),%eax
c0102221:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102224:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102227:	89 c1                	mov    %eax,%ecx
c0102229:	89 d6                	mov    %edx,%esi
c010222b:	89 df                	mov    %ebx,%edi
c010222d:	fc                   	cld    
c010222e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102230:	5b                   	pop    %ebx
c0102231:	5e                   	pop    %esi
c0102232:	5f                   	pop    %edi
c0102233:	5d                   	pop    %ebp
c0102234:	c3                   	ret    

c0102235 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0102235:	55                   	push   %ebp
c0102236:	89 e5                	mov    %esp,%ebp
c0102238:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c010223b:	8b 45 10             	mov    0x10(%ebp),%eax
c010223e:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0102243:	77 16                	ja     c010225b <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102245:	ff 75 10             	pushl  0x10(%ebp)
c0102248:	68 0c 34 10 c0       	push   $0xc010340c
c010224d:	ff 75 0c             	pushl  0xc(%ebp)
c0102250:	ff 75 08             	pushl  0x8(%ebp)
c0102253:	e8 9b ff ff ff       	call   c01021f3 <printk>
c0102258:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c010225b:	8b 45 10             	mov    0x10(%ebp),%eax
c010225e:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102263:	c9                   	leave  
c0102264:	c3                   	ret    

c0102265 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0102265:	55                   	push   %ebp
c0102266:	89 e5                	mov    %esp,%ebp
c0102268:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010226b:	8b 45 10             	mov    0x10(%ebp),%eax
c010226e:	c1 e8 0c             	shr    $0xc,%eax
c0102271:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102276:	76 13                	jbe    c010228b <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0102278:	83 ec 08             	sub    $0x8,%esp
c010227b:	ff 75 10             	pushl  0x10(%ebp)
c010227e:	68 30 34 10 c0       	push   $0xc0103430
c0102283:	e8 6b ff ff ff       	call   c01021f3 <printk>
c0102288:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c010228b:	8b 45 10             	mov    0x10(%ebp),%eax
c010228e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102293:	c9                   	leave  
c0102294:	c3                   	ret    

c0102295 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0102295:	55                   	push   %ebp
c0102296:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0102298:	8b 45 08             	mov    0x8(%ebp),%eax
c010229b:	ba 00 47 17 c0       	mov    $0xc0174700,%edx
c01022a0:	29 d0                	sub    %edx,%eax
c01022a2:	c1 f8 03             	sar    $0x3,%eax
c01022a5:	c1 e0 0c             	shl    $0xc,%eax
}
c01022a8:	5d                   	pop    %ebp
c01022a9:	c3                   	ret    

c01022aa <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c01022aa:	55                   	push   %ebp
c01022ab:	89 e5                	mov    %esp,%ebp
c01022ad:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01022b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b3:	c1 e8 0c             	shr    $0xc,%eax
c01022b6:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01022bb:	76 10                	jbe    c01022cd <pa2page+0x23>
		printk("pa2page called with invalid pa");
c01022bd:	83 ec 0c             	sub    $0xc,%esp
c01022c0:	68 54 34 10 c0       	push   $0xc0103454
c01022c5:	e8 29 ff ff ff       	call   c01021f3 <printk>
c01022ca:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c01022cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d0:	c1 e8 0c             	shr    $0xc,%eax
c01022d3:	c1 e0 03             	shl    $0x3,%eax
c01022d6:	05 00 47 17 c0       	add    $0xc0174700,%eax
}
c01022db:	c9                   	leave  
c01022dc:	c3                   	ret    

c01022dd <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c01022dd:	55                   	push   %ebp
c01022de:	89 e5                	mov    %esp,%ebp
c01022e0:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01022e3:	ff 75 08             	pushl  0x8(%ebp)
c01022e6:	e8 aa ff ff ff       	call   c0102295 <page2pa>
c01022eb:	83 c4 04             	add    $0x4,%esp
c01022ee:	83 ec 04             	sub    $0x4,%esp
c01022f1:	50                   	push   %eax
c01022f2:	6a 52                	push   $0x52
c01022f4:	68 73 34 10 c0       	push   $0xc0103473
c01022f9:	e8 67 ff ff ff       	call   c0102265 <_kaddr>
c01022fe:	83 c4 10             	add    $0x10,%esp
}
c0102301:	c9                   	leave  
c0102302:	c3                   	ret    

c0102303 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0102303:	55                   	push   %ebp
c0102304:	89 e5                	mov    %esp,%ebp
c0102306:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0102309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0102310:	8b 45 08             	mov    0x8(%ebp),%eax
c0102313:	8b 00                	mov    (%eax),%eax
c0102315:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0102318:	eb 10                	jmp    c010232a <ll_len+0x27>
		p = p->next;
c010231a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010231d:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102323:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0102326:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c010232a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010232e:	75 ea                	jne    c010231a <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0102330:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102333:	c9                   	leave  
c0102334:	c3                   	ret    

c0102335 <ll_pop>:
PCB* ll_pop(PCB** head){
c0102335:	55                   	push   %ebp
c0102336:	89 e5                	mov    %esp,%ebp
c0102338:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c010233b:	8b 45 08             	mov    0x8(%ebp),%eax
c010233e:	8b 00                	mov    (%eax),%eax
c0102340:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c0102343:	83 ec 08             	sub    $0x8,%esp
c0102346:	ff 75 f4             	pushl  -0xc(%ebp)
c0102349:	ff 75 08             	pushl  0x8(%ebp)
c010234c:	e8 a4 00 00 00       	call   c01023f5 <ll_delete>
c0102351:	83 c4 10             	add    $0x10,%esp
	return p;
c0102354:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102357:	c9                   	leave  
c0102358:	c3                   	ret    

c0102359 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0102359:	55                   	push   %ebp
c010235a:	89 e5                	mov    %esp,%ebp
c010235c:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010235f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102362:	8b 00                	mov    (%eax),%eax
c0102364:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0102367:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010236b:	75 0f                	jne    c010237c <ll_push+0x23>
		*head = p;
c010236d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102370:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102373:	89 10                	mov    %edx,(%eax)
		return 0;
c0102375:	b8 00 00 00 00       	mov    $0x0,%eax
c010237a:	eb 19                	jmp    c0102395 <ll_push+0x3c>
	}else{
		*head = p;
c010237c:	8b 45 08             	mov    0x8(%ebp),%eax
c010237f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102382:	89 10                	mov    %edx,(%eax)
		p->next = h;
c0102384:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102387:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010238a:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c0102390:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0102395:	c9                   	leave  
c0102396:	c3                   	ret    

c0102397 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0102397:	55                   	push   %ebp
c0102398:	89 e5                	mov    %esp,%ebp
c010239a:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010239d:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a0:	8b 00                	mov    (%eax),%eax
c01023a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c01023a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01023a8:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c01023af:	00 00 00 
	if(h == NULL){
c01023b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01023b6:	75 0f                	jne    c01023c7 <ll_entail+0x30>
		*head = p;
c01023b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01023be:	89 10                	mov    %edx,(%eax)
		return 0;
c01023c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01023c5:	eb 2c                	jmp    c01023f3 <ll_entail+0x5c>
	}else{
		while(h->next){
c01023c7:	eb 0c                	jmp    c01023d5 <ll_entail+0x3e>
			h = h->next;
c01023c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023cc:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01023d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c01023d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023d8:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01023de:	85 c0                	test   %eax,%eax
c01023e0:	75 e7                	jne    c01023c9 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c01023e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01023e8:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c01023ee:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01023f3:	c9                   	leave  
c01023f4:	c3                   	ret    

c01023f5 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c01023f5:	55                   	push   %ebp
c01023f6:	89 e5                	mov    %esp,%ebp
c01023f8:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c01023fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fe:	8b 00                	mov    (%eax),%eax
c0102400:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102403:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c010240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010240e:	75 07                	jne    c0102417 <ll_delete+0x22>
			return 0;
c0102410:	b8 00 00 00 00       	mov    $0x0,%eax
c0102415:	eb 59                	jmp    c0102470 <ll_delete+0x7b>
		if(sleep == p)
c0102417:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010241a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010241d:	75 09                	jne    c0102428 <ll_delete+0x33>
			break;
c010241f:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0102420:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102424:	75 26                	jne    c010244c <ll_delete+0x57>
c0102426:	eb 14                	jmp    c010243c <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0102428:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010242b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c010242e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102431:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102437:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c010243a:	eb ce                	jmp    c010240a <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c010243c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010243f:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0102445:	8b 45 08             	mov    0x8(%ebp),%eax
c0102448:	89 10                	mov    %edx,(%eax)
c010244a:	eb 12                	jmp    c010245e <ll_delete+0x69>
	else
		pre->next = sleep->next;
c010244c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010244f:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0102455:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102458:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c010245e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102461:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0102468:	00 00 00 
	return 1;
c010246b:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0102470:	c9                   	leave  
c0102471:	c3                   	ret    

c0102472 <init_pcb_pool>:

void init_pcb_pool()
{
c0102472:	55                   	push   %ebp
c0102473:	89 e5                	mov    %esp,%ebp
c0102475:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010247f:	eb 1d                	jmp    c010249e <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0102481:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102484:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c010248a:	05 40 20 00 00       	add    $0x2040,%eax
c010248f:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010249a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010249e:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c01024a5:	76 da                	jbe    c0102481 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c01024a7:	c9                   	leave  
c01024a8:	c3                   	ret    

c01024a9 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c01024a9:	55                   	push   %ebp
c01024aa:	89 e5                	mov    %esp,%ebp
c01024ac:	83 ec 24             	sub    $0x24,%esp
c01024af:	8b 45 14             	mov    0x14(%ebp),%eax
c01024b2:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c01024b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b8:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01024be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c01024c1:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01024c5:	75 46                	jne    c010250d <init_pcb+0x64>
		tf->ds = GD_KD;
c01024c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024ca:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c01024d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024d4:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c01024db:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024de:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c01024e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024e7:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c01024ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024f1:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c01024f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024fb:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0102501:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102504:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c010250b:	eb 4a                	jmp    c0102557 <init_pcb+0xae>
	}else
	if(pri == 3){
c010250d:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0102511:	75 44                	jne    c0102557 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0102513:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102516:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c010251d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102520:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0102527:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010252a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0102530:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102533:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c010253a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010253d:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0102544:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102547:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c010254d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102550:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0102557:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010255a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010255d:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0102560:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102563:	8b 55 10             	mov    0x10(%ebp),%edx
c0102566:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0102569:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010256d:	75 59                	jne    c01025c8 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c010256f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102572:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0102575:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102578:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c010257b:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0102582:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102589:	eb 26                	jmp    c01025b1 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c010258b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010258e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102595:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102598:	01 c2                	add    %eax,%edx
c010259a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010259d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c01025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025a7:	01 c8                	add    %ecx,%eax
c01025a9:	8b 00                	mov    (%eax),%eax
c01025ab:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c01025ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01025b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01025b4:	c1 e8 02             	shr    $0x2,%eax
c01025b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01025ba:	77 cf                	ja     c010258b <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c01025bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01025c2:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c01025c8:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01025cc:	0f 95 c0             	setne  %al
c01025cf:	0f b6 d0             	movzbl %al,%edx
c01025d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d5:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c01025db:	c9                   	leave  
c01025dc:	c3                   	ret    

c01025dd <pcb_create>:

PCB* pcb_create()
{
c01025dd:	55                   	push   %ebp
c01025de:	89 e5                	mov    %esp,%ebp
c01025e0:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01025e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01025ea:	eb 1f                	jmp    c010260b <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c01025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025ef:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01025f5:	05 40 20 00 00       	add    $0x2040,%eax
c01025fa:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c01025ff:	8b 00                	mov    (%eax),%eax
c0102601:	85 c0                	test   %eax,%eax
c0102603:	75 02                	jne    c0102607 <pcb_create+0x2a>
c0102605:	eb 0d                	jmp    c0102614 <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102607:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010260b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0102612:	76 d8                	jbe    c01025ec <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0102614:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102617:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c010261d:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102622:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0102625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102628:	6b c0 4c             	imul   $0x4c,%eax,%eax
c010262b:	8d 90 40 85 1b c0    	lea    -0x3fe47ac0(%eax),%edx
c0102631:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102634:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c010263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010263d:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c0102644:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0102647:	83 ec 0c             	sub    $0xc,%esp
c010264a:	6a 01                	push   $0x1
c010264c:	e8 32 e2 ff ff       	call   c0100883 <page_alloc>
c0102651:	83 c4 10             	add    $0x10,%esp
c0102654:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0102657:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010265b:	75 07                	jne    c0102664 <pcb_create+0x87>
c010265d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102662:	eb 77                	jmp    c01026db <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c0102664:	83 ec 0c             	sub    $0xc,%esp
c0102667:	ff 75 ec             	pushl  -0x14(%ebp)
c010266a:	e8 6e fc ff ff       	call   c01022dd <page2kva>
c010266f:	83 c4 10             	add    $0x10,%esp
c0102672:	89 c2                	mov    %eax,%edx
c0102674:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102677:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c010267d:	8b 15 a8 70 10 c0    	mov    0xc01070a8,%edx
c0102683:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102686:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c010268c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010268f:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0102696:	00 00 00 
	//p->ts = READY;
	pid ++;
c0102699:	a1 a8 70 10 c0       	mov    0xc01070a8,%eax
c010269e:	83 c0 01             	add    $0x1,%eax
c01026a1:	a3 a8 70 10 c0       	mov    %eax,0xc01070a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c01026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01026a9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01026ad:	8d 50 01             	lea    0x1(%eax),%edx
c01026b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01026b3:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c01026b7:	8b 15 c0 46 17 c0    	mov    0xc01746c0,%edx
c01026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026c0:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01026c6:	83 ec 04             	sub    $0x4,%esp
c01026c9:	68 00 10 00 00       	push   $0x1000
c01026ce:	52                   	push   %edx
c01026cf:	50                   	push   %eax
c01026d0:	e8 43 fb ff ff       	call   c0102218 <memcpy>
c01026d5:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c01026d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01026db:	c9                   	leave  
c01026dc:	c3                   	ret    

c01026dd <enready_pcb>:

void enready_pcb(PCB* pcb){
c01026dd:	55                   	push   %ebp
c01026de:	89 e5                	mov    %esp,%ebp
c01026e0:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c01026e3:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01026e8:	85 c0                	test   %eax,%eax
c01026ea:	75 18                	jne    c0102704 <enready_pcb+0x27>
		ready_list = pcb;
c01026ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ef:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
		ready_list->tail = pcb;
c01026f4:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c01026f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01026fc:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c0102702:	eb 32                	jmp    c0102736 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c0102704:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102709:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c010270c:	8b 45 08             	mov    0x8(%ebp),%eax
c010270f:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
		ready_list->next = temp;
c0102714:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102719:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010271c:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c0102722:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c0102727:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010272a:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c0102730:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c0102736:	c9                   	leave  
c0102737:	c3                   	ret    

c0102738 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0102738:	55                   	push   %ebp
c0102739:	89 e5                	mov    %esp,%ebp
c010273b:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c010273e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102741:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac
	lcr3(PADDR(pcb -> pgdir));
c0102746:	8b 45 08             	mov    0x8(%ebp),%eax
c0102749:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010274f:	83 ec 04             	sub    $0x4,%esp
c0102752:	50                   	push   %eax
c0102753:	68 af 00 00 00       	push   $0xaf
c0102758:	68 89 34 10 c0       	push   $0xc0103489
c010275d:	e8 d3 fa ff ff       	call   c0102235 <_paddr>
c0102762:	83 c4 10             	add    $0x10,%esp
c0102765:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102768:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010276b:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c010276e:	83 ec 0c             	sub    $0xc,%esp
c0102771:	ff 75 08             	pushl  0x8(%ebp)
c0102774:	e8 e3 db ff ff       	call   c010035c <enter_pcb>
c0102779:	83 c4 10             	add    $0x10,%esp
}
c010277c:	c9                   	leave  
c010277d:	c3                   	ret    

c010277e <free_pcb>:
void free_pcb(PCB* pcb){
c010277e:	55                   	push   %ebp
c010277f:	89 e5                	mov    %esp,%ebp
c0102781:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0102784:	8b 45 08             	mov    0x8(%ebp),%eax
c0102787:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010278d:	83 ec 0c             	sub    $0xc,%esp
c0102790:	50                   	push   %eax
c0102791:	e8 51 e6 ff ff       	call   c0100de7 <free_pgdir>
c0102796:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0102799:	8b 45 08             	mov    0x8(%ebp),%eax
c010279c:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01027a2:	83 ec 04             	sub    $0x4,%esp
c01027a5:	50                   	push   %eax
c01027a6:	68 b8 00 00 00       	push   $0xb8
c01027ab:	68 89 34 10 c0       	push   $0xc0103489
c01027b0:	e8 80 fa ff ff       	call   c0102235 <_paddr>
c01027b5:	83 c4 10             	add    $0x10,%esp
c01027b8:	83 ec 0c             	sub    $0xc,%esp
c01027bb:	50                   	push   %eax
c01027bc:	e8 e9 fa ff ff       	call   c01022aa <pa2page>
c01027c1:	83 c4 10             	add    $0x10,%esp
c01027c4:	83 ec 0c             	sub    $0xc,%esp
c01027c7:	50                   	push   %eax
c01027c8:	e8 3e e1 ff ff       	call   c010090b <page_decref>
c01027cd:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c01027d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d3:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c01027da:	00 00 00 

}
c01027dd:	c9                   	leave  
c01027de:	c3                   	ret    

c01027df <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c01027df:	55                   	push   %ebp
c01027e0:	89 e5                	mov    %esp,%ebp
c01027e2:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c01027e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01027e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01027eb:	68 10 08 00 00       	push   $0x810
c01027f0:	52                   	push   %edx
c01027f1:	50                   	push   %eax
c01027f2:	e8 21 fa ff ff       	call   c0102218 <memcpy>
c01027f7:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c01027fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027fd:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0102803:	8b 45 08             	mov    0x8(%ebp),%eax
c0102806:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c010280c:	8b 45 08             	mov    0x8(%ebp),%eax
c010280f:	05 20 10 00 00       	add    $0x1020,%eax
c0102814:	89 c2                	mov    %eax,%edx
c0102816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102819:	05 20 10 00 00       	add    $0x1020,%eax
c010281e:	29 c2                	sub    %eax,%edx
c0102820:	89 d0                	mov    %edx,%eax
c0102822:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c0102825:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102828:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c010282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102831:	01 c2                	add    %eax,%edx
c0102833:	8b 45 08             	mov    0x8(%ebp),%eax
c0102836:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c010283c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010283f:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c0102845:	8b 45 08             	mov    0x8(%ebp),%eax
c0102848:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL || dst->tt == THREAD){
c010284e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102851:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0102857:	85 c0                	test   %eax,%eax
c0102859:	74 0e                	je     c0102869 <copy_pcb+0x8a>
c010285b:	8b 45 08             	mov    0x8(%ebp),%eax
c010285e:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0102864:	83 f8 02             	cmp    $0x2,%eax
c0102867:	75 62                	jne    c01028cb <copy_pcb+0xec>
		
		dst->tf->ebp += offset;
c0102869:	8b 45 08             	mov    0x8(%ebp),%eax
c010286c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102872:	8b 55 08             	mov    0x8(%ebp),%edx
c0102875:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c010287b:	8b 4a 08             	mov    0x8(%edx),%ecx
c010287e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102881:	01 ca                	add    %ecx,%edx
c0102883:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0102886:	8b 45 08             	mov    0x8(%ebp),%eax
c0102889:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010288f:	8b 40 08             	mov    0x8(%eax),%eax
c0102892:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0102895:	eb 17                	jmp    c01028ae <copy_pcb+0xcf>
			*(ptr) += offset;
c0102897:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010289a:	8b 10                	mov    (%eax),%edx
c010289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010289f:	01 c2                	add    %eax,%edx
c01028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028a4:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c01028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028a9:	8b 00                	mov    (%eax),%eax
c01028ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL || dst->tt == THREAD){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c01028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028b1:	8b 00                	mov    (%eax),%eax
c01028b3:	85 c0                	test   %eax,%eax
c01028b5:	75 e0                	jne    c0102897 <copy_pcb+0xb8>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c01028b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01028ba:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c01028c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c3:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
	dst->tf = (void*)src->tf + offset;
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;

	if(dst->tt == KERNEL || dst->tt == THREAD){
c01028c9:	eb 1f                	jmp    c01028ea <copy_pcb+0x10b>
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
	}else{
		copy_pgdir(dst->pgdir, src->pgdir);
c01028cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01028ce:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c01028d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d7:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01028dd:	83 ec 08             	sub    $0x8,%esp
c01028e0:	52                   	push   %edx
c01028e1:	50                   	push   %eax
c01028e2:	e8 4b e2 ff ff       	call   c0100b32 <copy_pgdir>
c01028e7:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c01028ea:	c9                   	leave  
c01028eb:	c3                   	ret    

c01028ec <fork_current>:

void switch_proc();
void fork_current(){
c01028ec:	55                   	push   %ebp
c01028ed:	89 e5                	mov    %esp,%ebp
c01028ef:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c01028f2:	e8 e6 fc ff ff       	call   c01025dd <pcb_create>
c01028f7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c01028fa:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01028ff:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102905:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102908:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c010290e:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102913:	83 ec 08             	sub    $0x8,%esp
c0102916:	50                   	push   %eax
c0102917:	ff 75 f4             	pushl  -0xc(%ebp)
c010291a:	e8 c0 fe ff ff       	call   c01027df <copy_pcb>
c010291f:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0102922:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102927:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010292d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102930:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0102936:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0102939:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102942:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c0102949:	83 ec 08             	sub    $0x8,%esp
c010294c:	ff 75 f4             	pushl  -0xc(%ebp)
c010294f:	68 b0 50 15 c0       	push   $0xc01550b0
c0102954:	e8 00 fa ff ff       	call   c0102359 <ll_push>
c0102959:	83 c4 10             	add    $0x10,%esp
}
c010295c:	c9                   	leave  
c010295d:	c3                   	ret    

c010295e <thread_current>:

void thread_current(uint32_t entry, uint32_t esp){
c010295e:	55                   	push   %ebp
c010295f:	89 e5                	mov    %esp,%ebp
c0102961:	83 ec 18             	sub    $0x18,%esp
	//printk("ahh? %x\n", entry);
	PCB* son = pcb_create();
c0102964:	e8 74 fc ff ff       	call   c01025dd <pcb_create>
c0102969:	89 45 f4             	mov    %eax,-0xc(%ebp)
	
	son->tt = THREAD;
c010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296f:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0102976:	00 00 00 



	son->ppid = current->pid;
c0102979:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010297e:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102987:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c010298d:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102992:	83 ec 08             	sub    $0x8,%esp
c0102995:	50                   	push   %eax
c0102996:	ff 75 f4             	pushl  -0xc(%ebp)
c0102999:	e8 41 fe ff ff       	call   c01027df <copy_pcb>
c010299e:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c01029a1:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01029a6:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c01029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029af:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01029b5:	83 ec 04             	sub    $0x4,%esp
c01029b8:	68 00 10 00 00       	push   $0x1000
c01029bd:	52                   	push   %edx
c01029be:	50                   	push   %eax
c01029bf:	e8 54 f8 ff ff       	call   c0102218 <memcpy>
c01029c4:	83 c4 10             	add    $0x10,%esp
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c01029c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029ca:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c01029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d3:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01029d9:	83 ec 04             	sub    $0x4,%esp
c01029dc:	68 00 20 00 00       	push   $0x2000
c01029e1:	52                   	push   %edx
c01029e2:	50                   	push   %eax
c01029e3:	e8 a9 dc ff ff       	call   c0100691 <mm_alloc>
c01029e8:	83 c4 10             	add    $0x10,%esp

	son->tf->esp = esp-0x7F;
c01029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ee:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01029f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029f7:	83 ea 7f             	sub    $0x7f,%edx
c01029fa:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c01029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a00:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a06:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a09:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0102a0c:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102a11:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102a1a:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0102a20:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0102a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a26:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a2c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	ll_push(&ready_list, son);
c0102a33:	83 ec 08             	sub    $0x8,%esp
c0102a36:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a39:	68 b0 50 15 c0       	push   $0xc01550b0
c0102a3e:	e8 16 f9 ff ff       	call   c0102359 <ll_push>
c0102a43:	83 c4 10             	add    $0x10,%esp
}
c0102a46:	c9                   	leave  
c0102a47:	c3                   	ret    

c0102a48 <exit_current>:

void exit_current(){
c0102a48:	55                   	push   %ebp
c0102a49:	89 e5                	mov    %esp,%ebp
c0102a4b:	83 ec 18             	sub    $0x18,%esp
	

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0102a4e:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102a53:	05 68 20 00 00       	add    $0x2068,%eax
c0102a58:	83 ec 0c             	sub    $0xc,%esp
c0102a5b:	50                   	push   %eax
c0102a5c:	e8 d4 f8 ff ff       	call   c0102335 <ll_pop>
c0102a61:	83 c4 10             	add    $0x10,%esp
c0102a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0102a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a6b:	75 02                	jne    c0102a6f <exit_current+0x27>
c0102a6d:	eb 24                	jmp    c0102a93 <exit_current+0x4b>
		if(p->used == 0) continue;
c0102a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a72:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0102a78:	85 c0                	test   %eax,%eax
c0102a7a:	75 02                	jne    c0102a7e <exit_current+0x36>
c0102a7c:	eb 13                	jmp    c0102a91 <exit_current+0x49>
		ll_entail(&ready_list, p);
c0102a7e:	83 ec 08             	sub    $0x8,%esp
c0102a81:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a84:	68 b0 50 15 c0       	push   $0xc01550b0
c0102a89:	e8 09 f9 ff ff       	call   c0102397 <ll_entail>
c0102a8e:	83 c4 10             	add    $0x10,%esp
	}
c0102a91:	eb bb                	jmp    c0102a4e <exit_current+0x6>
	
	free_pcb(current);
c0102a93:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102a98:	83 ec 0c             	sub    $0xc,%esp
c0102a9b:	50                   	push   %eax
c0102a9c:	e8 dd fc ff ff       	call   c010277e <free_pcb>
c0102aa1:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c0102aa4:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0102aab:	00 00 00 
	do_scheduler();
c0102aae:	e8 be e5 ff ff       	call   c0101071 <do_scheduler>
}
c0102ab3:	c9                   	leave  
c0102ab4:	c3                   	ret    

c0102ab5 <join_current>:

void join_current(int pid){
c0102ab5:	55                   	push   %ebp
c0102ab6:	89 e5                	mov    %esp,%ebp
c0102ab8:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0102abb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102abf:	75 05                	jne    c0102ac6 <join_current+0x11>
c0102ac1:	e9 97 00 00 00       	jmp    c0102b5d <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102ac6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102acd:	eb 23                	jmp    c0102af2 <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0102acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ad2:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102ad8:	05 40 20 00 00       	add    $0x2040,%eax
c0102add:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102ae2:	8b 50 04             	mov    0x4(%eax),%edx
c0102ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae8:	39 c2                	cmp    %eax,%edx
c0102aea:	75 02                	jne    c0102aee <join_current+0x39>
c0102aec:	eb 0d                	jmp    c0102afb <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102aee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102af2:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0102af9:	76 d4                	jbe    c0102acf <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0102afb:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0102b02:	75 02                	jne    c0102b06 <join_current+0x51>
c0102b04:	eb 57                	jmp    c0102b5d <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c0102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b09:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102b0f:	05 40 20 00 00       	add    $0x2040,%eax
c0102b14:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102b19:	8b 00                	mov    (%eax),%eax
c0102b1b:	85 c0                	test   %eax,%eax
c0102b1d:	75 02                	jne    c0102b21 <join_current+0x6c>
c0102b1f:	eb 3c                	jmp    c0102b5d <join_current+0xa8>
	PCB *p = &PCBPool[i];
c0102b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b24:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102b2a:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0102b32:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0102b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b3d:	05 68 20 00 00       	add    $0x2068,%eax
c0102b42:	ff 75 ec             	pushl  -0x14(%ebp)
c0102b45:	50                   	push   %eax
c0102b46:	e8 4c f8 ff ff       	call   c0102397 <ll_entail>
c0102b4b:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0102b4e:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0102b55:	00 00 00 
	do_scheduler();
c0102b58:	e8 14 e5 ff ff       	call   c0101071 <do_scheduler>
c0102b5d:	c9                   	leave  
c0102b5e:	c3                   	ret    

c0102b5f <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0102b5f:	55                   	push   %ebp
c0102b60:	89 e5                	mov    %esp,%ebp
c0102b62:	57                   	push   %edi
c0102b63:	56                   	push   %esi
c0102b64:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102b65:	8b 45 10             	mov    0x10(%ebp),%eax
c0102b68:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102b6e:	89 c1                	mov    %eax,%ecx
c0102b70:	89 d6                	mov    %edx,%esi
c0102b72:	89 df                	mov    %ebx,%edi
c0102b74:	fc                   	cld    
c0102b75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102b77:	5b                   	pop    %ebx
c0102b78:	5e                   	pop    %esi
c0102b79:	5f                   	pop    %edi
c0102b7a:	5d                   	pop    %ebp
c0102b7b:	c3                   	ret    

c0102b7c <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0102b7c:	55                   	push   %ebp
c0102b7d:	89 e5                	mov    %esp,%ebp
c0102b7f:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102b82:	68 80 3e 00 00       	push   $0x3e80
c0102b87:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102b8c:	68 c0 50 15 c0       	push   $0xc01550c0
c0102b91:	e8 c9 ff ff ff       	call   c0102b5f <memcpy>
c0102b96:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0102b99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102ba0:	eb 0f                	jmp    c0102bb1 <initVCache+0x35>
		VDIRTY[x] = 0;
c0102ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ba5:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102baa:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0102bad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102bb1:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102bb8:	7e e8                	jle    c0102ba2 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0102bba:	c9                   	leave  
c0102bbb:	c3                   	ret    

c0102bbc <refreshVCache>:
void refreshVCache(){
c0102bbc:	55                   	push   %ebp
c0102bbd:	89 e5                	mov    %esp,%ebp
c0102bbf:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102bc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102bc9:	eb 0f                	jmp    c0102bda <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0102bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102bce:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102bd3:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102bd6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102bda:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102be1:	7e e8                	jle    c0102bcb <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0102be3:	c9                   	leave  
c0102be4:	c3                   	ret    

c0102be5 <flushVCache>:
void flushVCache(){
c0102be5:	55                   	push   %ebp
c0102be6:	89 e5                	mov    %esp,%ebp
c0102be8:	53                   	push   %ebx
c0102be9:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102bec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0102bf3:	eb 47                	jmp    c0102c3c <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0102bf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102bf8:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102bfd:	0f b6 00             	movzbl (%eax),%eax
c0102c00:	84 c0                	test   %al,%al
c0102c02:	74 34                	je     c0102c38 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0102c04:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102c07:	89 d0                	mov    %edx,%eax
c0102c09:	c1 e0 02             	shl    $0x2,%eax
c0102c0c:	01 d0                	add    %edx,%eax
c0102c0e:	c1 e0 06             	shl    $0x6,%eax
c0102c11:	8d 88 c0 50 15 c0    	lea    -0x3feaaf40(%eax),%ecx
c0102c17:	8b 1d ac 70 10 c0    	mov    0xc01070ac,%ebx
c0102c1d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102c20:	89 d0                	mov    %edx,%eax
c0102c22:	c1 e0 02             	shl    $0x2,%eax
c0102c25:	01 d0                	add    %edx,%eax
c0102c27:	c1 e0 06             	shl    $0x6,%eax
c0102c2a:	01 d8                	add    %ebx,%eax
c0102c2c:	6a 50                	push   $0x50
c0102c2e:	51                   	push   %ecx
c0102c2f:	50                   	push   %eax
c0102c30:	e8 2a ff ff ff       	call   c0102b5f <memcpy>
c0102c35:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102c38:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102c3c:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102c43:	7e b0                	jle    c0102bf5 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0102c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102c48:	c9                   	leave  
c0102c49:	c3                   	ret    

c0102c4a <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0102c4a:	55                   	push   %ebp
c0102c4b:	89 e5                	mov    %esp,%ebp
c0102c4d:	83 ec 04             	sub    $0x4,%esp
c0102c50:	8b 45 10             	mov    0x10(%ebp),%eax
c0102c53:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0102c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102c5a:	78 18                	js     c0102c74 <setPixelAt+0x2a>
c0102c5c:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102c63:	7f 0f                	jg     c0102c74 <setPixelAt+0x2a>
c0102c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c69:	78 09                	js     c0102c74 <setPixelAt+0x2a>
c0102c6b:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102c72:	7e 02                	jle    c0102c76 <setPixelAt+0x2c>
c0102c74:	eb 34                	jmp    c0102caa <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0102c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c79:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102c7e:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0102c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c84:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102c89:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0102c8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c8f:	89 d0                	mov    %edx,%eax
c0102c91:	c1 e0 02             	shl    $0x2,%eax
c0102c94:	01 d0                	add    %edx,%eax
c0102c96:	c1 e0 06             	shl    $0x6,%eax
c0102c99:	89 c2                	mov    %eax,%edx
c0102c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c9e:	01 c2                	add    %eax,%edx
c0102ca0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0102ca4:	88 82 c0 50 15 c0    	mov    %al,-0x3feaaf40(%edx)
}
c0102caa:	c9                   	leave  
c0102cab:	c3                   	ret    

c0102cac <forceClearVRAM>:
void forceClearVRAM(){
c0102cac:	55                   	push   %ebp
c0102cad:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0102caf:	5d                   	pop    %ebp
c0102cb0:	c3                   	ret    

c0102cb1 <clearVRAM>:
void clearVRAM(){
c0102cb1:	55                   	push   %ebp
c0102cb2:	89 e5                	mov    %esp,%ebp
c0102cb4:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102cb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102cbe:	eb 4e                	jmp    c0102d0e <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0102cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102cc3:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102cc8:	0f b6 00             	movzbl (%eax),%eax
c0102ccb:	0f b6 c0             	movzbl %al,%eax
c0102cce:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102cd1:	81 c2 c0 44 17 c0    	add    $0xc01744c0,%edx
c0102cd7:	0f b6 12             	movzbl (%edx),%edx
c0102cda:	0f b6 d2             	movzbl %dl,%edx
c0102cdd:	f7 d2                	not    %edx
c0102cdf:	21 d0                	and    %edx,%eax
c0102ce1:	85 c0                	test   %eax,%eax
c0102ce3:	74 25                	je     c0102d0a <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0102ce5:	8b 0d ac 70 10 c0    	mov    0xc01070ac,%ecx
c0102ceb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102cee:	89 d0                	mov    %edx,%eax
c0102cf0:	c1 e0 02             	shl    $0x2,%eax
c0102cf3:	01 d0                	add    %edx,%eax
c0102cf5:	c1 e0 06             	shl    $0x6,%eax
c0102cf8:	01 c8                	add    %ecx,%eax
c0102cfa:	6a 50                	push   $0x50
c0102cfc:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102d01:	50                   	push   %eax
c0102d02:	e8 58 fe ff ff       	call   c0102b5f <memcpy>
c0102d07:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102d0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102d0e:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102d15:	7e a9                	jle    c0102cc0 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0102d17:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102d1e:	83 c0 01             	add    $0x1,%eax
c0102d21:	a2 88 46 17 c0       	mov    %al,0xc0174688
	if(stamp==30){
c0102d26:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102d2d:	3c 1e                	cmp    $0x1e,%al
c0102d2f:	75 07                	jne    c0102d38 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0102d31:	c6 05 88 46 17 c0 00 	movb   $0x0,0xc0174688
		//printk("What matters\n");
	}
	if(stamp==0){
c0102d38:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102d3f:	84 c0                	test   %al,%al
c0102d41:	75 14                	jne    c0102d57 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102d43:	6a 32                	push   $0x32
c0102d45:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102d4a:	68 c0 45 17 c0       	push   $0xc01745c0
c0102d4f:	e8 0b fe ff ff       	call   c0102b5f <memcpy>
c0102d54:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0102d57:	c9                   	leave  
c0102d58:	c3                   	ret    

c0102d59 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0102d59:	55                   	push   %ebp
c0102d5a:	89 e5                	mov    %esp,%ebp
c0102d5c:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0102d5f:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102d64:	83 c0 01             	add    $0x1,%eax
c0102d67:	a3 8c 46 17 c0       	mov    %eax,0xc017468c
	current->timeslice ++;
c0102d6c:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102d71:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0102d77:	83 c2 01             	add    $0x1,%edx
c0102d7a:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c0102d80:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c0102d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0102d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102d8c:	75 02                	jne    c0102d90 <do_timer+0x37>
c0102d8e:	eb 6b                	jmp    c0102dfb <do_timer+0xa2>
	 	sleep->timeslice --;
c0102d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d93:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102d99:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9f:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0102da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0102dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dae:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102db4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0102db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dba:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102dc0:	85 c0                	test   %eax,%eax
c0102dc2:	74 02                	je     c0102dc6 <do_timer+0x6d>
c0102dc4:	eb 33                	jmp    c0102df9 <do_timer+0xa0>
	 	cur->ts = READY;
c0102dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dc9:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0102dd0:	00 00 00 
		ll_delete(&sleep_list, cur);
c0102dd3:	83 ec 08             	sub    $0x8,%esp
c0102dd6:	ff 75 f0             	pushl  -0x10(%ebp)
c0102dd9:	68 b4 50 15 c0       	push   $0xc01550b4
c0102dde:	e8 12 f6 ff ff       	call   c01023f5 <ll_delete>
c0102de3:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0102de6:	83 ec 08             	sub    $0x8,%esp
c0102de9:	ff 75 f0             	pushl  -0x10(%ebp)
c0102dec:	68 b0 50 15 c0       	push   $0xc01550b0
c0102df1:	e8 a1 f5 ff ff       	call   c0102397 <ll_entail>
c0102df6:	83 c4 10             	add    $0x10,%esp
	}
c0102df9:	eb 8d                	jmp    c0102d88 <do_timer+0x2f>
}
c0102dfb:	c9                   	leave  
c0102dfc:	c3                   	ret    

c0102dfd <tick>:
uint32_t tick(){
c0102dfd:	55                   	push   %ebp
c0102dfe:	89 e5                	mov    %esp,%ebp
	return _tick;
c0102e00:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102e05:	5d                   	pop    %ebp
c0102e06:	c3                   	ret    

c0102e07 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0102e07:	6a 00                	push   $0x0
c0102e09:	6a 00                	push   $0x0
c0102e0b:	e9 b8 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e10 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0102e10:	6a 00                	push   $0x0
c0102e12:	6a 01                	push   $0x1
c0102e14:	e9 af 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e19 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0102e19:	6a 00                	push   $0x0
c0102e1b:	6a 02                	push   $0x2
c0102e1d:	e9 a6 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e22 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0102e22:	6a 00                	push   $0x0
c0102e24:	6a 03                	push   $0x3
c0102e26:	e9 9d 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e2b <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0102e2b:	6a 00                	push   $0x0
c0102e2d:	6a 04                	push   $0x4
c0102e2f:	e9 94 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e34 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0102e34:	6a 00                	push   $0x0
c0102e36:	6a 05                	push   $0x5
c0102e38:	e9 8b 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e3d <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0102e3d:	6a 00                	push   $0x0
c0102e3f:	6a 06                	push   $0x6
c0102e41:	e9 82 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e46 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0102e46:	6a 00                	push   $0x0
c0102e48:	6a 07                	push   $0x7
c0102e4a:	e9 79 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e4f <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0102e4f:	6a 00                	push   $0x0
c0102e51:	6a 08                	push   $0x8
c0102e53:	e9 70 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e58 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0102e58:	6a 00                	push   $0x0
c0102e5a:	6a 09                	push   $0x9
c0102e5c:	e9 67 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e61 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0102e61:	6a 00                	push   $0x0
c0102e63:	6a 0a                	push   $0xa
c0102e65:	e9 5e 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e6a <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0102e6a:	6a 00                	push   $0x0
c0102e6c:	6a 0b                	push   $0xb
c0102e6e:	e9 55 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e73 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102e73:	6a 00                	push   $0x0
c0102e75:	6a 0c                	push   $0xc
c0102e77:	e9 4c 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e7c <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0102e7c:	6a 00                	push   $0x0
c0102e7e:	6a 0d                	push   $0xd
c0102e80:	e9 43 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e85 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102e85:	6a 00                	push   $0x0
c0102e87:	6a 0e                	push   $0xe
c0102e89:	e9 3a 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e8e <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102e8e:	fa                   	cli    
c0102e8f:	6a 00                	push   $0x0
c0102e91:	68 80 00 00 00       	push   $0x80
c0102e96:	e9 2d 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102e9b <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102e9b:	6a 00                	push   $0x0
c0102e9d:	68 e8 03 00 00       	push   $0x3e8
c0102ea2:	e9 21 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102ea7 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102ea7:	6a 00                	push   $0x0
c0102ea9:	68 e9 03 00 00       	push   $0x3e9
c0102eae:	e9 15 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102eb3 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0102eb3:	6a 00                	push   $0x0
c0102eb5:	68 f6 03 00 00       	push   $0x3f6
c0102eba:	e9 09 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102ebf <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0102ebf:	6a 00                	push   $0x0
c0102ec1:	6a ff                	push   $0xffffffff
c0102ec3:	e9 00 00 00 00       	jmp    c0102ec8 <asm_do_irq>

c0102ec8 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0102ec8:	fa                   	cli    
  pushl %ds
c0102ec9:	1e                   	push   %ds
  pushl %es
c0102eca:	06                   	push   %es
  pushl %fs
c0102ecb:	0f a0                	push   %fs
  pushl %gs
c0102ecd:	0f a8                	push   %gs
	pushal
c0102ecf:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0102ed0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0102ed4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102ed6:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0102ed8:	54                   	push   %esp
  call irq_handle
c0102ed9:	e8 86 e2 ff ff       	call   c0101164 <irq_handle>
  addl $4, %esp
c0102ede:	83 c4 04             	add    $0x4,%esp

c0102ee1 <switch_proc>:
switch_proc:
  popal
c0102ee1:	61                   	popa   
  popl %gs
c0102ee2:	0f a9                	pop    %gs
  popl %fs
c0102ee4:	0f a1                	pop    %fs
  popl %es
c0102ee6:	07                   	pop    %es
  popl %ds
c0102ee7:	1f                   	pop    %ds
  addl $8, %esp
c0102ee8:	83 c4 08             	add    $0x8,%esp
  sti
c0102eeb:	fb                   	sti    
  iret
c0102eec:	cf                   	iret   
c0102eed:	66 90                	xchg   %ax,%ax
c0102eef:	90                   	nop
c0102ef0:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0102ef6:	00 00                	add    %al,(%eax)
c0102ef8:	fe 4f 52             	decb   0x52(%edi)
c0102efb:	e4 66                	in     $0x66,%al

c0102efc <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0102efc:	66 c7 05 72 04 00 00 34 12 b8 00 60 10 00 0f 22     f..r...4...`..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0102f0c:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 1f 2f 10     .. .......".../.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0102f1c:	c0 ff e0                                            ...

c0102f1f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0102f1f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0102f24:	bc 00 00 11 c0       	mov    $0xc0110000,%esp

	# now to C code

	call	main
c0102f29:	e8 70 e9 ff ff       	call   c010189e <main>

c0102f2e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0102f2e:	eb fe                	jmp    c0102f2e <spin>

c0102f30 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0102f30:	55                   	push   %ebp
c0102f31:	89 e5                	mov    %esp,%ebp
c0102f33:	53                   	push   %ebx
c0102f34:	83 ec 04             	sub    $0x4,%esp
c0102f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f3a:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0102f3d:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0102f42:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0102f46:	89 d3                	mov    %edx,%ebx
c0102f48:	cd 80                	int    $0x80
}
c0102f4a:	83 c4 04             	add    $0x4,%esp
c0102f4d:	5b                   	pop    %ebx
c0102f4e:	5d                   	pop    %ebp
c0102f4f:	c3                   	ret    

c0102f50 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0102f50:	55                   	push   %ebp
c0102f51:	89 e5                	mov    %esp,%ebp
c0102f53:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0102f56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0102f5c:	eb 19                	jmp    c0102f77 <printp+0x27>
		printer(cur);
c0102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f61:	0f b6 00             	movzbl (%eax),%eax
c0102f64:	0f be c0             	movsbl %al,%eax
c0102f67:	83 ec 0c             	sub    $0xc,%esp
c0102f6a:	50                   	push   %eax
c0102f6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f6e:	ff d0                	call   *%eax
c0102f70:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0102f73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7a:	0f b6 00             	movzbl (%eax),%eax
c0102f7d:	84 c0                	test   %al,%al
c0102f7f:	75 dd                	jne    c0102f5e <printp+0xe>
		printer(cur);
	}
}
c0102f81:	c9                   	leave  
c0102f82:	c3                   	ret    

c0102f83 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0102f83:	55                   	push   %ebp
c0102f84:	89 e5                	mov    %esp,%ebp
c0102f86:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102f89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0102f8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0102f96:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0102f9d:	8b 45 10             	mov    0x10(%ebp),%eax
c0102fa0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102fa3:	e9 65 02 00 00       	jmp    c010320d <vfprintf+0x28a>

		if(cur == '%'){
c0102fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fab:	0f b6 00             	movzbl (%eax),%eax
c0102fae:	3c 25                	cmp    $0x25,%al
c0102fb0:	75 0c                	jne    c0102fbe <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0102fb2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0102fb9:	e9 4b 02 00 00       	jmp    c0103209 <vfprintf+0x286>
		}
		if(type == READ){
c0102fbe:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0102fc2:	0f 85 26 02 00 00    	jne    c01031ee <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0102fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fcb:	0f b6 00             	movzbl (%eax),%eax
c0102fce:	3c 73                	cmp    $0x73,%al
c0102fd0:	75 35                	jne    c0103007 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0102fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102fd5:	8b 00                	mov    (%eax),%eax
c0102fd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0102fda:	eb 19                	jmp    c0102ff5 <vfprintf+0x72>
					printer(*p);
c0102fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102fdf:	0f b6 00             	movzbl (%eax),%eax
c0102fe2:	0f be c0             	movsbl %al,%eax
c0102fe5:	83 ec 0c             	sub    $0xc,%esp
c0102fe8:	50                   	push   %eax
c0102fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fec:	ff d0                	call   *%eax
c0102fee:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0102ff1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0102ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ff8:	0f b6 00             	movzbl (%eax),%eax
c0102ffb:	84 c0                	test   %al,%al
c0102ffd:	75 dd                	jne    c0102fdc <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0102fff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103003:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0103007:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010300a:	0f b6 00             	movzbl (%eax),%eax
c010300d:	3c 78                	cmp    $0x78,%al
c010300f:	0f 85 99 00 00 00    	jne    c01030ae <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0103015:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103018:	8b 00                	mov    (%eax),%eax
c010301a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c010301d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103021:	75 1d                	jne    c0103040 <vfprintf+0xbd>
					printer('0');
c0103023:	83 ec 0c             	sub    $0xc,%esp
c0103026:	6a 30                	push   $0x30
c0103028:	8b 45 08             	mov    0x8(%ebp),%eax
c010302b:	ff d0                	call   *%eax
c010302d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103030:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103034:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010303b:	e9 c9 01 00 00       	jmp    c0103209 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0103040:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0103047:	eb 2d                	jmp    c0103076 <vfprintf+0xf3>
					int d=(x%16);
c0103049:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010304c:	83 e0 0f             	and    $0xf,%eax
c010304f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c0103052:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0103056:	7e 04                	jle    c010305c <vfprintf+0xd9>
						d+='a'-'0'-10;
c0103058:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c010305c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010305f:	83 c0 30             	add    $0x30,%eax
c0103062:	89 c1                	mov    %eax,%ecx
c0103064:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103067:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010306a:	01 d0                	add    %edx,%eax
c010306c:	88 08                	mov    %cl,(%eax)
					x>>=4;
c010306e:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0103072:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103076:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010307a:	75 cd                	jne    c0103049 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c010307c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0103080:	eb 1e                	jmp    c01030a0 <vfprintf+0x11d>
					printer(digits[di]);
c0103082:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103085:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103088:	01 d0                	add    %edx,%eax
c010308a:	0f b6 00             	movzbl (%eax),%eax
c010308d:	0f be c0             	movsbl %al,%eax
c0103090:	83 ec 0c             	sub    $0xc,%esp
c0103093:	50                   	push   %eax
c0103094:	8b 45 08             	mov    0x8(%ebp),%eax
c0103097:	ff d0                	call   *%eax
c0103099:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c010309c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c01030a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01030a4:	79 dc                	jns    c0103082 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01030a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01030aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c01030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030b1:	0f b6 00             	movzbl (%eax),%eax
c01030b4:	3c 64                	cmp    $0x64,%al
c01030b6:	0f 85 02 01 00 00    	jne    c01031be <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c01030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030bf:	8b 00                	mov    (%eax),%eax
c01030c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c01030c4:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c01030cb:	75 23                	jne    c01030f0 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c01030cd:	83 ec 08             	sub    $0x8,%esp
c01030d0:	68 9e 34 10 c0       	push   $0xc010349e
c01030d5:	ff 75 08             	pushl  0x8(%ebp)
c01030d8:	e8 73 fe ff ff       	call   c0102f50 <printp>
c01030dd:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01030e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01030e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01030eb:	e9 19 01 00 00       	jmp    c0103209 <vfprintf+0x286>
				}
				if(x==0){
c01030f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01030f4:	75 1e                	jne    c0103114 <vfprintf+0x191>
					printer('0');
c01030f6:	83 ec 0c             	sub    $0xc,%esp
c01030f9:	6a 30                	push   $0x30
c01030fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01030fe:	ff d0                	call   *%eax
c0103100:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0103103:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103107:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c010310e:	90                   	nop
c010310f:	e9 f5 00 00 00       	jmp    c0103209 <vfprintf+0x286>
				}
				if(x<0){
c0103114:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103118:	79 10                	jns    c010312a <vfprintf+0x1a7>
					printer('-');
c010311a:	83 ec 0c             	sub    $0xc,%esp
c010311d:	6a 2d                	push   $0x2d
c010311f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103122:	ff d0                	call   *%eax
c0103124:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0103127:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c010312a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0103131:	eb 53                	jmp    c0103186 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c0103133:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103136:	ba 67 66 66 66       	mov    $0x66666667,%edx
c010313b:	89 c8                	mov    %ecx,%eax
c010313d:	f7 ea                	imul   %edx
c010313f:	c1 fa 02             	sar    $0x2,%edx
c0103142:	89 c8                	mov    %ecx,%eax
c0103144:	c1 f8 1f             	sar    $0x1f,%eax
c0103147:	29 c2                	sub    %eax,%edx
c0103149:	89 d0                	mov    %edx,%eax
c010314b:	c1 e0 02             	shl    $0x2,%eax
c010314e:	01 d0                	add    %edx,%eax
c0103150:	01 c0                	add    %eax,%eax
c0103152:	29 c1                	sub    %eax,%ecx
c0103154:	89 ca                	mov    %ecx,%edx
c0103156:	89 d0                	mov    %edx,%eax
c0103158:	83 c0 30             	add    $0x30,%eax
c010315b:	89 c1                	mov    %eax,%ecx
c010315d:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103160:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103163:	01 d0                	add    %edx,%eax
c0103165:	88 08                	mov    %cl,(%eax)
					x/=10;
c0103167:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010316a:	ba 67 66 66 66       	mov    $0x66666667,%edx
c010316f:	89 c8                	mov    %ecx,%eax
c0103171:	f7 ea                	imul   %edx
c0103173:	c1 fa 02             	sar    $0x2,%edx
c0103176:	89 c8                	mov    %ecx,%eax
c0103178:	c1 f8 1f             	sar    $0x1f,%eax
c010317b:	29 c2                	sub    %eax,%edx
c010317d:	89 d0                	mov    %edx,%eax
c010317f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0103182:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103186:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010318a:	7f a7                	jg     c0103133 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c010318c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0103190:	eb 1e                	jmp    c01031b0 <vfprintf+0x22d>
					printer(digits[di]);
c0103192:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103195:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103198:	01 d0                	add    %edx,%eax
c010319a:	0f b6 00             	movzbl (%eax),%eax
c010319d:	0f be c0             	movsbl %al,%eax
c01031a0:	83 ec 0c             	sub    $0xc,%esp
c01031a3:	50                   	push   %eax
c01031a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01031a7:	ff d0                	call   *%eax
c01031a9:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c01031ac:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c01031b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01031b4:	79 dc                	jns    c0103192 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01031b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01031ba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c01031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031c1:	0f b6 00             	movzbl (%eax),%eax
c01031c4:	3c 63                	cmp    $0x63,%al
c01031c6:	75 1d                	jne    c01031e5 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c01031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031cb:	0f b6 00             	movzbl (%eax),%eax
c01031ce:	0f be c0             	movsbl %al,%eax
c01031d1:	83 ec 0c             	sub    $0xc,%esp
c01031d4:	50                   	push   %eax
c01031d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01031d8:	ff d0                	call   *%eax
c01031da:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c01031dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01031e1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c01031e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c01031ec:	eb 1b                	jmp    c0103209 <vfprintf+0x286>
		}
		if(type == NONE){
c01031ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031f2:	75 15                	jne    c0103209 <vfprintf+0x286>
			printer(cur);
c01031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031f7:	0f b6 00             	movzbl (%eax),%eax
c01031fa:	0f be c0             	movsbl %al,%eax
c01031fd:	83 ec 0c             	sub    $0xc,%esp
c0103200:	50                   	push   %eax
c0103201:	8b 45 08             	mov    0x8(%ebp),%eax
c0103204:	ff d0                	call   *%eax
c0103206:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0103209:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103210:	0f b6 00             	movzbl (%eax),%eax
c0103213:	84 c0                	test   %al,%al
c0103215:	0f 85 8d fd ff ff    	jne    c0102fa8 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c010321b:	c9                   	leave  
c010321c:	c3                   	ret    

c010321d <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c010321d:	55                   	push   %ebp
c010321e:	89 e5                	mov    %esp,%ebp
c0103220:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0103223:	8d 45 0c             	lea    0xc(%ebp),%eax
c0103226:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0103229:	8b 45 08             	mov    0x8(%ebp),%eax
c010322c:	83 ec 04             	sub    $0x4,%esp
c010322f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103232:	50                   	push   %eax
c0103233:	68 30 2f 10 c0       	push   $0xc0102f30
c0103238:	e8 46 fd ff ff       	call   c0102f83 <vfprintf>
c010323d:	83 c4 10             	add    $0x10,%esp
}
c0103240:	c9                   	leave  
c0103241:	c3                   	ret    
