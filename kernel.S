
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
c01000ba:	e8 4c 20 00 00       	call   c010210b <vfprintf>
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
c01000f0:	68 cc 23 10 c0       	push   $0xc01023cc
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
c0100131:	e8 6c 06 00 00       	call   c01007a2 <page_init>
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
c0100365:	8b 40 0c             	mov    0xc(%eax),%eax
c0100368:	83 ec 04             	sub    $0x4,%esp
c010036b:	50                   	push   %eax
c010036c:	6a 71                	push   $0x71
c010036e:	68 ef 23 10 c0       	push   $0xc01023ef
c0100373:	e8 65 fd ff ff       	call   c01000dd <_paddr>
c0100378:	83 c4 10             	add    $0x10,%esp
c010037b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c010037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100381:	0f 22 d8             	mov    %eax,%cr3
	//printk("2\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	05 10 40 00 00       	add    $0x4010,%eax
c010038c:	83 ec 0c             	sub    $0xc,%esp
c010038f:	50                   	push   %eax
c0100390:	e8 80 fe ff ff       	call   c0100215 <set_tss_esp0>
c0100395:	83 c4 10             	add    $0x10,%esp
	//printk("3\n");
	struct TrapFrame *tf = pcb->tf;
c0100398:	8b 45 08             	mov    0x8(%ebp),%eax
c010039b:	8b 40 08             	mov    0x8(%eax),%eax
c010039e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//disable_interrupt();
	//asm volatile("cli");
	asm volatile("mov %0, %%ds" : : "r"(tf->ds));
c01003a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a4:	8b 40 2c             	mov    0x2c(%eax),%eax
c01003a7:	8e d8                	mov    %eax,%ds
	//printk("0\n");
	asm volatile("mov %0, %%es" : : "r"(tf->es));
c01003a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ac:	8b 40 28             	mov    0x28(%eax),%eax
c01003af:	8e c0                	mov    %eax,%es
	//printk("0\n");
	asm volatile("mov %0, %%fs" : : "r"(tf->fs));
c01003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b4:	8b 40 24             	mov    0x24(%eax),%eax
c01003b7:	8e e0                	mov    %eax,%fs
	//printk("0\n");
	asm volatile("mov %0, %%gs" : : "r"(tf->gs));
c01003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003bc:	8b 40 20             	mov    0x20(%eax),%eax
c01003bf:	8e e8                	mov    %eax,%gs
	//printk("0\n");
	asm volatile("pushl %0" : : "r"((uint32_t)tf->ss));
c01003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003c4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01003c8:	0f b7 c0             	movzwl %ax,%eax
c01003cb:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->esp));
c01003cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003cf:	8b 40 44             	mov    0x44(%eax),%eax
c01003d2:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eflags));
c01003d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d6:	8b 40 40             	mov    0x40(%eax),%eax
c01003d9:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"((uint32_t)tf->cs));
c01003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003dd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01003e1:	0f b7 c0             	movzwl %ax,%eax
c01003e4:	50                   	push   %eax
	asm volatile("pushl %0" : : "r"(tf->eip));
c01003e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e8:	8b 40 38             	mov    0x38(%eax),%eax
c01003eb:	50                   	push   %eax
	asm volatile("iret"); 
c01003ec:	cf                   	iret   
}
c01003ed:	c9                   	leave  
c01003ee:	c3                   	ret    

c01003ef <scheduler_switch>:
void switch_proc();
extern PCB* current;
void scheduler_switch(PCB* pcb){
c01003ef:	55                   	push   %ebp
c01003f0:	89 e5                	mov    %esp,%ebp
c01003f2:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01003f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01003f8:	a3 40 46 1b c0       	mov    %eax,0xc01b4640
	lcr3(PADDR(pcb->pgdir));
c01003fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100400:	8b 40 0c             	mov    0xc(%eax),%eax
c0100403:	83 ec 04             	sub    $0x4,%esp
c0100406:	50                   	push   %eax
c0100407:	68 8b 00 00 00       	push   $0x8b
c010040c:	68 ef 23 10 c0       	push   $0xc01023ef
c0100411:	e8 c7 fc ff ff       	call   c01000dd <_paddr>
c0100416:	83 c4 10             	add    $0x10,%esp
c0100419:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041f:	0f 22 d8             	mov    %eax,%cr3
	set_tss_esp0((uint32_t)(pcb->kstacktop));
c0100422:	8b 45 08             	mov    0x8(%ebp),%eax
c0100425:	05 10 40 00 00       	add    $0x4010,%eax
c010042a:	83 ec 0c             	sub    $0xc,%esp
c010042d:	50                   	push   %eax
c010042e:	e8 e2 fd ff ff       	call   c0100215 <set_tss_esp0>
c0100433:	83 c4 10             	add    $0x10,%esp
	asm volatile("mov %0, %%esp" : : "r"(pcb->tf));
c0100436:	8b 45 08             	mov    0x8(%ebp),%eax
c0100439:	8b 40 08             	mov    0x8(%eax),%eax
c010043c:	89 c4                	mov    %eax,%esp
	asm volatile("jmp %0" : : "r"(switch_proc));
c010043e:	b8 6c 20 10 c0       	mov    $0xc010206c,%eax
c0100443:	ff e0                	jmp    *%eax

}
c0100445:	c9                   	leave  
c0100446:	c3                   	ret    

c0100447 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
c0100447:	55                   	push   %ebp
c0100448:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c010044a:	8b 45 08             	mov    0x8(%ebp),%eax
c010044d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0100453:	5d                   	pop    %ebp
c0100454:	c3                   	ret    

c0100455 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
c0100455:	55                   	push   %ebp
c0100456:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100458:	8b 45 08             	mov    0x8(%ebp),%eax
c010045b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0100461:	5d                   	pop    %ebp
c0100462:	c3                   	ret    

c0100463 <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
c0100463:	55                   	push   %ebp
c0100464:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c0100466:	8b 45 08             	mov    0x8(%ebp),%eax
c0100469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c010046f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100472:	c1 e8 0c             	shr    $0xc,%eax
c0100475:	25 ff ff 0f 00       	and    $0xfffff,%eax
c010047a:	89 c2                	mov    %eax,%edx
c010047c:	8b 45 08             	mov    0x8(%ebp),%eax
c010047f:	89 d1                	mov    %edx,%ecx
c0100481:	c1 e1 0c             	shl    $0xc,%ecx
c0100484:	8b 10                	mov    (%eax),%edx
c0100486:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c010048c:	09 ca                	or     %ecx,%edx
c010048e:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c0100490:	8b 45 08             	mov    0x8(%ebp),%eax
c0100493:	0f b6 10             	movzbl (%eax),%edx
c0100496:	83 ca 01             	or     $0x1,%edx
c0100499:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c010049b:	8b 45 08             	mov    0x8(%ebp),%eax
c010049e:	0f b6 10             	movzbl (%eax),%edx
c01004a1:	83 ca 02             	or     $0x2,%edx
c01004a4:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c01004a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a9:	0f b6 10             	movzbl (%eax),%edx
c01004ac:	83 ca 04             	or     $0x4,%edx
c01004af:	88 10                	mov    %dl,(%eax)
}
c01004b1:	5d                   	pop    %ebp
c01004b2:	c3                   	ret    

c01004b3 <make_pte>:

void
make_pte(PTE *p, void *addr) {
c01004b3:	55                   	push   %ebp
c01004b4:	89 e5                	mov    %esp,%ebp
	p->val = 0;
c01004b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	c1 e8 0c             	shr    $0xc,%eax
c01004c5:	25 ff ff 0f 00       	and    $0xfffff,%eax
c01004ca:	89 c2                	mov    %eax,%edx
c01004cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cf:	89 d1                	mov    %edx,%ecx
c01004d1:	c1 e1 0c             	shl    $0xc,%ecx
c01004d4:	8b 10                	mov    (%eax),%edx
c01004d6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
c01004dc:	09 ca                	or     %ecx,%edx
c01004de:	89 10                	mov    %edx,(%eax)
	p->present = 1;
c01004e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e3:	0f b6 10             	movzbl (%eax),%edx
c01004e6:	83 ca 01             	or     $0x1,%edx
c01004e9:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
c01004eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ee:	0f b6 10             	movzbl (%eax),%edx
c01004f1:	83 ca 02             	or     $0x2,%edx
c01004f4:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
c01004f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004f9:	0f b6 10             	movzbl (%eax),%edx
c01004fc:	83 ca 04             	or     $0x4,%edx
c01004ff:	88 10                	mov    %dl,(%eax)
}
c0100501:	5d                   	pop    %ebp
c0100502:	c3                   	ret    

c0100503 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0100503:	55                   	push   %ebp
c0100504:	89 e5                	mov    %esp,%ebp
c0100506:	83 ec 10             	sub    $0x10,%esp
c0100509:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100510:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100513:	89 c2                	mov    %eax,%edx
c0100515:	ec                   	in     (%dx),%al
c0100516:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0100519:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010051d:	0f b6 c0             	movzbl %al,%eax
c0100520:	83 e0 20             	and    $0x20,%eax
c0100523:	85 c0                	test   %eax,%eax
c0100525:	0f 95 c0             	setne  %al
c0100528:	0f b6 c0             	movzbl %al,%eax
}
c010052b:	c9                   	leave  
c010052c:	c3                   	ret    

c010052d <serial_printc>:

static inline
void serial_printc(char ch) {
c010052d:	55                   	push   %ebp
c010052e:	89 e5                	mov    %esp,%ebp
c0100530:	83 ec 14             	sub    $0x14,%esp
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0100539:	90                   	nop
c010053a:	e8 c4 ff ff ff       	call   c0100503 <serial_idle>
c010053f:	85 c0                	test   %eax,%eax
c0100541:	74 f7                	je     c010053a <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0100543:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100547:	0f b6 c0             	movzbl %al,%eax
c010054a:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0100551:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100554:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0100558:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010055b:	ee                   	out    %al,(%dx)
}
c010055c:	c9                   	leave  
c010055d:	c3                   	ret    

c010055e <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010055e:	55                   	push   %ebp
c010055f:	89 e5                	mov    %esp,%ebp
c0100561:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0100564:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100567:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010056a:	8b 45 08             	mov    0x8(%ebp),%eax
c010056d:	83 ec 04             	sub    $0x4,%esp
c0100570:	ff 75 f4             	pushl  -0xc(%ebp)
c0100573:	50                   	push   %eax
c0100574:	68 2d 05 10 c0       	push   $0xc010052d
c0100579:	e8 8d 1b 00 00       	call   c010210b <vfprintf>
c010057e:	83 c4 10             	add    $0x10,%esp
}
c0100581:	c9                   	leave  
c0100582:	c3                   	ret    

c0100583 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c0100583:	55                   	push   %ebp
c0100584:	89 e5                	mov    %esp,%ebp
c0100586:	57                   	push   %edi
c0100587:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c0100588:	8b 55 10             	mov    0x10(%ebp),%edx
c010058b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058e:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0100591:	89 d1                	mov    %edx,%ecx
c0100593:	89 df                	mov    %ebx,%edi
c0100595:	fc                   	cld    
c0100596:	f3 ab                	rep stos %eax,%es:(%edi)
}
c0100598:	5b                   	pop    %ebx
c0100599:	5f                   	pop    %edi
c010059a:	5d                   	pop    %ebp
c010059b:	c3                   	ret    

c010059c <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c010059c:	55                   	push   %ebp
c010059d:	89 e5                	mov    %esp,%ebp
c010059f:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01005a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a5:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01005aa:	77 16                	ja     c01005c2 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01005ac:	ff 75 10             	pushl  0x10(%ebp)
c01005af:	68 08 24 10 c0       	push   $0xc0102408
c01005b4:	ff 75 0c             	pushl  0xc(%ebp)
c01005b7:	ff 75 08             	pushl  0x8(%ebp)
c01005ba:	e8 9f ff ff ff       	call   c010055e <printk>
c01005bf:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01005c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c5:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01005ca:	c9                   	leave  
c01005cb:	c3                   	ret    

c01005cc <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c01005cc:	55                   	push   %ebp
c01005cd:	89 e5                	mov    %esp,%ebp
c01005cf:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01005d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d5:	c1 e8 0c             	shr    $0xc,%eax
c01005d8:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01005dd:	76 13                	jbe    c01005f2 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c01005df:	83 ec 08             	sub    $0x8,%esp
c01005e2:	ff 75 10             	pushl  0x10(%ebp)
c01005e5:	68 2c 24 10 c0       	push   $0xc010242c
c01005ea:	e8 6f ff ff ff       	call   c010055e <printk>
c01005ef:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c01005f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005f5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01005fa:	c9                   	leave  
c01005fb:	c3                   	ret    

c01005fc <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c01005fc:	55                   	push   %ebp
c01005fd:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c01005ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100602:	ba 00 37 17 c0       	mov    $0xc0173700,%edx
c0100607:	29 d0                	sub    %edx,%eax
c0100609:	c1 f8 03             	sar    $0x3,%eax
c010060c:	c1 e0 0c             	shl    $0xc,%eax
}
c010060f:	5d                   	pop    %ebp
c0100610:	c3                   	ret    

c0100611 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0100611:	55                   	push   %ebp
c0100612:	89 e5                	mov    %esp,%ebp
c0100614:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0100617:	8b 45 08             	mov    0x8(%ebp),%eax
c010061a:	c1 e8 0c             	shr    $0xc,%eax
c010061d:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0100622:	76 10                	jbe    c0100634 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0100624:	83 ec 0c             	sub    $0xc,%esp
c0100627:	68 50 24 10 c0       	push   $0xc0102450
c010062c:	e8 2d ff ff ff       	call   c010055e <printk>
c0100631:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0100634:	8b 45 08             	mov    0x8(%ebp),%eax
c0100637:	c1 e8 0c             	shr    $0xc,%eax
c010063a:	c1 e0 03             	shl    $0x3,%eax
c010063d:	05 00 37 17 c0       	add    $0xc0173700,%eax
}
c0100642:	c9                   	leave  
c0100643:	c3                   	ret    

c0100644 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0100644:	55                   	push   %ebp
c0100645:	89 e5                	mov    %esp,%ebp
c0100647:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c010064a:	ff 75 08             	pushl  0x8(%ebp)
c010064d:	e8 aa ff ff ff       	call   c01005fc <page2pa>
c0100652:	83 c4 04             	add    $0x4,%esp
c0100655:	83 ec 04             	sub    $0x4,%esp
c0100658:	50                   	push   %eax
c0100659:	6a 52                	push   $0x52
c010065b:	68 6f 24 10 c0       	push   $0xc010246f
c0100660:	e8 67 ff ff ff       	call   c01005cc <_kaddr>
c0100665:	83 c4 10             	add    $0x10,%esp
}
c0100668:	c9                   	leave  
c0100669:	c3                   	ret    

c010066a <mm_alloc>:
// The 'pages' array has one 'struct PageInfo' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------

void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
c010066a:	55                   	push   %ebp
c010066b:	89 e5                	mov    %esp,%ebp
c010066d:	83 ec 28             	sub    $0x28,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
c0100670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100673:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100676:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100679:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010067e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
c0100681:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0100688:	8b 55 0c             	mov    0xc(%ebp),%edx
c010068b:	8b 45 10             	mov    0x10(%ebp),%eax
c010068e:	01 c2                	add    %eax,%edx
c0100690:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100693:	01 d0                	add    %edx,%eax
c0100695:	83 e8 01             	sub    $0x1,%eax
c0100698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010069b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010069e:	ba 00 00 00 00       	mov    $0x0,%edx
c01006a3:	f7 75 e8             	divl   -0x18(%ebp)
c01006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006a9:	29 d0                	sub    %edx,%eax
c01006ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01006ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01006b4:	eb 2b                	jmp    c01006e1 <mm_alloc+0x77>
    p = page_alloc(0);
c01006b6:	83 ec 0c             	sub    $0xc,%esp
c01006b9:	6a 00                	push   $0x0
c01006bb:	e8 9c 01 00 00       	call   c010085c <page_alloc>
c01006c0:	83 c4 10             	add    $0x10,%esp
c01006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
c01006c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006c9:	6a 07                	push   $0x7
c01006cb:	50                   	push   %eax
c01006cc:	ff 75 dc             	pushl  -0x24(%ebp)
c01006cf:	ff 75 08             	pushl  0x8(%ebp)
c01006d2:	e8 84 03 00 00       	call   c0100a5b <page_insert>
c01006d7:	83 c4 10             	add    $0x10,%esp
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
c01006da:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01006e7:	72 cd                	jb     c01006b6 <mm_alloc+0x4c>
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}
c01006e9:	c9                   	leave  
c01006ea:	c3                   	ret    

