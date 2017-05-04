
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
}timer_handler;

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
 8048167:	55                   	push   %ebp
 8048168:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 804816a:	b8 df 05 00 00       	mov    $0x5df,%eax
 804816f:	cd 80                	int    $0x80
}
 8048171:	5d                   	pop    %ebp
 8048172:	c3                   	ret    

08048173 <sys_fork>:
static inline uint32_t sys_fork(){
 8048173:	55                   	push   %ebp
 8048174:	89 e5                	mov    %esp,%ebp
 8048176:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 8048180:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 8048185:	cd 80                	int    $0x80
 8048187:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 804818a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804818d:	c9                   	leave  
 804818e:	c3                   	ret    

0804818f <sys_pid>:
static inline uint32_t sys_pid(){
 804818f:	55                   	push   %ebp
 8048190:	89 e5                	mov    %esp,%ebp
 8048192:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048195:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 804819c:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 80481a1:	cd 80                	int    $0x80
 80481a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80481a9:	c9                   	leave  
 80481aa:	c3                   	ret    

080481ab <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 80481ab:	55                   	push   %ebp
 80481ac:	89 e5                	mov    %esp,%ebp
 80481ae:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 80481af:	b8 de 05 00 00       	mov    $0x5de,%eax
 80481b4:	8b 55 08             	mov    0x8(%ebp),%edx
 80481b7:	89 d3                	mov    %edx,%ebx
 80481b9:	cd 80                	int    $0x80
}
 80481bb:	5b                   	pop    %ebx
 80481bc:	5d                   	pop    %ebp
 80481bd:	c3                   	ret    

080481be <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
 80481be:	55                   	push   %ebp
 80481bf:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
 80481c1:	b8 4c 04 00 00       	mov    $0x44c,%eax
 80481c6:	cd 80                	int    $0x80
}
 80481c8:	5d                   	pop    %ebp
 80481c9:	c3                   	ret    

080481ca <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
 80481ca:	55                   	push   %ebp
 80481cb:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
 80481cd:	b8 4e 04 00 00       	mov    $0x44e,%eax
 80481d2:	cd 80                	int    $0x80
}
 80481d4:	5d                   	pop    %ebp
 80481d5:	c3                   	ret    

080481d6 <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
 80481d6:	55                   	push   %ebp
 80481d7:	89 e5                	mov    %esp,%ebp
 80481d9:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
 80481da:	b8 4f 04 00 00       	mov    $0x44f,%eax
 80481df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80481e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80481e5:	8b 55 10             	mov    0x10(%ebp),%edx
 80481e8:	cd 80                	int    $0x80
}
 80481ea:	5b                   	pop    %ebx
 80481eb:	5d                   	pop    %ebp
 80481ec:	c3                   	ret    

080481ed <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
 80481ed:	55                   	push   %ebp
 80481ee:	89 e5                	mov    %esp,%ebp
 80481f0:	53                   	push   %ebx
 80481f1:	83 ec 14             	sub    $0x14,%esp
 80481f4:	8b 45 08             	mov    0x8(%ebp),%eax
 80481f7:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
 80481fa:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
 80481fe:	b8 b0 04 00 00       	mov    $0x4b0,%eax
 8048203:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 8048207:	89 d3                	mov    %edx,%ebx
 8048209:	cd 80                	int    $0x80
 804820b:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 804820e:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
 8048212:	83 c4 14             	add    $0x14,%esp
 8048215:	5b                   	pop    %ebx
 8048216:	5d                   	pop    %ebp
 8048217:	c3                   	ret    

08048218 <sys_get_tick>:
static inline uint32_t sys_get_tick(){
 8048218:	55                   	push   %ebp
 8048219:	89 e5                	mov    %esp,%ebp
 804821b:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 804821e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
 8048225:	b8 15 05 00 00       	mov    $0x515,%eax
 804822a:	cd 80                	int    $0x80
 804822c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 804822f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048232:	c9                   	leave  
 8048233:	c3                   	ret    

08048234 <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
 8048234:	55                   	push   %ebp
 8048235:	89 e5                	mov    %esp,%ebp
 8048237:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
 804823a:	8b 45 08             	mov    0x8(%ebp),%eax
 804823d:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 8048244:	85 c0                	test   %eax,%eax
 8048246:	74 0f                	je     8048257 <isqrt+0x23>
 8048248:	8b 45 08             	mov    0x8(%ebp),%eax
 804824b:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 8048252:	e9 a9 00 00 00       	jmp    8048300 <isqrt+0xcc>
    const uint16_t *p = squares;
 8048257:	c7 45 fc 00 99 04 08 	movl   $0x8049900,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
 804825e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048261:	83 c0 40             	add    $0x40,%eax
 8048264:	0f b7 00             	movzwl (%eax),%eax
 8048267:	0f b7 c0             	movzwl %ax,%eax
 804826a:	3b 45 08             	cmp    0x8(%ebp),%eax
 804826d:	77 04                	ja     8048273 <isqrt+0x3f>
 804826f:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
 8048273:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048276:	83 c0 20             	add    $0x20,%eax
 8048279:	0f b7 00             	movzwl (%eax),%eax
 804827c:	0f b7 c0             	movzwl %ax,%eax
 804827f:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048282:	77 04                	ja     8048288 <isqrt+0x54>
 8048284:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
 8048288:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804828b:	83 c0 10             	add    $0x10,%eax
 804828e:	0f b7 00             	movzwl (%eax),%eax
 8048291:	0f b7 c0             	movzwl %ax,%eax
 8048294:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048297:	77 04                	ja     804829d <isqrt+0x69>
 8048299:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
 804829d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482a0:	83 c0 08             	add    $0x8,%eax
 80482a3:	0f b7 00             	movzwl (%eax),%eax
 80482a6:	0f b7 c0             	movzwl %ax,%eax
 80482a9:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482ac:	77 04                	ja     80482b2 <isqrt+0x7e>
 80482ae:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
 80482b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482b5:	83 c0 04             	add    $0x4,%eax
 80482b8:	0f b7 00             	movzwl (%eax),%eax
 80482bb:	0f b7 c0             	movzwl %ax,%eax
 80482be:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482c1:	77 04                	ja     80482c7 <isqrt+0x93>
 80482c3:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
 80482c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482ca:	83 c0 02             	add    $0x2,%eax
 80482cd:	0f b7 00             	movzwl (%eax),%eax
 80482d0:	0f b7 c0             	movzwl %ax,%eax
 80482d3:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482d6:	77 04                	ja     80482dc <isqrt+0xa8>
 80482d8:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
 80482dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482df:	ba 00 99 04 08       	mov    $0x8049900,%edx
 80482e4:	29 d0                	sub    %edx,%eax
 80482e6:	d1 f8                	sar    %eax
 80482e8:	89 c2                	mov    %eax,%edx
 80482ea:	8b 45 08             	mov    0x8(%ebp),%eax
 80482ed:	89 14 85 c0 b0 04 08 	mov    %edx,0x804b0c0(,%eax,4)
    return p - squares;
 80482f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482f7:	ba 00 99 04 08       	mov    $0x8049900,%edx
 80482fc:	29 d0                	sub    %edx,%eax
 80482fe:	d1 f8                	sar    %eax
}
 8048300:	c9                   	leave  
 8048301:	c3                   	ret    

08048302 <clearStage>:


static inline void clearStage(){
 8048302:	55                   	push   %ebp
 8048303:	89 e5                	mov    %esp,%ebp
	hash = 0;
 8048305:	c7 05 80 b0 04 08 00 	movl   $0x0,0x804b080
 804830c:	00 00 00 
	sys_init_vcache();
 804830f:	e8 aa fe ff ff       	call   80481be <sys_init_vcache>
}
 8048314:	5d                   	pop    %ebp
 8048315:	c3                   	ret    

08048316 <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
 8048316:	55                   	push   %ebp
 8048317:	89 e5                	mov    %esp,%ebp
 8048319:	83 ec 04             	sub    $0x4,%esp
 804831c:	8b 45 10             	mov    0x10(%ebp),%eax
 804831f:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
 8048322:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 8048326:	50                   	push   %eax
 8048327:	ff 75 08             	pushl  0x8(%ebp)
 804832a:	ff 75 0c             	pushl  0xc(%ebp)
 804832d:	e8 a4 fe ff ff       	call   80481d6 <sys_set_pixel>
 8048332:	83 c4 0c             	add    $0xc,%esp
}
 8048335:	c9                   	leave  
 8048336:	c3                   	ret    

