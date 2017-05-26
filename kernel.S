
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
c01000ba:	e8 b0 2f 00 00       	call   c010306f <vfprintf>
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
c01000f0:	68 30 33 10 c0       	push   $0xc0103330
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
c0100371:	68 53 33 10 c0       	push   $0xc0103353
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
c0100415:	68 53 33 10 c0       	push   $0xc0103353
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
c0100448:	b8 ce 2f 10 c0       	mov    $0xc0102fce,%eax
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
c0100583:	e8 e7 2a 00 00       	call   c010306f <vfprintf>
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
c01005d6:	68 6c 33 10 c0       	push   $0xc010336c
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
c010060c:	68 90 33 10 c0       	push   $0xc0103390
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
c010064e:	68 b4 33 10 c0       	push   $0xc01033b4
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
c0100682:	68 d3 33 10 c0       	push   $0xc01033d3
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
c010074d:	68 e9 33 10 c0       	push   $0xc01033e9
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
c01007ae:	68 e9 33 10 c0       	push   $0xc01033e9
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
c010089a:	68 04 34 10 c0       	push   $0xc0103404
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
c010097f:	68 e9 33 10 c0       	push   $0xc01033e9
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
c01009fb:	68 e9 33 10 c0       	push   $0xc01033e9
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
c0100b9d:	68 e9 33 10 c0       	push   $0xc01033e9
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
c0100c27:	68 e9 33 10 c0       	push   $0xc01033e9
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
c0100cd9:	68 e9 33 10 c0       	push   $0xc01033e9
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
c0100e4f:	68 e9 33 10 c0       	push   $0xc01033e9
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
c0100f53:	e8 43 14 00 00       	call   c010239b <ll_pop>
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
c0100f71:	e8 87 14 00 00       	call   c01023fd <ll_entail>
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
c0100fb1:	e8 e5 13 00 00       	call   c010239b <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 50 15 c0       	push   $0xc01550b0
c0100fc7:	e8 31 14 00 00       	call   c01023fd <ll_entail>
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
c0101010:	e8 e8 13 00 00       	call   c01023fd <ll_entail>
c0101015:	83 c4 10             	add    $0x10,%esp
		current = NULL;
c0101018:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
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
c0101090:	05 00 47 1b c0       	add    $0xc01b4700,%eax
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
c01010b1:	a1 04 50 15 c0       	mov    0xc0155004,%eax
c01010b6:	83 c0 01             	add    $0x1,%eax
c01010b9:	a3 04 50 15 c0       	mov    %eax,0xc0155004

	if(current == NULL){
c01010be:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010c3:	85 c0                	test   %eax,%eax
c01010c5:	75 49                	jne    c0101110 <do_scheduler+0x65>

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);
c01010c7:	83 ec 0c             	sub    $0xc,%esp
c01010ca:	68 b0 50 15 c0       	push   $0xc01550b0
c01010cf:	e8 c7 12 00 00       	call   c010239b <ll_pop>
c01010d4:	83 c4 10             	add    $0x10,%esp
c01010d7:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac

		current->ts = RUNNING;
c01010dc:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010e1:	c7 80 4c 20 00 00 01 	movl   $0x1,0x204c(%eax)
c01010e8:	00 00 00 
		current->timeslice = 0;
c01010eb:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010f0:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01010f7:	00 00 00 

		scheduler_switch(current);
c01010fa:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01010ff:	83 ec 0c             	sub    $0xc,%esp
c0101102:	50                   	push   %eax
c0101103:	e8 ed f2 ff ff       	call   c01003f5 <scheduler_switch>
c0101108:	83 c4 10             	add    $0x10,%esp
		return;
c010110b:	e9 8c 00 00 00       	jmp    c010119c <do_scheduler+0xf1>
	}
	if(current->ts == SLEEPING){
c0101110:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101115:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c010111b:	83 f8 03             	cmp    $0x3,%eax
c010111e:	75 27                	jne    c0101147 <do_scheduler+0x9c>

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);
c0101120:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0101125:	83 ec 08             	sub    $0x8,%esp
c0101128:	50                   	push   %eax
c0101129:	68 b4 50 15 c0       	push   $0xc01550b4
c010112e:	e8 ca 12 00 00       	call   c01023fd <ll_entail>
c0101133:	83 c4 10             	add    $0x10,%esp

		current = NULL;
c0101136:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
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
c0101147:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010114c:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0101152:	83 f8 02             	cmp    $0x2,%eax
c0101155:	77 10                	ja     c0101167 <do_scheduler+0xbc>
c0101157:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010115c:	8b 80 4c 20 00 00    	mov    0x204c(%eax),%eax
c0101162:	83 f8 02             	cmp    $0x2,%eax
c0101165:	75 35                	jne    c010119c <do_scheduler+0xf1>

		current->ts = READY;
c0101167:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010116c:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0101173:	00 00 00 

		ll_entail(&ready_list, current);
c0101176:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010117b:	83 ec 08             	sub    $0x8,%esp
c010117e:	50                   	push   %eax
c010117f:	68 b0 50 15 c0       	push   $0xc01550b0
c0101184:	e8 74 12 00 00       	call   c01023fd <ll_entail>
c0101189:	83 c4 10             	add    $0x10,%esp
		

		current = NULL;
c010118c:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
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
c01011a4:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
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
c01011d0:	e8 d0 0c 00 00       	call   c0101ea5 <do_syscall>
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
c01011e5:	e8 5c 1c 00 00       	call   c0102e46 <do_timer>
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
c010126f:	e8 57 0b 00 00       	call   c0101dcb <press_key>
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
c01012a1:	66 a3 08 50 15 c0    	mov    %ax,0xc0155008
	data[1] = (uint32_t)addr;
c01012a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01012aa:	66 a3 0a 50 15 c0    	mov    %ax,0xc015500a
	data[2] = ((uint32_t)addr) >> 16;
c01012b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b3:	c1 e8 10             	shr    $0x10,%eax
c01012b6:	66 a3 0c 50 15 c0    	mov    %ax,0xc015500c
	asm volatile("lidt (%0)" : : "r"(data));
c01012bc:	b8 08 50 15 c0       	mov    $0xc0155008,%eax
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
c01013d2:	ba ac 2f 10 c0       	mov    $0xc0102fac,%edx
c01013d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01013da:	c1 e0 03             	shl    $0x3,%eax
c01013dd:	05 40 79 1b c0       	add    $0xc01b7940,%eax
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
c01013fd:	b8 f4 2e 10 c0       	mov    $0xc0102ef4,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 40 79 1b c0       	push   $0xc01b7940
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 fd 2e 10 c0       	mov    $0xc0102efd,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 48 79 1b c0       	push   $0xc01b7948
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 06 2f 10 c0       	mov    $0xc0102f06,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 50 79 1b c0       	push   $0xc01b7950
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 0f 2f 10 c0       	mov    $0xc0102f0f,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 58 79 1b c0       	push   $0xc01b7958
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 18 2f 10 c0       	mov    $0xc0102f18,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 60 79 1b c0       	push   $0xc01b7960
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 21 2f 10 c0       	mov    $0xc0102f21,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 68 79 1b c0       	push   $0xc01b7968
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 2a 2f 10 c0       	mov    $0xc0102f2a,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 70 79 1b c0       	push   $0xc01b7970
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 33 2f 10 c0       	mov    $0xc0102f33,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 78 79 1b c0       	push   $0xc01b7978
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 3c 2f 10 c0       	mov    $0xc0102f3c,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 80 79 1b c0       	push   $0xc01b7980
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 45 2f 10 c0       	mov    $0xc0102f45,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 88 79 1b c0       	push   $0xc01b7988
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 4e 2f 10 c0       	mov    $0xc0102f4e,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 90 79 1b c0       	push   $0xc01b7990
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 57 2f 10 c0       	mov    $0xc0102f57,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 98 79 1b c0       	push   $0xc01b7998
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 60 2f 10 c0       	mov    $0xc0102f60,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 a0 79 1b c0       	push   $0xc01b79a0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 69 2f 10 c0       	mov    $0xc0102f69,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 a8 79 1b c0       	push   $0xc01b79a8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 7b 2f 10 c0       	mov    $0xc0102f7b,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 40 7d 1b c0       	push   $0xc01b7d40
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 88 2f 10 c0       	mov    $0xc0102f88,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 40 7a 1b c0       	push   $0xc01b7a40
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 94 2f 10 c0       	mov    $0xc0102f94,%eax
c0101572:	6a 00                	push   $0x0
c0101574:	50                   	push   %eax
c0101575:	6a 01                	push   $0x1
c0101577:	68 48 7a 1b c0       	push   $0xc01b7a48
c010157c:	e8 45 fd ff ff       	call   c01012c6 <set_intr>
c0101581:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
c0101584:	68 00 08 00 00       	push   $0x800
c0101589:	68 40 79 1b c0       	push   $0xc01b7940
c010158e:	e8 05 fd ff ff       	call   c0101298 <save_idt>
c0101593:	83 c4 08             	add    $0x8,%esp
}
c0101596:	c9                   	leave  
c0101597:	c3                   	ret    

c0101598 <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
c0101598:	55                   	push   %ebp
c0101599:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c010159b:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01015a0:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c01015a2:	b8 df 05 00 00       	mov    $0x5df,%eax
c01015a7:	cd 80                	int    $0x80
}
c01015a9:	5d                   	pop    %ebp
c01015aa:	c3                   	ret    

c01015ab <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c01015ab:	55                   	push   %ebp
c01015ac:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c01015ae:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c01015b3:	cd 80                	int    $0x80
}
c01015b5:	5d                   	pop    %ebp
c01015b6:	c3                   	ret    

c01015b7 <sys_fork>:
static inline uint32_t sys_fork(){
c01015b7:	55                   	push   %ebp
c01015b8:	89 e5                	mov    %esp,%ebp
c01015ba:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01015bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c01015c4:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c01015c9:	cd 80                	int    $0x80
c01015cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c01015ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015d1:	c9                   	leave  
c01015d2:	c3                   	ret    

c01015d3 <sys_pid>:
static inline uint32_t sys_pid(){
c01015d3:	55                   	push   %ebp
c01015d4:	89 e5                	mov    %esp,%ebp
c01015d6:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01015d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c01015e0:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c01015e5:	cd 80                	int    $0x80
c01015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c01015ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01015ed:	c9                   	leave  
c01015ee:	c3                   	ret    

c01015ef <sys_ppid>:
static inline uint32_t sys_ppid(){
c01015ef:	55                   	push   %ebp
c01015f0:	89 e5                	mov    %esp,%ebp
c01015f2:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c01015f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c01015fc:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c0101601:	cd 80                	int    $0x80
c0101603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c0101606:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101609:	c9                   	leave  
c010160a:	c3                   	ret    

c010160b <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c010160b:	55                   	push   %ebp
c010160c:	89 e5                	mov    %esp,%ebp
c010160e:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c010160f:	b8 de 05 00 00       	mov    $0x5de,%eax
c0101614:	8b 55 08             	mov    0x8(%ebp),%edx
c0101617:	89 d3                	mov    %edx,%ebx
c0101619:	cd 80                	int    $0x80
}
c010161b:	5b                   	pop    %ebx
c010161c:	5d                   	pop    %ebp
c010161d:	c3                   	ret    

c010161e <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c010161e:	55                   	push   %ebp
c010161f:	89 e5                	mov    %esp,%ebp
c0101621:	83 ec 40             	sub    $0x40,%esp
c0101624:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c010162b:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010162f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101633:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101636:	ee                   	out    %al,(%dx)
c0101637:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c010163e:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c0101642:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101646:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101649:	ee                   	out    %al,(%dx)
c010164a:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c0101651:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c0101655:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101659:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010165c:	ee                   	out    %al,(%dx)
c010165d:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c0101664:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c0101668:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010166c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010166f:	ee                   	out    %al,(%dx)
c0101670:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c0101677:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010167b:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010167f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101682:	ee                   	out    %al,(%dx)
c0101683:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c010168a:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c010168e:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0101692:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101695:	ee                   	out    %al,(%dx)
c0101696:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c010169d:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c01016a1:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c01016a5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01016a8:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c01016a9:	c9                   	leave  
c01016aa:	c3                   	ret    

c01016ab <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c01016ab:	55                   	push   %ebp
c01016ac:	89 e5                	mov    %esp,%ebp
c01016ae:	83 ec 70             	sub    $0x70,%esp
c01016b1:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01016b8:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01016bc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01016c3:	ee                   	out    %al,(%dx)
c01016c4:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01016cb:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01016cf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01016d6:	ee                   	out    %al,(%dx)
c01016d7:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01016de:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01016e2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01016e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01016e9:	ee                   	out    %al,(%dx)
c01016ea:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c01016f1:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c01016f5:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c01016f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01016fc:	ee                   	out    %al,(%dx)
c01016fd:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0101704:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c0101708:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c010170c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010170f:	ee                   	out    %al,(%dx)
c0101710:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c0101717:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010171b:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c010171f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0101722:	ee                   	out    %al,(%dx)
c0101723:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c010172a:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c010172e:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0101732:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101735:	ee                   	out    %al,(%dx)
c0101736:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c010173d:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0101741:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0101745:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101748:	ee                   	out    %al,(%dx)
c0101749:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0101750:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0101754:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c0101758:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010175b:	ee                   	out    %al,(%dx)
c010175c:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0101763:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c0101767:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c010176b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
c010176f:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c0101776:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c010177a:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c010177e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
c0101782:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c0101789:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c010178d:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c0101791:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
c0101795:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c010179c:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c01017a0:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c01017a4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01017a7:	ee                   	out    %al,(%dx)
c01017a8:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c01017af:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01017b3:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01017b7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01017ba:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01017bb:	c9                   	leave  
c01017bc:	c3                   	ret    

c01017bd <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01017bd:	55                   	push   %ebp
c01017be:	89 e5                	mov    %esp,%ebp
c01017c0:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01017c3:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01017ca:	0f b6 05 00 70 10 c0 	movzbl 0xc0107000,%eax
c01017d1:	0f b6 c0             	movzbl %al,%eax
c01017d4:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01017db:	88 45 f7             	mov    %al,-0x9(%ebp)
c01017de:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01017e2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01017e5:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e9:	0f b6 c0             	movzbl %al,%eax
c01017ec:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c01017f3:	88 45 ef             	mov    %al,-0x11(%ebp)
c01017f6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01017fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c01017fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101801:	c1 f8 08             	sar    $0x8,%eax
c0101804:	0f b6 c0             	movzbl %al,%eax
c0101807:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c010180e:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101811:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101815:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
}
c0101819:	c9                   	leave  
c010181a:	c3                   	ret    

c010181b <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010181b:	55                   	push   %ebp
c010181c:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c010181e:	e8 88 fd ff ff       	call   c01015ab <sys_handout>
  }
