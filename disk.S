
kernel.bin:     file format elf32-i386


Disassembly of section .text:

00100000 <read_cr0>:
	uint32_t val;
} CR3;

/* read CR0 */
static inline uint32_t
read_cr0() {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 10             	sub    $0x10,%esp
	uint32_t val;
	asm volatile("movl %%cr0, %0" : "=r"(val));
  100006:	0f 20 c0             	mov    %cr0,%eax
  100009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return val;
  10000c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10000f:	c9                   	leave  
  100010:	c3                   	ret    

00100011 <write_cr0>:

/* write CR0 */
static inline void
write_cr0(CR0 *cr0) {
  100011:	55                   	push   %ebp
  100012:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0, %%cr0" : : "r"(cr0->val));
  100014:	8b 45 08             	mov    0x8(%ebp),%eax
  100017:	8b 00                	mov    (%eax),%eax
  100019:	0f 22 c0             	mov    %eax,%cr0
}
  10001c:	5d                   	pop    %ebp
  10001d:	c3                   	ret    

0010001e <write_cr3>:

/* write CR3, notice that CR3 are never read in Nanos */
static inline void
write_cr3(CR3 *cr3) {
  10001e:	55                   	push   %ebp
  10001f:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0, %%cr3" : : "r"(cr3->val));
  100021:	8b 45 08             	mov    0x8(%ebp),%eax
  100024:	8b 00                	mov    (%eax),%eax
  100026:	0f 22 d8             	mov    %eax,%cr3
}
  100029:	5d                   	pop    %ebp
  10002a:	c3                   	ret    

0010002b <write_gdtr>:

/* modify the value of GDTR */
static inline void
write_gdtr(void *addr, uint32_t size) {
  10002b:	55                   	push   %ebp
  10002c:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
  10002e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100031:	83 e8 01             	sub    $0x1,%eax
  100034:	66 a3 b0 50 12 00    	mov    %ax,0x1250b0
	data[1] = (uint32_t)addr;
  10003a:	8b 45 08             	mov    0x8(%ebp),%eax
  10003d:	66 a3 b2 50 12 00    	mov    %ax,0x1250b2
	data[2] = ((uint32_t)addr) >> 16;
  100043:	8b 45 08             	mov    0x8(%ebp),%eax
  100046:	c1 e8 10             	shr    $0x10,%eax
  100049:	66 a3 b4 50 12 00    	mov    %ax,0x1250b4
	asm volatile("lgdt (%0)" : : "r"(data));
  10004f:	b8 b0 50 12 00       	mov    $0x1250b0,%eax
  100054:	0f 01 10             	lgdtl  (%eax)
}
  100057:	5d                   	pop    %ebp
  100058:	c3                   	ret    

00100059 <write_tr>:
	asm volatile("lidt (%0)" : : "r"(data));
}

/* write TR */
static inline void
write_tr(uint16_t selector) {
  100059:	55                   	push   %ebp
  10005a:	89 e5                	mov    %esp,%ebp
  10005c:	83 ec 04             	sub    $0x4,%esp
  10005f:	8b 45 08             	mov    0x8(%ebp),%eax
  100062:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	asm volatile("ltr %0" : : "r"(selector));
  100066:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  10006a:	0f 00 d8             	ltr    %ax
}
  10006d:	c9                   	leave  
  10006e:	c3                   	ret    

0010006f <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
  10006f:	55                   	push   %ebp
  100070:	89 e5                	mov    %esp,%ebp
  100072:	57                   	push   %edi
  100073:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
  100074:	8b 55 10             	mov    0x10(%ebp),%edx
  100077:	8b 45 0c             	mov    0xc(%ebp),%eax
  10007a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10007d:	89 d1                	mov    %edx,%ecx
  10007f:	89 df                	mov    %ebx,%edi
  100081:	fc                   	cld    
  100082:	f3 ab                	rep stos %eax,%es:(%edi)
}
  100084:	5b                   	pop    %ebx
  100085:	5f                   	pop    %edi
  100086:	5d                   	pop    %ebp
  100087:	c3                   	ret    

00100088 <get_kcr3>:
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
  100088:	55                   	push   %ebp
  100089:	89 e5                	mov    %esp,%ebp
	return &kcr3;
  10008b:	b8 00 30 10 00       	mov    $0x103000,%eax
}
  100090:	5d                   	pop    %ebp
  100091:	c3                   	ret    

00100092 <get_kpdir>:

PDE* get_kpdir() {
  100092:	55                   	push   %ebp
  100093:	89 e5                	mov    %esp,%ebp
	return kpdir;
  100095:	b8 00 40 10 00       	mov    $0x104000,%eax
}
  10009a:	5d                   	pop    %ebp
  10009b:	c3                   	ret    

0010009c <get_kptable>:

PTE* get_kptable() {
  10009c:	55                   	push   %ebp
  10009d:	89 e5                	mov    %esp,%ebp
	return kptable;
  10009f:	b8 00 50 10 00       	mov    $0x105000,%eax
}
  1000a4:	5d                   	pop    %ebp
  1000a5:	c3                   	ret    

001000a6 <init_page>:

/* Build a page table for the kernel */
void
init_page(void) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 28             	sub    $0x28,%esp
	CR0 cr0;
	CR3 cr3;
	PDE *pdir = (PDE *)va_to_pa(kpdir);
  1000ac:	b8 00 40 10 00       	mov    $0x104000,%eax
  1000b1:	05 00 00 00 40       	add    $0x40000000,%eax
  1000b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	PTE *ptable = (PTE *)va_to_pa(kptable);
  1000b9:	b8 00 50 10 00       	mov    $0x105000,%eax
  1000be:	05 00 00 00 40       	add    $0x40000000,%eax
  1000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t pdir_idx, ptable_idx, pframe_idx;


	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
  1000c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1000cd:	eb 1f                	jmp    1000ee <init_page+0x48>
		make_invalid_pde(&pdir[pdir_idx]);
  1000cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1000d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1000d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1000dc:	01 d0                	add    %edx,%eax
  1000de:	83 ec 0c             	sub    $0xc,%esp
  1000e1:	50                   	push   %eax
  1000e2:	e8 13 03 00 00       	call   1003fa <make_invalid_pde>
  1000e7:	83 c4 10             	add    $0x10,%esp
	PDE *pdir = (PDE *)va_to_pa(kpdir);
	PTE *ptable = (PTE *)va_to_pa(kptable);
	uint32_t pdir_idx, ptable_idx, pframe_idx;


	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
  1000ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1000ee:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
  1000f5:	76 d8                	jbe    1000cf <init_page+0x29>
		make_invalid_pde(&pdir[pdir_idx]);
	}

	pframe_idx = 0;
  1000f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
  1000fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  100105:	eb 78                	jmp    10017f <init_page+0xd9>
		make_pde(&pdir[pdir_idx], ptable);
  100107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10010a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100114:	01 d0                	add    %edx,%eax
  100116:	83 ec 08             	sub    $0x8,%esp
  100119:	ff 75 f4             	pushl  -0xc(%ebp)
  10011c:	50                   	push   %eax
  10011d:	e8 f4 02 00 00       	call   100416 <make_pde>
  100122:	83 c4 10             	add    $0x10,%esp
		make_pde(&pdir[pdir_idx + KOFFSET / PD_SIZE], ptable);
  100125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100128:	05 00 03 00 00       	add    $0x300,%eax
  10012d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100137:	01 d0                	add    %edx,%eax
  100139:	83 ec 08             	sub    $0x8,%esp
  10013c:	ff 75 f4             	pushl  -0xc(%ebp)
  10013f:	50                   	push   %eax
  100140:	e8 d1 02 00 00       	call   100416 <make_pde>
  100145:	83 c4 10             	add    $0x10,%esp
		for (ptable_idx = 0; ptable_idx < NR_PTE; ptable_idx ++) {
  100148:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10014f:	eb 21                	jmp    100172 <init_page+0xcc>
			make_pte(ptable, (void*)(pframe_idx << 12));
  100151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100154:	c1 e0 0c             	shl    $0xc,%eax
  100157:	83 ec 08             	sub    $0x8,%esp
  10015a:	50                   	push   %eax
  10015b:	ff 75 f4             	pushl  -0xc(%ebp)
  10015e:	e8 03 03 00 00       	call   100466 <make_pte>
  100163:	83 c4 10             	add    $0x10,%esp
			pframe_idx ++;
  100166:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			ptable ++;
  10016a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)

	pframe_idx = 0;
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
		make_pde(&pdir[pdir_idx], ptable);
		make_pde(&pdir[pdir_idx + KOFFSET / PD_SIZE], ptable);
		for (ptable_idx = 0; ptable_idx < NR_PTE; ptable_idx ++) {
  10016e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100172:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  100179:	76 d6                	jbe    100151 <init_page+0xab>
	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
		make_invalid_pde(&pdir[pdir_idx]);
	}

	pframe_idx = 0;
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
  10017b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  10017f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100183:	76 82                	jbe    100107 <init_page+0x61>
			ptable ++;
		}
	}

	/* make CR3 to be the entry of page directory */
	cr3.val = 0;
  100185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	cr3.page_directory_base = ((uint32_t)pdir) >> 12;
  10018c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10018f:	c1 e8 0c             	shr    $0xc,%eax
  100192:	25 ff ff 0f 00       	and    $0xfffff,%eax
  100197:	c1 e0 0c             	shl    $0xc,%eax
  10019a:	89 c2                	mov    %eax,%edx
  10019c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10019f:	25 ff 0f 00 00       	and    $0xfff,%eax
  1001a4:	09 d0                	or     %edx,%eax
  1001a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	write_cr3(&cr3);
  1001a9:	83 ec 0c             	sub    $0xc,%esp
  1001ac:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1001af:	50                   	push   %eax
  1001b0:	e8 69 fe ff ff       	call   10001e <write_cr3>
  1001b5:	83 c4 10             	add    $0x10,%esp

	/* set PG bit in CR0 to enable paging */
	cr0.val = read_cr0();
  1001b8:	e8 43 fe ff ff       	call   100000 <read_cr0>
  1001bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cr0.paging = 1;
  1001c0:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1001c4:	83 c8 80             	or     $0xffffff80,%eax
  1001c7:	88 45 e3             	mov    %al,-0x1d(%ebp)
	
	write_cr0(&cr0);
  1001ca:	83 ec 0c             	sub    $0xc,%esp
  1001cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1001d0:	50                   	push   %eax
  1001d1:	e8 3b fe ff ff       	call   100011 <write_cr0>
  1001d6:	83 c4 10             	add    $0x10,%esp

	/* Now we can access global variables! 
	 * Store CR3 in the global variable for future use. */
	kcr3.val = cr3.val;
  1001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1001dc:	a3 00 30 10 00       	mov    %eax,0x103000
}
  1001e1:	c9                   	leave  
  1001e2:	c3                   	ret    

