
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
c01000ba:	e8 34 42 00 00       	call   c01042f3 <vfprintf>
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
c01000f0:	68 b4 45 10 c0       	push   $0xc01045b4
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
c0100371:	68 d7 45 10 c0       	push   $0xc01045d7
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
c0100415:	68 d7 45 10 c0       	push   $0xc01045d7
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
c0100448:	b8 53 42 10 c0       	mov    $0xc0104253,%eax
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
c0100583:	e8 6b 3d 00 00       	call   c01042f3 <vfprintf>
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
c01005d6:	68 f0 45 10 c0       	push   $0xc01045f0
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
c010060c:	68 14 46 10 c0       	push   $0xc0104614
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
c010064e:	68 38 46 10 c0       	push   $0xc0104638
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
c0100682:	68 57 46 10 c0       	push   $0xc0104657
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
c010074d:	68 6d 46 10 c0       	push   $0xc010466d
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
c01007ae:	68 6d 46 10 c0       	push   $0xc010466d
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
c010089a:	68 88 46 10 c0       	push   $0xc0104688
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
c010097f:	68 6d 46 10 c0       	push   $0xc010466d
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
c01009fb:	68 6d 46 10 c0       	push   $0xc010466d
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
c0100b9d:	68 6d 46 10 c0       	push   $0xc010466d
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
c0100c27:	68 6d 46 10 c0       	push   $0xc010466d
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
c0100cd9:	68 6d 46 10 c0       	push   $0xc010466d
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
c0100e4f:	68 6d 46 10 c0       	push   $0xc010466d
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
c0100f53:	e8 c8 26 00 00       	call   c0103620 <ll_pop>
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
c0100f71:	e8 0c 27 00 00       	call   c0103682 <ll_entail>
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
c0100fb1:	e8 6a 26 00 00       	call   c0103620 <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 60 15 c0       	push   $0xc01560b0
c0100fc7:	e8 b6 26 00 00       	call   c0103682 <ll_entail>
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
c0101010:	e8 6d 26 00 00       	call   c0103682 <ll_entail>
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
c01010cf:	e8 4c 25 00 00       	call   c0103620 <ll_pop>
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
c010112e:	e8 4f 25 00 00       	call   c0103682 <ll_entail>
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
c0101184:	e8 f9 24 00 00       	call   c0103682 <ll_entail>
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
c01011d0:	e8 55 1f 00 00       	call   c010312a <do_syscall>
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
c01011e5:	e8 e1 2e 00 00       	call   c01040cb <do_timer>
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
c010126f:	e8 dc 1d 00 00       	call   c0103050 <press_key>
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
c01013d2:	ba 31 42 10 c0       	mov    $0xc0104231,%edx
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
c01013fd:	b8 79 41 10 c0       	mov    $0xc0104179,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 40 89 1b c0       	push   $0xc01b8940
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 82 41 10 c0       	mov    $0xc0104182,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 48 89 1b c0       	push   $0xc01b8948
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 8b 41 10 c0       	mov    $0xc010418b,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 50 89 1b c0       	push   $0xc01b8950
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 94 41 10 c0       	mov    $0xc0104194,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 58 89 1b c0       	push   $0xc01b8958
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 9d 41 10 c0       	mov    $0xc010419d,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 60 89 1b c0       	push   $0xc01b8960
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 a6 41 10 c0       	mov    $0xc01041a6,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 68 89 1b c0       	push   $0xc01b8968
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 af 41 10 c0       	mov    $0xc01041af,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 70 89 1b c0       	push   $0xc01b8970
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 b8 41 10 c0       	mov    $0xc01041b8,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 78 89 1b c0       	push   $0xc01b8978
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 c1 41 10 c0       	mov    $0xc01041c1,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 80 89 1b c0       	push   $0xc01b8980
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 ca 41 10 c0       	mov    $0xc01041ca,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 88 89 1b c0       	push   $0xc01b8988
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 d3 41 10 c0       	mov    $0xc01041d3,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 90 89 1b c0       	push   $0xc01b8990
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 dc 41 10 c0       	mov    $0xc01041dc,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 98 89 1b c0       	push   $0xc01b8998
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 e5 41 10 c0       	mov    $0xc01041e5,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 a0 89 1b c0       	push   $0xc01b89a0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 ee 41 10 c0       	mov    $0xc01041ee,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 a8 89 1b c0       	push   $0xc01b89a8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 00 42 10 c0       	mov    $0xc0104200,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 40 8d 1b c0       	push   $0xc01b8d40
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 0d 42 10 c0       	mov    $0xc010420d,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 40 8a 1b c0       	push   $0xc01b8a40
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 19 42 10 c0       	mov    $0xc0104219,%eax
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
c010160e:	e8 e0 2c 00 00       	call   c01042f3 <vfprintf>
c0101613:	83 c4 10             	add    $0x10,%esp
}
c0101616:	c9                   	leave  
c0101617:	c3                   	ret    

c0101618 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
c0101618:	55                   	push   %ebp
c0101619:	89 e5                	mov    %esp,%ebp
c010161b:	57                   	push   %edi
c010161c:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
c010161d:	8b 55 10             	mov    0x10(%ebp),%edx
c0101620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101623:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101626:	89 d1                	mov    %edx,%ecx
c0101628:	89 df                	mov    %ebx,%edi
c010162a:	fc                   	cld    
c010162b:	f3 ab                	rep stos %eax,%es:(%edi)
}
c010162d:	5b                   	pop    %ebx
c010162e:	5f                   	pop    %edi
c010162f:	5d                   	pop    %ebp
c0101630:	c3                   	ret    