c0101823:	eb f9                	jmp    c010181e <idle+0x3>

c0101825 <busy>:
}
void busy(){
c0101825:	55                   	push   %ebp
c0101826:	89 e5                	mov    %esp,%ebp
c0101828:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c010182b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c0101832:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c0101839:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101840:	eb 11                	jmp    c0101853 <busy+0x2e>
    if(fork()!=0){
c0101842:	e8 70 fd ff ff       	call   c01015b7 <sys_fork>
c0101847:	85 c0                	test   %eax,%eax
c0101849:	74 04                	je     c010184f <busy+0x2a>
        j++;
c010184b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c010184f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101853:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c0101857:	76 e9                	jbe    c0101842 <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c0101859:	e8 75 fd ff ff       	call   c01015d3 <sys_pid>
c010185e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c0101861:	e8 89 fd ff ff       	call   c01015ef <sys_ppid>
c0101866:	ff 75 f0             	pushl  -0x10(%ebp)
c0101869:	50                   	push   %eax
c010186a:	ff 75 e8             	pushl  -0x18(%ebp)
c010186d:	68 28 34 10 c0       	push   $0xc0103428
c0101872:	e8 92 1a 00 00       	call   c0103309 <printf>
c0101877:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c010187a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c0101881:	e8 25 fd ff ff       	call   c01015ab <sys_handout>
    sleep(pid);
c0101886:	83 ec 0c             	sub    $0xc,%esp
c0101889:	ff 75 e8             	pushl  -0x18(%ebp)
c010188c:	e8 7a fd ff ff       	call   c010160b <sys_sleep>
c0101891:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c0101894:	ff 75 ec             	pushl  -0x14(%ebp)
c0101897:	ff 75 e8             	pushl  -0x18(%ebp)
c010189a:	ff 75 e8             	pushl  -0x18(%ebp)
c010189d:	68 68 34 10 c0       	push   $0xc0103468
c01018a2:	e8 62 1a 00 00       	call   c0103309 <printf>
c01018a7:	83 c4 10             	add    $0x10,%esp
    times++;
c01018aa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c01018ae:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01018b2:	76 15                	jbe    c01018c9 <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c01018b4:	83 ec 0c             	sub    $0xc,%esp
c01018b7:	68 8c 34 10 c0       	push   $0xc010348c
c01018bc:	e8 48 1a 00 00       	call   c0103309 <printf>
c01018c1:	83 c4 10             	add    $0x10,%esp
      exit();
c01018c4:	e8 cf fc ff ff       	call   c0101598 <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c01018c9:	eb b6                	jmp    c0101881 <busy+0x5c>

c01018cb <main>:
}
void do_scheduler();
int main(){
c01018cb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c01018cf:	83 e4 f0             	and    $0xfffffff0,%esp
c01018d2:	ff 71 fc             	pushl  -0x4(%ecx)
c01018d5:	55                   	push   %ebp
c01018d6:	89 e5                	mov    %esp,%ebp
c01018d8:	51                   	push   %ecx
c01018d9:	83 ec 14             	sub    $0x14,%esp
  init_page();
c01018dc:	e8 4a e8 ff ff       	call   c010012b <init_page>
  init_segment();
c01018e1:	e8 f6 e9 ff ff       	call   c01002dc <init_segment>
	init_serial();
c01018e6:	e8 33 fd ff ff       	call   c010161e <init_serial>
	init_timer();
c01018eb:	e8 cd fe ff ff       	call   c01017bd <init_timer>
	init_idt();
c01018f0:	e8 ce fa ff ff       	call   c01013c3 <init_idt>
	init_intr();
c01018f5:	e8 b1 fd ff ff       	call   c01016ab <init_intr>
  init_pcb_pool();
c01018fa:	e8 d9 0b 00 00       	call   c01024d8 <init_pcb_pool>

  PCB* pidle = pcb_create();
c01018ff:	e8 3f 0d 00 00       	call   c0102643 <pcb_create>
c0101904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0101907:	83 ec 08             	sub    $0x8,%esp
c010190a:	68 1b 18 10 c0       	push   $0xc010181b
c010190f:	ff 75 f4             	pushl  -0xc(%ebp)
c0101912:	e8 15 04 00 00       	call   c0101d2c <empty_loader>
c0101917:	83 c4 10             	add    $0x10,%esp

  PCB* pcb = pcb_create();
c010191a:	e8 24 0d 00 00       	call   c0102643 <pcb_create>
c010191f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader(pcb, 102400);
c0101922:	83 ec 08             	sub    $0x8,%esp
c0101925:	68 00 90 01 00       	push   $0x19000
c010192a:	ff 75 f0             	pushl  -0x10(%ebp)
c010192d:	e8 62 02 00 00       	call   c0101b94 <loader>
c0101932:	83 c4 10             	add    $0x10,%esp

  enready_pcb(pidle);
c0101935:	83 ec 0c             	sub    $0xc,%esp
c0101938:	ff 75 f4             	pushl  -0xc(%ebp)
c010193b:	e8 03 0e 00 00       	call   c0102743 <enready_pcb>
c0101940:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c0101943:	83 ec 0c             	sub    $0xc,%esp
c0101946:	ff 75 f0             	pushl  -0x10(%ebp)
c0101949:	e8 f5 0d 00 00       	call   c0102743 <enready_pcb>
c010194e:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c0101951:	e8 ed 0c 00 00       	call   c0102643 <pcb_create>
c0101956:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader(app, 2*102400);
c0101959:	83 ec 08             	sub    $0x8,%esp
c010195c:	68 00 20 03 00       	push   $0x32000
c0101961:	ff 75 ec             	pushl  -0x14(%ebp)
c0101964:	e8 2b 02 00 00       	call   c0101b94 <loader>
c0101969:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c010196c:	83 ec 0c             	sub    $0xc,%esp
c010196f:	ff 75 ec             	pushl  -0x14(%ebp)
c0101972:	e8 cc 0d 00 00       	call   c0102743 <enready_pcb>
c0101977:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c010197a:	e8 2c f7 ff ff       	call   c01010ab <do_scheduler>

  while(1);
c010197f:	eb fe                	jmp    c010197f <main+0xb4>

c0101981 <serial_idle>:

static inline
int serial_idle(void) {
c0101981:	55                   	push   %ebp
c0101982:	89 e5                	mov    %esp,%ebp
c0101984:	83 ec 10             	sub    $0x10,%esp
c0101987:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101991:	89 c2                	mov    %eax,%edx
c0101993:	ec                   	in     (%dx),%al
c0101994:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101997:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c010199b:	0f b6 c0             	movzbl %al,%eax
c010199e:	83 e0 20             	and    $0x20,%eax
c01019a1:	85 c0                	test   %eax,%eax
c01019a3:	0f 95 c0             	setne  %al
c01019a6:	0f b6 c0             	movzbl %al,%eax
}
c01019a9:	c9                   	leave  
c01019aa:	c3                   	ret    

c01019ab <serial_printc>:

static inline
void serial_printc(char ch) {
c01019ab:	55                   	push   %ebp
c01019ac:	89 e5                	mov    %esp,%ebp
c01019ae:	83 ec 14             	sub    $0x14,%esp
c01019b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b4:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01019b7:	90                   	nop
c01019b8:	e8 c4 ff ff ff       	call   c0101981 <serial_idle>
c01019bd:	85 c0                	test   %eax,%eax
c01019bf:	74 f7                	je     c01019b8 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01019c1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01019c5:	0f b6 c0             	movzbl %al,%eax
c01019c8:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01019cf:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01019d2:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01019d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01019d9:	ee                   	out    %al,(%dx)
}
c01019da:	c9                   	leave  
c01019db:	c3                   	ret    

c01019dc <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c01019dc:	55                   	push   %ebp
c01019dd:	89 e5                	mov    %esp,%ebp
c01019df:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01019e2:	8d 45 0c             	lea    0xc(%ebp),%eax
c01019e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01019e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019eb:	83 ec 04             	sub    $0x4,%esp
c01019ee:	ff 75 f4             	pushl  -0xc(%ebp)
c01019f1:	50                   	push   %eax
c01019f2:	68 ab 19 10 c0       	push   $0xc01019ab
c01019f7:	e8 73 16 00 00       	call   c010306f <vfprintf>
c01019fc:	83 c4 10             	add    $0x10,%esp
}
c01019ff:	c9                   	leave  
c0101a00:	c3                   	ret    

c0101a01 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c0101a01:	55                   	push   %ebp
c0101a02:	89 e5                	mov    %esp,%ebp
c0101a04:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0101a07:	90                   	nop
c0101a08:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a12:	89 c2                	mov    %eax,%edx
c0101a14:	ec                   	in     (%dx),%al
c0101a15:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101a18:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101a1c:	0f b6 c0             	movzbl %al,%eax
c0101a1f:	25 c0 00 00 00       	and    $0xc0,%eax
c0101a24:	83 f8 40             	cmp    $0x40,%eax
c0101a27:	75 df                	jne    c0101a08 <waitdisk+0x7>
}
c0101a29:	c9                   	leave  
c0101a2a:	c3                   	ret    

c0101a2b <readsect>:

static inline void
readsect(void *dst, int offset) {
c0101a2b:	55                   	push   %ebp
c0101a2c:	89 e5                	mov    %esp,%ebp
c0101a2e:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c0101a31:	e8 cb ff ff ff       	call   c0101a01 <waitdisk>
c0101a36:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0101a3d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101a41:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0101a45:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0101a48:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0101a49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a4c:	0f b6 c0             	movzbl %al,%eax
c0101a4f:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c0101a56:	88 45 ef             	mov    %al,-0x11(%ebp)
c0101a59:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101a5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101a60:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101a61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a64:	c1 f8 08             	sar    $0x8,%eax
c0101a67:	0f b6 c0             	movzbl %al,%eax
c0101a6a:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101a71:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101a74:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101a78:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101a7b:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a7f:	c1 f8 10             	sar    $0x10,%eax
c0101a82:	0f b6 c0             	movzbl %al,%eax
c0101a85:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101a8c:	88 45 df             	mov    %al,-0x21(%ebp)
c0101a8f:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101a93:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101a96:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101a97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101a9a:	c1 f8 18             	sar    $0x18,%eax
c0101a9d:	83 c8 e0             	or     $0xffffffe0,%eax
c0101aa0:	0f b6 c0             	movzbl %al,%eax
c0101aa3:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c0101aaa:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101aad:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101ab1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101ab4:	ee                   	out    %al,(%dx)
c0101ab5:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101abc:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101ac0:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101ac4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ac7:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c0101ac8:	e8 34 ff ff ff       	call   c0101a01 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101acd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101ad4:	eb 29                	jmp    c0101aff <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c0101ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ad9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c0101ae6:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101aed:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101af0:	89 c2                	mov    %eax,%edx
c0101af2:	ed                   	in     (%dx),%eax
c0101af3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c0101af6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101af9:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101afb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101aff:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101b03:	7e d1                	jle    c0101ad6 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c0101b05:	c9                   	leave  
c0101b06:	c3                   	ret    

c0101b07 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0101b07:	55                   	push   %ebp
c0101b08:	89 e5                	mov    %esp,%ebp
c0101b0a:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0101b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	01 d0                	add    %edx,%eax
c0101b15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0101b18:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b1b:	99                   	cltd   
c0101b1c:	c1 ea 17             	shr    $0x17,%edx
c0101b1f:	01 d0                	add    %edx,%eax
c0101b21:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101b26:	29 d0                	sub    %edx,%eax
c0101b28:	f7 d8                	neg    %eax
c0101b2a:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0101b2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b30:	99                   	cltd   
c0101b31:	c1 ea 17             	shr    $0x17,%edx
c0101b34:	01 d0                	add    %edx,%eax
c0101b36:	c1 f8 09             	sar    $0x9,%eax
c0101b39:	83 c0 01             	add    $0x1,%eax
c0101b3c:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101b3f:	eb 19                	jmp    c0101b5a <readseg+0x53>
        readsect(pa, offset);
c0101b41:	ff 75 10             	pushl  0x10(%ebp)
c0101b44:	ff 75 08             	pushl  0x8(%ebp)
c0101b47:	e8 df fe ff ff       	call   c0101a2b <readsect>
c0101b4c:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0101b4f:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c0101b56:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0101b60:	72 df                	jb     c0101b41 <readseg+0x3a>
        readsect(pa, offset);
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0101b6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b6d:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c0101b72:	77 16                	ja     c0101b8a <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c0101b74:	ff 75 10             	pushl  0x10(%ebp)
c0101b77:	68 ac 34 10 c0       	push   $0xc01034ac
c0101b7c:	ff 75 0c             	pushl  0xc(%ebp)
c0101b7f:	ff 75 08             	pushl  0x8(%ebp)
c0101b82:	e8 55 fe ff ff       	call   c01019dc <printk>
c0101b87:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c0101b8a:	8b 45 10             	mov    0x10(%ebp),%eax
c0101b8d:	05 00 00 00 40       	add    $0x40000000,%eax
}
c0101b92:	c9                   	leave  
c0101b93:	c3                   	ret    

c0101b94 <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)


uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c0101b94:	55                   	push   %ebp
c0101b95:	89 e5                	mov    %esp,%ebp
c0101b97:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0101b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101ba3:	83 ec 04             	sub    $0x4,%esp
c0101ba6:	50                   	push   %eax
c0101ba7:	6a 17                	push   $0x17
c0101ba9:	68 cf 34 10 c0       	push   $0xc01034cf
c0101bae:	e8 b1 ff ff ff       	call   c0101b64 <_paddr>
c0101bb3:	83 c4 10             	add    $0x10,%esp
c0101bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c0101bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101bbc:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc2:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101bc8:	83 ec 04             	sub    $0x4,%esp
c0101bcb:	68 00 10 00 00       	push   $0x1000
c0101bd0:	6a 00                	push   $0x0
c0101bd2:	50                   	push   %eax
c0101bd3:	e8 b9 ea ff ff       	call   c0100691 <mm_alloc>
c0101bd8:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0101bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bde:	83 ec 04             	sub    $0x4,%esp
c0101be1:	50                   	push   %eax
c0101be2:	68 00 10 00 00       	push   $0x1000
c0101be7:	6a 00                	push   $0x0
c0101be9:	e8 19 ff ff ff       	call   c0101b07 <readseg>
c0101bee:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0101bf1:	b8 00 00 00 00       	mov    $0x0,%eax
c0101bf6:	8b 00                	mov    (%eax),%eax
c0101bf8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0101bfd:	0f 94 c0             	sete   %al
c0101c00:	0f b6 c0             	movzbl %al,%eax
c0101c03:	83 ec 08             	sub    $0x8,%esp
c0101c06:	50                   	push   %eax
c0101c07:	68 e3 34 10 c0       	push   $0xc01034e3
c0101c0c:	e8 cb fd ff ff       	call   c01019dc <printk>
c0101c11:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0101c14:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c19:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0101c1f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101c28:	0f b7 c0             	movzwl %ax,%eax
c0101c2b:	c1 e0 05             	shl    $0x5,%eax
c0101c2e:	89 c2                	mov    %eax,%edx
c0101c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c33:	01 d0                	add    %edx,%eax
c0101c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101c38:	eb 7f                	jmp    c0101cb9 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0101c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c3d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c40:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0101c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c46:	8b 48 14             	mov    0x14(%eax),%ecx
c0101c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c4c:	8b 50 08             	mov    0x8(%eax),%edx
c0101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c52:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101c58:	83 ec 04             	sub    $0x4,%esp
c0101c5b:	51                   	push   %ecx
c0101c5c:	52                   	push   %edx
c0101c5d:	50                   	push   %eax
c0101c5e:	e8 2e ea ff ff       	call   c0100691 <mm_alloc>
c0101c63:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c0101c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c69:	8b 50 04             	mov    0x4(%eax),%edx
c0101c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c6f:	01 d0                	add    %edx,%eax
c0101c71:	89 c2                	mov    %eax,%edx
c0101c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c76:	8b 40 10             	mov    0x10(%eax),%eax
c0101c79:	83 ec 04             	sub    $0x4,%esp
c0101c7c:	52                   	push   %edx
c0101c7d:	50                   	push   %eax
c0101c7e:	ff 75 e8             	pushl  -0x18(%ebp)
c0101c81:	e8 81 fe ff ff       	call   c0101b07 <readseg>
c0101c86:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0101c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c8c:	8b 50 10             	mov    0x10(%eax),%edx
c0101c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101c92:	01 d0                	add    %edx,%eax
c0101c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101c97:	eb 0c                	jmp    c0101ca5 <loader+0x111>
c0101c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c9c:	8d 50 01             	lea    0x1(%eax),%edx
c0101c9f:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0101ca2:	c6 00 00             	movb   $0x0,(%eax)
c0101ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ca8:	8b 50 14             	mov    0x14(%eax),%edx
c0101cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0101cae:	01 d0                	add    %edx,%eax
c0101cb0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0101cb3:	77 e4                	ja     c0101c99 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0101cb5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0101cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cbc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0101cbf:	0f 82 75 ff ff ff    	jb     c0101c3a <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c0101cc5:	b8 00 00 00 00       	mov    $0x0,%eax
c0101cca:	8b 40 18             	mov    0x18(%eax),%eax
c0101ccd:	a3 e8 2f 10 c0       	mov    %eax,0xc0102fe8

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd5:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101cdb:	83 ec 04             	sub    $0x4,%esp
c0101cde:	68 00 80 00 00       	push   $0x8000
c0101ce3:	68 00 60 bf be       	push   $0xbebf6000
c0101ce8:	50                   	push   %eax
c0101ce9:	e8 a3 e9 ff ff       	call   c0100691 <mm_alloc>
c0101cee:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0101cf1:	a1 e8 2f 10 c0       	mov    0xc0102fe8,%eax
c0101cf6:	6a 03                	push   $0x3
c0101cf8:	50                   	push   %eax
c0101cf9:	68 80 df bf be       	push   $0xbebfdf80
c0101cfe:	ff 75 08             	pushl  0x8(%ebp)
c0101d01:	e8 09 08 00 00       	call   c010250f <init_pcb>
c0101d06:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0101d09:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101d0e:	83 ec 04             	sub    $0x4,%esp
c0101d11:	50                   	push   %eax
c0101d12:	6a 39                	push   $0x39
c0101d14:	68 cf 34 10 c0       	push   $0xc01034cf
c0101d19:	e8 46 fe ff ff       	call   c0101b64 <_paddr>
c0101d1e:	83 c4 10             	add    $0x10,%esp
c0101d21:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101d27:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0101d2a:	c9                   	leave  
c0101d2b:	c3                   	ret    

c0101d2c <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0101d2c:	55                   	push   %ebp
c0101d2d:	89 e5                	mov    %esp,%ebp
c0101d2f:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0101d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d35:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0101d3b:	83 ec 04             	sub    $0x4,%esp
c0101d3e:	50                   	push   %eax
c0101d3f:	6a 42                	push   $0x42
c0101d41:	68 cf 34 10 c0       	push   $0xc01034cf
c0101d46:	e8 19 fe ff ff       	call   c0101b64 <_paddr>
c0101d4b:	83 c4 10             	add    $0x10,%esp
c0101d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d54:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0101d57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d5a:	a3 e8 2f 10 c0       	mov    %eax,0xc0102fe8
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c0101d5f:	a1 e8 2f 10 c0       	mov    0xc0102fe8,%eax
c0101d64:	8b 55 08             	mov    0x8(%ebp),%edx
c0101d67:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0101d6d:	83 c2 80             	add    $0xffffff80,%edx
c0101d70:	6a 00                	push   $0x0
c0101d72:	50                   	push   %eax
c0101d73:	52                   	push   %edx
c0101d74:	ff 75 08             	pushl  0x8(%ebp)
c0101d77:	e8 93 07 00 00       	call   c010250f <init_pcb>
c0101d7c:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0101d7f:	a1 c0 46 17 c0       	mov    0xc01746c0,%eax
c0101d84:	83 ec 04             	sub    $0x4,%esp
c0101d87:	50                   	push   %eax
c0101d88:	6a 46                	push   $0x46
c0101d8a:	68 cf 34 10 c0       	push   $0xc01034cf
c0101d8f:	e8 d0 fd ff ff       	call   c0101b64 <_paddr>
c0101d94:	83 c4 10             	add    $0x10,%esp
c0101d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d9d:	0f 22 d8             	mov    %eax,%cr3

c0101da0:	c9                   	leave  
c0101da1:	c3                   	ret    

c0101da2 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0101da2:	55                   	push   %ebp
c0101da3:	89 e5                	mov    %esp,%ebp
c0101da5:	83 ec 04             	sub    $0x4,%esp
c0101da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0101dae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0101db2:	83 e8 61             	sub    $0x61,%eax
c0101db5:	8b 04 85 40 50 15 c0 	mov    -0x3feaafc0(,%eax,4),%eax
}
c0101dbc:	c9                   	leave  
c0101dbd:	c3                   	ret    

c0101dbe <get_lastkey>:
int8_t get_lastkey(){
c0101dbe:	55                   	push   %ebp
c0101dbf:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0101dc1:	a1 a8 50 15 c0       	mov    0xc01550a8,%eax
c0101dc6:	83 c0 61             	add    $0x61,%eax
}
c0101dc9:	5d                   	pop    %ebp
c0101dca:	c3                   	ret    

