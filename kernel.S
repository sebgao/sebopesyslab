
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

00100011 <write_cr3>:
	asm volatile("movl %0, %%cr0" : : "r"(cr0->val));
}

/* write CR3, notice that CR3 are never read in Nanos */
static inline void
write_cr3(CR3 *cr3) {
  100011:	55                   	push   %ebp
  100012:	89 e5                	mov    %esp,%ebp
	asm volatile("movl %0, %%cr3" : : "r"(cr3->val));
  100014:	8b 45 08             	mov    0x8(%ebp),%eax
  100017:	8b 00                	mov    (%eax),%eax
  100019:	0f 22 d8             	mov    %eax,%cr3
}
  10001c:	5d                   	pop    %ebp
  10001d:	c3                   	ret    

0010001e <write_gdtr>:

/* modify the value of GDTR */
static inline void
write_gdtr(void *addr, uint32_t size) {
  10001e:	55                   	push   %ebp
  10001f:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
  100021:	8b 45 0c             	mov    0xc(%ebp),%eax
  100024:	83 e8 01             	sub    $0x1,%eax
  100027:	66 a3 b0 60 12 00    	mov    %ax,0x1260b0
	data[1] = (uint32_t)addr;
  10002d:	8b 45 08             	mov    0x8(%ebp),%eax
  100030:	66 a3 b2 60 12 00    	mov    %ax,0x1260b2
	data[2] = ((uint32_t)addr) >> 16;
  100036:	8b 45 08             	mov    0x8(%ebp),%eax
  100039:	c1 e8 10             	shr    $0x10,%eax
  10003c:	66 a3 b4 60 12 00    	mov    %ax,0x1260b4
	asm volatile("lgdt (%0)" : : "r"(data));
  100042:	b8 b0 60 12 00       	mov    $0x1260b0,%eax
  100047:	0f 01 10             	lgdtl  (%eax)
}
  10004a:	5d                   	pop    %ebp
  10004b:	c3                   	ret    

0010004c <write_tr>:
	asm volatile("lidt (%0)" : : "r"(data));
}

/* write TR */
static inline void
write_tr(uint16_t selector) {
  10004c:	55                   	push   %ebp
  10004d:	89 e5                	mov    %esp,%ebp
  10004f:	83 ec 04             	sub    $0x4,%esp
  100052:	8b 45 08             	mov    0x8(%ebp),%eax
  100055:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	asm volatile("ltr %0" : : "r"(selector));
  100059:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  10005d:	0f 00 d8             	ltr    %ax
}
  100060:	c9                   	leave  
  100061:	c3                   	ret    

00100062 <memset>:

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
  100062:	55                   	push   %ebp
  100063:	89 e5                	mov    %esp,%ebp
  100065:	57                   	push   %edi
  100066:	53                   	push   %ebx
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
  100067:	8b 55 10             	mov    0x10(%ebp),%edx
  10006a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10006d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100070:	89 d1                	mov    %edx,%ecx
  100072:	89 df                	mov    %ebx,%edi
  100074:	fc                   	cld    
  100075:	f3 ab                	rep stos %eax,%es:(%edi)
}
  100077:	5b                   	pop    %ebx
  100078:	5f                   	pop    %edi
  100079:	5d                   	pop    %ebp
  10007a:	c3                   	ret    

0010007b <get_kcr3>:
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
  10007b:	55                   	push   %ebp
  10007c:	89 e5                	mov    %esp,%ebp
	return &kcr3;
  10007e:	b8 00 40 10 00       	mov    $0x104000,%eax
}
  100083:	5d                   	pop    %ebp
  100084:	c3                   	ret    

00100085 <get_kpdir>:

PDE* get_kpdir() {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
	return kpdir;
  100088:	b8 00 50 10 00       	mov    $0x105000,%eax
}
  10008d:	5d                   	pop    %ebp
  10008e:	c3                   	ret    

0010008f <get_kptable>:

PTE* get_kptable() {
  10008f:	55                   	push   %ebp
  100090:	89 e5                	mov    %esp,%ebp
	return kptable;
  100092:	b8 00 60 10 00       	mov    $0x106000,%eax
}
  100097:	5d                   	pop    %ebp
  100098:	c3                   	ret    

00100099 <init_page>:

/* Build a page table for the kernel */
void
init_page(void) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	83 ec 28             	sub    $0x28,%esp
	CR0 cr0;
	CR3 cr3;
	PDE *pdir = (PDE *)va_to_pa(kpdir);
  10009f:	b8 00 50 10 00       	mov    $0x105000,%eax
  1000a4:	05 00 00 00 40       	add    $0x40000000,%eax
  1000a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	PTE *ptable = (PTE *)va_to_pa(kptable);
  1000ac:	b8 00 60 10 00       	mov    $0x106000,%eax
  1000b1:	05 00 00 00 40       	add    $0x40000000,%eax
  1000b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t pdir_idx, ptable_idx, pframe_idx;


	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
  1000b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1000c0:	eb 1f                	jmp    1000e1 <init_page+0x48>
		make_invalid_pde(&pdir[pdir_idx]);
  1000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1000c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1000cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1000cf:	01 d0                	add    %edx,%eax
  1000d1:	83 ec 0c             	sub    $0xc,%esp
  1000d4:	50                   	push   %eax
  1000d5:	e8 4b 03 00 00       	call   100425 <make_invalid_pde>
  1000da:	83 c4 10             	add    $0x10,%esp
	PDE *pdir = (PDE *)va_to_pa(kpdir);
	PTE *ptable = (PTE *)va_to_pa(kptable);
	uint32_t pdir_idx, ptable_idx, pframe_idx;


	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
  1000dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1000e1:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
  1000e8:	76 d8                	jbe    1000c2 <init_page+0x29>
		make_invalid_pde(&pdir[pdir_idx]);
	}

	pframe_idx = 0;
  1000ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
  1000f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1000f8:	eb 78                	jmp    100172 <init_page+0xd9>
		make_pde(&pdir[pdir_idx], ptable);
  1000fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1000fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100107:	01 d0                	add    %edx,%eax
  100109:	83 ec 08             	sub    $0x8,%esp
  10010c:	ff 75 f4             	pushl  -0xc(%ebp)
  10010f:	50                   	push   %eax
  100110:	e8 2c 03 00 00       	call   100441 <make_pde>
  100115:	83 c4 10             	add    $0x10,%esp
		make_pde(&pdir[pdir_idx + KOFFSET / PD_SIZE], ptable);
  100118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10011b:	05 00 03 00 00       	add    $0x300,%eax
  100120:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10012a:	01 d0                	add    %edx,%eax
  10012c:	83 ec 08             	sub    $0x8,%esp
  10012f:	ff 75 f4             	pushl  -0xc(%ebp)
  100132:	50                   	push   %eax
  100133:	e8 09 03 00 00       	call   100441 <make_pde>
  100138:	83 c4 10             	add    $0x10,%esp
		for (ptable_idx = 0; ptable_idx < NR_PTE; ptable_idx ++) {
  10013b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100142:	eb 21                	jmp    100165 <init_page+0xcc>
			make_pte(ptable, (void*)(pframe_idx << 12));
  100144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100147:	c1 e0 0c             	shl    $0xc,%eax
  10014a:	83 ec 08             	sub    $0x8,%esp
  10014d:	50                   	push   %eax
  10014e:	ff 75 f4             	pushl  -0xc(%ebp)
  100151:	e8 3b 03 00 00       	call   100491 <make_pte>
  100156:	83 c4 10             	add    $0x10,%esp
			pframe_idx ++;
  100159:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			ptable ++;
  10015d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)

	pframe_idx = 0;
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
		make_pde(&pdir[pdir_idx], ptable);
		make_pde(&pdir[pdir_idx + KOFFSET / PD_SIZE], ptable);
		for (ptable_idx = 0; ptable_idx < NR_PTE; ptable_idx ++) {
  100161:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100165:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  10016c:	76 d6                	jbe    100144 <init_page+0xab>
	for (pdir_idx = 0; pdir_idx < NR_PDE; pdir_idx ++) {
		make_invalid_pde(&pdir[pdir_idx]);
	}

	pframe_idx = 0;
	for (pdir_idx = 0; pdir_idx < PHY_MEM / PD_SIZE; pdir_idx ++) {
  10016e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  100172:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100176:	76 82                	jbe    1000fa <init_page+0x61>
			ptable ++;
		}
	}

	/* make CR3 to be the entry of page directory */
	cr3.val = 0;
  100178:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	cr3.page_directory_base = ((uint32_t)pdir) >> 12;
  10017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100182:	c1 e8 0c             	shr    $0xc,%eax
  100185:	25 ff ff 0f 00       	and    $0xfffff,%eax
  10018a:	c1 e0 0c             	shl    $0xc,%eax
  10018d:	89 c2                	mov    %eax,%edx
  10018f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100192:	25 ff 0f 00 00       	and    $0xfff,%eax
  100197:	09 d0                	or     %edx,%eax
  100199:	89 45 dc             	mov    %eax,-0x24(%ebp)
	write_cr3(&cr3);
  10019c:	83 ec 0c             	sub    $0xc,%esp
  10019f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1001a2:	50                   	push   %eax
  1001a3:	e8 69 fe ff ff       	call   100011 <write_cr3>
  1001a8:	83 c4 10             	add    $0x10,%esp

	/* set PG bit in CR0 to enable paging */
	cr0.val = read_cr0();
  1001ab:	e8 50 fe ff ff       	call   100000 <read_cr0>
  1001b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cr0.paging = 1;
  1001b3:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1001b7:	83 c8 80             	or     $0xffffff80,%eax
  1001ba:	88 45 e3             	mov    %al,-0x1d(%ebp)
	
	//write_cr0(&cr0);
	asm volatile("movl %0, %%cr0" : : "r"(cr0.val));
  1001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1001c0:	0f 22 c0             	mov    %eax,%cr0
	/* Now we can access global variables! 
	 * Store CR3 in the global variable for future use. */
	kcr3.val = cr3.val;
  1001c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1001c6:	a3 00 40 10 00       	mov    %eax,0x104000
}
  1001cb:	c9                   	leave  
  1001cc:	c3                   	ret    

001001cd <set_tss>:

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
  1001cd:	55                   	push   %ebp
  1001ce:	89 e5                	mov    %esp,%ebp
  1001d0:	83 ec 10             	sub    $0x10,%esp
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
  1001d3:	c7 05 08 60 12 00 10 	movl   $0x10,0x126008
  1001da:	00 00 00 

	uint32_t base = (uint32_t)&tss;
  1001dd:	c7 45 fc 00 60 12 00 	movl   $0x126000,-0x4(%ebp)
	uint32_t limit = sizeof(TSS) - 1;
  1001e4:	c7 45 f8 63 00 00 00 	movl   $0x63,-0x8(%ebp)
	ptr->limit_15_0  = limit & 0xffff;
  1001eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1001ee:	89 c2                	mov    %eax,%edx
  1001f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1001f3:	66 89 10             	mov    %dx,(%eax)
	ptr->base_15_0   = base & 0xffff;
  1001f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1001f9:	89 c2                	mov    %eax,%edx
  1001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1001fe:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->base_23_16  = (base >> 16) & 0xff;
  100202:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100205:	c1 e8 10             	shr    $0x10,%eax
  100208:	89 c2                	mov    %eax,%edx
  10020a:	8b 45 08             	mov    0x8(%ebp),%eax
  10020d:	88 50 04             	mov    %dl,0x4(%eax)
	ptr->type = SEG_TSS_32BIT;
  100210:	8b 45 08             	mov    0x8(%ebp),%eax
  100213:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100217:	83 e2 f0             	and    $0xfffffff0,%edx
  10021a:	83 ca 09             	or     $0x9,%edx
  10021d:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 0;
  100220:	8b 45 08             	mov    0x8(%ebp),%eax
  100223:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100227:	83 e2 ef             	and    $0xffffffef,%edx
  10022a:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = DPL_USER;
  10022d:	8b 45 08             	mov    0x8(%ebp),%eax
  100230:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100234:	83 ca 60             	or     $0x60,%edx
  100237:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  10023a:	8b 45 08             	mov    0x8(%ebp),%eax
  10023d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100241:	83 ca 80             	or     $0xffffff80,%edx
  100244:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = limit >> 16;
  100247:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10024a:	c1 e8 10             	shr    $0x10,%eax
  10024d:	83 e0 0f             	and    $0xf,%eax
  100250:	89 c2                	mov    %eax,%edx
  100252:	8b 45 08             	mov    0x8(%ebp),%eax
  100255:	89 d1                	mov    %edx,%ecx
  100257:	83 e1 0f             	and    $0xf,%ecx
  10025a:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10025e:	83 e2 f0             	and    $0xfffffff0,%edx
  100261:	09 ca                	or     %ecx,%edx
  100263:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
  100266:	8b 45 08             	mov    0x8(%ebp),%eax
  100269:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10026d:	83 e2 ef             	and    $0xffffffef,%edx
  100270:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10027a:	83 e2 df             	and    $0xffffffdf,%edx
  10027d:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
  100280:	8b 45 08             	mov    0x8(%ebp),%eax
  100283:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100287:	83 ca 40             	or     $0x40,%edx
  10028a:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 0;
  10028d:	8b 45 08             	mov    0x8(%ebp),%eax
  100290:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100294:	83 e2 7f             	and    $0x7f,%edx
  100297:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = base >> 24;
  10029a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10029d:	c1 e8 18             	shr    $0x18,%eax
  1002a0:	89 c2                	mov    %eax,%edx
  1002a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a5:	88 50 07             	mov    %dl,0x7(%eax)
}
  1002a8:	c9                   	leave  
  1002a9:	c3                   	ret    

001002aa <set_segment>:

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
  1002aa:	55                   	push   %ebp
  1002ab:	89 e5                	mov    %esp,%ebp
	ptr->limit_15_0  = 0xFFFF;
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	66 c7 00 ff ff       	movw   $0xffff,(%eax)
	ptr->base_15_0   = 0x0;
  1002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b8:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
	ptr->base_23_16  = 0x0;
  1002be:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c1:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = type;
  1002c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1002c8:	83 e0 0f             	and    $0xf,%eax
  1002cb:	89 c2                	mov    %eax,%edx
  1002cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d0:	89 d1                	mov    %edx,%ecx
  1002d2:	83 e1 0f             	and    $0xf,%ecx
  1002d5:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1002d9:	83 e2 f0             	and    $0xfffffff0,%edx
  1002dc:	09 ca                	or     %ecx,%edx
  1002de:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->segment_type = 1;
  1002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e4:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1002e8:	83 ca 10             	or     $0x10,%edx
  1002eb:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = pl;
  1002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f1:	83 e0 03             	and    $0x3,%eax
  1002f4:	89 c2                	mov    %eax,%edx
  1002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f9:	83 e2 03             	and    $0x3,%edx
  1002fc:	89 d1                	mov    %edx,%ecx
  1002fe:	c1 e1 05             	shl    $0x5,%ecx
  100301:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100305:	83 e2 9f             	and    $0xffffff9f,%edx
  100308:	09 ca                	or     %ecx,%edx
  10030a:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  10030d:	8b 45 08             	mov    0x8(%ebp),%eax
  100310:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100314:	83 ca 80             	or     $0xffffff80,%edx
  100317:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->limit_19_16 = 0xF;
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100321:	83 ca 0f             	or     $0xf,%edx
  100324:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->soft_use = 0;
  100327:	8b 45 08             	mov    0x8(%ebp),%eax
  10032a:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10032e:	83 e2 ef             	and    $0xffffffef,%edx
  100331:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->operation_size = 0;
  100334:	8b 45 08             	mov    0x8(%ebp),%eax
  100337:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  10033b:	83 e2 df             	and    $0xffffffdf,%edx
  10033e:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->pad0 = 1;
  100341:	8b 45 08             	mov    0x8(%ebp),%eax
  100344:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100348:	83 ca 40             	or     $0x40,%edx
  10034b:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->granularity = 1;
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	0f b6 50 06          	movzbl 0x6(%eax),%edx
  100355:	83 ca 80             	or     $0xffffff80,%edx
  100358:	88 50 06             	mov    %dl,0x6(%eax)
	ptr->base_31_24  = 0x0;
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	c6 40 07 00          	movb   $0x0,0x7(%eax)
}
  100362:	5d                   	pop    %ebp
  100363:	c3                   	ret    