c0101631 <memcpy2>:
static inline void memcpy2(void* dst, void* src, int len){
c0101631:	55                   	push   %ebp
c0101632:	89 e5                	mov    %esp,%ebp
c0101634:	57                   	push   %edi
c0101635:	56                   	push   %esi
c0101636:	53                   	push   %ebx
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
c0101637:	8b 45 10             	mov    0x10(%ebp),%eax
c010163a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010163d:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0101640:	89 c1                	mov    %eax,%ecx
c0101642:	89 d6                	mov    %edx,%esi
c0101644:	89 df                	mov    %ebx,%edi
c0101646:	fc                   	cld    
c0101647:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
c0101649:	5b                   	pop    %ebx
c010164a:	5e                   	pop    %esi
c010164b:	5f                   	pop    %edi
c010164c:	5d                   	pop    %ebp
c010164d:	c3                   	ret    

c010164e <strcmp>:

static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
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
c0101921:	68 40 d9 1d c0       	push   $0xc01dd940
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
c010193c:	68 40 d9 1d c0       	push   $0xc01dd940
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
c0101957:	68 40 db 1d c0       	push   $0xc01ddb40
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
c0101972:	68 40 db 1d c0       	push   $0xc01ddb40
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
c010198d:	68 40 d7 1d c0       	push   $0xc01dd740
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
c01019a8:	68 40 d7 1d c0       	push   $0xc01dd740
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
c01019fd:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a02:	0f b6 00             	movzbl (%eax),%eax
c0101a05:	0f b6 c0             	movzbl %al,%eax
c0101a08:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a0b:	85 c0                	test   %eax,%eax
c0101a0d:	75 28                	jne    c0101a37 <INodeAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a12:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a17:	0f b6 00             	movzbl (%eax),%eax
c0101a1a:	89 c2                	mov    %eax,%edx
c0101a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a1f:	09 d0                	or     %edx,%eax
c0101a21:	89 c2                	mov    %eax,%edx
c0101a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a26:	05 40 91 1b c0       	add    $0xc01b9140,%eax
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
c0101a91:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a96:	0f b6 00             	movzbl (%eax),%eax
c0101a99:	0f b6 c0             	movzbl %al,%eax
c0101a9c:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a9f:	85 c0                	test   %eax,%eax
c0101aa1:	75 28                	jne    c0101acb <dataAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aa6:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101aab:	0f b6 00             	movzbl (%eax),%eax
c0101aae:	89 c2                	mov    %eax,%edx
c0101ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ab3:	09 d0                	or     %edx,%eax
c0101ab5:	89 c2                	mov    %eax,%edx
c0101ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aba:	05 40 91 1b c0       	add    $0xc01b9140,%eax
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
c0101b0f:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
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
c0101b50:	e9 1a 01 00 00       	jmp    c0101c6f <fs_open_kr+0x190>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b58:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b5e:	05 20 02 00 00       	add    $0x220,%eax
c0101b63:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b68:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c0101b6c:	84 c0                	test   %al,%al
c0101b6e:	0f 85 e8 00 00 00    	jne    c0101c5c <fs_open_kr+0x17d>
			fs[i].used = 1;
c0101b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b77:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101b7d:	05 20 02 00 00       	add    $0x220,%eax
c0101b82:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b87:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b8e:	c1 e0 05             	shl    $0x5,%eax
c0101b91:	83 c0 10             	add    $0x10,%eax
c0101b94:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c0101b99:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b9f:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101ba5:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101bab:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101bb1:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bb7:	c1 e0 05             	shl    $0x5,%eax
c0101bba:	8d 90 40 d9 1d c0    	lea    -0x3fe226c0(%eax),%edx
c0101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc3:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101bc9:	05 10 02 00 00       	add    $0x210,%eax
c0101bce:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101bd3:	83 c0 04             	add    $0x4,%eax
c0101bd6:	52                   	push   %edx
c0101bd7:	50                   	push   %eax
c0101bd8:	e8 b0 fa ff ff       	call   c010168d <strcpy>
c0101bdd:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101be0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101be3:	c1 e0 05             	shl    $0x5,%eax
c0101be6:	83 c0 10             	add    $0x10,%eax
c0101be9:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c0101bee:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bf4:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101bfa:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c00:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101c06:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("$%d %d$\n", fs[i].file_size, fs[i].inode_offset);
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0c:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c12:	05 00 02 00 00       	add    $0x200,%eax
c0101c17:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0101c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c28:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c2e:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101c34:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101c3a:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0101c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c43:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0101c49:	81 c2 10 02 00 00    	add    $0x210,%edx
c0101c4f:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101c55:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c5a:	eb 13                	jmp    c0101c6f <fs_open_kr+0x190>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101c5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c60:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0101c64:	0f 8e eb fe ff ff    	jle    c0101b55 <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101c6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101c6f:	c9                   	leave  
c0101c70:	c3                   	ret    

c0101c71 <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101c71:	55                   	push   %ebp
c0101c72:	89 e5                	mov    %esp,%ebp
c0101c74:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101c80:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c85:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c8b:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101c91:	50                   	push   %eax
c0101c92:	e8 b4 fc ff ff       	call   c010194b <readINode>
c0101c97:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101c9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ca4:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101caa:	c1 e8 09             	shr    $0x9,%eax
c0101cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101cb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cb3:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cb9:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101cc1:	8b 55 10             	mov    0x10(%ebp),%edx
c0101cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cc7:	01 d0                	add    %edx,%eax
c0101cc9:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101cce:	0f 86 2d 01 00 00    	jbe    c0101e01 <fs_read_base_kr+0x190>
		readData(inode.data_block_offsets[D]);
c0101cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cd7:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101cde:	50                   	push   %eax
c0101cdf:	e8 9d fc ff ff       	call   c0101981 <readData>
c0101ce4:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101ce7:	b8 00 02 00 00       	mov    $0x200,%eax
c0101cec:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cef:	89 c2                	mov    %eax,%edx
c0101cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cf4:	05 40 d7 1d c0       	add    $0xc01dd740,%eax
c0101cf9:	52                   	push   %edx
c0101cfa:	50                   	push   %eax
c0101cfb:	ff 75 0c             	pushl  0xc(%ebp)
c0101cfe:	e8 2e f9 ff ff       	call   c0101631 <memcpy2>
c0101d03:	83 c4 0c             	add    $0xc,%esp
		f->offset += BLOCK_SIZE-R;
c0101d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d09:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d0f:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d12:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d18:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d1b:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d24:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101d27:	05 00 02 00 00       	add    $0x200,%eax
c0101d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101d2f:	8b 55 10             	mov    0x10(%ebp),%edx
c0101d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d35:	01 d0                	add    %edx,%eax
c0101d37:	2d 00 02 00 00       	sub    $0x200,%eax
c0101d3c:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d3f:	eb 63                	jmp    c0101da4 <fs_read_base_kr+0x133>
			D = f->offset >> 9;
c0101d41:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d44:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d4a:	c1 e8 09             	shr    $0x9,%eax
c0101d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
c0101d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d53:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101d5a:	50                   	push   %eax
c0101d5b:	e8 21 fc ff ff       	call   c0101981 <readData>
c0101d60:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101d63:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d69:	01 d0                	add    %edx,%eax
c0101d6b:	68 00 02 00 00       	push   $0x200
c0101d70:	68 40 d7 1d c0       	push   $0xc01dd740
c0101d75:	50                   	push   %eax
c0101d76:	e8 b6 f8 ff ff       	call   c0101631 <memcpy2>
c0101d7b:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101d7e:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d88:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d8e:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d97:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101d9d:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101da4:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101dab:	7f 94                	jg     c0101d41 <fs_read_base_kr+0xd0>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101db0:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101db6:	c1 e8 09             	shr    $0x9,%eax
c0101db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101dbf:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101dc6:	50                   	push   %eax
c0101dc7:	e8 b5 fb ff ff       	call   c0101981 <readData>
c0101dcc:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101dd5:	01 d0                	add    %edx,%eax
c0101dd7:	ff 75 10             	pushl  0x10(%ebp)
c0101dda:	68 40 d7 1d c0       	push   $0xc01dd740
c0101ddf:	50                   	push   %eax
c0101de0:	e8 4c f8 ff ff       	call   c0101631 <memcpy2>
c0101de5:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101deb:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101df1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101df4:	01 c2                	add    %eax,%edx
c0101df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101df9:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101dff:	eb 41                	jmp    c0101e42 <fs_read_base_kr+0x1d1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e04:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101e0b:	50                   	push   %eax
c0101e0c:	e8 70 fb ff ff       	call   c0101981 <readData>
c0101e11:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e17:	05 40 d7 1d c0       	add    $0xc01dd740,%eax
c0101e1c:	ff 75 10             	pushl  0x10(%ebp)
c0101e1f:	50                   	push   %eax
c0101e20:	ff 75 0c             	pushl  0xc(%ebp)
c0101e23:	e8 09 f8 ff ff       	call   c0101631 <memcpy2>
c0101e28:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e2e:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e34:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e37:	01 c2                	add    %eax,%edx
c0101e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e3c:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101e42:	c9                   	leave  
c0101e43:	c3                   	ret    

c0101e44 <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101e44:	55                   	push   %ebp
c0101e45:	89 e5                	mov    %esp,%ebp
c0101e47:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4d:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101e53:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e5e:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e64:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e67:	01 c2                	add    %eax,%edx
c0101e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e6c:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101e72:	39 c2                	cmp    %eax,%edx
c0101e74:	72 19                	jb     c0101e8f <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e79:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e82:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e88:	29 c2                	sub    %eax,%edx
c0101e8a:	89 d0                	mov    %edx,%eax
c0101e8c:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	fs_read_base_kr(fd, buf, len);
c0101e8f:	ff 75 10             	pushl  0x10(%ebp)
c0101e92:	ff 75 0c             	pushl  0xc(%ebp)
c0101e95:	ff 75 08             	pushl  0x8(%ebp)
c0101e98:	e8 d4 fd ff ff       	call   c0101c71 <fs_read_base_kr>
c0101e9d:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101ea0:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101ea3:	c9                   	leave  
c0101ea4:	c3                   	ret    

c0101ea5 <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101ea5:	55                   	push   %ebp
c0101ea6:	89 e5                	mov    %esp,%ebp
c0101ea8:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eae:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0101eb4:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101eb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ebf:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101ec5:	50                   	push   %eax
c0101ec6:	e8 80 fa ff ff       	call   c010194b <readINode>
c0101ecb:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101ece:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ed8:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ede:	c1 e8 09             	shr    $0x9,%eax
c0101ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101ee4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ee7:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101eed:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101ef2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101ef5:	8b 55 10             	mov    0x10(%ebp),%edx
c0101ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101efb:	01 d0                	add    %edx,%eax
c0101efd:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f02:	0f 86 53 01 00 00    	jbe    c010205b <fs_write_base_kr+0x1b6>
		readData(inode.data_block_offsets[D]);
c0101f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f0b:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101f12:	50                   	push   %eax
c0101f13:	e8 69 fa ff ff       	call   c0101981 <readData>
c0101f18:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101f1b:	b8 00 02 00 00       	mov    $0x200,%eax
c0101f20:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f23:	89 c2                	mov    %eax,%edx
c0101f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f28:	05 40 d7 1d c0       	add    $0xc01dd740,%eax
c0101f2d:	52                   	push   %edx
c0101f2e:	ff 75 0c             	pushl  0xc(%ebp)
c0101f31:	50                   	push   %eax
c0101f32:	e8 fa f6 ff ff       	call   c0101631 <memcpy2>
c0101f37:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f3d:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101f44:	50                   	push   %eax
c0101f45:	e8 52 fa ff ff       	call   c010199c <saveData>
c0101f4a:	83 c4 04             	add    $0x4,%esp
		f->offset += BLOCK_SIZE-R;
c0101f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f50:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f56:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f59:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f62:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f6b:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f6e:	05 00 02 00 00       	add    $0x200,%eax
c0101f73:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101f76:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f7c:	01 d0                	add    %edx,%eax
c0101f7e:	2d 00 02 00 00       	sub    $0x200,%eax
c0101f83:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f86:	eb 63                	jmp    c0101feb <fs_write_base_kr+0x146>
			D = f->offset >> 9;
c0101f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f8b:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f91:	c1 e8 09             	shr    $0x9,%eax
c0101f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101f97:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f9d:	01 d0                	add    %edx,%eax
c0101f9f:	68 00 02 00 00       	push   $0x200
c0101fa4:	50                   	push   %eax
c0101fa5:	68 40 d7 1d c0       	push   $0xc01dd740
c0101faa:	e8 82 f6 ff ff       	call   c0101631 <memcpy2>
c0101faf:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fb5:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0101fbc:	50                   	push   %eax
c0101fbd:	e8 da f9 ff ff       	call   c010199c <saveData>
c0101fc2:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c0101fc5:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fcf:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101fd5:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fde:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101fe4:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101feb:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101ff2:	7f 94                	jg     c0101f88 <fs_write_base_kr+0xe3>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ff7:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101ffd:	c1 e8 09             	shr    $0x9,%eax
c0102000:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0102003:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102006:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c010200d:	50                   	push   %eax
c010200e:	e8 6e f9 ff ff       	call   c0101981 <readData>
c0102013:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c0102016:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102019:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010201c:	01 d0                	add    %edx,%eax
c010201e:	ff 75 10             	pushl  0x10(%ebp)
c0102021:	50                   	push   %eax
c0102022:	68 40 d7 1d c0       	push   $0xc01dd740
c0102027:	e8 05 f6 ff ff       	call   c0101631 <memcpy2>
c010202c:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c010202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102032:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0102039:	50                   	push   %eax
c010203a:	e8 5d f9 ff ff       	call   c010199c <saveData>
c010203f:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0102042:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102045:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c010204b:	8b 45 10             	mov    0x10(%ebp),%eax
c010204e:	01 c2                	add    %eax,%edx
c0102050:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102053:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0102059:	eb 54                	jmp    c01020af <fs_write_base_kr+0x20a>
	}else{
		readData(inode.data_block_offsets[D]);
c010205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010205e:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c0102065:	50                   	push   %eax
c0102066:	e8 16 f9 ff ff       	call   c0101981 <readData>
c010206b:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c010206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102071:	05 40 d7 1d c0       	add    $0xc01dd740,%eax
c0102076:	ff 75 10             	pushl  0x10(%ebp)
c0102079:	ff 75 0c             	pushl  0xc(%ebp)
c010207c:	50                   	push   %eax
c010207d:	e8 af f5 ff ff       	call   c0101631 <memcpy2>
c0102082:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102085:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102088:	8b 04 85 40 db 1d c0 	mov    -0x3fe224c0(,%eax,4),%eax
c010208f:	50                   	push   %eax
c0102090:	e8 07 f9 ff ff       	call   c010199c <saveData>
c0102095:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0102098:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010209b:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01020a4:	01 c2                	add    %eax,%edx
c01020a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020a9:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c01020af:	c9                   	leave  
c01020b0:	c3                   	ret    

c01020b1 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c01020b1:	55                   	push   %ebp
c01020b2:	89 e5                	mov    %esp,%ebp
c01020b4:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c01020b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ba:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01020c0:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01020c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	if(f->file_size == 0){
c01020c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020cb:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01020d1:	85 c0                	test   %eax,%eax
c01020d3:	75 48                	jne    c010211d <fs_write_kr+0x6c>
		readINode(f->inode_offset);
c01020d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020d8:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020de:	50                   	push   %eax
c01020df:	e8 67 f8 ff ff       	call   c010194b <readINode>
c01020e4:	83 c4 04             	add    $0x4,%esp
		inode.data_block_offsets[0] = dataAlloc();
c01020e7:	e8 5f f9 ff ff       	call   c0101a4b <dataAlloc>
c01020ec:	a3 40 db 1d c0       	mov    %eax,0xc01ddb40
		saveINode(f->inode_offset);
c01020f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020f4:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020fa:	50                   	push   %eax
c01020fb:	e8 66 f8 ff ff       	call   c0101966 <saveINode>
c0102100:	83 c4 04             	add    $0x4,%esp
		f->file_size = len>512?512:len;
c0102103:	8b 45 10             	mov    0x10(%ebp),%eax
c0102106:	3d 00 02 00 00       	cmp    $0x200,%eax
c010210b:	7e 05                	jle    c0102112 <fs_write_kr+0x61>
c010210d:	b8 00 02 00 00       	mov    $0x200,%eax
c0102112:	89 c2                	mov    %eax,%edx
c0102114:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102117:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
		//printk("legal high %d\n", f->file_size);
	}
	
	if(f->offset + len > f->file_size){
c010211d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102120:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102126:	8b 45 10             	mov    0x10(%ebp),%eax
c0102129:	01 c2                	add    %eax,%edx
c010212b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010212e:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0102134:	39 c2                	cmp    %eax,%edx
c0102136:	0f 86 81 00 00 00    	jbe    c01021bd <fs_write_kr+0x10c>
		readINode(f->inode_offset);
c010213c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010213f:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102145:	50                   	push   %eax
c0102146:	e8 00 f8 ff ff       	call   c010194b <readINode>
c010214b:	83 c4 04             	add    $0x4,%esp
		D1 = f->offset >> 9;
c010214e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102151:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0102157:	c1 e8 09             	shr    $0x9,%eax
c010215a:	89 45 fc             	mov    %eax,-0x4(%ebp)
		D2 = (f->offset + len) >> 9;
c010215d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102160:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102166:	8b 45 10             	mov    0x10(%ebp),%eax
c0102169:	01 d0                	add    %edx,%eax
c010216b:	c1 e8 09             	shr    $0x9,%eax
c010216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		D1 += 1;
c0102171:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
		while(D1<=D2){
c0102175:	eb 15                	jmp    c010218c <fs_write_kr+0xdb>
			inode.data_block_offsets[D1] = dataAlloc();
c0102177:	e8 cf f8 ff ff       	call   c0101a4b <dataAlloc>
c010217c:	89 c2                	mov    %eax,%edx
c010217e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102181:	89 14 85 40 db 1d c0 	mov    %edx,-0x3fe224c0(,%eax,4)
			D1 ++;
c0102188:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	if(f->offset + len > f->file_size){
		readINode(f->inode_offset);
		D1 = f->offset >> 9;
		D2 = (f->offset + len) >> 9;
		D1 += 1;
		while(D1<=D2){
c010218c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102192:	7e e3                	jle    c0102177 <fs_write_kr+0xc6>
			inode.data_block_offsets[D1] = dataAlloc();
			D1 ++;
		}
		saveINode(f->inode_offset);
c0102194:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102197:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c010219d:	50                   	push   %eax
c010219e:	e8 c3 f7 ff ff       	call   c0101966 <saveINode>
c01021a3:	83 c4 04             	add    $0x4,%esp
		f->file_size = f->offset + len;
c01021a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021a9:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01021af:	8b 45 10             	mov    0x10(%ebp),%eax
c01021b2:	01 c2                	add    %eax,%edx
c01021b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021b7:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	};
	readDir(f->dir_offset);
c01021bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021c0:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c01021c6:	50                   	push   %eax
c01021c7:	e8 49 f7 ff ff       	call   c0101915 <readDir>
c01021cc:	83 c4 04             	add    $0x4,%esp
	dir.entries[f->entry_offset].file_size = f->file_size;
c01021cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021d2:	8b 90 10 02 00 00    	mov    0x210(%eax),%edx
c01021d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021db:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01021e1:	c1 e2 05             	shl    $0x5,%edx
c01021e4:	83 c2 10             	add    $0x10,%edx
c01021e7:	81 c2 40 d9 1d c0    	add    $0xc01dd940,%edx
c01021ed:	89 42 08             	mov    %eax,0x8(%edx)
	saveDir(f->dir_offset);
c01021f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021f3:	8b 80 0c 02 00 00    	mov    0x20c(%eax),%eax
c01021f9:	50                   	push   %eax
c01021fa:	e8 31 f7 ff ff       	call   c0101930 <saveDir>
c01021ff:	83 c4 04             	add    $0x4,%esp
	fs_write_base_kr(fd, buf, len);
c0102202:	ff 75 10             	pushl  0x10(%ebp)
c0102205:	ff 75 0c             	pushl  0xc(%ebp)
c0102208:	ff 75 08             	pushl  0x8(%ebp)
c010220b:	e8 95 fc ff ff       	call   c0101ea5 <fs_write_base_kr>
c0102210:	83 c4 0c             	add    $0xc,%esp
	return len;
c0102213:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0102216:	c9                   	leave  
c0102217:	c3                   	ret    

c0102218 <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c0102218:	55                   	push   %ebp
c0102219:	89 e5                	mov    %esp,%ebp
c010221b:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c010221e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102221:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102227:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c010222c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c010222f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102232:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102235:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c010223b:	c9                   	leave  
c010223c:	c3                   	ret    

c010223d <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c010223d:	55                   	push   %ebp
c010223e:	89 e5                	mov    %esp,%ebp
c0102240:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102243:	8b 45 08             	mov    0x8(%ebp),%eax
c0102246:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010224c:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102251:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c0102254:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102257:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
	}
c010225d:	c9                   	leave  
c010225e:	c3                   	ret    

c010225f <fs_close_kr>:
int fs_close_kr(int fd){
c010225f:	55                   	push   %ebp
c0102260:	89 e5                	mov    %esp,%ebp
c0102262:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102265:	8b 45 08             	mov    0x8(%ebp),%eax
c0102268:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010226e:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->used){
c0102276:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102279:	0f b6 80 2c 02 00 00 	movzbl 0x22c(%eax),%eax
c0102280:	84 c0                	test   %al,%al
c0102282:	74 11                	je     c0102295 <fs_close_kr+0x36>
		f->used = 0;
c0102284:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102287:	c6 80 2c 02 00 00 00 	movb   $0x0,0x22c(%eax)
		return 0;
c010228e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102293:	eb 05                	jmp    c010229a <fs_close_kr+0x3b>
	}else
		return 1;
c0102295:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010229a:	c9                   	leave  
c010229b:	c3                   	ret    

c010229c <some>:
void some(){
c010229c:	55                   	push   %ebp
c010229d:	89 e5                	mov    %esp,%ebp

}
c010229f:	5d                   	pop    %ebp
c01022a0:	c3                   	ret    

c01022a1 <fs_create_kr>:
int fs_create_kr(char* name){
c01022a1:	55                   	push   %ebp
c01022a2:	89 e5                	mov    %esp,%ebp
c01022a4:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c01022a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01022ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c01022b5:	e9 d8 00 00 00       	jmp    c0102392 <fs_create_kr+0xf1>
		readDir(dir_offset);
c01022ba:	ff 75 fc             	pushl  -0x4(%ebp)
c01022bd:	e8 53 f6 ff ff       	call   c0101915 <readDir>
c01022c2:	83 c4 04             	add    $0x4,%esp
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c01022c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01022cc:	e9 b1 00 00 00       	jmp    c0102382 <fs_create_kr+0xe1>
			if(dir.entries[entry_offset].inode_offset == -1)
c01022d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01022d4:	c1 e0 05             	shl    $0x5,%eax
c01022d7:	83 c0 10             	add    $0x10,%eax
c01022da:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c01022df:	8b 40 0c             	mov    0xc(%eax),%eax
c01022e2:	83 f8 ff             	cmp    $0xffffffff,%eax
c01022e5:	0f 85 93 00 00 00    	jne    c010237e <fs_create_kr+0xdd>
				goto OUT_OF_LOOP;
c01022eb:	90                   	nop
	
	//FILE_STREAM *f;
	int i=0;

	OUT_OF_LOOP:
	some();
c01022ec:	e8 ab ff ff ff       	call   c010229c <some>
	//printk("##%d\n", entry_offset);
	int index_inode = INodeAlloc();
c01022f1:	e8 c1 f6 ff ff       	call   c01019b7 <INodeAlloc>
c01022f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//printk("##%d\n", index_inode);
	dir.entries[entry_offset].inode_offset = index_inode;
c01022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01022fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01022ff:	c1 e2 05             	shl    $0x5,%edx
c0102302:	83 c2 10             	add    $0x10,%edx
c0102305:	81 c2 40 d9 1d c0    	add    $0xc01dd940,%edx
c010230b:	89 42 0c             	mov    %eax,0xc(%edx)
	strcpy(dir.entries[entry_offset].filename, name);
c010230e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102311:	c1 e0 05             	shl    $0x5,%eax
c0102314:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c0102319:	ff 75 08             	pushl  0x8(%ebp)
c010231c:	50                   	push   %eax
c010231d:	e8 6b f3 ff ff       	call   c010168d <strcpy>
c0102322:	83 c4 08             	add    $0x8,%esp
	//printk("##%s\n", name);
	//printk("##%s\n", dir.entries[entry_offset].filename);
	dir.entries[entry_offset].file_size = 0;
c0102325:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102328:	c1 e0 05             	shl    $0x5,%eax
c010232b:	83 c0 10             	add    $0x10,%eax
c010232e:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c0102333:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
	saveDir(dir_offset);
c010233a:	ff 75 fc             	pushl  -0x4(%ebp)
c010233d:	e8 ee f5 ff ff       	call   c0101930 <saveDir>
c0102342:	83 c4 04             	add    $0x4,%esp

	readINode(index_inode);
c0102345:	ff 75 f0             	pushl  -0x10(%ebp)
c0102348:	e8 fe f5 ff ff       	call   c010194b <readINode>
c010234d:	83 c4 04             	add    $0x4,%esp
	memset(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
c0102350:	68 00 02 00 00       	push   $0x200
c0102355:	68 ff 00 00 00       	push   $0xff
c010235a:	68 40 db 1d c0       	push   $0xc01ddb40
c010235f:	e8 b4 f2 ff ff       	call   c0101618 <memset>
c0102364:	83 c4 0c             	add    $0xc,%esp
	saveINode(index_inode);
c0102367:	ff 75 f0             	pushl  -0x10(%ebp)
c010236a:	e8 f7 f5 ff ff       	call   c0101966 <saveINode>
c010236f:	83 c4 04             	add    $0x4,%esp
	for(i=0; i<NR_FILE_STREAM; i++){
c0102372:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102379:	e9 37 01 00 00       	jmp    c01024b5 <fs_create_kr+0x214>
}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c010237e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102382:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102385:	83 f8 0f             	cmp    $0xf,%eax
c0102388:	0f 86 43 ff ff ff    	jbe    c01022d1 <fs_create_kr+0x30>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
c010238e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
void some(){

}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0102392:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102399:	0f 8e 1b ff ff ff    	jle    c01022ba <fs_create_kr+0x19>
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
	}
	goto FAILURE;
c010239f:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c01023a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01023a5:	e9 1a 01 00 00       	jmp    c01024c4 <fs_create_kr+0x223>

	readINode(index_inode);
	memset(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c01023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023ad:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023b3:	05 20 02 00 00       	add    $0x220,%eax
c01023b8:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01023bd:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
c01023c1:	84 c0                	test   %al,%al
c01023c3:	0f 85 e8 00 00 00    	jne    c01024b1 <fs_create_kr+0x210>
			fs[i].used = 1;
c01023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023cc:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01023d2:	05 20 02 00 00       	add    $0x220,%eax
c01023d7:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01023dc:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c01023e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01023e3:	c1 e0 05             	shl    $0x5,%eax
c01023e6:	83 c0 10             	add    $0x10,%eax
c01023e9:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c01023ee:	8b 40 08             	mov    0x8(%eax),%eax
c01023f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01023f4:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c01023fa:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102400:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0102406:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0102409:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010240c:	c1 e0 05             	shl    $0x5,%eax
c010240f:	8d 90 40 d9 1d c0    	lea    -0x3fe226c0(%eax),%edx
c0102415:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102418:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c010241e:	05 10 02 00 00       	add    $0x210,%eax
c0102423:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102428:	83 c0 04             	add    $0x4,%eax
c010242b:	52                   	push   %edx
c010242c:	50                   	push   %eax
c010242d:	e8 5b f2 ff ff       	call   c010168d <strcpy>
c0102432:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0102435:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102438:	c1 e0 05             	shl    $0x5,%eax
c010243b:	83 c0 10             	add    $0x10,%eax
c010243e:	05 40 d9 1d c0       	add    $0xc01dd940,%eax
c0102443:	8b 40 0c             	mov    0xc(%eax),%eax
c0102446:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102449:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010244f:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102455:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c010245b:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c010245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102461:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102467:	05 00 02 00 00       	add    $0x200,%eax
c010246c:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			fs[i].dir_offset = dir_offset;
c0102477:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010247d:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c0102483:	81 c2 00 02 00 00    	add    $0x200,%edx
c0102489:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c010248f:	89 42 0c             	mov    %eax,0xc(%edx)
			fs[i].entry_offset = entry_offset;
c0102492:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102495:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102498:	69 d2 30 02 00 00    	imul   $0x230,%edx,%edx
c010249e:	81 c2 10 02 00 00    	add    $0x210,%edx
c01024a4:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c01024aa:	89 02                	mov    %eax,(%edx)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c01024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024af:	eb 13                	jmp    c01024c4 <fs_create_kr+0x223>
	saveDir(dir_offset);

	readINode(index_inode);
	memset(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
c01024b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024b5:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c01024b9:	0f 8e eb fe ff ff    	jle    c01023aa <fs_create_kr+0x109>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c01024bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c01024c4:	c9                   	leave  
c01024c5:	c3                   	ret    

c01024c6 <init_fs>:
void init_fs(){
c01024c6:	55                   	push   %ebp
c01024c7:	89 e5                	mov    %esp,%ebp
c01024c9:	83 ec 68             	sub    $0x68,%esp
	//readDir(0);
	int i=0;
c01024cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c01024d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01024da:	eb 1b                	jmp    c01024f7 <init_fs+0x31>
		fs[i].used = 0;
c01024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024df:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c01024e5:	05 20 02 00 00       	add    $0x220,%eax
c01024ea:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01024ef:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
	return -1;
}
void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c01024f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024f7:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c01024fb:	7e df                	jle    c01024dc <init_fs+0x16>
		fs[i].used = 0;
	}
	int fd = fs_create_kr("testx.txt");
c01024fd:	68 ac 46 10 c0       	push   $0xc01046ac
c0102502:	e8 9a fd ff ff       	call   c01022a1 <fs_create_kr>
c0102507:	83 c4 04             	add    $0x4,%esp
c010250a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char magic[40];
	strcpy(magic, "File system works!\nDeus machismo!\n");
c010250d:	68 b8 46 10 c0       	push   $0xc01046b8
c0102512:	8d 45 c0             	lea    -0x40(%ebp),%eax
c0102515:	50                   	push   %eax
c0102516:	e8 72 f1 ff ff       	call   c010168d <strcpy>
c010251b:	83 c4 08             	add    $0x8,%esp
	int len = fs_write_kr(fd, magic, 40);
c010251e:	6a 28                	push   $0x28
c0102520:	8d 45 c0             	lea    -0x40(%ebp),%eax
c0102523:	50                   	push   %eax
c0102524:	ff 75 f0             	pushl  -0x10(%ebp)
c0102527:	e8 85 fb ff ff       	call   c01020b1 <fs_write_kr>
c010252c:	83 c4 0c             	add    $0xc,%esp
c010252f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	fs_close_kr(fd);
c0102532:	ff 75 f0             	pushl  -0x10(%ebp)
c0102535:	e8 25 fd ff ff       	call   c010225f <fs_close_kr>
c010253a:	83 c4 04             	add    $0x4,%esp
	//magic[len] = '\0';

	int fw = fs_open_kr("testx.txt");
c010253d:	68 ac 46 10 c0       	push   $0xc01046ac
c0102542:	e8 98 f5 ff ff       	call   c0101adf <fs_open_kr>
c0102547:	83 c4 04             	add    $0x4,%esp
c010254a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//printk("file: %d \n", fw);
	char verif[40];
	len = fs_read_kr(fw, verif, 40);
c010254d:	6a 28                	push   $0x28
c010254f:	8d 45 98             	lea    -0x68(%ebp),%eax
c0102552:	50                   	push   %eax
c0102553:	ff 75 e8             	pushl  -0x18(%ebp)
c0102556:	e8 e9 f8 ff ff       	call   c0101e44 <fs_read_kr>
c010255b:	83 c4 0c             	add    $0xc,%esp
c010255e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("%d bytes\n", len);
	verif[len] = '\0';
c0102561:	8d 55 98             	lea    -0x68(%ebp),%edx
c0102564:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102567:	01 d0                	add    %edx,%eax
c0102569:	c6 00 00             	movb   $0x0,(%eax)
	fs_close_kr(fw);
c010256c:	ff 75 e8             	pushl  -0x18(%ebp)
c010256f:	e8 eb fc ff ff       	call   c010225f <fs_close_kr>
c0102574:	83 c4 04             	add    $0x4,%esp
	printk("%s", verif);
c0102577:	83 ec 08             	sub    $0x8,%esp
c010257a:	8d 45 98             	lea    -0x68(%ebp),%eax
c010257d:	50                   	push   %eax
c010257e:	68 db 46 10 c0       	push   $0xc01046db
c0102583:	e8 6b f0 ff ff       	call   c01015f3 <printk>
c0102588:	83 c4 10             	add    $0x10,%esp
	printk("%d\n", fs[fw].file_size);
c010258b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010258e:	69 c0 30 02 00 00    	imul   $0x230,%eax,%eax
c0102594:	05 00 02 00 00       	add    $0x200,%eax
c0102599:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c010259e:	8b 40 08             	mov    0x8(%eax),%eax
c01025a1:	83 ec 08             	sub    $0x8,%esp
c01025a4:	50                   	push   %eax
c01025a5:	68 de 46 10 c0       	push   $0xc01046de
c01025aa:	e8 44 f0 ff ff       	call   c01015f3 <printk>
c01025af:	83 c4 10             	add    $0x10,%esp
	/*for(i=0; i<NR_ENTRIES; i++){
		printk("%x\n", dir.entries[i].file_size);
		printk("%x\n", dir.entries[i].inode_offset);
		printk("%s\n", dir.entries[i].filename);
	}*/
c01025b2:	c9                   	leave  
c01025b3:	c3                   	ret    

c01025b4 <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
c01025b4:	55                   	push   %ebp
c01025b5:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c01025b7:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01025bc:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c01025be:	b8 df 05 00 00       	mov    $0x5df,%eax
c01025c3:	cd 80                	int    $0x80
}
c01025c5:	5d                   	pop    %ebp
c01025c6:	c3                   	ret    

c01025c7 <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c01025c7:	55                   	push   %ebp
c01025c8:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c01025ca:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01025cf:	cd 80                	int    $0x80
}
c01025d1:	5d                   	pop    %ebp
c01025d2:	c3                   	ret    

c01025d3 <sys_fork>:
static inline uint32_t sys_fork(){
c01025d3:	55                   	push   %ebp
c01025d4:	89 e5                	mov    %esp,%ebp
c01025d6:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01025d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c01025e0:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c01025e5:	cd 80                	int    $0x80
c01025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c01025ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01025ed:	c9                   	leave  
c01025ee:	c3                   	ret    

c01025ef <sys_pid>:
static inline uint32_t sys_pid(){
c01025ef:	55                   	push   %ebp
c01025f0:	89 e5                	mov    %esp,%ebp
c01025f2:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01025f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c01025fc:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0102601:	cd 80                	int    $0x80
c0102603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0102606:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102609:	c9                   	leave  
c010260a:	c3                   	ret    

c010260b <sys_ppid>:
static inline uint32_t sys_ppid(){
c010260b:	55                   	push   %ebp
c010260c:	89 e5                	mov    %esp,%ebp
c010260e:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102611:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c0102618:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c010261d:	cd 80                	int    $0x80
c010261f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0102622:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102625:	c9                   	leave  
c0102626:	c3                   	ret    

c0102627 <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c0102627:	55                   	push   %ebp
c0102628:	89 e5                	mov    %esp,%ebp
c010262a:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c010262b:	b8 de 05 00 00       	mov    $0x5de,%eax
c0102630:	8b 55 08             	mov    0x8(%ebp),%edx
c0102633:	89 d3                	mov    %edx,%ebx
c0102635:	cd 80                	int    $0x80
}
c0102637:	5b                   	pop    %ebx
c0102638:	5d                   	pop    %ebp
c0102639:	c3                   	ret    

c010263a <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010263a:	55                   	push   %ebp
c010263b:	89 e5                	mov    %esp,%ebp
c010263d:	83 ec 40             	sub    $0x40,%esp
c0102640:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c0102647:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010264b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010264f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102652:	ee                   	out    %al,(%dx)
c0102653:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c010265a:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c010265e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0102662:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102665:	ee                   	out    %al,(%dx)
c0102666:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c010266d:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0102671:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102675:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102678:	ee                   	out    %al,(%dx)
c0102679:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0102680:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0102684:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010268b:	ee                   	out    %al,(%dx)
c010268c:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c0102693:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c0102697:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010269b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010269e:	ee                   	out    %al,(%dx)
c010269f:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c01026a6:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c01026aa:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01026ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01026b1:	ee                   	out    %al,(%dx)
c01026b2:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c01026b9:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01026bd:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01026c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01026c4:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01026c5:	c9                   	leave  
c01026c6:	c3                   	ret    

c01026c7 <serial_idle>:

static inline
int serial_idle(void) {
c01026c7:	55                   	push   %ebp
c01026c8:	89 e5                	mov    %esp,%ebp
c01026ca:	83 ec 10             	sub    $0x10,%esp
c01026cd:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01026d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026d7:	89 c2                	mov    %eax,%edx
c01026d9:	ec                   	in     (%dx),%al
c01026da:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01026dd:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01026e1:	0f b6 c0             	movzbl %al,%eax
c01026e4:	83 e0 20             	and    $0x20,%eax
c01026e7:	85 c0                	test   %eax,%eax
c01026e9:	0f 95 c0             	setne  %al
c01026ec:	0f b6 c0             	movzbl %al,%eax
}
c01026ef:	c9                   	leave  
c01026f0:	c3                   	ret    

c01026f1 <serial_printc>:

static inline
void serial_printc(char ch) {
c01026f1:	55                   	push   %ebp
c01026f2:	89 e5                	mov    %esp,%ebp
c01026f4:	83 ec 14             	sub    $0x14,%esp
c01026f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01026fa:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01026fd:	90                   	nop
c01026fe:	e8 c4 ff ff ff       	call   c01026c7 <serial_idle>
c0102703:	85 c0                	test   %eax,%eax
c0102705:	74 f7                	je     c01026fe <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102707:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010270b:	0f b6 c0             	movzbl %al,%eax
c010270e:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102715:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102718:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010271c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010271f:	ee                   	out    %al,(%dx)
}
c0102720:	c9                   	leave  
c0102721:	c3                   	ret    

c0102722 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102722:	55                   	push   %ebp
c0102723:	89 e5                	mov    %esp,%ebp
c0102725:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102728:	8d 45 0c             	lea    0xc(%ebp),%eax
c010272b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c010272e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102731:	83 ec 04             	sub    $0x4,%esp
c0102734:	ff 75 f4             	pushl  -0xc(%ebp)
c0102737:	50                   	push   %eax
c0102738:	68 f1 26 10 c0       	push   $0xc01026f1
c010273d:	e8 b1 1b 00 00       	call   c01042f3 <vfprintf>
c0102742:	83 c4 10             	add    $0x10,%esp
}
c0102745:	c9                   	leave  
c0102746:	c3                   	ret    

c0102747 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c0102747:	55                   	push   %ebp
c0102748:	89 e5                	mov    %esp,%ebp
c010274a:	83 ec 70             	sub    $0x70,%esp
c010274d:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c0102754:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c0102758:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010275c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010275f:	ee                   	out    %al,(%dx)
c0102760:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c0102767:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c010276b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010276f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102772:	ee                   	out    %al,(%dx)
c0102773:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c010277a:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c010277e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0102782:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102785:	ee                   	out    %al,(%dx)
c0102786:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c010278d:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0102791:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102798:	ee                   	out    %al,(%dx)
c0102799:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c01027a0:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c01027a4:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01027a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01027ab:	ee                   	out    %al,(%dx)
c01027ac:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c01027b3:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c01027b7:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c01027bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01027be:	ee                   	out    %al,(%dx)
c01027bf:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c01027c6:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c01027ca:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01027ce:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01027d1:	ee                   	out    %al,(%dx)
c01027d2:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c01027d9:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c01027dd:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c01027e1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01027e4:	ee                   	out    %al,(%dx)
c01027e5:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c01027ec:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c01027f0:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c01027f4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01027f7:	ee                   	out    %al,(%dx)
c01027f8:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c01027ff:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c0102803:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c0102807:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010280a:	ee                   	out    %al,(%dx)
c010280b:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0102812:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c0102816:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c010281a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010281d:	ee                   	out    %al,(%dx)
c010281e:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0102825:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c0102829:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c010282d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102830:	ee                   	out    %al,(%dx)
c0102831:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c0102838:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c010283c:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c0102840:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102843:	ee                   	out    %al,(%dx)
c0102844:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c010284b:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c010284f:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c0102853:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102856:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c0102857:	c9                   	leave  
c0102858:	c3                   	ret    

c0102859 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c0102859:	55                   	push   %ebp
c010285a:	89 e5                	mov    %esp,%ebp
c010285c:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c010285f:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c0102866:	0f b6 05 00 80 10 c0 	movzbl 0xc0108000,%eax
c010286d:	0f b6 c0             	movzbl %al,%eax
c0102870:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c0102877:	88 45 f7             	mov    %al,-0x9(%ebp)
c010287a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010287e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102881:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c0102882:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102885:	0f b6 c0             	movzbl %al,%eax
c0102888:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c010288f:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102892:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102896:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102899:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c010289a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010289d:	c1 f8 08             	sar    $0x8,%eax
c01028a0:	0f b6 c0             	movzbl %al,%eax
c01028a3:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c01028aa:	88 45 e7             	mov    %al,-0x19(%ebp)
c01028ad:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01028b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01028b4:	ee                   	out    %al,(%dx)
}
c01028b5:	c9                   	leave  
c01028b6:	c3                   	ret    

c01028b7 <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c01028b7:	55                   	push   %ebp
c01028b8:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c01028ba:	e8 08 fd ff ff       	call   c01025c7 <sys_handout>
  }
c01028bf:	eb f9                	jmp    c01028ba <idle+0x3>

c01028c1 <busy>:
}
void busy(){
c01028c1:	55                   	push   %ebp
c01028c2:	89 e5                	mov    %esp,%ebp
c01028c4:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c01028c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c01028ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c01028d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01028dc:	eb 11                	jmp    c01028ef <busy+0x2e>
    if(fork()!=0){
c01028de:	e8 f0 fc ff ff       	call   c01025d3 <sys_fork>
c01028e3:	85 c0                	test   %eax,%eax
c01028e5:	74 04                	je     c01028eb <busy+0x2a>
        j++;
c01028e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c01028eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01028ef:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c01028f3:	76 e9                	jbe    c01028de <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c01028f5:	e8 f5 fc ff ff       	call   c01025ef <sys_pid>
c01028fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c01028fd:	e8 09 fd ff ff       	call   c010260b <sys_ppid>
c0102902:	ff 75 f0             	pushl  -0x10(%ebp)
c0102905:	50                   	push   %eax
c0102906:	ff 75 e8             	pushl  -0x18(%ebp)
c0102909:	68 e4 46 10 c0       	push   $0xc01046e4
c010290e:	e8 7a 1c 00 00       	call   c010458d <printf>
c0102913:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c0102916:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c010291d:	e8 a5 fc ff ff       	call   c01025c7 <sys_handout>
    sleep(pid);
c0102922:	83 ec 0c             	sub    $0xc,%esp
c0102925:	ff 75 e8             	pushl  -0x18(%ebp)
c0102928:	e8 fa fc ff ff       	call   c0102627 <sys_sleep>
c010292d:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0102930:	ff 75 ec             	pushl  -0x14(%ebp)
c0102933:	ff 75 e8             	pushl  -0x18(%ebp)
c0102936:	ff 75 e8             	pushl  -0x18(%ebp)
c0102939:	68 24 47 10 c0       	push   $0xc0104724
c010293e:	e8 4a 1c 00 00       	call   c010458d <printf>
c0102943:	83 c4 10             	add    $0x10,%esp
    times++;
c0102946:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c010294a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010294e:	76 15                	jbe    c0102965 <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c0102950:	83 ec 0c             	sub    $0xc,%esp
c0102953:	68 48 47 10 c0       	push   $0xc0104748
c0102958:	e8 30 1c 00 00       	call   c010458d <printf>
c010295d:	83 c4 10             	add    $0x10,%esp
      exit();
c0102960:	e8 4f fc ff ff       	call   c01025b4 <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c0102965:	eb b6                	jmp    c010291d <busy+0x5c>

c0102967 <main>:
}
void do_scheduler();
int main(){
c0102967:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c010296b:	83 e4 f0             	and    $0xfffffff0,%esp
c010296e:	ff 71 fc             	pushl  -0x4(%ecx)
c0102971:	55                   	push   %ebp
c0102972:	89 e5                	mov    %esp,%ebp
c0102974:	51                   	push   %ecx
c0102975:	83 ec 14             	sub    $0x14,%esp
  init_page();
c0102978:	e8 ae d7 ff ff       	call   c010012b <init_page>
  init_segment();
c010297d:	e8 5a d9 ff ff       	call   c01002dc <init_segment>
	init_serial();
c0102982:	e8 b3 fc ff ff       	call   c010263a <init_serial>
	init_timer();
c0102987:	e8 cd fe ff ff       	call   c0102859 <init_timer>
	init_idt();
c010298c:	e8 32 ea ff ff       	call   c01013c3 <init_idt>
	init_intr();
c0102991:	e8 b1 fd ff ff       	call   c0102747 <init_intr>
  init_fs();
c0102996:	e8 2b fb ff ff       	call   c01024c6 <init_fs>
  init_pcb_pool();
c010299b:	e8 bd 0d 00 00       	call   c010375d <init_pcb_pool>
  printk("This is kernel!\n");
c01029a0:	83 ec 0c             	sub    $0xc,%esp
c01029a3:	68 66 47 10 c0       	push   $0xc0104766
c01029a8:	e8 75 fd ff ff       	call   c0102722 <printk>
c01029ad:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c01029b0:	e8 13 0f 00 00       	call   c01038c8 <pcb_create>
c01029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c01029b8:	83 ec 08             	sub    $0x8,%esp
c01029bb:	68 b7 28 10 c0       	push   $0xc01028b7
c01029c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01029c3:	e8 e6 05 00 00       	call   c0102fae <empty_loader>
c01029c8:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c01029cb:	83 ec 0c             	sub    $0xc,%esp
c01029ce:	ff 75 f4             	pushl  -0xc(%ebp)
c01029d1:	e8 f2 0f 00 00       	call   c01039c8 <enready_pcb>
c01029d6:	83 c4 10             	add    $0x10,%esp


  PCB* pcb = pcb_create();
c01029d9:	e8 ea 0e 00 00       	call   c01038c8 <pcb_create>
c01029de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader_file(pcb, "game");
c01029e1:	83 ec 08             	sub    $0x8,%esp
c01029e4:	68 77 47 10 c0       	push   $0xc0104777
c01029e9:	ff 75 f0             	pushl  -0x10(%ebp)
c01029ec:	e8 ec 03 00 00       	call   c0102ddd <loader_file>
c01029f1:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c01029f4:	83 ec 0c             	sub    $0xc,%esp
c01029f7:	ff 75 f0             	pushl  -0x10(%ebp)
c01029fa:	e8 c9 0f 00 00       	call   c01039c8 <enready_pcb>
c01029ff:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c0102a02:	e8 c1 0e 00 00       	call   c01038c8 <pcb_create>
c0102a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader_file(app, "app");
c0102a0a:	83 ec 08             	sub    $0x8,%esp
c0102a0d:	68 7c 47 10 c0       	push   $0xc010477c
c0102a12:	ff 75 ec             	pushl  -0x14(%ebp)
c0102a15:	e8 c3 03 00 00       	call   c0102ddd <loader_file>
c0102a1a:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c0102a1d:	83 ec 0c             	sub    $0xc,%esp
c0102a20:	ff 75 ec             	pushl  -0x14(%ebp)
c0102a23:	e8 a0 0f 00 00       	call   c01039c8 <enready_pcb>
c0102a28:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c0102a2b:	e8 7b e6 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c0102a30:	eb fe                	jmp    c0102a30 <main+0xc9>

c0102a32 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102a32:	55                   	push   %ebp
c0102a33:	89 e5                	mov    %esp,%ebp
c0102a35:	83 ec 10             	sub    $0x10,%esp
c0102a38:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102a42:	89 c2                	mov    %eax,%edx
c0102a44:	ec                   	in     (%dx),%al
c0102a45:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102a48:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102a4c:	0f b6 c0             	movzbl %al,%eax
c0102a4f:	83 e0 20             	and    $0x20,%eax
c0102a52:	85 c0                	test   %eax,%eax
c0102a54:	0f 95 c0             	setne  %al
c0102a57:	0f b6 c0             	movzbl %al,%eax
}
c0102a5a:	c9                   	leave  
c0102a5b:	c3                   	ret    

c0102a5c <serial_printc>:

static inline
void serial_printc(char ch) {
c0102a5c:	55                   	push   %ebp
c0102a5d:	89 e5                	mov    %esp,%ebp
c0102a5f:	83 ec 14             	sub    $0x14,%esp
c0102a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a65:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102a68:	90                   	nop
c0102a69:	e8 c4 ff ff ff       	call   c0102a32 <serial_idle>
c0102a6e:	85 c0                	test   %eax,%eax
c0102a70:	74 f7                	je     c0102a69 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102a72:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102a76:	0f b6 c0             	movzbl %al,%eax
c0102a79:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102a80:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102a83:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102a87:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102a8a:	ee                   	out    %al,(%dx)
}
c0102a8b:	c9                   	leave  
c0102a8c:	c3                   	ret    

c0102a8d <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102a8d:	55                   	push   %ebp
c0102a8e:	89 e5                	mov    %esp,%ebp
c0102a90:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0102a93:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9c:	83 ec 04             	sub    $0x4,%esp
c0102a9f:	ff 75 f4             	pushl  -0xc(%ebp)
c0102aa2:	50                   	push   %eax
c0102aa3:	68 5c 2a 10 c0       	push   $0xc0102a5c
c0102aa8:	e8 46 18 00 00       	call   c01042f3 <vfprintf>
c0102aad:	83 c4 10             	add    $0x10,%esp
}
c0102ab0:	c9                   	leave  
c0102ab1:	c3                   	ret    

