
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
c01000ba:	e8 ac 3e 00 00       	call   c0103f6b <vfprintf>
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
c01000f0:	68 2c 42 10 c0       	push   $0xc010422c
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
c0100371:	68 4f 42 10 c0       	push   $0xc010424f
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
c0100415:	68 4f 42 10 c0       	push   $0xc010424f
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
c0100448:	b8 cb 3e 10 c0       	mov    $0xc0103ecb,%eax
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
c0100583:	e8 e3 39 00 00       	call   c0103f6b <vfprintf>
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
c01005d6:	68 68 42 10 c0       	push   $0xc0104268
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
c010060c:	68 8c 42 10 c0       	push   $0xc010428c
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
c010064e:	68 b0 42 10 c0       	push   $0xc01042b0
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
c0100682:	68 cf 42 10 c0       	push   $0xc01042cf
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
c010074d:	68 e5 42 10 c0       	push   $0xc01042e5
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
c01007ae:	68 e5 42 10 c0       	push   $0xc01042e5
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
c010089a:	68 00 43 10 c0       	push   $0xc0104300
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
c010097f:	68 e5 42 10 c0       	push   $0xc01042e5
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
c01009fb:	68 e5 42 10 c0       	push   $0xc01042e5
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
c0100b9d:	68 e5 42 10 c0       	push   $0xc01042e5
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
c0100c27:	68 e5 42 10 c0       	push   $0xc01042e5
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
c0100cd9:	68 e5 42 10 c0       	push   $0xc01042e5
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
c0100e4f:	68 e5 42 10 c0       	push   $0xc01042e5
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
c0100f53:	e8 40 23 00 00       	call   c0103298 <ll_pop>
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
c0100f71:	e8 84 23 00 00       	call   c01032fa <ll_entail>
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
c0100fb1:	e8 e2 22 00 00       	call   c0103298 <ll_pop>
c0100fb6:	83 c4 10             	add    $0x10,%esp
c0100fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		ll_entail(&ready_list, pcb);
c0100fbc:	83 ec 08             	sub    $0x8,%esp
c0100fbf:	ff 75 f4             	pushl  -0xc(%ebp)
c0100fc2:	68 b0 60 15 c0       	push   $0xc01560b0
c0100fc7:	e8 2e 23 00 00       	call   c01032fa <ll_entail>
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
c0101010:	e8 e5 22 00 00       	call   c01032fa <ll_entail>
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
c01010cf:	e8 c4 21 00 00       	call   c0103298 <ll_pop>
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
c010112e:	e8 c7 21 00 00       	call   c01032fa <ll_entail>
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
c0101184:	e8 71 21 00 00       	call   c01032fa <ll_entail>
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
c01011d0:	e8 cd 1b 00 00       	call   c0102da2 <do_syscall>
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
c01011e5:	e8 59 2b 00 00       	call   c0103d43 <do_timer>
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
c010126f:	e8 54 1a 00 00       	call   c0102cc8 <press_key>
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
c01013d2:	ba a9 3e 10 c0       	mov    $0xc0103ea9,%edx
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
c01013fd:	b8 f1 3d 10 c0       	mov    $0xc0103df1,%eax
c0101402:	6a 00                	push   $0x0
c0101404:	50                   	push   %eax
c0101405:	6a 01                	push   $0x1
c0101407:	68 40 89 1b c0       	push   $0xc01b8940
c010140c:	e8 35 ff ff ff       	call   c0101346 <set_trap>
c0101411:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
c0101414:	b8 fa 3d 10 c0       	mov    $0xc0103dfa,%eax
c0101419:	6a 00                	push   $0x0
c010141b:	50                   	push   %eax
c010141c:	6a 01                	push   $0x1
c010141e:	68 48 89 1b c0       	push   $0xc01b8948
c0101423:	e8 1e ff ff ff       	call   c0101346 <set_trap>
c0101428:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
c010142b:	b8 03 3e 10 c0       	mov    $0xc0103e03,%eax
c0101430:	6a 00                	push   $0x0
c0101432:	50                   	push   %eax
c0101433:	6a 01                	push   $0x1
c0101435:	68 50 89 1b c0       	push   $0xc01b8950
c010143a:	e8 07 ff ff ff       	call   c0101346 <set_trap>
c010143f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
c0101442:	b8 0c 3e 10 c0       	mov    $0xc0103e0c,%eax
c0101447:	6a 00                	push   $0x0
c0101449:	50                   	push   %eax
c010144a:	6a 01                	push   $0x1
c010144c:	68 58 89 1b c0       	push   $0xc01b8958
c0101451:	e8 f0 fe ff ff       	call   c0101346 <set_trap>
c0101456:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
c0101459:	b8 15 3e 10 c0       	mov    $0xc0103e15,%eax
c010145e:	6a 00                	push   $0x0
c0101460:	50                   	push   %eax
c0101461:	6a 01                	push   $0x1
c0101463:	68 60 89 1b c0       	push   $0xc01b8960
c0101468:	e8 d9 fe ff ff       	call   c0101346 <set_trap>
c010146d:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
c0101470:	b8 1e 3e 10 c0       	mov    $0xc0103e1e,%eax
c0101475:	6a 00                	push   $0x0
c0101477:	50                   	push   %eax
c0101478:	6a 01                	push   $0x1
c010147a:	68 68 89 1b c0       	push   $0xc01b8968
c010147f:	e8 c2 fe ff ff       	call   c0101346 <set_trap>
c0101484:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
c0101487:	b8 27 3e 10 c0       	mov    $0xc0103e27,%eax
c010148c:	6a 00                	push   $0x0
c010148e:	50                   	push   %eax
c010148f:	6a 01                	push   $0x1
c0101491:	68 70 89 1b c0       	push   $0xc01b8970
c0101496:	e8 ab fe ff ff       	call   c0101346 <set_trap>
c010149b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
c010149e:	b8 30 3e 10 c0       	mov    $0xc0103e30,%eax
c01014a3:	6a 00                	push   $0x0
c01014a5:	50                   	push   %eax
c01014a6:	6a 01                	push   $0x1
c01014a8:	68 78 89 1b c0       	push   $0xc01b8978
c01014ad:	e8 94 fe ff ff       	call   c0101346 <set_trap>
c01014b2:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
c01014b5:	b8 39 3e 10 c0       	mov    $0xc0103e39,%eax
c01014ba:	6a 00                	push   $0x0
c01014bc:	50                   	push   %eax
c01014bd:	6a 01                	push   $0x1
c01014bf:	68 80 89 1b c0       	push   $0xc01b8980
c01014c4:	e8 7d fe ff ff       	call   c0101346 <set_trap>
c01014c9:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
c01014cc:	b8 42 3e 10 c0       	mov    $0xc0103e42,%eax
c01014d1:	6a 00                	push   $0x0
c01014d3:	50                   	push   %eax
c01014d4:	6a 01                	push   $0x1
c01014d6:	68 88 89 1b c0       	push   $0xc01b8988
c01014db:	e8 66 fe ff ff       	call   c0101346 <set_trap>
c01014e0:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
c01014e3:	b8 4b 3e 10 c0       	mov    $0xc0103e4b,%eax
c01014e8:	6a 00                	push   $0x0
c01014ea:	50                   	push   %eax
c01014eb:	6a 01                	push   $0x1
c01014ed:	68 90 89 1b c0       	push   $0xc01b8990
c01014f2:	e8 4f fe ff ff       	call   c0101346 <set_trap>
c01014f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
c01014fa:	b8 54 3e 10 c0       	mov    $0xc0103e54,%eax
c01014ff:	6a 00                	push   $0x0
c0101501:	50                   	push   %eax
c0101502:	6a 01                	push   $0x1
c0101504:	68 98 89 1b c0       	push   $0xc01b8998
c0101509:	e8 38 fe ff ff       	call   c0101346 <set_trap>
c010150e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
c0101511:	b8 5d 3e 10 c0       	mov    $0xc0103e5d,%eax
c0101516:	6a 00                	push   $0x0
c0101518:	50                   	push   %eax
c0101519:	6a 01                	push   $0x1
c010151b:	68 a0 89 1b c0       	push   $0xc01b89a0
c0101520:	e8 21 fe ff ff       	call   c0101346 <set_trap>
c0101525:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
c0101528:	b8 66 3e 10 c0       	mov    $0xc0103e66,%eax
c010152d:	6a 00                	push   $0x0
c010152f:	50                   	push   %eax
c0101530:	6a 01                	push   $0x1
c0101532:	68 a8 89 1b c0       	push   $0xc01b89a8
c0101537:	e8 0a fe ff ff       	call   c0101346 <set_trap>
c010153c:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
c010153f:	b8 78 3e 10 c0       	mov    $0xc0103e78,%eax
c0101544:	6a 03                	push   $0x3
c0101546:	50                   	push   %eax
c0101547:	6a 01                	push   $0x1
c0101549:	68 40 8d 1b c0       	push   $0xc01b8d40
c010154e:	e8 f3 fd ff ff       	call   c0101346 <set_trap>
c0101553:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
c0101556:	b8 85 3e 10 c0       	mov    $0xc0103e85,%eax
c010155b:	6a 00                	push   $0x0
c010155d:	50                   	push   %eax
c010155e:	6a 01                	push   $0x1
c0101560:	68 40 8a 1b c0       	push   $0xc01b8a40
c0101565:	e8 5c fd ff ff       	call   c01012c6 <set_intr>
c010156a:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
c010156d:	b8 91 3e 10 c0       	mov    $0xc0103e91,%eax
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
c010160e:	e8 58 29 00 00       	call   c0103f6b <vfprintf>
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

c0101635 <strcmp>:

static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
c0101635:	55                   	push   %ebp
c0101636:	89 e5                	mov    %esp,%ebp
    while(*s1 && (*s1==*s2))
c0101638:	eb 08                	jmp    c0101642 <strcmp+0xd>
        s1++,s2++;
c010163a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010163e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
c0101642:	8b 45 08             	mov    0x8(%ebp),%eax
c0101645:	0f b6 00             	movzbl (%eax),%eax
c0101648:	84 c0                	test   %al,%al
c010164a:	74 10                	je     c010165c <strcmp+0x27>
c010164c:	8b 45 08             	mov    0x8(%ebp),%eax
c010164f:	0f b6 10             	movzbl (%eax),%edx
c0101652:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101655:	0f b6 00             	movzbl (%eax),%eax
c0101658:	38 c2                	cmp    %al,%dl
c010165a:	74 de                	je     c010163a <strcmp+0x5>
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
c010165c:	8b 45 08             	mov    0x8(%ebp),%eax
c010165f:	0f b6 00             	movzbl (%eax),%eax
c0101662:	0f b6 d0             	movzbl %al,%edx
c0101665:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101668:	0f b6 00             	movzbl (%eax),%eax
c010166b:	0f b6 c0             	movzbl %al,%eax
c010166e:	29 c2                	sub    %eax,%edx
c0101670:	89 d0                	mov    %edx,%eax
}
c0101672:	5d                   	pop    %ebp
c0101673:	c3                   	ret    

c0101674 <strcpy>:
static inline void strcpy(char* dest, const char* source) 
{
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
c0101677:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
c010167a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
c0101681:	eb 04                	jmp    c0101687 <strcpy+0x13>
    {
        i++;
c0101683:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
c0101687:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010168a:	8b 45 08             	mov    0x8(%ebp),%eax
c010168d:	01 d0                	add    %edx,%eax
c010168f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
c0101692:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101695:	01 ca                	add    %ecx,%edx
c0101697:	0f b6 12             	movzbl (%edx),%edx
c010169a:	88 10                	mov    %dl,(%eax)
c010169c:	0f b6 00             	movzbl (%eax),%eax
c010169f:	84 c0                	test   %al,%al
c01016a1:	75 e0                	jne    c0101683 <strcpy+0xf>
    {
        i++;
    } 
}
c01016a3:	c9                   	leave  
c01016a4:	c3                   	ret    

c01016a5 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c01016a5:	55                   	push   %ebp
c01016a6:	89 e5                	mov    %esp,%ebp
c01016a8:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c01016ab:	90                   	nop
c01016ac:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01016b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016b6:	89 c2                	mov    %eax,%edx
c01016b8:	ec                   	in     (%dx),%al
c01016b9:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01016bc:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016c0:	0f b6 c0             	movzbl %al,%eax
c01016c3:	25 c0 00 00 00       	and    $0xc0,%eax
c01016c8:	83 f8 40             	cmp    $0x40,%eax
c01016cb:	75 df                	jne    c01016ac <waitdisk+0x7>
}
c01016cd:	c9                   	leave  
c01016ce:	c3                   	ret    

c01016cf <readsect>:

static inline void
readsect(void *dst, int offset) {
c01016cf:	55                   	push   %ebp
c01016d0:	89 e5                	mov    %esp,%ebp
c01016d2:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01016d5:	e8 cb ff ff ff       	call   c01016a5 <waitdisk>
c01016da:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01016e1:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01016e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01016e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01016ec:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01016ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01016fa:	88 45 ef             	mov    %al,-0x11(%ebp)
c01016fd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0101701:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c0101705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101708:	c1 f8 08             	sar    $0x8,%eax
c010170b:	0f b6 c0             	movzbl %al,%eax
c010170e:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c0101715:	88 45 e7             	mov    %al,-0x19(%ebp)
c0101718:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010171c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010171f:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c0101720:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101723:	c1 f8 10             	sar    $0x10,%eax
c0101726:	0f b6 c0             	movzbl %al,%eax
c0101729:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c0101730:	88 45 df             	mov    %al,-0x21(%ebp)
c0101733:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101737:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010173a:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c010173b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010173e:	c1 f8 18             	sar    $0x18,%eax
c0101741:	83 c8 e0             	or     $0xffffffe0,%eax
c0101744:	0f b6 c0             	movzbl %al,%eax
c0101747:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010174e:	88 45 d7             	mov    %al,-0x29(%ebp)
c0101751:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101755:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101758:	ee                   	out    %al,(%dx)
c0101759:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c0101760:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c0101764:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101768:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010176b:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c010176c:	e8 34 ff ff ff       	call   c01016a5 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101771:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101778:	eb 29                	jmp    c01017a3 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c010177a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010177d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101784:	8b 45 08             	mov    0x8(%ebp),%eax
c0101787:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c010178a:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0101791:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101794:	89 c2                	mov    %eax,%edx
c0101796:	ed                   	in     (%dx),%eax
c0101797:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c010179a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010179d:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010179f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01017a3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01017a7:	7e d1                	jle    c010177a <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c01017a9:	c9                   	leave  
c01017aa:	c3                   	ret    

c01017ab <writesect>:
static inline void
writesect(void *dst, int offset) {
c01017ab:	55                   	push   %ebp
c01017ac:	89 e5                	mov    %esp,%ebp
c01017ae:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c01017b1:	e8 ef fe ff ff       	call   c01016a5 <waitdisk>
c01017b6:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c01017bd:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01017c1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01017c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01017c8:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c01017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017cc:	0f b6 c0             	movzbl %al,%eax
c01017cf:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c01017d6:	88 45 ef             	mov    %al,-0x11(%ebp)
c01017d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01017dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c01017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017e4:	c1 f8 08             	sar    $0x8,%eax
c01017e7:	0f b6 c0             	movzbl %al,%eax
c01017ea:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c01017f1:	88 45 e7             	mov    %al,-0x19(%ebp)
c01017f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01017f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01017fb:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01017ff:	c1 f8 10             	sar    $0x10,%eax
c0101802:	0f b6 c0             	movzbl %al,%eax
c0101805:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c010180c:	88 45 df             	mov    %al,-0x21(%ebp)
c010180f:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101813:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0101816:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c0101817:	8b 45 0c             	mov    0xc(%ebp),%eax
c010181a:	c1 f8 18             	sar    $0x18,%eax
c010181d:	83 c8 e0             	or     $0xffffffe0,%eax
c0101820:	0f b6 c0             	movzbl %al,%eax
c0101823:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c010182a:	88 45 d7             	mov    %al,-0x29(%ebp)
c010182d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101831:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101834:	ee                   	out    %al,(%dx)
c0101835:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c010183c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
c0101840:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c0101844:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101847:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x30);

    waitdisk();
c0101848:	e8 58 fe ff ff       	call   c01016a5 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c010184d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101854:	eb 26                	jmp    c010187c <writesect+0xd1>
        outl(0x1F0, ((int *)(dst))[i]);
c0101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101859:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101860:	8b 45 08             	mov    0x8(%ebp),%eax
c0101863:	01 d0                	add    %edx,%eax
c0101865:	8b 00                	mov    (%eax),%eax
c0101867:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)
c010186e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
c0101871:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101874:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0101877:	ef                   	out    %eax,(%dx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x30);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0101878:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010187c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101880:	7e d4                	jle    c0101856 <writesect+0xab>
        outl(0x1F0, ((int *)(dst))[i]);
    }
}
c0101882:	c9                   	leave  
c0101883:	c3                   	ret    

c0101884 <readBitmap>:
struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
c0101884:	55                   	push   %ebp
c0101885:	89 e5                	mov    %esp,%ebp
c0101887:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c010188a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101891:	eb 22                	jmp    c01018b5 <readBitmap+0x31>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c0101893:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101896:	c1 e0 09             	shl    $0x9,%eax
c0101899:	8d 50 01             	lea    0x1(%eax),%edx
c010189c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010189f:	c1 e0 09             	shl    $0x9,%eax
c01018a2:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01018a7:	52                   	push   %edx
c01018a8:	50                   	push   %eax
c01018a9:	e8 21 fe ff ff       	call   c01016cf <readsect>
c01018ae:	83 c4 08             	add    $0x8,%esp
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018b5:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01018bc:	7e d5                	jle    c0101893 <readBitmap+0xf>
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c01018be:	c9                   	leave  
c01018bf:	c3                   	ret    

c01018c0 <saveBitmap>:

void saveBitmap(){
c01018c0:	55                   	push   %ebp
c01018c1:	89 e5                	mov    %esp,%ebp
c01018c3:	83 ec 10             	sub    $0x10,%esp
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018cd:	eb 22                	jmp    c01018f1 <saveBitmap+0x31>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
c01018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d2:	c1 e0 09             	shl    $0x9,%eax
c01018d5:	8d 50 01             	lea    0x1(%eax),%edx
c01018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018db:	c1 e0 09             	shl    $0x9,%eax
c01018de:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01018e3:	52                   	push   %edx
c01018e4:	50                   	push   %eax
c01018e5:	e8 c1 fe ff ff       	call   c01017ab <writesect>
c01018ea:	83 c4 08             	add    $0x8,%esp
	}
}

void saveBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
c01018ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018f1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01018f8:	7e d5                	jle    c01018cf <saveBitmap+0xf>
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
c01018fa:	c9                   	leave  
c01018fb:	c3                   	ret    

c01018fc <readDir>:
void readDir(int offset){
c01018fc:	55                   	push   %ebp
c01018fd:	89 e5                	mov    %esp,%ebp
	readsect(dir.entries, LOC_DIR(offset));
c01018ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101902:	05 01 01 00 00       	add    $0x101,%eax
c0101907:	50                   	push   %eax
c0101908:	68 40 d8 1d c0       	push   $0xc01dd840
c010190d:	e8 bd fd ff ff       	call   c01016cf <readsect>
c0101912:	83 c4 08             	add    $0x8,%esp
}
c0101915:	c9                   	leave  
c0101916:	c3                   	ret    

c0101917 <saveDir>:
void saveDir(int offset){
c0101917:	55                   	push   %ebp
c0101918:	89 e5                	mov    %esp,%ebp
	writesect(dir.entries, LOC_DIR(offset));
c010191a:	8b 45 08             	mov    0x8(%ebp),%eax
c010191d:	05 01 01 00 00       	add    $0x101,%eax
c0101922:	50                   	push   %eax
c0101923:	68 40 d8 1d c0       	push   $0xc01dd840
c0101928:	e8 7e fe ff ff       	call   c01017ab <writesect>
c010192d:	83 c4 08             	add    $0x8,%esp
}
c0101930:	c9                   	leave  
c0101931:	c3                   	ret    

c0101932 <readINode>:
void readINode(int offset){
c0101932:	55                   	push   %ebp
c0101933:	89 e5                	mov    %esp,%ebp
	readsect(inode.data_block_offsets, LOC_INODE(offset));
c0101935:	8b 45 08             	mov    0x8(%ebp),%eax
c0101938:	05 01 02 00 00       	add    $0x201,%eax
c010193d:	50                   	push   %eax
c010193e:	68 40 da 1d c0       	push   $0xc01dda40
c0101943:	e8 87 fd ff ff       	call   c01016cf <readsect>
c0101948:	83 c4 08             	add    $0x8,%esp
}
c010194b:	c9                   	leave  
c010194c:	c3                   	ret    

c010194d <saveINode>:
void saveINode(int offset){
c010194d:	55                   	push   %ebp
c010194e:	89 e5                	mov    %esp,%ebp
	writesect(inode.data_block_offsets, LOC_INODE(offset));
c0101950:	8b 45 08             	mov    0x8(%ebp),%eax
c0101953:	05 01 02 00 00       	add    $0x201,%eax
c0101958:	50                   	push   %eax
c0101959:	68 40 da 1d c0       	push   $0xc01dda40
c010195e:	e8 48 fe ff ff       	call   c01017ab <writesect>
c0101963:	83 c4 08             	add    $0x8,%esp
}
c0101966:	c9                   	leave  
c0101967:	c3                   	ret    

c0101968 <readData>:
void readData(int offset){
c0101968:	55                   	push   %ebp
c0101969:	89 e5                	mov    %esp,%ebp
	readsect(buffer, LOC_DATA(offset));
c010196b:	8b 45 08             	mov    0x8(%ebp),%eax
c010196e:	05 01 03 00 00       	add    $0x301,%eax
c0101973:	50                   	push   %eax
c0101974:	68 40 d6 1d c0       	push   $0xc01dd640
c0101979:	e8 51 fd ff ff       	call   c01016cf <readsect>
c010197e:	83 c4 08             	add    $0x8,%esp
}
c0101981:	c9                   	leave  
c0101982:	c3                   	ret    

c0101983 <saveData>:
void saveData(int offset){
c0101983:	55                   	push   %ebp
c0101984:	89 e5                	mov    %esp,%ebp
	writesect(buffer, LOC_DATA(offset));
c0101986:	8b 45 08             	mov    0x8(%ebp),%eax
c0101989:	05 01 03 00 00       	add    $0x301,%eax
c010198e:	50                   	push   %eax
c010198f:	68 40 d6 1d c0       	push   $0xc01dd640
c0101994:	e8 12 fe ff ff       	call   c01017ab <writesect>
c0101999:	83 c4 08             	add    $0x8,%esp
}
c010199c:	c9                   	leave  
c010199d:	c3                   	ret    