00100364 <init_segment>:
/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
  100364:	55                   	push   %ebp
  100365:	89 e5                	mov    %esp,%ebp
	memset(gdt, 0, sizeof(gdt));
  100367:	6a 30                	push   $0x30
  100369:	6a 00                	push   $0x0
  10036b:	68 80 60 12 00       	push   $0x126080
  100370:	e8 ed fc ff ff       	call   100062 <memset>
  100375:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
  100378:	6a 0a                	push   $0xa
  10037a:	6a 00                	push   $0x0
  10037c:	68 88 60 12 00       	push   $0x126088
  100381:	e8 24 ff ff ff       	call   1002aa <set_segment>
  100386:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
  100389:	6a 02                	push   $0x2
  10038b:	6a 00                	push   $0x0
  10038d:	68 90 60 12 00       	push   $0x126090
  100392:	e8 13 ff ff ff       	call   1002aa <set_segment>
  100397:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
  10039a:	6a 0a                	push   $0xa
  10039c:	6a 03                	push   $0x3
  10039e:	68 98 60 12 00       	push   $0x126098
  1003a3:	e8 02 ff ff ff       	call   1002aa <set_segment>
  1003a8:	83 c4 0c             	add    $0xc,%esp
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );
  1003ab:	6a 02                	push   $0x2
  1003ad:	6a 03                	push   $0x3
  1003af:	68 a0 60 12 00       	push   $0x1260a0
  1003b4:	e8 f1 fe ff ff       	call   1002aa <set_segment>
  1003b9:	83 c4 0c             	add    $0xc,%esp


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));
  1003bc:	6a 30                	push   $0x30
  1003be:	68 80 60 12 00       	push   $0x126080
  1003c3:	e8 56 fc ff ff       	call   10001e <write_gdtr>
  1003c8:	83 c4 08             	add    $0x8,%esp

	set_tss(&gdt[SEG_TSS]);
  1003cb:	68 a8 60 12 00       	push   $0x1260a8
  1003d0:	e8 f8 fd ff ff       	call   1001cd <set_tss>
  1003d5:	83 c4 04             	add    $0x4,%esp
	write_tr( SELECTOR_USER(SEG_TSS) );
  1003d8:	6a 2b                	push   $0x2b
  1003da:	e8 6d fc ff ff       	call   10004c <write_tr>
  1003df:	83 c4 04             	add    $0x4,%esp
}
  1003e2:	c9                   	leave  
  1003e3:	c3                   	ret    

001003e4 <switch_process>:

void switch_process(PCB *p)
{
  1003e4:	55                   	push   %ebp
  1003e5:	89 e5                	mov    %esp,%ebp
  1003e7:	83 ec 10             	sub    $0x10,%esp
	//lcr3(PADDR(p->pgdir));
	//tss.esp0 = (uint32_t)KSTACK_TOP(p->kstack) - 8;

	tss.esp0 = KSTACKTOP;
  1003ea:	c7 05 04 60 12 00 00 	movl   $0x200000,0x126004
  1003f1:	00 20 00 

	struct TrapFrame *tf = p->tf;
  1003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1003f7:	8b 40 04             	mov    0x4(%eax),%eax
  1003fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	asm volatile("mov %0, %%esp; \
  1003fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100400:	89 c4                	mov    %eax,%esp
  100402:	83 c4 04             	add    $0x4,%esp
  100405:	61                   	popa   
  100406:	83 c4 08             	add    $0x8,%esp
	asm volatile("pushl %0" : : "r"(p->tf.eip));
	*/
	//uint32_t esp;
	//asm volatile("mov %%esp, %0" : "=a"(esp));
	//printk("%x", esp);
	asm volatile("iret");
  100409:	cf                   	iret   
}
  10040a:	c9                   	leave  
  10040b:	c3                   	ret    

0010040c <enter_user_space>:
void enter_user_space(struct TrapFrame *tf)
{
  10040c:	55                   	push   %ebp
  10040d:	89 e5                	mov    %esp,%ebp

	tss.esp0 = KSTACKTOP;
  10040f:	c7 05 04 60 12 00 00 	movl   $0x200000,0x126004
  100416:	00 20 00 

	//struct TrapFrame *tf = p->tf;

	asm volatile("mov %0, %%esp; \
  100419:	8b 45 08             	mov    0x8(%ebp),%eax
  10041c:	89 c4                	mov    %eax,%esp
  10041e:	61                   	popa   
  10041f:	83 c4 08             	add    $0x8,%esp
	asm volatile("pushl %0" : : "r"(p->tf.esp));
	asm volatile("pushl %0" : : "r"(p->tf.eflags));
	asm volatile("pushl %0" : : "r"((uint32_t)p->tf.cs));
	asm volatile("pushl %0" : : "r"(p->tf.eip));
	*/
	asm volatile("iret");
  100422:	cf                   	iret   
}
  100423:	5d                   	pop    %ebp
  100424:	c3                   	ret    

00100425 <make_invalid_pde>:
#include "inc/memory.h"
#include "common.h"
void
make_invalid_pde(PDE *p) {
  100425:	55                   	push   %ebp
  100426:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100428:	8b 45 08             	mov    0x8(%ebp),%eax
  10042b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
  100431:	5d                   	pop    %ebp
  100432:	c3                   	ret    

00100433 <make_invalid_pte>:
void
make_invalid_pte(PTE *p) {
  100433:	55                   	push   %ebp
  100434:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100436:	8b 45 08             	mov    0x8(%ebp),%eax
  100439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
  10043f:	5d                   	pop    %ebp
  100440:	c3                   	ret    

00100441 <make_pde>:
/* For simplicity, we make all pages readable and writable for all ring 3 processes.
 * In Lab3, you may set different flags for different pages to perform the whole 
 * page level protection. */

void
make_pde(PDE *p, void *addr) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	c1 e8 0c             	shr    $0xc,%eax
  100453:	25 ff ff 0f 00       	and    $0xfffff,%eax
  100458:	89 c2                	mov    %eax,%edx
  10045a:	8b 45 08             	mov    0x8(%ebp),%eax
  10045d:	89 d1                	mov    %edx,%ecx
  10045f:	c1 e1 0c             	shl    $0xc,%ecx
  100462:	8b 10                	mov    (%eax),%edx
  100464:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  10046a:	09 ca                	or     %ecx,%edx
  10046c:	89 10                	mov    %edx,(%eax)
	p->present = 1;
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	0f b6 10             	movzbl (%eax),%edx
  100474:	83 ca 01             	or     $0x1,%edx
  100477:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
  100479:	8b 45 08             	mov    0x8(%ebp),%eax
  10047c:	0f b6 10             	movzbl (%eax),%edx
  10047f:	83 ca 02             	or     $0x2,%edx
  100482:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
  100484:	8b 45 08             	mov    0x8(%ebp),%eax
  100487:	0f b6 10             	movzbl (%eax),%edx
  10048a:	83 ca 04             	or     $0x4,%edx
  10048d:	88 10                	mov    %dl,(%eax)
}
  10048f:	5d                   	pop    %ebp
  100490:	c3                   	ret    

00100491 <make_pte>:

void
make_pte(PTE *p, void *addr) {
  100491:	55                   	push   %ebp
  100492:	89 e5                	mov    %esp,%ebp
	p->val = 0;
  100494:	8b 45 08             	mov    0x8(%ebp),%eax
  100497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	p->page_frame = ((uint32_t)addr) >> 12;
  10049d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a0:	c1 e8 0c             	shr    $0xc,%eax
  1004a3:	25 ff ff 0f 00       	and    $0xfffff,%eax
  1004a8:	89 c2                	mov    %eax,%edx
  1004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ad:	89 d1                	mov    %edx,%ecx
  1004af:	c1 e1 0c             	shl    $0xc,%ecx
  1004b2:	8b 10                	mov    (%eax),%edx
  1004b4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  1004ba:	09 ca                	or     %ecx,%edx
  1004bc:	89 10                	mov    %edx,(%eax)
	p->present = 1;
  1004be:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c1:	0f b6 10             	movzbl (%eax),%edx
  1004c4:	83 ca 01             	or     $0x1,%edx
  1004c7:	88 10                	mov    %dl,(%eax)
	p->read_write = 1;
  1004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cc:	0f b6 10             	movzbl (%eax),%edx
  1004cf:	83 ca 02             	or     $0x2,%edx
  1004d2:	88 10                	mov    %dl,(%eax)
	p->user_supervisor = 1;
  1004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d7:	0f b6 10             	movzbl (%eax),%edx
  1004da:	83 ca 04             	or     $0x4,%edx
  1004dd:	88 10                	mov    %dl,(%eax)
}
  1004df:	5d                   	pop    %ebp
  1004e0:	c3                   	ret    

001004e1 <irq_handle>:

void do_syscall(struct TrapFrame *);
/* TrapFrame的定义在include/x86/memory.h
 * 请仔细理解这段程序的含义，这些内容将在后续的实验中被反复使用。 */
void
irq_handle(struct TrapFrame *tf) {
  1004e1:	55                   	push   %ebp
  1004e2:	89 e5                	mov    %esp,%ebp
  1004e4:	83 ec 38             	sub    $0x38,%esp
	//stprintk("%d\n", tf->irq);
	//printk("%x %d %d %d %d \n", tf->irq, tf->eax, tf->ecx, tf->edx);
	if(tf->irq < 1000) {
  1004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ea:	8b 40 30             	mov    0x30(%eax),%eax
  1004ed:	3d e7 03 00 00       	cmp    $0x3e7,%eax
		}
		else {
			//printk("%s, %d: Unexpected exception #%d!\n", __FUNCTION__, __LINE__, tf->irq);
		}
	}
	if (tf->irq == 0x80) {
  1004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f5:	8b 40 30             	mov    0x30(%eax),%eax
  1004f8:	3d 80 00 00 00       	cmp    $0x80,%eax
  1004fd:	75 0e                	jne    10050d <irq_handle+0x2c>
		//printk("ha");
		do_syscall(tf);
  1004ff:	83 ec 0c             	sub    $0xc,%esp
  100502:	ff 75 08             	pushl  0x8(%ebp)
  100505:	e8 31 0a 00 00       	call   100f3b <do_syscall>
  10050a:	83 c4 10             	add    $0x10,%esp
	}
	if (tf->irq == 1000) {
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  100510:	8b 40 30             	mov    0x30(%eax),%eax
  100513:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  100518:	75 0a                	jne    100524 <irq_handle+0x43>
		//printk("haha");
		//serial_printc('t');
		do_timer();
  10051a:	e8 b9 0d 00 00       	call   1012d8 <do_timer>
  10051f:	e9 83 00 00 00       	jmp    1005a7 <irq_handle+0xc6>
	} else if (tf->irq == 1001) {
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	8b 40 30             	mov    0x30(%eax),%eax
  10052a:	3d e9 03 00 00       	cmp    $0x3e9,%eax
  10052f:	75 76                	jne    1005a7 <irq_handle+0xc6>
  100531:	c7 45 ec 60 00 00 00 	movl   $0x60,-0x14(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053b:	89 c2                	mov    %eax,%edx
  10053d:	ec                   	in     (%dx),%al
  10053e:	88 45 eb             	mov    %al,-0x15(%ebp)
	return data;
  100541:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
		//serial_printc('k');
		uint32_t code = inb(0x60);
  100545:	0f b6 c0             	movzbl %al,%eax
  100548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10054b:	c7 45 e4 61 00 00 00 	movl   $0x61,-0x1c(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100555:	89 c2                	mov    %eax,%edx
  100557:	ec                   	in     (%dx),%al
  100558:	88 45 e3             	mov    %al,-0x1d(%ebp)
	return data;
  10055b:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
		uint32_t val = inb(0x61);
  10055f:	0f b6 c0             	movzbl %al,%eax
  100562:	89 45 f0             	mov    %eax,-0x10(%ebp)
		outb(0x61, val | 0x80);
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	83 c8 80             	or     $0xffffff80,%eax
  10056b:	0f b6 c0             	movzbl %al,%eax
  10056e:	c7 45 dc 61 00 00 00 	movl   $0x61,-0x24(%ebp)
  100575:	88 45 db             	mov    %al,-0x25(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100578:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10057c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10057f:	ee                   	out    %al,(%dx)
		outb(0x61, val);
  100580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100583:	0f b6 c0             	movzbl %al,%eax
  100586:	c7 45 d4 61 00 00 00 	movl   $0x61,-0x2c(%ebp)
  10058d:	88 45 d3             	mov    %al,-0x2d(%ebp)
  100590:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  100594:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100597:	ee                   	out    %al,(%dx)
		press_key(code);
  100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10059b:	83 ec 0c             	sub    $0xc,%esp
  10059e:	50                   	push   %eax
  10059f:	e8 bd 08 00 00       	call   100e61 <press_key>
  1005a4:	83 c4 10             	add    $0x10,%esp
	} else {
		
	}
}
  1005a7:	c9                   	leave  
  1005a8:	c3                   	ret    

001005a9 <save_idt>:
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
  1005a9:	55                   	push   %ebp
  1005aa:	89 e5                	mov    %esp,%ebp
	static volatile uint16_t data[3];
	data[0] = size - 1;
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	83 e8 01             	sub    $0x1,%eax
  1005b2:	66 a3 b6 60 12 00    	mov    %ax,0x1260b6
	data[1] = (uint32_t)addr;
  1005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1005bb:	66 a3 b8 60 12 00    	mov    %ax,0x1260b8
	data[2] = ((uint32_t)addr) >> 16;
  1005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c4:	c1 e8 10             	shr    $0x10,%eax
  1005c7:	66 a3 ba 60 12 00    	mov    %ax,0x1260ba
	asm volatile("lidt (%0)" : : "r"(data));
  1005cd:	b8 b6 60 12 00       	mov    $0x1260b6,%eax
  1005d2:	0f 01 18             	lidtl  (%eax)
}
  1005d5:	5d                   	pop    %ebp
  1005d6:	c3                   	ret    

001005d7 <set_intr>:
/* IDT表的内容 */
struct GateDescriptor idt[NR_IRQ];

/* 初始化一个中断门(interrupt gate) */
static void
set_intr(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
  1005d7:	55                   	push   %ebp
  1005d8:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
  1005da:	8b 45 10             	mov    0x10(%ebp),%eax
  1005dd:	89 c2                	mov    %eax,%edx
  1005df:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e2:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
  1005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  1005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f2:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
  1005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f9:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = INTERRUPT_GATE_32;
  1005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100600:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100604:	83 e2 f0             	and    $0xfffffff0,%edx
  100607:	83 ca 0e             	or     $0xe,%edx
  10060a:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
  10060d:	8b 45 08             	mov    0x8(%ebp),%eax
  100610:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100614:	83 e2 ef             	and    $0xffffffef,%edx
  100617:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
  10061a:	8b 45 14             	mov    0x14(%ebp),%eax
  10061d:	83 e0 03             	and    $0x3,%eax
  100620:	89 c2                	mov    %eax,%edx
  100622:	8b 45 08             	mov    0x8(%ebp),%eax
  100625:	83 e2 03             	and    $0x3,%edx
  100628:	89 d1                	mov    %edx,%ecx
  10062a:	c1 e1 05             	shl    $0x5,%ecx
  10062d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100631:	83 e2 9f             	and    $0xffffff9f,%edx
  100634:	09 ca                	or     %ecx,%edx
  100636:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  100639:	8b 45 08             	mov    0x8(%ebp),%eax
  10063c:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100640:	83 ca 80             	or     $0xffffff80,%edx
  100643:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
  100646:	8b 45 10             	mov    0x10(%ebp),%eax
  100649:	c1 e8 10             	shr    $0x10,%eax
  10064c:	89 c2                	mov    %eax,%edx
  10064e:	8b 45 08             	mov    0x8(%ebp),%eax
  100651:	66 89 50 06          	mov    %dx,0x6(%eax)
}
  100655:	5d                   	pop    %ebp
  100656:	c3                   	ret    

00100657 <set_trap>:

/* 初始化一个陷阱门(trap gate) */
static void
set_trap(struct GateDescriptor *ptr, uint32_t selector, uint32_t offset, uint32_t dpl) {
  100657:	55                   	push   %ebp
  100658:	89 e5                	mov    %esp,%ebp
	ptr->offset_15_0 = offset & 0xFFFF;
  10065a:	8b 45 10             	mov    0x10(%ebp),%eax
  10065d:	89 c2                	mov    %eax,%edx
  10065f:	8b 45 08             	mov    0x8(%ebp),%eax
  100662:	66 89 10             	mov    %dx,(%eax)
	ptr->segment = selector << 3;
  100665:	8b 45 0c             	mov    0xc(%ebp),%eax
  100668:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  10066f:	8b 45 08             	mov    0x8(%ebp),%eax
  100672:	66 89 50 02          	mov    %dx,0x2(%eax)
	ptr->pad0 = 0;
  100676:	8b 45 08             	mov    0x8(%ebp),%eax
  100679:	c6 40 04 00          	movb   $0x0,0x4(%eax)
	ptr->type = TRAP_GATE_32;
  10067d:	8b 45 08             	mov    0x8(%ebp),%eax
  100680:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100684:	83 ca 0f             	or     $0xf,%edx
  100687:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->system = 0;
  10068a:	8b 45 08             	mov    0x8(%ebp),%eax
  10068d:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  100691:	83 e2 ef             	and    $0xffffffef,%edx
  100694:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->privilege_level = dpl;
  100697:	8b 45 14             	mov    0x14(%ebp),%eax
  10069a:	83 e0 03             	and    $0x3,%eax
  10069d:	89 c2                	mov    %eax,%edx
  10069f:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a2:	83 e2 03             	and    $0x3,%edx
  1006a5:	89 d1                	mov    %edx,%ecx
  1006a7:	c1 e1 05             	shl    $0x5,%ecx
  1006aa:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1006ae:	83 e2 9f             	and    $0xffffff9f,%edx
  1006b1:	09 ca                	or     %ecx,%edx
  1006b3:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->present = 1;
  1006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b9:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  1006bd:	83 ca 80             	or     $0xffffff80,%edx
  1006c0:	88 50 05             	mov    %dl,0x5(%eax)
	ptr->offset_31_16 = (offset >> 16) & 0xFFFF;
  1006c3:	8b 45 10             	mov    0x10(%ebp),%eax
  1006c6:	c1 e8 10             	shr    $0x10,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ce:	66 89 50 06          	mov    %dx,0x6(%eax)
}
  1006d2:	5d                   	pop    %ebp
  1006d3:	c3                   	ret    

001006d4 <init_idt>:
void vec13();
void vecsys();

void irq_empty();

void init_idt() {
  1006d4:	55                   	push   %ebp
  1006d5:	89 e5                	mov    %esp,%ebp
  1006d7:	83 ec 10             	sub    $0x10,%esp
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
  1006da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1006e1:	eb 22                	jmp    100705 <init_idt+0x31>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
  1006e3:	ba ab 13 10 00       	mov    $0x1013ab,%edx
  1006e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1006eb:	c1 e0 03             	shl    $0x3,%eax
  1006ee:	05 80 5a 14 00       	add    $0x145a80,%eax
  1006f3:	6a 00                	push   $0x0
  1006f5:	52                   	push   %edx
  1006f6:	6a 01                	push   $0x1
  1006f8:	50                   	push   %eax
  1006f9:	e8 59 ff ff ff       	call   100657 <set_trap>
  1006fe:	83 c4 10             	add    $0x10,%esp
void irq_empty();

void init_idt() {
	int i;
	/* 为了防止系统异常终止，所有irq都有处理函数(irq_empty)。 */
	for (i = 0; i < NR_IRQ; i ++) {
  100701:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100705:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10070c:	7e d5                	jle    1006e3 <init_idt+0xf>
		set_trap(idt + i, SEG_KERNEL_CODE, (uint32_t)irq_empty, DPL_KERNEL);
	}

	/* 设置异常的中断处理 */
	set_trap(idt + 0, SEG_KERNEL_CODE, (uint32_t)vec0, DPL_KERNEL);
  10070e:	b8 f4 12 10 00       	mov    $0x1012f4,%eax
  100713:	6a 00                	push   $0x0
  100715:	50                   	push   %eax
  100716:	6a 01                	push   $0x1
  100718:	68 80 5a 14 00       	push   $0x145a80
  10071d:	e8 35 ff ff ff       	call   100657 <set_trap>
  100722:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 1, SEG_KERNEL_CODE, (uint32_t)vec1, DPL_KERNEL);
  100725:	b8 fd 12 10 00       	mov    $0x1012fd,%eax
  10072a:	6a 00                	push   $0x0
  10072c:	50                   	push   %eax
  10072d:	6a 01                	push   $0x1
  10072f:	68 88 5a 14 00       	push   $0x145a88
  100734:	e8 1e ff ff ff       	call   100657 <set_trap>
  100739:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 2, SEG_KERNEL_CODE, (uint32_t)vec2, DPL_KERNEL);
  10073c:	b8 06 13 10 00       	mov    $0x101306,%eax
  100741:	6a 00                	push   $0x0
  100743:	50                   	push   %eax
  100744:	6a 01                	push   $0x1
  100746:	68 90 5a 14 00       	push   $0x145a90
  10074b:	e8 07 ff ff ff       	call   100657 <set_trap>
  100750:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 3, SEG_KERNEL_CODE, (uint32_t)vec3, DPL_KERNEL);
  100753:	b8 0f 13 10 00       	mov    $0x10130f,%eax
  100758:	6a 00                	push   $0x0
  10075a:	50                   	push   %eax
  10075b:	6a 01                	push   $0x1
  10075d:	68 98 5a 14 00       	push   $0x145a98
  100762:	e8 f0 fe ff ff       	call   100657 <set_trap>
  100767:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 4, SEG_KERNEL_CODE, (uint32_t)vec4, DPL_KERNEL);
  10076a:	b8 18 13 10 00       	mov    $0x101318,%eax
  10076f:	6a 00                	push   $0x0
  100771:	50                   	push   %eax
  100772:	6a 01                	push   $0x1
  100774:	68 a0 5a 14 00       	push   $0x145aa0
  100779:	e8 d9 fe ff ff       	call   100657 <set_trap>
  10077e:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 5, SEG_KERNEL_CODE, (uint32_t)vec5, DPL_KERNEL);
  100781:	b8 21 13 10 00       	mov    $0x101321,%eax
  100786:	6a 00                	push   $0x0
  100788:	50                   	push   %eax
  100789:	6a 01                	push   $0x1
  10078b:	68 a8 5a 14 00       	push   $0x145aa8
  100790:	e8 c2 fe ff ff       	call   100657 <set_trap>
  100795:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 6, SEG_KERNEL_CODE, (uint32_t)vec6, DPL_KERNEL);
  100798:	b8 2a 13 10 00       	mov    $0x10132a,%eax
  10079d:	6a 00                	push   $0x0
  10079f:	50                   	push   %eax
  1007a0:	6a 01                	push   $0x1
  1007a2:	68 b0 5a 14 00       	push   $0x145ab0
  1007a7:	e8 ab fe ff ff       	call   100657 <set_trap>
  1007ac:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 7, SEG_KERNEL_CODE, (uint32_t)vec7, DPL_KERNEL);
  1007af:	b8 33 13 10 00       	mov    $0x101333,%eax
  1007b4:	6a 00                	push   $0x0
  1007b6:	50                   	push   %eax
  1007b7:	6a 01                	push   $0x1
  1007b9:	68 b8 5a 14 00       	push   $0x145ab8
  1007be:	e8 94 fe ff ff       	call   100657 <set_trap>
  1007c3:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 8, SEG_KERNEL_CODE, (uint32_t)vec8, DPL_KERNEL);
  1007c6:	b8 3c 13 10 00       	mov    $0x10133c,%eax
  1007cb:	6a 00                	push   $0x0
  1007cd:	50                   	push   %eax
  1007ce:	6a 01                	push   $0x1
  1007d0:	68 c0 5a 14 00       	push   $0x145ac0
  1007d5:	e8 7d fe ff ff       	call   100657 <set_trap>
  1007da:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 9, SEG_KERNEL_CODE, (uint32_t)vec9, DPL_KERNEL);
  1007dd:	b8 45 13 10 00       	mov    $0x101345,%eax
  1007e2:	6a 00                	push   $0x0
  1007e4:	50                   	push   %eax
  1007e5:	6a 01                	push   $0x1
  1007e7:	68 c8 5a 14 00       	push   $0x145ac8
  1007ec:	e8 66 fe ff ff       	call   100657 <set_trap>
  1007f1:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 10, SEG_KERNEL_CODE, (uint32_t)vec10, DPL_KERNEL);
  1007f4:	b8 4e 13 10 00       	mov    $0x10134e,%eax
  1007f9:	6a 00                	push   $0x0
  1007fb:	50                   	push   %eax
  1007fc:	6a 01                	push   $0x1
  1007fe:	68 d0 5a 14 00       	push   $0x145ad0
  100803:	e8 4f fe ff ff       	call   100657 <set_trap>
  100808:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 11, SEG_KERNEL_CODE, (uint32_t)vec11, DPL_KERNEL);
  10080b:	b8 57 13 10 00       	mov    $0x101357,%eax
  100810:	6a 00                	push   $0x0
  100812:	50                   	push   %eax
  100813:	6a 01                	push   $0x1
  100815:	68 d8 5a 14 00       	push   $0x145ad8
  10081a:	e8 38 fe ff ff       	call   100657 <set_trap>
  10081f:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 12, SEG_KERNEL_CODE, (uint32_t)vec12, DPL_KERNEL);
  100822:	b8 60 13 10 00       	mov    $0x101360,%eax
  100827:	6a 00                	push   $0x0
  100829:	50                   	push   %eax
  10082a:	6a 01                	push   $0x1
  10082c:	68 e0 5a 14 00       	push   $0x145ae0
  100831:	e8 21 fe ff ff       	call   100657 <set_trap>
  100836:	83 c4 10             	add    $0x10,%esp
	set_trap(idt + 13, SEG_KERNEL_CODE, (uint32_t)vec13, DPL_KERNEL);
  100839:	b8 69 13 10 00       	mov    $0x101369,%eax
  10083e:	6a 00                	push   $0x0
  100840:	50                   	push   %eax
  100841:	6a 01                	push   $0x1
  100843:	68 e8 5a 14 00       	push   $0x145ae8
  100848:	e8 0a fe ff ff       	call   100657 <set_trap>
  10084d:	83 c4 10             	add    $0x10,%esp

	set_trap(idt + 0x80, SEG_KERNEL_CODE, (uint32_t)vecsys, DPL_USER);
  100850:	b8 7b 13 10 00       	mov    $0x10137b,%eax
  100855:	6a 03                	push   $0x3
  100857:	50                   	push   %eax
  100858:	6a 01                	push   $0x1
  10085a:	68 80 5e 14 00       	push   $0x145e80
  10085f:	e8 f3 fd ff ff       	call   100657 <set_trap>
  100864:	83 c4 10             	add    $0x10,%esp
	/* 设置外部中断的处理 */
	set_intr(idt + 32, SEG_KERNEL_CODE, (uint32_t)irq0, DPL_KERNEL);
  100867:	b8 87 13 10 00       	mov    $0x101387,%eax
  10086c:	6a 00                	push   $0x0
  10086e:	50                   	push   %eax
  10086f:	6a 01                	push   $0x1
  100871:	68 80 5b 14 00       	push   $0x145b80
  100876:	e8 5c fd ff ff       	call   1005d7 <set_intr>
  10087b:	83 c4 10             	add    $0x10,%esp
	set_intr(idt + 33, SEG_KERNEL_CODE, (uint32_t)irq1, DPL_KERNEL);
  10087e:	b8 93 13 10 00       	mov    $0x101393,%eax
  100883:	6a 00                	push   $0x0
  100885:	50                   	push   %eax
  100886:	6a 01                	push   $0x1
  100888:	68 88 5b 14 00       	push   $0x145b88
  10088d:	e8 45 fd ff ff       	call   1005d7 <set_intr>
  100892:	83 c4 10             	add    $0x10,%esp
	/* 写入IDT */
	save_idt(idt, sizeof(idt));
  100895:	68 00 08 00 00       	push   $0x800
  10089a:	68 80 5a 14 00       	push   $0x145a80
  10089f:	e8 05 fd ff ff       	call   1005a9 <save_idt>
  1008a4:	83 c4 08             	add    $0x8,%esp
}
  1008a7:	c9                   	leave  
  1008a8:	c3                   	ret    

