
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

08048167 <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
 8048167:	55                   	push   %ebp
 8048168:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
 804816a:	b8 4c 04 00 00       	mov    $0x44c,%eax
 804816f:	cd 80                	int    $0x80
}
 8048171:	5d                   	pop    %ebp
 8048172:	c3                   	ret    

08048173 <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
 8048173:	55                   	push   %ebp
 8048174:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
 8048176:	b8 4e 04 00 00       	mov    $0x44e,%eax
 804817b:	cd 80                	int    $0x80
}
 804817d:	5d                   	pop    %ebp
 804817e:	c3                   	ret    

0804817f <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
 804817f:	55                   	push   %ebp
 8048180:	89 e5                	mov    %esp,%ebp
 8048182:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
 8048183:	b8 4f 04 00 00       	mov    $0x44f,%eax
 8048188:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804818b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804818e:	8b 55 10             	mov    0x10(%ebp),%edx
 8048191:	cd 80                	int    $0x80
}
 8048193:	5b                   	pop    %ebx
 8048194:	5d                   	pop    %ebp
 8048195:	c3                   	ret    

08048196 <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
 8048196:	55                   	push   %ebp
 8048197:	89 e5                	mov    %esp,%ebp
 8048199:	53                   	push   %ebx
 804819a:	83 ec 14             	sub    $0x14,%esp
 804819d:	8b 45 08             	mov    0x8(%ebp),%eax
 80481a0:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
 80481a3:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
 80481a7:	b8 b0 04 00 00       	mov    $0x4b0,%eax
 80481ac:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 80481b0:	89 d3                	mov    %edx,%ebx
 80481b2:	cd 80                	int    $0x80
 80481b4:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481b7:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
 80481bb:	83 c4 14             	add    $0x14,%esp
 80481be:	5b                   	pop    %ebx
 80481bf:	5d                   	pop    %ebp
 80481c0:	c3                   	ret    

080481c1 <sys_get_tick>:
static inline uint32_t sys_get_tick(){
 80481c1:	55                   	push   %ebp
 80481c2:	89 e5                	mov    %esp,%ebp
 80481c4:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 80481c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
 80481ce:	b8 15 05 00 00       	mov    $0x515,%eax
 80481d3:	cd 80                	int    $0x80
 80481d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80481db:	c9                   	leave  
 80481dc:	c3                   	ret    

080481dd <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
 80481dd:	55                   	push   %ebp
 80481de:	89 e5                	mov    %esp,%ebp
 80481e0:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
 80481e3:	8b 45 08             	mov    0x8(%ebp),%eax
 80481e6:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 80481ed:	85 c0                	test   %eax,%eax
 80481ef:	74 0f                	je     8048200 <isqrt+0x23>
 80481f1:	8b 45 08             	mov    0x8(%ebp),%eax
 80481f4:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 80481fb:	e9 a9 00 00 00       	jmp    80482a9 <isqrt+0xcc>
    const uint16_t *p = squares;
 8048200:	c7 45 fc 40 97 04 08 	movl   $0x8049740,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
 8048207:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804820a:	83 c0 40             	add    $0x40,%eax
 804820d:	0f b7 00             	movzwl (%eax),%eax
 8048210:	0f b7 c0             	movzwl %ax,%eax
 8048213:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048216:	77 04                	ja     804821c <isqrt+0x3f>
 8048218:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
 804821c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804821f:	83 c0 20             	add    $0x20,%eax
 8048222:	0f b7 00             	movzwl (%eax),%eax
 8048225:	0f b7 c0             	movzwl %ax,%eax
 8048228:	3b 45 08             	cmp    0x8(%ebp),%eax
 804822b:	77 04                	ja     8048231 <isqrt+0x54>
 804822d:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
 8048231:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048234:	83 c0 10             	add    $0x10,%eax
 8048237:	0f b7 00             	movzwl (%eax),%eax
 804823a:	0f b7 c0             	movzwl %ax,%eax
 804823d:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048240:	77 04                	ja     8048246 <isqrt+0x69>
 8048242:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
 8048246:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048249:	83 c0 08             	add    $0x8,%eax
 804824c:	0f b7 00             	movzwl (%eax),%eax
 804824f:	0f b7 c0             	movzwl %ax,%eax
 8048252:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048255:	77 04                	ja     804825b <isqrt+0x7e>
 8048257:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
 804825b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804825e:	83 c0 04             	add    $0x4,%eax
 8048261:	0f b7 00             	movzwl (%eax),%eax
 8048264:	0f b7 c0             	movzwl %ax,%eax
 8048267:	3b 45 08             	cmp    0x8(%ebp),%eax
 804826a:	77 04                	ja     8048270 <isqrt+0x93>
 804826c:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
 8048270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048273:	83 c0 02             	add    $0x2,%eax
 8048276:	0f b7 00             	movzwl (%eax),%eax
 8048279:	0f b7 c0             	movzwl %ax,%eax
 804827c:	3b 45 08             	cmp    0x8(%ebp),%eax
 804827f:	77 04                	ja     8048285 <isqrt+0xa8>
 8048281:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
 8048285:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048288:	ba 40 97 04 08       	mov    $0x8049740,%edx
 804828d:	29 d0                	sub    %edx,%eax
 804828f:	d1 f8                	sar    %eax
 8048291:	89 c2                	mov    %eax,%edx
 8048293:	8b 45 08             	mov    0x8(%ebp),%eax
 8048296:	89 14 85 c0 b0 04 08 	mov    %edx,0x804b0c0(,%eax,4)
    return p - squares;
 804829d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482a0:	ba 40 97 04 08       	mov    $0x8049740,%edx
 80482a5:	29 d0                	sub    %edx,%eax
 80482a7:	d1 f8                	sar    %eax
}
 80482a9:	c9                   	leave  
 80482aa:	c3                   	ret    

080482ab <clearStage>:


static inline void clearStage(){
 80482ab:	55                   	push   %ebp
 80482ac:	89 e5                	mov    %esp,%ebp
	hash = 0;
 80482ae:	c7 05 80 b0 04 08 00 	movl   $0x0,0x804b080
 80482b5:	00 00 00 
	sys_init_vcache();
 80482b8:	e8 aa fe ff ff       	call   8048167 <sys_init_vcache>
}
 80482bd:	5d                   	pop    %ebp
 80482be:	c3                   	ret    

080482bf <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
 80482bf:	55                   	push   %ebp
 80482c0:	89 e5                	mov    %esp,%ebp
 80482c2:	83 ec 04             	sub    $0x4,%esp
 80482c5:	8b 45 10             	mov    0x10(%ebp),%eax
 80482c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
 80482cb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 80482cf:	50                   	push   %eax
 80482d0:	ff 75 08             	pushl  0x8(%ebp)
 80482d3:	ff 75 0c             	pushl  0xc(%ebp)
 80482d6:	e8 a4 fe ff ff       	call   804817f <sys_set_pixel>
 80482db:	83 c4 0c             	add    $0xc,%esp
}
 80482de:	c9                   	leave  
 80482df:	c3                   	ret    

