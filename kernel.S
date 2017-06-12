
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
c01000ba:	e8 6c 44 00 00       	call   c010452b <vfprintf>
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
c01000f0:	68 ec 47 10 c0       	push   $0xc01047ec
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
c0100371:	68 0f 48 10 c0       	push   $0xc010480f
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
c0100415:	68 0f 48 10 c0       	push   $0xc010480f
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
c0100448:	b8 8c 44 10 c0       	mov    $0xc010448c,%eax
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
c0100583:	e8 a3 3f 00 00       	call   c010452b <vfprintf>
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
c01005d6:	68 28 48 10 c0       	push   $0xc0104828
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
c010060c:	68 4c 48 10 c0       	push   $0xc010484c
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
c010064e:	68 70 48 10 c0       	push   $0xc0104870
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
c0100682:	68 8f 48 10 c0       	push   $0xc010488f
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
c010074d:	68 a5 48 10 c0       	push   $0xc01048a5
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
c01007ae:	68 a5 48 10 c0       	push   $0xc01048a5
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
c010089a:	68 c0 48 10 c0       	push   $0xc01048c0
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
c010097f:	68 a5 48 10 c0       	push   $0xc01048a5
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
c01009fb:	68 a5 48 10 c0       	push   $0xc01048a5
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
c0100b9d:	68 a5 48 10 c0       	push   $0xc01048a5
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
c0100c27:	68 a5 48 10 c0       	push   $0xc01048a5
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
c0100cd9:	68 a5 48 10 c0       	push   $0xc01048a5
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
c0100e4f:	68 a5 48 10 c0       	push   $0xc01048a5
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
c0100f53:	e8 d8 28 00 00       	call   c0103830 <ll_pop>
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
c0100f71:	e8 1c 29 00 00       	call   c0103892 <ll_entail>
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
c0100fb1:	e8 7a 28 00 00       	call   c0103830 <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 60 15 c0       	push   $0xc01560b0
c0100fc7:	e8 c6 28 00 00       	call   c0103892 <ll_entail>
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
c0101010:	e8 7d 28 00 00       	call   c0103892 <ll_entail>
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
c01010cf:	e8 5c 27 00 00       	call   c0103830 <ll_pop>
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
c010112e:	e8 5f 27 00 00       	call   c0103892 <ll_entail>
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
c0101184:	e8 09 27 00 00       	call   c0103892 <ll_entail>
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
c01011d0:	e8 66 20 00 00       	call   c010323b <do_syscall>
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
c01011e5:	e8 1a 31 00 00       	call   c0104304 <do_timer>
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
c010126f:	e8 ed 1e 00 00       	call   c0103161 <press_key>
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
c01013d2:	ba 6a 44 10 c0       	mov    $0xc010446a,%edx
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
c01013fd:	b8 b2 43 10 c0       	mov    $0xc01043b2,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 40 89 1b c0       	push   $0xc01b8940
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 bb 43 10 c0       	mov    $0xc01043bb,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 48 89 1b c0       	push   $0xc01b8948
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 c4 43 10 c0       	mov    $0xc01043c4,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 50 89 1b c0       	push   $0xc01b8950
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 cd 43 10 c0       	mov    $0xc01043cd,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 58 89 1b c0       	push   $0xc01b8958
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 d6 43 10 c0       	mov    $0xc01043d6,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 60 89 1b c0       	push   $0xc01b8960
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 df 43 10 c0       	mov    $0xc01043df,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 68 89 1b c0       	push   $0xc01b8968
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 e8 43 10 c0       	mov    $0xc01043e8,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 70 89 1b c0       	push   $0xc01b8970
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 f1 43 10 c0       	mov    $0xc01043f1,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 78 89 1b c0       	push   $0xc01b8978
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 fa 43 10 c0       	mov    $0xc01043fa,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 80 89 1b c0       	push   $0xc01b8980
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 03 44 10 c0       	mov    $0xc0104403,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 88 89 1b c0       	push   $0xc01b8988
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 0c 44 10 c0       	mov    $0xc010440c,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 90 89 1b c0       	push   $0xc01b8990
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 15 44 10 c0       	mov    $0xc0104415,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 98 89 1b c0       	push   $0xc01b8998
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 1e 44 10 c0       	mov    $0xc010441e,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 a0 89 1b c0       	push   $0xc01b89a0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 27 44 10 c0       	mov    $0xc0104427,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 a8 89 1b c0       	push   $0xc01b89a8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 39 44 10 c0       	mov    $0xc0104439,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 40 8d 1b c0       	push   $0xc01b8d40
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 46 44 10 c0       	mov    $0xc0104446,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 40 8a 1b c0       	push   $0xc01b8a40
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 52 44 10 c0       	mov    $0xc0104452,%eax
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

c0101598 <memcpy2>:
static inline void memcpy2(void* dst, void* src, int len){
c0101598:	55                   	push   %ebp
c0101599:	89 e5                	mov    %esp,%ebp
c010159b:	57                   	push   %edi
c010159c:	56                   	push   %esi
c010159d:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c010159e:	8b 45 10             	mov    0x10(%ebp),%eax
c01015a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01015a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01015a7:	89 c1                	mov    %eax,%ecx
c01015a9:	89 d6                	mov    %edx,%esi
c01015ab:	89 df                	mov    %ebx,%edi
c01015ad:	fc                   	cld    
c01015ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c01015b0:	5b                   	pop    %ebx
c01015b1:	5e                   	pop    %esi
c01015b2:	5f                   	pop    %edi
c01015b3:	5d                   	pop    %ebp
c01015b4:	c3                   	ret    

c01015b5 <memset2>:

static inline void memset2(void* dst, uint32_t src, int len){
c01015b5:	55                   	push   %ebp
c01015b6:	89 e5                	mov    %esp,%ebp
c01015b8:	57                   	push   %edi
c01015b9:	53                   	push   %ebx
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
c01015ba:	8b 55 10             	mov    0x10(%ebp),%edx
c01015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01015c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01015c3:	89 d1                	mov    %edx,%ecx
c01015c5:	89 df                	mov    %ebx,%edi
c01015c7:	fc                   	cld    
c01015c8:	f3 aa                	rep stos %al,%es:(%edi)
}
c01015ca:	5b                   	pop    %ebx
c01015cb:	5f                   	pop    %edi
c01015cc:	5d                   	pop    %ebp
c01015cd:	c3                   	ret    

c01015ce <strcmp>:
static inline int strcmp(const char* s1, const char* s2)
{
c01015ce:	55                   	push   %ebp
c01015cf:	89 e5                	mov    %esp,%ebp
    while(*s1 && (*s1==*s2))
c01015d1:	eb 08                	jmp    c01015db <strcmp+0xd>
        s1++,s2++;
c01015d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01015d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
c01015db:	8b 45 08             	mov    0x8(%ebp),%eax
c01015de:	0f b6 00             	movzbl (%eax),%eax
c01015e1:	84 c0                	test   %al,%al
c01015e3:	74 10                	je     c01015f5 <strcmp+0x27>
c01015e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01015e8:	0f b6 10             	movzbl (%eax),%edx
c01015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01015ee:	0f b6 00             	movzbl (%eax),%eax
c01015f1:	38 c2                	cmp    %al,%dl
c01015f3:	74 de                	je     c01015d3 <strcmp+0x5>
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
c01015f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01015f8:	0f b6 00             	movzbl (%eax),%eax
c01015fb:	0f b6 d0             	movzbl %al,%edx
c01015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101601:	0f b6 00             	movzbl (%eax),%eax
c0101604:	0f b6 c0             	movzbl %al,%eax
c0101607:	29 c2                	sub    %eax,%edx
c0101609:	89 d0                	mov    %edx,%eax
}
c010160b:	5d                   	pop    %ebp
c010160c:	c3                   	ret    

c010160d <strcpy>:
static inline void strcpy(char* dest, const char* source) 
{
c010160d:	55                   	push   %ebp
c010160e:	89 e5                	mov    %esp,%ebp
c0101610:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c0101613:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c010161a:	eb 04                	jmp    c0101620 <strcpy+0x13>
    {
        i++;
c010161c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c0101620:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	01 d0                	add    %edx,%eax
c0101628:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c010162b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010162e:	01 ca                	add    %ecx,%edx
c0101630:	0f b6 12             	movzbl (%edx),%edx
c0101633:	88 10                	mov    %dl,(%eax)
c0101635:	0f b6 00             	movzbl (%eax),%eax
c0101638:	84 c0                	test   %al,%al
c010163a:	75 e0                	jne    c010161c <strcpy+0xf>
    {
        i++;
    } 
}
c010163c:	c9                   	leave  
c010163d:	c3                   	ret    

c010163e <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c010163e:	55                   	push   %ebp
c010163f:	89 e5                	mov    %esp,%ebp
c0101641:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101644:	90                   	nop
c0101645:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010164f:	89 c2                	mov    %eax,%edx
c0101651:	ec                   	in     (%dx),%al
c0101652:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101655:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101659:	0f b6 c0             	movzbl %al,%eax
c010165c:	25 c0 00 00 00       	and    $0xc0,%eax
c0101661:	83 f8 40             	cmp    $0x40,%eax
c0101664:	75 df                	jne    c0101645 <waitdisk+0x7>
}
c0101666:	c9                   	leave  
c0101667:	c3                   	ret    

c0101668 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0101668:	55                   	push   %ebp
c0101669:	89 e5                	mov    %esp,%ebp
c010166b:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c010166e:	e8 cb ff ff ff       	call   c010163e <waitdisk>
c0101673:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c010167a:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010167e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101682:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101685:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101689:	0f b6 c0             	movzbl %al,%eax
c010168c:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101693:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101696:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010169a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010169d:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c010169e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016a1:	c1 f8 08             	sar    $0x8,%eax
c01016a4:	0f b6 c0             	movzbl %al,%eax
c01016a7:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01016ae:	88 45 e7             	mov    %al,-0x19(%ebp)
c01016b1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01016b8:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01016b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016bc:	c1 f8 10             	sar    $0x10,%eax
c01016bf:	0f b6 c0             	movzbl %al,%eax
c01016c2:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01016c9:	88 45 df             	mov    %al,-0x21(%ebp)
c01016cc:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01016d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01016d3:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016d7:	c1 f8 18             	sar    $0x18,%eax
c01016da:	83 c8 e0             	or     $0xffffffe0,%eax
c01016dd:	0f b6 c0             	movzbl %al,%eax
c01016e0:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c01016e7:	88 45 d7             	mov    %al,-0x29(%ebp)
c01016ea:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01016ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01016f1:	ee                   	out    %al,(%dx)
c01016f2:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c01016f9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c01016fd:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101701:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101705:	e8 34 ff ff ff       	call   c010163e <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010170a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101711:	eb 29                	jmp    c010173c <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101713:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010171d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101720:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101723:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c010172a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010172d:	89 c2                	mov    %eax,%edx
c010172f:	ed                   	in     (%dx),%eax
c0101730:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101733:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101736:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101738:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010173c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101740:	7e d1                	jle    c0101713 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101742:	c9                   	leave  
c0101743:	c3                   	ret    

c0101744 <writesect>:
static inline void
writesect(void *dst, int offset) {
c0101744:	55                   	push   %ebp
c0101745:	89 e5                	mov    %esp,%ebp
c0101747:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c010174a:	e8 ef fe ff ff       	call   c010163e <waitdisk>
c010174f:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0101756:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010175a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010175e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101761:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101762:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101765:	0f b6 c0             	movzbl %al,%eax
c0101768:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c010176f:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101772:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101776:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101779:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c010177a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010177d:	c1 f8 08             	sar    $0x8,%eax
c0101780:	0f b6 c0             	movzbl %al,%eax
c0101783:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c010178a:	88 45 e7             	mov    %al,-0x19(%ebp)
c010178d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101791:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101798:	c1 f8 10             	sar    $0x10,%eax
c010179b:	0f b6 c0             	movzbl %al,%eax
c010179e:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01017a5:	88 45 df             	mov    %al,-0x21(%ebp)
c01017a8:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017b3:	c1 f8 18             	sar    $0x18,%eax
c01017b6:	83 c8 e0             	or     $0xffffffe0,%eax
c01017b9:	0f b6 c0             	movzbl %al,%eax
c01017bc:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c01017c3:	88 45 d7             	mov    %al,-0x29(%ebp)
c01017c6:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01017ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01017cd:	ee                   	out    %al,(%dx)
c01017ce:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c01017d5:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
c01017d9:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c01017dd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x30);

    waitdisk();
c01017e1:	e8 58 fe ff ff       	call   c010163e <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01017e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01017ed:	eb 26                	jmp    c0101815 <writesect+0xd1>
        outl(0x1F0, ((int *)(dst))[i]);
c01017ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01017f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01017fc:	01 d0                	add    %edx,%eax
c01017fe:	8b 00                	mov    (%eax),%eax
c0101800:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)
c0101807:	89 45 c4             	mov    %eax,-0x3c(%ebp)
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
c010180a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010180d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0101810:	ef                   	out    %eax,(%dx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x30);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101811:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101815:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101819:	7e d4                	jle    c01017ef <writesect+0xab>
        outl(0x1F0, ((int *)(dst))[i]);
    }
}
c010181b:	c9                   	leave  
c010181c:	c3                   	ret    

c010181d <readBitmap>:
struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
c010181d:	55                   	push   %ebp
c010181e:	89 e5                	mov    %esp,%ebp
c0101820:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c0101823:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010182a:	eb 22                	jmp    c010184e <readBitmap+0x31>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c010182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010182f:	c1 e0 09             	shl    $0x9,%eax
c0101832:	8d 50 01             	lea    0x1(%eax),%edx
c0101835:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101838:	c1 e0 09             	shl    $0x9,%eax
c010183b:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101840:	52                   	push   %edx
c0101841:	50                   	push   %eax
c0101842:	e8 21 fe ff ff       	call   c0101668 <readsect>
c0101847:	83 c4 08             	add    $0x8,%esp
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c010184a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010184e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101855:	7e d5                	jle    c010182c <readBitmap+0xf>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c0101857:	c9                   	leave  
c0101858:	c3                   	ret    

c0101859 <saveBitmap>:

void saveBitmap(){
c0101859:	55                   	push   %ebp
c010185a:	89 e5                	mov    %esp,%ebp
c010185c:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c010185f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101866:	eb 22                	jmp    c010188a <saveBitmap+0x31>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c0101868:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010186b:	c1 e0 09             	shl    $0x9,%eax
c010186e:	8d 50 01             	lea    0x1(%eax),%edx
c0101871:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101874:	c1 e0 09             	shl    $0x9,%eax
c0101877:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c010187c:	52                   	push   %edx
c010187d:	50                   	push   %eax
c010187e:	e8 c1 fe ff ff       	call   c0101744 <writesect>
c0101883:	83 c4 08             	add    $0x8,%esp
	}
}

void saveBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c0101886:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010188a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101891:	7e d5                	jle    c0101868 <saveBitmap+0xf>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c0101893:	c9                   	leave  
c0101894:	c3                   	ret    

c0101895 <readDir>:
void readDir(int offset){
c0101895:	55                   	push   %ebp
c0101896:	89 e5                	mov    %esp,%ebp
	readsect(dir.entries, LOC_DIR(offset));
c0101898:	8b 45 08             	mov    0x8(%ebp),%eax
c010189b:	05 01 01 00 00       	add    $0x101,%eax
c01018a0:	50                   	push   %eax
c01018a1:	68 40 c3 1f c0       	push   $0xc01fc340
c01018a6:	e8 bd fd ff ff       	call   c0101668 <readsect>
c01018ab:	83 c4 08             	add    $0x8,%esp
}
c01018ae:	c9                   	leave  
c01018af:	c3                   	ret    

c01018b0 <saveDir>:
void saveDir(int offset){
c01018b0:	55                   	push   %ebp
c01018b1:	89 e5                	mov    %esp,%ebp
	writesect(dir.entries, LOC_DIR(offset));
c01018b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b6:	05 01 01 00 00       	add    $0x101,%eax
c01018bb:	50                   	push   %eax
c01018bc:	68 40 c3 1f c0       	push   $0xc01fc340
c01018c1:	e8 7e fe ff ff       	call   c0101744 <writesect>
c01018c6:	83 c4 08             	add    $0x8,%esp
}
c01018c9:	c9                   	leave  
c01018ca:	c3                   	ret    

c01018cb <readINode>:
void readINode(int offset){
c01018cb:	55                   	push   %ebp
c01018cc:	89 e5                	mov    %esp,%ebp
	readsect(inode.data_block_offsets, LOC_INODE(offset));
c01018ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01018d1:	05 01 02 00 00       	add    $0x201,%eax
c01018d6:	50                   	push   %eax
c01018d7:	68 40 c5 1f c0       	push   $0xc01fc540
c01018dc:	e8 87 fd ff ff       	call   c0101668 <readsect>
c01018e1:	83 c4 08             	add    $0x8,%esp
}
c01018e4:	c9                   	leave  
c01018e5:	c3                   	ret    

c01018e6 <saveINode>:
void saveINode(int offset){
c01018e6:	55                   	push   %ebp
c01018e7:	89 e5                	mov    %esp,%ebp
	writesect(inode.data_block_offsets, LOC_INODE(offset));
c01018e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01018ec:	05 01 02 00 00       	add    $0x201,%eax
c01018f1:	50                   	push   %eax
c01018f2:	68 40 c5 1f c0       	push   $0xc01fc540
c01018f7:	e8 48 fe ff ff       	call   c0101744 <writesect>
c01018fc:	83 c4 08             	add    $0x8,%esp
}
c01018ff:	c9                   	leave  
c0101900:	c3                   	ret    

c0101901 <readData>:
void readData(int offset){
c0101901:	55                   	push   %ebp
c0101902:	89 e5                	mov    %esp,%ebp
	readsect(buffer, LOC_DATA(offset));
c0101904:	8b 45 08             	mov    0x8(%ebp),%eax
c0101907:	05 01 03 00 00       	add    $0x301,%eax
c010190c:	50                   	push   %eax
c010190d:	68 40 c1 1f c0       	push   $0xc01fc140
c0101912:	e8 51 fd ff ff       	call   c0101668 <readsect>
c0101917:	83 c4 08             	add    $0x8,%esp
}
c010191a:	c9                   	leave  
c010191b:	c3                   	ret    

c010191c <saveData>:
void saveData(int offset){
c010191c:	55                   	push   %ebp
c010191d:	89 e5                	mov    %esp,%ebp
	writesect(buffer, LOC_DATA(offset));
c010191f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101922:	05 01 03 00 00       	add    $0x301,%eax
c0101927:	50                   	push   %eax
c0101928:	68 40 c1 1f c0       	push   $0xc01fc140
c010192d:	e8 12 fe ff ff       	call   c0101744 <writesect>
c0101932:	83 c4 08             	add    $0x8,%esp
}
c0101935:	c9                   	leave  
c0101936:	c3                   	ret    