c010199e <INodeAlloc>:
int INodeAlloc(){
c010199e:	55                   	push   %ebp
c010199f:	89 e5                	mov    %esp,%ebp
c01019a1:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c01019a4:	e8 db fe ff ff       	call   c0101884 <readBitmap>
	int i = 0;
c01019a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_INODE; i++){
c01019b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019b7:	eb 69                	jmp    c0101a22 <INodeAlloc+0x84>
		int sec = LOC_INODE(i);
c01019b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bc:	05 01 02 00 00       	add    $0x201,%eax
c01019c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c01019c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019c7:	c1 f8 03             	sar    $0x3,%eax
c01019ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c01019cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019d0:	83 e0 07             	and    $0x7,%eax
c01019d3:	ba 01 00 00 00       	mov    $0x1,%edx
c01019d8:	89 c1                	mov    %eax,%ecx
c01019da:	d3 e2                	shl    %cl,%edx
c01019dc:	89 d0                	mov    %edx,%eax
c01019de:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c01019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019e4:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01019e9:	0f b6 00             	movzbl (%eax),%eax
c01019ec:	0f b6 c0             	movzbl %al,%eax
c01019ef:	23 45 f0             	and    -0x10(%ebp),%eax
c01019f2:	85 c0                	test   %eax,%eax
c01019f4:	75 28                	jne    c0101a1e <INodeAlloc+0x80>
			bitmap.mask[secN] |= secR;
c01019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019f9:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c01019fe:	0f b6 00             	movzbl (%eax),%eax
c0101a01:	89 c2                	mov    %eax,%edx
c0101a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a06:	09 d0                	or     %edx,%eax
c0101a08:	89 c2                	mov    %eax,%edx
c0101a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a0d:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a12:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101a14:	e8 a7 fe ff ff       	call   c01018c0 <saveBitmap>
			return i;
c0101a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1c:	eb 12                	jmp    c0101a30 <INodeAlloc+0x92>
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
c0101a1e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a22:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a29:	7e 8e                	jle    c01019b9 <INodeAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101a2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101a30:	c9                   	leave  
c0101a31:	c3                   	ret    

c0101a32 <dataAlloc>:
int dataAlloc(){
c0101a32:	55                   	push   %ebp
c0101a33:	89 e5                	mov    %esp,%ebp
c0101a35:	83 ec 10             	sub    $0x10,%esp
	readBitmap();
c0101a38:	e8 47 fe ff ff       	call   c0101884 <readBitmap>
	int i = 0;
c0101a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < SC_DATA; i++){
c0101a44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a4b:	eb 69                	jmp    c0101ab6 <dataAlloc+0x84>
		int sec = LOC_DATA(i);
c0101a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a50:	05 01 03 00 00       	add    $0x301,%eax
c0101a55:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int secN = sec>>3;
c0101a58:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a5b:	c1 f8 03             	sar    $0x3,%eax
c0101a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int secR = 1<<(sec&0x7);
c0101a61:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a64:	83 e0 07             	and    $0x7,%eax
c0101a67:	ba 01 00 00 00       	mov    $0x1,%edx
c0101a6c:	89 c1                	mov    %eax,%ecx
c0101a6e:	d3 e2                	shl    %cl,%edx
c0101a70:	89 d0                	mov    %edx,%eax
c0101a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
c0101a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a78:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a7d:	0f b6 00             	movzbl (%eax),%eax
c0101a80:	0f b6 c0             	movzbl %al,%eax
c0101a83:	23 45 f0             	and    -0x10(%ebp),%eax
c0101a86:	85 c0                	test   %eax,%eax
c0101a88:	75 28                	jne    c0101ab2 <dataAlloc+0x80>
			bitmap.mask[secN] |= secR;
c0101a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a8d:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101a92:	0f b6 00             	movzbl (%eax),%eax
c0101a95:	89 c2                	mov    %eax,%edx
c0101a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a9a:	09 d0                	or     %edx,%eax
c0101a9c:	89 c2                	mov    %eax,%edx
c0101a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101aa1:	05 40 91 1b c0       	add    $0xc01b9140,%eax
c0101aa6:	88 10                	mov    %dl,(%eax)
			saveBitmap();
c0101aa8:	e8 13 fe ff ff       	call   c01018c0 <saveBitmap>
			return i;
c0101aad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101ab0:	eb 12                	jmp    c0101ac4 <dataAlloc+0x92>
	return -1;
}
int dataAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
c0101ab2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101ab6:	81 7d fc ff 7f 00 00 	cmpl   $0x7fff,-0x4(%ebp)
c0101abd:	7e 8e                	jle    c0101a4d <dataAlloc+0x1b>
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
c0101abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c0101ac4:	c9                   	leave  
c0101ac5:	c3                   	ret    

c0101ac6 <fs_open_kr>:

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
c0101ac6:	55                   	push   %ebp
c0101ac7:	89 e5                	mov    %esp,%ebp
c0101ac9:	83 ec 10             	sub    $0x10,%esp
	int dir_offset = 0, entry_offset = 0;
c0101acc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101ad3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(dir_offset < SC_DIR){
c0101ada:	eb 4c                	jmp    c0101b28 <fs_open_kr+0x62>
		readDir(dir_offset);
c0101adc:	ff 75 fc             	pushl  -0x4(%ebp)
c0101adf:	e8 18 fe ff ff       	call   c01018fc <readDir>
c0101ae4:	83 c4 04             	add    $0x4,%esp

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101ae7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101aee:	eb 2c                	jmp    c0101b1c <fs_open_kr+0x56>
			//printk("%d %d", dir_offset, entry_offset);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
c0101af0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101af3:	c1 e0 05             	shl    $0x5,%eax
c0101af6:	05 40 d8 1d c0       	add    $0xc01dd840,%eax
c0101afb:	ff 75 08             	pushl  0x8(%ebp)
c0101afe:	50                   	push   %eax
c0101aff:	e8 31 fb ff ff       	call   c0101635 <strcmp>
c0101b04:	83 c4 08             	add    $0x8,%esp
c0101b07:	85 c0                	test   %eax,%eax
c0101b09:	75 0d                	jne    c0101b18 <fs_open_kr+0x52>
				goto OUT_OF_LOOP;
c0101b0b:	90                   	nop
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101b0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b13:	e9 fa 00 00 00       	jmp    c0101c12 <fs_open_kr+0x14c>
int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
c0101b18:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b1f:	83 f8 0f             	cmp    $0xf,%eax
c0101b22:	76 cc                	jbe    c0101af0 <fs_open_kr+0x2a>
			//printk("%d %d", dir_offset, entry_offset);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
c0101b24:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
c0101b28:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101b2f:	7e ab                	jle    c0101adc <fs_open_kr+0x16>
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
c0101b31:	90                   	nop
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
c0101b32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101b37:	e9 e5 00 00 00       	jmp    c0101c21 <fs_open_kr+0x15b>
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
c0101b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b3f:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101b45:	05 20 02 00 00       	add    $0x220,%eax
c0101b4a:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b4f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0101b53:	84 c0                	test   %al,%al
c0101b55:	0f 85 b3 00 00 00    	jne    c0101c0e <fs_open_kr+0x148>
			fs[i].used = 1;
c0101b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b5e:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101b64:	05 20 02 00 00       	add    $0x220,%eax
c0101b69:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101b6e:	c6 40 04 01          	movb   $0x1,0x4(%eax)
			fs[i].file_size = dir.entries[entry_offset].file_size;
c0101b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b75:	c1 e0 05             	shl    $0x5,%eax
c0101b78:	83 c0 10             	add    $0x10,%eax
c0101b7b:	05 40 d8 1d c0       	add    $0xc01dd840,%eax
c0101b80:	8b 40 08             	mov    0x8(%eax),%eax
c0101b83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b86:	69 d2 28 02 00 00    	imul   $0x228,%edx,%edx
c0101b8c:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101b92:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101b98:	89 42 08             	mov    %eax,0x8(%edx)
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
c0101b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b9e:	c1 e0 05             	shl    $0x5,%eax
c0101ba1:	8d 90 40 d8 1d c0    	lea    -0x3fe227c0(%eax),%edx
c0101ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101baa:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101bb0:	05 00 02 00 00       	add    $0x200,%eax
c0101bb5:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101bba:	83 c0 0c             	add    $0xc,%eax
c0101bbd:	52                   	push   %edx
c0101bbe:	50                   	push   %eax
c0101bbf:	e8 b0 fa ff ff       	call   c0101674 <strcpy>
c0101bc4:	83 c4 08             	add    $0x8,%esp
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
c0101bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bca:	c1 e0 05             	shl    $0x5,%eax
c0101bcd:	83 c0 10             	add    $0x10,%eax
c0101bd0:	05 40 d8 1d c0       	add    $0xc01dd840,%eax
c0101bd5:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bdb:	69 d2 28 02 00 00    	imul   $0x228,%edx,%edx
c0101be1:	81 c2 00 02 00 00    	add    $0x200,%edx
c0101be7:	81 c2 40 91 1d c0    	add    $0xc01d9140,%edx
c0101bed:	89 42 04             	mov    %eax,0x4(%edx)
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
c0101bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf3:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101bf9:	05 00 02 00 00       	add    $0x200,%eax
c0101bfe:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
c0101c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0c:	eb 13                	jmp    c0101c21 <fs_open_kr+0x15b>
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
c0101c0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c12:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c0101c16:	0f 8e 20 ff ff ff    	jle    c0101b3c <fs_open_kr+0x76>
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
c0101c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	FAILURE:
	return -1;
}
c0101c21:	c9                   	leave  
c0101c22:	c3                   	ret    

c0101c23 <fs_read_base_kr>:
void fs_read_base_kr(int fd, void* buf, int32_t len){
c0101c23:	55                   	push   %ebp
c0101c24:	89 e5                	mov    %esp,%ebp
c0101c26:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2c:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101c32:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101c37:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c3d:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101c43:	50                   	push   %eax
c0101c44:	e8 e9 fc ff ff       	call   c0101932 <readINode>
c0101c49:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101c53:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c56:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c5c:	c1 e8 09             	shr    $0x9,%eax
c0101c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101c65:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101c6b:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101c73:	8b 55 10             	mov    0x10(%ebp),%edx
c0101c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c79:	01 d0                	add    %edx,%eax
c0101c7b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c80:	0f 86 2d 01 00 00    	jbe    c0101db3 <fs_read_base_kr+0x190>
		readData(inode.data_block_offsets[D]);
c0101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c89:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101c90:	50                   	push   %eax
c0101c91:	e8 d2 fc ff ff       	call   c0101968 <readData>
c0101c96:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
c0101c99:	b8 00 02 00 00       	mov    $0x200,%eax
c0101c9e:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101ca1:	89 c2                	mov    %eax,%edx
c0101ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ca6:	05 40 d6 1d c0       	add    $0xc01dd640,%eax
c0101cab:	52                   	push   %edx
c0101cac:	50                   	push   %eax
c0101cad:	ff 75 0c             	pushl  0xc(%ebp)
c0101cb0:	e8 63 f9 ff ff       	call   c0101618 <memcpy2>
c0101cb5:	83 c4 0c             	add    $0xc,%esp
		f->offset += BLOCK_SIZE-R;
c0101cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cbb:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cc1:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cc4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ccd:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101cd6:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101cd9:	05 00 02 00 00       	add    $0x200,%eax
c0101cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101ce1:	8b 55 10             	mov    0x10(%ebp),%edx
c0101ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ce7:	01 d0                	add    %edx,%eax
c0101ce9:	2d 00 02 00 00       	sub    $0x200,%eax
c0101cee:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101cf1:	eb 63                	jmp    c0101d56 <fs_read_base_kr+0x133>
			D = f->offset >> 9;
c0101cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101cf6:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101cfc:	c1 e8 09             	shr    $0x9,%eax
c0101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
c0101d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d05:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101d0c:	50                   	push   %eax
c0101d0d:	e8 56 fc ff ff       	call   c0101968 <readData>
c0101d12:	83 c4 04             	add    $0x4,%esp
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
c0101d15:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d1b:	01 d0                	add    %edx,%eax
c0101d1d:	68 00 02 00 00       	push   $0x200
c0101d22:	68 40 d6 1d c0       	push   $0xc01dd640
c0101d27:	50                   	push   %eax
c0101d28:	e8 eb f8 ff ff       	call   c0101618 <memcpy2>
c0101d2d:	83 c4 0c             	add    $0xc,%esp
			len -= BLOCK_SIZE;
c0101d30:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d3a:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d40:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101d46:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d49:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101d4f:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101d56:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101d5d:	7f 94                	jg     c0101cf3 <fs_read_base_kr+0xd0>
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101d5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d62:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101d68:	c1 e8 09             	shr    $0x9,%eax
c0101d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d71:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101d78:	50                   	push   %eax
c0101d79:	e8 ea fb ff ff       	call   c0101968 <readData>
c0101d7e:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf+offset, buffer, len);
c0101d81:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101d87:	01 d0                	add    %edx,%eax
c0101d89:	ff 75 10             	pushl  0x10(%ebp)
c0101d8c:	68 40 d6 1d c0       	push   $0xc01dd640
c0101d91:	50                   	push   %eax
c0101d92:	e8 81 f8 ff ff       	call   c0101618 <memcpy2>
c0101d97:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101d9d:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101da3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da6:	01 c2                	add    %eax,%edx
c0101da8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dab:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c0101db1:	eb 41                	jmp    c0101df4 <fs_read_base_kr+0x1d1>
	}else{
		readData(inode.data_block_offsets[D]);
c0101db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101db6:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101dbd:	50                   	push   %eax
c0101dbe:	e8 a5 fb ff ff       	call   c0101968 <readData>
c0101dc3:	83 c4 04             	add    $0x4,%esp
		memcpy2(buf, buffer+R, len);
c0101dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101dc9:	05 40 d6 1d c0       	add    $0xc01dd640,%eax
c0101dce:	ff 75 10             	pushl  0x10(%ebp)
c0101dd1:	50                   	push   %eax
c0101dd2:	ff 75 0c             	pushl  0xc(%ebp)
c0101dd5:	e8 3e f8 ff ff       	call   c0101618 <memcpy2>
c0101dda:	83 c4 0c             	add    $0xc,%esp
		f->offset += len;
c0101ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101de0:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101de6:	8b 45 10             	mov    0x10(%ebp),%eax
c0101de9:	01 c2                	add    %eax,%edx
c0101deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101dee:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0101df4:	c9                   	leave  
c0101df5:	c3                   	ret    

c0101df6 <fs_read_kr>:
int32_t fs_read_kr(int fd, void* buf, int32_t len){
c0101df6:	55                   	push   %ebp
c0101df7:	89 e5                	mov    %esp,%ebp
c0101df9:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dff:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101e05:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->offset+len >= f->file_size){
c0101e0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e10:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101e16:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e19:	01 c2                	add    %eax,%edx
c0101e1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e1e:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c0101e24:	39 c2                	cmp    %eax,%edx
c0101e26:	72 19                	jb     c0101e41 <fs_read_kr+0x4b>
		len = f->file_size-f->offset;
c0101e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e2b:	8b 90 08 02 00 00    	mov    0x208(%eax),%edx
c0101e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101e34:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e3a:	29 c2                	sub    %eax,%edx
c0101e3c:	89 d0                	mov    %edx,%eax
c0101e3e:	89 45 10             	mov    %eax,0x10(%ebp)
	}
	fs_read_base_kr(fd, buf, len);
c0101e41:	ff 75 10             	pushl  0x10(%ebp)
c0101e44:	ff 75 0c             	pushl  0xc(%ebp)
c0101e47:	ff 75 08             	pushl  0x8(%ebp)
c0101e4a:	e8 d4 fd ff ff       	call   c0101c23 <fs_read_base_kr>
c0101e4f:	83 c4 0c             	add    $0xc,%esp
	return len;
c0101e52:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c0101e55:	c9                   	leave  
c0101e56:	c3                   	ret    

c0101e57 <fs_write_base_kr>:
void fs_write_base_kr(int fd, void* buf, int32_t len){
c0101e57:	55                   	push   %ebp
c0101e58:	89 e5                	mov    %esp,%ebp
c0101e5a:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e60:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0101e66:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0101e6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
c0101e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e71:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0101e77:	50                   	push   %eax
c0101e78:	e8 b5 fa ff ff       	call   c0101932 <readINode>
c0101e7d:	83 c4 04             	add    $0x4,%esp
	uint32_t offset = 0;
c0101e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	uint32_t D, R;
	D = f->offset >> 9;
c0101e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e8a:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e90:	c1 e8 09             	shr    $0x9,%eax
c0101e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	R = f->offset % BLOCK_SIZE;
c0101e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101e99:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101e9f:	25 ff 01 00 00       	and    $0x1ff,%eax
c0101ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(R + len > BLOCK_SIZE){
c0101ea7:	8b 55 10             	mov    0x10(%ebp),%edx
c0101eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ead:	01 d0                	add    %edx,%eax
c0101eaf:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101eb4:	0f 86 53 01 00 00    	jbe    c010200d <fs_write_base_kr+0x1b6>
		readData(inode.data_block_offsets[D]);
c0101eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ebd:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101ec4:	50                   	push   %eax
c0101ec5:	e8 9e fa ff ff       	call   c0101968 <readData>
c0101eca:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
c0101ecd:	b8 00 02 00 00       	mov    $0x200,%eax
c0101ed2:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101ed5:	89 c2                	mov    %eax,%edx
c0101ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101eda:	05 40 d6 1d c0       	add    $0xc01dd640,%eax
c0101edf:	52                   	push   %edx
c0101ee0:	ff 75 0c             	pushl  0xc(%ebp)
c0101ee3:	50                   	push   %eax
c0101ee4:	e8 2f f7 ff ff       	call   c0101618 <memcpy2>
c0101ee9:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101eef:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101ef6:	50                   	push   %eax
c0101ef7:	e8 87 fa ff ff       	call   c0101983 <saveData>
c0101efc:	83 c4 04             	add    $0x4,%esp
		f->offset += BLOCK_SIZE-R;
c0101eff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f02:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f08:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f0b:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f14:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		offset += BLOCK_SIZE-R;
c0101f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f1d:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0101f20:	05 00 02 00 00       	add    $0x200,%eax
c0101f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
		len -= BLOCK_SIZE-R;
c0101f28:	8b 55 10             	mov    0x10(%ebp),%edx
c0101f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f2e:	01 d0                	add    %edx,%eax
c0101f30:	2d 00 02 00 00       	sub    $0x200,%eax
c0101f35:	89 45 10             	mov    %eax,0x10(%ebp)
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f38:	eb 63                	jmp    c0101f9d <fs_write_base_kr+0x146>
			D = f->offset >> 9;
c0101f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f3d:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f43:	c1 e8 09             	shr    $0x9,%eax
c0101f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
c0101f49:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101f4f:	01 d0                	add    %edx,%eax
c0101f51:	68 00 02 00 00       	push   $0x200
c0101f56:	50                   	push   %eax
c0101f57:	68 40 d6 1d c0       	push   $0xc01dd640
c0101f5c:	e8 b7 f6 ff ff       	call   c0101618 <memcpy2>
c0101f61:	83 c4 0c             	add    $0xc,%esp
			saveData(inode.data_block_offsets[D]);
c0101f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101f67:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101f6e:	50                   	push   %eax
c0101f6f:	e8 0f fa ff ff       	call   c0101983 <saveData>
c0101f74:	83 c4 04             	add    $0x4,%esp
			len -= BLOCK_SIZE;
c0101f77:	81 6d 10 00 02 00 00 	subl   $0x200,0x10(%ebp)
			f->offset += BLOCK_SIZE;
c0101f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f81:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101f87:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
c0101f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101f90:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
			offset += BLOCK_SIZE;
c0101f96:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%ebp)
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
c0101f9d:	81 7d 10 ff 01 00 00 	cmpl   $0x1ff,0x10(%ebp)
c0101fa4:	7f 94                	jg     c0101f3a <fs_write_base_kr+0xe3>
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
c0101fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101fa9:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0101faf:	c1 e8 09             	shr    $0x9,%eax
c0101fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		readData(inode.data_block_offsets[D]);
c0101fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fb8:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101fbf:	50                   	push   %eax
c0101fc0:	e8 a3 f9 ff ff       	call   c0101968 <readData>
c0101fc5:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer, buf+offset, len);
c0101fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101fce:	01 d0                	add    %edx,%eax
c0101fd0:	ff 75 10             	pushl  0x10(%ebp)
c0101fd3:	50                   	push   %eax
c0101fd4:	68 40 d6 1d c0       	push   $0xc01dd640
c0101fd9:	e8 3a f6 ff ff       	call   c0101618 <memcpy2>
c0101fde:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0101fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101fe4:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0101feb:	50                   	push   %eax
c0101fec:	e8 92 f9 ff ff       	call   c0101983 <saveData>
c0101ff1:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c0101ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ff7:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0101ffd:	8b 45 10             	mov    0x10(%ebp),%eax
c0102000:	01 c2                	add    %eax,%edx
c0102002:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102005:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
c010200b:	eb 54                	jmp    c0102061 <fs_write_base_kr+0x20a>
	}else{
		readData(inode.data_block_offsets[D]);
c010200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102010:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0102017:	50                   	push   %eax
c0102018:	e8 4b f9 ff ff       	call   c0101968 <readData>
c010201d:	83 c4 04             	add    $0x4,%esp
		memcpy2(buffer+R, buf, len);
c0102020:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102023:	05 40 d6 1d c0       	add    $0xc01dd640,%eax
c0102028:	ff 75 10             	pushl  0x10(%ebp)
c010202b:	ff 75 0c             	pushl  0xc(%ebp)
c010202e:	50                   	push   %eax
c010202f:	e8 e4 f5 ff ff       	call   c0101618 <memcpy2>
c0102034:	83 c4 0c             	add    $0xc,%esp
		saveData(inode.data_block_offsets[D]);
c0102037:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010203a:	8b 04 85 40 da 1d c0 	mov    -0x3fe225c0(,%eax,4),%eax
c0102041:	50                   	push   %eax
c0102042:	e8 3c f9 ff ff       	call   c0101983 <saveData>
c0102047:	83 c4 04             	add    $0x4,%esp
		f->offset += len;
c010204a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010204d:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102053:	8b 45 10             	mov    0x10(%ebp),%eax
c0102056:	01 c2                	add    %eax,%edx
c0102058:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010205b:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
c0102061:	c9                   	leave  
c0102062:	c3                   	ret    

c0102063 <fs_write_kr>:
int32_t fs_write_kr(int fd, void* buf, int32_t len){
c0102063:	55                   	push   %ebp
c0102064:	89 e5                	mov    %esp,%ebp
c0102066:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102069:	8b 45 08             	mov    0x8(%ebp),%eax
c010206c:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0102072:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102077:	89 45 f8             	mov    %eax,-0x8(%ebp)
	int32_t D1, D2;
	readINode(f->inode_offset);
c010207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010207d:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c0102083:	50                   	push   %eax
c0102084:	e8 a9 f8 ff ff       	call   c0101932 <readINode>
c0102089:	83 c4 04             	add    $0x4,%esp
	D1 = f->offset >> 9;
c010208c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010208f:	8b 80 00 02 00 00    	mov    0x200(%eax),%eax
c0102095:	c1 e8 09             	shr    $0x9,%eax
c0102098:	89 45 fc             	mov    %eax,-0x4(%ebp)
	D2 = (f->offset + len) >> 9;
c010209b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010209e:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01020a7:	01 d0                	add    %edx,%eax
c01020a9:	c1 e8 09             	shr    $0x9,%eax
c01020ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	D1 += 1;
c01020af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	while(D1<=D2){
c01020b3:	eb 15                	jmp    c01020ca <fs_write_kr+0x67>
		inode.data_block_offsets[D1] = dataAlloc();
c01020b5:	e8 78 f9 ff ff       	call   c0101a32 <dataAlloc>
c01020ba:	89 c2                	mov    %eax,%edx
c01020bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020bf:	89 14 85 40 da 1d c0 	mov    %edx,-0x3fe225c0(,%eax,4)
		D1 ++;
c01020c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
	int32_t D1, D2;
	readINode(f->inode_offset);
	D1 = f->offset >> 9;
	D2 = (f->offset + len) >> 9;
	D1 += 1;
	while(D1<=D2){
c01020ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01020d0:	7e e3                	jle    c01020b5 <fs_write_kr+0x52>
		inode.data_block_offsets[D1] = dataAlloc();
		D1 ++;
	}
	saveINode(f->inode_offset);
c01020d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020d5:	8b 80 04 02 00 00    	mov    0x204(%eax),%eax
c01020db:	50                   	push   %eax
c01020dc:	e8 6c f8 ff ff       	call   c010194d <saveINode>
c01020e1:	83 c4 04             	add    $0x4,%esp
	if(f->offset + len> f->file_size)
c01020e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020e7:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c01020ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01020f0:	01 c2                	add    %eax,%edx
c01020f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01020f5:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
c01020fb:	39 c2                	cmp    %eax,%edx
c01020fd:	76 17                	jbe    c0102116 <fs_write_kr+0xb3>
		f->file_size = f->offset + len;
c01020ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102102:	8b 90 00 02 00 00    	mov    0x200(%eax),%edx
c0102108:	8b 45 10             	mov    0x10(%ebp),%eax
c010210b:	01 c2                	add    %eax,%edx
c010210d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102110:	89 90 08 02 00 00    	mov    %edx,0x208(%eax)
	fs_write_base_kr(fd, buf, len);
c0102116:	ff 75 10             	pushl  0x10(%ebp)
c0102119:	ff 75 0c             	pushl  0xc(%ebp)
c010211c:	ff 75 08             	pushl  0x8(%ebp)
c010211f:	e8 33 fd ff ff       	call   c0101e57 <fs_write_base_kr>
c0102124:	83 c4 0c             	add    $0xc,%esp
	return len;
c0102127:	8b 45 10             	mov    0x10(%ebp),%eax
	
}
c010212a:	c9                   	leave  
c010212b:	c3                   	ret    

c010212c <fs_lseek_kr>:
void fs_lseek_kr(int fd, int32_t index){
c010212c:	55                   	push   %ebp
c010212d:	89 e5                	mov    %esp,%ebp
c010212f:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102132:	8b 45 08             	mov    0x8(%ebp),%eax
c0102135:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c010213b:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	f->offset = index;
c0102143:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102146:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102149:	89 90 00 02 00 00    	mov    %edx,0x200(%eax)
}
c010214f:	c9                   	leave  
c0102150:	c3                   	ret    

c0102151 <fs_size_kr>:
uint32_t fs_size_kr(int fd){
c0102151:	55                   	push   %ebp
c0102152:	89 e5                	mov    %esp,%ebp
c0102154:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102157:	8b 45 08             	mov    0x8(%ebp),%eax
c010215a:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0102160:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102165:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return f->file_size;
c0102168:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010216b:	8b 80 08 02 00 00    	mov    0x208(%eax),%eax
}
c0102171:	c9                   	leave  
c0102172:	c3                   	ret    

c0102173 <fs_close_kr>:
int fs_close_kr(int fd){
c0102173:	55                   	push   %ebp
c0102174:	89 e5                	mov    %esp,%ebp
c0102176:	83 ec 10             	sub    $0x10,%esp
	FILE_STREAM *f = &fs[fd];
c0102179:	8b 45 08             	mov    0x8(%ebp),%eax
c010217c:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c0102182:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c0102187:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(f->used){
c010218a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218d:	0f b6 80 24 02 00 00 	movzbl 0x224(%eax),%eax
c0102194:	84 c0                	test   %al,%al
c0102196:	74 11                	je     c01021a9 <fs_close_kr+0x36>
		f->used = 0;
c0102198:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010219b:	c6 80 24 02 00 00 00 	movb   $0x0,0x224(%eax)
		return 0;
c01021a2:	b8 00 00 00 00       	mov    $0x0,%eax
c01021a7:	eb 05                	jmp    c01021ae <fs_close_kr+0x3b>
	}else
		return 1;
c01021a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01021ae:	c9                   	leave  
c01021af:	c3                   	ret    

c01021b0 <init_fs>:
void init_fs(){
c01021b0:	55                   	push   %ebp
c01021b1:	89 e5                	mov    %esp,%ebp
c01021b3:	83 ec 48             	sub    $0x48,%esp
	//readDir(0);
	int i=0;
c01021b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0; i< NR_FILE_STREAM; i++){
c01021bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01021c4:	eb 1b                	jmp    c01021e1 <init_fs+0x31>
		fs[i].used = 0;
c01021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01021c9:	69 c0 28 02 00 00    	imul   $0x228,%eax,%eax
c01021cf:	05 20 02 00 00       	add    $0x220,%eax
c01021d4:	05 40 91 1d c0       	add    $0xc01d9140,%eax
c01021d9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
		return 1;
}
void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
c01021dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01021e1:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
c01021e5:	7e df                	jle    c01021c6 <init_fs+0x16>
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
c01021e7:	68 21 43 10 c0       	push   $0xc0104321
c01021ec:	e8 d5 f8 ff ff       	call   c0101ac6 <fs_open_kr>
c01021f1:	83 c4 04             	add    $0x4,%esp
c01021f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char magic[40];
	int len = fs_read_kr(fd, magic, 40);
c01021f7:	6a 28                	push   $0x28
c01021f9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
c01021fc:	50                   	push   %eax
c01021fd:	ff 75 f0             	pushl  -0x10(%ebp)
c0102200:	e8 f1 fb ff ff       	call   c0101df6 <fs_read_kr>
c0102205:	83 c4 0c             	add    $0xc,%esp
c0102208:	89 45 ec             	mov    %eax,-0x14(%ebp)
	magic[len] = '\0';
c010220b:	8d 55 c4             	lea    -0x3c(%ebp),%edx
c010220e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102211:	01 d0                	add    %edx,%eax
c0102213:	c6 00 00             	movb   $0x0,(%eax)
	printk("%s\n", magic);
c0102216:	83 ec 08             	sub    $0x8,%esp
c0102219:	8d 45 c4             	lea    -0x3c(%ebp),%eax
c010221c:	50                   	push   %eax
c010221d:	68 2a 43 10 c0       	push   $0xc010432a
c0102222:	e8 cc f3 ff ff       	call   c01015f3 <printk>
c0102227:	83 c4 10             	add    $0x10,%esp
	/*for(i=0; i<NR_ENTRIES; i++){
		printk("%x\n", dir.entries[i].file_size);
		printk("%x\n", dir.entries[i].inode_offset);
		printk("%s\n", dir.entries[i].filename);
	}*/
c010222a:	c9                   	leave  
c010222b:	c3                   	ret    

c010222c <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
c010222c:	55                   	push   %ebp
c010222d:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
c010222f:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0102234:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
c0102236:	b8 df 05 00 00       	mov    $0x5df,%eax
c010223b:	cd 80                	int    $0x80
}
c010223d:	5d                   	pop    %ebp
c010223e:	c3                   	ret    

c010223f <sys_handout>:
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
c010223f:	55                   	push   %ebp
c0102240:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
c0102242:	b8 dc 05 00 00       	mov    $0x5dc,%eax
c0102247:	cd 80                	int    $0x80
}
c0102249:	5d                   	pop    %ebp
c010224a:	c3                   	ret    

c010224b <sys_fork>:
static inline uint32_t sys_fork(){
c010224b:	55                   	push   %ebp
c010224c:	89 e5                	mov    %esp,%ebp
c010224e:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
c0102258:	b8 e0 05 00 00       	mov    $0x5e0,%eax
c010225d:	cd 80                	int    $0x80
c010225f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
c0102262:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102265:	c9                   	leave  
c0102266:	c3                   	ret    

c0102267 <sys_pid>:
static inline uint32_t sys_pid(){
c0102267:	55                   	push   %ebp
c0102268:	89 e5                	mov    %esp,%ebp
c010226a:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c010226d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
c0102274:	b8 dd 05 00 00       	mov    $0x5dd,%eax
c0102279:	cd 80                	int    $0x80
c010227b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c010227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0102281:	c9                   	leave  
c0102282:	c3                   	ret    

c0102283 <sys_ppid>:
static inline uint32_t sys_ppid(){
c0102283:	55                   	push   %ebp
c0102284:	89 e5                	mov    %esp,%ebp
c0102286:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
c0102289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
c0102290:	b8 e1 05 00 00       	mov    $0x5e1,%eax
c0102295:	cd 80                	int    $0x80
c0102297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
c010229a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010229d:	c9                   	leave  
c010229e:	c3                   	ret    

c010229f <sys_sleep>:
static inline void sys_sleep(uint32_t c){
c010229f:	55                   	push   %ebp
c01022a0:	89 e5                	mov    %esp,%ebp
c01022a2:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
c01022a3:	b8 de 05 00 00       	mov    $0x5de,%eax
c01022a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01022ab:	89 d3                	mov    %edx,%ebx
c01022ad:	cd 80                	int    $0x80
}
c01022af:	5b                   	pop    %ebx
c01022b0:	5d                   	pop    %ebp
c01022b1:	c3                   	ret    

c01022b2 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
c01022b2:	55                   	push   %ebp
c01022b3:	89 e5                	mov    %esp,%ebp
c01022b5:	83 ec 40             	sub    $0x40,%esp
c01022b8:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
c01022bf:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01022c3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01022c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01022ca:	ee                   	out    %al,(%dx)
c01022cb:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
c01022d2:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
c01022d6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01022da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01022dd:	ee                   	out    %al,(%dx)
c01022de:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
c01022e5:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
c01022e9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01022ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01022f0:	ee                   	out    %al,(%dx)
c01022f1:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
c01022f8:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
c01022fc:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0102300:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102303:	ee                   	out    %al,(%dx)
c0102304:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
c010230b:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010230f:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102313:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102316:	ee                   	out    %al,(%dx)
c0102317:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
c010231e:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
c0102322:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102326:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102329:	ee                   	out    %al,(%dx)
c010232a:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
c0102331:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
c0102335:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102339:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010233c:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
c010233d:	c9                   	leave  
c010233e:	c3                   	ret    

c010233f <serial_idle>:

static inline
int serial_idle(void) {
c010233f:	55                   	push   %ebp
c0102340:	89 e5                	mov    %esp,%ebp
c0102342:	83 ec 10             	sub    $0x10,%esp
c0102345:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c010234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010234f:	89 c2                	mov    %eax,%edx
c0102351:	ec                   	in     (%dx),%al
c0102352:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102355:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102359:	0f b6 c0             	movzbl %al,%eax
c010235c:	83 e0 20             	and    $0x20,%eax
c010235f:	85 c0                	test   %eax,%eax
c0102361:	0f 95 c0             	setne  %al
c0102364:	0f b6 c0             	movzbl %al,%eax
}
c0102367:	c9                   	leave  
c0102368:	c3                   	ret    

c0102369 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102369:	55                   	push   %ebp
c010236a:	89 e5                	mov    %esp,%ebp
c010236c:	83 ec 14             	sub    $0x14,%esp
c010236f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102372:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102375:	90                   	nop
c0102376:	e8 c4 ff ff ff       	call   c010233f <serial_idle>
c010237b:	85 c0                	test   %eax,%eax
c010237d:	74 f7                	je     c0102376 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010237f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102383:	0f b6 c0             	movzbl %al,%eax
c0102386:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c010238d:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102390:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102394:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102397:	ee                   	out    %al,(%dx)
}
c0102398:	c9                   	leave  
c0102399:	c3                   	ret    

c010239a <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c010239a:	55                   	push   %ebp
c010239b:	89 e5                	mov    %esp,%ebp
c010239d:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c01023a0:	8d 45 0c             	lea    0xc(%ebp),%eax
c01023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c01023a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a9:	83 ec 04             	sub    $0x4,%esp
c01023ac:	ff 75 f4             	pushl  -0xc(%ebp)
c01023af:	50                   	push   %eax
c01023b0:	68 69 23 10 c0       	push   $0xc0102369
c01023b5:	e8 b1 1b 00 00       	call   c0103f6b <vfprintf>
c01023ba:	83 c4 10             	add    $0x10,%esp
}
c01023bd:	c9                   	leave  
c01023be:	c3                   	ret    

c01023bf <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
c01023bf:	55                   	push   %ebp
c01023c0:	89 e5                	mov    %esp,%ebp
c01023c2:	83 ec 70             	sub    $0x70,%esp
c01023c5:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
c01023cc:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
c01023d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01023d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01023d7:	ee                   	out    %al,(%dx)
c01023d8:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
c01023df:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
c01023e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01023ea:	ee                   	out    %al,(%dx)
c01023eb:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
c01023f2:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
c01023f6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c01023fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01023fd:	ee                   	out    %al,(%dx)
c01023fe:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
c0102405:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
c0102409:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010240d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102410:	ee                   	out    %al,(%dx)
c0102411:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
c0102418:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
c010241c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0102420:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102423:	ee                   	out    %al,(%dx)
c0102424:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
c010242b:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
c010242f:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
c0102433:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102436:	ee                   	out    %al,(%dx)
c0102437:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
c010243e:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
c0102442:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
c0102446:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102449:	ee                   	out    %al,(%dx)
c010244a:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
c0102451:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
c0102455:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
c0102459:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010245c:	ee                   	out    %al,(%dx)
c010245d:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
c0102464:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
c0102468:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
c010246c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010246f:	ee                   	out    %al,(%dx)
c0102470:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
c0102477:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
c010247b:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
c010247f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102482:	ee                   	out    %al,(%dx)
c0102483:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
c010248a:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
c010248e:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
c0102492:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102495:	ee                   	out    %al,(%dx)
c0102496:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
c010249d:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
c01024a1:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
c01024a5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01024a8:	ee                   	out    %al,(%dx)
c01024a9:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
c01024b0:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
c01024b4:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
c01024b8:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01024bb:	ee                   	out    %al,(%dx)
c01024bc:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
c01024c3:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
c01024c7:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
c01024cb:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01024ce:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
c01024cf:	c9                   	leave  
c01024d0:	c3                   	ret    

c01024d1 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
c01024d1:	55                   	push   %ebp
c01024d2:	89 e5                	mov    %esp,%ebp
c01024d4:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
c01024d7:	c7 45 fc 4d 17 00 00 	movl   $0x174d,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
c01024de:	0f b6 05 00 80 10 c0 	movzbl 0xc0108000,%eax
c01024e5:	0f b6 c0             	movzbl %al,%eax
c01024e8:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
c01024ef:	88 45 f7             	mov    %al,-0x9(%ebp)
c01024f2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01024f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01024f9:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
c01024fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01024fd:	0f b6 c0             	movzbl %al,%eax
c0102500:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
c0102507:	88 45 ef             	mov    %al,-0x11(%ebp)
c010250a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010250e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102511:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
c0102512:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102515:	c1 f8 08             	sar    $0x8,%eax
c0102518:	0f b6 c0             	movzbl %al,%eax
c010251b:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
c0102522:	88 45 e7             	mov    %al,-0x19(%ebp)
c0102525:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0102529:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010252c:	ee                   	out    %al,(%dx)
}
c010252d:	c9                   	leave  
c010252e:	c3                   	ret    

c010252f <idle>:

//void loader(PCB* pcb, uint32_t offset);
extern uint32_t _tick;
extern void init_segment(void);
extern void init_page(void);
void idle(){
c010252f:	55                   	push   %ebp
c0102530:	89 e5                	mov    %esp,%ebp
  while(1){
    yield();
c0102532:	e8 08 fd ff ff       	call   c010223f <sys_handout>
  }
c0102537:	eb f9                	jmp    c0102532 <idle+0x3>

c0102539 <busy>:
}
void busy(){
c0102539:	55                   	push   %ebp
c010253a:	89 e5                	mov    %esp,%ebp
c010253c:	83 ec 18             	sub    $0x18,%esp
  //int i=0;
  //for(i=0; i<5; i++){
  //fork();
  //while(1);
  
  uint32_t i = 0;
c010253f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uint32_t j = 0;
c0102546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i=0;i<3;i++){
c010254d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102554:	eb 11                	jmp    c0102567 <busy+0x2e>
    if(fork()!=0){
c0102556:	e8 f0 fc ff ff       	call   c010224b <sys_fork>
c010255b:	85 c0                	test   %eax,%eax
c010255d:	74 04                	je     c0102563 <busy+0x2a>
        j++;
c010255f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  //fork();
  //while(1);
  
  uint32_t i = 0;
  uint32_t j = 0;
  for(i=0;i<3;i++){
c0102563:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102567:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
c010256b:	76 e9                	jbe    c0102556 <busy+0x1d>
    if(fork()!=0){
        j++;
    };
  }
  uint32_t pid = getpid();
c010256d:	e8 f5 fc ff ff       	call   c0102267 <sys_pid>
c0102572:	89 45 e8             	mov    %eax,-0x18(%ebp)
  printf("This is BUSY#%d process forked from BUSY#%d. Fork %d times.\n", pid, getppid(), j);
c0102575:	e8 09 fd ff ff       	call   c0102283 <sys_ppid>
c010257a:	ff 75 f0             	pushl  -0x10(%ebp)
c010257d:	50                   	push   %eax
c010257e:	ff 75 e8             	pushl  -0x18(%ebp)
c0102581:	68 30 43 10 c0       	push   $0xc0104330
c0102586:	e8 7a 1c 00 00       	call   c0104205 <printf>
c010258b:	83 c4 10             	add    $0x10,%esp
      //printf("FORK: %d\n", result);
      //sys_handout();
  //}
  uint32_t times=0;
c010258e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while(1){
    yield();
c0102595:	e8 a5 fc ff ff       	call   c010223f <sys_handout>
    sleep(pid);
c010259a:	83 ec 0c             	sub    $0xc,%esp
c010259d:	ff 75 e8             	pushl  -0x18(%ebp)
c01025a0:	e8 fa fc ff ff       	call   c010229f <sys_sleep>
c01025a5:	83 c4 10             	add    $0x10,%esp
    printf("BUSY#%d: Sleep %ds! Alive %d times\n", pid, pid, times);
c01025a8:	ff 75 ec             	pushl  -0x14(%ebp)
c01025ab:	ff 75 e8             	pushl  -0x18(%ebp)
c01025ae:	ff 75 e8             	pushl  -0x18(%ebp)
c01025b1:	68 70 43 10 c0       	push   $0xc0104370
c01025b6:	e8 4a 1c 00 00       	call   c0104205 <printf>
c01025bb:	83 c4 10             	add    $0x10,%esp
    times++;
c01025be:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(times>3){
c01025c2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01025c6:	76 15                	jbe    c01025dd <busy+0xa4>
      printf("BUSY#%d: Ready to exit! Bye!\n");
c01025c8:	83 ec 0c             	sub    $0xc,%esp
c01025cb:	68 94 43 10 c0       	push   $0xc0104394
c01025d0:	e8 30 1c 00 00       	call   c0104205 <printf>
c01025d5:	83 c4 10             	add    $0x10,%esp
      exit();
c01025d8:	e8 4f fc ff ff       	call   c010222c <sys_exit>
    }
    //printk("This is %d\n", res);
  }
c01025dd:	eb b6                	jmp    c0102595 <busy+0x5c>

c01025df <main>:
}
void do_scheduler();
int main(){
c01025df:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c01025e3:	83 e4 f0             	and    $0xfffffff0,%esp
c01025e6:	ff 71 fc             	pushl  -0x4(%ecx)
c01025e9:	55                   	push   %ebp
c01025ea:	89 e5                	mov    %esp,%ebp
c01025ec:	51                   	push   %ecx
c01025ed:	83 ec 14             	sub    $0x14,%esp
  init_page();
c01025f0:	e8 36 db ff ff       	call   c010012b <init_page>
  init_segment();
c01025f5:	e8 e2 dc ff ff       	call   c01002dc <init_segment>
	init_serial();
c01025fa:	e8 b3 fc ff ff       	call   c01022b2 <init_serial>
	init_timer();
c01025ff:	e8 cd fe ff ff       	call   c01024d1 <init_timer>
	init_idt();
c0102604:	e8 ba ed ff ff       	call   c01013c3 <init_idt>
	init_intr();
c0102609:	e8 b1 fd ff ff       	call   c01023bf <init_intr>
  init_fs();
c010260e:	e8 9d fb ff ff       	call   c01021b0 <init_fs>
  init_pcb_pool();
c0102613:	e8 bd 0d 00 00       	call   c01033d5 <init_pcb_pool>
  printk("This is kernel!\n");
c0102618:	83 ec 0c             	sub    $0xc,%esp
c010261b:	68 b2 43 10 c0       	push   $0xc01043b2
c0102620:	e8 75 fd ff ff       	call   c010239a <printk>
c0102625:	83 c4 10             	add    $0x10,%esp

  PCB* pidle = pcb_create();
c0102628:	e8 13 0f 00 00       	call   c0103540 <pcb_create>
c010262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  empty_loader(pidle, idle);
c0102630:	83 ec 08             	sub    $0x8,%esp
c0102633:	68 2f 25 10 c0       	push   $0xc010252f
c0102638:	ff 75 f4             	pushl  -0xc(%ebp)
c010263b:	e8 e6 05 00 00       	call   c0102c26 <empty_loader>
c0102640:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pidle);
c0102643:	83 ec 0c             	sub    $0xc,%esp
c0102646:	ff 75 f4             	pushl  -0xc(%ebp)
c0102649:	e8 f2 0f 00 00       	call   c0103640 <enready_pcb>
c010264e:	83 c4 10             	add    $0x10,%esp


  PCB* pcb = pcb_create();
c0102651:	e8 ea 0e 00 00       	call   c0103540 <pcb_create>
c0102656:	89 45 f0             	mov    %eax,-0x10(%ebp)
  loader_file(pcb, "game");
c0102659:	83 ec 08             	sub    $0x8,%esp
c010265c:	68 c3 43 10 c0       	push   $0xc01043c3
c0102661:	ff 75 f0             	pushl  -0x10(%ebp)
c0102664:	e8 ec 03 00 00       	call   c0102a55 <loader_file>
c0102669:	83 c4 10             	add    $0x10,%esp
  enready_pcb(pcb);
c010266c:	83 ec 0c             	sub    $0xc,%esp
c010266f:	ff 75 f0             	pushl  -0x10(%ebp)
c0102672:	e8 c9 0f 00 00       	call   c0103640 <enready_pcb>
c0102677:	83 c4 10             	add    $0x10,%esp

  //PCB* pcc = pcb_create();
  //empty_loader(pcc, busy);
  //enready_pcb(pcc);

  PCB* app = pcb_create();
c010267a:	e8 c1 0e 00 00       	call   c0103540 <pcb_create>
c010267f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  loader_file(app, "app");
c0102682:	83 ec 08             	sub    $0x8,%esp
c0102685:	68 c8 43 10 c0       	push   $0xc01043c8
c010268a:	ff 75 ec             	pushl  -0x14(%ebp)
c010268d:	e8 c3 03 00 00       	call   c0102a55 <loader_file>
c0102692:	83 c4 10             	add    $0x10,%esp
  enready_pcb(app);
c0102695:	83 ec 0c             	sub    $0xc,%esp
c0102698:	ff 75 ec             	pushl  -0x14(%ebp)
c010269b:	e8 a0 0f 00 00       	call   c0103640 <enready_pcb>
c01026a0:	83 c4 10             	add    $0x10,%esp

  do_scheduler();
c01026a3:	e8 03 ea ff ff       	call   c01010ab <do_scheduler>

  while(1);
c01026a8:	eb fe                	jmp    c01026a8 <main+0xc9>

c01026aa <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01026aa:	55                   	push   %ebp
c01026ab:	89 e5                	mov    %esp,%ebp
c01026ad:	83 ec 10             	sub    $0x10,%esp
c01026b0:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c01026b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01026ba:	89 c2                	mov    %eax,%edx
c01026bc:	ec                   	in     (%dx),%al
c01026bd:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c01026c0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c01026c4:	0f b6 c0             	movzbl %al,%eax
c01026c7:	83 e0 20             	and    $0x20,%eax
c01026ca:	85 c0                	test   %eax,%eax
c01026cc:	0f 95 c0             	setne  %al
c01026cf:	0f b6 c0             	movzbl %al,%eax
}
c01026d2:	c9                   	leave  
c01026d3:	c3                   	ret    

c01026d4 <serial_printc>:

static inline
void serial_printc(char ch) {
c01026d4:	55                   	push   %ebp
c01026d5:	89 e5                	mov    %esp,%ebp
c01026d7:	83 ec 14             	sub    $0x14,%esp
c01026da:	8b 45 08             	mov    0x8(%ebp),%eax
c01026dd:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c01026e0:	90                   	nop
c01026e1:	e8 c4 ff ff ff       	call   c01026aa <serial_idle>
c01026e6:	85 c0                	test   %eax,%eax
c01026e8:	74 f7                	je     c01026e1 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c01026ea:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c01026ee:	0f b6 c0             	movzbl %al,%eax
c01026f1:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c01026f8:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c01026fb:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01026ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102702:	ee                   	out    %al,(%dx)
}
c0102703:	c9                   	leave  
c0102704:	c3                   	ret    

c0102705 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0102705:	55                   	push   %ebp
c0102706:	89 e5                	mov    %esp,%ebp
c0102708:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010270b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0102711:	8b 45 08             	mov    0x8(%ebp),%eax
c0102714:	83 ec 04             	sub    $0x4,%esp
c0102717:	ff 75 f4             	pushl  -0xc(%ebp)
c010271a:	50                   	push   %eax
c010271b:	68 d4 26 10 c0       	push   $0xc01026d4
c0102720:	e8 46 18 00 00       	call   c0103f6b <vfprintf>
c0102725:	83 c4 10             	add    $0x10,%esp
}
c0102728:	c9                   	leave  
c0102729:	c3                   	ret    