c01006eb <init_kern_pgdir>:

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
c01006eb:	55                   	push   %ebp
c01006ec:	89 e5                	mov    %esp,%ebp
c01006ee:	53                   	push   %ebx
c01006ef:	83 ec 24             	sub    $0x24,%esp
	int pdx;
	pde_t *pgdir = kpgdir;
c01006f2:	c7 45 e8 00 30 13 c0 	movl   $0xc0133000,-0x18(%ebp)
	pte_t *pgtable = kpgtable;
c01006f9:	c7 45 f0 00 40 13 c0 	movl   $0xc0134000,-0x10(%ebp)

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c0100700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100707:	eb 3a                	jmp    c0100743 <init_kern_pgdir+0x58>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
c0100709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070c:	05 00 03 00 00       	add    $0x300,%eax
c0100711:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100718:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010071b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c010071e:	83 ec 04             	sub    $0x4,%esp
c0100721:	ff 75 f0             	pushl  -0x10(%ebp)
c0100724:	6a 36                	push   $0x36
c0100726:	68 85 24 10 c0       	push   $0xc0102485
c010072b:	e8 6c fe ff ff       	call   c010059c <_paddr>
c0100730:	83 c4 10             	add    $0x10,%esp
c0100733:	83 c8 03             	or     $0x3,%eax
c0100736:	89 03                	mov    %eax,(%ebx)
		pgtable += NPTENTRIES;
c0100738:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
c010073f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100743:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0100747:	7e c0                	jle    c0100709 <init_kern_pgdir+0x1e>
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
c0100749:	c7 45 ec 00 f0 ff 07 	movl   $0x7fff000,-0x14(%ebp)
	pgtable--;
c0100750:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100754:	eb 18                	jmp    c010076e <init_kern_pgdir+0x83>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
c0100756:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100759:	83 c8 07             	or     $0x7,%eax
c010075c:	89 c2                	mov    %eax,%edx
c010075e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100761:	89 10                	mov    %edx,(%eax)
		pgtable --;
c0100763:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
c0100767:	81 6d ec 00 10 00 00 	subl   $0x1000,-0x14(%ebp)
c010076e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100772:	79 e2                	jns    c0100756 <init_kern_pgdir+0x6b>
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
c0100774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100777:	a3 c0 36 17 c0       	mov    %eax,0xc01736c0
	lcr3(PADDR(kern_pgdir));	
c010077c:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0100781:	83 ec 04             	sub    $0x4,%esp
c0100784:	50                   	push   %eax
c0100785:	6a 43                	push   $0x43
c0100787:	68 85 24 10 c0       	push   $0xc0102485
c010078c:	e8 0b fe ff ff       	call   c010059c <_paddr>
c0100791:	83 c4 10             	add    $0x10,%esp
c0100794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0100797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079a:	0f 22 d8             	mov    %eax,%cr3
}
c010079d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01007a0:	c9                   	leave  
c01007a1:	c3                   	ret    

c01007a2 <page_init>:
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
c01007a2:	55                   	push   %ebp
c01007a3:	89 e5                	mov    %esp,%ebp
c01007a5:	83 ec 18             	sub    $0x18,%esp
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	
c01007a8:	e8 3e ff ff ff       	call   c01006eb <init_kern_pgdir>

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
c01007ad:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	for (i = 0; i < base; i++) {
c01007b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01007bb:	eb 11                	jmp    c01007ce <page_init+0x2c>
		pages[i].pp_ref = 1;
c01007bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c0:	66 c7 04 c5 04 37 17 	movw   $0x1,-0x3fe8c8fc(,%eax,8)
c01007c7:	c0 01 00 
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
c01007ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01007d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01007d4:	77 e7                	ja     c01007bd <page_init+0x1b>
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c01007d6:	c7 45 f4 ff 7f 00 00 	movl   $0x7fff,-0xc(%ebp)
c01007dd:	eb 31                	jmp    c0100810 <page_init+0x6e>
		pages[i].pp_ref = 0;
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	66 c7 04 c5 04 37 17 	movw   $0x0,-0x3fe8c8fc(,%eax,8)
c01007e9:	c0 00 00 
		pages[i].pp_link = page_free_list;
c01007ec:	8b 15 00 20 13 c0    	mov    0xc0132000,%edx
c01007f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f5:	89 14 c5 00 37 17 c0 	mov    %edx,-0x3fe8c900(,%eax,8)
		page_free_list = &pages[i];
c01007fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ff:	c1 e0 03             	shl    $0x3,%eax
c0100802:	05 00 37 17 c0       	add    $0xc0173700,%eax
c0100807:	a3 00 20 13 c0       	mov    %eax,0xc0132000
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
c010080c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100810:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100816:	76 c7                	jbe    c01007df <page_init+0x3d>
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
c0100818:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
c010081f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100822:	05 ff f9 00 00       	add    $0xf9ff,%eax
c0100827:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010082a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010082d:	ba 00 00 00 00       	mov    $0x0,%edx
c0100832:	f7 75 ec             	divl   -0x14(%ebp)
c0100835:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100838:	29 d0                	sub    %edx,%eax
c010083a:	89 c2                	mov    %eax,%edx
c010083c:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0100841:	83 ec 0c             	sub    $0xc,%esp
c0100844:	6a 03                	push   $0x3
c0100846:	68 00 00 0a 00       	push   $0xa0000
c010084b:	52                   	push   %edx
c010084c:	68 00 00 0a 00       	push   $0xa0000
c0100851:	50                   	push   %eax
c0100852:	e8 a1 01 00 00       	call   c01009f8 <boot_map_region>
c0100857:	83 c4 20             	add    $0x20,%esp
}
c010085a:	c9                   	leave  
c010085b:	c3                   	ret    

c010085c <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
c010085c:	55                   	push   %ebp
c010085d:	89 e5                	mov    %esp,%ebp
c010085f:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	struct PageInfo *p = page_free_list;
c0100862:	a1 00 20 13 c0       	mov    0xc0132000,%eax
c0100867:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (p == NULL) return NULL;
c010086a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010086e:	75 07                	jne    c0100877 <page_alloc+0x1b>
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
c0100875:	eb 43                	jmp    c01008ba <page_alloc+0x5e>
	if (alloc_flags & ALLOC_ZERO) {
c0100877:	8b 45 08             	mov    0x8(%ebp),%eax
c010087a:	83 e0 01             	and    $0x1,%eax
c010087d:	85 c0                	test   %eax,%eax
c010087f:	74 21                	je     c01008a2 <page_alloc+0x46>
		memset(page2kva(p), 0, PGSIZE);
c0100881:	83 ec 0c             	sub    $0xc,%esp
c0100884:	ff 75 f4             	pushl  -0xc(%ebp)
c0100887:	e8 b8 fd ff ff       	call   c0100644 <page2kva>
c010088c:	83 c4 10             	add    $0x10,%esp
c010088f:	83 ec 04             	sub    $0x4,%esp
c0100892:	68 00 10 00 00       	push   $0x1000
c0100897:	6a 00                	push   $0x0
c0100899:	50                   	push   %eax
c010089a:	e8 e4 fc ff ff       	call   c0100583 <memset>
c010089f:	83 c4 10             	add    $0x10,%esp
	}
	page_free_list = page_free_list -> pp_link;
c01008a2:	a1 00 20 13 c0       	mov    0xc0132000,%eax
c01008a7:	8b 00                	mov    (%eax),%eax
c01008a9:	a3 00 20 13 c0       	mov    %eax,0xc0132000
	p -> pp_link = NULL;
c01008ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return p;
c01008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01008ba:	c9                   	leave  
c01008bb:	c3                   	ret    

c01008bc <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
c01008bc:	55                   	push   %ebp
c01008bd:	89 e5                	mov    %esp,%ebp
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
	//assert(pp->pp_ref == 0 && pp->pp_link == NULL);
	pp->pp_link = page_free_list;
c01008bf:	8b 15 00 20 13 c0    	mov    0xc0132000,%edx
c01008c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01008c8:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
c01008ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01008cd:	a3 00 20 13 c0       	mov    %eax,0xc0132000
}
c01008d2:	5d                   	pop    %ebp
c01008d3:	c3                   	ret    

c01008d4 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
c01008d4:	55                   	push   %ebp
c01008d5:	89 e5                	mov    %esp,%ebp
	if (--pp->pp_ref == 0)
c01008d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01008da:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01008de:	8d 50 ff             	lea    -0x1(%eax),%edx
c01008e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01008e4:	66 89 50 04          	mov    %dx,0x4(%eax)
c01008e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01008eb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c01008ef:	66 85 c0             	test   %ax,%ax
c01008f2:	75 0b                	jne    c01008ff <page_decref+0x2b>
		page_free(pp);
c01008f4:	ff 75 08             	pushl  0x8(%ebp)
c01008f7:	e8 c0 ff ff ff       	call   c01008bc <page_free>
c01008fc:	83 c4 04             	add    $0x4,%esp
}
c01008ff:	c9                   	leave  
c0100900:	c3                   	ret    

c0100901 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
c0100901:	55                   	push   %ebp
c0100902:	89 e5                	mov    %esp,%ebp
c0100904:	53                   	push   %ebx
c0100905:	83 ec 14             	sub    $0x14,%esp
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);
c0100908:	8b 45 0c             	mov    0xc(%ebp),%eax
c010090b:	c1 e8 16             	shr    $0x16,%eax
c010090e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (pgdir[pdx] & PTE_P) {
c0100911:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100914:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010091b:	8b 45 08             	mov    0x8(%ebp),%eax
c010091e:	01 d0                	add    %edx,%eax
c0100920:	8b 00                	mov    (%eax),%eax
c0100922:	83 e0 01             	and    $0x1,%eax
c0100925:	85 c0                	test   %eax,%eax
c0100927:	74 31                	je     c010095a <pgdir_walk+0x59>
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100929:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010092c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100933:	8b 45 08             	mov    0x8(%ebp),%eax
c0100936:	01 d0                	add    %edx,%eax
c0100938:	8b 00                	mov    (%eax),%eax
c010093a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010093f:	83 ec 04             	sub    $0x4,%esp
c0100942:	50                   	push   %eax
c0100943:	68 bc 00 00 00       	push   $0xbc
c0100948:	68 85 24 10 c0       	push   $0xc0102485
c010094d:	e8 7a fc ff ff       	call   c01005cc <_kaddr>
c0100952:	83 c4 10             	add    $0x10,%esp
c0100955:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100958:	eb 7c                	jmp    c01009d6 <pgdir_walk+0xd5>
	}
	else {
		if (create == false) return NULL;
c010095a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010095e:	75 0a                	jne    c010096a <pgdir_walk+0x69>
c0100960:	b8 00 00 00 00       	mov    $0x0,%eax
c0100965:	e9 89 00 00 00       	jmp    c01009f3 <pgdir_walk+0xf2>

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
c010096a:	83 ec 0c             	sub    $0xc,%esp
c010096d:	6a 01                	push   $0x1
c010096f:	e8 e8 fe ff ff       	call   c010085c <page_alloc>
c0100974:	83 c4 10             	add    $0x10,%esp
c0100977:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (p == NULL) return NULL;
c010097a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010097e:	75 07                	jne    c0100987 <pgdir_walk+0x86>
c0100980:	b8 00 00 00 00       	mov    $0x0,%eax
c0100985:	eb 6c                	jmp    c01009f3 <pgdir_walk+0xf2>

		pgtable = page2kva(p);
c0100987:	83 ec 0c             	sub    $0xc,%esp
c010098a:	ff 75 ec             	pushl  -0x14(%ebp)
c010098d:	e8 b2 fc ff ff       	call   c0100644 <page2kva>
c0100992:	83 c4 10             	add    $0x10,%esp
c0100995:	89 45 f4             	mov    %eax,-0xc(%ebp)
		p -> pp_ref ++;
c0100998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010099b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c010099f:	8d 50 01             	lea    0x1(%eax),%edx
c01009a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01009a5:	66 89 50 04          	mov    %dx,0x4(%eax)

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
c01009a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01009b6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
c01009b9:	83 ec 04             	sub    $0x4,%esp
c01009bc:	ff 75 f4             	pushl  -0xc(%ebp)
c01009bf:	68 c7 00 00 00       	push   $0xc7
c01009c4:	68 85 24 10 c0       	push   $0xc0102485
c01009c9:	e8 ce fb ff ff       	call   c010059c <_paddr>
c01009ce:	83 c4 10             	add    $0x10,%esp
c01009d1:	83 c8 07             	or     $0x7,%eax
c01009d4:	89 03                	mov    %eax,(%ebx)
	}
	int ptx = PTX(va);
c01009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01009d9:	c1 e8 0c             	shr    $0xc,%eax
c01009dc:	25 ff 03 00 00       	and    $0x3ff,%eax
c01009e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	return &pgtable[ptx];
c01009e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f1:	01 d0                	add    %edx,%eax
}
c01009f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01009f6:	c9                   	leave  
c01009f7:	c3                   	ret    

c01009f8 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
c01009f8:	55                   	push   %ebp
c01009f9:	89 e5                	mov    %esp,%ebp
c01009fb:	83 ec 18             	sub    $0x18,%esp
	// Fill this function in
	int i;
	int n = size / PGSIZE;
c01009fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100a01:	c1 e8 0c             	shr    $0xc,%eax
c0100a04:	89 45 f0             	mov    %eax,-0x10(%ebp)

	for (i = 0; i < n; i ++) {
c0100a07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a0e:	eb 41                	jmp    c0100a51 <boot_map_region+0x59>
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
c0100a10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a13:	83 ec 04             	sub    $0x4,%esp
c0100a16:	6a 01                	push   $0x1
c0100a18:	50                   	push   %eax
c0100a19:	ff 75 08             	pushl  0x8(%ebp)
c0100a1c:	e8 e0 fe ff ff       	call   c0100901 <pgdir_walk>
c0100a21:	83 c4 10             	add    $0x10,%esp
c0100a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (pte == NULL) return;
c0100a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0100a2b:	75 02                	jne    c0100a2f <boot_map_region+0x37>
c0100a2d:	eb 2a                	jmp    c0100a59 <boot_map_region+0x61>

		*pte = pa | perm | PTE_P;
c0100a2f:	8b 45 18             	mov    0x18(%ebp),%eax
c0100a32:	0b 45 14             	or     0x14(%ebp),%eax
c0100a35:	83 c8 01             	or     $0x1,%eax
c0100a38:	89 c2                	mov    %eax,%edx
c0100a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a3d:	89 10                	mov    %edx,(%eax)

		va += PGSIZE;
c0100a3f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
		pa += PGSIZE;
c0100a46:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
c0100a4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100a57:	7c b7                	jl     c0100a10 <boot_map_region+0x18>
		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}
c0100a59:	c9                   	leave  
c0100a5a:	c3                   	ret    

c0100a5b <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
c0100a5b:	55                   	push   %ebp
c0100a5c:	89 e5                	mov    %esp,%ebp
c0100a5e:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, true);
c0100a61:	83 ec 04             	sub    $0x4,%esp
c0100a64:	6a 01                	push   $0x1
c0100a66:	ff 75 10             	pushl  0x10(%ebp)
c0100a69:	ff 75 08             	pushl  0x8(%ebp)
c0100a6c:	e8 90 fe ff ff       	call   c0100901 <pgdir_walk>
c0100a71:	83 c4 10             	add    $0x10,%esp
c0100a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) {
c0100a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a7b:	75 07                	jne    c0100a84 <page_insert+0x29>
		return -1;
c0100a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100a82:	eb 75                	jmp    c0100af9 <page_insert+0x9e>
//		return -E_NO_MEM;
	}

	physaddr_t pa = page2pa(pp);