c0101937 <INodeAlloc>:
int INodeAlloc(){
c0101937:	55                   	push   %ebp
c0101938:	89 e5                	mov    %esp,%ebp
c010193a:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c010193d:	e8 db fe ff ff       	call   c010181d <readBitmap>
	int i = 0;
c0101942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_INODE; i++){
c0101949:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101950:	eb 69                	jmp    c01019bb <INodeAlloc+0x84>
		int sec = LOC_INODE(i);
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	05 01 02 00 00       	add    $0x201,%eax
c010195a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c010195d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101960:	c1 f8 03             	sar    $0x3,%eax
c0101963:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101966:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101969:	83 e0 07             	and    $0x7,%eax
c010196c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101971:	89 c1                	mov    %eax,%ecx
c0101973:	d3 e2                	shl    %cl,%edx
c0101975:	89 d0                	mov    %edx,%eax
c0101977:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c010197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010197d:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101982:	0f b6 00             	movzbl (%eax),%eax
c0101985:	0f b6 c0             	movzbl %al,%eax
c0101988:	23 45 f0             	and    -0x10(%ebp),%eax
c010198b:	85 c0                	test   %eax,%eax
c010198d:	75 28                	jne    c01019b7 <INodeAlloc+0x80>
			bitmap.mask[secN] |= secR;
c010198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101992:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101997:	0f b6 00             	movzbl (%eax),%eax
c010199a:	89 c2                	mov    %eax,%edx
c010199c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010199f:	09 d0                	or     %edx,%eax
c01019a1:	89 c2                	mov    %eax,%edx
c01019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019a6:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01019ab:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c01019ad:	e8 a7 fe ff ff       	call   c0101859 <saveBitmap>
			return i;
c01019b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b5:	eb 12                	jmp    c01019c9 <INodeAlloc+0x92>
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
c01019b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019bb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019c2:	7e 8e                	jle    c0101952 <INodeAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c01019c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c01019c9:	c9                   	leave  
c01019ca:	c3                   	ret    

c01019cb <dataAlloc>:
int dataAlloc(){
c01019cb:	55                   	push   %ebp
c01019cc:	89 e5                	mov    %esp,%ebp
c01019ce:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c01019d1:	e8 47 fe ff ff       	call   c010181d <readBitmap>
	int i = 0;
c01019d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_DATA; i++){
c01019dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019e4:	eb 69                	jmp    c0101a4f <dataAlloc+0x84>
		int sec = LOC_DATA(i);
c01019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e9:	05 01 03 00 00       	add    $0x301,%eax
c01019ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c01019f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019f4:	c1 f8 03             	sar    $0x3,%eax
c01019f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c01019fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019fd:	83 e0 07             	and    $0x7,%eax
c0101a00:	ba 01 00 00 00       	mov    $0x1,%edx
c0101a05:	89 c1                	mov    %eax,%ecx
c0101a07:	d3 e2                	shl    %cl,%edx
c0101a09:	89 d0                	mov    %edx,%eax
c0101a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a11:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a16:	0f b6 00             	movzbl (%eax),%eax
c0101a19:	0f b6 c0             	movzbl %al,%eax
c0101a1c:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a1f:	85 c0                	test   %eax,%eax
c0101a21:	75 28                	jne    c0101a4b <dataAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a26:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a2b:	0f b6 00             	movzbl (%eax),%eax
c0101a2e:	89 c2                	mov    %eax,%edx
c0101a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a33:	09 d0                	or     %edx,%eax
c0101a35:	89 c2                	mov    %eax,%edx
c0101a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a3a:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a3f:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101a41:	e8 13 fe ff ff       	call   c0101859 <saveBitmap>
			return i;
c0101a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a49:	eb 12                	jmp    c0101a5d <dataAlloc+0x92>
	return -1;
}
int dataAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
c0101a4b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a4f:	81 7d fc ff 7f 00 00 	cmpl   $0x7fff,-0x4(%ebp)
c0101a56:	7e 8e                	jle    c01019e6 <dataAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101a5d:	c9                   	leave  
c0101a5e:	c3                   	ret    

c0101a5f <fs_open_kr>:

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
c0101a5f:	55                   	push   %ebp
c0101a60:	89 e5                	mov    %esp,%ebp
c0101a62:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0101a65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a6c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0101a73:	eb 4c                	jmp    c0101ac1 <fs_open_kr+0x62>
		readDir(dir_offset);
c0101a75:	ff 75 fc             	pushl  -0x4(%ebp)
c0101a78:	e8 18 fe ff ff       	call   c0101895 <readDir>
c0101a7d:	83 c4 04             	add    $0x4,%esp

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101a80:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101a87:	eb 2c                	jmp    c0101ab5 <fs_open_kr+0x56>
			//printk("%d %d", dir_offset, entry_offset);
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
c0101a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a8c:	c1 e0 05             	shl    $0x5,%eax
c0101a8f:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c0101a94:	ff 75 08             	pushl  0x8(%ebp)
c0101a97:	50                   	push   %eax
c0101a98:	e8 31 fb ff ff       	call   c01015ce <strcmp>
c0101a9d:	83 c4 08             	add    $0x8,%esp
c0101aa0:	85 c0                	test   %eax,%eax
c0101aa2:	75 0d                	jne    c0101ab1 <fs_open_kr+0x52>
				goto OUT_OF_LOOP;
c0101aa4:	90                   	nop
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101aac:	e9 2f 01 00 00       	jmp    c0101be0 <fs_open_kr+0x181>
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101ab1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101ab5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ab8:	83 f8 0f             	cmp    $0xf,%eax
c0101abb:	76 cc                	jbe    c0101a89 <fs_open_kr+0x2a>
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
c0101abd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0101ac1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101ac8:	7e ab                	jle    c0101a75 <fs_open_kr+0x16>
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
c0101aca:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0101acb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101ad0:	e9 1d 01 00 00       	jmp    c0101bf2 <fs_open_kr+0x193>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ad8:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101ade:	05 20 02 00 00       	add    $0x220,%eax
c0101ae3:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101ae8:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0101aec:	84 c0                	test   %al,%al
c0101aee:	0f 85 e8 00 00 00    	jne    c0101bdc <fs_open_kr+0x17d>
			fs[i].used = 1;
c0101af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101af7:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101afd:	05 20 02 00 00       	add    $0x220,%eax
c0101b02:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b07:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b0e:	c1 e0 05             	shl    $0x5,%eax
c0101b11:	83 c0 10             	add    $0x10,%eax
c0101b14:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c0101b19:	8b 40 08             	mov    0x8(%eax),%eax
c0101b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b1f:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101b25:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101b2b:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101b31:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b37:	c1 e0 05             	shl    $0x5,%eax
c0101b3a:	8d 90 40 c3 1f c0    	lea    -0x3fe03cc0(%eax),%edx
c0101b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b43:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b49:	05 10 02 00 00       	add    $0x210,%eax
c0101b4e:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b53:	83 c0 04             	add    $0x4,%eax
c0101b56:	52                   	push   %edx
c0101b57:	50                   	push   %eax
c0101b58:	e8 b0 fa ff ff       	call   c010160d <strcpy>
c0101b5d:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101b60:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b63:	c1 e0 05             	shl    $0x5,%eax
c0101b66:	83 c0 10             	add    $0x10,%eax
c0101b69:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c0101b6e:	8b 40 0c             	mov    0xc(%eax),%eax
c0101b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b74:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101b7a:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101b80:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101b86:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("$%d %d$\n", fs[i].file_size, fs[i].inode_offset);
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b8c:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b92:	05 00 02 00 00       	add    $0x200,%eax
c0101b97:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0101ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101ba8:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101bae:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101bb4:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101bba:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0101bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bc3:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101bc9:	81 c2 10 02 00 00    	add    $0x210,%edx
c0101bcf:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101bd5:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bda:	eb 16                	jmp    c0101bf2 <fs_open_kr+0x193>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101bdc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101be0:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0101be7:	0f 8e e8 fe ff ff    	jle    c0101ad5 <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101bf2:	c9                   	leave  
c0101bf3:	c3                   	ret    

c0101bf4 <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101bf4:	55                   	push   %ebp
c0101bf5:	89 e5                	mov    %esp,%ebp
c0101bf7:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfd:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c03:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c08:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101c0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c0e:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101c14:	50                   	push   %eax
c0101c15:	e8 b1 fc ff ff       	call   c01018cb <readINode>
c0101c1a:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101c1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101c24:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c27:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c2d:	c1 e8 09             	shr    $0x9,%eax
c0101c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c36:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c3c:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101c44:	8b 55 10             	mov    0x10(%ebp),%edx
c0101c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c4a:	01 d0                	add    %edx,%eax
c0101c4c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c51:	0f 86 2d 01 00 00    	jbe    c0101d84 <fs_read_base_kr+0x190>
		readData(inode.data_block_offsets[D]);
c0101c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c5a:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101c61:	50                   	push   %eax
c0101c62:	e8 9a fc ff ff       	call   c0101901 <readData>
c0101c67:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101c6a:	b8 00 02 00 00       	mov    $0x200,%eax
c0101c6f:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101c72:	89 c2                	mov    %eax,%edx
c0101c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c77:	05 40 c1 1f c0       	add    $0xc01fc140,%eax
c0101c7c:	52                   	push   %edx
c0101c7d:	50                   	push   %eax
c0101c7e:	ff 75 0c             	pushl  0xc(%ebp)
c0101c81:	e8 12 f9 ff ff       	call   c0101598 <memcpy2>
c0101c86:	83 c4 0c             	add    $0xc,%esp
		f->offset += BLOCK_SIZE-R;
c0101c89:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c8c:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c92:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101c95:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101c9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c9e:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ca7:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101caa:	05 00 02 00 00       	add    $0x200,%eax
c0101caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101cb2:	8b 55 10             	mov    0x10(%ebp),%edx
c0101cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb8:	01 d0                	add    %edx,%eax
c0101cba:	2d 00 02 00 00       	sub    $0x200,%eax
c0101cbf:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101cc2:	eb 63                	jmp    c0101d27 <fs_read_base_kr+0x133>
			D = f->offset >> 9;
c0101cc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cc7:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ccd:	c1 e8 09             	shr    $0x9,%eax
c0101cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
c0101cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cd6:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101cdd:	50                   	push   %eax
c0101cde:	e8 1e fc ff ff       	call   c0101901 <readData>
c0101ce3:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101cec:	01 d0                	add    %edx,%eax
c0101cee:	68 00 02 00 00       	push   $0x200
c0101cf3:	68 40 c1 1f c0       	push   $0xc01fc140
c0101cf8:	50                   	push   %eax
c0101cf9:	e8 9a f8 ff ff       	call   c0101598 <memcpy2>
c0101cfe:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101d01:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101d08:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d0b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d11:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d1a:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101d20:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d27:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101d2e:	7f 94                	jg     c0101cc4 <fs_read_base_kr+0xd0>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d33:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d39:	c1 e8 09             	shr    $0x9,%eax
c0101d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d42:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101d49:	50                   	push   %eax
c0101d4a:	e8 b2 fb ff ff       	call   c0101901 <readData>
c0101d4f:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101d52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d58:	01 d0                	add    %edx,%eax
c0101d5a:	ff 75 10             	pushl  0x10(%ebp)
c0101d5d:	68 40 c1 1f c0       	push   $0xc01fc140
c0101d62:	50                   	push   %eax
c0101d63:	e8 30 f8 ff ff       	call   c0101598 <memcpy2>
c0101d68:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101d6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d6e:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101d74:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d77:	01 c2                	add    %eax,%edx
c0101d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d7c:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101d82:	eb 41                	jmp    c0101dc5 <fs_read_base_kr+0x1d1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d87:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101d8e:	50                   	push   %eax
c0101d8f:	e8 6d fb ff ff       	call   c0101901 <readData>
c0101d94:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d9a:	05 40 c1 1f c0       	add    $0xc01fc140,%eax
c0101d9f:	ff 75 10             	pushl  0x10(%ebp)
c0101da2:	50                   	push   %eax
c0101da3:	ff 75 0c             	pushl  0xc(%ebp)
c0101da6:	e8 ed f7 ff ff       	call   c0101598 <memcpy2>
c0101dab:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101db1:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101db7:	8b 45 10             	mov    0x10(%ebp),%eax
c0101dba:	01 c2                	add    %eax,%edx
c0101dbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dbf:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101dc5:	c9                   	leave  
c0101dc6:	c3                   	ret    

c0101dc7 <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101dc7:	55                   	push   %ebp
c0101dc8:	89 e5                	mov    %esp,%ebp
c0101dca:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd0:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101dd6:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101de1:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101de7:	8b 45 10             	mov    0x10(%ebp),%eax
c0101dea:	01 c2                	add    %eax,%edx
c0101dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101def:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101df5:	39 c2                	cmp    %eax,%edx
c0101df7:	72 19                	jb     c0101e12 <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dfc:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e05:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e0b:	29 c2                	sub    %eax,%edx
c0101e0d:	89 d0                	mov    %edx,%eax
c0101e0f:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	if(len == 0)
c0101e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0101e16:	75 07                	jne    c0101e1f <fs_read_kr+0x58>
		return -1;
c0101e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101e1d:	eb 14                	jmp    c0101e33 <fs_read_kr+0x6c>
	fs_read_base_kr(fd, buf, len);
c0101e1f:	ff 75 10             	pushl  0x10(%ebp)
c0101e22:	ff 75 0c             	pushl  0xc(%ebp)
c0101e25:	ff 75 08             	pushl  0x8(%ebp)
c0101e28:	e8 c7 fd ff ff       	call   c0101bf4 <fs_read_base_kr>
c0101e2d:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101e30:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101e33:	c9                   	leave  
c0101e34:	c3                   	ret    

c0101e35 <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101e35:	55                   	push   %ebp
c0101e36:	89 e5                	mov    %esp,%ebp
c0101e38:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e3e:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101e44:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101e4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e4f:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101e55:	50                   	push   %eax
c0101e56:	e8 70 fa ff ff       	call   c01018cb <readINode>
c0101e5b:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e68:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e6e:	c1 e8 09             	shr    $0x9,%eax
c0101e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e77:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e7d:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101e82:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101e85:	8b 55 10             	mov    0x10(%ebp),%edx
c0101e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e8b:	01 d0                	add    %edx,%eax
c0101e8d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101e92:	0f 86 53 01 00 00    	jbe    c0101feb <fs_write_base_kr+0x1b6>
		readData(inode.data_block_offsets[D]);
c0101e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e9b:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101ea2:	50                   	push   %eax
c0101ea3:	e8 59 fa ff ff       	call   c0101901 <readData>
c0101ea8:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101eab:	b8 00 02 00 00       	mov    $0x200,%eax
c0101eb0:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101eb3:	89 c2                	mov    %eax,%edx
c0101eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101eb8:	05 40 c1 1f c0       	add    $0xc01fc140,%eax
c0101ebd:	52                   	push   %edx
c0101ebe:	ff 75 0c             	pushl  0xc(%ebp)
c0101ec1:	50                   	push   %eax
c0101ec2:	e8 d1 f6 ff ff       	call   c0101598 <memcpy2>
c0101ec7:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ecd:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101ed4:	50                   	push   %eax
c0101ed5:	e8 42 fa ff ff       	call   c010191c <saveData>
c0101eda:	83 c4 04             	add    $0x4,%esp
		f->offset += BLOCK_SIZE-R;
c0101edd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ee0:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ee6:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101ee9:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ef2:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101efb:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101efe:	05 00 02 00 00       	add    $0x200,%eax
c0101f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101f06:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f0c:	01 d0                	add    %edx,%eax
c0101f0e:	2d 00 02 00 00       	sub    $0x200,%eax
c0101f13:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f16:	eb 63                	jmp    c0101f7b <fs_write_base_kr+0x146>
			D = f->offset >> 9;
c0101f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f1b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f21:	c1 e8 09             	shr    $0x9,%eax
c0101f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101f27:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f2d:	01 d0                	add    %edx,%eax
c0101f2f:	68 00 02 00 00       	push   $0x200
c0101f34:	50                   	push   %eax
c0101f35:	68 40 c1 1f c0       	push   $0xc01fc140
c0101f3a:	e8 59 f6 ff ff       	call   c0101598 <memcpy2>
c0101f3f:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f45:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101f4c:	50                   	push   %eax
c0101f4d:	e8 ca f9 ff ff       	call   c010191c <saveData>
c0101f52:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c0101f55:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f5f:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f65:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f6e:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101f74:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f7b:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101f82:	7f 94                	jg     c0101f18 <fs_write_base_kr+0xe3>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101f84:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f87:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f8d:	c1 e8 09             	shr    $0x9,%eax
c0101f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f96:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101f9d:	50                   	push   %eax
c0101f9e:	e8 5e f9 ff ff       	call   c0101901 <readData>
c0101fa3:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c0101fa6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fac:	01 d0                	add    %edx,%eax
c0101fae:	ff 75 10             	pushl  0x10(%ebp)
c0101fb1:	50                   	push   %eax
c0101fb2:	68 40 c1 1f c0       	push   $0xc01fc140
c0101fb7:	e8 dc f5 ff ff       	call   c0101598 <memcpy2>
c0101fbc:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fc2:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101fc9:	50                   	push   %eax
c0101fca:	e8 4d f9 ff ff       	call   c010191c <saveData>
c0101fcf:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0101fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fd5:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101fdb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fde:	01 c2                	add    %eax,%edx
c0101fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fe3:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101fe9:	eb 54                	jmp    c010203f <fs_write_base_kr+0x20a>
	}else{
		readData(inode.data_block_offsets[D]);
c0101feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fee:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c0101ff5:	50                   	push   %eax
c0101ff6:	e8 06 f9 ff ff       	call   c0101901 <readData>
c0101ffb:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c0101ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102001:	05 40 c1 1f c0       	add    $0xc01fc140,%eax
c0102006:	ff 75 10             	pushl  0x10(%ebp)
c0102009:	ff 75 0c             	pushl  0xc(%ebp)
c010200c:	50                   	push   %eax
c010200d:	e8 86 f5 ff ff       	call   c0101598 <memcpy2>
c0102012:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102015:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102018:	8b 04 85 40 c5 1f c0 	mov    -0x3fe03ac0(,%eax,4),%eax
c010201f:	50                   	push   %eax
c0102020:	e8 f7 f8 ff ff       	call   c010191c <saveData>
c0102025:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0102028:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010202b:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102031:	8b 45 10             	mov    0x10(%ebp),%eax
c0102034:	01 c2                	add    %eax,%edx
c0102036:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102039:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c010203f:	c9                   	leave  
c0102040:	c3                   	ret    

c0102041 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c0102041:	55                   	push   %ebp
c0102042:	89 e5                	mov    %esp,%ebp
c0102044:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102047:	8b 45 08             	mov    0x8(%ebp),%eax
c010204a:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102050:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	if(f->file_size == 0){
c0102058:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010205b:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102061:	85 c0                	test   %eax,%eax
c0102063:	75 48                	jne    c01020ad <fs_write_kr+0x6c>
		readINode(f->inode_offset);
c0102065:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102068:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010206e:	50                   	push   %eax
c010206f:	e8 57 f8 ff ff       	call   c01018cb <readINode>
c0102074:	83 c4 04             	add    $0x4,%esp
		inode.data_block_offsets[0] = dataAlloc();
c0102077:	e8 4f f9 ff ff       	call   c01019cb <dataAlloc>
c010207c:	a3 40 c5 1f c0       	mov    %eax,0xc01fc540
		saveINode(f->inode_offset);
c0102081:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102084:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010208a:	50                   	push   %eax
c010208b:	e8 56 f8 ff ff       	call   c01018e6 <saveINode>
c0102090:	83 c4 04             	add    $0x4,%esp
		f->file_size = len>512?512:len;
c0102093:	8b 45 10             	mov    0x10(%ebp),%eax
c0102096:	3d 00 02 00 00       	cmp    $0x200,%eax
c010209b:	7e 05                	jle    c01020a2 <fs_write_kr+0x61>
c010209d:	b8 00 02 00 00       	mov    $0x200,%eax
c01020a2:	89 c2                	mov    %eax,%edx
c01020a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020a7:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
		//printk("legal high %d\n", f->file_size);
	}
	
	if(f->offset + len > f->file_size){
c01020ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020b0:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01020b9:	01 c2                	add    %eax,%edx
c01020bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020be:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01020c4:	39 c2                	cmp    %eax,%edx
c01020c6:	0f 86 81 00 00 00    	jbe    c010214d <fs_write_kr+0x10c>
		readINode(f->inode_offset);
c01020cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020cf:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020d5:	50                   	push   %eax
c01020d6:	e8 f0 f7 ff ff       	call   c01018cb <readINode>
c01020db:	83 c4 04             	add    $0x4,%esp
		D1 = f->offset >> 9;
c01020de:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020e1:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c01020e7:	c1 e8 09             	shr    $0x9,%eax
c01020ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
		D2 = (f->offset + len) >> 9;
c01020ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020f0:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01020f9:	01 d0                	add    %edx,%eax
c01020fb:	c1 e8 09             	shr    $0x9,%eax
c01020fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		D1 += 1;
c0102101:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
		while(D1<=D2){
c0102105:	eb 15                	jmp    c010211c <fs_write_kr+0xdb>
			inode.data_block_offsets[D1] = dataAlloc();
c0102107:	e8 bf f8 ff ff       	call   c01019cb <dataAlloc>
c010210c:	89 c2                	mov    %eax,%edx
c010210e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102111:	89 14 85 40 c5 1f c0 	mov    %edx,-0x3fe03ac0(,%eax,4)
			D1 ++;
c0102118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	if(f->offset + len > f->file_size){
		readINode(f->inode_offset);
		D1 = f->offset >> 9;
		D2 = (f->offset + len) >> 9;
		D1 += 1;
		while(D1<=D2){
c010211c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010211f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102122:	7e e3                	jle    c0102107 <fs_write_kr+0xc6>
			inode.data_block_offsets[D1] = dataAlloc();
			D1 ++;
		}
		saveINode(f->inode_offset);
c0102124:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102127:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010212d:	50                   	push   %eax
c010212e:	e8 b3 f7 ff ff       	call   c01018e6 <saveINode>
c0102133:	83 c4 04             	add    $0x4,%esp
		f->file_size = f->offset + len;
c0102136:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102139:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c010213f:	8b 45 10             	mov    0x10(%ebp),%eax
c0102142:	01 c2                	add    %eax,%edx
c0102144:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102147:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	};
	readDir(f->dir_offset);
c010214d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102150:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c0102156:	50                   	push   %eax
c0102157:	e8 39 f7 ff ff       	call   c0101895 <readDir>
c010215c:	83 c4 04             	add    $0x4,%esp
	dir.entries[f->entry_offset].file_size = f->file_size;
c010215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102162:	8b 90 10 02 00 00    	mov    0x210(%eax),%edx
c0102168:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010216b:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102171:	c1 e2 05             	shl    $0x5,%edx
c0102174:	83 c2 10             	add    $0x10,%edx
c0102177:	81 c2 40 c3 1f c0    	add    $0xc01fc340,%edx
c010217d:	89 42 08             	mov    %eax,0x8(%edx)
	saveDir(f->dir_offset);
c0102180:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102183:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c0102189:	50                   	push   %eax
c010218a:	e8 21 f7 ff ff       	call   c01018b0 <saveDir>
c010218f:	83 c4 04             	add    $0x4,%esp
	fs_write_base_kr(fd, buf, len);
c0102192:	ff 75 10             	pushl  0x10(%ebp)
c0102195:	ff 75 0c             	pushl  0xc(%ebp)
c0102198:	ff 75 08             	pushl  0x8(%ebp)
c010219b:	e8 95 fc ff ff       	call   c0101e35 <fs_write_base_kr>
c01021a0:	83 c4 0c             	add    $0xc,%esp
	return len;
c01021a3:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c01021a6:	c9                   	leave  
c01021a7:	c3                   	ret    

c01021a8 <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c01021a8:	55                   	push   %ebp
c01021a9:	89 e5                	mov    %esp,%ebp
c01021ab:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01021ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b1:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01021b7:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01021bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c01021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021c5:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c01021cb:	c9                   	leave  
c01021cc:	c3                   	ret    

c01021cd <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c01021cd:	55                   	push   %ebp
c01021ce:	89 e5                	mov    %esp,%ebp
c01021d0:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01021d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d6:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01021dc:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01021e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c01021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e7:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
	}
c01021ed:	c9                   	leave  
c01021ee:	c3                   	ret    

c01021ef <fs_close_kr>:
int fs_close_kr(int fd){
c01021ef:	55                   	push   %ebp
c01021f0:	89 e5                	mov    %esp,%ebp
c01021f2:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01021f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f8:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01021fe:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->used){
c0102206:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102209:	0f b6 80 2c 02 00 00 	movzbl 0x22c(%eax),%eax
c0102210:	84 c0                	test   %al,%al
c0102212:	74 11                	je     c0102225 <fs_close_kr+0x36>
		f->used = 0;
c0102214:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102217:	c6 80 2c 02 00 00 00 	movb   $0x0,0x22c(%eax)
		return 0;
c010221e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102223:	eb 05                	jmp    c010222a <fs_close_kr+0x3b>
	}else
		return 1;
c0102225:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010222a:	c9                   	leave  
c010222b:	c3                   	ret    

c010222c <some>:
void some(){
c010222c:	55                   	push   %ebp
c010222d:	89 e5                	mov    %esp,%ebp

}
c010222f:	5d                   	pop    %ebp
c0102230:	c3                   	ret    

c0102231 <fs_create_kr>:
int fs_create_kr(char* name){
c0102231:	55                   	push   %ebp
c0102232:	89 e5                	mov    %esp,%ebp
c0102234:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0102237:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010223e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0102245:	e9 d8 00 00 00       	jmp    c0102322 <fs_create_kr+0xf1>
		readDir(dir_offset);
c010224a:	ff 75 fc             	pushl  -0x4(%ebp)
c010224d:	e8 43 f6 ff ff       	call   c0101895 <readDir>
c0102252:	83 c4 04             	add    $0x4,%esp
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0102255:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010225c:	e9 b1 00 00 00       	jmp    c0102312 <fs_create_kr+0xe1>
			if(dir.entries[entry_offset].inode_offset == -1)
c0102261:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102264:	c1 e0 05             	shl    $0x5,%eax
c0102267:	83 c0 10             	add    $0x10,%eax
c010226a:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c010226f:	8b 40 0c             	mov    0xc(%eax),%eax
c0102272:	83 f8 ff             	cmp    $0xffffffff,%eax
c0102275:	0f 85 93 00 00 00    	jne    c010230e <fs_create_kr+0xdd>
				goto OUT_OF_LOOP;
c010227b:	90                   	nop
	
	//FILE_STREAM *f;
	int i=0;

	OUT_OF_LOOP:
	some();
c010227c:	e8 ab ff ff ff       	call   c010222c <some>
	//printk("##%d\n", entry_offset);
	int index_inode = INodeAlloc();
c0102281:	e8 b1 f6 ff ff       	call   c0101937 <INodeAlloc>
c0102286:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//printk("##%d\n", index_inode);
	dir.entries[entry_offset].inode_offset = index_inode;
c0102289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010228c:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010228f:	c1 e2 05             	shl    $0x5,%edx
c0102292:	83 c2 10             	add    $0x10,%edx
c0102295:	81 c2 40 c3 1f c0    	add    $0xc01fc340,%edx
c010229b:	89 42 0c             	mov    %eax,0xc(%edx)
	strcpy(dir.entries[entry_offset].filename, name);
c010229e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022a1:	c1 e0 05             	shl    $0x5,%eax
c01022a4:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c01022a9:	ff 75 08             	pushl  0x8(%ebp)
c01022ac:	50                   	push   %eax
c01022ad:	e8 5b f3 ff ff       	call   c010160d <strcpy>
c01022b2:	83 c4 08             	add    $0x8,%esp
	//printk("##%s\n", name);
	//printk("##%s\n", dir.entries[entry_offset].filename);
	dir.entries[entry_offset].file_size = 0;
c01022b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022b8:	c1 e0 05             	shl    $0x5,%eax
c01022bb:	83 c0 10             	add    $0x10,%eax
c01022be:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c01022c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
	saveDir(dir_offset);
c01022ca:	ff 75 fc             	pushl  -0x4(%ebp)
c01022cd:	e8 de f5 ff ff       	call   c01018b0 <saveDir>
c01022d2:	83 c4 04             	add    $0x4,%esp

	readINode(index_inode);
c01022d5:	ff 75 f0             	pushl  -0x10(%ebp)
c01022d8:	e8 ee f5 ff ff       	call   c01018cb <readINode>
c01022dd:	83 c4 04             	add    $0x4,%esp
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
c01022e0:	68 00 02 00 00       	push   $0x200
c01022e5:	68 ff 00 00 00       	push   $0xff
c01022ea:	68 40 c5 1f c0       	push   $0xc01fc540
c01022ef:	e8 c1 f2 ff ff       	call   c01015b5 <memset2>
c01022f4:	83 c4 0c             	add    $0xc,%esp
	saveINode(index_inode);
c01022f7:	ff 75 f0             	pushl  -0x10(%ebp)
c01022fa:	e8 e7 f5 ff ff       	call   c01018e6 <saveINode>
c01022ff:	83 c4 04             	add    $0x4,%esp
	for(i=0; i<NR_FILE_STREAM; i++){
c0102302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102309:	e9 37 01 00 00       	jmp    c0102445 <fs_create_kr+0x214>
}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c010230e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102312:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102315:	83 f8 0f             	cmp    $0xf,%eax
c0102318:	0f 86 43 ff ff ff    	jbe    c0102261 <fs_create_kr+0x30>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
c010231e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
void some(){

}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0102322:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102329:	0f 8e 1b ff ff ff    	jle    c010224a <fs_create_kr+0x19>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
	}
	goto FAILURE;
c010232f:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0102330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102335:	e9 1d 01 00 00       	jmp    c0102457 <fs_create_kr+0x226>

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c010233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010233d:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102343:	05 20 02 00 00       	add    $0x220,%eax
c0102348:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c010234d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0102351:	84 c0                	test   %al,%al
c0102353:	0f 85 e8 00 00 00    	jne    c0102441 <fs_create_kr+0x210>
			fs[i].used = 1;
c0102359:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010235c:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102362:	05 20 02 00 00       	add    $0x220,%eax
c0102367:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c010236c:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0102370:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102373:	c1 e0 05             	shl    $0x5,%eax
c0102376:	83 c0 10             	add    $0x10,%eax
c0102379:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c010237e:	8b 40 08             	mov    0x8(%eax),%eax
c0102381:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102384:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010238a:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102390:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0102396:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0102399:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010239c:	c1 e0 05             	shl    $0x5,%eax
c010239f:	8d 90 40 c3 1f c0    	lea    -0x3fe03cc0(%eax),%edx
c01023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023a8:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023ae:	05 10 02 00 00       	add    $0x210,%eax
c01023b3:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01023b8:	83 c0 04             	add    $0x4,%eax
c01023bb:	52                   	push   %edx
c01023bc:	50                   	push   %eax
c01023bd:	e8 4b f2 ff ff       	call   c010160d <strcpy>
c01023c2:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c01023c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01023c8:	c1 e0 05             	shl    $0x5,%eax
c01023cb:	83 c0 10             	add    $0x10,%eax
c01023ce:	05 40 c3 1f c0       	add    $0xc01fc340,%eax
c01023d3:	8b 40 0c             	mov    0xc(%eax),%eax
c01023d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01023d9:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c01023df:	81 c2 00 02 00 00    	add    $0x200,%edx
c01023e5:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c01023eb:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c01023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023f1:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023f7:	05 00 02 00 00       	add    $0x200,%eax
c01023fc:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0102407:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010240a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010240d:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0102413:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102419:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c010241f:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0102422:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102425:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102428:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010242e:	81 c2 10 02 00 00    	add    $0x210,%edx
c0102434:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c010243a:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c010243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010243f:	eb 16                	jmp    c0102457 <fs_create_kr+0x226>
	saveDir(dir_offset);

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
c0102441:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102445:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c010244c:	0f 8e e8 fe ff ff    	jle    c010233a <fs_create_kr+0x109>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0102452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0102457:	c9                   	leave  
c0102458:	c3                   	ret    

c0102459 <fs_open_md>:

int fs_open_md(char *pathname, int flags){
c0102459:	55                   	push   %ebp
c010245a:	89 e5                	mov    %esp,%ebp
c010245c:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_kr(pathname);
c010245f:	ff 75 08             	pushl  0x8(%ebp)
c0102462:	e8 f8 f5 ff ff       	call   c0101a5f <fs_open_kr>
c0102467:	83 c4 04             	add    $0x4,%esp
c010246a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(fd == -1 && flags == 1){
c010246d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
c0102471:	75 14                	jne    c0102487 <fs_open_md+0x2e>
c0102473:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0102477:	75 0e                	jne    c0102487 <fs_open_md+0x2e>
		fd = fs_create_kr(pathname);
c0102479:	ff 75 08             	pushl  0x8(%ebp)
c010247c:	e8 b0 fd ff ff       	call   c0102231 <fs_create_kr>
c0102481:	83 c4 04             	add    $0x4,%esp
c0102484:	89 45 fc             	mov    %eax,-0x4(%ebp)
	};
	//printk("step 1\n");
	return fd;
c0102487:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c010248a:	c9                   	leave  
c010248b:	c3                   	ret    

c010248c <fs_read_md>:
int fs_read_md(int fd, void *buf, int len){
c010248c:	55                   	push   %ebp
c010248d:	89 e5                	mov    %esp,%ebp
	return fs_read_kr(fd, buf, len);
c010248f:	ff 75 10             	pushl  0x10(%ebp)
c0102492:	ff 75 0c             	pushl  0xc(%ebp)
c0102495:	ff 75 08             	pushl  0x8(%ebp)
c0102498:	e8 2a f9 ff ff       	call   c0101dc7 <fs_read_kr>
c010249d:	83 c4 0c             	add    $0xc,%esp
};
c01024a0:	c9                   	leave  
c01024a1:	c3                   	ret    

c01024a2 <fs_write_md>:
int fs_write_md(int fd, void *buf, int len){
c01024a2:	55                   	push   %ebp
c01024a3:	89 e5                	mov    %esp,%ebp
	return fs_write_kr(fd, buf, len);
c01024a5:	ff 75 10             	pushl  0x10(%ebp)
c01024a8:	ff 75 0c             	pushl  0xc(%ebp)
c01024ab:	ff 75 08             	pushl  0x8(%ebp)
c01024ae:	e8 8e fb ff ff       	call   c0102041 <fs_write_kr>
c01024b3:	83 c4 0c             	add    $0xc,%esp
};
c01024b6:	c9                   	leave  
c01024b7:	c3                   	ret    

c01024b8 <fs_lseek_md>:
int fs_lseek_md(int fd, int offset, int whence){
c01024b8:	55                   	push   %ebp
c01024b9:	89 e5                	mov    %esp,%ebp
c01024bb:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01024be:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c1:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01024c7:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01024cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t index = 0;
c01024cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	if(whence == 0){
c01024d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01024da:	75 08                	jne    c01024e4 <fs_lseek_md+0x2c>
		index = offset;
c01024dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01024df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01024e2:	eb 30                	jmp    c0102514 <fs_lseek_md+0x5c>
	}else if(whence == 1){
c01024e4:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
c01024e8:	75 13                	jne    c01024fd <fs_lseek_md+0x45>
		index = f->offset + offset;
c01024ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024ed:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01024f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01024f6:	01 d0                	add    %edx,%eax
c01024f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01024fb:	eb 17                	jmp    c0102514 <fs_lseek_md+0x5c>
	}else if(whence == 2){
c01024fd:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
c0102501:	75 11                	jne    c0102514 <fs_lseek_md+0x5c>
		index = f->file_size + offset;
c0102503:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102506:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c010250c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010250f:	01 d0                	add    %edx,%eax
c0102511:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
	fs_lseek_kr(fd, index);
c0102514:	ff 75 fc             	pushl  -0x4(%ebp)
c0102517:	ff 75 08             	pushl  0x8(%ebp)
c010251a:	e8 89 fc ff ff       	call   c01021a8 <fs_lseek_kr>
c010251f:	83 c4 08             	add    $0x8,%esp
	return index;
c0102522:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c0102525:	c9                   	leave  
c0102526:	c3                   	ret    

c0102527 <fs_close_md>:
int fs_close_md(int fd){
c0102527:	55                   	push   %ebp
c0102528:	89 e5                	mov    %esp,%ebp
	return fs_close_kr(fd);
c010252a:	ff 75 08             	pushl  0x8(%ebp)
c010252d:	e8 bd fc ff ff       	call   c01021ef <fs_close_kr>
c0102532:	83 c4 04             	add    $0x4,%esp
};
c0102535:	c9                   	leave  
c0102536:	c3                   	ret    

c0102537 <fs_open_port>:

int fs_open_port(char *pathname, int flags){
c0102537:	55                   	push   %ebp
c0102538:	89 e5                	mov    %esp,%ebp
c010253a:	83 ec 10             	sub    $0x10,%esp
	int fd = fs_open_md(pathname, flags);
c010253d:	ff 75 0c             	pushl  0xc(%ebp)
c0102540:	ff 75 08             	pushl  0x8(%ebp)
c0102543:	e8 11 ff ff ff       	call   c0102459 <fs_open_md>
c0102548:	83 c4 08             	add    $0x8,%esp
c010254b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(fd == -1)
c010254e:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
c0102552:	75 07                	jne    c010255b <fs_open_port+0x24>
		return -1;
c0102554:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102559:	eb 4c                	jmp    c01025a7 <fs_open_port+0x70>
	int i = 0;
c010255b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i<FCBMAX; i++){
c0102562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102569:	eb 1c                	jmp    c0102587 <fs_open_port+0x50>
		if(current->fcb[i].fd_kr == -1)
c010256b:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102570:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102573:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102579:	8b 04 90             	mov    (%eax,%edx,4),%eax
c010257c:	83 f8 ff             	cmp    $0xffffffff,%eax
c010257f:	75 02                	jne    c0102583 <fs_open_port+0x4c>
			break;
c0102581:	eb 0d                	jmp    c0102590 <fs_open_port+0x59>
int fs_open_port(char *pathname, int flags){
	int fd = fs_open_md(pathname, flags);
	if(fd == -1)
		return -1;
	int i = 0;
	for(i = 0; i<FCBMAX; i++){
c0102583:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102587:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010258e:	7e db                	jle    c010256b <fs_open_port+0x34>
		if(current->fcb[i].fd_kr == -1)
			break;
	}
	current->fcb[i].fd_kr = fd;
c0102590:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102595:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102598:	8d 8a 18 08 00 00    	lea    0x818(%edx),%ecx
c010259e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01025a1:	89 14 88             	mov    %edx,(%eax,%ecx,4)
	return i;
c01025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c01025a7:	c9                   	leave  
c01025a8:	c3                   	ret    

c01025a9 <fs_read_port>:
int fs_read_port(int fd, void *buf, int len){
c01025a9:	55                   	push   %ebp
c01025aa:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c01025ac:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c01025b0:	75 07                	jne    c01025b9 <fs_read_port+0x10>
		return -1;
c01025b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01025b7:	eb 20                	jmp    c01025d9 <fs_read_port+0x30>
	return fs_read_md(current->fcb[fd].fd_kr, buf, len);
c01025b9:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01025be:	8b 55 08             	mov    0x8(%ebp),%edx
c01025c1:	81 c2 18 08 00 00    	add    $0x818,%edx
c01025c7:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01025ca:	ff 75 10             	pushl  0x10(%ebp)
c01025cd:	ff 75 0c             	pushl  0xc(%ebp)
c01025d0:	50                   	push   %eax
c01025d1:	e8 b6 fe ff ff       	call   c010248c <fs_read_md>
c01025d6:	83 c4 0c             	add    $0xc,%esp
};
c01025d9:	c9                   	leave  
c01025da:	c3                   	ret    

c01025db <fs_write_port>:
int fs_write_port(int fd, void *buf, int len){
c01025db:	55                   	push   %ebp
c01025dc:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c01025de:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c01025e2:	75 07                	jne    c01025eb <fs_write_port+0x10>
		return -1;
c01025e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01025e9:	eb 20                	jmp    c010260b <fs_write_port+0x30>
	return fs_write_md(current->fcb[fd].fd_kr, buf, len);
c01025eb:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01025f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01025f3:	81 c2 18 08 00 00    	add    $0x818,%edx
c01025f9:	8b 04 90             	mov    (%eax,%edx,4),%eax
c01025fc:	ff 75 10             	pushl  0x10(%ebp)
c01025ff:	ff 75 0c             	pushl  0xc(%ebp)
c0102602:	50                   	push   %eax
c0102603:	e8 9a fe ff ff       	call   c01024a2 <fs_write_md>
c0102608:	83 c4 0c             	add    $0xc,%esp
};
c010260b:	c9                   	leave  
c010260c:	c3                   	ret    

c010260d <fs_lseek_port>:
int fs_lseek_port(int fd, int offset, int whence){
c010260d:	55                   	push   %ebp
c010260e:	89 e5                	mov    %esp,%ebp
	if(fd == -1)
c0102610:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102614:	75 07                	jne    c010261d <fs_lseek_port+0x10>
		return -1;
c0102616:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010261b:	eb 20                	jmp    c010263d <fs_lseek_port+0x30>
	return fs_lseek_md(current->fcb[fd].fd_kr, offset, whence);
c010261d:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102622:	8b 55 08             	mov    0x8(%ebp),%edx
c0102625:	81 c2 18 08 00 00    	add    $0x818,%edx
c010262b:	8b 04 90             	mov    (%eax,%edx,4),%eax
c010262e:	ff 75 10             	pushl  0x10(%ebp)
c0102631:	ff 75 0c             	pushl  0xc(%ebp)
c0102634:	50                   	push   %eax
c0102635:	e8 7e fe ff ff       	call   c01024b8 <fs_lseek_md>
c010263a:	83 c4 0c             	add    $0xc,%esp
};
c010263d:	c9                   	leave  
c010263e:	c3                   	ret    

c010263f <fs_close_port>:
int fs_close_port(int fd){
c010263f:	55                   	push   %ebp
c0102640:	89 e5                	mov    %esp,%ebp
c0102642:	83 ec 10             	sub    $0x10,%esp
	if(fd == -1)
c0102645:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
c0102649:	75 07                	jne    c0102652 <fs_close_port+0x13>
		return -1;
c010264b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0102650:	eb 35                	jmp    c0102687 <fs_close_port+0x48>
	int ret = fs_close_md(current->fcb[fd].fd_kr);
c0102652:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102657:	8b 55 08             	mov    0x8(%ebp),%edx
c010265a:	81 c2 18 08 00 00    	add    $0x818,%edx
c0102660:	8b 04 90             	mov    (%eax,%edx,4),%eax
c0102663:	50                   	push   %eax
c0102664:	e8 be fe ff ff       	call   c0102527 <fs_close_md>
c0102669:	83 c4 04             	add    $0x4,%esp
c010266c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	current->fcb[fd].fd_kr = -1;
c010266f:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102674:	8b 55 08             	mov    0x8(%ebp),%edx
c0102677:	81 c2 18 08 00 00    	add    $0x818,%edx
c010267d:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	return ret;
c0102684:	8b 45 fc             	mov    -0x4(%ebp),%eax
};
c0102687:	c9                   	leave  
c0102688:	c3                   	ret    

c0102689 <init_fs>:

void init_fs(){
c0102689:	55                   	push   %ebp
c010268a:	89 e5                	mov    %esp,%ebp
c010268c:	83 ec 10             	sub    $0x10,%esp
	//readDir(0);
	int i=0;
c010268f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c0102696:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010269d:	eb 1b                	jmp    c01026ba <init_fs+0x31>
		fs[i].used = 0;
c010269f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026a2:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01026a8:	05 20 02 00 00       	add    $0x220,%eax
c01026ad:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01026b2:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
};

void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c01026b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01026ba:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01026c1:	7e dc                	jle    c010269f <init_fs+0x16>
	/*for(i=0; i<NR_ENTRIES; i++){
		printk("%x\n", dir.entries[i].file_size);
		printk("%x\n", dir.entries[i].inode_offset);
		printk("%s\n", dir.entries[i].filename);
	}*/
c01026c3:	c9                   	leave  
c01026c4:	c3                   	ret    

c01026c5 <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
c01026c5:	55                   	push   %ebp
c01026c6:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c01026c8:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01026cd:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c01026cf:	b8 df 05 00 00       	mov    $0x5df,%eax
c01026d4:	cd 80                	int    $0x80
}
c01026d6:	5d                   	pop    %ebp
c01026d7:	c3                   	ret    

c01026d8 <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c01026d8:	55                   	push   %ebp
c01026d9:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c01026db:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01026e0:	cd 80                	int    $0x80
}
c01026e2:	5d                   	pop    %ebp
c01026e3:	c3                   	ret    

c01026e4 <sys_fork>:
static inline uint32_t sys_fork(){
c01026e4:	55                   	push   %ebp
c01026e5:	89 e5                	mov    %esp,%ebp
c01026e7:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01026ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c01026f1:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c01026f6:	cd 80                	int    $0x80
c01026f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c01026fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01026fe:	c9                   	leave  
c01026ff:	c3                   	ret    

c0102700 <sys_pid>:
static inline uint32_t sys_pid(){
c0102700:	55                   	push   %ebp
c0102701:	89 e5                	mov    %esp,%ebp
c0102703:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c010270d:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0102712:	cd 80                	int    $0x80
c0102714:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0102717:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010271a:	c9                   	leave  
c010271b:	c3                   	ret    

c010271c <sys_ppid>:
static inline uint32_t sys_ppid(){
c010271c:	55                   	push   %ebp
c010271d:	89 e5                	mov    %esp,%ebp
c010271f:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102722:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c0102729:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c010272e:	cd 80                	int    $0x80
c0102730:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0102733:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102736:	c9                   	leave  
c0102737:	c3                   	ret    

c0102738 <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c0102738:	55                   	push   %ebp
c0102739:	89 e5                	mov    %esp,%ebp
c010273b:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c010273c:	b8 de 05 00 00       	mov    $0x5de,%eax
c0102741:	8b 55 08             	mov    0x8(%ebp),%edx
c0102744:	89 d3                	mov    %edx,%ebx
c0102746:	cd 80                	int    $0x80
}
c0102748:	5b                   	pop    %ebx
c0102749:	5d                   	pop    %ebp
c010274a:	c3                   	ret    

c010274b <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010274b:	55                   	push   %ebp
c010274c:	89 e5                	mov    %esp,%ebp
c010274e:	83 ec 40             	sub    $0x40,%esp
c0102751:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0102758:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010275c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102760:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102763:	ee                   	out    %al,(%dx)
c0102764:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c010276b:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c010276f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102773:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102776:	ee                   	out    %al,(%dx)
c0102777:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c010277e:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0102782:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102786:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102789:	ee                   	out    %al,(%dx)
c010278a:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0102791:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0102795:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102799:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010279c:	ee                   	out    %al,(%dx)
c010279d:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01027a4:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01027a8:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01027ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01027af:	ee                   	out    %al,(%dx)
c01027b0:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01027b7:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01027bb:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01027bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01027c2:	ee                   	out    %al,(%dx)
c01027c3:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c01027ca:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01027ce:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01027d2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01027d5:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01027d6:	c9                   	leave  
c01027d7:	c3                   	ret    

c01027d8 <serial_idle>:

static inline
int serial_idle(void) {
c01027d8:	55                   	push   %ebp
c01027d9:	89 e5                	mov    %esp,%ebp
c01027db:	83 ec 10             	sub    $0x10,%esp
c01027de:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01027e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01027e8:	89 c2                	mov    %eax,%edx
c01027ea:	ec                   	in     (%dx),%al
c01027eb:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01027ee:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01027f2:	0f b6 c0             	movzbl %al,%eax
c01027f5:	83 e0 20             	and    $0x20,%eax
c01027f8:	85 c0                	test   %eax,%eax
c01027fa:	0f 95 c0             	setne  %al
c01027fd:	0f b6 c0             	movzbl %al,%eax
}
c0102800:	c9                   	leave  
c0102801:	c3                   	ret    

c0102802 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102802:	55                   	push   %ebp
c0102803:	89 e5                	mov    %esp,%ebp
c0102805:	83 ec 14             	sub    $0x14,%esp
c0102808:	8b 45 08             	mov    0x8(%ebp),%eax
c010280b:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010280e:	90                   	nop
c010280f:	e8 c4 ff ff ff       	call   c01027d8 <serial_idle>
c0102814:	85 c0                	test   %eax,%eax
c0102816:	74 f7                	je     c010280f <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102818:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010281c:	0f b6 c0             	movzbl %al,%eax
c010281f:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102826:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102829:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010282d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102830:	ee                   	out    %al,(%dx)
}
c0102831:	c9                   	leave  
c0102832:	c3                   	ret    

c0102833 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102833:	55                   	push   %ebp
c0102834:	89 e5                	mov    %esp,%ebp
c0102836:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102839:	8d 45 0c             	lea    0xc(%ebp),%eax
c010283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010283f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102842:	83 ec 04             	sub    $0x4,%esp
c0102845:	ff 75 f4             	pushl  -0xc(%ebp)
c0102848:	50                   	push   %eax
c0102849:	68 02 28 10 c0       	push   $0xc0102802
c010284e:	e8 d8 1c 00 00       	call   c010452b <vfprintf>
c0102853:	83 c4 10             	add    $0x10,%esp
}
c0102856:	c9                   	leave  
c0102857:	c3                   	ret    

c0102858 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c0102858:	55                   	push   %ebp
c0102859:	89 e5                	mov    %esp,%ebp
c010285b:	83 ec 70             	sub    $0x70,%esp
c010285e:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0102865:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c0102869:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010286d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102870:	ee                   	out    %al,(%dx)
c0102871:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c0102878:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c010287c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102880:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102883:	ee                   	out    %al,(%dx)
c0102884:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c010288b:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c010288f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102893:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102896:	ee                   	out    %al,(%dx)
c0102897:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c010289e:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01028a2:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01028a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01028a9:	ee                   	out    %al,(%dx)
c01028aa:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01028b1:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01028b5:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01028b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01028bc:	ee                   	out    %al,(%dx)
c01028bd:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c01028c4:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c01028c8:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01028cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01028cf:	ee                   	out    %al,(%dx)
c01028d0:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c01028d7:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c01028db:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01028df:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01028e2:	ee                   	out    %al,(%dx)
c01028e3:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c01028ea:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c01028ee:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c01028f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01028f5:	ee                   	out    %al,(%dx)
c01028f6:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01028fd:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0102901:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c0102905:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102908:	ee                   	out    %al,(%dx)
c0102909:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0102910:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c0102914:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c0102918:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010291b:	ee                   	out    %al,(%dx)
c010291c:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0102923:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0102927:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c010292b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010292e:	ee                   	out    %al,(%dx)
c010292f:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0102936:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c010293a:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c010293e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102941:	ee                   	out    %al,(%dx)
c0102942:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c0102949:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c010294d:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0102951:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102954:	ee                   	out    %al,(%dx)
c0102955:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c010295c:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c0102960:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0102964:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102967:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c0102968:	c9                   	leave  
c0102969:	c3                   	ret    

c010296a <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c010296a:	55                   	push   %ebp
c010296b:	89 e5                	mov    %esp,%ebp
c010296d:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c0102970:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c0102977:	0f b6 05 00 80 10 c0 	movzbl 0xc0108000,%eax
c010297e:	0f b6 c0             	movzbl %al,%eax
c0102981:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c0102988:	88 45 f7             	mov    %al,-0x9(%ebp)
c010298b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010298f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102992:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0102993:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102996:	0f b6 c0             	movzbl %al,%eax
c0102999:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01029a0:	88 45 ef             	mov    %al,-0x11(%ebp)
c01029a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01029a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029aa:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01029ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029ae:	c1 f8 08             	sar    $0x8,%eax
c01029b1:	0f b6 c0             	movzbl %al,%eax
c01029b4:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c01029bb:	88 45 e7             	mov    %al,-0x19(%ebp)
c01029be:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01029c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01029c5:	ee                   	out    %al,(%dx)
}
c01029c6:	c9                   	leave  
c01029c7:	c3                   	ret    

c01029c8 <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c01029c8:	55                   	push   %ebp
c01029c9:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c01029cb:	e8 08 fd ff ff       	call   c01026d8 <sys_handout>
  }
c01029d0:	eb f9                	jmp    c01029cb <idle+0x3>

c01029d2 <busy>:
}
void busy(){
c01029d2:	55                   	push   %ebp
c01029d3:	89 e5                	mov    %esp,%ebp
c01029d5:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c01029d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c01029df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c01029e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01029ed:	eb 11                	jmp    c0102a00 <busy+0x2e>
    if(fork()!=0){
c01029ef:	e8 f0 fc ff ff       	call   c01026e4 <sys_fork>
c01029f4:	85 c0                	test   %eax,%eax
c01029f6:	74 04                	je     c01029fc <busy+0x2a>
        j++;
c01029f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c01029fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102a00:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c0102a04:	76 e9                	jbe    c01029ef <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c0102a06:	e8 f5 fc ff ff       	call   c0102700 <sys_pid>
c0102a0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c0102a0e:	e8 09 fd ff ff       	call   c010271c <sys_ppid>
c0102a13:	ff 75 f0             	pushl  -0x10(%ebp)
c0102a16:	50                   	push   %eax
c0102a17:	ff 75 e8             	pushl  -0x18(%ebp)
c0102a1a:	68 e4 48 10 c0       	push   $0xc01048e4
c0102a1f:	e8 a1 1d 00 00       	call   c01047c5 <printf>
c0102a24:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c0102a27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c0102a2e:	e8 a5 fc ff ff       	call   c01026d8 <sys_handout>
    sleep(pid);
c0102a33:	83 ec 0c             	sub    $0xc,%esp
c0102a36:	ff 75 e8             	pushl  -0x18(%ebp)
c0102a39:	e8 fa fc ff ff       	call   c0102738 <sys_sleep>
c0102a3e:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0102a41:	ff 75 ec             	pushl  -0x14(%ebp)
c0102a44:	ff 75 e8             	pushl  -0x18(%ebp)
c0102a47:	ff 75 e8             	pushl  -0x18(%ebp)
c0102a4a:	68 24 49 10 c0       	push   $0xc0104924
c0102a4f:	e8 71 1d 00 00       	call   c01047c5 <printf>
c0102a54:	83 c4 10             	add    $0x10,%esp
    times++;
c0102a57:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c0102a5b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0102a5f:	76 15                	jbe    c0102a76 <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0102a61:	83 ec 0c             	sub    $0xc,%esp
c0102a64:	68 48 49 10 c0       	push   $0xc0104948
c0102a69:	e8 57 1d 00 00       	call   c01047c5 <printf>
c0102a6e:	83 c4 10             	add    $0x10,%esp
      exit();
c0102a71:	e8 4f fc ff ff       	call   c01026c5 <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c0102a76:	eb b6                	jmp    c0102a2e <busy+0x5c>

c0102a78 <main>:
}
void do_scheduler();
int main(){
c0102a78:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0102a7c:	83 e4 f0             	and    $0xfffffff0,%esp
c0102a7f:	ff 71 fc             	pushl  -0x4(%ecx)
c0102a82:	55                   	push   %ebp
c0102a83:	89 e5                	mov    %esp,%ebp
c0102a85:	51                   	push   %ecx
c0102a86:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0102a89:	e8 9d d6 ff ff       	call   c010012b <init_page>
  init_segment();
c0102a8e:	e8 49 d8 ff ff       	call   c01002dc <init_segment>
	init_serial();
c0102a93:	e8 b3 fc ff ff       	call   c010274b <init_serial>
	init_timer();
c0102a98:	e8 cd fe ff ff       	call   c010296a <init_timer>
	init_idt();
c0102a9d:	e8 21 e9 ff ff       	call   c01013c3 <init_idt>
	init_intr();
c0102aa2:	e8 b1 fd ff ff       	call   c0102858 <init_intr>
  init_fs();
c0102aa7:	e8 dd fb ff ff       	call   c0102689 <init_fs>
  init_pcb_pool();
c0102aac:	e8 bc 0e 00 00       	call   c010396d <init_pcb_pool>
  printk("This is kernel!\n");
c0102ab1:	83 ec 0c             	sub    $0xc,%esp
c0102ab4:	68 66 49 10 c0       	push   $0xc0104966
c0102ab9:	e8 75 fd ff ff       	call   c0102833 <printk>
c0102abe:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c0102ac1:	e8 12 10 00 00       	call   c0103ad8 <pcb_create>
c0102ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0102ac9:	83 ec 08             	sub    $0x8,%esp
c0102acc:	68 c8 29 10 c0       	push   $0xc01029c8
c0102ad1:	ff 75 f4             	pushl  -0xc(%ebp)
c0102ad4:	e8 e6 05 00 00       	call   c01030bf <empty_loader>
c0102ad9:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c0102adc:	83 ec 0c             	sub    $0xc,%esp
c0102adf:	ff 75 f4             	pushl  -0xc(%ebp)
c0102ae2:	e8 1a 11 00 00       	call   c0103c01 <enready_pcb>
c0102ae7:	83 c4 10             	add    $0x10,%esp


  PCB* pcb = pcb_create();
c0102aea:	e8 e9 0f 00 00       	call   c0103ad8 <pcb_create>
c0102aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader_file(pcb, "game");
c0102af2:	83 ec 08             	sub    $0x8,%esp
c0102af5:	68 77 49 10 c0       	push   $0xc0104977
c0102afa:	ff 75 f0             	pushl  -0x10(%ebp)
c0102afd:	e8 ec 03 00 00       	call   c0102eee <loader_file>
c0102b02:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c0102b05:	83 ec 0c             	sub    $0xc,%esp
c0102b08:	ff 75 f0             	pushl  -0x10(%ebp)
c0102b0b:	e8 f1 10 00 00       	call   c0103c01 <enready_pcb>
c0102b10:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c0102b13:	e8 c0 0f 00 00       	call   c0103ad8 <pcb_create>
c0102b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader_file(app, "app");
c0102b1b:	83 ec 08             	sub    $0x8,%esp
c0102b1e:	68 7c 49 10 c0       	push   $0xc010497c
c0102b23:	ff 75 ec             	pushl  -0x14(%ebp)
c0102b26:	e8 c3 03 00 00       	call   c0102eee <loader_file>
c0102b2b:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c0102b2e:	83 ec 0c             	sub    $0xc,%esp
c0102b31:	ff 75 ec             	pushl  -0x14(%ebp)
c0102b34:	e8 c8 10 00 00       	call   c0103c01 <enready_pcb>
c0102b39:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c0102b3c:	e8 6a e5 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c0102b41:	eb fe                	jmp    c0102b41 <main+0xc9>

c0102b43 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102b43:	55                   	push   %ebp
c0102b44:	89 e5                	mov    %esp,%ebp
c0102b46:	83 ec 10             	sub    $0x10,%esp
c0102b49:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b53:	89 c2                	mov    %eax,%edx
c0102b55:	ec                   	in     (%dx),%al
c0102b56:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102b59:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102b5d:	0f b6 c0             	movzbl %al,%eax
c0102b60:	83 e0 20             	and    $0x20,%eax
c0102b63:	85 c0                	test   %eax,%eax
c0102b65:	0f 95 c0             	setne  %al
c0102b68:	0f b6 c0             	movzbl %al,%eax
}
c0102b6b:	c9                   	leave  
c0102b6c:	c3                   	ret    

c0102b6d <serial_printc>:

static inline
void serial_printc(char ch) {
c0102b6d:	55                   	push   %ebp
c0102b6e:	89 e5                	mov    %esp,%ebp
c0102b70:	83 ec 14             	sub    $0x14,%esp
c0102b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b76:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102b79:	90                   	nop
c0102b7a:	e8 c4 ff ff ff       	call   c0102b43 <serial_idle>
c0102b7f:	85 c0                	test   %eax,%eax
c0102b81:	74 f7                	je     c0102b7a <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102b83:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102b87:	0f b6 c0             	movzbl %al,%eax
c0102b8a:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102b91:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102b94:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102b98:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102b9b:	ee                   	out    %al,(%dx)
}
c0102b9c:	c9                   	leave  
c0102b9d:	c3                   	ret    

c0102b9e <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102b9e:	55                   	push   %ebp
c0102b9f:	89 e5                	mov    %esp,%ebp
c0102ba1:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102ba4:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bad:	83 ec 04             	sub    $0x4,%esp
c0102bb0:	ff 75 f4             	pushl  -0xc(%ebp)
c0102bb3:	50                   	push   %eax
c0102bb4:	68 6d 2b 10 c0       	push   $0xc0102b6d
c0102bb9:	e8 6d 19 00 00       	call   c010452b <vfprintf>
c0102bbe:	83 c4 10             	add    $0x10,%esp
}
c0102bc1:	c9                   	leave  
c0102bc2:	c3                   	ret    

c0102bc3 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0102bc3:	55                   	push   %ebp
c0102bc4:	89 e5                	mov    %esp,%ebp
c0102bc6:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0102bc9:	90                   	nop
c0102bca:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102bd4:	89 c2                	mov    %eax,%edx
c0102bd6:	ec                   	in     (%dx),%al
c0102bd7:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102bda:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102bde:	0f b6 c0             	movzbl %al,%eax
c0102be1:	25 c0 00 00 00       	and    $0xc0,%eax
c0102be6:	83 f8 40             	cmp    $0x40,%eax
c0102be9:	75 df                	jne    c0102bca <waitdisk+0x7>
}
c0102beb:	c9                   	leave  
c0102bec:	c3                   	ret    

c0102bed <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102bed:	55                   	push   %ebp
c0102bee:	89 e5                	mov    %esp,%ebp
c0102bf0:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0102bf3:	e8 cb ff ff ff       	call   c0102bc3 <waitdisk>
c0102bf8:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0102bff:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102c03:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102c07:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102c0a:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0102c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c0e:	0f b6 c0             	movzbl %al,%eax
c0102c11:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0102c18:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102c1b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102c1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102c22:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0102c23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c26:	c1 f8 08             	sar    $0x8,%eax
c0102c29:	0f b6 c0             	movzbl %al,%eax
c0102c2c:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0102c33:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102c36:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102c3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102c3d:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0102c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c41:	c1 f8 10             	sar    $0x10,%eax
c0102c44:	0f b6 c0             	movzbl %al,%eax
c0102c47:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0102c4e:	88 45 df             	mov    %al,-0x21(%ebp)
c0102c51:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c58:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0102c59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c5c:	c1 f8 18             	sar    $0x18,%eax
c0102c5f:	83 c8 e0             	or     $0xffffffe0,%eax
c0102c62:	0f b6 c0             	movzbl %al,%eax
c0102c65:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0102c6c:	88 45 d7             	mov    %al,-0x29(%ebp)
c0102c6f:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0102c73:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c76:	ee                   	out    %al,(%dx)
c0102c77:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0102c7e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0102c82:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0102c86:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c89:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0102c8a:	e8 34 ff ff ff       	call   c0102bc3 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102c8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102c96:	eb 29                	jmp    c0102cc1 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0102c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0102ca8:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cb2:	89 c2                	mov    %eax,%edx
c0102cb4:	ed                   	in     (%dx),%eax
c0102cb5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0102cb8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102cbb:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102cbd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102cc1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0102cc5:	7e d1                	jle    c0102c98 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0102cc7:	c9                   	leave  
c0102cc8:	c3                   	ret    

c0102cc9 <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0102cc9:	55                   	push   %ebp
c0102cca:	89 e5                	mov    %esp,%ebp
c0102ccc:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd5:	01 d0                	add    %edx,%eax
c0102cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102cda:	8b 45 10             	mov    0x10(%ebp),%eax
c0102cdd:	99                   	cltd   
c0102cde:	c1 ea 17             	shr    $0x17,%edx
c0102ce1:	01 d0                	add    %edx,%eax
c0102ce3:	25 ff 01 00 00       	and    $0x1ff,%eax
c0102ce8:	29 d0                	sub    %edx,%eax
c0102cea:	f7 d8                	neg    %eax
c0102cec:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102cef:	8b 45 10             	mov    0x10(%ebp),%eax
c0102cf2:	99                   	cltd   
c0102cf3:	c1 ea 17             	shr    $0x17,%edx
c0102cf6:	01 d0                	add    %edx,%eax
c0102cf8:	c1 f8 09             	sar    $0x9,%eax
c0102cfb:	83 c0 01             	add    $0x1,%eax
c0102cfe:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102d01:	eb 19                	jmp    c0102d1c <readseg+0x53>
        readsect(pa, offset);
c0102d03:	ff 75 10             	pushl  0x10(%ebp)
c0102d06:	ff 75 08             	pushl  0x8(%ebp)
c0102d09:	e8 df fe ff ff       	call   c0102bed <readsect>
c0102d0e:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102d11:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0102d18:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102d22:	72 df                	jb     c0102d03 <readseg+0x3a>
        readsect(pa, offset);
c0102d24:	c9                   	leave  
c0102d25:	c3                   	ret    

c0102d26 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0102d26:	55                   	push   %ebp
c0102d27:	89 e5                	mov    %esp,%ebp
c0102d29:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0102d2c:	8b 45 10             	mov    0x10(%ebp),%eax
c0102d2f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0102d34:	77 16                	ja     c0102d4c <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102d36:	ff 75 10             	pushl  0x10(%ebp)
c0102d39:	68 80 49 10 c0       	push   $0xc0104980
c0102d3e:	ff 75 0c             	pushl  0xc(%ebp)
c0102d41:	ff 75 08             	pushl  0x8(%ebp)
c0102d44:	e8 55 fe ff ff       	call   c0102b9e <printk>
c0102d49:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0102d4c:	8b 45 10             	mov    0x10(%ebp),%eax
c0102d4f:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102d54:	c9                   	leave  
c0102d55:	c3                   	ret    

c0102d56 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)
#define elf_r ((char*) ELFADDR)

uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0102d56:	55                   	push   %ebp
c0102d57:	89 e5                	mov    %esp,%ebp
c0102d59:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5f:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d65:	83 ec 04             	sub    $0x4,%esp
c0102d68:	50                   	push   %eax
c0102d69:	6a 17                	push   $0x17
c0102d6b:	68 a3 49 10 c0       	push   $0xc01049a3
c0102d70:	e8 b1 ff ff ff       	call   c0102d26 <_paddr>
c0102d75:	83 c4 10             	add    $0x10,%esp
c0102d78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d7e:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d84:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d8a:	83 ec 04             	sub    $0x4,%esp
c0102d8d:	68 00 10 00 00       	push   $0x1000
c0102d92:	6a 00                	push   $0x0
c0102d94:	50                   	push   %eax
c0102d95:	e8 f7 d8 ff ff       	call   c0100691 <mm_alloc>
c0102d9a:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102da0:	83 ec 04             	sub    $0x4,%esp
c0102da3:	50                   	push   %eax
c0102da4:	68 00 10 00 00       	push   $0x1000
c0102da9:	6a 00                	push   $0x0
c0102dab:	e8 19 ff ff ff       	call   c0102cc9 <readseg>
c0102db0:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102db3:	b8 00 00 00 00       	mov    $0x0,%eax
c0102db8:	8b 00                	mov    (%eax),%eax
c0102dba:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102dbf:	0f 94 c0             	sete   %al
c0102dc2:	0f b6 c0             	movzbl %al,%eax
c0102dc5:	83 ec 08             	sub    $0x8,%esp
c0102dc8:	50                   	push   %eax
c0102dc9:	68 b7 49 10 c0       	push   $0xc01049b7
c0102dce:	e8 cb fd ff ff       	call   c0102b9e <printk>
c0102dd3:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102dd6:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ddb:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102de1:	b8 00 00 00 00       	mov    $0x0,%eax
c0102de6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102dea:	0f b7 c0             	movzwl %ax,%eax
c0102ded:	c1 e0 05             	shl    $0x5,%eax
c0102df0:	89 c2                	mov    %eax,%edx
c0102df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df5:	01 d0                	add    %edx,%eax
c0102df7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102dfa:	eb 7f                	jmp    c0102e7b <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0102dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dff:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e02:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e08:	8b 48 14             	mov    0x14(%eax),%ecx
c0102e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e0e:	8b 50 08             	mov    0x8(%eax),%edx
c0102e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e14:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102e1a:	83 ec 04             	sub    $0x4,%esp
c0102e1d:	51                   	push   %ecx
c0102e1e:	52                   	push   %edx
c0102e1f:	50                   	push   %eax
c0102e20:	e8 6c d8 ff ff       	call   c0100691 <mm_alloc>
c0102e25:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2b:	8b 50 04             	mov    0x4(%eax),%edx
c0102e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e31:	01 d0                	add    %edx,%eax
c0102e33:	89 c2                	mov    %eax,%edx
c0102e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e38:	8b 40 10             	mov    0x10(%eax),%eax
c0102e3b:	83 ec 04             	sub    $0x4,%esp
c0102e3e:	52                   	push   %edx
c0102e3f:	50                   	push   %eax
c0102e40:	ff 75 e8             	pushl  -0x18(%ebp)
c0102e43:	e8 81 fe ff ff       	call   c0102cc9 <readseg>
c0102e48:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e4e:	8b 50 10             	mov    0x10(%eax),%edx
c0102e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e54:	01 d0                	add    %edx,%eax
c0102e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e59:	eb 0c                	jmp    c0102e67 <loader+0x111>
c0102e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5e:	8d 50 01             	lea    0x1(%eax),%edx
c0102e61:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102e64:	c6 00 00             	movb   $0x0,(%eax)
c0102e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6a:	8b 50 14             	mov    0x14(%eax),%edx
c0102e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e70:	01 d0                	add    %edx,%eax
c0102e72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e75:	77 e4                	ja     c0102e5b <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102e77:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102e81:	0f 82 75 ff ff ff    	jb     c0102dfc <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0102e87:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e8c:	8b 40 18             	mov    0x18(%eax),%eax
c0102e8f:	a3 a4 44 10 c0       	mov    %eax,0xc01044a4

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102e94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e97:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102e9d:	83 ec 04             	sub    $0x4,%esp
c0102ea0:	68 00 80 00 00       	push   $0x8000
c0102ea5:	68 00 60 bf be       	push   $0xbebf6000
c0102eaa:	50                   	push   %eax
c0102eab:	e8 e1 d7 ff ff       	call   c0100691 <mm_alloc>
c0102eb0:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102eb3:	a1 a4 44 10 c0       	mov    0xc01044a4,%eax
c0102eb8:	6a 03                	push   $0x3
c0102eba:	50                   	push   %eax
c0102ebb:	68 80 df bf be       	push   $0xbebfdf80
c0102ec0:	ff 75 08             	pushl  0x8(%ebp)
c0102ec3:	e8 dc 0a 00 00       	call   c01039a4 <init_pcb>
c0102ec8:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102ecb:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102ed0:	83 ec 04             	sub    $0x4,%esp
c0102ed3:	50                   	push   %eax
c0102ed4:	6a 39                	push   $0x39
c0102ed6:	68 a3 49 10 c0       	push   $0xc01049a3
c0102edb:	e8 46 fe ff ff       	call   c0102d26 <_paddr>
c0102ee0:	83 c4 10             	add    $0x10,%esp
c0102ee3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ee9:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102eec:	c9                   	leave  
c0102eed:	c3                   	ret    

