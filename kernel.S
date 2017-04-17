
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
c01000ba:	e8 64 25 00 00       	call   c0102623 <vfprintf>
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
c01000f0:	68 e4 28 10 c0       	push   $0xc01028e4
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
c0100371:	68 07 29 10 c0       	push   $0xc0102907
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
c0100415:	68 07 29 10 c0       	push   $0xc0102907
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
c010044a:	b8 84 25 10 c0       	mov    $0xc0102584,%eax
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
c0100585:	e8 99 20 00 00       	call   c0102623 <vfprintf>
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
c01005bb:	68 20 29 10 c0       	push   $0xc0102920
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
c01005f1:	68 44 29 10 c0       	push   $0xc0102944
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
c0100633:	68 68 29 10 c0       	push   $0xc0102968
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
c0100667:	68 87 29 10 c0       	push   $0xc0102987
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
c0100732:	68 9d 29 10 c0       	push   $0xc010299d
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
c0100793:	68 9d 29 10 c0       	push   $0xc010299d
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
c0100954:	68 9d 29 10 c0       	push   $0xc010299d
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
c01009d0:	68 9d 29 10 c0       	push   $0xc010299d
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
c0100c27:	68 9d 29 10 c0       	push   $0xc010299d
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
c0100cec:	83 ec 18             	sub    $0x18,%esp
	count ++;
c0100cef:	a1 04 40 15 c0       	mov    0xc0154004,%eax
c0100cf4:	83 c0 01             	add    $0x1,%eax
c0100cf7:	a3 04 40 15 c0       	mov    %eax,0xc0154004

	if(current == NULL){
c0100cfc:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d01:	85 c0                	test   %eax,%eax
c0100d03:	75 5d                	jne    c0100d62 <do_scheduler+0x79>
		current = ready_list;
c0100d05:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c0100d0a:	a3 b0 40 15 c0       	mov    %eax,0xc01540b0
		ready_list = ready_list -> next;
c0100d0f:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c0100d14:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100d1a:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4

		//current->tail = current;
		//current->next = NULL;
		current->ts = RUNNING;
c0100d1f:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d24:	c7 80 3c 40 00 00 01 	movl   $0x1,0x403c(%eax)
c0100d2b:	00 00 00 
		current->timeslice = 0;
c0100d2e:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d33:	c7 80 40 40 00 00 00 	movl   $0x0,0x4040(%eax)
c0100d3a:	00 00 00 
		current->next = NULL;
c0100d3d:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d42:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0100d49:	00 00 00 
		scheduler_switch(current);
c0100d4c:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d51:	83 ec 0c             	sub    $0xc,%esp
c0100d54:	50                   	push   %eax
c0100d55:	e8 9b f6 ff ff       	call   c01003f5 <scheduler_switch>
c0100d5a:	83 c4 10             	add    $0x10,%esp
		return;
c0100d5d:	e9 fa 00 00 00       	jmp    c0100e5c <do_scheduler+0x173>
	}
	if(current->ts == SLEEPING){
c0100d62:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d67:	8b 80 3c 40 00 00    	mov    0x403c(%eax),%eax
c0100d6d:	83 f8 03             	cmp    $0x3,%eax
c0100d70:	75 67                	jne    c0100dd9 <do_scheduler+0xf0>
		current->ts = SLEEPING;
c0100d72:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d77:	c7 80 3c 40 00 00 03 	movl   $0x3,0x403c(%eax)
c0100d7e:	00 00 00 

		PCB* p=sleep_list;
c0100d81:	a1 b8 40 15 c0       	mov    0xc01540b8,%eax
c0100d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL){
c0100d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d8d:	75 0c                	jne    c0100d9b <do_scheduler+0xb2>
			sleep_list = current;
c0100d8f:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100d94:	a3 b8 40 15 c0       	mov    %eax,0xc01540b8
c0100d99:	eb 2a                	jmp    c0100dc5 <do_scheduler+0xdc>
		}else{
			while(p->next){
c0100d9b:	eb 0c                	jmp    c0100da9 <do_scheduler+0xc0>
				p=p->next;
c0100d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da0:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100da6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		PCB* p=sleep_list;
		if(p == NULL){
			sleep_list = current;
		}else{
			while(p->next){
c0100da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dac:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100db2:	85 c0                	test   %eax,%eax
c0100db4:	75 e7                	jne    c0100d9d <do_scheduler+0xb4>
				p=p->next;
			}
			p->next = current;
c0100db6:	8b 15 b0 40 15 c0    	mov    0xc01540b0,%edx
c0100dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dbf:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		}

		current = NULL;
c0100dc5:	c7 05 b0 40 15 c0 00 	movl   $0x0,0xc01540b0
c0100dcc:	00 00 00 
		do_scheduler();
c0100dcf:	e8 15 ff ff ff       	call   c0100ce9 <do_scheduler>
		//current = NULL;
		//do_scheduler();
		return;
c0100dd4:	e9 83 00 00 00       	jmp    c0100e5c <do_scheduler+0x173>
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 5 || current->ts == STOP){
c0100dd9:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100dde:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c0100de4:	83 f8 05             	cmp    $0x5,%eax
c0100de7:	77 10                	ja     c0100df9 <do_scheduler+0x110>
c0100de9:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100dee:	8b 80 3c 40 00 00    	mov    0x403c(%eax),%eax
c0100df4:	83 f8 02             	cmp    $0x2,%eax
c0100df7:	75 63                	jne    c0100e5c <do_scheduler+0x173>
		current->ts = READY;
c0100df9:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100dfe:	c7 80 3c 40 00 00 00 	movl   $0x0,0x403c(%eax)
c0100e05:	00 00 00 

		PCB* p=ready_list;
c0100e08:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c0100e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(p == NULL){
c0100e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100e14:	75 0c                	jne    c0100e22 <do_scheduler+0x139>
			ready_list = current;
c0100e16:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100e1b:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
c0100e20:	eb 2a                	jmp    c0100e4c <do_scheduler+0x163>
		}else{
			while(p->next){
c0100e22:	eb 0c                	jmp    c0100e30 <do_scheduler+0x147>
				p=p->next;
c0100e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e27:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)

		PCB* p=ready_list;
		if(p == NULL){
			ready_list = current;
		}else{
			while(p->next){
c0100e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e33:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0100e39:	85 c0                	test   %eax,%eax
c0100e3b:	75 e7                	jne    c0100e24 <do_scheduler+0x13b>
				p=p->next;
			}
			p->next = current;
c0100e3d:	8b 15 b0 40 15 c0    	mov    0xc01540b0,%edx
c0100e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100e46:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		}
		

		current = NULL;
c0100e4c:	c7 05 b0 40 15 c0 00 	movl   $0x0,0xc01540b0
c0100e53:	00 00 00 
		do_scheduler();
c0100e56:	e8 8e fe ff ff       	call   c0100ce9 <do_scheduler>
		//scheduler_switch(current);
		return;
c0100e5b:	90                   	nop
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
c0100e5c:	c9                   	leave  
c0100e5d:	c3                   	ret    

c0100e5e <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void switch_proc();
void irq_handle(struct TrapFrame *tf) {
c0100e5e:	55                   	push   %ebp
c0100e5f:	89 e5                	mov    %esp,%ebp
c0100e61:	83 ec 38             	sub    $0x38,%esp
	//printk("eh\n");
	current->tf = tf;
c0100e64:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0100e69:	8b 55 08             	mov    0x8(%ebp),%edx
c0100e6c:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : : "m"(esp));
	//printk("%x %x %x\n", esp, tf->esp, (uint32_t)tf);
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
c0100e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e75:	8b 40 30             	mov    0x30(%eax),%eax
c0100e78:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
c0100e7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e80:	8b 40 30             	mov    0x30(%eax),%eax
c0100e83:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100e88:	75 0e                	jne    c0100e98 <irq_handle+0x3a>
		//printk("ha");
		do_syscall(tf);
c0100e8a:	83 ec 0c             	sub    $0xc,%esp
c0100e8d:	ff 75 08             	pushl  0x8(%ebp)
c0100e90:	e8 ae 0c 00 00       	call   c0101b43 <do_syscall>
c0100e95:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
c0100e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e9b:	8b 40 30             	mov    0x30(%eax),%eax
c0100e9e:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0100ea3:	75 0f                	jne    c0100eb4 <irq_handle+0x56>
		//printk("haha");
		//serial_printc('t');
		do_timer();
c0100ea5:	e8 90 15 00 00       	call   c010243a <do_timer>
		do_scheduler();
c0100eaa:	e8 3a fe ff ff       	call   c0100ce9 <do_scheduler>
c0100eaf:	e9 83 00 00 00       	jmp    c0100f37 <irq_handle+0xd9>
	} else if (tf->irq == 1001) {
c0100eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100eb7:	8b 40 30             	mov    0x30(%eax),%eax
c0100eba:	3d e9 03 00 00       	cmp    $0x3e9,%eax
c0100ebf:	75 76                	jne    c0100f37 <irq_handle+0xd9>
c0100ec1:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100ecb:	89 c2                	mov    %eax,%edx
c0100ecd:	ec                   	in     (%dx),%al
c0100ece:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
c0100ed1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
c0100ed5:	0f b6 c0             	movzbl %al,%eax
c0100ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100edb:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0100ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ee5:	89 c2                	mov    %eax,%edx
c0100ee7:	ec                   	in     (%dx),%al
c0100ee8:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
c0100eeb:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
c0100eef:	0f b6 c0             	movzbl %al,%eax
c0100ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
c0100ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ef8:	83 c8 80             	or     $0xffffff80,%eax
c0100efb:	0f b6 c0             	movzbl %al,%eax
c0100efe:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
c0100f05:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0100f08:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100f0f:	ee                   	out    %al,(%dx)
		outb(0x61, val);
c0100f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f13:	0f b6 c0             	movzbl %al,%eax
c0100f16:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
c0100f1d:	88 45 d3             	mov    %al,-0x2d(%ebp)
c0100f20:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0100f24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100f27:	ee                   	out    %al,(%dx)
		press_key(code);
c0100f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f2b:	83 ec 0c             	sub    $0xc,%esp
c0100f2e:	50                   	push   %eax
c0100f2f:	e8 35 0b 00 00       	call   c0101a69 <press_key>
c0100f34:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
	if((tf->irq == 0x80 && (tf->eax == SYS_HANDOUT || tf->eax == SYS_SLEEP))){
c0100f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f3a:	8b 40 30             	mov    0x30(%eax),%eax
c0100f3d:	3d 80 00 00 00       	cmp    $0x80,%eax
c0100f42:	75 1f                	jne    c0100f63 <irq_handle+0x105>
c0100f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f47:	8b 40 1c             	mov    0x1c(%eax),%eax
c0100f4a:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0100f4f:	74 0d                	je     c0100f5e <irq_handle+0x100>
c0100f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f54:	8b 40 1c             	mov    0x1c(%eax),%eax
c0100f57:	3d de 05 00 00       	cmp    $0x5de,%eax
c0100f5c:	75 05                	jne    c0100f63 <irq_handle+0x105>
		//printk("handout");
		//current->ts = STOP;
		do_scheduler();
c0100f5e:	e8 86 fd ff ff       	call   c0100ce9 <do_scheduler>
	}
}
c0100f63:	c9                   	leave  
c0100f64:	c3                   	ret    

c0100f65 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
c0100f65:	55                   	push   %ebp
c0100f66:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
c0100f68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100f6b:	83 e8 01             	sub    $0x1,%eax
c0100f6e:	66 a3 08 40 15 c0    	mov    %ax,0xc0154008
	data[1] = (uint32_t)addr;
c0100f74:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f77:	66 a3 0a 40 15 c0    	mov    %ax,0xc015400a
	data[2] = ((uint32_t)addr) >> 16;
c0100f7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f80:	c1 e8 10             	shr    $0x10,%eax
c0100f83:	66 a3 0c 40 15 c0    	mov    %ax,0xc015400c
	asm volatile("lidt (%0)" : : "r"(data));
c0100f89:	b8 08 40 15 c0       	mov    $0xc0154008,%eax
c0100f8e:	0f 01 18             	lidtl  (%eax)
}
c0100f91:	5d                   	pop    %ebp
c0100f92:	c3                   	ret    

c0100f93 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0100f93:	55                   	push   %ebp
c0100f94:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0100f96:	8b 45 10             	mov    0x10(%ebp),%eax
c0100f99:	89 c2                	mov    %eax,%edx
c0100f9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100f9e:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0100fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100fa4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fae:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb5:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
c0100fb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fbc:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fc0:	83 e2 f0             	and    $0xfffffff0,%edx
c0100fc3:	83 ca 0e             	or     $0xe,%edx
c0100fc6:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0100fc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fcc:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fd0:	83 e2 ef             	and    $0xffffffef,%edx
c0100fd3:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0100fd6:	8b 45 14             	mov    0x14(%ebp),%eax
c0100fd9:	83 e0 03             	and    $0x3,%eax
c0100fdc:	89 c2                	mov    %eax,%edx
c0100fde:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fe1:	83 e2 03             	and    $0x3,%edx
c0100fe4:	89 d1                	mov    %edx,%ecx
c0100fe6:	c1 e1 05             	shl    $0x5,%ecx
c0100fe9:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100fed:	83 e2 9f             	and    $0xffffff9f,%edx
c0100ff0:	09 ca                	or     %ecx,%edx
c0100ff2:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0100ff5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ff8:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0100ffc:	83 ca 80             	or     $0xffffff80,%edx
c0100fff:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c0101002:	8b 45 10             	mov    0x10(%ebp),%eax
c0101005:	c1 e8 10             	shr    $0x10,%eax
c0101008:	89 c2                	mov    %eax,%edx
c010100a:	8b 45 08             	mov    0x8(%ebp),%eax
c010100d:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c0101011:	5d                   	pop    %ebp
c0101012:	c3                   	ret    

c0101013 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
c0101013:	55                   	push   %ebp
c0101014:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
c0101016:	8b 45 10             	mov    0x10(%ebp),%eax
c0101019:	89 c2                	mov    %eax,%edx
c010101b:	8b 45 08             	mov    0x8(%ebp),%eax
c010101e:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
c0101021:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101024:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010102b:	8b 45 08             	mov    0x8(%ebp),%eax
c010102e:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
c0101032:	8b 45 08             	mov    0x8(%ebp),%eax
c0101035:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
c0101039:	8b 45 08             	mov    0x8(%ebp),%eax
c010103c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101040:	83 ca 0f             	or     $0xf,%edx
c0101043:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
c0101046:	8b 45 08             	mov    0x8(%ebp),%eax
c0101049:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010104d:	83 e2 ef             	and    $0xffffffef,%edx
c0101050:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
c0101053:	8b 45 14             	mov    0x14(%ebp),%eax
c0101056:	83 e0 03             	and    $0x3,%eax
c0101059:	89 c2                	mov    %eax,%edx
c010105b:	8b 45 08             	mov    0x8(%ebp),%eax
c010105e:	83 e2 03             	and    $0x3,%edx
c0101061:	89 d1                	mov    %edx,%ecx
c0101063:	c1 e1 05             	shl    $0x5,%ecx
c0101066:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c010106a:	83 e2 9f             	and    $0xffffff9f,%edx
c010106d:	09 ca                	or     %ecx,%edx
c010106f:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
c0101072:	8b 45 08             	mov    0x8(%ebp),%eax
c0101075:	0f b6 50 05          	movzbl 0x5(%eax),%edx
c0101079:	83 ca 80             	or     $0xffffff80,%edx
c010107c:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
c010107f:	8b 45 10             	mov    0x10(%ebp),%eax
c0101082:	c1 e8 10             	shr    $0x10,%eax
c0101085:	89 c2                	mov    %eax,%edx
c0101087:	8b 45 08             	mov    0x8(%ebp),%eax
c010108a:	66 89 50 06          	mov    %dx,0x6(%eax)
}
c010108e:	5d                   	pop    %ebp
c010108f:	c3                   	ret    