c0102ab2 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0102ab2:	55                   	push   %ebp
c0102ab3:	89 e5                	mov    %esp,%ebp
c0102ab5:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0102ab8:	90                   	nop
c0102ab9:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ac3:	89 c2                	mov    %eax,%edx
c0102ac5:	ec                   	in     (%dx),%al
c0102ac6:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102ac9:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102acd:	0f b6 c0             	movzbl %al,%eax
c0102ad0:	25 c0 00 00 00       	and    $0xc0,%eax
c0102ad5:	83 f8 40             	cmp    $0x40,%eax
c0102ad8:	75 df                	jne    c0102ab9 <waitdisk+0x7>
}
c0102ada:	c9                   	leave  
c0102adb:	c3                   	ret    

c0102adc <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102adc:	55                   	push   %ebp
c0102add:	89 e5                	mov    %esp,%ebp
c0102adf:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0102ae2:	e8 cb ff ff ff       	call   c0102ab2 <waitdisk>
c0102ae7:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0102aee:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102af2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0102af6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102af9:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0102afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102afd:	0f b6 c0             	movzbl %al,%eax
c0102b00:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0102b07:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102b0a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102b0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102b11:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0102b12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b15:	c1 f8 08             	sar    $0x8,%eax
c0102b18:	0f b6 c0             	movzbl %al,%eax
c0102b1b:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0102b22:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102b25:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102b29:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102b2c:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0102b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b30:	c1 f8 10             	sar    $0x10,%eax
c0102b33:	0f b6 c0             	movzbl %al,%eax
c0102b36:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0102b3d:	88 45 df             	mov    %al,-0x21(%ebp)
c0102b40:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0102b44:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b47:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0102b48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b4b:	c1 f8 18             	sar    $0x18,%eax
c0102b4e:	83 c8 e0             	or     $0xffffffe0,%eax
c0102b51:	0f b6 c0             	movzbl %al,%eax
c0102b54:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0102b5b:	88 45 d7             	mov    %al,-0x29(%ebp)
c0102b5e:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0102b62:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b65:	ee                   	out    %al,(%dx)
c0102b66:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0102b6d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0102b71:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0102b75:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b78:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0102b79:	e8 34 ff ff ff       	call   c0102ab2 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102b7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102b85:	eb 29                	jmp    c0102bb0 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0102b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b94:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0102b97:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102b9e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ba1:	89 c2                	mov    %eax,%edx
c0102ba3:	ed                   	in     (%dx),%eax
c0102ba4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0102ba7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102baa:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102bac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102bb0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0102bb4:	7e d1                	jle    c0102b87 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0102bb6:	c9                   	leave  
c0102bb7:	c3                   	ret    