c0100a84:	83 ec 0c             	sub    $0xc,%esp
c0100a87:	ff 75 0c             	pushl  0xc(%ebp)
c0100a8a:	e8 6d fb ff ff       	call   c01005fc <page2pa>
c0100a8f:	83 c4 10             	add    $0x10,%esp
c0100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (*pte & PTE_P) {
c0100a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a98:	8b 00                	mov    (%eax),%eax
c0100a9a:	83 e0 01             	and    $0x1,%eax
c0100a9d:	85 c0                	test   %eax,%eax
c0100a9f:	74 32                	je     c0100ad3 <page_insert+0x78>
		if (PTE_ADDR(*pte) == pa) {
c0100aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aa4:	8b 00                	mov    (%eax),%eax
c0100aa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100aab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0100aae:	75 12                	jne    c0100ac2 <page_insert+0x67>
			*pte = pa | perm | PTE_P;
c0100ab0:	8b 45 14             	mov    0x14(%ebp),%eax
c0100ab3:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100ab6:	83 c8 01             	or     $0x1,%eax
c0100ab9:	89 c2                	mov    %eax,%edx
c0100abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100abe:	89 10                	mov    %edx,(%eax)
c0100ac0:	eb 11                	jmp    c0100ad3 <page_insert+0x78>
		}
		else {
			page_remove(pgdir, va);
c0100ac2:	83 ec 08             	sub    $0x8,%esp
c0100ac5:	ff 75 10             	pushl  0x10(%ebp)
c0100ac8:	ff 75 08             	pushl  0x8(%ebp)
c0100acb:	e8 7a 00 00 00       	call   c0100b4a <page_remove>
c0100ad0:	83 c4 10             	add    $0x10,%esp
		}
	}
	*pte = pa | perm | PTE_P;
c0100ad3:	8b 45 14             	mov    0x14(%ebp),%eax
c0100ad6:	0b 45 f0             	or     -0x10(%ebp),%eax
c0100ad9:	83 c8 01             	or     $0x1,%eax
c0100adc:	89 c2                	mov    %eax,%edx
c0100ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae1:	89 10                	mov    %edx,(%eax)
	pp -> pp_ref ++;
c0100ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ae6:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0100aea:	8d 50 01             	lea    0x1(%eax),%edx
c0100aed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af0:	66 89 50 04          	mov    %dx,0x4(%eax)
	return 0;
c0100af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100af9:	c9                   	leave  
c0100afa:	c3                   	ret    

c0100afb <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
c0100afb:	55                   	push   %ebp
c0100afc:	89 e5                	mov    %esp,%ebp
c0100afe:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte = pgdir_walk(pgdir, va, false);
c0100b01:	83 ec 04             	sub    $0x4,%esp
c0100b04:	6a 00                	push   $0x0
c0100b06:	ff 75 0c             	pushl  0xc(%ebp)
c0100b09:	ff 75 08             	pushl  0x8(%ebp)
c0100b0c:	e8 f0 fd ff ff       	call   c0100901 <pgdir_walk>
c0100b11:	83 c4 10             	add    $0x10,%esp
c0100b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (pte == NULL) return NULL;
c0100b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b1b:	75 07                	jne    c0100b24 <page_lookup+0x29>
c0100b1d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b22:	eb 24                	jmp    c0100b48 <page_lookup+0x4d>
	if (pte_store != NULL) *pte_store = pte;
c0100b24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0100b28:	74 08                	je     c0100b32 <page_lookup+0x37>
c0100b2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0100b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b30:	89 10                	mov    %edx,(%eax)
	return pa2page(PTE_ADDR(*pte));
c0100b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b35:	8b 00                	mov    (%eax),%eax
c0100b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100b3c:	83 ec 0c             	sub    $0xc,%esp
c0100b3f:	50                   	push   %eax
c0100b40:	e8 cc fa ff ff       	call   c0100611 <pa2page>
c0100b45:	83 c4 10             	add    $0x10,%esp
}
c0100b48:	c9                   	leave  
c0100b49:	c3                   	ret    

c0100b4a <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
c0100b4a:	55                   	push   %ebp
c0100b4b:	89 e5                	mov    %esp,%ebp
c0100b4d:	83 ec 18             	sub    $0x18,%esp
	pte_t *pte;
	pte_t **pte_store = &pte;
c0100b50:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0100b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);
c0100b56:	83 ec 04             	sub    $0x4,%esp
c0100b59:	ff 75 f4             	pushl  -0xc(%ebp)
c0100b5c:	ff 75 0c             	pushl  0xc(%ebp)
c0100b5f:	ff 75 08             	pushl  0x8(%ebp)
c0100b62:	e8 94 ff ff ff       	call   c0100afb <page_lookup>
c0100b67:	83 c4 10             	add    $0x10,%esp
c0100b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if (p != NULL) {
c0100b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b71:	74 2a                	je     c0100b9d <page_remove+0x53>
		**pte_store = 0;
c0100b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b76:	8b 00                	mov    (%eax),%eax
c0100b78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		page_decref(p);
c0100b7e:	83 ec 0c             	sub    $0xc,%esp
c0100b81:	ff 75 f0             	pushl  -0x10(%ebp)
c0100b84:	e8 4b fd ff ff       	call   c01008d4 <page_decref>
c0100b89:	83 c4 10             	add    $0x10,%esp
		tlb_invalidate(pgdir, va);
c0100b8c:	83 ec 08             	sub    $0x8,%esp
c0100b8f:	ff 75 0c             	pushl  0xc(%ebp)
c0100b92:	ff 75 08             	pushl  0x8(%ebp)
c0100b95:	e8 05 00 00 00       	call   c0100b9f <tlb_invalidate>
c0100b9a:	83 c4 10             	add    $0x10,%esp
	}
}
c0100b9d:	c9                   	leave  
c0100b9e:	c3                   	ret    

c0100b9f <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
c0100b9f:	55                   	push   %ebp
c0100ba0:	89 e5                	mov    %esp,%ebp
c0100ba2:	83 ec 10             	sub    $0x10,%esp
c0100ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ba8:	89 45 fc             	mov    %eax,-0x4(%ebp)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
c0100bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100bae:	0f 01 38             	invlpg (%eax)
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
c0100bb1:	c9                   	leave  
c0100bb2:	c3                   	ret    

c0100bb3 <free_pgdir>:

void free_pgdir(pde_t *pgdir)
{
c0100bb3:	55                   	push   %ebp
c0100bb4:	89 e5                	mov    %esp,%ebp
c0100bb6:	83 ec 18             	sub    $0x18,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100bb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bc0:	e9 09 01 00 00       	jmp    c0100cce <free_pgdir+0x11b>
		if (pgdir[pdx] & PTE_P) {
c0100bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd2:	01 d0                	add    %edx,%eax
c0100bd4:	8b 00                	mov    (%eax),%eax
c0100bd6:	83 e0 01             	and    $0x1,%eax
c0100bd9:	85 c0                	test   %eax,%eax
c0100bdb:	0f 84 e9 00 00 00    	je     c0100cca <free_pgdir+0x117>
			if (kern_pgdir[pdx] & PTE_P) continue;
c0100be1:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0100be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100be9:	c1 e2 02             	shl    $0x2,%edx
c0100bec:	01 d0                	add    %edx,%eax
c0100bee:	8b 00                	mov    (%eax),%eax
c0100bf0:	83 e0 01             	and    $0x1,%eax
c0100bf3:	85 c0                	test   %eax,%eax
c0100bf5:	74 05                	je     c0100bfc <free_pgdir+0x49>
c0100bf7:	e9 ce 00 00 00       	jmp    c0100cca <free_pgdir+0x117>
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
c0100bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c09:	01 d0                	add    %edx,%eax
c0100c0b:	8b 00                	mov    (%eax),%eax
c0100c0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c12:	83 ec 04             	sub    $0x4,%esp
c0100c15:	50                   	push   %eax
c0100c16:	68 5d 01 00 00       	push   $0x15d
c0100c1b:	68 85 24 10 c0       	push   $0xc0102485
c0100c20:	e8 a7 f9 ff ff       	call   c01005cc <_kaddr>
c0100c25:	83 c4 10             	add    $0x10,%esp
c0100c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0100c32:	eb 4a                	jmp    c0100c7e <free_pgdir+0xcb>
				if (pgtable[ptx] & PTE_P) {
c0100c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c41:	01 d0                	add    %edx,%eax
c0100c43:	8b 00                	mov    (%eax),%eax
c0100c45:	83 e0 01             	and    $0x1,%eax
c0100c48:	85 c0                	test   %eax,%eax
c0100c4a:	74 2e                	je     c0100c7a <free_pgdir+0xc7>
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
c0100c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100c59:	01 d0                	add    %edx,%eax
c0100c5b:	8b 00                	mov    (%eax),%eax
c0100c5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c62:	83 ec 0c             	sub    $0xc,%esp
c0100c65:	50                   	push   %eax
c0100c66:	e8 a6 f9 ff ff       	call   c0100611 <pa2page>
c0100c6b:	83 c4 10             	add    $0x10,%esp
c0100c6e:	83 ec 0c             	sub    $0xc,%esp
c0100c71:	50                   	push   %eax
c0100c72:	e8 5d fc ff ff       	call   c01008d4 <page_decref>
c0100c77:	83 c4 10             	add    $0x10,%esp
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
c0100c7a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0100c7e:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
c0100c85:	7e ad                	jle    c0100c34 <free_pgdir+0x81>
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
c0100c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c94:	01 d0                	add    %edx,%eax
c0100c96:	8b 00                	mov    (%eax),%eax
c0100c98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0100c9d:	83 ec 0c             	sub    $0xc,%esp
c0100ca0:	50                   	push   %eax
c0100ca1:	e8 6b f9 ff ff       	call   c0100611 <pa2page>
c0100ca6:	83 c4 10             	add    $0x10,%esp
c0100ca9:	83 ec 0c             	sub    $0xc,%esp
c0100cac:	50                   	push   %eax
c0100cad:	e8 22 fc ff ff       	call   c01008d4 <page_decref>
c0100cb2:	83 c4 10             	add    $0x10,%esp
			pgdir[pdx] = 0;
c0100cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cc2:	01 d0                	add    %edx,%eax
c0100cc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
c0100cca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cce:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0100cd5:	0f 8e ea fe ff ff    	jle    c0100bc5 <free_pgdir+0x12>
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}
c0100cdb:	c9                   	leave  
c0100cdc:	c3                   	ret    

c0100cdd <do_scheduler>:
extern PCB* current; 
extern void scheduler_switch(PCB* pcb);
extern uint32_t _tick;
uint32_t cpid = 0;
uint32_t count = 0;
void do_scheduler(){
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 08             	sub    $0x8,%esp
	count ++;
c0100ce3:	a1 04 40 15 c0       	mov    0xc0154004,%eax
c0100ce8:	83 c0 01             	add    $0x1,%eax
c0100ceb:	a3 04 40 15 c0       	mov    %eax,0xc0154004
	//printk("%x", _tick);
	 if(count % 3 == 2){
c0100cf0:	8b 0d 04 40 15 c0    	mov    0xc0154004,%ecx
c0100cf6:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
c0100cfb:	89 c8                	mov    %ecx,%eax
c0100cfd:	f7 e2                	mul    %edx
c0100cff:	d1 ea                	shr    %edx
c0100d01:	89 d0                	mov    %edx,%eax
c0100d03:	01 c0                	add    %eax,%eax
c0100d05:	01 d0                	add    %edx,%eax
c0100d07:	29 c1                	sub    %eax,%ecx
c0100d09:	89 ca                	mov    %ecx,%edx
c0100d0b:	83 fa 02             	cmp    $0x2,%edx
c0100d0e:	75 30                	jne    c0100d40 <do_scheduler+0x63>
	 	cpid++;
c0100d10:	a1 00 40 15 c0       	mov    0xc0154000,%eax
c0100d15:	83 c0 01             	add    $0x1,%eax
c0100d18:	a3 00 40 15 c0       	mov    %eax,0xc0154000
	 	scheduler_switch(&PCBPool[cpid%2]);
c0100d1d:	a1 00 40 15 c0       	mov    0xc0154000,%eax
c0100d22:	83 e0 01             	and    $0x1,%eax
c0100d25:	c1 e0 05             	shl    $0x5,%eax
c0100d28:	89 c2                	mov    %eax,%edx
c0100d2a:	c1 e2 09             	shl    $0x9,%edx
c0100d2d:	01 d0                	add    %edx,%eax
c0100d2f:	05 40 64 1b c0       	add    $0xc01b6440,%eax
c0100d34:	83 ec 0c             	sub    $0xc,%esp
c0100d37:	50                   	push   %eax
c0100d38:	e8 b2 f6 ff ff       	call   c01003ef <scheduler_switch>
c0100d3d:	83 c4 10             	add    $0x10,%esp
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0100d40:	c9                   	leave  
c0100d41:	c3                   	ret    

c0100d42 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0100d42:	55                   	push   %ebp
c0100d43:	89 e5                	mov    %esp,%ebp
c0100d45:	83 ec 38             	sub    $0x38,%esp
	current->tf = tf;
c0100d48:	a1 40 46 1b c0       	mov    0xc01b4640,%eax
c0100d4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0100d50:	89 50 08             	mov    %edx,0x8(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0100d53:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d56:	8b 40 30             	mov    0x30(%eax),%eax
c0100d59:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0100d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d61:	8b 40 30             	mov    0x30(%eax),%eax
c0100d64:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100d69:	75 0e                	jne    c0100d79 <irq_handle+0x37>
		//printk("ha");
		do_syscall(tf);
c0100d6b:	83 ec 0c             	sub    $0xc,%esp
c0100d6e:	ff 75 08             	pushl  0x8(%ebp)
c0100d71:	e8 70 0b 00 00       	call   c01018e6 <do_syscall>
c0100d76:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0100d79:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d7c:	8b 40 30             	mov    0x30(%eax),%eax
c0100d7f:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0100d84:	75 0f                	jne    c0100d95 <irq_handle+0x53>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0100d86:	e8 eb 11 00 00       	call   c0101f76 <do_timer>
		do_scheduler();
c0100d8b:	e8 4d ff ff ff       	call   c0100cdd <do_scheduler>
c0100d90:	e9 83 00 00 00       	jmp    c0100e18 <irq_handle+0xd6>
	} else if (tf->irq == 1001) {
c0100d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d98:	8b 40 30             	mov    0x30(%eax),%eax
c0100d9b:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0100da0:	75 76                	jne    c0100e18 <irq_handle+0xd6>
c0100da2:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100dac:	89 c2                	mov    %eax,%edx
c0100dae:	ec                   	in     (%dx),%al
c0100daf:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0100db2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0100db6:	0f b6 c0             	movzbl %al,%eax
c0100db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100dbc:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100dc6:	89 c2                	mov    %eax,%edx
c0100dc8:	ec                   	in     (%dx),%al
c0100dc9:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0100dcc:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0100dd0:	0f b6 c0             	movzbl %al,%eax
c0100dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0100dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100dd9:	83 c8 80             	or     $0xffffff80,%eax
c0100ddc:	0f b6 c0             	movzbl %al,%eax
c0100ddf:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0100de6:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100de9:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100ded:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100df0:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0100df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100df4:	0f b6 c0             	movzbl %al,%eax
c0100df7:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0100dfe:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0100e01:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100e05:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100e08:	ee                   	out    %al,(%dx)
		press_key(code);
c0100e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e0c:	83 ec 0c             	sub    $0xc,%esp
c0100e0f:	50                   	push   %eax
c0100e10:	e8 f7 09 00 00       	call   c010180c <press_key>
c0100e15:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
}
c0100e18:	c9                   	leave  
c0100e19:	c3                   	ret    

c0100e1a <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0100e1a:	55                   	push   %ebp
c0100e1b:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e20:	83 e8 01             	sub    $0x1,%eax
c0100e23:	66 a3 08 40 15 c0    	mov    %ax,0xc0154008
	data[1] = (uint32_t)addr;
c0100e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e2c:	66 a3 0a 40 15 c0    	mov    %ax,0xc015400a
	data[2] = ((uint32_t)addr) >> 16;
c0100e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e35:	c1 e8 10             	shr    $0x10,%eax
c0100e38:	66 a3 0c 40 15 c0    	mov    %ax,0xc015400c
	asm volatile("lidt (%0)" : : "r"(data));
c0100e3e:	b8 08 40 15 c0       	mov    $0xc0154008,%eax
c0100e43:	0f 01 18             	lidtl  (%eax)
}
c0100e46:	5d                   	pop    %ebp
c0100e47:	c3                   	ret    

c0100e48 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100e48:	55                   	push   %ebp
c0100e49:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100e4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e53:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100e56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e59:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e63:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100e67:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e6a:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e71:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100e75:	83 e2 f0             	and    $0xfffffff0,%edx
c0100e78:	83 ca 0e             	or     $0xe,%edx
c0100e7b:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e81:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100e85:	83 e2 ef             	and    $0xffffffef,%edx
c0100e88:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100e8b:	8b 45 14             	mov    0x14(%ebp),%eax
c0100e8e:	83 e0 03             	and    $0x3,%eax
c0100e91:	89 c2                	mov    %eax,%edx
c0100e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e96:	83 e2 03             	and    $0x3,%edx
c0100e99:	89 d1                	mov    %edx,%ecx
c0100e9b:	c1 e1 05             	shl    $0x5,%ecx
c0100e9e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100ea2:	83 e2 9f             	and    $0xffffff9f,%edx
c0100ea5:	09 ca                	or     %ecx,%edx
c0100ea7:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ead:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100eb1:	83 ca 80             	or     $0xffffff80,%edx
c0100eb4:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100eb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0100eba:	c1 e8 10             	shr    $0x10,%eax
c0100ebd:	89 c2                	mov    %eax,%edx
c0100ebf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ec2:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100ec6:	5d                   	pop    %ebp
c0100ec7:	c3                   	ret    

c0100ec8 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100ec8:	55                   	push   %ebp
c0100ec9:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100ecb:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ece:	89 c2                	mov    %eax,%edx
c0100ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ed3:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ed9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ee3:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100eea:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c0100eee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ef1:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100ef5:	83 ca 0f             	or     $0xf,%edx
c0100ef8:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100efb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100efe:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f02:	83 e2 ef             	and    $0xffffffef,%edx
c0100f05:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100f08:	8b 45 14             	mov    0x14(%ebp),%eax
c0100f0b:	83 e0 03             	and    $0x3,%eax
c0100f0e:	89 c2                	mov    %eax,%edx
c0100f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f13:	83 e2 03             	and    $0x3,%edx
c0100f16:	89 d1                	mov    %edx,%ecx
c0100f18:	c1 e1 05             	shl    $0x5,%ecx
c0100f1b:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f1f:	83 e2 9f             	and    $0xffffff9f,%edx
c0100f22:	09 ca                	or     %ecx,%edx
c0100f24:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f2a:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100f2e:	83 ca 80             	or     $0xffffff80,%edx
c0100f31:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0100f34:	8b 45 10             	mov    0x10(%ebp),%eax
c0100f37:	c1 e8 10             	shr    $0x10,%eax
c0100f3a:	89 c2                	mov    %eax,%edx
c0100f3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f3f:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0100f43:	5d                   	pop    %ebp
c0100f44:	c3                   	ret    

c0100f45 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0100f45:	55                   	push   %ebp
c0100f46:	89 e5                	mov    %esp,%ebp
c0100f48:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100f4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f52:	eb 22                	jmp    c0100f76 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c0100f54:	ba 4a 20 10 c0       	mov    $0xc010204a,%edx
c0100f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f5c:	c1 e0 03             	shl    $0x3,%eax
c0100f5f:	05 40 3a 1b c0       	add    $0xc01b3a40,%eax
c0100f64:	6a 00                	push   $0x0
c0100f66:	52                   	push   %edx
c0100f67:	6a 01                	push   $0x1
c0100f69:	50                   	push   %eax
c0100f6a:	e8 59 ff ff ff       	call   c0100ec8 <set_trap>
c0100f6f:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0100f72:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100f76:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0100f7d:	7e d5                	jle    c0100f54 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c0100f7f:	b8 92 1f 10 c0       	mov    $0xc0101f92,%eax
c0100f84:	6a 00                	push   $0x0
c0100f86:	50                   	push   %eax
c0100f87:	6a 01                	push   $0x1
c0100f89:	68 40 3a 1b c0       	push   $0xc01b3a40
c0100f8e:	e8 35 ff ff ff       	call   c0100ec8 <set_trap>
c0100f93:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0100f96:	b8 9b 1f 10 c0       	mov    $0xc0101f9b,%eax
c0100f9b:	6a 00                	push   $0x0
c0100f9d:	50                   	push   %eax
c0100f9e:	6a 01                	push   $0x1
c0100fa0:	68 48 3a 1b c0       	push   $0xc01b3a48
c0100fa5:	e8 1e ff ff ff       	call   c0100ec8 <set_trap>
c0100faa:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c0100fad:	b8 a4 1f 10 c0       	mov    $0xc0101fa4,%eax
c0100fb2:	6a 00                	push   $0x0
c0100fb4:	50                   	push   %eax
c0100fb5:	6a 01                	push   $0x1
c0100fb7:	68 50 3a 1b c0       	push   $0xc01b3a50
c0100fbc:	e8 07 ff ff ff       	call   c0100ec8 <set_trap>
c0100fc1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0100fc4:	b8 ad 1f 10 c0       	mov    $0xc0101fad,%eax
c0100fc9:	6a 00                	push   $0x0
c0100fcb:	50                   	push   %eax
c0100fcc:	6a 01                	push   $0x1
c0100fce:	68 58 3a 1b c0       	push   $0xc01b3a58
c0100fd3:	e8 f0 fe ff ff       	call   c0100ec8 <set_trap>
c0100fd8:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0100fdb:	b8 b6 1f 10 c0       	mov    $0xc0101fb6,%eax
c0100fe0:	6a 00                	push   $0x0
c0100fe2:	50                   	push   %eax
c0100fe3:	6a 01                	push   $0x1
c0100fe5:	68 60 3a 1b c0       	push   $0xc01b3a60
c0100fea:	e8 d9 fe ff ff       	call   c0100ec8 <set_trap>
c0100fef:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0100ff2:	b8 bf 1f 10 c0       	mov    $0xc0101fbf,%eax
c0100ff7:	6a 00                	push   $0x0
c0100ff9:	50                   	push   %eax
c0100ffa:	6a 01                	push   $0x1
c0100ffc:	68 68 3a 1b c0       	push   $0xc01b3a68
c0101001:	e8 c2 fe ff ff       	call   c0100ec8 <set_trap>
c0101006:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101009:	b8 c8 1f 10 c0       	mov    $0xc0101fc8,%eax
c010100e:	6a 00                	push   $0x0
c0101010:	50                   	push   %eax
c0101011:	6a 01                	push   $0x1
c0101013:	68 70 3a 1b c0       	push   $0xc01b3a70
c0101018:	e8 ab fe ff ff       	call   c0100ec8 <set_trap>
c010101d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c0101020:	b8 d1 1f 10 c0       	mov    $0xc0101fd1,%eax
c0101025:	6a 00                	push   $0x0
c0101027:	50                   	push   %eax
c0101028:	6a 01                	push   $0x1
c010102a:	68 78 3a 1b c0       	push   $0xc01b3a78
c010102f:	e8 94 fe ff ff       	call   c0100ec8 <set_trap>
c0101034:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0101037:	b8 da 1f 10 c0       	mov    $0xc0101fda,%eax
c010103c:	6a 00                	push   $0x0
c010103e:	50                   	push   %eax
c010103f:	6a 01                	push   $0x1
c0101041:	68 80 3a 1b c0       	push   $0xc01b3a80
c0101046:	e8 7d fe ff ff       	call   c0100ec8 <set_trap>
c010104b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c010104e:	b8 e3 1f 10 c0       	mov    $0xc0101fe3,%eax
c0101053:	6a 00                	push   $0x0
c0101055:	50                   	push   %eax
c0101056:	6a 01                	push   $0x1
c0101058:	68 88 3a 1b c0       	push   $0xc01b3a88
c010105d:	e8 66 fe ff ff       	call   c0100ec8 <set_trap>
c0101062:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c0101065:	b8 ec 1f 10 c0       	mov    $0xc0101fec,%eax
c010106a:	6a 00                	push   $0x0
c010106c:	50                   	push   %eax
c010106d:	6a 01                	push   $0x1
c010106f:	68 90 3a 1b c0       	push   $0xc01b3a90
c0101074:	e8 4f fe ff ff       	call   c0100ec8 <set_trap>
c0101079:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c010107c:	b8 f5 1f 10 c0       	mov    $0xc0101ff5,%eax
c0101081:	6a 00                	push   $0x0
c0101083:	50                   	push   %eax
c0101084:	6a 01                	push   $0x1
c0101086:	68 98 3a 1b c0       	push   $0xc01b3a98
c010108b:	e8 38 fe ff ff       	call   c0100ec8 <set_trap>
c0101090:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101093:	b8 fe 1f 10 c0       	mov    $0xc0101ffe,%eax
c0101098:	6a 00                	push   $0x0
c010109a:	50                   	push   %eax
c010109b:	6a 01                	push   $0x1
c010109d:	68 a0 3a 1b c0       	push   $0xc01b3aa0
c01010a2:	e8 21 fe ff ff       	call   c0100ec8 <set_trap>
c01010a7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c01010aa:	b8 07 20 10 c0       	mov    $0xc0102007,%eax
c01010af:	6a 00                	push   $0x0
c01010b1:	50                   	push   %eax
c01010b2:	6a 01                	push   $0x1
c01010b4:	68 a8 3a 1b c0       	push   $0xc01b3aa8
c01010b9:	e8 0a fe ff ff       	call   c0100ec8 <set_trap>
c01010be:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c01010c1:	b8 19 20 10 c0       	mov    $0xc0102019,%eax
c01010c6:	6a 03                	push   $0x3
c01010c8:	50                   	push   %eax
c01010c9:	6a 01                	push   $0x1
c01010cb:	68 40 3e 1b c0       	push   $0xc01b3e40
c01010d0:	e8 f3 fd ff ff       	call   c0100ec8 <set_trap>
c01010d5:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c01010d8:	b8 26 20 10 c0       	mov    $0xc0102026,%eax
c01010dd:	6a 00                	push   $0x0
c01010df:	50                   	push   %eax
c01010e0:	6a 01                	push   $0x1
c01010e2:	68 40 3b 1b c0       	push   $0xc01b3b40
c01010e7:	e8 5c fd ff ff       	call   c0100e48 <set_intr>
c01010ec:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c01010ef:	b8 32 20 10 c0       	mov    $0xc0102032,%eax
c01010f4:	6a 00                	push   $0x0
c01010f6:	50                   	push   %eax
c01010f7:	6a 01                	push   $0x1
c01010f9:	68 48 3b 1b c0       	push   $0xc01b3b48
c01010fe:	e8 45 fd ff ff       	call   c0100e48 <set_intr>
c0101103:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101106:	68 00 08 00 00       	push   $0x800
c010110b:	68 40 3a 1b c0       	push   $0xc01b3a40
c0101110:	e8 05 fd ff ff       	call   c0100e1a <save_idt>
c0101115:	83 c4 08             	add    $0x8,%esp
}
c0101118:	c9                   	leave  
c0101119:	c3                   	ret    

c010111a <sys_get_tick>:
	char r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_get_tick(){
c010111a:	55                   	push   %ebp
c010111b:	89 e5                	mov    %esp,%ebp
c010111d:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
c0101127:	b8 15 05 00 00       	mov    $0x515,%eax
c010112c:	cd 80                	int    $0x80
c010112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101131:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101134:	c9                   	leave  
c0101135:	c3                   	ret    

c0101136 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c0101136:	55                   	push   %ebp
c0101137:	89 e5                	mov    %esp,%ebp
c0101139:	83 ec 40             	sub    $0x40,%esp
c010113c:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0101143:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101147:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010114b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010114e:	ee                   	out    %al,(%dx)
c010114f:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c0101156:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c010115a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010115e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101161:	ee                   	out    %al,(%dx)
c0101162:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0101169:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c010116d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101171:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101174:	ee                   	out    %al,(%dx)
c0101175:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c010117c:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0101180:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101187:	ee                   	out    %al,(%dx)
c0101188:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c010118f:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0101193:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101197:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010119a:	ee                   	out    %al,(%dx)
c010119b:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01011a2:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01011a6:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01011aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01011ad:	ee                   	out    %al,(%dx)
c01011ae:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c01011b5:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01011b9:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01011bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01011c0:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01011c1:	c9                   	leave  
c01011c2:	c3                   	ret    

c01011c3 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c01011c3:	55                   	push   %ebp
c01011c4:	89 e5                	mov    %esp,%ebp
c01011c6:	83 ec 70             	sub    $0x70,%esp
c01011c9:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01011d0:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01011d4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01011d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01011db:	ee                   	out    %al,(%dx)
c01011dc:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01011e3:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01011e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01011eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011ee:	ee                   	out    %al,(%dx)
c01011ef:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01011f6:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01011fa:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01011fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101201:	ee                   	out    %al,(%dx)
c0101202:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0101209:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c010120d:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101211:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101214:	ee                   	out    %al,(%dx)
c0101215:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c010121c:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0101220:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0101224:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101227:	ee                   	out    %al,(%dx)
c0101228:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010122f:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c0101233:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101237:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010123a:	ee                   	out    %al,(%dx)
c010123b:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0101242:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0101246:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c010124a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010124d:	ee                   	out    %al,(%dx)
c010124e:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0101255:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101259:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c010125d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101260:	ee                   	out    %al,(%dx)
c0101261:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0101268:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c010126c:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c0101270:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0101273:	ee                   	out    %al,(%dx)
c0101274:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c010127b:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c010127f:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c0101283:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0101286:	ee                   	out    %al,(%dx)
c0101287:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c010128e:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0101292:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0101296:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101299:	ee                   	out    %al,(%dx)
c010129a:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c01012a1:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01012a5:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c01012a9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01012ac:	ee                   	out    %al,(%dx)
c01012ad:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c01012b4:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c01012b8:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c01012bc:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
c01012c0:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c01012c7:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01012cb:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01012cf:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01012d2:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01012d3:	c9                   	leave  
c01012d4:	c3                   	ret    

c01012d5 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01012db:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01012e2:	0f b6 05 00 60 10 c0 	movzbl 0xc0106000,%eax
c01012e9:	0f b6 c0             	movzbl %al,%eax
c01012ec:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01012f3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01012f6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01012fd:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01012fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c010130b:	88 45 ef             	mov    %al,-0x11(%ebp)
c010130e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101312:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c0101316:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101319:	c1 f8 08             	sar    $0x8,%eax
c010131c:	0f b6 c0             	movzbl %al,%eax
c010131f:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0101326:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101329:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010132d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101330:	ee                   	out    %al,(%dx)
}
c0101331:	c9                   	leave  
c0101332:	c3                   	ret    

c0101333 <idle>:

//void loader(PCB* pcb, uint32_t offset);

extern void init_segment(void);
extern void init_page(void);
void idle(){
c0101333:	55                   	push   %ebp
c0101334:	89 e5                	mov    %esp,%ebp
c0101336:	83 ec 18             	sub    $0x18,%esp
  uint32_t tick=0, cur=0;
c0101339:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101340:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    //  printk("This is idle!\n");
    //}
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    cur = sys_get_tick();
c0101347:	e8 ce fd ff ff       	call   c010111a <sys_get_tick>
c010134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(tick < cur){
c010134f:	eb 14                	jmp    c0101365 <idle+0x32>
      printf("This is idle!\n");
c0101351:	83 ec 0c             	sub    $0xc,%esp
c0101354:	68 9e 24 10 c0       	push   $0xc010249e
c0101359:	e8 47 10 00 00       	call   c01023a5 <printf>
c010135e:	83 c4 10             	add    $0x10,%esp
      tick+=50;
c0101361:	83 45 f4 32          	addl   $0x32,-0xc(%ebp)
    //}
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    cur = sys_get_tick();
    while(tick < cur){
c0101365:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010136b:	72 e4                	jb     c0101351 <idle+0x1e>
      printf("This is idle!\n");
      tick+=50;
    }
    //enable_interrupt();
  }
c010136d:	eb d8                	jmp    c0101347 <idle+0x14>

c010136f <main>:
}

int main(){
c010136f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0101373:	83 e4 f0             	and    $0xfffffff0,%esp
c0101376:	ff 71 fc             	pushl  -0x4(%ecx)
c0101379:	55                   	push   %ebp
c010137a:	89 e5                	mov    %esp,%ebp
c010137c:	51                   	push   %ecx
c010137d:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0101380:	e8 a6 ed ff ff       	call   c010012b <init_page>
  init_segment();
c0101385:	e8 52 ef ff ff       	call   c01002dc <init_segment>
	init_serial();
c010138a:	e8 a7 fd ff ff       	call   c0101136 <init_serial>
	init_timer();
c010138f:	e8 41 ff ff ff       	call   c01012d5 <init_timer>
	init_idt();
c0101394:	e8 ac fb ff ff       	call   c0100f45 <init_idt>
	init_intr();
c0101399:	e8 25 fe ff ff       	call   c01011c3 <init_intr>
  init_pcb_pool();
c010139e:	e8 c2 07 00 00       	call   c0101b65 <init_pcb_pool>

  PCB* pcb = pcb_create();
c01013a3:	e8 b0 08 00 00       	call   c0101c58 <pcb_create>
c01013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  PCB* pidle = pcb_create();
c01013ab:	e8 a8 08 00 00       	call   c0101c58 <pcb_create>
c01013b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c01013b3:	83 ec 08             	sub    $0x8,%esp
c01013b6:	68 00 90 01 00       	push   $0x19000
c01013bb:	ff 75 f4             	pushl  -0xc(%ebp)
c01013be:	e8 44 02 00 00       	call   c0101607 <loader>
c01013c3:	83 c4 10             	add    $0x10,%esp
  empty_loader(pidle, idle);
c01013c6:	83 ec 08             	sub    $0x8,%esp
c01013c9:	68 33 13 10 c0       	push   $0xc0101333
c01013ce:	ff 75 f0             	pushl  -0x10(%ebp)
c01013d1:	e8 86 03 00 00       	call   c010175c <empty_loader>
c01013d6:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));

  switch_pcb(pidle);
c01013d9:	83 ec 0c             	sub    $0xc,%esp
c01013dc:	ff 75 f0             	pushl  -0x10(%ebp)
c01013df:	e8 58 09 00 00       	call   c0101d3c <switch_pcb>
c01013e4:	83 c4 10             	add    $0x10,%esp
  //loader(pcb, 0);
  //empty_loader(pidle, idle);
  //switch_pcb(pidle);
  //printk("e\n");

	return 1;
c01013e7:	b8 01 00 00 00       	mov    $0x1,%eax
};
c01013ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c01013ef:	c9                   	leave  
c01013f0:	8d 61 fc             	lea    -0x4(%ecx),%esp
c01013f3:	c3                   	ret    