c0101dcb <press_key>:
void press_key(int code){
c0101dcb:	55                   	push   %ebp
c0101dcc:	89 e5                	mov    %esp,%ebp
c0101dce:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0101dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0101dd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ddb:	25 80 00 00 00       	and    $0x80,%eax
c0101de0:	85 c0                	test   %eax,%eax
c0101de2:	75 35                	jne    c0101e19 <press_key+0x4e>
		for(;i<26;i++){
c0101de4:	eb 2b                	jmp    c0101e11 <press_key+0x46>
			if(letter[i]==code){
c0101de6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101de9:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101df0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101df3:	75 18                	jne    c0101e0d <press_key+0x42>
				keydown[i] = 1;
c0101df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101df8:	c7 04 85 40 50 15 c0 	movl   $0x1,-0x3feaafc0(,%eax,4)
c0101dff:	01 00 00 00 
				lastkey = i;
c0101e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e06:	a3 a8 50 15 c0       	mov    %eax,0xc01550a8
				return;
c0101e0b:	eb 3b                	jmp    c0101e48 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0101e0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101e11:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101e15:	7e cf                	jle    c0101de6 <press_key+0x1b>
c0101e17:	eb 2f                	jmp    c0101e48 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0101e19:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0101e1d:	eb 23                	jmp    c0101e42 <press_key+0x77>
			if(letter[i]==code){
c0101e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e22:	8b 04 85 40 70 10 c0 	mov    -0x3fef8fc0(,%eax,4),%eax
c0101e29:	3b 45 08             	cmp    0x8(%ebp),%eax
c0101e2c:	75 10                	jne    c0101e3e <press_key+0x73>
				keydown[i] = 0;
c0101e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e31:	c7 04 85 40 50 15 c0 	movl   $0x0,-0x3feaafc0(,%eax,4)
c0101e38:	00 00 00 00 
				return;
c0101e3c:	eb 0a                	jmp    c0101e48 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0101e3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101e42:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0101e46:	7e d7                	jle    c0101e1f <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0101e48:	c9                   	leave  
c0101e49:	c3                   	ret    

c0101e4a <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0101e4a:	55                   	push   %ebp
c0101e4b:	89 e5                	mov    %esp,%ebp
c0101e4d:	83 ec 10             	sub    $0x10,%esp
c0101e50:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0101e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e5a:	89 c2                	mov    %eax,%edx
c0101e5c:	ec                   	in     (%dx),%al
c0101e5d:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0101e60:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0101e64:	0f b6 c0             	movzbl %al,%eax
c0101e67:	83 e0 20             	and    $0x20,%eax
c0101e6a:	85 c0                	test   %eax,%eax
c0101e6c:	0f 95 c0             	setne  %al
c0101e6f:	0f b6 c0             	movzbl %al,%eax
}
c0101e72:	c9                   	leave  
c0101e73:	c3                   	ret    

c0101e74 <serial_printc>:

static inline
void serial_printc(char ch) {
c0101e74:	55                   	push   %ebp
c0101e75:	89 e5                	mov    %esp,%ebp
c0101e77:	83 ec 14             	sub    $0x14,%esp
c0101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7d:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0101e80:	90                   	nop
c0101e81:	e8 c4 ff ff ff       	call   c0101e4a <serial_idle>
c0101e86:	85 c0                	test   %eax,%eax
c0101e88:	74 f7                	je     c0101e81 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0101e8a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0101e8e:	0f b6 c0             	movzbl %al,%eax
c0101e91:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0101e98:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0101e9b:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0101e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0101ea2:	ee                   	out    %al,(%dx)
}
c0101ea3:	c9                   	leave  
c0101ea4:	c3                   	ret    

c0101ea5 <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0101ea5:	55                   	push   %ebp
c0101ea6:	89 e5                	mov    %esp,%ebp
c0101ea8:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0101eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eae:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101eb1:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101eb6:	0f 84 a6 02 00 00    	je     c0102162 <do_syscall+0x2bd>
c0101ebc:	3d df 05 00 00       	cmp    $0x5df,%eax
c0101ec1:	0f 87 97 00 00 00    	ja     c0101f5e <do_syscall+0xb9>
c0101ec7:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101ecc:	0f 84 d5 02 00 00    	je     c01021a7 <do_syscall+0x302>
c0101ed2:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0101ed7:	77 3d                	ja     c0101f16 <do_syscall+0x71>
c0101ed9:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101ede:	0f 84 a9 02 00 00    	je     c010218d <do_syscall+0x2e8>
c0101ee4:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0101ee9:	77 10                	ja     c0101efb <do_syscall+0x56>
c0101eeb:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0101ef0:	0f 84 80 02 00 00    	je     c0102176 <do_syscall+0x2d1>
c0101ef6:	e9 01 03 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101efb:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0101f00:	0f 84 8e 02 00 00    	je     c0102194 <do_syscall+0x2ef>
c0101f06:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0101f0b:	0f 84 8a 02 00 00    	je     c010219b <do_syscall+0x2f6>
c0101f11:	e9 e6 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101f16:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101f1b:	0f 84 2d 02 00 00    	je     c010214e <do_syscall+0x2a9>
c0101f21:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0101f26:	77 1b                	ja     c0101f43 <do_syscall+0x9e>
c0101f28:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0101f2d:	0f 84 9b 02 00 00    	je     c01021ce <do_syscall+0x329>
c0101f33:	3d 15 05 00 00       	cmp    $0x515,%eax
c0101f38:	0f 84 b0 02 00 00    	je     c01021ee <do_syscall+0x349>
c0101f3e:	e9 b9 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101f43:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0101f48:	0f 84 a9 01 00 00    	je     c01020f7 <do_syscall+0x252>
c0101f4e:	3d de 05 00 00       	cmp    $0x5de,%eax
c0101f53:	0f 84 ca 01 00 00    	je     c0102123 <do_syscall+0x27e>
c0101f59:	e9 9e 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101f5e:	3d 41 06 00 00       	cmp    $0x641,%eax
c0101f63:	0f 84 a7 00 00 00    	je     c0102010 <do_syscall+0x16b>
c0101f69:	3d 41 06 00 00       	cmp    $0x641,%eax
c0101f6e:	77 44                	ja     c0101fb4 <do_syscall+0x10f>
c0101f70:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0101f75:	0f 84 65 01 00 00    	je     c01020e0 <do_syscall+0x23b>
c0101f7b:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0101f80:	77 1b                	ja     c0101f9d <do_syscall+0xf8>
c0101f82:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c0101f87:	0f 84 df 01 00 00    	je     c010216c <do_syscall+0x2c7>
c0101f8d:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0101f92:	0f 84 75 01 00 00    	je     c010210d <do_syscall+0x268>
c0101f98:	e9 5f 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101f9d:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0101fa2:	0f 84 13 01 00 00    	je     c01020bb <do_syscall+0x216>
c0101fa8:	3d 40 06 00 00       	cmp    $0x640,%eax
c0101fad:	74 41                	je     c0101ff0 <do_syscall+0x14b>
c0101faf:	e9 48 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101fb4:	3d 44 06 00 00       	cmp    $0x644,%eax
c0101fb9:	0f 84 c6 00 00 00    	je     c0102085 <do_syscall+0x1e0>
c0101fbf:	3d 44 06 00 00       	cmp    $0x644,%eax
c0101fc4:	77 13                	ja     c0101fd9 <do_syscall+0x134>
c0101fc6:	3d 42 06 00 00       	cmp    $0x642,%eax
c0101fcb:	74 6b                	je     c0102038 <do_syscall+0x193>
c0101fcd:	3d 43 06 00 00       	cmp    $0x643,%eax
c0101fd2:	74 7b                	je     c010204f <do_syscall+0x1aa>
c0101fd4:	e9 23 02 00 00       	jmp    c01021fc <do_syscall+0x357>
c0101fd9:	3d 45 06 00 00       	cmp    $0x645,%eax
c0101fde:	0f 84 b8 00 00 00    	je     c010209c <do_syscall+0x1f7>
c0101fe4:	3d 46 06 00 00       	cmp    $0x646,%eax
c0101fe9:	74 7b                	je     c0102066 <do_syscall+0x1c1>
c0101feb:	e9 0c 02 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0101ff0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff3:	8b 40 18             	mov    0x18(%eax),%eax
c0101ff6:	89 c2                	mov    %eax,%edx
c0101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ffb:	8b 40 10             	mov    0x10(%eax),%eax
c0101ffe:	83 ec 08             	sub    $0x8,%esp
c0102001:	52                   	push   %edx
c0102002:	50                   	push   %eax
c0102003:	e8 09 ef ff ff       	call   c0100f11 <sem_init_kr>
c0102008:	83 c4 10             	add    $0x10,%esp
		break;
c010200b:	e9 ec 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0102010:	8b 45 08             	mov    0x8(%ebp),%eax
c0102013:	8b 40 18             	mov    0x18(%eax),%eax
c0102016:	89 c2                	mov    %eax,%edx
c0102018:	8b 45 08             	mov    0x8(%ebp),%eax
c010201b:	8b 40 10             	mov    0x10(%eax),%eax
c010201e:	83 ec 08             	sub    $0x8,%esp
c0102021:	52                   	push   %edx
c0102022:	50                   	push   %eax
c0102023:	e8 56 f0 ff ff       	call   c010107e <sem_open_kr>
c0102028:	83 c4 10             	add    $0x10,%esp
c010202b:	89 c2                	mov    %eax,%edx
c010202d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102030:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102033:	e9 c4 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0102038:	8b 45 08             	mov    0x8(%ebp),%eax
c010203b:	8b 40 10             	mov    0x10(%eax),%eax
c010203e:	83 ec 0c             	sub    $0xc,%esp
c0102041:	50                   	push   %eax
c0102042:	e8 36 ef ff ff       	call   c0100f7d <sem_post_kr>
c0102047:	83 c4 10             	add    $0x10,%esp
		break;
c010204a:	e9 ad 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c010204f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102052:	8b 40 10             	mov    0x10(%eax),%eax
c0102055:	83 ec 0c             	sub    $0xc,%esp
c0102058:	50                   	push   %eax
c0102059:	e8 73 ef ff ff       	call   c0100fd1 <sem_wait_kr>
c010205e:	83 c4 10             	add    $0x10,%esp
		break;
c0102061:	e9 96 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c0102066:	8b 45 08             	mov    0x8(%ebp),%eax
c0102069:	8b 40 10             	mov    0x10(%eax),%eax
c010206c:	83 ec 0c             	sub    $0xc,%esp
c010206f:	50                   	push   %eax
c0102070:	e8 b4 ef ff ff       	call   c0101029 <sem_trywait_kr>
c0102075:	83 c4 10             	add    $0x10,%esp
c0102078:	89 c2                	mov    %eax,%edx
c010207a:	8b 45 08             	mov    0x8(%ebp),%eax
c010207d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102080:	e9 77 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0102085:	8b 45 08             	mov    0x8(%ebp),%eax
c0102088:	8b 40 10             	mov    0x10(%eax),%eax
c010208b:	83 ec 0c             	sub    $0xc,%esp
c010208e:	50                   	push   %eax
c010208f:	e8 9d ee ff ff       	call   c0100f31 <sem_close_kr>
c0102094:	83 c4 10             	add    $0x10,%esp
		break;
c0102097:	e9 60 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c010209c:	8b 45 08             	mov    0x8(%ebp),%eax
c010209f:	8b 40 10             	mov    0x10(%eax),%eax
c01020a2:	83 ec 0c             	sub    $0xc,%esp
c01020a5:	50                   	push   %eax
c01020a6:	e8 b8 ef ff ff       	call   c0101063 <sem_get_kr>
c01020ab:	83 c4 10             	add    $0x10,%esp
c01020ae:	89 c2                	mov    %eax,%edx
c01020b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b3:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01020b6:	e9 41 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c01020bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01020be:	8b 48 14             	mov    0x14(%eax),%ecx
c01020c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c4:	8b 50 18             	mov    0x18(%eax),%edx
c01020c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ca:	8b 40 10             	mov    0x10(%eax),%eax
c01020cd:	83 ec 04             	sub    $0x4,%esp
c01020d0:	51                   	push   %ecx
c01020d1:	52                   	push   %edx
c01020d2:	50                   	push   %eax
c01020d3:	e8 ec 08 00 00       	call   c01029c4 <thread_current>
c01020d8:	83 c4 10             	add    $0x10,%esp
		break;
c01020db:	e9 1c 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_JOIN:
			join_current(tf->ebx);
c01020e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e3:	8b 40 10             	mov    0x10(%eax),%eax
c01020e6:	83 ec 0c             	sub    $0xc,%esp
c01020e9:	50                   	push   %eax
c01020ea:	e8 b3 0a 00 00       	call   c0102ba2 <join_current>
c01020ef:	83 c4 10             	add    $0x10,%esp
		break;
c01020f2:	e9 05 01 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_PID:
			tf->eax = current->pid;
c01020f7:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01020fc:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102102:	8b 45 08             	mov    0x8(%ebp),%eax
c0102105:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102108:	e9 ef 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_PPID:
			tf->eax = current->ppid;
c010210d:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102112:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c0102118:	8b 45 08             	mov    0x8(%ebp),%eax
c010211b:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010211e:	e9 d9 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0102123:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102128:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c010212f:	00 00 00 
			current->timeslice = tf->ebx*200;
c0102132:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102137:	8b 55 08             	mov    0x8(%ebp),%edx
c010213a:	8b 52 10             	mov    0x10(%edx),%edx
c010213d:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0102143:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c0102149:	e9 ae 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_HANDOUT:
			current->ts = STOP;
c010214e:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102153:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c010215a:	00 00 00 
		break;
c010215d:	e9 9a 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_EXIT:
			exit_current();
c0102162:	e8 ce 09 00 00       	call   c0102b35 <exit_current>
		break;
c0102167:	e9 90 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_FORK:
			fork_current();
c010216c:	e8 e1 07 00 00       	call   c0102952 <fork_current>
		break;
c0102171:	e9 86 00 00 00       	jmp    c01021fc <do_syscall+0x357>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0102176:	8b 45 08             	mov    0x8(%ebp),%eax
c0102179:	8b 40 10             	mov    0x10(%eax),%eax
c010217c:	0f be c0             	movsbl %al,%eax
c010217f:	83 ec 0c             	sub    $0xc,%esp
c0102182:	50                   	push   %eax
c0102183:	e8 ec fc ff ff       	call   c0101e74 <serial_printc>
c0102188:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c010218b:	eb 6f                	jmp    c01021fc <do_syscall+0x357>
		case SYS_INIT_CACHE:
			initVCache();
c010218d:	e8 d7 0a 00 00       	call   c0102c69 <initVCache>
		break;
c0102192:	eb 68                	jmp    c01021fc <do_syscall+0x357>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0102194:	e8 05 0c 00 00       	call   c0102d9e <clearVRAM>
		break;
c0102199:	eb 61                	jmp    c01021fc <do_syscall+0x357>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c010219b:	e8 fe 0b 00 00       	call   c0102d9e <clearVRAM>
			flushVCache();
c01021a0:	e8 2d 0b 00 00       	call   c0102cd2 <flushVCache>
		break;
c01021a5:	eb 55                	jmp    c01021fc <do_syscall+0x357>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c01021a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01021aa:	8b 40 14             	mov    0x14(%eax),%eax
c01021ad:	0f b6 c0             	movzbl %al,%eax
c01021b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01021b3:	8b 52 18             	mov    0x18(%edx),%edx
c01021b6:	89 d1                	mov    %edx,%ecx
c01021b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01021bb:	8b 52 10             	mov    0x10(%edx),%edx
c01021be:	83 ec 04             	sub    $0x4,%esp
c01021c1:	50                   	push   %eax
c01021c2:	51                   	push   %ecx
c01021c3:	52                   	push   %edx
c01021c4:	e8 6e 0b 00 00       	call   c0102d37 <setPixelAt>
c01021c9:	83 c4 10             	add    $0x10,%esp
		break;
c01021cc:	eb 2e                	jmp    c01021fc <do_syscall+0x357>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c01021ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d1:	8b 40 10             	mov    0x10(%eax),%eax
c01021d4:	0f be c0             	movsbl %al,%eax
c01021d7:	83 ec 0c             	sub    $0xc,%esp
c01021da:	50                   	push   %eax
c01021db:	e8 c2 fb ff ff       	call   c0101da2 <get_key>
c01021e0:	83 c4 10             	add    $0x10,%esp
c01021e3:	0f be d0             	movsbl %al,%edx
c01021e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01021e9:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01021ec:	eb 0e                	jmp    c01021fc <do_syscall+0x357>
		case SYS_GET_TICK:
			tf->eax = tick();
c01021ee:	e8 f7 0c 00 00       	call   c0102eea <tick>
c01021f3:	89 c2                	mov    %eax,%edx
c01021f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f8:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c01021fb:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c01021fc:	c9                   	leave  
c01021fd:	c3                   	ret    

c01021fe <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01021fe:	55                   	push   %ebp
c01021ff:	89 e5                	mov    %esp,%ebp
c0102201:	83 ec 10             	sub    $0x10,%esp
c0102204:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010220b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220e:	89 c2                	mov    %eax,%edx
c0102210:	ec                   	in     (%dx),%al
c0102211:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102214:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102218:	0f b6 c0             	movzbl %al,%eax
c010221b:	83 e0 20             	and    $0x20,%eax
c010221e:	85 c0                	test   %eax,%eax
c0102220:	0f 95 c0             	setne  %al
c0102223:	0f b6 c0             	movzbl %al,%eax
}
c0102226:	c9                   	leave  
c0102227:	c3                   	ret    

c0102228 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102228:	55                   	push   %ebp
c0102229:	89 e5                	mov    %esp,%ebp
c010222b:	83 ec 14             	sub    $0x14,%esp
c010222e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102231:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102234:	90                   	nop
c0102235:	e8 c4 ff ff ff       	call   c01021fe <serial_idle>
c010223a:	85 c0                	test   %eax,%eax
c010223c:	74 f7                	je     c0102235 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010223e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102242:	0f b6 c0             	movzbl %al,%eax
c0102245:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010224c:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010224f:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102253:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102256:	ee                   	out    %al,(%dx)
}
c0102257:	c9                   	leave  
c0102258:	c3                   	ret    

c0102259 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102259:	55                   	push   %ebp
c010225a:	89 e5                	mov    %esp,%ebp
c010225c:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010225f:	8d 45 0c             	lea    0xc(%ebp),%eax
c0102262:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102265:	8b 45 08             	mov    0x8(%ebp),%eax
c0102268:	83 ec 04             	sub    $0x4,%esp
c010226b:	ff 75 f4             	pushl  -0xc(%ebp)
c010226e:	50                   	push   %eax
c010226f:	68 28 22 10 c0       	push   $0xc0102228
c0102274:	e8 f6 0d 00 00       	call   c010306f <vfprintf>
c0102279:	83 c4 10             	add    $0x10,%esp
}
c010227c:	c9                   	leave  
c010227d:	c3                   	ret    

c010227e <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c010227e:	55                   	push   %ebp
c010227f:	89 e5                	mov    %esp,%ebp
c0102281:	57                   	push   %edi
c0102282:	56                   	push   %esi
c0102283:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102284:	8b 45 10             	mov    0x10(%ebp),%eax
c0102287:	8b 55 0c             	mov    0xc(%ebp),%edx
c010228a:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010228d:	89 c1                	mov    %eax,%ecx
c010228f:	89 d6                	mov    %edx,%esi
c0102291:	89 df                	mov    %ebx,%edi
c0102293:	fc                   	cld    
c0102294:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102296:	5b                   	pop    %ebx
c0102297:	5e                   	pop    %esi
c0102298:	5f                   	pop    %edi
c0102299:	5d                   	pop    %ebp
c010229a:	c3                   	ret    