c0102bb8 <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0102bb8:	55                   	push   %ebp
c0102bb9:	89 e5                	mov    %esp,%ebp
c0102bbb:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bc4:	01 d0                	add    %edx,%eax
c0102bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102bc9:	8b 45 10             	mov    0x10(%ebp),%eax
c0102bcc:	99                   	cltd   
c0102bcd:	c1 ea 17             	shr    $0x17,%edx
c0102bd0:	01 d0                	add    %edx,%eax
c0102bd2:	25 ff 01 00 00       	and    $0x1ff,%eax
c0102bd7:	29 d0                	sub    %edx,%eax
c0102bd9:	f7 d8                	neg    %eax
c0102bdb:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102bde:	8b 45 10             	mov    0x10(%ebp),%eax
c0102be1:	99                   	cltd   
c0102be2:	c1 ea 17             	shr    $0x17,%edx
c0102be5:	01 d0                	add    %edx,%eax
c0102be7:	c1 f8 09             	sar    $0x9,%eax
c0102bea:	83 c0 01             	add    $0x1,%eax
c0102bed:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102bf0:	eb 19                	jmp    c0102c0b <readseg+0x53>
        readsect(pa, offset);
c0102bf2:	ff 75 10             	pushl  0x10(%ebp)
c0102bf5:	ff 75 08             	pushl  0x8(%ebp)
c0102bf8:	e8 df fe ff ff       	call   c0102adc <readsect>
c0102bfd:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102c00:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0102c07:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0102c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c0e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102c11:	72 df                	jb     c0102bf2 <readseg+0x3a>
        readsect(pa, offset);
c0102c13:	c9                   	leave  
c0102c14:	c3                   	ret    

c0102c15 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0102c15:	55                   	push   %ebp
c0102c16:	89 e5                	mov    %esp,%ebp
c0102c18:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0102c1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0102c1e:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0102c23:	77 16                	ja     c0102c3b <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0102c25:	ff 75 10             	pushl  0x10(%ebp)
c0102c28:	68 80 47 10 c0       	push   $0xc0104780
c0102c2d:	ff 75 0c             	pushl  0xc(%ebp)
c0102c30:	ff 75 08             	pushl  0x8(%ebp)
c0102c33:	e8 55 fe ff ff       	call   c0102a8d <printk>
c0102c38:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0102c3b:	8b 45 10             	mov    0x10(%ebp),%eax
c0102c3e:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0102c43:	c9                   	leave  
c0102c44:	c3                   	ret    

c0102c45 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)
#define elf_r ((char*) ELFADDR)

uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0102c45:	55                   	push   %ebp
c0102c46:	89 e5                	mov    %esp,%ebp
c0102c48:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c4e:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102c54:	83 ec 04             	sub    $0x4,%esp
c0102c57:	50                   	push   %eax
c0102c58:	6a 17                	push   $0x17
c0102c5a:	68 a3 47 10 c0       	push   $0xc01047a3
c0102c5f:	e8 b1 ff ff ff       	call   c0102c15 <_paddr>
c0102c64:	83 c4 10             	add    $0x10,%esp
c0102c67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0102c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c6d:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c73:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102c79:	83 ec 04             	sub    $0x4,%esp
c0102c7c:	68 00 10 00 00       	push   $0x1000
c0102c81:	6a 00                	push   $0x0
c0102c83:	50                   	push   %eax
c0102c84:	e8 08 da ff ff       	call   c0100691 <mm_alloc>
c0102c89:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c8f:	83 ec 04             	sub    $0x4,%esp
c0102c92:	50                   	push   %eax
c0102c93:	68 00 10 00 00       	push   $0x1000
c0102c98:	6a 00                	push   $0x0
c0102c9a:	e8 19 ff ff ff       	call   c0102bb8 <readseg>
c0102c9f:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102ca2:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ca7:	8b 00                	mov    (%eax),%eax
c0102ca9:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102cae:	0f 94 c0             	sete   %al
c0102cb1:	0f b6 c0             	movzbl %al,%eax
c0102cb4:	83 ec 08             	sub    $0x8,%esp
c0102cb7:	50                   	push   %eax
c0102cb8:	68 b7 47 10 c0       	push   $0xc01047b7
c0102cbd:	e8 cb fd ff ff       	call   c0102a8d <printk>
c0102cc2:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102cc5:	b8 00 00 00 00       	mov    $0x0,%eax
c0102cca:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102cd0:	b8 00 00 00 00       	mov    $0x0,%eax
c0102cd5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102cd9:	0f b7 c0             	movzwl %ax,%eax
c0102cdc:	c1 e0 05             	shl    $0x5,%eax
c0102cdf:	89 c2                	mov    %eax,%edx
c0102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce4:	01 d0                	add    %edx,%eax
c0102ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102ce9:	eb 7f                	jmp    c0102d6a <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0102ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cee:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cf1:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf7:	8b 48 14             	mov    0x14(%eax),%ecx
c0102cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cfd:	8b 50 08             	mov    0x8(%eax),%edx
c0102d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d03:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d09:	83 ec 04             	sub    $0x4,%esp
c0102d0c:	51                   	push   %ecx
c0102d0d:	52                   	push   %edx
c0102d0e:	50                   	push   %eax
c0102d0f:	e8 7d d9 ff ff       	call   c0100691 <mm_alloc>
c0102d14:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0102d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d1a:	8b 50 04             	mov    0x4(%eax),%edx
c0102d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d20:	01 d0                	add    %edx,%eax
c0102d22:	89 c2                	mov    %eax,%edx
c0102d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d27:	8b 40 10             	mov    0x10(%eax),%eax
c0102d2a:	83 ec 04             	sub    $0x4,%esp
c0102d2d:	52                   	push   %edx
c0102d2e:	50                   	push   %eax
c0102d2f:	ff 75 e8             	pushl  -0x18(%ebp)
c0102d32:	e8 81 fe ff ff       	call   c0102bb8 <readseg>
c0102d37:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d3d:	8b 50 10             	mov    0x10(%eax),%edx
c0102d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d43:	01 d0                	add    %edx,%eax
c0102d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d48:	eb 0c                	jmp    c0102d56 <loader+0x111>
c0102d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d4d:	8d 50 01             	lea    0x1(%eax),%edx
c0102d50:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102d53:	c6 00 00             	movb   $0x0,(%eax)
c0102d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d59:	8b 50 14             	mov    0x14(%eax),%edx
c0102d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d5f:	01 d0                	add    %edx,%eax
c0102d61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d64:	77 e4                	ja     c0102d4a <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102d66:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102d70:	0f 82 75 ff ff ff    	jb     c0102ceb <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0102d76:	b8 00 00 00 00       	mov    $0x0,%eax
c0102d7b:	8b 40 18             	mov    0x18(%eax),%eax
c0102d7e:	a3 6c 42 10 c0       	mov    %eax,0xc010426c

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d86:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102d8c:	83 ec 04             	sub    $0x4,%esp
c0102d8f:	68 00 80 00 00       	push   $0x8000
c0102d94:	68 00 60 bf be       	push   $0xbebf6000
c0102d99:	50                   	push   %eax
c0102d9a:	e8 f2 d8 ff ff       	call   c0100691 <mm_alloc>
c0102d9f:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102da2:	a1 6c 42 10 c0       	mov    0xc010426c,%eax
c0102da7:	6a 03                	push   $0x3
c0102da9:	50                   	push   %eax
c0102daa:	68 80 df bf be       	push   $0xbebfdf80
c0102daf:	ff 75 08             	pushl  0x8(%ebp)
c0102db2:	e8 dd 09 00 00       	call   c0103794 <init_pcb>
c0102db7:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102dba:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102dbf:	83 ec 04             	sub    $0x4,%esp
c0102dc2:	50                   	push   %eax
c0102dc3:	6a 39                	push   $0x39
c0102dc5:	68 a3 47 10 c0       	push   $0xc01047a3
c0102dca:	e8 46 fe ff ff       	call   c0102c15 <_paddr>
c0102dcf:	83 c4 10             	add    $0x10,%esp
c0102dd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102dd8:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102ddb:	c9                   	leave  
c0102ddc:	c3                   	ret    

c0102ddd <loader_file>:

void loader_file(PCB* pcb, char* filename){
c0102ddd:	55                   	push   %ebp
c0102dde:	89 e5                	mov    %esp,%ebp
c0102de0:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de6:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102dec:	83 ec 04             	sub    $0x4,%esp
c0102def:	50                   	push   %eax
c0102df0:	6a 44                	push   $0x44
c0102df2:	68 a3 47 10 c0       	push   $0xc01047a3
c0102df7:	e8 19 fe ff ff       	call   c0102c15 <_paddr>
c0102dfc:	83 c4 10             	add    $0x10,%esp
c0102dff:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e02:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e05:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102e08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0b:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102e11:	83 ec 04             	sub    $0x4,%esp
c0102e14:	68 00 10 00 00       	push   $0x1000
c0102e19:	6a 00                	push   $0x0
c0102e1b:	50                   	push   %eax
c0102e1c:	e8 70 d8 ff ff       	call   c0100691 <mm_alloc>
c0102e21:	83 c4 10             	add    $0x10,%esp
  int fd = fs_open_kr(filename);
c0102e24:	83 ec 0c             	sub    $0xc,%esp
c0102e27:	ff 75 0c             	pushl  0xc(%ebp)
c0102e2a:	e8 b0 ec ff ff       	call   c0101adf <fs_open_kr>
c0102e2f:	83 c4 10             	add    $0x10,%esp
c0102e32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fs_read_kr(fd, elf_r, 8*SECTSIZE);
c0102e35:	83 ec 04             	sub    $0x4,%esp
c0102e38:	68 00 10 00 00       	push   $0x1000
c0102e3d:	6a 00                	push   $0x0
c0102e3f:	ff 75 ec             	pushl  -0x14(%ebp)
c0102e42:	e8 fd ef ff ff       	call   c0101e44 <fs_read_kr>
c0102e47:	83 c4 10             	add    $0x10,%esp
  //readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("%x\n", *(uint32_t *)(elf_r+7*SECTSIZE));
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102e4a:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e4f:	8b 00                	mov    (%eax),%eax
c0102e51:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102e56:	0f 94 c0             	sete   %al
c0102e59:	0f b6 c0             	movzbl %al,%eax
c0102e5c:	83 ec 08             	sub    $0x8,%esp
c0102e5f:	50                   	push   %eax
c0102e60:	68 b7 47 10 c0       	push   $0xc01047b7
c0102e65:	e8 23 fc ff ff       	call   c0102a8d <printk>
c0102e6a:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102e6d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e72:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102e78:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e7d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102e81:	0f b7 c0             	movzwl %ax,%eax
c0102e84:	c1 e0 05             	shl    $0x5,%eax
c0102e87:	89 c2                	mov    %eax,%edx
c0102e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e8c:	01 d0                	add    %edx,%eax
c0102e8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102e91:	e9 a5 00 00 00       	jmp    c0102f3b <loader_file+0x15e>
    pa = (unsigned char*)ph->vaddr; 
c0102e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e99:	8b 40 08             	mov    0x8(%eax),%eax
c0102e9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //printk("%x %x %x\n", pcb->pgdir, ph->vaddr, ph->memsz);
    if(ph->vaddr == 0 || ph->memsz == 0)break;
c0102e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea2:	8b 40 08             	mov    0x8(%eax),%eax
c0102ea5:	85 c0                	test   %eax,%eax
c0102ea7:	0f 84 9a 00 00 00    	je     c0102f47 <loader_file+0x16a>
c0102ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb0:	8b 40 14             	mov    0x14(%eax),%eax
c0102eb3:	85 c0                	test   %eax,%eax
c0102eb5:	0f 84 8c 00 00 00    	je     c0102f47 <loader_file+0x16a>
    //printk("a\n");
    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ebe:	8b 48 14             	mov    0x14(%eax),%ecx
c0102ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ec4:	8b 50 08             	mov    0x8(%eax),%edx
c0102ec7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eca:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102ed0:	83 ec 04             	sub    $0x4,%esp
c0102ed3:	51                   	push   %ecx
c0102ed4:	52                   	push   %edx
c0102ed5:	50                   	push   %eax
c0102ed6:	e8 b6 d7 ff ff       	call   c0100691 <mm_alloc>
c0102edb:	83 c4 10             	add    $0x10,%esp
    //printk("b\n");
    //printk("hahaha?\n");
    fs_lseek_kr(fd, ph->off);
c0102ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee1:	8b 40 04             	mov    0x4(%eax),%eax
c0102ee4:	83 ec 08             	sub    $0x8,%esp
c0102ee7:	50                   	push   %eax
c0102ee8:	ff 75 ec             	pushl  -0x14(%ebp)
c0102eeb:	e8 28 f3 ff ff       	call   c0102218 <fs_lseek_kr>
c0102ef0:	83 c4 10             	add    $0x10,%esp
    fs_read_kr(fd, pa, ph->filesz);
c0102ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ef6:	8b 40 10             	mov    0x10(%eax),%eax
c0102ef9:	83 ec 04             	sub    $0x4,%esp
c0102efc:	50                   	push   %eax
c0102efd:	ff 75 e4             	pushl  -0x1c(%ebp)
c0102f00:	ff 75 ec             	pushl  -0x14(%ebp)
c0102f03:	e8 3c ef ff ff       	call   c0101e44 <fs_read_kr>
c0102f08:	83 c4 10             	add    $0x10,%esp
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0e:	8b 50 10             	mov    0x10(%eax),%edx
c0102f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f14:	01 d0                	add    %edx,%eax
c0102f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f19:	eb 0c                	jmp    c0102f27 <loader_file+0x14a>
c0102f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f1e:	8d 50 01             	lea    0x1(%eax),%edx
c0102f21:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102f24:	c6 00 00             	movb   $0x0,(%eax)
c0102f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2a:	8b 50 14             	mov    0x14(%eax),%edx
c0102f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f30:	01 d0                	add    %edx,%eax
c0102f32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f35:	77 e4                	ja     c0102f1b <loader_file+0x13e>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102f37:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f3e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0102f41:	0f 82 4f ff ff ff    	jb     c0102e96 <loader_file+0xb9>
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  //printk("c\n");
  //while(1);
  entry = elf->entry;
c0102f47:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f4c:	8b 40 18             	mov    0x18(%eax),%eax
c0102f4f:	a3 6c 42 10 c0       	mov    %eax,0xc010426c
  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  //printk("e\n");
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102f54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f57:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102f5d:	83 ec 04             	sub    $0x4,%esp
c0102f60:	68 00 80 00 00       	push   $0x8000
c0102f65:	68 00 60 bf be       	push   $0xbebf6000
c0102f6a:	50                   	push   %eax
c0102f6b:	e8 21 d7 ff ff       	call   c0100691 <mm_alloc>
c0102f70:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102f73:	a1 6c 42 10 c0       	mov    0xc010426c,%eax
c0102f78:	6a 03                	push   $0x3
c0102f7a:	50                   	push   %eax
c0102f7b:	68 80 df bf be       	push   $0xbebfdf80
c0102f80:	ff 75 08             	pushl  0x8(%ebp)
c0102f83:	e8 0c 08 00 00       	call   c0103794 <init_pcb>
c0102f88:	83 c4 10             	add    $0x10,%esp
  //printk("f\n");
  //printk("%x\n", *(uint32_t*)(0x80481fd));
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102f8b:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102f90:	83 ec 04             	sub    $0x4,%esp
c0102f93:	50                   	push   %eax
c0102f94:	6a 74                	push   $0x74
c0102f96:	68 a3 47 10 c0       	push   $0xc01047a3
c0102f9b:	e8 75 fc ff ff       	call   c0102c15 <_paddr>
c0102fa0:	83 c4 10             	add    $0x10,%esp
c0102fa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102fa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102fa9:	0f 22 d8             	mov    %eax,%cr3
  //printk("g\n");
  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102fac:	c9                   	leave  
c0102fad:	c3                   	ret    

c0102fae <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0102fae:	55                   	push   %ebp
c0102faf:	89 e5                	mov    %esp,%ebp
c0102fb1:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0102fb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fb7:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102fbd:	83 ec 04             	sub    $0x4,%esp
c0102fc0:	50                   	push   %eax
c0102fc1:	6a 7d                	push   $0x7d
c0102fc3:	68 a3 47 10 c0       	push   $0xc01047a3
c0102fc8:	e8 48 fc ff ff       	call   c0102c15 <_paddr>
c0102fcd:	83 c4 10             	add    $0x10,%esp
c0102fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fd6:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0102fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fdc:	a3 6c 42 10 c0       	mov    %eax,0xc010426c
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c0102fe1:	a1 6c 42 10 c0       	mov    0xc010426c,%eax
c0102fe6:	8b 55 08             	mov    0x8(%ebp),%edx
c0102fe9:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0102fef:	83 c2 80             	add    $0xffffff80,%edx
c0102ff2:	6a 00                	push   $0x0
c0102ff4:	50                   	push   %eax
c0102ff5:	52                   	push   %edx
c0102ff6:	ff 75 08             	pushl  0x8(%ebp)
c0102ff9:	e8 96 07 00 00       	call   c0103794 <init_pcb>
c0102ffe:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0103001:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0103006:	83 ec 04             	sub    $0x4,%esp
c0103009:	50                   	push   %eax
c010300a:	68 81 00 00 00       	push   $0x81
c010300f:	68 a3 47 10 c0       	push   $0xc01047a3
c0103014:	e8 fc fb ff ff       	call   c0102c15 <_paddr>
c0103019:	83 c4 10             	add    $0x10,%esp
c010301c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103022:	0f 22 d8             	mov    %eax,%cr3

c0103025:	c9                   	leave  
c0103026:	c3                   	ret    

c0103027 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0103027:	55                   	push   %ebp
c0103028:	89 e5                	mov    %esp,%ebp
c010302a:	83 ec 04             	sub    $0x4,%esp
c010302d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103030:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0103033:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0103037:	83 e8 61             	sub    $0x61,%eax
c010303a:	8b 04 85 40 60 15 c0 	mov    -0x3fea9fc0(,%eax,4),%eax
}
c0103041:	c9                   	leave  
c0103042:	c3                   	ret    

