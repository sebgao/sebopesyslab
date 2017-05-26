
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
 8048098:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 804809b:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80480a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80480a9:	a1 00 b0 04 08       	mov    0x804b000,%eax
 80480ae:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80480b4:	05 39 30 00 00       	add    $0x3039,%eax
 80480b9:	a3 00 b0 04 08       	mov    %eax,0x804b000
    y ^= (y<<13);   
 80480be:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480c3:	c1 e0 0d             	shl    $0xd,%eax
 80480c6:	89 c2                	mov    %eax,%edx
 80480c8:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480cd:	31 d0                	xor    %edx,%eax
 80480cf:	a3 04 b0 04 08       	mov    %eax,0x804b004
    y ^= (y>>17);   
 80480d4:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480d9:	c1 e8 11             	shr    $0x11,%eax
 80480dc:	89 c2                	mov    %eax,%edx
 80480de:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480e3:	31 d0                	xor    %edx,%eax
 80480e5:	a3 04 b0 04 08       	mov    %eax,0x804b004
    y ^= (y<<5);    
 80480ea:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480ef:	c1 e0 05             	shl    $0x5,%eax
 80480f2:	89 c2                	mov    %eax,%edx
 80480f4:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480f9:	31 d0                	xor    %edx,%eax
 80480fb:	a3 04 b0 04 08       	mov    %eax,0x804b004
      
    t = (A*z + c);  
 8048100:	a1 08 b0 04 08       	mov    0x804b008,%eax
 8048105:	ba 00 00 00 00       	mov    $0x0,%edx
 804810a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 804810d:	89 cb                	mov    %ecx,%ebx
 804810f:	0f af da             	imul   %edx,%ebx
 8048112:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048115:	0f af c8             	imul   %eax,%ecx
 8048118:	01 d9                	add    %ebx,%ecx
 804811a:	f7 65 f0             	mull   -0x10(%ebp)
 804811d:	01 d1                	add    %edx,%ecx
 804811f:	89 ca                	mov    %ecx,%edx
 8048121:	8b 0d 0c b0 04 08    	mov    0x804b00c,%ecx
 8048127:	bb 00 00 00 00       	mov    $0x0,%ebx
 804812c:	01 c8                	add    %ecx,%eax
 804812e:	11 da                	adc    %ebx,%edx
 8048130:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048133:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 8048136:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048139:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804813c:	89 d0                	mov    %edx,%eax
 804813e:	31 d2                	xor    %edx,%edx
 8048140:	a3 0c b0 04 08       	mov    %eax,0x804b00c
    z = t;  
 8048145:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048148:	a3 08 b0 04 08       	mov    %eax,0x804b008
       
    return x+y+z;    
 804814d:	8b 15 00 b0 04 08    	mov    0x804b000,%edx
 8048153:	a1 04 b0 04 08       	mov    0x804b004,%eax
 8048158:	01 c2                	add    %eax,%edx
 804815a:	a1 08 b0 04 08       	mov    0x804b008,%eax
 804815f:	01 d0                	add    %edx,%eax
 8048161:	83 c4 14             	add    $0x14,%esp
 8048164:	5b                   	pop    %ebx
 8048165:	5d                   	pop    %ebp
 8048166:	c3                   	ret    

08048167 <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
 8048167:	55                   	push   %ebp
 8048168:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 804816a:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 804816f:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 8048171:	b8 df 05 00 00       	mov    $0x5df,%eax
 8048176:	cd 80                	int    $0x80
}
 8048178:	5d                   	pop    %ebp
 8048179:	c3                   	ret    

0804817a <sys_fork>:
}

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline uint32_t sys_fork(){
 804817a:	55                   	push   %ebp
 804817b:	89 e5                	mov    %esp,%ebp
 804817d:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 8048187:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 804818c:	cd 80                	int    $0x80
 804818e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 8048191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048194:	c9                   	leave  
 8048195:	c3                   	ret    

08048196 <sys_pid>:
static inline uint32_t sys_pid(){
 8048196:	55                   	push   %ebp
 8048197:	89 e5                	mov    %esp,%ebp
 8048199:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 804819c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 80481a3:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 80481a8:	cd 80                	int    $0x80
 80481aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80481b0:	c9                   	leave  
 80481b1:	c3                   	ret    

080481b2 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 80481b2:	55                   	push   %ebp
 80481b3:	89 e5                	mov    %esp,%ebp
 80481b5:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 80481b6:	b8 de 05 00 00       	mov    $0x5de,%eax
 80481bb:	8b 55 08             	mov    0x8(%ebp),%edx
 80481be:	89 d3                	mov    %edx,%ebx
 80481c0:	cd 80                	int    $0x80
}
 80481c2:	5b                   	pop    %ebx
 80481c3:	5d                   	pop    %ebp
 80481c4:	c3                   	ret    

080481c5 <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
 80481c5:	55                   	push   %ebp
 80481c6:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
 80481c8:	b8 4c 04 00 00       	mov    $0x44c,%eax
 80481cd:	cd 80                	int    $0x80
}
 80481cf:	5d                   	pop    %ebp
 80481d0:	c3                   	ret    

080481d1 <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
 80481d1:	55                   	push   %ebp
 80481d2:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
 80481d4:	b8 4e 04 00 00       	mov    $0x44e,%eax
 80481d9:	cd 80                	int    $0x80
}
 80481db:	5d                   	pop    %ebp
 80481dc:	c3                   	ret    

080481dd <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
 80481dd:	55                   	push   %ebp
 80481de:	89 e5                	mov    %esp,%ebp
 80481e0:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
 80481e1:	b8 4f 04 00 00       	mov    $0x44f,%eax
 80481e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80481e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80481ec:	8b 55 10             	mov    0x10(%ebp),%edx
 80481ef:	cd 80                	int    $0x80
}
 80481f1:	5b                   	pop    %ebx
 80481f2:	5d                   	pop    %ebp
 80481f3:	c3                   	ret    

080481f4 <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
 80481f4:	55                   	push   %ebp
 80481f5:	89 e5                	mov    %esp,%ebp
 80481f7:	53                   	push   %ebx
 80481f8:	83 ec 14             	sub    $0x14,%esp
 80481fb:	8b 45 08             	mov    0x8(%ebp),%eax
 80481fe:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
 8048201:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
 8048205:	b8 b0 04 00 00       	mov    $0x4b0,%eax
 804820a:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 804820e:	89 d3                	mov    %edx,%ebx
 8048210:	cd 80                	int    $0x80
 8048212:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 8048215:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
 8048219:	83 c4 14             	add    $0x14,%esp
 804821c:	5b                   	pop    %ebx
 804821d:	5d                   	pop    %ebp
 804821e:	c3                   	ret    

0804821f <sys_get_tick>:
static inline uint32_t sys_get_tick(){
 804821f:	55                   	push   %ebp
 8048220:	89 e5                	mov    %esp,%ebp
 8048222:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
 804822c:	b8 15 05 00 00       	mov    $0x515,%eax
 8048231:	cd 80                	int    $0x80
 8048233:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 8048236:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048239:	c9                   	leave  
 804823a:	c3                   	ret    

0804823b <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
 804823b:	55                   	push   %ebp
 804823c:	89 e5                	mov    %esp,%ebp
 804823e:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
 8048241:	8b 45 08             	mov    0x8(%ebp),%eax
 8048244:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 804824b:	85 c0                	test   %eax,%eax
 804824d:	74 0f                	je     804825e <isqrt+0x23>
 804824f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048252:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 8048259:	e9 a9 00 00 00       	jmp    8048307 <isqrt+0xcc>
    const uint16_t *p = squares;
 804825e:	c7 45 fc c0 98 04 08 	movl   $0x80498c0,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
 8048265:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048268:	83 c0 40             	add    $0x40,%eax
 804826b:	0f b7 00             	movzwl (%eax),%eax
 804826e:	0f b7 c0             	movzwl %ax,%eax
 8048271:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048274:	77 04                	ja     804827a <isqrt+0x3f>
 8048276:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
 804827a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804827d:	83 c0 20             	add    $0x20,%eax
 8048280:	0f b7 00             	movzwl (%eax),%eax
 8048283:	0f b7 c0             	movzwl %ax,%eax
 8048286:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048289:	77 04                	ja     804828f <isqrt+0x54>
 804828b:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
 804828f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048292:	83 c0 10             	add    $0x10,%eax
 8048295:	0f b7 00             	movzwl (%eax),%eax
 8048298:	0f b7 c0             	movzwl %ax,%eax
 804829b:	3b 45 08             	cmp    0x8(%ebp),%eax
 804829e:	77 04                	ja     80482a4 <isqrt+0x69>
 80482a0:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
 80482a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482a7:	83 c0 08             	add    $0x8,%eax
 80482aa:	0f b7 00             	movzwl (%eax),%eax
 80482ad:	0f b7 c0             	movzwl %ax,%eax
 80482b0:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482b3:	77 04                	ja     80482b9 <isqrt+0x7e>
 80482b5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
 80482b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482bc:	83 c0 04             	add    $0x4,%eax
 80482bf:	0f b7 00             	movzwl (%eax),%eax
 80482c2:	0f b7 c0             	movzwl %ax,%eax
 80482c5:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482c8:	77 04                	ja     80482ce <isqrt+0x93>
 80482ca:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
 80482ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482d1:	83 c0 02             	add    $0x2,%eax
 80482d4:	0f b7 00             	movzwl (%eax),%eax
 80482d7:	0f b7 c0             	movzwl %ax,%eax
 80482da:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482dd:	77 04                	ja     80482e3 <isqrt+0xa8>
 80482df:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
 80482e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482e6:	ba c0 98 04 08       	mov    $0x80498c0,%edx
 80482eb:	29 d0                	sub    %edx,%eax
 80482ed:	d1 f8                	sar    %eax
 80482ef:	89 c2                	mov    %eax,%edx
 80482f1:	8b 45 08             	mov    0x8(%ebp),%eax
 80482f4:	89 14 85 c0 b0 04 08 	mov    %edx,0x804b0c0(,%eax,4)
    return p - squares;
 80482fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482fe:	ba c0 98 04 08       	mov    $0x80498c0,%edx
 8048303:	29 d0                	sub    %edx,%eax
 8048305:	d1 f8                	sar    %eax
}
 8048307:	c9                   	leave  
 8048308:	c3                   	ret    

08048309 <clearStage>:


static inline void clearStage(){
 8048309:	55                   	push   %ebp
 804830a:	89 e5                	mov    %esp,%ebp
	hash = 0;
 804830c:	c7 05 80 b0 04 08 00 	movl   $0x0,0x804b080
 8048313:	00 00 00 
	sys_init_vcache();
 8048316:	e8 aa fe ff ff       	call   80481c5 <sys_init_vcache>
}
 804831b:	5d                   	pop    %ebp
 804831c:	c3                   	ret    

0804831d <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
 804831d:	55                   	push   %ebp
 804831e:	89 e5                	mov    %esp,%ebp
 8048320:	83 ec 04             	sub    $0x4,%esp
 8048323:	8b 45 10             	mov    0x10(%ebp),%eax
 8048326:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
 8048329:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 804832d:	50                   	push   %eax
 804832e:	ff 75 08             	pushl  0x8(%ebp)
 8048331:	ff 75 0c             	pushl  0xc(%ebp)
 8048334:	e8 a4 fe ff ff       	call   80481dd <sys_set_pixel>
 8048339:	83 c4 0c             	add    $0xc,%esp
}
 804833c:	c9                   	leave  
 804833d:	c3                   	ret    