c01013f4 <serial_idle>:

static inline
int serial_idle(void) {
c01013f4:	55                   	push   %ebp
c01013f5:	89 e5                	mov    %esp,%ebp
c01013f7:	83 ec 10             	sub    $0x10,%esp
c01013fa:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101401:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101404:	89 c2                	mov    %eax,%edx
c0101406:	ec                   	in     (%dx),%al
c0101407:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010140a:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010140e:	0f b6 c0             	movzbl %al,%eax
c0101411:	83 e0 20             	and    $0x20,%eax
c0101414:	85 c0                	test   %eax,%eax
c0101416:	0f 95 c0             	setne  %al
c0101419:	0f b6 c0             	movzbl %al,%eax
}
c010141c:	c9                   	leave  
c010141d:	c3                   	ret    

c010141e <serial_printc>:

static inline
void serial_printc(char ch) {
c010141e:	55                   	push   %ebp
c010141f:	89 e5                	mov    %esp,%ebp
c0101421:	83 ec 14             	sub    $0x14,%esp
c0101424:	8b 45 08             	mov    0x8(%ebp),%eax
c0101427:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010142a:	90                   	nop
c010142b:	e8 c4 ff ff ff       	call   c01013f4 <serial_idle>
c0101430:	85 c0                	test   %eax,%eax
c0101432:	74 f7                	je     c010142b <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101434:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101438:	0f b6 c0             	movzbl %al,%eax
c010143b:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101442:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101445:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101449:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010144c:	ee                   	out    %al,(%dx)
}
c010144d:	c9                   	leave  
c010144e:	c3                   	ret    

c010144f <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010144f:	55                   	push   %ebp
c0101450:	89 e5                	mov    %esp,%ebp
c0101452:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101455:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101458:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010145b:	8b 45 08             	mov    0x8(%ebp),%eax
c010145e:	83 ec 04             	sub    $0x4,%esp
c0101461:	ff 75 f4             	pushl  -0xc(%ebp)
c0101464:	50                   	push   %eax
c0101465:	68 1e 14 10 c0       	push   $0xc010141e
c010146a:	e8 9c 0c 00 00       	call   c010210b <vfprintf>
c010146f:	83 c4 10             	add    $0x10,%esp
}
c0101472:	c9                   	leave  
c0101473:	c3                   	ret    

c0101474 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101474:	55                   	push   %ebp
c0101475:	89 e5                	mov    %esp,%ebp
c0101477:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c010147a:	90                   	nop
c010147b:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101482:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101485:	89 c2                	mov    %eax,%edx
c0101487:	ec                   	in     (%dx),%al
c0101488:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010148b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010148f:	0f b6 c0             	movzbl %al,%eax
c0101492:	25 c0 00 00 00       	and    $0xc0,%eax
c0101497:	83 f8 40             	cmp    $0x40,%eax
c010149a:	75 df                	jne    c010147b <waitdisk+0x7>
}
c010149c:	c9                   	leave  
c010149d:	c3                   	ret    

c010149e <readsect>:

static inline void
readsect(void *dst, int offset) {
c010149e:	55                   	push   %ebp
c010149f:	89 e5                	mov    %esp,%ebp
c01014a1:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01014a4:	e8 cb ff ff ff       	call   c0101474 <waitdisk>
c01014a9:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01014b0:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01014b4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01014b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01014bb:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014bf:	0f b6 c0             	movzbl %al,%eax
c01014c2:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01014c9:	88 45 ef             	mov    %al,-0x11(%ebp)
c01014cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01014d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01014d3:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014d7:	c1 f8 08             	sar    $0x8,%eax
c01014da:	0f b6 c0             	movzbl %al,%eax
c01014dd:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01014e4:	88 45 e7             	mov    %al,-0x19(%ebp)
c01014e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01014ee:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01014ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014f2:	c1 f8 10             	sar    $0x10,%eax
c01014f5:	0f b6 c0             	movzbl %al,%eax
c01014f8:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01014ff:	88 45 df             	mov    %al,-0x21(%ebp)
c0101502:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101506:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101509:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c010150a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010150d:	c1 f8 18             	sar    $0x18,%eax
c0101510:	83 c8 e0             	or     $0xffffffe0,%eax
c0101513:	0f b6 c0             	movzbl %al,%eax
c0101516:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010151d:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101520:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101524:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101527:	ee                   	out    %al,(%dx)
c0101528:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c010152f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101533:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101537:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010153a:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c010153b:	e8 34 ff ff ff       	call   c0101474 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101540:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101547:	eb 29                	jmp    c0101572 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101549:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010154c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101553:	8b 45 08             	mov    0x8(%ebp),%eax
c0101556:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101559:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101560:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101563:	89 c2                	mov    %eax,%edx
c0101565:	ed                   	in     (%dx),%eax
c0101566:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101569:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010156c:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010156e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101572:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101576:	7e d1                	jle    c0101549 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101578:	c9                   	leave  
c0101579:	c3                   	ret    

c010157a <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c010157a:	55                   	push   %ebp
c010157b:	89 e5                	mov    %esp,%ebp
c010157d:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101580:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101583:	8b 45 08             	mov    0x8(%ebp),%eax
c0101586:	01 d0                	add    %edx,%eax
c0101588:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c010158b:	8b 45 10             	mov    0x10(%ebp),%eax
c010158e:	99                   	cltd   
c010158f:	c1 ea 17             	shr    $0x17,%edx
c0101592:	01 d0                	add    %edx,%eax
c0101594:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101599:	29 d0                	sub    %edx,%eax
c010159b:	f7 d8                	neg    %eax
c010159d:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c01015a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01015a3:	99                   	cltd   
c01015a4:	c1 ea 17             	shr    $0x17,%edx
c01015a7:	01 d0                	add    %edx,%eax
c01015a9:	c1 f8 09             	sar    $0x9,%eax
c01015ac:	83 c0 01             	add    $0x1,%eax
c01015af:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01015b2:	eb 19                	jmp    c01015cd <readseg+0x53>
        readsect(pa, offset);
c01015b4:	ff 75 10             	pushl  0x10(%ebp)
c01015b7:	ff 75 08             	pushl  0x8(%ebp)
c01015ba:	e8 df fe ff ff       	call   c010149e <readsect>
c01015bf:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c01015c2:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c01015c9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01015cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01015d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01015d3:	72 df                	jb     c01015b4 <readseg+0x3a>
        readsect(pa, offset);
c01015d5:	c9                   	leave  
c01015d6:	c3                   	ret    

c01015d7 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c01015d7:	55                   	push   %ebp
c01015d8:	89 e5                	mov    %esp,%ebp
c01015da:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01015dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01015e0:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01015e5:	77 16                	ja     c01015fd <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01015e7:	ff 75 10             	pushl  0x10(%ebp)
c01015ea:	68 b0 24 10 c0       	push   $0xc01024b0
c01015ef:	ff 75 0c             	pushl  0xc(%ebp)
c01015f2:	ff 75 08             	pushl  0x8(%ebp)
c01015f5:	e8 55 fe ff ff       	call   c010144f <printk>
c01015fa:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01015fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101600:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101605:	c9                   	leave  
c0101606:	c3                   	ret    

c0101607 <loader>:
#define elf   ((struct ELFHeader *) elf_t)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101607:	55                   	push   %ebp
c0101608:	89 e5                	mov    %esp,%ebp
c010160a:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c010160d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101610:	50                   	push   %eax
c0101611:	68 00 10 00 00       	push   $0x1000
c0101616:	68 40 42 1b c0       	push   $0xc01b4240
c010161b:	e8 5a ff ff ff       	call   c010157a <readseg>
c0101620:	83 c4 0c             	add    $0xc,%esp
  //printk("b\n");
  //printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101623:	b8 40 42 1b c0       	mov    $0xc01b4240,%eax
c0101628:	8b 40 1c             	mov    0x1c(%eax),%eax
c010162b:	05 40 42 1b c0       	add    $0xc01b4240,%eax
c0101630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101633:	b8 40 42 1b c0       	mov    $0xc01b4240,%eax
c0101638:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010163c:	0f b7 c0             	movzwl %ax,%eax
c010163f:	c1 e0 05             	shl    $0x5,%eax
c0101642:	89 c2                	mov    %eax,%edx
c0101644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101647:	01 d0                	add    %edx,%eax
c0101649:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //uint32_t p = PADDR(pcb -> pgdir);
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
c010164c:	8b 45 08             	mov    0x8(%ebp),%eax
c010164f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101652:	83 ec 04             	sub    $0x4,%esp
c0101655:	50                   	push   %eax
c0101656:	6a 20                	push   $0x20
c0101658:	68 d3 24 10 c0       	push   $0xc01024d3
c010165d:	e8 75 ff ff ff       	call   c01015d7 <_paddr>
c0101662:	83 c4 10             	add    $0x10,%esp
c0101665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010166b:	0f 22 d8             	mov    %eax,%cr3
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c010166e:	eb 7c                	jmp    c01016ec <loader+0xe5>
    pa = (unsigned char*)ph->paddr; 
c0101670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101673:	8b 40 0c             	mov    0xc(%eax),%eax
c0101676:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101679:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010167c:	8b 48 14             	mov    0x14(%eax),%ecx
c010167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101682:	8b 50 08             	mov    0x8(%eax),%edx
c0101685:	8b 45 08             	mov    0x8(%ebp),%eax
c0101688:	8b 40 0c             	mov    0xc(%eax),%eax
c010168b:	83 ec 04             	sub    $0x4,%esp
c010168e:	51                   	push   %ecx
c010168f:	52                   	push   %edx
c0101690:	50                   	push   %eax
c0101691:	e8 d4 ef ff ff       	call   c010066a <mm_alloc>
c0101696:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010169c:	8b 50 04             	mov    0x4(%eax),%edx
c010169f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016a2:	01 d0                	add    %edx,%eax
c01016a4:	89 c2                	mov    %eax,%edx
c01016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016a9:	8b 40 10             	mov    0x10(%eax),%eax
c01016ac:	83 ec 04             	sub    $0x4,%esp
c01016af:	52                   	push   %edx
c01016b0:	50                   	push   %eax
c01016b1:	ff 75 e8             	pushl  -0x18(%ebp)
c01016b4:	e8 c1 fe ff ff       	call   c010157a <readseg>
c01016b9:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c01016bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016bf:	8b 50 10             	mov    0x10(%eax),%edx
c01016c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01016c5:	01 d0                	add    %edx,%eax
c01016c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01016ca:	eb 0c                	jmp    c01016d8 <loader+0xd1>
c01016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016cf:	8d 50 01             	lea    0x1(%eax),%edx
c01016d2:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01016d5:	c6 00 00             	movb   $0x0,(%eax)
c01016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016db:	8b 50 14             	mov    0x14(%eax),%edx
c01016de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01016e1:	01 d0                	add    %edx,%eax
c01016e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01016e6:	77 e4                	ja     c01016cc <loader+0xc5>
  //printk("%x\n", p);
  lcr3(PADDR(pcb -> pgdir));
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01016e8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01016f2:	0f 82 78 ff ff ff    	jb     c0101670 <loader+0x69>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c01016f8:	b8 40 42 1b c0       	mov    $0xc01b4240,%eax
c01016fd:	8b 40 18             	mov    0x18(%eax),%eax
c0101700:	a3 84 20 10 c0       	mov    %eax,0xc0102084

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101705:	8b 45 08             	mov    0x8(%ebp),%eax
c0101708:	8b 40 0c             	mov    0xc(%eax),%eax
c010170b:	83 ec 04             	sub    $0x4,%esp
c010170e:	68 00 80 00 00       	push   $0x8000
c0101713:	68 00 60 bf be       	push   $0xbebf6000
c0101718:	50                   	push   %eax
c0101719:	e8 4c ef ff ff       	call   c010066a <mm_alloc>
c010171e:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-8, entry, 3);
c0101721:	a1 84 20 10 c0       	mov    0xc0102084,%eax
c0101726:	6a 03                	push   $0x3
c0101728:	50                   	push   %eax
c0101729:	68 f8 df bf be       	push   $0xbebfdff8
c010172e:	ff 75 08             	pushl  0x8(%ebp)
c0101731:	e8 63 04 00 00       	call   c0101b99 <init_pcb>
c0101736:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0101739:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c010173e:	83 ec 04             	sub    $0x4,%esp
c0101741:	50                   	push   %eax
c0101742:	6a 36                	push   $0x36
c0101744:	68 d3 24 10 c0       	push   $0xc01024d3
c0101749:	e8 89 fe ff ff       	call   c01015d7 <_paddr>
c010174e:	83 c4 10             	add    $0x10,%esp
c0101751:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101754:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101757:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c010175a:	c9                   	leave  
c010175b:	c3                   	ret    

c010175c <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c010175c:	55                   	push   %ebp
c010175d:	89 e5                	mov    %esp,%ebp
c010175f:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101762:	8b 45 08             	mov    0x8(%ebp),%eax
c0101765:	8b 40 0c             	mov    0xc(%eax),%eax
c0101768:	83 ec 04             	sub    $0x4,%esp
c010176b:	50                   	push   %eax
c010176c:	6a 3f                	push   $0x3f
c010176e:	68 d3 24 10 c0       	push   $0xc01024d3
c0101773:	e8 5f fe ff ff       	call   c01015d7 <_paddr>
c0101778:	83 c4 10             	add    $0x10,%esp
c010177b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101781:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0101784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101787:	a3 84 20 10 c0       	mov    %eax,0xc0102084
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c010178c:	8b 45 08             	mov    0x8(%ebp),%eax
c010178f:	8b 40 0c             	mov    0xc(%eax),%eax
c0101792:	83 ec 04             	sub    $0x4,%esp
c0101795:	68 00 80 00 00       	push   $0x8000
c010179a:	68 00 60 bf be       	push   $0xbebf6000
c010179f:	50                   	push   %eax
c01017a0:	e8 c5 ee ff ff       	call   c010066a <mm_alloc>
c01017a5:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-8, entry, 0);
c01017a8:	a1 84 20 10 c0       	mov    0xc0102084,%eax
c01017ad:	6a 00                	push   $0x0
c01017af:	50                   	push   %eax
c01017b0:	68 f8 df bf be       	push   $0xbebfdff8
c01017b5:	ff 75 08             	pushl  0x8(%ebp)
c01017b8:	e8 dc 03 00 00       	call   c0101b99 <init_pcb>
c01017bd:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c01017c0:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c01017c5:	83 ec 04             	sub    $0x4,%esp
c01017c8:	50                   	push   %eax
c01017c9:	6a 43                	push   $0x43
c01017cb:	68 d3 24 10 c0       	push   $0xc01024d3
c01017d0:	e8 02 fe ff ff       	call   c01015d7 <_paddr>
c01017d5:	83 c4 10             	add    $0x10,%esp
c01017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017de:	0f 22 d8             	mov    %eax,%cr3

};
c01017e1:	c9                   	leave  
c01017e2:	c3                   	ret    