c0101090 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
c0101090:	55                   	push   %ebp
c0101091:	89 e5                	mov    %esp,%ebp
c0101093:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c0101096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010109d:	eb 22                	jmp    c01010c1 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
c010109f:	ba 62 25 10 c0       	mov    $0xc0102562,%edx
c01010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01010a7:	c1 e0 03             	shl    $0x3,%eax
c01010aa:	05 40 3a 1b c0       	add    $0xc01b3a40,%eax
c01010af:	6a 00                	push   $0x0
c01010b1:	52                   	push   %edx
c01010b2:	6a 01                	push   $0x1
c01010b4:	50                   	push   %eax
c01010b5:	e8 59 ff ff ff       	call   c0101013 <set_trap>
c01010ba:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
c01010bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01010c1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01010c8:	7e d5                	jle    c010109f <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
c01010ca:	b8 aa 24 10 c0       	mov    $0xc01024aa,%eax
c01010cf:	6a 00                	push   $0x0
c01010d1:	50                   	push   %eax
c01010d2:	6a 01                	push   $0x1
c01010d4:	68 40 3a 1b c0       	push   $0xc01b3a40
c01010d9:	e8 35 ff ff ff       	call   c0101013 <set_trap>
c01010de:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c01010e1:	b8 b3 24 10 c0       	mov    $0xc01024b3,%eax
c01010e6:	6a 00                	push   $0x0
c01010e8:	50                   	push   %eax
c01010e9:	6a 01                	push   $0x1
c01010eb:	68 48 3a 1b c0       	push   $0xc01b3a48
c01010f0:	e8 1e ff ff ff       	call   c0101013 <set_trap>
c01010f5:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c01010f8:	b8 bc 24 10 c0       	mov    $0xc01024bc,%eax
c01010fd:	6a 00                	push   $0x0
c01010ff:	50                   	push   %eax
c0101100:	6a 01                	push   $0x1
c0101102:	68 50 3a 1b c0       	push   $0xc01b3a50
c0101107:	e8 07 ff ff ff       	call   c0101013 <set_trap>
c010110c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c010110f:	b8 c5 24 10 c0       	mov    $0xc01024c5,%eax
c0101114:	6a 00                	push   $0x0
c0101116:	50                   	push   %eax
c0101117:	6a 01                	push   $0x1
c0101119:	68 58 3a 1b c0       	push   $0xc01b3a58
c010111e:	e8 f0 fe ff ff       	call   c0101013 <set_trap>
c0101123:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101126:	b8 ce 24 10 c0       	mov    $0xc01024ce,%eax
c010112b:	6a 00                	push   $0x0
c010112d:	50                   	push   %eax
c010112e:	6a 01                	push   $0x1
c0101130:	68 60 3a 1b c0       	push   $0xc01b3a60
c0101135:	e8 d9 fe ff ff       	call   c0101013 <set_trap>
c010113a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c010113d:	b8 d7 24 10 c0       	mov    $0xc01024d7,%eax
c0101142:	6a 00                	push   $0x0
c0101144:	50                   	push   %eax
c0101145:	6a 01                	push   $0x1
c0101147:	68 68 3a 1b c0       	push   $0xc01b3a68
c010114c:	e8 c2 fe ff ff       	call   c0101013 <set_trap>
c0101151:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101154:	b8 e0 24 10 c0       	mov    $0xc01024e0,%eax
c0101159:	6a 00                	push   $0x0
c010115b:	50                   	push   %eax
c010115c:	6a 01                	push   $0x1
c010115e:	68 70 3a 1b c0       	push   $0xc01b3a70
c0101163:	e8 ab fe ff ff       	call   c0101013 <set_trap>
c0101168:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010116b:	b8 e9 24 10 c0       	mov    $0xc01024e9,%eax
c0101170:	6a 00                	push   $0x0
c0101172:	50                   	push   %eax
c0101173:	6a 01                	push   $0x1
c0101175:	68 78 3a 1b c0       	push   $0xc01b3a78
c010117a:	e8 94 fe ff ff       	call   c0101013 <set_trap>
c010117f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c0101182:	b8 f2 24 10 c0       	mov    $0xc01024f2,%eax
c0101187:	6a 00                	push   $0x0
c0101189:	50                   	push   %eax
c010118a:	6a 01                	push   $0x1
c010118c:	68 80 3a 1b c0       	push   $0xc01b3a80
c0101191:	e8 7d fe ff ff       	call   c0101013 <set_trap>
c0101196:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c0101199:	b8 fb 24 10 c0       	mov    $0xc01024fb,%eax
c010119e:	6a 00                	push   $0x0
c01011a0:	50                   	push   %eax
c01011a1:	6a 01                	push   $0x1
c01011a3:	68 88 3a 1b c0       	push   $0xc01b3a88
c01011a8:	e8 66 fe ff ff       	call   c0101013 <set_trap>
c01011ad:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01011b0:	b8 04 25 10 c0       	mov    $0xc0102504,%eax
c01011b5:	6a 00                	push   $0x0
c01011b7:	50                   	push   %eax
c01011b8:	6a 01                	push   $0x1
c01011ba:	68 90 3a 1b c0       	push   $0xc01b3a90
c01011bf:	e8 4f fe ff ff       	call   c0101013 <set_trap>
c01011c4:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01011c7:	b8 0d 25 10 c0       	mov    $0xc010250d,%eax
c01011cc:	6a 00                	push   $0x0
c01011ce:	50                   	push   %eax
c01011cf:	6a 01                	push   $0x1
c01011d1:	68 98 3a 1b c0       	push   $0xc01b3a98
c01011d6:	e8 38 fe ff ff       	call   c0101013 <set_trap>
c01011db:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c01011de:	b8 16 25 10 c0       	mov    $0xc0102516,%eax
c01011e3:	6a 00                	push   $0x0
c01011e5:	50                   	push   %eax
c01011e6:	6a 01                	push   $0x1
c01011e8:	68 a0 3a 1b c0       	push   $0xc01b3aa0
c01011ed:	e8 21 fe ff ff       	call   c0101013 <set_trap>
c01011f2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c01011f5:	b8 1f 25 10 c0       	mov    $0xc010251f,%eax
c01011fa:	6a 00                	push   $0x0
c01011fc:	50                   	push   %eax
c01011fd:	6a 01                	push   $0x1
c01011ff:	68 a8 3a 1b c0       	push   $0xc01b3aa8
c0101204:	e8 0a fe ff ff       	call   c0101013 <set_trap>
c0101209:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010120c:	b8 31 25 10 c0       	mov    $0xc0102531,%eax
c0101211:	6a 03                	push   $0x3
c0101213:	50                   	push   %eax
c0101214:	6a 01                	push   $0x1
c0101216:	68 40 3e 1b c0       	push   $0xc01b3e40
c010121b:	e8 f3 fd ff ff       	call   c0101013 <set_trap>
c0101220:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101223:	b8 3e 25 10 c0       	mov    $0xc010253e,%eax
c0101228:	6a 00                	push   $0x0
c010122a:	50                   	push   %eax
c010122b:	6a 01                	push   $0x1
c010122d:	68 40 3b 1b c0       	push   $0xc01b3b40
c0101232:	e8 5c fd ff ff       	call   c0100f93 <set_intr>
c0101237:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010123a:	b8 4a 25 10 c0       	mov    $0xc010254a,%eax
c010123f:	6a 00                	push   $0x0
c0101241:	50                   	push   %eax
c0101242:	6a 01                	push   $0x1
c0101244:	68 48 3b 1b c0       	push   $0xc01b3b48
c0101249:	e8 45 fd ff ff       	call   c0100f93 <set_intr>
c010124e:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101251:	68 00 08 00 00       	push   $0x800
c0101256:	68 40 3a 1b c0       	push   $0xc01b3a40
c010125b:	e8 05 fd ff ff       	call   c0100f65 <save_idt>
c0101260:	83 c4 08             	add    $0x8,%esp
}
c0101263:	c9                   	leave  
c0101264:	c3                   	ret    

c0101265 <sys_handout>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_handout(){
c0101265:	55                   	push   %ebp
c0101266:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c0101268:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c010126d:	cd 80                	int    $0x80
}
c010126f:	5d                   	pop    %ebp
c0101270:	c3                   	ret    

c0101271 <sys_pid>:
static inline uint32_t sys_pid(){
c0101271:	55                   	push   %ebp
c0101272:	89 e5                	mov    %esp,%ebp
c0101274:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0101277:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c010127e:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0101283:	cd 80                	int    $0x80
c0101285:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101288:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010128b:	c9                   	leave  
c010128c:	c3                   	ret    

c010128d <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010128d:	55                   	push   %ebp
c010128e:	89 e5                	mov    %esp,%ebp
c0101290:	83 ec 40             	sub    $0x40,%esp
c0101293:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c010129a:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010129e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01012a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01012a5:	ee                   	out    %al,(%dx)
c01012a6:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c01012ad:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c01012b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01012b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
c01012b9:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c01012c0:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c01012c4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01012c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01012cb:	ee                   	out    %al,(%dx)
c01012cc:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c01012d3:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01012d7:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01012db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01012de:	ee                   	out    %al,(%dx)
c01012df:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c01012e6:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01012ea:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01012ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01012f1:	ee                   	out    %al,(%dx)
c01012f2:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01012f9:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01012fd:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101301:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101304:	ee                   	out    %al,(%dx)
c0101305:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c010130c:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0101310:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101314:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101317:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c0101318:	c9                   	leave  
c0101319:	c3                   	ret    

c010131a <serial_idle>:

static inline
int serial_idle(void) {
c010131a:	55                   	push   %ebp
c010131b:	89 e5                	mov    %esp,%ebp
c010131d:	83 ec 10             	sub    $0x10,%esp
c0101320:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101327:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010132a:	89 c2                	mov    %eax,%edx
c010132c:	ec                   	in     (%dx),%al
c010132d:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101330:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101334:	0f b6 c0             	movzbl %al,%eax
c0101337:	83 e0 20             	and    $0x20,%eax
c010133a:	85 c0                	test   %eax,%eax
c010133c:	0f 95 c0             	setne  %al
c010133f:	0f b6 c0             	movzbl %al,%eax
}
c0101342:	c9                   	leave  
c0101343:	c3                   	ret    

c0101344 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101344:	55                   	push   %ebp
c0101345:	89 e5                	mov    %esp,%ebp
c0101347:	83 ec 14             	sub    $0x14,%esp
c010134a:	8b 45 08             	mov    0x8(%ebp),%eax
c010134d:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101350:	90                   	nop
c0101351:	e8 c4 ff ff ff       	call   c010131a <serial_idle>
c0101356:	85 c0                	test   %eax,%eax
c0101358:	74 f7                	je     c0101351 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010135a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010135e:	0f b6 c0             	movzbl %al,%eax
c0101361:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101368:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010136b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101372:	ee                   	out    %al,(%dx)
}
c0101373:	c9                   	leave  
c0101374:	c3                   	ret    

c0101375 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101375:	55                   	push   %ebp
c0101376:	89 e5                	mov    %esp,%ebp
c0101378:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010137b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101381:	8b 45 08             	mov    0x8(%ebp),%eax
c0101384:	83 ec 04             	sub    $0x4,%esp
c0101387:	ff 75 f4             	pushl  -0xc(%ebp)
c010138a:	50                   	push   %eax
c010138b:	68 44 13 10 c0       	push   $0xc0101344
c0101390:	e8 8e 12 00 00       	call   c0102623 <vfprintf>
c0101395:	83 c4 10             	add    $0x10,%esp
}
c0101398:	c9                   	leave  
c0101399:	c3                   	ret    