001001e3 <set_tss>:

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
  1001e3:	55                   	push   %ebp
  1001e4:	89 e5                	mov    %esp,%ebp
  1001e6:	83 ec 10             	sub    $0x10,%esp
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
  1001e9:	c7 05 08 50 12 00 10 	movl   $0x10,0x125008
  1001f0:	00 00 00 

	uint32_t base = (uint32_t)&tss;
  1001f3:	c7 45 fc 00 50 12 00 	movl   $0x125000,-0x4(%ebp)
	uint32_t limit = sizeof(TSS) - 1;
  1001fa:	c7 45 f8 63 00 00 00 	movl   $0x63,-0x8(%ebp)
	ptr->limit_15_0  = limit & 0xffff;
  100201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100204:	89 c2                	mov    %eax,%edx
  100206:	8b 45 08             	mov    0x8(%ebp),%eax
  100209:	66 89 10             	mov    %dx,(%eax)
	ptr->base_15_0   = base & 0xffff;
  10020c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10020f:	89 c2                	mov    %eax,%edx
  100211:	8b 45 08             	mov    0x8(%ebp),%eax
  100214:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->base_23_16  = (base >> 16) & 0xff;
  100218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10021b:	c1 e8 10             	shr    $0x10,%eax
  10021e:	89 c2                	mov    %eax,%edx
  100220:	8b 45 08             	mov    0x8(%ebp),%eax
  100223:	88 50 04             	mov    %dl,0x4(%eax)
	ptr->type = SEG_TSS_32BIT;
  100226:	8b 45 08             	mov    0x8(%ebp),%eax
  100229:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10022d:	83 e2 f0             	and    $0xfffffff0,%edx
  100230:	83 ca 09             	or     $0x9,%edx
  100233:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 0;
  100236:	8b 45 08             	mov    0x8(%ebp),%eax
  100239:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10023d:	83 e2 ef             	and    $0xffffffef,%edx
  100240:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = DPL_USER;
  100243:	8b 45 08             	mov    0x8(%ebp),%eax
  100246:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10024a:	83 ca 60             	or     $0x60,%edx
  10024d:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  100250:	8b 45 08             	mov    0x8(%ebp),%eax
  100253:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100257:	83 ca 80             	or     $0xffffff80,%edx
  10025a:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = limit >> 16;
  10025d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100260:	c1 e8 10             	shr    $0x10,%eax
  100263:	83 e0 0f             	and    $0xf,%eax
  100266:	89 c2                	mov    %eax,%edx
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	89 d1                	mov    %edx,%ecx
  10026d:	83 e1 0f             	and    $0xf,%ecx
  100270:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100274:	83 e2 f0             	and    $0xfffffff0,%edx
  100277:	09 ca                	or     %ecx,%edx
  100279:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
  10027c:	8b 45 08             	mov    0x8(%ebp),%eax
  10027f:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100283:	83 e2 ef             	and    $0xffffffef,%edx
  100286:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
  100289:	8b 45 08             	mov    0x8(%ebp),%eax
  10028c:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100290:	83 e2 df             	and    $0xffffffdf,%edx
  100293:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
  100296:	8b 45 08             	mov    0x8(%ebp),%eax
  100299:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10029d:	83 ca 40             	or     $0x40,%edx
  1002a0:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 0;
  1002a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a6:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  1002aa:	83 e2 7f             	and    $0x7f,%edx
  1002ad:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = base >> 24;
  1002b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1002b3:	c1 e8 18             	shr    $0x18,%eax
  1002b6:	89 c2                	mov    %eax,%edx
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	88 50 07             	mov    %dl,0x7(%eax)
}
  1002be:	c9                   	leave  
  1002bf:	c3                   	ret    

001002c0 <set_segment>:

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
  1002c0:	55                   	push   %ebp
  1002c1:	89 e5                	mov    %esp,%ebp
	ptr->limit_15_0  = 0xFFFF;
  1002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c6:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
	ptr->base_15_0   = 0x0;
  1002cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ce:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
	ptr->base_23_16  = 0x0;
  1002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d7:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = type;
  1002db:	8b 45 10             	mov    0x10(%ebp),%eax
  1002de:	83 e0 0f             	and    $0xf,%eax
  1002e1:	89 c2                	mov    %eax,%edx
  1002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e6:	89 d1                	mov    %edx,%ecx
  1002e8:	83 e1 0f             	and    $0xf,%ecx
  1002eb:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1002ef:	83 e2 f0             	and    $0xfffffff0,%edx
  1002f2:	09 ca                	or     %ecx,%edx
  1002f4:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 1;
  1002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fa:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1002fe:	83 ca 10             	or     $0x10,%edx
  100301:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = pl;
  100304:	8b 45 0c             	mov    0xc(%ebp),%eax
  100307:	83 e0 03             	and    $0x3,%eax
  10030a:	89 c2                	mov    %eax,%edx
  10030c:	8b 45 08             	mov    0x8(%ebp),%eax
  10030f:	83 e2 03             	and    $0x3,%edx
  100312:	89 d1                	mov    %edx,%ecx
  100314:	c1 e1 05             	shl    $0x5,%ecx
  100317:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10031b:	83 e2 9f             	and    $0xffffff9f,%edx
  10031e:	09 ca                	or     %ecx,%edx
  100320:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  100323:	8b 45 08             	mov    0x8(%ebp),%eax
  100326:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10032a:	83 ca 80             	or     $0xffffff80,%edx
  10032d:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = 0xF;
  100330:	8b 45 08             	mov    0x8(%ebp),%eax
  100333:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100337:	83 ca 0f             	or     $0xf,%edx
  10033a:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
  10033d:	8b 45 08             	mov    0x8(%ebp),%eax
  100340:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100344:	83 e2 ef             	and    $0xffffffef,%edx
  100347:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
  10034a:	8b 45 08             	mov    0x8(%ebp),%eax
  10034d:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100351:	83 e2 df             	and    $0xffffffdf,%edx
  100354:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10035e:	83 ca 40             	or     $0x40,%edx
  100361:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 1;
  100364:	8b 45 08             	mov    0x8(%ebp),%eax
  100367:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10036b:	83 ca 80             	or     $0xffffff80,%edx
  10036e:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = 0x0;
  100371:	8b 45 08             	mov    0x8(%ebp),%eax
  100374:	c6 40 07 00          	movb   $0x0,0x7(%eax)
}
  100378:	5d                   	pop    %ebp
  100379:	c3                   	ret    

0010037a <init_segment>:
/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
  10037a:	55                   	push   %ebp
  10037b:	89 e5                	mov    %esp,%ebp
	memset(gdt, 0, sizeof(gdt));
  10037d:	6a 30                	push   $0x30
  10037f:	6a 00                	push   $0x0
  100381:	68 80 50 12 00       	push   $0x125080
  100386:	e8 e4 fc ff ff       	call   10006f <memset>
  10038b:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
  10038e:	6a 0a                	push   $0xa
  100390:	6a 00                	push   $0x0
  100392:	68 88 50 12 00       	push   $0x125088
  100397:	e8 24 ff ff ff       	call   1002c0 <set_segment>
  10039c:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
  10039f:	6a 02                	push   $0x2
  1003a1:	6a 00                	push   $0x0
  1003a3:	68 90 50 12 00       	push   $0x125090
  1003a8:	e8 13 ff ff ff       	call   1002c0 <set_segment>
  1003ad:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
  1003b0:	6a 0a                	push   $0xa
  1003b2:	6a 03                	push   $0x3
  1003b4:	68 98 50 12 00       	push   $0x125098
  1003b9:	e8 02 ff ff ff       	call   1002c0 <set_segment>
  1003be:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
  1003c1:	6a 02                	push   $0x2
  1003c3:	6a 03                	push   $0x3
  1003c5:	68 a0 50 12 00       	push   $0x1250a0
  1003ca:	e8 f1 fe ff ff       	call   1002c0 <set_segment>
  1003cf:	83 c4 0c             	add    $0xc,%esp

	write_gdtr(gdt, sizeof(gdt));
  1003d2:	6a 30                	push   $0x30
  1003d4:	68 80 50 12 00       	push   $0x125080
  1003d9:	e8 4d fc ff ff       	call   10002b <write_gdtr>
  1003de:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
  1003e1:	68 a8 50 12 00       	push   $0x1250a8
  1003e6:	e8 f8 fd ff ff       	call   1001e3 <set_tss>
  1003eb:	83 c4 04             	add    $0x4,%esp
	write_tr( SELECTOR_USER(SEG_TSS) );
  1003ee:	6a 2b                	push   $0x2b
  1003f0:	e8 64 fc ff ff       	call   100059 <write_tr>
  1003f5:	83 c4 04             	add    $0x4,%esp
}
  1003f8:	c9                   	leave  
  1003f9:	c3                   	ret    

001003fa <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
  1003fa:	55                   	push   %ebp
  1003fb:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  1003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
  100406:	5d                   	pop    %ebp
  100407:	c3                   	ret    

00100408 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
  100408:	55                   	push   %ebp
  100409:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
  100414:	5d                   	pop    %ebp
  100415:	c3                   	ret    

00100416 <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
  100416:	55                   	push   %ebp
  100417:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100419:	8b 45 08             	mov    0x8(%ebp),%eax
  10041c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
  100422:	8b 45 0c             	mov    0xc(%ebp),%eax
  100425:	c1 e8 0c             	shr    $0xc,%eax
  100428:	25 ff ff 0f 00       	and    $0xfffff,%eax
  10042d:	89 c2                	mov    %eax,%edx
  10042f:	8b 45 08             	mov    0x8(%ebp),%eax
  100432:	89 d1                	mov    %edx,%ecx
  100434:	c1 e1 0c             	shl    $0xc,%ecx
  100437:	8b 10                	mov    (%eax),%edx
  100439:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  10043f:	09 ca                	or     %ecx,%edx
  100441:	89 10                	mov    %edx,(%eax)
	p->present = 1;
  100443:	8b 45 08             	mov    0x8(%ebp),%eax
  100446:	0f b6 10             	movzbl (%eax),%edx
  100449:	83 ca 01             	or     $0x1,%edx
  10044c:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
  10044e:	8b 45 08             	mov    0x8(%ebp),%eax
  100451:	0f b6 10             	movzbl (%eax),%edx
  100454:	83 ca 02             	or     $0x2,%edx
  100457:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
  100459:	8b 45 08             	mov    0x8(%ebp),%eax
  10045c:	0f b6 10             	movzbl (%eax),%edx
  10045f:	83 ca 04             	or     $0x4,%edx
  100462:	88 10                	mov    %dl,(%eax)
}
  100464:	5d                   	pop    %ebp
  100465:	c3                   	ret    

00100466 <make_pte>:

void
make_pte(PTE *p, void *addr) {
  100466:	55                   	push   %ebp
  100467:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100469:	8b 45 08             	mov    0x8(%ebp),%eax
  10046c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
  100472:	8b 45 0c             	mov    0xc(%ebp),%eax
  100475:	c1 e8 0c             	shr    $0xc,%eax
  100478:	25 ff ff 0f 00       	and    $0xfffff,%eax
  10047d:	89 c2                	mov    %eax,%edx
  10047f:	8b 45 08             	mov    0x8(%ebp),%eax
  100482:	89 d1                	mov    %edx,%ecx
  100484:	c1 e1 0c             	shl    $0xc,%ecx
  100487:	8b 10                	mov    (%eax),%edx
  100489:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  10048f:	09 ca                	or     %ecx,%edx
  100491:	89 10                	mov    %edx,(%eax)
	p->present = 1;
  100493:	8b 45 08             	mov    0x8(%ebp),%eax
  100496:	0f b6 10             	movzbl (%eax),%edx
  100499:	83 ca 01             	or     $0x1,%edx
  10049c:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
  10049e:	8b 45 08             	mov    0x8(%ebp),%eax
  1004a1:	0f b6 10             	movzbl (%eax),%edx
  1004a4:	83 ca 02             	or     $0x2,%edx
  1004a7:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
  1004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ac:	0f b6 10             	movzbl (%eax),%edx
  1004af:	83 ca 04             	or     $0x4,%edx
  1004b2:	88 10                	mov    %dl,(%eax)
}
  1004b4:	5d                   	pop    %ebp
  1004b5:	c3                   	ret    