c0102eee <loader_file>:

void loader_file(PCB* pcb, char* filename){
c0102eee:	55                   	push   %ebp
c0102eef:	89 e5                	mov    %esp,%ebp
c0102ef1:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102ef4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef7:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102efd:	83 ec 04             	sub    $0x4,%esp
c0102f00:	50                   	push   %eax
c0102f01:	6a 44                	push   $0x44
c0102f03:	68 a3 49 10 c0       	push   $0xc01049a3
c0102f08:	e8 19 fe ff ff       	call   c0102d26 <_paddr>
c0102f0d:	83 c4 10             	add    $0x10,%esp
c0102f10:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102f13:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f16:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102f19:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f1c:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102f22:	83 ec 04             	sub    $0x4,%esp
c0102f25:	68 00 10 00 00       	push   $0x1000
c0102f2a:	6a 00                	push   $0x0
c0102f2c:	50                   	push   %eax
c0102f2d:	e8 5f d7 ff ff       	call   c0100691 <mm_alloc>
c0102f32:	83 c4 10             	add    $0x10,%esp
  int fd = fs_open_kr(filename);
c0102f35:	83 ec 0c             	sub    $0xc,%esp
c0102f38:	ff 75 0c             	pushl  0xc(%ebp)
c0102f3b:	e8 1f eb ff ff       	call   c0101a5f <fs_open_kr>
c0102f40:	83 c4 10             	add    $0x10,%esp
c0102f43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fs_read_kr(fd, elf_r, 8*SECTSIZE);
c0102f46:	83 ec 04             	sub    $0x4,%esp
c0102f49:	68 00 10 00 00       	push   $0x1000
c0102f4e:	6a 00                	push   $0x0
c0102f50:	ff 75 ec             	pushl  -0x14(%ebp)
c0102f53:	e8 6f ee ff ff       	call   c0101dc7 <fs_read_kr>
c0102f58:	83 c4 10             	add    $0x10,%esp
  //readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("%x\n", *(uint32_t *)(elf_r+7*SECTSIZE));
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102f5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f60:	8b 00                	mov    (%eax),%eax
c0102f62:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102f67:	0f 94 c0             	sete   %al
c0102f6a:	0f b6 c0             	movzbl %al,%eax
c0102f6d:	83 ec 08             	sub    $0x8,%esp
c0102f70:	50                   	push   %eax
c0102f71:	68 b7 49 10 c0       	push   $0xc01049b7
c0102f76:	e8 23 fc ff ff       	call   c0102b9e <printk>
c0102f7b:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102f7e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f83:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102f89:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f8e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102f92:	0f b7 c0             	movzwl %ax,%eax
c0102f95:	c1 e0 05             	shl    $0x5,%eax
c0102f98:	89 c2                	mov    %eax,%edx
c0102f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f9d:	01 d0                	add    %edx,%eax
c0102f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102fa2:	e9 a5 00 00 00       	jmp    c010304c <loader_file+0x15e>
    pa = (unsigned char*)ph->vaddr; 
c0102fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102faa:	8b 40 08             	mov    0x8(%eax),%eax
c0102fad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //printk("%x %x %x\n", pcb->pgdir, ph->vaddr, ph->memsz);
    if(ph->vaddr == 0 || ph->memsz == 0)break;
c0102fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fb3:	8b 40 08             	mov    0x8(%eax),%eax
c0102fb6:	85 c0                	test   %eax,%eax
c0102fb8:	0f 84 9a 00 00 00    	je     c0103058 <loader_file+0x16a>
c0102fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fc1:	8b 40 14             	mov    0x14(%eax),%eax
c0102fc4:	85 c0                	test   %eax,%eax
c0102fc6:	0f 84 8c 00 00 00    	je     c0103058 <loader_file+0x16a>
    //printk("a\n");
    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fcf:	8b 48 14             	mov    0x14(%eax),%ecx
c0102fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fd5:	8b 50 08             	mov    0x8(%eax),%edx
c0102fd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fdb:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102fe1:	83 ec 04             	sub    $0x4,%esp
c0102fe4:	51                   	push   %ecx
c0102fe5:	52                   	push   %edx
c0102fe6:	50                   	push   %eax
c0102fe7:	e8 a5 d6 ff ff       	call   c0100691 <mm_alloc>
c0102fec:	83 c4 10             	add    $0x10,%esp
    //printk("b\n");
    //printk("hahaha?\n");
    fs_lseek_kr(fd, ph->off);
c0102fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ff2:	8b 40 04             	mov    0x4(%eax),%eax
c0102ff5:	83 ec 08             	sub    $0x8,%esp
c0102ff8:	50                   	push   %eax
c0102ff9:	ff 75 ec             	pushl  -0x14(%ebp)
c0102ffc:	e8 a7 f1 ff ff       	call   c01021a8 <fs_lseek_kr>
c0103001:	83 c4 10             	add    $0x10,%esp
    fs_read_kr(fd, pa, ph->filesz);
c0103004:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103007:	8b 40 10             	mov    0x10(%eax),%eax
c010300a:	83 ec 04             	sub    $0x4,%esp
c010300d:	50                   	push   %eax
c010300e:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103011:	ff 75 ec             	pushl  -0x14(%ebp)
c0103014:	e8 ae ed ff ff       	call   c0101dc7 <fs_read_kr>
c0103019:	83 c4 10             	add    $0x10,%esp
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c010301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010301f:	8b 50 10             	mov    0x10(%eax),%edx
c0103022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103025:	01 d0                	add    %edx,%eax
c0103027:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010302a:	eb 0c                	jmp    c0103038 <loader_file+0x14a>
c010302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010302f:	8d 50 01             	lea    0x1(%eax),%edx
c0103032:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0103035:	c6 00 00             	movb   $0x0,(%eax)
c0103038:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010303b:	8b 50 14             	mov    0x14(%eax),%edx
c010303e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103041:	01 d0                	add    %edx,%eax
c0103043:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103046:	77 e4                	ja     c010302c <loader_file+0x13e>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0103048:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010304f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103052:	0f 82 4f ff ff ff    	jb     c0102fa7 <loader_file+0xb9>
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  //printk("c\n");
  //while(1);
  entry = elf->entry;
c0103058:	b8 00 00 00 00       	mov    $0x0,%eax
c010305d:	8b 40 18             	mov    0x18(%eax),%eax
c0103060:	a3 a4 44 10 c0       	mov    %eax,0xc01044a4
  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  //printk("e\n");
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0103065:	8b 45 08             	mov    0x8(%ebp),%eax
c0103068:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010306e:	83 ec 04             	sub    $0x4,%esp
c0103071:	68 00 80 00 00       	push   $0x8000
c0103076:	68 00 60 bf be       	push   $0xbebf6000
c010307b:	50                   	push   %eax
c010307c:	e8 10 d6 ff ff       	call   c0100691 <mm_alloc>
c0103081:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0103084:	a1 a4 44 10 c0       	mov    0xc01044a4,%eax
c0103089:	6a 03                	push   $0x3
c010308b:	50                   	push   %eax
c010308c:	68 80 df bf be       	push   $0xbebfdf80
c0103091:	ff 75 08             	pushl  0x8(%ebp)
c0103094:	e8 0b 09 00 00       	call   c01039a4 <init_pcb>
c0103099:	83 c4 10             	add    $0x10,%esp
  //printk("f\n");
  //printk("%x\n", *(uint32_t*)(0x80481fd));
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c010309c:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c01030a1:	83 ec 04             	sub    $0x4,%esp
c01030a4:	50                   	push   %eax
c01030a5:	6a 74                	push   $0x74
c01030a7:	68 a3 49 10 c0       	push   $0xc01049a3
c01030ac:	e8 75 fc ff ff       	call   c0102d26 <_paddr>
c01030b1:	83 c4 10             	add    $0x10,%esp
c01030b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030ba:	0f 22 d8             	mov    %eax,%cr3
  //printk("g\n");
  //switch_pcb(pcb);
  
  //printk("e\n");
};
c01030bd:	c9                   	leave  
c01030be:	c3                   	ret    