c0103043 <get_lastkey>:
int8_t get_lastkey(){
c0103043:	55                   	push   %ebp
c0103044:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0103046:	a1 a8 60 15 c0       	mov    0xc01560a8,%eax
c010304b:	83 c0 61             	add    $0x61,%eax
}
c010304e:	5d                   	pop    %ebp
c010304f:	c3                   	ret    

c0103050 <press_key>:
void press_key(int code){
c0103050:	55                   	push   %ebp
c0103051:	89 e5                	mov    %esp,%ebp
c0103053:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0103056:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c010305d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103060:	25 80 00 00 00       	and    $0x80,%eax
c0103065:	85 c0                	test   %eax,%eax
c0103067:	75 35                	jne    c010309e <press_key+0x4e>
		for(;i<26;i++){
c0103069:	eb 2b                	jmp    c0103096 <press_key+0x46>
			if(letter[i]==code){
c010306b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010306e:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0103075:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103078:	75 18                	jne    c0103092 <press_key+0x42>
				keydown[i] = 1;
c010307a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010307d:	c7 04 85 40 60 15 c0 	movl   $0x1,-0x3fea9fc0(,%eax,4)
c0103084:	01 00 00 00 
				lastkey = i;
c0103088:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010308b:	a3 a8 60 15 c0       	mov    %eax,0xc01560a8
				return;
c0103090:	eb 3b                	jmp    c01030cd <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0103092:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103096:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c010309a:	7e cf                	jle    c010306b <press_key+0x1b>
c010309c:	eb 2f                	jmp    c01030cd <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c010309e:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c01030a2:	eb 23                	jmp    c01030c7 <press_key+0x77>
			if(letter[i]==code){
c01030a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030a7:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c01030ae:	3b 45 08             	cmp    0x8(%ebp),%eax
c01030b1:	75 10                	jne    c01030c3 <press_key+0x73>
				keydown[i] = 0;
c01030b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030b6:	c7 04 85 40 60 15 c0 	movl   $0x0,-0x3fea9fc0(,%eax,4)
c01030bd:	00 00 00 00 
				return;
c01030c1:	eb 0a                	jmp    c01030cd <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c01030c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01030c7:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c01030cb:	7e d7                	jle    c01030a4 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c01030cd:	c9                   	leave  
c01030ce:	c3                   	ret    

c01030cf <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01030cf:	55                   	push   %ebp
c01030d0:	89 e5                	mov    %esp,%ebp
c01030d2:	83 ec 10             	sub    $0x10,%esp
c01030d5:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01030dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030df:	89 c2                	mov    %eax,%edx
c01030e1:	ec                   	in     (%dx),%al
c01030e2:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01030e5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01030e9:	0f b6 c0             	movzbl %al,%eax
c01030ec:	83 e0 20             	and    $0x20,%eax
c01030ef:	85 c0                	test   %eax,%eax
c01030f1:	0f 95 c0             	setne  %al
c01030f4:	0f b6 c0             	movzbl %al,%eax
}
c01030f7:	c9                   	leave  
c01030f8:	c3                   	ret    

c01030f9 <serial_printc>:

static inline
void serial_printc(char ch) {
c01030f9:	55                   	push   %ebp
c01030fa:	89 e5                	mov    %esp,%ebp
c01030fc:	83 ec 14             	sub    $0x14,%esp
c01030ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103102:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103105:	90                   	nop
c0103106:	e8 c4 ff ff ff       	call   c01030cf <serial_idle>
c010310b:	85 c0                	test   %eax,%eax
c010310d:	74 f7                	je     c0103106 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010310f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0103113:	0f b6 c0             	movzbl %al,%eax
c0103116:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010311d:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0103120:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103124:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103127:	ee                   	out    %al,(%dx)
}
c0103128:	c9                   	leave  
c0103129:	c3                   	ret    

c010312a <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c010312a:	55                   	push   %ebp
c010312b:	89 e5                	mov    %esp,%ebp
c010312d:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0103130:	8b 45 08             	mov    0x8(%ebp),%eax
c0103133:	8b 40 1c             	mov    0x1c(%eax),%eax
c0103136:	3d df 05 00 00       	cmp    $0x5df,%eax
c010313b:	0f 84 a6 02 00 00    	je     c01033e7 <do_syscall+0x2bd>
c0103141:	3d df 05 00 00       	cmp    $0x5df,%eax
c0103146:	0f 87 97 00 00 00    	ja     c01031e3 <do_syscall+0xb9>
c010314c:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0103151:	0f 84 d5 02 00 00    	je     c010342c <do_syscall+0x302>
c0103157:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c010315c:	77 3d                	ja     c010319b <do_syscall+0x71>
c010315e:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0103163:	0f 84 a9 02 00 00    	je     c0103412 <do_syscall+0x2e8>
c0103169:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c010316e:	77 10                	ja     c0103180 <do_syscall+0x56>
c0103170:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0103175:	0f 84 80 02 00 00    	je     c01033fb <do_syscall+0x2d1>
c010317b:	e9 01 03 00 00       	jmp    c0103481 <do_syscall+0x357>
c0103180:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0103185:	0f 84 8e 02 00 00    	je     c0103419 <do_syscall+0x2ef>
c010318b:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0103190:	0f 84 8a 02 00 00    	je     c0103420 <do_syscall+0x2f6>
c0103196:	e9 e6 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c010319b:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01031a0:	0f 84 2d 02 00 00    	je     c01033d3 <do_syscall+0x2a9>
c01031a6:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c01031ab:	77 1b                	ja     c01031c8 <do_syscall+0x9e>
c01031ad:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c01031b2:	0f 84 9b 02 00 00    	je     c0103453 <do_syscall+0x329>
c01031b8:	3d 15 05 00 00       	cmp    $0x515,%eax
c01031bd:	0f 84 b0 02 00 00    	je     c0103473 <do_syscall+0x349>
c01031c3:	e9 b9 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c01031c8:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c01031cd:	0f 84 a9 01 00 00    	je     c010337c <do_syscall+0x252>
c01031d3:	3d de 05 00 00       	cmp    $0x5de,%eax
c01031d8:	0f 84 ca 01 00 00    	je     c01033a8 <do_syscall+0x27e>
c01031de:	e9 9e 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c01031e3:	3d 41 06 00 00       	cmp    $0x641,%eax
c01031e8:	0f 84 a7 00 00 00    	je     c0103295 <do_syscall+0x16b>
c01031ee:	3d 41 06 00 00       	cmp    $0x641,%eax
c01031f3:	77 44                	ja     c0103239 <do_syscall+0x10f>
c01031f5:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c01031fa:	0f 84 65 01 00 00    	je     c0103365 <do_syscall+0x23b>
c0103200:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0103205:	77 1b                	ja     c0103222 <do_syscall+0xf8>
c0103207:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c010320c:	0f 84 df 01 00 00    	je     c01033f1 <do_syscall+0x2c7>
c0103212:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0103217:	0f 84 75 01 00 00    	je     c0103392 <do_syscall+0x268>
c010321d:	e9 5f 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c0103222:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0103227:	0f 84 13 01 00 00    	je     c0103340 <do_syscall+0x216>
c010322d:	3d 40 06 00 00       	cmp    $0x640,%eax
c0103232:	74 41                	je     c0103275 <do_syscall+0x14b>
c0103234:	e9 48 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c0103239:	3d 44 06 00 00       	cmp    $0x644,%eax
c010323e:	0f 84 c6 00 00 00    	je     c010330a <do_syscall+0x1e0>
c0103244:	3d 44 06 00 00       	cmp    $0x644,%eax
c0103249:	77 13                	ja     c010325e <do_syscall+0x134>
c010324b:	3d 42 06 00 00       	cmp    $0x642,%eax
c0103250:	74 6b                	je     c01032bd <do_syscall+0x193>
c0103252:	3d 43 06 00 00       	cmp    $0x643,%eax
c0103257:	74 7b                	je     c01032d4 <do_syscall+0x1aa>
c0103259:	e9 23 02 00 00       	jmp    c0103481 <do_syscall+0x357>
c010325e:	3d 45 06 00 00       	cmp    $0x645,%eax
c0103263:	0f 84 b8 00 00 00    	je     c0103321 <do_syscall+0x1f7>
c0103269:	3d 46 06 00 00       	cmp    $0x646,%eax
c010326e:	74 7b                	je     c01032eb <do_syscall+0x1c1>
c0103270:	e9 0c 02 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0103275:	8b 45 08             	mov    0x8(%ebp),%eax
c0103278:	8b 40 18             	mov    0x18(%eax),%eax
c010327b:	89 c2                	mov    %eax,%edx
c010327d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103280:	8b 40 10             	mov    0x10(%eax),%eax
c0103283:	83 ec 08             	sub    $0x8,%esp
c0103286:	52                   	push   %edx
c0103287:	50                   	push   %eax
c0103288:	e8 84 dc ff ff       	call   c0100f11 <sem_init_kr>
c010328d:	83 c4 10             	add    $0x10,%esp
		break;
c0103290:	e9 ec 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0103295:	8b 45 08             	mov    0x8(%ebp),%eax
c0103298:	8b 40 18             	mov    0x18(%eax),%eax
c010329b:	89 c2                	mov    %eax,%edx
c010329d:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a0:	8b 40 10             	mov    0x10(%eax),%eax
c01032a3:	83 ec 08             	sub    $0x8,%esp
c01032a6:	52                   	push   %edx
c01032a7:	50                   	push   %eax
c01032a8:	e8 d1 dd ff ff       	call   c010107e <sem_open_kr>
c01032ad:	83 c4 10             	add    $0x10,%esp
c01032b0:	89 c2                	mov    %eax,%edx
c01032b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01032b5:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01032b8:	e9 c4 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c01032bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01032c0:	8b 40 10             	mov    0x10(%eax),%eax
c01032c3:	83 ec 0c             	sub    $0xc,%esp
c01032c6:	50                   	push   %eax
c01032c7:	e8 b1 dc ff ff       	call   c0100f7d <sem_post_kr>
c01032cc:	83 c4 10             	add    $0x10,%esp
		break;
c01032cf:	e9 ad 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c01032d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d7:	8b 40 10             	mov    0x10(%eax),%eax
c01032da:	83 ec 0c             	sub    $0xc,%esp
c01032dd:	50                   	push   %eax
c01032de:	e8 ee dc ff ff       	call   c0100fd1 <sem_wait_kr>
c01032e3:	83 c4 10             	add    $0x10,%esp
		break;
c01032e6:	e9 96 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c01032eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01032ee:	8b 40 10             	mov    0x10(%eax),%eax
c01032f1:	83 ec 0c             	sub    $0xc,%esp
c01032f4:	50                   	push   %eax
c01032f5:	e8 2f dd ff ff       	call   c0101029 <sem_trywait_kr>
c01032fa:	83 c4 10             	add    $0x10,%esp
c01032fd:	89 c2                	mov    %eax,%edx
c01032ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103302:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103305:	e9 77 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c010330a:	8b 45 08             	mov    0x8(%ebp),%eax
c010330d:	8b 40 10             	mov    0x10(%eax),%eax
c0103310:	83 ec 0c             	sub    $0xc,%esp
c0103313:	50                   	push   %eax
c0103314:	e8 18 dc ff ff       	call   c0100f31 <sem_close_kr>
c0103319:	83 c4 10             	add    $0x10,%esp
		break;
c010331c:	e9 60 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0103321:	8b 45 08             	mov    0x8(%ebp),%eax
c0103324:	8b 40 10             	mov    0x10(%eax),%eax
c0103327:	83 ec 0c             	sub    $0xc,%esp
c010332a:	50                   	push   %eax
c010332b:	e8 33 dd ff ff       	call   c0101063 <sem_get_kr>
c0103330:	83 c4 10             	add    $0x10,%esp
c0103333:	89 c2                	mov    %eax,%edx
c0103335:	8b 45 08             	mov    0x8(%ebp),%eax
c0103338:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010333b:	e9 41 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c0103340:	8b 45 08             	mov    0x8(%ebp),%eax
c0103343:	8b 48 14             	mov    0x14(%eax),%ecx
c0103346:	8b 45 08             	mov    0x8(%ebp),%eax
c0103349:	8b 50 18             	mov    0x18(%eax),%edx
c010334c:	8b 45 08             	mov    0x8(%ebp),%eax
c010334f:	8b 40 10             	mov    0x10(%eax),%eax
c0103352:	83 ec 04             	sub    $0x4,%esp
c0103355:	51                   	push   %ecx
c0103356:	52                   	push   %edx
c0103357:	50                   	push   %eax
c0103358:	e8 ec 08 00 00       	call   c0103c49 <thread_current>
c010335d:	83 c4 10             	add    $0x10,%esp
		break;
c0103360:	e9 1c 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_JOIN:
			join_current(tf->ebx);
c0103365:	8b 45 08             	mov    0x8(%ebp),%eax
c0103368:	8b 40 10             	mov    0x10(%eax),%eax
c010336b:	83 ec 0c             	sub    $0xc,%esp
c010336e:	50                   	push   %eax
c010336f:	e8 b3 0a 00 00       	call   c0103e27 <join_current>
c0103374:	83 c4 10             	add    $0x10,%esp
		break;
c0103377:	e9 05 01 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_PID:
			tf->eax = current->pid;
c010337c:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103381:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103387:	8b 45 08             	mov    0x8(%ebp),%eax
c010338a:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010338d:	e9 ef 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_PPID:
			tf->eax = current->ppid;
c0103392:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103397:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c010339d:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a0:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01033a3:	e9 d9 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c01033a8:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01033ad:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c01033b4:	00 00 00 
			current->timeslice = tf->ebx*200;
c01033b7:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01033bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01033bf:	8b 52 10             	mov    0x10(%edx),%edx
c01033c2:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c01033c8:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c01033ce:	e9 ae 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_HANDOUT:
			current->ts = STOP;
c01033d3:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01033d8:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c01033df:	00 00 00 
		break;
c01033e2:	e9 9a 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_EXIT:
			exit_current();
c01033e7:	e8 ce 09 00 00       	call   c0103dba <exit_current>
		break;
c01033ec:	e9 90 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_FORK:
			fork_current();
c01033f1:	e8 e1 07 00 00       	call   c0103bd7 <fork_current>
		break;
c01033f6:	e9 86 00 00 00       	jmp    c0103481 <do_syscall+0x357>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c01033fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01033fe:	8b 40 10             	mov    0x10(%eax),%eax
c0103401:	0f be c0             	movsbl %al,%eax
c0103404:	83 ec 0c             	sub    $0xc,%esp
c0103407:	50                   	push   %eax
c0103408:	e8 ec fc ff ff       	call   c01030f9 <serial_printc>
c010340d:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0103410:	eb 6f                	jmp    c0103481 <do_syscall+0x357>
		case SYS_INIT_CACHE:
			initVCache();
c0103412:	e8 d7 0a 00 00       	call   c0103eee <initVCache>
		break;
c0103417:	eb 68                	jmp    c0103481 <do_syscall+0x357>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0103419:	e8 05 0c 00 00       	call   c0104023 <clearVRAM>
		break;
c010341e:	eb 61                	jmp    c0103481 <do_syscall+0x357>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0103420:	e8 fe 0b 00 00       	call   c0104023 <clearVRAM>
			flushVCache();
c0103425:	e8 2d 0b 00 00       	call   c0103f57 <flushVCache>
		break;
c010342a:	eb 55                	jmp    c0103481 <do_syscall+0x357>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c010342c:	8b 45 08             	mov    0x8(%ebp),%eax
c010342f:	8b 40 14             	mov    0x14(%eax),%eax
c0103432:	0f b6 c0             	movzbl %al,%eax
c0103435:	8b 55 08             	mov    0x8(%ebp),%edx
c0103438:	8b 52 18             	mov    0x18(%edx),%edx
c010343b:	89 d1                	mov    %edx,%ecx
c010343d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103440:	8b 52 10             	mov    0x10(%edx),%edx
c0103443:	83 ec 04             	sub    $0x4,%esp
c0103446:	50                   	push   %eax
c0103447:	51                   	push   %ecx
c0103448:	52                   	push   %edx
c0103449:	e8 6e 0b 00 00       	call   c0103fbc <setPixelAt>
c010344e:	83 c4 10             	add    $0x10,%esp
		break;
c0103451:	eb 2e                	jmp    c0103481 <do_syscall+0x357>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c0103453:	8b 45 08             	mov    0x8(%ebp),%eax
c0103456:	8b 40 10             	mov    0x10(%eax),%eax
c0103459:	0f be c0             	movsbl %al,%eax
c010345c:	83 ec 0c             	sub    $0xc,%esp
c010345f:	50                   	push   %eax
c0103460:	e8 c2 fb ff ff       	call   c0103027 <get_key>
c0103465:	83 c4 10             	add    $0x10,%esp
c0103468:	0f be d0             	movsbl %al,%edx
c010346b:	8b 45 08             	mov    0x8(%ebp),%eax
c010346e:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103471:	eb 0e                	jmp    c0103481 <do_syscall+0x357>
		case SYS_GET_TICK:
			tf->eax = tick();
c0103473:	e8 f7 0c 00 00       	call   c010416f <tick>
c0103478:	89 c2                	mov    %eax,%edx
c010347a:	8b 45 08             	mov    0x8(%ebp),%eax
c010347d:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c0103480:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c0103481:	c9                   	leave  
c0103482:	c3                   	ret    

c0103483 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0103483:	55                   	push   %ebp
c0103484:	89 e5                	mov    %esp,%ebp
c0103486:	83 ec 10             	sub    $0x10,%esp
c0103489:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103490:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103493:	89 c2                	mov    %eax,%edx
c0103495:	ec                   	in     (%dx),%al
c0103496:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103499:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010349d:	0f b6 c0             	movzbl %al,%eax
c01034a0:	83 e0 20             	and    $0x20,%eax
c01034a3:	85 c0                	test   %eax,%eax
c01034a5:	0f 95 c0             	setne  %al
c01034a8:	0f b6 c0             	movzbl %al,%eax
}
c01034ab:	c9                   	leave  
c01034ac:	c3                   	ret    

c01034ad <serial_printc>:

static inline
void serial_printc(char ch) {
c01034ad:	55                   	push   %ebp
c01034ae:	89 e5                	mov    %esp,%ebp
c01034b0:	83 ec 14             	sub    $0x14,%esp
c01034b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b6:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01034b9:	90                   	nop
c01034ba:	e8 c4 ff ff ff       	call   c0103483 <serial_idle>
c01034bf:	85 c0                	test   %eax,%eax
c01034c1:	74 f7                	je     c01034ba <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01034c3:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01034c7:	0f b6 c0             	movzbl %al,%eax
c01034ca:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01034d1:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01034d4:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01034d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034db:	ee                   	out    %al,(%dx)
}
c01034dc:	c9                   	leave  
c01034dd:	c3                   	ret    

c01034de <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01034de:	55                   	push   %ebp
c01034df:	89 e5                	mov    %esp,%ebp
c01034e1:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01034e4:	8d 45 0c             	lea    0xc(%ebp),%eax
c01034e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01034ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ed:	83 ec 04             	sub    $0x4,%esp
c01034f0:	ff 75 f4             	pushl  -0xc(%ebp)
c01034f3:	50                   	push   %eax
c01034f4:	68 ad 34 10 c0       	push   $0xc01034ad
c01034f9:	e8 f5 0d 00 00       	call   c01042f3 <vfprintf>
c01034fe:	83 c4 10             	add    $0x10,%esp
}
c0103501:	c9                   	leave  
c0103502:	c3                   	ret    

c0103503 <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c0103503:	55                   	push   %ebp
c0103504:	89 e5                	mov    %esp,%ebp
c0103506:	57                   	push   %edi
c0103507:	56                   	push   %esi
c0103508:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103509:	8b 45 10             	mov    0x10(%ebp),%eax
c010350c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010350f:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103512:	89 c1                	mov    %eax,%ecx
c0103514:	89 d6                	mov    %edx,%esi
c0103516:	89 df                	mov    %ebx,%edi
c0103518:	fc                   	cld    
c0103519:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c010351b:	5b                   	pop    %ebx
c010351c:	5e                   	pop    %esi
c010351d:	5f                   	pop    %edi
c010351e:	5d                   	pop    %ebp
c010351f:	c3                   	ret    

c0103520 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103520:	55                   	push   %ebp
c0103521:	89 e5                	mov    %esp,%ebp
c0103523:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0103526:	8b 45 10             	mov    0x10(%ebp),%eax
c0103529:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c010352e:	77 16                	ja     c0103546 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0103530:	ff 75 10             	pushl  0x10(%ebp)
c0103533:	68 cc 47 10 c0       	push   $0xc01047cc
c0103538:	ff 75 0c             	pushl  0xc(%ebp)
c010353b:	ff 75 08             	pushl  0x8(%ebp)
c010353e:	e8 9b ff ff ff       	call   c01034de <printk>
c0103543:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0103546:	8b 45 10             	mov    0x10(%ebp),%eax
c0103549:	05 00 00 00 40       	add    $0x40000000,%eax
}
c010354e:	c9                   	leave  
c010354f:	c3                   	ret    