c010139a <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c010139a:	55                   	push   %ebp
c010139b:	89 e5                	mov    %esp,%ebp
c010139d:	83 ec 70             	sub    $0x70,%esp
c01013a0:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01013a7:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01013ab:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01013af:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01013b2:	ee                   	out    %al,(%dx)
c01013b3:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01013ba:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01013be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013c5:	ee                   	out    %al,(%dx)
c01013c6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01013cd:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01013d1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01013d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01013d8:	ee                   	out    %al,(%dx)
c01013d9:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c01013e0:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01013e4:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01013e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01013eb:	ee                   	out    %al,(%dx)
c01013ec:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01013f3:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01013f7:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01013fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01013fe:	ee                   	out    %al,(%dx)
c01013ff:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0101406:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010140a:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c010140e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101411:	ee                   	out    %al,(%dx)
c0101412:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c0101419:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c010141d:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101421:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101424:	ee                   	out    %al,(%dx)
c0101425:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c010142c:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101430:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0101434:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101437:	ee                   	out    %al,(%dx)
c0101438:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c010143f:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0101443:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c0101447:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010144a:	ee                   	out    %al,(%dx)
c010144b:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0101452:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c0101456:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c010145a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010145d:	ee                   	out    %al,(%dx)
c010145e:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0101465:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0101469:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c010146d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101470:	ee                   	out    %al,(%dx)
c0101471:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0101478:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c010147c:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101480:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101483:	ee                   	out    %al,(%dx)
c0101484:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010148b:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c010148f:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0101493:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0101496:	ee                   	out    %al,(%dx)
c0101497:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c010149e:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01014a2:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01014a6:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01014a9:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01014aa:	c9                   	leave  
c01014ab:	c3                   	ret    

c01014ac <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01014ac:	55                   	push   %ebp
c01014ad:	89 e5                	mov    %esp,%ebp
c01014af:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01014b2:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01014b9:	0f b6 05 00 60 10 c0 	movzbl 0xc0106000,%eax
c01014c0:	0f b6 c0             	movzbl %al,%eax
c01014c3:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01014ca:	88 45 f7             	mov    %al,-0x9(%ebp)
c01014cd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01014d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01014d4:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01014d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01014d8:	0f b6 c0             	movzbl %al,%eax
c01014db:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01014e2:	88 45 ef             	mov    %al,-0x11(%ebp)
c01014e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01014e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01014ec:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01014ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01014f0:	c1 f8 08             	sar    $0x8,%eax
c01014f3:	0f b6 c0             	movzbl %al,%eax
c01014f6:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c01014fd:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101500:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101504:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101507:	ee                   	out    %al,(%dx)
}
c0101508:	c9                   	leave  
c0101509:	c3                   	ret    

c010150a <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010150a:	55                   	push   %ebp
c010150b:	89 e5                	mov    %esp,%ebp
  while(1){
    sys_handout();
c010150d:	e8 53 fd ff ff       	call   c0101265 <sys_handout>
  }
c0101512:	eb f9                	jmp    c010150d <idle+0x3>

c0101514 <busy>:
}
void busy(){
c0101514:	55                   	push   %ebp
c0101515:	89 e5                	mov    %esp,%ebp
c0101517:	83 ec 18             	sub    $0x18,%esp
  uint32_t tick=0;
c010151a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //disable_interrupt();
    //ktick++;
    //printk("ha %x\n", sys_get_tick());
    //cur = sys_get_tick();
    //while(tick < cur){
      printf("This is busy! Sleep %ds! Recall %d times\n", sys_pid(), tick);
c0101521:	e8 4b fd ff ff       	call   c0101271 <sys_pid>
c0101526:	83 ec 04             	sub    $0x4,%esp
c0101529:	ff 75 f4             	pushl  -0xc(%ebp)
c010152c:	50                   	push   %eax
c010152d:	68 b8 29 10 c0       	push   $0xc01029b8
c0101532:	e8 86 13 00 00       	call   c01028bd <printf>
c0101537:	83 c4 10             	add    $0x10,%esp
      tick++;
c010153a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      //tick++;
    //}

    //printf("1 %x\n", _tick);
    //printf("2 %x\n", _tick);
    sys_handout();
c010153e:	e8 22 fd ff ff       	call   c0101265 <sys_handout>
    //sys_sleep(sys_pid()*200);
    //sys_handout();
    //printf("3 %x\n", _tick);
    //enable_interrupt();
  }
c0101543:	eb dc                	jmp    c0101521 <busy+0xd>

c0101545 <main>:
}
void do_scheduler();
int main(){
c0101545:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0101549:	83 e4 f0             	and    $0xfffffff0,%esp
c010154c:	ff 71 fc             	pushl  -0x4(%ecx)
c010154f:	55                   	push   %ebp
c0101550:	89 e5                	mov    %esp,%ebp
c0101552:	51                   	push   %ecx
c0101553:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0101556:	e8 d0 eb ff ff       	call   c010012b <init_page>
  init_segment();
c010155b:	e8 7c ed ff ff       	call   c01002dc <init_segment>
	init_serial();
c0101560:	e8 28 fd ff ff       	call   c010128d <init_serial>
	init_timer();
c0101565:	e8 42 ff ff ff       	call   c01014ac <init_timer>
	init_idt();
c010156a:	e8 21 fb ff ff       	call   c0101090 <init_idt>
	init_intr();
c010156f:	e8 26 fe ff ff       	call   c010139a <init_intr>
  init_pcb_pool();
c0101574:	e8 c9 08 00 00       	call   c0101e42 <init_pcb_pool>

  PCB* pidle = pcb_create();
c0101579:	e8 19 0a 00 00       	call   c0101f97 <pcb_create>
c010157e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 // loader(pcb, 102400);
  empty_loader(pidle, idle);
c0101581:	83 ec 08             	sub    $0x8,%esp
c0101584:	68 0a 15 10 c0       	push   $0xc010150a
c0101589:	ff 75 f0             	pushl  -0x10(%ebp)
c010158c:	e8 3c 04 00 00       	call   c01019cd <empty_loader>
c0101591:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c0101594:	e8 fe 09 00 00       	call   c0101f97 <pcb_create>
c0101599:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(pcb, 102400);
c010159c:	83 ec 08             	sub    $0x8,%esp
c010159f:	68 00 90 01 00       	push   $0x19000
c01015a4:	ff 75 ec             	pushl  -0x14(%ebp)
c01015a7:	e8 ac 02 00 00       	call   c0101858 <loader>
c01015ac:	83 c4 10             	add    $0x10,%esp

 // loader(pcc, 102400);
  //printk("%x\n", *((uint32_t*)entry));
  //lcr3(PADDR(pcb->pgdir));
  printk("haha\n");
c01015af:	83 ec 0c             	sub    $0xc,%esp
c01015b2:	68 e2 29 10 c0       	push   $0xc01029e2
c01015b7:	e8 b9 fd ff ff       	call   c0101375 <printk>
c01015bc:	83 c4 10             	add    $0x10,%esp
  //enable_interrupt();
  printk("haha\n");
c01015bf:	83 ec 0c             	sub    $0xc,%esp
c01015c2:	68 e2 29 10 c0       	push   $0xc01029e2
c01015c7:	e8 a9 fd ff ff       	call   c0101375 <printk>
c01015cc:	83 c4 10             	add    $0x10,%esp
  //asm volatile("int $0x0");
  //switch_pcb(pidle);
  printk("haha\n");
c01015cf:	83 ec 0c             	sub    $0xc,%esp
c01015d2:	68 e2 29 10 c0       	push   $0xc01029e2
c01015d7:	e8 99 fd ff ff       	call   c0101375 <printk>
c01015dc:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c01015df:	83 ec 0c             	sub    $0xc,%esp
c01015e2:	ff 75 f0             	pushl  -0x10(%ebp)
c01015e5:	e8 aa 0a 00 00       	call   c0102094 <enready_pcb>
c01015ea:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c01015ed:	83 ec 0c             	sub    $0xc,%esp
c01015f0:	ff 75 ec             	pushl  -0x14(%ebp)
c01015f3:	e8 9c 0a 00 00       	call   c0102094 <enready_pcb>
c01015f8:	83 c4 10             	add    $0x10,%esp
  uint32_t i = 0;
c01015fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(i=0; i<50;i++){
c0101602:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101609:	eb 2d                	jmp    c0101638 <main+0xf3>
    PCB* pcc = pcb_create();
c010160b:	e8 87 09 00 00       	call   c0101f97 <pcb_create>
c0101610:	89 45 e8             	mov    %eax,-0x18(%ebp)
    empty_loader(pcc, busy);
c0101613:	83 ec 08             	sub    $0x8,%esp
c0101616:	68 14 15 10 c0       	push   $0xc0101514
c010161b:	ff 75 e8             	pushl  -0x18(%ebp)
c010161e:	e8 aa 03 00 00       	call   c01019cd <empty_loader>
c0101623:	83 c4 10             	add    $0x10,%esp
    enready_pcb(pcc);
c0101626:	83 ec 0c             	sub    $0xc,%esp
c0101629:	ff 75 e8             	pushl  -0x18(%ebp)
c010162c:	e8 63 0a 00 00       	call   c0102094 <enready_pcb>
c0101631:	83 c4 10             	add    $0x10,%esp
  //switch_pcb(pidle);
  printk("haha\n");
  enready_pcb(pidle);
  enready_pcb(pcb);
  uint32_t i = 0;
  for(i=0; i<50;i++){
c0101634:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101638:	83 7d f4 31          	cmpl   $0x31,-0xc(%ebp)
c010163c:	76 cd                	jbe    c010160b <main+0xc6>
    enready_pcb(pcc);
  }
  //enready_pcb(pcc);
  //enready_pcb(pidle);

  do_scheduler();
c010163e:	e8 a6 f6 ff ff       	call   c0100ce9 <do_scheduler>

  while(1);
c0101643:	eb fe                	jmp    c0101643 <main+0xfe>

c0101645 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101645:	55                   	push   %ebp
c0101646:	89 e5                	mov    %esp,%ebp
c0101648:	83 ec 10             	sub    $0x10,%esp
c010164b:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101652:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101655:	89 c2                	mov    %eax,%edx
c0101657:	ec                   	in     (%dx),%al
c0101658:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c010165b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010165f:	0f b6 c0             	movzbl %al,%eax
c0101662:	83 e0 20             	and    $0x20,%eax
c0101665:	85 c0                	test   %eax,%eax
c0101667:	0f 95 c0             	setne  %al
c010166a:	0f b6 c0             	movzbl %al,%eax
}
c010166d:	c9                   	leave  
c010166e:	c3                   	ret    

c010166f <serial_printc>:

static inline
void serial_printc(char ch) {
c010166f:	55                   	push   %ebp
c0101670:	89 e5                	mov    %esp,%ebp
c0101672:	83 ec 14             	sub    $0x14,%esp
c0101675:	8b 45 08             	mov    0x8(%ebp),%eax
c0101678:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c010167b:	90                   	nop
c010167c:	e8 c4 ff ff ff       	call   c0101645 <serial_idle>
c0101681:	85 c0                	test   %eax,%eax
c0101683:	74 f7                	je     c010167c <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101685:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101689:	0f b6 c0             	movzbl %al,%eax
c010168c:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101693:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101696:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010169a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010169d:	ee                   	out    %al,(%dx)
}
c010169e:	c9                   	leave  
c010169f:	c3                   	ret    

c01016a0 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01016a0:	55                   	push   %ebp
c01016a1:	89 e5                	mov    %esp,%ebp
c01016a3:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01016a6:	8d 45 0c             	lea    0xc(%ebp),%eax
c01016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01016ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01016af:	83 ec 04             	sub    $0x4,%esp
c01016b2:	ff 75 f4             	pushl  -0xc(%ebp)
c01016b5:	50                   	push   %eax
c01016b6:	68 6f 16 10 c0       	push   $0xc010166f
c01016bb:	e8 63 0f 00 00       	call   c0102623 <vfprintf>
c01016c0:	83 c4 10             	add    $0x10,%esp
}
c01016c3:	c9                   	leave  
c01016c4:	c3                   	ret    

c01016c5 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c01016c5:	55                   	push   %ebp
c01016c6:	89 e5                	mov    %esp,%ebp
c01016c8:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c01016cb:	90                   	nop
c01016cc:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01016d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016d6:	89 c2                	mov    %eax,%edx
c01016d8:	ec                   	in     (%dx),%al
c01016d9:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01016dc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016e0:	0f b6 c0             	movzbl %al,%eax
c01016e3:	25 c0 00 00 00       	and    $0xc0,%eax
c01016e8:	83 f8 40             	cmp    $0x40,%eax
c01016eb:	75 df                	jne    c01016cc <waitdisk+0x7>
}
c01016ed:	c9                   	leave  
c01016ee:	c3                   	ret    

c01016ef <readsect>:

static inline void
readsect(void *dst, int offset) {
c01016ef:	55                   	push   %ebp
c01016f0:	89 e5                	mov    %esp,%ebp
c01016f2:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01016f5:	e8 cb ff ff ff       	call   c01016c5 <waitdisk>
c01016fa:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0101701:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101705:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101709:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010170c:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c010170d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101710:	0f b6 c0             	movzbl %al,%eax
c0101713:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c010171a:	88 45 ef             	mov    %al,-0x11(%ebp)
c010171d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101721:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101724:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101725:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101728:	c1 f8 08             	sar    $0x8,%eax
c010172b:	0f b6 c0             	movzbl %al,%eax
c010172e:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101735:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101738:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010173c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010173f:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101740:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101743:	c1 f8 10             	sar    $0x10,%eax
c0101746:	0f b6 c0             	movzbl %al,%eax
c0101749:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101750:	88 45 df             	mov    %al,-0x21(%ebp)
c0101753:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101757:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010175a:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c010175b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010175e:	c1 f8 18             	sar    $0x18,%eax
c0101761:	83 c8 e0             	or     $0xffffffe0,%eax
c0101764:	0f b6 c0             	movzbl %al,%eax
c0101767:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010176e:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101771:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101775:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
c0101779:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101780:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101784:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101788:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010178b:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c010178c:	e8 34 ff ff ff       	call   c01016c5 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101791:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101798:	eb 29                	jmp    c01017c3 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c010179a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010179d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01017a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c01017aa:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c01017b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01017b4:	89 c2                	mov    %eax,%edx
c01017b6:	ed                   	in     (%dx),%eax
c01017b7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c01017ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01017bd:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01017bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01017c3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01017c7:	7e d1                	jle    c010179a <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c01017c9:	c9                   	leave  
c01017ca:	c3                   	ret    

c01017cb <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c01017cb:	55                   	push   %ebp
c01017cc:	89 e5                	mov    %esp,%ebp
c01017ce:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c01017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01017d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01017d7:	01 d0                	add    %edx,%eax
c01017d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c01017dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01017df:	99                   	cltd   
c01017e0:	c1 ea 17             	shr    $0x17,%edx
c01017e3:	01 d0                	add    %edx,%eax
c01017e5:	25 ff 01 00 00       	and    $0x1ff,%eax
c01017ea:	29 d0                	sub    %edx,%eax
c01017ec:	f7 d8                	neg    %eax
c01017ee:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c01017f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01017f4:	99                   	cltd   
c01017f5:	c1 ea 17             	shr    $0x17,%edx
c01017f8:	01 d0                	add    %edx,%eax
c01017fa:	c1 f8 09             	sar    $0x9,%eax
c01017fd:	83 c0 01             	add    $0x1,%eax
c0101800:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101803:	eb 19                	jmp    c010181e <readseg+0x53>
        readsect(pa, offset);
c0101805:	ff 75 10             	pushl  0x10(%ebp)
c0101808:	ff 75 08             	pushl  0x8(%ebp)
c010180b:	e8 df fe ff ff       	call   c01016ef <readsect>
c0101810:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101813:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c010181a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010181e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101821:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101824:	72 df                	jb     c0101805 <readseg+0x3a>
        readsect(pa, offset);
c0101826:	c9                   	leave  
c0101827:	c3                   	ret    

c0101828 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101828:	55                   	push   %ebp
c0101829:	89 e5                	mov    %esp,%ebp
c010182b:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c010182e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101831:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101836:	77 16                	ja     c010184e <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101838:	ff 75 10             	pushl  0x10(%ebp)
c010183b:	68 e8 29 10 c0       	push   $0xc01029e8
c0101840:	ff 75 0c             	pushl  0xc(%ebp)
c0101843:	ff 75 08             	pushl  0x8(%ebp)
c0101846:	e8 55 fe ff ff       	call   c01016a0 <printk>
c010184b:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c010184e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101851:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101856:	c9                   	leave  
c0101857:	c3                   	ret    

c0101858 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101858:	55                   	push   %ebp
c0101859:	89 e5                	mov    %esp,%ebp
c010185b:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c010185e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101861:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c0101867:	83 ec 04             	sub    $0x4,%esp
c010186a:	50                   	push   %eax
c010186b:	6a 17                	push   $0x17
c010186d:	68 0b 2a 10 c0       	push   $0xc0102a0b
c0101872:	e8 b1 ff ff ff       	call   c0101828 <_paddr>
c0101877:	83 c4 10             	add    $0x10,%esp
c010187a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c010187d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101880:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101883:	8b 45 08             	mov    0x8(%ebp),%eax
c0101886:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010188c:	83 ec 04             	sub    $0x4,%esp
c010188f:	68 00 10 00 00       	push   $0x1000
c0101894:	6a 00                	push   $0x0
c0101896:	50                   	push   %eax
c0101897:	e8 da ed ff ff       	call   c0100676 <mm_alloc>
c010189c:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c010189f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01018a2:	83 ec 04             	sub    $0x4,%esp
c01018a5:	50                   	push   %eax
c01018a6:	68 00 10 00 00       	push   $0x1000
c01018ab:	6a 00                	push   $0x0
c01018ad:	e8 19 ff ff ff       	call   c01017cb <readseg>
c01018b2:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  //printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c01018b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01018ba:	8b 40 1c             	mov    0x1c(%eax),%eax
c01018bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c01018c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01018c5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01018c9:	0f b7 c0             	movzwl %ax,%eax
c01018cc:	c1 e0 05             	shl    $0x5,%eax
c01018cf:	89 c2                	mov    %eax,%edx
c01018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018d4:	01 d0                	add    %edx,%eax
c01018d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01018d9:	eb 7f                	jmp    c010195a <loader+0x102>
    pa = (unsigned char*)ph->paddr; 
c01018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018de:	8b 40 0c             	mov    0xc(%eax),%eax
c01018e1:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c01018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018e7:	8b 48 14             	mov    0x14(%eax),%ecx
c01018ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01018ed:	8b 50 08             	mov    0x8(%eax),%edx
c01018f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01018f3:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c01018f9:	83 ec 04             	sub    $0x4,%esp
c01018fc:	51                   	push   %ecx
c01018fd:	52                   	push   %edx
c01018fe:	50                   	push   %eax
c01018ff:	e8 72 ed ff ff       	call   c0100676 <mm_alloc>
c0101904:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010190a:	8b 50 04             	mov    0x4(%eax),%edx
c010190d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101910:	01 d0                	add    %edx,%eax
c0101912:	89 c2                	mov    %eax,%edx
c0101914:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101917:	8b 40 10             	mov    0x10(%eax),%eax
c010191a:	83 ec 04             	sub    $0x4,%esp
c010191d:	52                   	push   %edx
c010191e:	50                   	push   %eax
c010191f:	ff 75 e8             	pushl  -0x18(%ebp)
c0101922:	e8 a4 fe ff ff       	call   c01017cb <readseg>
c0101927:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c010192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010192d:	8b 50 10             	mov    0x10(%eax),%edx
c0101930:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101933:	01 d0                	add    %edx,%eax
c0101935:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101938:	eb 0c                	jmp    c0101946 <loader+0xee>
c010193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010193d:	8d 50 01             	lea    0x1(%eax),%edx
c0101940:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101943:	c6 00 00             	movb   $0x0,(%eax)
c0101946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101949:	8b 50 14             	mov    0x14(%eax),%edx
c010194c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010194f:	01 d0                	add    %edx,%eax
c0101951:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101954:	77 e4                	ja     c010193a <loader+0xe2>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101956:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010195d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101960:	0f 82 75 ff ff ff    	jb     c01018db <loader+0x83>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101966:	b8 00 00 00 00       	mov    $0x0,%eax
c010196b:	8b 40 18             	mov    0x18(%eax),%eax
c010196e:	a3 9c 25 10 c0       	mov    %eax,0xc010259c

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101973:	8b 45 08             	mov    0x8(%ebp),%eax
c0101976:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010197c:	83 ec 04             	sub    $0x4,%esp
c010197f:	68 00 80 00 00       	push   $0x8000
c0101984:	68 00 60 bf be       	push   $0xbebf6000
c0101989:	50                   	push   %eax
c010198a:	e8 e7 ec ff ff       	call   c0100676 <mm_alloc>
c010198f:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x1FF, entry, 3);
c0101992:	a1 9c 25 10 c0       	mov    0xc010259c,%eax
c0101997:	6a 03                	push   $0x3
c0101999:	50                   	push   %eax
c010199a:	68 01 de bf be       	push   $0xbebfde01
c010199f:	ff 75 08             	pushl  0x8(%ebp)
c01019a2:	e8 cf 04 00 00       	call   c0101e76 <init_pcb>
c01019a7:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c01019aa:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c01019af:	83 ec 04             	sub    $0x4,%esp
c01019b2:	50                   	push   %eax
c01019b3:	6a 39                	push   $0x39
c01019b5:	68 0b 2a 10 c0       	push   $0xc0102a0b
c01019ba:	e8 69 fe ff ff       	call   c0101828 <_paddr>
c01019bf:	83 c4 10             	add    $0x10,%esp
c01019c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01019c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019c8:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c01019cb:	c9                   	leave  
c01019cc:	c3                   	ret    

c01019cd <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c01019cd:	55                   	push   %ebp
c01019ce:	89 e5                	mov    %esp,%ebp
c01019d0:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c01019d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d6:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c01019dc:	83 ec 04             	sub    $0x4,%esp
c01019df:	50                   	push   %eax
c01019e0:	6a 42                	push   $0x42
c01019e2:	68 0b 2a 10 c0       	push   $0xc0102a0b
c01019e7:	e8 3c fe ff ff       	call   c0101828 <_paddr>
c01019ec:	83 c4 10             	add    $0x10,%esp
c01019ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f5:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c01019f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01019fb:	a3 9c 25 10 c0       	mov    %eax,0xc010259c
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstack0top, entry, 0);
c0101a00:	a1 9c 25 10 c0       	mov    0xc010259c,%eax
c0101a05:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a08:	81 c2 00 20 00 00    	add    $0x2000,%edx
c0101a0e:	6a 00                	push   $0x0
c0101a10:	50                   	push   %eax
c0101a11:	52                   	push   %edx
c0101a12:	ff 75 08             	pushl  0x8(%ebp)
c0101a15:	e8 5c 04 00 00       	call   c0101e76 <init_pcb>
c0101a1a:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0101a1d:	a1 c0 36 17 c0       	mov    0xc01736c0,%eax
c0101a22:	83 ec 04             	sub    $0x4,%esp
c0101a25:	50                   	push   %eax
c0101a26:	6a 46                	push   $0x46
c0101a28:	68 0b 2a 10 c0       	push   $0xc0102a0b
c0101a2d:	e8 f6 fd ff ff       	call   c0101828 <_paddr>
c0101a32:	83 c4 10             	add    $0x10,%esp
c0101a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a3b:	0f 22 d8             	mov    %eax,%cr3

};
c0101a3e:	c9                   	leave  
c0101a3f:	c3                   	ret    

c0101a40 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101a40:	55                   	push   %ebp
c0101a41:	89 e5                	mov    %esp,%ebp
c0101a43:	83 ec 04             	sub    $0x4,%esp
c0101a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a49:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101a4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101a50:	83 e8 61             	sub    $0x61,%eax
c0101a53:	8b 04 85 40 40 15 c0 	mov    -0x3feabfc0(,%eax,4),%eax
}
c0101a5a:	c9                   	leave  
c0101a5b:	c3                   	ret    

c0101a5c <get_lastkey>:
int8_t get_lastkey(){
c0101a5c:	55                   	push   %ebp
c0101a5d:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101a5f:	a1 a8 40 15 c0       	mov    0xc01540a8,%eax
c0101a64:	83 c0 61             	add    $0x61,%eax
}
c0101a67:	5d                   	pop    %ebp
c0101a68:	c3                   	ret    