c01017e3 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c01017e3:	55                   	push   %ebp
c01017e4:	89 e5                	mov    %esp,%ebp
c01017e6:	83 ec 04             	sub    $0x4,%esp
c01017e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01017ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c01017ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c01017f3:	83 e8 61             	sub    $0x61,%eax
c01017f6:	8b 04 85 40 40 15 c0 	mov    -0x3feabfc0(,%eax,4),%eax
}
c01017fd:	c9                   	leave  
c01017fe:	c3                   	ret    

c01017ff <get_lastkey>:
int8_t get_lastkey(){
c01017ff:	55                   	push   %ebp
c0101800:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101802:	a1 a8 40 15 c0       	mov    0xc01540a8,%eax
c0101807:	83 c0 61             	add    $0x61,%eax
}
c010180a:	5d                   	pop    %ebp
c010180b:	c3                   	ret    

c010180c <press_key>:
void press_key(int code){
c010180c:	55                   	push   %ebp
c010180d:	89 e5                	mov    %esp,%ebp
c010180f:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101812:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101819:	8b 45 08             	mov    0x8(%ebp),%eax
c010181c:	25 80 00 00 00       	and    $0x80,%eax
c0101821:	85 c0                	test   %eax,%eax
c0101823:	75 35                	jne    c010185a <press_key+0x4e>
		for(;i<26;i++){
c0101825:	eb 2b                	jmp    c0101852 <press_key+0x46>
			if(letter[i]==code){
c0101827:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010182a:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c0101831:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101834:	75 18                	jne    c010184e <press_key+0x42>
				keydown[i] = 1;
c0101836:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101839:	c7 04 85 40 40 15 c0 	movl   $0x1,-0x3feabfc0(,%eax,4)
c0101840:	01 00 00 00 
				lastkey = i;
c0101844:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101847:	a3 a8 40 15 c0       	mov    %eax,0xc01540a8
				return;
c010184c:	eb 3b                	jmp    c0101889 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c010184e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101852:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101856:	7e cf                	jle    c0101827 <press_key+0x1b>
c0101858:	eb 2f                	jmp    c0101889 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c010185a:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c010185e:	eb 23                	jmp    c0101883 <press_key+0x77>
			if(letter[i]==code){
c0101860:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101863:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c010186a:	3b 45 08             	cmp    0x8(%ebp),%eax
c010186d:	75 10                	jne    c010187f <press_key+0x73>
				keydown[i] = 0;
c010186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101872:	c7 04 85 40 40 15 c0 	movl   $0x0,-0x3feabfc0(,%eax,4)
c0101879:	00 00 00 00 
				return;
c010187d:	eb 0a                	jmp    c0101889 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c010187f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101883:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101887:	7e d7                	jle    c0101860 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101889:	c9                   	leave  
c010188a:	c3                   	ret    

c010188b <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c010188b:	55                   	push   %ebp
c010188c:	89 e5                	mov    %esp,%ebp
c010188e:	83 ec 10             	sub    $0x10,%esp
c0101891:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101898:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010189b:	89 c2                	mov    %eax,%edx
c010189d:	ec                   	in     (%dx),%al
c010189e:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01018a1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01018a5:	0f b6 c0             	movzbl %al,%eax
c01018a8:	83 e0 20             	and    $0x20,%eax
c01018ab:	85 c0                	test   %eax,%eax
c01018ad:	0f 95 c0             	setne  %al
c01018b0:	0f b6 c0             	movzbl %al,%eax
}
c01018b3:	c9                   	leave  
c01018b4:	c3                   	ret    

c01018b5 <serial_printc>:

static inline
void serial_printc(char ch) {
c01018b5:	55                   	push   %ebp
c01018b6:	89 e5                	mov    %esp,%ebp
c01018b8:	83 ec 14             	sub    $0x14,%esp
c01018bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01018be:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01018c1:	90                   	nop
c01018c2:	e8 c4 ff ff ff       	call   c010188b <serial_idle>
c01018c7:	85 c0                	test   %eax,%eax
c01018c9:	74 f7                	je     c01018c2 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01018cb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01018cf:	0f b6 c0             	movzbl %al,%eax
c01018d2:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01018d9:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01018dc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01018e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01018e3:	ee                   	out    %al,(%dx)
}
c01018e4:	c9                   	leave  
c01018e5:	c3                   	ret    

c01018e6 <do_syscall>:
#include "lib/syscall.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();

void do_syscall(struct TrapFrame *tf) {
c01018e6:	55                   	push   %ebp
c01018e7:	89 e5                	mov    %esp,%ebp
c01018e9:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c01018ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01018ef:	8b 40 1c             	mov    0x1c(%eax),%eax
c01018f2:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c01018f7:	0f 84 85 00 00 00    	je     c0101982 <do_syscall+0x9c>
c01018fd:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101902:	77 1a                	ja     c010191e <do_syscall+0x38>
c0101904:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101909:	74 63                	je     c010196e <do_syscall+0x88>
c010190b:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101910:	77 66                	ja     c0101978 <do_syscall+0x92>
c0101912:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101917:	74 3e                	je     c0101957 <do_syscall+0x71>
c0101919:	e9 0d 01 00 00       	jmp    c0101a2b <do_syscall+0x145>
c010191e:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101923:	0f 84 8f 00 00 00    	je     c01019b8 <do_syscall+0xd2>
c0101929:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c010192e:	77 0c                	ja     c010193c <do_syscall+0x56>
c0101930:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101935:	74 5a                	je     c0101991 <do_syscall+0xab>
c0101937:	e9 ef 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
c010193c:	3d 14 05 00 00       	cmp    $0x514,%eax
c0101941:	0f 84 a0 00 00 00    	je     c01019e7 <do_syscall+0x101>
c0101947:	3d 15 05 00 00       	cmp    $0x515,%eax
c010194c:	0f 84 86 00 00 00    	je     c01019d8 <do_syscall+0xf2>
c0101952:	e9 d4 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0101957:	8b 45 08             	mov    0x8(%ebp),%eax
c010195a:	8b 40 10             	mov    0x10(%eax),%eax
c010195d:	0f be c0             	movsbl %al,%eax
c0101960:	50                   	push   %eax
c0101961:	e8 4f ff ff ff       	call   c01018b5 <serial_printc>
c0101966:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
c0101969:	e9 bd 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
		case SYS_INIT_CACHE:
			initVCache();
c010196e:	e8 26 04 00 00       	call   c0101d99 <initVCache>
		break;
c0101973:	e9 b3 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0101978:	e8 51 05 00 00       	call   c0101ece <clearVRAM>
		break;
c010197d:	e9 a9 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0101982:	e8 47 05 00 00       	call   c0101ece <clearVRAM>
			flushVCache();
c0101987:	e8 76 04 00 00       	call   c0101e02 <flushVCache>
		break;
c010198c:	e9 9a 00 00 00       	jmp    c0101a2b <do_syscall+0x145>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0101991:	8b 45 08             	mov    0x8(%ebp),%eax
c0101994:	8b 40 14             	mov    0x14(%eax),%eax
c0101997:	0f b6 c0             	movzbl %al,%eax
c010199a:	8b 55 08             	mov    0x8(%ebp),%edx
c010199d:	8b 52 18             	mov    0x18(%edx),%edx
c01019a0:	89 d1                	mov    %edx,%ecx
c01019a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01019a5:	8b 52 10             	mov    0x10(%edx),%edx
c01019a8:	83 ec 04             	sub    $0x4,%esp
c01019ab:	50                   	push   %eax
c01019ac:	51                   	push   %ecx
c01019ad:	52                   	push   %edx
c01019ae:	e8 b4 04 00 00       	call   c0101e67 <setPixelAt>
c01019b3:	83 c4 10             	add    $0x10,%esp
		break;
c01019b6:	eb 73                	jmp    c0101a2b <do_syscall+0x145>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c01019b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019bb:	8b 40 10             	mov    0x10(%eax),%eax
c01019be:	0f be c0             	movsbl %al,%eax
c01019c1:	83 ec 0c             	sub    $0xc,%esp
c01019c4:	50                   	push   %eax
c01019c5:	e8 19 fe ff ff       	call   c01017e3 <get_key>
c01019ca:	83 c4 10             	add    $0x10,%esp
c01019cd:	0f be d0             	movsbl %al,%edx
c01019d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d3:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01019d6:	eb 53                	jmp    c0101a2b <do_syscall+0x145>
		case SYS_GET_TICK:
			tf->eax = tick();
c01019d8:	e8 ab 05 00 00       	call   c0101f88 <tick>
c01019dd:	89 c2                	mov    %eax,%edx
c01019df:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e2:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c01019e5:	eb 44                	jmp    c0101a2b <do_syscall+0x145>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c01019e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01019ee:	eb 34                	jmp    c0101a24 <do_syscall+0x13e>
				if(!timer_handlers[i].used){
c01019f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f3:	8b 04 c5 04 37 1b c0 	mov    -0x3fe4c8fc(,%eax,8),%eax
c01019fa:	85 c0                	test   %eax,%eax
c01019fc:	75 22                	jne    c0101a20 <do_syscall+0x13a>
					timer_handlers[i].ptr = (void*)tf->ebx;
c01019fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a01:	8b 40 10             	mov    0x10(%eax),%eax
c0101a04:	89 c2                	mov    %eax,%edx
c0101a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a09:	89 14 c5 00 37 1b c0 	mov    %edx,-0x3fe4c900(,%eax,8)
					timer_handlers[i].used = 1;
c0101a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a13:	c7 04 c5 04 37 1b c0 	movl   $0x1,-0x3fe4c8fc(,%eax,8)
c0101a1a:	01 00 00 00 
					break;
c0101a1e:	eb 0a                	jmp    c0101a2a <do_syscall+0x144>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101a20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101a24:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101a28:	7e c6                	jle    c01019f0 <do_syscall+0x10a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c0101a2a:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0101a2b:	c9                   	leave  
c0101a2c:	c3                   	ret    

c0101a2d <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
c0101a30:	83 ec 10             	sub    $0x10,%esp
c0101a33:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a3d:	89 c2                	mov    %eax,%edx
c0101a3f:	ec                   	in     (%dx),%al
c0101a40:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101a43:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101a47:	0f b6 c0             	movzbl %al,%eax
c0101a4a:	83 e0 20             	and    $0x20,%eax
c0101a4d:	85 c0                	test   %eax,%eax
c0101a4f:	0f 95 c0             	setne  %al
c0101a52:	0f b6 c0             	movzbl %al,%eax
}
c0101a55:	c9                   	leave  
c0101a56:	c3                   	ret    

c0101a57 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101a57:	55                   	push   %ebp
c0101a58:	89 e5                	mov    %esp,%ebp
c0101a5a:	83 ec 14             	sub    $0x14,%esp
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101a63:	90                   	nop
c0101a64:	e8 c4 ff ff ff       	call   c0101a2d <serial_idle>
c0101a69:	85 c0                	test   %eax,%eax
c0101a6b:	74 f7                	je     c0101a64 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101a6d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101a71:	0f b6 c0             	movzbl %al,%eax
c0101a74:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101a7b:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101a7e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101a85:	ee                   	out    %al,(%dx)
}
c0101a86:	c9                   	leave  
c0101a87:	c3                   	ret    

c0101a88 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101a88:	55                   	push   %ebp
c0101a89:	89 e5                	mov    %esp,%ebp
c0101a8b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101a8e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a97:	83 ec 04             	sub    $0x4,%esp
c0101a9a:	ff 75 f4             	pushl  -0xc(%ebp)
c0101a9d:	50                   	push   %eax
c0101a9e:	68 57 1a 10 c0       	push   $0xc0101a57
c0101aa3:	e8 63 06 00 00       	call   c010210b <vfprintf>
c0101aa8:	83 c4 10             	add    $0x10,%esp
}
c0101aab:	c9                   	leave  
c0101aac:	c3                   	ret    

c0101aad <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101aad:	55                   	push   %ebp
c0101aae:	89 e5                	mov    %esp,%ebp
c0101ab0:	57                   	push   %edi
c0101ab1:	56                   	push   %esi
c0101ab2:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101ab3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101abc:	89 c1                	mov    %eax,%ecx
c0101abe:	89 d6                	mov    %edx,%esi
c0101ac0:	89 df                	mov    %ebx,%edi
c0101ac2:	fc                   	cld    
c0101ac3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101ac5:	5b                   	pop    %ebx
c0101ac6:	5e                   	pop    %esi
c0101ac7:	5f                   	pop    %edi
c0101ac8:	5d                   	pop    %ebp
c0101ac9:	c3                   	ret    

c0101aca <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101aca:	55                   	push   %ebp
c0101acb:	89 e5                	mov    %esp,%ebp
c0101acd:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101ad0:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ad3:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101ad8:	77 16                	ja     c0101af0 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101ada:	ff 75 10             	pushl  0x10(%ebp)
c0101add:	68 e8 24 10 c0       	push   $0xc01024e8
c0101ae2:	ff 75 0c             	pushl  0xc(%ebp)
c0101ae5:	ff 75 08             	pushl  0x8(%ebp)
c0101ae8:	e8 9b ff ff ff       	call   c0101a88 <printk>
c0101aed:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101af0:	8b 45 10             	mov    0x10(%ebp),%eax
c0101af3:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101af8:	c9                   	leave  
c0101af9:	c3                   	ret    

c0101afa <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0101afa:	55                   	push   %ebp
c0101afb:	89 e5                	mov    %esp,%ebp
c0101afd:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0101b00:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b03:	c1 e8 0c             	shr    $0xc,%eax
c0101b06:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0101b0b:	76 13                	jbe    c0101b20 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0101b0d:	83 ec 08             	sub    $0x8,%esp
c0101b10:	ff 75 10             	pushl  0x10(%ebp)
c0101b13:	68 0c 25 10 c0       	push   $0xc010250c
c0101b18:	e8 6b ff ff ff       	call   c0101a88 <printk>
c0101b1d:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0101b20:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b23:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0101b28:	c9                   	leave  
c0101b29:	c3                   	ret    

c0101b2a <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0101b2a:	55                   	push   %ebp
c0101b2b:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b30:	ba 00 37 17 c0       	mov    $0xc0173700,%edx
c0101b35:	29 d0                	sub    %edx,%eax
c0101b37:	c1 f8 03             	sar    $0x3,%eax
c0101b3a:	c1 e0 0c             	shl    $0xc,%eax
}
c0101b3d:	5d                   	pop    %ebp
c0101b3e:	c3                   	ret    

c0101b3f <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c0101b3f:	55                   	push   %ebp
c0101b40:	89 e5                	mov    %esp,%ebp
c0101b42:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0101b45:	ff 75 08             	pushl  0x8(%ebp)
c0101b48:	e8 dd ff ff ff       	call   c0101b2a <page2pa>
c0101b4d:	83 c4 04             	add    $0x4,%esp
c0101b50:	83 ec 04             	sub    $0x4,%esp
c0101b53:	50                   	push   %eax
c0101b54:	6a 52                	push   $0x52
c0101b56:	68 2e 25 10 c0       	push   $0xc010252e
c0101b5b:	e8 9a ff ff ff       	call   c0101afa <_kaddr>
c0101b60:	83 c4 10             	add    $0x10,%esp
}
c0101b63:	c9                   	leave  
c0101b64:	c3                   	ret    