c0103550 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c0103550:	55                   	push   %ebp
c0103551:	89 e5                	mov    %esp,%ebp
c0103553:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103556:	8b 45 10             	mov    0x10(%ebp),%eax
c0103559:	c1 e8 0c             	shr    $0xc,%eax
c010355c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0103561:	76 13                	jbe    c0103576 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c0103563:	83 ec 08             	sub    $0x8,%esp
c0103566:	ff 75 10             	pushl  0x10(%ebp)
c0103569:	68 f0 47 10 c0       	push   $0xc01047f0
c010356e:	e8 6b ff ff ff       	call   c01034de <printk>
c0103573:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c0103576:	8b 45 10             	mov    0x10(%ebp),%eax
c0103579:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010357e:	c9                   	leave  
c010357f:	c3                   	ret    

c0103580 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c0103580:	55                   	push   %ebp
c0103581:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c0103583:	8b 45 08             	mov    0x8(%ebp),%eax
c0103586:	ba 00 57 17 c0       	mov    $0xc0175700,%edx
c010358b:	29 d0                	sub    %edx,%eax
c010358d:	c1 f8 03             	sar    $0x3,%eax
c0103590:	c1 e0 0c             	shl    $0xc,%eax
}
c0103593:	5d                   	pop    %ebp
c0103594:	c3                   	ret    

c0103595 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0103595:	55                   	push   %ebp
c0103596:	89 e5                	mov    %esp,%ebp
c0103598:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c010359b:	8b 45 08             	mov    0x8(%ebp),%eax
c010359e:	c1 e8 0c             	shr    $0xc,%eax
c01035a1:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01035a6:	76 10                	jbe    c01035b8 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c01035a8:	83 ec 0c             	sub    $0xc,%esp
c01035ab:	68 14 48 10 c0       	push   $0xc0104814
c01035b0:	e8 29 ff ff ff       	call   c01034de <printk>
c01035b5:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c01035b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01035bb:	c1 e8 0c             	shr    $0xc,%eax
c01035be:	c1 e0 03             	shl    $0x3,%eax
c01035c1:	05 00 57 17 c0       	add    $0xc0175700,%eax
}
c01035c6:	c9                   	leave  
c01035c7:	c3                   	ret    

c01035c8 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c01035c8:	55                   	push   %ebp
c01035c9:	89 e5                	mov    %esp,%ebp
c01035cb:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c01035ce:	ff 75 08             	pushl  0x8(%ebp)
c01035d1:	e8 aa ff ff ff       	call   c0103580 <page2pa>
c01035d6:	83 c4 04             	add    $0x4,%esp
c01035d9:	83 ec 04             	sub    $0x4,%esp
c01035dc:	50                   	push   %eax
c01035dd:	6a 52                	push   $0x52
c01035df:	68 33 48 10 c0       	push   $0xc0104833
c01035e4:	e8 67 ff ff ff       	call   c0103550 <_kaddr>
c01035e9:	83 c4 10             	add    $0x10,%esp
}
c01035ec:	c9                   	leave  
c01035ed:	c3                   	ret    

c01035ee <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c01035ee:	55                   	push   %ebp
c01035ef:	89 e5                	mov    %esp,%ebp
c01035f1:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c01035f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c01035fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01035fe:	8b 00                	mov    (%eax),%eax
c0103600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c0103603:	eb 10                	jmp    c0103615 <ll_len+0x27>
		p = p->next;
c0103605:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103608:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c010360e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0103611:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0103615:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103619:	75 ea                	jne    c0103605 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c010361b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010361e:	c9                   	leave  
c010361f:	c3                   	ret    