080482e0 <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
 80482e0:	55                   	push   %ebp
 80482e1:	89 e5                	mov    %esp,%ebp
 80482e3:	53                   	push   %ebx
 80482e4:	83 ec 14             	sub    $0x14,%esp
 80482e7:	8b 45 18             	mov    0x18(%ebp),%eax
 80482ea:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
 80482ed:	8b 45 08             	mov    0x8(%ebp),%eax
 80482f0:	6b d0 1d             	imul   $0x1d,%eax,%edx
 80482f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80482f6:	6b c0 39             	imul   $0x39,%eax,%eax
 80482f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80482fc:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 8048300:	89 d0                	mov    %edx,%eax
 8048302:	01 c0                	add    %eax,%eax
 8048304:	01 d0                	add    %edx,%eax
 8048306:	c1 e0 02             	shl    $0x2,%eax
 8048309:	01 d0                	add    %edx,%eax
 804830b:	01 c8                	add    %ecx,%eax
 804830d:	89 c2                	mov    %eax,%edx
 804830f:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048314:	01 d0                	add    %edx,%eax
 8048316:	a3 80 b0 04 08       	mov    %eax,0x804b080
	int i=0, j=0;
 804831b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
 8048329:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048330:	eb 38                	jmp    804836a <drawRect+0x8a>
		for(j=0;j<h;j++){
 8048332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048339:	eb 23                	jmp    804835e <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
 804833b:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804833f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048342:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048345:	01 d1                	add    %edx,%ecx
 8048347:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804834a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 804834d:	01 da                	add    %ebx,%edx
 804834f:	50                   	push   %eax
 8048350:	51                   	push   %ecx
 8048351:	52                   	push   %edx
 8048352:	e8 68 ff ff ff       	call   80482bf <drawPoint>
 8048357:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
 804835a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804835e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048361:	3b 45 14             	cmp    0x14(%ebp),%eax
 8048364:	7c d5                	jl     804833b <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
 8048366:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 804836a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804836d:	3b 45 10             	cmp    0x10(%ebp),%eax
 8048370:	7c c0                	jl     8048332 <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
 8048372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048375:	c9                   	leave  
 8048376:	c3                   	ret    

08048377 <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
 8048377:	55                   	push   %ebp
 8048378:	89 e5                	mov    %esp,%ebp
 804837a:	53                   	push   %ebx
 804837b:	83 ec 14             	sub    $0x14,%esp
 804837e:	8b 45 14             	mov    0x14(%ebp),%eax
 8048381:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
 8048384:	8b 45 08             	mov    0x8(%ebp),%eax
 8048387:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
 804838d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048390:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
 8048396:	01 c2                	add    %eax,%edx
 8048398:	8b 45 10             	mov    0x10(%ebp),%eax
 804839b:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
 80483a1:	01 d0                	add    %edx,%eax
 80483a3:	89 c2                	mov    %eax,%edx
 80483a5:	a1 80 b0 04 08       	mov    0x804b080,%eax
 80483aa:	01 d0                	add    %edx,%eax
 80483ac:	a3 80 b0 04 08       	mov    %eax,0x804b080
	for(i=-r; i<=r; i++){
 80483b1:	8b 45 10             	mov    0x10(%ebp),%eax
 80483b4:	f7 d8                	neg    %eax
 80483b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
 80483b9:	eb 5c                	jmp    8048417 <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
 80483bb:	8b 45 10             	mov    0x10(%ebp),%eax
 80483be:	0f af 45 10          	imul   0x10(%ebp),%eax
 80483c2:	89 c2                	mov    %eax,%edx
 80483c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80483c7:	0f af 45 f8          	imul   -0x8(%ebp),%eax
 80483cb:	29 c2                	sub    %eax,%edx
 80483cd:	89 d0                	mov    %edx,%eax
 80483cf:	50                   	push   %eax
 80483d0:	e8 08 fe ff ff       	call   80481dd <isqrt>
 80483d5:	83 c4 04             	add    $0x4,%esp
 80483d8:	83 c0 01             	add    $0x1,%eax
 80483db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 80483de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80483e1:	f7 d8                	neg    %eax
 80483e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80483e6:	eb 23                	jmp    804840b <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
 80483e8:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 80483ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80483ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 80483f2:	01 d1                	add    %edx,%ecx
 80483f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80483f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80483fa:	01 da                	add    %ebx,%edx
 80483fc:	50                   	push   %eax
 80483fd:	51                   	push   %ecx
 80483fe:	52                   	push   %edx
 80483ff:	e8 bb fe ff ff       	call   80482bf <drawPoint>
 8048404:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 8048407:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804840b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804840e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8048411:	7e d5                	jle    80483e8 <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
 8048413:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048417:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804841a:	3b 45 10             	cmp    0x10(%ebp),%eax
 804841d:	7e 9c                	jle    80483bb <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
 804841f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048422:	c9                   	leave  
 8048423:	c3                   	ret    

08048424 <drawText1>:

static inline void drawText1(){
 8048424:	55                   	push   %ebp
 8048425:	89 e5                	mov    %esp,%ebp
 8048427:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
 804842a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048431:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
 8048438:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804843f:	eb 53                	jmp    8048494 <drawText1+0x70>
        for(i=0;i<52;i++){
 8048441:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048448:	eb 40                	jmp    804848a <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
 804844a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804844d:	6b d0 34             	imul   $0x34,%eax,%edx
 8048450:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048453:	01 d0                	add    %edx,%eax
 8048455:	0f b6 80 40 99 04 08 	movzbl 0x8049940(%eax),%eax
 804845c:	84 c0                	test   %al,%al
 804845e:	74 26                	je     8048486 <drawText1+0x62>
 8048460:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048463:	89 d0                	mov    %edx,%eax
 8048465:	c1 e0 02             	shl    $0x2,%eax
 8048468:	01 d0                	add    %edx,%eax
 804846a:	8d 50 14             	lea    0x14(%eax),%edx
 804846d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048470:	c1 e0 02             	shl    $0x2,%eax
 8048473:	83 c0 32             	add    $0x32,%eax
 8048476:	6a 0e                	push   $0xe
 8048478:	6a 05                	push   $0x5
 804847a:	6a 04                	push   $0x4
 804847c:	52                   	push   %edx
 804847d:	50                   	push   %eax
 804847e:	e8 5d fe ff ff       	call   80482e0 <drawRect>
 8048483:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
 8048486:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804848a:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
 804848e:	7e ba                	jle    804844a <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
 8048490:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048494:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 8048498:	7e a7                	jle    8048441 <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
 804849a:	c9                   	leave  
 804849b:	c3                   	ret    

0804849c <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
 804849c:	55                   	push   %ebp
 804849d:	89 e5                	mov    %esp,%ebp
 804849f:	53                   	push   %ebx
 80484a0:	83 ec 24             	sub    $0x24,%esp
 80484a3:	8b 45 18             	mov    0x18(%ebp),%eax
 80484a6:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
 80484a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
 80484b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 80484b4:	75 0d                	jne    80484c3 <drawNumber+0x27>
        temp[0] = '0';
 80484b6:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
 80484ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 80484c1:	eb 5f                	jmp    8048522 <drawNumber+0x86>

    }else{    
        while(num>=1){
 80484c3:	eb 53                	jmp    8048518 <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
 80484c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 80484c8:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80484cd:	89 c8                	mov    %ecx,%eax
 80484cf:	f7 ea                	imul   %edx
 80484d1:	c1 fa 02             	sar    $0x2,%edx
 80484d4:	89 c8                	mov    %ecx,%eax
 80484d6:	c1 f8 1f             	sar    $0x1f,%eax
 80484d9:	29 c2                	sub    %eax,%edx
 80484db:	89 d0                	mov    %edx,%eax
 80484dd:	c1 e0 02             	shl    $0x2,%eax
 80484e0:	01 d0                	add    %edx,%eax
 80484e2:	01 c0                	add    %eax,%eax
 80484e4:	29 c1                	sub    %eax,%ecx
 80484e6:	89 ca                	mov    %ecx,%edx
 80484e8:	89 d0                	mov    %edx,%eax
 80484ea:	83 c0 30             	add    $0x30,%eax
 80484ed:	89 c1                	mov    %eax,%ecx
 80484ef:	8d 55 dd             	lea    -0x23(%ebp),%edx
 80484f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80484f5:	01 d0                	add    %edx,%eax
 80484f7:	88 08                	mov    %cl,(%eax)
            num/=10;
 80484f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 80484fc:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048501:	89 c8                	mov    %ecx,%eax
 8048503:	f7 ea                	imul   %edx
 8048505:	c1 fa 02             	sar    $0x2,%edx
 8048508:	89 c8                	mov    %ecx,%eax
 804850a:	c1 f8 1f             	sar    $0x1f,%eax
 804850d:	29 c2                	sub    %eax,%edx
 804850f:	89 d0                	mov    %edx,%eax
 8048511:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
 8048514:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
 8048518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804851c:	7f a7                	jg     80484c5 <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
 804851e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
 8048522:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048529:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8048530:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
 8048537:	e9 aa 00 00 00       	jmp    80485e6 <drawNumber+0x14a>
        for(yy=0; yy<7; yy++){
 804853c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8048543:	e9 8c 00 00 00       	jmp    80485d4 <drawNumber+0x138>
            for(xx=0; xx<5; xx++){
 8048548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804854f:	eb 79                	jmp    80485ca <drawNumber+0x12e>
                const char* num = nums[temp[di]-'0'];
 8048551:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048554:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048557:	01 d0                	add    %edx,%eax
 8048559:	0f b6 00             	movzbl (%eax),%eax
 804855c:	0f be c0             	movsbl %al,%eax
 804855f:	83 e8 30             	sub    $0x30,%eax
 8048562:	8b 04 85 20 b0 04 08 	mov    0x804b020(,%eax,4),%eax
 8048569:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
 804856c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804856f:	89 d0                	mov    %edx,%eax
 8048571:	c1 e0 02             	shl    $0x2,%eax
 8048574:	01 c2                	add    %eax,%edx
 8048576:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048579:	01 d0                	add    %edx,%eax
 804857b:	89 c2                	mov    %eax,%edx
 804857d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048580:	01 d0                	add    %edx,%eax
 8048582:	0f b6 00             	movzbl (%eax),%eax
 8048585:	84 c0                	test   %al,%al
 8048587:	74 3d                	je     80485c6 <drawNumber+0x12a>
 8048589:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
 804858d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8048590:	89 d1                	mov    %edx,%ecx
 8048592:	0f af 4d 14          	imul   0x14(%ebp),%ecx
 8048596:	8b 55 10             	mov    0x10(%ebp),%edx
 8048599:	01 d1                	add    %edx,%ecx
 804859b:	8b 55 14             	mov    0x14(%ebp),%edx
 804859e:	83 c2 0a             	add    $0xa,%edx
 80485a1:	89 d3                	mov    %edx,%ebx
 80485a3:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
 80485a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 80485aa:	01 d3                	add    %edx,%ebx
 80485ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80485af:	0f af 55 14          	imul   0x14(%ebp),%edx
 80485b3:	01 da                	add    %ebx,%edx
 80485b5:	50                   	push   %eax
 80485b6:	ff 75 14             	pushl  0x14(%ebp)
 80485b9:	ff 75 14             	pushl  0x14(%ebp)
 80485bc:	51                   	push   %ecx
 80485bd:	52                   	push   %edx
 80485be:	e8 1d fd ff ff       	call   80482e0 <drawRect>
 80485c3:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
 80485c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80485ca:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 80485ce:	7e 81                	jle    8048551 <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
 80485d0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 80485d4:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
 80485d8:	0f 8e 6a ff ff ff    	jle    8048548 <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
 80485de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
 80485e2:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
 80485e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 80485ea:	0f 89 4c ff ff ff    	jns    804853c <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
 80485f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80485f3:	c9                   	leave  
 80485f4:	c3                   	ret    

080485f5 <drawStage>:

static inline void drawStage(){
 80485f5:	55                   	push   %ebp
 80485f6:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
 80485f8:	8b 15 84 b0 04 08    	mov    0x804b084,%edx
 80485fe:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048603:	39 c2                	cmp    %eax,%edx
 8048605:	75 02                	jne    8048609 <drawStage+0x14>
 8048607:	eb 0f                	jmp    8048618 <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
 8048609:	e8 65 fb ff ff       	call   8048173 <sys_flush_vcache>
	lhash = hash;
 804860e:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048613:	a3 84 b0 04 08       	mov    %eax,0x804b084
}
 8048618:	5d                   	pop    %ebp
 8048619:	c3                   	ret    

0804861a <key>:
static int curtime = 0;

static int score;
void dreamOf100HZ(int);

static inline int8_t key(char s){
 804861a:	55                   	push   %ebp
 804861b:	89 e5                	mov    %esp,%ebp
 804861d:	83 ec 04             	sub    $0x4,%esp
 8048620:	8b 45 08             	mov    0x8(%ebp),%eax
 8048623:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
 8048626:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 804862a:	50                   	push   %eax
 804862b:	e8 66 fb ff ff       	call   8048196 <sys_key_down>
 8048630:	83 c4 04             	add    $0x4,%esp
}
 8048633:	c9                   	leave  
 8048634:	c3                   	ret    

08048635 <main>:



int main(){
 8048635:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048639:	83 e4 f0             	and    $0xfffffff0,%esp
 804863c:	ff 71 fc             	pushl  -0x4(%ecx)
 804863f:	55                   	push   %ebp
 8048640:	89 e5                	mov    %esp,%ebp
 8048642:	51                   	push   %ecx
 8048643:	83 ec 04             	sub    $0x4,%esp
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
 8048646:	e8 76 fb ff ff       	call   80481c1 <sys_get_tick>
 804864b:	a3 48 b0 04 08       	mov    %eax,0x804b048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 8048650:	eb 1e                	jmp    8048670 <main+0x3b>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
 8048652:	a1 48 b0 04 08       	mov    0x804b048,%eax
 8048657:	83 ec 0c             	sub    $0xc,%esp
 804865a:	50                   	push   %eax
 804865b:	e8 8c 07 00 00       	call   8048dec <dreamOf100HZ>
 8048660:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime++;
 8048663:	a1 20 ba 04 08       	mov    0x804ba20,%eax
 8048668:	83 c0 01             	add    $0x1,%eax
 804866b:	a3 20 ba 04 08       	mov    %eax,0x804ba20
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 8048670:	8b 15 20 ba 04 08    	mov    0x804ba20,%edx
 8048676:	a1 48 b0 04 08       	mov    0x804b048,%eax
 804867b:	39 c2                	cmp    %eax,%edx
 804867d:	7c d3                	jl     8048652 <main+0x1d>
		}
		

		//enable_interrupt();
		
	}
 804867f:	eb c5                	jmp    8048646 <main+0x11>

08048681 <hitMonster>:
domain int x, y, size, score = 0;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
 8048681:	55                   	push   %ebp
 8048682:	89 e5                	mov    %esp,%ebp
 8048684:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 8048687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
 804868e:	e9 9c 01 00 00       	jmp    804882f <hitMonster+0x1ae>
		int dx = x-mon.x; 
 8048693:	8b 15 2c ba 04 08    	mov    0x804ba2c,%edx
 8048699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804869c:	c1 e0 02             	shl    $0x2,%eax
 804869f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80486a6:	29 c1                	sub    %eax,%ecx
 80486a8:	89 c8                	mov    %ecx,%eax
 80486aa:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80486af:	8b 40 04             	mov    0x4(%eax),%eax
 80486b2:	29 c2                	sub    %eax,%edx
 80486b4:	89 d0                	mov    %edx,%eax
 80486b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
 80486b9:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80486bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80486c2:	c1 e0 02             	shl    $0x2,%eax
 80486c5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80486cc:	29 c1                	sub    %eax,%ecx
 80486ce:	89 c8                	mov    %ecx,%eax
 80486d0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80486d5:	8b 40 08             	mov    0x8(%eax),%eax
 80486d8:	29 c2                	sub    %eax,%edx
 80486da:	89 d0                	mov    %edx,%eax
 80486dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
 80486df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80486e2:	89 c2                	mov    %eax,%edx
 80486e4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80486eb:	89 c2                	mov    %eax,%edx
 80486ed:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80486f4:	29 d0                	sub    %edx,%eax
 80486f6:	83 c0 10             	add    $0x10,%eax
 80486f9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80486fe:	8b 40 04             	mov    0x4(%eax),%eax
 8048701:	85 c0                	test   %eax,%eax
 8048703:	0f 85 22 01 00 00    	jne    804882b <hitMonster+0x1aa>
 8048709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804870c:	c1 e0 02             	shl    $0x2,%eax
 804870f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048716:	29 c2                	sub    %eax,%edx
 8048718:	89 d0                	mov    %edx,%eax
 804871a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804871f:	8b 00                	mov    (%eax),%eax
 8048721:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048724:	0f 8c 01 01 00 00    	jl     804882b <hitMonster+0x1aa>
 804872a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804872d:	c1 e0 02             	shl    $0x2,%eax
 8048730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048737:	29 c2                	sub    %eax,%edx
 8048739:	89 d0                	mov    %edx,%eax
 804873b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048740:	8b 00                	mov    (%eax),%eax
 8048742:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8048745:	0f 8c e0 00 00 00    	jl     804882b <hitMonster+0x1aa>
 804874b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804874e:	c1 e0 02             	shl    $0x2,%eax
 8048751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048758:	29 c2                	sub    %eax,%edx
 804875a:	89 d0                	mov    %edx,%eax
 804875c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048761:	8b 00                	mov    (%eax),%eax
 8048763:	f7 d8                	neg    %eax
 8048765:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048768:	0f 8f bd 00 00 00    	jg     804882b <hitMonster+0x1aa>
 804876e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048771:	c1 e0 02             	shl    $0x2,%eax
 8048774:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804877b:	29 c2                	sub    %eax,%edx
 804877d:	89 d0                	mov    %edx,%eax
 804877f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048784:	8b 00                	mov    (%eax),%eax
 8048786:	f7 d8                	neg    %eax
 8048788:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 804878b:	0f 8f 9a 00 00 00    	jg     804882b <hitMonster+0x1aa>
			if(mon.size <= size){
 8048791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048794:	c1 e0 02             	shl    $0x2,%eax
 8048797:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804879e:	29 c2                	sub    %eax,%edx
 80487a0:	89 d0                	mov    %edx,%eax
 80487a2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487a7:	8b 10                	mov    (%eax),%edx
 80487a9:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80487ae:	39 c2                	cmp    %eax,%edx
 80487b0:	7f 68                	jg     804881a <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
 80487b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487b5:	89 c2                	mov    %eax,%edx
 80487b7:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80487be:	89 c2                	mov    %eax,%edx
 80487c0:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80487c7:	29 d0                	sub    %edx,%eax
 80487c9:	83 c0 10             	add    $0x10,%eax
 80487cc:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487d1:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
 80487d8:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80487dd:	83 f8 0c             	cmp    $0xc,%eax
 80487e0:	7f 0d                	jg     80487ef <hitMonster+0x16e>
 80487e2:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80487e7:	83 c0 01             	add    $0x1,%eax
 80487ea:	a3 34 ba 04 08       	mov    %eax,0x804ba34
				score += mon.size;
 80487ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487f2:	c1 e0 02             	shl    $0x2,%eax
 80487f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487fc:	29 c2                	sub    %eax,%edx
 80487fe:	89 d0                	mov    %edx,%eax
 8048800:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048805:	8b 10                	mov    (%eax),%edx
 8048807:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 804880c:	01 d0                	add    %edx,%eax
 804880e:	a3 24 ba 04 08       	mov    %eax,0x804ba24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
 8048813:	b8 01 00 00 00       	mov    $0x1,%eax
 8048818:	eb 24                	jmp    804883e <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
 804881a:	c7 05 28 ba 04 08 03 	movl   $0x3,0x804ba28
 8048821:	00 00 00 
				return 0;
 8048824:	b8 00 00 00 00       	mov    $0x0,%eax
 8048829:	eb 13                	jmp    804883e <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
 804882b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804882f:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
 8048833:	0f 8e 5a fe ff ff    	jle    8048693 <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
 8048839:	b8 00 00 00 00       	mov    $0x0,%eax
}
 804883e:	c9                   	leave  
 804883f:	c3                   	ret    

08048840 <drawMonster>:

void drawMonster(){
 8048840:	55                   	push   %ebp
 8048841:	89 e5                	mov    %esp,%ebp
 8048843:	56                   	push   %esi
 8048844:	53                   	push   %ebx
 8048845:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 8048848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 804884f:	e9 89 03 00 00       	jmp    8048bdd <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
 8048854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048857:	89 c2                	mov    %eax,%edx
 8048859:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048860:	89 c2                	mov    %eax,%edx
 8048862:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048869:	29 d0                	sub    %edx,%eax
 804886b:	83 c0 10             	add    $0x10,%eax
 804886e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048873:	8b 40 04             	mov    0x4(%eax),%eax
 8048876:	85 c0                	test   %eax,%eax
 8048878:	0f 85 5b 03 00 00    	jne    8048bd9 <drawMonster+0x399>
			mon.x += mon.sx;
 804887e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048881:	c1 e0 02             	shl    $0x2,%eax
 8048884:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804888b:	29 c2                	sub    %eax,%edx
 804888d:	89 d0                	mov    %edx,%eax
 804888f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048894:	8b 50 04             	mov    0x4(%eax),%edx
 8048897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804889a:	c1 e0 02             	shl    $0x2,%eax
 804889d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80488a4:	29 c1                	sub    %eax,%ecx
 80488a6:	89 c8                	mov    %ecx,%eax
 80488a8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488ad:	8b 40 0c             	mov    0xc(%eax),%eax
 80488b0:	01 c2                	add    %eax,%edx
 80488b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488b5:	c1 e0 02             	shl    $0x2,%eax
 80488b8:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80488bf:	29 c1                	sub    %eax,%ecx
 80488c1:	89 c8                	mov    %ecx,%eax
 80488c3:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488c8:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
 80488cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488ce:	c1 e0 02             	shl    $0x2,%eax
 80488d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488d8:	29 c2                	sub    %eax,%edx
 80488da:	89 d0                	mov    %edx,%eax
 80488dc:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488e1:	8b 48 08             	mov    0x8(%eax),%ecx
 80488e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488e7:	89 c2                	mov    %eax,%edx
 80488e9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80488f0:	89 c2                	mov    %eax,%edx
 80488f2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80488f9:	29 d0                	sub    %edx,%eax
 80488fb:	83 c0 10             	add    $0x10,%eax
 80488fe:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048903:	8b 00                	mov    (%eax),%eax
 8048905:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 8048908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804890b:	c1 e0 02             	shl    $0x2,%eax
 804890e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048915:	29 c1                	sub    %eax,%ecx
 8048917:	89 c8                	mov    %ecx,%eax
 8048919:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804891e:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
 8048921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048924:	c1 e0 02             	shl    $0x2,%eax
 8048927:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804892e:	29 c2                	sub    %eax,%edx
 8048930:	89 d0                	mov    %edx,%eax
 8048932:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048937:	8b 40 04             	mov    0x4(%eax),%eax
 804893a:	83 f8 09             	cmp    $0x9,%eax
 804893d:	7f 35                	jg     8048974 <drawMonster+0x134>
 804893f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048942:	c1 e0 02             	shl    $0x2,%eax
 8048945:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804894c:	29 c2                	sub    %eax,%edx
 804894e:	89 d0                	mov    %edx,%eax
 8048950:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048955:	8b 40 04             	mov    0x4(%eax),%eax
 8048958:	8d 50 01             	lea    0x1(%eax),%edx
 804895b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804895e:	c1 e0 02             	shl    $0x2,%eax
 8048961:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048968:	29 c1                	sub    %eax,%ecx
 804896a:	89 c8                	mov    %ecx,%eax
 804896c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048971:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
 8048974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048977:	c1 e0 02             	shl    $0x2,%eax
 804897a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048981:	29 c2                	sub    %eax,%edx
 8048983:	89 d0                	mov    %edx,%eax
 8048985:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804898a:	8b 40 04             	mov    0x4(%eax),%eax
 804898d:	3d 36 01 00 00       	cmp    $0x136,%eax
 8048992:	7e 35                	jle    80489c9 <drawMonster+0x189>
 8048994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048997:	c1 e0 02             	shl    $0x2,%eax
 804899a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489a1:	29 c2                	sub    %eax,%edx
 80489a3:	89 d0                	mov    %edx,%eax
 80489a5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489aa:	8b 40 04             	mov    0x4(%eax),%eax
 80489ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 80489b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489b3:	c1 e0 02             	shl    $0x2,%eax
 80489b6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489bd:	29 c1                	sub    %eax,%ecx
 80489bf:	89 c8                	mov    %ecx,%eax
 80489c1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489c6:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
 80489c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489cc:	c1 e0 02             	shl    $0x2,%eax
 80489cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489d6:	29 c2                	sub    %eax,%edx
 80489d8:	89 d0                	mov    %edx,%eax
 80489da:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489df:	8b 40 08             	mov    0x8(%eax),%eax
 80489e2:	83 f8 09             	cmp    $0x9,%eax
 80489e5:	7f 35                	jg     8048a1c <drawMonster+0x1dc>
 80489e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489ea:	c1 e0 02             	shl    $0x2,%eax
 80489ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489f4:	29 c2                	sub    %eax,%edx
 80489f6:	89 d0                	mov    %edx,%eax
 80489f8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489fd:	8b 40 08             	mov    0x8(%eax),%eax
 8048a00:	8d 50 01             	lea    0x1(%eax),%edx
 8048a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a06:	c1 e0 02             	shl    $0x2,%eax
 8048a09:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a10:	29 c1                	sub    %eax,%ecx
 8048a12:	89 c8                	mov    %ecx,%eax
 8048a14:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a19:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
 8048a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a1f:	c1 e0 02             	shl    $0x2,%eax
 8048a22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a29:	29 c2                	sub    %eax,%edx
 8048a2b:	89 d0                	mov    %edx,%eax
 8048a2d:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a32:	8b 40 08             	mov    0x8(%eax),%eax
 8048a35:	3d be 00 00 00       	cmp    $0xbe,%eax
 8048a3a:	7e 35                	jle    8048a71 <drawMonster+0x231>
 8048a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a3f:	c1 e0 02             	shl    $0x2,%eax
 8048a42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a49:	29 c2                	sub    %eax,%edx
 8048a4b:	89 d0                	mov    %edx,%eax
 8048a4d:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a52:	8b 40 08             	mov    0x8(%eax),%eax
 8048a55:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a5b:	c1 e0 02             	shl    $0x2,%eax
 8048a5e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a65:	29 c1                	sub    %eax,%ecx
 8048a67:	89 c8                	mov    %ecx,%eax
 8048a69:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a6e:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
 8048a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a74:	c1 e0 02             	shl    $0x2,%eax
 8048a77:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a7e:	29 c2                	sub    %eax,%edx
 8048a80:	89 d0                	mov    %edx,%eax
 8048a82:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a87:	8b 10                	mov    (%eax),%edx
 8048a89:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048a8e:	39 c2                	cmp    %eax,%edx
 8048a90:	7f 07                	jg     8048a99 <drawMonster+0x259>
 8048a92:	b8 0f 00 00 00       	mov    $0xf,%eax
 8048a97:	eb 05                	jmp    8048a9e <drawMonster+0x25e>
 8048a99:	b8 05 00 00 00       	mov    $0x5,%eax
 8048a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
 8048aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048aa4:	0f b6 d8             	movzbl %al,%ebx
 8048aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048aaa:	c1 e0 02             	shl    $0x2,%eax
 8048aad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ab4:	29 c2                	sub    %eax,%edx
 8048ab6:	89 d0                	mov    %edx,%eax
 8048ab8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048abd:	8b 08                	mov    (%eax),%ecx
 8048abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ac2:	c1 e0 02             	shl    $0x2,%eax
 8048ac5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048acc:	29 c2                	sub    %eax,%edx
 8048ace:	89 d0                	mov    %edx,%eax
 8048ad0:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ad5:	8b 50 08             	mov    0x8(%eax),%edx
 8048ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048adb:	c1 e0 02             	shl    $0x2,%eax
 8048ade:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
 8048ae5:	29 c6                	sub    %eax,%esi
 8048ae7:	89 f0                	mov    %esi,%eax
 8048ae9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aee:	8b 40 04             	mov    0x4(%eax),%eax
 8048af1:	53                   	push   %ebx
 8048af2:	51                   	push   %ecx
 8048af3:	52                   	push   %edx
 8048af4:	50                   	push   %eax
 8048af5:	e8 7d f8 ff ff       	call   8048377 <drawCirc>
 8048afa:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
 8048afd:	e8 92 f5 ff ff       	call   8048094 <UKISS>
 8048b02:	89 c2                	mov    %eax,%edx
 8048b04:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b09:	01 c2                	add    %eax,%edx
 8048b0b:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b10:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b13:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048b18:	89 c8                	mov    %ecx,%eax
 8048b1a:	f7 e2                	mul    %edx
 8048b1c:	89 d0                	mov    %edx,%eax
 8048b1e:	c1 e8 05             	shr    $0x5,%eax
 8048b21:	89 c2                	mov    %eax,%edx
 8048b23:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048b2a:	89 c2                	mov    %eax,%edx
 8048b2c:	89 d0                	mov    %edx,%eax
 8048b2e:	c1 e0 04             	shl    $0x4,%eax
 8048b31:	29 d0                	sub    %edx,%eax
 8048b33:	29 c1                	sub    %eax,%ecx
 8048b35:	89 c8                	mov    %ecx,%eax
 8048b37:	85 c0                	test   %eax,%eax
 8048b39:	0f 85 9a 00 00 00    	jne    8048bd9 <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
 8048b3f:	e8 50 f5 ff ff       	call   8048094 <UKISS>
 8048b44:	89 c2                	mov    %eax,%edx
 8048b46:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b4b:	01 c2                	add    %eax,%edx
 8048b4d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b52:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b55:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048b5a:	89 c8                	mov    %ecx,%eax
 8048b5c:	f7 e2                	mul    %edx
 8048b5e:	d1 ea                	shr    %edx
 8048b60:	89 d0                	mov    %edx,%eax
 8048b62:	01 c0                	add    %eax,%eax
 8048b64:	01 d0                	add    %edx,%eax
 8048b66:	29 c1                	sub    %eax,%ecx
 8048b68:	89 ca                	mov    %ecx,%edx
 8048b6a:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048b6d:	89 c1                	mov    %eax,%ecx
 8048b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b72:	c1 e0 02             	shl    $0x2,%eax
 8048b75:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b7c:	29 c2                	sub    %eax,%edx
 8048b7e:	89 d0                	mov    %edx,%eax
 8048b80:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b85:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
 8048b88:	e8 07 f5 ff ff       	call   8048094 <UKISS>
 8048b8d:	89 c2                	mov    %eax,%edx
 8048b8f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b94:	01 c2                	add    %eax,%edx
 8048b96:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b9b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b9e:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048ba3:	89 c8                	mov    %ecx,%eax
 8048ba5:	f7 e2                	mul    %edx
 8048ba7:	d1 ea                	shr    %edx
 8048ba9:	89 d0                	mov    %edx,%eax
 8048bab:	01 c0                	add    %eax,%eax
 8048bad:	01 d0                	add    %edx,%eax
 8048baf:	29 c1                	sub    %eax,%ecx
 8048bb1:	89 ca                	mov    %ecx,%edx
 8048bb3:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048bb6:	89 c1                	mov    %eax,%ecx
 8048bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bbb:	89 c2                	mov    %eax,%edx
 8048bbd:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048bc4:	89 c2                	mov    %eax,%edx
 8048bc6:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048bcd:	29 d0                	sub    %edx,%eax
 8048bcf:	83 c0 10             	add    $0x10,%eax
 8048bd2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bd7:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
 8048bd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048bdd:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048be1:	0f 8e 6d fc ff ff    	jle    8048854 <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
 8048be7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8048bea:	5b                   	pop    %ebx
 8048beb:	5e                   	pop    %esi
 8048bec:	5d                   	pop    %ebp
 8048bed:	c3                   	ret    

08048bee <createMonster>:
void createMonster(){
 8048bee:	55                   	push   %ebp
 8048bef:	89 e5                	mov    %esp,%ebp
 8048bf1:	83 ec 18             	sub    $0x18,%esp
	int i=0;
 8048bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048bfb:	e9 e0 01 00 00       	jmp    8048de0 <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
 8048c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c03:	89 c2                	mov    %eax,%edx
 8048c05:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c0c:	89 c2                	mov    %eax,%edx
 8048c0e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c15:	29 d0                	sub    %edx,%eax
 8048c17:	83 c0 10             	add    $0x10,%eax
 8048c1a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c1f:	8b 40 04             	mov    0x4(%eax),%eax
 8048c22:	85 c0                	test   %eax,%eax
 8048c24:	75 05                	jne    8048c2b <createMonster+0x3d>
 8048c26:	e9 b1 01 00 00       	jmp    8048ddc <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
 8048c2b:	e8 64 f4 ff ff       	call   8048094 <UKISS>
 8048c30:	89 c2                	mov    %eax,%edx
 8048c32:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c37:	01 c2                	add    %eax,%edx
 8048c39:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c3e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c41:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
 8048c46:	89 c8                	mov    %ecx,%eax
 8048c48:	f7 e2                	mul    %edx
 8048c4a:	89 d0                	mov    %edx,%eax
 8048c4c:	c1 e8 0c             	shr    $0xc,%eax
 8048c4f:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
 8048c55:	29 c1                	sub    %eax,%ecx
 8048c57:	89 c8                	mov    %ecx,%eax
 8048c59:	85 c0                	test   %eax,%eax
 8048c5b:	0f 85 7b 01 00 00    	jne    8048ddc <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
 8048c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c64:	89 c2                	mov    %eax,%edx
 8048c66:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c6d:	89 c2                	mov    %eax,%edx
 8048c6f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c76:	29 d0                	sub    %edx,%eax
 8048c78:	83 c0 10             	add    $0x10,%eax
 8048c7b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
 8048c87:	e8 08 f4 ff ff       	call   8048094 <UKISS>
 8048c8c:	89 c2                	mov    %eax,%edx
 8048c8e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c93:	01 c2                	add    %eax,%edx
 8048c95:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c9a:	01 d0                	add    %edx,%eax
 8048c9c:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048ca2:	89 d1                	mov    %edx,%ecx
 8048ca4:	ba 00 00 00 00       	mov    $0x0,%edx
 8048ca9:	f7 f1                	div    %ecx
 8048cab:	89 d0                	mov    %edx,%eax
 8048cad:	83 c0 01             	add    $0x1,%eax
 8048cb0:	01 c0                	add    %eax,%eax
 8048cb2:	89 c1                	mov    %eax,%ecx
 8048cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048cb7:	c1 e0 02             	shl    $0x2,%eax
 8048cba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048cc1:	29 c2                	sub    %eax,%edx
 8048cc3:	89 d0                	mov    %edx,%eax
 8048cc5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048cca:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
 8048ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ccf:	c1 e0 02             	shl    $0x2,%eax
 8048cd2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048cd9:	29 c2                	sub    %eax,%edx
 8048cdb:	89 d0                	mov    %edx,%eax
 8048cdd:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ce2:	8b 00                	mov    (%eax),%eax
 8048ce4:	89 c2                	mov    %eax,%edx
 8048ce6:	83 fa 0e             	cmp    $0xe,%edx
 8048ce9:	7e 05                	jle    8048cf0 <createMonster+0x102>
 8048ceb:	ba 0e 00 00 00       	mov    $0xe,%edx
 8048cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048cf3:	c1 e0 02             	shl    $0x2,%eax
 8048cf6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048cfd:	29 c1                	sub    %eax,%ecx
 8048cff:	89 c8                	mov    %ecx,%eax
 8048d01:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d06:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
 8048d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d0b:	c1 e0 02             	shl    $0x2,%eax
 8048d0e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d15:	29 c2                	sub    %eax,%edx
 8048d17:	89 d0                	mov    %edx,%eax
 8048d19:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d1e:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
 8048d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d28:	c1 e0 02             	shl    $0x2,%eax
 8048d2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d32:	29 c2                	sub    %eax,%edx
 8048d34:	89 d0                	mov    %edx,%eax
 8048d36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d3b:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
 8048d42:	e8 4d f3 ff ff       	call   8048094 <UKISS>
 8048d47:	89 c2                	mov    %eax,%edx
 8048d49:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d4e:	01 c2                	add    %eax,%edx
 8048d50:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d55:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048d58:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048d5d:	89 c8                	mov    %ecx,%eax
 8048d5f:	f7 e2                	mul    %edx
 8048d61:	d1 ea                	shr    %edx
 8048d63:	89 d0                	mov    %edx,%eax
 8048d65:	01 c0                	add    %eax,%eax
 8048d67:	01 d0                	add    %edx,%eax
 8048d69:	29 c1                	sub    %eax,%ecx
 8048d6b:	89 ca                	mov    %ecx,%edx
 8048d6d:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048d70:	89 c1                	mov    %eax,%ecx
 8048d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d75:	c1 e0 02             	shl    $0x2,%eax
 8048d78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d7f:	29 c2                	sub    %eax,%edx
 8048d81:	89 d0                	mov    %edx,%eax
 8048d83:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d88:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
 8048d8b:	e8 04 f3 ff ff       	call   8048094 <UKISS>
 8048d90:	89 c2                	mov    %eax,%edx
 8048d92:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d97:	01 c2                	add    %eax,%edx
 8048d99:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d9e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048da1:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048da6:	89 c8                	mov    %ecx,%eax
 8048da8:	f7 e2                	mul    %edx
 8048daa:	d1 ea                	shr    %edx
 8048dac:	89 d0                	mov    %edx,%eax
 8048dae:	01 c0                	add    %eax,%eax
 8048db0:	01 d0                	add    %edx,%eax
 8048db2:	29 c1                	sub    %eax,%ecx
 8048db4:	89 ca                	mov    %ecx,%edx
 8048db6:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048db9:	89 c1                	mov    %eax,%ecx
 8048dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dbe:	89 c2                	mov    %eax,%edx
 8048dc0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048dc7:	89 c2                	mov    %eax,%edx
 8048dc9:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048dd0:	29 d0                	sub    %edx,%eax
 8048dd2:	83 c0 10             	add    $0x10,%eax
 8048dd5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dda:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
 8048ddc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048de0:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048de4:	0f 8e 16 fe ff ff    	jle    8048c00 <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
 8048dea:	c9                   	leave  
 8048deb:	c3                   	ret    

08048dec <dreamOf100HZ>:
void dreamOf100HZ(int timestamp){
 8048dec:	55                   	push   %ebp
 8048ded:	89 e5                	mov    %esp,%ebp
 8048def:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
 8048df2:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8048df7:	85 c0                	test   %eax,%eax
 8048df9:	0f 85 2b 04 00 00    	jne    804922a <dreamOf100HZ+0x43e>
		clearStage();
 8048dff:	e8 a7 f4 ff ff       	call   80482ab <clearStage>
		drawText1();
 8048e04:	e8 1b f6 ff ff       	call   8048424 <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
 8048e09:	e8 e7 f7 ff ff       	call   80485f5 <drawStage>

		int i=0;
 8048e0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
 8048e15:	c7 05 2c ba 04 08 1e 	movl   $0x1e,0x804ba2c
 8048e1c:	00 00 00 
		y = 30;
 8048e1f:	c7 05 30 ba 04 08 1e 	movl   $0x1e,0x804ba30
 8048e26:	00 00 00 
		size = 4;
 8048e29:	c7 05 34 ba 04 08 04 	movl   $0x4,0x804ba34
 8048e30:	00 00 00 
		score = 0;
 8048e33:	c7 05 24 ba 04 08 00 	movl   $0x0,0x804ba24
 8048e3a:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
 8048e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e40:	89 c2                	mov    %eax,%edx
 8048e42:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048e49:	89 c2                	mov    %eax,%edx
 8048e4b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048e52:	29 d0                	sub    %edx,%eax
 8048e54:	83 c0 10             	add    $0x10,%eax
 8048e57:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
 8048e63:	e8 2c f2 ff ff       	call   8048094 <UKISS>
 8048e68:	89 c2                	mov    %eax,%edx
 8048e6a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e6f:	01 c2                	add    %eax,%edx
 8048e71:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e76:	01 d0                	add    %edx,%eax
 8048e78:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048e7e:	89 d1                	mov    %edx,%ecx
 8048e80:	ba 00 00 00 00       	mov    $0x0,%edx
 8048e85:	f7 f1                	div    %ecx
 8048e87:	89 d0                	mov    %edx,%eax
 8048e89:	83 c0 01             	add    $0x1,%eax
 8048e8c:	89 c1                	mov    %eax,%ecx
 8048e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e91:	c1 e0 02             	shl    $0x2,%eax
 8048e94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048e9b:	29 c2                	sub    %eax,%edx
 8048e9d:	89 d0                	mov    %edx,%eax
 8048e9f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ea4:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
 8048ea6:	e8 e9 f1 ff ff       	call   8048094 <UKISS>
 8048eab:	89 c2                	mov    %eax,%edx
 8048ead:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048eb2:	01 c2                	add    %eax,%edx
 8048eb4:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048eb9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048ebc:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8048ec1:	89 c8                	mov    %ecx,%eax
 8048ec3:	f7 e2                	mul    %edx
 8048ec5:	c1 ea 08             	shr    $0x8,%edx
 8048ec8:	89 d0                	mov    %edx,%eax
 8048eca:	c1 e0 02             	shl    $0x2,%eax
 8048ecd:	01 d0                	add    %edx,%eax
 8048ecf:	c1 e0 06             	shl    $0x6,%eax
 8048ed2:	29 c1                	sub    %eax,%ecx
 8048ed4:	89 ca                	mov    %ecx,%edx
 8048ed6:	89 d1                	mov    %edx,%ecx
 8048ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048edb:	c1 e0 02             	shl    $0x2,%eax
 8048ede:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ee5:	29 c2                	sub    %eax,%edx
 8048ee7:	89 d0                	mov    %edx,%eax
 8048ee9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048eee:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
 8048ef1:	e8 9e f1 ff ff       	call   8048094 <UKISS>
 8048ef6:	89 c2                	mov    %eax,%edx
 8048ef8:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048efd:	01 c2                	add    %eax,%edx
 8048eff:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f04:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f07:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8048f0c:	89 c8                	mov    %ecx,%eax
 8048f0e:	f7 e2                	mul    %edx
 8048f10:	89 d0                	mov    %edx,%eax
 8048f12:	c1 e8 06             	shr    $0x6,%eax
 8048f15:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8048f1b:	29 c1                	sub    %eax,%ecx
 8048f1d:	89 c8                	mov    %ecx,%eax
 8048f1f:	89 c1                	mov    %eax,%ecx
 8048f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f24:	c1 e0 02             	shl    $0x2,%eax
 8048f27:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f2e:	29 c2                	sub    %eax,%edx
 8048f30:	89 d0                	mov    %edx,%eax
 8048f32:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f37:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
 8048f3a:	e8 55 f1 ff ff       	call   8048094 <UKISS>
 8048f3f:	89 c2                	mov    %eax,%edx
 8048f41:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f46:	01 c2                	add    %eax,%edx
 8048f48:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f4d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f50:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048f55:	89 c8                	mov    %ecx,%eax
 8048f57:	f7 e2                	mul    %edx
 8048f59:	d1 ea                	shr    %edx
 8048f5b:	89 d0                	mov    %edx,%eax
 8048f5d:	01 c0                	add    %eax,%eax
 8048f5f:	01 d0                	add    %edx,%eax
 8048f61:	29 c1                	sub    %eax,%ecx
 8048f63:	89 ca                	mov    %ecx,%edx
 8048f65:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048f68:	89 c1                	mov    %eax,%ecx
 8048f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f6d:	c1 e0 02             	shl    $0x2,%eax
 8048f70:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f77:	29 c2                	sub    %eax,%edx
 8048f79:	89 d0                	mov    %edx,%eax
 8048f7b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f80:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
 8048f83:	e8 0c f1 ff ff       	call   8048094 <UKISS>
 8048f88:	89 c2                	mov    %eax,%edx
 8048f8a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f8f:	01 c2                	add    %eax,%edx
 8048f91:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f96:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f99:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048f9e:	89 c8                	mov    %ecx,%eax
 8048fa0:	f7 e2                	mul    %edx
 8048fa2:	d1 ea                	shr    %edx
 8048fa4:	89 d0                	mov    %edx,%eax
 8048fa6:	01 c0                	add    %eax,%eax
 8048fa8:	01 d0                	add    %edx,%eax
 8048faa:	29 c1                	sub    %eax,%ecx
 8048fac:	89 ca                	mov    %ecx,%edx
 8048fae:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048fb1:	89 c1                	mov    %eax,%ecx
 8048fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fb6:	89 c2                	mov    %eax,%edx
 8048fb8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048fbf:	89 c2                	mov    %eax,%edx
 8048fc1:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048fc8:	29 d0                	sub    %edx,%eax
 8048fca:	83 c0 10             	add    $0x10,%eax
 8048fcd:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048fd2:	89 08                	mov    %ecx,(%eax)
		i++;
 8048fd4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
 8048fd8:	e9 29 02 00 00       	jmp    8049206 <dreamOf100HZ+0x41a>
			monsters[i].status = MONSTER_SLEEP;
 8048fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fe0:	89 c2                	mov    %eax,%edx
 8048fe2:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048fe9:	89 c2                	mov    %eax,%edx
 8048feb:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048ff2:	29 d0                	sub    %edx,%eax
 8048ff4:	83 c0 10             	add    $0x10,%eax
 8048ff7:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ffc:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
 8049003:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049006:	89 c2                	mov    %eax,%edx
 8049008:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804900f:	89 c2                	mov    %eax,%edx
 8049011:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049018:	29 d0                	sub    %edx,%eax
 804901a:	83 c0 10             	add    $0x10,%eax
 804901d:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
 8049029:	e8 66 f0 ff ff       	call   8048094 <UKISS>
 804902e:	89 c2                	mov    %eax,%edx
 8049030:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049035:	01 c2                	add    %eax,%edx
 8049037:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804903c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804903f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8049044:	89 c8                	mov    %ecx,%eax
 8049046:	f7 e2                	mul    %edx
 8049048:	c1 ea 04             	shr    $0x4,%edx
 804904b:	89 d0                	mov    %edx,%eax
 804904d:	c1 e0 02             	shl    $0x2,%eax
 8049050:	01 d0                	add    %edx,%eax
 8049052:	c1 e0 02             	shl    $0x2,%eax
 8049055:	29 c1                	sub    %eax,%ecx
 8049057:	89 ca                	mov    %ecx,%edx
 8049059:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 804905e:	83 c0 03             	add    $0x3,%eax
 8049061:	39 c2                	cmp    %eax,%edx
 8049063:	0f 83 99 01 00 00    	jae    8049202 <dreamOf100HZ+0x416>
				monsters[i].status = MONSTER_ALIVE;
 8049069:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804906c:	89 c2                	mov    %eax,%edx
 804906e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049075:	89 c2                	mov    %eax,%edx
 8049077:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804907e:	29 d0                	sub    %edx,%eax
 8049080:	83 c0 10             	add    $0x10,%eax
 8049083:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
 804908f:	e8 00 f0 ff ff       	call   8048094 <UKISS>
 8049094:	89 c2                	mov    %eax,%edx
 8049096:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804909b:	01 c2                	add    %eax,%edx
 804909d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80490a2:	01 d0                	add    %edx,%eax
 80490a4:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 80490aa:	89 d1                	mov    %edx,%ecx
 80490ac:	ba 00 00 00 00       	mov    $0x0,%edx
 80490b1:	f7 f1                	div    %ecx
 80490b3:	89 d0                	mov    %edx,%eax
 80490b5:	01 c0                	add    %eax,%eax
 80490b7:	83 c0 01             	add    $0x1,%eax
 80490ba:	89 c1                	mov    %eax,%ecx
 80490bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80490bf:	c1 e0 02             	shl    $0x2,%eax
 80490c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80490c9:	29 c2                	sub    %eax,%edx
 80490cb:	89 d0                	mov    %edx,%eax
 80490cd:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490d2:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
 80490d4:	e8 bb ef ff ff       	call   8048094 <UKISS>
 80490d9:	89 c2                	mov    %eax,%edx
 80490db:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80490e0:	01 c2                	add    %eax,%edx
 80490e2:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80490e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80490ea:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80490ef:	89 c8                	mov    %ecx,%eax
 80490f1:	f7 e2                	mul    %edx
 80490f3:	c1 ea 08             	shr    $0x8,%edx
 80490f6:	89 d0                	mov    %edx,%eax
 80490f8:	c1 e0 02             	shl    $0x2,%eax
 80490fb:	01 d0                	add    %edx,%eax
 80490fd:	c1 e0 06             	shl    $0x6,%eax
 8049100:	29 c1                	sub    %eax,%ecx
 8049102:	89 ca                	mov    %ecx,%edx
 8049104:	89 d1                	mov    %edx,%ecx
 8049106:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049109:	c1 e0 02             	shl    $0x2,%eax
 804910c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049113:	29 c2                	sub    %eax,%edx
 8049115:	89 d0                	mov    %edx,%eax
 8049117:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804911c:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
 804911f:	e8 70 ef ff ff       	call   8048094 <UKISS>
 8049124:	89 c2                	mov    %eax,%edx
 8049126:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804912b:	01 c2                	add    %eax,%edx
 804912d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049132:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049135:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 804913a:	89 c8                	mov    %ecx,%eax
 804913c:	f7 e2                	mul    %edx
 804913e:	89 d0                	mov    %edx,%eax
 8049140:	c1 e8 06             	shr    $0x6,%eax
 8049143:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8049149:	29 c1                	sub    %eax,%ecx
 804914b:	89 c8                	mov    %ecx,%eax
 804914d:	89 c1                	mov    %eax,%ecx
 804914f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049152:	c1 e0 02             	shl    $0x2,%eax
 8049155:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804915c:	29 c2                	sub    %eax,%edx
 804915e:	89 d0                	mov    %edx,%eax
 8049160:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049165:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
 8049168:	e8 27 ef ff ff       	call   8048094 <UKISS>
 804916d:	89 c2                	mov    %eax,%edx
 804916f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049174:	01 c2                	add    %eax,%edx
 8049176:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804917b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804917e:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049183:	89 c8                	mov    %ecx,%eax
 8049185:	f7 e2                	mul    %edx
 8049187:	d1 ea                	shr    %edx
 8049189:	89 d0                	mov    %edx,%eax
 804918b:	01 c0                	add    %eax,%eax
 804918d:	01 d0                	add    %edx,%eax
 804918f:	29 c1                	sub    %eax,%ecx
 8049191:	89 ca                	mov    %ecx,%edx
 8049193:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049196:	89 c1                	mov    %eax,%ecx
 8049198:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804919b:	c1 e0 02             	shl    $0x2,%eax
 804919e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491a5:	29 c2                	sub    %eax,%edx
 80491a7:	89 d0                	mov    %edx,%eax
 80491a9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491ae:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
 80491b1:	e8 de ee ff ff       	call   8048094 <UKISS>
 80491b6:	89 c2                	mov    %eax,%edx
 80491b8:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80491bd:	01 c2                	add    %eax,%edx
 80491bf:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80491c4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80491c7:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80491cc:	89 c8                	mov    %ecx,%eax
 80491ce:	f7 e2                	mul    %edx
 80491d0:	d1 ea                	shr    %edx
 80491d2:	89 d0                	mov    %edx,%eax
 80491d4:	01 c0                	add    %eax,%eax
 80491d6:	01 d0                	add    %edx,%eax
 80491d8:	29 c1                	sub    %eax,%ecx
 80491da:	89 ca                	mov    %ecx,%edx
 80491dc:	8d 42 ff             	lea    -0x1(%edx),%eax
 80491df:	89 c1                	mov    %eax,%ecx
 80491e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491e4:	89 c2                	mov    %eax,%edx
 80491e6:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80491ed:	89 c2                	mov    %eax,%edx
 80491ef:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80491f6:	29 d0                	sub    %edx,%eax
 80491f8:	83 c0 10             	add    $0x10,%eax
 80491fb:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049200:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
 8049202:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049206:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 804920a:	0f 8e cd fd ff ff    	jle    8048fdd <dreamOf100HZ+0x1f1>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
 8049210:	83 ec 0c             	sub    $0xc,%esp
 8049213:	68 c3 9f 04 08       	push   $0x8049fc3
 8049218:	e8 de 04 00 00       	call   80496fb <printf>
 804921d:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
 8049220:	c7 05 28 ba 04 08 01 	movl   $0x1,0x804ba28
 8049227:	00 00 00 
	}
	if(gameStatus == GAME_READY){
 804922a:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 804922f:	83 f8 01             	cmp    $0x1,%eax
 8049232:	75 2b                	jne    804925f <dreamOf100HZ+0x473>
		//printf("%d\n", key('q'));
		if(key('q') ){
 8049234:	83 ec 0c             	sub    $0xc,%esp
 8049237:	6a 71                	push   $0x71
 8049239:	e8 dc f3 ff ff       	call   804861a <key>
 804923e:	83 c4 10             	add    $0x10,%esp
 8049241:	84 c0                	test   %al,%al
 8049243:	74 1a                	je     804925f <dreamOf100HZ+0x473>
			printf("Press W, A, S, D to move\n");
 8049245:	83 ec 0c             	sub    $0xc,%esp
 8049248:	68 d5 9f 04 08       	push   $0x8049fd5
 804924d:	e8 a9 04 00 00       	call   80496fb <printf>
 8049252:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
 8049255:	c7 05 28 ba 04 08 02 	movl   $0x2,0x804ba28
 804925c:	00 00 00 
		}
	}

	if(gameStatus == GAME_ING){
 804925f:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049264:	83 f8 02             	cmp    $0x2,%eax
 8049267:	0f 85 4c 01 00 00    	jne    80493b9 <dreamOf100HZ+0x5cd>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
			if(key('a'))x--;
 804926d:	83 ec 0c             	sub    $0xc,%esp
 8049270:	6a 61                	push   $0x61
 8049272:	e8 a3 f3 ff ff       	call   804861a <key>
 8049277:	83 c4 10             	add    $0x10,%esp
 804927a:	84 c0                	test   %al,%al
 804927c:	74 0d                	je     804928b <dreamOf100HZ+0x49f>
 804927e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049283:	83 e8 01             	sub    $0x1,%eax
 8049286:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
			if(key('d'))x++;
 804928b:	83 ec 0c             	sub    $0xc,%esp
 804928e:	6a 64                	push   $0x64
 8049290:	e8 85 f3 ff ff       	call   804861a <key>
 8049295:	83 c4 10             	add    $0x10,%esp
 8049298:	84 c0                	test   %al,%al
 804929a:	74 0d                	je     80492a9 <dreamOf100HZ+0x4bd>
 804929c:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80492a1:	83 c0 01             	add    $0x1,%eax
 80492a4:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
			if(key('w'))y--;
 80492a9:	83 ec 0c             	sub    $0xc,%esp
 80492ac:	6a 77                	push   $0x77
 80492ae:	e8 67 f3 ff ff       	call   804861a <key>
 80492b3:	83 c4 10             	add    $0x10,%esp
 80492b6:	84 c0                	test   %al,%al
 80492b8:	74 0d                	je     80492c7 <dreamOf100HZ+0x4db>
 80492ba:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492bf:	83 e8 01             	sub    $0x1,%eax
 80492c2:	a3 30 ba 04 08       	mov    %eax,0x804ba30
			if(key('s'))y++;
 80492c7:	83 ec 0c             	sub    $0xc,%esp
 80492ca:	6a 73                	push   $0x73
 80492cc:	e8 49 f3 ff ff       	call   804861a <key>
 80492d1:	83 c4 10             	add    $0x10,%esp
 80492d4:	84 c0                	test   %al,%al
 80492d6:	74 0d                	je     80492e5 <dreamOf100HZ+0x4f9>
 80492d8:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492dd:	83 c0 01             	add    $0x1,%eax
 80492e0:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}

		if(x < 0) x++;
 80492e5:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80492ea:	85 c0                	test   %eax,%eax
 80492ec:	79 0d                	jns    80492fb <dreamOf100HZ+0x50f>
 80492ee:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80492f3:	83 c0 01             	add    $0x1,%eax
 80492f6:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(x > VWIDTH) x--;
 80492fb:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049300:	3d 40 01 00 00       	cmp    $0x140,%eax
 8049305:	7e 0d                	jle    8049314 <dreamOf100HZ+0x528>
 8049307:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804930c:	83 e8 01             	sub    $0x1,%eax
 804930f:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(y < 0) y++;
 8049314:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049319:	85 c0                	test   %eax,%eax
 804931b:	79 0d                	jns    804932a <dreamOf100HZ+0x53e>
 804931d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049322:	83 c0 01             	add    $0x1,%eax
 8049325:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(y > VHEIGHT) y--;
 804932a:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804932f:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049334:	7e 0d                	jle    8049343 <dreamOf100HZ+0x557>
 8049336:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804933b:	83 e8 01             	sub    $0x1,%eax
 804933e:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		//else{
		clearStage();
 8049343:	e8 63 ef ff ff       	call   80482ab <clearStage>
		drawCirc(x, y, size, 3);
 8049348:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 804934e:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8049354:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049359:	6a 03                	push   $0x3
 804935b:	51                   	push   %ecx
 804935c:	52                   	push   %edx
 804935d:	50                   	push   %eax
 804935e:	e8 14 f0 ff ff       	call   8048377 <drawCirc>
 8049363:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
 8049366:	e8 d5 f4 ff ff       	call   8048840 <drawMonster>
		drawCirc(x, y, size, 3);
 804936b:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 8049371:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8049377:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804937c:	6a 03                	push   $0x3
 804937e:	51                   	push   %ecx
 804937f:	52                   	push   %edx
 8049380:	50                   	push   %eax
 8049381:	e8 f1 ef ff ff       	call   8048377 <drawCirc>
 8049386:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 0, 180, 1, 7);
 8049389:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 804938e:	83 ec 0c             	sub    $0xc,%esp
 8049391:	6a 07                	push   $0x7
 8049393:	6a 01                	push   $0x1
 8049395:	68 b4 00 00 00       	push   $0xb4
 804939a:	6a 00                	push   $0x0
 804939c:	50                   	push   %eax
 804939d:	e8 fa f0 ff ff       	call   804849c <drawNumber>
 80493a2:	83 c4 20             	add    $0x20,%esp
		drawStage();
 80493a5:	e8 4b f2 ff ff       	call   80485f5 <drawStage>
		
		
		createMonster();
 80493aa:	e8 3f f8 ff ff       	call   8048bee <createMonster>
		while(hitMonster());
 80493af:	90                   	nop
 80493b0:	e8 cc f2 ff ff       	call   8048681 <hitMonster>
 80493b5:	85 c0                	test   %eax,%eax
 80493b7:	75 f7                	jne    80493b0 <dreamOf100HZ+0x5c4>
		//}
	}
	if(gameStatus == GAME_END){
 80493b9:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 80493be:	83 f8 03             	cmp    $0x3,%eax
 80493c1:	75 3a                	jne    80493fd <dreamOf100HZ+0x611>
		printf("You're dead\n");
 80493c3:	83 ec 0c             	sub    $0xc,%esp
 80493c6:	68 ef 9f 04 08       	push   $0x8049fef
 80493cb:	e8 2b 03 00 00       	call   80496fb <printf>
 80493d0:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
 80493d3:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80493d8:	83 ec 08             	sub    $0x8,%esp
 80493db:	50                   	push   %eax
 80493dc:	68 fc 9f 04 08       	push   $0x8049ffc
 80493e1:	e8 15 03 00 00       	call   80496fb <printf>
 80493e6:	83 c4 10             	add    $0x10,%esp
		clearStage();
 80493e9:	e8 bd ee ff ff       	call   80482ab <clearStage>
		drawStage();
 80493ee:	e8 02 f2 ff ff       	call   80485f5 <drawStage>
		gameStatus = GAME_START;
 80493f3:	c7 05 28 ba 04 08 00 	movl   $0x0,0x804ba28
 80493fa:	00 00 00 
	}
 80493fd:	c9                   	leave  
 80493fe:	c3                   	ret    

080493ff <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
 80493ff:	55                   	push   %ebp
 8049400:	89 e5                	mov    %esp,%ebp
 8049402:	53                   	push   %ebx
 8049403:	83 ec 04             	sub    $0x4,%esp
 8049406:	8b 45 08             	mov    0x8(%ebp),%eax
 8049409:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 804940c:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8049411:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 8049415:	89 d3                	mov    %edx,%ebx
 8049417:	cd 80                	int    $0x80
}
 8049419:	83 c4 04             	add    $0x4,%esp
 804941c:	5b                   	pop    %ebx
 804941d:	5d                   	pop    %ebp
 804941e:	c3                   	ret    

0804941f <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 804941f:	55                   	push   %ebp
 8049420:	89 e5                	mov    %esp,%ebp
 8049422:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8049425:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049428:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 804942b:	eb 19                	jmp    8049446 <printp+0x27>
		printer(cur);
 804942d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049430:	0f b6 00             	movzbl (%eax),%eax
 8049433:	0f be c0             	movsbl %al,%eax
 8049436:	83 ec 0c             	sub    $0xc,%esp
 8049439:	50                   	push   %eax
 804943a:	8b 45 08             	mov    0x8(%ebp),%eax
 804943d:	ff d0                	call   *%eax
 804943f:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8049442:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049446:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049449:	0f b6 00             	movzbl (%eax),%eax
 804944c:	84 c0                	test   %al,%al
 804944e:	75 dd                	jne    804942d <printp+0xe>
		printer(cur);
	}
}
 8049450:	c9                   	leave  
 8049451:	c3                   	ret    

08049452 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8049452:	55                   	push   %ebp
 8049453:	89 e5                	mov    %esp,%ebp
 8049455:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
 804945b:	8b 45 0c             	mov    0xc(%ebp),%eax
 804945e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8049461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8049468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804946f:	8b 45 10             	mov    0x10(%ebp),%eax
 8049472:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8049475:	e9 71 02 00 00       	jmp    80496eb <vfprintf+0x299>
		if(cur == '%'){
 804947a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804947d:	0f b6 00             	movzbl (%eax),%eax
 8049480:	3c 25                	cmp    $0x25,%al
 8049482:	75 0c                	jne    8049490 <vfprintf+0x3e>
			type = READ;
 8049484:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 804948b:	e9 57 02 00 00       	jmp    80496e7 <vfprintf+0x295>
		}
		if(type == READ){
 8049490:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8049494:	0f 85 32 02 00 00    	jne    80496cc <vfprintf+0x27a>
			if(cur == 's'){
 804949a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804949d:	0f b6 00             	movzbl (%eax),%eax
 80494a0:	3c 73                	cmp    $0x73,%al
 80494a2:	75 35                	jne    80494d9 <vfprintf+0x87>
				char* p= XGET(pointer, char*);
 80494a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80494a7:	8b 00                	mov    (%eax),%eax
 80494a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80494ac:	eb 19                	jmp    80494c7 <vfprintf+0x75>
					printer(*p);
 80494ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80494b1:	0f b6 00             	movzbl (%eax),%eax
 80494b4:	0f be c0             	movsbl %al,%eax
 80494b7:	83 ec 0c             	sub    $0xc,%esp
 80494ba:	50                   	push   %eax
 80494bb:	8b 45 08             	mov    0x8(%ebp),%eax
 80494be:	ff d0                	call   *%eax
 80494c0:	83 c4 10             	add    $0x10,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80494c3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80494c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80494ca:	0f b6 00             	movzbl (%eax),%eax
 80494cd:	84 c0                	test   %al,%al
 80494cf:	75 dd                	jne    80494ae <vfprintf+0x5c>
					printer(*p);
				}
				XNEXT(pointer);
 80494d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80494d5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
 80494d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80494dc:	0f b6 00             	movzbl (%eax),%eax
 80494df:	3c 78                	cmp    $0x78,%al
 80494e1:	0f 85 9f 00 00 00    	jne    8049586 <vfprintf+0x134>
				uint32_t x = XGET(pointer, int);
 80494e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80494ea:	8b 00                	mov    (%eax),%eax
 80494ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 80494ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80494f3:	75 1d                	jne    8049512 <vfprintf+0xc0>
					printer('0');
 80494f5:	83 ec 0c             	sub    $0xc,%esp
 80494f8:	6a 30                	push   $0x30
 80494fa:	8b 45 08             	mov    0x8(%ebp),%eax
 80494fd:	ff d0                	call   *%eax
 80494ff:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8049502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8049506:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804950d:	e9 d5 01 00 00       	jmp    80496e7 <vfprintf+0x295>
					continue;
				}
				char digits[100];
				int di=0;
 8049512:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 8049519:	eb 30                	jmp    804954b <vfprintf+0xf9>
					int d=(x%16);
 804951b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804951e:	83 e0 0f             	and    $0xf,%eax
 8049521:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8049524:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8049528:	7e 04                	jle    804952e <vfprintf+0xdc>
						d+='a'-'0'-10;
 804952a:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 804952e:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8049531:	83 c0 30             	add    $0x30,%eax
 8049534:	89 c1                	mov    %eax,%ecx
 8049536:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
 804953c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804953f:	01 d0                	add    %edx,%eax
 8049541:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8049543:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8049547:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
 804954b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804954f:	75 ca                	jne    804951b <vfprintf+0xc9>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8049551:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8049555:	eb 21                	jmp    8049578 <vfprintf+0x126>
					printer(digits[di]);
 8049557:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
 804955d:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8049560:	01 d0                	add    %edx,%eax
 8049562:	0f b6 00             	movzbl (%eax),%eax
 8049565:	0f be c0             	movsbl %al,%eax
 8049568:	83 ec 0c             	sub    $0xc,%esp
 804956b:	50                   	push   %eax
 804956c:	8b 45 08             	mov    0x8(%ebp),%eax
 804956f:	ff d0                	call   *%eax
 8049571:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8049574:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8049578:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804957c:	79 d9                	jns    8049557 <vfprintf+0x105>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804957e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049582:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
 8049586:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049589:	0f b6 00             	movzbl (%eax),%eax
 804958c:	3c 64                	cmp    $0x64,%al
 804958e:	0f 85 08 01 00 00    	jne    804969c <vfprintf+0x24a>
				int x = XGET(pointer, int);
 8049594:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049597:	8b 00                	mov    (%eax),%eax
 8049599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 804959c:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80495a3:	75 23                	jne    80495c8 <vfprintf+0x176>
					printp(printer, "-2147483648");
 80495a5:	83 ec 08             	sub    $0x8,%esp
 80495a8:	68 07 a0 04 08       	push   $0x804a007
 80495ad:	ff 75 08             	pushl  0x8(%ebp)
 80495b0:	e8 6a fe ff ff       	call   804941f <printp>
 80495b5:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80495b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80495bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80495c3:	e9 1f 01 00 00       	jmp    80496e7 <vfprintf+0x295>
				}
				if(x==0){
 80495c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80495cc:	75 1e                	jne    80495ec <vfprintf+0x19a>
					printer('0');
 80495ce:	83 ec 0c             	sub    $0xc,%esp
 80495d1:	6a 30                	push   $0x30
 80495d3:	8b 45 08             	mov    0x8(%ebp),%eax
 80495d6:	ff d0                	call   *%eax
 80495d8:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80495db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80495df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80495e6:	90                   	nop
 80495e7:	e9 fb 00 00 00       	jmp    80496e7 <vfprintf+0x295>
				}
				if(x<0){
 80495ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80495f0:	79 10                	jns    8049602 <vfprintf+0x1b0>
					printer('-');
 80495f2:	83 ec 0c             	sub    $0xc,%esp
 80495f5:	6a 2d                	push   $0x2d
 80495f7:	8b 45 08             	mov    0x8(%ebp),%eax
 80495fa:	ff d0                	call   *%eax
 80495fc:	83 c4 10             	add    $0x10,%esp
					x=-x;
 80495ff:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
 8049602:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8049609:	eb 56                	jmp    8049661 <vfprintf+0x20f>
					digits[di] = '0'+(x%10);
 804960b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804960e:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8049613:	89 c8                	mov    %ecx,%eax
 8049615:	f7 ea                	imul   %edx
 8049617:	c1 fa 02             	sar    $0x2,%edx
 804961a:	89 c8                	mov    %ecx,%eax
 804961c:	c1 f8 1f             	sar    $0x1f,%eax
 804961f:	29 c2                	sub    %eax,%edx
 8049621:	89 d0                	mov    %edx,%eax
 8049623:	c1 e0 02             	shl    $0x2,%eax
 8049626:	01 d0                	add    %edx,%eax
 8049628:	01 c0                	add    %eax,%eax
 804962a:	29 c1                	sub    %eax,%ecx
 804962c:	89 ca                	mov    %ecx,%edx
 804962e:	89 d0                	mov    %edx,%eax
 8049630:	83 c0 30             	add    $0x30,%eax
 8049633:	89 c1                	mov    %eax,%ecx
 8049635:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
 804963b:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804963e:	01 d0                	add    %edx,%eax
 8049640:	88 08                	mov    %cl,(%eax)
					x/=10;
 8049642:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8049645:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804964a:	89 c8                	mov    %ecx,%eax
 804964c:	f7 ea                	imul   %edx
 804964e:	c1 fa 02             	sar    $0x2,%edx
 8049651:	89 c8                	mov    %ecx,%eax
 8049653:	c1 f8 1f             	sar    $0x1f,%eax
 8049656:	29 c2                	sub    %eax,%edx
 8049658:	89 d0                	mov    %edx,%eax
 804965a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 804965d:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
 8049661:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8049665:	7f a4                	jg     804960b <vfprintf+0x1b9>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8049667:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 804966b:	eb 21                	jmp    804968e <vfprintf+0x23c>
					printer(digits[di]);
 804966d:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
 8049673:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049676:	01 d0                	add    %edx,%eax
 8049678:	0f b6 00             	movzbl (%eax),%eax
 804967b:	0f be c0             	movsbl %al,%eax
 804967e:	83 ec 0c             	sub    $0xc,%esp
 8049681:	50                   	push   %eax
 8049682:	8b 45 08             	mov    0x8(%ebp),%eax
 8049685:	ff d0                	call   *%eax
 8049687:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804968a:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 804968e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8049692:	79 d9                	jns    804966d <vfprintf+0x21b>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8049694:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049698:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 804969c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804969f:	0f b6 00             	movzbl (%eax),%eax
 80496a2:	3c 63                	cmp    $0x63,%al
 80496a4:	75 1d                	jne    80496c3 <vfprintf+0x271>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80496a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80496a9:	0f b6 00             	movzbl (%eax),%eax
 80496ac:	0f be c0             	movsbl %al,%eax
 80496af:	83 ec 0c             	sub    $0xc,%esp
 80496b2:	50                   	push   %eax
 80496b3:	8b 45 08             	mov    0x8(%ebp),%eax
 80496b6:	ff d0                	call   *%eax
 80496b8:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80496bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80496bf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80496c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80496ca:	eb 1b                	jmp    80496e7 <vfprintf+0x295>
		}
		if(type == NONE){
 80496cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80496d0:	75 15                	jne    80496e7 <vfprintf+0x295>
			printer(cur);
 80496d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496d5:	0f b6 00             	movzbl (%eax),%eax
 80496d8:	0f be c0             	movsbl %al,%eax
 80496db:	83 ec 0c             	sub    $0xc,%esp
 80496de:	50                   	push   %eax
 80496df:	8b 45 08             	mov    0x8(%ebp),%eax
 80496e2:	ff d0                	call   *%eax
 80496e4:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 80496e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80496eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496ee:	0f b6 00             	movzbl (%eax),%eax
 80496f1:	84 c0                	test   %al,%al
 80496f3:	0f 85 81 fd ff ff    	jne    804947a <vfprintf+0x28>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 80496f9:	c9                   	leave  
 80496fa:	c3                   	ret    

080496fb <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 80496fb:	55                   	push   %ebp
 80496fc:	89 e5                	mov    %esp,%ebp
 80496fe:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8049701:	8d 45 0c             	lea    0xc(%ebp),%eax
 8049704:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintf(sys_printch, ctl, args);
 8049707:	8b 45 08             	mov    0x8(%ebp),%eax
 804970a:	83 ec 04             	sub    $0x4,%esp
 804970d:	ff 75 f4             	pushl  -0xc(%ebp)
 8049710:	50                   	push   %eax
 8049711:	68 ff 93 04 08       	push   $0x80493ff
 8049716:	e8 37 fd ff ff       	call   8049452 <vfprintf>
 804971b:	83 c4 10             	add    $0x10,%esp
}
 804971e:	c9                   	leave  
 804971f:	c3                   	ret    