c01030bf <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c01030bf:	55                   	push   %ebp
c01030c0:	89 e5                	mov    %esp,%ebp
c01030c2:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c01030c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01030c8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01030ce:	83 ec 04             	sub    $0x4,%esp
c01030d1:	50                   	push   %eax
c01030d2:	6a 7d                	push   $0x7d
c01030d4:	68 a3 49 10 c0       	push   $0xc01049a3
c01030d9:	e8 48 fc ff ff       	call   c0102d26 <_paddr>
c01030de:	83 c4 10             	add    $0x10,%esp
c01030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030e7:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c01030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030ed:	a3 a4 44 10 c0       	mov    %eax,0xc01044a4
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c01030f2:	a1 a4 44 10 c0       	mov    0xc01044a4,%eax
c01030f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01030fa:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0103100:	83 c2 80             	add    $0xffffff80,%edx
c0103103:	6a 00                	push   $0x0
c0103105:	50                   	push   %eax
c0103106:	52                   	push   %edx
c0103107:	ff 75 08             	pushl  0x8(%ebp)
c010310a:	e8 95 08 00 00       	call   c01039a4 <init_pcb>
c010310f:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0103112:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0103117:	83 ec 04             	sub    $0x4,%esp
c010311a:	50                   	push   %eax
c010311b:	68 81 00 00 00       	push   $0x81
c0103120:	68 a3 49 10 c0       	push   $0xc01049a3
c0103125:	e8 fc fb ff ff       	call   c0102d26 <_paddr>
c010312a:	83 c4 10             	add    $0x10,%esp
c010312d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103130:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103133:	0f 22 d8             	mov    %eax,%cr3

c0103136:	c9                   	leave  
c0103137:	c3                   	ret    

c0103138 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0103138:	55                   	push   %ebp
c0103139:	89 e5                	mov    %esp,%ebp
c010313b:	83 ec 04             	sub    $0x4,%esp
c010313e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103141:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0103144:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0103148:	83 e8 61             	sub    $0x61,%eax
c010314b:	8b 04 85 40 60 15 c0 	mov    -0x3fea9fc0(,%eax,4),%eax
}
c0103152:	c9                   	leave  
c0103153:	c3                   	ret    

c0103154 <get_lastkey>:
int8_t get_lastkey(){
c0103154:	55                   	push   %ebp
c0103155:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0103157:	a1 a8 60 15 c0       	mov    0xc01560a8,%eax
c010315c:	83 c0 61             	add    $0x61,%eax
}
c010315f:	5d                   	pop    %ebp
c0103160:	c3                   	ret    