c0101a69 <press_key>:
void press_key(int code){
c0101a69:	55                   	push   %ebp
c0101a6a:	89 e5                	mov    %esp,%ebp
c0101a6c:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101a6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a79:	25 80 00 00 00       	and    $0x80,%eax
c0101a7e:	85 c0                	test   %eax,%eax
c0101a80:	75 35                	jne    c0101ab7 <press_key+0x4e>
		for(;i<26;i++){
c0101a82:	eb 2b                	jmp    c0101aaf <press_key+0x46>
			if(letter[i]==code){
c0101a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a87:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c0101a8e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101a91:	75 18                	jne    c0101aab <press_key+0x42>
				keydown[i] = 1;
c0101a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a96:	c7 04 85 40 40 15 c0 	movl   $0x1,-0x3feabfc0(,%eax,4)
c0101a9d:	01 00 00 00 
				lastkey = i;
c0101aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aa4:	a3 a8 40 15 c0       	mov    %eax,0xc01540a8
				return;
c0101aa9:	eb 3b                	jmp    c0101ae6 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101aab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101aaf:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101ab3:	7e cf                	jle    c0101a84 <press_key+0x1b>
c0101ab5:	eb 2f                	jmp    c0101ae6 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101ab7:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101abb:	eb 23                	jmp    c0101ae0 <press_key+0x77>
			if(letter[i]==code){
c0101abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ac0:	8b 04 85 40 60 10 c0 	mov    -0x3fef9fc0(,%eax,4),%eax
c0101ac7:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101aca:	75 10                	jne    c0101adc <press_key+0x73>
				keydown[i] = 0;
c0101acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101acf:	c7 04 85 40 40 15 c0 	movl   $0x0,-0x3feabfc0(,%eax,4)
c0101ad6:	00 00 00 00 
				return;
c0101ada:	eb 0a                	jmp    c0101ae6 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101adc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ae0:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101ae4:	7e d7                	jle    c0101abd <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101ae6:	c9                   	leave  
c0101ae7:	c3                   	ret    

c0101ae8 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101ae8:	55                   	push   %ebp
c0101ae9:	89 e5                	mov    %esp,%ebp
c0101aeb:	83 ec 10             	sub    $0x10,%esp
c0101aee:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101af5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101af8:	89 c2                	mov    %eax,%edx
c0101afa:	ec                   	in     (%dx),%al
c0101afb:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101afe:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101b02:	0f b6 c0             	movzbl %al,%eax
c0101b05:	83 e0 20             	and    $0x20,%eax
c0101b08:	85 c0                	test   %eax,%eax
c0101b0a:	0f 95 c0             	setne  %al
c0101b0d:	0f b6 c0             	movzbl %al,%eax
}
c0101b10:	c9                   	leave  
c0101b11:	c3                   	ret    

c0101b12 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101b12:	55                   	push   %ebp
c0101b13:	89 e5                	mov    %esp,%ebp
c0101b15:	83 ec 14             	sub    $0x14,%esp
c0101b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1b:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101b1e:	90                   	nop
c0101b1f:	e8 c4 ff ff ff       	call   c0101ae8 <serial_idle>
c0101b24:	85 c0                	test   %eax,%eax
c0101b26:	74 f7                	je     c0101b1f <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101b28:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101b2c:	0f b6 c0             	movzbl %al,%eax
c0101b2f:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101b36:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101b39:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101b40:	ee                   	out    %al,(%dx)
}
c0101b41:	c9                   	leave  
c0101b42:	c3                   	ret    

c0101b43 <do_syscall>:

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101b43:	55                   	push   %ebp
c0101b44:	89 e5                	mov    %esp,%ebp
c0101b46:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
c0101b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4c:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b4f:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101b54:	0f 84 3b 01 00 00    	je     c0101c95 <do_syscall+0x152>
c0101b5a:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101b5f:	77 48                	ja     c0101ba9 <do_syscall+0x66>
c0101b61:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101b66:	0f 84 e9 00 00 00    	je     c0101c55 <do_syscall+0x112>
c0101b6c:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101b71:	77 1b                	ja     c0101b8e <do_syscall+0x4b>
c0101b73:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101b78:	0f 84 b6 00 00 00    	je     c0101c34 <do_syscall+0xf1>
c0101b7e:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101b83:	0f 84 c2 00 00 00    	je     c0101c4b <do_syscall+0x108>
c0101b89:	e9 7a 01 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
c0101b8e:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101b93:	0f 84 c6 00 00 00    	je     c0101c5f <do_syscall+0x11c>
c0101b99:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101b9e:	0f 84 ca 00 00 00    	je     c0101c6e <do_syscall+0x12b>
c0101ba4:	e9 5f 01 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
c0101ba9:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101bae:	74 70                	je     c0101c20 <do_syscall+0xdd>
c0101bb0:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101bb5:	77 1b                	ja     c0101bd2 <do_syscall+0x8f>
c0101bb7:	3d 14 05 00 00       	cmp    $0x514,%eax
c0101bbc:	0f 84 02 01 00 00    	je     c0101cc4 <do_syscall+0x181>
c0101bc2:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101bc7:	0f 84 e8 00 00 00    	je     c0101cb5 <do_syscall+0x172>
c0101bcd:	e9 36 01 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
c0101bd2:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101bd7:	74 0c                	je     c0101be5 <do_syscall+0xa2>
c0101bd9:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101bde:	74 1b                	je     c0101bfb <do_syscall+0xb8>
c0101be0:	e9 23 01 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_PID:
			tf->eax = current->pid;
c0101be5:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101bea:	8b 90 34 40 00 00    	mov    0x4034(%eax),%edx
c0101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf3:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101bf6:	e9 0d 01 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0101bfb:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101c00:	c7 80 3c 40 00 00 03 	movl   $0x3,0x403c(%eax)
c0101c07:	00 00 00 
			current->timeslice = tf->ebx;
c0101c0a:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101c0f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c12:	8b 52 10             	mov    0x10(%edx),%edx
c0101c15:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)
		break;
c0101c1b:	e9 e8 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_HANDOUT:
			current->ts = STOP;
c0101c20:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0101c25:	c7 80 3c 40 00 00 02 	movl   $0x2,0x403c(%eax)
c0101c2c:	00 00 00 
		break;
c0101c2f:	e9 d4 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0101c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c37:	8b 40 10             	mov    0x10(%eax),%eax
c0101c3a:	0f be c0             	movsbl %al,%eax
c0101c3d:	50                   	push   %eax
c0101c3e:	e8 cf fe ff ff       	call   c0101b12 <serial_printc>
c0101c43:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
c0101c46:	e9 bd 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_INIT_CACHE:
			initVCache();
c0101c4b:	e8 ff 04 00 00       	call   c010214f <initVCache>
		break;
c0101c50:	e9 b3 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0101c55:	e8 2a 06 00 00       	call   c0102284 <clearVRAM>
		break;
c0101c5a:	e9 a9 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0101c5f:	e8 20 06 00 00       	call   c0102284 <clearVRAM>
			flushVCache();
c0101c64:	e8 4f 05 00 00       	call   c01021b8 <flushVCache>
		break;
c0101c69:	e9 9a 00 00 00       	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c0101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c71:	8b 40 14             	mov    0x14(%eax),%eax
c0101c74:	0f b6 c0             	movzbl %al,%eax
c0101c77:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c7a:	8b 52 18             	mov    0x18(%edx),%edx
c0101c7d:	89 d1                	mov    %edx,%ecx
c0101c7f:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c82:	8b 52 10             	mov    0x10(%edx),%edx
c0101c85:	83 ec 04             	sub    $0x4,%esp
c0101c88:	50                   	push   %eax
c0101c89:	51                   	push   %ecx
c0101c8a:	52                   	push   %edx
c0101c8b:	e8 8d 05 00 00       	call   c010221d <setPixelAt>
c0101c90:	83 c4 10             	add    $0x10,%esp
		break;
c0101c93:	eb 73                	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0101c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c98:	8b 40 10             	mov    0x10(%eax),%eax
c0101c9b:	0f be c0             	movsbl %al,%eax
c0101c9e:	83 ec 0c             	sub    $0xc,%esp
c0101ca1:	50                   	push   %eax
c0101ca2:	e8 99 fd ff ff       	call   c0101a40 <get_key>
c0101ca7:	83 c4 10             	add    $0x10,%esp
c0101caa:	0f be d0             	movsbl %al,%edx
c0101cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb0:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0101cb3:	eb 53                	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_GET_TICK:
			tf->eax = tick();
c0101cb5:	e8 e6 07 00 00       	call   c01024a0 <tick>
c0101cba:	89 c2                	mov    %eax,%edx
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0101cc2:	eb 44                	jmp    c0101d08 <do_syscall+0x1c5>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ccb:	eb 34                	jmp    c0101d01 <do_syscall+0x1be>
				if(!timer_handlers[i].used){
c0101ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cd0:	8b 04 c5 04 37 1b c0 	mov    -0x3fe4c8fc(,%eax,8),%eax
c0101cd7:	85 c0                	test   %eax,%eax
c0101cd9:	75 22                	jne    c0101cfd <do_syscall+0x1ba>
					timer_handlers[i].ptr = (void*)tf->ebx;
c0101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cde:	8b 40 10             	mov    0x10(%eax),%eax
c0101ce1:	89 c2                	mov    %eax,%edx
c0101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ce6:	89 14 c5 00 37 1b c0 	mov    %edx,-0x3fe4c900(,%eax,8)
					timer_handlers[i].used = 1;
c0101ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cf0:	c7 04 c5 04 37 1b c0 	movl   $0x1,-0x3fe4c8fc(,%eax,8)
c0101cf7:	01 00 00 00 
					break;
c0101cfb:	eb 0a                	jmp    c0101d07 <do_syscall+0x1c4>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
c0101cfd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101d01:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101d05:	7e c6                	jle    c0101ccd <do_syscall+0x18a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
c0101d07:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0101d08:	c9                   	leave  
c0101d09:	c3                   	ret    

c0101d0a <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101d0a:	55                   	push   %ebp
c0101d0b:	89 e5                	mov    %esp,%ebp
c0101d0d:	83 ec 10             	sub    $0x10,%esp
c0101d10:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d1a:	89 c2                	mov    %eax,%edx
c0101d1c:	ec                   	in     (%dx),%al
c0101d1d:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101d20:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101d24:	0f b6 c0             	movzbl %al,%eax
c0101d27:	83 e0 20             	and    $0x20,%eax
c0101d2a:	85 c0                	test   %eax,%eax
c0101d2c:	0f 95 c0             	setne  %al
c0101d2f:	0f b6 c0             	movzbl %al,%eax
}
c0101d32:	c9                   	leave  
c0101d33:	c3                   	ret    

c0101d34 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101d34:	55                   	push   %ebp
c0101d35:	89 e5                	mov    %esp,%ebp
c0101d37:	83 ec 14             	sub    $0x14,%esp
c0101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3d:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101d40:	90                   	nop
c0101d41:	e8 c4 ff ff ff       	call   c0101d0a <serial_idle>
c0101d46:	85 c0                	test   %eax,%eax
c0101d48:	74 f7                	je     c0101d41 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101d4a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101d4e:	0f b6 c0             	movzbl %al,%eax
c0101d51:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101d58:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101d5b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101d5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101d62:	ee                   	out    %al,(%dx)
}
c0101d63:	c9                   	leave  
c0101d64:	c3                   	ret    

c0101d65 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0101d65:	55                   	push   %ebp
c0101d66:	89 e5                	mov    %esp,%ebp
c0101d68:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0101d6b:	8d 45 0c             	lea    0xc(%ebp),%eax
c0101d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0101d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d74:	83 ec 04             	sub    $0x4,%esp
c0101d77:	ff 75 f4             	pushl  -0xc(%ebp)
c0101d7a:	50                   	push   %eax
c0101d7b:	68 34 1d 10 c0       	push   $0xc0101d34
c0101d80:	e8 9e 08 00 00       	call   c0102623 <vfprintf>
c0101d85:	83 c4 10             	add    $0x10,%esp
}
c0101d88:	c9                   	leave  
c0101d89:	c3                   	ret    

c0101d8a <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0101d8a:	55                   	push   %ebp
c0101d8b:	89 e5                	mov    %esp,%ebp
c0101d8d:	57                   	push   %edi
c0101d8e:	56                   	push   %esi
c0101d8f:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0101d90:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d93:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d96:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101d99:	89 c1                	mov    %eax,%ecx
c0101d9b:	89 d6                	mov    %edx,%esi
c0101d9d:	89 df                	mov    %ebx,%edi
c0101d9f:	fc                   	cld    
c0101da0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0101da2:	5b                   	pop    %ebx
c0101da3:	5e                   	pop    %esi
c0101da4:	5f                   	pop    %edi
c0101da5:	5d                   	pop    %ebp
c0101da6:	c3                   	ret    

c0101da7 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101da7:	55                   	push   %ebp
c0101da8:	89 e5                	mov    %esp,%ebp
c0101daa:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101dad:	8b 45 10             	mov    0x10(%ebp),%eax
c0101db0:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101db5:	77 16                	ja     c0101dcd <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101db7:	ff 75 10             	pushl  0x10(%ebp)
c0101dba:	68 20 2a 10 c0       	push   $0xc0102a20
c0101dbf:	ff 75 0c             	pushl  0xc(%ebp)
c0101dc2:	ff 75 08             	pushl  0x8(%ebp)
c0101dc5:	e8 9b ff ff ff       	call   c0101d65 <printk>
c0101dca:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101dcd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101dd0:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101dd5:	c9                   	leave  
c0101dd6:	c3                   	ret    

c0101dd7 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0101dd7:	55                   	push   %ebp
c0101dd8:	89 e5                	mov    %esp,%ebp
c0101dda:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0101ddd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101de0:	c1 e8 0c             	shr    $0xc,%eax
c0101de3:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0101de8:	76 13                	jbe    c0101dfd <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0101dea:	83 ec 08             	sub    $0x8,%esp
c0101ded:	ff 75 10             	pushl  0x10(%ebp)
c0101df0:	68 44 2a 10 c0       	push   $0xc0102a44
c0101df5:	e8 6b ff ff ff       	call   c0101d65 <printk>
c0101dfa:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0101dfd:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e00:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0101e05:	c9                   	leave  
c0101e06:	c3                   	ret    

c0101e07 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0101e07:	55                   	push   %ebp
c0101e08:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0d:	ba 00 37 17 c0       	mov    $0xc0173700,%edx
c0101e12:	29 d0                	sub    %edx,%eax
c0101e14:	c1 f8 03             	sar    $0x3,%eax
c0101e17:	c1 e0 0c             	shl    $0xc,%eax
}
c0101e1a:	5d                   	pop    %ebp
c0101e1b:	c3                   	ret    

c0101e1c <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
c0101e1c:	55                   	push   %ebp
c0101e1d:	89 e5                	mov    %esp,%ebp
c0101e1f:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0101e22:	ff 75 08             	pushl  0x8(%ebp)
c0101e25:	e8 dd ff ff ff       	call   c0101e07 <page2pa>
c0101e2a:	83 c4 04             	add    $0x4,%esp
c0101e2d:	83 ec 04             	sub    $0x4,%esp
c0101e30:	50                   	push   %eax
c0101e31:	6a 52                	push   $0x52
c0101e33:	68 66 2a 10 c0       	push   $0xc0102a66
c0101e38:	e8 9a ff ff ff       	call   c0101dd7 <_kaddr>
c0101e3d:	83 c4 10             	add    $0x10,%esp
}
c0101e40:	c9                   	leave  
c0101e41:	c3                   	ret    

c0101e42 <init_pcb_pool>:
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_pcb_pool()
{
c0101e42:	55                   	push   %ebp
c0101e43:	89 e5                	mov    %esp,%ebp
c0101e45:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101e4f:	eb 1d                	jmp    c0101e6e <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c0101e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e54:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c0101e5a:	05 30 40 00 00       	add    $0x4030,%eax
c0101e5f:	05 00 64 1b c0       	add    $0xc01b6400,%eax
c0101e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
};*/

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101e6a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101e6e:	83 7d fc 63          	cmpl   $0x63,-0x4(%ebp)
c0101e72:	76 dd                	jbe    c0101e51 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0101e74:	c9                   	leave  
c0101e75:	c3                   	ret    