c010272a <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
c010272a:	55                   	push   %ebp
c010272b:	89 e5                	mov    %esp,%ebp
c010272d:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
c0102730:	90                   	nop
c0102731:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102738:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010273b:	89 c2                	mov    %eax,%edx
c010273d:	ec                   	in     (%dx),%al
c010273e:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102741:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102745:	0f b6 c0             	movzbl %al,%eax
c0102748:	25 c0 00 00 00       	and    $0xc0,%eax
c010274d:	83 f8 40             	cmp    $0x40,%eax
c0102750:	75 df                	jne    c0102731 <waitdisk+0x7>
}
c0102752:	c9                   	leave  
c0102753:	c3                   	ret    

c0102754 <readsect>:

static inline void
readsect(void *dst, int offset) {
c0102754:	55                   	push   %ebp
c0102755:	89 e5                	mov    %esp,%ebp
c0102757:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
c010275a:	e8 cb ff ff ff       	call   c010272a <waitdisk>
c010275f:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
c0102766:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010276a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010276e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0102771:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
c0102772:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102775:	0f b6 c0             	movzbl %al,%eax
c0102778:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
c010277f:	88 45 ef             	mov    %al,-0x11(%ebp)
c0102782:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0102786:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102789:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
c010278a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010278d:	c1 f8 08             	sar    $0x8,%eax
c0102790:	0f b6 c0             	movzbl %al,%eax
c0102793:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
c010279a:	88 45 e7             	mov    %al,-0x19(%ebp)
c010279d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01027a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01027a4:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
c01027a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027a8:	c1 f8 10             	sar    $0x10,%eax
c01027ab:	0f b6 c0             	movzbl %al,%eax
c01027ae:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
c01027b5:	88 45 df             	mov    %al,-0x21(%ebp)
c01027b8:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01027bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01027bf:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
c01027c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01027c3:	c1 f8 18             	sar    $0x18,%eax
c01027c6:	83 c8 e0             	or     $0xffffffe0,%eax
c01027c9:	0f b6 c0             	movzbl %al,%eax
c01027cc:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
c01027d3:	88 45 d7             	mov    %al,-0x29(%ebp)
c01027d6:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01027da:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01027dd:	ee                   	out    %al,(%dx)
c01027de:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
c01027e5:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
c01027e9:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
c01027ed:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01027f0:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
c01027f1:	e8 34 ff ff ff       	call   c010272a <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
c01027f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01027fd:	eb 29                	jmp    c0102828 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
c01027ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102809:	8b 45 08             	mov    0x8(%ebp),%eax
c010280c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
c010280f:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
c0102816:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102819:	89 c2                	mov    %eax,%edx
c010281b:	ed                   	in     (%dx),%eax
c010281c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
c010281f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102822:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
c0102824:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102828:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010282c:	7e d1                	jle    c01027ff <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
c010282e:	c9                   	leave  
c010282f:	c3                   	ret    

c0102830 <readseg>:
        outl(0x1F0, ((int *)(dst))[i]);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
c0102830:	55                   	push   %ebp
c0102831:	89 e5                	mov    %esp,%ebp
c0102833:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
c0102836:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102839:	8b 45 08             	mov    0x8(%ebp),%eax
c010283c:	01 d0                	add    %edx,%eax
c010283e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
c0102841:	8b 45 10             	mov    0x10(%ebp),%eax
c0102844:	99                   	cltd   
c0102845:	c1 ea 17             	shr    $0x17,%edx
c0102848:	01 d0                	add    %edx,%eax
c010284a:	25 ff 01 00 00       	and    $0x1ff,%eax
c010284f:	29 d0                	sub    %edx,%eax
c0102851:	f7 d8                	neg    %eax
c0102853:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
c0102856:	8b 45 10             	mov    0x10(%ebp),%eax
c0102859:	99                   	cltd   
c010285a:	c1 ea 17             	shr    $0x17,%edx
c010285d:	01 d0                	add    %edx,%eax
c010285f:	c1 f8 09             	sar    $0x9,%eax
c0102862:	83 c0 01             	add    $0x1,%eax
c0102865:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102868:	eb 19                	jmp    c0102883 <readseg+0x53>
        readsect(pa, offset);
c010286a:	ff 75 10             	pushl  0x10(%ebp)
c010286d:	ff 75 08             	pushl  0x8(%ebp)
c0102870:	e8 df fe ff ff       	call   c0102754 <readsect>
c0102875:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
c0102878:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
c010287f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0102883:	8b 45 08             	mov    0x8(%ebp),%eax
c0102886:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0102889:	72 df                	jb     c010286a <readseg+0x3a>
        readsect(pa, offset);
c010288b:	c9                   	leave  
c010288c:	c3                   	ret    

c010288d <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c010288d:	55                   	push   %ebp
c010288e:	89 e5                	mov    %esp,%ebp
c0102890:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c0102893:	8b 45 10             	mov    0x10(%ebp),%eax
c0102896:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c010289b:	77 16                	ja     c01028b3 <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c010289d:	ff 75 10             	pushl  0x10(%ebp)
c01028a0:	68 cc 43 10 c0       	push   $0xc01043cc
c01028a5:	ff 75 0c             	pushl  0xc(%ebp)
c01028a8:	ff 75 08             	pushl  0x8(%ebp)
c01028ab:	e8 55 fe ff ff       	call   c0102705 <printk>
c01028b0:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01028b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01028b6:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01028bb:	c9                   	leave  
c01028bc:	c3                   	ret    

c01028bd <loader>:
#define elf   ((struct ELFHeader *) ELFADDR)
#define elf_r ((char*) ELFADDR)

uint32_t entry;

void loader(PCB* pcb, uint32_t offset){
c01028bd:	55                   	push   %ebp
c01028be:	89 e5                	mov    %esp,%ebp
c01028c0:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c01028c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c6:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01028cc:	83 ec 04             	sub    $0x4,%esp
c01028cf:	50                   	push   %eax
c01028d0:	6a 17                	push   $0x17
c01028d2:	68 ef 43 10 c0       	push   $0xc01043ef
c01028d7:	e8 b1 ff ff ff       	call   c010288d <_paddr>
c01028dc:	83 c4 10             	add    $0x10,%esp
c01028df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01028e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01028e5:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c01028e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01028eb:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01028f1:	83 ec 04             	sub    $0x4,%esp
c01028f4:	68 00 10 00 00       	push   $0x1000
c01028f9:	6a 00                	push   $0x0
c01028fb:	50                   	push   %eax
c01028fc:	e8 90 dd ff ff       	call   c0100691 <mm_alloc>
c0102901:	83 c4 10             	add    $0x10,%esp
  readseg((unsigned char*)elf, 8*SECTSIZE, offset);
c0102904:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102907:	83 ec 04             	sub    $0x4,%esp
c010290a:	50                   	push   %eax
c010290b:	68 00 10 00 00       	push   $0x1000
c0102910:	6a 00                	push   $0x0
c0102912:	e8 19 ff ff ff       	call   c0102830 <readseg>
c0102917:	83 c4 10             	add    $0x10,%esp
  //printk("b\n");
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c010291a:	b8 00 00 00 00       	mov    $0x0,%eax
c010291f:	8b 00                	mov    (%eax),%eax
c0102921:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102926:	0f 94 c0             	sete   %al
c0102929:	0f b6 c0             	movzbl %al,%eax
c010292c:	83 ec 08             	sub    $0x8,%esp
c010292f:	50                   	push   %eax
c0102930:	68 03 44 10 c0       	push   $0xc0104403
c0102935:	e8 cb fd ff ff       	call   c0102705 <printk>
c010293a:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c010293d:	b8 00 00 00 00       	mov    $0x0,%eax
c0102942:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102945:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102948:	b8 00 00 00 00       	mov    $0x0,%eax
c010294d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102951:	0f b7 c0             	movzwl %ax,%eax
c0102954:	c1 e0 05             	shl    $0x5,%eax
c0102957:	89 c2                	mov    %eax,%edx
c0102959:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010295c:	01 d0                	add    %edx,%eax
c010295e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102961:	eb 7f                	jmp    c01029e2 <loader+0x125>
    pa = (unsigned char*)ph->paddr; 
c0102963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102966:	8b 40 0c             	mov    0xc(%eax),%eax
c0102969:	89 45 e8             	mov    %eax,-0x18(%ebp)

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296f:	8b 48 14             	mov    0x14(%eax),%ecx
c0102972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102975:	8b 50 08             	mov    0x8(%eax),%edx
c0102978:	8b 45 08             	mov    0x8(%ebp),%eax
c010297b:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102981:	83 ec 04             	sub    $0x4,%esp
c0102984:	51                   	push   %ecx
c0102985:	52                   	push   %edx
c0102986:	50                   	push   %eax
c0102987:	e8 05 dd ff ff       	call   c0100691 <mm_alloc>
c010298c:	83 c4 10             	add    $0x10,%esp
    readseg(pa, ph->filesz, offset+ph->off); 
c010298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102992:	8b 50 04             	mov    0x4(%eax),%edx
c0102995:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102998:	01 d0                	add    %edx,%eax
c010299a:	89 c2                	mov    %eax,%edx
c010299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299f:	8b 40 10             	mov    0x10(%eax),%eax
c01029a2:	83 ec 04             	sub    $0x4,%esp
c01029a5:	52                   	push   %edx
c01029a6:	50                   	push   %eax
c01029a7:	ff 75 e8             	pushl  -0x18(%ebp)
c01029aa:	e8 81 fe ff ff       	call   c0102830 <readseg>
c01029af:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c01029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b5:	8b 50 10             	mov    0x10(%eax),%edx
c01029b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029bb:	01 d0                	add    %edx,%eax
c01029bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01029c0:	eb 0c                	jmp    c01029ce <loader+0x111>
c01029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01029c5:	8d 50 01             	lea    0x1(%eax),%edx
c01029c8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01029cb:	c6 00 00             	movb   $0x0,(%eax)
c01029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d1:	8b 50 14             	mov    0x14(%eax),%edx
c01029d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029d7:	01 d0                	add    %edx,%eax
c01029d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01029dc:	77 e4                	ja     c01029c2 <loader+0x105>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c01029de:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01029e8:	0f 82 75 ff ff ff    	jb     c0102963 <loader+0xa6>

    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
    readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  entry = elf->entry;
c01029ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01029f3:	8b 40 18             	mov    0x18(%eax),%eax
c01029f6:	a3 e4 3e 10 c0       	mov    %eax,0xc0103ee4

  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c01029fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029fe:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a04:	83 ec 04             	sub    $0x4,%esp
c0102a07:	68 00 80 00 00       	push   $0x8000
c0102a0c:	68 00 60 bf be       	push   $0xbebf6000
c0102a11:	50                   	push   %eax
c0102a12:	e8 7a dc ff ff       	call   c0100691 <mm_alloc>
c0102a17:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102a1a:	a1 e4 3e 10 c0       	mov    0xc0103ee4,%eax
c0102a1f:	6a 03                	push   $0x3
c0102a21:	50                   	push   %eax
c0102a22:	68 80 df bf be       	push   $0xbebfdf80
c0102a27:	ff 75 08             	pushl  0x8(%ebp)
c0102a2a:	e8 dd 09 00 00       	call   c010340c <init_pcb>
c0102a2f:	83 c4 10             	add    $0x10,%esp
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102a32:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102a37:	83 ec 04             	sub    $0x4,%esp
c0102a3a:	50                   	push   %eax
c0102a3b:	6a 39                	push   $0x39
c0102a3d:	68 ef 43 10 c0       	push   $0xc01043ef
c0102a42:	e8 46 fe ff ff       	call   c010288d <_paddr>
c0102a47:	83 c4 10             	add    $0x10,%esp
c0102a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a50:	0f 22 d8             	mov    %eax,%cr3

  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102a53:	c9                   	leave  
c0102a54:	c3                   	ret    

c0102a55 <loader_file>:

void loader_file(PCB* pcb, char* filename){
c0102a55:	55                   	push   %ebp
c0102a56:	89 e5                	mov    %esp,%ebp
c0102a58:	83 ec 28             	sub    $0x28,%esp
  //102400
  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;
  lcr3(PADDR(pcb -> pgdir));
c0102a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5e:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a64:	83 ec 04             	sub    $0x4,%esp
c0102a67:	50                   	push   %eax
c0102a68:	6a 44                	push   $0x44
c0102a6a:	68 ef 43 10 c0       	push   $0xc01043ef
c0102a6f:	e8 19 fe ff ff       	call   c010288d <_paddr>
c0102a74:	83 c4 10             	add    $0x10,%esp
c0102a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a7d:	0f 22 d8             	mov    %eax,%cr3

  mm_alloc(pcb->pgdir, ELFADDR, 0x1000);
c0102a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a83:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102a89:	83 ec 04             	sub    $0x4,%esp
c0102a8c:	68 00 10 00 00       	push   $0x1000
c0102a91:	6a 00                	push   $0x0
c0102a93:	50                   	push   %eax
c0102a94:	e8 f8 db ff ff       	call   c0100691 <mm_alloc>
c0102a99:	83 c4 10             	add    $0x10,%esp
  int fd = fs_open_kr(filename);
c0102a9c:	83 ec 0c             	sub    $0xc,%esp
c0102a9f:	ff 75 0c             	pushl  0xc(%ebp)
c0102aa2:	e8 1f f0 ff ff       	call   c0101ac6 <fs_open_kr>
c0102aa7:	83 c4 10             	add    $0x10,%esp
c0102aaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fs_read_kr(fd, elf_r, 8*SECTSIZE);
c0102aad:	83 ec 04             	sub    $0x4,%esp
c0102ab0:	68 00 10 00 00       	push   $0x1000
c0102ab5:	6a 00                	push   $0x0
c0102ab7:	ff 75 ec             	pushl  -0x14(%ebp)
c0102aba:	e8 37 f3 ff ff       	call   c0101df6 <fs_read_kr>
c0102abf:	83 c4 10             	add    $0x10,%esp
  //readseg((unsigned char*)elf, 8*SECTSIZE, offset);
  //printk("%x\n", *(uint32_t *)(elf_r+7*SECTSIZE));
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
c0102ac2:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ac7:	8b 00                	mov    (%eax),%eax
c0102ac9:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0102ace:	0f 94 c0             	sete   %al
c0102ad1:	0f b6 c0             	movzbl %al,%eax
c0102ad4:	83 ec 08             	sub    $0x8,%esp
c0102ad7:	50                   	push   %eax
c0102ad8:	68 03 44 10 c0       	push   $0xc0104403
c0102add:	e8 23 fc ff ff       	call   c0102705 <printk>
c0102ae2:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
c0102ae5:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aea:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
c0102af0:	b8 00 00 00 00       	mov    $0x0,%eax
c0102af5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102af9:	0f b7 c0             	movzwl %ax,%eax
c0102afc:	c1 e0 05             	shl    $0x5,%eax
c0102aff:	89 c2                	mov    %eax,%edx
c0102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b04:	01 d0                	add    %edx,%eax
c0102b06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102b09:	e9 a5 00 00 00       	jmp    c0102bb3 <loader_file+0x15e>
    pa = (unsigned char*)ph->vaddr; 
c0102b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b11:	8b 40 08             	mov    0x8(%eax),%eax
c0102b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    //printk("%x %x %x\n", pcb->pgdir, ph->vaddr, ph->memsz);
    if(ph->vaddr == 0 || ph->memsz == 0)break;
c0102b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1a:	8b 40 08             	mov    0x8(%eax),%eax
c0102b1d:	85 c0                	test   %eax,%eax
c0102b1f:	0f 84 9a 00 00 00    	je     c0102bbf <loader_file+0x16a>
c0102b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b28:	8b 40 14             	mov    0x14(%eax),%eax
c0102b2b:	85 c0                	test   %eax,%eax
c0102b2d:	0f 84 8c 00 00 00    	je     c0102bbf <loader_file+0x16a>
    //printk("a\n");
    mm_alloc(pcb->pgdir, ph->vaddr, ph->memsz);
c0102b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b36:	8b 48 14             	mov    0x14(%eax),%ecx
c0102b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b3c:	8b 50 08             	mov    0x8(%eax),%edx
c0102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b42:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102b48:	83 ec 04             	sub    $0x4,%esp
c0102b4b:	51                   	push   %ecx
c0102b4c:	52                   	push   %edx
c0102b4d:	50                   	push   %eax
c0102b4e:	e8 3e db ff ff       	call   c0100691 <mm_alloc>
c0102b53:	83 c4 10             	add    $0x10,%esp
    //printk("b\n");
    //printk("hahaha?\n");
    fs_lseek_kr(fd, ph->off);
c0102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b59:	8b 40 04             	mov    0x4(%eax),%eax
c0102b5c:	83 ec 08             	sub    $0x8,%esp
c0102b5f:	50                   	push   %eax
c0102b60:	ff 75 ec             	pushl  -0x14(%ebp)
c0102b63:	e8 c4 f5 ff ff       	call   c010212c <fs_lseek_kr>
c0102b68:	83 c4 10             	add    $0x10,%esp
    fs_read_kr(fd, pa, ph->filesz);
c0102b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b6e:	8b 40 10             	mov    0x10(%eax),%eax
c0102b71:	83 ec 04             	sub    $0x4,%esp
c0102b74:	50                   	push   %eax
c0102b75:	ff 75 e4             	pushl  -0x1c(%ebp)
c0102b78:	ff 75 ec             	pushl  -0x14(%ebp)
c0102b7b:	e8 76 f2 ff ff       	call   c0101df6 <fs_read_kr>
c0102b80:	83 c4 10             	add    $0x10,%esp
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
c0102b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b86:	8b 50 10             	mov    0x10(%eax),%edx
c0102b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b8c:	01 d0                	add    %edx,%eax
c0102b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b91:	eb 0c                	jmp    c0102b9f <loader_file+0x14a>
c0102b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b96:	8d 50 01             	lea    0x1(%eax),%edx
c0102b99:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0102b9c:	c6 00 00             	movb   $0x0,(%eax)
c0102b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba2:	8b 50 14             	mov    0x14(%eax),%edx
c0102ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ba8:	01 d0                	add    %edx,%eax
c0102baa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102bad:	77 e4                	ja     c0102b93 <loader_file+0x13e>
  //printk("%x\n", p);
  
  
  //printk("c\n");

  for(; ph < eph; ph ++) {
c0102baf:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0102bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0102bb9:	0f 82 4f ff ff ff    	jb     c0102b0e <loader_file+0xb9>
    //readseg(pa, ph->filesz, offset+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }
  //printk("c\n");
  //while(1);
  entry = elf->entry;
c0102bbf:	b8 00 00 00 00       	mov    $0x0,%eax
c0102bc4:	8b 40 18             	mov    0x18(%eax),%eax
c0102bc7:	a3 e4 3e 10 c0       	mov    %eax,0xc0103ee4
  //lcr3(PADDR(kern_pgdir));
 // printk("hello: %x %x %x\n", entry, USTACKTOP-entry, USTACKTOP);
  //init_pcb(pcb, entry+4096, entry);
  //printf("%x\n", USTACKTOP-USTACKSIZE);
  //printk("e\n");
  mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
c0102bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bcf:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102bd5:	83 ec 04             	sub    $0x4,%esp
c0102bd8:	68 00 80 00 00       	push   $0x8000
c0102bdd:	68 00 60 bf be       	push   $0xbebf6000
c0102be2:	50                   	push   %eax
c0102be3:	e8 a9 da ff ff       	call   c0100691 <mm_alloc>
c0102be8:	83 c4 10             	add    $0x10,%esp
  init_pcb(pcb, USTACKTOP-0x80, entry, 3);
c0102beb:	a1 e4 3e 10 c0       	mov    0xc0103ee4,%eax
c0102bf0:	6a 03                	push   $0x3
c0102bf2:	50                   	push   %eax
c0102bf3:	68 80 df bf be       	push   $0xbebfdf80
c0102bf8:	ff 75 08             	pushl  0x8(%ebp)
c0102bfb:	e8 0c 08 00 00       	call   c010340c <init_pcb>
c0102c00:	83 c4 10             	add    $0x10,%esp
  //printk("f\n");
  //printk("%x\n", *(uint32_t*)(0x80481fd));
  //printk("%x\n", *((uint32_t*)entry));
  lcr3(PADDR(kern_pgdir));
c0102c03:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102c08:	83 ec 04             	sub    $0x4,%esp
c0102c0b:	50                   	push   %eax
c0102c0c:	6a 74                	push   $0x74
c0102c0e:	68 ef 43 10 c0       	push   $0xc01043ef
c0102c13:	e8 75 fc ff ff       	call   c010288d <_paddr>
c0102c18:	83 c4 10             	add    $0x10,%esp
c0102c1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c21:	0f 22 d8             	mov    %eax,%cr3
  //printk("g\n");
  //switch_pcb(pcb);
  
  //printk("e\n");
};
c0102c24:	c9                   	leave  
c0102c25:	c3                   	ret    

c0102c26 <empty_loader>:

void empty_loader(PCB* pcb, void (*ptr)(void)){
c0102c26:	55                   	push   %ebp
c0102c27:	89 e5                	mov    %esp,%ebp
c0102c29:	83 ec 18             	sub    $0x18,%esp

  lcr3(PADDR(pcb -> pgdir));
c0102c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c2f:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0102c35:	83 ec 04             	sub    $0x4,%esp
c0102c38:	50                   	push   %eax
c0102c39:	6a 7d                	push   $0x7d
c0102c3b:	68 ef 43 10 c0       	push   $0xc01043ef
c0102c40:	e8 48 fc ff ff       	call   c010288d <_paddr>
c0102c45:	83 c4 10             	add    $0x10,%esp
c0102c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4e:	0f 22 d8             	mov    %eax,%cr3
  entry = (uint32_t)ptr;
c0102c51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c54:	a3 e4 3e 10 c0       	mov    %eax,0xc0103ee4
  //mm_alloc(pcb->pgdir, USTACKTOP-USTACKSIZE, USTACKSIZE);
  init_pcb(pcb, (uint32_t)pcb->kstacktop-0x80, entry, 0);
c0102c59:	a1 e4 3e 10 c0       	mov    0xc0103ee4,%eax
c0102c5e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c61:	81 c2 20 20 00 00    	add    $0x2020,%edx
c0102c67:	83 c2 80             	add    $0xffffff80,%edx
c0102c6a:	6a 00                	push   $0x0
c0102c6c:	50                   	push   %eax
c0102c6d:	52                   	push   %edx
c0102c6e:	ff 75 08             	pushl  0x8(%ebp)
c0102c71:	e8 96 07 00 00       	call   c010340c <init_pcb>
c0102c76:	83 c4 10             	add    $0x10,%esp
  lcr3(PADDR(kern_pgdir));
c0102c79:	a1 c0 56 17 c0       	mov    0xc01756c0,%eax
c0102c7e:	83 ec 04             	sub    $0x4,%esp
c0102c81:	50                   	push   %eax
c0102c82:	68 81 00 00 00       	push   $0x81
c0102c87:	68 ef 43 10 c0       	push   $0xc01043ef
c0102c8c:	e8 fc fb ff ff       	call   c010288d <_paddr>
c0102c91:	83 c4 10             	add    $0x10,%esp
c0102c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c9a:	0f 22 d8             	mov    %eax,%cr3

c0102c9d:	c9                   	leave  
c0102c9e:	c3                   	ret    

c0102c9f <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
c0102c9f:	55                   	push   %ebp
c0102ca0:	89 e5                	mov    %esp,%ebp
c0102ca2:	83 ec 04             	sub    $0x4,%esp
c0102ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
c0102cab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
c0102caf:	83 e8 61             	sub    $0x61,%eax
c0102cb2:	8b 04 85 40 60 15 c0 	mov    -0x3fea9fc0(,%eax,4),%eax
}
c0102cb9:	c9                   	leave  
c0102cba:	c3                   	ret    

c0102cbb <get_lastkey>:
int8_t get_lastkey(){
c0102cbb:	55                   	push   %ebp
c0102cbc:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
c0102cbe:	a1 a8 60 15 c0       	mov    0xc01560a8,%eax
c0102cc3:	83 c0 61             	add    $0x61,%eax
}
c0102cc6:	5d                   	pop    %ebp
c0102cc7:	c3                   	ret    

c0102cc8 <press_key>:
void press_key(int code){
c0102cc8:	55                   	push   %ebp
c0102cc9:	89 e5                	mov    %esp,%ebp
c0102ccb:	83 ec 10             	sub    $0x10,%esp
	int i=0;
c0102cce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
c0102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd8:	25 80 00 00 00       	and    $0x80,%eax
c0102cdd:	85 c0                	test   %eax,%eax
c0102cdf:	75 35                	jne    c0102d16 <press_key+0x4e>
		for(;i<26;i++){
c0102ce1:	eb 2b                	jmp    c0102d0e <press_key+0x46>
			if(letter[i]==code){
c0102ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102ce6:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0102ced:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cf0:	75 18                	jne    c0102d0a <press_key+0x42>
				keydown[i] = 1;
c0102cf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102cf5:	c7 04 85 40 60 15 c0 	movl   $0x1,-0x3fea9fc0(,%eax,4)
c0102cfc:	01 00 00 00 
				lastkey = i;
c0102d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d03:	a3 a8 60 15 c0       	mov    %eax,0xc01560a8
				return;
c0102d08:	eb 3b                	jmp    c0102d45 <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
c0102d0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102d0e:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0102d12:	7e cf                	jle    c0102ce3 <press_key+0x1b>
c0102d14:	eb 2f                	jmp    c0102d45 <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
c0102d16:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
c0102d1a:	eb 23                	jmp    c0102d3f <press_key+0x77>
			if(letter[i]==code){
c0102d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d1f:	8b 04 85 40 80 10 c0 	mov    -0x3fef7fc0(,%eax,4),%eax
c0102d26:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d29:	75 10                	jne    c0102d3b <press_key+0x73>
				keydown[i] = 0;
c0102d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d2e:	c7 04 85 40 60 15 c0 	movl   $0x0,-0x3fea9fc0(,%eax,4)
c0102d35:	00 00 00 00 
				return;
c0102d39:	eb 0a                	jmp    c0102d45 <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
c0102d3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102d3f:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
c0102d43:	7e d7                	jle    c0102d1c <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
c0102d45:	c9                   	leave  
c0102d46:	c3                   	ret    

c0102d47 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c0102d47:	55                   	push   %ebp
c0102d48:	89 e5                	mov    %esp,%ebp
c0102d4a:	83 ec 10             	sub    $0x10,%esp
c0102d4d:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0102d54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d57:	89 c2                	mov    %eax,%edx
c0102d59:	ec                   	in     (%dx),%al
c0102d5a:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0102d5d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0102d61:	0f b6 c0             	movzbl %al,%eax
c0102d64:	83 e0 20             	and    $0x20,%eax
c0102d67:	85 c0                	test   %eax,%eax
c0102d69:	0f 95 c0             	setne  %al
c0102d6c:	0f b6 c0             	movzbl %al,%eax
}
c0102d6f:	c9                   	leave  
c0102d70:	c3                   	ret    

c0102d71 <serial_printc>:

static inline
void serial_printc(char ch) {
c0102d71:	55                   	push   %ebp
c0102d72:	89 e5                	mov    %esp,%ebp
c0102d74:	83 ec 14             	sub    $0x14,%esp
c0102d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7a:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0102d7d:	90                   	nop
c0102d7e:	e8 c4 ff ff ff       	call   c0102d47 <serial_idle>
c0102d83:	85 c0                	test   %eax,%eax
c0102d85:	74 f7                	je     c0102d7e <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c0102d87:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0102d8b:	0f b6 c0             	movzbl %al,%eax
c0102d8e:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0102d95:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c0102d98:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0102d9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102d9f:	ee                   	out    %al,(%dx)
}
c0102da0:	c9                   	leave  
c0102da1:	c3                   	ret    

c0102da2 <do_syscall>:


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
c0102da2:	55                   	push   %ebp
c0102da3:	89 e5                	mov    %esp,%ebp
c0102da5:	83 ec 08             	sub    $0x8,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
c0102da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dab:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102dae:	3d df 05 00 00       	cmp    $0x5df,%eax
c0102db3:	0f 84 a6 02 00 00    	je     c010305f <do_syscall+0x2bd>
c0102db9:	3d df 05 00 00       	cmp    $0x5df,%eax
c0102dbe:	0f 87 97 00 00 00    	ja     c0102e5b <do_syscall+0xb9>
c0102dc4:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0102dc9:	0f 84 d5 02 00 00    	je     c01030a4 <do_syscall+0x302>
c0102dcf:	3d 4f 04 00 00       	cmp    $0x44f,%eax
c0102dd4:	77 3d                	ja     c0102e13 <do_syscall+0x71>
c0102dd6:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0102ddb:	0f 84 a9 02 00 00    	je     c010308a <do_syscall+0x2e8>
c0102de1:	3d 4c 04 00 00       	cmp    $0x44c,%eax
c0102de6:	77 10                	ja     c0102df8 <do_syscall+0x56>
c0102de8:	3d e8 03 00 00       	cmp    $0x3e8,%eax
c0102ded:	0f 84 80 02 00 00    	je     c0103073 <do_syscall+0x2d1>
c0102df3:	e9 01 03 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102df8:	3d 4d 04 00 00       	cmp    $0x44d,%eax
c0102dfd:	0f 84 8e 02 00 00    	je     c0103091 <do_syscall+0x2ef>
c0102e03:	3d 4e 04 00 00       	cmp    $0x44e,%eax
c0102e08:	0f 84 8a 02 00 00    	je     c0103098 <do_syscall+0x2f6>
c0102e0e:	e9 e6 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102e13:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0102e18:	0f 84 2d 02 00 00    	je     c010304b <do_syscall+0x2a9>
c0102e1e:	3d dc 05 00 00       	cmp    $0x5dc,%eax
c0102e23:	77 1b                	ja     c0102e40 <do_syscall+0x9e>
c0102e25:	3d b0 04 00 00       	cmp    $0x4b0,%eax
c0102e2a:	0f 84 9b 02 00 00    	je     c01030cb <do_syscall+0x329>
c0102e30:	3d 15 05 00 00       	cmp    $0x515,%eax
c0102e35:	0f 84 b0 02 00 00    	je     c01030eb <do_syscall+0x349>
c0102e3b:	e9 b9 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102e40:	3d dd 05 00 00       	cmp    $0x5dd,%eax
c0102e45:	0f 84 a9 01 00 00    	je     c0102ff4 <do_syscall+0x252>
c0102e4b:	3d de 05 00 00       	cmp    $0x5de,%eax
c0102e50:	0f 84 ca 01 00 00    	je     c0103020 <do_syscall+0x27e>
c0102e56:	e9 9e 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102e5b:	3d 41 06 00 00       	cmp    $0x641,%eax
c0102e60:	0f 84 a7 00 00 00    	je     c0102f0d <do_syscall+0x16b>
c0102e66:	3d 41 06 00 00       	cmp    $0x641,%eax
c0102e6b:	77 44                	ja     c0102eb1 <do_syscall+0x10f>
c0102e6d:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0102e72:	0f 84 65 01 00 00    	je     c0102fdd <do_syscall+0x23b>
c0102e78:	3d e2 05 00 00       	cmp    $0x5e2,%eax
c0102e7d:	77 1b                	ja     c0102e9a <do_syscall+0xf8>
c0102e7f:	3d e0 05 00 00       	cmp    $0x5e0,%eax
c0102e84:	0f 84 df 01 00 00    	je     c0103069 <do_syscall+0x2c7>
c0102e8a:	3d e1 05 00 00       	cmp    $0x5e1,%eax
c0102e8f:	0f 84 75 01 00 00    	je     c010300a <do_syscall+0x268>
c0102e95:	e9 5f 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102e9a:	3d e6 05 00 00       	cmp    $0x5e6,%eax
c0102e9f:	0f 84 13 01 00 00    	je     c0102fb8 <do_syscall+0x216>
c0102ea5:	3d 40 06 00 00       	cmp    $0x640,%eax
c0102eaa:	74 41                	je     c0102eed <do_syscall+0x14b>
c0102eac:	e9 48 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102eb1:	3d 44 06 00 00       	cmp    $0x644,%eax
c0102eb6:	0f 84 c6 00 00 00    	je     c0102f82 <do_syscall+0x1e0>
c0102ebc:	3d 44 06 00 00       	cmp    $0x644,%eax
c0102ec1:	77 13                	ja     c0102ed6 <do_syscall+0x134>
c0102ec3:	3d 42 06 00 00       	cmp    $0x642,%eax
c0102ec8:	74 6b                	je     c0102f35 <do_syscall+0x193>
c0102eca:	3d 43 06 00 00       	cmp    $0x643,%eax
c0102ecf:	74 7b                	je     c0102f4c <do_syscall+0x1aa>
c0102ed1:	e9 23 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
c0102ed6:	3d 45 06 00 00       	cmp    $0x645,%eax
c0102edb:	0f 84 b8 00 00 00    	je     c0102f99 <do_syscall+0x1f7>
c0102ee1:	3d 46 06 00 00       	cmp    $0x646,%eax
c0102ee6:	74 7b                	je     c0102f63 <do_syscall+0x1c1>
c0102ee8:	e9 0c 02 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
c0102eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef0:	8b 40 18             	mov    0x18(%eax),%eax
c0102ef3:	89 c2                	mov    %eax,%edx
c0102ef5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef8:	8b 40 10             	mov    0x10(%eax),%eax
c0102efb:	83 ec 08             	sub    $0x8,%esp
c0102efe:	52                   	push   %edx
c0102eff:	50                   	push   %eax
c0102f00:	e8 0c e0 ff ff       	call   c0100f11 <sem_init_kr>
c0102f05:	83 c4 10             	add    $0x10,%esp
		break;
c0102f08:	e9 ec 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
c0102f0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f10:	8b 40 18             	mov    0x18(%eax),%eax
c0102f13:	89 c2                	mov    %eax,%edx
c0102f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f18:	8b 40 10             	mov    0x10(%eax),%eax
c0102f1b:	83 ec 08             	sub    $0x8,%esp
c0102f1e:	52                   	push   %edx
c0102f1f:	50                   	push   %eax
c0102f20:	e8 59 e1 ff ff       	call   c010107e <sem_open_kr>
c0102f25:	83 c4 10             	add    $0x10,%esp
c0102f28:	89 c2                	mov    %eax,%edx
c0102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f2d:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102f30:	e9 c4 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
c0102f35:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f38:	8b 40 10             	mov    0x10(%eax),%eax
c0102f3b:	83 ec 0c             	sub    $0xc,%esp
c0102f3e:	50                   	push   %eax
c0102f3f:	e8 39 e0 ff ff       	call   c0100f7d <sem_post_kr>
c0102f44:	83 c4 10             	add    $0x10,%esp
		break;
c0102f47:	e9 ad 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
c0102f4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f4f:	8b 40 10             	mov    0x10(%eax),%eax
c0102f52:	83 ec 0c             	sub    $0xc,%esp
c0102f55:	50                   	push   %eax
c0102f56:	e8 76 e0 ff ff       	call   c0100fd1 <sem_wait_kr>
c0102f5b:	83 c4 10             	add    $0x10,%esp
		break;
c0102f5e:	e9 96 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
c0102f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f66:	8b 40 10             	mov    0x10(%eax),%eax
c0102f69:	83 ec 0c             	sub    $0xc,%esp
c0102f6c:	50                   	push   %eax
c0102f6d:	e8 b7 e0 ff ff       	call   c0101029 <sem_trywait_kr>
c0102f72:	83 c4 10             	add    $0x10,%esp
c0102f75:	89 c2                	mov    %eax,%edx
c0102f77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f7a:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102f7d:	e9 77 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
c0102f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f85:	8b 40 10             	mov    0x10(%eax),%eax
c0102f88:	83 ec 0c             	sub    $0xc,%esp
c0102f8b:	50                   	push   %eax
c0102f8c:	e8 a0 df ff ff       	call   c0100f31 <sem_close_kr>
c0102f91:	83 c4 10             	add    $0x10,%esp
		break;
c0102f94:	e9 60 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
c0102f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f9c:	8b 40 10             	mov    0x10(%eax),%eax
c0102f9f:	83 ec 0c             	sub    $0xc,%esp
c0102fa2:	50                   	push   %eax
c0102fa3:	e8 bb e0 ff ff       	call   c0101063 <sem_get_kr>
c0102fa8:	83 c4 10             	add    $0x10,%esp
c0102fab:	89 c2                	mov    %eax,%edx
c0102fad:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fb0:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0102fb3:	e9 41 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
c0102fb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fbb:	8b 48 14             	mov    0x14(%eax),%ecx
c0102fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fc1:	8b 50 18             	mov    0x18(%eax),%edx
c0102fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fc7:	8b 40 10             	mov    0x10(%eax),%eax
c0102fca:	83 ec 04             	sub    $0x4,%esp
c0102fcd:	51                   	push   %ecx
c0102fce:	52                   	push   %edx
c0102fcf:	50                   	push   %eax
c0102fd0:	e8 ec 08 00 00       	call   c01038c1 <thread_current>
c0102fd5:	83 c4 10             	add    $0x10,%esp
		break;
c0102fd8:	e9 1c 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_JOIN:
			join_current(tf->ebx);
c0102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fe0:	8b 40 10             	mov    0x10(%eax),%eax
c0102fe3:	83 ec 0c             	sub    $0xc,%esp
c0102fe6:	50                   	push   %eax
c0102fe7:	e8 b3 0a 00 00       	call   c0103a9f <join_current>
c0102fec:	83 c4 10             	add    $0x10,%esp
		break;
c0102fef:	e9 05 01 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_PID:
			tf->eax = current->pid;
c0102ff4:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0102ff9:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0102fff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103002:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c0103005:	e9 ef 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_PPID:
			tf->eax = current->ppid;
c010300a:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010300f:	8b 90 48 20 00 00    	mov    0x2048(%eax),%edx
c0103015:	8b 45 08             	mov    0x8(%ebp),%eax
c0103018:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c010301b:	e9 d9 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
c0103020:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103025:	c7 80 4c 20 00 00 03 	movl   $0x3,0x204c(%eax)
c010302c:	00 00 00 
			current->timeslice = tf->ebx*200;
c010302f:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103034:	8b 55 08             	mov    0x8(%ebp),%edx
c0103037:	8b 52 10             	mov    0x10(%edx),%edx
c010303a:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
c0103040:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
		break;
c0103046:	e9 ae 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_HANDOUT:
			current->ts = STOP;
c010304b:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103050:	c7 80 4c 20 00 00 02 	movl   $0x2,0x204c(%eax)
c0103057:	00 00 00 
		break;
c010305a:	e9 9a 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_EXIT:
			exit_current();
c010305f:	e8 ce 09 00 00       	call   c0103a32 <exit_current>
		break;
c0103064:	e9 90 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_FORK:
			fork_current();
c0103069:	e8 e1 07 00 00       	call   c010384f <fork_current>
		break;
c010306e:	e9 86 00 00 00       	jmp    c01030f9 <do_syscall+0x357>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
c0103073:	8b 45 08             	mov    0x8(%ebp),%eax
c0103076:	8b 40 10             	mov    0x10(%eax),%eax
c0103079:	0f be c0             	movsbl %al,%eax
c010307c:	83 ec 0c             	sub    $0xc,%esp
c010307f:	50                   	push   %eax
c0103080:	e8 ec fc ff ff       	call   c0102d71 <serial_printc>
c0103085:	83 c4 10             	add    $0x10,%esp
			//printk("1\n");
		break;
c0103088:	eb 6f                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_INIT_CACHE:
			initVCache();
c010308a:	e8 d7 0a 00 00       	call   c0103b66 <initVCache>
		break;
c010308f:	eb 68                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_CLEAR_VRAM:
			clearVRAM();
c0103091:	e8 05 0c 00 00       	call   c0103c9b <clearVRAM>
		break;
c0103096:	eb 61                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
c0103098:	e8 fe 0b 00 00       	call   c0103c9b <clearVRAM>
			flushVCache();
c010309d:	e8 2d 0b 00 00       	call   c0103bcf <flushVCache>
		break;
c01030a2:	eb 55                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
c01030a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01030a7:	8b 40 14             	mov    0x14(%eax),%eax
c01030aa:	0f b6 c0             	movzbl %al,%eax
c01030ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01030b0:	8b 52 18             	mov    0x18(%edx),%edx
c01030b3:	89 d1                	mov    %edx,%ecx
c01030b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01030b8:	8b 52 10             	mov    0x10(%edx),%edx
c01030bb:	83 ec 04             	sub    $0x4,%esp
c01030be:	50                   	push   %eax
c01030bf:	51                   	push   %ecx
c01030c0:	52                   	push   %edx
c01030c1:	e8 6e 0b 00 00       	call   c0103c34 <setPixelAt>
c01030c6:	83 c4 10             	add    $0x10,%esp
		break;
c01030c9:	eb 2e                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
c01030cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01030ce:	8b 40 10             	mov    0x10(%eax),%eax
c01030d1:	0f be c0             	movsbl %al,%eax
c01030d4:	83 ec 0c             	sub    $0xc,%esp
c01030d7:	50                   	push   %eax
c01030d8:	e8 c2 fb ff ff       	call   c0102c9f <get_key>
c01030dd:	83 c4 10             	add    $0x10,%esp
c01030e0:	0f be d0             	movsbl %al,%edx
c01030e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01030e6:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
c01030e9:	eb 0e                	jmp    c01030f9 <do_syscall+0x357>
		case SYS_GET_TICK:
			tf->eax = tick();
c01030eb:	e8 f7 0c 00 00       	call   c0103de7 <tick>
c01030f0:	89 c2                	mov    %eax,%edx
c01030f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01030f5:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
c01030f8:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
c01030f9:	c9                   	leave  
c01030fa:	c3                   	ret    

c01030fb <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
c01030fb:	55                   	push   %ebp
c01030fc:	89 e5                	mov    %esp,%ebp
c01030fe:	83 ec 10             	sub    $0x10,%esp
c0103101:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
c0103108:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010310b:	89 c2                	mov    %eax,%edx
c010310d:	ec                   	in     (%dx),%al
c010310e:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
c0103111:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
c0103115:	0f b6 c0             	movzbl %al,%eax
c0103118:	83 e0 20             	and    $0x20,%eax
c010311b:	85 c0                	test   %eax,%eax
c010311d:	0f 95 c0             	setne  %al
c0103120:	0f b6 c0             	movzbl %al,%eax
}
c0103123:	c9                   	leave  
c0103124:	c3                   	ret    

c0103125 <serial_printc>:

static inline
void serial_printc(char ch) {
c0103125:	55                   	push   %ebp
c0103126:	89 e5                	mov    %esp,%ebp
c0103128:	83 ec 14             	sub    $0x14,%esp
c010312b:	8b 45 08             	mov    0x8(%ebp),%eax
c010312e:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
c0103131:	90                   	nop
c0103132:	e8 c4 ff ff ff       	call   c01030fb <serial_idle>
c0103137:	85 c0                	test   %eax,%eax
c0103139:	74 f7                	je     c0103132 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
c010313b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c010313f:	0f b6 c0             	movzbl %al,%eax
c0103142:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
c0103149:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
c010314c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c0103150:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103153:	ee                   	out    %al,(%dx)
}
c0103154:	c9                   	leave  
c0103155:	c3                   	ret    

c0103156 <printk>:
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
c0103156:	55                   	push   %ebp
c0103157:	89 e5                	mov    %esp,%ebp
c0103159:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010315c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010315f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
c0103162:	8b 45 08             	mov    0x8(%ebp),%eax
c0103165:	83 ec 04             	sub    $0x4,%esp
c0103168:	ff 75 f4             	pushl  -0xc(%ebp)
c010316b:	50                   	push   %eax
c010316c:	68 25 31 10 c0       	push   $0xc0103125
c0103171:	e8 f5 0d 00 00       	call   c0103f6b <vfprintf>
c0103176:	83 c4 10             	add    $0x10,%esp
}
c0103179:	c9                   	leave  
c010317a:	c3                   	ret    

c010317b <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
c010317b:	55                   	push   %ebp
c010317c:	89 e5                	mov    %esp,%ebp
c010317e:	57                   	push   %edi
c010317f:	56                   	push   %esi
c0103180:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103181:	8b 45 10             	mov    0x10(%ebp),%eax
c0103184:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103187:	8b 5d 08             	mov    0x8(%ebp),%ebx
c010318a:	89 c1                	mov    %eax,%ecx
c010318c:	89 d6                	mov    %edx,%esi
c010318e:	89 df                	mov    %ebx,%edi
c0103190:	fc                   	cld    
c0103191:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0103193:	5b                   	pop    %ebx
c0103194:	5e                   	pop    %esi
c0103195:	5f                   	pop    %edi
c0103196:	5d                   	pop    %ebp
c0103197:	c3                   	ret    

c0103198 <_paddr>:
 */
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
c0103198:	55                   	push   %ebp
c0103199:	89 e5                	mov    %esp,%ebp
c010319b:	83 ec 08             	sub    $0x8,%esp
	if ((uint32_t)kva < KERNBASE)
c010319e:	8b 45 10             	mov    0x10(%ebp),%eax
c01031a1:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
c01031a6:	77 16                	ja     c01031be <_paddr+0x26>
		printk(file, line, "PADDR called with invalid kva 0x%x", kva);
c01031a8:	ff 75 10             	pushl  0x10(%ebp)
c01031ab:	68 18 44 10 c0       	push   $0xc0104418
c01031b0:	ff 75 0c             	pushl  0xc(%ebp)
c01031b3:	ff 75 08             	pushl  0x8(%ebp)
c01031b6:	e8 9b ff ff ff       	call   c0103156 <printk>
c01031bb:	83 c4 10             	add    $0x10,%esp
	return (physaddr_t)kva - KERNBASE;
c01031be:	8b 45 10             	mov    0x10(%ebp),%eax
c01031c1:	05 00 00 00 40       	add    $0x40000000,%eax
}
c01031c6:	c9                   	leave  
c01031c7:	c3                   	ret    

c01031c8 <_kaddr>:
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
c01031c8:	55                   	push   %ebp
c01031c9:	89 e5                	mov    %esp,%ebp
c01031cb:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c01031ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01031d1:	c1 e8 0c             	shr    $0xc,%eax
c01031d4:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c01031d9:	76 13                	jbe    c01031ee <_kaddr+0x26>
		printk("KADDR called with invalid pa 0x%x", pa);
c01031db:	83 ec 08             	sub    $0x8,%esp
c01031de:	ff 75 10             	pushl  0x10(%ebp)
c01031e1:	68 3c 44 10 c0       	push   $0xc010443c
c01031e6:	e8 6b ff ff ff       	call   c0103156 <printk>
c01031eb:	83 c4 10             	add    $0x10,%esp
	return (void *)(pa + KERNBASE);
c01031ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01031f1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01031f6:	c9                   	leave  
c01031f7:	c3                   	ret    

c01031f8 <page2pa>:
void	tlb_invalidate(pde_t *pgdir, void *va);


static inline physaddr_t
page2pa(struct PageInfo *pp)
{
c01031f8:	55                   	push   %ebp
c01031f9:	89 e5                	mov    %esp,%ebp
	return (pp - pages) << PGSHIFT;
c01031fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fe:	ba 00 57 17 c0       	mov    $0xc0175700,%edx
c0103203:	29 d0                	sub    %edx,%eax
c0103205:	c1 f8 03             	sar    $0x3,%eax
c0103208:	c1 e0 0c             	shl    $0xc,%eax
}
c010320b:	5d                   	pop    %ebp
c010320c:	c3                   	ret    

c010320d <pa2page>:

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
c010320d:	55                   	push   %ebp
c010320e:	89 e5                	mov    %esp,%ebp
c0103210:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
c0103213:	8b 45 08             	mov    0x8(%ebp),%eax
c0103216:	c1 e8 0c             	shr    $0xc,%eax
c0103219:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
c010321e:	76 10                	jbe    c0103230 <pa2page+0x23>
		printk("pa2page called with invalid pa");
c0103220:	83 ec 0c             	sub    $0xc,%esp
c0103223:	68 60 44 10 c0       	push   $0xc0104460
c0103228:	e8 29 ff ff ff       	call   c0103156 <printk>
c010322d:	83 c4 10             	add    $0x10,%esp
	return &pages[PGNUM(pa)];
c0103230:	8b 45 08             	mov    0x8(%ebp),%eax
c0103233:	c1 e8 0c             	shr    $0xc,%eax
c0103236:	c1 e0 03             	shl    $0x3,%eax
c0103239:	05 00 57 17 c0       	add    $0xc0175700,%eax
}
c010323e:	c9                   	leave  
c010323f:	c3                   	ret    

c0103240 <page2kva>:

static inline void*
page2kva(struct PageInfo *pp)
{
c0103240:	55                   	push   %ebp
c0103241:	89 e5                	mov    %esp,%ebp
c0103243:	83 ec 08             	sub    $0x8,%esp
	return KADDR(page2pa(pp));
c0103246:	ff 75 08             	pushl  0x8(%ebp)
c0103249:	e8 aa ff ff ff       	call   c01031f8 <page2pa>
c010324e:	83 c4 04             	add    $0x4,%esp
c0103251:	83 ec 04             	sub    $0x4,%esp
c0103254:	50                   	push   %eax
c0103255:	6a 52                	push   $0x52
c0103257:	68 7f 44 10 c0       	push   $0xc010447f
c010325c:	e8 67 ff ff ff       	call   c01031c8 <_kaddr>
c0103261:	83 c4 10             	add    $0x10,%esp
}
c0103264:	c9                   	leave  
c0103265:	c3                   	ret    

c0103266 <ll_len>:
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

uint32_t ll_len(PCB** head){
c0103266:	55                   	push   %ebp
c0103267:	89 e5                	mov    %esp,%ebp
c0103269:	83 ec 10             	sub    $0x10,%esp
	uint32_t i = 0;
c010326c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	PCB* p = *head;
c0103273:	8b 45 08             	mov    0x8(%ebp),%eax
c0103276:	8b 00                	mov    (%eax),%eax
c0103278:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while(p){
c010327b:	eb 10                	jmp    c010328d <ll_len+0x27>
		p = p->next;
c010327d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103280:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103286:	89 45 f8             	mov    %eax,-0x8(%ebp)
		i++;
c0103289:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
};*/

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
c010328d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103291:	75 ea                	jne    c010327d <ll_len+0x17>
		p = p->next;
		i++;
	}
	return i;
c0103293:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103296:	c9                   	leave  
c0103297:	c3                   	ret    

c0103298 <ll_pop>:
PCB* ll_pop(PCB** head){
c0103298:	55                   	push   %ebp
c0103299:	89 e5                	mov    %esp,%ebp
c010329b:	83 ec 18             	sub    $0x18,%esp
	PCB* p = *head;
c010329e:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a1:	8b 00                	mov    (%eax),%eax
c01032a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	ll_delete(head, p);
c01032a6:	83 ec 08             	sub    $0x8,%esp
c01032a9:	ff 75 f4             	pushl  -0xc(%ebp)
c01032ac:	ff 75 08             	pushl  0x8(%ebp)
c01032af:	e8 a4 00 00 00       	call   c0103358 <ll_delete>
c01032b4:	83 c4 10             	add    $0x10,%esp
	return p;
c01032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01032ba:	c9                   	leave  
c01032bb:	c3                   	ret    

c01032bc <ll_push>:
uint32_t ll_push(PCB** head, PCB* p){
c01032bc:	55                   	push   %ebp
c01032bd:	89 e5                	mov    %esp,%ebp
c01032bf:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c01032c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01032c5:	8b 00                	mov    (%eax),%eax
c01032c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(h == NULL){
c01032ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01032ce:	75 0f                	jne    c01032df <ll_push+0x23>
		*head = p;
c01032d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032d6:	89 10                	mov    %edx,(%eax)
		return 0;
c01032d8:	b8 00 00 00 00       	mov    $0x0,%eax
c01032dd:	eb 19                	jmp    c01032f8 <ll_push+0x3c>
	}else{
		*head = p;
c01032df:	8b 45 08             	mov    0x8(%ebp),%eax
c01032e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032e5:	89 10                	mov    %edx,(%eax)
		p->next = h;
c01032e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032ed:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c01032f3:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c01032f8:	c9                   	leave  
c01032f9:	c3                   	ret    

c01032fa <ll_entail>:
uint32_t ll_entail(PCB** head, PCB* p){
c01032fa:	55                   	push   %ebp
c01032fb:	89 e5                	mov    %esp,%ebp
c01032fd:	83 ec 10             	sub    $0x10,%esp
	PCB* h = *head;
c0103300:	8b 45 08             	mov    0x8(%ebp),%eax
c0103303:	8b 00                	mov    (%eax),%eax
c0103305:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
c0103308:	8b 45 0c             	mov    0xc(%ebp),%eax
c010330b:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c0103312:	00 00 00 
	if(h == NULL){
c0103315:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103319:	75 0f                	jne    c010332a <ll_entail+0x30>
		*head = p;
c010331b:	8b 45 08             	mov    0x8(%ebp),%eax
c010331e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103321:	89 10                	mov    %edx,(%eax)
		return 0;
c0103323:	b8 00 00 00 00       	mov    $0x0,%eax
c0103328:	eb 2c                	jmp    c0103356 <ll_entail+0x5c>
	}else{
		while(h->next){
c010332a:	eb 0c                	jmp    c0103338 <ll_entail+0x3e>
			h = h->next;
c010332c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010332f:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103335:	89 45 fc             	mov    %eax,-0x4(%ebp)
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
c0103338:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010333b:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103341:	85 c0                	test   %eax,%eax
c0103343:	75 e7                	jne    c010332c <ll_entail+0x32>
			h = h->next;
		}
		h->next = p;
c0103345:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103348:	8b 55 0c             	mov    0xc(%ebp),%edx
c010334b:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		return 1;
c0103351:	b8 01 00 00 00       	mov    $0x1,%eax
	}
}
c0103356:	c9                   	leave  
c0103357:	c3                   	ret    

c0103358 <ll_delete>:
uint32_t ll_delete(PCB** head, PCB* p){
c0103358:	55                   	push   %ebp
c0103359:	89 e5                	mov    %esp,%ebp
c010335b:	83 ec 10             	sub    $0x10,%esp
	PCB *sleep = *head, *pre = NULL;
c010335e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103361:	8b 00                	mov    (%eax),%eax
c0103363:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0103366:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	while(1){
		if(sleep == NULL)
c010336d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103371:	75 07                	jne    c010337a <ll_delete+0x22>
			return 0;
c0103373:	b8 00 00 00 00       	mov    $0x0,%eax
c0103378:	eb 59                	jmp    c01033d3 <ll_delete+0x7b>
		if(sleep == p)
c010337a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010337d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103380:	75 09                	jne    c010338b <ll_delete+0x33>
			break;
c0103382:	90                   	nop
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
c0103383:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103387:	75 26                	jne    c01033af <ll_delete+0x57>
c0103389:	eb 14                	jmp    c010339f <ll_delete+0x47>
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
c010338b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010338e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		sleep = sleep->next;
c0103391:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103394:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c010339a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	}
c010339d:	eb ce                	jmp    c010336d <ll_delete+0x15>
	if(pre == NULL)
		*head = sleep->next;
c010339f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033a2:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01033a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01033ab:	89 10                	mov    %edx,(%eax)
c01033ad:	eb 12                	jmp    c01033c1 <ll_delete+0x69>
	else
		pre->next = sleep->next;
c01033af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033b2:	8b 90 60 20 00 00    	mov    0x2060(%eax),%edx
c01033b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01033bb:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
	sleep->next = NULL;
c01033c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033c4:	c7 80 60 20 00 00 00 	movl   $0x0,0x2060(%eax)
c01033cb:	00 00 00 
	return 1;
c01033ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01033d3:	c9                   	leave  
c01033d4:	c3                   	ret    

c01033d5 <init_pcb_pool>:

void init_pcb_pool()
{
c01033d5:	55                   	push   %ebp
c01033d6:	89 e5                	mov    %esp,%ebp
c01033d8:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01033db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01033e2:	eb 1d                	jmp    c0103401 <init_pcb_pool+0x2c>
		PCBPool[i].used = 0;
c01033e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033e7:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c01033ed:	05 40 20 00 00       	add    $0x2040,%eax
c01033f2:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c01033f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c01033fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103401:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%ebp)
c0103408:	76 da                	jbe    c01033e4 <init_pcb_pool+0xf>
		PCBPool[i].used = 0;
	}
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}
c010340a:	c9                   	leave  
c010340b:	c3                   	ret    

c010340c <init_pcb>:

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
c010340c:	55                   	push   %ebp
c010340d:	89 e5                	mov    %esp,%ebp
c010340f:	83 ec 24             	sub    $0x24,%esp
c0103412:	8b 45 14             	mov    0x14(%ebp),%eax
c0103415:	88 45 dc             	mov    %al,-0x24(%ebp)
	struct TrapFrame *tf = (p->tf);
c0103418:	8b 45 08             	mov    0x8(%ebp),%eax
c010341b:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103421:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(pri == 0){
c0103424:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c0103428:	75 46                	jne    c0103470 <init_pcb+0x64>
		tf->ds = GD_KD;
c010342a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010342d:	c7 40 2c 10 00 00 00 	movl   $0x10,0x2c(%eax)
		tf->es = GD_KD;
c0103434:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103437:	c7 40 28 10 00 00 00 	movl   $0x10,0x28(%eax)
		tf->ss = GD_KD;
c010343e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103441:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
		tf->fs = GD_KD;
c0103447:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010344a:	c7 40 24 10 00 00 00 	movl   $0x10,0x24(%eax)
		tf->gs = GD_KD;
c0103451:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103454:	c7 40 20 10 00 00 00 	movl   $0x10,0x20(%eax)
		tf->cs = GD_KT;
c010345b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010345e:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c0103464:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103467:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
c010346e:	eb 4a                	jmp    c01034ba <init_pcb+0xae>
	}else
	if(pri == 3){
c0103470:	80 7d dc 03          	cmpb   $0x3,-0x24(%ebp)
c0103474:	75 44                	jne    c01034ba <init_pcb+0xae>
		tf->ds = GD_UD | 3;
c0103476:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103479:	c7 40 2c 23 00 00 00 	movl   $0x23,0x2c(%eax)
		tf->es = GD_UD | 3;
c0103480:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103483:	c7 40 28 23 00 00 00 	movl   $0x23,0x28(%eax)
		tf->ss = GD_UD | 3;
c010348a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010348d:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
		tf->fs = GD_UD | 3;
c0103493:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103496:	c7 40 24 23 00 00 00 	movl   $0x23,0x24(%eax)
		tf->gs = GD_UD | 3;
c010349d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034a0:	c7 40 20 23 00 00 00 	movl   $0x23,0x20(%eax)
		tf->cs = GD_UT | 3;
c01034a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034aa:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		tf->eflags = 0x2 | FL_IF;
c01034b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034b3:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	}
	
	tf->esp = ustack;
c01034ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034c0:	89 50 44             	mov    %edx,0x44(%eax)

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
c01034c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034c6:	8b 55 10             	mov    0x10(%ebp),%edx
c01034c9:	89 50 38             	mov    %edx,0x38(%eax)
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
c01034cc:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c01034d0:	75 59                	jne    c010352b <init_pcb+0x11f>
		uint32_t* ptr1 = (void*)(ustack);
c01034d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint32_t* ptr2 = (void*)tf;
c01034d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01034db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32_t si = sizeof(struct TrapFrame);
c01034de:	c7 45 ec 4c 00 00 00 	movl   $0x4c,-0x14(%ebp)
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c01034e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01034ec:	eb 26                	jmp    c0103514 <init_pcb+0x108>
		{
			ptr1[i] = ptr2[i];
c01034ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fb:	01 c2                	add    %eax,%edx
c01034fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103500:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
c0103507:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010350a:	01 c8                	add    %ecx,%eax
c010350c:	8b 00                	mov    (%eax),%eax
c010350e:	89 02                	mov    %eax,(%edx)
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
c0103510:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103514:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103517:	c1 e8 02             	shr    $0x2,%eax
c010351a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010351d:	77 cf                	ja     c01034ee <init_pcb+0xe2>
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
c010351f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103522:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103525:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	}
	p->tt = pri==0?KERNEL:USER;
c010352b:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
c010352f:	0f 95 c0             	setne  %al
c0103532:	0f b6 d0             	movzbl %al,%edx
c0103535:	8b 45 08             	mov    0x8(%ebp),%eax
c0103538:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)
	//lcr3(PADDR(kern_pgdir));
}
c010353e:	c9                   	leave  
c010353f:	c3                   	ret    

c0103540 <pcb_create>:

PCB* pcb_create()
{
c0103540:	55                   	push   %ebp
c0103541:	89 e5                	mov    %esp,%ebp
c0103543:	83 ec 18             	sub    $0x18,%esp
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010354d:	eb 1f                	jmp    c010356e <pcb_create+0x2e>
		if(!PCBPool[i].used)break;
c010354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103552:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103558:	05 40 20 00 00       	add    $0x2040,%eax
c010355d:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c0103562:	8b 00                	mov    (%eax),%eax
c0103564:	85 c0                	test   %eax,%eax
c0103566:	75 02                	jne    c010356a <pcb_create+0x2a>
c0103568:	eb 0d                	jmp    c0103577 <pcb_create+0x37>
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c010356a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010356e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0103575:	76 d8                	jbe    c010354f <pcb_create+0xf>
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
c0103577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357a:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103580:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c0103585:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p->tf = &tfPool[i];
c0103588:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010358b:	6b c0 4c             	imul   $0x4c,%eax,%eax
c010358e:	8d 90 40 e0 1d c0    	lea    -0x3fe21fc0(%eax),%edx
c0103594:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103597:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	p->used = 1;
c010359d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035a0:	c7 80 40 20 00 00 01 	movl   $0x1,0x2040(%eax)
c01035a7:	00 00 00 
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
c01035aa:	83 ec 0c             	sub    $0xc,%esp
c01035ad:	6a 01                	push   $0x1
c01035af:	e8 cf d2 ff ff       	call   c0100883 <page_alloc>
c01035b4:	83 c4 10             	add    $0x10,%esp
c01035b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
c01035ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01035be:	75 07                	jne    c01035c7 <pcb_create+0x87>
c01035c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01035c5:	eb 77                	jmp    c010363e <pcb_create+0xfe>
	p->pgdir = page2kva(pp);
c01035c7:	83 ec 0c             	sub    $0xc,%esp
c01035ca:	ff 75 ec             	pushl  -0x14(%ebp)
c01035cd:	e8 6e fc ff ff       	call   c0103240 <page2kva>
c01035d2:	83 c4 10             	add    $0x10,%esp
c01035d5:	89 c2                	mov    %eax,%edx
c01035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035da:	89 90 5c 20 00 00    	mov    %edx,0x205c(%eax)
	p->pid = pid;
c01035e0:	8b 15 a8 80 10 c0    	mov    0xc01080a8,%edx
c01035e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035e9:	89 90 44 20 00 00    	mov    %edx,0x2044(%eax)
	p->timeslice = 0;
c01035ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035f2:	c7 80 54 20 00 00 00 	movl   $0x0,0x2054(%eax)
c01035f9:	00 00 00 
	//p->ts = READY;
	pid ++;
c01035fc:	a1 a8 80 10 c0       	mov    0xc01080a8,%eax
c0103601:	83 c0 01             	add    $0x1,%eax
c0103604:	a3 a8 80 10 c0       	mov    %eax,0xc01080a8
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
c0103609:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010360c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
c0103610:	8d 50 01             	lea    0x1(%eax),%edx
c0103613:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103616:	66 89 50 04          	mov    %dx,0x4(%eax)
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
c010361a:	8b 15 c0 56 17 c0    	mov    0xc01756c0,%edx
c0103620:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103623:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103629:	83 ec 04             	sub    $0x4,%esp
c010362c:	68 00 10 00 00       	push   $0x1000
c0103631:	52                   	push   %edx
c0103632:	50                   	push   %eax
c0103633:	e8 43 fb ff ff       	call   c010317b <memcpy>
c0103638:	83 c4 10             	add    $0x10,%esp
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
c010363b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010363e:	c9                   	leave  
c010363f:	c3                   	ret    

c0103640 <enready_pcb>:

void enready_pcb(PCB* pcb){
c0103640:	55                   	push   %ebp
c0103641:	89 e5                	mov    %esp,%ebp
c0103643:	83 ec 10             	sub    $0x10,%esp
	if(ready_list == NULL){
c0103646:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c010364b:	85 c0                	test   %eax,%eax
c010364d:	75 18                	jne    c0103667 <enready_pcb+0x27>
		ready_list = pcb;
c010364f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103652:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->tail = pcb;
c0103657:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c010365c:	8b 55 08             	mov    0x8(%ebp),%edx
c010365f:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
c0103665:	eb 32                	jmp    c0103699 <enready_pcb+0x59>
	}else{
		PCB* temp = ready_list;
c0103667:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c010366c:	89 45 fc             	mov    %eax,-0x4(%ebp)
		ready_list = pcb;
c010366f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103672:	a3 b0 60 15 c0       	mov    %eax,0xc01560b0
		ready_list->next = temp;
c0103677:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c010367c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010367f:	89 90 60 20 00 00    	mov    %edx,0x2060(%eax)
		ready_list->tail = temp->tail;
c0103685:	a1 b0 60 15 c0       	mov    0xc01560b0,%eax
c010368a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010368d:	8b 92 64 20 00 00    	mov    0x2064(%edx),%edx
c0103693:	89 90 64 20 00 00    	mov    %edx,0x2064(%eax)
	}
}
c0103699:	c9                   	leave  
c010369a:	c3                   	ret    

c010369b <switch_pcb>:

void switch_pcb(PCB* pcb){
c010369b:	55                   	push   %ebp
c010369c:	89 e5                	mov    %esp,%ebp
c010369e:	83 ec 18             	sub    $0x18,%esp
	current = pcb;
c01036a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a4:	a3 ac 60 15 c0       	mov    %eax,0xc01560ac
	lcr3(PADDR(pcb -> pgdir));
c01036a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ac:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01036b2:	83 ec 04             	sub    $0x4,%esp
c01036b5:	50                   	push   %eax
c01036b6:	68 af 00 00 00       	push   $0xaf
c01036bb:	68 95 44 10 c0       	push   $0xc0104495
c01036c0:	e8 d3 fa ff ff       	call   c0103198 <_paddr>
c01036c5:	83 c4 10             	add    $0x10,%esp
c01036c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
c01036cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ce:	0f 22 d8             	mov    %eax,%cr3
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
c01036d1:	83 ec 0c             	sub    $0xc,%esp
c01036d4:	ff 75 08             	pushl  0x8(%ebp)
c01036d7:	e8 80 cc ff ff       	call   c010035c <enter_pcb>
c01036dc:	83 c4 10             	add    $0x10,%esp
}
c01036df:	c9                   	leave  
c01036e0:	c3                   	ret    

c01036e1 <free_pcb>:
void free_pcb(PCB* pcb){
c01036e1:	55                   	push   %ebp
c01036e2:	89 e5                	mov    %esp,%ebp
c01036e4:	83 ec 08             	sub    $0x8,%esp
	free_pgdir(pcb->pgdir);
c01036e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ea:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01036f0:	83 ec 0c             	sub    $0xc,%esp
c01036f3:	50                   	push   %eax
c01036f4:	e8 ee d6 ff ff       	call   c0100de7 <free_pgdir>
c01036f9:	83 c4 10             	add    $0x10,%esp
	page_decref(pa2page(PADDR(pcb->pgdir)));
c01036fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ff:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103705:	83 ec 04             	sub    $0x4,%esp
c0103708:	50                   	push   %eax
c0103709:	68 b8 00 00 00       	push   $0xb8
c010370e:	68 95 44 10 c0       	push   $0xc0104495
c0103713:	e8 80 fa ff ff       	call   c0103198 <_paddr>
c0103718:	83 c4 10             	add    $0x10,%esp
c010371b:	83 ec 0c             	sub    $0xc,%esp
c010371e:	50                   	push   %eax
c010371f:	e8 e9 fa ff ff       	call   c010320d <pa2page>
c0103724:	83 c4 10             	add    $0x10,%esp
c0103727:	83 ec 0c             	sub    $0xc,%esp
c010372a:	50                   	push   %eax
c010372b:	e8 db d1 ff ff       	call   c010090b <page_decref>
c0103730:	83 c4 10             	add    $0x10,%esp
	pcb->used = 0;
c0103733:	8b 45 08             	mov    0x8(%ebp),%eax
c0103736:	c7 80 40 20 00 00 00 	movl   $0x0,0x2040(%eax)
c010373d:	00 00 00 

}
c0103740:	c9                   	leave  
c0103741:	c3                   	ret    

c0103742 <copy_pcb>:

void copy_pcb(PCB *dst, PCB *src)
{
c0103742:	55                   	push   %ebp
c0103743:	89 e5                	mov    %esp,%ebp
c0103745:	83 ec 18             	sub    $0x18,%esp
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
c0103748:	8b 55 0c             	mov    0xc(%ebp),%edx
c010374b:	8b 45 08             	mov    0x8(%ebp),%eax
c010374e:	68 10 08 00 00       	push   $0x810
c0103753:	52                   	push   %edx
c0103754:	50                   	push   %eax
c0103755:	e8 21 fa ff ff       	call   c010317b <memcpy>
c010375a:	83 c4 0c             	add    $0xc,%esp
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
c010375d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103760:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0103766:	8b 45 08             	mov    0x8(%ebp),%eax
c0103769:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
c010376f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103772:	05 20 10 00 00       	add    $0x1020,%eax
c0103777:	89 c2                	mov    %eax,%edx
c0103779:	8b 45 0c             	mov    0xc(%ebp),%eax
c010377c:	05 20 10 00 00       	add    $0x1020,%eax
c0103781:	29 c2                	sub    %eax,%edx
c0103783:	89 d0                	mov    %edx,%eax
c0103785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	dst->tf = (void*)src->tf + offset;
c0103788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010378b:	8b 90 58 20 00 00    	mov    0x2058(%eax),%edx
c0103791:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103794:	01 c2                	add    %eax,%edx
c0103796:	8b 45 08             	mov    0x8(%ebp),%eax
c0103799:	89 90 58 20 00 00    	mov    %edx,0x2058(%eax)
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;
c010379f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037a2:	8b 90 50 20 00 00    	mov    0x2050(%eax),%edx
c01037a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ab:	89 90 50 20 00 00    	mov    %edx,0x2050(%eax)

	if(dst->tt == KERNEL){
c01037b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01037b4:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c01037ba:	85 c0                	test   %eax,%eax
c01037bc:	75 62                	jne    c0103820 <copy_pcb+0xde>
		
		dst->tf->ebp += offset;
c01037be:	8b 45 08             	mov    0x8(%ebp),%eax
c01037c1:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037c7:	8b 55 08             	mov    0x8(%ebp),%edx
c01037ca:	8b 92 58 20 00 00    	mov    0x2058(%edx),%edx
c01037d0:	8b 4a 08             	mov    0x8(%edx),%ecx
c01037d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01037d6:	01 ca                	add    %ecx,%edx
c01037d8:	89 50 08             	mov    %edx,0x8(%eax)
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
c01037db:	8b 45 08             	mov    0x8(%ebp),%eax
c01037de:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01037e4:	8b 40 08             	mov    0x8(%eax),%eax
c01037e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(*(ptr)!=0){
c01037ea:	eb 17                	jmp    c0103803 <copy_pcb+0xc1>
			*(ptr) += offset;
c01037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ef:	8b 10                	mov    (%eax),%edx
c01037f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037f4:	01 c2                	add    %eax,%edx
c01037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f9:	89 10                	mov    %edx,(%eax)
			ptr = (uint32_t*)*(ptr);
c01037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037fe:	8b 00                	mov    (%eax),%eax
c0103800:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
c0103803:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103806:	8b 00                	mov    (%eax),%eax
c0103808:	85 c0                	test   %eax,%eax
c010380a:	75 e0                	jne    c01037ec <copy_pcb+0xaa>
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
c010380c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010380f:	8b 90 4c 20 00 00    	mov    0x204c(%eax),%edx
c0103815:	8b 45 08             	mov    0x8(%ebp),%eax
c0103818:	89 90 4c 20 00 00    	mov    %edx,0x204c(%eax)
c010381e:	eb 2d                	jmp    c010384d <copy_pcb+0x10b>
	}else if(dst->tt != THREAD){
c0103820:	8b 45 08             	mov    0x8(%ebp),%eax
c0103823:	8b 80 50 20 00 00    	mov    0x2050(%eax),%eax
c0103829:	83 f8 02             	cmp    $0x2,%eax
c010382c:	74 1f                	je     c010384d <copy_pcb+0x10b>
		copy_pgdir(dst->pgdir, src->pgdir);
c010382e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103831:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c0103837:	8b 45 08             	mov    0x8(%ebp),%eax
c010383a:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103840:	83 ec 08             	sub    $0x8,%esp
c0103843:	52                   	push   %edx
c0103844:	50                   	push   %eax
c0103845:	e8 e8 d2 ff ff       	call   c0100b32 <copy_pgdir>
c010384a:	83 c4 10             	add    $0x10,%esp
	}
	//lcr3(PADDR(kern_pgdir));
}
c010384d:	c9                   	leave  
c010384e:	c3                   	ret    

c010384f <fork_current>:

void switch_proc();
void fork_current(){
c010384f:	55                   	push   %ebp
c0103850:	89 e5                	mov    %esp,%ebp
c0103852:	83 ec 18             	sub    $0x18,%esp
	PCB* son = pcb_create();
c0103855:	e8 e6 fc ff ff       	call   c0103540 <pcb_create>
c010385a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	son->ppid = current->pid;
c010385d:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103862:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c0103868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010386b:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c0103871:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103876:	83 ec 08             	sub    $0x8,%esp
c0103879:	50                   	push   %eax
c010387a:	ff 75 f4             	pushl  -0xc(%ebp)
c010387d:	e8 c0 fe ff ff       	call   c0103742 <copy_pcb>
c0103882:	83 c4 10             	add    $0x10,%esp

	current->tf->eax = son->pid;
c0103885:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010388a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103890:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103893:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c0103899:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010389c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010389f:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01038a5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	ll_push(&ready_list, son);
c01038ac:	83 ec 08             	sub    $0x8,%esp
c01038af:	ff 75 f4             	pushl  -0xc(%ebp)
c01038b2:	68 b0 60 15 c0       	push   $0xc01560b0
c01038b7:	e8 00 fa ff ff       	call   c01032bc <ll_push>
c01038bc:	83 c4 10             	add    $0x10,%esp
}
c01038bf:	c9                   	leave  
c01038c0:	c3                   	ret    

c01038c1 <thread_current>:

void thread_current(uint32_t entry, uint32_t exit, uint32_t arg){
c01038c1:	55                   	push   %ebp
c01038c2:	89 e5                	mov    %esp,%ebp
c01038c4:	83 ec 28             	sub    $0x28,%esp
	PCB* son = pcb_create();
c01038c7:	e8 74 fc ff ff       	call   c0103540 <pcb_create>
c01038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	son->tt = THREAD;
c01038cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038d2:	c7 80 50 20 00 00 02 	movl   $0x2,0x2050(%eax)
c01038d9:	00 00 00 
	son->ppid = current->pid;
c01038dc:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01038e1:	8b 90 44 20 00 00    	mov    0x2044(%eax),%edx
c01038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038ea:	89 90 48 20 00 00    	mov    %edx,0x2048(%eax)

	copy_pcb(son, current);
c01038f0:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01038f5:	83 ec 08             	sub    $0x8,%esp
c01038f8:	50                   	push   %eax
c01038f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01038fc:	e8 41 fe ff ff       	call   c0103742 <copy_pcb>
c0103901:	83 c4 10             	add    $0x10,%esp
	memcpy(son->pgdir, current->pgdir, PGSIZE);
c0103904:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103909:	8b 90 5c 20 00 00    	mov    0x205c(%eax),%edx
c010390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103912:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103918:	83 ec 04             	sub    $0x4,%esp
c010391b:	68 00 10 00 00       	push   $0x1000
c0103920:	52                   	push   %edx
c0103921:	50                   	push   %eax
c0103922:	e8 54 f8 ff ff       	call   c010317b <memcpy>
c0103927:	83 c4 10             	add    $0x10,%esp

	uint32_t esp = 0xeebfd000;
c010392a:	c7 45 f0 00 d0 bf ee 	movl   $0xeebfd000,-0x10(%ebp)
	mm_alloc(son->pgdir, esp-2*NPKSTACKSIZE, 2*NPKSTACKSIZE);
c0103931:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103934:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
c010393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010393d:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c0103943:	83 ec 04             	sub    $0x4,%esp
c0103946:	68 00 20 00 00       	push   $0x2000
c010394b:	52                   	push   %edx
c010394c:	50                   	push   %eax
c010394d:	e8 3f cd ff ff       	call   c0100691 <mm_alloc>
c0103952:	83 c4 10             	add    $0x10,%esp

	son->tf->ebp = esp-0x40;
c0103955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103958:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c010395e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103961:	83 ea 40             	sub    $0x40,%edx
c0103964:	89 50 08             	mov    %edx,0x8(%eax)
	son->tf->esp = esp-0x40;
c0103967:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010396a:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103970:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103973:	83 ea 40             	sub    $0x40,%edx
c0103976:	89 50 44             	mov    %edx,0x44(%eax)
	son->tf->eip = entry;
c0103979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010397c:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103982:	8b 55 08             	mov    0x8(%ebp),%edx
c0103985:	89 50 38             	mov    %edx,0x38(%eax)

	current->tf->eax = son->pid;
c0103988:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c010398d:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c0103993:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103996:	8b 92 44 20 00 00    	mov    0x2044(%edx),%edx
c010399c:	89 50 1c             	mov    %edx,0x1c(%eax)
	son->tf->eax = 0;
c010399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a2:	8b 80 58 20 00 00    	mov    0x2058(%eax),%eax
c01039a8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	
	lcr3(PADDR(son->pgdir));
c01039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b2:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01039b8:	83 ec 04             	sub    $0x4,%esp
c01039bb:	50                   	push   %eax
c01039bc:	68 fb 00 00 00       	push   $0xfb
c01039c1:	68 95 44 10 c0       	push   $0xc0104495
c01039c6:	e8 cd f7 ff ff       	call   c0103198 <_paddr>
c01039cb:	83 c4 10             	add    $0x10,%esp
c01039ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039d4:	0f 22 d8             	mov    %eax,%cr3

	uint32_t* ptr=(uint32_t*)(esp-0x40);
c01039d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039da:	83 e8 40             	sub    $0x40,%eax
c01039dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptr[0] = (uint32_t)exit;
c01039e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039e6:	89 10                	mov    %edx,(%eax)
	ptr[1] = arg;
c01039e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039eb:	8d 50 04             	lea    0x4(%eax),%edx
c01039ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01039f1:	89 02                	mov    %eax,(%edx)

	lcr3(PADDR(current->pgdir));
c01039f3:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c01039f8:	8b 80 5c 20 00 00    	mov    0x205c(%eax),%eax
c01039fe:	83 ec 04             	sub    $0x4,%esp
c0103a01:	50                   	push   %eax
c0103a02:	68 01 01 00 00       	push   $0x101
c0103a07:	68 95 44 10 c0       	push   $0xc0104495
c0103a0c:	e8 87 f7 ff ff       	call   c0103198 <_paddr>
c0103a11:	83 c4 10             	add    $0x10,%esp
c0103a14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a1a:	0f 22 d8             	mov    %eax,%cr3

	ll_push(&ready_list, son);
c0103a1d:	83 ec 08             	sub    $0x8,%esp
c0103a20:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a23:	68 b0 60 15 c0       	push   $0xc01560b0
c0103a28:	e8 8f f8 ff ff       	call   c01032bc <ll_push>
c0103a2d:	83 c4 10             	add    $0x10,%esp
}
c0103a30:	c9                   	leave  
c0103a31:	c3                   	ret    

c0103a32 <exit_current>:

void exit_current(){
c0103a32:	55                   	push   %ebp
c0103a33:	89 e5                	mov    %esp,%ebp
c0103a35:	83 ec 18             	sub    $0x18,%esp

	PCB* p;

	while(1){
		p = ll_pop(&current->join_list);
c0103a38:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103a3d:	05 68 20 00 00       	add    $0x2068,%eax
c0103a42:	83 ec 0c             	sub    $0xc,%esp
c0103a45:	50                   	push   %eax
c0103a46:	e8 4d f8 ff ff       	call   c0103298 <ll_pop>
c0103a4b:	83 c4 10             	add    $0x10,%esp
c0103a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p == NULL) break;
c0103a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a55:	75 02                	jne    c0103a59 <exit_current+0x27>
c0103a57:	eb 24                	jmp    c0103a7d <exit_current+0x4b>
		if(p->used == 0) continue;
c0103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5c:	8b 80 40 20 00 00    	mov    0x2040(%eax),%eax
c0103a62:	85 c0                	test   %eax,%eax
c0103a64:	75 02                	jne    c0103a68 <exit_current+0x36>
c0103a66:	eb 13                	jmp    c0103a7b <exit_current+0x49>
		ll_entail(&ready_list, p);
c0103a68:	83 ec 08             	sub    $0x8,%esp
c0103a6b:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a6e:	68 b0 60 15 c0       	push   $0xc01560b0
c0103a73:	e8 82 f8 ff ff       	call   c01032fa <ll_entail>
c0103a78:	83 c4 10             	add    $0x10,%esp
	}
c0103a7b:	eb bb                	jmp    c0103a38 <exit_current+0x6>
	
	free_pcb(current);
c0103a7d:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103a82:	83 ec 0c             	sub    $0xc,%esp
c0103a85:	50                   	push   %eax
c0103a86:	e8 56 fc ff ff       	call   c01036e1 <free_pcb>
c0103a8b:	83 c4 10             	add    $0x10,%esp
	current = NULL;
c0103a8e:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0103a95:	00 00 00 
	do_scheduler();
c0103a98:	e8 0e d6 ff ff       	call   c01010ab <do_scheduler>
}
c0103a9d:	c9                   	leave  
c0103a9e:	c3                   	ret    

c0103a9f <join_current>:

void join_current(int pid){
c0103a9f:	55                   	push   %ebp
c0103aa0:	89 e5                	mov    %esp,%ebp
c0103aa2:	83 ec 18             	sub    $0x18,%esp
	if(pid == 0)return;
c0103aa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103aa9:	75 05                	jne    c0103ab0 <join_current+0x11>
c0103aab:	e9 97 00 00 00       	jmp    c0103b47 <join_current+0xa8>
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ab7:	eb 23                	jmp    c0103adc <join_current+0x3d>
		if(PCBPool[i].pid == pid)break;
c0103ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103abc:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103ac2:	05 40 20 00 00       	add    $0x2040,%eax
c0103ac7:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c0103acc:	8b 50 04             	mov    0x4(%eax),%edx
c0103acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad2:	39 c2                	cmp    %eax,%edx
c0103ad4:	75 02                	jne    c0103ad8 <join_current+0x39>
c0103ad6:	eb 0d                	jmp    c0103ae5 <join_current+0x46>
}

void join_current(int pid){
	if(pid == 0)return;
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
c0103ad8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103adc:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
c0103ae3:	76 d4                	jbe    c0103ab9 <join_current+0x1a>
		if(PCBPool[i].pid == pid)break;
	}
	if(i == PCBPOOLMAX) return;
c0103ae5:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
c0103aec:	75 02                	jne    c0103af0 <join_current+0x51>
c0103aee:	eb 57                	jmp    c0103b47 <join_current+0xa8>
	if(PCBPool[i].used == 0) return;
c0103af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af3:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103af9:	05 40 20 00 00       	add    $0x2040,%eax
c0103afe:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c0103b03:	8b 00                	mov    (%eax),%eax
c0103b05:	85 c0                	test   %eax,%eax
c0103b07:	75 02                	jne    c0103b0b <join_current+0x6c>
c0103b09:	eb 3c                	jmp    c0103b47 <join_current+0xa8>
	PCB *p = &PCBPool[i];
c0103b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b0e:	69 c0 6c 20 00 00    	imul   $0x206c,%eax,%eax
c0103b14:	05 40 09 1f c0       	add    $0xc01f0940,%eax
c0103b19:	89 45 f0             	mov    %eax,-0x10(%ebp)

	PCB* cur = current;
c0103b1c:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103b21:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ll_entail(&p->join_list, cur);
c0103b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b27:	05 68 20 00 00       	add    $0x2068,%eax
c0103b2c:	ff 75 ec             	pushl  -0x14(%ebp)
c0103b2f:	50                   	push   %eax
c0103b30:	e8 c5 f7 ff ff       	call   c01032fa <ll_entail>
c0103b35:	83 c4 08             	add    $0x8,%esp
	current = NULL;
c0103b38:	c7 05 ac 60 15 c0 00 	movl   $0x0,0xc01560ac
c0103b3f:	00 00 00 
	do_scheduler();
c0103b42:	e8 64 d5 ff ff       	call   c01010ab <do_scheduler>
c0103b47:	c9                   	leave  
c0103b48:	c3                   	ret    

c0103b49 <memcpy>:
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
c0103b49:	55                   	push   %ebp
c0103b4a:	89 e5                	mov    %esp,%ebp
c0103b4c:	57                   	push   %edi
c0103b4d:	56                   	push   %esi
c0103b4e:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
c0103b4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
c0103b58:	89 c1                	mov    %eax,%ecx
c0103b5a:	89 d6                	mov    %edx,%esi
c0103b5c:	89 df                	mov    %ebx,%edi
c0103b5e:	fc                   	cld    
c0103b5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
c0103b61:	5b                   	pop    %ebx
c0103b62:	5e                   	pop    %esi
c0103b63:	5f                   	pop    %edi
c0103b64:	5d                   	pop    %ebp
c0103b65:	c3                   	ret    

c0103b66 <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
c0103b66:	55                   	push   %ebp
c0103b67:	89 e5                	mov    %esp,%ebp
c0103b69:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
c0103b6c:	68 80 3e 00 00       	push   $0x3e80
c0103b71:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103b76:	68 c0 60 15 c0       	push   $0xc01560c0
c0103b7b:	e8 c9 ff ff ff       	call   c0103b49 <memcpy>
c0103b80:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
c0103b83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103b8a:	eb 0f                	jmp    c0103b9b <initVCache+0x35>
		VDIRTY[x] = 0;
c0103b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103b8f:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103b94:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
c0103b97:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103b9b:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103ba2:	7e e8                	jle    c0103b8c <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
c0103ba4:	c9                   	leave  
c0103ba5:	c3                   	ret    

c0103ba6 <refreshVCache>:
void refreshVCache(){
c0103ba6:	55                   	push   %ebp
c0103ba7:	89 e5                	mov    %esp,%ebp
c0103ba9:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103bac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103bb3:	eb 0f                	jmp    c0103bc4 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
c0103bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103bb8:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103bbd:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
c0103bc0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103bc4:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103bcb:	7e e8                	jle    c0103bb5 <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
c0103bcd:	c9                   	leave  
c0103bce:	c3                   	ret    

c0103bcf <flushVCache>:
void flushVCache(){
c0103bcf:	55                   	push   %ebp
c0103bd0:	89 e5                	mov    %esp,%ebp
c0103bd2:	53                   	push   %ebx
c0103bd3:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0103bdd:	eb 47                	jmp    c0103c26 <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
c0103bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103be2:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103be7:	0f b6 00             	movzbl (%eax),%eax
c0103bea:	84 c0                	test   %al,%al
c0103bec:	74 34                	je     c0103c22 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
c0103bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103bf1:	89 d0                	mov    %edx,%eax
c0103bf3:	c1 e0 02             	shl    $0x2,%eax
c0103bf6:	01 d0                	add    %edx,%eax
c0103bf8:	c1 e0 06             	shl    $0x6,%eax
c0103bfb:	8d 88 c0 60 15 c0    	lea    -0x3fea9f40(%eax),%ecx
c0103c01:	8b 1d ac 80 10 c0    	mov    0xc01080ac,%ebx
c0103c07:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0103c0a:	89 d0                	mov    %edx,%eax
c0103c0c:	c1 e0 02             	shl    $0x2,%eax
c0103c0f:	01 d0                	add    %edx,%eax
c0103c11:	c1 e0 06             	shl    $0x6,%eax
c0103c14:	01 d8                	add    %ebx,%eax
c0103c16:	6a 50                	push   $0x50
c0103c18:	51                   	push   %ecx
c0103c19:	50                   	push   %eax
c0103c1a:	e8 2a ff ff ff       	call   c0103b49 <memcpy>
c0103c1f:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
c0103c22:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0103c26:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
c0103c2d:	7e b0                	jle    c0103bdf <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
c0103c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0103c32:	c9                   	leave  
c0103c33:	c3                   	ret    

c0103c34 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
c0103c34:	55                   	push   %ebp
c0103c35:	89 e5                	mov    %esp,%ebp
c0103c37:	83 ec 04             	sub    $0x4,%esp
c0103c3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
c0103c40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103c44:	78 18                	js     c0103c5e <setPixelAt+0x2a>
c0103c46:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
c0103c4d:	7f 0f                	jg     c0103c5e <setPixelAt+0x2a>
c0103c4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103c53:	78 09                	js     c0103c5e <setPixelAt+0x2a>
c0103c55:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
c0103c5c:	7e 02                	jle    c0103c60 <setPixelAt+0x2c>
c0103c5e:	eb 34                	jmp    c0103c94 <setPixelAt+0x60>
	VDIRTY[x] = 1;
c0103c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c63:	05 c0 54 17 c0       	add    $0xc01754c0,%eax
c0103c68:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
c0103c6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c6e:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0103c73:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
c0103c76:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c79:	89 d0                	mov    %edx,%eax
c0103c7b:	c1 e0 02             	shl    $0x2,%eax
c0103c7e:	01 d0                	add    %edx,%eax
c0103c80:	c1 e0 06             	shl    $0x6,%eax
c0103c83:	89 c2                	mov    %eax,%edx
c0103c85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c88:	01 c2                	add    %eax,%edx
c0103c8a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
c0103c8e:	88 82 c0 60 15 c0    	mov    %al,-0x3fea9f40(%edx)
}
c0103c94:	c9                   	leave  
c0103c95:	c3                   	ret    

c0103c96 <forceClearVRAM>:
void forceClearVRAM(){
c0103c96:	55                   	push   %ebp
c0103c97:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
c0103c99:	5d                   	pop    %ebp
c0103c9a:	c3                   	ret    

c0103c9b <clearVRAM>:
void clearVRAM(){
c0103c9b:	55                   	push   %ebp
c0103c9c:	89 e5                	mov    %esp,%ebp
c0103c9e:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0103ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0103ca8:	eb 4e                	jmp    c0103cf8 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
c0103caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103cad:	05 c0 55 17 c0       	add    $0xc01755c0,%eax
c0103cb2:	0f b6 00             	movzbl (%eax),%eax
c0103cb5:	0f b6 c0             	movzbl %al,%eax
c0103cb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103cbb:	81 c2 c0 54 17 c0    	add    $0xc01754c0,%edx
c0103cc1:	0f b6 12             	movzbl (%edx),%edx
c0103cc4:	0f b6 d2             	movzbl %dl,%edx
c0103cc7:	f7 d2                	not    %edx
c0103cc9:	21 d0                	and    %edx,%eax
c0103ccb:	85 c0                	test   %eax,%eax
c0103ccd:	74 25                	je     c0103cf4 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
c0103ccf:	8b 0d ac 80 10 c0    	mov    0xc01080ac,%ecx
c0103cd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103cd8:	89 d0                	mov    %edx,%eax
c0103cda:	c1 e0 02             	shl    $0x2,%eax
c0103cdd:	01 d0                	add    %edx,%eax
c0103cdf:	c1 e0 06             	shl    $0x6,%eax
c0103ce2:	01 c8                	add    %ecx,%eax
c0103ce4:	6a 50                	push   $0x50
c0103ce6:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103ceb:	50                   	push   %eax
c0103cec:	e8 58 fe ff ff       	call   c0103b49 <memcpy>
c0103cf1:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
c0103cf4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0103cf8:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
c0103cff:	7e a9                	jle    c0103caa <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
c0103d01:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103d08:	83 c0 01             	add    $0x1,%eax
c0103d0b:	a2 88 56 17 c0       	mov    %al,0xc0175688
	if(stamp==30){
c0103d10:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103d17:	3c 1e                	cmp    $0x1e,%al
c0103d19:	75 07                	jne    c0103d22 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
c0103d1b:	c6 05 88 56 17 c0 00 	movb   $0x0,0xc0175688
		//printk("What matters\n");
	}
	if(stamp==0){
c0103d22:	0f b6 05 88 56 17 c0 	movzbl 0xc0175688,%eax
c0103d29:	84 c0                	test   %al,%al
c0103d2b:	75 14                	jne    c0103d41 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
c0103d2d:	6a 32                	push   $0x32
c0103d2f:	68 c0 5a 16 c0       	push   $0xc0165ac0
c0103d34:	68 c0 55 17 c0       	push   $0xc01755c0
c0103d39:	e8 0b fe ff ff       	call   c0103b49 <memcpy>
c0103d3e:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
c0103d41:	c9                   	leave  
c0103d42:	c3                   	ret    

c0103d43 <do_timer>:
#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
c0103d43:	55                   	push   %ebp
c0103d44:	89 e5                	mov    %esp,%ebp
c0103d46:	83 ec 18             	sub    $0x18,%esp
	_tick++;
c0103d49:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c0103d4e:	83 c0 01             	add    $0x1,%eax
c0103d51:	a3 8c 56 17 c0       	mov    %eax,0xc017568c
	current->timeslice ++;
c0103d56:	a1 ac 60 15 c0       	mov    0xc01560ac,%eax
c0103d5b:	8b 90 54 20 00 00    	mov    0x2054(%eax),%edx
c0103d61:	83 c2 01             	add    $0x1,%edx
c0103d64:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)

	PCB *sleep = sleep_list, *cur;
c0103d6a:	a1 b4 60 15 c0       	mov    0xc01560b4,%eax
c0103d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	 while(1){
	 	if(sleep == NULL)break;
c0103d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d76:	75 02                	jne    c0103d7a <do_timer+0x37>
c0103d78:	eb 6b                	jmp    c0103de5 <do_timer+0xa2>
	 	sleep->timeslice --;
c0103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d7d:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0103d83:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d89:	89 90 54 20 00 00    	mov    %edx,0x2054(%eax)
	 	
	 	cur = sleep;
c0103d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d92:	89 45 f0             	mov    %eax,-0x10(%ebp)

	 	sleep = sleep->next;
c0103d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d98:	8b 80 60 20 00 00    	mov    0x2060(%eax),%eax
c0103d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 	if(cur->timeslice > 0) continue;
c0103da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da4:	8b 80 54 20 00 00    	mov    0x2054(%eax),%eax
c0103daa:	85 c0                	test   %eax,%eax
c0103dac:	74 02                	je     c0103db0 <do_timer+0x6d>
c0103dae:	eb 33                	jmp    c0103de3 <do_timer+0xa0>
	 	cur->ts = READY;
c0103db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db3:	c7 80 4c 20 00 00 00 	movl   $0x0,0x204c(%eax)
c0103dba:	00 00 00 
		ll_delete(&sleep_list, cur);
c0103dbd:	83 ec 08             	sub    $0x8,%esp
c0103dc0:	ff 75 f0             	pushl  -0x10(%ebp)
c0103dc3:	68 b4 60 15 c0       	push   $0xc01560b4
c0103dc8:	e8 8b f5 ff ff       	call   c0103358 <ll_delete>
c0103dcd:	83 c4 10             	add    $0x10,%esp
		ll_entail(&ready_list, cur);
c0103dd0:	83 ec 08             	sub    $0x8,%esp
c0103dd3:	ff 75 f0             	pushl  -0x10(%ebp)
c0103dd6:	68 b0 60 15 c0       	push   $0xc01560b0
c0103ddb:	e8 1a f5 ff ff       	call   c01032fa <ll_entail>
c0103de0:	83 c4 10             	add    $0x10,%esp
	}
c0103de3:	eb 8d                	jmp    c0103d72 <do_timer+0x2f>
}
c0103de5:	c9                   	leave  
c0103de6:	c3                   	ret    

c0103de7 <tick>:
uint32_t tick(){
c0103de7:	55                   	push   %ebp
c0103de8:	89 e5                	mov    %esp,%ebp
	return _tick;
c0103dea:	a1 8c 56 17 c0       	mov    0xc017568c,%eax
c0103def:	5d                   	pop    %ebp
c0103df0:	c3                   	ret    

c0103df1 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
c0103df1:	6a 00                	push   $0x0
c0103df3:	6a 00                	push   $0x0
c0103df5:	e9 b8 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103dfa <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
c0103dfa:	6a 00                	push   $0x0
c0103dfc:	6a 01                	push   $0x1
c0103dfe:	e9 af 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e03 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
c0103e03:	6a 00                	push   $0x0
c0103e05:	6a 02                	push   $0x2
c0103e07:	e9 a6 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e0c <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
c0103e0c:	6a 00                	push   $0x0
c0103e0e:	6a 03                	push   $0x3
c0103e10:	e9 9d 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e15 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
c0103e15:	6a 00                	push   $0x0
c0103e17:	6a 04                	push   $0x4
c0103e19:	e9 94 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e1e <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
c0103e1e:	6a 00                	push   $0x0
c0103e20:	6a 05                	push   $0x5
c0103e22:	e9 8b 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e27 <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
c0103e27:	6a 00                	push   $0x0
c0103e29:	6a 06                	push   $0x6
c0103e2b:	e9 82 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e30 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
c0103e30:	6a 00                	push   $0x0
c0103e32:	6a 07                	push   $0x7
c0103e34:	e9 79 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e39 <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
c0103e39:	6a 00                	push   $0x0
c0103e3b:	6a 08                	push   $0x8
c0103e3d:	e9 70 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e42 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
c0103e42:	6a 00                	push   $0x0
c0103e44:	6a 09                	push   $0x9
c0103e46:	e9 67 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e4b <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
c0103e4b:	6a 00                	push   $0x0
c0103e4d:	6a 0a                	push   $0xa
c0103e4f:	e9 5e 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e54 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
c0103e54:	6a 00                	push   $0x0
c0103e56:	6a 0b                	push   $0xb
c0103e58:	e9 55 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e5d <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
c0103e5d:	6a 00                	push   $0x0
c0103e5f:	6a 0c                	push   $0xc
c0103e61:	e9 4c 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e66 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
c0103e66:	6a 00                	push   $0x0
c0103e68:	6a 0d                	push   $0xd
c0103e6a:	e9 43 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e6f <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
c0103e6f:	6a 00                	push   $0x0
c0103e71:	6a 0e                	push   $0xe
c0103e73:	e9 3a 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e78 <vecsys>:

.globl vecsys; vecsys: cli;  pushl $0;  pushl $0x80; jmp asm_do_irq
c0103e78:	fa                   	cli    
c0103e79:	6a 00                	push   $0x0
c0103e7b:	68 80 00 00 00       	push   $0x80
c0103e80:	e9 2d 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e85 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
c0103e85:	6a 00                	push   $0x0
c0103e87:	68 e8 03 00 00       	push   $0x3e8
c0103e8c:	e9 21 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e91 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
c0103e91:	6a 00                	push   $0x0
c0103e93:	68 e9 03 00 00       	push   $0x3e9
c0103e98:	e9 15 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103e9d <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
c0103e9d:	6a 00                	push   $0x0
c0103e9f:	68 f6 03 00 00       	push   $0x3f6
c0103ea4:	e9 09 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103ea9 <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
c0103ea9:	6a 00                	push   $0x0
c0103eab:	6a ff                	push   $0xffffffff
c0103ead:	e9 00 00 00 00       	jmp    c0103eb2 <asm_do_irq>

c0103eb2 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle
.globl switch_proc

asm_do_irq:
  cli
c0103eb2:	fa                   	cli    
  pushl %ds
c0103eb3:	1e                   	push   %ds
  pushl %es
c0103eb4:	06                   	push   %es
  pushl %fs
c0103eb5:	0f a0                	push   %fs
  pushl %gs
c0103eb7:	0f a8                	push   %gs
	pushal
c0103eb9:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
c0103eba:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
c0103ebe:	8e d8                	mov    %eax,%ds
  movw %ax, %es
c0103ec0:	8e c0                	mov    %eax,%es

  pushl %esp			# ???
c0103ec2:	54                   	push   %esp
  call irq_handle
c0103ec3:	e8 d6 d2 ff ff       	call   c010119e <irq_handle>
  addl $4, %esp
c0103ec8:	83 c4 04             	add    $0x4,%esp

c0103ecb <switch_proc>:
switch_proc:
  popal
c0103ecb:	61                   	popa   
  popl %gs
c0103ecc:	0f a9                	pop    %gs
  popl %fs
c0103ece:	0f a1                	pop    %fs
  popl %es
c0103ed0:	07                   	pop    %es
  popl %ds
c0103ed1:	1f                   	pop    %ds
  addl $8, %esp
c0103ed2:	83 c4 08             	add    $0x8,%esp
  sti
c0103ed5:	fb                   	sti    
  iret
c0103ed6:	cf                   	iret   
c0103ed7:	90                   	nop
c0103ed8:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
c0103ede:	00 00                	add    %al,(%eax)
c0103ee0:	fe 4f 52             	decb   0x52(%edi)
c0103ee3:	e4 66                	in     $0x66,%al

c0103ee4 <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
c0103ee4:	66 c7 05 72 04 00 00 34 12 b8 00 70 10 00 0f 22     f..r...4...p..."
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
c0103ef4:	d8 0f 20 c0 0d 01 00 01 80 0f 22 c0 b8 07 3f 10     .. ......."...?.
	movl	%eax, %cr0
	#jmp spin
	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
c0103f04:	c0 ff e0                                            ...

c0103f07 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
c0103f07:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
c0103f0c:	bc 00 10 11 c0       	mov    $0xc0111000,%esp

	# now to C code

	call	main
c0103f11:	e8 c9 e6 ff ff       	call   c01025df <main>

c0103f16 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
c0103f16:	eb fe                	jmp    c0103f16 <spin>

c0103f18 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
c0103f18:	55                   	push   %ebp
c0103f19:	89 e5                	mov    %esp,%ebp
c0103f1b:	53                   	push   %ebx
c0103f1c:	83 ec 04             	sub    $0x4,%esp
c0103f1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f22:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
c0103f25:	b8 e8 03 00 00       	mov    $0x3e8,%eax
c0103f2a:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
c0103f2e:	89 d3                	mov    %edx,%ebx
c0103f30:	cd 80                	int    $0x80
}
c0103f32:	83 c4 04             	add    $0x4,%esp
c0103f35:	5b                   	pop    %ebx
c0103f36:	5d                   	pop    %ebp
c0103f37:	c3                   	ret    

c0103f38 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
c0103f38:	55                   	push   %ebp
c0103f39:	89 e5                	mov    %esp,%ebp
c0103f3b:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
c0103f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
c0103f44:	eb 19                	jmp    c0103f5f <printp+0x27>
		printer(cur);
c0103f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f49:	0f b6 00             	movzbl (%eax),%eax
c0103f4c:	0f be c0             	movsbl %al,%eax
c0103f4f:	83 ec 0c             	sub    $0xc,%esp
c0103f52:	50                   	push   %eax
c0103f53:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f56:	ff d0                	call   *%eax
c0103f58:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
c0103f5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f62:	0f b6 00             	movzbl (%eax),%eax
c0103f65:	84 c0                	test   %al,%al
c0103f67:	75 dd                	jne    c0103f46 <printp+0xe>
		printer(cur);
	}
}
c0103f69:	c9                   	leave  
c0103f6a:	c3                   	ret    

c0103f6b <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
c0103f6b:	55                   	push   %ebp
c0103f6c:	89 e5                	mov    %esp,%ebp
c0103f6e:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
c0103f71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
c0103f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
c0103f7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
c0103f85:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
c0103f8b:	e9 65 02 00 00       	jmp    c01041f5 <vfprintf+0x28a>

		if(cur == '%'){
c0103f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f93:	0f b6 00             	movzbl (%eax),%eax
c0103f96:	3c 25                	cmp    $0x25,%al
c0103f98:	75 0c                	jne    c0103fa6 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
c0103f9a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
c0103fa1:	e9 4b 02 00 00       	jmp    c01041f1 <vfprintf+0x286>
		}
		if(type == READ){
c0103fa6:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
c0103faa:	0f 85 26 02 00 00    	jne    c01041d6 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
c0103fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fb3:	0f b6 00             	movzbl (%eax),%eax
c0103fb6:	3c 73                	cmp    $0x73,%al
c0103fb8:	75 35                	jne    c0103fef <vfprintf+0x84>
				char* p= XGET(pointer, char*);
c0103fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fbd:	8b 00                	mov    (%eax),%eax
c0103fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
c0103fc2:	eb 19                	jmp    c0103fdd <vfprintf+0x72>
					printer(*p);
c0103fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc7:	0f b6 00             	movzbl (%eax),%eax
c0103fca:	0f be c0             	movsbl %al,%eax
c0103fcd:	83 ec 0c             	sub    $0xc,%esp
c0103fd0:	50                   	push   %eax
c0103fd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fd4:	ff d0                	call   *%eax
c0103fd6:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
c0103fd9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
c0103fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe0:	0f b6 00             	movzbl (%eax),%eax
c0103fe3:	84 c0                	test   %al,%al
c0103fe5:	75 dd                	jne    c0103fc4 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
c0103fe7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0103feb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
c0103fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff2:	0f b6 00             	movzbl (%eax),%eax
c0103ff5:	3c 78                	cmp    $0x78,%al
c0103ff7:	0f 85 99 00 00 00    	jne    c0104096 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
c0103ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104000:	8b 00                	mov    (%eax),%eax
c0104002:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
c0104005:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104009:	75 1d                	jne    c0104028 <vfprintf+0xbd>
					printer('0');
c010400b:	83 ec 0c             	sub    $0xc,%esp
c010400e:	6a 30                	push   $0x30
c0104010:	8b 45 08             	mov    0x8(%ebp),%eax
c0104013:	ff d0                	call   *%eax
c0104015:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c0104018:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c010401c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104023:	e9 c9 01 00 00       	jmp    c01041f1 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
c0104028:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
c010402f:	eb 2d                	jmp    c010405e <vfprintf+0xf3>
					int d=(x%16);
c0104031:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104034:	83 e0 0f             	and    $0xf,%eax
c0104037:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
c010403a:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
c010403e:	7e 04                	jle    c0104044 <vfprintf+0xd9>
						d+='a'-'0'-10;
c0104040:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
c0104044:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104047:	83 c0 30             	add    $0x30,%eax
c010404a:	89 c1                	mov    %eax,%ecx
c010404c:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010404f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104052:	01 d0                	add    %edx,%eax
c0104054:	88 08                	mov    %cl,(%eax)
					x>>=4;
c0104056:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
c010405a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010405e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104062:	75 cd                	jne    c0104031 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
c0104064:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
c0104068:	eb 1e                	jmp    c0104088 <vfprintf+0x11d>
					printer(digits[di]);
c010406a:	8d 55 c1             	lea    -0x3f(%ebp),%edx
c010406d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104070:	01 d0                	add    %edx,%eax
c0104072:	0f b6 00             	movzbl (%eax),%eax
c0104075:	0f be c0             	movsbl %al,%eax
c0104078:	83 ec 0c             	sub    $0xc,%esp
c010407b:	50                   	push   %eax
c010407c:	8b 45 08             	mov    0x8(%ebp),%eax
c010407f:	ff d0                	call   *%eax
c0104081:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
c0104084:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0104088:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010408c:	79 dc                	jns    c010406a <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010408e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c0104092:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
c0104096:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104099:	0f b6 00             	movzbl (%eax),%eax
c010409c:	3c 64                	cmp    $0x64,%al
c010409e:	0f 85 02 01 00 00    	jne    c01041a6 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
c01040a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040a7:	8b 00                	mov    (%eax),%eax
c01040a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
c01040ac:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
c01040b3:	75 23                	jne    c01040d8 <vfprintf+0x16d>
					printp(printer, "-2147483648");
c01040b5:	83 ec 08             	sub    $0x8,%esp
c01040b8:	68 aa 44 10 c0       	push   $0xc01044aa
c01040bd:	ff 75 08             	pushl  0x8(%ebp)
c01040c0:	e8 73 fe ff ff       	call   c0103f38 <printp>
c01040c5:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01040c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01040cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01040d3:	e9 19 01 00 00       	jmp    c01041f1 <vfprintf+0x286>
				}
				if(x==0){
c01040d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01040dc:	75 1e                	jne    c01040fc <vfprintf+0x191>
					printer('0');
c01040de:	83 ec 0c             	sub    $0xc,%esp
c01040e1:	6a 30                	push   $0x30
c01040e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01040e6:	ff d0                	call   *%eax
c01040e8:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
c01040eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
c01040ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
c01040f6:	90                   	nop
c01040f7:	e9 f5 00 00 00       	jmp    c01041f1 <vfprintf+0x286>
				}
				if(x<0){
c01040fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104100:	79 10                	jns    c0104112 <vfprintf+0x1a7>
					printer('-');
c0104102:	83 ec 0c             	sub    $0xc,%esp
c0104105:	6a 2d                	push   $0x2d
c0104107:	8b 45 08             	mov    0x8(%ebp),%eax
c010410a:	ff d0                	call   *%eax
c010410c:	83 c4 10             	add    $0x10,%esp
					x=-x;
c010410f:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
c0104112:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
c0104119:	eb 53                	jmp    c010416e <vfprintf+0x203>
					digits[di] = '0'+(x%10);
c010411b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010411e:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104123:	89 c8                	mov    %ecx,%eax
c0104125:	f7 ea                	imul   %edx
c0104127:	c1 fa 02             	sar    $0x2,%edx
c010412a:	89 c8                	mov    %ecx,%eax
c010412c:	c1 f8 1f             	sar    $0x1f,%eax
c010412f:	29 c2                	sub    %eax,%edx
c0104131:	89 d0                	mov    %edx,%eax
c0104133:	c1 e0 02             	shl    $0x2,%eax
c0104136:	01 d0                	add    %edx,%eax
c0104138:	01 c0                	add    %eax,%eax
c010413a:	29 c1                	sub    %eax,%ecx
c010413c:	89 ca                	mov    %ecx,%edx
c010413e:	89 d0                	mov    %edx,%eax
c0104140:	83 c0 30             	add    $0x30,%eax
c0104143:	89 c1                	mov    %eax,%ecx
c0104145:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c0104148:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010414b:	01 d0                	add    %edx,%eax
c010414d:	88 08                	mov    %cl,(%eax)
					x/=10;
c010414f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104152:	ba 67 66 66 66       	mov    $0x66666667,%edx
c0104157:	89 c8                	mov    %ecx,%eax
c0104159:	f7 ea                	imul   %edx
c010415b:	c1 fa 02             	sar    $0x2,%edx
c010415e:	89 c8                	mov    %ecx,%eax
c0104160:	c1 f8 1f             	sar    $0x1f,%eax
c0104163:	29 c2                	sub    %eax,%edx
c0104165:	89 d0                	mov    %edx,%eax
c0104167:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
c010416a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
c010416e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104172:	7f a7                	jg     c010411b <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
c0104174:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
c0104178:	eb 1e                	jmp    c0104198 <vfprintf+0x22d>
					printer(digits[di]);
c010417a:	8d 55 b2             	lea    -0x4e(%ebp),%edx
c010417d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104180:	01 d0                	add    %edx,%eax
c0104182:	0f b6 00             	movzbl (%eax),%eax
c0104185:	0f be c0             	movsbl %al,%eax
c0104188:	83 ec 0c             	sub    $0xc,%esp
c010418b:	50                   	push   %eax
c010418c:	8b 45 08             	mov    0x8(%ebp),%eax
c010418f:	ff d0                	call   *%eax
c0104191:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
c0104194:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
c0104198:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010419c:	79 dc                	jns    c010417a <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
c010419e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01041a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
c01041a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041a9:	0f b6 00             	movzbl (%eax),%eax
c01041ac:	3c 63                	cmp    $0x63,%al
c01041ae:	75 1d                	jne    c01041cd <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
c01041b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041b3:	0f b6 00             	movzbl (%eax),%eax
c01041b6:	0f be c0             	movsbl %al,%eax
c01041b9:	83 ec 0c             	sub    $0xc,%esp
c01041bc:	50                   	push   %eax
c01041bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01041c0:	ff d0                	call   *%eax
c01041c2:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
c01041c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
c01041c9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
c01041cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
c01041d4:	eb 1b                	jmp    c01041f1 <vfprintf+0x286>
		}
		if(type == NONE){
c01041d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01041da:	75 15                	jne    c01041f1 <vfprintf+0x286>
			printer(cur);
c01041dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041df:	0f b6 00             	movzbl (%eax),%eax
c01041e2:	0f be c0             	movsbl %al,%eax
c01041e5:	83 ec 0c             	sub    $0xc,%esp
c01041e8:	50                   	push   %eax
c01041e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01041ec:	ff d0                	call   *%eax
c01041ee:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
c01041f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01041f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f8:	0f b6 00             	movzbl (%eax),%eax
c01041fb:	84 c0                	test   %al,%al
c01041fd:	0f 85 8d fd ff ff    	jne    c0103f90 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
c0104203:	c9                   	leave  
c0104204:	c3                   	ret    

c0104205 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
c0104205:	55                   	push   %ebp
c0104206:	89 e5                	mov    %esp,%ebp
c0104208:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
c010420b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010420e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
c0104211:	8b 45 08             	mov    0x8(%ebp),%eax
c0104214:	83 ec 04             	sub    $0x4,%esp
c0104217:	ff 75 f4             	pushl  -0xc(%ebp)
c010421a:	50                   	push   %eax
c010421b:	68 18 3f 10 c0       	push   $0xc0103f18
c0104220:	e8 46 fd ff ff       	call   c0103f6b <vfprintf>
c0104225:	83 c4 10             	add    $0x10,%esp
}
c0104228:	c9                   	leave  
c0104229:	c3                   	ret    