08048337 <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
 8048337:	55                   	push   %ebp
 8048338:	89 e5                	mov    %esp,%ebp
 804833a:	53                   	push   %ebx
 804833b:	83 ec 14             	sub    $0x14,%esp
 804833e:	8b 45 18             	mov    0x18(%ebp),%eax
 8048341:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
 8048344:	8b 45 08             	mov    0x8(%ebp),%eax
 8048347:	6b d0 1d             	imul   $0x1d,%eax,%edx
 804834a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804834d:	6b c0 39             	imul   $0x39,%eax,%eax
 8048350:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048353:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 8048357:	89 d0                	mov    %edx,%eax
 8048359:	01 c0                	add    %eax,%eax
 804835b:	01 d0                	add    %edx,%eax
 804835d:	c1 e0 02             	shl    $0x2,%eax
 8048360:	01 d0                	add    %edx,%eax
 8048362:	01 c8                	add    %ecx,%eax
 8048364:	89 c2                	mov    %eax,%edx
 8048366:	a1 80 b0 04 08       	mov    0x804b080,%eax
 804836b:	01 d0                	add    %edx,%eax
 804836d:	a3 80 b0 04 08       	mov    %eax,0x804b080
	int i=0, j=0;
 8048372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
 8048380:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048387:	eb 38                	jmp    80483c1 <drawRect+0x8a>
		for(j=0;j<h;j++){
 8048389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048390:	eb 23                	jmp    80483b5 <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
 8048392:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 8048396:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048399:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804839c:	01 d1                	add    %edx,%ecx
 804839e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80483a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80483a4:	01 da                	add    %ebx,%edx
 80483a6:	50                   	push   %eax
 80483a7:	51                   	push   %ecx
 80483a8:	52                   	push   %edx
 80483a9:	e8 68 ff ff ff       	call   8048316 <drawPoint>
 80483ae:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
 80483b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80483b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483b8:	3b 45 14             	cmp    0x14(%ebp),%eax
 80483bb:	7c d5                	jl     8048392 <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
 80483bd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80483c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80483c4:	3b 45 10             	cmp    0x10(%ebp),%eax
 80483c7:	7c c0                	jl     8048389 <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
 80483c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80483cc:	c9                   	leave  
 80483cd:	c3                   	ret    

080483ce <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
 80483ce:	55                   	push   %ebp
 80483cf:	89 e5                	mov    %esp,%ebp
 80483d1:	53                   	push   %ebx
 80483d2:	83 ec 14             	sub    $0x14,%esp
 80483d5:	8b 45 14             	mov    0x14(%ebp),%eax
 80483d8:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
 80483db:	8b 45 08             	mov    0x8(%ebp),%eax
 80483de:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
 80483e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483e7:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
 80483ed:	01 c2                	add    %eax,%edx
 80483ef:	8b 45 10             	mov    0x10(%ebp),%eax
 80483f2:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
 80483f8:	01 d0                	add    %edx,%eax
 80483fa:	89 c2                	mov    %eax,%edx
 80483fc:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048401:	01 d0                	add    %edx,%eax
 8048403:	a3 80 b0 04 08       	mov    %eax,0x804b080
	for(i=-r; i<=r; i++){
 8048408:	8b 45 10             	mov    0x10(%ebp),%eax
 804840b:	f7 d8                	neg    %eax
 804840d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 8048410:	eb 5c                	jmp    804846e <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
 8048412:	8b 45 10             	mov    0x10(%ebp),%eax
 8048415:	0f af 45 10          	imul   0x10(%ebp),%eax
 8048419:	89 c2                	mov    %eax,%edx
 804841b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804841e:	0f af 45 f8          	imul   -0x8(%ebp),%eax
 8048422:	29 c2                	sub    %eax,%edx
 8048424:	89 d0                	mov    %edx,%eax
 8048426:	50                   	push   %eax
 8048427:	e8 08 fe ff ff       	call   8048234 <isqrt>
 804842c:	83 c4 04             	add    $0x4,%esp
 804842f:	83 c0 01             	add    $0x1,%eax
 8048432:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 8048435:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048438:	f7 d8                	neg    %eax
 804843a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804843d:	eb 23                	jmp    8048462 <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
 804843f:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 8048443:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048446:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048449:	01 d1                	add    %edx,%ecx
 804844b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804844e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048451:	01 da                	add    %ebx,%edx
 8048453:	50                   	push   %eax
 8048454:	51                   	push   %ecx
 8048455:	52                   	push   %edx
 8048456:	e8 bb fe ff ff       	call   8048316 <drawPoint>
 804845b:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 804845e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048465:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8048468:	7e d5                	jle    804843f <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
 804846a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 804846e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048471:	3b 45 10             	cmp    0x10(%ebp),%eax
 8048474:	7e 9c                	jle    8048412 <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
 8048476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048479:	c9                   	leave  
 804847a:	c3                   	ret    

0804847b <drawText1>:

static inline void drawText1(){
 804847b:	55                   	push   %ebp
 804847c:	89 e5                	mov    %esp,%ebp
 804847e:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
 8048481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048488:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
 804848f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048496:	eb 53                	jmp    80484eb <drawText1+0x70>
        for(i=0;i<52;i++){
 8048498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804849f:	eb 40                	jmp    80484e1 <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
 80484a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80484a4:	6b d0 34             	imul   $0x34,%eax,%edx
 80484a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80484aa:	01 d0                	add    %edx,%eax
 80484ac:	0f b6 80 00 9b 04 08 	movzbl 0x8049b00(%eax),%eax
 80484b3:	84 c0                	test   %al,%al
 80484b5:	74 26                	je     80484dd <drawText1+0x62>
 80484b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80484ba:	89 d0                	mov    %edx,%eax
 80484bc:	c1 e0 02             	shl    $0x2,%eax
 80484bf:	01 d0                	add    %edx,%eax
 80484c1:	8d 50 14             	lea    0x14(%eax),%edx
 80484c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80484c7:	c1 e0 02             	shl    $0x2,%eax
 80484ca:	83 c0 32             	add    $0x32,%eax
 80484cd:	6a 0e                	push   $0xe
 80484cf:	6a 05                	push   $0x5
 80484d1:	6a 04                	push   $0x4
 80484d3:	52                   	push   %edx
 80484d4:	50                   	push   %eax
 80484d5:	e8 5d fe ff ff       	call   8048337 <drawRect>
 80484da:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
 80484dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80484e1:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
 80484e5:	7e ba                	jle    80484a1 <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
 80484e7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80484eb:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 80484ef:	7e a7                	jle    8048498 <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
 80484f1:	c9                   	leave  
 80484f2:	c3                   	ret    

080484f3 <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
 80484f3:	55                   	push   %ebp
 80484f4:	89 e5                	mov    %esp,%ebp
 80484f6:	53                   	push   %ebx
 80484f7:	83 ec 24             	sub    $0x24,%esp
 80484fa:	8b 45 18             	mov    0x18(%ebp),%eax
 80484fd:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
 8048500:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
 8048507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804850b:	75 0d                	jne    804851a <drawNumber+0x27>
        temp[0] = '0';
 804850d:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
 8048511:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048518:	eb 5f                	jmp    8048579 <drawNumber+0x86>

    }else{    
        while(num>=1){
 804851a:	eb 53                	jmp    804856f <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
 804851c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 804851f:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048524:	89 c8                	mov    %ecx,%eax
 8048526:	f7 ea                	imul   %edx
 8048528:	c1 fa 02             	sar    $0x2,%edx
 804852b:	89 c8                	mov    %ecx,%eax
 804852d:	c1 f8 1f             	sar    $0x1f,%eax
 8048530:	29 c2                	sub    %eax,%edx
 8048532:	89 d0                	mov    %edx,%eax
 8048534:	c1 e0 02             	shl    $0x2,%eax
 8048537:	01 d0                	add    %edx,%eax
 8048539:	01 c0                	add    %eax,%eax
 804853b:	29 c1                	sub    %eax,%ecx
 804853d:	89 ca                	mov    %ecx,%edx
 804853f:	89 d0                	mov    %edx,%eax
 8048541:	83 c0 30             	add    $0x30,%eax
 8048544:	89 c1                	mov    %eax,%ecx
 8048546:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048549:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804854c:	01 d0                	add    %edx,%eax
 804854e:	88 08                	mov    %cl,(%eax)
            num/=10;
 8048550:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8048553:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048558:	89 c8                	mov    %ecx,%eax
 804855a:	f7 ea                	imul   %edx
 804855c:	c1 fa 02             	sar    $0x2,%edx
 804855f:	89 c8                	mov    %ecx,%eax
 8048561:	c1 f8 1f             	sar    $0x1f,%eax
 8048564:	29 c2                	sub    %eax,%edx
 8048566:	89 d0                	mov    %edx,%eax
 8048568:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
 804856b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
 804856f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048573:	7f a7                	jg     804851c <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
 8048575:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
 8048579:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048580:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
 804858e:	e9 b2 00 00 00       	jmp    8048645 <drawNumber+0x152>
        for(yy=0; yy<7; yy++){
 8048593:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804859a:	e9 94 00 00 00       	jmp    8048633 <drawNumber+0x140>
            for(xx=0; xx<5; xx++){
 804859f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80485a6:	eb 7d                	jmp    8048625 <drawNumber+0x132>
                const char* num = nums[temp[di]-'0'];
 80485a8:	8d 55 dd             	lea    -0x23(%ebp),%edx
 80485ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80485ae:	01 d0                	add    %edx,%eax
 80485b0:	0f b6 00             	movzbl (%eax),%eax
 80485b3:	0f be c0             	movsbl %al,%eax
 80485b6:	83 e8 30             	sub    $0x30,%eax
 80485b9:	8b 04 85 20 b0 04 08 	mov    0x804b020(,%eax,4),%eax
 80485c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
 80485c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485c6:	89 d0                	mov    %edx,%eax
 80485c8:	c1 e0 02             	shl    $0x2,%eax
 80485cb:	01 c2                	add    %eax,%edx
 80485cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80485d0:	01 d0                	add    %edx,%eax
 80485d2:	89 c2                	mov    %eax,%edx
 80485d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485d7:	01 d0                	add    %edx,%eax
 80485d9:	0f b6 00             	movzbl (%eax),%eax
 80485dc:	84 c0                	test   %al,%al
 80485de:	74 41                	je     8048621 <drawNumber+0x12e>
 80485e0:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
 80485e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485e7:	89 d1                	mov    %edx,%ecx
 80485e9:	0f af 4d 14          	imul   0x14(%ebp),%ecx
 80485ed:	8b 55 10             	mov    0x10(%ebp),%edx
 80485f0:	01 d1                	add    %edx,%ecx
 80485f2:	8b 55 14             	mov    0x14(%ebp),%edx
 80485f5:	0f af 55 14          	imul   0x14(%ebp),%edx
 80485f9:	83 c2 0a             	add    $0xa,%edx
 80485fc:	89 d3                	mov    %edx,%ebx
 80485fe:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
 8048602:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048605:	01 d3                	add    %edx,%ebx
 8048607:	8b 55 f0             	mov    -0x10(%ebp),%edx
 804860a:	0f af 55 14          	imul   0x14(%ebp),%edx
 804860e:	01 da                	add    %ebx,%edx
 8048610:	50                   	push   %eax
 8048611:	ff 75 14             	pushl  0x14(%ebp)
 8048614:	ff 75 14             	pushl  0x14(%ebp)
 8048617:	51                   	push   %ecx
 8048618:	52                   	push   %edx
 8048619:	e8 19 fd ff ff       	call   8048337 <drawRect>
 804861e:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
 8048621:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8048625:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 8048629:	0f 8e 79 ff ff ff    	jle    80485a8 <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
 804862f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 8048633:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
 8048637:	0f 8e 62 ff ff ff    	jle    804859f <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
 804863d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
 8048641:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
 8048645:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 8048649:	0f 89 44 ff ff ff    	jns    8048593 <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
 804864f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048652:	c9                   	leave  
 8048653:	c3                   	ret    

08048654 <drawStage>:

static inline void drawStage(){
 8048654:	55                   	push   %ebp
 8048655:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
 8048657:	8b 15 84 b0 04 08    	mov    0x804b084,%edx
 804865d:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048662:	39 c2                	cmp    %eax,%edx
 8048664:	75 02                	jne    8048668 <drawStage+0x14>
 8048666:	eb 0f                	jmp    8048677 <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
 8048668:	e8 5d fb ff ff       	call   80481ca <sys_flush_vcache>
	lhash = hash;
 804866d:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048672:	a3 84 b0 04 08       	mov    %eax,0x804b084
}
 8048677:	5d                   	pop    %ebp
 8048678:	c3                   	ret    

08048679 <key>:
static int timestamp = 1;
static int curtime = 0;
static int score = 0;
void dreamOf100HZ(int);

static inline int8_t key(char s){
 8048679:	55                   	push   %ebp
 804867a:	89 e5                	mov    %esp,%ebp
 804867c:	83 ec 04             	sub    $0x4,%esp
 804867f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048682:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
 8048685:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048689:	50                   	push   %eax
 804868a:	e8 5e fb ff ff       	call   80481ed <sys_key_down>
 804868f:	83 c4 04             	add    $0x4,%esp
}
 8048692:	c9                   	leave  
 8048693:	c3                   	ret    

08048694 <main>:

void game();

int main(){
 8048694:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048698:	83 e4 f0             	and    $0xfffffff0,%esp
 804869b:	ff 71 fc             	pushl  -0x4(%ecx)
 804869e:	55                   	push   %ebp
 804869f:	89 e5                	mov    %esp,%ebp
 80486a1:	51                   	push   %ecx
 80486a2:	83 ec 04             	sub    $0x4,%esp
	//printk("4\n");
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	printf("Hello this is INIT#%d! Now I want to fork GAME! WATCH ME!\n", getpid());
 80486a5:	e8 e5 fa ff ff       	call   804818f <sys_pid>
 80486aa:	83 ec 08             	sub    $0x8,%esp
 80486ad:	50                   	push   %eax
 80486ae:	68 84 a1 04 08       	push   $0x804a184
 80486b3:	e8 ef 11 00 00       	call   80498a7 <printf>
 80486b8:	83 c4 10             	add    $0x10,%esp
	if(fork()!=0){
 80486bb:	e8 b3 fa ff ff       	call   8048173 <sys_fork>
 80486c0:	85 c0                	test   %eax,%eax
 80486c2:	74 33                	je     80486f7 <main+0x63>
		printf("INIT#%d: My dute is done! I choose goudai!\n", getpid());
 80486c4:	e8 c6 fa ff ff       	call   804818f <sys_pid>
 80486c9:	83 ec 08             	sub    $0x8,%esp
 80486cc:	50                   	push   %eax
 80486cd:	68 c0 a1 04 08       	push   $0x804a1c0
 80486d2:	e8 d0 11 00 00       	call   80498a7 <printf>
 80486d7:	83 c4 10             	add    $0x10,%esp
		//while(1);
		exit();
 80486da:	e8 88 fa ff ff       	call   8048167 <sys_exit>
		printf("INIT#%d: To check whether I am alive! You should not see this!\n", getpid());
 80486df:	e8 ab fa ff ff       	call   804818f <sys_pid>
 80486e4:	83 ec 08             	sub    $0x8,%esp
 80486e7:	50                   	push   %eax
 80486e8:	68 ec a1 04 08       	push   $0x804a1ec
 80486ed:	e8 b5 11 00 00       	call   80498a7 <printf>
 80486f2:	83 c4 10             	add    $0x10,%esp
 80486f5:	eb 05                	jmp    80486fc <main+0x68>
	}else{
		game();
 80486f7:	e8 0d 00 00 00       	call   8048709 <game>
	}
	return 1;
 80486fc:	b8 01 00 00 00       	mov    $0x1,%eax
};
 8048701:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8048704:	c9                   	leave  
 8048705:	8d 61 fc             	lea    -0x4(%ecx),%esp
 8048708:	c3                   	ret    

08048709 <game>:

void game(){
 8048709:	55                   	push   %ebp
 804870a:	89 e5                	mov    %esp,%ebp
 804870c:	83 ec 08             	sub    $0x8,%esp
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
 804870f:	e8 7b fa ff ff       	call   804818f <sys_pid>
 8048714:	83 ec 08             	sub    $0x8,%esp
 8048717:	50                   	push   %eax
 8048718:	68 2c a2 04 08       	push   $0x804a22c
 804871d:	e8 85 11 00 00       	call   80498a7 <printf>
 8048722:	83 c4 10             	add    $0x10,%esp
	while(1){
		timestamp = sys_get_tick();
 8048725:	e8 ee fa ff ff       	call   8048218 <sys_get_tick>
 804872a:	a3 48 b0 04 08       	mov    %eax,0x804b048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 804872f:	eb 1e                	jmp    804874f <game+0x46>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
 8048731:	a1 48 b0 04 08       	mov    0x804b048,%eax
 8048736:	83 ec 0c             	sub    $0xc,%esp
 8048739:	50                   	push   %eax
 804873a:	e8 8c 07 00 00       	call   8048ecb <dreamOf100HZ>
 804873f:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime+=2;
 8048742:	a1 20 ba 04 08       	mov    0x804ba20,%eax
 8048747:	83 c0 02             	add    $0x2,%eax
 804874a:	a3 20 ba 04 08       	mov    %eax,0x804ba20
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 804874f:	8b 15 20 ba 04 08    	mov    0x804ba20,%edx
 8048755:	a1 48 b0 04 08       	mov    0x804b048,%eax
 804875a:	39 c2                	cmp    %eax,%edx
 804875c:	7c d3                	jl     8048731 <game+0x28>
		//sys_handout();
		

		//enable_interrupt();
		
	}
 804875e:	eb c5                	jmp    8048725 <game+0x1c>

08048760 <hitMonster>:
domain int x, y, size;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
 8048760:	55                   	push   %ebp
 8048761:	89 e5                	mov    %esp,%ebp
 8048763:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 8048766:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
 804876d:	e9 9c 01 00 00       	jmp    804890e <hitMonster+0x1ae>
		int dx = x-mon.x; 
 8048772:	8b 15 2c ba 04 08    	mov    0x804ba2c,%edx
 8048778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804877b:	c1 e0 02             	shl    $0x2,%eax
 804877e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048785:	29 c1                	sub    %eax,%ecx
 8048787:	89 c8                	mov    %ecx,%eax
 8048789:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804878e:	8b 40 04             	mov    0x4(%eax),%eax
 8048791:	29 c2                	sub    %eax,%edx
 8048793:	89 d0                	mov    %edx,%eax
 8048795:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
 8048798:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 804879e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487a1:	c1 e0 02             	shl    $0x2,%eax
 80487a4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80487ab:	29 c1                	sub    %eax,%ecx
 80487ad:	89 c8                	mov    %ecx,%eax
 80487af:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487b4:	8b 40 08             	mov    0x8(%eax),%eax
 80487b7:	29 c2                	sub    %eax,%edx
 80487b9:	89 d0                	mov    %edx,%eax
 80487bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
 80487be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487c1:	89 c2                	mov    %eax,%edx
 80487c3:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80487ca:	89 c2                	mov    %eax,%edx
 80487cc:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80487d3:	29 d0                	sub    %edx,%eax
 80487d5:	83 c0 10             	add    $0x10,%eax
 80487d8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487dd:	8b 40 04             	mov    0x4(%eax),%eax
 80487e0:	85 c0                	test   %eax,%eax
 80487e2:	0f 85 22 01 00 00    	jne    804890a <hitMonster+0x1aa>
 80487e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487eb:	c1 e0 02             	shl    $0x2,%eax
 80487ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487f5:	29 c2                	sub    %eax,%edx
 80487f7:	89 d0                	mov    %edx,%eax
 80487f9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487fe:	8b 00                	mov    (%eax),%eax
 8048800:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048803:	0f 8c 01 01 00 00    	jl     804890a <hitMonster+0x1aa>
 8048809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804880c:	c1 e0 02             	shl    $0x2,%eax
 804880f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048816:	29 c2                	sub    %eax,%edx
 8048818:	89 d0                	mov    %edx,%eax
 804881a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804881f:	8b 00                	mov    (%eax),%eax
 8048821:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8048824:	0f 8c e0 00 00 00    	jl     804890a <hitMonster+0x1aa>
 804882a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804882d:	c1 e0 02             	shl    $0x2,%eax
 8048830:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048837:	29 c2                	sub    %eax,%edx
 8048839:	89 d0                	mov    %edx,%eax
 804883b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048840:	8b 00                	mov    (%eax),%eax
 8048842:	f7 d8                	neg    %eax
 8048844:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048847:	0f 8f bd 00 00 00    	jg     804890a <hitMonster+0x1aa>
 804884d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048850:	c1 e0 02             	shl    $0x2,%eax
 8048853:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804885a:	29 c2                	sub    %eax,%edx
 804885c:	89 d0                	mov    %edx,%eax
 804885e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048863:	8b 00                	mov    (%eax),%eax
 8048865:	f7 d8                	neg    %eax
 8048867:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 804886a:	0f 8f 9a 00 00 00    	jg     804890a <hitMonster+0x1aa>
			if(mon.size <= size){
 8048870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048873:	c1 e0 02             	shl    $0x2,%eax
 8048876:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804887d:	29 c2                	sub    %eax,%edx
 804887f:	89 d0                	mov    %edx,%eax
 8048881:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048886:	8b 10                	mov    (%eax),%edx
 8048888:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 804888d:	39 c2                	cmp    %eax,%edx
 804888f:	7f 68                	jg     80488f9 <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
 8048891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048894:	89 c2                	mov    %eax,%edx
 8048896:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804889d:	89 c2                	mov    %eax,%edx
 804889f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80488a6:	29 d0                	sub    %edx,%eax
 80488a8:	83 c0 10             	add    $0x10,%eax
 80488ab:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488b0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
 80488b7:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80488bc:	83 f8 0c             	cmp    $0xc,%eax
 80488bf:	7f 0d                	jg     80488ce <hitMonster+0x16e>
 80488c1:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80488c6:	83 c0 01             	add    $0x1,%eax
 80488c9:	a3 34 ba 04 08       	mov    %eax,0x804ba34
				score += mon.size;
 80488ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80488d1:	c1 e0 02             	shl    $0x2,%eax
 80488d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488db:	29 c2                	sub    %eax,%edx
 80488dd:	89 d0                	mov    %edx,%eax
 80488df:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488e4:	8b 10                	mov    (%eax),%edx
 80488e6:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80488eb:	01 d0                	add    %edx,%eax
 80488ed:	a3 24 ba 04 08       	mov    %eax,0x804ba24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
 80488f2:	b8 01 00 00 00       	mov    $0x1,%eax
 80488f7:	eb 24                	jmp    804891d <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
 80488f9:	c7 05 28 ba 04 08 03 	movl   $0x3,0x804ba28
 8048900:	00 00 00 
				return 0;
 8048903:	b8 00 00 00 00       	mov    $0x0,%eax
 8048908:	eb 13                	jmp    804891d <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
 804890a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804890e:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
 8048912:	0f 8e 5a fe ff ff    	jle    8048772 <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
 8048918:	b8 00 00 00 00       	mov    $0x0,%eax
}
 804891d:	c9                   	leave  
 804891e:	c3                   	ret    

0804891f <drawMonster>:

void drawMonster(){
 804891f:	55                   	push   %ebp
 8048920:	89 e5                	mov    %esp,%ebp
 8048922:	56                   	push   %esi
 8048923:	53                   	push   %ebx
 8048924:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 8048927:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 804892e:	e9 89 03 00 00       	jmp    8048cbc <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
 8048933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048936:	89 c2                	mov    %eax,%edx
 8048938:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804893f:	89 c2                	mov    %eax,%edx
 8048941:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048948:	29 d0                	sub    %edx,%eax
 804894a:	83 c0 10             	add    $0x10,%eax
 804894d:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048952:	8b 40 04             	mov    0x4(%eax),%eax
 8048955:	85 c0                	test   %eax,%eax
 8048957:	0f 85 5b 03 00 00    	jne    8048cb8 <drawMonster+0x399>
			mon.x += mon.sx;
 804895d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048960:	c1 e0 02             	shl    $0x2,%eax
 8048963:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804896a:	29 c2                	sub    %eax,%edx
 804896c:	89 d0                	mov    %edx,%eax
 804896e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048973:	8b 50 04             	mov    0x4(%eax),%edx
 8048976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048979:	c1 e0 02             	shl    $0x2,%eax
 804897c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048983:	29 c1                	sub    %eax,%ecx
 8048985:	89 c8                	mov    %ecx,%eax
 8048987:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804898c:	8b 40 0c             	mov    0xc(%eax),%eax
 804898f:	01 c2                	add    %eax,%edx
 8048991:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048994:	c1 e0 02             	shl    $0x2,%eax
 8048997:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804899e:	29 c1                	sub    %eax,%ecx
 80489a0:	89 c8                	mov    %ecx,%eax
 80489a2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489a7:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
 80489aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489ad:	c1 e0 02             	shl    $0x2,%eax
 80489b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489b7:	29 c2                	sub    %eax,%edx
 80489b9:	89 d0                	mov    %edx,%eax
 80489bb:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489c0:	8b 48 08             	mov    0x8(%eax),%ecx
 80489c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489c6:	89 c2                	mov    %eax,%edx
 80489c8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80489cf:	89 c2                	mov    %eax,%edx
 80489d1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80489d8:	29 d0                	sub    %edx,%eax
 80489da:	83 c0 10             	add    $0x10,%eax
 80489dd:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489e2:	8b 00                	mov    (%eax),%eax
 80489e4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 80489e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489ea:	c1 e0 02             	shl    $0x2,%eax
 80489ed:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489f4:	29 c1                	sub    %eax,%ecx
 80489f6:	89 c8                	mov    %ecx,%eax
 80489f8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489fd:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
 8048a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a03:	c1 e0 02             	shl    $0x2,%eax
 8048a06:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a0d:	29 c2                	sub    %eax,%edx
 8048a0f:	89 d0                	mov    %edx,%eax
 8048a11:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a16:	8b 40 04             	mov    0x4(%eax),%eax
 8048a19:	83 f8 09             	cmp    $0x9,%eax
 8048a1c:	7f 35                	jg     8048a53 <drawMonster+0x134>
 8048a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a21:	c1 e0 02             	shl    $0x2,%eax
 8048a24:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a2b:	29 c2                	sub    %eax,%edx
 8048a2d:	89 d0                	mov    %edx,%eax
 8048a2f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a34:	8b 40 04             	mov    0x4(%eax),%eax
 8048a37:	8d 50 01             	lea    0x1(%eax),%edx
 8048a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a3d:	c1 e0 02             	shl    $0x2,%eax
 8048a40:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a47:	29 c1                	sub    %eax,%ecx
 8048a49:	89 c8                	mov    %ecx,%eax
 8048a4b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a50:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
 8048a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a56:	c1 e0 02             	shl    $0x2,%eax
 8048a59:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a60:	29 c2                	sub    %eax,%edx
 8048a62:	89 d0                	mov    %edx,%eax
 8048a64:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a69:	8b 40 04             	mov    0x4(%eax),%eax
 8048a6c:	3d 36 01 00 00       	cmp    $0x136,%eax
 8048a71:	7e 35                	jle    8048aa8 <drawMonster+0x189>
 8048a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a76:	c1 e0 02             	shl    $0x2,%eax
 8048a79:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a80:	29 c2                	sub    %eax,%edx
 8048a82:	89 d0                	mov    %edx,%eax
 8048a84:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a89:	8b 40 04             	mov    0x4(%eax),%eax
 8048a8c:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a92:	c1 e0 02             	shl    $0x2,%eax
 8048a95:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a9c:	29 c1                	sub    %eax,%ecx
 8048a9e:	89 c8                	mov    %ecx,%eax
 8048aa0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aa5:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
 8048aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048aab:	c1 e0 02             	shl    $0x2,%eax
 8048aae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ab5:	29 c2                	sub    %eax,%edx
 8048ab7:	89 d0                	mov    %edx,%eax
 8048ab9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048abe:	8b 40 08             	mov    0x8(%eax),%eax
 8048ac1:	83 f8 09             	cmp    $0x9,%eax
 8048ac4:	7f 35                	jg     8048afb <drawMonster+0x1dc>
 8048ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ac9:	c1 e0 02             	shl    $0x2,%eax
 8048acc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ad3:	29 c2                	sub    %eax,%edx
 8048ad5:	89 d0                	mov    %edx,%eax
 8048ad7:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048adc:	8b 40 08             	mov    0x8(%eax),%eax
 8048adf:	8d 50 01             	lea    0x1(%eax),%edx
 8048ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ae5:	c1 e0 02             	shl    $0x2,%eax
 8048ae8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048aef:	29 c1                	sub    %eax,%ecx
 8048af1:	89 c8                	mov    %ecx,%eax
 8048af3:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048af8:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
 8048afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048afe:	c1 e0 02             	shl    $0x2,%eax
 8048b01:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b08:	29 c2                	sub    %eax,%edx
 8048b0a:	89 d0                	mov    %edx,%eax
 8048b0c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b11:	8b 40 08             	mov    0x8(%eax),%eax
 8048b14:	3d be 00 00 00       	cmp    $0xbe,%eax
 8048b19:	7e 35                	jle    8048b50 <drawMonster+0x231>
 8048b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b1e:	c1 e0 02             	shl    $0x2,%eax
 8048b21:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b28:	29 c2                	sub    %eax,%edx
 8048b2a:	89 d0                	mov    %edx,%eax
 8048b2c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b31:	8b 40 08             	mov    0x8(%eax),%eax
 8048b34:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b3a:	c1 e0 02             	shl    $0x2,%eax
 8048b3d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048b44:	29 c1                	sub    %eax,%ecx
 8048b46:	89 c8                	mov    %ecx,%eax
 8048b48:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b4d:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
 8048b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b53:	c1 e0 02             	shl    $0x2,%eax
 8048b56:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b5d:	29 c2                	sub    %eax,%edx
 8048b5f:	89 d0                	mov    %edx,%eax
 8048b61:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b66:	8b 10                	mov    (%eax),%edx
 8048b68:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048b6d:	39 c2                	cmp    %eax,%edx
 8048b6f:	7f 07                	jg     8048b78 <drawMonster+0x259>
 8048b71:	b8 0f 00 00 00       	mov    $0xf,%eax
 8048b76:	eb 05                	jmp    8048b7d <drawMonster+0x25e>
 8048b78:	b8 05 00 00 00       	mov    $0x5,%eax
 8048b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
 8048b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048b83:	0f b6 d8             	movzbl %al,%ebx
 8048b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b89:	c1 e0 02             	shl    $0x2,%eax
 8048b8c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b93:	29 c2                	sub    %eax,%edx
 8048b95:	89 d0                	mov    %edx,%eax
 8048b97:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b9c:	8b 08                	mov    (%eax),%ecx
 8048b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ba1:	c1 e0 02             	shl    $0x2,%eax
 8048ba4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048bab:	29 c2                	sub    %eax,%edx
 8048bad:	89 d0                	mov    %edx,%eax
 8048baf:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bb4:	8b 50 08             	mov    0x8(%eax),%edx
 8048bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bba:	c1 e0 02             	shl    $0x2,%eax
 8048bbd:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
 8048bc4:	29 c6                	sub    %eax,%esi
 8048bc6:	89 f0                	mov    %esi,%eax
 8048bc8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bcd:	8b 40 04             	mov    0x4(%eax),%eax
 8048bd0:	53                   	push   %ebx
 8048bd1:	51                   	push   %ecx
 8048bd2:	52                   	push   %edx
 8048bd3:	50                   	push   %eax
 8048bd4:	e8 f5 f7 ff ff       	call   80483ce <drawCirc>
 8048bd9:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
 8048bdc:	e8 b3 f4 ff ff       	call   8048094 <UKISS>
 8048be1:	89 c2                	mov    %eax,%edx
 8048be3:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048be8:	01 c2                	add    %eax,%edx
 8048bea:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048bef:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048bf2:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048bf7:	89 c8                	mov    %ecx,%eax
 8048bf9:	f7 e2                	mul    %edx
 8048bfb:	89 d0                	mov    %edx,%eax
 8048bfd:	c1 e8 05             	shr    $0x5,%eax
 8048c00:	89 c2                	mov    %eax,%edx
 8048c02:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c09:	89 c2                	mov    %eax,%edx
 8048c0b:	89 d0                	mov    %edx,%eax
 8048c0d:	c1 e0 04             	shl    $0x4,%eax
 8048c10:	29 d0                	sub    %edx,%eax
 8048c12:	29 c1                	sub    %eax,%ecx
 8048c14:	89 c8                	mov    %ecx,%eax
 8048c16:	85 c0                	test   %eax,%eax
 8048c18:	0f 85 9a 00 00 00    	jne    8048cb8 <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
 8048c1e:	e8 71 f4 ff ff       	call   8048094 <UKISS>
 8048c23:	89 c2                	mov    %eax,%edx
 8048c25:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c2a:	01 c2                	add    %eax,%edx
 8048c2c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c31:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c34:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048c39:	89 c8                	mov    %ecx,%eax
 8048c3b:	f7 e2                	mul    %edx
 8048c3d:	d1 ea                	shr    %edx
 8048c3f:	89 d0                	mov    %edx,%eax
 8048c41:	01 c0                	add    %eax,%eax
 8048c43:	01 d0                	add    %edx,%eax
 8048c45:	29 c1                	sub    %eax,%ecx
 8048c47:	89 ca                	mov    %ecx,%edx
 8048c49:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048c4c:	89 c1                	mov    %eax,%ecx
 8048c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c51:	c1 e0 02             	shl    $0x2,%eax
 8048c54:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048c5b:	29 c2                	sub    %eax,%edx
 8048c5d:	89 d0                	mov    %edx,%eax
 8048c5f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c64:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
 8048c67:	e8 28 f4 ff ff       	call   8048094 <UKISS>
 8048c6c:	89 c2                	mov    %eax,%edx
 8048c6e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c73:	01 c2                	add    %eax,%edx
 8048c75:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c7a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c7d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048c82:	89 c8                	mov    %ecx,%eax
 8048c84:	f7 e2                	mul    %edx
 8048c86:	d1 ea                	shr    %edx
 8048c88:	89 d0                	mov    %edx,%eax
 8048c8a:	01 c0                	add    %eax,%eax
 8048c8c:	01 d0                	add    %edx,%eax
 8048c8e:	29 c1                	sub    %eax,%ecx
 8048c90:	89 ca                	mov    %ecx,%edx
 8048c92:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048c95:	89 c1                	mov    %eax,%ecx
 8048c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c9a:	89 c2                	mov    %eax,%edx
 8048c9c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048ca3:	89 c2                	mov    %eax,%edx
 8048ca5:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048cac:	29 d0                	sub    %edx,%eax
 8048cae:	83 c0 10             	add    $0x10,%eax
 8048cb1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048cb6:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
 8048cb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048cbc:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048cc0:	0f 8e 6d fc ff ff    	jle    8048933 <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
 8048cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8048cc9:	5b                   	pop    %ebx
 8048cca:	5e                   	pop    %esi
 8048ccb:	5d                   	pop    %ebp
 8048ccc:	c3                   	ret    

08048ccd <createMonster>:
void createMonster(){
 8048ccd:	55                   	push   %ebp
 8048cce:	89 e5                	mov    %esp,%ebp
 8048cd0:	83 ec 18             	sub    $0x18,%esp
	int i=0;
 8048cd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048cda:	e9 e0 01 00 00       	jmp    8048ebf <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
 8048cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ce2:	89 c2                	mov    %eax,%edx
 8048ce4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048ceb:	89 c2                	mov    %eax,%edx
 8048ced:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048cf4:	29 d0                	sub    %edx,%eax
 8048cf6:	83 c0 10             	add    $0x10,%eax
 8048cf9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048cfe:	8b 40 04             	mov    0x4(%eax),%eax
 8048d01:	85 c0                	test   %eax,%eax
 8048d03:	75 05                	jne    8048d0a <createMonster+0x3d>
 8048d05:	e9 b1 01 00 00       	jmp    8048ebb <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
 8048d0a:	e8 85 f3 ff ff       	call   8048094 <UKISS>
 8048d0f:	89 c2                	mov    %eax,%edx
 8048d11:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d16:	01 c2                	add    %eax,%edx
 8048d18:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d1d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048d20:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
 8048d25:	89 c8                	mov    %ecx,%eax
 8048d27:	f7 e2                	mul    %edx
 8048d29:	89 d0                	mov    %edx,%eax
 8048d2b:	c1 e8 0c             	shr    $0xc,%eax
 8048d2e:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
 8048d34:	29 c1                	sub    %eax,%ecx
 8048d36:	89 c8                	mov    %ecx,%eax
 8048d38:	85 c0                	test   %eax,%eax
 8048d3a:	0f 85 7b 01 00 00    	jne    8048ebb <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
 8048d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d43:	89 c2                	mov    %eax,%edx
 8048d45:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048d4c:	89 c2                	mov    %eax,%edx
 8048d4e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048d55:	29 d0                	sub    %edx,%eax
 8048d57:	83 c0 10             	add    $0x10,%eax
 8048d5a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
 8048d66:	e8 29 f3 ff ff       	call   8048094 <UKISS>
 8048d6b:	89 c2                	mov    %eax,%edx
 8048d6d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d72:	01 c2                	add    %eax,%edx
 8048d74:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d79:	01 d0                	add    %edx,%eax
 8048d7b:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048d81:	89 d1                	mov    %edx,%ecx
 8048d83:	ba 00 00 00 00       	mov    $0x0,%edx
 8048d88:	f7 f1                	div    %ecx
 8048d8a:	89 d0                	mov    %edx,%eax
 8048d8c:	83 c0 01             	add    $0x1,%eax
 8048d8f:	01 c0                	add    %eax,%eax
 8048d91:	89 c1                	mov    %eax,%ecx
 8048d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d96:	c1 e0 02             	shl    $0x2,%eax
 8048d99:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048da0:	29 c2                	sub    %eax,%edx
 8048da2:	89 d0                	mov    %edx,%eax
 8048da4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048da9:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
 8048dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dae:	c1 e0 02             	shl    $0x2,%eax
 8048db1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048db8:	29 c2                	sub    %eax,%edx
 8048dba:	89 d0                	mov    %edx,%eax
 8048dbc:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dc1:	8b 00                	mov    (%eax),%eax
 8048dc3:	89 c2                	mov    %eax,%edx
 8048dc5:	83 fa 0e             	cmp    $0xe,%edx
 8048dc8:	7e 05                	jle    8048dcf <createMonster+0x102>
 8048dca:	ba 0e 00 00 00       	mov    $0xe,%edx
 8048dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dd2:	c1 e0 02             	shl    $0x2,%eax
 8048dd5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048ddc:	29 c1                	sub    %eax,%ecx
 8048dde:	89 c8                	mov    %ecx,%eax
 8048de0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048de5:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
 8048de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dea:	c1 e0 02             	shl    $0x2,%eax
 8048ded:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048df4:	29 c2                	sub    %eax,%edx
 8048df6:	89 d0                	mov    %edx,%eax
 8048df8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dfd:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
 8048e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e07:	c1 e0 02             	shl    $0x2,%eax
 8048e0a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048e11:	29 c2                	sub    %eax,%edx
 8048e13:	89 d0                	mov    %edx,%eax
 8048e15:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e1a:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
 8048e21:	e8 6e f2 ff ff       	call   8048094 <UKISS>
 8048e26:	89 c2                	mov    %eax,%edx
 8048e28:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e2d:	01 c2                	add    %eax,%edx
 8048e2f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e34:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048e37:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048e3c:	89 c8                	mov    %ecx,%eax
 8048e3e:	f7 e2                	mul    %edx
 8048e40:	d1 ea                	shr    %edx
 8048e42:	89 d0                	mov    %edx,%eax
 8048e44:	01 c0                	add    %eax,%eax
 8048e46:	01 d0                	add    %edx,%eax
 8048e48:	29 c1                	sub    %eax,%ecx
 8048e4a:	89 ca                	mov    %ecx,%edx
 8048e4c:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048e4f:	89 c1                	mov    %eax,%ecx
 8048e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e54:	c1 e0 02             	shl    $0x2,%eax
 8048e57:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048e5e:	29 c2                	sub    %eax,%edx
 8048e60:	89 d0                	mov    %edx,%eax
 8048e62:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e67:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
 8048e6a:	e8 25 f2 ff ff       	call   8048094 <UKISS>
 8048e6f:	89 c2                	mov    %eax,%edx
 8048e71:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e76:	01 c2                	add    %eax,%edx
 8048e78:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e7d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048e80:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048e85:	89 c8                	mov    %ecx,%eax
 8048e87:	f7 e2                	mul    %edx
 8048e89:	d1 ea                	shr    %edx
 8048e8b:	89 d0                	mov    %edx,%eax
 8048e8d:	01 c0                	add    %eax,%eax
 8048e8f:	01 d0                	add    %edx,%eax
 8048e91:	29 c1                	sub    %eax,%ecx
 8048e93:	89 ca                	mov    %ecx,%edx
 8048e95:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048e98:	89 c1                	mov    %eax,%ecx
 8048e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e9d:	89 c2                	mov    %eax,%edx
 8048e9f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048ea6:	89 c2                	mov    %eax,%edx
 8048ea8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048eaf:	29 d0                	sub    %edx,%eax
 8048eb1:	83 c0 10             	add    $0x10,%eax
 8048eb4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048eb9:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
 8048ebb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048ebf:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048ec3:	0f 8e 16 fe ff ff    	jle    8048cdf <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
 8048ec9:	c9                   	leave  
 8048eca:	c3                   	ret    

08048ecb <dreamOf100HZ>:

void dreamOf100HZ(int timestamp){
 8048ecb:	55                   	push   %ebp
 8048ecc:	89 e5                	mov    %esp,%ebp
 8048ece:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
 8048ed1:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8048ed6:	85 c0                	test   %eax,%eax
 8048ed8:	0f 85 2b 04 00 00    	jne    8049309 <dreamOf100HZ+0x43e>
		//printf("%x\n", st);
		//printf("Score: %d\n", curtime);
		clearStage();
 8048ede:	e8 1f f4 ff ff       	call   8048302 <clearStage>
		drawText1();
 8048ee3:	e8 93 f5 ff ff       	call   804847b <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
 8048ee8:	e8 67 f7 ff ff       	call   8048654 <drawStage>

		int i=0;
 8048eed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
 8048ef4:	c7 05 2c ba 04 08 1e 	movl   $0x1e,0x804ba2c
 8048efb:	00 00 00 
		y = 30;
 8048efe:	c7 05 30 ba 04 08 1e 	movl   $0x1e,0x804ba30
 8048f05:	00 00 00 
		size = 4;
 8048f08:	c7 05 34 ba 04 08 04 	movl   $0x4,0x804ba34
 8048f0f:	00 00 00 
		score = 0;
 8048f12:	c7 05 24 ba 04 08 00 	movl   $0x0,0x804ba24
 8048f19:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
 8048f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f1f:	89 c2                	mov    %eax,%edx
 8048f21:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048f28:	89 c2                	mov    %eax,%edx
 8048f2a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048f31:	29 d0                	sub    %edx,%eax
 8048f33:	83 c0 10             	add    $0x10,%eax
 8048f36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
 8048f42:	e8 4d f1 ff ff       	call   8048094 <UKISS>
 8048f47:	89 c2                	mov    %eax,%edx
 8048f49:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f4e:	01 c2                	add    %eax,%edx
 8048f50:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f55:	01 d0                	add    %edx,%eax
 8048f57:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048f5d:	89 d1                	mov    %edx,%ecx
 8048f5f:	ba 00 00 00 00       	mov    $0x0,%edx
 8048f64:	f7 f1                	div    %ecx
 8048f66:	89 d0                	mov    %edx,%eax
 8048f68:	83 c0 01             	add    $0x1,%eax
 8048f6b:	89 c1                	mov    %eax,%ecx
 8048f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f70:	c1 e0 02             	shl    $0x2,%eax
 8048f73:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f7a:	29 c2                	sub    %eax,%edx
 8048f7c:	89 d0                	mov    %edx,%eax
 8048f7e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f83:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
 8048f85:	e8 0a f1 ff ff       	call   8048094 <UKISS>
 8048f8a:	89 c2                	mov    %eax,%edx
 8048f8c:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f91:	01 c2                	add    %eax,%edx
 8048f93:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f98:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f9b:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8048fa0:	89 c8                	mov    %ecx,%eax
 8048fa2:	f7 e2                	mul    %edx
 8048fa4:	c1 ea 08             	shr    $0x8,%edx
 8048fa7:	89 d0                	mov    %edx,%eax
 8048fa9:	c1 e0 02             	shl    $0x2,%eax
 8048fac:	01 d0                	add    %edx,%eax
 8048fae:	c1 e0 06             	shl    $0x6,%eax
 8048fb1:	29 c1                	sub    %eax,%ecx
 8048fb3:	89 ca                	mov    %ecx,%edx
 8048fb5:	89 d1                	mov    %edx,%ecx
 8048fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fba:	c1 e0 02             	shl    $0x2,%eax
 8048fbd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048fc4:	29 c2                	sub    %eax,%edx
 8048fc6:	89 d0                	mov    %edx,%eax
 8048fc8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048fcd:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
 8048fd0:	e8 bf f0 ff ff       	call   8048094 <UKISS>
 8048fd5:	89 c2                	mov    %eax,%edx
 8048fd7:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048fdc:	01 c2                	add    %eax,%edx
 8048fde:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048fe3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048fe6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8048feb:	89 c8                	mov    %ecx,%eax
 8048fed:	f7 e2                	mul    %edx
 8048fef:	89 d0                	mov    %edx,%eax
 8048ff1:	c1 e8 06             	shr    $0x6,%eax
 8048ff4:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8048ffa:	29 c1                	sub    %eax,%ecx
 8048ffc:	89 c8                	mov    %ecx,%eax
 8048ffe:	89 c1                	mov    %eax,%ecx
 8049000:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049003:	c1 e0 02             	shl    $0x2,%eax
 8049006:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804900d:	29 c2                	sub    %eax,%edx
 804900f:	89 d0                	mov    %edx,%eax
 8049011:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049016:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
 8049019:	e8 76 f0 ff ff       	call   8048094 <UKISS>
 804901e:	89 c2                	mov    %eax,%edx
 8049020:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049025:	01 c2                	add    %eax,%edx
 8049027:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804902c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804902f:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049034:	89 c8                	mov    %ecx,%eax
 8049036:	f7 e2                	mul    %edx
 8049038:	d1 ea                	shr    %edx
 804903a:	89 d0                	mov    %edx,%eax
 804903c:	01 c0                	add    %eax,%eax
 804903e:	01 d0                	add    %edx,%eax
 8049040:	29 c1                	sub    %eax,%ecx
 8049042:	89 ca                	mov    %ecx,%edx
 8049044:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049047:	89 c1                	mov    %eax,%ecx
 8049049:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804904c:	c1 e0 02             	shl    $0x2,%eax
 804904f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049056:	29 c2                	sub    %eax,%edx
 8049058:	89 d0                	mov    %edx,%eax
 804905a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804905f:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
 8049062:	e8 2d f0 ff ff       	call   8048094 <UKISS>
 8049067:	89 c2                	mov    %eax,%edx
 8049069:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804906e:	01 c2                	add    %eax,%edx
 8049070:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049075:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049078:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 804907d:	89 c8                	mov    %ecx,%eax
 804907f:	f7 e2                	mul    %edx
 8049081:	d1 ea                	shr    %edx
 8049083:	89 d0                	mov    %edx,%eax
 8049085:	01 c0                	add    %eax,%eax
 8049087:	01 d0                	add    %edx,%eax
 8049089:	29 c1                	sub    %eax,%ecx
 804908b:	89 ca                	mov    %ecx,%edx
 804908d:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049090:	89 c1                	mov    %eax,%ecx
 8049092:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049095:	89 c2                	mov    %eax,%edx
 8049097:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804909e:	89 c2                	mov    %eax,%edx
 80490a0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80490a7:	29 d0                	sub    %edx,%eax
 80490a9:	83 c0 10             	add    $0x10,%eax
 80490ac:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490b1:	89 08                	mov    %ecx,(%eax)
		i++;
 80490b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
 80490b7:	e9 29 02 00 00       	jmp    80492e5 <dreamOf100HZ+0x41a>
			monsters[i].status = MONSTER_SLEEP;
 80490bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80490bf:	89 c2                	mov    %eax,%edx
 80490c1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80490c8:	89 c2                	mov    %eax,%edx
 80490ca:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80490d1:	29 d0                	sub    %edx,%eax
 80490d3:	83 c0 10             	add    $0x10,%eax
 80490d6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490db:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
 80490e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80490e5:	89 c2                	mov    %eax,%edx
 80490e7:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80490ee:	89 c2                	mov    %eax,%edx
 80490f0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80490f7:	29 d0                	sub    %edx,%eax
 80490f9:	83 c0 10             	add    $0x10,%eax
 80490fc:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049101:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
 8049108:	e8 87 ef ff ff       	call   8048094 <UKISS>
 804910d:	89 c2                	mov    %eax,%edx
 804910f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049114:	01 c2                	add    %eax,%edx
 8049116:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804911b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804911e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8049123:	89 c8                	mov    %ecx,%eax
 8049125:	f7 e2                	mul    %edx
 8049127:	c1 ea 04             	shr    $0x4,%edx
 804912a:	89 d0                	mov    %edx,%eax
 804912c:	c1 e0 02             	shl    $0x2,%eax
 804912f:	01 d0                	add    %edx,%eax
 8049131:	c1 e0 02             	shl    $0x2,%eax
 8049134:	29 c1                	sub    %eax,%ecx
 8049136:	89 ca                	mov    %ecx,%edx
 8049138:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 804913d:	83 c0 03             	add    $0x3,%eax
 8049140:	39 c2                	cmp    %eax,%edx
 8049142:	0f 83 99 01 00 00    	jae    80492e1 <dreamOf100HZ+0x416>
				monsters[i].status = MONSTER_ALIVE;
 8049148:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804914b:	89 c2                	mov    %eax,%edx
 804914d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049154:	89 c2                	mov    %eax,%edx
 8049156:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804915d:	29 d0                	sub    %edx,%eax
 804915f:	83 c0 10             	add    $0x10,%eax
 8049162:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
 804916e:	e8 21 ef ff ff       	call   8048094 <UKISS>
 8049173:	89 c2                	mov    %eax,%edx
 8049175:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804917a:	01 c2                	add    %eax,%edx
 804917c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049181:	01 d0                	add    %edx,%eax
 8049183:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8049189:	89 d1                	mov    %edx,%ecx
 804918b:	ba 00 00 00 00       	mov    $0x0,%edx
 8049190:	f7 f1                	div    %ecx
 8049192:	89 d0                	mov    %edx,%eax
 8049194:	01 c0                	add    %eax,%eax
 8049196:	83 c0 01             	add    $0x1,%eax
 8049199:	89 c1                	mov    %eax,%ecx
 804919b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804919e:	c1 e0 02             	shl    $0x2,%eax
 80491a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491a8:	29 c2                	sub    %eax,%edx
 80491aa:	89 d0                	mov    %edx,%eax
 80491ac:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491b1:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
 80491b3:	e8 dc ee ff ff       	call   8048094 <UKISS>
 80491b8:	89 c2                	mov    %eax,%edx
 80491ba:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80491bf:	01 c2                	add    %eax,%edx
 80491c1:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80491c6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80491c9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80491ce:	89 c8                	mov    %ecx,%eax
 80491d0:	f7 e2                	mul    %edx
 80491d2:	c1 ea 08             	shr    $0x8,%edx
 80491d5:	89 d0                	mov    %edx,%eax
 80491d7:	c1 e0 02             	shl    $0x2,%eax
 80491da:	01 d0                	add    %edx,%eax
 80491dc:	c1 e0 06             	shl    $0x6,%eax
 80491df:	29 c1                	sub    %eax,%ecx
 80491e1:	89 ca                	mov    %ecx,%edx
 80491e3:	89 d1                	mov    %edx,%ecx
 80491e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491e8:	c1 e0 02             	shl    $0x2,%eax
 80491eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491f2:	29 c2                	sub    %eax,%edx
 80491f4:	89 d0                	mov    %edx,%eax
 80491f6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491fb:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
 80491fe:	e8 91 ee ff ff       	call   8048094 <UKISS>
 8049203:	89 c2                	mov    %eax,%edx
 8049205:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804920a:	01 c2                	add    %eax,%edx
 804920c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049211:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049214:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8049219:	89 c8                	mov    %ecx,%eax
 804921b:	f7 e2                	mul    %edx
 804921d:	89 d0                	mov    %edx,%eax
 804921f:	c1 e8 06             	shr    $0x6,%eax
 8049222:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8049228:	29 c1                	sub    %eax,%ecx
 804922a:	89 c8                	mov    %ecx,%eax
 804922c:	89 c1                	mov    %eax,%ecx
 804922e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049231:	c1 e0 02             	shl    $0x2,%eax
 8049234:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804923b:	29 c2                	sub    %eax,%edx
 804923d:	89 d0                	mov    %edx,%eax
 804923f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049244:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
 8049247:	e8 48 ee ff ff       	call   8048094 <UKISS>
 804924c:	89 c2                	mov    %eax,%edx
 804924e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049253:	01 c2                	add    %eax,%edx
 8049255:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804925a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804925d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049262:	89 c8                	mov    %ecx,%eax
 8049264:	f7 e2                	mul    %edx
 8049266:	d1 ea                	shr    %edx
 8049268:	89 d0                	mov    %edx,%eax
 804926a:	01 c0                	add    %eax,%eax
 804926c:	01 d0                	add    %edx,%eax
 804926e:	29 c1                	sub    %eax,%ecx
 8049270:	89 ca                	mov    %ecx,%edx
 8049272:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049275:	89 c1                	mov    %eax,%ecx
 8049277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804927a:	c1 e0 02             	shl    $0x2,%eax
 804927d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049284:	29 c2                	sub    %eax,%edx
 8049286:	89 d0                	mov    %edx,%eax
 8049288:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804928d:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
 8049290:	e8 ff ed ff ff       	call   8048094 <UKISS>
 8049295:	89 c2                	mov    %eax,%edx
 8049297:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804929c:	01 c2                	add    %eax,%edx
 804929e:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492a3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80492a6:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80492ab:	89 c8                	mov    %ecx,%eax
 80492ad:	f7 e2                	mul    %edx
 80492af:	d1 ea                	shr    %edx
 80492b1:	89 d0                	mov    %edx,%eax
 80492b3:	01 c0                	add    %eax,%eax
 80492b5:	01 d0                	add    %edx,%eax
 80492b7:	29 c1                	sub    %eax,%ecx
 80492b9:	89 ca                	mov    %ecx,%edx
 80492bb:	8d 42 ff             	lea    -0x1(%edx),%eax
 80492be:	89 c1                	mov    %eax,%ecx
 80492c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80492c3:	89 c2                	mov    %eax,%edx
 80492c5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80492cc:	89 c2                	mov    %eax,%edx
 80492ce:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80492d5:	29 d0                	sub    %edx,%eax
 80492d7:	83 c0 10             	add    $0x10,%eax
 80492da:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80492df:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
 80492e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80492e5:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 80492e9:	0f 8e cd fd ff ff    	jle    80490bc <dreamOf100HZ+0x1f1>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
 80492ef:	83 ec 0c             	sub    $0xc,%esp
 80492f2:	68 4e a2 04 08       	push   $0x804a24e
 80492f7:	e8 ab 05 00 00       	call   80498a7 <printf>
 80492fc:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
 80492ff:	c7 05 28 ba 04 08 01 	movl   $0x1,0x804ba28
 8049306:	00 00 00 
	}
	if(gameStatus == GAME_READY){
 8049309:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 804930e:	83 f8 01             	cmp    $0x1,%eax
 8049311:	75 2b                	jne    804933e <dreamOf100HZ+0x473>
		//printf("%d\n", key('q'));
		if(key('q') ){
 8049313:	83 ec 0c             	sub    $0xc,%esp
 8049316:	6a 71                	push   $0x71
 8049318:	e8 5c f3 ff ff       	call   8048679 <key>
 804931d:	83 c4 10             	add    $0x10,%esp
 8049320:	84 c0                	test   %al,%al
 8049322:	74 1a                	je     804933e <dreamOf100HZ+0x473>
			printf("Press W, A, S, D to move\n");
 8049324:	83 ec 0c             	sub    $0xc,%esp
 8049327:	68 60 a2 04 08       	push   $0x804a260
 804932c:	e8 76 05 00 00       	call   80498a7 <printf>
 8049331:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
 8049334:	c7 05 28 ba 04 08 02 	movl   $0x2,0x804ba28
 804933b:	00 00 00 
		}
	}

	if(gameStatus == GAME_ING){
 804933e:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049343:	83 f8 02             	cmp    $0x2,%eax
 8049346:	0f 85 28 02 00 00    	jne    8049574 <dreamOf100HZ+0x6a9>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
		if(key('a'))x--;
 804934c:	83 ec 0c             	sub    $0xc,%esp
 804934f:	6a 61                	push   $0x61
 8049351:	e8 23 f3 ff ff       	call   8048679 <key>
 8049356:	83 c4 10             	add    $0x10,%esp
 8049359:	84 c0                	test   %al,%al
 804935b:	74 0d                	je     804936a <dreamOf100HZ+0x49f>
 804935d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049362:	83 e8 01             	sub    $0x1,%eax
 8049365:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('d'))x++;
 804936a:	83 ec 0c             	sub    $0xc,%esp
 804936d:	6a 64                	push   $0x64
 804936f:	e8 05 f3 ff ff       	call   8048679 <key>
 8049374:	83 c4 10             	add    $0x10,%esp
 8049377:	84 c0                	test   %al,%al
 8049379:	74 0d                	je     8049388 <dreamOf100HZ+0x4bd>
 804937b:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049380:	83 c0 01             	add    $0x1,%eax
 8049383:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('w'))y--;
 8049388:	83 ec 0c             	sub    $0xc,%esp
 804938b:	6a 77                	push   $0x77
 804938d:	e8 e7 f2 ff ff       	call   8048679 <key>
 8049392:	83 c4 10             	add    $0x10,%esp
 8049395:	84 c0                	test   %al,%al
 8049397:	74 0d                	je     80493a6 <dreamOf100HZ+0x4db>
 8049399:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804939e:	83 e8 01             	sub    $0x1,%eax
 80493a1:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(key('s'))y++;
 80493a6:	83 ec 0c             	sub    $0xc,%esp
 80493a9:	6a 73                	push   $0x73
 80493ab:	e8 c9 f2 ff ff       	call   8048679 <key>
 80493b0:	83 c4 10             	add    $0x10,%esp
 80493b3:	84 c0                	test   %al,%al
 80493b5:	74 0d                	je     80493c4 <dreamOf100HZ+0x4f9>
 80493b7:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80493bc:	83 c0 01             	add    $0x1,%eax
 80493bf:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		if(key('l')){
 80493c4:	83 ec 0c             	sub    $0xc,%esp
 80493c7:	6a 6c                	push   $0x6c
 80493c9:	e8 ab f2 ff ff       	call   8048679 <key>
 80493ce:	83 c4 10             	add    $0x10,%esp
 80493d1:	84 c0                	test   %al,%al
 80493d3:	74 23                	je     80493f8 <dreamOf100HZ+0x52d>
			printf("GAME#%d: Sleep 5s!\n", getpid());
 80493d5:	e8 b5 ed ff ff       	call   804818f <sys_pid>
 80493da:	83 ec 08             	sub    $0x8,%esp
 80493dd:	50                   	push   %eax
 80493de:	68 7a a2 04 08       	push   $0x804a27a
 80493e3:	e8 bf 04 00 00       	call   80498a7 <printf>
 80493e8:	83 c4 10             	add    $0x10,%esp
			sleep(5);
 80493eb:	83 ec 0c             	sub    $0xc,%esp
 80493ee:	6a 05                	push   $0x5
 80493f0:	e8 b6 ed ff ff       	call   80481ab <sys_sleep>
 80493f5:	83 c4 10             	add    $0x10,%esp
		}
		if(key('m')){
 80493f8:	83 ec 0c             	sub    $0xc,%esp
 80493fb:	6a 6d                	push   $0x6d
 80493fd:	e8 77 f2 ff ff       	call   8048679 <key>
 8049402:	83 c4 10             	add    $0x10,%esp
 8049405:	84 c0                	test   %al,%al
 8049407:	74 25                	je     804942e <dreamOf100HZ+0x563>
			clearStage();
 8049409:	e8 f4 ee ff ff       	call   8048302 <clearStage>
			drawStage();
 804940e:	e8 41 f2 ff ff       	call   8048654 <drawStage>
			printf("GAME#%d: Ready to exit! Bye!\n", getpid());
 8049413:	e8 77 ed ff ff       	call   804818f <sys_pid>
 8049418:	83 ec 08             	sub    $0x8,%esp
 804941b:	50                   	push   %eax
 804941c:	68 8e a2 04 08       	push   $0x804a28e
 8049421:	e8 81 04 00 00       	call   80498a7 <printf>
 8049426:	83 c4 10             	add    $0x10,%esp
			exit();
 8049429:	e8 39 ed ff ff       	call   8048167 <sys_exit>
		}
		if(key('k')){
 804942e:	83 ec 0c             	sub    $0xc,%esp
 8049431:	6a 6b                	push   $0x6b
 8049433:	e8 41 f2 ff ff       	call   8048679 <key>
 8049438:	83 c4 10             	add    $0x10,%esp
 804943b:	84 c0                	test   %al,%al
 804943d:	74 1b                	je     804945a <dreamOf100HZ+0x58f>
			printf("GAME#%d: Fork!\n", getpid());
 804943f:	e8 4b ed ff ff       	call   804818f <sys_pid>
 8049444:	83 ec 08             	sub    $0x8,%esp
 8049447:	50                   	push   %eax
 8049448:	68 ac a2 04 08       	push   $0x804a2ac
 804944d:	e8 55 04 00 00       	call   80498a7 <printf>
 8049452:	83 c4 10             	add    $0x10,%esp
			fork();
 8049455:	e8 19 ed ff ff       	call   8048173 <sys_fork>
		}
		if(x < 0) x++;
 804945a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804945f:	85 c0                	test   %eax,%eax
 8049461:	79 0d                	jns    8049470 <dreamOf100HZ+0x5a5>
 8049463:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049468:	83 c0 01             	add    $0x1,%eax
 804946b:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(x > VWIDTH) x--;
 8049470:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049475:	3d 40 01 00 00       	cmp    $0x140,%eax
 804947a:	7e 0d                	jle    8049489 <dreamOf100HZ+0x5be>
 804947c:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049481:	83 e8 01             	sub    $0x1,%eax
 8049484:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(y < 0) y++;
 8049489:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804948e:	85 c0                	test   %eax,%eax
 8049490:	79 0d                	jns    804949f <dreamOf100HZ+0x5d4>
 8049492:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049497:	83 c0 01             	add    $0x1,%eax
 804949a:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(y > VHEIGHT) y--;
 804949f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80494a4:	3d c8 00 00 00       	cmp    $0xc8,%eax
 80494a9:	7e 0d                	jle    80494b8 <dreamOf100HZ+0x5ed>
 80494ab:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80494b0:	83 e8 01             	sub    $0x1,%eax
 80494b3:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		//else{
		clearStage();
 80494b8:	e8 45 ee ff ff       	call   8048302 <clearStage>
		drawCirc(x, y, size, 3);
 80494bd:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 80494c3:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80494c9:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80494ce:	6a 03                	push   $0x3
 80494d0:	51                   	push   %ecx
 80494d1:	52                   	push   %edx
 80494d2:	50                   	push   %eax
 80494d3:	e8 f6 ee ff ff       	call   80483ce <drawCirc>
 80494d8:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
 80494db:	e8 3f f4 ff ff       	call   804891f <drawMonster>
		drawCirc(x, y, size, 3);
 80494e0:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 80494e6:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80494ec:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80494f1:	6a 03                	push   $0x3
 80494f3:	51                   	push   %ecx
 80494f4:	52                   	push   %edx
 80494f5:	50                   	push   %eax
 80494f6:	e8 d3 ee ff ff       	call   80483ce <drawCirc>
 80494fb:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 10, 180, 1, 7);
 80494fe:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8049503:	83 ec 0c             	sub    $0xc,%esp
 8049506:	6a 07                	push   $0x7
 8049508:	6a 01                	push   $0x1
 804950a:	68 b4 00 00 00       	push   $0xb4
 804950f:	6a 0a                	push   $0xa
 8049511:	50                   	push   %eax
 8049512:	e8 dc ef ff ff       	call   80484f3 <drawNumber>
 8049517:	83 c4 20             	add    $0x20,%esp
		drawNumber(getpid(), 300, 10, 1, 7);
 804951a:	e8 70 ec ff ff       	call   804818f <sys_pid>
 804951f:	83 ec 0c             	sub    $0xc,%esp
 8049522:	6a 07                	push   $0x7
 8049524:	6a 01                	push   $0x1
 8049526:	6a 0a                	push   $0xa
 8049528:	68 2c 01 00 00       	push   $0x12c
 804952d:	50                   	push   %eax
 804952e:	e8 c0 ef ff ff       	call   80484f3 <drawNumber>
 8049533:	83 c4 20             	add    $0x20,%esp
		if(key('p')){
 8049536:	83 ec 0c             	sub    $0xc,%esp
 8049539:	6a 70                	push   $0x70
 804953b:	e8 39 f1 ff ff       	call   8048679 <key>
 8049540:	83 c4 10             	add    $0x10,%esp
 8049543:	84 c0                	test   %al,%al
 8049545:	74 19                	je     8049560 <dreamOf100HZ+0x695>
			drawNumber(getpid(), 100, 100, 5, 7);
 8049547:	e8 43 ec ff ff       	call   804818f <sys_pid>
 804954c:	83 ec 0c             	sub    $0xc,%esp
 804954f:	6a 07                	push   $0x7
 8049551:	6a 05                	push   $0x5
 8049553:	6a 64                	push   $0x64
 8049555:	6a 64                	push   $0x64
 8049557:	50                   	push   %eax
 8049558:	e8 96 ef ff ff       	call   80484f3 <drawNumber>
 804955d:	83 c4 20             	add    $0x20,%esp
		}
		drawStage();
 8049560:	e8 ef f0 ff ff       	call   8048654 <drawStage>
		
		
		createMonster();
 8049565:	e8 63 f7 ff ff       	call   8048ccd <createMonster>
		while(hitMonster());
 804956a:	90                   	nop
 804956b:	e8 f0 f1 ff ff       	call   8048760 <hitMonster>
 8049570:	85 c0                	test   %eax,%eax
 8049572:	75 f7                	jne    804956b <dreamOf100HZ+0x6a0>
		//}
	}
	if(gameStatus == GAME_END){
 8049574:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049579:	83 f8 03             	cmp    $0x3,%eax
 804957c:	75 3a                	jne    80495b8 <dreamOf100HZ+0x6ed>
		printf("You're dead\n");
 804957e:	83 ec 0c             	sub    $0xc,%esp
 8049581:	68 bc a2 04 08       	push   $0x804a2bc
 8049586:	e8 1c 03 00 00       	call   80498a7 <printf>
 804958b:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
 804958e:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8049593:	83 ec 08             	sub    $0x8,%esp
 8049596:	50                   	push   %eax
 8049597:	68 c9 a2 04 08       	push   $0x804a2c9
 804959c:	e8 06 03 00 00       	call   80498a7 <printf>
 80495a1:	83 c4 10             	add    $0x10,%esp
		clearStage();
 80495a4:	e8 59 ed ff ff       	call   8048302 <clearStage>
		drawStage();
 80495a9:	e8 a6 f0 ff ff       	call   8048654 <drawStage>
		gameStatus = GAME_START;
 80495ae:	c7 05 28 ba 04 08 00 	movl   $0x0,0x804ba28
 80495b5:	00 00 00 
	}
 80495b8:	c9                   	leave  
 80495b9:	c3                   	ret    

080495ba <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 80495ba:	55                   	push   %ebp
 80495bb:	89 e5                	mov    %esp,%ebp
 80495bd:	53                   	push   %ebx
 80495be:	83 ec 04             	sub    $0x4,%esp
 80495c1:	8b 45 08             	mov    0x8(%ebp),%eax
 80495c4:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80495c7:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80495cc:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80495d0:	89 d3                	mov    %edx,%ebx
 80495d2:	cd 80                	int    $0x80
}
 80495d4:	83 c4 04             	add    $0x4,%esp
 80495d7:	5b                   	pop    %ebx
 80495d8:	5d                   	pop    %ebp
 80495d9:	c3                   	ret    

080495da <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80495da:	55                   	push   %ebp
 80495db:	89 e5                	mov    %esp,%ebp
 80495dd:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80495e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 80495e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80495e6:	eb 19                	jmp    8049601 <printp+0x27>
		printer(cur);
 80495e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80495eb:	0f b6 00             	movzbl (%eax),%eax
 80495ee:	0f be c0             	movsbl %al,%eax
 80495f1:	83 ec 0c             	sub    $0xc,%esp
 80495f4:	50                   	push   %eax
 80495f5:	8b 45 08             	mov    0x8(%ebp),%eax
 80495f8:	ff d0                	call   *%eax
 80495fa:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80495fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049604:	0f b6 00             	movzbl (%eax),%eax
 8049607:	84 c0                	test   %al,%al
 8049609:	75 dd                	jne    80495e8 <printp+0xe>
		printer(cur);
	}
}
 804960b:	c9                   	leave  
 804960c:	c3                   	ret    

0804960d <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 804960d:	55                   	push   %ebp
 804960e:	89 e5                	mov    %esp,%ebp
 8049610:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 8049613:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8049619:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8049620:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8049627:	8b 45 10             	mov    0x10(%ebp),%eax
 804962a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 804962d:	e9 65 02 00 00       	jmp    8049897 <vfprintf+0x28a>

		if(cur == '%'){
 8049632:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049635:	0f b6 00             	movzbl (%eax),%eax
 8049638:	3c 25                	cmp    $0x25,%al
 804963a:	75 0c                	jne    8049648 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 804963c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8049643:	e9 4b 02 00 00       	jmp    8049893 <vfprintf+0x286>
		}
		if(type == READ){
 8049648:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 804964c:	0f 85 26 02 00 00    	jne    8049878 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8049652:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049655:	0f b6 00             	movzbl (%eax),%eax
 8049658:	3c 73                	cmp    $0x73,%al
 804965a:	75 35                	jne    8049691 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 804965c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804965f:	8b 00                	mov    (%eax),%eax
 8049661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8049664:	eb 19                	jmp    804967f <vfprintf+0x72>
					printer(*p);
 8049666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049669:	0f b6 00             	movzbl (%eax),%eax
 804966c:	0f be c0             	movsbl %al,%eax
 804966f:	83 ec 0c             	sub    $0xc,%esp
 8049672:	50                   	push   %eax
 8049673:	8b 45 08             	mov    0x8(%ebp),%eax
 8049676:	ff d0                	call   *%eax
 8049678:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 804967b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 804967f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049682:	0f b6 00             	movzbl (%eax),%eax
 8049685:	84 c0                	test   %al,%al
 8049687:	75 dd                	jne    8049666 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8049689:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804968d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8049691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049694:	0f b6 00             	movzbl (%eax),%eax
 8049697:	3c 78                	cmp    $0x78,%al
 8049699:	0f 85 99 00 00 00    	jne    8049738 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 804969f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80496a2:	8b 00                	mov    (%eax),%eax
 80496a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 80496a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80496ab:	75 1d                	jne    80496ca <vfprintf+0xbd>
					printer('0');
 80496ad:	83 ec 0c             	sub    $0xc,%esp
 80496b0:	6a 30                	push   $0x30
 80496b2:	8b 45 08             	mov    0x8(%ebp),%eax
 80496b5:	ff d0                	call   *%eax
 80496b7:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80496ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80496be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80496c5:	e9 c9 01 00 00       	jmp    8049893 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80496ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80496d1:	eb 2d                	jmp    8049700 <vfprintf+0xf3>
					int d=(x%16);
 80496d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80496d6:	83 e0 0f             	and    $0xf,%eax
 80496d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80496dc:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80496e0:	7e 04                	jle    80496e6 <vfprintf+0xd9>
						d+='a'-'0'-10;
 80496e2:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80496e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80496e9:	83 c0 30             	add    $0x30,%eax
 80496ec:	89 c1                	mov    %eax,%ecx
 80496ee:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80496f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80496f4:	01 d0                	add    %edx,%eax
 80496f6:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80496f8:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80496fc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8049700:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8049704:	75 cd                	jne    80496d3 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8049706:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 804970a:	eb 1e                	jmp    804972a <vfprintf+0x11d>
					printer(digits[di]);
 804970c:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804970f:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8049712:	01 d0                	add    %edx,%eax
 8049714:	0f b6 00             	movzbl (%eax),%eax
 8049717:	0f be c0             	movsbl %al,%eax
 804971a:	83 ec 0c             	sub    $0xc,%esp
 804971d:	50                   	push   %eax
 804971e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049721:	ff d0                	call   *%eax
 8049723:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8049726:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 804972a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804972e:	79 dc                	jns    804970c <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8049730:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049734:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8049738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804973b:	0f b6 00             	movzbl (%eax),%eax
 804973e:	3c 64                	cmp    $0x64,%al
 8049740:	0f 85 02 01 00 00    	jne    8049848 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8049746:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049749:	8b 00                	mov    (%eax),%eax
 804974b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 804974e:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8049755:	75 23                	jne    804977a <vfprintf+0x16d>
					printp(printer, "-2147483648");
 8049757:	83 ec 08             	sub    $0x8,%esp
 804975a:	68 d4 a2 04 08       	push   $0x804a2d4
 804975f:	ff 75 08             	pushl  0x8(%ebp)
 8049762:	e8 73 fe ff ff       	call   80495da <printp>
 8049767:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804976a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804976e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8049775:	e9 19 01 00 00       	jmp    8049893 <vfprintf+0x286>
				}
				if(x==0){
 804977a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804977e:	75 1e                	jne    804979e <vfprintf+0x191>
					printer('0');
 8049780:	83 ec 0c             	sub    $0xc,%esp
 8049783:	6a 30                	push   $0x30
 8049785:	8b 45 08             	mov    0x8(%ebp),%eax
 8049788:	ff d0                	call   *%eax
 804978a:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804978d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8049791:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8049798:	90                   	nop
 8049799:	e9 f5 00 00 00       	jmp    8049893 <vfprintf+0x286>
				}
				if(x<0){
 804979e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80497a2:	79 10                	jns    80497b4 <vfprintf+0x1a7>
					printer('-');
 80497a4:	83 ec 0c             	sub    $0xc,%esp
 80497a7:	6a 2d                	push   $0x2d
 80497a9:	8b 45 08             	mov    0x8(%ebp),%eax
 80497ac:	ff d0                	call   *%eax
 80497ae:	83 c4 10             	add    $0x10,%esp
					x=-x;
 80497b1:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 80497b4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 80497bb:	eb 53                	jmp    8049810 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 80497bd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80497c0:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80497c5:	89 c8                	mov    %ecx,%eax
 80497c7:	f7 ea                	imul   %edx
 80497c9:	c1 fa 02             	sar    $0x2,%edx
 80497cc:	89 c8                	mov    %ecx,%eax
 80497ce:	c1 f8 1f             	sar    $0x1f,%eax
 80497d1:	29 c2                	sub    %eax,%edx
 80497d3:	89 d0                	mov    %edx,%eax
 80497d5:	c1 e0 02             	shl    $0x2,%eax
 80497d8:	01 d0                	add    %edx,%eax
 80497da:	01 c0                	add    %eax,%eax
 80497dc:	29 c1                	sub    %eax,%ecx
 80497de:	89 ca                	mov    %ecx,%edx
 80497e0:	89 d0                	mov    %edx,%eax
 80497e2:	83 c0 30             	add    $0x30,%eax
 80497e5:	89 c1                	mov    %eax,%ecx
 80497e7:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80497ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80497ed:	01 d0                	add    %edx,%eax
 80497ef:	88 08                	mov    %cl,(%eax)
					x/=10;
 80497f1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80497f4:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80497f9:	89 c8                	mov    %ecx,%eax
 80497fb:	f7 ea                	imul   %edx
 80497fd:	c1 fa 02             	sar    $0x2,%edx
 8049800:	89 c8                	mov    %ecx,%eax
 8049802:	c1 f8 1f             	sar    $0x1f,%eax
 8049805:	29 c2                	sub    %eax,%edx
 8049807:	89 d0                	mov    %edx,%eax
 8049809:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 804980c:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8049810:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8049814:	7f a7                	jg     80497bd <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8049816:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 804981a:	eb 1e                	jmp    804983a <vfprintf+0x22d>
					printer(digits[di]);
 804981c:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 804981f:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049822:	01 d0                	add    %edx,%eax
 8049824:	0f b6 00             	movzbl (%eax),%eax
 8049827:	0f be c0             	movsbl %al,%eax
 804982a:	83 ec 0c             	sub    $0xc,%esp
 804982d:	50                   	push   %eax
 804982e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049831:	ff d0                	call   *%eax
 8049833:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8049836:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 804983a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 804983e:	79 dc                	jns    804981c <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8049840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049844:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 8049848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804984b:	0f b6 00             	movzbl (%eax),%eax
 804984e:	3c 63                	cmp    $0x63,%al
 8049850:	75 1d                	jne    804986f <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8049852:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049855:	0f b6 00             	movzbl (%eax),%eax
 8049858:	0f be c0             	movsbl %al,%eax
 804985b:	83 ec 0c             	sub    $0xc,%esp
 804985e:	50                   	push   %eax
 804985f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049862:	ff d0                	call   *%eax
 8049864:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 8049867:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804986b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 804986f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8049876:	eb 1b                	jmp    8049893 <vfprintf+0x286>
		}
		if(type == NONE){
 8049878:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 804987c:	75 15                	jne    8049893 <vfprintf+0x286>
			printer(cur);
 804987e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049881:	0f b6 00             	movzbl (%eax),%eax
 8049884:	0f be c0             	movsbl %al,%eax
 8049887:	83 ec 0c             	sub    $0xc,%esp
 804988a:	50                   	push   %eax
 804988b:	8b 45 08             	mov    0x8(%ebp),%eax
 804988e:	ff d0                	call   *%eax
 8049890:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8049893:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804989a:	0f b6 00             	movzbl (%eax),%eax
 804989d:	84 c0                	test   %al,%al
 804989f:	0f 85 8d fd ff ff    	jne    8049632 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 80498a5:	c9                   	leave  
 80498a6:	c3                   	ret    

080498a7 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 80498a7:	55                   	push   %ebp
 80498a8:	89 e5                	mov    %esp,%ebp
 80498aa:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 80498ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 80498b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 80498b3:	8b 45 08             	mov    0x8(%ebp),%eax
 80498b6:	83 ec 04             	sub    $0x4,%esp
 80498b9:	ff 75 f4             	pushl  -0xc(%ebp)
 80498bc:	50                   	push   %eax
 80498bd:	68 ba 95 04 08       	push   $0x80495ba
 80498c2:	e8 46 fd ff ff       	call   804960d <vfprintf>
 80498c7:	83 c4 10             	add    $0x10,%esp
}
 80498ca:	c9                   	leave  
 80498cb:	c3                   	ret    