001004b6 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void
irq_handle(struct TrapFrame *tf) {
  1004b6:	55                   	push   %ebp
  1004b7:	89 e5                	mov    %esp,%ebp
  1004b9:	83 ec 38             	sub    $0x38,%esp
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
  1004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1004bf:	8b 40 20             	mov    0x20(%eax),%eax
  1004c2:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
  1004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ca:	8b 40 20             	mov    0x20(%eax),%eax
  1004cd:	3d 80 00 00 00       	cmp    $0x80,%eax
  1004d2:	75 0e                	jne    1004e2 <irq_handle+0x2c>
		//printk("ha");
		do_syscall(tf);
  1004d4:	83 ec 0c             	sub    $0xc,%esp
  1004d7:	ff 75 08             	pushl  0x8(%ebp)
  1004da:	e8 4b 09 00 00       	call   100e2a <do_syscall>
  1004df:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
  1004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e5:	8b 40 20             	mov    0x20(%eax),%eax
  1004e8:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  1004ed:	75 0a                	jne    1004f9 <irq_handle+0x43>
		//printk("haha");
		//serial_printc('t');
		do_timer();
  1004ef:	e8 77 0c 00 00       	call   10116b <do_timer>
  1004f4:	e9 83 00 00 00       	jmp    10057c <irq_handle+0xc6>
	} else if (tf->irq == 1001) {
  1004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004fc:	8b 40 20             	mov    0x20(%eax),%eax
  1004ff:	3d e9 03 00 00       	cmp    $0x3e9,%eax
  100504:	75 76                	jne    10057c <irq_handle+0xc6>
  100506:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  10050d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100510:	89 c2                	mov    %eax,%edx
  100512:	ec                   	in     (%dx),%al
  100513:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
  100516:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
  10051a:	0f b6 c0             	movzbl %al,%eax
  10051d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100520:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10052a:	89 c2                	mov    %eax,%edx
  10052c:	ec                   	in     (%dx),%al
  10052d:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
  100530:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
  100534:	0f b6 c0             	movzbl %al,%eax
  100537:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
  10053a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053d:	83 c8 80             	or     $0xffffff80,%eax
  100540:	0f b6 c0             	movzbl %al,%eax
  100543:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
  10054a:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  10054d:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100551:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100554:	ee                   	out    %al,(%dx)
		outb(0x61, val);
  100555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100558:	0f b6 c0             	movzbl %al,%eax
  10055b:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
  100562:	88 45 d3             	mov    %al,-0x2d(%ebp)
  100565:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  100569:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10056c:	ee                   	out    %al,(%dx)
		press_key(code);
  10056d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100570:	83 ec 0c             	sub    $0xc,%esp
  100573:	50                   	push   %eax
  100574:	e8 d7 07 00 00       	call   100d50 <press_key>
  100579:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
}
  10057c:	c9                   	leave  
  10057d:	c3                   	ret    

0010057e <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
  10057e:	55                   	push   %ebp
  10057f:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
  100581:	8b 45 0c             	mov    0xc(%ebp),%eax
  100584:	83 e8 01             	sub    $0x1,%eax
  100587:	66 a3 b6 50 12 00    	mov    %ax,0x1250b6
	data[1] = (uint32_t)addr;
  10058d:	8b 45 08             	mov    0x8(%ebp),%eax
  100590:	66 a3 b8 50 12 00    	mov    %ax,0x1250b8
	data[2] = ((uint32_t)addr) >> 16;
  100596:	8b 45 08             	mov    0x8(%ebp),%eax
  100599:	c1 e8 10             	shr    $0x10,%eax
  10059c:	66 a3 ba 50 12 00    	mov    %ax,0x1250ba
	asm volatile("lidt (%0)" : : "r"(data));
  1005a2:	b8 b6 50 12 00       	mov    $0x1250b6,%eax
  1005a7:	0f 01 18             	lidtl  (%eax)
}
  1005aa:	5d                   	pop    %ebp
  1005ab:	c3                   	ret    

001005ac <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
  1005ac:	55                   	push   %ebp
  1005ad:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
  1005af:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b2:	89 c2                	mov    %eax,%edx
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
  1005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ce:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
  1005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d5:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1005d9:	83 e2 f0             	and    $0xfffffff0,%edx
  1005dc:	83 ca 0e             	or     $0xe,%edx
  1005df:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
  1005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e5:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1005e9:	83 e2 ef             	and    $0xffffffef,%edx
  1005ec:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
  1005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  1005f2:	83 e0 03             	and    $0x3,%eax
  1005f5:	89 c2                	mov    %eax,%edx
  1005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fa:	83 e2 03             	and    $0x3,%edx
  1005fd:	89 d1                	mov    %edx,%ecx
  1005ff:	c1 e1 05             	shl    $0x5,%ecx
  100602:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100606:	83 e2 9f             	and    $0xffffff9f,%edx
  100609:	09 ca                	or     %ecx,%edx
  10060b:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  10060e:	8b 45 08             	mov    0x8(%ebp),%eax
  100611:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100615:	83 ca 80             	or     $0xffffff80,%edx
  100618:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
  10061b:	8b 45 10             	mov    0x10(%ebp),%eax
  10061e:	c1 e8 10             	shr    $0x10,%eax
  100621:	89 c2                	mov    %eax,%edx
  100623:	8b 45 08             	mov    0x8(%ebp),%eax
  100626:	66 89 50 06          	mov    %dx,0x6(%eax)
}
  10062a:	5d                   	pop    %ebp
  10062b:	c3                   	ret    

0010062c <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
  10062c:	55                   	push   %ebp
  10062d:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
  10062f:	8b 45 10             	mov    0x10(%ebp),%eax
  100632:	89 c2                	mov    %eax,%edx
  100634:	8b 45 08             	mov    0x8(%ebp),%eax
  100637:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
  10063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  100644:	8b 45 08             	mov    0x8(%ebp),%eax
  100647:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
  10064b:	8b 45 08             	mov    0x8(%ebp),%eax
  10064e:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
  100652:	8b 45 08             	mov    0x8(%ebp),%eax
  100655:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100659:	83 ca 0f             	or     $0xf,%edx
  10065c:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
  10065f:	8b 45 08             	mov    0x8(%ebp),%eax
  100662:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100666:	83 e2 ef             	and    $0xffffffef,%edx
  100669:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
  10066c:	8b 45 14             	mov    0x14(%ebp),%eax
  10066f:	83 e0 03             	and    $0x3,%eax
  100672:	89 c2                	mov    %eax,%edx
  100674:	8b 45 08             	mov    0x8(%ebp),%eax
  100677:	83 e2 03             	and    $0x3,%edx
  10067a:	89 d1                	mov    %edx,%ecx
  10067c:	c1 e1 05             	shl    $0x5,%ecx
  10067f:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100683:	83 e2 9f             	and    $0xffffff9f,%edx
  100686:	09 ca                	or     %ecx,%edx
  100688:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  10068b:	8b 45 08             	mov    0x8(%ebp),%eax
  10068e:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100692:	83 ca 80             	or     $0xffffff80,%edx
  100695:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
  100698:	8b 45 10             	mov    0x10(%ebp),%eax
  10069b:	c1 e8 10             	shr    $0x10,%eax
  10069e:	89 c2                	mov    %eax,%edx
  1006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a3:	66 89 50 06          	mov    %dx,0x6(%eax)
}
  1006a7:	5d                   	pop    %ebp
  1006a8:	c3                   	ret    

001006a9 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
  1006a9:	55                   	push   %ebp
  1006aa:	89 e5                	mov    %esp,%ebp
  1006ac:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
  1006af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1006b6:	eb 22                	jmp    1006da <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
  1006b8:	ba 3e 12 10 00       	mov    $0x10123e,%edx
  1006bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006c0:	c1 e0 03             	shl    $0x3,%eax
  1006c3:	05 80 4a 14 00       	add    $0x144a80,%eax
  1006c8:	6a 00                	push   $0x0
  1006ca:	52                   	push   %edx
  1006cb:	6a 01                	push   $0x1
  1006cd:	50                   	push   %eax
  1006ce:	e8 59 ff ff ff       	call   10062c <set_trap>
  1006d3:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
  1006d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1006da:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1006e1:	7e d5                	jle    1006b8 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
  1006e3:	b8 87 11 10 00       	mov    $0x101187,%eax
  1006e8:	6a 00                	push   $0x0
  1006ea:	50                   	push   %eax
  1006eb:	6a 01                	push   $0x1
  1006ed:	68 80 4a 14 00       	push   $0x144a80
  1006f2:	e8 35 ff ff ff       	call   10062c <set_trap>
  1006f7:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
  1006fa:	b8 90 11 10 00       	mov    $0x101190,%eax
  1006ff:	6a 00                	push   $0x0
  100701:	50                   	push   %eax
  100702:	6a 01                	push   $0x1
  100704:	68 88 4a 14 00       	push   $0x144a88
  100709:	e8 1e ff ff ff       	call   10062c <set_trap>
  10070e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
  100711:	b8 99 11 10 00       	mov    $0x101199,%eax
  100716:	6a 00                	push   $0x0
  100718:	50                   	push   %eax
  100719:	6a 01                	push   $0x1
  10071b:	68 90 4a 14 00       	push   $0x144a90
  100720:	e8 07 ff ff ff       	call   10062c <set_trap>
  100725:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
  100728:	b8 a2 11 10 00       	mov    $0x1011a2,%eax
  10072d:	6a 00                	push   $0x0
  10072f:	50                   	push   %eax
  100730:	6a 01                	push   $0x1
  100732:	68 98 4a 14 00       	push   $0x144a98
  100737:	e8 f0 fe ff ff       	call   10062c <set_trap>
  10073c:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
  10073f:	b8 ab 11 10 00       	mov    $0x1011ab,%eax
  100744:	6a 00                	push   $0x0
  100746:	50                   	push   %eax
  100747:	6a 01                	push   $0x1
  100749:	68 a0 4a 14 00       	push   $0x144aa0
  10074e:	e8 d9 fe ff ff       	call   10062c <set_trap>
  100753:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
  100756:	b8 b4 11 10 00       	mov    $0x1011b4,%eax
  10075b:	6a 00                	push   $0x0
  10075d:	50                   	push   %eax
  10075e:	6a 01                	push   $0x1
  100760:	68 a8 4a 14 00       	push   $0x144aa8
  100765:	e8 c2 fe ff ff       	call   10062c <set_trap>
  10076a:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
  10076d:	b8 bd 11 10 00       	mov    $0x1011bd,%eax
  100772:	6a 00                	push   $0x0
  100774:	50                   	push   %eax
  100775:	6a 01                	push   $0x1
  100777:	68 b0 4a 14 00       	push   $0x144ab0
  10077c:	e8 ab fe ff ff       	call   10062c <set_trap>
  100781:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
  100784:	b8 c6 11 10 00       	mov    $0x1011c6,%eax
  100789:	6a 00                	push   $0x0
  10078b:	50                   	push   %eax
  10078c:	6a 01                	push   $0x1
  10078e:	68 b8 4a 14 00       	push   $0x144ab8
  100793:	e8 94 fe ff ff       	call   10062c <set_trap>
  100798:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
  10079b:	b8 cf 11 10 00       	mov    $0x1011cf,%eax
  1007a0:	6a 00                	push   $0x0
  1007a2:	50                   	push   %eax
  1007a3:	6a 01                	push   $0x1
  1007a5:	68 c0 4a 14 00       	push   $0x144ac0
  1007aa:	e8 7d fe ff ff       	call   10062c <set_trap>
  1007af:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
  1007b2:	b8 d8 11 10 00       	mov    $0x1011d8,%eax
  1007b7:	6a 00                	push   $0x0
  1007b9:	50                   	push   %eax
  1007ba:	6a 01                	push   $0x1
  1007bc:	68 c8 4a 14 00       	push   $0x144ac8
  1007c1:	e8 66 fe ff ff       	call   10062c <set_trap>
  1007c6:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
  1007c9:	b8 e1 11 10 00       	mov    $0x1011e1,%eax
  1007ce:	6a 00                	push   $0x0
  1007d0:	50                   	push   %eax
  1007d1:	6a 01                	push   $0x1
  1007d3:	68 d0 4a 14 00       	push   $0x144ad0
  1007d8:	e8 4f fe ff ff       	call   10062c <set_trap>
  1007dd:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
  1007e0:	b8 ea 11 10 00       	mov    $0x1011ea,%eax
  1007e5:	6a 00                	push   $0x0
  1007e7:	50                   	push   %eax
  1007e8:	6a 01                	push   $0x1
  1007ea:	68 d8 4a 14 00       	push   $0x144ad8
  1007ef:	e8 38 fe ff ff       	call   10062c <set_trap>
  1007f4:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
  1007f7:	b8 f3 11 10 00       	mov    $0x1011f3,%eax
  1007fc:	6a 00                	push   $0x0
  1007fe:	50                   	push   %eax
  1007ff:	6a 01                	push   $0x1
  100801:	68 e0 4a 14 00       	push   $0x144ae0
  100806:	e8 21 fe ff ff       	call   10062c <set_trap>
  10080b:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
  10080e:	b8 fc 11 10 00       	mov    $0x1011fc,%eax
  100813:	6a 00                	push   $0x0
  100815:	50                   	push   %eax
  100816:	6a 01                	push   $0x1
  100818:	68 e8 4a 14 00       	push   $0x144ae8
  10081d:	e8 0a fe ff ff       	call   10062c <set_trap>
  100822:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
  100825:	b8 0e 12 10 00       	mov    $0x10120e,%eax
  10082a:	6a 03                	push   $0x3
  10082c:	50                   	push   %eax
  10082d:	6a 01                	push   $0x1
  10082f:	68 80 4e 14 00       	push   $0x144e80
  100834:	e8 f3 fd ff ff       	call   10062c <set_trap>
  100839:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
  10083c:	b8 1a 12 10 00       	mov    $0x10121a,%eax
  100841:	6a 00                	push   $0x0
  100843:	50                   	push   %eax
  100844:	6a 01                	push   $0x1
  100846:	68 80 4b 14 00       	push   $0x144b80
  10084b:	e8 5c fd ff ff       	call   1005ac <set_intr>
  100850:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
  100853:	b8 26 12 10 00       	mov    $0x101226,%eax
  100858:	6a 00                	push   $0x0
  10085a:	50                   	push   %eax
  10085b:	6a 01                	push   $0x1
  10085d:	68 88 4b 14 00       	push   $0x144b88
  100862:	e8 45 fd ff ff       	call   1005ac <set_intr>
  100867:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
  10086a:	68 00 08 00 00       	push   $0x800
  10086f:	68 80 4a 14 00       	push   $0x144a80
  100874:	e8 05 fd ff ff       	call   10057e <save_idt>
  100879:	83 c4 08             	add    $0x8,%esp
}
  10087c:	c9                   	leave  
  10087d:	c3                   	ret    