c0101e76 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0101e76:	55                   	push   %ebp
c0101e77:	89 e5                	mov    %esp,%ebp
c0101e79:	83 ec 24             	sub    $0x24,%esp
c0101e7c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e7f:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0101e82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e85:	8b 80 44 40 00 00    	mov    0x4044(%eax),%eax
c0101e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0101e8e:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0101e92:	75 46                	jne    c0101eda <init_pcb+0x64>
		tf->ds = GD_KD;
c0101e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e97:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0101e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ea1:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0101ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101eab:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0101eb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101eb4:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0101ebb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ebe:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c0101ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ec8:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0101ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ed1:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0101ed8:	eb 4a                	jmp    c0101f24 <init_pcb+0xae>
	}else
	if(pri == 3){
c0101eda:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0101ede:	75 44                	jne    c0101f24 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0101ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ee3:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0101eea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101eed:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0101ef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ef7:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0101efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f00:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0101f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f0a:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c0101f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f14:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0101f1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f1d:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0101f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f27:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f2a:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c0101f2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f30:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f33:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0101f36:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0101f3a:	75 59                	jne    c0101f95 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c0101f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0101f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0101f48:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0101f4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101f56:	eb 26                	jmp    c0101f7e <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0101f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f65:	01 c2                	add    %eax,%edx
c0101f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0101f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f74:	01 c8                	add    %ecx,%eax
c0101f76:	8b 00                	mov    (%eax),%eax
c0101f78:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0101f7a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f81:	c1 e8 02             	shr    $0x2,%eax
c0101f84:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101f87:	77 cf                	ja     c0101f58 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0101f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101f8f:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	}
	//lcr3(PADDR(kern_pgdir));
}
c0101f95:	c9                   	leave  
c0101f96:	c3                   	ret    

c0101f97 <pcb_create>:

PCB* pcb_create()
{
c0101f97:	55                   	push   %ebp
c0101f98:	89 e5                	mov    %esp,%ebp
c0101f9a:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101fa4:	eb 1f                	jmp    c0101fc5 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0101fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fa9:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c0101faf:	05 30 40 00 00       	add    $0x4030,%eax
c0101fb4:	05 00 64 1b c0       	add    $0xc01b6400,%eax
c0101fb9:	8b 00                	mov    (%eax),%eax
c0101fbb:	85 c0                	test   %eax,%eax
c0101fbd:	75 02                	jne    c0101fc1 <pcb_create+0x2a>
c0101fbf:	eb 0a                	jmp    c0101fcb <pcb_create+0x34>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0101fc1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101fc5:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0101fc9:	76 db                	jbe    c0101fa6 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0101fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fce:	69 c0 54 40 00 00    	imul   $0x4054,%eax,%eax
c0101fd4:	05 00 64 1b c0       	add    $0xc01b6400,%eax
c0101fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0101fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fdf:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0101fe2:	8d 90 40 46 1b c0    	lea    -0x3fe4b9c0(%eax),%edx
c0101fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101feb:	89 90 44 40 00 00    	mov    %edx,0x4044(%eax)
	p->used = 1;
c0101ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ff4:	c7 80 30 40 00 00 01 	movl   $0x1,0x4030(%eax)
c0101ffb:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0101ffe:	83 ec 0c             	sub    $0xc,%esp
c0102001:	6a 01                	push   $0x1
c0102003:	e8 60 e8 ff ff       	call   c0100868 <page_alloc>
c0102008:	83 c4 10             	add    $0x10,%esp
c010200b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c010200e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102012:	75 07                	jne    c010201b <pcb_create+0x84>
c0102014:	b8 00 00 00 00       	mov    $0x0,%eax
c0102019:	eb 77                	jmp    c0102092 <pcb_create+0xfb>
	p->pgdir = page2kva(pp);
c010201b:	83 ec 0c             	sub    $0xc,%esp
c010201e:	ff 75 ec             	pushl  -0x14(%ebp)
c0102021:	e8 f6 fd ff ff       	call   c0101e1c <page2kva>
c0102026:	83 c4 10             	add    $0x10,%esp
c0102029:	89 c2                	mov    %eax,%edx
c010202b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010202e:	89 90 48 40 00 00    	mov    %edx,0x4048(%eax)
	p->pid = pid;
c0102034:	8b 15 ac 40 15 c0    	mov    0xc01540ac,%edx
c010203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010203d:	89 90 34 40 00 00    	mov    %edx,0x4034(%eax)
	p->timeslice = 0;
c0102043:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102046:	c7 80 40 40 00 00 00 	movl   $0x0,0x4040(%eax)
c010204d:	00 00 00 
	//p->ts = READY;
	pid ++;
c0102050:	a1 ac 40 15 c0       	mov    0xc01540ac,%eax
c0102055:	83 c0 01             	add    $0x1,%eax
c0102058:	a3 ac 40 15 c0       	mov    %eax,0xc01540ac
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c010205d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102060:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0102064:	8d 50 01             	lea    0x1(%eax),%edx
c0102067:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010206a:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c010206e:	8b 15 c0 36 17 c0    	mov    0xc01736c0,%edx
c0102074:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102077:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c010207d:	83 ec 04             	sub    $0x4,%esp
c0102080:	68 00 10 00 00       	push   $0x1000
c0102085:	52                   	push   %edx
c0102086:	50                   	push   %eax
c0102087:	e8 fe fc ff ff       	call   c0101d8a <memcpy>
c010208c:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c010208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102092:	c9                   	leave  
c0102093:	c3                   	ret    

c0102094 <enready_pcb>:

void enready_pcb(PCB* pcb){
c0102094:	55                   	push   %ebp
c0102095:	89 e5                	mov    %esp,%ebp
c0102097:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c010209a:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c010209f:	85 c0                	test   %eax,%eax
c01020a1:	75 18                	jne    c01020bb <enready_pcb+0x27>
		ready_list = pcb;
c01020a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a6:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
		ready_list->tail = pcb;
c01020ab:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01020b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01020b3:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)
c01020b9:	eb 32                	jmp    c01020ed <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01020bb:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01020c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01020c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c6:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
		ready_list->next = temp;
c01020cb:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01020d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01020d3:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
		ready_list->tail = temp->tail;
c01020d9:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01020de:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01020e1:	8b 92 50 40 00 00    	mov    0x4050(%edx),%edx
c01020e7:	89 90 50 40 00 00    	mov    %edx,0x4050(%eax)
	}
}
c01020ed:	c9                   	leave  
c01020ee:	c3                   	ret    

c01020ef <switch_pcb>:

void switch_pcb(PCB* pcb){
c01020ef:	55                   	push   %ebp
c01020f0:	89 e5                	mov    %esp,%ebp
c01020f2:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01020f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f8:	a3 b0 40 15 c0       	mov    %eax,0xc01540b0
	lcr3(PADDR(pcb -> pgdir));
c01020fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102100:	8b 80 48 40 00 00    	mov    0x4048(%eax),%eax
c0102106:	83 ec 04             	sub    $0x4,%esp
c0102109:	50                   	push   %eax
c010210a:	6a 75                	push   $0x75
c010210c:	68 7c 2a 10 c0       	push   $0xc0102a7c
c0102111:	e8 91 fc ff ff       	call   c0101da7 <_paddr>
c0102116:	83 c4 10             	add    $0x10,%esp
c0102119:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c010211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010211f:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0102122:	83 ec 0c             	sub    $0xc,%esp
c0102125:	ff 75 08             	pushl  0x8(%ebp)
c0102128:	e8 2f e2 ff ff       	call   c010035c <enter_pcb>
c010212d:	83 c4 10             	add    $0x10,%esp
}
c0102130:	c9                   	leave  
c0102131:	c3                   	ret    

c0102132 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0102132:	55                   	push   %ebp
c0102133:	89 e5                	mov    %esp,%ebp
c0102135:	57                   	push   %edi
c0102136:	56                   	push   %esi
c0102137:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102138:	8b 45 10             	mov    0x10(%ebp),%eax
c010213b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010213e:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102141:	89 c1                	mov    %eax,%ecx
c0102143:	89 d6                	mov    %edx,%esi
c0102145:	89 df                	mov    %ebx,%edi
c0102147:	fc                   	cld    
c0102148:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c010214a:	5b                   	pop    %ebx
c010214b:	5e                   	pop    %esi
c010214c:	5f                   	pop    %edi
c010214d:	5d                   	pop    %ebp
c010214e:	c3                   	ret    

c010214f <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c010214f:	55                   	push   %ebp
c0102150:	89 e5                	mov    %esp,%ebp
c0102152:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102155:	68 80 3e 00 00       	push   $0x3e80
c010215a:	68 c0 3a 16 c0       	push   $0xc0163ac0
c010215f:	68 c0 40 15 c0       	push   $0xc01540c0
c0102164:	e8 c9 ff ff ff       	call   c0102132 <memcpy>
c0102169:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c010216c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102173:	eb 0f                	jmp    c0102184 <initVCache+0x35>
		VDIRTY[x] = 0;
c0102175:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102178:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c010217d:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0102180:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102184:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c010218b:	7e e8                	jle    c0102175 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c010218d:	c9                   	leave  
c010218e:	c3                   	ret    