001008a9 <init_serial>:

#include "common.h"
#define SERIAL_PORT  0x3F8

static inline
void init_serial(void) {
  1008a9:	55                   	push   %ebp
  1008aa:	89 e5                	mov    %esp,%ebp
  1008ac:	83 ec 40             	sub    $0x40,%esp
  1008af:	c7 45 fc f9 03 00 00 	movl   $0x3f9,-0x4(%ebp)
  1008b6:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1008ba:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1008be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1008c1:	ee                   	out    %al,(%dx)
  1008c2:	c7 45 f4 fb 03 00 00 	movl   $0x3fb,-0xc(%ebp)
  1008c9:	c6 45 f3 80          	movb   $0x80,-0xd(%ebp)
  1008cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1008d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1008d4:	ee                   	out    %al,(%dx)
  1008d5:	c7 45 ec f8 03 00 00 	movl   $0x3f8,-0x14(%ebp)
  1008dc:	c6 45 eb 01          	movb   $0x1,-0x15(%ebp)
  1008e0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1008e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008e7:	ee                   	out    %al,(%dx)
  1008e8:	c7 45 e4 f9 03 00 00 	movl   $0x3f9,-0x1c(%ebp)
  1008ef:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
  1008f3:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1008f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1008fa:	ee                   	out    %al,(%dx)
  1008fb:	c7 45 dc fb 03 00 00 	movl   $0x3fb,-0x24(%ebp)
  100902:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  100906:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10090a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10090d:	ee                   	out    %al,(%dx)
  10090e:	c7 45 d4 fa 03 00 00 	movl   $0x3fa,-0x2c(%ebp)
  100915:	c6 45 d3 c7          	movb   $0xc7,-0x2d(%ebp)
  100919:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  10091d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100920:	ee                   	out    %al,(%dx)
  100921:	c7 45 cc fc 03 00 00 	movl   $0x3fc,-0x34(%ebp)
  100928:	c6 45 cb 0b          	movb   $0xb,-0x35(%ebp)
  10092c:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
  100930:	8b 55 cc             	mov    -0x34(%ebp),%edx
  100933:	ee                   	out    %al,(%dx)
	outb(SERIAL_PORT + 0, 0x01);
	outb(SERIAL_PORT + 1, 0x00);
	outb(SERIAL_PORT + 3, 0x03);
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}
  100934:	c9                   	leave  
  100935:	c3                   	ret    

00100936 <serial_idle>:

static inline
int serial_idle(void) {
  100936:	55                   	push   %ebp
  100937:	89 e5                	mov    %esp,%ebp
  100939:	83 ec 10             	sub    $0x10,%esp
  10093c:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100946:	89 c2                	mov    %eax,%edx
  100948:	ec                   	in     (%dx),%al
  100949:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
  10094c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
  100950:	0f b6 c0             	movzbl %al,%eax
  100953:	83 e0 20             	and    $0x20,%eax
  100956:	85 c0                	test   %eax,%eax
  100958:	0f 95 c0             	setne  %al
  10095b:	0f b6 c0             	movzbl %al,%eax
}
  10095e:	c9                   	leave  
  10095f:	c3                   	ret    

00100960 <serial_printc>:

static inline
void serial_printc(char ch) {
  100960:	55                   	push   %ebp
  100961:	89 e5                	mov    %esp,%ebp
  100963:	83 ec 14             	sub    $0x14,%esp
  100966:	8b 45 08             	mov    0x8(%ebp),%eax
  100969:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
  10096c:	90                   	nop
  10096d:	e8 c4 ff ff ff       	call   100936 <serial_idle>
  100972:	85 c0                	test   %eax,%eax
  100974:	74 f7                	je     10096d <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
  100976:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  10097a:	0f b6 c0             	movzbl %al,%eax
  10097d:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
  100984:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100987:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10098b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10098e:	ee                   	out    %al,(%dx)
}
  10098f:	c9                   	leave  
  100990:	c3                   	ret    

00100991 <printk>:
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
  100991:	55                   	push   %ebp
  100992:	89 e5                	mov    %esp,%ebp
  100994:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
  100997:	8d 45 0c             	lea    0xc(%ebp),%eax
  10099a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(serial_printc, ctl, args);
  10099d:	8b 45 08             	mov    0x8(%ebp),%eax
  1009a0:	83 ec 04             	sub    $0x4,%esp
  1009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  1009a6:	50                   	push   %eax
  1009a7:	68 60 09 10 00       	push   $0x100960
  1009ac:	e8 83 0a 00 00       	call   101434 <vfprintf>
  1009b1:	83 c4 10             	add    $0x10,%esp
}
  1009b4:	c9                   	leave  
  1009b5:	c3                   	ret    

001009b6 <init_intr>:
#include "common.h"
#define IO_PIC1 0x20
#define IO_PIC2 0xA0
#define IRQ_OFFSET 0x20
#define IRQ_SLAVE 2
void init_intr(void){
  1009b6:	55                   	push   %ebp
  1009b7:	89 e5                	mov    %esp,%ebp
  1009b9:	83 ec 70             	sub    $0x70,%esp
  1009bc:	c7 45 fc 21 00 00 00 	movl   $0x21,-0x4(%ebp)
  1009c3:	c6 45 fb ff          	movb   $0xff,-0x5(%ebp)
  1009c7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1009cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1009ce:	ee                   	out    %al,(%dx)
  1009cf:	c7 45 f4 a1 00 00 00 	movl   $0xa1,-0xc(%ebp)
  1009d6:	c6 45 f3 ff          	movb   $0xff,-0xd(%ebp)
  1009da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1009de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009e1:	ee                   	out    %al,(%dx)
  1009e2:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  1009e9:	c6 45 eb 11          	movb   $0x11,-0x15(%ebp)
  1009ed:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1009f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1009f4:	ee                   	out    %al,(%dx)
  1009f5:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
  1009fc:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  100a00:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  100a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a07:	ee                   	out    %al,(%dx)
  100a08:	c7 45 dc 21 00 00 00 	movl   $0x21,-0x24(%ebp)
  100a0f:	c6 45 db 04          	movb   $0x4,-0x25(%ebp)
  100a13:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100a17:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100a1a:	ee                   	out    %al,(%dx)
  100a1b:	c7 45 d4 21 00 00 00 	movl   $0x21,-0x2c(%ebp)
  100a22:	c6 45 d3 03          	movb   $0x3,-0x2d(%ebp)
  100a26:	0f b6 45 d3          	movzbl -0x2d(%ebp),%eax
  100a2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100a2d:	ee                   	out    %al,(%dx)
  100a2e:	c7 45 cc a0 00 00 00 	movl   $0xa0,-0x34(%ebp)
  100a35:	c6 45 cb 11          	movb   $0x11,-0x35(%ebp)
  100a39:	0f b6 45 cb          	movzbl -0x35(%ebp),%eax
  100a3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  100a40:	ee                   	out    %al,(%dx)
  100a41:	c7 45 c4 a1 00 00 00 	movl   $0xa1,-0x3c(%ebp)
  100a48:	c6 45 c3 28          	movb   $0x28,-0x3d(%ebp)
  100a4c:	0f b6 45 c3          	movzbl -0x3d(%ebp),%eax
  100a50:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  100a53:	ee                   	out    %al,(%dx)
  100a54:	c7 45 bc a1 00 00 00 	movl   $0xa1,-0x44(%ebp)
  100a5b:	c6 45 bb 02          	movb   $0x2,-0x45(%ebp)
  100a5f:	0f b6 45 bb          	movzbl -0x45(%ebp),%eax
  100a63:	8b 55 bc             	mov    -0x44(%ebp),%edx
  100a66:	ee                   	out    %al,(%dx)
  100a67:	c7 45 b4 a1 00 00 00 	movl   $0xa1,-0x4c(%ebp)
  100a6e:	c6 45 b3 01          	movb   $0x1,-0x4d(%ebp)
  100a72:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
  100a76:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  100a79:	ee                   	out    %al,(%dx)
  100a7a:	c7 45 ac 20 00 00 00 	movl   $0x20,-0x54(%ebp)
  100a81:	c6 45 ab 68          	movb   $0x68,-0x55(%ebp)
  100a85:	0f b6 45 ab          	movzbl -0x55(%ebp),%eax
  100a89:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100a8c:	ee                   	out    %al,(%dx)
  100a8d:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%ebp)
  100a94:	c6 45 a3 0a          	movb   $0xa,-0x5d(%ebp)
  100a98:	0f b6 45 a3          	movzbl -0x5d(%ebp),%eax
  100a9c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  100a9f:	ee                   	out    %al,(%dx)
  100aa0:	c7 45 9c a0 00 00 00 	movl   $0xa0,-0x64(%ebp)
  100aa7:	c6 45 9b 68          	movb   $0x68,-0x65(%ebp)
  100aab:	0f b6 45 9b          	movzbl -0x65(%ebp),%eax
  100aaf:	8b 55 9c             	mov    -0x64(%ebp),%edx
  100ab2:	ee                   	out    %al,(%dx)
  100ab3:	c7 45 94 a0 00 00 00 	movl   $0xa0,-0x6c(%ebp)
  100aba:	c6 45 93 0a          	movb   $0xa,-0x6d(%ebp)
  100abe:	0f b6 45 93          	movzbl -0x6d(%ebp),%eax
  100ac2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  100ac5:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);             /* OCW3 */
	outb(IO_PIC2, 0x0a);             /* OCW3 */
}
  100ac6:	c9                   	leave  
  100ac7:	c3                   	ret    

00100ac8 <init_timer>:
  .operate_mode = 2,  // rate generator, for more accuracy
  .access_mode  = 3,  // low byte / high byte, see below
  .channel      = 0,  // use channel 0
};

void init_timer(){
  100ac8:	55                   	push   %ebp
  100ac9:	89 e5                	mov    %esp,%ebp
  100acb:	83 ec 20             	sub    $0x20,%esp
	int counter = PIT_FREQUENCE / HZ;
  100ace:	c7 45 fc 9b 2e 00 00 	movl   $0x2e9b,-0x4(%ebp)
	outb(PORT_CMD, mode.val);
  100ad5:	0f b6 05 00 30 10 00 	movzbl 0x103000,%eax
  100adc:	0f b6 c0             	movzbl %al,%eax
  100adf:	c7 45 f8 43 00 00 00 	movl   $0x43,-0x8(%ebp)
  100ae6:	88 45 f7             	mov    %al,-0x9(%ebp)
  100ae9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100aed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100af0:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, counter & 0xFF);         // access low byte
  100af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100af4:	0f b6 c0             	movzbl %al,%eax
  100af7:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
  100afe:	88 45 ef             	mov    %al,-0x11(%ebp)
  100b01:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b08:	ee                   	out    %al,(%dx)
	outb(PORT_CH_0, (counter >> 8) & 0xFF);  // access high byte
  100b09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b0c:	c1 f8 08             	sar    $0x8,%eax
  100b0f:	0f b6 c0             	movzbl %al,%eax
  100b12:	c7 45 e8 40 00 00 00 	movl   $0x40,-0x18(%ebp)
  100b19:	88 45 e7             	mov    %al,-0x19(%ebp)
  100b1c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100b20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100b23:	ee                   	out    %al,(%dx)
}
  100b24:	c9                   	leave  
  100b25:	c3                   	ret    

00100b26 <waitdisk>:
#define SECTSIZE    512

static inline void
waitdisk(void) {
  100b26:	55                   	push   %ebp
  100b27:	89 e5                	mov    %esp,%ebp
  100b29:	83 ec 10             	sub    $0x10,%esp
    while((inb(0x1F7) & 0xC0) != 0x40);
  100b2c:	90                   	nop
  100b2d:	c7 45 fc f7 01 00 00 	movl   $0x1f7,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100b37:	89 c2                	mov    %eax,%edx
  100b39:	ec                   	in     (%dx),%al
  100b3a:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
  100b3d:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100b41:	0f b6 c0             	movzbl %al,%eax
  100b44:	25 c0 00 00 00       	and    $0xc0,%eax
  100b49:	83 f8 40             	cmp    $0x40,%eax
  100b4c:	75 df                	jne    100b2d <waitdisk+0x7>
}
  100b4e:	c9                   	leave  
  100b4f:	c3                   	ret    

00100b50 <readsect>:

static inline void
readsect(void *dst, int offset) {
  100b50:	55                   	push   %ebp
  100b51:	89 e5                	mov    %esp,%ebp
  100b53:	83 ec 40             	sub    $0x40,%esp
    int i;
    waitdisk();
  100b56:	e8 cb ff ff ff       	call   100b26 <waitdisk>
  100b5b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%ebp)
  100b62:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100b66:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  100b6a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100b6d:	ee                   	out    %al,(%dx)
    outb(0x1F2, 1);
    outb(0x1F3, offset);
  100b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b71:	0f b6 c0             	movzbl %al,%eax
  100b74:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%ebp)
  100b7b:	88 45 ef             	mov    %al,-0x11(%ebp)
  100b7e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100b82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b85:	ee                   	out    %al,(%dx)
    outb(0x1F4, offset >> 8);
  100b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b89:	c1 f8 08             	sar    $0x8,%eax
  100b8c:	0f b6 c0             	movzbl %al,%eax
  100b8f:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%ebp)
  100b96:	88 45 e7             	mov    %al,-0x19(%ebp)
  100b99:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  100b9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  100ba0:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
  100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ba4:	c1 f8 10             	sar    $0x10,%eax
  100ba7:	0f b6 c0             	movzbl %al,%eax
  100baa:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%ebp)
  100bb1:	88 45 df             	mov    %al,-0x21(%ebp)
  100bb4:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100bb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100bbb:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
  100bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bbf:	c1 f8 18             	sar    $0x18,%eax
  100bc2:	83 c8 e0             	or     $0xffffffe0,%eax
  100bc5:	0f b6 c0             	movzbl %al,%eax
  100bc8:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%ebp)
  100bcf:	88 45 d7             	mov    %al,-0x29(%ebp)
  100bd2:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  100bd6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100bd9:	ee                   	out    %al,(%dx)
  100bda:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%ebp)
  100be1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
  100be5:	0f b6 45 cf          	movzbl -0x31(%ebp),%eax
  100be9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  100bec:	ee                   	out    %al,(%dx)
    outb(0x1F7, 0x20);

    waitdisk();
  100bed:	e8 34 ff ff ff       	call   100b26 <waitdisk>
    for (i = 0; i < SECTSIZE / 4; i ++) {
  100bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100bf9:	eb 29                	jmp    100c24 <readsect+0xd4>
        ((int *)dst)[i] = inl(0x1F0);
  100bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100bfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c05:	8b 45 08             	mov    0x8(%ebp),%eax
  100c08:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  100c0b:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%ebp)

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
  100c12:	8b 45 c8             	mov    -0x38(%ebp),%eax
  100c15:	89 c2                	mov    %eax,%edx
  100c17:	ed                   	in     (%dx),%eax
  100c18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	return data;
  100c1b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  100c1e:	89 01                	mov    %eax,(%ecx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
  100c20:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100c24:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100c28:	7e d1                	jle    100bfb <readsect+0xab>
        ((int *)dst)[i] = inl(0x1F0);
    }
}
  100c2a:	c9                   	leave  
  100c2b:	c3                   	ret    

00100c2c <readseg>:

static inline void
readseg(unsigned char *pa, int count, int offset) {
  100c2c:	55                   	push   %ebp
  100c2d:	89 e5                	mov    %esp,%ebp
  100c2f:	83 ec 10             	sub    $0x10,%esp
    unsigned char *epa;
    epa = pa + count;
  100c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c35:	8b 45 08             	mov    0x8(%ebp),%eax
  100c38:	01 d0                	add    %edx,%eax
  100c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    pa -= offset % SECTSIZE;
  100c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  100c40:	99                   	cltd   
  100c41:	c1 ea 17             	shr    $0x17,%edx
  100c44:	01 d0                	add    %edx,%eax
  100c46:	25 ff 01 00 00       	and    $0x1ff,%eax
  100c4b:	29 d0                	sub    %edx,%eax
  100c4d:	f7 d8                	neg    %eax
  100c4f:	01 45 08             	add    %eax,0x8(%ebp)
    offset = (offset / SECTSIZE) + 1;
  100c52:	8b 45 10             	mov    0x10(%ebp),%eax
  100c55:	99                   	cltd   
  100c56:	c1 ea 17             	shr    $0x17,%edx
  100c59:	01 d0                	add    %edx,%eax
  100c5b:	c1 f8 09             	sar    $0x9,%eax
  100c5e:	83 c0 01             	add    $0x1,%eax
  100c61:	89 45 10             	mov    %eax,0x10(%ebp)
    for(; pa < epa; pa += SECTSIZE, offset ++)
  100c64:	eb 19                	jmp    100c7f <readseg+0x53>
        readsect(pa, offset);
  100c66:	ff 75 10             	pushl  0x10(%ebp)
  100c69:	ff 75 08             	pushl  0x8(%ebp)
  100c6c:	e8 df fe ff ff       	call   100b50 <readsect>
  100c71:	83 c4 08             	add    $0x8,%esp
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
  100c74:	81 45 08 00 02 00 00 	addl   $0x200,0x8(%ebp)
  100c7b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  100c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c82:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100c85:	72 df                	jb     100c66 <readseg+0x3a>
        readsect(pa, offset);
  100c87:	c9                   	leave  
  100c88:	c3                   	ret    

00100c89 <page>:
int main_after_you();

PCB *current;
PCB *userpcb;

int page(){
  100c89:	55                   	push   %ebp
  100c8a:	89 e5                	mov    %esp,%ebp
   * consistent with virtual memory, although it is not necessary. */
  //main_after_you();
  /*asm volatile (" addl %0, %%esp\n\t\
          jmp *%1": : "r"(0), "r"(main_after_you));
  */
  return 0;
  100c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c91:	5d                   	pop    %ebp
  100c92:	c3                   	ret    

00100c93 <main>:

int main(){
  100c93:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  100c97:	83 e4 f0             	and    $0xfffffff0,%esp
  100c9a:	ff 71 fc             	pushl  -0x4(%ecx)
  100c9d:	55                   	push   %ebp
  100c9e:	89 e5                	mov    %esp,%ebp
  100ca0:	51                   	push   %ecx
  100ca1:	83 ec 64             	sub    $0x64,%esp
  //KOFFSET
  //init_page();
  init_segment();
  100ca4:	e8 bb f6 ff ff       	call   100364 <init_segment>
	init_serial();
  100ca9:	e8 fb fb ff ff       	call   1008a9 <init_serial>
	init_timer();
  100cae:	e8 15 fe ff ff       	call   100ac8 <init_timer>
	init_idt();
  100cb3:	e8 1c fa ff ff       	call   1006d4 <init_idt>
	init_intr();
  100cb8:	e8 f9 fc ff ff       	call   1009b6 <init_intr>


  struct ProgramHeader *ph, *eph;
  unsigned char* pa, *i;

  readseg((unsigned char*)elf, 8*SECTSIZE, 102400);
  100cbd:	83 ec 04             	sub    $0x4,%esp
  100cc0:	68 00 90 01 00       	push   $0x19000
  100cc5:	68 00 10 00 00       	push   $0x1000
  100cca:	68 00 00 02 00       	push   $0x20000
  100ccf:	e8 58 ff ff ff       	call   100c2c <readseg>
  100cd4:	83 c4 10             	add    $0x10,%esp

  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));
  100cd7:	b8 00 00 02 00       	mov    $0x20000,%eax
  100cdc:	8b 00                	mov    (%eax),%eax
  100cde:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  100ce3:	0f 94 c0             	sete   %al
  100ce6:	0f b6 c0             	movzbl %al,%eax
  100ce9:	83 ec 08             	sub    $0x8,%esp
  100cec:	50                   	push   %eax
  100ced:	68 a2 19 10 00       	push   $0x1019a2
  100cf2:	e8 9a fc ff ff       	call   100991 <printk>
  100cf7:	83 c4 10             	add    $0x10,%esp


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  100cfa:	b8 00 00 02 00       	mov    $0x20000,%eax
  100cff:	8b 40 1c             	mov    0x1c(%eax),%eax
  100d02:	05 00 00 02 00       	add    $0x20000,%eax
  100d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  eph = ph + elf->phnum;
  100d0a:	b8 00 00 02 00       	mov    $0x20000,%eax
  100d0f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  100d13:	0f b7 c0             	movzwl %ax,%eax
  100d16:	c1 e0 05             	shl    $0x5,%eax
  100d19:	89 c2                	mov    %eax,%edx
  100d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d1e:	01 d0                	add    %edx,%eax
  100d20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; ph < eph; ph ++) {
  100d23:	eb 5c                	jmp    100d81 <main+0xee>
    //printf("%x %x\n", ph->paddr, ph->off);
    pa = (unsigned char*)ph->paddr; 
  100d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d28:	8b 40 0c             	mov    0xc(%eax),%eax
  100d2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    readseg(pa, ph->filesz, 102400+ph->off); 
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	8b 40 04             	mov    0x4(%eax),%eax
  100d34:	05 00 90 01 00       	add    $0x19000,%eax
  100d39:	89 c2                	mov    %eax,%edx
  100d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3e:	8b 40 10             	mov    0x10(%eax),%eax
  100d41:	83 ec 04             	sub    $0x4,%esp
  100d44:	52                   	push   %edx
  100d45:	50                   	push   %eax
  100d46:	ff 75 e8             	pushl  -0x18(%ebp)
  100d49:	e8 de fe ff ff       	call   100c2c <readseg>
  100d4e:	83 c4 10             	add    $0x10,%esp
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  100d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d54:	8b 50 10             	mov    0x10(%eax),%edx
  100d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100d5a:	01 d0                	add    %edx,%eax
  100d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100d5f:	eb 0c                	jmp    100d6d <main+0xda>
  100d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100d64:	8d 50 01             	lea    0x1(%eax),%edx
  100d67:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100d6a:	c6 00 00             	movb   $0x0,(%eax)
  100d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d70:	8b 50 14             	mov    0x14(%eax),%edx
  100d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100d76:	01 d0                	add    %edx,%eax
  100d78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  100d7b:	77 e4                	ja     100d61 <main+0xce>
  printk("Magic Assertion: %x\n", (elf->magic == 0x464C457FU));


  ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph ++) {
  100d7d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
  100d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100d87:	72 9c                	jb     100d25 <main+0x92>
    pa = (unsigned char*)ph->paddr; 
    readseg(pa, ph->filesz, 102400+ph->off); 
    for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
  }

  printk("%s\n", "Here we go!");
  100d89:	83 ec 08             	sub    $0x8,%esp
  100d8c:	68 b7 19 10 00       	push   $0x1019b7
  100d91:	68 c3 19 10 00       	push   $0x1019c3
  100d96:	e8 f6 fb ff ff       	call   100991 <printk>
  100d9b:	83 c4 10             	add    $0x10,%esp
  //uint32_t esp;
};

  */
  uint32_t esp;
  asm volatile("mov %%esp, %0": "=m"(esp));
  100d9e:	89 65 e4             	mov    %esp,-0x1c(%ebp)
  printk("%x\n", esp);
  100da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100da4:	83 ec 08             	sub    $0x8,%esp
  100da7:	50                   	push   %eax
  100da8:	68 c7 19 10 00       	push   $0x1019c7
  100dad:	e8 df fb ff ff       	call   100991 <printk>
  100db2:	83 c4 10             	add    $0x10,%esp
  struct TrapFrame tf;
  tf.ds = GD_UD | 3;
  100db5:	c7 45 c4 23 00 00 00 	movl   $0x23,-0x3c(%ebp)
  tf.es = GD_UD | 3;
  100dbc:	c7 45 c0 23 00 00 00 	movl   $0x23,-0x40(%ebp)
  tf.ss = GD_UD | 3;
  100dc3:	66 c7 45 e0 23 00    	movw   $0x23,-0x20(%ebp)
  tf.esp = USTACKTOP;
  100dc9:	c7 45 dc 00 00 30 00 	movl   $0x300000,-0x24(%ebp)
  tf.cs = GD_UT | 3;
  100dd0:	66 c7 45 d4 1b 00    	movw   $0x1b,-0x2c(%ebp)
  tf.eflags = 0x2 | FL_IF;
  100dd6:	c7 45 d8 02 02 00 00 	movl   $0x202,-0x28(%ebp)
  tf.eip = elf->entry;
  100ddd:	b8 00 00 02 00       	mov    $0x20000,%eax
  100de2:	8b 40 18             	mov    0x18(%eax),%eax
  100de5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("mov %0, %%ds" : : "r"(tf.ds));
  100de8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  100deb:	8e d8                	mov    %eax,%ds
  asm volatile("mov %0, %%es" : : "r"(tf.es));
  100ded:	8b 45 c0             	mov    -0x40(%ebp),%eax
  100df0:	8e c0                	mov    %eax,%es
  asm volatile("mov %0, %%fs" : : "r"(tf.fs));
  100df2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  100df5:	8e e0                	mov    %eax,%fs
  asm volatile("mov %0, %%gs" : : "r"(tf.gs));
  100df7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100dfa:	8e e8                	mov    %eax,%gs
  asm volatile("pushl %0" : : "r"((uint32_t)tf.ss));
  100dfc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  100e00:	0f b7 c0             	movzwl %ax,%eax
  100e03:	50                   	push   %eax
  asm volatile("pushl %0" : : "r"(tf.esp));
  100e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100e07:	50                   	push   %eax
  asm volatile("pushl %0" : : "r"(tf.eflags));
  100e08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100e0b:	50                   	push   %eax
  asm volatile("pushl %0" : : "r"((uint32_t)tf.cs));
  100e0c:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
  100e10:	0f b7 c0             	movzwl %ax,%eax
  100e13:	50                   	push   %eax
  asm volatile("pushl %0" : : "r"(tf.eip));
  100e14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100e17:	50                   	push   %eax
  asm volatile("iret"); 
  100e18:	cf                   	iret   
  /*asm volatile("\
          add $0x4, %%esp; \
          popal; \
          add $0x8, %%esp");*/

  printk("%x %x %x\n", tf.eflags, tf.cs, tf.eip);
  100e19:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  100e1c:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
  100e20:	0f b7 d0             	movzwl %ax,%edx
  100e23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100e26:	51                   	push   %ecx
  100e27:	52                   	push   %edx
  100e28:	50                   	push   %eax
  100e29:	68 cb 19 10 00       	push   $0x1019cb
  100e2e:	e8 5e fb ff ff       	call   100991 <printk>
  100e33:	83 c4 10             	add    $0x10,%esp
    /*if(sys_key_down('a'))printf("%s\n", "hahahah");;
    //printf("%c", get_lastkey());
    wait_for_interrupt();
    disable_interrupt();
    enable_interrupt();*/
  };
  100e36:	eb fe                	jmp    100e36 <main+0x1a3>

00100e38 <get_key>:
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
  100e38:	55                   	push   %ebp
  100e39:	89 e5                	mov    %esp,%ebp
  100e3b:	83 ec 04             	sub    $0x4,%esp
  100e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	return keydown[s-'a'];
  100e44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  100e48:	83 e8 61             	sub    $0x61,%eax
  100e4b:	8b 04 85 c0 60 12 00 	mov    0x1260c0(,%eax,4),%eax
}
  100e52:	c9                   	leave  
  100e53:	c3                   	ret    

00100e54 <get_lastkey>:
int8_t get_lastkey(){
  100e54:	55                   	push   %ebp
  100e55:	89 e5                	mov    %esp,%ebp
	return lastkey+'a';
  100e57:	a1 28 61 12 00       	mov    0x126128,%eax
  100e5c:	83 c0 61             	add    $0x61,%eax
}
  100e5f:	5d                   	pop    %ebp
  100e60:	c3                   	ret    

00100e61 <press_key>:
void press_key(int code){
  100e61:	55                   	push   %ebp
  100e62:	89 e5                	mov    %esp,%ebp
  100e64:	83 ec 10             	sub    $0x10,%esp
	int i=0;
  100e67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	//printk("haha\n");
	if((code & 0x80) == 0){
  100e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100e71:	25 80 00 00 00       	and    $0x80,%eax
  100e76:	85 c0                	test   %eax,%eax
  100e78:	75 35                	jne    100eaf <press_key+0x4e>
		for(;i<26;i++){
  100e7a:	eb 2b                	jmp    100ea7 <press_key+0x46>
			if(letter[i]==code){
  100e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7f:	8b 04 85 40 30 10 00 	mov    0x103040(,%eax,4),%eax
  100e86:	3b 45 08             	cmp    0x8(%ebp),%eax
  100e89:	75 18                	jne    100ea3 <press_key+0x42>
				keydown[i] = 1;
  100e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8e:	c7 04 85 c0 60 12 00 	movl   $0x1,0x1260c0(,%eax,4)
  100e95:	01 00 00 00 
				lastkey = i;
  100e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9c:	a3 28 61 12 00       	mov    %eax,0x126128
				return;
  100ea1:	eb 3b                	jmp    100ede <press_key+0x7d>
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
  100ea3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ea7:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
  100eab:	7e cf                	jle    100e7c <press_key+0x1b>
  100ead:	eb 2f                	jmp    100ede <press_key+0x7d>
				lastkey = i;
				return;
			}
		}
	}else{
		code &= 0x7F;
  100eaf:	83 65 08 7f          	andl   $0x7f,0x8(%ebp)
		for(;i<26;i++){
  100eb3:	eb 23                	jmp    100ed8 <press_key+0x77>
			if(letter[i]==code){
  100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb8:	8b 04 85 40 30 10 00 	mov    0x103040(,%eax,4),%eax
  100ebf:	3b 45 08             	cmp    0x8(%ebp),%eax
  100ec2:	75 10                	jne    100ed4 <press_key+0x73>
				keydown[i] = 0;
  100ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec7:	c7 04 85 c0 60 12 00 	movl   $0x0,0x1260c0(,%eax,4)
  100ece:	00 00 00 00 
				return;
  100ed2:	eb 0a                	jmp    100ede <press_key+0x7d>
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
  100ed4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ed8:	83 7d fc 19          	cmpl   $0x19,-0x4(%ebp)
  100edc:	7e d7                	jle    100eb5 <press_key+0x54>
				keydown[i] = 0;
				return;
			}
		}
	}
}
  100ede:	c9                   	leave  
  100edf:	c3                   	ret    

00100ee0 <serial_idle>:
	outb(SERIAL_PORT + 2, 0xC7);
	outb(SERIAL_PORT + 4, 0x0B);
}

static inline
int serial_idle(void) {
  100ee0:	55                   	push   %ebp
  100ee1:	89 e5                	mov    %esp,%ebp
  100ee3:	83 ec 10             	sub    $0x10,%esp
  100ee6:	c7 45 fc fd 03 00 00 	movl   $0x3fd,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef0:	89 c2                	mov    %eax,%edx
  100ef2:	ec                   	in     (%dx),%al
  100ef3:	88 45 fb             	mov    %al,-0x5(%ebp)
	return data;
  100ef6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
	return (inb(SERIAL_PORT + 5) & 0x20) != 0;
  100efa:	0f b6 c0             	movzbl %al,%eax
  100efd:	83 e0 20             	and    $0x20,%eax
  100f00:	85 c0                	test   %eax,%eax
  100f02:	0f 95 c0             	setne  %al
  100f05:	0f b6 c0             	movzbl %al,%eax
}
  100f08:	c9                   	leave  
  100f09:	c3                   	ret    

00100f0a <serial_printc>:

static inline
void serial_printc(char ch) {
  100f0a:	55                   	push   %ebp
  100f0b:	89 e5                	mov    %esp,%ebp
  100f0d:	83 ec 14             	sub    $0x14,%esp
  100f10:	8b 45 08             	mov    0x8(%ebp),%eax
  100f13:	88 45 ec             	mov    %al,-0x14(%ebp)
	while (!serial_idle());
  100f16:	90                   	nop
  100f17:	e8 c4 ff ff ff       	call   100ee0 <serial_idle>
  100f1c:	85 c0                	test   %eax,%eax
  100f1e:	74 f7                	je     100f17 <serial_printc+0xd>
	outb(SERIAL_PORT, ch);
  100f20:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100f24:	0f b6 c0             	movzbl %al,%eax
  100f27:	c7 45 fc f8 03 00 00 	movl   $0x3f8,-0x4(%ebp)
  100f2e:	88 45 fb             	mov    %al,-0x5(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100f31:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  100f35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100f38:	ee                   	out    %al,(%dx)
}
  100f39:	c9                   	leave  
  100f3a:	c3                   	ret    

00100f3b <do_syscall>:
#include "lib/syscall.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];
extern uint32_t tick();

void do_syscall(struct TrapFrame *tf) {
  100f3b:	55                   	push   %ebp
  100f3c:	89 e5                	mov    %esp,%ebp
  100f3e:	83 ec 18             	sub    $0x18,%esp
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	int i;
	switch(tf->eax) {
  100f41:	8b 45 08             	mov    0x8(%ebp),%eax
  100f44:	8b 40 1c             	mov    0x1c(%eax),%eax
  100f47:	3d 4e 04 00 00       	cmp    $0x44e,%eax
  100f4c:	0f 84 85 00 00 00    	je     100fd7 <do_syscall+0x9c>
  100f52:	3d 4e 04 00 00       	cmp    $0x44e,%eax
  100f57:	77 1a                	ja     100f73 <do_syscall+0x38>
  100f59:	3d 4c 04 00 00       	cmp    $0x44c,%eax
  100f5e:	74 63                	je     100fc3 <do_syscall+0x88>
  100f60:	3d 4c 04 00 00       	cmp    $0x44c,%eax
  100f65:	77 66                	ja     100fcd <do_syscall+0x92>
  100f67:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  100f6c:	74 3e                	je     100fac <do_syscall+0x71>
  100f6e:	e9 0d 01 00 00       	jmp    101080 <do_syscall+0x145>
  100f73:	3d b0 04 00 00       	cmp    $0x4b0,%eax
  100f78:	0f 84 8f 00 00 00    	je     10100d <do_syscall+0xd2>
  100f7e:	3d b0 04 00 00       	cmp    $0x4b0,%eax
  100f83:	77 0c                	ja     100f91 <do_syscall+0x56>
  100f85:	3d 4f 04 00 00       	cmp    $0x44f,%eax
  100f8a:	74 5a                	je     100fe6 <do_syscall+0xab>
  100f8c:	e9 ef 00 00 00       	jmp    101080 <do_syscall+0x145>
  100f91:	3d 14 05 00 00       	cmp    $0x514,%eax
  100f96:	0f 84 a0 00 00 00    	je     10103c <do_syscall+0x101>
  100f9c:	3d 15 05 00 00       	cmp    $0x515,%eax
  100fa1:	0f 84 86 00 00 00    	je     10102d <do_syscall+0xf2>
  100fa7:	e9 d4 00 00 00       	jmp    101080 <do_syscall+0x145>
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
  100fac:	8b 45 08             	mov    0x8(%ebp),%eax
  100faf:	8b 40 10             	mov    0x10(%eax),%eax
  100fb2:	0f be c0             	movsbl %al,%eax
  100fb5:	50                   	push   %eax
  100fb6:	e8 4f ff ff ff       	call   100f0a <serial_printc>
  100fbb:	83 c4 04             	add    $0x4,%esp
			//printk("1\n");
		break;
  100fbe:	e9 bd 00 00 00       	jmp    101080 <do_syscall+0x145>
		case SYS_INIT_CACHE:
			initVCache();
  100fc3:	e8 33 01 00 00       	call   1010fb <initVCache>
		break;
  100fc8:	e9 b3 00 00 00       	jmp    101080 <do_syscall+0x145>
		case SYS_CLEAR_VRAM:
			clearVRAM();
  100fcd:	e8 5e 02 00 00       	call   101230 <clearVRAM>
		break;
  100fd2:	e9 a9 00 00 00       	jmp    101080 <do_syscall+0x145>
		case SYS_FLUSH_VCACHE:
			clearVRAM();
  100fd7:	e8 54 02 00 00       	call   101230 <clearVRAM>
			flushVCache();
  100fdc:	e8 83 01 00 00       	call   101164 <flushVCache>
		break;
  100fe1:	e9 9a 00 00 00       	jmp    101080 <do_syscall+0x145>
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
  100fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  100fe9:	8b 40 14             	mov    0x14(%eax),%eax
  100fec:	0f b6 c0             	movzbl %al,%eax
  100fef:	8b 55 08             	mov    0x8(%ebp),%edx
  100ff2:	8b 52 18             	mov    0x18(%edx),%edx
  100ff5:	89 d1                	mov    %edx,%ecx
  100ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  100ffa:	8b 52 10             	mov    0x10(%edx),%edx
  100ffd:	83 ec 04             	sub    $0x4,%esp
  101000:	50                   	push   %eax
  101001:	51                   	push   %ecx
  101002:	52                   	push   %edx
  101003:	e8 c1 01 00 00       	call   1011c9 <setPixelAt>
  101008:	83 c4 10             	add    $0x10,%esp
		break;
  10100b:	eb 73                	jmp    101080 <do_syscall+0x145>
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
  10100d:	8b 45 08             	mov    0x8(%ebp),%eax
  101010:	8b 40 10             	mov    0x10(%eax),%eax
  101013:	0f be c0             	movsbl %al,%eax
  101016:	83 ec 0c             	sub    $0xc,%esp
  101019:	50                   	push   %eax
  10101a:	e8 19 fe ff ff       	call   100e38 <get_key>
  10101f:	83 c4 10             	add    $0x10,%esp
  101022:	0f be d0             	movsbl %al,%edx
  101025:	8b 45 08             	mov    0x8(%ebp),%eax
  101028:	89 50 1c             	mov    %edx,0x1c(%eax)
		break;
  10102b:	eb 53                	jmp    101080 <do_syscall+0x145>
		case SYS_GET_TICK:
			tf->eax = tick();
  10102d:	e8 b8 02 00 00       	call   1012ea <tick>
  101032:	89 c2                	mov    %eax,%edx
  101034:	8b 45 08             	mov    0x8(%ebp),%eax
  101037:	89 50 1c             	mov    %edx,0x1c(%eax)
			//printk("%d\n", tf->eax);
		break;
  10103a:	eb 44                	jmp    101080 <do_syscall+0x145>
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
  10103c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101043:	eb 34                	jmp    101079 <do_syscall+0x13e>
				if(!timer_handlers[i].used){
  101045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101048:	8b 04 c5 44 57 14 00 	mov    0x145744(,%eax,8),%eax
  10104f:	85 c0                	test   %eax,%eax
  101051:	75 22                	jne    101075 <do_syscall+0x13a>
					timer_handlers[i].ptr = (void*)tf->ebx;
  101053:	8b 45 08             	mov    0x8(%ebp),%eax
  101056:	8b 40 10             	mov    0x10(%eax),%eax
  101059:	89 c2                	mov    %eax,%edx
  10105b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10105e:	89 14 c5 40 57 14 00 	mov    %edx,0x145740(,%eax,8)
					timer_handlers[i].used = 1;
  101065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101068:	c7 04 c5 44 57 14 00 	movl   $0x1,0x145744(,%eax,8)
  10106f:	01 00 00 00 
					break;
  101073:	eb 0a                	jmp    10107f <do_syscall+0x144>
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
  101075:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101079:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  10107d:	7e c6                	jle    101045 <do_syscall+0x10a>
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
  10107f:	90                   	nop
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
  101080:	c9                   	leave  
  101081:	c3                   	ret    

00101082 <init_user_tf>:
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_user_tf(PCB *p, uint32_t entry)
{
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	83 ec 10             	sub    $0x10,%esp
	struct TrapFrame *tf = (p->tf);
  101088:	8b 45 08             	mov    0x8(%ebp),%eax
  10108b:	8b 40 04             	mov    0x4(%eax),%eax
  10108e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//tf->ds = SELECTOR_USER(SEG_USER_DATA);
	//tf->es = SELECTOR_USER(SEG_USER_DATA);
	//tf->ss = SELECTOR_USER(SEG_USER_DATA);
	tf->old_esp = USTACKTOP - 8;
  101091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101094:	c7 40 0c f8 ff 2f 00 	movl   $0x2ffff8,0xc(%eax)
	tf->eip = entry;
  10109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10109e:	8b 55 0c             	mov    0xc(%ebp),%edx
  1010a1:	89 50 38             	mov    %edx,0x38(%eax)
	tf->cs = SELECTOR_USER(SEG_USER_CODE);
  1010a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010a7:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->eflags = 0x2 | FL_IF;
  1010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010b0:	c7 40 40 02 02 00 00 	movl   $0x202,0x40(%eax)
	p->tf = tf;
  1010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1010bd:	89 50 04             	mov    %edx,0x4(%eax)
}
  1010c0:	c9                   	leave  
  1010c1:	c3                   	ret    

001010c2 <pcb_create>:

PCB* pcb_create()
{
  1010c2:	55                   	push   %ebp
  1010c3:	89 e5                	mov    %esp,%ebp
  1010c5:	83 ec 10             	sub    $0x10,%esp
	PCB *p = &PCBPool[0];
  1010c8:	c7 45 fc 80 80 14 00 	movl   $0x148080,-0x4(%ebp)
	p->tf = &tfPool[0];
  1010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010d2:	c7 40 04 c0 62 14 00 	movl   $0x1462c0,0x4(%eax)
	return p;
  1010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1010dc:	c9                   	leave  
  1010dd:	c3                   	ret    

001010de <memcpy>:

static inline void memcpy(void* dst, void* src, int len){
  1010de:	55                   	push   %ebp
  1010df:	89 e5                	mov    %esp,%ebp
  1010e1:	57                   	push   %edi
  1010e2:	56                   	push   %esi
  1010e3:	53                   	push   %ebx
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
  1010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1010e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1010ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1010ed:	89 c1                	mov    %eax,%ecx
  1010ef:	89 d6                	mov    %edx,%esi
  1010f1:	89 df                	mov    %ebx,%edi
  1010f3:	fc                   	cld    
  1010f4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
}
  1010f6:	5b                   	pop    %ebx
  1010f7:	5e                   	pop    %esi
  1010f8:	5f                   	pop    %edi
  1010f9:	5d                   	pop    %ebp
  1010fa:	c3                   	ret    

001010fb <initVCache>:
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
  1010fb:	55                   	push   %ebp
  1010fc:	89 e5                	mov    %esp,%ebp
  1010fe:	83 ec 10             	sub    $0x10,%esp
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
  101101:	68 80 3e 00 00       	push   $0x3e80
  101106:	68 40 5b 13 00       	push   $0x135b40
  10110b:	68 40 61 12 00       	push   $0x126140
  101110:	e8 c9 ff ff ff       	call   1010de <memcpy>
  101115:	83 c4 0c             	add    $0xc,%esp
	for(x=0; x<VHEIGHT; x++){
  101118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10111f:	eb 0f                	jmp    101130 <initVCache+0x35>
		VDIRTY[x] = 0;
  101121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101124:	05 40 55 14 00       	add    $0x145540,%eax
  101129:	c6 00 00             	movb   $0x0,(%eax)
static uint8_t stamp;
void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
  10112c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101130:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  101137:	7e e8                	jle    101121 <initVCache+0x26>

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
  101139:	c9                   	leave  
  10113a:	c3                   	ret    

0010113b <refreshVCache>:
void refreshVCache(){
  10113b:	55                   	push   %ebp
  10113c:	89 e5                	mov    %esp,%ebp
  10113e:	83 ec 10             	sub    $0x10,%esp
	int x;

	for(x=0; x<VHEIGHT; x++){
  101141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101148:	eb 0f                	jmp    101159 <refreshVCache+0x1e>
		VDIRTY[x] = 0;
  10114a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10114d:	05 40 55 14 00       	add    $0x145540,%eax
  101152:	c6 00 00             	movb   $0x0,(%eax)
	}*/
}
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
  101155:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101159:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  101160:	7e e8                	jle    10114a <refreshVCache+0xf>
		VDIRTY[x] = 0;
	};
}
  101162:	c9                   	leave  
  101163:	c3                   	ret    

00101164 <flushVCache>:
void flushVCache(){
  101164:	55                   	push   %ebp
  101165:	89 e5                	mov    %esp,%ebp
  101167:	53                   	push   %ebx
  101168:	83 ec 10             	sub    $0x10,%esp
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
  10116b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101172:	eb 47                	jmp    1011bb <flushVCache+0x57>
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
  101174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101177:	05 40 55 14 00       	add    $0x145540,%eax
  10117c:	0f b6 00             	movzbl (%eax),%eax
  10117f:	84 c0                	test   %al,%al
  101181:	74 34                	je     1011b7 <flushVCache+0x53>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
  101183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  101186:	89 d0                	mov    %edx,%eax
  101188:	c1 e0 02             	shl    $0x2,%eax
  10118b:	01 d0                	add    %edx,%eax
  10118d:	c1 e0 06             	shl    $0x6,%eax
  101190:	8d 88 40 61 12 00    	lea    0x126140(%eax),%ecx
  101196:	8b 1d a8 30 10 00    	mov    0x1030a8,%ebx
  10119c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10119f:	89 d0                	mov    %edx,%eax
  1011a1:	c1 e0 02             	shl    $0x2,%eax
  1011a4:	01 d0                	add    %edx,%eax
  1011a6:	c1 e0 06             	shl    $0x6,%eax
  1011a9:	01 d8                	add    %ebx,%eax
  1011ab:	6a 50                	push   $0x50
  1011ad:	51                   	push   %ecx
  1011ae:	50                   	push   %eax
  1011af:	e8 2a ff ff ff       	call   1010de <memcpy>
  1011b4:	83 c4 0c             	add    $0xc,%esp
	};
}
void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
  1011b7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1011bb:	81 7d f8 c7 00 00 00 	cmpl   $0xc7,-0x8(%ebp)
  1011c2:	7e b0                	jle    101174 <flushVCache+0x10>
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
  1011c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011c7:	c9                   	leave  
  1011c8:	c3                   	ret    

001011c9 <setPixelAt>:
void setPixelAt(int x, int y, uint8_t color){
  1011c9:	55                   	push   %ebp
  1011ca:	89 e5                	mov    %esp,%ebp
  1011cc:	83 ec 04             	sub    $0x4,%esp
  1011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1011d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
  1011d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1011d9:	78 18                	js     1011f3 <setPixelAt+0x2a>
  1011db:	81 7d 08 c7 00 00 00 	cmpl   $0xc7,0x8(%ebp)
  1011e2:	7f 0f                	jg     1011f3 <setPixelAt+0x2a>
  1011e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1011e8:	78 09                	js     1011f3 <setPixelAt+0x2a>
  1011ea:	81 7d 0c 3f 01 00 00 	cmpl   $0x13f,0xc(%ebp)
  1011f1:	7e 02                	jle    1011f5 <setPixelAt+0x2c>
  1011f3:	eb 34                	jmp    101229 <setPixelAt+0x60>
	VDIRTY[x] = 1;
  1011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f8:	05 40 55 14 00       	add    $0x145540,%eax
  1011fd:	c6 00 01             	movb   $0x1,(%eax)
	VCDIRTY[x] = 1;
  101200:	8b 45 08             	mov    0x8(%ebp),%eax
  101203:	05 40 56 14 00       	add    $0x145640,%eax
  101208:	c6 00 01             	movb   $0x1,(%eax)
	VCACHE[VWIDTH*x+y]=color;
  10120b:	8b 55 08             	mov    0x8(%ebp),%edx
  10120e:	89 d0                	mov    %edx,%eax
  101210:	c1 e0 02             	shl    $0x2,%eax
  101213:	01 d0                	add    %edx,%eax
  101215:	c1 e0 06             	shl    $0x6,%eax
  101218:	89 c2                	mov    %eax,%edx
  10121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10121d:	01 c2                	add    %eax,%edx
  10121f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  101223:	88 82 40 61 12 00    	mov    %al,0x126140(%edx)
}
  101229:	c9                   	leave  
  10122a:	c3                   	ret    

0010122b <forceClearVRAM>:
void forceClearVRAM(){
  10122b:	55                   	push   %ebp
  10122c:	89 e5                	mov    %esp,%ebp
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
  10122e:	5d                   	pop    %ebp
  10122f:	c3                   	ret    

00101230 <clearVRAM>:
void clearVRAM(){
  101230:	55                   	push   %ebp
  101231:	89 e5                	mov    %esp,%ebp
  101233:	83 ec 10             	sub    $0x10,%esp
	int x;
	
	for(x=0; x<VHEIGHT; x++){
  101236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10123d:	eb 4e                	jmp    10128d <clearVRAM+0x5d>
		if(VCDIRTY[x] & ~VDIRTY[x]){
  10123f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101242:	05 40 56 14 00       	add    $0x145640,%eax
  101247:	0f b6 00             	movzbl (%eax),%eax
  10124a:	0f b6 c0             	movzbl %al,%eax
  10124d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101250:	81 c2 40 55 14 00    	add    $0x145540,%edx
  101256:	0f b6 12             	movzbl (%edx),%edx
  101259:	0f b6 d2             	movzbl %dl,%edx
  10125c:	f7 d2                	not    %edx
  10125e:	21 d0                	and    %edx,%eax
  101260:	85 c0                	test   %eax,%eax
  101262:	74 25                	je     101289 <clearVRAM+0x59>
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
  101264:	8b 0d a8 30 10 00    	mov    0x1030a8,%ecx
  10126a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10126d:	89 d0                	mov    %edx,%eax
  10126f:	c1 e0 02             	shl    $0x2,%eax
  101272:	01 d0                	add    %edx,%eax
  101274:	c1 e0 06             	shl    $0x6,%eax
  101277:	01 c8                	add    %ecx,%eax
  101279:	6a 50                	push   $0x50
  10127b:	68 40 5b 13 00       	push   $0x135b40
  101280:	50                   	push   %eax
  101281:	e8 58 fe ff ff       	call   1010de <memcpy>
  101286:	83 c4 0c             	add    $0xc,%esp

}
void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
  101289:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10128d:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%ebp)
  101294:	7e a9                	jle    10123f <clearVRAM+0xf>
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
  101296:	0f b6 05 08 57 14 00 	movzbl 0x145708,%eax
  10129d:	83 c0 01             	add    $0x1,%eax
  1012a0:	a2 08 57 14 00       	mov    %al,0x145708
	if(stamp==30){
  1012a5:	0f b6 05 08 57 14 00 	movzbl 0x145708,%eax
  1012ac:	3c 1e                	cmp    $0x1e,%al
  1012ae:	75 07                	jne    1012b7 <clearVRAM+0x87>
		//printk("What matters\n");
		stamp=0;
  1012b0:	c6 05 08 57 14 00 00 	movb   $0x0,0x145708
		//printk("What matters\n");
	}
	if(stamp==0){
  1012b7:	0f b6 05 08 57 14 00 	movzbl 0x145708,%eax
  1012be:	84 c0                	test   %al,%al
  1012c0:	75 14                	jne    1012d6 <clearVRAM+0xa6>
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
  1012c2:	6a 32                	push   $0x32
  1012c4:	68 40 5b 13 00       	push   $0x135b40
  1012c9:	68 40 56 14 00       	push   $0x145640
  1012ce:	e8 0b fe ff ff       	call   1010de <memcpy>
  1012d3:	83 c4 0c             	add    $0xc,%esp
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
  1012d6:	c9                   	leave  
  1012d7:	c3                   	ret    

001012d8 <do_timer>:
#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
  1012d8:	55                   	push   %ebp
  1012d9:	89 e5                	mov    %esp,%ebp
	_tick++;
  1012db:	a1 0c 57 14 00       	mov    0x14570c,%eax
  1012e0:	83 c0 01             	add    $0x1,%eax
  1012e3:	a3 0c 57 14 00       	mov    %eax,0x14570c
	//printk("%d", _tick);
}
  1012e8:	5d                   	pop    %ebp
  1012e9:	c3                   	ret    

001012ea <tick>:
uint32_t tick(){
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
	return _tick;
  1012ed:	a1 0c 57 14 00       	mov    0x14570c,%eax
  1012f2:	5d                   	pop    %ebp
  1012f3:	c3                   	ret    

001012f4 <vec0>:

# 中断和异常处理函数的入口
# 中断处理函数会在IDT中为相应的中断/异常设置处理程序
# 中断/异常的行为参见i386手册
#----|-----entry------|-errorcode-|-----id-----|---handler---|
.globl vec0;    vec0:   pushl $0;  pushl    $0; jmp asm_do_irq
  1012f4:	6a 00                	push   $0x0
  1012f6:	6a 00                	push   $0x0
  1012f8:	e9 b7 00 00 00       	jmp    1013b4 <asm_do_irq>

001012fd <vec1>:
.globl vec1;    vec1:   pushl $0;  pushl    $1; jmp asm_do_irq
  1012fd:	6a 00                	push   $0x0
  1012ff:	6a 01                	push   $0x1
  101301:	e9 ae 00 00 00       	jmp    1013b4 <asm_do_irq>

00101306 <vec2>:
.globl vec2;    vec2:   pushl $0;  pushl    $2; jmp asm_do_irq
  101306:	6a 00                	push   $0x0
  101308:	6a 02                	push   $0x2
  10130a:	e9 a5 00 00 00       	jmp    1013b4 <asm_do_irq>

0010130f <vec3>:
.globl vec3;    vec3:   pushl $0;  pushl    $3; jmp asm_do_irq
  10130f:	6a 00                	push   $0x0
  101311:	6a 03                	push   $0x3
  101313:	e9 9c 00 00 00       	jmp    1013b4 <asm_do_irq>

00101318 <vec4>:
.globl vec4;    vec4:   pushl $0;  pushl    $4; jmp asm_do_irq
  101318:	6a 00                	push   $0x0
  10131a:	6a 04                	push   $0x4
  10131c:	e9 93 00 00 00       	jmp    1013b4 <asm_do_irq>

00101321 <vec5>:
.globl vec5;    vec5:   pushl $0;  pushl    $5; jmp asm_do_irq
  101321:	6a 00                	push   $0x0
  101323:	6a 05                	push   $0x5
  101325:	e9 8a 00 00 00       	jmp    1013b4 <asm_do_irq>

0010132a <vec6>:
.globl vec6;    vec6:   pushl $0;  pushl    $6; jmp asm_do_irq
  10132a:	6a 00                	push   $0x0
  10132c:	6a 06                	push   $0x6
  10132e:	e9 81 00 00 00       	jmp    1013b4 <asm_do_irq>

00101333 <vec7>:
.globl vec7;    vec7:   pushl $0;  pushl    $7; jmp asm_do_irq
  101333:	6a 00                	push   $0x0
  101335:	6a 07                	push   $0x7
  101337:	e9 78 00 00 00       	jmp    1013b4 <asm_do_irq>

0010133c <vec8>:
.globl vec8;    vec8:   pushl $0;  pushl    $8; jmp asm_do_irq
  10133c:	6a 00                	push   $0x0
  10133e:	6a 08                	push   $0x8
  101340:	e9 6f 00 00 00       	jmp    1013b4 <asm_do_irq>

00101345 <vec9>:
.globl vec9;    vec9:   pushl $0;  pushl    $9; jmp asm_do_irq
  101345:	6a 00                	push   $0x0
  101347:	6a 09                	push   $0x9
  101349:	e9 66 00 00 00       	jmp    1013b4 <asm_do_irq>

0010134e <vec10>:
.globl vec10;   vec10:  pushl $0;  pushl   $10; jmp asm_do_irq
  10134e:	6a 00                	push   $0x0
  101350:	6a 0a                	push   $0xa
  101352:	e9 5d 00 00 00       	jmp    1013b4 <asm_do_irq>

00101357 <vec11>:
.globl vec11;   vec11:  pushl $0;  pushl   $11; jmp asm_do_irq
  101357:	6a 00                	push   $0x0
  101359:	6a 0b                	push   $0xb
  10135b:	e9 54 00 00 00       	jmp    1013b4 <asm_do_irq>

00101360 <vec12>:
.globl vec12;   vec12:  pushl $0;  pushl   $12; jmp asm_do_irq
  101360:	6a 00                	push   $0x0
  101362:	6a 0c                	push   $0xc
  101364:	e9 4b 00 00 00       	jmp    1013b4 <asm_do_irq>

00101369 <vec13>:
.globl vec13;   vec13:  pushl $0;  pushl   $13; jmp asm_do_irq
  101369:	6a 00                	push   $0x0
  10136b:	6a 0d                	push   $0xd
  10136d:	e9 42 00 00 00       	jmp    1013b4 <asm_do_irq>

00101372 <vec14>:
.globl vec14;   vec14:  pushl $0;  pushl   $14; jmp asm_do_irq
  101372:	6a 00                	push   $0x0
  101374:	6a 0e                	push   $0xe
  101376:	e9 39 00 00 00       	jmp    1013b4 <asm_do_irq>

0010137b <vecsys>:

.globl vecsys; vecsys:  pushl $0;  pushl $0x80; jmp asm_do_irq
  10137b:	6a 00                	push   $0x0
  10137d:	68 80 00 00 00       	push   $0x80
  101382:	e9 2d 00 00 00       	jmp    1013b4 <asm_do_irq>

00101387 <irq0>:

.globl irq0;     irq0:  pushl $0;  pushl $1000; jmp asm_do_irq
  101387:	6a 00                	push   $0x0
  101389:	68 e8 03 00 00       	push   $0x3e8
  10138e:	e9 21 00 00 00       	jmp    1013b4 <asm_do_irq>

00101393 <irq1>:
.globl irq1;     irq1:  pushl $0;  pushl $1001; jmp asm_do_irq
  101393:	6a 00                	push   $0x0
  101395:	68 e9 03 00 00       	push   $0x3e9
  10139a:	e9 15 00 00 00       	jmp    1013b4 <asm_do_irq>

0010139f <irq14>:
.globl irq14;   irq14:  pushl $0;  pushl $1014; jmp asm_do_irq
  10139f:	6a 00                	push   $0x0
  1013a1:	68 f6 03 00 00       	push   $0x3f6
  1013a6:	e9 09 00 00 00       	jmp    1013b4 <asm_do_irq>

001013ab <irq_empty>:
.globl irq_empty;
			irq_empty:	pushl $0;  pushl   $-1; jmp asm_do_irq
  1013ab:	6a 00                	push   $0x0
  1013ad:	6a ff                	push   $0xffffffff
  1013af:	e9 00 00 00 00       	jmp    1013b4 <asm_do_irq>

001013b4 <asm_do_irq>:
.globl asm_do_irq
.extern irq_handle


asm_do_irq:
  cli
  1013b4:	fa                   	cli    
  pushl %ds
  1013b5:	1e                   	push   %ds
  pushl %es
  1013b6:	06                   	push   %es
  pushl %fs
  1013b7:	0f a0                	push   %fs
  pushl %gs
  1013b9:	0f a8                	push   %gs
	pushal
  1013bb:	60                   	pusha  

  movw $SELECTOR_KERNEL(SEG_KERNEL_DATA), %ax
  1013bc:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
  1013c0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
  1013c2:	8e c0                	mov    %eax,%es

	pushl %esp			# ???
  1013c4:	54                   	push   %esp
	call irq_handle
  1013c5:	e8 17 f1 ff ff       	call   1004e1 <irq_handle>

	addl $4, %esp
  1013ca:	83 c4 04             	add    $0x4,%esp

	popal
  1013cd:	61                   	popa   
  popl %gs
  1013ce:	0f a9                	pop    %gs
  popl %fs
  1013d0:	0f a1                	pop    %fs
  popl %es
  1013d2:	07                   	pop    %es
  popl %ds
  1013d3:	1f                   	pop    %ds
  addl $8, %esp
  1013d4:	83 c4 08             	add    $0x8,%esp
  sti
  1013d7:	fb                   	sti    
  1013d8:	cf                   	iret   
  1013d9:	66 90                	xchg   %ax,%ax
  1013db:	90                   	nop

001013dc <_start>:
  #movl $0x50000, %esp
  #pushl $0x0
  #pushl $0x0
  #pushl main
  #iret
  1013dc:	e9 b2 f8 ff ff       	jmp    100c93 <main>

001013e1 <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
  1013e1:	55                   	push   %ebp
  1013e2:	89 e5                	mov    %esp,%ebp
  1013e4:	53                   	push   %ebx
  1013e5:	83 ec 04             	sub    $0x4,%esp
  1013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013eb:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
  1013ee:	b8 e8 03 00 00       	mov    $0x3e8,%eax
  1013f3:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
  1013f7:	89 d3                	mov    %edx,%ebx
  1013f9:	cd 80                	int    $0x80
}
  1013fb:	83 c4 04             	add    $0x4,%esp
  1013fe:	5b                   	pop    %ebx
  1013ff:	5d                   	pop    %ebp
  101400:	c3                   	ret    

00101401 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
  101401:	55                   	push   %ebp
  101402:	89 e5                	mov    %esp,%ebp
  101404:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
  101407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10140a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
  10140d:	eb 19                	jmp    101428 <printp+0x27>
		printer(cur);
  10140f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101412:	0f b6 00             	movzbl (%eax),%eax
  101415:	0f be c0             	movsbl %al,%eax
  101418:	83 ec 0c             	sub    $0xc,%esp
  10141b:	50                   	push   %eax
  10141c:	8b 45 08             	mov    0x8(%ebp),%eax
  10141f:	ff d0                	call   *%eax
  101421:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
  101424:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10142b:	0f b6 00             	movzbl (%eax),%eax
  10142e:	84 c0                	test   %al,%al
  101430:	75 dd                	jne    10140f <printp+0xe>
		printer(cur);
	}
}
  101432:	c9                   	leave  
  101433:	c3                   	ret    

00101434 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
  101434:	55                   	push   %ebp
  101435:	89 e5                	mov    %esp,%ebp
  101437:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
  10143d:	8b 45 0c             	mov    0xc(%ebp),%eax
  101440:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
  101443:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
  10144a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
  101451:	8b 45 10             	mov    0x10(%ebp),%eax
  101454:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
  101457:	e9 71 02 00 00       	jmp    1016cd <vfprintf+0x299>
		if(cur == '%'){
  10145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10145f:	0f b6 00             	movzbl (%eax),%eax
  101462:	3c 25                	cmp    $0x25,%al
  101464:	75 0c                	jne    101472 <vfprintf+0x3e>
			type = READ;
  101466:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
  10146d:	e9 57 02 00 00       	jmp    1016c9 <vfprintf+0x295>
		}
		if(type == READ){
  101472:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  101476:	0f 85 32 02 00 00    	jne    1016ae <vfprintf+0x27a>
			if(cur == 's'){
  10147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10147f:	0f b6 00             	movzbl (%eax),%eax
  101482:	3c 73                	cmp    $0x73,%al
  101484:	75 35                	jne    1014bb <vfprintf+0x87>
				char* p= XGET(pointer, char*);
  101486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101489:	8b 00                	mov    (%eax),%eax
  10148b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
  10148e:	eb 19                	jmp    1014a9 <vfprintf+0x75>
					printer(*p);
  101490:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101493:	0f b6 00             	movzbl (%eax),%eax
  101496:	0f be c0             	movsbl %al,%eax
  101499:	83 ec 0c             	sub    $0xc,%esp
  10149c:	50                   	push   %eax
  10149d:	8b 45 08             	mov    0x8(%ebp),%eax
  1014a0:	ff d0                	call   *%eax
  1014a2:	83 c4 10             	add    $0x10,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  1014a5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  1014a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014ac:	0f b6 00             	movzbl (%eax),%eax
  1014af:	84 c0                	test   %al,%al
  1014b1:	75 dd                	jne    101490 <vfprintf+0x5c>
					printer(*p);
				}
				XNEXT(pointer);
  1014b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  1014b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
  1014bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1014be:	0f b6 00             	movzbl (%eax),%eax
  1014c1:	3c 78                	cmp    $0x78,%al
  1014c3:	0f 85 9f 00 00 00    	jne    101568 <vfprintf+0x134>
				uint32_t x = XGET(pointer, int);
  1014c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1014cc:	8b 00                	mov    (%eax),%eax
  1014ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
  1014d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1014d5:	75 1d                	jne    1014f4 <vfprintf+0xc0>
					printer('0');
  1014d7:	83 ec 0c             	sub    $0xc,%esp
  1014da:	6a 30                	push   $0x30
  1014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1014df:	ff d0                	call   *%eax
  1014e1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  1014e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  1014e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1014ef:	e9 d5 01 00 00       	jmp    1016c9 <vfprintf+0x295>
					continue;
				}
				char digits[100];
				int di=0;
  1014f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
  1014fb:	eb 30                	jmp    10152d <vfprintf+0xf9>
					int d=(x%16);
  1014fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101500:	83 e0 0f             	and    $0xf,%eax
  101503:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
  101506:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  10150a:	7e 04                	jle    101510 <vfprintf+0xdc>
						d+='a'-'0'-10;
  10150c:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
  101510:	8b 45 d8             	mov    -0x28(%ebp),%eax
  101513:	83 c0 30             	add    $0x30,%eax
  101516:	89 c1                	mov    %eax,%ecx
  101518:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  10151e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101521:	01 d0                	add    %edx,%eax
  101523:	88 08                	mov    %cl,(%eax)
					x>>=4;
  101525:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
  101529:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  10152d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  101531:	75 ca                	jne    1014fd <vfprintf+0xc9>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
  101533:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
  101537:	eb 21                	jmp    10155a <vfprintf+0x126>
					printer(digits[di]);
  101539:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  10153f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101542:	01 d0                	add    %edx,%eax
  101544:	0f b6 00             	movzbl (%eax),%eax
  101547:	0f be c0             	movsbl %al,%eax
  10154a:	83 ec 0c             	sub    $0xc,%esp
  10154d:	50                   	push   %eax
  10154e:	8b 45 08             	mov    0x8(%ebp),%eax
  101551:	ff d0                	call   *%eax
  101553:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  101556:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  10155a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10155e:	79 d9                	jns    101539 <vfprintf+0x105>
					printer(digits[di]);
				}
				XNEXT(pointer);
  101560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  101564:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
  101568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10156b:	0f b6 00             	movzbl (%eax),%eax
  10156e:	3c 64                	cmp    $0x64,%al
  101570:	0f 85 08 01 00 00    	jne    10167e <vfprintf+0x24a>
				int x = XGET(pointer, int);
  101576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101579:	8b 00                	mov    (%eax),%eax
  10157b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
  10157e:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
  101585:	75 23                	jne    1015aa <vfprintf+0x176>
					printp(printer, "-2147483648");
  101587:	83 ec 08             	sub    $0x8,%esp
  10158a:	68 d5 19 10 00       	push   $0x1019d5
  10158f:	ff 75 08             	pushl  0x8(%ebp)
  101592:	e8 6a fe ff ff       	call   101401 <printp>
  101597:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  10159a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  10159e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  1015a5:	e9 1f 01 00 00       	jmp    1016c9 <vfprintf+0x295>
				}
				if(x==0){
  1015aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1015ae:	75 1e                	jne    1015ce <vfprintf+0x19a>
					printer('0');
  1015b0:	83 ec 0c             	sub    $0xc,%esp
  1015b3:	6a 30                	push   $0x30
  1015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b8:	ff d0                	call   *%eax
  1015ba:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  1015bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  1015c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  1015c8:	90                   	nop
  1015c9:	e9 fb 00 00 00       	jmp    1016c9 <vfprintf+0x295>
				}
				if(x<0){
  1015ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1015d2:	79 10                	jns    1015e4 <vfprintf+0x1b0>
					printer('-');
  1015d4:	83 ec 0c             	sub    $0xc,%esp
  1015d7:	6a 2d                	push   $0x2d
  1015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015dc:	ff d0                	call   *%eax
  1015de:	83 c4 10             	add    $0x10,%esp
					x=-x;
  1015e1:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
  1015e4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
  1015eb:	eb 56                	jmp    101643 <vfprintf+0x20f>
					digits[di] = '0'+(x%10);
  1015ed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1015f0:	ba 67 66 66 66       	mov    $0x66666667,%edx
  1015f5:	89 c8                	mov    %ecx,%eax
  1015f7:	f7 ea                	imul   %edx
  1015f9:	c1 fa 02             	sar    $0x2,%edx
  1015fc:	89 c8                	mov    %ecx,%eax
  1015fe:	c1 f8 1f             	sar    $0x1f,%eax
  101601:	29 c2                	sub    %eax,%edx
  101603:	89 d0                	mov    %edx,%eax
  101605:	c1 e0 02             	shl    $0x2,%eax
  101608:	01 d0                	add    %edx,%eax
  10160a:	01 c0                	add    %eax,%eax
  10160c:	29 c1                	sub    %eax,%ecx
  10160e:	89 ca                	mov    %ecx,%edx
  101610:	89 d0                	mov    %edx,%eax
  101612:	83 c0 30             	add    $0x30,%eax
  101615:	89 c1                	mov    %eax,%ecx
  101617:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  10161d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  101620:	01 d0                	add    %edx,%eax
  101622:	88 08                	mov    %cl,(%eax)
					x/=10;
  101624:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  101627:	ba 67 66 66 66       	mov    $0x66666667,%edx
  10162c:	89 c8                	mov    %ecx,%eax
  10162e:	f7 ea                	imul   %edx
  101630:	c1 fa 02             	sar    $0x2,%edx
  101633:	89 c8                	mov    %ecx,%eax
  101635:	c1 f8 1f             	sar    $0x1f,%eax
  101638:	29 c2                	sub    %eax,%edx
  10163a:	89 d0                	mov    %edx,%eax
  10163c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
  10163f:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  101643:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  101647:	7f a4                	jg     1015ed <vfprintf+0x1b9>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
  101649:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
  10164d:	eb 21                	jmp    101670 <vfprintf+0x23c>
					printer(digits[di]);
  10164f:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  101655:	8b 45 d0             	mov    -0x30(%ebp),%eax
  101658:	01 d0                	add    %edx,%eax
  10165a:	0f b6 00             	movzbl (%eax),%eax
  10165d:	0f be c0             	movsbl %al,%eax
  101660:	83 ec 0c             	sub    $0xc,%esp
  101663:	50                   	push   %eax
  101664:	8b 45 08             	mov    0x8(%ebp),%eax
  101667:	ff d0                	call   *%eax
  101669:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  10166c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  101670:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  101674:	79 d9                	jns    10164f <vfprintf+0x21b>
					printer(digits[di]);
				}
				XNEXT(pointer);
  101676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  10167a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
  10167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101681:	0f b6 00             	movzbl (%eax),%eax
  101684:	3c 63                	cmp    $0x63,%al
  101686:	75 1d                	jne    1016a5 <vfprintf+0x271>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
  101688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10168b:	0f b6 00             	movzbl (%eax),%eax
  10168e:	0f be c0             	movsbl %al,%eax
  101691:	83 ec 0c             	sub    $0xc,%esp
  101694:	50                   	push   %eax
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	ff d0                	call   *%eax
  10169a:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
  10169d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  1016a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
  1016a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
  1016ac:	eb 1b                	jmp    1016c9 <vfprintf+0x295>
		}
		if(type == NONE){
  1016ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1016b2:	75 15                	jne    1016c9 <vfprintf+0x295>
			printer(cur);
  1016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016b7:	0f b6 00             	movzbl (%eax),%eax
  1016ba:	0f be c0             	movsbl %al,%eax
  1016bd:	83 ec 0c             	sub    $0xc,%esp
  1016c0:	50                   	push   %eax
  1016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c4:	ff d0                	call   *%eax
  1016c6:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  1016c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016d0:	0f b6 00             	movzbl (%eax),%eax
  1016d3:	84 c0                	test   %al,%al
  1016d5:	0f 85 81 fd ff ff    	jne    10145c <vfprintf+0x28>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
  1016db:	c9                   	leave  
  1016dc:	c3                   	ret    

001016dd <vfprintfs>:

void vfprintfs(void (*printer)(char), const char *ctl, void **args) {
  1016dd:	55                   	push   %ebp
  1016de:	89 e5                	mov    %esp,%ebp
  1016e0:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
  1016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1016e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
  1016ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
  1016f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
  1016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1016fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
  101700:	e9 68 02 00 00       	jmp    10196d <vfprintfs+0x290>
		if(cur == '%'){
  101705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101708:	0f b6 00             	movzbl (%eax),%eax
  10170b:	3c 25                	cmp    $0x25,%al
  10170d:	75 0c                	jne    10171b <vfprintfs+0x3e>
			type = READ;
  10170f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
  101716:	e9 4e 02 00 00       	jmp    101969 <vfprintfs+0x28c>
		}
		if(type == READ){
  10171b:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  10171f:	0f 85 29 02 00 00    	jne    10194e <vfprintfs+0x271>
			if(cur == 's'){
  101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101728:	0f b6 00             	movzbl (%eax),%eax
  10172b:	3c 73                	cmp    $0x73,%al
  10172d:	75 32                	jne    101761 <vfprintfs+0x84>
				char* p= XGET(pointer, char*);
  10172f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101732:	8b 00                	mov    (%eax),%eax
  101734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
  101737:	eb 16                	jmp    10174f <vfprintfs+0x72>
					sys_printch(*p);
  101739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10173c:	0f b6 00             	movzbl (%eax),%eax
  10173f:	0f be c0             	movsbl %al,%eax
  101742:	50                   	push   %eax
  101743:	e8 99 fc ff ff       	call   1013e1 <sys_printch>
  101748:	83 c4 04             	add    $0x4,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  10174b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  10174f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101752:	0f b6 00             	movzbl (%eax),%eax
  101755:	84 c0                	test   %al,%al
  101757:	75 e0                	jne    101739 <vfprintfs+0x5c>
					sys_printch(*p);
				}
				XNEXT(pointer);
  101759:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  10175d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
  101761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101764:	0f b6 00             	movzbl (%eax),%eax
  101767:	3c 78                	cmp    $0x78,%al
  101769:	0f 85 99 00 00 00    	jne    101808 <vfprintfs+0x12b>
				uint32_t x = XGET(pointer, int);
  10176f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101772:	8b 00                	mov    (%eax),%eax
  101774:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
  101777:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10177b:	75 1a                	jne    101797 <vfprintfs+0xba>
					sys_printch('0');
  10177d:	6a 30                	push   $0x30
  10177f:	e8 5d fc ff ff       	call   1013e1 <sys_printch>
  101784:	83 c4 04             	add    $0x4,%esp
					XNEXT(pointer);
  101787:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  10178b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101792:	e9 d2 01 00 00       	jmp    101969 <vfprintfs+0x28c>
					continue;
				}
				char digits[100];
				int di=0;
  101797:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
  10179e:	eb 30                	jmp    1017d0 <vfprintfs+0xf3>
					int d=(x%16);
  1017a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1017a3:	83 e0 0f             	and    $0xf,%eax
  1017a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
  1017a9:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  1017ad:	7e 04                	jle    1017b3 <vfprintfs+0xd6>
						d+='a'-'0'-10;
  1017af:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
  1017b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1017b6:	83 c0 30             	add    $0x30,%eax
  1017b9:	89 c1                	mov    %eax,%ecx
  1017bb:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1017c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1017c4:	01 d0                	add    %edx,%eax
  1017c6:	88 08                	mov    %cl,(%eax)
					x>>=4;
  1017c8:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
  1017cc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  1017d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1017d4:	75 ca                	jne    1017a0 <vfprintfs+0xc3>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
  1017d6:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
  1017da:	eb 1e                	jmp    1017fa <vfprintfs+0x11d>
					sys_printch(digits[di]);
  1017dc:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1017e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1017e5:	01 d0                	add    %edx,%eax
  1017e7:	0f b6 00             	movzbl (%eax),%eax
  1017ea:	0f be c0             	movsbl %al,%eax
  1017ed:	50                   	push   %eax
  1017ee:	e8 ee fb ff ff       	call   1013e1 <sys_printch>
  1017f3:	83 c4 04             	add    $0x4,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  1017f6:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  1017fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1017fe:	79 dc                	jns    1017dc <vfprintfs+0xff>
					sys_printch(digits[di]);
				}
				XNEXT(pointer);
  101800:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  101804:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
  101808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10180b:	0f b6 00             	movzbl (%eax),%eax
  10180e:	3c 64                	cmp    $0x64,%al
  101810:	0f 85 08 01 00 00    	jne    10191e <vfprintfs+0x241>
				int x = XGET(pointer, int);
  101816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101819:	8b 00                	mov    (%eax),%eax
  10181b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
  10181e:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
  101825:	75 23                	jne    10184a <vfprintfs+0x16d>
					printp(printer, "-2147483648");
  101827:	83 ec 08             	sub    $0x8,%esp
  10182a:	68 d5 19 10 00       	push   $0x1019d5
  10182f:	ff 75 08             	pushl  0x8(%ebp)
  101832:	e8 ca fb ff ff       	call   101401 <printp>
  101837:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  10183a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  10183e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  101845:	e9 1f 01 00 00       	jmp    101969 <vfprintfs+0x28c>
				}
				if(x==0){
  10184a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  10184e:	75 1e                	jne    10186e <vfprintfs+0x191>
					sys_printch('0');
  101850:	83 ec 0c             	sub    $0xc,%esp
  101853:	6a 30                	push   $0x30
  101855:	e8 87 fb ff ff       	call   1013e1 <sys_printch>
  10185a:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  10185d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  101861:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  101868:	90                   	nop
  101869:	e9 fb 00 00 00       	jmp    101969 <vfprintfs+0x28c>
				}
				if(x<0){
  10186e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  101872:	79 10                	jns    101884 <vfprintfs+0x1a7>
					sys_printch('-');
  101874:	83 ec 0c             	sub    $0xc,%esp
  101877:	6a 2d                	push   $0x2d
  101879:	e8 63 fb ff ff       	call   1013e1 <sys_printch>
  10187e:	83 c4 10             	add    $0x10,%esp
					x=-x;
  101881:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
  101884:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
  10188b:	eb 56                	jmp    1018e3 <vfprintfs+0x206>
					digits[di] = '0'+(x%10);
  10188d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  101890:	ba 67 66 66 66       	mov    $0x66666667,%edx
  101895:	89 c8                	mov    %ecx,%eax
  101897:	f7 ea                	imul   %edx
  101899:	c1 fa 02             	sar    $0x2,%edx
  10189c:	89 c8                	mov    %ecx,%eax
  10189e:	c1 f8 1f             	sar    $0x1f,%eax
  1018a1:	29 c2                	sub    %eax,%edx
  1018a3:	89 d0                	mov    %edx,%eax
  1018a5:	c1 e0 02             	shl    $0x2,%eax
  1018a8:	01 d0                	add    %edx,%eax
  1018aa:	01 c0                	add    %eax,%eax
  1018ac:	29 c1                	sub    %eax,%ecx
  1018ae:	89 ca                	mov    %ecx,%edx
  1018b0:	89 d0                	mov    %edx,%eax
  1018b2:	83 c0 30             	add    $0x30,%eax
  1018b5:	89 c1                	mov    %eax,%ecx
  1018b7:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1018bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1018c0:	01 d0                	add    %edx,%eax
  1018c2:	88 08                	mov    %cl,(%eax)
					x/=10;
  1018c4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1018c7:	ba 67 66 66 66       	mov    $0x66666667,%edx
  1018cc:	89 c8                	mov    %ecx,%eax
  1018ce:	f7 ea                	imul   %edx
  1018d0:	c1 fa 02             	sar    $0x2,%edx
  1018d3:	89 c8                	mov    %ecx,%eax
  1018d5:	c1 f8 1f             	sar    $0x1f,%eax
  1018d8:	29 c2                	sub    %eax,%edx
  1018da:	89 d0                	mov    %edx,%eax
  1018dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
  1018df:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					sys_printch('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  1018e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1018e7:	7f a4                	jg     10188d <vfprintfs+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
  1018e9:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
  1018ed:	eb 21                	jmp    101910 <vfprintfs+0x233>
					sys_printch(digits[di]);
  1018ef:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  1018f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1018f8:	01 d0                	add    %edx,%eax
  1018fa:	0f b6 00             	movzbl (%eax),%eax
  1018fd:	0f be c0             	movsbl %al,%eax
  101900:	83 ec 0c             	sub    $0xc,%esp
  101903:	50                   	push   %eax
  101904:	e8 d8 fa ff ff       	call   1013e1 <sys_printch>
  101909:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  10190c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  101910:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  101914:	79 d9                	jns    1018ef <vfprintfs+0x212>
					sys_printch(digits[di]);
				}
				XNEXT(pointer);
  101916:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  10191a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
  10191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101921:	0f b6 00             	movzbl (%eax),%eax
  101924:	3c 63                	cmp    $0x63,%al
  101926:	75 1d                	jne    101945 <vfprintfs+0x268>
				//char* pointer = (char*)args;
				//printer(*pointer);
				sys_printch(XGET(pointer, char));
  101928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10192b:	0f b6 00             	movzbl (%eax),%eax
  10192e:	0f be c0             	movsbl %al,%eax
  101931:	83 ec 0c             	sub    $0xc,%esp
  101934:	50                   	push   %eax
  101935:	e8 a7 fa ff ff       	call   1013e1 <sys_printch>
  10193a:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
  10193d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  101941:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
  101945:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
  10194c:	eb 1b                	jmp    101969 <vfprintfs+0x28c>
		}
		if(type == NONE){
  10194e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  101952:	75 15                	jne    101969 <vfprintfs+0x28c>
			sys_printch(cur);
  101954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101957:	0f b6 00             	movzbl (%eax),%eax
  10195a:	0f be c0             	movsbl %al,%eax
  10195d:	83 ec 0c             	sub    $0xc,%esp
  101960:	50                   	push   %eax
  101961:	e8 7b fa ff ff       	call   1013e1 <sys_printch>
  101966:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  101969:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101970:	0f b6 00             	movzbl (%eax),%eax
  101973:	84 c0                	test   %al,%al
  101975:	0f 85 8a fd ff ff    	jne    101705 <vfprintfs+0x28>
		if(type == NONE){
			sys_printch(cur);
		}
		//last = cur;
	}
}
  10197b:	c9                   	leave  
  10197c:	c3                   	ret    

0010197d <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
  10197d:	55                   	push   %ebp
  10197e:	89 e5                	mov    %esp,%ebp
  101980:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
  101983:	8d 45 0c             	lea    0xc(%ebp),%eax
  101986:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintfs(sys_printch, ctl, args);
  101989:	8b 45 08             	mov    0x8(%ebp),%eax
  10198c:	83 ec 04             	sub    $0x4,%esp
  10198f:	ff 75 f4             	pushl  -0xc(%ebp)
  101992:	50                   	push   %eax
  101993:	68 e1 13 10 00       	push   $0x1013e1
  101998:	e8 40 fd ff ff       	call   1016dd <vfprintfs>
  10199d:	83 c4 10             	add    $0x10,%esp
}
  1019a0:	c9                   	leave  
  1019a1:	c3                   	ret    