c0103161 <press_key>:
void press_key(int code){
c0103161:	55                   	push   %ebp
c0103162:	89 e5                	mov    %esp,%ebp
c0103164:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0103167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c010316e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103171:	25 80 00 00 00       	and    $0x80,%eax
c0103176:	85 c0                	test   %eax,%eax
c0103178:	75 35                	jne    c01031af <press_key+0x4e>
		for(;i<26;i++){
c010317a:	eb 2b                	jmp    c01031a7 <press_key+0x46>
			if(letter[i]==code){
c010317c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010317f:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0103186:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103189:	75 18                	jne    c01031a3 <press_key+0x42>
				keydown[i] = 1;
c010318b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010318e:	c7 04 85 40 60 15 c0 	movl   $0x1,-0x3fea9fc0(,%eax,4)
c0103195:	01 00 00 00 
				lastkey = i;
c0103199:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010319c:	a3 a8 60 15 c0       	mov    %eax,0xc01560a8
				return;
c01031a1:	eb 3b                	jmp    c01031de <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c01031a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01031a7:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01031ab:	7e cf                	jle    c010317c <press_key+0x1b>
c01031ad:	eb 2f                	jmp    c01031de <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c01031af:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c01031b3:	eb 23                	jmp    c01031d8 <press_key+0x77>
			if(letter[i]==code){
c01031b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031b8:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c01031bf:	3b 45 08             	cmp    0x8(%ebp),%eax
c01031c2:	75 10                	jne    c01031d4 <press_key+0x73>
				keydown[i] = 0;
c01031c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031c7:	c7 04 85 40 60 15 c0 	movl   $0x0,-0x3fea9fc0(,%eax,4)
c01031ce:	00 00 00 00 
				return;
c01031d2:	eb 0a                	jmp    c01031de <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c01031d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01031d8:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01031dc:	7e d7                	jle    c01031b5 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c01031de:	c9                   	leave  
c01031df:	c3                   	ret    

c01031e0 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01031e0:	55                   	push   %ebp
c01031e1:	89 e5                	mov    %esp,%ebp
c01031e3:	83 ec 10             	sub    $0x10,%esp
c01031e6:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01031ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01031f0:	89 c2                	mov    %eax,%edx
c01031f2:	ec                   	in     (%dx),%al
c01031f3:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01031f6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01031fa:	0f b6 c0             	movzbl %al,%eax
c01031fd:	83 e0 20             	and    $0x20,%eax
c0103200:	85 c0                	test   %eax,%eax
c0103202:	0f 95 c0             	setne  %al
c0103205:	0f b6 c0             	movzbl %al,%eax
}
c0103208:	c9                   	leave  
c0103209:	c3                   	ret    

c010320a <serial_printc>:

static inline
void serial_printc(char ch) {
c010320a:	55                   	push   %ebp
c010320b:	89 e5                	mov    %esp,%ebp
c010320d:	83 ec 14             	sub    $0x14,%esp
c0103210:	8b 45 08             	mov    0x8(%ebp),%eax
c0103213:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103216:	90                   	nop
c0103217:	e8 c4 ff ff ff       	call   c01031e0 <serial_idle>
c010321c:	85 c0                	test   %eax,%eax
c010321e:	74 f7                	je     c0103217 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0103220:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103224:	0f b6 c0             	movzbl %al,%eax
c0103227:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010322e:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103231:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103235:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103238:	ee                   	out    %al,(%dx)
}
c0103239:	c9                   	leave  
c010323a:	c3                   	ret    

c010323b <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c010323b:	55                   	push   %ebp
c010323c:	89 e5                	mov    %esp,%ebp
c010323e:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0103241:	8b 45 08             	mov    0x8(%ebp),%eax
c0103244:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103247:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c010324c:	0f 84 23 03 00 00    	je     c0103575 <do_syscall+0x33a>
c0103252:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0103257:	0f 87 ad 00 00 00    	ja     c010330a <do_syscall+0xcf>
c010325d:	3d 15 05 00 00       	cmp    $0x515,%eax
c0103262:	0f 84 1b 04 00 00    	je     c0103683 <do_syscall+0x448>
c0103268:	3d 15 05 00 00       	cmp    $0x515,%eax
c010326d:	77 53                	ja     c01032c2 <do_syscall+0x87>
c010326f:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0103274:	0f 84 af 03 00 00    	je     c0103629 <do_syscall+0x3ee>
c010327a:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c010327f:	77 1b                	ja     c010329c <do_syscall+0x61>
c0103281:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0103286:	0f 84 7f 03 00 00    	je     c010360b <do_syscall+0x3d0>
c010328c:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0103291:	0f 84 8b 03 00 00    	je     c0103622 <do_syscall+0x3e7>
c0103297:	e9 f5 03 00 00       	jmp    c0103691 <do_syscall+0x456>
c010329c:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c01032a1:	0f 84 95 03 00 00    	je     c010363c <do_syscall+0x401>
c01032a7:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c01032ac:	0f 82 7e 03 00 00    	jb     c0103630 <do_syscall+0x3f5>
c01032b2:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01032b7:	0f 84 a6 03 00 00    	je     c0103663 <do_syscall+0x428>
c01032bd:	e9 cf 03 00 00       	jmp    c0103691 <do_syscall+0x456>
c01032c2:	3d de 05 00 00       	cmp    $0x5de,%eax
c01032c7:	0f 84 eb 02 00 00    	je     c01035b8 <do_syscall+0x37d>
c01032cd:	3d de 05 00 00       	cmp    $0x5de,%eax
c01032d2:	77 1b                	ja     c01032ef <do_syscall+0xb4>
c01032d4:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01032d9:	0f 84 04 03 00 00    	je     c01035e3 <do_syscall+0x3a8>
c01032df:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c01032e4:	0f 84 a2 02 00 00    	je     c010358c <do_syscall+0x351>
c01032ea:	e9 a2 03 00 00       	jmp    c0103691 <do_syscall+0x456>
c01032ef:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c01032f4:	0f 84 07 03 00 00    	je     c0103601 <do_syscall+0x3c6>
c01032fa:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c01032ff:	0f 87 9d 02 00 00    	ja     c01035a2 <do_syscall+0x367>
c0103305:	e9 ed 02 00 00       	jmp    c01035f7 <do_syscall+0x3bc>
c010330a:	3d 45 06 00 00       	cmp    $0x645,%eax
c010330f:	0f 84 1c 02 00 00    	je     c0103531 <do_syscall+0x2f6>
c0103315:	3d 45 06 00 00       	cmp    $0x645,%eax
c010331a:	77 48                	ja     c0103364 <do_syscall+0x129>
c010331c:	3d 41 06 00 00       	cmp    $0x641,%eax
c0103321:	0f 84 7e 01 00 00    	je     c01034a5 <do_syscall+0x26a>
c0103327:	3d 41 06 00 00       	cmp    $0x641,%eax
c010332c:	77 1b                	ja     c0103349 <do_syscall+0x10e>
c010332e:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0103333:	0f 84 17 02 00 00    	je     c0103550 <do_syscall+0x315>
c0103339:	3d 40 06 00 00       	cmp    $0x640,%eax
c010333e:	0f 84 41 01 00 00    	je     c0103485 <do_syscall+0x24a>
c0103344:	e9 48 03 00 00       	jmp    c0103691 <do_syscall+0x456>
c0103349:	3d 43 06 00 00       	cmp    $0x643,%eax
c010334e:	0f 84 90 01 00 00    	je     c01034e4 <do_syscall+0x2a9>
c0103354:	3d 43 06 00 00       	cmp    $0x643,%eax
c0103359:	0f 87 bb 01 00 00    	ja     c010351a <do_syscall+0x2df>
c010335f:	e9 69 01 00 00       	jmp    c01034cd <do_syscall+0x292>
c0103364:	3d a5 06 00 00       	cmp    $0x6a5,%eax
c0103369:	74 68                	je     c01033d3 <do_syscall+0x198>
c010336b:	3d a5 06 00 00       	cmp    $0x6a5,%eax
c0103370:	77 17                	ja     c0103389 <do_syscall+0x14e>
c0103372:	3d 46 06 00 00       	cmp    $0x646,%eax
c0103377:	0f 84 7e 01 00 00    	je     c01034fb <do_syscall+0x2c0>
c010337d:	3d a4 06 00 00       	cmp    $0x6a4,%eax
c0103382:	74 27                	je     c01033ab <do_syscall+0x170>
c0103384:	e9 08 03 00 00       	jmp    c0103691 <do_syscall+0x456>
c0103389:	3d a7 06 00 00       	cmp    $0x6a7,%eax
c010338e:	0f 84 a1 00 00 00    	je     c0103435 <do_syscall+0x1fa>
c0103394:	3d a7 06 00 00       	cmp    $0x6a7,%eax
c0103399:	72 69                	jb     c0103404 <do_syscall+0x1c9>
c010339b:	3d a8 06 00 00       	cmp    $0x6a8,%eax
c01033a0:	0f 84 c0 00 00 00    	je     c0103466 <do_syscall+0x22b>
c01033a6:	e9 e6 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FS_OPEN:
			tf->eax = fs_open_port((char*)tf->ebx, tf->ecx);
c01033ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01033ae:	8b 40 18             	mov    0x18(%eax),%eax
c01033b1:	89 c2                	mov    %eax,%edx
c01033b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b6:	8b 40 10             	mov    0x10(%eax),%eax
c01033b9:	83 ec 08             	sub    $0x8,%esp
c01033bc:	52                   	push   %edx
c01033bd:	50                   	push   %eax
c01033be:	e8 74 f1 ff ff       	call   c0102537 <fs_open_port>
c01033c3:	83 c4 10             	add    $0x10,%esp
c01033c6:	89 c2                	mov    %eax,%edx
c01033c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01033cb:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01033ce:	e9 be 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FS_READ:
			tf->eax = fs_read_port(tf->ebx, (void*)tf->ecx, tf->edx);
c01033d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d6:	8b 40 14             	mov    0x14(%eax),%eax
c01033d9:	89 c1                	mov    %eax,%ecx
c01033db:	8b 45 08             	mov    0x8(%ebp),%eax
c01033de:	8b 40 18             	mov    0x18(%eax),%eax
c01033e1:	89 c2                	mov    %eax,%edx
c01033e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033e6:	8b 40 10             	mov    0x10(%eax),%eax
c01033e9:	83 ec 04             	sub    $0x4,%esp
c01033ec:	51                   	push   %ecx
c01033ed:	52                   	push   %edx
c01033ee:	50                   	push   %eax
c01033ef:	e8 b5 f1 ff ff       	call   c01025a9 <fs_read_port>
c01033f4:	83 c4 10             	add    $0x10,%esp
c01033f7:	89 c2                	mov    %eax,%edx
c01033f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01033fc:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01033ff:	e9 8d 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FS_WRITE:
			tf->eax = fs_write_port(tf->ebx, (void*)tf->ecx, tf->edx);
c0103404:	8b 45 08             	mov    0x8(%ebp),%eax
c0103407:	8b 40 14             	mov    0x14(%eax),%eax
c010340a:	89 c1                	mov    %eax,%ecx
c010340c:	8b 45 08             	mov    0x8(%ebp),%eax
c010340f:	8b 40 18             	mov    0x18(%eax),%eax
c0103412:	89 c2                	mov    %eax,%edx
c0103414:	8b 45 08             	mov    0x8(%ebp),%eax
c0103417:	8b 40 10             	mov    0x10(%eax),%eax
c010341a:	83 ec 04             	sub    $0x4,%esp
c010341d:	51                   	push   %ecx
c010341e:	52                   	push   %edx
c010341f:	50                   	push   %eax
c0103420:	e8 b6 f1 ff ff       	call   c01025db <fs_write_port>
c0103425:	83 c4 10             	add    $0x10,%esp
c0103428:	89 c2                	mov    %eax,%edx
c010342a:	8b 45 08             	mov    0x8(%ebp),%eax
c010342d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103430:	e9 5c 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FS_LSEEK:
			tf->eax = fs_lseek_port(tf->ebx, tf->ecx, tf->edx);
c0103435:	8b 45 08             	mov    0x8(%ebp),%eax
c0103438:	8b 40 14             	mov    0x14(%eax),%eax
c010343b:	89 c1                	mov    %eax,%ecx
c010343d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103440:	8b 40 18             	mov    0x18(%eax),%eax
c0103443:	89 c2                	mov    %eax,%edx
c0103445:	8b 45 08             	mov    0x8(%ebp),%eax
c0103448:	8b 40 10             	mov    0x10(%eax),%eax
c010344b:	83 ec 04             	sub    $0x4,%esp
c010344e:	51                   	push   %ecx
c010344f:	52                   	push   %edx
c0103450:	50                   	push   %eax
c0103451:	e8 b7 f1 ff ff       	call   c010260d <fs_lseek_port>
c0103456:	83 c4 10             	add    $0x10,%esp
c0103459:	89 c2                	mov    %eax,%edx
c010345b:	8b 45 08             	mov    0x8(%ebp),%eax
c010345e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103461:	e9 2b 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FS_CLOSE:
			tf->eax = fs_close_port(tf->ebx);
c0103466:	8b 45 08             	mov    0x8(%ebp),%eax
c0103469:	8b 40 10             	mov    0x10(%eax),%eax
c010346c:	83 ec 0c             	sub    $0xc,%esp
c010346f:	50                   	push   %eax
c0103470:	e8 ca f1 ff ff       	call   c010263f <fs_close_port>
c0103475:	83 c4 10             	add    $0x10,%esp
c0103478:	89 c2                	mov    %eax,%edx
c010347a:	8b 45 08             	mov    0x8(%ebp),%eax
c010347d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103480:	e9 0c 02 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0103485:	8b 45 08             	mov    0x8(%ebp),%eax
c0103488:	8b 40 18             	mov    0x18(%eax),%eax
c010348b:	89 c2                	mov    %eax,%edx
c010348d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103490:	8b 40 10             	mov    0x10(%eax),%eax
c0103493:	83 ec 08             	sub    $0x8,%esp
c0103496:	52                   	push   %edx
c0103497:	50                   	push   %eax
c0103498:	e8 74 da ff ff       	call   c0100f11 <sem_init_kr>
c010349d:	83 c4 10             	add    $0x10,%esp
		break;
c01034a0:	e9 ec 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c01034a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01034a8:	8b 40 18             	mov    0x18(%eax),%eax
c01034ab:	89 c2                	mov    %eax,%edx
c01034ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b0:	8b 40 10             	mov    0x10(%eax),%eax
c01034b3:	83 ec 08             	sub    $0x8,%esp
c01034b6:	52                   	push   %edx
c01034b7:	50                   	push   %eax
c01034b8:	e8 c1 db ff ff       	call   c010107e <sem_open_kr>
c01034bd:	83 c4 10             	add    $0x10,%esp
c01034c0:	89 c2                	mov    %eax,%edx
c01034c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01034c5:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01034c8:	e9 c4 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c01034cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01034d0:	8b 40 10             	mov    0x10(%eax),%eax
c01034d3:	83 ec 0c             	sub    $0xc,%esp
c01034d6:	50                   	push   %eax
c01034d7:	e8 a1 da ff ff       	call   c0100f7d <sem_post_kr>
c01034dc:	83 c4 10             	add    $0x10,%esp
		break;
c01034df:	e9 ad 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c01034e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01034e7:	8b 40 10             	mov    0x10(%eax),%eax
c01034ea:	83 ec 0c             	sub    $0xc,%esp
c01034ed:	50                   	push   %eax
c01034ee:	e8 de da ff ff       	call   c0100fd1 <sem_wait_kr>
c01034f3:	83 c4 10             	add    $0x10,%esp
		break;
c01034f6:	e9 96 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c01034fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01034fe:	8b 40 10             	mov    0x10(%eax),%eax
c0103501:	83 ec 0c             	sub    $0xc,%esp
c0103504:	50                   	push   %eax
c0103505:	e8 1f db ff ff       	call   c0101029 <sem_trywait_kr>
c010350a:	83 c4 10             	add    $0x10,%esp
c010350d:	89 c2                	mov    %eax,%edx
c010350f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103512:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103515:	e9 77 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c010351a:	8b 45 08             	mov    0x8(%ebp),%eax
c010351d:	8b 40 10             	mov    0x10(%eax),%eax
c0103520:	83 ec 0c             	sub    $0xc,%esp
c0103523:	50                   	push   %eax
c0103524:	e8 08 da ff ff       	call   c0100f31 <sem_close_kr>
c0103529:	83 c4 10             	add    $0x10,%esp
		break;
c010352c:	e9 60 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0103531:	8b 45 08             	mov    0x8(%ebp),%eax
c0103534:	8b 40 10             	mov    0x10(%eax),%eax
c0103537:	83 ec 0c             	sub    $0xc,%esp
c010353a:	50                   	push   %eax
c010353b:	e8 23 db ff ff       	call   c0101063 <sem_get_kr>
c0103540:	83 c4 10             	add    $0x10,%esp
c0103543:	89 c2                	mov    %eax,%edx
c0103545:	8b 45 08             	mov    0x8(%ebp),%eax
c0103548:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010354b:	e9 41 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c0103550:	8b 45 08             	mov    0x8(%ebp),%eax
c0103553:	8b 48 14             	mov    0x14(%eax),%ecx
c0103556:	8b 45 08             	mov    0x8(%ebp),%eax
c0103559:	8b 50 18             	mov    0x18(%eax),%edx
c010355c:	8b 45 08             	mov    0x8(%ebp),%eax
c010355f:	8b 40 10             	mov    0x10(%eax),%eax
c0103562:	83 ec 04             	sub    $0x4,%esp
c0103565:	51                   	push   %ecx
c0103566:	52                   	push   %edx
c0103567:	50                   	push   %eax
c0103568:	e8 15 09 00 00       	call   c0103e82 <thread_current>
c010356d:	83 c4 10             	add    $0x10,%esp
		break;
c0103570:	e9 1c 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_JOIN:
			join_current(tf->ebx);
c0103575:	8b 45 08             	mov    0x8(%ebp),%eax
c0103578:	8b 40 10             	mov    0x10(%eax),%eax
c010357b:	83 ec 0c             	sub    $0xc,%esp
c010357e:	50                   	push   %eax
c010357f:	e8 dc 0a 00 00       	call   c0104060 <join_current>
c0103584:	83 c4 10             	add    $0x10,%esp
		break;
c0103587:	e9 05 01 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_PID:
			tf->eax = current->pid;
c010358c:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103591:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103597:	8b 45 08             	mov    0x8(%ebp),%eax
c010359a:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010359d:	e9 ef 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_PPID:
			tf->eax = current->ppid;
c01035a2:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01035a7:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c01035ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01035b0:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01035b3:	e9 d9 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c01035b8:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01035bd:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c01035c4:	00 00 00 
			current->timeslice = tf->ebx*200;
c01035c7:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01035cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01035cf:	8b 52 10             	mov    0x10(%edx),%edx
c01035d2:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c01035d8:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c01035de:	e9 ae 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_HANDOUT:
			current->ts = STOP;
c01035e3:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01035e8:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c01035ef:	00 00 00 
		break;
c01035f2:	e9 9a 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_EXIT:
			exit_current();
c01035f7:	e8 f7 09 00 00       	call   c0103ff3 <exit_current>
		break;
c01035fc:	e9 90 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_FORK:
			fork_current();
c0103601:	e8 0a 08 00 00       	call   c0103e10 <fork_current>
		break;
c0103606:	e9 86 00 00 00       	jmp    c0103691 <do_syscall+0x456>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c010360b:	8b 45 08             	mov    0x8(%ebp),%eax
c010360e:	8b 40 10             	mov    0x10(%eax),%eax
c0103611:	0f be c0             	movsbl %al,%eax
c0103614:	83 ec 0c             	sub    $0xc,%esp
c0103617:	50                   	push   %eax
c0103618:	e8 ed fb ff ff       	call   c010320a <serial_printc>
c010361d:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0103620:	eb 6f                	jmp    c0103691 <do_syscall+0x456>
		case SYS_INIT_CACHE:
			initVCache();
c0103622:	e8 00 0b 00 00       	call   c0104127 <initVCache>
		break;
c0103627:	eb 68                	jmp    c0103691 <do_syscall+0x456>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0103629:	e8 2e 0c 00 00       	call   c010425c <clearVRAM>
		break;
c010362e:	eb 61                	jmp    c0103691 <do_syscall+0x456>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0103630:	e8 27 0c 00 00       	call   c010425c <clearVRAM>
			flushVCache();
c0103635:	e8 56 0b 00 00       	call   c0104190 <flushVCache>
		break;
c010363a:	eb 55                	jmp    c0103691 <do_syscall+0x456>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c010363c:	8b 45 08             	mov    0x8(%ebp),%eax
c010363f:	8b 40 14             	mov    0x14(%eax),%eax
c0103642:	0f b6 c0             	movzbl %al,%eax
c0103645:	8b 55 08             	mov    0x8(%ebp),%edx
c0103648:	8b 52 18             	mov    0x18(%edx),%edx
c010364b:	89 d1                	mov    %edx,%ecx
c010364d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103650:	8b 52 10             	mov    0x10(%edx),%edx
c0103653:	83 ec 04             	sub    $0x4,%esp
c0103656:	50                   	push   %eax
c0103657:	51                   	push   %ecx
c0103658:	52                   	push   %edx
c0103659:	e8 97 0b 00 00       	call   c01041f5 <setPixelAt>
c010365e:	83 c4 10             	add    $0x10,%esp
		break;
c0103661:	eb 2e                	jmp    c0103691 <do_syscall+0x456>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0103663:	8b 45 08             	mov    0x8(%ebp),%eax
c0103666:	8b 40 10             	mov    0x10(%eax),%eax
c0103669:	0f be c0             	movsbl %al,%eax
c010366c:	83 ec 0c             	sub    $0xc,%esp
c010366f:	50                   	push   %eax
c0103670:	e8 c3 fa ff ff       	call   c0103138 <get_key>
c0103675:	83 c4 10             	add    $0x10,%esp
c0103678:	0f be d0             	movsbl %al,%edx
c010367b:	8b 45 08             	mov    0x8(%ebp),%eax
c010367e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103681:	eb 0e                	jmp    c0103691 <do_syscall+0x456>
		case SYS_GET_TICK:
			tf->eax = tick();
c0103683:	e8 20 0d 00 00       	call   c01043a8 <tick>
c0103688:	89 c2                	mov    %eax,%edx
c010368a:	8b 45 08             	mov    0x8(%ebp),%eax
c010368d:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0103690:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0103691:	c9                   	leave  
c0103692:	c3                   	ret    

c0103693 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103693:	55                   	push   %ebp
c0103694:	89 e5                	mov    %esp,%ebp
c0103696:	83 ec 10             	sub    $0x10,%esp
c0103699:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01036a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036a3:	89 c2                	mov    %eax,%edx
c01036a5:	ec                   	in     (%dx),%al
c01036a6:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01036a9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01036ad:	0f b6 c0             	movzbl %al,%eax
c01036b0:	83 e0 20             	and    $0x20,%eax
c01036b3:	85 c0                	test   %eax,%eax
c01036b5:	0f 95 c0             	setne  %al
c01036b8:	0f b6 c0             	movzbl %al,%eax
}
c01036bb:	c9                   	leave  
c01036bc:	c3                   	ret    

c01036bd <serial_printc>:

static inline
void serial_printc(char ch) {
c01036bd:	55                   	push   %ebp
c01036be:	89 e5                	mov    %esp,%ebp
c01036c0:	83 ec 14             	sub    $0x14,%esp
c01036c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c6:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01036c9:	90                   	nop
c01036ca:	e8 c4 ff ff ff       	call   c0103693 <serial_idle>
c01036cf:	85 c0                	test   %eax,%eax
c01036d1:	74 f7                	je     c01036ca <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01036d3:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01036d7:	0f b6 c0             	movzbl %al,%eax
c01036da:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01036e1:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01036e4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01036e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01036eb:	ee                   	out    %al,(%dx)
}
c01036ec:	c9                   	leave  
c01036ed:	c3                   	ret    

c01036ee <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01036ee:	55                   	push   %ebp
c01036ef:	89 e5                	mov    %esp,%ebp
c01036f1:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01036f4:	8d 45 0c             	lea    0xc(%ebp),%eax
c01036f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01036fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01036fd:	83 ec 04             	sub    $0x4,%esp
c0103700:	ff 75 f4             	pushl  -0xc(%ebp)
c0103703:	50                   	push   %eax
c0103704:	68 bd 36 10 c0       	push   $0xc01036bd
c0103709:	e8 1d 0e 00 00       	call   c010452b <vfprintf>
c010370e:	83 c4 10             	add    $0x10,%esp
}
c0103711:	c9                   	leave  
c0103712:	c3                   	ret    

c0103713 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0103713:	55                   	push   %ebp
c0103714:	89 e5                	mov    %esp,%ebp
c0103716:	57                   	push   %edi
c0103717:	56                   	push   %esi
c0103718:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103719:	8b 45 10             	mov    0x10(%ebp),%eax
c010371c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010371f:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103722:	89 c1                	mov    %eax,%ecx
c0103724:	89 d6                	mov    %edx,%esi
c0103726:	89 df                	mov    %ebx,%edi
c0103728:	fc                   	cld    
c0103729:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c010372b:	5b                   	pop    %ebx
c010372c:	5e                   	pop    %esi
c010372d:	5f                   	pop    %edi
c010372e:	5d                   	pop    %ebp
c010372f:	c3                   	ret    

c0103730 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103730:	55                   	push   %ebp
c0103731:	89 e5                	mov    %esp,%ebp
c0103733:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0103736:	8b 45 10             	mov    0x10(%ebp),%eax
c0103739:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c010373e:	77 16                	ja     c0103756 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0103740:	ff 75 10             	pushl  0x10(%ebp)
c0103743:	68 cc 49 10 c0       	push   $0xc01049cc
c0103748:	ff 75 0c             	pushl  0xc(%ebp)
c010374b:	ff 75 08             	pushl  0x8(%ebp)
c010374e:	e8 9b ff ff ff       	call   c01036ee <printk>
c0103753:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0103756:	8b 45 10             	mov    0x10(%ebp),%eax
c0103759:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010375e:	c9                   	leave  
c010375f:	c3                   	ret    

c0103760 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0103760:	55                   	push   %ebp
c0103761:	89 e5                	mov    %esp,%ebp
c0103763:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103766:	8b 45 10             	mov    0x10(%ebp),%eax
c0103769:	c1 e8 0c             	shr    $0xc,%eax
c010376c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103771:	76 13                	jbe    c0103786 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0103773:	83 ec 08             	sub    $0x8,%esp
c0103776:	ff 75 10             	pushl  0x10(%ebp)
c0103779:	68 f0 49 10 c0       	push   $0xc01049f0
c010377e:	e8 6b ff ff ff       	call   c01036ee <printk>
c0103783:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0103786:	8b 45 10             	mov    0x10(%ebp),%eax
c0103789:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010378e:	c9                   	leave  
c010378f:	c3                   	ret    

c0103790 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0103790:	55                   	push   %ebp
c0103791:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0103793:	8b 45 08             	mov    0x8(%ebp),%eax
c0103796:	ba 00 57 17 c0       	mov    $0xc0175700,%edx
c010379b:	29 d0                	sub    %edx,%eax
c010379d:	c1 f8 03             	sar    $0x3,%eax
c01037a0:	c1 e0 0c             	shl    $0xc,%eax
}
c01037a3:	5d                   	pop    %ebp
c01037a4:	c3                   	ret    

c01037a5 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c01037a5:	55                   	push   %ebp
c01037a6:	89 e5                	mov    %esp,%ebp
c01037a8:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01037ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ae:	c1 e8 0c             	shr    $0xc,%eax
c01037b1:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01037b6:	76 10                	jbe    c01037c8 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c01037b8:	83 ec 0c             	sub    $0xc,%esp
c01037bb:	68 14 4a 10 c0       	push   $0xc0104a14
c01037c0:	e8 29 ff ff ff       	call   c01036ee <printk>
c01037c5:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c01037c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01037cb:	c1 e8 0c             	shr    $0xc,%eax
c01037ce:	c1 e0 03             	shl    $0x3,%eax
c01037d1:	05 00 57 17 c0       	add    $0xc0175700,%eax
}
c01037d6:	c9                   	leave  
c01037d7:	c3                   	ret    

c01037d8 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c01037d8:	55                   	push   %ebp
c01037d9:	89 e5                	mov    %esp,%ebp
c01037db:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01037de:	ff 75 08             	pushl  0x8(%ebp)
c01037e1:	e8 aa ff ff ff       	call   c0103790 <page2pa>
c01037e6:	83 c4 04             	add    $0x4,%esp
c01037e9:	83 ec 04             	sub    $0x4,%esp
c01037ec:	50                   	push   %eax
c01037ed:	6a 52                	push   $0x52
c01037ef:	68 33 4a 10 c0       	push   $0xc0104a33
c01037f4:	e8 67 ff ff ff       	call   c0103760 <_kaddr>
c01037f9:	83 c4 10             	add    $0x10,%esp
}
c01037fc:	c9                   	leave  
c01037fd:	c3                   	ret    

c01037fe <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c01037fe:	55                   	push   %ebp
c01037ff:	89 e5                	mov    %esp,%ebp
c0103801:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0103804:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c010380b:	8b 45 08             	mov    0x8(%ebp),%eax
c010380e:	8b 00                	mov    (%eax),%eax
c0103810:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0103813:	eb 10                	jmp    c0103825 <ll_len+0x27>
		p = p->next;
c0103815:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103818:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c010381e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0103821:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0103825:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103829:	75 ea                	jne    c0103815 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c010382b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010382e:	c9                   	leave  
c010382f:	c3                   	ret    