c0103620 <ll_pop>:
PCB* ll_pop(PCB** head){
c0103620:	55                   	push   %ebp
c0103621:	89 e5                	mov    %esp,%ebp
c0103623:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c0103626:	8b 45 08             	mov    0x8(%ebp),%eax
c0103629:	8b 00                	mov    (%eax),%eax
c010362b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c010362e:	83 ec 08             	sub    $0x8,%esp
c0103631:	ff 75 f4             	pushl  -0xc(%ebp)
c0103634:	ff 75 08             	pushl  0x8(%ebp)
c0103637:	e8 a4 00 00 00       	call   c01036e0 <ll_delete>
c010363c:	83 c4 10             	add    $0x10,%esp
	return p;
c010363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103642:	c9                   	leave  
c0103643:	c3                   	ret    

c0103644 <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c0103644:	55                   	push   %ebp
c0103645:	89 e5                	mov    %esp,%ebp
c0103647:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c010364a:	8b 45 08             	mov    0x8(%ebp),%eax
c010364d:	8b 00                	mov    (%eax),%eax
c010364f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c0103652:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103656:	75 0f                	jne    c0103667 <ll_push+0x23>
		*head = p;
c0103658:	8b 45 08             	mov    0x8(%ebp),%eax
c010365b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010365e:	89 10                	mov    %edx,(%eax)
		return 0;
c0103660:	b8 00 00 00 00       	mov    $0x0,%eax
c0103665:	eb 19                	jmp    c0103680 <ll_push+0x3c>
	}else{
		*head = p;
c0103667:	8b 45 08             	mov    0x8(%ebp),%eax
c010366a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010366d:	89 10                	mov    %edx,(%eax)
		p->next = h;
c010366f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103672:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103675:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c010367b:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103680:	c9                   	leave  
c0103681:	c3                   	ret    

c0103682 <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c0103682:	55                   	push   %ebp
c0103683:	89 e5                	mov    %esp,%ebp
c0103685:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103688:	8b 45 08             	mov    0x8(%ebp),%eax
c010368b:	8b 00                	mov    (%eax),%eax
c010368d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0103690:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103693:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c010369a:	00 00 00 
	if(h == NULL){
c010369d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01036a1:	75 0f                	jne    c01036b2 <ll_entail+0x30>
		*head = p;
c01036a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036a9:	89 10                	mov    %edx,(%eax)
		return 0;
c01036ab:	b8 00 00 00 00       	mov    $0x0,%eax
c01036b0:	eb 2c                	jmp    c01036de <ll_entail+0x5c>
	}else{
		while(h->next){
c01036b2:	eb 0c                	jmp    c01036c0 <ll_entail+0x3e>
			h = h->next;
c01036b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036b7:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01036bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c01036c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036c3:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c01036c9:	85 c0                	test   %eax,%eax
c01036cb:	75 e7                	jne    c01036b4 <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c01036cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01036d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036d3:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c01036d9:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01036de:	c9                   	leave  
c01036df:	c3                   	ret    

c01036e0 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c01036e0:	55                   	push   %ebp
c01036e1:	89 e5                	mov    %esp,%ebp
c01036e3:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c01036e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e9:	8b 00                	mov    (%eax),%eax
c01036eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01036ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c01036f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01036f9:	75 07                	jne    c0103702 <ll_delete+0x22>
			return 0;
c01036fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0103700:	eb 59                	jmp    c010375b <ll_delete+0x7b>
		if(sleep == p)
c0103702:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103705:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103708:	75 09                	jne    c0103713 <ll_delete+0x33>
			break;
c010370a:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c010370b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010370f:	75 26                	jne    c0103737 <ll_delete+0x57>
c0103711:	eb 14                	jmp    c0103727 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c0103713:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103716:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0103719:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010371c:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103722:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c0103725:	eb ce                	jmp    c01036f5 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c0103727:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010372a:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0103730:	8b 45 08             	mov    0x8(%ebp),%eax
c0103733:	89 10                	mov    %edx,(%eax)
c0103735:	eb 12                	jmp    c0103749 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c0103737:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010373a:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c0103740:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103743:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c0103749:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010374c:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0103753:	00 00 00 
	return 1;
c0103756:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010375b:	c9                   	leave  
c010375c:	c3                   	ret    

c010375d <init_pcb_pool>:

void init_pcb_pool()
{
c010375d:	55                   	push   %ebp
c010375e:	89 e5                	mov    %esp,%ebp
c0103760:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103763:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010376a:	eb 1d                	jmp    c0103789 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c010376c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010376f:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103775:	05 40 20 00 00       	add    $0x2040,%eax
c010377a:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c010377f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103785:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103789:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0103790:	76 da                	jbe    c010376c <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c0103792:	c9                   	leave  
c0103793:	c3                   	ret    

c0103794 <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c0103794:	55                   	push   %ebp
c0103795:	89 e5                	mov    %esp,%ebp
c0103797:	83 ec 24             	sub    $0x24,%esp
c010379a:	8b 45 14             	mov    0x14(%ebp),%eax
c010379d:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c01037a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01037a3:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c01037ac:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01037b0:	75 46                	jne    c01037f8 <init_pcb+0x64>
		tf->ds = GD_KD;
c01037b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037b5:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c01037bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037bf:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c01037c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037c9:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c01037cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037d2:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c01037d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037dc:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c01037e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037e6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01037ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01037ef:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c01037f6:	eb 4a                	jmp    c0103842 <init_pcb+0xae>
	}else
	if(pri == 3){
c01037f8:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c01037fc:	75 44                	jne    c0103842 <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c01037fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103801:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0103808:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010380b:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c0103812:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103815:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c010381b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010381e:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c0103825:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103828:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c010382f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103832:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103838:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010383b:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c0103842:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103845:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103848:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c010384b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010384e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103851:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c0103854:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103858:	75 59                	jne    c01038b3 <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c010385a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010385d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c0103860:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103863:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c0103866:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c010386d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103874:	eb 26                	jmp    c010389c <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c0103876:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103879:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103883:	01 c2                	add    %eax,%edx
c0103885:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103888:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c010388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103892:	01 c8                	add    %ecx,%eax
c0103894:	8b 00                	mov    (%eax),%eax
c0103896:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103898:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010389c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010389f:	c1 e8 02             	shr    $0x2,%eax
c01038a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01038a5:	77 cf                	ja     c0103876 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c01038a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01038aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038ad:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c01038b3:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01038b7:	0f 95 c0             	setne  %al
c01038ba:	0f b6 d0             	movzbl %al,%edx
c01038bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c0:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c01038c6:	c9                   	leave  
c01038c7:	c3                   	ret    

c01038c8 <pcb_create>:

PCB* pcb_create()
{
c01038c8:	55                   	push   %ebp
c01038c9:	89 e5                	mov    %esp,%ebp
c01038cb:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01038ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01038d5:	eb 1f                	jmp    c01038f6 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c01038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038da:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01038e0:	05 40 20 00 00       	add    $0x2040,%eax
c01038e5:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c01038ea:	8b 00                	mov    (%eax),%eax
c01038ec:	85 c0                	test   %eax,%eax
c01038ee:	75 02                	jne    c01038f2 <pcb_create+0x2a>
c01038f0:	eb 0d                	jmp    c01038ff <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01038f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01038f6:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c01038fd:	76 d8                	jbe    c01038d7 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c01038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103902:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103908:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c010390d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0103910:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103913:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0103916:	8d 90 40 e1 1d c0    	lea    -0x3fe21ec0(%eax),%edx
c010391c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010391f:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c0103925:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103928:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c010392f:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c0103932:	83 ec 0c             	sub    $0xc,%esp
c0103935:	6a 01                	push   $0x1
c0103937:	e8 47 cf ff ff       	call   c0100883 <page_alloc>
c010393c:	83 c4 10             	add    $0x10,%esp
c010393f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c0103942:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103946:	75 07                	jne    c010394f <pcb_create+0x87>
c0103948:	b8 00 00 00 00       	mov    $0x0,%eax
c010394d:	eb 77                	jmp    c01039c6 <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c010394f:	83 ec 0c             	sub    $0xc,%esp
c0103952:	ff 75 ec             	pushl  -0x14(%ebp)
c0103955:	e8 6e fc ff ff       	call   c01035c8 <page2kva>
c010395a:	83 c4 10             	add    $0x10,%esp
c010395d:	89 c2                	mov    %eax,%edx
c010395f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103962:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c0103968:	8b 15 a8 80 10 c0    	mov    0xc01080a8,%edx
c010396e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103971:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c0103977:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010397a:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c0103981:	00 00 00 
	//p->ts = READY;
	pid ++;
c0103984:	a1 a8 80 10 c0       	mov    0xc01080a8,%eax
c0103989:	83 c0 01             	add    $0x1,%eax
c010398c:	a3 a8 80 10 c0       	mov    %eax,0xc01080a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0103991:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103994:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0103998:	8d 50 01             	lea    0x1(%eax),%edx
c010399b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010399e:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c01039a2:	8b 15 c0 56 17 c0    	mov    0xc01756c0,%edx
c01039a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ab:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01039b1:	83 ec 04             	sub    $0x4,%esp
c01039b4:	68 00 10 00 00       	push   $0x1000
c01039b9:	52                   	push   %edx
c01039ba:	50                   	push   %eax
c01039bb:	e8 43 fb ff ff       	call   c0103503 <memcpy>
c01039c0:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c01039c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01039c6:	c9                   	leave  
c01039c7:	c3                   	ret    

c01039c8 <enready_pcb>:

void enready_pcb(PCB* pcb){
c01039c8:	55                   	push   %ebp
c01039c9:	89 e5                	mov    %esp,%ebp
c01039cb:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c01039ce:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01039d3:	85 c0                	test   %eax,%eax
c01039d5:	75 18                	jne    c01039ef <enready_pcb+0x27>
		ready_list = pcb;
c01039d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039da:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->tail = pcb;
c01039df:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01039e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01039e7:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c01039ed:	eb 32                	jmp    c0103a21 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c01039ef:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c01039f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c01039f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039fa:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->next = temp;
c01039ff:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103a07:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c0103a0d:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c0103a12:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103a15:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c0103a1b:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c0103a21:	c9                   	leave  
c0103a22:	c3                   	ret    

c0103a23 <switch_pcb>:

void switch_pcb(PCB* pcb){
c0103a23:	55                   	push   %ebp
c0103a24:	89 e5                	mov    %esp,%ebp
c0103a26:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c0103a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2c:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac
	lcr3(PADDR(pcb -> pgdir));
c0103a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a34:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103a3a:	83 ec 04             	sub    $0x4,%esp
c0103a3d:	50                   	push   %eax
c0103a3e:	68 af 00 00 00       	push   $0xaf
c0103a43:	68 49 48 10 c0       	push   $0xc0104849
c0103a48:	e8 d3 fa ff ff       	call   c0103520 <_paddr>
c0103a4d:	83 c4 10             	add    $0x10,%esp
c0103a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0103a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a56:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c0103a59:	83 ec 0c             	sub    $0xc,%esp
c0103a5c:	ff 75 08             	pushl  0x8(%ebp)
c0103a5f:	e8 f8 c8 ff ff       	call   c010035c <enter_pcb>
c0103a64:	83 c4 10             	add    $0x10,%esp
}
c0103a67:	c9                   	leave  
c0103a68:	c3                   	ret    

c0103a69 <free_pcb>:
void free_pcb(PCB* pcb){
c0103a69:	55                   	push   %ebp
c0103a6a:	89 e5                	mov    %esp,%ebp
c0103a6c:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c0103a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a72:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103a78:	83 ec 0c             	sub    $0xc,%esp
c0103a7b:	50                   	push   %eax
c0103a7c:	e8 66 d3 ff ff       	call   c0100de7 <free_pgdir>
c0103a81:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c0103a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a87:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103a8d:	83 ec 04             	sub    $0x4,%esp
c0103a90:	50                   	push   %eax
c0103a91:	68 b8 00 00 00       	push   $0xb8
c0103a96:	68 49 48 10 c0       	push   $0xc0104849
c0103a9b:	e8 80 fa ff ff       	call   c0103520 <_paddr>
c0103aa0:	83 c4 10             	add    $0x10,%esp
c0103aa3:	83 ec 0c             	sub    $0xc,%esp
c0103aa6:	50                   	push   %eax
c0103aa7:	e8 e9 fa ff ff       	call   c0103595 <pa2page>
c0103aac:	83 c4 10             	add    $0x10,%esp
c0103aaf:	83 ec 0c             	sub    $0xc,%esp
c0103ab2:	50                   	push   %eax
c0103ab3:	e8 53 ce ff ff       	call   c010090b <page_decref>
c0103ab8:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c0103abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103abe:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c0103ac5:	00 00 00 

}
c0103ac8:	c9                   	leave  
c0103ac9:	c3                   	ret    

c0103aca <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c0103aca:	55                   	push   %ebp
c0103acb:	89 e5                	mov    %esp,%ebp
c0103acd:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0103ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad6:	68 10 08 00 00       	push   $0x810
c0103adb:	52                   	push   %edx
c0103adc:	50                   	push   %eax
c0103add:	e8 21 fa ff ff       	call   c0103503 <memcpy>
c0103ae2:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c0103ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ae8:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0103aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af1:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c0103af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afa:	05 20 10 00 00       	add    $0x1020,%eax
c0103aff:	89 c2                	mov    %eax,%edx
c0103b01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b04:	05 20 10 00 00       	add    $0x1020,%eax
c0103b09:	29 c2                	sub    %eax,%edx
c0103b0b:	89 d0                	mov    %edx,%eax
c0103b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c0103b10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b13:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c0103b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b1c:	01 c2                	add    %eax,%edx
c0103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b21:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c0103b27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b2a:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c0103b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b33:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c0103b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3c:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103b42:	85 c0                	test   %eax,%eax
c0103b44:	75 62                	jne    c0103ba8 <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c0103b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b49:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103b4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b52:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c0103b58:	8b 4a 08             	mov    0x8(%edx),%ecx
c0103b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b5e:	01 ca                	add    %ecx,%edx
c0103b60:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c0103b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b66:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103b6c:	8b 40 08             	mov    0x8(%eax),%eax
c0103b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c0103b72:	eb 17                	jmp    c0103b8b <copy_pcb+0xc1>
			*(ptr) += offset;
c0103b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b77:	8b 10                	mov    (%eax),%edx
c0103b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b7c:	01 c2                	add    %eax,%edx
c0103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b81:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c0103b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b86:	8b 00                	mov    (%eax),%eax
c0103b88:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0103b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b8e:	8b 00                	mov    (%eax),%eax
c0103b90:	85 c0                	test   %eax,%eax
c0103b92:	75 e0                	jne    c0103b74 <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c0103b94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b97:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0103b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba0:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c0103ba6:	eb 2d                	jmp    c0103bd5 <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c0103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bab:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103bb1:	83 f8 02             	cmp    $0x2,%eax
c0103bb4:	74 1f                	je     c0103bd5 <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c0103bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103bb9:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0103bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc2:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103bc8:	83 ec 08             	sub    $0x8,%esp
c0103bcb:	52                   	push   %edx
c0103bcc:	50                   	push   %eax
c0103bcd:	e8 60 cf ff ff       	call   c0100b32 <copy_pgdir>
c0103bd2:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c0103bd5:	c9                   	leave  
c0103bd6:	c3                   	ret    

c0103bd7 <fork_current>:

void switch_proc();
void fork_current(){
c0103bd7:	55                   	push   %ebp
c0103bd8:	89 e5                	mov    %esp,%ebp
c0103bda:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0103bdd:	e8 e6 fc ff ff       	call   c01038c8 <pcb_create>
c0103be2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c0103be5:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103bea:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bf3:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0103bf9:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103bfe:	83 ec 08             	sub    $0x8,%esp
c0103c01:	50                   	push   %eax
c0103c02:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c05:	e8 c0 fe ff ff       	call   c0103aca <copy_pcb>
c0103c0a:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0103c0d:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103c12:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c1b:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103c21:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0103c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c27:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103c2d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c0103c34:	83 ec 08             	sub    $0x8,%esp
c0103c37:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c3a:	68 b0 60 15 c0       	push   $0xc01560b0
c0103c3f:	e8 00 fa ff ff       	call   c0103644 <ll_push>
c0103c44:	83 c4 10             	add    $0x10,%esp
}
c0103c47:	c9                   	leave  
c0103c48:	c3                   	ret    

c0103c49 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c0103c49:	55                   	push   %ebp
c0103c4a:	89 e5                	mov    %esp,%ebp
c0103c4c:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c0103c4f:	e8 74 fc ff ff       	call   c01038c8 <pcb_create>
c0103c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c0103c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c5a:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c0103c61:	00 00 00 
	son->ppid = current->pid;
c0103c64:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103c69:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c72:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0103c78:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103c7d:	83 ec 08             	sub    $0x8,%esp
c0103c80:	50                   	push   %eax
c0103c81:	ff 75 f4             	pushl  -0xc(%ebp)
c0103c84:	e8 41 fe ff ff       	call   c0103aca <copy_pcb>
c0103c89:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c0103c8c:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103c91:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0103c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103ca0:	83 ec 04             	sub    $0x4,%esp
c0103ca3:	68 00 10 00 00       	push   $0x1000
c0103ca8:	52                   	push   %edx
c0103ca9:	50                   	push   %eax
c0103caa:	e8 54 f8 ff ff       	call   c0103503 <memcpy>
c0103caf:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c0103cb2:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0103cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cbc:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c0103cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc5:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103ccb:	83 ec 04             	sub    $0x4,%esp
c0103cce:	68 00 20 00 00       	push   $0x2000
c0103cd3:	52                   	push   %edx
c0103cd4:	50                   	push   %eax
c0103cd5:	e8 b7 c9 ff ff       	call   c0100691 <mm_alloc>
c0103cda:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c0103cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce0:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103ce6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103ce9:	83 ea 40             	sub    $0x40,%edx
c0103cec:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c0103cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cf2:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103cf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103cfb:	83 ea 40             	sub    $0x40,%edx
c0103cfe:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c0103d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d04:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103d0a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d0d:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0103d10:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103d15:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d1e:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103d24:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0103d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d2a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103d30:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c0103d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d3a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103d40:	83 ec 04             	sub    $0x4,%esp
c0103d43:	50                   	push   %eax
c0103d44:	68 fb 00 00 00       	push   $0xfb
c0103d49:	68 49 48 10 c0       	push   $0xc0104849
c0103d4e:	e8 cd f7 ff ff       	call   c0103520 <_paddr>
c0103d53:	83 c4 10             	add    $0x10,%esp
c0103d56:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d5c:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c0103d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d62:	83 e8 40             	sub    $0x40,%eax
c0103d65:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c0103d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d6e:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c0103d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d73:	8d 50 04             	lea    0x4(%eax),%edx
c0103d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d79:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c0103d7b:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103d80:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103d86:	83 ec 04             	sub    $0x4,%esp
c0103d89:	50                   	push   %eax
c0103d8a:	68 01 01 00 00       	push   $0x101
c0103d8f:	68 49 48 10 c0       	push   $0xc0104849
c0103d94:	e8 87 f7 ff ff       	call   c0103520 <_paddr>
c0103d99:	83 c4 10             	add    $0x10,%esp
c0103d9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103da2:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c0103da5:	83 ec 08             	sub    $0x8,%esp
c0103da8:	ff 75 f4             	pushl  -0xc(%ebp)
c0103dab:	68 b0 60 15 c0       	push   $0xc01560b0
c0103db0:	e8 8f f8 ff ff       	call   c0103644 <ll_push>
c0103db5:	83 c4 10             	add    $0x10,%esp
}
c0103db8:	c9                   	leave  
c0103db9:	c3                   	ret    

c0103dba <exit_current>:

void exit_current(){
c0103dba:	55                   	push   %ebp
c0103dbb:	89 e5                	mov    %esp,%ebp
c0103dbd:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0103dc0:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103dc5:	05 68 20 00 00       	add    $0x2068,%eax
c0103dca:	83 ec 0c             	sub    $0xc,%esp
c0103dcd:	50                   	push   %eax
c0103dce:	e8 4d f8 ff ff       	call   c0103620 <ll_pop>
c0103dd3:	83 c4 10             	add    $0x10,%esp
c0103dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0103dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ddd:	75 02                	jne    c0103de1 <exit_current+0x27>
c0103ddf:	eb 24                	jmp    c0103e05 <exit_current+0x4b>
		if(p->used == 0) continue;
c0103de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de4:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0103dea:	85 c0                	test   %eax,%eax
c0103dec:	75 02                	jne    c0103df0 <exit_current+0x36>
c0103dee:	eb 13                	jmp    c0103e03 <exit_current+0x49>
		ll_entail(&ready_list, p);
c0103df0:	83 ec 08             	sub    $0x8,%esp
c0103df3:	ff 75 f4             	pushl  -0xc(%ebp)
c0103df6:	68 b0 60 15 c0       	push   $0xc01560b0
c0103dfb:	e8 82 f8 ff ff       	call   c0103682 <ll_entail>
c0103e00:	83 c4 10             	add    $0x10,%esp
	}
c0103e03:	eb bb                	jmp    c0103dc0 <exit_current+0x6>
	
	free_pcb(current);
c0103e05:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103e0a:	83 ec 0c             	sub    $0xc,%esp
c0103e0d:	50                   	push   %eax
c0103e0e:	e8 56 fc ff ff       	call   c0103a69 <free_pcb>
c0103e13:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c0103e16:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0103e1d:	00 00 00 
	do_scheduler();
c0103e20:	e8 86 d2 ff ff       	call   c01010ab <do_scheduler>
}
c0103e25:	c9                   	leave  
c0103e26:	c3                   	ret    

c0103e27 <join_current>:

void join_current(int pid){
c0103e27:	55                   	push   %ebp
c0103e28:	89 e5                	mov    %esp,%ebp
c0103e2a:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0103e2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103e31:	75 05                	jne    c0103e38 <join_current+0x11>
c0103e33:	e9 97 00 00 00       	jmp    c0103ecf <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103e38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103e3f:	eb 23                	jmp    c0103e64 <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0103e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e44:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103e4a:	05 40 20 00 00       	add    $0x2040,%eax
c0103e4f:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c0103e54:	8b 50 04             	mov    0x4(%eax),%edx
c0103e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e5a:	39 c2                	cmp    %eax,%edx
c0103e5c:	75 02                	jne    c0103e60 <join_current+0x39>
c0103e5e:	eb 0d                	jmp    c0103e6d <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103e60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e64:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0103e6b:	76 d4                	jbe    c0103e41 <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0103e6d:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0103e74:	75 02                	jne    c0103e78 <join_current+0x51>
c0103e76:	eb 57                	jmp    c0103ecf <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c0103e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e7b:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103e81:	05 40 20 00 00       	add    $0x2040,%eax
c0103e86:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c0103e8b:	8b 00                	mov    (%eax),%eax
c0103e8d:	85 c0                	test   %eax,%eax
c0103e8f:	75 02                	jne    c0103e93 <join_current+0x6c>
c0103e91:	eb 3c                	jmp    c0103ecf <join_current+0xa8>
	PCB *p = &PCBPool[i];
c0103e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e96:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103e9c:	05 40 0a 1f c0       	add    $0xc01f0a40,%eax
c0103ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0103ea4:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103ea9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0103eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103eaf:	05 68 20 00 00       	add    $0x2068,%eax
c0103eb4:	ff 75 ec             	pushl  -0x14(%ebp)
c0103eb7:	50                   	push   %eax
c0103eb8:	e8 c5 f7 ff ff       	call   c0103682 <ll_entail>
c0103ebd:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0103ec0:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0103ec7:	00 00 00 
	do_scheduler();
c0103eca:	e8 dc d1 ff ff       	call   c01010ab <do_scheduler>
c0103ecf:	c9                   	leave  
c0103ed0:	c3                   	ret    

c0103ed1 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0103ed1:	55                   	push   %ebp
c0103ed2:	89 e5                	mov    %esp,%ebp
c0103ed4:	57                   	push   %edi
c0103ed5:	56                   	push   %esi
c0103ed6:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103ed7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103eda:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103ee0:	89 c1                	mov    %eax,%ecx
c0103ee2:	89 d6                	mov    %edx,%esi
c0103ee4:	89 df                	mov    %ebx,%edi
c0103ee6:	fc                   	cld    
c0103ee7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0103ee9:	5b                   	pop    %ebx
c0103eea:	5e                   	pop    %esi
c0103eeb:	5f                   	pop    %edi
c0103eec:	5d                   	pop    %ebp
c0103eed:	c3                   	ret    

c0103eee <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0103eee:	55                   	push   %ebp
c0103eef:	89 e5                	mov    %esp,%ebp
c0103ef1:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0103ef4:	68 80 3e 00 00       	push   $0x3e80
c0103ef9:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103efe:	68 c0 60 15 c0       	push   $0xc01560c0
c0103f03:	e8 c9 ff ff ff       	call   c0103ed1 <memcpy>
c0103f08:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0103f0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103f12:	eb 0f                	jmp    c0103f23 <initVCache+0x35>
		VDIRTY[x] = 0;
c0103f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f17:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103f1c:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0103f1f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103f23:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103f2a:	7e e8                	jle    c0103f14 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0103f2c:	c9                   	leave  
c0103f2d:	c3                   	ret    

c0103f2e <refreshVCache>:
void refreshVCache(){
c0103f2e:	55                   	push   %ebp
c0103f2f:	89 e5                	mov    %esp,%ebp
c0103f31:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103f3b:	eb 0f                	jmp    c0103f4c <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0103f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f40:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103f45:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103f48:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103f4c:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103f53:	7e e8                	jle    c0103f3d <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0103f55:	c9                   	leave  
c0103f56:	c3                   	ret    

c0103f57 <flushVCache>:
void flushVCache(){
c0103f57:	55                   	push   %ebp
c0103f58:	89 e5                	mov    %esp,%ebp
c0103f5a:	53                   	push   %ebx
c0103f5b:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103f5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0103f65:	eb 47                	jmp    c0103fae <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0103f67:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f6a:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103f6f:	0f b6 00             	movzbl (%eax),%eax
c0103f72:	84 c0                	test   %al,%al
c0103f74:	74 34                	je     c0103faa <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0103f76:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103f79:	89 d0                	mov    %edx,%eax
c0103f7b:	c1 e0 02             	shl    $0x2,%eax
c0103f7e:	01 d0                	add    %edx,%eax
c0103f80:	c1 e0 06             	shl    $0x6,%eax
c0103f83:	8d 88 c0 60 15 c0    	lea    -0x3fea9f40(%eax),%ecx
c0103f89:	8b 1d ac 80 10 c0    	mov    0xc01080ac,%ebx
c0103f8f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103f92:	89 d0                	mov    %edx,%eax
c0103f94:	c1 e0 02             	shl    $0x2,%eax
c0103f97:	01 d0                	add    %edx,%eax
c0103f99:	c1 e0 06             	shl    $0x6,%eax
c0103f9c:	01 d8                	add    %ebx,%eax
c0103f9e:	6a 50                	push   $0x50
c0103fa0:	51                   	push   %ecx
c0103fa1:	50                   	push   %eax
c0103fa2:	e8 2a ff ff ff       	call   c0103ed1 <memcpy>
c0103fa7:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103faa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0103fae:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0103fb5:	7e b0                	jle    c0103f67 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0103fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103fba:	c9                   	leave  
c0103fbb:	c3                   	ret    

c0103fbc <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0103fbc:	55                   	push   %ebp
c0103fbd:	89 e5                	mov    %esp,%ebp
c0103fbf:	83 ec 04             	sub    $0x4,%esp
c0103fc2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0103fc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103fcc:	78 18                	js     c0103fe6 <setPixelAt+0x2a>
c0103fce:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0103fd5:	7f 0f                	jg     c0103fe6 <setPixelAt+0x2a>
c0103fd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103fdb:	78 09                	js     c0103fe6 <setPixelAt+0x2a>
c0103fdd:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0103fe4:	7e 02                	jle    c0103fe8 <setPixelAt+0x2c>
c0103fe6:	eb 34                	jmp    c010401c <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0103fe8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103feb:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103ff0:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0103ff3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ff6:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0103ffb:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0103ffe:	8b 55 08             	mov    0x8(%ebp),%edx
c0104001:	89 d0                	mov    %edx,%eax
c0104003:	c1 e0 02             	shl    $0x2,%eax
c0104006:	01 d0                	add    %edx,%eax
c0104008:	c1 e0 06             	shl    $0x6,%eax
c010400b:	89 c2                	mov    %eax,%edx
c010400d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104010:	01 c2                	add    %eax,%edx
c0104012:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0104016:	88 82 c0 60 15 c0    	mov    %al,-0x3fea9f40(%edx)
}
c010401c:	c9                   	leave  
c010401d:	c3                   	ret    

c010401e <forceClearVRAM>:
void forceClearVRAM(){
c010401e:	55                   	push   %ebp
c010401f:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0104021:	5d                   	pop    %ebp
c0104022:	c3                   	ret    

c0104023 <clearVRAM>:
void clearVRAM(){
c0104023:	55                   	push   %ebp
c0104024:	89 e5                	mov    %esp,%ebp
c0104026:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0104029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0104030:	eb 4e                	jmp    c0104080 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0104032:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104035:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c010403a:	0f b6 00             	movzbl (%eax),%eax
c010403d:	0f b6 c0             	movzbl %al,%eax
c0104040:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104043:	81 c2 c0 54 17 c0    	add    $0xc01754c0,%edx
c0104049:	0f b6 12             	movzbl (%edx),%edx
c010404c:	0f b6 d2             	movzbl %dl,%edx
c010404f:	f7 d2                	not    %edx
c0104051:	21 d0                	and    %edx,%eax
c0104053:	85 c0                	test   %eax,%eax
c0104055:	74 25                	je     c010407c <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0104057:	8b 0d ac 80 10 c0    	mov    0xc01080ac,%ecx
c010405d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104060:	89 d0                	mov    %edx,%eax
c0104062:	c1 e0 02             	shl    $0x2,%eax
c0104065:	01 d0                	add    %edx,%eax
c0104067:	c1 e0 06             	shl    $0x6,%eax
c010406a:	01 c8                	add    %ecx,%eax
c010406c:	6a 50                	push   $0x50
c010406e:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0104073:	50                   	push   %eax
c0104074:	e8 58 fe ff ff       	call   c0103ed1 <memcpy>
c0104079:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c010407c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0104080:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0104087:	7e a9                	jle    c0104032 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0104089:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0104090:	83 c0 01             	add    $0x1,%eax
c0104093:	a2 88 56 17 c0       	mov    %al,0xc0175688
	if(stamp==30){
c0104098:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c010409f:	3c 1e                	cmp    $0x1e,%al
c01040a1:	75 07                	jne    c01040aa <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c01040a3:	c6 05 88 56 17 c0 00 	movb   $0x0,0xc0175688
		//printk("What matters\n");
	}
	if(stamp==0){
c01040aa:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c01040b1:	84 c0                	test   %al,%al
c01040b3:	75 14                	jne    c01040c9 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c01040b5:	6a 32                	push   $0x32
c01040b7:	68 c0 5a 16 c0       	push   $0xc0165ac0
c01040bc:	68 c0 55 17 c0       	push   $0xc01755c0
c01040c1:	e8 0b fe ff ff       	call   c0103ed1 <memcpy>
c01040c6:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c01040c9:	c9                   	leave  
c01040ca:	c3                   	ret    

c01040cb <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c01040cb:	55                   	push   %ebp
c01040cc:	89 e5                	mov    %esp,%ebp
c01040ce:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c01040d1:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c01040d6:	83 c0 01             	add    $0x1,%eax
c01040d9:	a3 8c 56 17 c0       	mov    %eax,0xc017568c
	current->timeslice ++;
c01040de:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01040e3:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c01040e9:	83 c2 01             	add    $0x1,%edx
c01040ec:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c01040f2:	a1 b4 60 15 c0       	mov    0xc01560b4,%eax
c01040f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c01040fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040fe:	75 02                	jne    c0104102 <do_timer+0x37>
c0104100:	eb 6b                	jmp    c010416d <do_timer+0xa2>
	 	sleep->timeslice --;
c0104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104105:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c010410b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010410e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104111:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0104117:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010411a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c010411d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104120:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0104126:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0104129:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010412c:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0104132:	85 c0                	test   %eax,%eax
c0104134:	74 02                	je     c0104138 <do_timer+0x6d>
c0104136:	eb 33                	jmp    c010416b <do_timer+0xa0>
	 	cur->ts = READY;
c0104138:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010413b:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0104142:	00 00 00 
		ll_delete(&sleep_list, cur);
c0104145:	83 ec 08             	sub    $0x8,%esp
c0104148:	ff 75 f0             	pushl  -0x10(%ebp)
c010414b:	68 b4 60 15 c0       	push   $0xc01560b4
c0104150:	e8 8b f5 ff ff       	call   c01036e0 <ll_delete>
c0104155:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0104158:	83 ec 08             	sub    $0x8,%esp
c010415b:	ff 75 f0             	pushl  -0x10(%ebp)
c010415e:	68 b0 60 15 c0       	push   $0xc01560b0
c0104163:	e8 1a f5 ff ff       	call   c0103682 <ll_entail>
c0104168:	83 c4 10             	add    $0x10,%esp
	}
c010416b:	eb 8d                	jmp    c01040fa <do_timer+0x2f>
}
c010416d:	c9                   	leave  
c010416e:	c3                   	ret    

c010416f <tick>:
uint32_t tick(){
c010416f:	55                   	push   %ebp
c0104170:	89 e5                	mov    %esp,%ebp
	return _tick;
c0104172:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c0104177:	5d                   	pop    %ebp
c0104178:	c3                   	ret    

c0104179 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0104179:	6a 00                	push   $0x0
c010417b:	6a 00                	push   $0x0
c010417d:	e9 b8 00 00 00       	jmp    c010423a <asm_do_irq>

c0104182 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0104182:	6a 00                	push   $0x0
c0104184:	6a 01                	push   $0x1
c0104186:	e9 af 00 00 00       	jmp    c010423a <asm_do_irq>

c010418b <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c010418b:	6a 00                	push   $0x0
c010418d:	6a 02                	push   $0x2
c010418f:	e9 a6 00 00 00       	jmp    c010423a <asm_do_irq>

c0104194 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0104194:	6a 00                	push   $0x0
c0104196:	6a 03                	push   $0x3
c0104198:	e9 9d 00 00 00       	jmp    c010423a <asm_do_irq>

c010419d <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c010419d:	6a 00                	push   $0x0
c010419f:	6a 04                	push   $0x4
c01041a1:	e9 94 00 00 00       	jmp    c010423a <asm_do_irq>

c01041a6 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c01041a6:	6a 00                	push   $0x0
c01041a8:	6a 05                	push   $0x5
c01041aa:	e9 8b 00 00 00       	jmp    c010423a <asm_do_irq>

c01041af <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c01041af:	6a 00                	push   $0x0
c01041b1:	6a 06                	push   $0x6
c01041b3:	e9 82 00 00 00       	jmp    c010423a <asm_do_irq>

c01041b8 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c01041b8:	6a 00                	push   $0x0
c01041ba:	6a 07                	push   $0x7
c01041bc:	e9 79 00 00 00       	jmp    c010423a <asm_do_irq>

c01041c1 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c01041c1:	6a 00                	push   $0x0
c01041c3:	6a 08                	push   $0x8
c01041c5:	e9 70 00 00 00       	jmp    c010423a <asm_do_irq>

c01041ca <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c01041ca:	6a 00                	push   $0x0
c01041cc:	6a 09                	push   $0x9
c01041ce:	e9 67 00 00 00       	jmp    c010423a <asm_do_irq>

c01041d3 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c01041d3:	6a 00                	push   $0x0
c01041d5:	6a 0a                	push   $0xa
c01041d7:	e9 5e 00 00 00       	jmp    c010423a <asm_do_irq>

c01041dc <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c01041dc:	6a 00                	push   $0x0
c01041de:	6a 0b                	push   $0xb
c01041e0:	e9 55 00 00 00       	jmp    c010423a <asm_do_irq>

c01041e5 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c01041e5:	6a 00                	push   $0x0
c01041e7:	6a 0c                	push   $0xc
c01041e9:	e9 4c 00 00 00       	jmp    c010423a <asm_do_irq>

c01041ee <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c01041ee:	6a 00                	push   $0x0
c01041f0:	6a 0d                	push   $0xd
c01041f2:	e9 43 00 00 00       	jmp    c010423a <asm_do_irq>

c01041f7 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c01041f7:	6a 00                	push   $0x0
c01041f9:	6a 0e                	push   $0xe
c01041fb:	e9 3a 00 00 00       	jmp    c010423a <asm_do_irq>

c0104200 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0104200:	fa                   	cli    
c0104201:	6a 00                	push   $0x0
c0104203:	68 80 00 00 00       	push   $0x80
c0104208:	e9 2d 00 00 00       	jmp    c010423a <asm_do_irq>

c010420d <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c010420d:	6a 00                	push   $0x0
c010420f:	68 e8 03 00 00       	push   $0x3e8
c0104214:	e9 21 00 00 00       	jmp    c010423a <asm_do_irq>

c0104219 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0104219:	6a 00                	push   $0x0
c010421b:	68 e9 03 00 00       	push   $0x3e9
c0104220:	e9 15 00 00 00       	jmp    c010423a <asm_do_irq>

c0104225 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0104225:	6a 00                	push   $0x0
c0104227:	68 f6 03 00 00       	push   $0x3f6
c010422c:	e9 09 00 00 00       	jmp    c010423a <asm_do_irq>

c0104231 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0104231:	6a 00                	push   $0x0
c0104233:	6a ff                	push   $0xffffffff
c0104235:	e9 00 00 00 00       	jmp    c010423a <asm_do_irq>

c010423a <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c010423a:	fa                   	cli    
  pushl %ds
c010423b:	1e                   	push   %ds
  pushl %es
c010423c:	06                   	push   %es
  pushl %fs
c010423d:	0f a0                	push   %fs
  pushl %gs
c010423f:	0f a8                	push   %gs
	pushal
c0104241:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0104242:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0104246:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0104248:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c010424a:	54                   	push   %esp
  call irq_handle
c010424b:	e8 4e cf ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0104250:	83 c4 04             	add    $0x4,%esp

c0104253 <switch_proc>:
switch_proc:
  popal
c0104253:	61                   	popa   
  popl %gs
c0104254:	0f a9                	pop    %gs
  popl %fs
c0104256:	0f a1                	pop    %fs
  popl %es
c0104258:	07                   	pop    %es
  popl %ds
c0104259:	1f                   	pop    %ds
  addl $8, %esp
c010425a:	83 c4 08             	add    $0x8,%esp
  sti
c010425d:	fb                   	sti    
  iret
c010425e:	cf                   	iret   
c010425f:	90                   	nop
c0104260:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0104266:	00 00                	add    %al,(%eax)
c0104268:	fe 4f 52             	decb   0x52(%edi)
c010426b:	e4 66                	in     $0x66,%al

c010426c <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c010426c:	66 c7 05 72 04 00 00 34 12 b8 00 70 10 00 0f 22     f..r...4...p..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c010427c:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 8f 42 10     .. ......."...B.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c010428c:	c0 ff e0                                            ...

c010428f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c010428f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0104294:	bc 00 10 11 c0       	mov    $0xc0111000,%esp

	# now to C code

	call	main
c0104299:	e8 c9 e6 ff ff       	call   c0102967 <main>

c010429e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c010429e:	eb fe                	jmp    c010429e <spin>

c01042a0 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c01042a0:	55                   	push   %ebp
c01042a1:	89 e5                	mov    %esp,%ebp
c01042a3:	53                   	push   %ebx
c01042a4:	83 ec 04             	sub    $0x4,%esp
c01042a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01042aa:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c01042ad:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c01042b2:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c01042b6:	89 d3                	mov    %edx,%ebx
c01042b8:	cd 80                	int    $0x80
}
c01042ba:	83 c4 04             	add    $0x4,%esp
c01042bd:	5b                   	pop    %ebx
c01042be:	5d                   	pop    %ebp
c01042bf:	c3                   	ret    

c01042c0 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c01042c0:	55                   	push   %ebp
c01042c1:	89 e5                	mov    %esp,%ebp
c01042c3:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c01042c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c01042cc:	eb 19                	jmp    c01042e7 <printp+0x27>
		printer(cur);
c01042ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d1:	0f b6 00             	movzbl (%eax),%eax
c01042d4:	0f be c0             	movsbl %al,%eax
c01042d7:	83 ec 0c             	sub    $0xc,%esp
c01042da:	50                   	push   %eax
c01042db:	8b 45 08             	mov    0x8(%ebp),%eax
c01042de:	ff d0                	call   *%eax
c01042e0:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c01042e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01042e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ea:	0f b6 00             	movzbl (%eax),%eax
c01042ed:	84 c0                	test   %al,%al
c01042ef:	75 dd                	jne    c01042ce <printp+0xe>
		printer(cur);
	}
}
c01042f1:	c9                   	leave  
c01042f2:	c3                   	ret    

c01042f3 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c01042f3:	55                   	push   %ebp
c01042f4:	89 e5                	mov    %esp,%ebp
c01042f6:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c01042f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c01042ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0104306:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c010430d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104310:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0104313:	e9 65 02 00 00       	jmp    c010457d <vfprintf+0x28a>

		if(cur == '%'){
c0104318:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431b:	0f b6 00             	movzbl (%eax),%eax
c010431e:	3c 25                	cmp    $0x25,%al
c0104320:	75 0c                	jne    c010432e <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0104322:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0104329:	e9 4b 02 00 00       	jmp    c0104579 <vfprintf+0x286>
		}
		if(type == READ){
c010432e:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0104332:	0f 85 26 02 00 00    	jne    c010455e <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0104338:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433b:	0f b6 00             	movzbl (%eax),%eax
c010433e:	3c 73                	cmp    $0x73,%al
c0104340:	75 35                	jne    c0104377 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0104342:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104345:	8b 00                	mov    (%eax),%eax
c0104347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c010434a:	eb 19                	jmp    c0104365 <vfprintf+0x72>
					printer(*p);
c010434c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010434f:	0f b6 00             	movzbl (%eax),%eax
c0104352:	0f be c0             	movsbl %al,%eax
c0104355:	83 ec 0c             	sub    $0xc,%esp
c0104358:	50                   	push   %eax
c0104359:	8b 45 08             	mov    0x8(%ebp),%eax
c010435c:	ff d0                	call   *%eax
c010435e:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0104361:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0104365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104368:	0f b6 00             	movzbl (%eax),%eax
c010436b:	84 c0                	test   %al,%al
c010436d:	75 dd                	jne    c010434c <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c010436f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104373:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0104377:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437a:	0f b6 00             	movzbl (%eax),%eax
c010437d:	3c 78                	cmp    $0x78,%al
c010437f:	0f 85 99 00 00 00    	jne    c010441e <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0104385:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104388:	8b 00                	mov    (%eax),%eax
c010438a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c010438d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104391:	75 1d                	jne    c01043b0 <vfprintf+0xbd>
					printer('0');
c0104393:	83 ec 0c             	sub    $0xc,%esp
c0104396:	6a 30                	push   $0x30
c0104398:	8b 45 08             	mov    0x8(%ebp),%eax
c010439b:	ff d0                	call   *%eax
c010439d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01043a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01043a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01043ab:	e9 c9 01 00 00       	jmp    c0104579 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c01043b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c01043b7:	eb 2d                	jmp    c01043e6 <vfprintf+0xf3>
					int d=(x%16);
c01043b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043bc:	83 e0 0f             	and    $0xf,%eax
c01043bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c01043c2:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c01043c6:	7e 04                	jle    c01043cc <vfprintf+0xd9>
						d+='a'-'0'-10;
c01043c8:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c01043cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043cf:	83 c0 30             	add    $0x30,%eax
c01043d2:	89 c1                	mov    %eax,%ecx
c01043d4:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c01043d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043da:	01 d0                	add    %edx,%eax
c01043dc:	88 08                	mov    %cl,(%eax)
					x>>=4;
c01043de:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c01043e2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c01043e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01043ea:	75 cd                	jne    c01043b9 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c01043ec:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c01043f0:	eb 1e                	jmp    c0104410 <vfprintf+0x11d>
					printer(digits[di]);
c01043f2:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c01043f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043f8:	01 d0                	add    %edx,%eax
c01043fa:	0f b6 00             	movzbl (%eax),%eax
c01043fd:	0f be c0             	movsbl %al,%eax
c0104400:	83 ec 0c             	sub    $0xc,%esp
c0104403:	50                   	push   %eax
c0104404:	8b 45 08             	mov    0x8(%ebp),%eax
c0104407:	ff d0                	call   *%eax
c0104409:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c010440c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0104410:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104414:	79 dc                	jns    c01043f2 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0104416:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010441a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104421:	0f b6 00             	movzbl (%eax),%eax
c0104424:	3c 64                	cmp    $0x64,%al
c0104426:	0f 85 02 01 00 00    	jne    c010452e <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c010442c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010442f:	8b 00                	mov    (%eax),%eax
c0104431:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c0104434:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c010443b:	75 23                	jne    c0104460 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c010443d:	83 ec 08             	sub    $0x8,%esp
c0104440:	68 5e 48 10 c0       	push   $0xc010485e
c0104445:	ff 75 08             	pushl  0x8(%ebp)
c0104448:	e8 73 fe ff ff       	call   c01042c0 <printp>
c010444d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104450:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104454:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c010445b:	e9 19 01 00 00       	jmp    c0104579 <vfprintf+0x286>
				}
				if(x==0){
c0104460:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104464:	75 1e                	jne    c0104484 <vfprintf+0x191>
					printer('0');
c0104466:	83 ec 0c             	sub    $0xc,%esp
c0104469:	6a 30                	push   $0x30
c010446b:	8b 45 08             	mov    0x8(%ebp),%eax
c010446e:	ff d0                	call   *%eax
c0104470:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104473:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0104477:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c010447e:	90                   	nop
c010447f:	e9 f5 00 00 00       	jmp    c0104579 <vfprintf+0x286>
				}
				if(x<0){
c0104484:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104488:	79 10                	jns    c010449a <vfprintf+0x1a7>
					printer('-');
c010448a:	83 ec 0c             	sub    $0xc,%esp
c010448d:	6a 2d                	push   $0x2d
c010448f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104492:	ff d0                	call   *%eax
c0104494:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0104497:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c010449a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c01044a1:	eb 53                	jmp    c01044f6 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c01044a3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01044a6:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01044ab:	89 c8                	mov    %ecx,%eax
c01044ad:	f7 ea                	imul   %edx
c01044af:	c1 fa 02             	sar    $0x2,%edx
c01044b2:	89 c8                	mov    %ecx,%eax
c01044b4:	c1 f8 1f             	sar    $0x1f,%eax
c01044b7:	29 c2                	sub    %eax,%edx
c01044b9:	89 d0                	mov    %edx,%eax
c01044bb:	c1 e0 02             	shl    $0x2,%eax
c01044be:	01 d0                	add    %edx,%eax
c01044c0:	01 c0                	add    %eax,%eax
c01044c2:	29 c1                	sub    %eax,%ecx
c01044c4:	89 ca                	mov    %ecx,%edx
c01044c6:	89 d0                	mov    %edx,%eax
c01044c8:	83 c0 30             	add    $0x30,%eax
c01044cb:	89 c1                	mov    %eax,%ecx
c01044cd:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c01044d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044d3:	01 d0                	add    %edx,%eax
c01044d5:	88 08                	mov    %cl,(%eax)
					x/=10;
c01044d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01044da:	ba 67 66 66 66       	mov    $0x66666667,%edx
c01044df:	89 c8                	mov    %ecx,%eax
c01044e1:	f7 ea                	imul   %edx
c01044e3:	c1 fa 02             	sar    $0x2,%edx
c01044e6:	89 c8                	mov    %ecx,%eax
c01044e8:	c1 f8 1f             	sar    $0x1f,%eax
c01044eb:	29 c2                	sub    %eax,%edx
c01044ed:	89 d0                	mov    %edx,%eax
c01044ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c01044f2:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c01044f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01044fa:	7f a7                	jg     c01044a3 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c01044fc:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0104500:	eb 1e                	jmp    c0104520 <vfprintf+0x22d>
					printer(digits[di]);
c0104502:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104505:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104508:	01 d0                	add    %edx,%eax
c010450a:	0f b6 00             	movzbl (%eax),%eax
c010450d:	0f be c0             	movsbl %al,%eax
c0104510:	83 ec 0c             	sub    $0xc,%esp
c0104513:	50                   	push   %eax
c0104514:	8b 45 08             	mov    0x8(%ebp),%eax
c0104517:	ff d0                	call   *%eax
c0104519:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c010451c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104520:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104524:	79 dc                	jns    c0104502 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0104526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c010452a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c010452e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104531:	0f b6 00             	movzbl (%eax),%eax
c0104534:	3c 63                	cmp    $0x63,%al
c0104536:	75 1d                	jne    c0104555 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c0104538:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010453b:	0f b6 00             	movzbl (%eax),%eax
c010453e:	0f be c0             	movsbl %al,%eax
c0104541:	83 ec 0c             	sub    $0xc,%esp
c0104544:	50                   	push   %eax
c0104545:	8b 45 08             	mov    0x8(%ebp),%eax
c0104548:	ff d0                	call   *%eax
c010454a:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c010454d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104551:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c0104555:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c010455c:	eb 1b                	jmp    c0104579 <vfprintf+0x286>
		}
		if(type == NONE){
c010455e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104562:	75 15                	jne    c0104579 <vfprintf+0x286>
			printer(cur);
c0104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104567:	0f b6 00             	movzbl (%eax),%eax
c010456a:	0f be c0             	movsbl %al,%eax
c010456d:	83 ec 0c             	sub    $0xc,%esp
c0104570:	50                   	push   %eax
c0104571:	8b 45 08             	mov    0x8(%ebp),%eax
c0104574:	ff d0                	call   *%eax
c0104576:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c0104579:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010457d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104580:	0f b6 00             	movzbl (%eax),%eax
c0104583:	84 c0                	test   %al,%al
c0104585:	0f 85 8d fd ff ff    	jne    c0104318 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c010458b:	c9                   	leave  
c010458c:	c3                   	ret    

c010458d <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c010458d:	55                   	push   %ebp
c010458e:	89 e5                	mov    %esp,%ebp
c0104590:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c0104593:	8d 45 0c             	lea    0xc(%ebp),%eax
c0104596:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0104599:	8b 45 08             	mov    0x8(%ebp),%eax
c010459c:	83 ec 04             	sub    $0x4,%esp
c010459f:	ff 75 f4             	pushl  -0xc(%ebp)
c01045a2:	50                   	push   %eax
c01045a3:	68 a0 42 10 c0       	push   $0xc01042a0
c01045a8:	e8 46 fd ff ff       	call   c01042f3 <vfprintf>
c01045ad:	83 c4 10             	add    $0x10,%esp
}
c01045b0:	c9                   	leave  
c01045b1:	c3                   	ret    