c010229b <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c010229b:	55                   	push   %ebp
c010229c:	89 e5                	mov    %esp,%ebp
c010229e:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c01022a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01022a4:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01022a9:	77 16                	ja     c01022c1 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01022ab:	ff 75 10             	pushl  0x10(%ebp)
c01022ae:	68 f8 34 10 c0       	push   $0xc01034f8
c01022b3:	ff 75 0c             	pushl  0xc(%ebp)
c01022b6:	ff 75 08             	pushl  0x8(%ebp)
c01022b9:	e8 9b ff ff ff       	call   c0102259 <printk>
c01022be:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01022c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01022c4:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01022c9:	c9                   	leave  
c01022ca:	c3                   	ret    

c01022cb <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c01022cb:	55                   	push   %ebp
c01022cc:	89 e5                	mov    %esp,%ebp
c01022ce:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01022d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01022d4:	c1 e8 0c             	shr    $0xc,%eax
c01022d7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01022dc:	76 13                	jbe    c01022f1 <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c01022de:	83 ec 08             	sub    $0x8,%esp
c01022e1:	ff 75 10             	pushl  0x10(%ebp)
c01022e4:	68 1c 35 10 c0       	push   $0xc010351c
c01022e9:	e8 6b ff ff ff       	call   c0102259 <printk>
c01022ee:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c01022f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01022f4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01022f9:	c9                   	leave  
c01022fa:	c3                   	ret    

c01022fb <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c01022fb:	55                   	push   %ebp
c01022fc:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c01022fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102301:	ba 00 47 17 c0       	mov    $0xc0174700,%edx
c0102306:	29 d0                	sub    %edx,%eax
c0102308:	c1 f8 03             	sar    $0x3,%eax
c010230b:	c1 e0 0c             	shl    $0xc,%eax
}
c010230e:	5d                   	pop    %ebp
c010230f:	c3                   	ret    

c0102310 <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c0102310:	55                   	push   %ebp
c0102311:	89 e5                	mov    %esp,%ebp
c0102313:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0102316:	8b 45 08             	mov    0x8(%ebp),%eax
c0102319:	c1 e8 0c             	shr    $0xc,%eax
c010231c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c0102321:	76 10                	jbe    c0102333 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0102323:	83 ec 0c             	sub    $0xc,%esp
c0102326:	68 40 35 10 c0       	push   $0xc0103540
c010232b:	e8 29 ff ff ff       	call   c0102259 <printk>
c0102330:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0102333:	8b 45 08             	mov    0x8(%ebp),%eax
c0102336:	c1 e8 0c             	shr    $0xc,%eax
c0102339:	c1 e0 03             	shl    $0x3,%eax
c010233c:	05 00 47 17 c0       	add    $0xc0174700,%eax
}
c0102341:	c9                   	leave  
c0102342:	c3                   	ret    

c0102343 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0102343:	55                   	push   %ebp
c0102344:	89 e5                	mov    %esp,%ebp
c0102346:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0102349:	ff 75 08             	pushl  0x8(%ebp)
c010234c:	e8 aa ff ff ff       	call   c01022fb <page2pa>
c0102351:	83 c4 04             	add    $0x4,%esp
c0102354:	83 ec 04             	sub    $0x4,%esp
c0102357:	50                   	push   %eax
c0102358:	6a 52                	push   $0x52
c010235a:	68 5f 35 10 c0       	push   $0xc010355f
c010235f:	e8 67 ff ff ff       	call   c01022cb <_kaddr>
c0102364:	83 c4 10             	add    $0x10,%esp
}
c0102367:	c9                   	leave  
c0102368:	c3                   	ret    

c0102369 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0102369:	55                   	push   %ebp
c010236a:	89 e5                	mov    %esp,%ebp
c010236c:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c010236f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0102376:	8b 45 08             	mov    0x8(%ebp),%eax
c0102379:	8b 00                	mov    (%eax),%eax
c010237b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c010237e:	eb 10                	jmp    c0102390 <ll_len+0x27>
		p = p->next;
c0102380:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102383:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102389:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c010238c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c0102390:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0102394:	75 ea                	jne    c0102380 <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0102396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102399:	c9                   	leave  
c010239a:	c3                   	ret    