c010218f <refreshVCache>:
void refreshVCache(){
c010218f:	55                   	push   %ebp
c0102190:	89 e5                	mov    %esp,%ebp
c0102192:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010219c:	eb 0f                	jmp    c01021ad <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c010219e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a1:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c01021a6:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c01021a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021ad:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01021b4:	7e e8                	jle    c010219e <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c01021b6:	c9                   	leave  
c01021b7:	c3                   	ret    

c01021b8 <flushVCache>:
void flushVCache(){
c01021b8:	55                   	push   %ebp
c01021b9:	89 e5                	mov    %esp,%ebp
c01021bb:	53                   	push   %ebx
c01021bc:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c01021bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01021c6:	eb 47                	jmp    c010220f <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c01021c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021cb:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c01021d0:	0f b6 00             	movzbl (%eax),%eax
c01021d3:	84 c0                	test   %al,%al
c01021d5:	74 34                	je     c010220b <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c01021d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01021da:	89 d0                	mov    %edx,%eax
c01021dc:	c1 e0 02             	shl    $0x2,%eax
c01021df:	01 d0                	add    %edx,%eax
c01021e1:	c1 e0 06             	shl    $0x6,%eax
c01021e4:	8d 88 c0 40 15 c0    	lea    -0x3feabf40(%eax),%ecx
c01021ea:	8b 1d a8 60 10 c0    	mov    0xc01060a8,%ebx
c01021f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01021f3:	89 d0                	mov    %edx,%eax
c01021f5:	c1 e0 02             	shl    $0x2,%eax
c01021f8:	01 d0                	add    %edx,%eax
c01021fa:	c1 e0 06             	shl    $0x6,%eax
c01021fd:	01 d8                	add    %ebx,%eax
c01021ff:	6a 50                	push   $0x50
c0102201:	51                   	push   %ecx
c0102202:	50                   	push   %eax
c0102203:	e8 2a ff ff ff       	call   c0102132 <memcpy>
c0102208:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c010220b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c010220f:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102216:	7e b0                	jle    c01021c8 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0102218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010221b:	c9                   	leave  
c010221c:	c3                   	ret    

c010221d <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c010221d:	55                   	push   %ebp
c010221e:	89 e5                	mov    %esp,%ebp
c0102220:	83 ec 04             	sub    $0x4,%esp
c0102223:	8b 45 10             	mov    0x10(%ebp),%eax
c0102226:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0102229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010222d:	78 18                	js     c0102247 <setPixelAt+0x2a>
c010222f:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102236:	7f 0f                	jg     c0102247 <setPixelAt+0x2a>
c0102238:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010223c:	78 09                	js     c0102247 <setPixelAt+0x2a>
c010223e:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102245:	7e 02                	jle    c0102249 <setPixelAt+0x2c>
c0102247:	eb 34                	jmp    c010227d <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0102249:	8b 45 08             	mov    0x8(%ebp),%eax
c010224c:	05 c0 34 17 c0       	add    $0xc01734c0,%eax
c0102251:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0102254:	8b 45 08             	mov    0x8(%ebp),%eax
c0102257:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c010225c:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c010225f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102262:	89 d0                	mov    %edx,%eax
c0102264:	c1 e0 02             	shl    $0x2,%eax
c0102267:	01 d0                	add    %edx,%eax
c0102269:	c1 e0 06             	shl    $0x6,%eax
c010226c:	89 c2                	mov    %eax,%edx
c010226e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102271:	01 c2                	add    %eax,%edx
c0102273:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0102277:	88 82 c0 40 15 c0    	mov    %al,-0x3feabf40(%edx)
}
c010227d:	c9                   	leave  
c010227e:	c3                   	ret    

c010227f <forceClearVRAM>:
void forceClearVRAM(){
c010227f:	55                   	push   %ebp
c0102280:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0102282:	5d                   	pop    %ebp
c0102283:	c3                   	ret    

c0102284 <clearVRAM>:
void clearVRAM(){
c0102284:	55                   	push   %ebp
c0102285:	89 e5                	mov    %esp,%ebp
c0102287:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c010228a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102291:	eb 4e                	jmp    c01022e1 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0102293:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102296:	05 c0 35 17 c0       	add    $0xc01735c0,%eax
c010229b:	0f b6 00             	movzbl (%eax),%eax
c010229e:	0f b6 c0             	movzbl %al,%eax
c01022a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01022a4:	81 c2 c0 34 17 c0    	add    $0xc01734c0,%edx
c01022aa:	0f b6 12             	movzbl (%edx),%edx
c01022ad:	0f b6 d2             	movzbl %dl,%edx
c01022b0:	f7 d2                	not    %edx
c01022b2:	21 d0                	and    %edx,%eax
c01022b4:	85 c0                	test   %eax,%eax
c01022b6:	74 25                	je     c01022dd <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c01022b8:	8b 0d a8 60 10 c0    	mov    0xc01060a8,%ecx
c01022be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01022c1:	89 d0                	mov    %edx,%eax
c01022c3:	c1 e0 02             	shl    $0x2,%eax
c01022c6:	01 d0                	add    %edx,%eax
c01022c8:	c1 e0 06             	shl    $0x6,%eax
c01022cb:	01 c8                	add    %ecx,%eax
c01022cd:	6a 50                	push   $0x50
c01022cf:	68 c0 3a 16 c0       	push   $0xc0163ac0
c01022d4:	50                   	push   %eax
c01022d5:	e8 58 fe ff ff       	call   c0102132 <memcpy>
c01022da:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c01022dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022e1:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c01022e8:	7e a9                	jle    c0102293 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c01022ea:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c01022f1:	83 c0 01             	add    $0x1,%eax
c01022f4:	a2 88 36 17 c0       	mov    %al,0xc0173688
	if(stamp==30){
c01022f9:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c0102300:	3c 1e                	cmp    $0x1e,%al
c0102302:	75 07                	jne    c010230b <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0102304:	c6 05 88 36 17 c0 00 	movb   $0x0,0xc0173688
		//printk("What matters\n");
	}
	if(stamp==0){
c010230b:	0f b6 05 88 36 17 c0 	movzbl 0xc0173688,%eax
c0102312:	84 c0                	test   %al,%al
c0102314:	75 14                	jne    c010232a <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102316:	6a 32                	push   $0x32
c0102318:	68 c0 3a 16 c0       	push   $0xc0163ac0
c010231d:	68 c0 35 17 c0       	push   $0xc01735c0
c0102322:	e8 0b fe ff ff       	call   c0102132 <memcpy>
c0102327:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c010232a:	c9                   	leave  
c010232b:	c3                   	ret    

c010232c <lislen>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;
uint32_t lislen(PCB* head){
c010232c:	55                   	push   %ebp
c010232d:	89 e5                	mov    %esp,%ebp
c010232f:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c0102332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while(head){
c0102339:	eb 10                	jmp    c010234b <lislen+0x1f>
		head = head->next;
c010233b:	8b 45 08             	mov    0x8(%ebp),%eax
c010233e:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0102344:	89 45 08             	mov    %eax,0x8(%ebp)
		i++;
c0102347:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;
uint32_t lislen(PCB* head){
	uint32_t i = 0;
	while(head){
c010234b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010234f:	75 ea                	jne    c010233b <lislen+0xf>
		head = head->next;
		i++;
	}
	return i;
c0102351:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102354:	c9                   	leave  
c0102355:	c3                   	ret    

c0102356 <find_and_wake>:
uint32_t find_and_wake(){
c0102356:	55                   	push   %ebp
c0102357:	89 e5                	mov    %esp,%ebp
c0102359:	83 ec 10             	sub    $0x10,%esp
	if(sleep_list == NULL)return 0;
c010235c:	a1 b8 40 15 c0       	mov    0xc01540b8,%eax
c0102361:	85 c0                	test   %eax,%eax
c0102363:	75 0a                	jne    c010236f <find_and_wake+0x19>
c0102365:	b8 00 00 00 00       	mov    $0x0,%eax
c010236a:	e9 c9 00 00 00       	jmp    c0102438 <find_and_wake+0xe2>
	PCB *sleep = sleep_list, *pre = NULL;
c010236f:	a1 b8 40 15 c0       	mov    0xc01540b8,%eax
c0102374:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102377:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	while(1){
		if(sleep == NULL)
c010237e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102382:	75 0a                	jne    c010238e <find_and_wake+0x38>
			return 0;
c0102384:	b8 00 00 00 00       	mov    $0x0,%eax
c0102389:	e9 aa 00 00 00       	jmp    c0102438 <find_and_wake+0xe2>
		if(sleep->timeslice <= 0)
c010238e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102391:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c0102397:	85 c0                	test   %eax,%eax
c0102399:	75 1e                	jne    c01023b9 <find_and_wake+0x63>
			break;
c010239b:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	sleep->ts = READY;
c010239c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010239f:	c7 80 3c 40 00 00 00 	movl   $0x0,0x403c(%eax)
c01023a6:	00 00 00 

	PCB* p=ready_list;
c01023a9:	a1 b4 40 15 c0       	mov    0xc01540b4,%eax
c01023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(p == NULL){
c01023b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01023b5:	75 20                	jne    c01023d7 <find_and_wake+0x81>
c01023b7:	eb 14                	jmp    c01023cd <find_and_wake+0x77>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep->timeslice <= 0)
			break;
		pre = sleep;
c01023b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c01023bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023c2:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c01023c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c01023cb:	eb b1                	jmp    c010237e <find_and_wake+0x28>
	sleep->ts = READY;

	PCB* p=ready_list;

	if(p == NULL){
		ready_list = sleep;
c01023cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023d0:	a3 b4 40 15 c0       	mov    %eax,0xc01540b4
c01023d5:	eb 27                	jmp    c01023fe <find_and_wake+0xa8>
	}else{
		while(p->next){
c01023d7:	eb 0c                	jmp    c01023e5 <find_and_wake+0x8f>
			p=p->next;
c01023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023dc:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c01023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	PCB* p=ready_list;

	if(p == NULL){
		ready_list = sleep;
	}else{
		while(p->next){
c01023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023e8:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c01023ee:	85 c0                	test   %eax,%eax
c01023f0:	75 e7                	jne    c01023d9 <find_and_wake+0x83>
			p=p->next;
		}
		p->next = sleep;
c01023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023f8:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
	}


	if(pre == NULL)
c01023fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102402:	75 10                	jne    c0102414 <find_and_wake+0xbe>
		sleep_list = sleep->next;
c0102404:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102407:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c010240d:	a3 b8 40 15 c0       	mov    %eax,0xc01540b8
c0102412:	eb 12                	jmp    c0102426 <find_and_wake+0xd0>
	else
		pre->next = sleep->next;
c0102414:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102417:	8b 90 4c 40 00 00    	mov    0x404c(%eax),%edx
c010241d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102420:	89 90 4c 40 00 00    	mov    %edx,0x404c(%eax)
	//sleep_list = sleep->next;

	sleep->next = NULL;
c0102426:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102429:	c7 80 4c 40 00 00 00 	movl   $0x0,0x404c(%eax)
c0102430:	00 00 00 

	return 1;
c0102433:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0102438:	c9                   	leave  
c0102439:	c3                   	ret    

c010243a <do_timer>:
void do_timer(){
c010243a:	55                   	push   %ebp
c010243b:	89 e5                	mov    %esp,%ebp
c010243d:	83 ec 10             	sub    $0x10,%esp
	_tick++;
c0102440:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c0102445:	83 c0 01             	add    $0x1,%eax
c0102448:	a3 8c 36 17 c0       	mov    %eax,0xc017368c
	current->timeslice ++;
c010244d:	a1 b0 40 15 c0       	mov    0xc01540b0,%eax
c0102452:	8b 90 40 40 00 00    	mov    0x4040(%eax),%edx
c0102458:	83 c2 01             	add    $0x1,%edx
c010245b:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)

	PCB *sleep = sleep_list;
c0102461:	a1 b8 40 15 c0       	mov    0xc01540b8,%eax
c0102466:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//printk("%x\n", sleep);
	 while(1){
	 	if(sleep == NULL)break;
c0102469:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010246d:	75 03                	jne    c0102472 <do_timer+0x38>
c010246f:	90                   	nop
	// 		select->ts = READY;
	// 		ready_list->tail->next = select;
	// 		ready_list->tail = select;
	 	sleep = sleep->next;
	}
	while(find_and_wake());
c0102470:	eb 23                	jmp    c0102495 <do_timer+0x5b>

	PCB *sleep = sleep_list;
	//printk("%x\n", sleep);
	 while(1){
	 	if(sleep == NULL)break;
	 	sleep->timeslice --;
c0102472:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102475:	8b 80 40 40 00 00    	mov    0x4040(%eax),%eax
c010247b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010247e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102481:	89 90 40 40 00 00    	mov    %edx,0x4040(%eax)
	// 		}
	// 		select->next = NULL;
	// 		select->ts = READY;
	// 		ready_list->tail->next = select;
	// 		ready_list->tail = select;
	 	sleep = sleep->next;
c0102487:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010248a:	8b 80 4c 40 00 00    	mov    0x404c(%eax),%eax
c0102490:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0102493:	eb d4                	jmp    c0102469 <do_timer+0x2f>
	while(find_and_wake());
c0102495:	e8 bc fe ff ff       	call   c0102356 <find_and_wake>
c010249a:	85 c0                	test   %eax,%eax
c010249c:	75 f7                	jne    c0102495 <do_timer+0x5b>
	//printk("lislen %d\n", lislen(sleep_list));
	//printk("realen %d\n", lislen(ready_list));
}
c010249e:	c9                   	leave  
c010249f:	c3                   	ret    

c01024a0 <tick>:
uint32_t tick(){
c01024a0:	55                   	push   %ebp
c01024a1:	89 e5                	mov    %esp,%ebp
	return _tick;
c01024a3:	a1 8c 36 17 c0       	mov    0xc017368c,%eax
c01024a8:	5d                   	pop    %ebp
c01024a9:	c3                   	ret    

c01024aa <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c01024aa:	6a 00                	push   $0x0
c01024ac:	6a 00                	push   $0x0
c01024ae:	e9 b8 00 00 00       	jmp    c010256b <asm_do_irq>

c01024b3 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c01024b3:	6a 00                	push   $0x0
c01024b5:	6a 01                	push   $0x1
c01024b7:	e9 af 00 00 00       	jmp    c010256b <asm_do_irq>

c01024bc <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c01024bc:	6a 00                	push   $0x0
c01024be:	6a 02                	push   $0x2
c01024c0:	e9 a6 00 00 00       	jmp    c010256b <asm_do_irq>

c01024c5 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c01024c5:	6a 00                	push   $0x0
c01024c7:	6a 03                	push   $0x3
c01024c9:	e9 9d 00 00 00       	jmp    c010256b <asm_do_irq>

c01024ce <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c01024ce:	6a 00                	push   $0x0
c01024d0:	6a 04                	push   $0x4
c01024d2:	e9 94 00 00 00       	jmp    c010256b <asm_do_irq>

c01024d7 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c01024d7:	6a 00                	push   $0x0
c01024d9:	6a 05                	push   $0x5
c01024db:	e9 8b 00 00 00       	jmp    c010256b <asm_do_irq>

c01024e0 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c01024e0:	6a 00                	push   $0x0
c01024e2:	6a 06                	push   $0x6
c01024e4:	e9 82 00 00 00       	jmp    c010256b <asm_do_irq>

c01024e9 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c01024e9:	6a 00                	push   $0x0
c01024eb:	6a 07                	push   $0x7
c01024ed:	e9 79 00 00 00       	jmp    c010256b <asm_do_irq>

c01024f2 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c01024f2:	6a 00                	push   $0x0
c01024f4:	6a 08                	push   $0x8
c01024f6:	e9 70 00 00 00       	jmp    c010256b <asm_do_irq>

c01024fb <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c01024fb:	6a 00                	push   $0x0
c01024fd:	6a 09                	push   $0x9
c01024ff:	e9 67 00 00 00       	jmp    c010256b <asm_do_irq>

c0102504 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0102504:	6a 00                	push   $0x0
c0102506:	6a 0a                	push   $0xa
c0102508:	e9 5e 00 00 00       	jmp    c010256b <asm_do_irq>

c010250d <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c010250d:	6a 00                	push   $0x0
c010250f:	6a 0b                	push   $0xb
c0102511:	e9 55 00 00 00       	jmp    c010256b <asm_do_irq>

c0102516 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102516:	6a 00                	push   $0x0
c0102518:	6a 0c                	push   $0xc
c010251a:	e9 4c 00 00 00       	jmp    c010256b <asm_do_irq>

c010251f <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c010251f:	6a 00                	push   $0x0
c0102521:	6a 0d                	push   $0xd
c0102523:	e9 43 00 00 00       	jmp    c010256b <asm_do_irq>

c0102528 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102528:	6a 00                	push   $0x0
c010252a:	6a 0e                	push   $0xe
c010252c:	e9 3a 00 00 00       	jmp    c010256b <asm_do_irq>

c0102531 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102531:	fa                   	cli    
c0102532:	6a 00                	push   $0x0
c0102534:	68 80 00 00 00       	push   $0x80
c0102539:	e9 2d 00 00 00       	jmp    c010256b <asm_do_irq>

c010253e <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c010253e:	6a 00                	push   $0x0
c0102540:	68 e8 03 00 00       	push   $0x3e8
c0102545:	e9 21 00 00 00       	jmp    c010256b <asm_do_irq>

c010254a <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c010254a:	6a 00                	push   $0x0
c010254c:	68 e9 03 00 00       	push   $0x3e9
c0102551:	e9 15 00 00 00       	jmp    c010256b <asm_do_irq>

c0102556 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0102556:	6a 00                	push   $0x0
c0102558:	68 f6 03 00 00       	push   $0x3f6
c010255d:	e9 09 00 00 00       	jmp    c010256b <asm_do_irq>

c0102562 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0102562:	6a 00                	push   $0x0
c0102564:	6a ff                	push   $0xffffffff
c0102566:	e9 00 00 00 00       	jmp    c010256b <asm_do_irq>

c010256b <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c010256b:	fa                   	cli    
  pushl %ds
c010256c:	1e                   	push   %ds
  pushl %es
c010256d:	06                   	push   %es
  pushl %fs
c010256e:	0f a0                	push   %fs
  pushl %gs
c0102570:	0f a8                	push   %gs
	pushal
c0102572:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0102573:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0102577:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102579:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c010257b:	54                   	push   %esp
  call irq_handle
c010257c:	e8 dd e8 ff ff       	call   c0100e5e <irq_handle>
  addl $4, %esp
c0102581:	83 c4 04             	add    $0x4,%esp

c0102584 <switch_proc>:
switch_proc:
  popal
c0102584:	61                   	popa   
  popl %gs
c0102585:	0f a9                	pop    %gs
  popl %fs
c0102587:	0f a1                	pop    %fs
  popl %es
c0102589:	07                   	pop    %es
  popl %ds
c010258a:	1f                   	pop    %ds
  addl $8, %esp
c010258b:	83 c4 08             	add    $0x8,%esp
  sti
c010258e:	fb                   	sti    
  iret
c010258f:	cf                   	iret   
c0102590:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0102596:	00 00                	add    %al,(%eax)
c0102598:	fe 4f 52             	decb   0x52(%edi)
c010259b:	e4 66                	in     $0x66,%al

c010259c <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c010259c:	66 c7 05 72 04 00 00 34 12 b8 00 50 10 00 0f 22     f..r...4...P..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c01025ac:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 bf 25 10     .. ......."...%.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c01025bc:	c0 ff e0                                            ...

c01025bf <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c01025bf:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c01025c4:	bc 00 f0 10 c0       	mov    $0xc010f000,%esp

	# now to C code

	call	main
c01025c9:	e8 77 ef ff ff       	call   c0101545 <main>

c01025ce <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c01025ce:	eb fe                	jmp    c01025ce <spin>

c01025d0 <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c01025d0:	55                   	push   %ebp
c01025d1:	89 e5                	mov    %esp,%ebp
c01025d3:	53                   	push   %ebx
c01025d4:	83 ec 04             	sub    $0x4,%esp
c01025d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025da:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c01025dd:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c01025e2:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c01025e6:	89 d3                	mov    %edx,%ebx
c01025e8:	cd 80                	int    $0x80
}
c01025ea:	83 c4 04             	add    $0x4,%esp
c01025ed:	5b                   	pop    %ebx
c01025ee:	5d                   	pop    %ebp
c01025ef:	c3                   	ret    

c01025f0 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c01025f0:	55                   	push   %ebp
c01025f1:	89 e5                	mov    %esp,%ebp
c01025f3:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c01025f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c01025fc:	eb 19                	jmp    c0102617 <printp+0x27>
		printer(cur);
c01025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102601:	0f b6 00             	movzbl (%eax),%eax
c0102604:	0f be c0             	movsbl %al,%eax
c0102607:	83 ec 0c             	sub    $0xc,%esp
c010260a:	50                   	push   %eax
c010260b:	8b 45 08             	mov    0x8(%ebp),%eax
c010260e:	ff d0                	call   *%eax
c0102610:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0102613:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010261a:	0f b6 00             	movzbl (%eax),%eax
c010261d:	84 c0                	test   %al,%al
c010261f:	75 dd                	jne    c01025fe <printp+0xe>
		printer(cur);
	}
}
c0102621:	c9                   	leave  
c0102622:	c3                   	ret    

c0102623 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0102623:	55                   	push   %ebp
c0102624:	89 e5                	mov    %esp,%ebp
c0102626:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0102629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c010262f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0102636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c010263d:	8b 45 10             	mov    0x10(%ebp),%eax
c0102640:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0102643:	e9 65 02 00 00       	jmp    c01028ad <vfprintf+0x28a>

		if(cur == '%'){
c0102648:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010264b:	0f b6 00             	movzbl (%eax),%eax
c010264e:	3c 25                	cmp    $0x25,%al
c0102650:	75 0c                	jne    c010265e <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0102652:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0102659:	e9 4b 02 00 00       	jmp    c01028a9 <vfprintf+0x286>
		}
		if(type == READ){
c010265e:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0102662:	0f 85 26 02 00 00    	jne    c010288e <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0102668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010266b:	0f b6 00             	movzbl (%eax),%eax
c010266e:	3c 73                	cmp    $0x73,%al
c0102670:	75 35                	jne    c01026a7 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0102672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102675:	8b 00                	mov    (%eax),%eax
c0102677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c010267a:	eb 19                	jmp    c0102695 <vfprintf+0x72>
					printer(*p);
c010267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010267f:	0f b6 00             	movzbl (%eax),%eax
c0102682:	0f be c0             	movsbl %al,%eax
c0102685:	83 ec 0c             	sub    $0xc,%esp
c0102688:	50                   	push   %eax
c0102689:	8b 45 08             	mov    0x8(%ebp),%eax
c010268c:	ff d0                	call   *%eax
c010268e:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0102691:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0102695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102698:	0f b6 00             	movzbl (%eax),%eax
c010269b:	84 c0                	test   %al,%al
c010269d:	75 dd                	jne    c010267c <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c010269f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01026a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c01026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026aa:	0f b6 00             	movzbl (%eax),%eax
c01026ad:	3c 78                	cmp    $0x78,%al
c01026af:	0f 85 99 00 00 00    	jne    c010274e <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c01026b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01026b8:	8b 00                	mov    (%eax),%eax
c01026ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c01026bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01026c1:	75 1d                	jne    c01026e0 <vfprintf+0xbd>
					printer('0');
c01026c3:	83 ec 0c             	sub    $0xc,%esp
c01026c6:	6a 30                	push   $0x30
c01026c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01026cb:	ff d0                	call   *%eax
c01026cd:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01026d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01026d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01026db:	e9 c9 01 00 00       	jmp    c01028a9 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c01026e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c01026e7:	eb 2d                	jmp    c0102716 <vfprintf+0xf3>
					int d=(x%16);
c01026e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01026ec:	83 e0 0f             	and    $0xf,%eax
c01026ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c01026f2:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c01026f6:	7e 04                	jle    c01026fc <vfprintf+0xd9>
						d+='a'-'0'-10;
c01026f8:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c01026fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01026ff:	83 c0 30             	add    $0x30,%eax
c0102702:	89 c1                	mov    %eax,%ecx
c0102704:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102707:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010270a:	01 d0                	add    %edx,%eax
c010270c:	88 08                	mov    %cl,(%eax)
					x>>=4;
c010270e:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c0102712:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102716:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010271a:	75 cd                	jne    c01026e9 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c010271c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0102720:	eb 1e                	jmp    c0102740 <vfprintf+0x11d>
					printer(digits[di]);
c0102722:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0102725:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102728:	01 d0                	add    %edx,%eax
c010272a:	0f b6 00             	movzbl (%eax),%eax
c010272d:	0f be c0             	movsbl %al,%eax
c0102730:	83 ec 0c             	sub    $0xc,%esp
c0102733:	50                   	push   %eax
c0102734:	8b 45 08             	mov    0x8(%ebp),%eax
c0102737:	ff d0                	call   *%eax
c0102739:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c010273c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0102740:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102744:	79 dc                	jns    c0102722 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0102746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010274a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c010274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102751:	0f b6 00             	movzbl (%eax),%eax
c0102754:	3c 64                	cmp    $0x64,%al
c0102756:	0f 85 02 01 00 00    	jne    c010285e <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c010275c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010275f:	8b 00                	mov    (%eax),%eax
c0102761:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0102764:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c010276b:	75 23                	jne    c0102790 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c010276d:	83 ec 08             	sub    $0x8,%esp
c0102770:	68 91 2a 10 c0       	push   $0xc0102a91
c0102775:	ff 75 08             	pushl  0x8(%ebp)
c0102778:	e8 73 fe ff ff       	call   c01025f0 <printp>
c010277d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0102780:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0102784:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c010278b:	e9 19 01 00 00       	jmp    c01028a9 <vfprintf+0x286>
				}
				if(x==0){
c0102790:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102794:	75 1e                	jne    c01027b4 <vfprintf+0x191>
					printer('0');
c0102796:	83 ec 0c             	sub    $0xc,%esp
c0102799:	6a 30                	push   $0x30
c010279b:	8b 45 08             	mov    0x8(%ebp),%eax
c010279e:	ff d0                	call   *%eax
c01027a0:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01027a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01027a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01027ae:	90                   	nop
c01027af:	e9 f5 00 00 00       	jmp    c01028a9 <vfprintf+0x286>
				}
				if(x<0){
c01027b4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01027b8:	79 10                	jns    c01027ca <vfprintf+0x1a7>
					printer('-');
c01027ba:	83 ec 0c             	sub    $0xc,%esp
c01027bd:	6a 2d                	push   $0x2d
c01027bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c2:	ff d0                	call   *%eax
c01027c4:	83 c4 10             	add    $0x10,%esp
					x=-x;
c01027c7:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c01027ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c01027d1:	eb 53                	jmp    c0102826 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c01027d3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01027d6:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01027db:	89 c8                	mov    %ecx,%eax
c01027dd:	f7 ea                	imul   %edx
c01027df:	c1 fa 02             	sar    $0x2,%edx
c01027e2:	89 c8                	mov    %ecx,%eax
c01027e4:	c1 f8 1f             	sar    $0x1f,%eax
c01027e7:	29 c2                	sub    %eax,%edx
c01027e9:	89 d0                	mov    %edx,%eax
c01027eb:	c1 e0 02             	shl    $0x2,%eax
c01027ee:	01 d0                	add    %edx,%eax
c01027f0:	01 c0                	add    %eax,%eax
c01027f2:	29 c1                	sub    %eax,%ecx
c01027f4:	89 ca                	mov    %ecx,%edx
c01027f6:	89 d0                	mov    %edx,%eax
c01027f8:	83 c0 30             	add    $0x30,%eax
c01027fb:	89 c1                	mov    %eax,%ecx
c01027fd:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0102800:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102803:	01 d0                	add    %edx,%eax
c0102805:	88 08                	mov    %cl,(%eax)
					x/=10;
c0102807:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010280a:	ba 67 66 66 66       	mov    $0x66666667,%edx
c010280f:	89 c8                	mov    %ecx,%eax
c0102811:	f7 ea                	imul   %edx
c0102813:	c1 fa 02             	sar    $0x2,%edx
c0102816:	89 c8                	mov    %ecx,%eax
c0102818:	c1 f8 1f             	sar    $0x1f,%eax
c010281b:	29 c2                	sub    %eax,%edx
c010281d:	89 d0                	mov    %edx,%eax
c010281f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c0102822:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0102826:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010282a:	7f a7                	jg     c01027d3 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c010282c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0102830:	eb 1e                	jmp    c0102850 <vfprintf+0x22d>
					printer(digits[di]);
c0102832:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0102835:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102838:	01 d0                	add    %edx,%eax
c010283a:	0f b6 00             	movzbl (%eax),%eax
c010283d:	0f be c0             	movsbl %al,%eax
c0102840:	83 ec 0c             	sub    $0xc,%esp
c0102843:	50                   	push   %eax
c0102844:	8b 45 08             	mov    0x8(%ebp),%eax
c0102847:	ff d0                	call   *%eax
c0102849:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c010284c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0102850:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102854:	79 dc                	jns    c0102832 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0102856:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010285a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c010285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102861:	0f b6 00             	movzbl (%eax),%eax
c0102864:	3c 63                	cmp    $0x63,%al
c0102866:	75 1d                	jne    c0102885 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0102868:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010286b:	0f b6 00             	movzbl (%eax),%eax
c010286e:	0f be c0             	movsbl %al,%eax
c0102871:	83 ec 0c             	sub    $0xc,%esp
c0102874:	50                   	push   %eax
c0102875:	8b 45 08             	mov    0x8(%ebp),%eax
c0102878:	ff d0                	call   *%eax
c010287a:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c010287d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0102881:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0102885:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c010288c:	eb 1b                	jmp    c01028a9 <vfprintf+0x286>
		}
		if(type == NONE){
c010288e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102892:	75 15                	jne    c01028a9 <vfprintf+0x286>
			printer(cur);
c0102894:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102897:	0f b6 00             	movzbl (%eax),%eax
c010289a:	0f be c0             	movsbl %al,%eax
c010289d:	83 ec 0c             	sub    $0xc,%esp
c01028a0:	50                   	push   %eax
c01028a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028a4:	ff d0                	call   *%eax
c01028a6:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01028a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028b0:	0f b6 00             	movzbl (%eax),%eax
c01028b3:	84 c0                	test   %al,%al
c01028b5:	0f 85 8d fd ff ff    	jne    c0102648 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c01028bb:	c9                   	leave  
c01028bc:	c3                   	ret    

c01028bd <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c01028bd:	55                   	push   %ebp
c01028be:	89 e5                	mov    %esp,%ebp
c01028c0:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01028c3:	8d 45 0c             	lea    0xc(%ebp),%eax
c01028c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c01028c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01028cc:	83 ec 04             	sub    $0x4,%esp
c01028cf:	ff 75 f4             	pushl  -0xc(%ebp)
c01028d2:	50                   	push   %eax
c01028d3:	68 d0 25 10 c0       	push   $0xc01025d0
c01028d8:	e8 46 fd ff ff       	call   c0102623 <vfprintf>
c01028dd:	83 c4 10             	add    $0x10,%esp
}
c01028e0:	c9                   	leave  
c01028e1:	c3                   	ret    