0010087e <enable_interrupt>:

/* 打开外部中断 */
static inline void
enable_interrupt(void) {
  10087e:	55                   	push   %ebp
  10087f:	89 e5                	mov    %esp,%ebp
	asm volatile("sti");
  100881:	fb                   	sti    
}
  100882:	5d                   	pop    %ebp
  100883:	c3                   	ret    

00100884 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
  100884:	55                   	push   %ebp
  100885:	89 e5                	mov    %esp,%ebp
  100887:	83 ec 40             	sub    $0x40,%esp
  10088a:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
  100891:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100895:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10089c:	ee                   	out    %al,(%dx)
  10089d:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
  1008a4:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
  1008a8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1008ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008af:	ee                   	out    %al,(%dx)
  1008b0:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
  1008b7:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
  1008bb:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1008bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008c2:	ee                   	out    %al,(%dx)
  1008c3:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
  1008ca:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
  1008ce:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1008d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008d5:	ee                   	out    %al,(%dx)
  1008d6:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
  1008dd:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1008e1:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1008e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008e8:	ee                   	out    %al,(%dx)
  1008e9:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
  1008f0:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
  1008f4:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  1008f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008fb:	ee                   	out    %al,(%dx)
  1008fc:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
  100903:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
  100907:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
  10090b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10090e:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
  10090f:	c9                   	leave  
  100910:	c3                   	ret    

00100911 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
  100911:	55                   	push   %ebp
  100912:	89 e5                	mov    %esp,%ebp
  100914:	83 ec 70             	sub    $0x70,%esp
  100917:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
  10091e:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
  100922:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100926:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100929:	ee                   	out    %al,(%dx)
  10092a:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
  100931:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
  100935:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100939:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093c:	ee                   	out    %al,(%dx)
  10093d:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  100944:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
  100948:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10094c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10094f:	ee                   	out    %al,(%dx)
  100950:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
  100957:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  10095b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10095f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100962:	ee                   	out    %al,(%dx)
  100963:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
  10096a:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
  10096e:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100972:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100975:	ee                   	out    %al,(%dx)
  100976:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
  10097d:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
  100981:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  100985:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100988:	ee                   	out    %al,(%dx)
  100989:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
  100990:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
  100994:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
  100998:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10099b:	ee                   	out    %al,(%dx)
  10099c:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
  1009a3:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
  1009a7:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
  1009ab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1009ae:	ee                   	out    %al,(%dx)
  1009af:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
  1009b6:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
  1009ba:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
  1009be:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1009c1:	ee                   	out    %al,(%dx)
  1009c2:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
  1009c9:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
  1009cd:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
  1009d1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1009d4:	ee                   	out    %al,(%dx)
  1009d5:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
  1009dc:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
  1009e0:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
  1009e4:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1009e7:	ee                   	out    %al,(%dx)
  1009e8:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
  1009ef:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
  1009f3:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
  1009f7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1009fa:	ee                   	out    %al,(%dx)
  1009fb:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
  100a02:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
  100a06:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
  100a0a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  100a0d:	ee                   	out    %al,(%dx)
  100a0e:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
  100a15:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
  100a19:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
  100a1d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  100a20:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
  100a21:	c9                   	leave  
  100a22:	c3                   	ret    

00100a23 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
  100a23:	55                   	push   %ebp
  100a24:	89 e5                	mov    %esp,%ebp
  100a26:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
  100a29:	c7 45 fc 9b 2e 00 00 	movl   $0x2e9b,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
  100a30:	0f b6 05 00 20 10 00 	movzbl 0x102000,%eax
  100a37:	0f b6 c0             	movzbl %al,%eax
  100a3a:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
  100a41:	88 45 f7             	mov    %al,-0x9(%ebp)
  100a44:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100a48:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100a4b:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
  100a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a4f:	0f b6 c0             	movzbl %al,%eax
  100a52:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
  100a59:	88 45 ef             	mov    %al,-0x11(%ebp)
  100a5c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100a60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100a63:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
  100a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a67:	c1 f8 08             	sar    $0x8,%eax
  100a6a:	0f b6 c0             	movzbl %al,%eax
  100a6d:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
  100a74:	88 45 e7             	mov    %al,-0x19(%ebp)
  100a77:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100a7b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100a7e:	ee                   	out    %al,(%dx)
}
  100a7f:	c9                   	leave  
  100a80:	c3                   	ret    

00100a81 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
  100a81:	55                   	push   %ebp
  100a82:	89 e5                	mov    %esp,%ebp
  100a84:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
  100a87:	90                   	nop
  100a88:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a92:	89 c2                	mov    %eax,%edx
  100a94:	ec                   	in     (%dx),%al
  100a95:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
  100a98:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100a9c:	0f b6 c0             	movzbl %al,%eax
  100a9f:	25 c0 00 00 00       	and    $0xc0,%eax
  100aa4:	83 f8 40             	cmp    $0x40,%eax
  100aa7:	75 df                	jne    100a88 <waitdisk+0x7>
}
  100aa9:	c9                   	leave  
  100aaa:	c3                   	ret    

00100aab <readsect>:

static inline void
readsect(void *dst, int offset) {
  100aab:	55                   	push   %ebp
  100aac:	89 e5                	mov    %esp,%ebp
  100aae:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
  100ab1:	e8 cb ff ff ff       	call   100a81 <waitdisk>
  100ab6:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
  100abd:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100ac1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100ac5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100ac8:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
  100ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100acc:	0f b6 c0             	movzbl %al,%eax
  100acf:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
  100ad6:	88 45 ef             	mov    %al,-0x11(%ebp)
  100ad9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100add:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ae0:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
  100ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae4:	c1 f8 08             	sar    $0x8,%eax
  100ae7:	0f b6 c0             	movzbl %al,%eax
  100aea:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
  100af1:	88 45 e7             	mov    %al,-0x19(%ebp)
  100af4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100af8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100afb:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
  100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aff:	c1 f8 10             	sar    $0x10,%eax
  100b02:	0f b6 c0             	movzbl %al,%eax
  100b05:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
  100b0c:	88 45 df             	mov    %al,-0x21(%ebp)
  100b0f:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100b13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100b16:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
  100b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b1a:	c1 f8 18             	sar    $0x18,%eax
  100b1d:	83 c8 e0             	or     $0xffffffe0,%eax
  100b20:	0f b6 c0             	movzbl %al,%eax
  100b23:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
  100b2a:	88 45 d7             	mov    %al,-0x29(%ebp)
  100b2d:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100b31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100b34:	ee                   	out    %al,(%dx)
  100b35:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
  100b3c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
  100b40:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
  100b44:	8b 55 d0             	mov    -0x30(%ebp),%edx
  100b47:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
  100b48:	e8 34 ff ff ff       	call   100a81 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
  100b4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100b54:	eb 29                	jmp    100b7f <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
  100b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b60:	8b 45 08             	mov    0x8(%ebp),%eax
  100b63:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  100b66:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
  100b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  100b70:	89 c2                	mov    %eax,%edx
  100b72:	ed                   	in     (%dx),%eax
  100b73:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
  100b76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  100b79:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
  100b7b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100b7f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100b83:	7e d1                	jle    100b56 <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
  100b85:	c9                   	leave  
  100b86:	c3                   	ret    

00100b87 <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
  100b87:	55                   	push   %ebp
  100b88:	89 e5                	mov    %esp,%ebp
  100b8a:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
  100b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b90:	8b 45 08             	mov    0x8(%ebp),%eax
  100b93:	01 d0                	add    %edx,%eax
  100b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
  100b98:	8b 45 10             	mov    0x10(%ebp),%eax
  100b9b:	99                   	cltd   
  100b9c:	c1 ea 17             	shr    $0x17,%edx
  100b9f:	01 d0                	add    %edx,%eax
  100ba1:	25 ff 01 00 00       	and    $0x1ff,%eax
  100ba6:	29 d0                	sub    %edx,%eax
  100ba8:	f7 d8                	neg    %eax
  100baa:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
  100bad:	8b 45 10             	mov    0x10(%ebp),%eax
  100bb0:	99                   	cltd   
  100bb1:	c1 ea 17             	shr    $0x17,%edx
  100bb4:	01 d0                	add    %edx,%eax
  100bb6:	c1 f8 09             	sar    $0x9,%eax
  100bb9:	83 c0 01             	add    $0x1,%eax
  100bbc:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
  100bbf:	eb 19                	jmp    100bda <readseg+0x53>
        readsect(pa, offset);
  100bc1:	ff 75 10             	pushl  0x10(%ebp)
  100bc4:	ff 75 08             	pushl  0x8(%ebp)
  100bc7:	e8 df fe ff ff       	call   100aab <readsect>
  100bcc:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
  100bcf:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
  100bd6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  100bda:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100be0:	72 df                	jb     100bc1 <readseg+0x3a>
        readsect(pa, offset);
  100be2:	c9                   	leave  
  100be3:	c3                   	ret    

00100be4 <main>:

extern void init_segment(void);
extern void init_page(void);
int main_after_you();

int main(){
  100be4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  100be8:	83 e4 f0             	and    $0xfffffff0,%esp
  100beb:	ff 71 fc             	pushl  -0x4(%ecx)
  100bee:	55                   	push   %ebp
  100bef:	89 e5                	mov    %esp,%ebp
  100bf1:	51                   	push   %ecx
  100bf2:	83 ec 04             	sub    $0x4,%esp
  init_page();
  100bf5:	e8 ac f4 ff ff       	call   1000a6 <init_page>
  /* After paging is enabled, we can jump to the high address to keep 
   * consistent with virtual memory, although it is not necessary. */
  //main_after_you();
  asm volatile (" addl %0, %%esp\n\t\
  100bfa:	b8 00 00 00 c0       	mov    $0xc0000000,%eax
  100bff:	ba 16 0c 10 00       	mov    $0x100c16,%edx
  100c04:	01 c4                	add    %eax,%esp
  100c06:	ff e2                	jmp    *%edx
  100c08:	b8 00 00 00 00       	mov    $0x0,%eax
          jmp *%1": : "r"(KOFFSET), "r"(main_after_you));
}
  100c0d:	83 c4 04             	add    $0x4,%esp
  100c10:	59                   	pop    %ecx
  100c11:	5d                   	pop    %ebp
  100c12:	8d 61 fc             	lea    -0x4(%ecx),%esp
  100c15:	c3                   	ret    

00100c16 <main_after_you>:

int main_after_you(){
  100c16:	55                   	push   %ebp
  100c17:	89 e5                	mov    %esp,%ebp
  100c19:	83 ec 18             	sub    $0x18,%esp
  init_segment();
  100c1c:	e8 59 f7 ff ff       	call   10037a <init_segment>
	init_serial();
  100c21:	e8 5e fc ff ff       	call   100884 <init_serial>
	init_timer();
  100c26:	e8 f8 fd ff ff       	call   100a23 <init_timer>
	init_idt();
  100c2b:	e8 79 fa ff ff       	call   1006a9 <init_idt>
	init_intr();
  100c30:	e8 dc fc ff ff       	call   100911 <init_intr>


  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);
  100c35:	83 ec 04             	sub    $0x4,%esp
  100c38:	68 00 90 01 00       	push   $0x19000
  100c3d:	68 00 10 00 00       	push   $0x1000
  100c42:	68 00 00 01 00       	push   $0x10000
  100c47:	e8 3b ff ff ff       	call   100b87 <readseg>
  100c4c:	83 c4 10             	add    $0x10,%esp

  printf("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
  100c4f:	b8 00 00 01 00       	mov    $0x10000,%eax
  100c54:	8b 00                	mov    (%eax),%eax
  100c56:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  100c5b:	0f 94 c0             	sete   %al
  100c5e:	0f b6 c0             	movzbl %al,%eax
  100c61:	83 ec 08             	sub    $0x8,%esp
  100c64:	50                   	push   %eax
  100c65:	68 79 15 10 00       	push   $0x101579
  100c6a:	e8 e5 08 00 00       	call   101554 <printf>
  100c6f:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  100c72:	b8 00 00 01 00       	mov    $0x10000,%eax
  100c77:	8b 40 1c             	mov    0x1c(%eax),%eax
  100c7a:	05 00 00 01 00       	add    $0x10000,%eax
  100c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
  100c82:	b8 00 00 01 00       	mov    $0x10000,%eax
  100c87:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  100c8b:	0f b7 c0             	movzwl %ax,%eax
  100c8e:	c1 e0 05             	shl    $0x5,%eax
  100c91:	89 c2                	mov    %eax,%edx
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	01 d0                	add    %edx,%eax
  100c98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; ph < eph; ph ++) {
  100c9b:	eb 5c                	jmp    100cf9 <main_after_you+0xe3>
    //printf("%x %x\n", ph->paddr, ph->off);
    pa = (unsigned char*)ph->paddr; 
  100c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  100ca3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    readseg(pa, ph->filesz, 102400+ph->off); 
  100ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca9:	8b 40 04             	mov    0x4(%eax),%eax
  100cac:	05 00 90 01 00       	add    $0x19000,%eax
  100cb1:	89 c2                	mov    %eax,%edx
  100cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb6:	8b 40 10             	mov    0x10(%eax),%eax
  100cb9:	83 ec 04             	sub    $0x4,%esp
  100cbc:	52                   	push   %edx
  100cbd:	50                   	push   %eax
  100cbe:	ff 75 e8             	pushl  -0x18(%ebp)
  100cc1:	e8 c1 fe ff ff       	call   100b87 <readseg>
  100cc6:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  100cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ccc:	8b 50 10             	mov    0x10(%eax),%edx
  100ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100cd2:	01 d0                	add    %edx,%eax
  100cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100cd7:	eb 0c                	jmp    100ce5 <main_after_you+0xcf>
  100cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100cdc:	8d 50 01             	lea    0x1(%eax),%edx
  100cdf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100ce2:	c6 00 00             	movb   $0x0,(%eax)
  100ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce8:	8b 50 14             	mov    0x14(%eax),%edx
  100ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100cee:	01 d0                	add    %edx,%eax
  100cf0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  100cf3:	77 e4                	ja     100cd9 <main_after_you+0xc3>
  printf("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph ++) {
  100cf5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
  100cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100cff:	72 9c                	jb     100c9d <main_after_you+0x87>
    pa = (unsigned char*)ph->paddr; 
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }

  printf("%s\n", "Here we go!");
  100d01:	83 ec 08             	sub    $0x8,%esp
  100d04:	68 8e 15 10 00       	push   $0x10158e
  100d09:	68 9a 15 10 00       	push   $0x10159a
  100d0e:	e8 41 08 00 00       	call   101554 <printf>
  100d13:	83 c4 10             	add    $0x10,%esp

  //printf("%x %x\n", (int)elf->entry, *(int*)(elf->entry));
  enable_interrupt();
  100d16:	e8 63 fb ff ff       	call   10087e <enable_interrupt>
  ((void(*)(void))elf->entry)();
  100d1b:	b8 00 00 01 00       	mov    $0x10000,%eax
  100d20:	8b 40 18             	mov    0x18(%eax),%eax
  100d23:	ff d0                	call   *%eax
    /*if(sys_key_down('a'))printf("%s\n", "hahahah");;
    //printf("%c", get_lastkey());
    wait_for_interrupt();
    disable_interrupt();
    enable_interrupt();*/
  };
  100d25:	eb fe                	jmp    100d25 <main_after_you+0x10f>

00100d27 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
  100d2a:	83 ec 04             	sub    $0x4,%esp
  100d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d30:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
  100d33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  100d37:	83 e8 61             	sub    $0x61,%eax
  100d3a:	8b 04 85 c0 50 12 00 	mov    0x1250c0(,%eax,4),%eax
}
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <get_lastkey>:
int8_t get_lastkey(){
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
  100d46:	a1 28 51 12 00       	mov    0x125128,%eax
  100d4b:	83 c0 61             	add    $0x61,%eax
}
  100d4e:	5d                   	pop    %ebp
  100d4f:	c3                   	ret    

00100d50 <press_key>:
void press_key(int code){
  100d50:	55                   	push   %ebp
  100d51:	89 e5                	mov    %esp,%ebp
  100d53:	83 ec 10             	sub    $0x10,%esp
	int i=0;
  100d56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
  100d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d60:	25 80 00 00 00       	and    $0x80,%eax
  100d65:	85 c0                	test   %eax,%eax
  100d67:	75 35                	jne    100d9e <press_key+0x4e>
		for(;i<26;i++){
  100d69:	eb 2b                	jmp    100d96 <press_key+0x46>
			if(letter[i]==code){
  100d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d6e:	8b 04 85 40 20 10 00 	mov    0x102040(,%eax,4),%eax
  100d75:	3b 45 08             	cmp    0x8(%ebp),%eax
  100d78:	75 18                	jne    100d92 <press_key+0x42>
				keydown[i] = 1;
  100d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d7d:	c7 04 85 c0 50 12 00 	movl   $0x1,0x1250c0(,%eax,4)
  100d84:	01 00 00 00 
				lastkey = i;
  100d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d8b:	a3 28 51 12 00       	mov    %eax,0x125128
				return;
  100d90:	eb 3b                	jmp    100dcd <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
  100d92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100d96:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
  100d9a:	7e cf                	jle    100d6b <press_key+0x1b>
  100d9c:	eb 2f                	jmp    100dcd <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
  100d9e:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
  100da2:	eb 23                	jmp    100dc7 <press_key+0x77>
			if(letter[i]==code){
  100da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100da7:	8b 04 85 40 20 10 00 	mov    0x102040(,%eax,4),%eax
  100dae:	3b 45 08             	cmp    0x8(%ebp),%eax
  100db1:	75 10                	jne    100dc3 <press_key+0x73>
				keydown[i] = 0;
  100db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100db6:	c7 04 85 c0 50 12 00 	movl   $0x0,0x1250c0(,%eax,4)
  100dbd:	00 00 00 00 
				return;
  100dc1:	eb 0a                	jmp    100dcd <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
  100dc3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100dc7:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
  100dcb:	7e d7                	jle    100da4 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
  100dcd:	c9                   	leave  
  100dce:	c3                   	ret    

00100dcf <serial_idle>:

static inline
int serial_idle(void) {
  100dcf:	55                   	push   %ebp
  100dd0:	89 e5                	mov    %esp,%ebp
  100dd2:	83 ec 10             	sub    $0x10,%esp
  100dd5:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ddf:	89 c2                	mov    %eax,%edx
  100de1:	ec                   	in     (%dx),%al
  100de2:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
  100de5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
  100de9:	0f b6 c0             	movzbl %al,%eax
  100dec:	83 e0 20             	and    $0x20,%eax
  100def:	85 c0                	test   %eax,%eax
  100df1:	0f 95 c0             	setne  %al
  100df4:	0f b6 c0             	movzbl %al,%eax
}
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <serial_printc>:

static inline
void serial_printc(char ch) {
  100df9:	55                   	push   %ebp
  100dfa:	89 e5                	mov    %esp,%ebp
  100dfc:	83 ec 14             	sub    $0x14,%esp
  100dff:	8b 45 08             	mov    0x8(%ebp),%eax
  100e02:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
  100e05:	90                   	nop
  100e06:	e8 c4 ff ff ff       	call   100dcf <serial_idle>
  100e0b:	85 c0                	test   %eax,%eax
  100e0d:	74 f7                	je     100e06 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
  100e0f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e13:	0f b6 c0             	movzbl %al,%eax
  100e16:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
  100e1d:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100e20:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100e24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100e27:	ee                   	out    %al,(%dx)
}
  100e28:	c9                   	leave  
  100e29:	c3                   	ret    

00100e2a <do_syscall>:
#include "lib/syscall.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();

void do_syscall(struct TrapFrame *tf) {
  100e2a:	55                   	push   %ebp
  100e2b:	89 e5                	mov    %esp,%ebp
  100e2d:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	int i;
	switch(tf->eax) {
  100e30:	8b 45 08             	mov    0x8(%ebp),%eax
  100e33:	8b 40 1c             	mov    0x1c(%eax),%eax
  100e36:	3d 4e 04 00 00       	cmp    $0x44e,%eax
  100e3b:	0f 84 85 00 00 00    	je     100ec6 <do_syscall+0x9c>
  100e41:	3d 4e 04 00 00       	cmp    $0x44e,%eax
  100e46:	77 1a                	ja     100e62 <do_syscall+0x38>
  100e48:	3d 4c 04 00 00       	cmp    $0x44c,%eax
  100e4d:	74 63                	je     100eb2 <do_syscall+0x88>
  100e4f:	3d 4c 04 00 00       	cmp    $0x44c,%eax
  100e54:	77 66                	ja     100ebc <do_syscall+0x92>
  100e56:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  100e5b:	74 3e                	je     100e9b <do_syscall+0x71>
  100e5d:	e9 0d 01 00 00       	jmp    100f6f <do_syscall+0x145>
  100e62:	3d b0 04 00 00       	cmp    $0x4b0,%eax
  100e67:	0f 84 8f 00 00 00    	je     100efc <do_syscall+0xd2>
  100e6d:	3d b0 04 00 00       	cmp    $0x4b0,%eax
  100e72:	77 0c                	ja     100e80 <do_syscall+0x56>
  100e74:	3d 4f 04 00 00       	cmp    $0x44f,%eax
  100e79:	74 5a                	je     100ed5 <do_syscall+0xab>
  100e7b:	e9 ef 00 00 00       	jmp    100f6f <do_syscall+0x145>
  100e80:	3d 14 05 00 00       	cmp    $0x514,%eax
  100e85:	0f 84 a0 00 00 00    	je     100f2b <do_syscall+0x101>
  100e8b:	3d 15 05 00 00       	cmp    $0x515,%eax
  100e90:	0f 84 86 00 00 00    	je     100f1c <do_syscall+0xf2>
  100e96:	e9 d4 00 00 00       	jmp    100f6f <do_syscall+0x145>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
  100e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100e9e:	8b 40 10             	mov    0x10(%eax),%eax
  100ea1:	0f be c0             	movsbl %al,%eax
  100ea4:	50                   	push   %eax
  100ea5:	e8 4f ff ff ff       	call   100df9 <serial_printc>
  100eaa:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
  100ead:	e9 bd 00 00 00       	jmp    100f6f <do_syscall+0x145>
		case SYS_INIT_CACHE:
			initVCache();
  100eb2:	e8 d7 00 00 00       	call   100f8e <initVCache>
		break;
  100eb7:	e9 b3 00 00 00       	jmp    100f6f <do_syscall+0x145>
		case SYS_CLEAR_VRAM:
			clearVRAM();
  100ebc:	e8 02 02 00 00       	call   1010c3 <clearVRAM>
		break;
  100ec1:	e9 a9 00 00 00       	jmp    100f6f <do_syscall+0x145>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
  100ec6:	e8 f8 01 00 00       	call   1010c3 <clearVRAM>
			flushVCache();
  100ecb:	e8 27 01 00 00       	call   100ff7 <flushVCache>
		break;
  100ed0:	e9 9a 00 00 00       	jmp    100f6f <do_syscall+0x145>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
  100ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ed8:	8b 40 14             	mov    0x14(%eax),%eax
  100edb:	0f b6 c0             	movzbl %al,%eax
  100ede:	8b 55 08             	mov    0x8(%ebp),%edx
  100ee1:	8b 52 18             	mov    0x18(%edx),%edx
  100ee4:	89 d1                	mov    %edx,%ecx
  100ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  100ee9:	8b 52 10             	mov    0x10(%edx),%edx
  100eec:	83 ec 04             	sub    $0x4,%esp
  100eef:	50                   	push   %eax
  100ef0:	51                   	push   %ecx
  100ef1:	52                   	push   %edx
  100ef2:	e8 65 01 00 00       	call   10105c <setPixelAt>
  100ef7:	83 c4 10             	add    $0x10,%esp
		break;
  100efa:	eb 73                	jmp    100f6f <do_syscall+0x145>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
  100efc:	8b 45 08             	mov    0x8(%ebp),%eax
  100eff:	8b 40 10             	mov    0x10(%eax),%eax
  100f02:	0f be c0             	movsbl %al,%eax
  100f05:	83 ec 0c             	sub    $0xc,%esp
  100f08:	50                   	push   %eax
  100f09:	e8 19 fe ff ff       	call   100d27 <get_key>
  100f0e:	83 c4 10             	add    $0x10,%esp
  100f11:	0f be d0             	movsbl %al,%edx
  100f14:	8b 45 08             	mov    0x8(%ebp),%eax
  100f17:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
  100f1a:	eb 53                	jmp    100f6f <do_syscall+0x145>
		case SYS_GET_TICK:
			tf->eax = tick();
  100f1c:	e8 5c 02 00 00       	call   10117d <tick>
  100f21:	89 c2                	mov    %eax,%edx
  100f23:	8b 45 08             	mov    0x8(%ebp),%eax
  100f26:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
  100f29:	eb 44                	jmp    100f6f <do_syscall+0x145>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
  100f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100f32:	eb 34                	jmp    100f68 <do_syscall+0x13e>
				if(!timer_handlers[i].used){
  100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f37:	8b 04 c5 44 47 14 00 	mov    0x144744(,%eax,8),%eax
  100f3e:	85 c0                	test   %eax,%eax
  100f40:	75 22                	jne    100f64 <do_syscall+0x13a>
					timer_handlers[i].ptr = (void*)tf->ebx;
  100f42:	8b 45 08             	mov    0x8(%ebp),%eax
  100f45:	8b 40 10             	mov    0x10(%eax),%eax
  100f48:	89 c2                	mov    %eax,%edx
  100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4d:	89 14 c5 40 47 14 00 	mov    %edx,0x144740(,%eax,8)
					timer_handlers[i].used = 1;
  100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f57:	c7 04 c5 44 47 14 00 	movl   $0x1,0x144744(,%eax,8)
  100f5e:	01 00 00 00 
					break;
  100f62:	eb 0a                	jmp    100f6e <do_syscall+0x144>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
  100f64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100f68:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  100f6c:	7e c6                	jle    100f34 <do_syscall+0x10a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
  100f6e:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
  100f6f:	c9                   	leave  
  100f70:	c3                   	ret    

00100f71 <memcpy>:
#include "inc/types.h"
#include "inc/x86.h"

void printf(const char *ctl, ...);

static inline void memcpy(void* dst, void* src, int len){
  100f71:	55                   	push   %ebp
  100f72:	89 e5                	mov    %esp,%ebp
  100f74:	57                   	push   %edi
  100f75:	56                   	push   %esi
  100f76:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
  100f77:	8b 45 10             	mov    0x10(%ebp),%eax
  100f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  100f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f80:	89 c1                	mov    %eax,%ecx
  100f82:	89 d6                	mov    %edx,%esi
  100f84:	89 df                	mov    %ebx,%edi
  100f86:	fc                   	cld    
  100f87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
  100f89:	5b                   	pop    %ebx
  100f8a:	5e                   	pop    %esi
  100f8b:	5f                   	pop    %edi
  100f8c:	5d                   	pop    %ebp
  100f8d:	c3                   	ret    

00100f8e <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
  100f8e:	55                   	push   %ebp
  100f8f:	89 e5                	mov    %esp,%ebp
  100f91:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
  100f94:	68 80 3e 00 00       	push   $0x3e80
  100f99:	68 40 4b 13 00       	push   $0x134b40
  100f9e:	68 40 51 12 00       	push   $0x125140
  100fa3:	e8 c9 ff ff ff       	call   100f71 <memcpy>
  100fa8:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
  100fab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fb2:	eb 0f                	jmp    100fc3 <initVCache+0x35>
		VDIRTY[x] = 0;
  100fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fb7:	05 40 45 14 00       	add    $0x144540,%eax
  100fbc:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
  100fbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fc3:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  100fca:	7e e8                	jle    100fb4 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
  100fcc:	c9                   	leave  
  100fcd:	c3                   	ret    

00100fce <refreshVCache>:
void refreshVCache(){
  100fce:	55                   	push   %ebp
  100fcf:	89 e5                	mov    %esp,%ebp
  100fd1:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
  100fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fdb:	eb 0f                	jmp    100fec <refreshVCache+0x1e>
		VDIRTY[x] = 0;
  100fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fe0:	05 40 45 14 00       	add    $0x144540,%eax
  100fe5:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
  100fe8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fec:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  100ff3:	7e e8                	jle    100fdd <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
  100ff5:	c9                   	leave  
  100ff6:	c3                   	ret    

00100ff7 <flushVCache>:
void flushVCache(){
  100ff7:	55                   	push   %ebp
  100ff8:	89 e5                	mov    %esp,%ebp
  100ffa:	53                   	push   %ebx
  100ffb:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
  100ffe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101005:	eb 47                	jmp    10104e <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
  101007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10100a:	05 40 45 14 00       	add    $0x144540,%eax
  10100f:	0f b6 00             	movzbl (%eax),%eax
  101012:	84 c0                	test   %al,%al
  101014:	74 34                	je     10104a <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
  101016:	8b 55 f8             	mov    -0x8(%ebp),%edx
  101019:	89 d0                	mov    %edx,%eax
  10101b:	c1 e0 02             	shl    $0x2,%eax
  10101e:	01 d0                	add    %edx,%eax
  101020:	c1 e0 06             	shl    $0x6,%eax
  101023:	8d 88 40 51 12 00    	lea    0x125140(%eax),%ecx
  101029:	8b 1d a8 20 10 00    	mov    0x1020a8,%ebx
  10102f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  101032:	89 d0                	mov    %edx,%eax
  101034:	c1 e0 02             	shl    $0x2,%eax
  101037:	01 d0                	add    %edx,%eax
  101039:	c1 e0 06             	shl    $0x6,%eax
  10103c:	01 d8                	add    %ebx,%eax
  10103e:	6a 50                	push   $0x50
  101040:	51                   	push   %ecx
  101041:	50                   	push   %eax
  101042:	e8 2a ff ff ff       	call   100f71 <memcpy>
  101047:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
  10104a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  10104e:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
  101055:	7e b0                	jle    101007 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
  101057:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10105a:	c9                   	leave  
  10105b:	c3                   	ret    

0010105c <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
  10105c:	55                   	push   %ebp
  10105d:	89 e5                	mov    %esp,%ebp
  10105f:	83 ec 04             	sub    $0x4,%esp
  101062:	8b 45 10             	mov    0x10(%ebp),%eax
  101065:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
  101068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10106c:	78 18                	js     101086 <setPixelAt+0x2a>
  10106e:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
  101075:	7f 0f                	jg     101086 <setPixelAt+0x2a>
  101077:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10107b:	78 09                	js     101086 <setPixelAt+0x2a>
  10107d:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
  101084:	7e 02                	jle    101088 <setPixelAt+0x2c>
  101086:	eb 34                	jmp    1010bc <setPixelAt+0x60>
	VDIRTY[x] = 1;
  101088:	8b 45 08             	mov    0x8(%ebp),%eax
  10108b:	05 40 45 14 00       	add    $0x144540,%eax
  101090:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
  101093:	8b 45 08             	mov    0x8(%ebp),%eax
  101096:	05 40 46 14 00       	add    $0x144640,%eax
  10109b:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
  10109e:	8b 55 08             	mov    0x8(%ebp),%edx
  1010a1:	89 d0                	mov    %edx,%eax
  1010a3:	c1 e0 02             	shl    $0x2,%eax
  1010a6:	01 d0                	add    %edx,%eax
  1010a8:	c1 e0 06             	shl    $0x6,%eax
  1010ab:	89 c2                	mov    %eax,%edx
  1010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1010b0:	01 c2                	add    %eax,%edx
  1010b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  1010b6:	88 82 40 51 12 00    	mov    %al,0x125140(%edx)
}
  1010bc:	c9                   	leave  
  1010bd:	c3                   	ret    

001010be <forceClearVRAM>:
void forceClearVRAM(){
  1010be:	55                   	push   %ebp
  1010bf:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
  1010c1:	5d                   	pop    %ebp
  1010c2:	c3                   	ret    

001010c3 <clearVRAM>:
void clearVRAM(){
  1010c3:	55                   	push   %ebp
  1010c4:	89 e5                	mov    %esp,%ebp
  1010c6:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
  1010c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d0:	eb 4e                	jmp    101120 <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
  1010d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010d5:	05 40 46 14 00       	add    $0x144640,%eax
  1010da:	0f b6 00             	movzbl (%eax),%eax
  1010dd:	0f b6 c0             	movzbl %al,%eax
  1010e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1010e3:	81 c2 40 45 14 00    	add    $0x144540,%edx
  1010e9:	0f b6 12             	movzbl (%edx),%edx
  1010ec:	0f b6 d2             	movzbl %dl,%edx
  1010ef:	f7 d2                	not    %edx
  1010f1:	21 d0                	and    %edx,%eax
  1010f3:	85 c0                	test   %eax,%eax
  1010f5:	74 25                	je     10111c <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
  1010f7:	8b 0d a8 20 10 00    	mov    0x1020a8,%ecx
  1010fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101100:	89 d0                	mov    %edx,%eax
  101102:	c1 e0 02             	shl    $0x2,%eax
  101105:	01 d0                	add    %edx,%eax
  101107:	c1 e0 06             	shl    $0x6,%eax
  10110a:	01 c8                	add    %ecx,%eax
  10110c:	6a 50                	push   $0x50
  10110e:	68 40 4b 13 00       	push   $0x134b40
  101113:	50                   	push   %eax
  101114:	e8 58 fe ff ff       	call   100f71 <memcpy>
  101119:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
  10111c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101120:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  101127:	7e a9                	jle    1010d2 <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
  101129:	0f b6 05 08 47 14 00 	movzbl 0x144708,%eax
  101130:	83 c0 01             	add    $0x1,%eax
  101133:	a2 08 47 14 00       	mov    %al,0x144708
	if(stamp==30){
  101138:	0f b6 05 08 47 14 00 	movzbl 0x144708,%eax
  10113f:	3c 1e                	cmp    $0x1e,%al
  101141:	75 07                	jne    10114a <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
  101143:	c6 05 08 47 14 00 00 	movb   $0x0,0x144708
		//printk("What matters\n");
	}
	if(stamp==0){
  10114a:	0f b6 05 08 47 14 00 	movzbl 0x144708,%eax
  101151:	84 c0                	test   %al,%al
  101153:	75 14                	jne    101169 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
  101155:	6a 32                	push   $0x32
  101157:	68 40 4b 13 00       	push   $0x134b40
  10115c:	68 40 46 14 00       	push   $0x144640
  101161:	e8 0b fe ff ff       	call   100f71 <memcpy>
  101166:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
  101169:	c9                   	leave  
  10116a:	c3                   	ret    

0010116b <do_timer>:
#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
  10116b:	55                   	push   %ebp
  10116c:	89 e5                	mov    %esp,%ebp
	_tick++;
  10116e:	a1 0c 47 14 00       	mov    0x14470c,%eax
  101173:	83 c0 01             	add    $0x1,%eax
  101176:	a3 0c 47 14 00       	mov    %eax,0x14470c
	//printk("%d", _tick);
}
  10117b:	5d                   	pop    %ebp
  10117c:	c3                   	ret    

0010117d <tick>:
uint32_t tick(){
  10117d:	55                   	push   %ebp
  10117e:	89 e5                	mov    %esp,%ebp
	return _tick;
  101180:	a1 0c 47 14 00       	mov    0x14470c,%eax
  101185:	5d                   	pop    %ebp
  101186:	c3                   	ret    

00101187 <vec0>:
# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
  101187:	6a 00                	push   $0x0
  101189:	6a 00                	push   $0x0
  10118b:	e9 b7 00 00 00       	jmp    101247 <asm_do_irq>

00101190 <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
  101190:	6a 00                	push   $0x0
  101192:	6a 01                	push   $0x1
  101194:	e9 ae 00 00 00       	jmp    101247 <asm_do_irq>

00101199 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
  101199:	6a 00                	push   $0x0
  10119b:	6a 02                	push   $0x2
  10119d:	e9 a5 00 00 00       	jmp    101247 <asm_do_irq>

001011a2 <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
  1011a2:	6a 00                	push   $0x0
  1011a4:	6a 03                	push   $0x3
  1011a6:	e9 9c 00 00 00       	jmp    101247 <asm_do_irq>

001011ab <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
  1011ab:	6a 00                	push   $0x0
  1011ad:	6a 04                	push   $0x4
  1011af:	e9 93 00 00 00       	jmp    101247 <asm_do_irq>

001011b4 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
  1011b4:	6a 00                	push   $0x0
  1011b6:	6a 05                	push   $0x5
  1011b8:	e9 8a 00 00 00       	jmp    101247 <asm_do_irq>

001011bd <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
  1011bd:	6a 00                	push   $0x0
  1011bf:	6a 06                	push   $0x6
  1011c1:	e9 81 00 00 00       	jmp    101247 <asm_do_irq>

001011c6 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
  1011c6:	6a 00                	push   $0x0
  1011c8:	6a 07                	push   $0x7
  1011ca:	e9 78 00 00 00       	jmp    101247 <asm_do_irq>

001011cf <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
  1011cf:	6a 00                	push   $0x0
  1011d1:	6a 08                	push   $0x8
  1011d3:	e9 6f 00 00 00       	jmp    101247 <asm_do_irq>

001011d8 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
  1011d8:	6a 00                	push   $0x0
  1011da:	6a 09                	push   $0x9
  1011dc:	e9 66 00 00 00       	jmp    101247 <asm_do_irq>

001011e1 <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
  1011e1:	6a 00                	push   $0x0
  1011e3:	6a 0a                	push   $0xa
  1011e5:	e9 5d 00 00 00       	jmp    101247 <asm_do_irq>

001011ea <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
  1011ea:	6a 00                	push   $0x0
  1011ec:	6a 0b                	push   $0xb
  1011ee:	e9 54 00 00 00       	jmp    101247 <asm_do_irq>

001011f3 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
  1011f3:	6a 00                	push   $0x0
  1011f5:	6a 0c                	push   $0xc
  1011f7:	e9 4b 00 00 00       	jmp    101247 <asm_do_irq>

001011fc <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
  1011fc:	6a 00                	push   $0x0
  1011fe:	6a 0d                	push   $0xd
  101200:	e9 42 00 00 00       	jmp    101247 <asm_do_irq>

00101205 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
  101205:	6a 00                	push   $0x0
  101207:	6a 0e                	push   $0xe
  101209:	e9 39 00 00 00       	jmp    101247 <asm_do_irq>

0010120e <vecsys>:

.globl vecsys; vecsys:  pushl $0;  pushl $0x80; jmp asm_do_irq
  10120e:	6a 00                	push   $0x0
  101210:	68 80 00 00 00       	push   $0x80
  101215:	e9 2d 00 00 00       	jmp    101247 <asm_do_irq>

0010121a <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
  10121a:	6a 00                	push   $0x0
  10121c:	68 e8 03 00 00       	push   $0x3e8
  101221:	e9 21 00 00 00       	jmp    101247 <asm_do_irq>

00101226 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
  101226:	6a 00                	push   $0x0
  101228:	68 e9 03 00 00       	push   $0x3e9
  10122d:	e9 15 00 00 00       	jmp    101247 <asm_do_irq>

00101232 <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
  101232:	6a 00                	push   $0x0
  101234:	68 f6 03 00 00       	push   $0x3f6
  101239:	e9 09 00 00 00       	jmp    101247 <asm_do_irq>

0010123e <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
  10123e:	6a 00                	push   $0x0
  101240:	6a ff                	push   $0xffffffff
  101242:	e9 00 00 00 00       	jmp    101247 <asm_do_irq>

00101247 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle


asm_do_irq:
	cli
  101247:	fa                   	cli    
	pushal
  101248:	60                   	pusha  
	
	pushl %esp			# ???
  101249:	54                   	push   %esp
	call irq_handle
  10124a:	e8 67 f2 ff ff       	call   1004b6 <irq_handle>
	addl $4, %esp
  10124f:	83 c4 04             	add    $0x4,%esp

	popal
  101252:	61                   	popa   
	addl $8, %esp
  101253:	83 c4 08             	add    $0x8,%esp
	sti
  101256:	fb                   	sti    
	iret
  101257:	cf                   	iret   

00101258 <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
  101258:	55                   	push   %ebp
  101259:	89 e5                	mov    %esp,%ebp
  10125b:	53                   	push   %ebx
  10125c:	83 ec 04             	sub    $0x4,%esp
  10125f:	8b 45 08             	mov    0x8(%ebp),%eax
  101262:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
  101265:	b8 e8 03 00 00       	mov    $0x3e8,%eax
  10126a:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
  10126e:	89 d3                	mov    %edx,%ebx
  101270:	cd 80                	int    $0x80
}
  101272:	83 c4 04             	add    $0x4,%esp
  101275:	5b                   	pop    %ebx
  101276:	5d                   	pop    %ebp
  101277:	c3                   	ret    

00101278 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
  101278:	55                   	push   %ebp
  101279:	89 e5                	mov    %esp,%ebp
  10127b:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
  10127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  101281:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
  101284:	eb 19                	jmp    10129f <printp+0x27>
		printer(cur);
  101286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101289:	0f b6 00             	movzbl (%eax),%eax
  10128c:	0f be c0             	movsbl %al,%eax
  10128f:	83 ec 0c             	sub    $0xc,%esp
  101292:	50                   	push   %eax
  101293:	8b 45 08             	mov    0x8(%ebp),%eax
  101296:	ff d0                	call   *%eax
  101298:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
  10129b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10129f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012a2:	0f b6 00             	movzbl (%eax),%eax
  1012a5:	84 c0                	test   %al,%al
  1012a7:	75 dd                	jne    101286 <printp+0xe>
		printer(cur);
	}
}
  1012a9:	c9                   	leave  
  1012aa:	c3                   	ret    

001012ab <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
  1012ab:	55                   	push   %ebp
  1012ac:	89 e5                	mov    %esp,%ebp
  1012ae:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
  1012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1012b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
  1012ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
  1012c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
  1012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1012cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
  1012ce:	e9 71 02 00 00       	jmp    101544 <vfprintf+0x299>
		if(cur == '%'){
  1012d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012d6:	0f b6 00             	movzbl (%eax),%eax
  1012d9:	3c 25                	cmp    $0x25,%al
  1012db:	75 0c                	jne    1012e9 <vfprintf+0x3e>
			type = READ;
  1012dd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
  1012e4:	e9 57 02 00 00       	jmp    101540 <vfprintf+0x295>
		}
		if(type == READ){
  1012e9:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  1012ed:	0f 85 32 02 00 00    	jne    101525 <vfprintf+0x27a>
			if(cur == 's'){
  1012f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012f6:	0f b6 00             	movzbl (%eax),%eax
  1012f9:	3c 73                	cmp    $0x73,%al
  1012fb:	75 35                	jne    101332 <vfprintf+0x87>
				char* p= XGET(pointer, char*);
  1012fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101300:	8b 00                	mov    (%eax),%eax
  101302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
  101305:	eb 19                	jmp    101320 <vfprintf+0x75>
					printer(*p);
  101307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10130a:	0f b6 00             	movzbl (%eax),%eax
  10130d:	0f be c0             	movsbl %al,%eax
  101310:	83 ec 0c             	sub    $0xc,%esp
  101313:	50                   	push   %eax
  101314:	8b 45 08             	mov    0x8(%ebp),%eax
  101317:	ff d0                	call   *%eax
  101319:	83 c4 10             	add    $0x10,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  10131c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  101320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101323:	0f b6 00             	movzbl (%eax),%eax
  101326:	84 c0                	test   %al,%al
  101328:	75 dd                	jne    101307 <vfprintf+0x5c>
					printer(*p);
				}
				XNEXT(pointer);
  10132a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  10132e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
  101332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101335:	0f b6 00             	movzbl (%eax),%eax
  101338:	3c 78                	cmp    $0x78,%al
  10133a:	0f 85 9f 00 00 00    	jne    1013df <vfprintf+0x134>
				uint32_t x = XGET(pointer, int);
  101340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101343:	8b 00                	mov    (%eax),%eax
  101345:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
  101348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10134c:	75 1d                	jne    10136b <vfprintf+0xc0>
					printer('0');
  10134e:	83 ec 0c             	sub    $0xc,%esp
  101351:	6a 30                	push   $0x30
  101353:	8b 45 08             	mov    0x8(%ebp),%eax
  101356:	ff d0                	call   *%eax
  101358:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  10135b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  10135f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101366:	e9 d5 01 00 00       	jmp    101540 <vfprintf+0x295>
					continue;
				}
				char digits[100];
				int di=0;
  10136b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
  101372:	eb 30                	jmp    1013a4 <vfprintf+0xf9>
					int d=(x%16);
  101374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101377:	83 e0 0f             	and    $0xf,%eax
  10137a:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
  10137d:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  101381:	7e 04                	jle    101387 <vfprintf+0xdc>
						d+='a'-'0'-10;
  101383:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
  101387:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10138a:	83 c0 30             	add    $0x30,%eax
  10138d:	89 c1                	mov    %eax,%ecx
  10138f:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  101395:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101398:	01 d0                	add    %edx,%eax
  10139a:	88 08                	mov    %cl,(%eax)
					x>>=4;
  10139c:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
  1013a0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  1013a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1013a8:	75 ca                	jne    101374 <vfprintf+0xc9>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
  1013aa:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
  1013ae:	eb 21                	jmp    1013d1 <vfprintf+0x126>
					printer(digits[di]);
  1013b0:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1013b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1013b9:	01 d0                	add    %edx,%eax
  1013bb:	0f b6 00             	movzbl (%eax),%eax
  1013be:	0f be c0             	movsbl %al,%eax
  1013c1:	83 ec 0c             	sub    $0xc,%esp
  1013c4:	50                   	push   %eax
  1013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c8:	ff d0                	call   *%eax
  1013ca:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  1013cd:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  1013d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1013d5:	79 d9                	jns    1013b0 <vfprintf+0x105>
					printer(digits[di]);
				}
				XNEXT(pointer);
  1013d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  1013db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
  1013df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1013e2:	0f b6 00             	movzbl (%eax),%eax
  1013e5:	3c 64                	cmp    $0x64,%al
  1013e7:	0f 85 08 01 00 00    	jne    1014f5 <vfprintf+0x24a>
				int x = XGET(pointer, int);
  1013ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1013f0:	8b 00                	mov    (%eax),%eax
  1013f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
  1013f5:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
  1013fc:	75 23                	jne    101421 <vfprintf+0x176>
					printp(printer, "-2147483648");
  1013fe:	83 ec 08             	sub    $0x8,%esp
  101401:	68 9e 15 10 00       	push   $0x10159e
  101406:	ff 75 08             	pushl  0x8(%ebp)
  101409:	e8 6a fe ff ff       	call   101278 <printp>
  10140e:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  101411:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  101415:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  10141c:	e9 1f 01 00 00       	jmp    101540 <vfprintf+0x295>
				}
				if(x==0){
  101421:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  101425:	75 1e                	jne    101445 <vfprintf+0x19a>
					printer('0');
  101427:	83 ec 0c             	sub    $0xc,%esp
  10142a:	6a 30                	push   $0x30
  10142c:	8b 45 08             	mov    0x8(%ebp),%eax
  10142f:	ff d0                	call   *%eax
  101431:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  101434:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  101438:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  10143f:	90                   	nop
  101440:	e9 fb 00 00 00       	jmp    101540 <vfprintf+0x295>
				}
				if(x<0){
  101445:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  101449:	79 10                	jns    10145b <vfprintf+0x1b0>
					printer('-');
  10144b:	83 ec 0c             	sub    $0xc,%esp
  10144e:	6a 2d                	push   $0x2d
  101450:	8b 45 08             	mov    0x8(%ebp),%eax
  101453:	ff d0                	call   *%eax
  101455:	83 c4 10             	add    $0x10,%esp
					x=-x;
  101458:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
  10145b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
  101462:	eb 56                	jmp    1014ba <vfprintf+0x20f>
					digits[di] = '0'+(x%10);
  101464:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  101467:	ba 67 66 66 66       	mov    $0x66666667,%edx
  10146c:	89 c8                	mov    %ecx,%eax
  10146e:	f7 ea                	imul   %edx
  101470:	c1 fa 02             	sar    $0x2,%edx
  101473:	89 c8                	mov    %ecx,%eax
  101475:	c1 f8 1f             	sar    $0x1f,%eax
  101478:	29 c2                	sub    %eax,%edx
  10147a:	89 d0                	mov    %edx,%eax
  10147c:	c1 e0 02             	shl    $0x2,%eax
  10147f:	01 d0                	add    %edx,%eax
  101481:	01 c0                	add    %eax,%eax
  101483:	29 c1                	sub    %eax,%ecx
  101485:	89 ca                	mov    %ecx,%edx
  101487:	89 d0                	mov    %edx,%eax
  101489:	83 c0 30             	add    $0x30,%eax
  10148c:	89 c1                	mov    %eax,%ecx
  10148e:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  101494:	8b 45 d0             	mov    -0x30(%ebp),%eax
  101497:	01 d0                	add    %edx,%eax
  101499:	88 08                	mov    %cl,(%eax)
					x/=10;
  10149b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10149e:	ba 67 66 66 66       	mov    $0x66666667,%edx
  1014a3:	89 c8                	mov    %ecx,%eax
  1014a5:	f7 ea                	imul   %edx
  1014a7:	c1 fa 02             	sar    $0x2,%edx
  1014aa:	89 c8                	mov    %ecx,%eax
  1014ac:	c1 f8 1f             	sar    $0x1f,%eax
  1014af:	29 c2                	sub    %eax,%edx
  1014b1:	89 d0                	mov    %edx,%eax
  1014b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
  1014b6:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  1014ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1014be:	7f a4                	jg     101464 <vfprintf+0x1b9>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
  1014c0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
  1014c4:	eb 21                	jmp    1014e7 <vfprintf+0x23c>
					printer(digits[di]);
  1014c6:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1014cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1014cf:	01 d0                	add    %edx,%eax
  1014d1:	0f b6 00             	movzbl (%eax),%eax
  1014d4:	0f be c0             	movsbl %al,%eax
  1014d7:	83 ec 0c             	sub    $0xc,%esp
  1014da:	50                   	push   %eax
  1014db:	8b 45 08             	mov    0x8(%ebp),%eax
  1014de:	ff d0                	call   *%eax
  1014e0:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  1014e3:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  1014e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  1014eb:	79 d9                	jns    1014c6 <vfprintf+0x21b>
					printer(digits[di]);
				}
				XNEXT(pointer);
  1014ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  1014f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
  1014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1014f8:	0f b6 00             	movzbl (%eax),%eax
  1014fb:	3c 63                	cmp    $0x63,%al
  1014fd:	75 1d                	jne    10151c <vfprintf+0x271>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
  1014ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101502:	0f b6 00             	movzbl (%eax),%eax
  101505:	0f be c0             	movsbl %al,%eax
  101508:	83 ec 0c             	sub    $0xc,%esp
  10150b:	50                   	push   %eax
  10150c:	8b 45 08             	mov    0x8(%ebp),%eax
  10150f:	ff d0                	call   *%eax
  101511:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
  101514:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  101518:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
  10151c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
  101523:	eb 1b                	jmp    101540 <vfprintf+0x295>
		}
		if(type == NONE){
  101525:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  101529:	75 15                	jne    101540 <vfprintf+0x295>
			printer(cur);
  10152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10152e:	0f b6 00             	movzbl (%eax),%eax
  101531:	0f be c0             	movsbl %al,%eax
  101534:	83 ec 0c             	sub    $0xc,%esp
  101537:	50                   	push   %eax
  101538:	8b 45 08             	mov    0x8(%ebp),%eax
  10153b:	ff d0                	call   *%eax
  10153d:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  101540:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101547:	0f b6 00             	movzbl (%eax),%eax
  10154a:	84 c0                	test   %al,%al
  10154c:	0f 85 81 fd ff ff    	jne    1012d3 <vfprintf+0x28>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
  101552:	c9                   	leave  
  101553:	c3                   	ret    

00101554 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
  101554:	55                   	push   %ebp
  101555:	89 e5                	mov    %esp,%ebp
  101557:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
  10155a:	8d 45 0c             	lea    0xc(%ebp),%eax
  10155d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(sys_printch, ctl, args);
  101560:	8b 45 08             	mov    0x8(%ebp),%eax
  101563:	83 ec 04             	sub    $0x4,%esp
  101566:	ff 75 f4             	pushl  -0xc(%ebp)
  101569:	50                   	push   %eax
  10156a:	68 58 12 10 00       	push   $0x101258
  10156f:	e8 37 fd ff ff       	call   1012ab <vfprintf>
  101574:	83 c4 10             	add    $0x10,%esp
}
  101577:	c9                   	leave  
  101578:	c3                   	ret    