c0103830 <ll_pop>:
PCB* ll_pop(PCB** head){
c0103830:	55                   	push   %ebp
c0103831:	89 e5                	mov    %esp,%ebp
c0103833:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0103836:	8b 45 08             	mov    0x8(%ebp),%eax
c0103839:	8b 00                	mov    (%eax),%eax
c010383b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c010383e:	83 ec 08             	sub    $0x8,%esp
c0103841:	ff 75 f4             	pushl  -0xc(%ebp)
c0103844:	ff 75 08             	pushl  0x8(%ebp)
c0103847:	e8 a4 00 00 00       	call   c01038f0 <ll_delete>
c010384c:	83 c4 10             	add    $0x10,%esp
	return p;
c010384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103852:	c9                   	leave  
c0103853:	c3                   	ret    

c0103854 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0103854:	55                   	push   %ebp
c0103855:	89 e5                	mov    %esp,%ebp
c0103857:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010385a:	8b 45 08             	mov    0x8(%ebp),%eax
c010385d:	8b 00                	mov    (%eax),%eax
c010385f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0103862:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103866:	75 0f                	jne    c0103877 <ll_push+0x23>
		*head = p;
c0103868:	8b 45 08             	mov    0x8(%ebp),%eax
c010386b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010386e:	89 10                	mov    %edx,(%eax)
		return 0;
c0103870:	b8 00 00 00 00       	mov    $0x0,%eax
c0103875:	eb 19                	jmp    c0103890 <ll_push+0x3c>
	}else{
		*head = p;
c0103877:	8b 45 08             	mov    0x8(%ebp),%eax
c010387a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010387d:	89 10                	mov    %edx,(%eax)
		p->next = h;
c010387f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103882:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103885:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c010388b:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103890:	c9                   	leave  
c0103891:	c3                   	ret    

c0103892 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0103892:	55                   	push   %ebp
c0103893:	89 e5                	mov    %esp,%ebp
c0103895:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103898:	8b 45 08             	mov    0x8(%ebp),%eax
c010389b:	8b 00                	mov    (%eax),%eax
c010389d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c01038a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038a3:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c01038aa:	00 00 00 
	if(h == NULL){
c01038ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01038b1:	75 0f                	jne    c01038c2 <ll_entail+0x30>
		*head = p;
c01038b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01038b9:	89 10                	mov    %edx,(%eax)
		return 0;
c01038bb:	b8 00 00 00 00       	mov    $0x0,%eax
c01038c0:	eb 2c                	jmp    c01038ee <ll_entail+0x5c>
	}else{
		while(h->next){
c01038c2:	eb 0c                	jmp    c01038d0 <ll_entail+0x3e>
			h = h->next;
c01038c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01038c7:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c01038cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c01038d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01038d3:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c01038d9:	85 c0                	test   %eax,%eax
c01038db:	75 e7                	jne    c01038c4 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c01038dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01038e0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01038e3:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		return 1;
c01038e9:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01038ee:	c9                   	leave  
c01038ef:	c3                   	ret    

c01038f0 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c01038f0:	55                   	push   %ebp
c01038f1:	89 e5                	mov    %esp,%ebp
c01038f3:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c01038f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01038f9:	8b 00                	mov    (%eax),%eax
c01038fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01038fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c0103905:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103909:	75 07                	jne    c0103912 <ll_delete+0x22>
			return 0;
c010390b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103910:	eb 59                	jmp    c010396b <ll_delete+0x7b>
		if(sleep == p)
c0103912:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103915:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103918:	75 09                	jne    c0103923 <ll_delete+0x33>
			break;
c010391a:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c010391b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010391f:	75 26                	jne    c0103947 <ll_delete+0x57>
c0103921:	eb 14                	jmp    c0103937 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0103923:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103926:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0103929:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010392c:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c0103932:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0103935:	eb ce                	jmp    c0103905 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c0103937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010393a:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103940:	8b 45 08             	mov    0x8(%ebp),%eax
c0103943:	89 10                	mov    %edx,(%eax)
c0103945:	eb 12                	jmp    c0103959 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0103947:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010394a:	8b 90 60 24 00 00    	mov    0x2460(%eax),%edx
c0103950:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103953:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
	sleep->next = NULL;
c0103959:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010395c:	c7 80 60 24 00 00 00 	movl   $0x0,0x2460(%eax)
c0103963:	00 00 00 
	return 1;
c0103966:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010396b:	c9                   	leave  
c010396c:	c3                   	ret    

c010396d <init_pcb_pool>:

void init_pcb_pool()
{
c010396d:	55                   	push   %ebp
c010396e:	89 e5                	mov    %esp,%ebp
c0103970:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103973:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010397a:	eb 1d                	jmp    c0103999 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c010397c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010397f:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103985:	05 40 20 00 00       	add    $0x2040,%eax
c010398a:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c010398f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103995:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103999:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c01039a0:	76 da                	jbe    c010397c <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c01039a2:	c9                   	leave  
c01039a3:	c3                   	ret    

c01039a4 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c01039a4:	55                   	push   %ebp
c01039a5:	89 e5                	mov    %esp,%ebp
c01039a7:	83 ec 24             	sub    $0x24,%esp
c01039aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01039ad:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c01039b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01039b3:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01039b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c01039bc:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01039c0:	75 46                	jne    c0103a08 <init_pcb+0x64>
		tf->ds = GD_KD;
c01039c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039c5:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c01039cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039cf:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c01039d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039d9:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c01039df:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039e2:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c01039e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039ec:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c01039f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039f6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01039fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01039ff:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0103a06:	eb 4a                	jmp    c0103a52 <init_pcb+0xae>
	}else
	if(pri == 3){
c0103a08:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0103a0c:	75 44                	jne    c0103a52 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0103a0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a11:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0103a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a1b:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0103a22:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a25:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0103a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a2e:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0103a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a38:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0103a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a42:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103a48:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a4b:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0103a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a55:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a58:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0103a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a5e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103a61:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0103a64:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103a68:	75 59                	jne    c0103ac3 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c0103a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0103a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0103a76:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103a7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103a84:	eb 26                	jmp    c0103aac <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0103a86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a93:	01 c2                	add    %eax,%edx
c0103a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a98:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa2:	01 c8                	add    %ecx,%eax
c0103aa4:	8b 00                	mov    (%eax),%eax
c0103aa6:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103aa8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aaf:	c1 e8 02             	shr    $0x2,%eax
c0103ab2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0103ab5:	77 cf                	ja     c0103a86 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0103ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103abd:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c0103ac3:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103ac7:	0f 95 c0             	setne  %al
c0103aca:	0f b6 d0             	movzbl %al,%edx
c0103acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad0:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0103ad6:	c9                   	leave  
c0103ad7:	c3                   	ret    

c0103ad8 <pcb_create>:

PCB* pcb_create()
{
c0103ad8:	55                   	push   %ebp
c0103ad9:	89 e5                	mov    %esp,%ebp
c0103adb:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ae5:	eb 1f                	jmp    c0103b06 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0103ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aea:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103af0:	05 40 20 00 00       	add    $0x2040,%eax
c0103af5:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c0103afa:	8b 00                	mov    (%eax),%eax
c0103afc:	85 c0                	test   %eax,%eax
c0103afe:	75 02                	jne    c0103b02 <pcb_create+0x2a>
c0103b00:	eb 0d                	jmp    c0103b0f <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103b02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103b06:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0103b0d:	76 d8                	jbe    c0103ae7 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0103b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b12:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0103b18:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c0103b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0103b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b23:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0103b26:	8d 90 40 cb 1f c0    	lea    -0x3fe034c0(%eax),%edx
c0103b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b2f:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	for(i=0; i<FCBMAX; i++){
c0103b35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b3c:	eb 17                	jmp    c0103b55 <pcb_create+0x7d>
		p->fcb[i].fd_kr = -1;
c0103b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b44:	81 c2 18 08 00 00    	add    $0x818,%edx
c0103b4a:	c7 04 90 ff ff ff ff 	movl   $0xffffffff,(%eax,%edx,4)
	for(i=0; i<PCBPOOLMAX; i++){
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
	p->tf = &tfPool[i];
	for(i=0; i<FCBMAX; i++){
c0103b51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103b55:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
c0103b5c:	76 e0                	jbe    c0103b3e <pcb_create+0x66>
		p->fcb[i].fd_kr = -1;
	}
	p->used = 1;
c0103b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b61:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c0103b68:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0103b6b:	83 ec 0c             	sub    $0xc,%esp
c0103b6e:	6a 01                	push   $0x1
c0103b70:	e8 0e cd ff ff       	call   c0100883 <page_alloc>
c0103b75:	83 c4 10             	add    $0x10,%esp
c0103b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0103b7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b7f:	75 07                	jne    c0103b88 <pcb_create+0xb0>
c0103b81:	b8 00 00 00 00       	mov    $0x0,%eax
c0103b86:	eb 77                	jmp    c0103bff <pcb_create+0x127>
	p->pgdir = page2kva(pp);
c0103b88:	83 ec 0c             	sub    $0xc,%esp
c0103b8b:	ff 75 ec             	pushl  -0x14(%ebp)
c0103b8e:	e8 45 fc ff ff       	call   c01037d8 <page2kva>
c0103b93:	83 c4 10             	add    $0x10,%esp
c0103b96:	89 c2                	mov    %eax,%edx
c0103b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b9b:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c0103ba1:	8b 15 a8 80 10 c0    	mov    0xc01080a8,%edx
c0103ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103baa:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c0103bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bb3:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0103bba:	00 00 00 
	//p->ts = READY;
	pid ++;
c0103bbd:	a1 a8 80 10 c0       	mov    0xc01080a8,%eax
c0103bc2:	83 c0 01             	add    $0x1,%eax
c0103bc5:	a3 a8 80 10 c0       	mov    %eax,0xc01080a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0103bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bcd:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0103bd1:	8d 50 01             	lea    0x1(%eax),%edx
c0103bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bd7:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0103bdb:	8b 15 c0 56 17 c0    	mov    0xc01756c0,%edx
c0103be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103be4:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103bea:	83 ec 04             	sub    $0x4,%esp
c0103bed:	68 00 10 00 00       	push   $0x1000
c0103bf2:	52                   	push   %edx
c0103bf3:	50                   	push   %eax
c0103bf4:	e8 1a fb ff ff       	call   c0103713 <memcpy>
c0103bf9:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0103bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103bff:	c9                   	leave  
c0103c00:	c3                   	ret    

c0103c01 <enready_pcb>:

void enready_pcb(PCB* pcb){
c0103c01:	55                   	push   %ebp
c0103c02:	89 e5                	mov    %esp,%ebp
c0103c04:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0103c07:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103c0c:	85 c0                	test   %eax,%eax
c0103c0e:	75 18                	jne    c0103c28 <enready_pcb+0x27>
		ready_list = pcb;
c0103c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c13:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->tail = pcb;
c0103c18:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103c1d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c20:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
c0103c26:	eb 32                	jmp    c0103c5a <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c0103c28:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c0103c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c33:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->next = temp;
c0103c38:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103c3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103c40:	89 90 60 24 00 00    	mov    %edx,0x2460(%eax)
		ready_list->tail = temp->tail;
c0103c46:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103c4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103c4e:	8b 92 64 24 00 00    	mov    0x2464(%edx),%edx
c0103c54:	89 90 64 24 00 00    	mov    %edx,0x2464(%eax)
	}
}
c0103c5a:	c9                   	leave  
c0103c5b:	c3                   	ret    

c0103c5c <switch_pcb>:

void switch_pcb(PCB* pcb){
c0103c5c:	55                   	push   %ebp
c0103c5d:	89 e5                	mov    %esp,%ebp
c0103c5f:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c0103c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c65:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac
	lcr3(PADDR(pcb -> pgdir));
c0103c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103c73:	83 ec 04             	sub    $0x4,%esp
c0103c76:	50                   	push   %eax
c0103c77:	68 b2 00 00 00       	push   $0xb2
c0103c7c:	68 49 4a 10 c0       	push   $0xc0104a49
c0103c81:	e8 aa fa ff ff       	call   c0103730 <_paddr>
c0103c86:	83 c4 10             	add    $0x10,%esp
c0103c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0103c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c8f:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0103c92:	83 ec 0c             	sub    $0xc,%esp
c0103c95:	ff 75 08             	pushl  0x8(%ebp)
c0103c98:	e8 bf c6 ff ff       	call   c010035c <enter_pcb>
c0103c9d:	83 c4 10             	add    $0x10,%esp
}
c0103ca0:	c9                   	leave  
c0103ca1:	c3                   	ret    

c0103ca2 <free_pcb>:
void free_pcb(PCB* pcb){
c0103ca2:	55                   	push   %ebp
c0103ca3:	89 e5                	mov    %esp,%ebp
c0103ca5:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0103ca8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cab:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103cb1:	83 ec 0c             	sub    $0xc,%esp
c0103cb4:	50                   	push   %eax
c0103cb5:	e8 2d d1 ff ff       	call   c0100de7 <free_pgdir>
c0103cba:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0103cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc0:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103cc6:	83 ec 04             	sub    $0x4,%esp
c0103cc9:	50                   	push   %eax
c0103cca:	68 bb 00 00 00       	push   $0xbb
c0103ccf:	68 49 4a 10 c0       	push   $0xc0104a49
c0103cd4:	e8 57 fa ff ff       	call   c0103730 <_paddr>
c0103cd9:	83 c4 10             	add    $0x10,%esp
c0103cdc:	83 ec 0c             	sub    $0xc,%esp
c0103cdf:	50                   	push   %eax
c0103ce0:	e8 c0 fa ff ff       	call   c01037a5 <pa2page>
c0103ce5:	83 c4 10             	add    $0x10,%esp
c0103ce8:	83 ec 0c             	sub    $0xc,%esp
c0103ceb:	50                   	push   %eax
c0103cec:	e8 1a cc ff ff       	call   c010090b <page_decref>
c0103cf1:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c0103cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cf7:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c0103cfe:	00 00 00 

}
c0103d01:	c9                   	leave  
c0103d02:	c3                   	ret    

c0103d03 <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c0103d03:	55                   	push   %ebp
c0103d04:	89 e5                	mov    %esp,%ebp
c0103d06:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0103d09:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0f:	68 10 08 00 00       	push   $0x810
c0103d14:	52                   	push   %edx
c0103d15:	50                   	push   %eax
c0103d16:	e8 f8 f9 ff ff       	call   c0103713 <memcpy>
c0103d1b:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c0103d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d21:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0103d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2a:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c0103d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d33:	05 20 10 00 00       	add    $0x1020,%eax
c0103d38:	89 c2                	mov    %eax,%edx
c0103d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d3d:	05 20 10 00 00       	add    $0x1020,%eax
c0103d42:	29 c2                	sub    %eax,%edx
c0103d44:	89 d0                	mov    %edx,%eax
c0103d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c0103d49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d4c:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c0103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d55:	01 c2                	add    %eax,%edx
c0103d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d5a:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c0103d60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103d63:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c0103d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d6c:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c0103d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d75:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103d7b:	85 c0                	test   %eax,%eax
c0103d7d:	75 62                	jne    c0103de1 <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c0103d7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d82:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103d88:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d8b:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c0103d91:	8b 4a 08             	mov    0x8(%edx),%ecx
c0103d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103d97:	01 ca                	add    %ecx,%edx
c0103d99:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0103d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9f:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103da5:	8b 40 08             	mov    0x8(%eax),%eax
c0103da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0103dab:	eb 17                	jmp    c0103dc4 <copy_pcb+0xc1>
			*(ptr) += offset;
c0103dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103db0:	8b 10                	mov    (%eax),%edx
c0103db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db5:	01 c2                	add    %eax,%edx
c0103db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dba:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0103dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dbf:	8b 00                	mov    (%eax),%eax
c0103dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0103dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dc7:	8b 00                	mov    (%eax),%eax
c0103dc9:	85 c0                	test   %eax,%eax
c0103dcb:	75 e0                	jne    c0103dad <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0103dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103dd0:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0103dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dd9:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c0103ddf:	eb 2d                	jmp    c0103e0e <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c0103de1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103de4:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103dea:	83 f8 02             	cmp    $0x2,%eax
c0103ded:	74 1f                	je     c0103e0e <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c0103def:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103df2:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0103df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dfb:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103e01:	83 ec 08             	sub    $0x8,%esp
c0103e04:	52                   	push   %edx
c0103e05:	50                   	push   %eax
c0103e06:	e8 27 cd ff ff       	call   c0100b32 <copy_pgdir>
c0103e0b:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c0103e0e:	c9                   	leave  
c0103e0f:	c3                   	ret    

c0103e10 <fork_current>:

void switch_proc();
void fork_current(){
c0103e10:	55                   	push   %ebp
c0103e11:	89 e5                	mov    %esp,%ebp
c0103e13:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0103e16:	e8 bd fc ff ff       	call   c0103ad8 <pcb_create>
c0103e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c0103e1e:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103e23:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e2c:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0103e32:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103e37:	83 ec 08             	sub    $0x8,%esp
c0103e3a:	50                   	push   %eax
c0103e3b:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e3e:	e8 c0 fe ff ff       	call   c0103d03 <copy_pcb>
c0103e43:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0103e46:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103e4b:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e54:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103e5a:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0103e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e60:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103e66:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c0103e6d:	83 ec 08             	sub    $0x8,%esp
c0103e70:	ff 75 f4             	pushl  -0xc(%ebp)
c0103e73:	68 b0 60 15 c0       	push   $0xc01560b0
c0103e78:	e8 d7 f9 ff ff       	call   c0103854 <ll_push>
c0103e7d:	83 c4 10             	add    $0x10,%esp
}
c0103e80:	c9                   	leave  
c0103e81:	c3                   	ret    

c0103e82 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c0103e82:	55                   	push   %ebp
c0103e83:	89 e5                	mov    %esp,%ebp
c0103e85:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c0103e88:	e8 4b fc ff ff       	call   c0103ad8 <pcb_create>
c0103e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c0103e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e93:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0103e9a:	00 00 00 
	son->ppid = current->pid;
c0103e9d:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103ea2:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eab:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0103eb1:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103eb6:	83 ec 08             	sub    $0x8,%esp
c0103eb9:	50                   	push   %eax
c0103eba:	ff 75 f4             	pushl  -0xc(%ebp)
c0103ebd:	e8 41 fe ff ff       	call   c0103d03 <copy_pcb>
c0103ec2:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c0103ec5:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103eca:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0103ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ed3:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103ed9:	83 ec 04             	sub    $0x4,%esp
c0103edc:	68 00 10 00 00       	push   $0x1000
c0103ee1:	52                   	push   %edx
c0103ee2:	50                   	push   %eax
c0103ee3:	e8 2b f8 ff ff       	call   c0103713 <memcpy>
c0103ee8:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c0103eeb:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0103ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ef5:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c0103efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103efe:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103f04:	83 ec 04             	sub    $0x4,%esp
c0103f07:	68 00 20 00 00       	push   $0x2000
c0103f0c:	52                   	push   %edx
c0103f0d:	50                   	push   %eax
c0103f0e:	e8 7e c7 ff ff       	call   c0100691 <mm_alloc>
c0103f13:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c0103f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f19:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103f22:	83 ea 40             	sub    $0x40,%edx
c0103f25:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c0103f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f2b:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103f34:	83 ea 40             	sub    $0x40,%edx
c0103f37:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c0103f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f3d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f43:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f46:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0103f49:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103f4e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f57:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103f5d:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0103f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f63:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103f69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c0103f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f73:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103f79:	83 ec 04             	sub    $0x4,%esp
c0103f7c:	50                   	push   %eax
c0103f7d:	68 fe 00 00 00       	push   $0xfe
c0103f82:	68 49 4a 10 c0       	push   $0xc0104a49
c0103f87:	e8 a4 f7 ff ff       	call   c0103730 <_paddr>
c0103f8c:	83 c4 10             	add    $0x10,%esp
c0103f8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f95:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c0103f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f9b:	83 e8 40             	sub    $0x40,%eax
c0103f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c0103fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fa7:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c0103fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fac:	8d 50 04             	lea    0x4(%eax),%edx
c0103faf:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fb2:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c0103fb4:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103fb9:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103fbf:	83 ec 04             	sub    $0x4,%esp
c0103fc2:	50                   	push   %eax
c0103fc3:	68 04 01 00 00       	push   $0x104
c0103fc8:	68 49 4a 10 c0       	push   $0xc0104a49
c0103fcd:	e8 5e f7 ff ff       	call   c0103730 <_paddr>
c0103fd2:	83 c4 10             	add    $0x10,%esp
c0103fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fdb:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c0103fde:	83 ec 08             	sub    $0x8,%esp
c0103fe1:	ff 75 f4             	pushl  -0xc(%ebp)
c0103fe4:	68 b0 60 15 c0       	push   $0xc01560b0
c0103fe9:	e8 66 f8 ff ff       	call   c0103854 <ll_push>
c0103fee:	83 c4 10             	add    $0x10,%esp
}
c0103ff1:	c9                   	leave  
c0103ff2:	c3                   	ret    

c0103ff3 <exit_current>:

void exit_current(){
c0103ff3:	55                   	push   %ebp
c0103ff4:	89 e5                	mov    %esp,%ebp
c0103ff6:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0103ff9:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103ffe:	05 68 24 00 00       	add    $0x2468,%eax
c0104003:	83 ec 0c             	sub    $0xc,%esp
c0104006:	50                   	push   %eax
c0104007:	e8 24 f8 ff ff       	call   c0103830 <ll_pop>
c010400c:	83 c4 10             	add    $0x10,%esp
c010400f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0104012:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104016:	75 02                	jne    c010401a <exit_current+0x27>
c0104018:	eb 24                	jmp    c010403e <exit_current+0x4b>
		if(p->used == 0) continue;
c010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010401d:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0104023:	85 c0                	test   %eax,%eax
c0104025:	75 02                	jne    c0104029 <exit_current+0x36>
c0104027:	eb 13                	jmp    c010403c <exit_current+0x49>
		ll_entail(&ready_list, p);
c0104029:	83 ec 08             	sub    $0x8,%esp
c010402c:	ff 75 f4             	pushl  -0xc(%ebp)
c010402f:	68 b0 60 15 c0       	push   $0xc01560b0
c0104034:	e8 59 f8 ff ff       	call   c0103892 <ll_entail>
c0104039:	83 c4 10             	add    $0x10,%esp
	}
c010403c:	eb bb                	jmp    c0103ff9 <exit_current+0x6>
	
	free_pcb(current);
c010403e:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0104043:	83 ec 0c             	sub    $0xc,%esp
c0104046:	50                   	push   %eax
c0104047:	e8 56 fc ff ff       	call   c0103ca2 <free_pcb>
c010404c:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c010404f:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0104056:	00 00 00 
	do_scheduler();
c0104059:	e8 4d d0 ff ff       	call   c01010ab <do_scheduler>
}
c010405e:	c9                   	leave  
c010405f:	c3                   	ret    

c0104060 <join_current>:

void join_current(int pid){
c0104060:	55                   	push   %ebp
c0104061:	89 e5                	mov    %esp,%ebp
c0104063:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0104066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010406a:	75 05                	jne    c0104071 <join_current+0x11>
c010406c:	e9 97 00 00 00       	jmp    c0104108 <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0104071:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104078:	eb 23                	jmp    c010409d <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c010407a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010407d:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c0104083:	05 40 20 00 00       	add    $0x2040,%eax
c0104088:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c010408d:	8b 50 04             	mov    0x4(%eax),%edx
c0104090:	8b 45 08             	mov    0x8(%ebp),%eax
c0104093:	39 c2                	cmp    %eax,%edx
c0104095:	75 02                	jne    c0104099 <join_current+0x39>
c0104097:	eb 0d                	jmp    c01040a6 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0104099:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010409d:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01040a4:	76 d4                	jbe    c010407a <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c01040a6:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c01040ad:	75 02                	jne    c01040b1 <join_current+0x51>
c01040af:	eb 57                	jmp    c0104108 <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c01040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040b4:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c01040ba:	05 40 20 00 00       	add    $0x2040,%eax
c01040bf:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c01040c4:	8b 00                	mov    (%eax),%eax
c01040c6:	85 c0                	test   %eax,%eax
c01040c8:	75 02                	jne    c01040cc <join_current+0x6c>
c01040ca:	eb 3c                	jmp    c0104108 <join_current+0xa8>
	PCB *p = &PCBPool[i];
c01040cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040cf:	69 c0 6c 24 00 00    	imul   $0x246c,%eax,%eax
c01040d5:	05 40 f4 20 c0       	add    $0xc020f440,%eax
c01040da:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c01040dd:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01040e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c01040e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040e8:	05 68 24 00 00       	add    $0x2468,%eax
c01040ed:	ff 75 ec             	pushl  -0x14(%ebp)
c01040f0:	50                   	push   %eax
c01040f1:	e8 9c f7 ff ff       	call   c0103892 <ll_entail>
c01040f6:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c01040f9:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0104100:	00 00 00 
	do_scheduler();
c0104103:	e8 a3 cf ff ff       	call   c01010ab <do_scheduler>
c0104108:	c9                   	leave  
c0104109:	c3                   	ret    

c010410a <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c010410a:	55                   	push   %ebp
c010410b:	89 e5                	mov    %esp,%ebp
c010410d:	57                   	push   %edi
c010410e:	56                   	push   %esi
c010410f:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0104110:	8b 45 10             	mov    0x10(%ebp),%eax
c0104113:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104116:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0104119:	89 c1                	mov    %eax,%ecx
c010411b:	89 d6                	mov    %edx,%esi
c010411d:	89 df                	mov    %ebx,%edi
c010411f:	fc                   	cld    
c0104120:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0104122:	5b                   	pop    %ebx
c0104123:	5e                   	pop    %esi
c0104124:	5f                   	pop    %edi
c0104125:	5d                   	pop    %ebp
c0104126:	c3                   	ret    

c0104127 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0104127:	55                   	push   %ebp
c0104128:	89 e5                	mov    %esp,%ebp
c010412a:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c010412d:	68 80 3e 00 00       	push   $0x3e80
c0104132:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0104137:	68 c0 60 15 c0       	push   $0xc01560c0
c010413c:	e8 c9 ff ff ff       	call   c010410a <memcpy>
c0104141:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0104144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010414b:	eb 0f                	jmp    c010415c <initVCache+0x35>
		VDIRTY[x] = 0;
c010414d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104150:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0104155:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0104158:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010415c:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0104163:	7e e8                	jle    c010414d <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0104165:	c9                   	leave  
c0104166:	c3                   	ret    

c0104167 <refreshVCache>:
void refreshVCache(){
c0104167:	55                   	push   %ebp
c0104168:	89 e5                	mov    %esp,%ebp
c010416a:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c010416d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104174:	eb 0f                	jmp    c0104185 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0104176:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104179:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c010417e:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0104181:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104185:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c010418c:	7e e8                	jle    c0104176 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c010418e:	c9                   	leave  
c010418f:	c3                   	ret    

c0104190 <flushVCache>:
void flushVCache(){
c0104190:	55                   	push   %ebp
c0104191:	89 e5                	mov    %esp,%ebp
c0104193:	53                   	push   %ebx
c0104194:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0104197:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010419e:	eb 47                	jmp    c01041e7 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c01041a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041a3:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c01041a8:	0f b6 00             	movzbl (%eax),%eax
c01041ab:	84 c0                	test   %al,%al
c01041ad:	74 34                	je     c01041e3 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c01041af:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01041b2:	89 d0                	mov    %edx,%eax
c01041b4:	c1 e0 02             	shl    $0x2,%eax
c01041b7:	01 d0                	add    %edx,%eax
c01041b9:	c1 e0 06             	shl    $0x6,%eax
c01041bc:	8d 88 c0 60 15 c0    	lea    -0x3fea9f40(%eax),%ecx
c01041c2:	8b 1d ac 80 10 c0    	mov    0xc01080ac,%ebx
c01041c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01041cb:	89 d0                	mov    %edx,%eax
c01041cd:	c1 e0 02             	shl    $0x2,%eax
c01041d0:	01 d0                	add    %edx,%eax
c01041d2:	c1 e0 06             	shl    $0x6,%eax
c01041d5:	01 d8                	add    %ebx,%eax
c01041d7:	6a 50                	push   $0x50
c01041d9:	51                   	push   %ecx
c01041da:	50                   	push   %eax
c01041db:	e8 2a ff ff ff       	call   c010410a <memcpy>
c01041e0:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c01041e3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01041e7:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c01041ee:	7e b0                	jle    c01041a0 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c01041f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01041f3:	c9                   	leave  
c01041f4:	c3                   	ret    

c01041f5 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c01041f5:	55                   	push   %ebp
c01041f6:	89 e5                	mov    %esp,%ebp
c01041f8:	83 ec 04             	sub    $0x4,%esp
c01041fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01041fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0104201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104205:	78 18                	js     c010421f <setPixelAt+0x2a>
c0104207:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c010420e:	7f 0f                	jg     c010421f <setPixelAt+0x2a>
c0104210:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104214:	78 09                	js     c010421f <setPixelAt+0x2a>
c0104216:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c010421d:	7e 02                	jle    c0104221 <setPixelAt+0x2c>
c010421f:	eb 34                	jmp    c0104255 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0104221:	8b 45 08             	mov    0x8(%ebp),%eax
c0104224:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0104229:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c010422c:	8b 45 08             	mov    0x8(%ebp),%eax
c010422f:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0104234:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0104237:	8b 55 08             	mov    0x8(%ebp),%edx
c010423a:	89 d0                	mov    %edx,%eax
c010423c:	c1 e0 02             	shl    $0x2,%eax
c010423f:	01 d0                	add    %edx,%eax
c0104241:	c1 e0 06             	shl    $0x6,%eax
c0104244:	89 c2                	mov    %eax,%edx
c0104246:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104249:	01 c2                	add    %eax,%edx
c010424b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c010424f:	88 82 c0 60 15 c0    	mov    %al,-0x3fea9f40(%edx)
}
c0104255:	c9                   	leave  
c0104256:	c3                   	ret    

c0104257 <forceClearVRAM>:
void forceClearVRAM(){
c0104257:	55                   	push   %ebp
c0104258:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c010425a:	5d                   	pop    %ebp
c010425b:	c3                   	ret    

c010425c <clearVRAM>:
void clearVRAM(){
c010425c:	55                   	push   %ebp
c010425d:	89 e5                	mov    %esp,%ebp
c010425f:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0104262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104269:	eb 4e                	jmp    c01042b9 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c010426b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010426e:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0104273:	0f b6 00             	movzbl (%eax),%eax
c0104276:	0f b6 c0             	movzbl %al,%eax
c0104279:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010427c:	81 c2 c0 54 17 c0    	add    $0xc01754c0,%edx
c0104282:	0f b6 12             	movzbl (%edx),%edx
c0104285:	0f b6 d2             	movzbl %dl,%edx
c0104288:	f7 d2                	not    %edx
c010428a:	21 d0                	and    %edx,%eax
c010428c:	85 c0                	test   %eax,%eax
c010428e:	74 25                	je     c01042b5 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0104290:	8b 0d ac 80 10 c0    	mov    0xc01080ac,%ecx
c0104296:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104299:	89 d0                	mov    %edx,%eax
c010429b:	c1 e0 02             	shl    $0x2,%eax
c010429e:	01 d0                	add    %edx,%eax
c01042a0:	c1 e0 06             	shl    $0x6,%eax
c01042a3:	01 c8                	add    %ecx,%eax
c01042a5:	6a 50                	push   $0x50
c01042a7:	68 c0 5a 16 c0       	push   $0xc0165ac0
c01042ac:	50                   	push   %eax
c01042ad:	e8 58 fe ff ff       	call   c010410a <memcpy>
c01042b2:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01042b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01042b9:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01042c0:	7e a9                	jle    c010426b <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c01042c2:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c01042c9:	83 c0 01             	add    $0x1,%eax
c01042cc:	a2 88 56 17 c0       	mov    %al,0xc0175688
	if(stamp==30){
c01042d1:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c01042d8:	3c 1e                	cmp    $0x1e,%al
c01042da:	75 07                	jne    c01042e3 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c01042dc:	c6 05 88 56 17 c0 00 	movb   $0x0,0xc0175688
		//printk("What matters\n");
	}
	if(stamp==0){
c01042e3:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c01042ea:	84 c0                	test   %al,%al
c01042ec:	75 14                	jne    c0104302 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c01042ee:	6a 32                	push   $0x32
c01042f0:	68 c0 5a 16 c0       	push   $0xc0165ac0
c01042f5:	68 c0 55 17 c0       	push   $0xc01755c0
c01042fa:	e8 0b fe ff ff       	call   c010410a <memcpy>
c01042ff:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0104302:	c9                   	leave  
c0104303:	c3                   	ret    

c0104304 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0104304:	55                   	push   %ebp
c0104305:	89 e5                	mov    %esp,%ebp
c0104307:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c010430a:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c010430f:	83 c0 01             	add    $0x1,%eax
c0104312:	a3 8c 56 17 c0       	mov    %eax,0xc017568c
	current->timeslice ++;
c0104317:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010431c:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0104322:	83 c2 01             	add    $0x1,%edx
c0104325:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c010432b:	a1 b4 60 15 c0       	mov    0xc01560b4,%eax
c0104330:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0104333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104337:	75 02                	jne    c010433b <do_timer+0x37>
c0104339:	eb 6b                	jmp    c01043a6 <do_timer+0xa2>
	 	sleep->timeslice --;
c010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433e:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0104344:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434a:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104353:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0104356:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104359:	8b 80 60 24 00 00    	mov    0x2460(%eax),%eax
c010435f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0104362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104365:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c010436b:	85 c0                	test   %eax,%eax
c010436d:	74 02                	je     c0104371 <do_timer+0x6d>
c010436f:	eb 33                	jmp    c01043a4 <do_timer+0xa0>
	 	cur->ts = READY;
c0104371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104374:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c010437b:	00 00 00 
		ll_delete(&sleep_list, cur);
c010437e:	83 ec 08             	sub    $0x8,%esp
c0104381:	ff 75 f0             	pushl  -0x10(%ebp)
c0104384:	68 b4 60 15 c0       	push   $0xc01560b4
c0104389:	e8 62 f5 ff ff       	call   c01038f0 <ll_delete>
c010438e:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0104391:	83 ec 08             	sub    $0x8,%esp
c0104394:	ff 75 f0             	pushl  -0x10(%ebp)
c0104397:	68 b0 60 15 c0       	push   $0xc01560b0
c010439c:	e8 f1 f4 ff ff       	call   c0103892 <ll_entail>
c01043a1:	83 c4 10             	add    $0x10,%esp
	}
c01043a4:	eb 8d                	jmp    c0104333 <do_timer+0x2f>
}
c01043a6:	c9                   	leave  
c01043a7:	c3                   	ret    

c01043a8 <tick>:
uint32_t tick(){
c01043a8:	55                   	push   %ebp
c01043a9:	89 e5                	mov    %esp,%ebp
	return _tick;
c01043ab:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c01043b0:	5d                   	pop    %ebp
c01043b1:	c3                   	ret    

c01043b2 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c01043b2:	6a 00                	push   $0x0
c01043b4:	6a 00                	push   $0x0
c01043b6:	e9 b8 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043bb <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c01043bb:	6a 00                	push   $0x0
c01043bd:	6a 01                	push   $0x1
c01043bf:	e9 af 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043c4 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c01043c4:	6a 00                	push   $0x0
c01043c6:	6a 02                	push   $0x2
c01043c8:	e9 a6 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043cd <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c01043cd:	6a 00                	push   $0x0
c01043cf:	6a 03                	push   $0x3
c01043d1:	e9 9d 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043d6 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c01043d6:	6a 00                	push   $0x0
c01043d8:	6a 04                	push   $0x4
c01043da:	e9 94 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043df <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c01043df:	6a 00                	push   $0x0
c01043e1:	6a 05                	push   $0x5
c01043e3:	e9 8b 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043e8 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c01043e8:	6a 00                	push   $0x0
c01043ea:	6a 06                	push   $0x6
c01043ec:	e9 82 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043f1 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c01043f1:	6a 00                	push   $0x0
c01043f3:	6a 07                	push   $0x7
c01043f5:	e9 79 00 00 00       	jmp    c0104473 <asm_do_irq>

c01043fa <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c01043fa:	6a 00                	push   $0x0
c01043fc:	6a 08                	push   $0x8
c01043fe:	e9 70 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104403 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0104403:	6a 00                	push   $0x0
c0104405:	6a 09                	push   $0x9
c0104407:	e9 67 00 00 00       	jmp    c0104473 <asm_do_irq>

c010440c <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c010440c:	6a 00                	push   $0x0
c010440e:	6a 0a                	push   $0xa
c0104410:	e9 5e 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104415 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0104415:	6a 00                	push   $0x0
c0104417:	6a 0b                	push   $0xb
c0104419:	e9 55 00 00 00       	jmp    c0104473 <asm_do_irq>

c010441e <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c010441e:	6a 00                	push   $0x0
c0104420:	6a 0c                	push   $0xc
c0104422:	e9 4c 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104427 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0104427:	6a 00                	push   $0x0
c0104429:	6a 0d                	push   $0xd
c010442b:	e9 43 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104430 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0104430:	6a 00                	push   $0x0
c0104432:	6a 0e                	push   $0xe
c0104434:	e9 3a 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104439 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0104439:	fa                   	cli    
c010443a:	6a 00                	push   $0x0
c010443c:	68 80 00 00 00       	push   $0x80
c0104441:	e9 2d 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104446 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0104446:	6a 00                	push   $0x0
c0104448:	68 e8 03 00 00       	push   $0x3e8
c010444d:	e9 21 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104452 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0104452:	6a 00                	push   $0x0
c0104454:	68 e9 03 00 00       	push   $0x3e9
c0104459:	e9 15 00 00 00       	jmp    c0104473 <asm_do_irq>

c010445e <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c010445e:	6a 00                	push   $0x0
c0104460:	68 f6 03 00 00       	push   $0x3f6
c0104465:	e9 09 00 00 00       	jmp    c0104473 <asm_do_irq>

c010446a <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c010446a:	6a 00                	push   $0x0
c010446c:	6a ff                	push   $0xffffffff
c010446e:	e9 00 00 00 00       	jmp    c0104473 <asm_do_irq>

c0104473 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0104473:	fa                   	cli    
  pushl %ds
c0104474:	1e                   	push   %ds
  pushl %es
c0104475:	06                   	push   %es
  pushl %fs
c0104476:	0f a0                	push   %fs
  pushl %gs
c0104478:	0f a8                	push   %gs
	pushal
c010447a:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c010447b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c010447f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0104481:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0104483:	54                   	push   %esp
  call irq_handle
c0104484:	e8 15 cd ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0104489:	83 c4 04             	add    $0x4,%esp

c010448c <switch_proc>:
switch_proc:
  popal
c010448c:	61                   	popa   
  popl %gs
c010448d:	0f a9                	pop    %gs
  popl %fs
c010448f:	0f a1                	pop    %fs
  popl %es
c0104491:	07                   	pop    %es
  popl %ds
c0104492:	1f                   	pop    %ds
  addl $8, %esp
c0104493:	83 c4 08             	add    $0x8,%esp
  sti
c0104496:	fb                   	sti    
  iret
c0104497:	cf                   	iret   
c0104498:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c010449e:	00 00                	add    %al,(%eax)
c01044a0:	fe 4f 52             	decb   0x52(%edi)
c01044a3:	e4 66                	in     $0x66,%al

c01044a4 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c01044a4:	66 c7 05 72 04 00 00 34 12 b8 00 70 10 00 0f 22     f..r...4...p..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c01044b4:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 c7 44 10     .. ......."...D.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c01044c4:	c0 ff e0                                            ...

c01044c7 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c01044c7:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c01044cc:	bc 00 10 11 c0       	mov    $0xc0111000,%esp

	# now to C code

	call	main
c01044d1:	e8 a2 e5 ff ff       	call   c0102a78 <main>

c01044d6 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c01044d6:	eb fe                	jmp    c01044d6 <spin>

c01044d8 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c01044d8:	55                   	push   %ebp
c01044d9:	89 e5                	mov    %esp,%ebp
c01044db:	53                   	push   %ebx
c01044dc:	83 ec 04             	sub    $0x4,%esp
c01044df:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e2:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c01044e5:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c01044ea:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c01044ee:	89 d3                	mov    %edx,%ebx
c01044f0:	cd 80                	int    $0x80
}
c01044f2:	83 c4 04             	add    $0x4,%esp
c01044f5:	5b                   	pop    %ebx
c01044f6:	5d                   	pop    %ebp
c01044f7:	c3                   	ret    

c01044f8 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c01044f8:	55                   	push   %ebp
c01044f9:	89 e5                	mov    %esp,%ebp
c01044fb:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c01044fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104501:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0104504:	eb 19                	jmp    c010451f <printp+0x27>
		printer(cur);
c0104506:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104509:	0f b6 00             	movzbl (%eax),%eax
c010450c:	0f be c0             	movsbl %al,%eax
c010450f:	83 ec 0c             	sub    $0xc,%esp
c0104512:	50                   	push   %eax
c0104513:	8b 45 08             	mov    0x8(%ebp),%eax
c0104516:	ff d0                	call   *%eax
c0104518:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c010451b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010451f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104522:	0f b6 00             	movzbl (%eax),%eax
c0104525:	84 c0                	test   %al,%al
c0104527:	75 dd                	jne    c0104506 <printp+0xe>
		printer(cur);
	}
}
c0104529:	c9                   	leave  
c010452a:	c3                   	ret    

c010452b <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c010452b:	55                   	push   %ebp
c010452c:	89 e5                	mov    %esp,%ebp
c010452e:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0104531:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0104537:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c010453e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0104545:	8b 45 10             	mov    0x10(%ebp),%eax
c0104548:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c010454b:	e9 65 02 00 00       	jmp    c01047b5 <vfprintf+0x28a>

		if(cur == '%'){
c0104550:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104553:	0f b6 00             	movzbl (%eax),%eax
c0104556:	3c 25                	cmp    $0x25,%al
c0104558:	75 0c                	jne    c0104566 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c010455a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0104561:	e9 4b 02 00 00       	jmp    c01047b1 <vfprintf+0x286>
		}
		if(type == READ){
c0104566:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c010456a:	0f 85 26 02 00 00    	jne    c0104796 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104573:	0f b6 00             	movzbl (%eax),%eax
c0104576:	3c 73                	cmp    $0x73,%al
c0104578:	75 35                	jne    c01045af <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c010457a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010457d:	8b 00                	mov    (%eax),%eax
c010457f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0104582:	eb 19                	jmp    c010459d <vfprintf+0x72>
					printer(*p);
c0104584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104587:	0f b6 00             	movzbl (%eax),%eax
c010458a:	0f be c0             	movsbl %al,%eax
c010458d:	83 ec 0c             	sub    $0xc,%esp
c0104590:	50                   	push   %eax
c0104591:	8b 45 08             	mov    0x8(%ebp),%eax
c0104594:	ff d0                	call   *%eax
c0104596:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0104599:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c010459d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045a0:	0f b6 00             	movzbl (%eax),%eax
c01045a3:	84 c0                	test   %al,%al
c01045a5:	75 dd                	jne    c0104584 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c01045a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01045ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c01045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b2:	0f b6 00             	movzbl (%eax),%eax
c01045b5:	3c 78                	cmp    $0x78,%al
c01045b7:	0f 85 99 00 00 00    	jne    c0104656 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c01045bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045c0:	8b 00                	mov    (%eax),%eax
c01045c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c01045c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01045c9:	75 1d                	jne    c01045e8 <vfprintf+0xbd>
					printer('0');
c01045cb:	83 ec 0c             	sub    $0xc,%esp
c01045ce:	6a 30                	push   $0x30
c01045d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d3:	ff d0                	call   *%eax
c01045d5:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01045d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01045dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01045e3:	e9 c9 01 00 00       	jmp    c01047b1 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c01045e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c01045ef:	eb 2d                	jmp    c010461e <vfprintf+0xf3>
					int d=(x%16);
c01045f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045f4:	83 e0 0f             	and    $0xf,%eax
c01045f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c01045fa:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c01045fe:	7e 04                	jle    c0104604 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0104600:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0104604:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104607:	83 c0 30             	add    $0x30,%eax
c010460a:	89 c1                	mov    %eax,%ecx
c010460c:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010460f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104612:	01 d0                	add    %edx,%eax
c0104614:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0104616:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c010461a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010461e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104622:	75 cd                	jne    c01045f1 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0104624:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0104628:	eb 1e                	jmp    c0104648 <vfprintf+0x11d>
					printer(digits[di]);
c010462a:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010462d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104630:	01 d0                	add    %edx,%eax
c0104632:	0f b6 00             	movzbl (%eax),%eax
c0104635:	0f be c0             	movsbl %al,%eax
c0104638:	83 ec 0c             	sub    $0xc,%esp
c010463b:	50                   	push   %eax
c010463c:	8b 45 08             	mov    0x8(%ebp),%eax
c010463f:	ff d0                	call   *%eax
c0104641:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0104644:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0104648:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010464c:	79 dc                	jns    c010462a <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010464e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104652:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0104656:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104659:	0f b6 00             	movzbl (%eax),%eax
c010465c:	3c 64                	cmp    $0x64,%al
c010465e:	0f 85 02 01 00 00    	jne    c0104766 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0104664:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104667:	8b 00                	mov    (%eax),%eax
c0104669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c010466c:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0104673:	75 23                	jne    c0104698 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0104675:	83 ec 08             	sub    $0x8,%esp
c0104678:	68 5e 4a 10 c0       	push   $0xc0104a5e
c010467d:	ff 75 08             	pushl  0x8(%ebp)
c0104680:	e8 73 fe ff ff       	call   c01044f8 <printp>
c0104685:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104688:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010468c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0104693:	e9 19 01 00 00       	jmp    c01047b1 <vfprintf+0x286>
				}
				if(x==0){
c0104698:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010469c:	75 1e                	jne    c01046bc <vfprintf+0x191>
					printer('0');
c010469e:	83 ec 0c             	sub    $0xc,%esp
c01046a1:	6a 30                	push   $0x30
c01046a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a6:	ff d0                	call   *%eax
c01046a8:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01046ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01046af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01046b6:	90                   	nop
c01046b7:	e9 f5 00 00 00       	jmp    c01047b1 <vfprintf+0x286>
				}
				if(x<0){
c01046bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01046c0:	79 10                	jns    c01046d2 <vfprintf+0x1a7>
					printer('-');
c01046c2:	83 ec 0c             	sub    $0xc,%esp
c01046c5:	6a 2d                	push   $0x2d
c01046c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ca:	ff d0                	call   *%eax
c01046cc:	83 c4 10             	add    $0x10,%esp
					x=-x;
c01046cf:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c01046d2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c01046d9:	eb 53                	jmp    c010472e <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c01046db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01046de:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01046e3:	89 c8                	mov    %ecx,%eax
c01046e5:	f7 ea                	imul   %edx
c01046e7:	c1 fa 02             	sar    $0x2,%edx
c01046ea:	89 c8                	mov    %ecx,%eax
c01046ec:	c1 f8 1f             	sar    $0x1f,%eax
c01046ef:	29 c2                	sub    %eax,%edx
c01046f1:	89 d0                	mov    %edx,%eax
c01046f3:	c1 e0 02             	shl    $0x2,%eax
c01046f6:	01 d0                	add    %edx,%eax
c01046f8:	01 c0                	add    %eax,%eax
c01046fa:	29 c1                	sub    %eax,%ecx
c01046fc:	89 ca                	mov    %ecx,%edx
c01046fe:	89 d0                	mov    %edx,%eax
c0104700:	83 c0 30             	add    $0x30,%eax
c0104703:	89 c1                	mov    %eax,%ecx
c0104705:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104708:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010470b:	01 d0                	add    %edx,%eax
c010470d:	88 08                	mov    %cl,(%eax)
					x/=10;
c010470f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104712:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104717:	89 c8                	mov    %ecx,%eax
c0104719:	f7 ea                	imul   %edx
c010471b:	c1 fa 02             	sar    $0x2,%edx
c010471e:	89 c8                	mov    %ecx,%eax
c0104720:	c1 f8 1f             	sar    $0x1f,%eax
c0104723:	29 c2                	sub    %eax,%edx
c0104725:	89 d0                	mov    %edx,%eax
c0104727:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010472a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010472e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104732:	7f a7                	jg     c01046db <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0104734:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0104738:	eb 1e                	jmp    c0104758 <vfprintf+0x22d>
					printer(digits[di]);
c010473a:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c010473d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104740:	01 d0                	add    %edx,%eax
c0104742:	0f b6 00             	movzbl (%eax),%eax
c0104745:	0f be c0             	movsbl %al,%eax
c0104748:	83 ec 0c             	sub    $0xc,%esp
c010474b:	50                   	push   %eax
c010474c:	8b 45 08             	mov    0x8(%ebp),%eax
c010474f:	ff d0                	call   *%eax
c0104751:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0104754:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104758:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010475c:	79 dc                	jns    c010473a <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010475e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104762:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104769:	0f b6 00             	movzbl (%eax),%eax
c010476c:	3c 63                	cmp    $0x63,%al
c010476e:	75 1d                	jne    c010478d <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0104770:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104773:	0f b6 00             	movzbl (%eax),%eax
c0104776:	0f be c0             	movsbl %al,%eax
c0104779:	83 ec 0c             	sub    $0xc,%esp
c010477c:	50                   	push   %eax
c010477d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104780:	ff d0                	call   *%eax
c0104782:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0104785:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104789:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c010478d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0104794:	eb 1b                	jmp    c01047b1 <vfprintf+0x286>
		}
		if(type == NONE){
c0104796:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010479a:	75 15                	jne    c01047b1 <vfprintf+0x286>
			printer(cur);
c010479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479f:	0f b6 00             	movzbl (%eax),%eax
c01047a2:	0f be c0             	movsbl %al,%eax
c01047a5:	83 ec 0c             	sub    $0xc,%esp
c01047a8:	50                   	push   %eax
c01047a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047ac:	ff d0                	call   *%eax
c01047ae:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01047b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b8:	0f b6 00             	movzbl (%eax),%eax
c01047bb:	84 c0                	test   %al,%al
c01047bd:	0f 85 8d fd ff ff    	jne    c0104550 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c01047c3:	c9                   	leave  
c01047c4:	c3                   	ret    

c01047c5 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c01047c5:	55                   	push   %ebp
c01047c6:	89 e5                	mov    %esp,%ebp
c01047c8:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01047cb:	8d 45 0c             	lea    0xc(%ebp),%eax
c01047ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c01047d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047d4:	83 ec 04             	sub    $0x4,%esp
c01047d7:	ff 75 f4             	pushl  -0xc(%ebp)
c01047da:	50                   	push   %eax
c01047db:	68 d8 44 10 c0       	push   $0xc01044d8
c01047e0:	e8 46 fd ff ff       	call   c010452b <vfprintf>
c01047e5:	83 c4 10             	add    $0x10,%esp
}
c01047e8:	c9                   	leave  
c01047e9:	c3                   	ret    