c010239b <ll_pop>:
PCB* ll_pop(PCB** head){
c010239b:	55                   	push   %ebp
c010239c:	89 e5                	mov    %esp,%ebp
c010239e:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c01023a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a4:	8b 00                	mov    (%eax),%eax
c01023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c01023a9:	83 ec 08             	sub    $0x8,%esp
c01023ac:	ff 75 f4             	pushl  -0xc(%ebp)
c01023af:	ff 75 08             	pushl  0x8(%ebp)
c01023b2:	e8 a4 00 00 00       	call   c010245b <ll_delete>
c01023b7:	83 c4 10             	add    $0x10,%esp
	return p;
c01023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01023bd:	c9                   	leave  
c01023be:	c3                   	ret    

c01023bf <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c01023bf:	55                   	push   %ebp
c01023c0:	89 e5                	mov    %esp,%ebp
c01023c2:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c01023c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c8:	8b 00                	mov    (%eax),%eax
c01023ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c01023cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01023d1:	75 0f                	jne    c01023e2 <ll_push+0x23>
		*head = p;
c01023d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01023d9:	89 10                	mov    %edx,(%eax)
		return 0;
c01023db:	b8 00 00 00 00       	mov    $0x0,%eax
c01023e0:	eb 19                	jmp    c01023fb <ll_push+0x3c>
	}else{
		*head = p;
c01023e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01023e8:	89 10                	mov    %edx,(%eax)
		p->next = h;
c01023ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01023ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023f0:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c01023f6:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01023fb:	c9                   	leave  
c01023fc:	c3                   	ret    

c01023fd <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c01023fd:	55                   	push   %ebp
c01023fe:	89 e5                	mov    %esp,%ebp
c0102400:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0102403:	8b 45 08             	mov    0x8(%ebp),%eax
c0102406:	8b 00                	mov    (%eax),%eax
c0102408:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c010240b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010240e:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0102415:	00 00 00 
	if(h == NULL){
c0102418:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010241c:	75 0f                	jne    c010242d <ll_entail+0x30>
		*head = p;
c010241e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102421:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102424:	89 10                	mov    %edx,(%eax)
		return 0;
c0102426:	b8 00 00 00 00       	mov    $0x0,%eax
c010242b:	eb 2c                	jmp    c0102459 <ll_entail+0x5c>
	}else{
		while(h->next){
c010242d:	eb 0c                	jmp    c010243b <ll_entail+0x3e>
			h = h->next;
c010242f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102432:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102438:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c010243b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010243e:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102444:	85 c0                	test   %eax,%eax
c0102446:	75 e7                	jne    c010242f <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0102448:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010244b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010244e:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c0102454:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0102459:	c9                   	leave  
c010245a:	c3                   	ret    

c010245b <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c010245b:	55                   	push   %ebp
c010245c:	89 e5                	mov    %esp,%ebp
c010245e:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c0102461:	8b 45 08             	mov    0x8(%ebp),%eax
c0102464:	8b 00                	mov    (%eax),%eax
c0102466:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102469:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c0102470:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0102474:	75 07                	jne    c010247d <ll_delete+0x22>
			return 0;
c0102476:	b8 00 00 00 00       	mov    $0x0,%eax
c010247b:	eb 59                	jmp    c01024d6 <ll_delete+0x7b>
		if(sleep == p)
c010247d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102480:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0102483:	75 09                	jne    c010248e <ll_delete+0x33>
			break;
c0102485:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0102486:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010248a:	75 26                	jne    c01024b2 <ll_delete+0x57>
c010248c:	eb 14                	jmp    c01024a2 <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c010248e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102491:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0102494:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102497:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c010249d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c01024a0:	eb ce                	jmp    c0102470 <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c01024a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024a5:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01024ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ae:	89 10                	mov    %edx,(%eax)
c01024b0:	eb 12                	jmp    c01024c4 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c01024b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024b5:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01024bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01024be:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c01024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024c7:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c01024ce:	00 00 00 
	return 1;
c01024d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01024d6:	c9                   	leave  
c01024d7:	c3                   	ret    

c01024d8 <init_pcb_pool>:

void init_pcb_pool()
{
c01024d8:	55                   	push   %ebp
c01024d9:	89 e5                	mov    %esp,%ebp
c01024db:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01024de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01024e5:	eb 1d                	jmp    c0102504 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c01024e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024ea:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01024f0:	05 40 20 00 00       	add    $0x2040,%eax
c01024f5:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c01024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102500:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102504:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c010250b:	76 da                	jbe    c01024e7 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c010250d:	c9                   	leave  
c010250e:	c3                   	ret    

c010250f <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c010250f:	55                   	push   %ebp
c0102510:	89 e5                	mov    %esp,%ebp
c0102512:	83 ec 24             	sub    $0x24,%esp
c0102515:	8b 45 14             	mov    0x14(%ebp),%eax
c0102518:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c010251b:	8b 45 08             	mov    0x8(%ebp),%eax
c010251e:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102524:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0102527:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010252b:	75 46                	jne    c0102573 <init_pcb+0x64>
		tf->ds = GD_KD;
c010252d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102530:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0102537:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010253a:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c0102541:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102544:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c010254a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010254d:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0102554:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102557:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c010255e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102561:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0102567:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010256a:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c0102571:	eb 4a                	jmp    c01025bd <init_pcb+0xae>
	}else
	if(pri == 3){
c0102573:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0102577:	75 44                	jne    c01025bd <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0102579:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010257c:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0102583:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102586:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c010258d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102590:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0102596:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102599:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c01025a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025a3:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c01025aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025ad:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01025b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025b6:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c01025bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025c0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01025c3:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c01025c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025c9:	8b 55 10             	mov    0x10(%ebp),%edx
c01025cc:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c01025cf:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01025d3:	75 59                	jne    c010262e <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c01025d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c01025db:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01025de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c01025e1:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c01025e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01025ef:	eb 26                	jmp    c0102617 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c01025f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01025f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025fe:	01 c2                	add    %eax,%edx
c0102600:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102603:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c010260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010260d:	01 c8                	add    %ecx,%eax
c010260f:	8b 00                	mov    (%eax),%eax
c0102611:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0102613:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102617:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010261a:	c1 e8 02             	shr    $0x2,%eax
c010261d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102620:	77 cf                	ja     c01025f1 <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c0102622:	8b 45 08             	mov    0x8(%ebp),%eax
c0102625:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102628:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c010262e:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0102632:	0f 95 c0             	setne  %al
c0102635:	0f b6 d0             	movzbl %al,%edx
c0102638:	8b 45 08             	mov    0x8(%ebp),%eax
c010263b:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c0102641:	c9                   	leave  
c0102642:	c3                   	ret    

c0102643 <pcb_create>:

PCB* pcb_create()
{
c0102643:	55                   	push   %ebp
c0102644:	89 e5                	mov    %esp,%ebp
c0102646:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102650:	eb 1f                	jmp    c0102671 <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c0102652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102655:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c010265b:	05 40 20 00 00       	add    $0x2040,%eax
c0102660:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102665:	8b 00                	mov    (%eax),%eax
c0102667:	85 c0                	test   %eax,%eax
c0102669:	75 02                	jne    c010266d <pcb_create+0x2a>
c010266b:	eb 0d                	jmp    c010267a <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010266d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102671:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0102678:	76 d8                	jbe    c0102652 <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c010267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010267d:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102683:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102688:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c010268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010268e:	6b c0 4c             	imul   $0x4c,%eax,%eax
c0102691:	8d 90 40 85 1b c0    	lea    -0x3fe47ac0(%eax),%edx
c0102697:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010269a:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c01026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026a3:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c01026aa:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c01026ad:	83 ec 0c             	sub    $0xc,%esp
c01026b0:	6a 01                	push   $0x1
c01026b2:	e8 cc e1 ff ff       	call   c0100883 <page_alloc>
c01026b7:	83 c4 10             	add    $0x10,%esp
c01026ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c01026bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01026c1:	75 07                	jne    c01026ca <pcb_create+0x87>
c01026c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01026c8:	eb 77                	jmp    c0102741 <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c01026ca:	83 ec 0c             	sub    $0xc,%esp
c01026cd:	ff 75 ec             	pushl  -0x14(%ebp)
c01026d0:	e8 6e fc ff ff       	call   c0102343 <page2kva>
c01026d5:	83 c4 10             	add    $0x10,%esp
c01026d8:	89 c2                	mov    %eax,%edx
c01026da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026dd:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c01026e3:	8b 15 a8 70 10 c0    	mov    0xc01070a8,%edx
c01026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026ec:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c01026f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01026f5:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01026fc:	00 00 00 
	//p->ts = READY;
	pid ++;
c01026ff:	a1 a8 70 10 c0       	mov    0xc01070a8,%eax
c0102704:	83 c0 01             	add    $0x1,%eax
c0102707:	a3 a8 70 10 c0       	mov    %eax,0xc01070a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c010270c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010270f:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0102713:	8d 50 01             	lea    0x1(%eax),%edx
c0102716:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102719:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c010271d:	8b 15 c0 46 17 c0    	mov    0xc01746c0,%edx
c0102723:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102726:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c010272c:	83 ec 04             	sub    $0x4,%esp
c010272f:	68 00 10 00 00       	push   $0x1000
c0102734:	52                   	push   %edx
c0102735:	50                   	push   %eax
c0102736:	e8 43 fb ff ff       	call   c010227e <memcpy>
c010273b:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c010273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102741:	c9                   	leave  
c0102742:	c3                   	ret    

c0102743 <enready_pcb>:

void enready_pcb(PCB* pcb){
c0102743:	55                   	push   %ebp
c0102744:	89 e5                	mov    %esp,%ebp
c0102746:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0102749:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010274e:	85 c0                	test   %eax,%eax
c0102750:	75 18                	jne    c010276a <enready_pcb+0x27>
		ready_list = pcb;
c0102752:	8b 45 08             	mov    0x8(%ebp),%eax
c0102755:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
		ready_list->tail = pcb;
c010275a:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010275f:	8b 55 08             	mov    0x8(%ebp),%edx
c0102762:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c0102768:	eb 32                	jmp    c010279c <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c010276a:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c0102772:	8b 45 08             	mov    0x8(%ebp),%eax
c0102775:	a3 b0 50 15 c0       	mov    %eax,0xc01550b0
		ready_list->next = temp;
c010277a:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010277f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102782:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c0102788:	a1 b0 50 15 c0       	mov    0xc01550b0,%eax
c010278d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102790:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c0102796:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c010279c:	c9                   	leave  
c010279d:	c3                   	ret    

c010279e <switch_pcb>:

void switch_pcb(PCB* pcb){
c010279e:	55                   	push   %ebp
c010279f:	89 e5                	mov    %esp,%ebp
c01027a1:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01027a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01027a7:	a3 ac 50 15 c0       	mov    %eax,0xc01550ac
	lcr3(PADDR(pcb -> pgdir));
c01027ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01027af:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01027b5:	83 ec 04             	sub    $0x4,%esp
c01027b8:	50                   	push   %eax
c01027b9:	68 af 00 00 00       	push   $0xaf
c01027be:	68 75 35 10 c0       	push   $0xc0103575
c01027c3:	e8 d3 fa ff ff       	call   c010229b <_paddr>
c01027c8:	83 c4 10             	add    $0x10,%esp
c01027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027d1:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c01027d4:	83 ec 0c             	sub    $0xc,%esp
c01027d7:	ff 75 08             	pushl  0x8(%ebp)
c01027da:	e8 7d db ff ff       	call   c010035c <enter_pcb>
c01027df:	83 c4 10             	add    $0x10,%esp
}
c01027e2:	c9                   	leave  
c01027e3:	c3                   	ret    

c01027e4 <free_pcb>:
void free_pcb(PCB* pcb){
c01027e4:	55                   	push   %ebp
c01027e5:	89 e5                	mov    %esp,%ebp
c01027e7:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c01027ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ed:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01027f3:	83 ec 0c             	sub    $0xc,%esp
c01027f6:	50                   	push   %eax
c01027f7:	e8 eb e5 ff ff       	call   c0100de7 <free_pgdir>
c01027fc:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c01027ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102802:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102808:	83 ec 04             	sub    $0x4,%esp
c010280b:	50                   	push   %eax
c010280c:	68 b8 00 00 00       	push   $0xb8
c0102811:	68 75 35 10 c0       	push   $0xc0103575
c0102816:	e8 80 fa ff ff       	call   c010229b <_paddr>
c010281b:	83 c4 10             	add    $0x10,%esp
c010281e:	83 ec 0c             	sub    $0xc,%esp
c0102821:	50                   	push   %eax
c0102822:	e8 e9 fa ff ff       	call   c0102310 <pa2page>
c0102827:	83 c4 10             	add    $0x10,%esp
c010282a:	83 ec 0c             	sub    $0xc,%esp
c010282d:	50                   	push   %eax
c010282e:	e8 d8 e0 ff ff       	call   c010090b <page_decref>
c0102833:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c0102836:	8b 45 08             	mov    0x8(%ebp),%eax
c0102839:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c0102840:	00 00 00 

}
c0102843:	c9                   	leave  
c0102844:	c3                   	ret    

c0102845 <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c0102845:	55                   	push   %ebp
c0102846:	89 e5                	mov    %esp,%ebp
c0102848:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c010284b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010284e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102851:	68 10 08 00 00       	push   $0x810
c0102856:	52                   	push   %edx
c0102857:	50                   	push   %eax
c0102858:	e8 21 fa ff ff       	call   c010227e <memcpy>
c010285d:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c0102860:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102863:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0102869:	8b 45 08             	mov    0x8(%ebp),%eax
c010286c:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c0102872:	8b 45 08             	mov    0x8(%ebp),%eax
c0102875:	05 20 10 00 00       	add    $0x1020,%eax
c010287a:	89 c2                	mov    %eax,%edx
c010287c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010287f:	05 20 10 00 00       	add    $0x1020,%eax
c0102884:	29 c2                	sub    %eax,%edx
c0102886:	89 d0                	mov    %edx,%eax
c0102888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c010288b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010288e:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c0102894:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102897:	01 c2                	add    %eax,%edx
c0102899:	8b 45 08             	mov    0x8(%ebp),%eax
c010289c:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c01028a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01028a5:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c01028ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ae:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c01028b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b7:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c01028bd:	85 c0                	test   %eax,%eax
c01028bf:	75 62                	jne    c0102923 <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c01028c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c4:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01028ca:	8b 55 08             	mov    0x8(%ebp),%edx
c01028cd:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c01028d3:	8b 4a 08             	mov    0x8(%edx),%ecx
c01028d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028d9:	01 ca                	add    %ecx,%edx
c01028db:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c01028de:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e1:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01028e7:	8b 40 08             	mov    0x8(%eax),%eax
c01028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c01028ed:	eb 17                	jmp    c0102906 <copy_pcb+0xc1>
			*(ptr) += offset;
c01028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028f2:	8b 10                	mov    (%eax),%edx
c01028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01028f7:	01 c2                	add    %eax,%edx
c01028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028fc:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c01028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102901:	8b 00                	mov    (%eax),%eax
c0102903:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102909:	8b 00                	mov    (%eax),%eax
c010290b:	85 c0                	test   %eax,%eax
c010290d:	75 e0                	jne    c01028ef <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c010290f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102912:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0102918:	8b 45 08             	mov    0x8(%ebp),%eax
c010291b:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c0102921:	eb 2d                	jmp    c0102950 <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c0102923:	8b 45 08             	mov    0x8(%ebp),%eax
c0102926:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c010292c:	83 f8 02             	cmp    $0x2,%eax
c010292f:	74 1f                	je     c0102950 <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c0102931:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102934:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c010293a:	8b 45 08             	mov    0x8(%ebp),%eax
c010293d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102943:	83 ec 08             	sub    $0x8,%esp
c0102946:	52                   	push   %edx
c0102947:	50                   	push   %eax
c0102948:	e8 e5 e1 ff ff       	call   c0100b32 <copy_pgdir>
c010294d:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c0102950:	c9                   	leave  
c0102951:	c3                   	ret    

c0102952 <fork_current>:

void switch_proc();
void fork_current(){
c0102952:	55                   	push   %ebp
c0102953:	89 e5                	mov    %esp,%ebp
c0102955:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0102958:	e8 e6 fc ff ff       	call   c0102643 <pcb_create>
c010295d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c0102960:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102965:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c010296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296e:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0102974:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102979:	83 ec 08             	sub    $0x8,%esp
c010297c:	50                   	push   %eax
c010297d:	ff 75 f4             	pushl  -0xc(%ebp)
c0102980:	e8 c0 fe ff ff       	call   c0102845 <copy_pcb>
c0102985:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0102988:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c010298d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102993:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102996:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c010299c:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a2:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01029a8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c01029af:	83 ec 08             	sub    $0x8,%esp
c01029b2:	ff 75 f4             	pushl  -0xc(%ebp)
c01029b5:	68 b0 50 15 c0       	push   $0xc01550b0
c01029ba:	e8 00 fa ff ff       	call   c01023bf <ll_push>
c01029bf:	83 c4 10             	add    $0x10,%esp
}
c01029c2:	c9                   	leave  
c01029c3:	c3                   	ret    

c01029c4 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c01029c4:	55                   	push   %ebp
c01029c5:	89 e5                	mov    %esp,%ebp
c01029c7:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c01029ca:	e8 74 fc ff ff       	call   c0102643 <pcb_create>
c01029cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c01029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d5:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c01029dc:	00 00 00 
	son->ppid = current->pid;
c01029df:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01029e4:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ed:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01029f3:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c01029f8:	83 ec 08             	sub    $0x8,%esp
c01029fb:	50                   	push   %eax
c01029fc:	ff 75 f4             	pushl  -0xc(%ebp)
c01029ff:	e8 41 fe ff ff       	call   c0102845 <copy_pcb>
c0102a04:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c0102a07:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102a0c:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0102a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a15:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a1b:	83 ec 04             	sub    $0x4,%esp
c0102a1e:	68 00 10 00 00       	push   $0x1000
c0102a23:	52                   	push   %edx
c0102a24:	50                   	push   %eax
c0102a25:	e8 54 f8 ff ff       	call   c010227e <memcpy>
c0102a2a:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c0102a2d:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0102a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a37:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c0102a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a40:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a46:	83 ec 04             	sub    $0x4,%esp
c0102a49:	68 00 20 00 00       	push   $0x2000
c0102a4e:	52                   	push   %edx
c0102a4f:	50                   	push   %eax
c0102a50:	e8 3c dc ff ff       	call   c0100691 <mm_alloc>
c0102a55:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c0102a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a5b:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a61:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a64:	83 ea 40             	sub    $0x40,%edx
c0102a67:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c0102a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a6d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a76:	83 ea 40             	sub    $0x40,%edx
c0102a79:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c0102a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7f:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a85:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a88:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0102a8b:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102a90:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102a99:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0102a9f:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c0102aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa5:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0102aab:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c0102ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab5:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102abb:	83 ec 04             	sub    $0x4,%esp
c0102abe:	50                   	push   %eax
c0102abf:	68 fb 00 00 00       	push   $0xfb
c0102ac4:	68 75 35 10 c0       	push   $0xc0103575
c0102ac9:	e8 cd f7 ff ff       	call   c010229b <_paddr>
c0102ace:	83 c4 10             	add    $0x10,%esp
c0102ad1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad7:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c0102ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102add:	83 e8 40             	sub    $0x40,%eax
c0102ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c0102ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ae9:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c0102aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102aee:	8d 50 04             	lea    0x4(%eax),%edx
c0102af1:	8b 45 10             	mov    0x10(%ebp),%eax
c0102af4:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c0102af6:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102afb:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102b01:	83 ec 04             	sub    $0x4,%esp
c0102b04:	50                   	push   %eax
c0102b05:	68 01 01 00 00       	push   $0x101
c0102b0a:	68 75 35 10 c0       	push   $0xc0103575
c0102b0f:	e8 87 f7 ff ff       	call   c010229b <_paddr>
c0102b14:	83 c4 10             	add    $0x10,%esp
c0102b17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1d:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c0102b20:	83 ec 08             	sub    $0x8,%esp
c0102b23:	ff 75 f4             	pushl  -0xc(%ebp)
c0102b26:	68 b0 50 15 c0       	push   $0xc01550b0
c0102b2b:	e8 8f f8 ff ff       	call   c01023bf <ll_push>
c0102b30:	83 c4 10             	add    $0x10,%esp
}
c0102b33:	c9                   	leave  
c0102b34:	c3                   	ret    

c0102b35 <exit_current>:

void exit_current(){
c0102b35:	55                   	push   %ebp
c0102b36:	89 e5                	mov    %esp,%ebp
c0102b38:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0102b3b:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102b40:	05 68 20 00 00       	add    $0x2068,%eax
c0102b45:	83 ec 0c             	sub    $0xc,%esp
c0102b48:	50                   	push   %eax
c0102b49:	e8 4d f8 ff ff       	call   c010239b <ll_pop>
c0102b4e:	83 c4 10             	add    $0x10,%esp
c0102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0102b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b58:	75 02                	jne    c0102b5c <exit_current+0x27>
c0102b5a:	eb 24                	jmp    c0102b80 <exit_current+0x4b>
		if(p->used == 0) continue;
c0102b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b5f:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0102b65:	85 c0                	test   %eax,%eax
c0102b67:	75 02                	jne    c0102b6b <exit_current+0x36>
c0102b69:	eb 13                	jmp    c0102b7e <exit_current+0x49>
		ll_entail(&ready_list, p);
c0102b6b:	83 ec 08             	sub    $0x8,%esp
c0102b6e:	ff 75 f4             	pushl  -0xc(%ebp)
c0102b71:	68 b0 50 15 c0       	push   $0xc01550b0
c0102b76:	e8 82 f8 ff ff       	call   c01023fd <ll_entail>
c0102b7b:	83 c4 10             	add    $0x10,%esp
	}
c0102b7e:	eb bb                	jmp    c0102b3b <exit_current+0x6>
	
	free_pcb(current);
c0102b80:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102b85:	83 ec 0c             	sub    $0xc,%esp
c0102b88:	50                   	push   %eax
c0102b89:	e8 56 fc ff ff       	call   c01027e4 <free_pcb>
c0102b8e:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c0102b91:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0102b98:	00 00 00 
	do_scheduler();
c0102b9b:	e8 0b e5 ff ff       	call   c01010ab <do_scheduler>
}
c0102ba0:	c9                   	leave  
c0102ba1:	c3                   	ret    

c0102ba2 <join_current>:

void join_current(int pid){
c0102ba2:	55                   	push   %ebp
c0102ba3:	89 e5                	mov    %esp,%ebp
c0102ba5:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0102ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bac:	75 05                	jne    c0102bb3 <join_current+0x11>
c0102bae:	e9 97 00 00 00       	jmp    c0102c4a <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102bb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102bba:	eb 23                	jmp    c0102bdf <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0102bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bbf:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102bc5:	05 40 20 00 00       	add    $0x2040,%eax
c0102bca:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102bcf:	8b 50 04             	mov    0x4(%eax),%edx
c0102bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd5:	39 c2                	cmp    %eax,%edx
c0102bd7:	75 02                	jne    c0102bdb <join_current+0x39>
c0102bd9:	eb 0d                	jmp    c0102be8 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0102bdb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102bdf:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0102be6:	76 d4                	jbe    c0102bbc <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0102be8:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0102bef:	75 02                	jne    c0102bf3 <join_current+0x51>
c0102bf1:	eb 57                	jmp    c0102c4a <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c0102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf6:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102bfc:	05 40 20 00 00       	add    $0x2040,%eax
c0102c01:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102c06:	8b 00                	mov    (%eax),%eax
c0102c08:	85 c0                	test   %eax,%eax
c0102c0a:	75 02                	jne    c0102c0e <join_current+0x6c>
c0102c0c:	eb 3c                	jmp    c0102c4a <join_current+0xa8>
	PCB *p = &PCBPool[i];
c0102c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c11:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0102c17:	05 40 ae 1c c0       	add    $0xc01cae40,%eax
c0102c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0102c1f:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102c24:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0102c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c2a:	05 68 20 00 00       	add    $0x2068,%eax
c0102c2f:	ff 75 ec             	pushl  -0x14(%ebp)
c0102c32:	50                   	push   %eax
c0102c33:	e8 c5 f7 ff ff       	call   c01023fd <ll_entail>
c0102c38:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0102c3b:	c7 05 ac 50 15 c0 00 	movl   $0x0,0xc01550ac
c0102c42:	00 00 00 
	do_scheduler();
c0102c45:	e8 61 e4 ff ff       	call   c01010ab <do_scheduler>
c0102c4a:	c9                   	leave  
c0102c4b:	c3                   	ret    

c0102c4c <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0102c4c:	55                   	push   %ebp
c0102c4d:	89 e5                	mov    %esp,%ebp
c0102c4f:	57                   	push   %edi
c0102c50:	56                   	push   %esi
c0102c51:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0102c52:	8b 45 10             	mov    0x10(%ebp),%eax
c0102c55:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0102c5b:	89 c1                	mov    %eax,%ecx
c0102c5d:	89 d6                	mov    %edx,%esi
c0102c5f:	89 df                	mov    %ebx,%edi
c0102c61:	fc                   	cld    
c0102c62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0102c64:	5b                   	pop    %ebx
c0102c65:	5e                   	pop    %esi
c0102c66:	5f                   	pop    %edi
c0102c67:	5d                   	pop    %ebp
c0102c68:	c3                   	ret    

c0102c69 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0102c69:	55                   	push   %ebp
c0102c6a:	89 e5                	mov    %esp,%ebp
c0102c6c:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0102c6f:	68 80 3e 00 00       	push   $0x3e80
c0102c74:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102c79:	68 c0 50 15 c0       	push   $0xc01550c0
c0102c7e:	e8 c9 ff ff ff       	call   c0102c4c <memcpy>
c0102c83:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0102c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102c8d:	eb 0f                	jmp    c0102c9e <initVCache+0x35>
		VDIRTY[x] = 0;
c0102c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c92:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102c97:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0102c9a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102c9e:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102ca5:	7e e8                	jle    c0102c8f <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0102ca7:	c9                   	leave  
c0102ca8:	c3                   	ret    

c0102ca9 <refreshVCache>:
void refreshVCache(){
c0102ca9:	55                   	push   %ebp
c0102caa:	89 e5                	mov    %esp,%ebp
c0102cac:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102caf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102cb6:	eb 0f                	jmp    c0102cc7 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0102cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102cbb:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102cc0:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0102cc3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102cc7:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102cce:	7e e8                	jle    c0102cb8 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0102cd0:	c9                   	leave  
c0102cd1:	c3                   	ret    

c0102cd2 <flushVCache>:
void flushVCache(){
c0102cd2:	55                   	push   %ebp
c0102cd3:	89 e5                	mov    %esp,%ebp
c0102cd5:	53                   	push   %ebx
c0102cd6:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102cd9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0102ce0:	eb 47                	jmp    c0102d29 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0102ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102ce5:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102cea:	0f b6 00             	movzbl (%eax),%eax
c0102ced:	84 c0                	test   %al,%al
c0102cef:	74 34                	je     c0102d25 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0102cf1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102cf4:	89 d0                	mov    %edx,%eax
c0102cf6:	c1 e0 02             	shl    $0x2,%eax
c0102cf9:	01 d0                	add    %edx,%eax
c0102cfb:	c1 e0 06             	shl    $0x6,%eax
c0102cfe:	8d 88 c0 50 15 c0    	lea    -0x3feaaf40(%eax),%ecx
c0102d04:	8b 1d ac 70 10 c0    	mov    0xc01070ac,%ebx
c0102d0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102d0d:	89 d0                	mov    %edx,%eax
c0102d0f:	c1 e0 02             	shl    $0x2,%eax
c0102d12:	01 d0                	add    %edx,%eax
c0102d14:	c1 e0 06             	shl    $0x6,%eax
c0102d17:	01 d8                	add    %ebx,%eax
c0102d19:	6a 50                	push   $0x50
c0102d1b:	51                   	push   %ecx
c0102d1c:	50                   	push   %eax
c0102d1d:	e8 2a ff ff ff       	call   c0102c4c <memcpy>
c0102d22:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0102d25:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0102d29:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0102d30:	7e b0                	jle    c0102ce2 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0102d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102d35:	c9                   	leave  
c0102d36:	c3                   	ret    

c0102d37 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0102d37:	55                   	push   %ebp
c0102d38:	89 e5                	mov    %esp,%ebp
c0102d3a:	83 ec 04             	sub    $0x4,%esp
c0102d3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0102d40:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0102d43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d47:	78 18                	js     c0102d61 <setPixelAt+0x2a>
c0102d49:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0102d50:	7f 0f                	jg     c0102d61 <setPixelAt+0x2a>
c0102d52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d56:	78 09                	js     c0102d61 <setPixelAt+0x2a>
c0102d58:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0102d5f:	7e 02                	jle    c0102d63 <setPixelAt+0x2c>
c0102d61:	eb 34                	jmp    c0102d97 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0102d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d66:	05 c0 44 17 c0       	add    $0xc01744c0,%eax
c0102d6b:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d71:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102d76:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0102d79:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d7c:	89 d0                	mov    %edx,%eax
c0102d7e:	c1 e0 02             	shl    $0x2,%eax
c0102d81:	01 d0                	add    %edx,%eax
c0102d83:	c1 e0 06             	shl    $0x6,%eax
c0102d86:	89 c2                	mov    %eax,%edx
c0102d88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d8b:	01 c2                	add    %eax,%edx
c0102d8d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0102d91:	88 82 c0 50 15 c0    	mov    %al,-0x3feaaf40(%edx)
}
c0102d97:	c9                   	leave  
c0102d98:	c3                   	ret    

c0102d99 <forceClearVRAM>:
void forceClearVRAM(){
c0102d99:	55                   	push   %ebp
c0102d9a:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0102d9c:	5d                   	pop    %ebp
c0102d9d:	c3                   	ret    

c0102d9e <clearVRAM>:
void clearVRAM(){
c0102d9e:	55                   	push   %ebp
c0102d9f:	89 e5                	mov    %esp,%ebp
c0102da1:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102da4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102dab:	eb 4e                	jmp    c0102dfb <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0102dad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102db0:	05 c0 45 17 c0       	add    $0xc01745c0,%eax
c0102db5:	0f b6 00             	movzbl (%eax),%eax
c0102db8:	0f b6 c0             	movzbl %al,%eax
c0102dbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102dbe:	81 c2 c0 44 17 c0    	add    $0xc01744c0,%edx
c0102dc4:	0f b6 12             	movzbl (%edx),%edx
c0102dc7:	0f b6 d2             	movzbl %dl,%edx
c0102dca:	f7 d2                	not    %edx
c0102dcc:	21 d0                	and    %edx,%eax
c0102dce:	85 c0                	test   %eax,%eax
c0102dd0:	74 25                	je     c0102df7 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0102dd2:	8b 0d ac 70 10 c0    	mov    0xc01070ac,%ecx
c0102dd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102ddb:	89 d0                	mov    %edx,%eax
c0102ddd:	c1 e0 02             	shl    $0x2,%eax
c0102de0:	01 d0                	add    %edx,%eax
c0102de2:	c1 e0 06             	shl    $0x6,%eax
c0102de5:	01 c8                	add    %ecx,%eax
c0102de7:	6a 50                	push   $0x50
c0102de9:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102dee:	50                   	push   %eax
c0102def:	e8 58 fe ff ff       	call   c0102c4c <memcpy>
c0102df4:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0102df7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102dfb:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0102e02:	7e a9                	jle    c0102dad <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0102e04:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102e0b:	83 c0 01             	add    $0x1,%eax
c0102e0e:	a2 88 46 17 c0       	mov    %al,0xc0174688
	if(stamp==30){
c0102e13:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102e1a:	3c 1e                	cmp    $0x1e,%al
c0102e1c:	75 07                	jne    c0102e25 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0102e1e:	c6 05 88 46 17 c0 00 	movb   $0x0,0xc0174688
		//printk("What matters\n");
	}
	if(stamp==0){
c0102e25:	0f b6 05 88 46 17 c0 	movzbl 0xc0174688,%eax
c0102e2c:	84 c0                	test   %al,%al
c0102e2e:	75 14                	jne    c0102e44 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0102e30:	6a 32                	push   $0x32
c0102e32:	68 c0 4a 16 c0       	push   $0xc0164ac0
c0102e37:	68 c0 45 17 c0       	push   $0xc01745c0
c0102e3c:	e8 0b fe ff ff       	call   c0102c4c <memcpy>
c0102e41:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0102e44:	c9                   	leave  
c0102e45:	c3                   	ret    

c0102e46 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0102e46:	55                   	push   %ebp
c0102e47:	89 e5                	mov    %esp,%ebp
c0102e49:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0102e4c:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102e51:	83 c0 01             	add    $0x1,%eax
c0102e54:	a3 8c 46 17 c0       	mov    %eax,0xc017468c
	current->timeslice ++;
c0102e59:	a1 ac 50 15 c0       	mov    0xc01550ac,%eax
c0102e5e:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0102e64:	83 c2 01             	add    $0x1,%edx
c0102e67:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c0102e6d:	a1 b4 50 15 c0       	mov    0xc01550b4,%eax
c0102e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0102e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e79:	75 02                	jne    c0102e7d <do_timer+0x37>
c0102e7b:	eb 6b                	jmp    c0102ee8 <do_timer+0xa2>
	 	sleep->timeslice --;
c0102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e80:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102e86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e8c:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0102e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e95:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0102e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e9b:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0102ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0102ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea7:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0102ead:	85 c0                	test   %eax,%eax
c0102eaf:	74 02                	je     c0102eb3 <do_timer+0x6d>
c0102eb1:	eb 33                	jmp    c0102ee6 <do_timer+0xa0>
	 	cur->ts = READY;
c0102eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eb6:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0102ebd:	00 00 00 
		ll_delete(&sleep_list, cur);
c0102ec0:	83 ec 08             	sub    $0x8,%esp
c0102ec3:	ff 75 f0             	pushl  -0x10(%ebp)
c0102ec6:	68 b4 50 15 c0       	push   $0xc01550b4
c0102ecb:	e8 8b f5 ff ff       	call   c010245b <ll_delete>
c0102ed0:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0102ed3:	83 ec 08             	sub    $0x8,%esp
c0102ed6:	ff 75 f0             	pushl  -0x10(%ebp)
c0102ed9:	68 b0 50 15 c0       	push   $0xc01550b0
c0102ede:	e8 1a f5 ff ff       	call   c01023fd <ll_entail>
c0102ee3:	83 c4 10             	add    $0x10,%esp
	}
c0102ee6:	eb 8d                	jmp    c0102e75 <do_timer+0x2f>
}
c0102ee8:	c9                   	leave  
c0102ee9:	c3                   	ret    

c0102eea <tick>:
uint32_t tick(){
c0102eea:	55                   	push   %ebp
c0102eeb:	89 e5                	mov    %esp,%ebp
	return _tick;
c0102eed:	a1 8c 46 17 c0       	mov    0xc017468c,%eax
c0102ef2:	5d                   	pop    %ebp
c0102ef3:	c3                   	ret    

c0102ef4 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0102ef4:	6a 00                	push   $0x0
c0102ef6:	6a 00                	push   $0x0
c0102ef8:	e9 b8 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102efd <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0102efd:	6a 00                	push   $0x0
c0102eff:	6a 01                	push   $0x1
c0102f01:	e9 af 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f06 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0102f06:	6a 00                	push   $0x0
c0102f08:	6a 02                	push   $0x2
c0102f0a:	e9 a6 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f0f <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0102f0f:	6a 00                	push   $0x0
c0102f11:	6a 03                	push   $0x3
c0102f13:	e9 9d 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f18 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0102f18:	6a 00                	push   $0x0
c0102f1a:	6a 04                	push   $0x4
c0102f1c:	e9 94 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f21 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0102f21:	6a 00                	push   $0x0
c0102f23:	6a 05                	push   $0x5
c0102f25:	e9 8b 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f2a <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0102f2a:	6a 00                	push   $0x0
c0102f2c:	6a 06                	push   $0x6
c0102f2e:	e9 82 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f33 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0102f33:	6a 00                	push   $0x0
c0102f35:	6a 07                	push   $0x7
c0102f37:	e9 79 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f3c <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0102f3c:	6a 00                	push   $0x0
c0102f3e:	6a 08                	push   $0x8
c0102f40:	e9 70 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f45 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0102f45:	6a 00                	push   $0x0
c0102f47:	6a 09                	push   $0x9
c0102f49:	e9 67 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f4e <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0102f4e:	6a 00                	push   $0x0
c0102f50:	6a 0a                	push   $0xa
c0102f52:	e9 5e 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f57 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0102f57:	6a 00                	push   $0x0
c0102f59:	6a 0b                	push   $0xb
c0102f5b:	e9 55 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f60 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0102f60:	6a 00                	push   $0x0
c0102f62:	6a 0c                	push   $0xc
c0102f64:	e9 4c 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f69 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0102f69:	6a 00                	push   $0x0
c0102f6b:	6a 0d                	push   $0xd
c0102f6d:	e9 43 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f72 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0102f72:	6a 00                	push   $0x0
c0102f74:	6a 0e                	push   $0xe
c0102f76:	e9 3a 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f7b <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0102f7b:	fa                   	cli    
c0102f7c:	6a 00                	push   $0x0
c0102f7e:	68 80 00 00 00       	push   $0x80
c0102f83:	e9 2d 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f88 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0102f88:	6a 00                	push   $0x0
c0102f8a:	68 e8 03 00 00       	push   $0x3e8
c0102f8f:	e9 21 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102f94 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0102f94:	6a 00                	push   $0x0
c0102f96:	68 e9 03 00 00       	push   $0x3e9
c0102f9b:	e9 15 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102fa0 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0102fa0:	6a 00                	push   $0x0
c0102fa2:	68 f6 03 00 00       	push   $0x3f6
c0102fa7:	e9 09 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102fac <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0102fac:	6a 00                	push   $0x0
c0102fae:	6a ff                	push   $0xffffffff
c0102fb0:	e9 00 00 00 00       	jmp    c0102fb5 <asm_do_irq>

c0102fb5 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0102fb5:	fa                   	cli    
  pushl %ds
c0102fb6:	1e                   	push   %ds
  pushl %es
c0102fb7:	06                   	push   %es
  pushl %fs
c0102fb8:	0f a0                	push   %fs
  pushl %gs
c0102fba:	0f a8                	push   %gs
	pushal
c0102fbc:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0102fbd:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0102fc1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0102fc3:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0102fc5:	54                   	push   %esp
  call irq_handle
c0102fc6:	e8 d3 e1 ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0102fcb:	83 c4 04             	add    $0x4,%esp

c0102fce <switch_proc>:
switch_proc:
  popal
c0102fce:	61                   	popa   
  popl %gs
c0102fcf:	0f a9                	pop    %gs
  popl %fs
c0102fd1:	0f a1                	pop    %fs
  popl %es
c0102fd3:	07                   	pop    %es
  popl %ds
c0102fd4:	1f                   	pop    %ds
  addl $8, %esp
c0102fd5:	83 c4 08             	add    $0x8,%esp
  sti
c0102fd8:	fb                   	sti    
  iret
c0102fd9:	cf                   	iret   
c0102fda:	66 90                	xchg   %ax,%ax
c0102fdc:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0102fe2:	00 00                	add    %al,(%eax)
c0102fe4:	fe 4f 52             	decb   0x52(%edi)
c0102fe7:	e4 66                	in     $0x66,%al

c0102fe8 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0102fe8:	66 c7 05 72 04 00 00 34 12 b8 00 60 10 00 0f 22     f..r...4...`..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0102ff8:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 0b 30 10     .. ......."...0.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0103008:	c0 ff e0                                            ...

c010300b <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c010300b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0103010:	bc 00 00 11 c0       	mov    $0xc0110000,%esp

	# now to C code

	call	main
c0103015:	e8 b1 e8 ff ff       	call   c01018cb <main>

c010301a <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c010301a:	eb fe                	jmp    c010301a <spin>

c010301c <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c010301c:	55                   	push   %ebp
c010301d:	89 e5                	mov    %esp,%ebp
c010301f:	53                   	push   %ebx
c0103020:	83 ec 04             	sub    $0x4,%esp
c0103023:	8b 45 08             	mov    0x8(%ebp),%eax
c0103026:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0103029:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c010302e:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0103032:	89 d3                	mov    %edx,%ebx
c0103034:	cd 80                	int    $0x80
}
c0103036:	83 c4 04             	add    $0x4,%esp
c0103039:	5b                   	pop    %ebx
c010303a:	5d                   	pop    %ebp
c010303b:	c3                   	ret    

c010303c <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c010303c:	55                   	push   %ebp
c010303d:	89 e5                	mov    %esp,%ebp
c010303f:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0103042:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103045:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0103048:	eb 19                	jmp    c0103063 <printp+0x27>
		printer(cur);
c010304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010304d:	0f b6 00             	movzbl (%eax),%eax
c0103050:	0f be c0             	movsbl %al,%eax
c0103053:	83 ec 0c             	sub    $0xc,%esp
c0103056:	50                   	push   %eax
c0103057:	8b 45 08             	mov    0x8(%ebp),%eax
c010305a:	ff d0                	call   *%eax
c010305c:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c010305f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103063:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103066:	0f b6 00             	movzbl (%eax),%eax
c0103069:	84 c0                	test   %al,%al
c010306b:	75 dd                	jne    c010304a <printp+0xe>
		printer(cur);
	}
}
c010306d:	c9                   	leave  
c010306e:	c3                   	ret    

c010306f <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c010306f:	55                   	push   %ebp
c0103070:	89 e5                	mov    %esp,%ebp
c0103072:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0103075:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103078:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c010307b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0103082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0103089:	8b 45 10             	mov    0x10(%ebp),%eax
c010308c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c010308f:	e9 65 02 00 00       	jmp    c01032f9 <vfprintf+0x28a>

		if(cur == '%'){
c0103094:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103097:	0f b6 00             	movzbl (%eax),%eax
c010309a:	3c 25                	cmp    $0x25,%al
c010309c:	75 0c                	jne    c01030aa <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c010309e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c01030a5:	e9 4b 02 00 00       	jmp    c01032f5 <vfprintf+0x286>
		}
		if(type == READ){
c01030aa:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c01030ae:	0f 85 26 02 00 00    	jne    c01032da <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c01030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030b7:	0f b6 00             	movzbl (%eax),%eax
c01030ba:	3c 73                	cmp    $0x73,%al
c01030bc:	75 35                	jne    c01030f3 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c01030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030c1:	8b 00                	mov    (%eax),%eax
c01030c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c01030c6:	eb 19                	jmp    c01030e1 <vfprintf+0x72>
					printer(*p);
c01030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030cb:	0f b6 00             	movzbl (%eax),%eax
c01030ce:	0f be c0             	movsbl %al,%eax
c01030d1:	83 ec 0c             	sub    $0xc,%esp
c01030d4:	50                   	push   %eax
c01030d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01030d8:	ff d0                	call   *%eax
c01030da:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c01030dd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c01030e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030e4:	0f b6 00             	movzbl (%eax),%eax
c01030e7:	84 c0                	test   %al,%al
c01030e9:	75 dd                	jne    c01030c8 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c01030eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01030ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c01030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030f6:	0f b6 00             	movzbl (%eax),%eax
c01030f9:	3c 78                	cmp    $0x78,%al
c01030fb:	0f 85 99 00 00 00    	jne    c010319a <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0103101:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103104:	8b 00                	mov    (%eax),%eax
c0103106:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0103109:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010310d:	75 1d                	jne    c010312c <vfprintf+0xbd>
					printer('0');
c010310f:	83 ec 0c             	sub    $0xc,%esp
c0103112:	6a 30                	push   $0x30
c0103114:	8b 45 08             	mov    0x8(%ebp),%eax
c0103117:	ff d0                	call   *%eax
c0103119:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c010311c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c0103120:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103127:	e9 c9 01 00 00       	jmp    c01032f5 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c010312c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c0103133:	eb 2d                	jmp    c0103162 <vfprintf+0xf3>
					int d=(x%16);
c0103135:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103138:	83 e0 0f             	and    $0xf,%eax
c010313b:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c010313e:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c0103142:	7e 04                	jle    c0103148 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0103144:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0103148:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010314b:	83 c0 30             	add    $0x30,%eax
c010314e:	89 c1                	mov    %eax,%ecx
c0103150:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103153:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103156:	01 d0                	add    %edx,%eax
c0103158:	88 08                	mov    %cl,(%eax)
					x>>=4;
c010315a:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c010315e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103162:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103166:	75 cd                	jne    c0103135 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0103168:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c010316c:	eb 1e                	jmp    c010318c <vfprintf+0x11d>
					printer(digits[di]);
c010316e:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c0103171:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103174:	01 d0                	add    %edx,%eax
c0103176:	0f b6 00             	movzbl (%eax),%eax
c0103179:	0f be c0             	movsbl %al,%eax
c010317c:	83 ec 0c             	sub    $0xc,%esp
c010317f:	50                   	push   %eax
c0103180:	8b 45 08             	mov    0x8(%ebp),%eax
c0103183:	ff d0                	call   *%eax
c0103185:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0103188:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c010318c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103190:	79 dc                	jns    c010316e <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c0103192:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103196:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c010319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010319d:	0f b6 00             	movzbl (%eax),%eax
c01031a0:	3c 64                	cmp    $0x64,%al
c01031a2:	0f 85 02 01 00 00    	jne    c01032aa <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c01031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031ab:	8b 00                	mov    (%eax),%eax
c01031ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c01031b0:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c01031b7:	75 23                	jne    c01031dc <vfprintf+0x16d>
					printp(printer, "-2147483648");
c01031b9:	83 ec 08             	sub    $0x8,%esp
c01031bc:	68 8a 35 10 c0       	push   $0xc010358a
c01031c1:	ff 75 08             	pushl  0x8(%ebp)
c01031c4:	e8 73 fe ff ff       	call   c010303c <printp>
c01031c9:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01031cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01031d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01031d7:	e9 19 01 00 00       	jmp    c01032f5 <vfprintf+0x286>
				}
				if(x==0){
c01031dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01031e0:	75 1e                	jne    c0103200 <vfprintf+0x191>
					printer('0');
c01031e2:	83 ec 0c             	sub    $0xc,%esp
c01031e5:	6a 30                	push   $0x30
c01031e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01031ea:	ff d0                	call   *%eax
c01031ec:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01031ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01031f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01031fa:	90                   	nop
c01031fb:	e9 f5 00 00 00       	jmp    c01032f5 <vfprintf+0x286>
				}
				if(x<0){
c0103200:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103204:	79 10                	jns    c0103216 <vfprintf+0x1a7>
					printer('-');
c0103206:	83 ec 0c             	sub    $0xc,%esp
c0103209:	6a 2d                	push   $0x2d
c010320b:	8b 45 08             	mov    0x8(%ebp),%eax
c010320e:	ff d0                	call   *%eax
c0103210:	83 c4 10             	add    $0x10,%esp
					x=-x;
c0103213:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0103216:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c010321d:	eb 53                	jmp    c0103272 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c010321f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103222:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0103227:	89 c8                	mov    %ecx,%eax
c0103229:	f7 ea                	imul   %edx
c010322b:	c1 fa 02             	sar    $0x2,%edx
c010322e:	89 c8                	mov    %ecx,%eax
c0103230:	c1 f8 1f             	sar    $0x1f,%eax
c0103233:	29 c2                	sub    %eax,%edx
c0103235:	89 d0                	mov    %edx,%eax
c0103237:	c1 e0 02             	shl    $0x2,%eax
c010323a:	01 d0                	add    %edx,%eax
c010323c:	01 c0                	add    %eax,%eax
c010323e:	29 c1                	sub    %eax,%ecx
c0103240:	89 ca                	mov    %ecx,%edx
c0103242:	89 d0                	mov    %edx,%eax
c0103244:	83 c0 30             	add    $0x30,%eax
c0103247:	89 c1                	mov    %eax,%ecx
c0103249:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c010324c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010324f:	01 d0                	add    %edx,%eax
c0103251:	88 08                	mov    %cl,(%eax)
					x/=10;
c0103253:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103256:	ba 67 66 66 66       	mov    $0x66666667,%edx
c010325b:	89 c8                	mov    %ecx,%eax
c010325d:	f7 ea                	imul   %edx
c010325f:	c1 fa 02             	sar    $0x2,%edx
c0103262:	89 c8                	mov    %ecx,%eax
c0103264:	c1 f8 1f             	sar    $0x1f,%eax
c0103267:	29 c2                	sub    %eax,%edx
c0103269:	89 d0                	mov    %edx,%eax
c010326b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010326e:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c0103272:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103276:	7f a7                	jg     c010321f <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0103278:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c010327c:	eb 1e                	jmp    c010329c <vfprintf+0x22d>
					printer(digits[di]);
c010327e:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0103281:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103284:	01 d0                	add    %edx,%eax
c0103286:	0f b6 00             	movzbl (%eax),%eax
c0103289:	0f be c0             	movsbl %al,%eax
c010328c:	83 ec 0c             	sub    $0xc,%esp
c010328f:	50                   	push   %eax
c0103290:	8b 45 08             	mov    0x8(%ebp),%eax
c0103293:	ff d0                	call   *%eax
c0103295:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0103298:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c010329c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01032a0:	79 dc                	jns    c010327e <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c01032a2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01032a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c01032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ad:	0f b6 00             	movzbl (%eax),%eax
c01032b0:	3c 63                	cmp    $0x63,%al
c01032b2:	75 1d                	jne    c01032d1 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c01032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032b7:	0f b6 00             	movzbl (%eax),%eax
c01032ba:	0f be c0             	movsbl %al,%eax
c01032bd:	83 ec 0c             	sub    $0xc,%esp
c01032c0:	50                   	push   %eax
c01032c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01032c4:	ff d0                	call   *%eax
c01032c6:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c01032c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01032cd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c01032d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c01032d8:	eb 1b                	jmp    c01032f5 <vfprintf+0x286>
		}
		if(type == NONE){
c01032da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01032de:	75 15                	jne    c01032f5 <vfprintf+0x286>
			printer(cur);
c01032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e3:	0f b6 00             	movzbl (%eax),%eax
c01032e6:	0f be c0             	movsbl %al,%eax
c01032e9:	83 ec 0c             	sub    $0xc,%esp
c01032ec:	50                   	push   %eax
c01032ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01032f0:	ff d0                	call   *%eax
c01032f2:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01032f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fc:	0f b6 00             	movzbl (%eax),%eax
c01032ff:	84 c0                	test   %al,%al
c0103301:	0f 85 8d fd ff ff    	jne    c0103094 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0103307:	c9                   	leave  
c0103308:	c3                   	ret    

c0103309 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0103309:	55                   	push   %ebp
c010330a:	89 e5                	mov    %esp,%ebp
c010330c:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010330f:	8d 45 0c             	lea    0xc(%ebp),%eax
c0103312:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0103315:	8b 45 08             	mov    0x8(%ebp),%eax
c0103318:	83 ec 04             	sub    $0x4,%esp
c010331b:	ff 75 f4             	pushl  -0xc(%ebp)
c010331e:	50                   	push   %eax
c010331f:	68 1c 30 10 c0       	push   $0xc010301c
c0103324:	e8 46 fd ff ff       	call   c010306f <vfprintf>
c0103329:	83 c4 10             	add    $0x10,%esp
}
c010332c:	c9                   	leave  
c010332d:	c3                   	ret    