c0101b65 <init_pcb_pool>:
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_pcb_pool()
{
c0101b65:	55                   	push   %ebp
c0101b66:	89 e5                	mov    %esp,%ebp
c0101b68:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b72:	eb 1d                	jmp    c0101b91 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0101b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101b77:	c1 e0 05             	shl    $0x5,%eax
c0101b7a:	89 c2                	mov    %eax,%edx
c0101b7c:	c1 e2 09             	shl    $0x9,%edx
c0101b7f:	01 d0                	add    %edx,%eax
c0101b81:	05 40 64 1b c0       	add    $0xc01b6440,%eax
c0101b86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
};*/

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101b8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b91:	83 7d fc 63          	cmpl   $0x63,-0x4(%ebp)
c0101b95:	76 dd                	jbe    c0101b74 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
}
c0101b97:	c9                   	leave  
c0101b98:	c3                   	ret    

c0101b99 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0101b99:	55                   	push   %ebp
c0101b9a:	89 e5                	mov    %esp,%ebp
c0101b9c:	83 ec 14             	sub    $0x14,%esp
c0101b9f:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba2:	88 45 ec             	mov    %al,-0x14(%ebp)
	struct TrapFrame *tf = (p->tf);
c0101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba8:	8b 40 08             	mov    0x8(%eax),%eax
c0101bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(pri == 0){
c0101bae:	80 7d ec 00          	cmpb   $0x0,-0x14(%ebp)
c0101bb2:	75 46                	jne    c0101bfa <init_pcb+0x61>
		tf->ds = GD_KD;
c0101bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bb7:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0101bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bc1:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0101bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bcb:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0101bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bd4:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0101bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bde:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0101be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101be8:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0101bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101bf1:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0101bf8:	eb 4a                	jmp    c0101c44 <init_pcb+0xab>
	}else
	if(pri == 3){
c0101bfa:	80 7d ec 03          	cmpb   $0x3,-0x14(%ebp)
c0101bfe:	75 44                	jne    c0101c44 <init_pcb+0xab>
		tf->ds = GD_UD | 3;
c0101c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c03:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0101c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c0d:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0101c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c17:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0101c1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c20:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0101c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c2a:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0101c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c34:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0101c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c3d:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0101c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c47:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c4a:	89 50 44             	mov    %edx,0x44(%eax)
	tf->eip = entry;
c0101c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c50:	8b 55 10             	mov    0x10(%ebp),%edx
c0101c53:	89 50 38             	mov    %edx,0x38(%eax)
}
c0101c56:	c9                   	leave  
c0101c57:	c3                   	ret    

c0101c58 <pcb_create>:

PCB* pcb_create()
{
c0101c58:	55                   	push   %ebp
c0101c59:	89 e5                	mov    %esp,%ebp
c0101c5b:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c65:	eb 1f                	jmp    c0101c86 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0101c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c6a:	c1 e0 05             	shl    $0x5,%eax
c0101c6d:	89 c2                	mov    %eax,%edx
c0101c6f:	c1 e2 09             	shl    $0x9,%edx
c0101c72:	01 d0                	add    %edx,%eax
c0101c74:	05 40 64 1b c0       	add    $0xc01b6440,%eax
c0101c79:	8b 40 04             	mov    0x4(%eax),%eax
c0101c7c:	85 c0                	test   %eax,%eax
c0101c7e:	75 02                	jne    c0101c82 <pcb_create+0x2a>
c0101c80:	eb 0a                	jmp    c0101c8c <pcb_create+0x34>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101c82:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c86:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101c8a:	76 db                	jbe    c0101c67 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c8f:	c1 e0 05             	shl    $0x5,%eax
c0101c92:	89 c2                	mov    %eax,%edx
c0101c94:	c1 e2 09             	shl    $0x9,%edx
c0101c97:	01 d0                	add    %edx,%eax
c0101c99:	05 40 64 1b c0       	add    $0xc01b6440,%eax
c0101c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0101ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ca4:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0101ca7:	8d 90 80 46 1b c0    	lea    -0x3fe4b980(%eax),%edx
c0101cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb0:	89 50 08             	mov    %edx,0x8(%eax)
	p->used = 1;
c0101cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb6:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0101cbd:	83 ec 0c             	sub    $0xc,%esp
c0101cc0:	6a 01                	push   $0x1
c0101cc2:	e8 95 eb ff ff       	call   c010085c <page_alloc>
c0101cc7:	83 c4 10             	add    $0x10,%esp
c0101cca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0101ccd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0101cd1:	75 07                	jne    c0101cda <pcb_create+0x82>
c0101cd3:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cd8:	eb 60                	jmp    c0101d3a <pcb_create+0xe2>
	p->pgdir = page2kva(pp);
c0101cda:	83 ec 0c             	sub    $0xc,%esp
c0101cdd:	ff 75 ec             	pushl  -0x14(%ebp)
c0101ce0:	e8 5a fe ff ff       	call   c0101b3f <page2kva>
c0101ce5:	83 c4 10             	add    $0x10,%esp
c0101ce8:	89 c2                	mov    %eax,%edx
c0101cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ced:	89 50 0c             	mov    %edx,0xc(%eax)
	p->pid = pid;
c0101cf0:	8b 15 ac 40 15 c0    	mov    0xc01540ac,%edx
c0101cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cf9:	89 10                	mov    %edx,(%eax)
	pid ++;
c0101cfb:	a1 ac 40 15 c0       	mov    0xc01540ac,%eax
c0101d00:	83 c0 01             	add    $0x1,%eax
c0101d03:	a3 ac 40 15 c0       	mov    %eax,0xc01540ac
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0101d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101d0b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0101d0f:	8d 50 01             	lea    0x1(%eax),%edx
c0101d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101d15:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c0101d19:	8b 15 c0 36 17 c0    	mov    0xc01736c0,%edx
c0101d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d22:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d25:	83 ec 04             	sub    $0x4,%esp
c0101d28:	68 00 10 00 00       	push   $0x1000
c0101d2d:	52                   	push   %edx
c0101d2e:	50                   	push   %eax
c0101d2f:	e8 79 fd ff ff       	call   c0101aad <memcpy>
c0101d34:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c0101d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0101d3a:	c9                   	leave  
c0101d3b:	c3                   	ret    

c0101d3c <switch_pcb>:

void switch_pcb(PCB* pcb){
c0101d3c:	55                   	push   %ebp
c0101d3d:	89 e5                	mov    %esp,%ebp
c0101d3f:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c0101d42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d45:	a3 40 46 1b c0       	mov    %eax,0xc01b4640
	lcr3(PADDR(pcb -> pgdir));
c0101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d50:	83 ec 04             	sub    $0x4,%esp
c0101d53:	50                   	push   %eax
c0101d54:	6a 51                	push   $0x51
c0101d56:	68 44 25 10 c0       	push   $0xc0102544
c0101d5b:	e8 6a fd ff ff       	call   c0101aca <_paddr>
c0101d60:	83 c4 10             	add    $0x10,%esp
c0101d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d69:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0101d6c:	83 ec 0c             	sub    $0xc,%esp
c0101d6f:	ff 75 08             	pushl  0x8(%ebp)
c0101d72:	e8 e5 e5 ff ff       	call   c010035c <enter_pcb>
c0101d77:	83 c4 10             	add    $0x10,%esp
}
c0101d7a:	c9                   	leave  
c0101d7b:	c3                   	ret    

c0101d7c <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0101d7c:	55                   	push   %ebp
c0101d7d:	89 e5                	mov    %esp,%ebp
c0101d7f:	57                   	push   %edi
c0101d80:	56                   	push   %esi
c0101d81:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101d82:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d88:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101d8b:	89 c1                	mov    %eax,%ecx
c0101d8d:	89 d6                	mov    %edx,%esi
c0101d8f:	89 df                	mov    %ebx,%edi
c0101d91:	fc                   	cld    
c0101d92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101d94:	5b                   	pop    %ebx
c0101d95:	5e                   	pop    %esi
c0101d96:	5f                   	pop    %edi
c0101d97:	5d                   	pop    %ebp
c0101d98:	c3                   	ret    

c0101d99 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0101d99:	55                   	push   %ebp
c0101d9a:	89 e5                	mov    %esp,%ebp
c0101d9c:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0101d9f:	68 80 3e 00 00       	push   $0x3e80
c0101da4:	68 c0 3a 16 c0       	push   $0xc0163ac0
c0101da9:	68 c0 40 15 c0       	push   $0xc01540c0
c0101dae:	e8 c9 ff ff ff       	call   c0101d7c <memcpy>
c0101db3:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0101db6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101dbd:	eb 0f                	jmp    c0101dce <initVCache+0x35>
		VDIRTY[x] = 0;
c0101dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dc2:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0101dc7:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0101dca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101dce:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101dd5:	7e e8                	jle    c0101dbf <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0101dd7:	c9                   	leave  
c0101dd8:	c3                   	ret    

c0101dd9 <refreshVCache>:
void refreshVCache(){
c0101dd9:	55                   	push   %ebp
c0101dda:	89 e5                	mov    %esp,%ebp
c0101ddc:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101ddf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101de6:	eb 0f                	jmp    c0101df7 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0101de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101deb:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0101df0:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0101df3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101df7:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101dfe:	7e e8                	jle    c0101de8 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0101e00:	c9                   	leave  
c0101e01:	c3                   	ret    

c0101e02 <flushVCache>:
void flushVCache(){
c0101e02:	55                   	push   %ebp
c0101e03:	89 e5                	mov    %esp,%ebp
c0101e05:	53                   	push   %ebx
c0101e06:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101e09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101e10:	eb 47                	jmp    c0101e59 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0101e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e15:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0101e1a:	0f b6 00             	movzbl (%eax),%eax
c0101e1d:	84 c0                	test   %al,%al
c0101e1f:	74 34                	je     c0101e55 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0101e21:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101e24:	89 d0                	mov    %edx,%eax
c0101e26:	c1 e0 02             	shl    $0x2,%eax
c0101e29:	01 d0                	add    %edx,%eax
c0101e2b:	c1 e0 06             	shl    $0x6,%eax
c0101e2e:	8d 88 c0 40 15 c0    	lea    -0x3feabf40(%eax),%ecx
c0101e34:	8b 1d a8 60 10 c0    	mov    0xc01060a8,%ebx
c0101e3a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101e3d:	89 d0                	mov    %edx,%eax
c0101e3f:	c1 e0 02             	shl    $0x2,%eax
c0101e42:	01 d0                	add    %edx,%eax
c0101e44:	c1 e0 06             	shl    $0x6,%eax
c0101e47:	01 d8                	add    %ebx,%eax
c0101e49:	6a 50                	push   $0x50
c0101e4b:	51                   	push   %ecx
c0101e4c:	50                   	push   %eax
c0101e4d:	e8 2a ff ff ff       	call   c0101d7c <memcpy>
c0101e52:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0101e55:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101e59:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0101e60:	7e b0                	jle    c0101e12 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0101e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101e65:	c9                   	leave  
c0101e66:	c3                   	ret    

c0101e67 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0101e67:	55                   	push   %ebp
c0101e68:	89 e5                	mov    %esp,%ebp
c0101e6a:	83 ec 04             	sub    $0x4,%esp
c0101e6d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e70:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0101e73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101e77:	78 18                	js     c0101e91 <setPixelAt+0x2a>
c0101e79:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0101e80:	7f 0f                	jg     c0101e91 <setPixelAt+0x2a>
c0101e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101e86:	78 09                	js     c0101e91 <setPixelAt+0x2a>
c0101e88:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0101e8f:	7e 02                	jle    c0101e93 <setPixelAt+0x2c>
c0101e91:	eb 34                	jmp    c0101ec7 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0101e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e96:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0101e9b:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea1:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c0101ea6:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0101ea9:	8b 55 08             	mov    0x8(%ebp),%edx
c0101eac:	89 d0                	mov    %edx,%eax
c0101eae:	c1 e0 02             	shl    $0x2,%eax
c0101eb1:	01 d0                	add    %edx,%eax
c0101eb3:	c1 e0 06             	shl    $0x6,%eax
c0101eb6:	89 c2                	mov    %eax,%edx
c0101eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ebb:	01 c2                	add    %eax,%edx
c0101ebd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0101ec1:	88 82 c0 40 15 c0    	mov    %al,-0x3feabf40(%edx)
}
c0101ec7:	c9                   	leave  
c0101ec8:	c3                   	ret    

c0101ec9 <forceClearVRAM>:
void forceClearVRAM(){
c0101ec9:	55                   	push   %ebp
c0101eca:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0101ecc:	5d                   	pop    %ebp
c0101ecd:	c3                   	ret    

c0101ece <clearVRAM>:
void clearVRAM(){
c0101ece:	55                   	push   %ebp
c0101ecf:	89 e5                	mov    %esp,%ebp
c0101ed1:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101edb:	eb 4e                	jmp    c0101f2b <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0101edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ee0:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c0101ee5:	0f b6 00             	movzbl (%eax),%eax
c0101ee8:	0f b6 c0             	movzbl %al,%eax
c0101eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101eee:	81 c2 c0 34 17 c0    	add    $0xc01734c0,%edx
c0101ef4:	0f b6 12             	movzbl (%edx),%edx
c0101ef7:	0f b6 d2             	movzbl %dl,%edx
c0101efa:	f7 d2                	not    %edx
c0101efc:	21 d0                	and    %edx,%eax
c0101efe:	85 c0                	test   %eax,%eax
c0101f00:	74 25                	je     c0101f27 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0101f02:	8b 0d a8 60 10 c0    	mov    0xc01060a8,%ecx
c0101f08:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101f0b:	89 d0                	mov    %edx,%eax
c0101f0d:	c1 e0 02             	shl    $0x2,%eax
c0101f10:	01 d0                	add    %edx,%eax
c0101f12:	c1 e0 06             	shl    $0x6,%eax
c0101f15:	01 c8                	add    %ecx,%eax
c0101f17:	6a 50                	push   $0x50
c0101f19:	68 c0 3a 16 c0       	push   $0xc0163ac0
c0101f1e:	50                   	push   %eax
c0101f1f:	e8 58 fe ff ff       	call   c0101d7c <memcpy>
c0101f24:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0101f27:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101f2b:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0101f32:	7e a9                	jle    c0101edd <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0101f34:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c0101f3b:	83 c0 01             	add    $0x1,%eax
c0101f3e:	a2 88 36 17 c0       	mov    %al,0xc0173688
	if(stamp==30){
c0101f43:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c0101f4a:	3c 1e                	cmp    $0x1e,%al
c0101f4c:	75 07                	jne    c0101f55 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0101f4e:	c6 05 88 36 17 c0 00 	movb   $0x0,0xc0173688
		//printk("What matters\n");
	}
	if(stamp==0){
c0101f55:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c0101f5c:	84 c0                	test   %al,%al
c0101f5e:	75 14                	jne    c0101f74 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0101f60:	6a 32                	push   $0x32
c0101f62:	68 c0 3a 16 c0       	push   $0xc0163ac0
c0101f67:	68 c0 35 17 c0       	push   $0xc01735c0
c0101f6c:	e8 0b fe ff ff       	call   c0101d7c <memcpy>
c0101f71:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0101f74:	c9                   	leave  
c0101f75:	c3                   	ret    

c0101f76 <do_timer>:
#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
c0101f76:	55                   	push   %ebp
c0101f77:	89 e5                	mov    %esp,%ebp
	_tick++;
c0101f79:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c0101f7e:	83 c0 01             	add    $0x1,%eax
c0101f81:	a3 8c 36 17 c0       	mov    %eax,0xc017368c
	//printk("%x", _tick);
}
c0101f86:	5d                   	pop    %ebp
c0101f87:	c3                   	ret    

c0101f88 <tick>:
uint32_t tick(){
c0101f88:	55                   	push   %ebp
c0101f89:	89 e5                	mov    %esp,%ebp
	return _tick;
c0101f8b:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c0101f90:	5d                   	pop    %ebp
c0101f91:	c3                   	ret    

c0101f92 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0101f92:	6a 00                	push   $0x0
c0101f94:	6a 00                	push   $0x0
c0101f96:	e9 b8 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101f9b <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0101f9b:	6a 00                	push   $0x0
c0101f9d:	6a 01                	push   $0x1
c0101f9f:	e9 af 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fa4 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0101fa4:	6a 00                	push   $0x0
c0101fa6:	6a 02                	push   $0x2
c0101fa8:	e9 a6 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fad <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0101fad:	6a 00                	push   $0x0
c0101faf:	6a 03                	push   $0x3
c0101fb1:	e9 9d 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fb6 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0101fb6:	6a 00                	push   $0x0
c0101fb8:	6a 04                	push   $0x4
c0101fba:	e9 94 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fbf <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0101fbf:	6a 00                	push   $0x0
c0101fc1:	6a 05                	push   $0x5
c0101fc3:	e9 8b 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fc8 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0101fc8:	6a 00                	push   $0x0
c0101fca:	6a 06                	push   $0x6
c0101fcc:	e9 82 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fd1 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0101fd1:	6a 00                	push   $0x0
c0101fd3:	6a 07                	push   $0x7
c0101fd5:	e9 79 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fda <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0101fda:	6a 00                	push   $0x0
c0101fdc:	6a 08                	push   $0x8
c0101fde:	e9 70 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fe3 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0101fe3:	6a 00                	push   $0x0
c0101fe5:	6a 09                	push   $0x9
c0101fe7:	e9 67 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101fec <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0101fec:	6a 00                	push   $0x0
c0101fee:	6a 0a                	push   $0xa
c0101ff0:	e9 5e 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101ff5 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0101ff5:	6a 00                	push   $0x0
c0101ff7:	6a 0b                	push   $0xb
c0101ff9:	e9 55 00 00 00       	jmp    c0102053 <asm_do_irq>

c0101ffe <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0101ffe:	6a 00                	push   $0x0
c0102000:	6a 0c                	push   $0xc
c0102002:	e9 4c 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102007 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0102007:	6a 00                	push   $0x0
c0102009:	6a 0d                	push   $0xd
c010200b:	e9 43 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102010 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102010:	6a 00                	push   $0x0
c0102012:	6a 0e                	push   $0xe
c0102014:	e9 3a 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102019 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102019:	fa                   	cli    
c010201a:	6a 00                	push   $0x0
c010201c:	68 80 00 00 00       	push   $0x80
c0102021:	e9 2d 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102026 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102026:	6a 00                	push   $0x0
c0102028:	68 e8 03 00 00       	push   $0x3e8
c010202d:	e9 21 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102032 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102032:	6a 00                	push   $0x0
c0102034:	68 e9 03 00 00       	push   $0x3e9
c0102039:	e9 15 00 00 00       	jmp    c0102053 <asm_do_irq>

c010203e <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c010203e:	6a 00                	push   $0x0
c0102040:	68 f6 03 00 00       	push   $0x3f6
c0102045:	e9 09 00 00 00       	jmp    c0102053 <asm_do_irq>

c010204a <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c010204a:	6a 00                	push   $0x0
c010204c:	6a ff                	push   $0xffffffff
c010204e:	e9 00 00 00 00       	jmp    c0102053 <asm_do_irq>

c0102053 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0102053:	fa                   	cli    
  pushl %ds
c0102054:	1e                   	push   %ds
  pushl %es
c0102055:	06                   	push   %es
  pushl %fs
c0102056:	0f a0                	push   %fs
  pushl %gs
c0102058:	0f a8                	push   %gs
	pushal
c010205a:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c010205b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c010205f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102061:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0102063:	54                   	push   %esp
  call irq_handle
c0102064:	e8 d9 ec ff ff       	call   c0100d42 <irq_handle>
  addl $4, %esp
c0102069:	83 c4 04             	add    $0x4,%esp

c010206c <switch_proc>:
switch_proc:
  popal
c010206c:	61                   	popa   
  popl %gs
c010206d:	0f a9                	pop    %gs
  popl %fs
c010206f:	0f a1                	pop    %fs
  popl %es
c0102071:	07                   	pop    %es
  popl %ds
c0102072:	1f                   	pop    %ds
  addl $8, %esp
c0102073:	83 c4 08             	add    $0x8,%esp
  sti
c0102076:	fb                   	sti    
c0102077:	cf                   	iret   
c0102078:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c010207e:	00 00                	add    %al,(%eax)
c0102080:	fe 4f 52             	decb   0x52(%edi)
c0102083:	e4 66                	in     $0x66,%al

c0102084 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0102084:	66 c7 05 72 04 00 00 34 12 b8 00 50 10 00 0f 22     f..r...4...P..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0102094:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 a7 20 10     .. ......."... .
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c01020a4:	c0 ff e0                                            ...

c01020a7 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c01020a7:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c01020ac:	bc 00 f0 10 c0       	mov    $0xc010f000,%esp

	# now to C code

	call	main
c01020b1:	e8 b9 f2 ff ff       	call   c010136f <main>

c01020b6 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c01020b6:	eb fe                	jmp    c01020b6 <spin>

c01020b8 <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
c01020b8:	55                   	push   %ebp
c01020b9:	89 e5                	mov    %esp,%ebp
c01020bb:	53                   	push   %ebx
c01020bc:	83 ec 04             	sub    $0x4,%esp
c01020bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c2:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c01020c5:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c01020ca:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c01020ce:	89 d3                	mov    %edx,%ebx
c01020d0:	cd 80                	int    $0x80
}
c01020d2:	83 c4 04             	add    $0x4,%esp
c01020d5:	5b                   	pop    %ebx
c01020d6:	5d                   	pop    %ebp
c01020d7:	c3                   	ret    

c01020d8 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c01020d8:	55                   	push   %ebp
c01020d9:	89 e5                	mov    %esp,%ebp
c01020db:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c01020de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01020e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c01020e4:	eb 19                	jmp    c01020ff <printp+0x27>
		printer(cur);
c01020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01020e9:	0f b6 00             	movzbl (%eax),%eax
c01020ec:	0f be c0             	movsbl %al,%eax
c01020ef:	83 ec 0c             	sub    $0xc,%esp
c01020f2:	50                   	push   %eax
c01020f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f6:	ff d0                	call   *%eax
c01020f8:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c01020fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102102:	0f b6 00             	movzbl (%eax),%eax
c0102105:	84 c0                	test   %al,%al
c0102107:	75 dd                	jne    c01020e6 <printp+0xe>
		printer(cur);
	}
}
c0102109:	c9                   	leave  
c010210a:	c3                   	ret    

c010210b <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c010210b:	55                   	push   %ebp
c010210c:	89 e5                	mov    %esp,%ebp
c010210e:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102111:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0102117:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c010211e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0102125:	8b 45 10             	mov    0x10(%ebp),%eax
c0102128:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c010212b:	e9 65 02 00 00       	jmp    c0102395 <vfprintf+0x28a>

		if(cur == '%'){
c0102130:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102133:	0f b6 00             	movzbl (%eax),%eax
c0102136:	3c 25                	cmp    $0x25,%al
c0102138:	75 0c                	jne    c0102146 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c010213a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0102141:	e9 4b 02 00 00       	jmp    c0102391 <vfprintf+0x286>
		}
		if(type == READ){
c0102146:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c010214a:	0f 85 26 02 00 00    	jne    c0102376 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0102150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102153:	0f b6 00             	movzbl (%eax),%eax
c0102156:	3c 73                	cmp    $0x73,%al
c0102158:	75 35                	jne    c010218f <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c010215a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010215d:	8b 00                	mov    (%eax),%eax
c010215f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0102162:	eb 19                	jmp    c010217d <vfprintf+0x72>
					printer(*p);
c0102164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102167:	0f b6 00             	movzbl (%eax),%eax
c010216a:	0f be c0             	movsbl %al,%eax
c010216d:	83 ec 0c             	sub    $0xc,%esp
c0102170:	50                   	push   %eax
c0102171:	8b 45 08             	mov    0x8(%ebp),%eax
c0102174:	ff d0                	call   *%eax
c0102176:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0102179:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c010217d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102180:	0f b6 00             	movzbl (%eax),%eax
c0102183:	84 c0                	test   %al,%al
c0102185:	75 dd                	jne    c0102164 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0102187:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010218b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c010218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102192:	0f b6 00             	movzbl (%eax),%eax
c0102195:	3c 78                	cmp    $0x78,%al
c0102197:	0f 85 99 00 00 00    	jne    c0102236 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c010219d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01021a0:	8b 00                	mov    (%eax),%eax
c01021a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c01021a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01021a9:	75 1d                	jne    c01021c8 <vfprintf+0xbd>
					printer('0');
c01021ab:	83 ec 0c             	sub    $0xc,%esp
c01021ae:	6a 30                	push   $0x30
c01021b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b3:	ff d0                	call   *%eax
c01021b5:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01021b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01021bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01021c3:	e9 c9 01 00 00       	jmp    c0102391 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c01021c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c01021cf:	eb 2d                	jmp    c01021fe <vfprintf+0xf3>
					int d=(x%16);
c01021d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01021d4:	83 e0 0f             	and    $0xf,%eax
c01021d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c01021da:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c01021de:	7e 04                	jle    c01021e4 <vfprintf+0xd9>
						d+='a'-'0'-10;
c01021e0:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c01021e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01021e7:	83 c0 30             	add    $0x30,%eax
c01021ea:	89 c1                	mov    %eax,%ecx
c01021ec:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c01021ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01021f2:	01 d0                	add    %edx,%eax
c01021f4:	88 08                	mov    %cl,(%eax)
					x>>=4;
c01021f6:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c01021fa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c01021fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102202:	75 cd                	jne    c01021d1 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0102204:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0102208:	eb 1e                	jmp    c0102228 <vfprintf+0x11d>
					printer(digits[di]);
c010220a:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010220d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102210:	01 d0                	add    %edx,%eax
c0102212:	0f b6 00             	movzbl (%eax),%eax
c0102215:	0f be c0             	movsbl %al,%eax
c0102218:	83 ec 0c             	sub    $0xc,%esp
c010221b:	50                   	push   %eax
c010221c:	8b 45 08             	mov    0x8(%ebp),%eax
c010221f:	ff d0                	call   *%eax
c0102221:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0102224:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0102228:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010222c:	79 dc                	jns    c010220a <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010222e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102232:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0102236:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102239:	0f b6 00             	movzbl (%eax),%eax
c010223c:	3c 64                	cmp    $0x64,%al
c010223e:	0f 85 02 01 00 00    	jne    c0102346 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c0102244:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102247:	8b 00                	mov    (%eax),%eax
c0102249:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c010224c:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c0102253:	75 23                	jne    c0102278 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c0102255:	83 ec 08             	sub    $0x8,%esp
c0102258:	68 59 25 10 c0       	push   $0xc0102559
c010225d:	ff 75 08             	pushl  0x8(%ebp)
c0102260:	e8 73 fe ff ff       	call   c01020d8 <printp>
c0102265:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102268:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010226c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0102273:	e9 19 01 00 00       	jmp    c0102391 <vfprintf+0x286>
				}
				if(x==0){
c0102278:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010227c:	75 1e                	jne    c010229c <vfprintf+0x191>
					printer('0');
c010227e:	83 ec 0c             	sub    $0xc,%esp
c0102281:	6a 30                	push   $0x30
c0102283:	8b 45 08             	mov    0x8(%ebp),%eax
c0102286:	ff d0                	call   *%eax
c0102288:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c010228b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010228f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c0102296:	90                   	nop
c0102297:	e9 f5 00 00 00       	jmp    c0102391 <vfprintf+0x286>
				}
				if(x<0){
c010229c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01022a0:	79 10                	jns    c01022b2 <vfprintf+0x1a7>
					printer('-');
c01022a2:	83 ec 0c             	sub    $0xc,%esp
c01022a5:	6a 2d                	push   $0x2d
c01022a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01022aa:	ff d0                	call   *%eax
c01022ac:	83 c4 10             	add    $0x10,%esp
					x=-x;
c01022af:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c01022b2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c01022b9:	eb 53                	jmp    c010230e <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c01022bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01022be:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01022c3:	89 c8                	mov    %ecx,%eax
c01022c5:	f7 ea                	imul   %edx
c01022c7:	c1 fa 02             	sar    $0x2,%edx
c01022ca:	89 c8                	mov    %ecx,%eax
c01022cc:	c1 f8 1f             	sar    $0x1f,%eax
c01022cf:	29 c2                	sub    %eax,%edx
c01022d1:	89 d0                	mov    %edx,%eax
c01022d3:	c1 e0 02             	shl    $0x2,%eax
c01022d6:	01 d0                	add    %edx,%eax
c01022d8:	01 c0                	add    %eax,%eax
c01022da:	29 c1                	sub    %eax,%ecx
c01022dc:	89 ca                	mov    %ecx,%edx
c01022de:	89 d0                	mov    %edx,%eax
c01022e0:	83 c0 30             	add    $0x30,%eax
c01022e3:	89 c1                	mov    %eax,%ecx
c01022e5:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c01022e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01022eb:	01 d0                	add    %edx,%eax
c01022ed:	88 08                	mov    %cl,(%eax)
					x/=10;
c01022ef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01022f2:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01022f7:	89 c8                	mov    %ecx,%eax
c01022f9:	f7 ea                	imul   %edx
c01022fb:	c1 fa 02             	sar    $0x2,%edx
c01022fe:	89 c8                	mov    %ecx,%eax
c0102300:	c1 f8 1f             	sar    $0x1f,%eax
c0102303:	29 c2                	sub    %eax,%edx
c0102305:	89 d0                	mov    %edx,%eax
c0102307:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010230a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010230e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102312:	7f a7                	jg     c01022bb <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0102314:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0102318:	eb 1e                	jmp    c0102338 <vfprintf+0x22d>
					printer(digits[di]);
c010231a:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c010231d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102320:	01 d0                	add    %edx,%eax
c0102322:	0f b6 00             	movzbl (%eax),%eax
c0102325:	0f be c0             	movsbl %al,%eax
c0102328:	83 ec 0c             	sub    $0xc,%esp
c010232b:	50                   	push   %eax
c010232c:	8b 45 08             	mov    0x8(%ebp),%eax
c010232f:	ff d0                	call   *%eax
c0102331:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0102334:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0102338:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010233c:	79 dc                	jns    c010231a <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010233e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102342:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c0102346:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102349:	0f b6 00             	movzbl (%eax),%eax
c010234c:	3c 63                	cmp    $0x63,%al
c010234e:	75 1d                	jne    c010236d <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0102350:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102353:	0f b6 00             	movzbl (%eax),%eax
c0102356:	0f be c0             	movsbl %al,%eax
c0102359:	83 ec 0c             	sub    $0xc,%esp
c010235c:	50                   	push   %eax
c010235d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102360:	ff d0                	call   *%eax
c0102362:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c0102365:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102369:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c010236d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c0102374:	eb 1b                	jmp    c0102391 <vfprintf+0x286>
		}
		if(type == NONE){
c0102376:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010237a:	75 15                	jne    c0102391 <vfprintf+0x286>
			printer(cur);
c010237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010237f:	0f b6 00             	movzbl (%eax),%eax
c0102382:	0f be c0             	movsbl %al,%eax
c0102385:	83 ec 0c             	sub    $0xc,%esp
c0102388:	50                   	push   %eax
c0102389:	8b 45 08             	mov    0x8(%ebp),%eax
c010238c:	ff d0                	call   *%eax
c010238e:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102391:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102398:	0f b6 00             	movzbl (%eax),%eax
c010239b:	84 c0                	test   %al,%al
c010239d:	0f 85 8d fd ff ff    	jne    c0102130 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c01023a3:	c9                   	leave  
c01023a4:	c3                   	ret    

c01023a5 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c01023a5:	55                   	push   %ebp
c01023a6:	89 e5                	mov    %esp,%ebp
c01023a8:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01023ab:	8d 45 0c             	lea    0xc(%ebp),%eax
c01023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c01023b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b4:	83 ec 04             	sub    $0x4,%esp
c01023b7:	ff 75 f4             	pushl  -0xc(%ebp)
c01023ba:	50                   	push   %eax
c01023bb:	68 b8 20 10 c0       	push   $0xc01020b8
c01023c0:	e8 46 fd ff ff       	call   c010210b <vfprintf>
c01023c5:	83 c4 10             	add    $0x10,%esp
}
c01023c8:	c9                   	leave  
c01023c9:	c3                   	ret    