0804833e <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
 804833e:	55                   	push   %ebp
 804833f:	89 e5                	mov    %esp,%ebp
 8048341:	53                   	push   %ebx
 8048342:	83 ec 14             	sub    $0x14,%esp
 8048345:	8b 45 18             	mov    0x18(%ebp),%eax
 8048348:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
 804834b:	8b 45 08             	mov    0x8(%ebp),%eax
 804834e:	6b d0 1d             	imul   $0x1d,%eax,%edx
 8048351:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048354:	6b c0 39             	imul   $0x39,%eax,%eax
 8048357:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804835a:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 804835e:	89 d0                	mov    %edx,%eax
 8048360:	01 c0                	add    %eax,%eax
 8048362:	01 d0                	add    %edx,%eax
 8048364:	c1 e0 02             	shl    $0x2,%eax
 8048367:	01 d0                	add    %edx,%eax
 8048369:	01 c8                	add    %ecx,%eax
 804836b:	89 c2                	mov    %eax,%edx
 804836d:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048372:	01 d0                	add    %edx,%eax
 8048374:	a3 80 b0 04 08       	mov    %eax,0x804b080
	int i=0, j=0;
 8048379:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
 8048387:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804838e:	eb 38                	jmp    80483c8 <drawRect+0x8a>
		for(j=0;j<h;j++){
 8048390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048397:	eb 23                	jmp    80483bc <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
 8048399:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804839d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80483a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 80483a3:	01 d1                	add    %edx,%ecx
 80483a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80483a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80483ab:	01 da                	add    %ebx,%edx
 80483ad:	50                   	push   %eax
 80483ae:	51                   	push   %ecx
 80483af:	52                   	push   %edx
 80483b0:	e8 68 ff ff ff       	call   804831d <drawPoint>
 80483b5:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
 80483b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80483bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483bf:	3b 45 14             	cmp    0x14(%ebp),%eax
 80483c2:	7c d5                	jl     8048399 <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
 80483c4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80483c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80483cb:	3b 45 10             	cmp    0x10(%ebp),%eax
 80483ce:	7c c0                	jl     8048390 <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
 80483d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80483d3:	c9                   	leave  
 80483d4:	c3                   	ret    

080483d5 <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
 80483d5:	55                   	push   %ebp
 80483d6:	89 e5                	mov    %esp,%ebp
 80483d8:	53                   	push   %ebx
 80483d9:	83 ec 14             	sub    $0x14,%esp
 80483dc:	8b 45 14             	mov    0x14(%ebp),%eax
 80483df:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
 80483e2:	8b 45 08             	mov    0x8(%ebp),%eax
 80483e5:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
 80483eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483ee:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
 80483f4:	01 c2                	add    %eax,%edx
 80483f6:	8b 45 10             	mov    0x10(%ebp),%eax
 80483f9:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
 80483ff:	01 d0                	add    %edx,%eax
 8048401:	89 c2                	mov    %eax,%edx
 8048403:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048408:	01 d0                	add    %edx,%eax
 804840a:	a3 80 b0 04 08       	mov    %eax,0x804b080
	for(i=-r; i<=r; i++){
 804840f:	8b 45 10             	mov    0x10(%ebp),%eax
 8048412:	f7 d8                	neg    %eax
 8048414:	89 45 f8             	mov    %eax,-0x8(%ebp)
 8048417:	eb 5c                	jmp    8048475 <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
 8048419:	8b 45 10             	mov    0x10(%ebp),%eax
 804841c:	0f af 45 10          	imul   0x10(%ebp),%eax
 8048420:	89 c2                	mov    %eax,%edx
 8048422:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048425:	0f af 45 f8          	imul   -0x8(%ebp),%eax
 8048429:	29 c2                	sub    %eax,%edx
 804842b:	89 d0                	mov    %edx,%eax
 804842d:	50                   	push   %eax
 804842e:	e8 08 fe ff ff       	call   804823b <isqrt>
 8048433:	83 c4 04             	add    $0x4,%esp
 8048436:	83 c0 01             	add    $0x1,%eax
 8048439:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 804843c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804843f:	f7 d8                	neg    %eax
 8048441:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048444:	eb 23                	jmp    8048469 <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
 8048446:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804844a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804844d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048450:	01 d1                	add    %edx,%ecx
 8048452:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048455:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048458:	01 da                	add    %ebx,%edx
 804845a:	50                   	push   %eax
 804845b:	51                   	push   %ecx
 804845c:	52                   	push   %edx
 804845d:	e8 bb fe ff ff       	call   804831d <drawPoint>
 8048462:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 8048465:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048469:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804846c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 804846f:	7e d5                	jle    8048446 <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
 8048471:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048475:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048478:	3b 45 10             	cmp    0x10(%ebp),%eax
 804847b:	7e 9c                	jle    8048419 <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
 804847d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048480:	c9                   	leave  
 8048481:	c3                   	ret    

08048482 <drawText1>:

static inline void drawText1(){
 8048482:	55                   	push   %ebp
 8048483:	89 e5                	mov    %esp,%ebp
 8048485:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
 8048488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804848f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
 8048496:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804849d:	eb 53                	jmp    80484f2 <drawText1+0x70>
        for(i=0;i<52;i++){
 804849f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 80484a6:	eb 40                	jmp    80484e8 <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
 80484a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80484ab:	6b d0 34             	imul   $0x34,%eax,%edx
 80484ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80484b1:	01 d0                	add    %edx,%eax
 80484b3:	0f b6 80 c0 9a 04 08 	movzbl 0x8049ac0(%eax),%eax
 80484ba:	84 c0                	test   %al,%al
 80484bc:	74 26                	je     80484e4 <drawText1+0x62>
 80484be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80484c1:	89 d0                	mov    %edx,%eax
 80484c3:	c1 e0 02             	shl    $0x2,%eax
 80484c6:	01 d0                	add    %edx,%eax
 80484c8:	8d 50 14             	lea    0x14(%eax),%edx
 80484cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80484ce:	c1 e0 02             	shl    $0x2,%eax
 80484d1:	83 c0 32             	add    $0x32,%eax
 80484d4:	6a 0e                	push   $0xe
 80484d6:	6a 05                	push   $0x5
 80484d8:	6a 04                	push   $0x4
 80484da:	52                   	push   %edx
 80484db:	50                   	push   %eax
 80484dc:	e8 5d fe ff ff       	call   804833e <drawRect>
 80484e1:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
 80484e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80484e8:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
 80484ec:	7e ba                	jle    80484a8 <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
 80484ee:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80484f2:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 80484f6:	7e a7                	jle    804849f <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
 80484f8:	c9                   	leave  
 80484f9:	c3                   	ret    

080484fa <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
 80484fa:	55                   	push   %ebp
 80484fb:	89 e5                	mov    %esp,%ebp
 80484fd:	53                   	push   %ebx
 80484fe:	83 ec 24             	sub    $0x24,%esp
 8048501:	8b 45 18             	mov    0x18(%ebp),%eax
 8048504:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
 8048507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
 804850e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048512:	75 0d                	jne    8048521 <drawNumber+0x27>
        temp[0] = '0';
 8048514:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
 8048518:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804851f:	eb 5f                	jmp    8048580 <drawNumber+0x86>

    }else{    
        while(num>=1){
 8048521:	eb 53                	jmp    8048576 <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
 8048523:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8048526:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804852b:	89 c8                	mov    %ecx,%eax
 804852d:	f7 ea                	imul   %edx
 804852f:	c1 fa 02             	sar    $0x2,%edx
 8048532:	89 c8                	mov    %ecx,%eax
 8048534:	c1 f8 1f             	sar    $0x1f,%eax
 8048537:	29 c2                	sub    %eax,%edx
 8048539:	89 d0                	mov    %edx,%eax
 804853b:	c1 e0 02             	shl    $0x2,%eax
 804853e:	01 d0                	add    %edx,%eax
 8048540:	01 c0                	add    %eax,%eax
 8048542:	29 c1                	sub    %eax,%ecx
 8048544:	89 ca                	mov    %ecx,%edx
 8048546:	89 d0                	mov    %edx,%eax
 8048548:	83 c0 30             	add    $0x30,%eax
 804854b:	89 c1                	mov    %eax,%ecx
 804854d:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048550:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048553:	01 d0                	add    %edx,%eax
 8048555:	88 08                	mov    %cl,(%eax)
            num/=10;
 8048557:	8b 4d 08             	mov    0x8(%ebp),%ecx
 804855a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804855f:	89 c8                	mov    %ecx,%eax
 8048561:	f7 ea                	imul   %edx
 8048563:	c1 fa 02             	sar    $0x2,%edx
 8048566:	89 c8                	mov    %ecx,%eax
 8048568:	c1 f8 1f             	sar    $0x1f,%eax
 804856b:	29 c2                	sub    %eax,%edx
 804856d:	89 d0                	mov    %edx,%eax
 804856f:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
 8048572:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
 8048576:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804857a:	7f a7                	jg     8048523 <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
 804857c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
 8048580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048587:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804858e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
 8048595:	e9 b2 00 00 00       	jmp    804864c <drawNumber+0x152>
        for(yy=0; yy<7; yy++){
 804859a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80485a1:	e9 94 00 00 00       	jmp    804863a <drawNumber+0x140>
            for(xx=0; xx<5; xx++){
 80485a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80485ad:	eb 7d                	jmp    804862c <drawNumber+0x132>
                const char* num = nums[temp[di]-'0'];
 80485af:	8d 55 dd             	lea    -0x23(%ebp),%edx
 80485b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80485b5:	01 d0                	add    %edx,%eax
 80485b7:	0f b6 00             	movzbl (%eax),%eax
 80485ba:	0f be c0             	movsbl %al,%eax
 80485bd:	83 e8 30             	sub    $0x30,%eax
 80485c0:	8b 04 85 20 b0 04 08 	mov    0x804b020(,%eax,4),%eax
 80485c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
 80485ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485cd:	89 d0                	mov    %edx,%eax
 80485cf:	c1 e0 02             	shl    $0x2,%eax
 80485d2:	01 c2                	add    %eax,%edx
 80485d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80485d7:	01 d0                	add    %edx,%eax
 80485d9:	89 c2                	mov    %eax,%edx
 80485db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485de:	01 d0                	add    %edx,%eax
 80485e0:	0f b6 00             	movzbl (%eax),%eax
 80485e3:	84 c0                	test   %al,%al
 80485e5:	74 41                	je     8048628 <drawNumber+0x12e>
 80485e7:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
 80485eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485ee:	89 d1                	mov    %edx,%ecx
 80485f0:	0f af 4d 14          	imul   0x14(%ebp),%ecx
 80485f4:	8b 55 10             	mov    0x10(%ebp),%edx
 80485f7:	01 d1                	add    %edx,%ecx
 80485f9:	8b 55 14             	mov    0x14(%ebp),%edx
 80485fc:	0f af 55 14          	imul   0x14(%ebp),%edx
 8048600:	83 c2 0a             	add    $0xa,%edx
 8048603:	89 d3                	mov    %edx,%ebx
 8048605:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
 8048609:	8b 55 0c             	mov    0xc(%ebp),%edx
 804860c:	01 d3                	add    %edx,%ebx
 804860e:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8048611:	0f af 55 14          	imul   0x14(%ebp),%edx
 8048615:	01 da                	add    %ebx,%edx
 8048617:	50                   	push   %eax
 8048618:	ff 75 14             	pushl  0x14(%ebp)
 804861b:	ff 75 14             	pushl  0x14(%ebp)
 804861e:	51                   	push   %ecx
 804861f:	52                   	push   %edx
 8048620:	e8 19 fd ff ff       	call   804833e <drawRect>
 8048625:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
 8048628:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 804862c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 8048630:	0f 8e 79 ff ff ff    	jle    80485af <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
 8048636:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 804863a:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
 804863e:	0f 8e 62 ff ff ff    	jle    80485a6 <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
 8048644:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
 8048648:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
 804864c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 8048650:	0f 89 44 ff ff ff    	jns    804859a <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
 8048656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048659:	c9                   	leave  
 804865a:	c3                   	ret    

0804865b <drawStage>:

static inline void drawStage(){
 804865b:	55                   	push   %ebp
 804865c:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
 804865e:	8b 15 84 b0 04 08    	mov    0x804b084,%edx
 8048664:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048669:	39 c2                	cmp    %eax,%edx
 804866b:	75 02                	jne    804866f <drawStage+0x14>
 804866d:	eb 0f                	jmp    804867e <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
 804866f:	e8 5d fb ff ff       	call   80481d1 <sys_flush_vcache>
	lhash = hash;
 8048674:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048679:	a3 84 b0 04 08       	mov    %eax,0x804b084
}
 804867e:	5d                   	pop    %ebp
 804867f:	c3                   	ret    

08048680 <key>:
static int timestamp = 1;
static int curtime = 0;
static int score = 0;
void dreamOf100HZ(int);

static inline int8_t key(char s){
 8048680:	55                   	push   %ebp
 8048681:	89 e5                	mov    %esp,%ebp
 8048683:	83 ec 04             	sub    $0x4,%esp
 8048686:	8b 45 08             	mov    0x8(%ebp),%eax
 8048689:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
 804868c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048690:	50                   	push   %eax
 8048691:	e8 5e fb ff ff       	call   80481f4 <sys_key_down>
 8048696:	83 c4 04             	add    $0x4,%esp
}
 8048699:	c9                   	leave  
 804869a:	c3                   	ret    

0804869b <main>:

void game();

int main(){
 804869b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 804869f:	83 e4 f0             	and    $0xfffffff0,%esp
 80486a2:	ff 71 fc             	pushl  -0x4(%ecx)
 80486a5:	55                   	push   %ebp
 80486a6:	89 e5                	mov    %esp,%ebp
 80486a8:	51                   	push   %ecx
 80486a9:	83 ec 04             	sub    $0x4,%esp
	//printk("4\n");
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	printf("Hello this is INIT#%d! Now I want to fork GAME! WATCH ME!\n", getpid());
 80486ac:	e8 e5 fa ff ff       	call   8048196 <sys_pid>
 80486b1:	83 ec 08             	sub    $0x8,%esp
 80486b4:	50                   	push   %eax
 80486b5:	68 44 a1 04 08       	push   $0x804a144
 80486ba:	e8 c5 11 00 00       	call   8049884 <printf>
 80486bf:	83 c4 10             	add    $0x10,%esp
	if(fork()!=0){
 80486c2:	e8 b3 fa ff ff       	call   804817a <sys_fork>
 80486c7:	85 c0                	test   %eax,%eax
 80486c9:	74 33                	je     80486fe <main+0x63>
		printf("INIT#%d: My duty is done! I choose goudai!\n", getpid());
 80486cb:	e8 c6 fa ff ff       	call   8048196 <sys_pid>
 80486d0:	83 ec 08             	sub    $0x8,%esp
 80486d3:	50                   	push   %eax
 80486d4:	68 80 a1 04 08       	push   $0x804a180
 80486d9:	e8 a6 11 00 00       	call   8049884 <printf>
 80486de:	83 c4 10             	add    $0x10,%esp
		//while(1);
		exit();
 80486e1:	e8 81 fa ff ff       	call   8048167 <sys_exit>
		printf("INIT#%d: To check whether I am alive! You should not see this!\n", getpid());
 80486e6:	e8 ab fa ff ff       	call   8048196 <sys_pid>
 80486eb:	83 ec 08             	sub    $0x8,%esp
 80486ee:	50                   	push   %eax
 80486ef:	68 ac a1 04 08       	push   $0x804a1ac
 80486f4:	e8 8b 11 00 00       	call   8049884 <printf>
 80486f9:	83 c4 10             	add    $0x10,%esp
 80486fc:	eb 05                	jmp    8048703 <main+0x68>
	}else{
		game();
 80486fe:	e8 0d 00 00 00       	call   8048710 <game>
	}
	return 1;
 8048703:	b8 01 00 00 00       	mov    $0x1,%eax
};
 8048708:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804870b:	c9                   	leave  
 804870c:	8d 61 fc             	lea    -0x4(%ecx),%esp
 804870f:	c3                   	ret    

08048710 <game>:

void game(){
 8048710:	55                   	push   %ebp
 8048711:	89 e5                	mov    %esp,%ebp
 8048713:	83 ec 08             	sub    $0x8,%esp
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
 8048716:	e8 7b fa ff ff       	call   8048196 <sys_pid>
 804871b:	83 ec 08             	sub    $0x8,%esp
 804871e:	50                   	push   %eax
 804871f:	68 ec a1 04 08       	push   $0x804a1ec
 8048724:	e8 5b 11 00 00       	call   8049884 <printf>
 8048729:	83 c4 10             	add    $0x10,%esp
	while(1){
		timestamp = sys_get_tick();
 804872c:	e8 ee fa ff ff       	call   804821f <sys_get_tick>
 8048731:	a3 48 b0 04 08       	mov    %eax,0x804b048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 8048736:	eb 1e                	jmp    8048756 <game+0x46>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
 8048738:	a1 48 b0 04 08       	mov    0x804b048,%eax
 804873d:	83 ec 0c             	sub    $0xc,%esp
 8048740:	50                   	push   %eax
 8048741:	e8 8c 07 00 00       	call   8048ed2 <dreamOf100HZ>
 8048746:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime+=2;
 8048749:	a1 20 ba 04 08       	mov    0x804ba20,%eax
 804874e:	83 c0 02             	add    $0x2,%eax
 8048751:	a3 20 ba 04 08       	mov    %eax,0x804ba20
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 8048756:	8b 15 20 ba 04 08    	mov    0x804ba20,%edx
 804875c:	a1 48 b0 04 08       	mov    0x804b048,%eax
 8048761:	39 c2                	cmp    %eax,%edx
 8048763:	7c d3                	jl     8048738 <game+0x28>
		//sys_handout();
		

		//enable_interrupt();
		
	}
 8048765:	eb c5                	jmp    804872c <game+0x1c>

08048767 <hitMonster>:
domain int x, y, size;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
 8048767:	55                   	push   %ebp
 8048768:	89 e5                	mov    %esp,%ebp
 804876a:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 804876d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
 8048774:	e9 9c 01 00 00       	jmp    8048915 <hitMonster+0x1ae>
		int dx = x-mon.x; 
 8048779:	8b 15 2c ba 04 08    	mov    0x804ba2c,%edx
 804877f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048782:	c1 e0 02             	shl    $0x2,%eax
 8048785:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804878c:	29 c1                	sub    %eax,%ecx
 804878e:	89 c8                	mov    %ecx,%eax
 8048790:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048795:	8b 40 04             	mov    0x4(%eax),%eax
 8048798:	29 c2                	sub    %eax,%edx
 804879a:	89 d0                	mov    %edx,%eax
 804879c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
 804879f:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80487a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487a8:	c1 e0 02             	shl    $0x2,%eax
 80487ab:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80487b2:	29 c1                	sub    %eax,%ecx
 80487b4:	89 c8                	mov    %ecx,%eax
 80487b6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487bb:	8b 40 08             	mov    0x8(%eax),%eax
 80487be:	29 c2                	sub    %eax,%edx
 80487c0:	89 d0                	mov    %edx,%eax
 80487c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
 80487c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487c8:	89 c2                	mov    %eax,%edx
 80487ca:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80487d1:	89 c2                	mov    %eax,%edx
 80487d3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80487da:	29 d0                	sub    %edx,%eax
 80487dc:	83 c0 10             	add    $0x10,%eax
 80487df:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487e4:	8b 40 04             	mov    0x4(%eax),%eax
 80487e7:	85 c0                	test   %eax,%eax
 80487e9:	0f 85 22 01 00 00    	jne    8048911 <hitMonster+0x1aa>
 80487ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487f2:	c1 e0 02             	shl    $0x2,%eax
 80487f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487fc:	29 c2                	sub    %eax,%edx
 80487fe:	89 d0                	mov    %edx,%eax
 8048800:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048805:	8b 00                	mov    (%eax),%eax
 8048807:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 804880a:	0f 8c 01 01 00 00    	jl     8048911 <hitMonster+0x1aa>
 8048810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048813:	c1 e0 02             	shl    $0x2,%eax
 8048816:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804881d:	29 c2                	sub    %eax,%edx
 804881f:	89 d0                	mov    %edx,%eax
 8048821:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048826:	8b 00                	mov    (%eax),%eax
 8048828:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 804882b:	0f 8c e0 00 00 00    	jl     8048911 <hitMonster+0x1aa>
 8048831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048834:	c1 e0 02             	shl    $0x2,%eax
 8048837:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804883e:	29 c2                	sub    %eax,%edx
 8048840:	89 d0                	mov    %edx,%eax
 8048842:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048847:	8b 00                	mov    (%eax),%eax
 8048849:	f7 d8                	neg    %eax
 804884b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 804884e:	0f 8f bd 00 00 00    	jg     8048911 <hitMonster+0x1aa>
 8048854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048857:	c1 e0 02             	shl    $0x2,%eax
 804885a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048861:	29 c2                	sub    %eax,%edx
 8048863:	89 d0                	mov    %edx,%eax
 8048865:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804886a:	8b 00                	mov    (%eax),%eax
 804886c:	f7 d8                	neg    %eax
 804886e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8048871:	0f 8f 9a 00 00 00    	jg     8048911 <hitMonster+0x1aa>
			if(mon.size <= size){
 8048877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804887a:	c1 e0 02             	shl    $0x2,%eax
 804887d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048884:	29 c2                	sub    %eax,%edx
 8048886:	89 d0                	mov    %edx,%eax
 8048888:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804888d:	8b 10                	mov    (%eax),%edx
 804888f:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048894:	39 c2                	cmp    %eax,%edx
 8048896:	7f 68                	jg     8048900 <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
 8048898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804889b:	89 c2                	mov    %eax,%edx
 804889d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80488a4:	89 c2                	mov    %eax,%edx
 80488a6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80488ad:	29 d0                	sub    %edx,%eax
 80488af:	83 c0 10             	add    $0x10,%eax
 80488b2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488b7:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
 80488be:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80488c3:	83 f8 0c             	cmp    $0xc,%eax
 80488c6:	7f 0d                	jg     80488d5 <hitMonster+0x16e>
 80488c8:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80488cd:	83 c0 01             	add    $0x1,%eax
 80488d0:	a3 34 ba 04 08       	mov    %eax,0x804ba34
				score += mon.size;
 80488d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80488d8:	c1 e0 02             	shl    $0x2,%eax
 80488db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488e2:	29 c2                	sub    %eax,%edx
 80488e4:	89 d0                	mov    %edx,%eax
 80488e6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488eb:	8b 10                	mov    (%eax),%edx
 80488ed:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80488f2:	01 d0                	add    %edx,%eax
 80488f4:	a3 24 ba 04 08       	mov    %eax,0x804ba24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
 80488f9:	b8 01 00 00 00       	mov    $0x1,%eax
 80488fe:	eb 24                	jmp    8048924 <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
 8048900:	c7 05 28 ba 04 08 03 	movl   $0x3,0x804ba28
 8048907:	00 00 00 
				return 0;
 804890a:	b8 00 00 00 00       	mov    $0x0,%eax
 804890f:	eb 13                	jmp    8048924 <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
 8048911:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8048915:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
 8048919:	0f 8e 5a fe ff ff    	jle    8048779 <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
 804891f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8048924:	c9                   	leave  
 8048925:	c3                   	ret    

08048926 <drawMonster>:

void drawMonster(){
 8048926:	55                   	push   %ebp
 8048927:	89 e5                	mov    %esp,%ebp
 8048929:	56                   	push   %esi
 804892a:	53                   	push   %ebx
 804892b:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 804892e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048935:	e9 89 03 00 00       	jmp    8048cc3 <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
 804893a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804893d:	89 c2                	mov    %eax,%edx
 804893f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048946:	89 c2                	mov    %eax,%edx
 8048948:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804894f:	29 d0                	sub    %edx,%eax
 8048951:	83 c0 10             	add    $0x10,%eax
 8048954:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048959:	8b 40 04             	mov    0x4(%eax),%eax
 804895c:	85 c0                	test   %eax,%eax
 804895e:	0f 85 5b 03 00 00    	jne    8048cbf <drawMonster+0x399>
			mon.x += mon.sx;
 8048964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048967:	c1 e0 02             	shl    $0x2,%eax
 804896a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048971:	29 c2                	sub    %eax,%edx
 8048973:	89 d0                	mov    %edx,%eax
 8048975:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804897a:	8b 50 04             	mov    0x4(%eax),%edx
 804897d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048980:	c1 e0 02             	shl    $0x2,%eax
 8048983:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804898a:	29 c1                	sub    %eax,%ecx
 804898c:	89 c8                	mov    %ecx,%eax
 804898e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048993:	8b 40 0c             	mov    0xc(%eax),%eax
 8048996:	01 c2                	add    %eax,%edx
 8048998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804899b:	c1 e0 02             	shl    $0x2,%eax
 804899e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489a5:	29 c1                	sub    %eax,%ecx
 80489a7:	89 c8                	mov    %ecx,%eax
 80489a9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489ae:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
 80489b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489b4:	c1 e0 02             	shl    $0x2,%eax
 80489b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489be:	29 c2                	sub    %eax,%edx
 80489c0:	89 d0                	mov    %edx,%eax
 80489c2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489c7:	8b 48 08             	mov    0x8(%eax),%ecx
 80489ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489cd:	89 c2                	mov    %eax,%edx
 80489cf:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80489d6:	89 c2                	mov    %eax,%edx
 80489d8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80489df:	29 d0                	sub    %edx,%eax
 80489e1:	83 c0 10             	add    $0x10,%eax
 80489e4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489e9:	8b 00                	mov    (%eax),%eax
 80489eb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 80489ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489f1:	c1 e0 02             	shl    $0x2,%eax
 80489f4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489fb:	29 c1                	sub    %eax,%ecx
 80489fd:	89 c8                	mov    %ecx,%eax
 80489ff:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a04:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
 8048a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a0a:	c1 e0 02             	shl    $0x2,%eax
 8048a0d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a14:	29 c2                	sub    %eax,%edx
 8048a16:	89 d0                	mov    %edx,%eax
 8048a18:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a1d:	8b 40 04             	mov    0x4(%eax),%eax
 8048a20:	83 f8 09             	cmp    $0x9,%eax
 8048a23:	7f 35                	jg     8048a5a <drawMonster+0x134>
 8048a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a28:	c1 e0 02             	shl    $0x2,%eax
 8048a2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a32:	29 c2                	sub    %eax,%edx
 8048a34:	89 d0                	mov    %edx,%eax
 8048a36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a3b:	8b 40 04             	mov    0x4(%eax),%eax
 8048a3e:	8d 50 01             	lea    0x1(%eax),%edx
 8048a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a44:	c1 e0 02             	shl    $0x2,%eax
 8048a47:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a4e:	29 c1                	sub    %eax,%ecx
 8048a50:	89 c8                	mov    %ecx,%eax
 8048a52:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a57:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
 8048a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a5d:	c1 e0 02             	shl    $0x2,%eax
 8048a60:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a67:	29 c2                	sub    %eax,%edx
 8048a69:	89 d0                	mov    %edx,%eax
 8048a6b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a70:	8b 40 04             	mov    0x4(%eax),%eax
 8048a73:	3d 36 01 00 00       	cmp    $0x136,%eax
 8048a78:	7e 35                	jle    8048aaf <drawMonster+0x189>
 8048a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a7d:	c1 e0 02             	shl    $0x2,%eax
 8048a80:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a87:	29 c2                	sub    %eax,%edx
 8048a89:	89 d0                	mov    %edx,%eax
 8048a8b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a90:	8b 40 04             	mov    0x4(%eax),%eax
 8048a93:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a99:	c1 e0 02             	shl    $0x2,%eax
 8048a9c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048aa3:	29 c1                	sub    %eax,%ecx
 8048aa5:	89 c8                	mov    %ecx,%eax
 8048aa7:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aac:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
 8048aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ab2:	c1 e0 02             	shl    $0x2,%eax
 8048ab5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048abc:	29 c2                	sub    %eax,%edx
 8048abe:	89 d0                	mov    %edx,%eax
 8048ac0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ac5:	8b 40 08             	mov    0x8(%eax),%eax
 8048ac8:	83 f8 09             	cmp    $0x9,%eax
 8048acb:	7f 35                	jg     8048b02 <drawMonster+0x1dc>
 8048acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ad0:	c1 e0 02             	shl    $0x2,%eax
 8048ad3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ada:	29 c2                	sub    %eax,%edx
 8048adc:	89 d0                	mov    %edx,%eax
 8048ade:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ae3:	8b 40 08             	mov    0x8(%eax),%eax
 8048ae6:	8d 50 01             	lea    0x1(%eax),%edx
 8048ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048aec:	c1 e0 02             	shl    $0x2,%eax
 8048aef:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048af6:	29 c1                	sub    %eax,%ecx
 8048af8:	89 c8                	mov    %ecx,%eax
 8048afa:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aff:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
 8048b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b05:	c1 e0 02             	shl    $0x2,%eax
 8048b08:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b0f:	29 c2                	sub    %eax,%edx
 8048b11:	89 d0                	mov    %edx,%eax
 8048b13:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b18:	8b 40 08             	mov    0x8(%eax),%eax
 8048b1b:	3d be 00 00 00       	cmp    $0xbe,%eax
 8048b20:	7e 35                	jle    8048b57 <drawMonster+0x231>
 8048b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b25:	c1 e0 02             	shl    $0x2,%eax
 8048b28:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b2f:	29 c2                	sub    %eax,%edx
 8048b31:	89 d0                	mov    %edx,%eax
 8048b33:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b38:	8b 40 08             	mov    0x8(%eax),%eax
 8048b3b:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b41:	c1 e0 02             	shl    $0x2,%eax
 8048b44:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048b4b:	29 c1                	sub    %eax,%ecx
 8048b4d:	89 c8                	mov    %ecx,%eax
 8048b4f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b54:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
 8048b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b5a:	c1 e0 02             	shl    $0x2,%eax
 8048b5d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b64:	29 c2                	sub    %eax,%edx
 8048b66:	89 d0                	mov    %edx,%eax
 8048b68:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b6d:	8b 10                	mov    (%eax),%edx
 8048b6f:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048b74:	39 c2                	cmp    %eax,%edx
 8048b76:	7f 07                	jg     8048b7f <drawMonster+0x259>
 8048b78:	b8 0f 00 00 00       	mov    $0xf,%eax
 8048b7d:	eb 05                	jmp    8048b84 <drawMonster+0x25e>
 8048b7f:	b8 05 00 00 00       	mov    $0x5,%eax
 8048b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
 8048b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048b8a:	0f b6 d8             	movzbl %al,%ebx
 8048b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b90:	c1 e0 02             	shl    $0x2,%eax
 8048b93:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b9a:	29 c2                	sub    %eax,%edx
 8048b9c:	89 d0                	mov    %edx,%eax
 8048b9e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ba3:	8b 08                	mov    (%eax),%ecx
 8048ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ba8:	c1 e0 02             	shl    $0x2,%eax
 8048bab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048bb2:	29 c2                	sub    %eax,%edx
 8048bb4:	89 d0                	mov    %edx,%eax
 8048bb6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bbb:	8b 50 08             	mov    0x8(%eax),%edx
 8048bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bc1:	c1 e0 02             	shl    $0x2,%eax
 8048bc4:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
 8048bcb:	29 c6                	sub    %eax,%esi
 8048bcd:	89 f0                	mov    %esi,%eax
 8048bcf:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bd4:	8b 40 04             	mov    0x4(%eax),%eax
 8048bd7:	53                   	push   %ebx
 8048bd8:	51                   	push   %ecx
 8048bd9:	52                   	push   %edx
 8048bda:	50                   	push   %eax
 8048bdb:	e8 f5 f7 ff ff       	call   80483d5 <drawCirc>
 8048be0:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
 8048be3:	e8 ac f4 ff ff       	call   8048094 <UKISS>
 8048be8:	89 c2                	mov    %eax,%edx
 8048bea:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048bef:	01 c2                	add    %eax,%edx
 8048bf1:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048bf6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048bf9:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048bfe:	89 c8                	mov    %ecx,%eax
 8048c00:	f7 e2                	mul    %edx
 8048c02:	89 d0                	mov    %edx,%eax
 8048c04:	c1 e8 05             	shr    $0x5,%eax
 8048c07:	89 c2                	mov    %eax,%edx
 8048c09:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c10:	89 c2                	mov    %eax,%edx
 8048c12:	89 d0                	mov    %edx,%eax
 8048c14:	c1 e0 04             	shl    $0x4,%eax
 8048c17:	29 d0                	sub    %edx,%eax
 8048c19:	29 c1                	sub    %eax,%ecx
 8048c1b:	89 c8                	mov    %ecx,%eax
 8048c1d:	85 c0                	test   %eax,%eax
 8048c1f:	0f 85 9a 00 00 00    	jne    8048cbf <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
 8048c25:	e8 6a f4 ff ff       	call   8048094 <UKISS>
 8048c2a:	89 c2                	mov    %eax,%edx
 8048c2c:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c31:	01 c2                	add    %eax,%edx
 8048c33:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c38:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c3b:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048c40:	89 c8                	mov    %ecx,%eax
 8048c42:	f7 e2                	mul    %edx
 8048c44:	d1 ea                	shr    %edx
 8048c46:	89 d0                	mov    %edx,%eax
 8048c48:	01 c0                	add    %eax,%eax
 8048c4a:	01 d0                	add    %edx,%eax
 8048c4c:	29 c1                	sub    %eax,%ecx
 8048c4e:	89 ca                	mov    %ecx,%edx
 8048c50:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048c53:	89 c1                	mov    %eax,%ecx
 8048c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c58:	c1 e0 02             	shl    $0x2,%eax
 8048c5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048c62:	29 c2                	sub    %eax,%edx
 8048c64:	89 d0                	mov    %edx,%eax
 8048c66:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c6b:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
 8048c6e:	e8 21 f4 ff ff       	call   8048094 <UKISS>
 8048c73:	89 c2                	mov    %eax,%edx
 8048c75:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c7a:	01 c2                	add    %eax,%edx
 8048c7c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c81:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c84:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048c89:	89 c8                	mov    %ecx,%eax
 8048c8b:	f7 e2                	mul    %edx
 8048c8d:	d1 ea                	shr    %edx
 8048c8f:	89 d0                	mov    %edx,%eax
 8048c91:	01 c0                	add    %eax,%eax
 8048c93:	01 d0                	add    %edx,%eax
 8048c95:	29 c1                	sub    %eax,%ecx
 8048c97:	89 ca                	mov    %ecx,%edx
 8048c99:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048c9c:	89 c1                	mov    %eax,%ecx
 8048c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ca1:	89 c2                	mov    %eax,%edx
 8048ca3:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048caa:	89 c2                	mov    %eax,%edx
 8048cac:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048cb3:	29 d0                	sub    %edx,%eax
 8048cb5:	83 c0 10             	add    $0x10,%eax
 8048cb8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048cbd:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
 8048cbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048cc3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048cc7:	0f 8e 6d fc ff ff    	jle    804893a <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
 8048ccd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8048cd0:	5b                   	pop    %ebx
 8048cd1:	5e                   	pop    %esi
 8048cd2:	5d                   	pop    %ebp
 8048cd3:	c3                   	ret    

08048cd4 <createMonster>:
void createMonster(){
 8048cd4:	55                   	push   %ebp
 8048cd5:	89 e5                	mov    %esp,%ebp
 8048cd7:	83 ec 18             	sub    $0x18,%esp
	int i=0;
 8048cda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048ce1:	e9 e0 01 00 00       	jmp    8048ec6 <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
 8048ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ce9:	89 c2                	mov    %eax,%edx
 8048ceb:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048cf2:	89 c2                	mov    %eax,%edx
 8048cf4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048cfb:	29 d0                	sub    %edx,%eax
 8048cfd:	83 c0 10             	add    $0x10,%eax
 8048d00:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d05:	8b 40 04             	mov    0x4(%eax),%eax
 8048d08:	85 c0                	test   %eax,%eax
 8048d0a:	75 05                	jne    8048d11 <createMonster+0x3d>
 8048d0c:	e9 b1 01 00 00       	jmp    8048ec2 <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
 8048d11:	e8 7e f3 ff ff       	call   8048094 <UKISS>
 8048d16:	89 c2                	mov    %eax,%edx
 8048d18:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d1d:	01 c2                	add    %eax,%edx
 8048d1f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d24:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048d27:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
 8048d2c:	89 c8                	mov    %ecx,%eax
 8048d2e:	f7 e2                	mul    %edx
 8048d30:	89 d0                	mov    %edx,%eax
 8048d32:	c1 e8 0c             	shr    $0xc,%eax
 8048d35:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
 8048d3b:	29 c1                	sub    %eax,%ecx
 8048d3d:	89 c8                	mov    %ecx,%eax
 8048d3f:	85 c0                	test   %eax,%eax
 8048d41:	0f 85 7b 01 00 00    	jne    8048ec2 <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
 8048d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d4a:	89 c2                	mov    %eax,%edx
 8048d4c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048d53:	89 c2                	mov    %eax,%edx
 8048d55:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048d5c:	29 d0                	sub    %edx,%eax
 8048d5e:	83 c0 10             	add    $0x10,%eax
 8048d61:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
 8048d6d:	e8 22 f3 ff ff       	call   8048094 <UKISS>
 8048d72:	89 c2                	mov    %eax,%edx
 8048d74:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d79:	01 c2                	add    %eax,%edx
 8048d7b:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d80:	01 d0                	add    %edx,%eax
 8048d82:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048d88:	89 d1                	mov    %edx,%ecx
 8048d8a:	ba 00 00 00 00       	mov    $0x0,%edx
 8048d8f:	f7 f1                	div    %ecx
 8048d91:	89 d0                	mov    %edx,%eax
 8048d93:	83 c0 01             	add    $0x1,%eax
 8048d96:	01 c0                	add    %eax,%eax
 8048d98:	89 c1                	mov    %eax,%ecx
 8048d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d9d:	c1 e0 02             	shl    $0x2,%eax
 8048da0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048da7:	29 c2                	sub    %eax,%edx
 8048da9:	89 d0                	mov    %edx,%eax
 8048dab:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048db0:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
 8048db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048db5:	c1 e0 02             	shl    $0x2,%eax
 8048db8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048dbf:	29 c2                	sub    %eax,%edx
 8048dc1:	89 d0                	mov    %edx,%eax
 8048dc3:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dc8:	8b 00                	mov    (%eax),%eax
 8048dca:	89 c2                	mov    %eax,%edx
 8048dcc:	83 fa 0e             	cmp    $0xe,%edx
 8048dcf:	7e 05                	jle    8048dd6 <createMonster+0x102>
 8048dd1:	ba 0e 00 00 00       	mov    $0xe,%edx
 8048dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dd9:	c1 e0 02             	shl    $0x2,%eax
 8048ddc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048de3:	29 c1                	sub    %eax,%ecx
 8048de5:	89 c8                	mov    %ecx,%eax
 8048de7:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dec:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
 8048dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048df1:	c1 e0 02             	shl    $0x2,%eax
 8048df4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048dfb:	29 c2                	sub    %eax,%edx
 8048dfd:	89 d0                	mov    %edx,%eax
 8048dff:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e04:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
 8048e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e0e:	c1 e0 02             	shl    $0x2,%eax
 8048e11:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048e18:	29 c2                	sub    %eax,%edx
 8048e1a:	89 d0                	mov    %edx,%eax
 8048e1c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e21:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
 8048e28:	e8 67 f2 ff ff       	call   8048094 <UKISS>
 8048e2d:	89 c2                	mov    %eax,%edx
 8048e2f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e34:	01 c2                	add    %eax,%edx
 8048e36:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e3b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048e3e:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048e43:	89 c8                	mov    %ecx,%eax
 8048e45:	f7 e2                	mul    %edx
 8048e47:	d1 ea                	shr    %edx
 8048e49:	89 d0                	mov    %edx,%eax
 8048e4b:	01 c0                	add    %eax,%eax
 8048e4d:	01 d0                	add    %edx,%eax
 8048e4f:	29 c1                	sub    %eax,%ecx
 8048e51:	89 ca                	mov    %ecx,%edx
 8048e53:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048e56:	89 c1                	mov    %eax,%ecx
 8048e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e5b:	c1 e0 02             	shl    $0x2,%eax
 8048e5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048e65:	29 c2                	sub    %eax,%edx
 8048e67:	89 d0                	mov    %edx,%eax
 8048e69:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e6e:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
 8048e71:	e8 1e f2 ff ff       	call   8048094 <UKISS>
 8048e76:	89 c2                	mov    %eax,%edx
 8048e78:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e7d:	01 c2                	add    %eax,%edx
 8048e7f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e84:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048e87:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048e8c:	89 c8                	mov    %ecx,%eax
 8048e8e:	f7 e2                	mul    %edx
 8048e90:	d1 ea                	shr    %edx
 8048e92:	89 d0                	mov    %edx,%eax
 8048e94:	01 c0                	add    %eax,%eax
 8048e96:	01 d0                	add    %edx,%eax
 8048e98:	29 c1                	sub    %eax,%ecx
 8048e9a:	89 ca                	mov    %ecx,%edx
 8048e9c:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048e9f:	89 c1                	mov    %eax,%ecx
 8048ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ea4:	89 c2                	mov    %eax,%edx
 8048ea6:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048ead:	89 c2                	mov    %eax,%edx
 8048eaf:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048eb6:	29 d0                	sub    %edx,%eax
 8048eb8:	83 c0 10             	add    $0x10,%eax
 8048ebb:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ec0:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
 8048ec2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048ec6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048eca:	0f 8e 16 fe ff ff    	jle    8048ce6 <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
 8048ed0:	c9                   	leave  
 8048ed1:	c3                   	ret    

08048ed2 <dreamOf100HZ>:

void dreamOf100HZ(int timestamp){
 8048ed2:	55                   	push   %ebp
 8048ed3:	89 e5                	mov    %esp,%ebp
 8048ed5:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(key('l')){
 8048ed8:	6a 6c                	push   $0x6c
 8048eda:	e8 a1 f7 ff ff       	call   8048680 <key>
 8048edf:	83 c4 04             	add    $0x4,%esp
 8048ee2:	84 c0                	test   %al,%al
 8048ee4:	74 23                	je     8048f09 <dreamOf100HZ+0x37>
		printf("GAME#%d: Sleep 5s!\n", getpid());
 8048ee6:	e8 ab f2 ff ff       	call   8048196 <sys_pid>
 8048eeb:	83 ec 08             	sub    $0x8,%esp
 8048eee:	50                   	push   %eax
 8048eef:	68 0e a2 04 08       	push   $0x804a20e
 8048ef4:	e8 8b 09 00 00       	call   8049884 <printf>
 8048ef9:	83 c4 10             	add    $0x10,%esp
		sleep(5);
 8048efc:	83 ec 0c             	sub    $0xc,%esp
 8048eff:	6a 05                	push   $0x5
 8048f01:	e8 ac f2 ff ff       	call   80481b2 <sys_sleep>
 8048f06:	83 c4 10             	add    $0x10,%esp
	}
	if(key('m')){
 8048f09:	83 ec 0c             	sub    $0xc,%esp
 8048f0c:	6a 6d                	push   $0x6d
 8048f0e:	e8 6d f7 ff ff       	call   8048680 <key>
 8048f13:	83 c4 10             	add    $0x10,%esp
 8048f16:	84 c0                	test   %al,%al
 8048f18:	74 25                	je     8048f3f <dreamOf100HZ+0x6d>
		clearStage();
 8048f1a:	e8 ea f3 ff ff       	call   8048309 <clearStage>
		drawStage();
 8048f1f:	e8 37 f7 ff ff       	call   804865b <drawStage>
		printf("GAME#%d: Ready to exit! Bye!\n", getpid());
 8048f24:	e8 6d f2 ff ff       	call   8048196 <sys_pid>
 8048f29:	83 ec 08             	sub    $0x8,%esp
 8048f2c:	50                   	push   %eax
 8048f2d:	68 22 a2 04 08       	push   $0x804a222
 8048f32:	e8 4d 09 00 00       	call   8049884 <printf>
 8048f37:	83 c4 10             	add    $0x10,%esp
		exit();
 8048f3a:	e8 28 f2 ff ff       	call   8048167 <sys_exit>
	}
	if(gameStatus == GAME_START){
 8048f3f:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8048f44:	85 c0                	test   %eax,%eax
 8048f46:	0f 85 2b 04 00 00    	jne    8049377 <dreamOf100HZ+0x4a5>
		//printf("%x\n", st);
		//printf("Score: %d\n", curtime);
		clearStage();
 8048f4c:	e8 b8 f3 ff ff       	call   8048309 <clearStage>
		drawText1();
 8048f51:	e8 2c f5 ff ff       	call   8048482 <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
 8048f56:	e8 00 f7 ff ff       	call   804865b <drawStage>

		int i=0;
 8048f5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
 8048f62:	c7 05 2c ba 04 08 1e 	movl   $0x1e,0x804ba2c
 8048f69:	00 00 00 
		y = 30;
 8048f6c:	c7 05 30 ba 04 08 1e 	movl   $0x1e,0x804ba30
 8048f73:	00 00 00 
		size = 4;
 8048f76:	c7 05 34 ba 04 08 04 	movl   $0x4,0x804ba34
 8048f7d:	00 00 00 
		score = 0;
 8048f80:	c7 05 24 ba 04 08 00 	movl   $0x0,0x804ba24
 8048f87:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
 8048f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f8d:	89 c2                	mov    %eax,%edx
 8048f8f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048f96:	89 c2                	mov    %eax,%edx
 8048f98:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048f9f:	29 d0                	sub    %edx,%eax
 8048fa1:	83 c0 10             	add    $0x10,%eax
 8048fa4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
 8048fb0:	e8 df f0 ff ff       	call   8048094 <UKISS>
 8048fb5:	89 c2                	mov    %eax,%edx
 8048fb7:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048fbc:	01 c2                	add    %eax,%edx
 8048fbe:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048fc3:	01 d0                	add    %edx,%eax
 8048fc5:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048fcb:	89 d1                	mov    %edx,%ecx
 8048fcd:	ba 00 00 00 00       	mov    $0x0,%edx
 8048fd2:	f7 f1                	div    %ecx
 8048fd4:	89 d0                	mov    %edx,%eax
 8048fd6:	83 c0 01             	add    $0x1,%eax
 8048fd9:	89 c1                	mov    %eax,%ecx
 8048fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fde:	c1 e0 02             	shl    $0x2,%eax
 8048fe1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048fe8:	29 c2                	sub    %eax,%edx
 8048fea:	89 d0                	mov    %edx,%eax
 8048fec:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ff1:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
 8048ff3:	e8 9c f0 ff ff       	call   8048094 <UKISS>
 8048ff8:	89 c2                	mov    %eax,%edx
 8048ffa:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048fff:	01 c2                	add    %eax,%edx
 8049001:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049006:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049009:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804900e:	89 c8                	mov    %ecx,%eax
 8049010:	f7 e2                	mul    %edx
 8049012:	c1 ea 08             	shr    $0x8,%edx
 8049015:	89 d0                	mov    %edx,%eax
 8049017:	c1 e0 02             	shl    $0x2,%eax
 804901a:	01 d0                	add    %edx,%eax
 804901c:	c1 e0 06             	shl    $0x6,%eax
 804901f:	29 c1                	sub    %eax,%ecx
 8049021:	89 ca                	mov    %ecx,%edx
 8049023:	89 d1                	mov    %edx,%ecx
 8049025:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049028:	c1 e0 02             	shl    $0x2,%eax
 804902b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049032:	29 c2                	sub    %eax,%edx
 8049034:	89 d0                	mov    %edx,%eax
 8049036:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804903b:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
 804903e:	e8 51 f0 ff ff       	call   8048094 <UKISS>
 8049043:	89 c2                	mov    %eax,%edx
 8049045:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804904a:	01 c2                	add    %eax,%edx
 804904c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049051:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049054:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8049059:	89 c8                	mov    %ecx,%eax
 804905b:	f7 e2                	mul    %edx
 804905d:	89 d0                	mov    %edx,%eax
 804905f:	c1 e8 06             	shr    $0x6,%eax
 8049062:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8049068:	29 c1                	sub    %eax,%ecx
 804906a:	89 c8                	mov    %ecx,%eax
 804906c:	89 c1                	mov    %eax,%ecx
 804906e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049071:	c1 e0 02             	shl    $0x2,%eax
 8049074:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804907b:	29 c2                	sub    %eax,%edx
 804907d:	89 d0                	mov    %edx,%eax
 804907f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049084:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
 8049087:	e8 08 f0 ff ff       	call   8048094 <UKISS>
 804908c:	89 c2                	mov    %eax,%edx
 804908e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049093:	01 c2                	add    %eax,%edx
 8049095:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804909a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804909d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80490a2:	89 c8                	mov    %ecx,%eax
 80490a4:	f7 e2                	mul    %edx
 80490a6:	d1 ea                	shr    %edx
 80490a8:	89 d0                	mov    %edx,%eax
 80490aa:	01 c0                	add    %eax,%eax
 80490ac:	01 d0                	add    %edx,%eax
 80490ae:	29 c1                	sub    %eax,%ecx
 80490b0:	89 ca                	mov    %ecx,%edx
 80490b2:	8d 42 ff             	lea    -0x1(%edx),%eax
 80490b5:	89 c1                	mov    %eax,%ecx
 80490b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80490ba:	c1 e0 02             	shl    $0x2,%eax
 80490bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80490c4:	29 c2                	sub    %eax,%edx
 80490c6:	89 d0                	mov    %edx,%eax
 80490c8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490cd:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
 80490d0:	e8 bf ef ff ff       	call   8048094 <UKISS>
 80490d5:	89 c2                	mov    %eax,%edx
 80490d7:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80490dc:	01 c2                	add    %eax,%edx
 80490de:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80490e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80490e6:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80490eb:	89 c8                	mov    %ecx,%eax
 80490ed:	f7 e2                	mul    %edx
 80490ef:	d1 ea                	shr    %edx
 80490f1:	89 d0                	mov    %edx,%eax
 80490f3:	01 c0                	add    %eax,%eax
 80490f5:	01 d0                	add    %edx,%eax
 80490f7:	29 c1                	sub    %eax,%ecx
 80490f9:	89 ca                	mov    %ecx,%edx
 80490fb:	8d 42 ff             	lea    -0x1(%edx),%eax
 80490fe:	89 c1                	mov    %eax,%ecx
 8049100:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049103:	89 c2                	mov    %eax,%edx
 8049105:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804910c:	89 c2                	mov    %eax,%edx
 804910e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049115:	29 d0                	sub    %edx,%eax
 8049117:	83 c0 10             	add    $0x10,%eax
 804911a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804911f:	89 08                	mov    %ecx,(%eax)
		i++;
 8049121:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
 8049125:	e9 29 02 00 00       	jmp    8049353 <dreamOf100HZ+0x481>
			monsters[i].status = MONSTER_SLEEP;
 804912a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804912d:	89 c2                	mov    %eax,%edx
 804912f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049136:	89 c2                	mov    %eax,%edx
 8049138:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804913f:	29 d0                	sub    %edx,%eax
 8049141:	83 c0 10             	add    $0x10,%eax
 8049144:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049149:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
 8049150:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049153:	89 c2                	mov    %eax,%edx
 8049155:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804915c:	89 c2                	mov    %eax,%edx
 804915e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049165:	29 d0                	sub    %edx,%eax
 8049167:	83 c0 10             	add    $0x10,%eax
 804916a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804916f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
 8049176:	e8 19 ef ff ff       	call   8048094 <UKISS>
 804917b:	89 c2                	mov    %eax,%edx
 804917d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049182:	01 c2                	add    %eax,%edx
 8049184:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049189:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804918c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8049191:	89 c8                	mov    %ecx,%eax
 8049193:	f7 e2                	mul    %edx
 8049195:	c1 ea 04             	shr    $0x4,%edx
 8049198:	89 d0                	mov    %edx,%eax
 804919a:	c1 e0 02             	shl    $0x2,%eax
 804919d:	01 d0                	add    %edx,%eax
 804919f:	c1 e0 02             	shl    $0x2,%eax
 80491a2:	29 c1                	sub    %eax,%ecx
 80491a4:	89 ca                	mov    %ecx,%edx
 80491a6:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80491ab:	83 c0 03             	add    $0x3,%eax
 80491ae:	39 c2                	cmp    %eax,%edx
 80491b0:	0f 83 99 01 00 00    	jae    804934f <dreamOf100HZ+0x47d>
				monsters[i].status = MONSTER_ALIVE;
 80491b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491b9:	89 c2                	mov    %eax,%edx
 80491bb:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80491c2:	89 c2                	mov    %eax,%edx
 80491c4:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80491cb:	29 d0                	sub    %edx,%eax
 80491cd:	83 c0 10             	add    $0x10,%eax
 80491d0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
 80491dc:	e8 b3 ee ff ff       	call   8048094 <UKISS>
 80491e1:	89 c2                	mov    %eax,%edx
 80491e3:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80491e8:	01 c2                	add    %eax,%edx
 80491ea:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80491ef:	01 d0                	add    %edx,%eax
 80491f1:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 80491f7:	89 d1                	mov    %edx,%ecx
 80491f9:	ba 00 00 00 00       	mov    $0x0,%edx
 80491fe:	f7 f1                	div    %ecx
 8049200:	89 d0                	mov    %edx,%eax
 8049202:	01 c0                	add    %eax,%eax
 8049204:	83 c0 01             	add    $0x1,%eax
 8049207:	89 c1                	mov    %eax,%ecx
 8049209:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804920c:	c1 e0 02             	shl    $0x2,%eax
 804920f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049216:	29 c2                	sub    %eax,%edx
 8049218:	89 d0                	mov    %edx,%eax
 804921a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804921f:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
 8049221:	e8 6e ee ff ff       	call   8048094 <UKISS>
 8049226:	89 c2                	mov    %eax,%edx
 8049228:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804922d:	01 c2                	add    %eax,%edx
 804922f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049234:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049237:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804923c:	89 c8                	mov    %ecx,%eax
 804923e:	f7 e2                	mul    %edx
 8049240:	c1 ea 08             	shr    $0x8,%edx
 8049243:	89 d0                	mov    %edx,%eax
 8049245:	c1 e0 02             	shl    $0x2,%eax
 8049248:	01 d0                	add    %edx,%eax
 804924a:	c1 e0 06             	shl    $0x6,%eax
 804924d:	29 c1                	sub    %eax,%ecx
 804924f:	89 ca                	mov    %ecx,%edx
 8049251:	89 d1                	mov    %edx,%ecx
 8049253:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049256:	c1 e0 02             	shl    $0x2,%eax
 8049259:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049260:	29 c2                	sub    %eax,%edx
 8049262:	89 d0                	mov    %edx,%eax
 8049264:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049269:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
 804926c:	e8 23 ee ff ff       	call   8048094 <UKISS>
 8049271:	89 c2                	mov    %eax,%edx
 8049273:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049278:	01 c2                	add    %eax,%edx
 804927a:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804927f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049282:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8049287:	89 c8                	mov    %ecx,%eax
 8049289:	f7 e2                	mul    %edx
 804928b:	89 d0                	mov    %edx,%eax
 804928d:	c1 e8 06             	shr    $0x6,%eax
 8049290:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8049296:	29 c1                	sub    %eax,%ecx
 8049298:	89 c8                	mov    %ecx,%eax
 804929a:	89 c1                	mov    %eax,%ecx
 804929c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804929f:	c1 e0 02             	shl    $0x2,%eax
 80492a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80492a9:	29 c2                	sub    %eax,%edx
 80492ab:	89 d0                	mov    %edx,%eax
 80492ad:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80492b2:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
 80492b5:	e8 da ed ff ff       	call   8048094 <UKISS>
 80492ba:	89 c2                	mov    %eax,%edx
 80492bc:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80492c1:	01 c2                	add    %eax,%edx
 80492c3:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492c8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80492cb:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80492d0:	89 c8                	mov    %ecx,%eax
 80492d2:	f7 e2                	mul    %edx
 80492d4:	d1 ea                	shr    %edx
 80492d6:	89 d0                	mov    %edx,%eax
 80492d8:	01 c0                	add    %eax,%eax
 80492da:	01 d0                	add    %edx,%eax
 80492dc:	29 c1                	sub    %eax,%ecx
 80492de:	89 ca                	mov    %ecx,%edx
 80492e0:	8d 42 ff             	lea    -0x1(%edx),%eax
 80492e3:	89 c1                	mov    %eax,%ecx
 80492e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80492e8:	c1 e0 02             	shl    $0x2,%eax
 80492eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80492f2:	29 c2                	sub    %eax,%edx
 80492f4:	89 d0                	mov    %edx,%eax
 80492f6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80492fb:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
 80492fe:	e8 91 ed ff ff       	call   8048094 <UKISS>
 8049303:	89 c2                	mov    %eax,%edx
 8049305:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804930a:	01 c2                	add    %eax,%edx
 804930c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049311:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049314:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049319:	89 c8                	mov    %ecx,%eax
 804931b:	f7 e2                	mul    %edx
 804931d:	d1 ea                	shr    %edx
 804931f:	89 d0                	mov    %edx,%eax
 8049321:	01 c0                	add    %eax,%eax
 8049323:	01 d0                	add    %edx,%eax
 8049325:	29 c1                	sub    %eax,%ecx
 8049327:	89 ca                	mov    %ecx,%edx
 8049329:	8d 42 ff             	lea    -0x1(%edx),%eax
 804932c:	89 c1                	mov    %eax,%ecx
 804932e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049331:	89 c2                	mov    %eax,%edx
 8049333:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804933a:	89 c2                	mov    %eax,%edx
 804933c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049343:	29 d0                	sub    %edx,%eax
 8049345:	83 c0 10             	add    $0x10,%eax
 8049348:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804934d:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
 804934f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049353:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8049357:	0f 8e cd fd ff ff    	jle    804912a <dreamOf100HZ+0x258>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
 804935d:	83 ec 0c             	sub    $0xc,%esp
 8049360:	68 40 a2 04 08       	push   $0x804a240
 8049365:	e8 1a 05 00 00       	call   8049884 <printf>
 804936a:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
 804936d:	c7 05 28 ba 04 08 01 	movl   $0x1,0x804ba28
 8049374:	00 00 00 
	}
	if(gameStatus == GAME_READY){
 8049377:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 804937c:	83 f8 01             	cmp    $0x1,%eax
 804937f:	75 30                	jne    80493b1 <dreamOf100HZ+0x4df>
		//printf("%d\n", key('q'));
		if(key('q')){
 8049381:	83 ec 0c             	sub    $0xc,%esp
 8049384:	6a 71                	push   $0x71
 8049386:	e8 f5 f2 ff ff       	call   8048680 <key>
 804938b:	83 c4 10             	add    $0x10,%esp
 804938e:	84 c0                	test   %al,%al
 8049390:	74 1f                	je     80493b1 <dreamOf100HZ+0x4df>
			printf("Press W, A, S, D to move\n");
 8049392:	83 ec 0c             	sub    $0xc,%esp
 8049395:	68 52 a2 04 08       	push   $0x804a252
 804939a:	e8 e5 04 00 00       	call   8049884 <printf>
 804939f:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
 80493a2:	c7 05 28 ba 04 08 02 	movl   $0x2,0x804ba28
 80493a9:	00 00 00 
			return;
 80493ac:	e9 e4 01 00 00       	jmp    8049595 <dreamOf100HZ+0x6c3>
		}
		
	}

	if(gameStatus == GAME_ING){
 80493b1:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 80493b6:	83 f8 02             	cmp    $0x2,%eax
 80493b9:	0f 85 92 01 00 00    	jne    8049551 <dreamOf100HZ+0x67f>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
		if(key('a'))x--;
 80493bf:	83 ec 0c             	sub    $0xc,%esp
 80493c2:	6a 61                	push   $0x61
 80493c4:	e8 b7 f2 ff ff       	call   8048680 <key>
 80493c9:	83 c4 10             	add    $0x10,%esp
 80493cc:	84 c0                	test   %al,%al
 80493ce:	74 0d                	je     80493dd <dreamOf100HZ+0x50b>
 80493d0:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80493d5:	83 e8 01             	sub    $0x1,%eax
 80493d8:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('d'))x++;
 80493dd:	83 ec 0c             	sub    $0xc,%esp
 80493e0:	6a 64                	push   $0x64
 80493e2:	e8 99 f2 ff ff       	call   8048680 <key>
 80493e7:	83 c4 10             	add    $0x10,%esp
 80493ea:	84 c0                	test   %al,%al
 80493ec:	74 0d                	je     80493fb <dreamOf100HZ+0x529>
 80493ee:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80493f3:	83 c0 01             	add    $0x1,%eax
 80493f6:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('w'))y--;
 80493fb:	83 ec 0c             	sub    $0xc,%esp
 80493fe:	6a 77                	push   $0x77
 8049400:	e8 7b f2 ff ff       	call   8048680 <key>
 8049405:	83 c4 10             	add    $0x10,%esp
 8049408:	84 c0                	test   %al,%al
 804940a:	74 0d                	je     8049419 <dreamOf100HZ+0x547>
 804940c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049411:	83 e8 01             	sub    $0x1,%eax
 8049414:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(key('s'))y++;
 8049419:	83 ec 0c             	sub    $0xc,%esp
 804941c:	6a 73                	push   $0x73
 804941e:	e8 5d f2 ff ff       	call   8048680 <key>
 8049423:	83 c4 10             	add    $0x10,%esp
 8049426:	84 c0                	test   %al,%al
 8049428:	74 0d                	je     8049437 <dreamOf100HZ+0x565>
 804942a:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804942f:	83 c0 01             	add    $0x1,%eax
 8049432:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		if(x < 0) x++;
 8049437:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804943c:	85 c0                	test   %eax,%eax
 804943e:	79 0d                	jns    804944d <dreamOf100HZ+0x57b>
 8049440:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049445:	83 c0 01             	add    $0x1,%eax
 8049448:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(x > VWIDTH) x--;
 804944d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049452:	3d 40 01 00 00       	cmp    $0x140,%eax
 8049457:	7e 0d                	jle    8049466 <dreamOf100HZ+0x594>
 8049459:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804945e:	83 e8 01             	sub    $0x1,%eax
 8049461:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(y < 0) y++;
 8049466:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804946b:	85 c0                	test   %eax,%eax
 804946d:	79 0d                	jns    804947c <dreamOf100HZ+0x5aa>
 804946f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049474:	83 c0 01             	add    $0x1,%eax
 8049477:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(y > VHEIGHT) y--;
 804947c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049481:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049486:	7e 0d                	jle    8049495 <dreamOf100HZ+0x5c3>
 8049488:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804948d:	83 e8 01             	sub    $0x1,%eax
 8049490:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		//else{
		clearStage();
 8049495:	e8 6f ee ff ff       	call   8048309 <clearStage>
		drawCirc(x, y, size, 3);
 804949a:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 80494a0:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80494a6:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80494ab:	6a 03                	push   $0x3
 80494ad:	51                   	push   %ecx
 80494ae:	52                   	push   %edx
 80494af:	50                   	push   %eax
 80494b0:	e8 20 ef ff ff       	call   80483d5 <drawCirc>
 80494b5:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
 80494b8:	e8 69 f4 ff ff       	call   8048926 <drawMonster>
		drawCirc(x, y, size, 3);
 80494bd:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 80494c3:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80494c9:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80494ce:	6a 03                	push   $0x3
 80494d0:	51                   	push   %ecx
 80494d1:	52                   	push   %edx
 80494d2:	50                   	push   %eax
 80494d3:	e8 fd ee ff ff       	call   80483d5 <drawCirc>
 80494d8:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 10, 180, 1, 7);
 80494db:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80494e0:	83 ec 0c             	sub    $0xc,%esp
 80494e3:	6a 07                	push   $0x7
 80494e5:	6a 01                	push   $0x1
 80494e7:	68 b4 00 00 00       	push   $0xb4
 80494ec:	6a 0a                	push   $0xa
 80494ee:	50                   	push   %eax
 80494ef:	e8 06 f0 ff ff       	call   80484fa <drawNumber>
 80494f4:	83 c4 20             	add    $0x20,%esp
		drawNumber(getpid(), 300, 10, 1, 7);
 80494f7:	e8 9a ec ff ff       	call   8048196 <sys_pid>
 80494fc:	83 ec 0c             	sub    $0xc,%esp
 80494ff:	6a 07                	push   $0x7
 8049501:	6a 01                	push   $0x1
 8049503:	6a 0a                	push   $0xa
 8049505:	68 2c 01 00 00       	push   $0x12c
 804950a:	50                   	push   %eax
 804950b:	e8 ea ef ff ff       	call   80484fa <drawNumber>
 8049510:	83 c4 20             	add    $0x20,%esp
		if(key('p')){
 8049513:	83 ec 0c             	sub    $0xc,%esp
 8049516:	6a 70                	push   $0x70
 8049518:	e8 63 f1 ff ff       	call   8048680 <key>
 804951d:	83 c4 10             	add    $0x10,%esp
 8049520:	84 c0                	test   %al,%al
 8049522:	74 19                	je     804953d <dreamOf100HZ+0x66b>
			drawNumber(getpid(), 100, 100, 5, 7);
 8049524:	e8 6d ec ff ff       	call   8048196 <sys_pid>
 8049529:	83 ec 0c             	sub    $0xc,%esp
 804952c:	6a 07                	push   $0x7
 804952e:	6a 05                	push   $0x5
 8049530:	6a 64                	push   $0x64
 8049532:	6a 64                	push   $0x64
 8049534:	50                   	push   %eax
 8049535:	e8 c0 ef ff ff       	call   80484fa <drawNumber>
 804953a:	83 c4 20             	add    $0x20,%esp
		}
		drawStage();
 804953d:	e8 19 f1 ff ff       	call   804865b <drawStage>
		
		
		createMonster();
 8049542:	e8 8d f7 ff ff       	call   8048cd4 <createMonster>
		while(hitMonster());
 8049547:	90                   	nop
 8049548:	e8 1a f2 ff ff       	call   8048767 <hitMonster>
 804954d:	85 c0                	test   %eax,%eax
 804954f:	75 f7                	jne    8049548 <dreamOf100HZ+0x676>
		//}
	}
	if(gameStatus == GAME_END){
 8049551:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049556:	83 f8 03             	cmp    $0x3,%eax
 8049559:	75 3a                	jne    8049595 <dreamOf100HZ+0x6c3>
		printf("You're dead\n");
 804955b:	83 ec 0c             	sub    $0xc,%esp
 804955e:	68 6c a2 04 08       	push   $0x804a26c
 8049563:	e8 1c 03 00 00       	call   8049884 <printf>
 8049568:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
 804956b:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8049570:	83 ec 08             	sub    $0x8,%esp
 8049573:	50                   	push   %eax
 8049574:	68 79 a2 04 08       	push   $0x804a279
 8049579:	e8 06 03 00 00       	call   8049884 <printf>
 804957e:	83 c4 10             	add    $0x10,%esp
		clearStage();
 8049581:	e8 83 ed ff ff       	call   8048309 <clearStage>
		drawStage();
 8049586:	e8 d0 f0 ff ff       	call   804865b <drawStage>
		gameStatus = GAME_START;
 804958b:	c7 05 28 ba 04 08 00 	movl   $0x0,0x804ba28
 8049592:	00 00 00 
	}
 8049595:	c9                   	leave  
 8049596:	c3                   	ret    

08049597 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8049597:	55                   	push   %ebp
 8049598:	89 e5                	mov    %esp,%ebp
 804959a:	53                   	push   %ebx
 804959b:	83 ec 04             	sub    $0x4,%esp
 804959e:	8b 45 08             	mov    0x8(%ebp),%eax
 80495a1:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80495a4:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80495a9:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80495ad:	89 d3                	mov    %edx,%ebx
 80495af:	cd 80                	int    $0x80
}
 80495b1:	83 c4 04             	add    $0x4,%esp
 80495b4:	5b                   	pop    %ebx
 80495b5:	5d                   	pop    %ebp
 80495b6:	c3                   	ret    

080495b7 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80495b7:	55                   	push   %ebp
 80495b8:	89 e5                	mov    %esp,%ebp
 80495ba:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80495bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80495c3:	eb 19                	jmp    80495de <printp+0x27>
		printer(cur);
 80495c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80495c8:	0f b6 00             	movzbl (%eax),%eax
 80495cb:	0f be c0             	movsbl %al,%eax
 80495ce:	83 ec 0c             	sub    $0xc,%esp
 80495d1:	50                   	push   %eax
 80495d2:	8b 45 08             	mov    0x8(%ebp),%eax
 80495d5:	ff d0                	call   *%eax
 80495d7:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80495da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80495de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80495e1:	0f b6 00             	movzbl (%eax),%eax
 80495e4:	84 c0                	test   %al,%al
 80495e6:	75 dd                	jne    80495c5 <printp+0xe>
		printer(cur);
	}
}
 80495e8:	c9                   	leave  
 80495e9:	c3                   	ret    

080495ea <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80495ea:	55                   	push   %ebp
 80495eb:	89 e5                	mov    %esp,%ebp
 80495ed:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80495f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80495f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 80495fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8049604:	8b 45 10             	mov    0x10(%ebp),%eax
 8049607:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 804960a:	e9 65 02 00 00       	jmp    8049874 <vfprintf+0x28a>

		if(cur == '%'){
 804960f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049612:	0f b6 00             	movzbl (%eax),%eax
 8049615:	3c 25                	cmp    $0x25,%al
 8049617:	75 0c                	jne    8049625 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8049619:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8049620:	e9 4b 02 00 00       	jmp    8049870 <vfprintf+0x286>
		}
		if(type == READ){
 8049625:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8049629:	0f 85 26 02 00 00    	jne    8049855 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 804962f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049632:	0f b6 00             	movzbl (%eax),%eax
 8049635:	3c 73                	cmp    $0x73,%al
 8049637:	75 35                	jne    804966e <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8049639:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804963c:	8b 00                	mov    (%eax),%eax
 804963e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8049641:	eb 19                	jmp    804965c <vfprintf+0x72>
					printer(*p);
 8049643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049646:	0f b6 00             	movzbl (%eax),%eax
 8049649:	0f be c0             	movsbl %al,%eax
 804964c:	83 ec 0c             	sub    $0xc,%esp
 804964f:	50                   	push   %eax
 8049650:	8b 45 08             	mov    0x8(%ebp),%eax
 8049653:	ff d0                	call   *%eax
 8049655:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 8049658:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 804965c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804965f:	0f b6 00             	movzbl (%eax),%eax
 8049662:	84 c0                	test   %al,%al
 8049664:	75 dd                	jne    8049643 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8049666:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804966a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 804966e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049671:	0f b6 00             	movzbl (%eax),%eax
 8049674:	3c 78                	cmp    $0x78,%al
 8049676:	0f 85 99 00 00 00    	jne    8049715 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 804967c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804967f:	8b 00                	mov    (%eax),%eax
 8049681:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8049684:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8049688:	75 1d                	jne    80496a7 <vfprintf+0xbd>
					printer('0');
 804968a:	83 ec 0c             	sub    $0xc,%esp
 804968d:	6a 30                	push   $0x30
 804968f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049692:	ff d0                	call   *%eax
 8049694:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8049697:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804969b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80496a2:	e9 c9 01 00 00       	jmp    8049870 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80496a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80496ae:	eb 2d                	jmp    80496dd <vfprintf+0xf3>
					int d=(x%16);
 80496b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80496b3:	83 e0 0f             	and    $0xf,%eax
 80496b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80496b9:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80496bd:	7e 04                	jle    80496c3 <vfprintf+0xd9>
						d+='a'-'0'-10;
 80496bf:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80496c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80496c6:	83 c0 30             	add    $0x30,%eax
 80496c9:	89 c1                	mov    %eax,%ecx
 80496cb:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80496ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80496d1:	01 d0                	add    %edx,%eax
 80496d3:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80496d5:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80496d9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80496dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80496e1:	75 cd                	jne    80496b0 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80496e3:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80496e7:	eb 1e                	jmp    8049707 <vfprintf+0x11d>
					printer(digits[di]);
 80496e9:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80496ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80496ef:	01 d0                	add    %edx,%eax
 80496f1:	0f b6 00             	movzbl (%eax),%eax
 80496f4:	0f be c0             	movsbl %al,%eax
 80496f7:	83 ec 0c             	sub    $0xc,%esp
 80496fa:	50                   	push   %eax
 80496fb:	8b 45 08             	mov    0x8(%ebp),%eax
 80496fe:	ff d0                	call   *%eax
 8049700:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8049703:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8049707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804970b:	79 dc                	jns    80496e9 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804970d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049711:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8049715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049718:	0f b6 00             	movzbl (%eax),%eax
 804971b:	3c 64                	cmp    $0x64,%al
 804971d:	0f 85 02 01 00 00    	jne    8049825 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8049723:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049726:	8b 00                	mov    (%eax),%eax
 8049728:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 804972b:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8049732:	75 23                	jne    8049757 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 8049734:	83 ec 08             	sub    $0x8,%esp
 8049737:	68 84 a2 04 08       	push   $0x804a284
 804973c:	ff 75 08             	pushl  0x8(%ebp)
 804973f:	e8 73 fe ff ff       	call   80495b7 <printp>
 8049744:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8049747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804974b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8049752:	e9 19 01 00 00       	jmp    8049870 <vfprintf+0x286>
				}
				if(x==0){
 8049757:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804975b:	75 1e                	jne    804977b <vfprintf+0x191>
					printer('0');
 804975d:	83 ec 0c             	sub    $0xc,%esp
 8049760:	6a 30                	push   $0x30
 8049762:	8b 45 08             	mov    0x8(%ebp),%eax
 8049765:	ff d0                	call   *%eax
 8049767:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804976a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804976e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8049775:	90                   	nop
 8049776:	e9 f5 00 00 00       	jmp    8049870 <vfprintf+0x286>
				}
				if(x<0){
 804977b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804977f:	79 10                	jns    8049791 <vfprintf+0x1a7>
					printer('-');
 8049781:	83 ec 0c             	sub    $0xc,%esp
 8049784:	6a 2d                	push   $0x2d
 8049786:	8b 45 08             	mov    0x8(%ebp),%eax
 8049789:	ff d0                	call   *%eax
 804978b:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804978e:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8049791:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8049798:	eb 53                	jmp    80497ed <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 804979a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804979d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80497a2:	89 c8                	mov    %ecx,%eax
 80497a4:	f7 ea                	imul   %edx
 80497a6:	c1 fa 02             	sar    $0x2,%edx
 80497a9:	89 c8                	mov    %ecx,%eax
 80497ab:	c1 f8 1f             	sar    $0x1f,%eax
 80497ae:	29 c2                	sub    %eax,%edx
 80497b0:	89 d0                	mov    %edx,%eax
 80497b2:	c1 e0 02             	shl    $0x2,%eax
 80497b5:	01 d0                	add    %edx,%eax
 80497b7:	01 c0                	add    %eax,%eax
 80497b9:	29 c1                	sub    %eax,%ecx
 80497bb:	89 ca                	mov    %ecx,%edx
 80497bd:	89 d0                	mov    %edx,%eax
 80497bf:	83 c0 30             	add    $0x30,%eax
 80497c2:	89 c1                	mov    %eax,%ecx
 80497c4:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80497c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80497ca:	01 d0                	add    %edx,%eax
 80497cc:	88 08                	mov    %cl,(%eax)
					x/=10;
 80497ce:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80497d1:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80497d6:	89 c8                	mov    %ecx,%eax
 80497d8:	f7 ea                	imul   %edx
 80497da:	c1 fa 02             	sar    $0x2,%edx
 80497dd:	89 c8                	mov    %ecx,%eax
 80497df:	c1 f8 1f             	sar    $0x1f,%eax
 80497e2:	29 c2                	sub    %eax,%edx
 80497e4:	89 d0                	mov    %edx,%eax
 80497e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80497e9:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80497ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80497f1:	7f a7                	jg     804979a <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80497f3:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 80497f7:	eb 1e                	jmp    8049817 <vfprintf+0x22d>
					printer(digits[di]);
 80497f9:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80497fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80497ff:	01 d0                	add    %edx,%eax
 8049801:	0f b6 00             	movzbl (%eax),%eax
 8049804:	0f be c0             	movsbl %al,%eax
 8049807:	83 ec 0c             	sub    $0xc,%esp
 804980a:	50                   	push   %eax
 804980b:	8b 45 08             	mov    0x8(%ebp),%eax
 804980e:	ff d0                	call   *%eax
 8049810:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8049813:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8049817:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 804981b:	79 dc                	jns    80497f9 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804981d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049821:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 8049825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049828:	0f b6 00             	movzbl (%eax),%eax
 804982b:	3c 63                	cmp    $0x63,%al
 804982d:	75 1d                	jne    804984c <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 804982f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049832:	0f b6 00             	movzbl (%eax),%eax
 8049835:	0f be c0             	movsbl %al,%eax
 8049838:	83 ec 0c             	sub    $0xc,%esp
 804983b:	50                   	push   %eax
 804983c:	8b 45 08             	mov    0x8(%ebp),%eax
 804983f:	ff d0                	call   *%eax
 8049841:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 8049844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049848:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 804984c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8049853:	eb 1b                	jmp    8049870 <vfprintf+0x286>
		}
		if(type == NONE){
 8049855:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8049859:	75 15                	jne    8049870 <vfprintf+0x286>
			printer(cur);
 804985b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804985e:	0f b6 00             	movzbl (%eax),%eax
 8049861:	0f be c0             	movsbl %al,%eax
 8049864:	83 ec 0c             	sub    $0xc,%esp
 8049867:	50                   	push   %eax
 8049868:	8b 45 08             	mov    0x8(%ebp),%eax
 804986b:	ff d0                	call   *%eax
 804986d:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8049870:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049877:	0f b6 00             	movzbl (%eax),%eax
 804987a:	84 c0                	test   %al,%al
 804987c:	0f 85 8d fd ff ff    	jne    804960f <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8049882:	c9                   	leave  
 8049883:	c3                   	ret    

08049884 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8049884:	55                   	push   %ebp
 8049885:	89 e5                	mov    %esp,%ebp
 8049887:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 804988a:	8d 45 0c             	lea    0xc(%ebp),%eax
 804988d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8049890:	8b 45 08             	mov    0x8(%ebp),%eax
 8049893:	83 ec 04             	sub    $0x4,%esp
 8049896:	ff 75 f4             	pushl  -0xc(%ebp)
 8049899:	50                   	push   %eax
 804989a:	68 97 95 04 08       	push   $0x8049597
 804989f:	e8 46 fd ff ff       	call   80495ea <vfprintf>
 80498a4:	83 c4 10             	add    $0x10,%esp
}
 80498a7:	c9                   	leave  
 80498a8:	c3                   	ret    
