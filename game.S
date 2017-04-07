
game.bin:     file format elf32-i386


Disassembly of section .text:

00200000 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
  200000:	55                   	push   %ebp
  200001:	57                   	push   %edi
  200002:	56                   	push   %esi
  200003:	53                   	push   %ebx
    unsigned long long t, A = 698769069ULL;    
  
    x = 69069*x+12345;    
  200004:	69 2d 0c 20 20 00 cd 	imul   $0x10dcd,0x20200c,%ebp
  20000b:	0d 01 00 
  20000e:	81 c5 39 30 00 00    	add    $0x3039,%ebp
  200014:	89 2d 0c 20 20 00    	mov    %ebp,0x20200c
    y ^= (y<<13);   
  20001a:	a1 08 20 20 00       	mov    0x202008,%eax
  20001f:	89 c3                	mov    %eax,%ebx
  200021:	c1 e3 0d             	shl    $0xd,%ebx
  200024:	31 c3                	xor    %eax,%ebx
    y ^= (y>>17);   
  200026:	89 d8                	mov    %ebx,%eax
  200028:	c1 e8 11             	shr    $0x11,%eax
  20002b:	31 c3                	xor    %eax,%ebx
    y ^= (y<<5);    
  20002d:	89 d8                	mov    %ebx,%eax
  20002f:	c1 e0 05             	shl    $0x5,%eax
  200032:	31 c3                	xor    %eax,%ebx
  200034:	89 1d 08 20 20 00    	mov    %ebx,0x202008
      
    t = (A*z + c);  
  20003a:	b9 ad 5e a6 29       	mov    $0x29a65ead,%ecx
  20003f:	89 c8                	mov    %ecx,%eax
  200041:	f7 25 04 20 20 00    	mull   0x202004
  200047:	89 d1                	mov    %edx,%ecx
  200049:	89 c2                	mov    %eax,%edx
  20004b:	8b 35 00 20 20 00    	mov    0x202000,%esi
  200051:	bf 00 00 00 00       	mov    $0x0,%edi
  200056:	01 d6                	add    %edx,%esi
  200058:	11 cf                	adc    %ecx,%edi
    c = (t >> 32);  
  20005a:	89 3d 00 20 20 00    	mov    %edi,0x202000
    z = t;  
  200060:	89 f0                	mov    %esi,%eax
  200062:	89 35 04 20 20 00    	mov    %esi,0x202004
  200068:	01 e8                	add    %ebp,%eax
       
    return x+y+z;    
  20006a:	01 d8                	add    %ebx,%eax
  20006c:	5b                   	pop    %ebx
  20006d:	5e                   	pop    %esi
  20006e:	5f                   	pop    %edi
  20006f:	5d                   	pop    %ebp
  200070:	c3                   	ret    

00200071 <hitMonster>:
domain int x, y, size, score = 0;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
  200071:	55                   	push   %ebp
  200072:	57                   	push   %edi
  200073:	56                   	push   %esi
  200074:	53                   	push   %ebx
  200075:	83 ec 0c             	sub    $0xc,%esp
	int i=0;
	REP_MONSTER(){
		int dx = x-mon.x; 
  200078:	a1 68 2e 20 00       	mov    0x202e68,%eax
  20007d:	89 04 24             	mov    %eax,(%esp)
		int dy = y-mon.y;
  200080:	a1 64 2e 20 00       	mov    0x202e64,%eax
  200085:	89 44 24 04          	mov    %eax,0x4(%esp)
  200089:	ba 04 2a 20 00       	mov    $0x202a04,%edx
  20008e:	bd 34 2c 20 00       	mov    $0x202c34,%ebp

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
  200093:	b9 00 00 00 00       	mov    $0x0,%ecx
	REP_MONSTER(){
		int dx = x-mon.x; 
  200098:	8b 32                	mov    (%edx),%esi
		int dy = y-mon.y;
  20009a:	8b 5a 04             	mov    0x4(%edx),%ebx
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
  20009d:	8b 42 10             	mov    0x10(%edx),%eax
  2000a0:	85 c0                	test   %eax,%eax
  2000a2:	75 66                	jne    20010a <hitMonster+0x99>


int hitMonster(){
	int i=0;
	REP_MONSTER(){
		int dx = x-mon.x; 
  2000a4:	8b 3c 24             	mov    (%esp),%edi
  2000a7:	29 f7                	sub    %esi,%edi
		int dy = y-mon.y;
  2000a9:	8b 74 24 04          	mov    0x4(%esp),%esi
  2000ad:	29 de                	sub    %ebx,%esi
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
  2000af:	8b 5a fc             	mov    -0x4(%edx),%ebx
  2000b2:	39 de                	cmp    %ebx,%esi
  2000b4:	7f 54                	jg     20010a <hitMonster+0x99>
  2000b6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  2000ba:	39 df                	cmp    %ebx,%edi
  2000bc:	7f 4c                	jg     20010a <hitMonster+0x99>
  2000be:	89 df                	mov    %ebx,%edi
  2000c0:	f7 df                	neg    %edi
  2000c2:	39 fe                	cmp    %edi,%esi
  2000c4:	7c 44                	jl     20010a <hitMonster+0x99>
  2000c6:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  2000ca:	7c 3e                	jl     20010a <hitMonster+0x99>
			if(mon.size <= size){
  2000cc:	8b 15 60 2e 20 00    	mov    0x202e60,%edx
  2000d2:	39 d3                	cmp    %edx,%ebx
  2000d4:	7f 28                	jg     2000fe <hitMonster+0x8d>
				mon.status = MONSTER_DEAD;
  2000d6:	6b c9 1c             	imul   $0x1c,%ecx,%ecx
  2000d9:	c7 81 14 2a 20 00 01 	movl   $0x1,0x202a14(%ecx)
  2000e0:	00 00 00 
				if(size<13)size++;
  2000e3:	83 fa 0c             	cmp    $0xc,%edx
  2000e6:	7f 09                	jg     2000f1 <hitMonster+0x80>
  2000e8:	83 c2 01             	add    $0x1,%edx
  2000eb:	89 15 60 2e 20 00    	mov    %edx,0x202e60
				score += mon.size;
  2000f1:	01 1d 70 2e 20 00    	add    %ebx,0x202e70
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
  2000f7:	b8 01 00 00 00       	mov    $0x1,%eax
  2000fc:	eb 1b                	jmp    200119 <hitMonster+0xa8>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
  2000fe:	c7 05 6c 2e 20 00 03 	movl   $0x3,0x202e6c
  200105:	00 00 00 
				return 0;
  200108:	eb 0f                	jmp    200119 <hitMonster+0xa8>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
  20010a:	83 c1 01             	add    $0x1,%ecx
  20010d:	83 c2 1c             	add    $0x1c,%edx
  200110:	39 ea                	cmp    %ebp,%edx
  200112:	75 84                	jne    200098 <hitMonster+0x27>
				return 0;
			}
			return 1;
		}
	}
	return 0;
  200114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  200119:	83 c4 0c             	add    $0xc,%esp
  20011c:	5b                   	pop    %ebx
  20011d:	5e                   	pop    %esi
  20011e:	5f                   	pop    %edi
  20011f:	5d                   	pop    %ebp
  200120:	c3                   	ret    

00200121 <drawMonster>:

void drawMonster(){
  200121:	55                   	push   %ebp
  200122:	57                   	push   %edi
  200123:	56                   	push   %esi
  200124:	53                   	push   %ebx
  200125:	83 ec 2c             	sub    $0x2c,%esp
  200128:	c7 44 24 18 08 2a 20 	movl   $0x202a08,0x18(%esp)
  20012f:	00 
  200130:	8b 44 24 18          	mov    0x18(%esp),%eax
  200134:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	int i=0;
	REP_MONSTER(){
		if(mon.status == MONSTER_ALIVE){
  200138:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  20013c:	0f 85 e1 01 00 00    	jne    200323 <drawMonster+0x202>
			mon.x += mon.sx;
  200142:	89 c1                	mov    %eax,%ecx
  200144:	8b 50 04             	mov    0x4(%eax),%edx
  200147:	03 50 fc             	add    -0x4(%eax),%edx
  20014a:	89 50 fc             	mov    %edx,-0x4(%eax)
			mon.y += mon.sy;
  20014d:	8b 40 08             	mov    0x8(%eax),%eax
  200150:	03 01                	add    (%ecx),%eax
  200152:	89 01                	mov    %eax,(%ecx)

			if(mon.x < 10) mon.x++;
  200154:	83 fa 09             	cmp    $0x9,%edx
  200157:	7f 06                	jg     20015f <drawMonster+0x3e>
  200159:	83 c2 01             	add    $0x1,%edx
  20015c:	89 51 fc             	mov    %edx,-0x4(%ecx)
			if(mon.x > VWIDTH-10) mon.x--;
  20015f:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  200163:	8b 52 fc             	mov    -0x4(%edx),%edx
  200166:	81 fa 36 01 00 00    	cmp    $0x136,%edx
  20016c:	7e 0a                	jle    200178 <drawMonster+0x57>
  20016e:	83 ea 01             	sub    $0x1,%edx
  200171:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  200175:	89 51 fc             	mov    %edx,-0x4(%ecx)
			if(mon.y < 10) mon.y++;
  200178:	83 f8 09             	cmp    $0x9,%eax
  20017b:	7f 09                	jg     200186 <drawMonster+0x65>
  20017d:	83 c0 01             	add    $0x1,%eax
  200180:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  200184:	89 02                	mov    %eax,(%edx)
			if(mon.y > VHEIGHT-10) mon.y--;
  200186:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  20018a:	8b 00                	mov    (%eax),%eax
  20018c:	3d be 00 00 00       	cmp    $0xbe,%eax
  200191:	7e 09                	jle    20019c <drawMonster+0x7b>
  200193:	83 e8 01             	sub    $0x1,%eax
  200196:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  20019a:	89 02                	mov    %eax,(%edx)
			int color = size>=mon.size?15:5;
  20019c:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  2001a0:	8b 41 f8             	mov    -0x8(%ecx),%eax
  2001a3:	89 c7                	mov    %eax,%edi
  2001a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2001a9:	3b 05 60 2e 20 00    	cmp    0x202e60,%eax
  2001af:	0f 9e c2             	setle  %dl
  2001b2:	0f b6 d2             	movzbl %dl,%edx
  2001b5:	83 ea 01             	sub    $0x1,%edx
  2001b8:	83 e2 f6             	and    $0xfffffff6,%edx
  2001bb:	83 c2 0f             	add    $0xf,%edx
			drawCirc(mon.x, mon.y, mon.size, color);
  2001be:	8b 29                	mov    (%ecx),%ebp
  2001c0:	8b 41 fc             	mov    -0x4(%ecx),%eax
  2001c3:	89 44 24 14          	mov    %eax,0x14(%esp)
}


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
  2001c7:	69 c8 49 01 00 00    	imul   $0x149,%eax,%ecx
  2001cd:	69 c5 9d 00 00 00    	imul   $0x9d,%ebp,%eax
  2001d3:	01 c1                	add    %eax,%ecx
  2001d5:	69 c7 c9 02 00 00    	imul   $0x2c9,%edi,%eax
  2001db:	01 c8                	add    %ecx,%eax
  2001dd:	01 05 e4 29 20 00    	add    %eax,0x2029e4
	for(i=-r; i<=r; i++){
  2001e3:	89 f9                	mov    %edi,%ecx
  2001e5:	f7 d9                	neg    %ecx
  2001e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  2001eb:	39 cf                	cmp    %ecx,%edi
  2001ed:	0f 8c b7 00 00 00    	jl     2002aa <drawMonster+0x189>
		int delta = isqrt(r*r-i*i)+1;
  2001f3:	89 f9                	mov    %edi,%ecx
  2001f5:	0f af cf             	imul   %edi,%ecx
  2001f8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
static inline void clearStage(){
	hash = 0;
	sys_init_vcache();
}
static inline void drawPoint(int x, int y, uint8_t color){
	sys_set_pixel(y, x, color);
  2001fc:	0f b6 d2             	movzbl %dl,%edx
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
}
static inline void sys_set_pixel(int x, int y, int color){
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
  2001ff:	b8 4f 04 00 00       	mov    $0x44f,%eax

static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
  200204:	8b 7c 24 08          	mov    0x8(%esp),%edi
  200208:	89 f9                	mov    %edi,%ecx
  20020a:	0f af cf             	imul   %edi,%ecx
  20020d:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  200211:	29 cb                	sub    %ecx,%ebx
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
    if(memoriza[x] > 0) return memoriza[x];
  200213:	8b 3c 9d 80 20 20 00 	mov    0x202080(,%ebx,4),%edi
  20021a:	85 ff                	test   %edi,%edi
  20021c:	75 5a                	jne    200278 <drawMonster+0x157>
    const uint16_t *p = squares;
  20021e:	b9 80 15 20 00       	mov    $0x201580,%ecx
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
  200223:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  200229:	76 05                	jbe    200230 <drawMonster+0x10f>
  20022b:	b9 c0 15 20 00       	mov    $0x2015c0,%ecx
    if (p[ 16] <= x) p +=  16;
  200230:	0f b7 71 20          	movzwl 0x20(%ecx),%esi
  200234:	39 f3                	cmp    %esi,%ebx
  200236:	72 03                	jb     20023b <drawMonster+0x11a>
  200238:	83 c1 20             	add    $0x20,%ecx
    if (p[  8] <= x) p +=   8;
  20023b:	0f b7 71 10          	movzwl 0x10(%ecx),%esi
  20023f:	39 f3                	cmp    %esi,%ebx
  200241:	72 03                	jb     200246 <drawMonster+0x125>
  200243:	83 c1 10             	add    $0x10,%ecx
    if (p[  4] <= x) p +=   4;
  200246:	0f b7 71 08          	movzwl 0x8(%ecx),%esi
  20024a:	39 f3                	cmp    %esi,%ebx
  20024c:	72 03                	jb     200251 <drawMonster+0x130>
  20024e:	83 c1 08             	add    $0x8,%ecx
    if (p[  2] <= x) p +=   2;
  200251:	0f b7 71 04          	movzwl 0x4(%ecx),%esi
  200255:	39 f3                	cmp    %esi,%ebx
  200257:	72 03                	jb     20025c <drawMonster+0x13b>
  200259:	83 c1 04             	add    $0x4,%ecx
    if (p[  1] <= x) p +=   1;
  20025c:	0f b7 71 02          	movzwl 0x2(%ecx),%esi
  200260:	39 f3                	cmp    %esi,%ebx
  200262:	72 03                	jb     200267 <drawMonster+0x146>
  200264:	83 c1 02             	add    $0x2,%ecx
    memoriza[x] = p - squares;
  200267:	81 e9 80 15 20 00    	sub    $0x201580,%ecx
  20026d:	d1 f9                	sar    %ecx
  20026f:	89 cf                	mov    %ecx,%edi
  200271:	89 0c 9d 80 20 20 00 	mov    %ecx,0x202080(,%ebx,4)

static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
  200278:	83 c7 01             	add    $0x1,%edi
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
  20027b:	89 fe                	mov    %edi,%esi
  20027d:	f7 de                	neg    %esi
  20027f:	39 f7                	cmp    %esi,%edi
  200281:	7c 14                	jl     200297 <drawMonster+0x176>
  200283:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  200287:	03 4c 24 14          	add    0x14(%esp),%ecx
  20028b:	8d 1c 2e             	lea    (%esi,%ebp,1),%ebx
  20028e:	cd 80                	int    $0x80
  200290:	83 c6 01             	add    $0x1,%esi
  200293:	39 f7                	cmp    %esi,%edi
  200295:	7d f4                	jge    20028b <drawMonster+0x16a>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
  200297:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
  20029c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  2002a0:	39 7c 24 0c          	cmp    %edi,0xc(%esp)
  2002a4:	0f 8d 5a ff ff ff    	jge    200204 <drawMonster+0xe3>
			if(KISS()%60==0){
  2002aa:	e8 51 fd ff ff       	call   200000 <UKISS>
  2002af:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  2002b5:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2002bb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2002be:	b8 89 88 88 88       	mov    $0x88888889,%eax
  2002c3:	f7 e1                	mul    %ecx
  2002c5:	c1 ea 05             	shr    $0x5,%edx
  2002c8:	6b d2 3c             	imul   $0x3c,%edx,%edx
  2002cb:	39 d1                	cmp    %edx,%ecx
  2002cd:	75 54                	jne    200323 <drawMonster+0x202>
				mon.sx = -1 + KISS()%3;
  2002cf:	e8 2c fd ff ff       	call   200000 <UKISS>
  2002d4:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  2002da:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2002e0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2002e3:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
  2002e8:	f7 e1                	mul    %ecx
  2002ea:	d1 ea                	shr    %edx
  2002ec:	8d 04 52             	lea    (%edx,%edx,2),%eax
  2002ef:	29 c1                	sub    %eax,%ecx
  2002f1:	8d 41 ff             	lea    -0x1(%ecx),%eax
  2002f4:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  2002f8:	89 47 04             	mov    %eax,0x4(%edi)
				mon.sy = -1 + KISS()%3;
  2002fb:	e8 00 fd ff ff       	call   200000 <UKISS>
  200300:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  200306:	03 15 64 2e 20 00    	add    0x202e64,%edx
  20030c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  20030f:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
  200314:	f7 e1                	mul    %ecx
  200316:	d1 ea                	shr    %edx
  200318:	8d 04 52             	lea    (%edx,%edx,2),%eax
  20031b:	29 c1                	sub    %eax,%ecx
  20031d:	8d 41 ff             	lea    -0x1(%ecx),%eax
  200320:	89 47 08             	mov    %eax,0x8(%edi)
  200323:	83 44 24 18 1c       	addl   $0x1c,0x18(%esp)
  200328:	8b 44 24 18          	mov    0x18(%esp),%eax
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
  20032c:	3d 38 2c 20 00       	cmp    $0x202c38,%eax
  200331:	0f 85 f9 fd ff ff    	jne    200130 <drawMonster+0xf>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
  200337:	83 c4 2c             	add    $0x2c,%esp
  20033a:	5b                   	pop    %ebx
  20033b:	5e                   	pop    %esi
  20033c:	5f                   	pop    %edi
  20033d:	5d                   	pop    %ebp
  20033e:	c3                   	ret    

0020033f <createMonster>:
void createMonster(){
  20033f:	55                   	push   %ebp
  200340:	57                   	push   %edi
  200341:	56                   	push   %esi
  200342:	53                   	push   %ebx
  200343:	83 ec 0c             	sub    $0xc,%esp
  200346:	bb 14 2a 20 00       	mov    $0x202a14,%ebx
  20034b:	bf 44 2c 20 00       	mov    $0x202c44,%edi
	int i=0;
	REP_MONSTER(){
		if(mon.status == MONSTER_ALIVE) continue;
		if(KISS()%(250*MONSTER_SIZE) == 0){
  200350:	bd 59 17 b7 d1       	mov    $0xd1b71759,%ebp
  200355:	89 de                	mov    %ebx,%esi
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
		if(mon.status == MONSTER_ALIVE) continue;
  200357:	83 3b 00             	cmpl   $0x0,(%ebx)
  20035a:	0f 84 c1 00 00 00    	je     200421 <createMonster+0xe2>
		if(KISS()%(250*MONSTER_SIZE) == 0){
  200360:	e8 9b fc ff ff       	call   200000 <UKISS>
  200365:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20036b:	03 15 64 2e 20 00    	add    0x202e64,%edx
  200371:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200374:	89 c8                	mov    %ecx,%eax
  200376:	f7 e5                	mul    %ebp
  200378:	c1 ea 0c             	shr    $0xc,%edx
  20037b:	69 d2 88 13 00 00    	imul   $0x1388,%edx,%edx
  200381:	39 d1                	cmp    %edx,%ecx
  200383:	0f 85 98 00 00 00    	jne    200421 <createMonster+0xe2>
			mon.status = MONSTER_ALIVE;
  200389:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
			mon.size = 2 + 2*(KISS()%size);
  20038f:	e8 6c fc ff ff       	call   200000 <UKISS>
  200394:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20039a:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2003a0:	01 d0                	add    %edx,%eax
  2003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  2003a7:	f7 35 60 2e 20 00    	divl   0x202e60
  2003ad:	8d 44 12 02          	lea    0x2(%edx,%edx,1),%eax
  2003b1:	89 43 ec             	mov    %eax,-0x14(%ebx)
			mon.size = mon.size >14?14:mon.size; 
  2003b4:	89 c2                	mov    %eax,%edx
  2003b6:	83 f8 0e             	cmp    $0xe,%eax
  2003b9:	7e 05                	jle    2003c0 <createMonster+0x81>
  2003bb:	ba 0e 00 00 00       	mov    $0xe,%edx
  2003c0:	89 56 ec             	mov    %edx,-0x14(%esi)
			mon.x = VWIDTH/2;
  2003c3:	c7 46 f0 a0 00 00 00 	movl   $0xa0,-0x10(%esi)
			mon.y = VHEIGHT/2;
  2003ca:	c7 46 f4 64 00 00 00 	movl   $0x64,-0xc(%esi)
			mon.sx = -1 + KISS()%3;
  2003d1:	e8 2a fc ff ff       	call   200000 <UKISS>
  2003d6:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  2003dc:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2003e2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2003e5:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
  2003ea:	f7 e1                	mul    %ecx
  2003ec:	d1 ea                	shr    %edx
  2003ee:	8d 04 52             	lea    (%edx,%edx,2),%eax
  2003f1:	29 c1                	sub    %eax,%ecx
  2003f3:	83 e9 01             	sub    $0x1,%ecx
  2003f6:	89 4e f8             	mov    %ecx,-0x8(%esi)
			mon.sy = -1 + KISS()%3;
  2003f9:	e8 02 fc ff ff       	call   200000 <UKISS>
  2003fe:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  200404:	03 15 64 2e 20 00    	add    0x202e64,%edx
  20040a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  20040d:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
  200412:	f7 e1                	mul    %ecx
  200414:	d1 ea                	shr    %edx
  200416:	8d 04 52             	lea    (%edx,%edx,2),%eax
  200419:	29 c1                	sub    %eax,%ecx
  20041b:	83 e9 01             	sub    $0x1,%ecx
  20041e:	89 4e fc             	mov    %ecx,-0x4(%esi)
  200421:	83 c3 1c             	add    $0x1c,%ebx
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
  200424:	39 fb                	cmp    %edi,%ebx
  200426:	0f 85 29 ff ff ff    	jne    200355 <createMonster+0x16>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
  20042c:	83 c4 0c             	add    $0xc,%esp
  20042f:	5b                   	pop    %ebx
  200430:	5e                   	pop    %esi
  200431:	5f                   	pop    %edi
  200432:	5d                   	pop    %ebp
  200433:	c3                   	ret    

00200434 <dreamOf100HZ>:
void dreamOf100HZ(int timestamp){
  200434:	55                   	push   %ebp
  200435:	57                   	push   %edi
  200436:	56                   	push   %esi
  200437:	53                   	push   %ebx
  200438:	83 ec 3c             	sub    $0x3c,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
  20043b:	a1 6c 2e 20 00       	mov    0x202e6c,%eax
  200440:	85 c0                	test   %eax,%eax
  200442:	0f 85 1b 03 00 00    	jne    200763 <dreamOf100HZ+0x32f>
static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
  200448:	66 b8 4c 04          	mov    $0x44c,%ax
  20044c:	cd 80                	int    $0x80
  20044e:	c7 44 24 14 40 11 20 	movl   $0x201140,0x14(%esp)
  200455:	00 
  200456:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  20045d:	00 
  20045e:	c7 44 24 18 d4 0a 00 	movl   $0xad4,0x18(%esp)
  200465:	00 
  200466:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  20046d:	00 
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
}
static inline void sys_set_pixel(int x, int y, int color){
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
  20046e:	b0 4f                	mov    $0x4f,%al
  200470:	ba 0e 00 00 00       	mov    $0xe,%edx
  200475:	eb 57                	jmp    2004ce <dreamOf100HZ+0x9a>

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
  200477:	80 7d 00 00          	cmpb   $0x0,0x0(%ebp)
  20047b:	74 23                	je     2004a0 <dreamOf100HZ+0x6c>
}
static inline void drawPoint(int x, int y, uint8_t color){
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
  20047d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  200481:	01 5c 24 10          	add    %ebx,0x10(%esp)
  200485:	8d 4f fc             	lea    -0x4(%edi),%ecx
  200488:	eb 10                	jmp    20049a <dreamOf100HZ+0x66>
  20048a:	cd 80                	int    $0x80
  20048c:	83 c3 01             	add    $0x1,%ebx
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
  20048f:	39 f3                	cmp    %esi,%ebx
  200491:	75 f7                	jne    20048a <dreamOf100HZ+0x56>
  200493:	83 c1 01             	add    $0x1,%ecx
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
  200496:	39 cf                	cmp    %ecx,%edi
  200498:	74 06                	je     2004a0 <dreamOf100HZ+0x6c>
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
void dreamOf100HZ(int timestamp){
  20049a:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  20049e:	eb ea                	jmp    20048a <dreamOf100HZ+0x56>
  2004a0:	83 c5 01             	add    $0x1,%ebp
  2004a3:	83 c7 04             	add    $0x4,%edi
  2004a6:	83 44 24 0c 74       	addl   $0x74,0xc(%esp)
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
  2004ab:	81 ff 06 01 00 00    	cmp    $0x106,%edi
  2004b1:	75 c4                	jne    200477 <dreamOf100HZ+0x43>
  2004b3:	83 44 24 14 34       	addl   $0x34,0x14(%esp)
  2004b8:	81 44 24 18 1d 01 00 	addl   $0x11d,0x18(%esp)
  2004bf:	00 
  2004c0:	83 44 24 08 05       	addl   $0x5,0x8(%esp)
  2004c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
  2004c9:	83 ff 78             	cmp    $0x78,%edi
  2004cc:	74 1a                	je     2004e8 <dreamOf100HZ+0xb4>
  2004ce:	8b 7c 24 18          	mov    0x18(%esp),%edi
  2004d2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  2004d6:	8b 6c 24 14          	mov    0x14(%esp),%ebp
  2004da:	bf 36 00 00 00       	mov    $0x36,%edi
  2004df:	8b 74 24 08          	mov    0x8(%esp),%esi
  2004e3:	83 c6 05             	add    $0x5,%esi
  2004e6:	eb 8f                	jmp    200477 <dreamOf100HZ+0x43>
  2004e8:	8b 54 24 10          	mov    0x10(%esp),%edx
  2004ec:	89 15 e4 29 20 00    	mov    %edx,0x2029e4
        i++;
    }
}

static inline void drawStage(){
	if(lhash == hash)return;
  2004f2:	39 15 e0 29 20 00    	cmp    %edx,0x2029e0
  2004f8:	74 0d                	je     200507 <dreamOf100HZ+0xd3>

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
  2004fa:	b8 4e 04 00 00       	mov    $0x44e,%eax
  2004ff:	cd 80                	int    $0x80
	//clear_vram();
	sys_flush_vcache();
	lhash = hash;
  200501:	89 15 e0 29 20 00    	mov    %edx,0x2029e0
		drawText1();
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();

		int i=0;
		x = 30;
  200507:	c7 05 68 2e 20 00 1e 	movl   $0x1e,0x202e68
  20050e:	00 00 00 
		y = 30;
  200511:	c7 05 64 2e 20 00 1e 	movl   $0x1e,0x202e64
  200518:	00 00 00 
		size = 4;
  20051b:	c7 05 60 2e 20 00 04 	movl   $0x4,0x202e60
  200522:	00 00 00 
		score = 0;
  200525:	c7 05 70 2e 20 00 00 	movl   $0x0,0x202e70
  20052c:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
  20052f:	c7 05 14 2a 20 00 00 	movl   $0x0,0x202a14
  200536:	00 00 00 
		monsters[i].size = 1 + (KISS()%size);
  200539:	e8 c2 fa ff ff       	call   200000 <UKISS>
  20053e:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  200544:	03 15 64 2e 20 00    	add    0x202e64,%edx
  20054a:	01 d0                	add    %edx,%eax
  20054c:	ba 00 00 00 00       	mov    $0x0,%edx
  200551:	f7 35 60 2e 20 00    	divl   0x202e60
  200557:	8d 42 01             	lea    0x1(%edx),%eax
  20055a:	a3 00 2a 20 00       	mov    %eax,0x202a00
		monsters[i].x = KISS()%VWIDTH;
  20055f:	e8 9c fa ff ff       	call   200000 <UKISS>
  200564:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20056a:	03 15 64 2e 20 00    	add    0x202e64,%edx
  200570:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200573:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  200578:	89 c8                	mov    %ecx,%eax
  20057a:	f7 e2                	mul    %edx
  20057c:	89 d0                	mov    %edx,%eax
  20057e:	c1 e8 08             	shr    $0x8,%eax
  200581:	8d 04 80             	lea    (%eax,%eax,4),%eax
  200584:	c1 e0 06             	shl    $0x6,%eax
  200587:	29 c1                	sub    %eax,%ecx
  200589:	89 0d 04 2a 20 00    	mov    %ecx,0x202a04
		monsters[i].y = KISS()%VHEIGHT;
  20058f:	e8 6c fa ff ff       	call   200000 <UKISS>
  200594:	8b 0d 68 2e 20 00    	mov    0x202e68,%ecx
  20059a:	03 0d 64 2e 20 00    	add    0x202e64,%ecx
  2005a0:	01 c1                	add    %eax,%ecx
  2005a2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  2005a7:	89 c8                	mov    %ecx,%eax
  2005a9:	f7 e2                	mul    %edx
  2005ab:	c1 ea 06             	shr    $0x6,%edx
  2005ae:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
  2005b4:	29 d1                	sub    %edx,%ecx
  2005b6:	89 0d 08 2a 20 00    	mov    %ecx,0x202a08
		monsters[i].sx = -1 + KISS()%3;
  2005bc:	e8 3f fa ff ff       	call   200000 <UKISS>
  2005c1:	8b 0d 68 2e 20 00    	mov    0x202e68,%ecx
  2005c7:	03 0d 64 2e 20 00    	add    0x202e64,%ecx
  2005cd:	01 c1                	add    %eax,%ecx
  2005cf:	bb ab aa aa aa       	mov    $0xaaaaaaab,%ebx
  2005d4:	89 c8                	mov    %ecx,%eax
  2005d6:	f7 e3                	mul    %ebx
  2005d8:	89 d0                	mov    %edx,%eax
  2005da:	d1 e8                	shr    %eax
  2005dc:	8d 04 40             	lea    (%eax,%eax,2),%eax
  2005df:	29 c1                	sub    %eax,%ecx
  2005e1:	89 c8                	mov    %ecx,%eax
  2005e3:	83 e8 01             	sub    $0x1,%eax
  2005e6:	a3 0c 2a 20 00       	mov    %eax,0x202a0c
		monsters[i].sy = -1 + KISS()%3;
  2005eb:	e8 10 fa ff ff       	call   200000 <UKISS>
  2005f0:	8b 0d 68 2e 20 00    	mov    0x202e68,%ecx
  2005f6:	03 0d 64 2e 20 00    	add    0x202e64,%ecx
  2005fc:	01 c1                	add    %eax,%ecx
  2005fe:	89 c8                	mov    %ecx,%eax
  200600:	f7 e3                	mul    %ebx
  200602:	89 d0                	mov    %edx,%eax
  200604:	d1 e8                	shr    %eax
  200606:	8d 04 40             	lea    (%eax,%eax,2),%eax
  200609:	29 c1                	sub    %eax,%ecx
  20060b:	89 c8                	mov    %ecx,%eax
  20060d:	83 e8 01             	sub    $0x1,%eax
  200610:	a3 10 2a 20 00       	mov    %eax,0x202a10
  200615:	be 30 2a 20 00       	mov    $0x202a30,%esi
		i++;
		REP_MONSTER(){
			monsters[i].status = MONSTER_SLEEP;
			monsters[i].count = 0;
			if(KISS()%MONSTER_SIZE < size+3){
  20061a:	bd cd cc cc cc       	mov    $0xcccccccd,%ebp
				monsters[i].status = MONSTER_ALIVE;
				monsters[i].size = 1 + 2*(KISS()%size);
				monsters[i].x = KISS()%VWIDTH;
				monsters[i].y = KISS()%VHEIGHT;
  20061f:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
			monsters[i].status = MONSTER_SLEEP;
  200624:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
			monsters[i].count = 0;
  20062a:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
			if(KISS()%MONSTER_SIZE < size+3){
  200631:	e8 ca f9 ff ff       	call   200000 <UKISS>
  200636:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20063c:	03 15 64 2e 20 00    	add    0x202e64,%edx
  200642:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200645:	89 c8                	mov    %ecx,%eax
  200647:	f7 e5                	mul    %ebp
  200649:	89 d0                	mov    %edx,%eax
  20064b:	c1 e8 04             	shr    $0x4,%eax
  20064e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  200651:	c1 e0 02             	shl    $0x2,%eax
  200654:	29 c1                	sub    %eax,%ecx
  200656:	a1 60 2e 20 00       	mov    0x202e60,%eax
  20065b:	83 c0 03             	add    $0x3,%eax
  20065e:	39 c1                	cmp    %eax,%ecx
  200660:	0f 83 d2 00 00 00    	jae    200738 <dreamOf100HZ+0x304>
				monsters[i].status = MONSTER_ALIVE;
  200666:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
				monsters[i].size = 1 + 2*(KISS()%size);
  20066c:	e8 8f f9 ff ff       	call   200000 <UKISS>
  200671:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  200677:	03 15 64 2e 20 00    	add    0x202e64,%edx
  20067d:	01 d0                	add    %edx,%eax
  20067f:	ba 00 00 00 00       	mov    $0x0,%edx
  200684:	f7 35 60 2e 20 00    	divl   0x202e60
  20068a:	8d 44 12 01          	lea    0x1(%edx,%edx,1),%eax
  20068e:	89 46 ec             	mov    %eax,-0x14(%esi)
				monsters[i].x = KISS()%VWIDTH;
  200691:	e8 6a f9 ff ff       	call   200000 <UKISS>
  200696:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20069c:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2006a2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2006a5:	89 c8                	mov    %ecx,%eax
  2006a7:	f7 e5                	mul    %ebp
  2006a9:	89 d0                	mov    %edx,%eax
  2006ab:	c1 e8 08             	shr    $0x8,%eax
  2006ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
  2006b1:	c1 e0 06             	shl    $0x6,%eax
  2006b4:	29 c1                	sub    %eax,%ecx
  2006b6:	89 4e f0             	mov    %ecx,-0x10(%esi)
				monsters[i].y = KISS()%VHEIGHT;
  2006b9:	e8 42 f9 ff ff       	call   200000 <UKISS>
  2006be:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  2006c4:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2006ca:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2006cd:	89 c8                	mov    %ecx,%eax
  2006cf:	f7 e3                	mul    %ebx
  2006d1:	89 d0                	mov    %edx,%eax
  2006d3:	c1 e8 06             	shr    $0x6,%eax
  2006d6:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
  2006dc:	29 c1                	sub    %eax,%ecx
  2006de:	89 4e f4             	mov    %ecx,-0xc(%esi)
				monsters[i].sx = -1 + KISS()%3;
  2006e1:	e8 1a f9 ff ff       	call   200000 <UKISS>
  2006e6:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  2006ec:	03 15 64 2e 20 00    	add    0x202e64,%edx
  2006f2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2006f5:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
  2006fa:	89 c8                	mov    %ecx,%eax
  2006fc:	f7 e7                	mul    %edi
  2006fe:	89 d0                	mov    %edx,%eax
  200700:	d1 e8                	shr    %eax
  200702:	8d 04 40             	lea    (%eax,%eax,2),%eax
  200705:	29 c1                	sub    %eax,%ecx
  200707:	89 c8                	mov    %ecx,%eax
  200709:	83 e8 01             	sub    $0x1,%eax
  20070c:	89 46 f8             	mov    %eax,-0x8(%esi)
				monsters[i].sy = -1 + KISS()%3;
  20070f:	e8 ec f8 ff ff       	call   200000 <UKISS>
  200714:	8b 15 68 2e 20 00    	mov    0x202e68,%edx
  20071a:	03 15 64 2e 20 00    	add    0x202e64,%edx
  200720:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200723:	89 c8                	mov    %ecx,%eax
  200725:	f7 e7                	mul    %edi
  200727:	89 d0                	mov    %edx,%eax
  200729:	d1 e8                	shr    %eax
  20072b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  20072e:	29 c1                	sub    %eax,%ecx
  200730:	89 c8                	mov    %ecx,%eax
  200732:	83 e8 01             	sub    $0x1,%eax
  200735:	89 46 fc             	mov    %eax,-0x4(%esi)
  200738:	83 c6 1c             	add    $0x1c,%esi
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
  20073b:	81 fe 44 2c 20 00    	cmp    $0x202c44,%esi
  200741:	0f 85 dd fe ff ff    	jne    200624 <dreamOf100HZ+0x1f0>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
  200747:	83 ec 0c             	sub    $0xc,%esp
  20074a:	68 80 0e 20 00       	push   $0x200e80
  20074f:	e8 fe 06 00 00       	call   200e52 <printf>
		gameStatus = GAME_READY;
  200754:	c7 05 6c 2e 20 00 01 	movl   $0x1,0x202e6c
  20075b:	00 00 00 
  20075e:	83 c4 10             	add    $0x10,%esp
  200761:	eb 05                	jmp    200768 <dreamOf100HZ+0x334>
	}
	if(gameStatus == GAME_READY){
  200763:	83 f8 01             	cmp    $0x1,%eax
  200766:	75 1a                	jne    200782 <dreamOf100HZ+0x34e>
}
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
  200768:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  20076d:	bb 71 00 00 00       	mov    $0x71,%ebx
  200772:	b8 b0 04 00 00       	mov    $0x4b0,%eax
  200777:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  200779:	89 44 24 25          	mov    %eax,0x25(%esp)
  20077d:	e9 cc 03 00 00       	jmp    200b4e <dreamOf100HZ+0x71a>
			printf("Press W, A, S, D to move\n");
			gameStatus = GAME_ING;
		}
	}

	if(gameStatus == GAME_ING){
  200782:	83 f8 02             	cmp    $0x2,%eax
  200785:	0f 85 c3 03 00 00    	jne    200b4e <dreamOf100HZ+0x71a>
}
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
  20078b:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  200790:	bb 61 00 00 00       	mov    $0x61,%ebx
  200795:	66 b8 b0 04          	mov    $0x4b0,%ax
  200799:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  20079b:	89 44 24 25          	mov    %eax,0x25(%esp)
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  20079f:	bb 64 00 00 00       	mov    $0x64,%ebx
  2007a4:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  2007a6:	89 44 24 25          	mov    %eax,0x25(%esp)
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  2007aa:	bb 77 00 00 00       	mov    $0x77,%ebx
  2007af:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  2007b1:	89 44 24 25          	mov    %eax,0x25(%esp)
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  2007b5:	bb 73 00 00 00       	mov    $0x73,%ebx
  2007ba:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  2007bc:	89 44 24 25          	mov    %eax,0x25(%esp)
			if(key('d'))x++;
			if(key('w'))y--;
			if(key('s'))y++;
		//}

		if(x < 0) x++;
  2007c0:	a1 68 2e 20 00       	mov    0x202e68,%eax
  2007c5:	85 c0                	test   %eax,%eax
  2007c7:	79 08                	jns    2007d1 <dreamOf100HZ+0x39d>
  2007c9:	83 c0 01             	add    $0x1,%eax
  2007cc:	a3 68 2e 20 00       	mov    %eax,0x202e68
		if(x > VWIDTH) x--;
  2007d1:	a1 68 2e 20 00       	mov    0x202e68,%eax
  2007d6:	3d 40 01 00 00       	cmp    $0x140,%eax
  2007db:	7e 08                	jle    2007e5 <dreamOf100HZ+0x3b1>
  2007dd:	83 e8 01             	sub    $0x1,%eax
  2007e0:	a3 68 2e 20 00       	mov    %eax,0x202e68
		if(y < 0) y++;
  2007e5:	a1 64 2e 20 00       	mov    0x202e64,%eax
  2007ea:	85 c0                	test   %eax,%eax
  2007ec:	79 08                	jns    2007f6 <dreamOf100HZ+0x3c2>
  2007ee:	83 c0 01             	add    $0x1,%eax
  2007f1:	a3 64 2e 20 00       	mov    %eax,0x202e64
		if(y > VHEIGHT) y--;
  2007f6:	a1 64 2e 20 00       	mov    0x202e64,%eax
  2007fb:	3d c8 00 00 00       	cmp    $0xc8,%eax
  200800:	7e 08                	jle    20080a <dreamOf100HZ+0x3d6>
  200802:	83 e8 01             	sub    $0x1,%eax
  200805:	a3 64 2e 20 00       	mov    %eax,0x202e64
static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
  20080a:	b8 4c 04 00 00       	mov    $0x44c,%eax
  20080f:	cd 80                	int    $0x80
		//}
		//else{
		clearStage();
		drawCirc(x, y, size, 3);
  200811:	a1 60 2e 20 00       	mov    0x202e60,%eax
  200816:	89 c7                	mov    %eax,%edi
  200818:	89 44 24 0c          	mov    %eax,0xc(%esp)
  20081c:	8b 2d 64 2e 20 00    	mov    0x202e64,%ebp
  200822:	a1 68 2e 20 00       	mov    0x202e68,%eax
  200827:	89 44 24 10          	mov    %eax,0x10(%esp)
}


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
  20082b:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
  200831:	69 c5 9d 00 00 00    	imul   $0x9d,%ebp,%eax
  200837:	01 c2                	add    %eax,%edx
  200839:	69 c7 c9 02 00 00    	imul   $0x2c9,%edi,%eax
  20083f:	01 d0                	add    %edx,%eax
  200841:	a3 e4 29 20 00       	mov    %eax,0x2029e4
	for(i=-r; i<=r; i++){
  200846:	89 fa                	mov    %edi,%edx
  200848:	89 f8                	mov    %edi,%eax
  20084a:	f7 d8                	neg    %eax
  20084c:	89 44 24 08          	mov    %eax,0x8(%esp)
  200850:	39 c2                	cmp    %eax,%edx
  200852:	0f 8c b9 00 00 00    	jl     200911 <dreamOf100HZ+0x4dd>
		int delta = isqrt(r*r-i*i)+1;
  200858:	89 d7                	mov    %edx,%edi
  20085a:	0f af fa             	imul   %edx,%edi
  20085d:	89 7c 24 14          	mov    %edi,0x14(%esp)
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
}
static inline void sys_set_pixel(int x, int y, int color){
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
  200861:	b8 4f 04 00 00       	mov    $0x44f,%eax
  200866:	8b 7c 24 08          	mov    0x8(%esp),%edi
  20086a:	89 fa                	mov    %edi,%edx
  20086c:	0f af d7             	imul   %edi,%edx
  20086f:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  200873:	29 d1                	sub    %edx,%ecx
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
    if(memoriza[x] > 0) return memoriza[x];
  200875:	8b 3c 8d 80 20 20 00 	mov    0x202080(,%ecx,4),%edi
  20087c:	85 ff                	test   %edi,%edi
  20087e:	75 5a                	jne    2008da <dreamOf100HZ+0x4a6>
    const uint16_t *p = squares;
  200880:	ba 80 15 20 00       	mov    $0x201580,%edx
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
  200885:	81 f9 ff 03 00 00    	cmp    $0x3ff,%ecx
  20088b:	76 05                	jbe    200892 <dreamOf100HZ+0x45e>
  20088d:	ba c0 15 20 00       	mov    $0x2015c0,%edx
    if (p[ 16] <= x) p +=  16;
  200892:	0f b7 5a 20          	movzwl 0x20(%edx),%ebx
  200896:	39 d9                	cmp    %ebx,%ecx
  200898:	72 03                	jb     20089d <dreamOf100HZ+0x469>
  20089a:	83 c2 20             	add    $0x20,%edx
    if (p[  8] <= x) p +=   8;
  20089d:	0f b7 5a 10          	movzwl 0x10(%edx),%ebx
  2008a1:	39 d9                	cmp    %ebx,%ecx
  2008a3:	72 03                	jb     2008a8 <dreamOf100HZ+0x474>
  2008a5:	83 c2 10             	add    $0x10,%edx
    if (p[  4] <= x) p +=   4;
  2008a8:	0f b7 5a 08          	movzwl 0x8(%edx),%ebx
  2008ac:	39 d9                	cmp    %ebx,%ecx
  2008ae:	72 03                	jb     2008b3 <dreamOf100HZ+0x47f>
  2008b0:	83 c2 08             	add    $0x8,%edx
    if (p[  2] <= x) p +=   2;
  2008b3:	0f b7 5a 04          	movzwl 0x4(%edx),%ebx
  2008b7:	39 d9                	cmp    %ebx,%ecx
  2008b9:	72 03                	jb     2008be <dreamOf100HZ+0x48a>
  2008bb:	83 c2 04             	add    $0x4,%edx
    if (p[  1] <= x) p +=   1;
  2008be:	0f b7 5a 02          	movzwl 0x2(%edx),%ebx
  2008c2:	39 d9                	cmp    %ebx,%ecx
  2008c4:	72 03                	jb     2008c9 <dreamOf100HZ+0x495>
  2008c6:	83 c2 02             	add    $0x2,%edx
    memoriza[x] = p - squares;
  2008c9:	81 ea 80 15 20 00    	sub    $0x201580,%edx
  2008cf:	d1 fa                	sar    %edx
  2008d1:	89 d7                	mov    %edx,%edi
  2008d3:	89 14 8d 80 20 20 00 	mov    %edx,0x202080(,%ecx,4)

static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
  2008da:	83 c7 01             	add    $0x1,%edi
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
  2008dd:	89 fe                	mov    %edi,%esi
  2008df:	f7 de                	neg    %esi
  2008e1:	39 f7                	cmp    %esi,%edi
  2008e3:	7c 19                	jl     2008fe <dreamOf100HZ+0x4ca>
  2008e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  2008e9:	03 4c 24 10          	add    0x10(%esp),%ecx
  2008ed:	8d 1c 2e             	lea    (%esi,%ebp,1),%ebx
  2008f0:	ba 03 00 00 00       	mov    $0x3,%edx
  2008f5:	cd 80                	int    $0x80
  2008f7:	83 c6 01             	add    $0x1,%esi
  2008fa:	39 f7                	cmp    %esi,%edi
  2008fc:	7d ef                	jge    2008ed <dreamOf100HZ+0x4b9>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
  2008fe:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
  200903:	8b 54 24 08          	mov    0x8(%esp),%edx
  200907:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  20090b:	0f 8d 55 ff ff ff    	jge    200866 <dreamOf100HZ+0x432>
		

		drawMonster();
  200911:	e8 0b f8 ff ff       	call   200121 <drawMonster>
		drawCirc(x, y, size, 3);
  200916:	a1 60 2e 20 00       	mov    0x202e60,%eax
  20091b:	89 c7                	mov    %eax,%edi
  20091d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  200921:	8b 2d 64 2e 20 00    	mov    0x202e64,%ebp
  200927:	a1 68 2e 20 00       	mov    0x202e68,%eax
  20092c:	89 44 24 10          	mov    %eax,0x10(%esp)
}


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
  200930:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
  200936:	69 c5 9d 00 00 00    	imul   $0x9d,%ebp,%eax
  20093c:	01 c2                	add    %eax,%edx
  20093e:	69 c7 c9 02 00 00    	imul   $0x2c9,%edi,%eax
  200944:	01 d0                	add    %edx,%eax
  200946:	01 05 e4 29 20 00    	add    %eax,0x2029e4
	for(i=-r; i<=r; i++){
  20094c:	89 fa                	mov    %edi,%edx
  20094e:	89 f8                	mov    %edi,%eax
  200950:	f7 d8                	neg    %eax
  200952:	89 44 24 08          	mov    %eax,0x8(%esp)
  200956:	39 c2                	cmp    %eax,%edx
  200958:	0f 8c b9 00 00 00    	jl     200a17 <dreamOf100HZ+0x5e3>
		int delta = isqrt(r*r-i*i)+1;
  20095e:	89 d7                	mov    %edx,%edi
  200960:	0f af fa             	imul   %edx,%edi
  200963:	89 7c 24 14          	mov    %edi,0x14(%esp)
  200967:	b8 4f 04 00 00       	mov    $0x44f,%eax
  20096c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  200970:	89 fa                	mov    %edi,%edx
  200972:	0f af d7             	imul   %edi,%edx
  200975:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  200979:	29 d1                	sub    %edx,%ecx
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
    if(memoriza[x] > 0) return memoriza[x];
  20097b:	8b 3c 8d 80 20 20 00 	mov    0x202080(,%ecx,4),%edi
  200982:	85 ff                	test   %edi,%edi
  200984:	75 5a                	jne    2009e0 <dreamOf100HZ+0x5ac>
    const uint16_t *p = squares;
  200986:	ba 80 15 20 00       	mov    $0x201580,%edx
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
  20098b:	81 f9 ff 03 00 00    	cmp    $0x3ff,%ecx
  200991:	76 05                	jbe    200998 <dreamOf100HZ+0x564>
  200993:	ba c0 15 20 00       	mov    $0x2015c0,%edx
    if (p[ 16] <= x) p +=  16;
  200998:	0f b7 5a 20          	movzwl 0x20(%edx),%ebx
  20099c:	39 d9                	cmp    %ebx,%ecx
  20099e:	72 03                	jb     2009a3 <dreamOf100HZ+0x56f>
  2009a0:	83 c2 20             	add    $0x20,%edx
    if (p[  8] <= x) p +=   8;
  2009a3:	0f b7 5a 10          	movzwl 0x10(%edx),%ebx
  2009a7:	39 d9                	cmp    %ebx,%ecx
  2009a9:	72 03                	jb     2009ae <dreamOf100HZ+0x57a>
  2009ab:	83 c2 10             	add    $0x10,%edx
    if (p[  4] <= x) p +=   4;
  2009ae:	0f b7 5a 08          	movzwl 0x8(%edx),%ebx
  2009b2:	39 d9                	cmp    %ebx,%ecx
  2009b4:	72 03                	jb     2009b9 <dreamOf100HZ+0x585>
  2009b6:	83 c2 08             	add    $0x8,%edx
    if (p[  2] <= x) p +=   2;
  2009b9:	0f b7 5a 04          	movzwl 0x4(%edx),%ebx
  2009bd:	39 d9                	cmp    %ebx,%ecx
  2009bf:	72 03                	jb     2009c4 <dreamOf100HZ+0x590>
  2009c1:	83 c2 04             	add    $0x4,%edx
    if (p[  1] <= x) p +=   1;
  2009c4:	0f b7 5a 02          	movzwl 0x2(%edx),%ebx
  2009c8:	39 d9                	cmp    %ebx,%ecx
  2009ca:	72 03                	jb     2009cf <dreamOf100HZ+0x59b>
  2009cc:	83 c2 02             	add    $0x2,%edx
    memoriza[x] = p - squares;
  2009cf:	81 ea 80 15 20 00    	sub    $0x201580,%edx
  2009d5:	d1 fa                	sar    %edx
  2009d7:	89 d7                	mov    %edx,%edi
  2009d9:	89 14 8d 80 20 20 00 	mov    %edx,0x202080(,%ecx,4)

static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
  2009e0:	83 c7 01             	add    $0x1,%edi
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
  2009e3:	89 fe                	mov    %edi,%esi
  2009e5:	f7 de                	neg    %esi
  2009e7:	39 f7                	cmp    %esi,%edi
  2009e9:	7c 19                	jl     200a04 <dreamOf100HZ+0x5d0>
  2009eb:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  2009ef:	03 4c 24 10          	add    0x10(%esp),%ecx
  2009f3:	8d 1c 2e             	lea    (%esi,%ebp,1),%ebx
  2009f6:	ba 03 00 00 00       	mov    $0x3,%edx
  2009fb:	cd 80                	int    $0x80
  2009fd:	83 c6 01             	add    $0x1,%esi
  200a00:	39 f7                	cmp    %esi,%edi
  200a02:	7d ef                	jge    2009f3 <dreamOf100HZ+0x5bf>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
  200a04:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
  200a09:	8b 54 24 08          	mov    0x8(%esp),%edx
  200a0d:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  200a11:	0f 8d 55 ff ff ff    	jge    20096c <dreamOf100HZ+0x538>
		drawNumber(score, 0, 180, 1, 7);
  200a17:	8b 0d 70 2e 20 00    	mov    0x202e70,%ecx
}

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
    char temp[11];
    int di=0;
    if(num == 0){
  200a1d:	85 c9                	test   %ecx,%ecx
  200a1f:	74 13                	je     200a34 <dreamOf100HZ+0x600>
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
  200a21:	bb 00 00 00 00       	mov    $0x0,%ebx
            temp[di] = '0'+(num%10);
  200a26:	be 67 66 66 66       	mov    $0x66666667,%esi
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
  200a2b:	85 c9                	test   %ecx,%ecx
  200a2d:	7f 17                	jg     200a46 <dreamOf100HZ+0x612>
  200a2f:	e9 f1 00 00 00       	jmp    200b25 <dreamOf100HZ+0x6f1>

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
    char temp[11];
    int di=0;
    if(num == 0){
        temp[0] = '0';
  200a34:	c6 44 24 25 30       	movb   $0x30,0x25(%esp)
        di = 0;
  200a39:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  200a40:	00 
  200a41:	e9 8d 00 00 00       	jmp    200ad3 <dreamOf100HZ+0x69f>

    }else{    
        while(num>=1){
            temp[di] = '0'+(num%10);
  200a46:	89 c8                	mov    %ecx,%eax
  200a48:	f7 ee                	imul   %esi
  200a4a:	c1 fa 02             	sar    $0x2,%edx
  200a4d:	89 c8                	mov    %ecx,%eax
  200a4f:	c1 f8 1f             	sar    $0x1f,%eax
  200a52:	29 c2                	sub    %eax,%edx
  200a54:	8d 04 92             	lea    (%edx,%edx,4),%eax
  200a57:	01 c0                	add    %eax,%eax
  200a59:	29 c1                	sub    %eax,%ecx
  200a5b:	89 c8                	mov    %ecx,%eax
  200a5d:	83 c0 30             	add    $0x30,%eax
  200a60:	88 44 1c 25          	mov    %al,0x25(%esp,%ebx,1)
            num/=10;
  200a64:	89 d1                	mov    %edx,%ecx
            di++;
  200a66:	83 c3 01             	add    $0x1,%ebx
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
  200a69:	85 d2                	test   %edx,%edx
  200a6b:	7f d9                	jg     200a46 <dreamOf100HZ+0x612>
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
  200a6d:	83 eb 01             	sub    $0x1,%ebx
  200a70:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  200a74:	79 5d                	jns    200ad3 <dreamOf100HZ+0x69f>
  200a76:	e9 aa 00 00 00       	jmp    200b25 <dreamOf100HZ+0x6f1>
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
  200a7b:	80 3c 0f 00          	cmpb   $0x0,(%edi,%ecx,1)
  200a7f:	74 08                	je     200a89 <dreamOf100HZ+0x655>
}
static inline void drawPoint(int x, int y, uint8_t color){
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
  200a81:	01 35 e4 29 20 00    	add    %esi,0x2029e4
  200a87:	cd 80                	int    $0x80
  200a89:	83 c6 1d             	add    $0x1d,%esi
  200a8c:	83 c1 01             	add    $0x1,%ecx
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
  200a8f:	39 cd                	cmp    %ecx,%ebp
  200a91:	75 e8                	jne    200a7b <dreamOf100HZ+0x647>
  200a93:	83 44 24 08 39       	addl   $0x39,0x8(%esp)
  200a98:	8b 54 24 08          	mov    0x8(%esp),%edx
  200a9c:	83 c7 05             	add    $0x5,%edi
  200a9f:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
  200aa4:	39 54 24 10          	cmp    %edx,0x10(%esp)
  200aa8:	74 13                	je     200abd <dreamOf100HZ+0x689>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
  200aaa:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  200aae:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  200ab2:	8b 74 24 08          	mov    0x8(%esp),%esi
  200ab6:	ba 07 00 00 00       	mov    $0x7,%edx
  200abb:	eb be                	jmp    200a7b <dreamOf100HZ+0x647>
  200abd:	83 6c 24 1c 0b       	subl   $0xb,0x1c(%esp)
  200ac2:	81 44 24 10 3f 01 00 	addl   $0x13f,0x10(%esp)
  200ac9:	00 
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
  200aca:	83 6c 24 14 01       	subl   $0x1,0x14(%esp)
  200acf:	79 17                	jns    200ae8 <dreamOf100HZ+0x6b4>
  200ad1:	eb 52                	jmp    200b25 <dreamOf100HZ+0x6f1>
static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
    char temp[11];
    int di=0;
    if(num == 0){
        temp[0] = '0';
        di = 0;
  200ad3:	c7 44 24 10 fe 29 00 	movl   $0x29fe,0x10(%esp)
  200ada:	00 
  200adb:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  200ae2:	00 
  200ae3:	b8 4f 04 00 00       	mov    $0x44f,%eax
  200ae8:	8b 54 24 10          	mov    0x10(%esp),%edx
  200aec:	81 ea 8f 01 00 00    	sub    $0x18f,%edx
  200af2:	89 54 24 08          	mov    %edx,0x8(%esp)
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
  200af6:	8b 54 24 14          	mov    0x14(%esp),%edx
  200afa:	0f be 54 14 25       	movsbl 0x25(%esp,%edx,1),%edx
  200aff:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  200b03:	89 f7                	mov    %esi,%edi
  200b05:	03 3c 95 80 1f 20 00 	add    0x201f80(,%edx,4),%edi
  200b0c:	c7 44 24 0c b4 00 00 	movl   $0xb4,0xc(%esp)
  200b13:	00 
  200b14:	89 f2                	mov    %esi,%edx
  200b16:	f7 da                	neg    %edx
  200b18:	89 54 24 18          	mov    %edx,0x18(%esp)
  200b1c:	bd 05 00 00 00       	mov    $0x5,%ebp
  200b21:	29 f5                	sub    %esi,%ebp
  200b23:	eb 85                	jmp    200aaa <dreamOf100HZ+0x676>
        i++;
    }
}

static inline void drawStage(){
	if(lhash == hash)return;
  200b25:	8b 15 e4 29 20 00    	mov    0x2029e4,%edx
  200b2b:	3b 15 e0 29 20 00    	cmp    0x2029e0,%edx
  200b31:	74 0d                	je     200b40 <dreamOf100HZ+0x70c>

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
  200b33:	b8 4e 04 00 00       	mov    $0x44e,%eax
  200b38:	cd 80                	int    $0x80
	//clear_vram();
	sys_flush_vcache();
	lhash = hash;
  200b3a:	89 15 e0 29 20 00    	mov    %edx,0x2029e0
		drawStage();
		
		
		createMonster();
  200b40:	e8 fa f7 ff ff       	call   20033f <createMonster>
		while(hitMonster());
  200b45:	e8 27 f5 ff ff       	call   200071 <hitMonster>
  200b4a:	85 c0                	test   %eax,%eax
  200b4c:	75 f7                	jne    200b45 <dreamOf100HZ+0x711>
		//}
	}
	if(gameStatus == GAME_END){
  200b4e:	83 3d 6c 2e 20 00 03 	cmpl   $0x3,0x202e6c
  200b55:	75 55                	jne    200bac <dreamOf100HZ+0x778>
		printf("You're dead\n");
  200b57:	83 ec 0c             	sub    $0xc,%esp
  200b5a:	68 92 0e 20 00       	push   $0x200e92
  200b5f:	e8 ee 02 00 00       	call   200e52 <printf>
		printf("Score: %d\n", score);
  200b64:	83 c4 08             	add    $0x8,%esp
  200b67:	ff 35 70 2e 20 00    	pushl  0x202e70
  200b6d:	68 9f 0e 20 00       	push   $0x200e9f
  200b72:	e8 db 02 00 00       	call   200e52 <printf>
    return p - squares;
}


static inline void clearStage(){
	hash = 0;
  200b77:	c7 05 e4 29 20 00 00 	movl   $0x0,0x2029e4
  200b7e:	00 00 00 
static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
  200b81:	b8 4c 04 00 00       	mov    $0x44c,%eax
  200b86:	cd 80                	int    $0x80
        i++;
    }
}

static inline void drawStage(){
	if(lhash == hash)return;
  200b88:	83 c4 10             	add    $0x10,%esp
  200b8b:	83 3d e0 29 20 00 00 	cmpl   $0x0,0x2029e0
  200b92:	74 0e                	je     200ba2 <dreamOf100HZ+0x76e>

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
  200b94:	b0 4e                	mov    $0x4e,%al
  200b96:	cd 80                	int    $0x80
	//clear_vram();
	sys_flush_vcache();
	lhash = hash;
  200b98:	c7 05 e0 29 20 00 00 	movl   $0x0,0x2029e0
  200b9f:	00 00 00 
		clearStage();
		drawStage();
		gameStatus = GAME_START;
  200ba2:	c7 05 6c 2e 20 00 00 	movl   $0x0,0x202e6c
  200ba9:	00 00 00 
	}
  200bac:	83 c4 3c             	add    $0x3c,%esp
  200baf:	5b                   	pop    %ebx
  200bb0:	5e                   	pop    %esi
  200bb1:	5f                   	pop    %edi
  200bb2:	5d                   	pop    %ebp
  200bb3:	c3                   	ret    

00200bb4 <main>:
	sys_add_timer(ptr);
};



int main(){
  200bb4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  200bb8:	83 e4 f0             	and    $0xfffffff0,%esp
  200bbb:	ff 71 fc             	pushl  -0x4(%ecx)
  200bbe:	55                   	push   %ebp
  200bbf:	89 e5                	mov    %esp,%ebp
  200bc1:	53                   	push   %ebx
  200bc2:	51                   	push   %ecx
  200bc3:	83 ec 10             	sub    $0x10,%esp
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_get_tick(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_TICK)); //SYSCALL HERE!
  200bc6:	bb 15 05 00 00       	mov    $0x515,%ebx
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_get_tick(){
	uint32_t r_eax = 0;
  200bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	asm volatile("int $0x80": : "a"(SYS_GET_TICK)); //SYSCALL HERE!
  200bd2:	89 d8                	mov    %ebx,%eax
  200bd4:	cd 80                	int    $0x80
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
  200bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
  200bd9:	c7 05 20 20 20 00 00 	movl   $0x0,0x202020
  200be0:	00 00 00 
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
  200be3:	83 3d 74 2e 20 00 00 	cmpl   $0x0,0x202e74
  200bea:	79 df                	jns    200bcb <main+0x17>
  200bec:	b9 00 00 00 00       	mov    $0x0,%ecx
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
  200bf1:	83 ec 0c             	sub    $0xc,%esp
  200bf4:	51                   	push   %ecx
  200bf5:	e8 3a f8 ff ff       	call   200434 <dreamOf100HZ>
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime++;
  200bfa:	a1 74 2e 20 00       	mov    0x202e74,%eax
  200bff:	8d 50 01             	lea    0x1(%eax),%edx
  200c02:	89 15 74 2e 20 00    	mov    %edx,0x202e74
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
  200c08:	8b 0d 20 20 20 00    	mov    0x202020,%ecx
  200c0e:	83 c4 10             	add    $0x10,%esp
  200c11:	39 d1                	cmp    %edx,%ecx
  200c13:	7f dc                	jg     200bf1 <main+0x3d>
  200c15:	eb b4                	jmp    200bcb <main+0x17>

00200c17 <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
  200c17:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
  200c18:	b8 e8 03 00 00       	mov    $0x3e8,%eax
  200c1d:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
  200c22:	cd 80                	int    $0x80
}
  200c24:	5b                   	pop    %ebx
  200c25:	c3                   	ret    

00200c26 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
  200c26:	56                   	push   %esi
  200c27:	53                   	push   %ebx
  200c28:	83 ec 04             	sub    $0x4,%esp
  200c2b:	8b 74 24 10          	mov    0x10(%esp),%esi
  200c2f:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	const char *str = ctl;
	for(;cur!='\0';str++){
  200c33:	0f b6 03             	movzbl (%ebx),%eax
  200c36:	84 c0                	test   %al,%al
  200c38:	74 16                	je     200c50 <printp+0x2a>
		printer(cur);
  200c3a:	83 ec 0c             	sub    $0xc,%esp
  200c3d:	0f be c0             	movsbl %al,%eax
  200c40:	50                   	push   %eax
  200c41:	ff d6                	call   *%esi
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
  200c43:	83 c3 01             	add    $0x1,%ebx
  200c46:	0f b6 03             	movzbl (%ebx),%eax
  200c49:	83 c4 10             	add    $0x10,%esp
  200c4c:	84 c0                	test   %al,%al
  200c4e:	75 ea                	jne    200c3a <printp+0x14>
		printer(cur);
	}
}
  200c50:	83 c4 04             	add    $0x4,%esp
  200c53:	5b                   	pop    %ebx
  200c54:	5e                   	pop    %esi
  200c55:	c3                   	ret    

00200c56 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
  200c56:	55                   	push   %ebp
  200c57:	57                   	push   %edi
  200c58:	56                   	push   %esi
  200c59:	53                   	push   %ebx
  200c5a:	83 ec 7c             	sub    $0x7c,%esp
  200c5d:	8b b4 24 90 00 00 00 	mov    0x90(%esp),%esi
  200c64:	8b ac 24 94 00 00 00 	mov    0x94(%esp),%ebp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  200c6b:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
  200c6f:	84 c0                	test   %al,%al
  200c71:	0f 84 d3 01 00 00    	je     200e4a <vfprintf+0x1f4>
  200c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  200c7c:	8d 7c 24 0b          	lea    0xb(%esp),%edi
		if(cur == '%'){
  200c80:	3c 25                	cmp    $0x25,%al
  200c82:	0f 84 ae 01 00 00    	je     200e36 <vfprintf+0x1e0>
			type = READ;
			continue;
		}
		if(type == READ){
  200c88:	83 fb 01             	cmp    $0x1,%ebx
  200c8b:	0f 85 93 01 00 00    	jne    200e24 <vfprintf+0x1ce>
			if(cur == 's'){
  200c91:	3c 73                	cmp    $0x73,%al
  200c93:	75 2e                	jne    200cc3 <vfprintf+0x6d>
				char* p= XGET(pointer, char*);
  200c95:	8b 84 24 98 00 00 00 	mov    0x98(%esp),%eax
  200c9c:	8b 18                	mov    (%eax),%ebx
				for(; *p != '\0';p++){
  200c9e:	0f b6 03             	movzbl (%ebx),%eax
  200ca1:	84 c0                	test   %al,%al
  200ca3:	74 16                	je     200cbb <vfprintf+0x65>
					printer(*p);
  200ca5:	83 ec 0c             	sub    $0xc,%esp
  200ca8:	0f be c0             	movsbl %al,%eax
  200cab:	50                   	push   %eax
  200cac:	ff d6                	call   *%esi
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  200cae:	83 c3 01             	add    $0x1,%ebx
  200cb1:	0f b6 03             	movzbl (%ebx),%eax
  200cb4:	83 c4 10             	add    $0x10,%esp
  200cb7:	84 c0                	test   %al,%al
  200cb9:	75 ea                	jne    200ca5 <vfprintf+0x4f>
					printer(*p);
				}
				XNEXT(pointer);
  200cbb:	83 84 24 98 00 00 00 	addl   $0x4,0x98(%esp)
  200cc2:	04 
				i++;
			}
			if(cur == 'x'){
  200cc3:	80 7d 00 78          	cmpb   $0x78,0x0(%ebp)
  200cc7:	75 72                	jne    200d3b <vfprintf+0xe5>
				uint32_t x = XGET(pointer, int);
  200cc9:	8b 84 24 98 00 00 00 	mov    0x98(%esp),%eax
  200cd0:	8b 10                	mov    (%eax),%edx
  200cd2:	b9 00 00 00 00       	mov    $0x0,%ecx
				if(x==0){
  200cd7:	85 d2                	test   %edx,%edx
  200cd9:	75 1c                	jne    200cf7 <vfprintf+0xa1>
					printer('0');
  200cdb:	83 ec 0c             	sub    $0xc,%esp
  200cde:	6a 30                	push   $0x30
  200ce0:	ff d6                	call   *%esi
					XNEXT(pointer);
  200ce2:	83 84 24 a8 00 00 00 	addl   $0x4,0xa8(%esp)
  200ce9:	04 
					type = NONE;
					continue;
  200cea:	83 c4 10             	add    $0x10,%esp
			if(cur == 'x'){
				uint32_t x = XGET(pointer, int);
				if(x==0){
					printer('0');
					XNEXT(pointer);
					type = NONE;
  200ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  200cf2:	e9 44 01 00 00       	jmp    200e3b <vfprintf+0x1e5>
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
					int d=(x%16);
  200cf7:	89 d0                	mov    %edx,%eax
  200cf9:	83 e0 0f             	and    $0xf,%eax
					if(d>=10){
  200cfc:	83 f8 09             	cmp    $0x9,%eax
  200cff:	7e 03                	jle    200d04 <vfprintf+0xae>
						d+='a'-'0'-10;
  200d01:	83 c0 27             	add    $0x27,%eax
					}
					digits[di] = '0'+d;
  200d04:	83 c0 30             	add    $0x30,%eax
  200d07:	88 44 0c 0c          	mov    %al,0xc(%esp,%ecx,1)
					x>>=4;
  200d0b:	c1 ea 04             	shr    $0x4,%edx
					di ++;
  200d0e:	83 c1 01             	add    $0x1,%ecx
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  200d11:	85 d2                	test   %edx,%edx
  200d13:	75 e2                	jne    200cf7 <vfprintf+0xa1>
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  200d15:	89 c8                	mov    %ecx,%eax
  200d17:	83 e8 01             	sub    $0x1,%eax
  200d1a:	78 17                	js     200d33 <vfprintf+0xdd>
  200d1c:	8d 5c 0c 0b          	lea    0xb(%esp,%ecx,1),%ebx
					printer(digits[di]);
  200d20:	83 ec 0c             	sub    $0xc,%esp
  200d23:	0f be 03             	movsbl (%ebx),%eax
  200d26:	50                   	push   %eax
  200d27:	ff d6                	call   *%esi
  200d29:	83 eb 01             	sub    $0x1,%ebx
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  200d2c:	83 c4 10             	add    $0x10,%esp
  200d2f:	39 fb                	cmp    %edi,%ebx
  200d31:	75 ed                	jne    200d20 <vfprintf+0xca>
					printer(digits[di]);
				}
				XNEXT(pointer);
  200d33:	83 84 24 98 00 00 00 	addl   $0x4,0x98(%esp)
  200d3a:	04 
				i++;
			}
			if(cur == 'd'){
  200d3b:	80 7d 00 64          	cmpb   $0x64,0x0(%ebp)
  200d3f:	0f 85 b7 00 00 00    	jne    200dfc <vfprintf+0x1a6>
				int x = XGET(pointer, int);
  200d45:	8b 84 24 98 00 00 00 	mov    0x98(%esp),%eax
  200d4c:	8b 18                	mov    (%eax),%ebx
				if(x==-2147483648){
  200d4e:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
  200d54:	75 1e                	jne    200d74 <vfprintf+0x11e>
					printp(printer, "-2147483648");
  200d56:	83 ec 08             	sub    $0x8,%esp
  200d59:	68 80 17 20 00       	push   $0x201780
  200d5e:	56                   	push   %esi
  200d5f:	e8 c2 fe ff ff       	call   200c26 <printp>
					XNEXT(pointer);
  200d64:	83 84 24 a8 00 00 00 	addl   $0x4,0xa8(%esp)
  200d6b:	04 
					type = NONE;
					continue;
  200d6c:	83 c4 10             	add    $0x10,%esp
  200d6f:	e9 81 00 00 00       	jmp    200df5 <vfprintf+0x19f>
				}
				if(x==0){
  200d74:	85 db                	test   %ebx,%ebx
  200d76:	75 14                	jne    200d8c <vfprintf+0x136>
					printer('0');
  200d78:	83 ec 0c             	sub    $0xc,%esp
  200d7b:	6a 30                	push   $0x30
  200d7d:	ff d6                	call   *%esi
					XNEXT(pointer);
  200d7f:	83 84 24 a8 00 00 00 	addl   $0x4,0xa8(%esp)
  200d86:	04 
					type = NONE;
					continue;
  200d87:	83 c4 10             	add    $0x10,%esp
  200d8a:	eb 69                	jmp    200df5 <vfprintf+0x19f>
				}
				if(x<0){
  200d8c:	85 db                	test   %ebx,%ebx
  200d8e:	79 0c                	jns    200d9c <vfprintf+0x146>
					printer('-');
  200d90:	83 ec 0c             	sub    $0xc,%esp
  200d93:	6a 2d                	push   $0x2d
  200d95:	ff d6                	call   *%esi
					x=-x;
  200d97:	f7 db                	neg    %ebx
  200d99:	83 c4 10             	add    $0x10,%esp
				}
				char digits[100];
				int di=0;
				while(x>=1){
  200d9c:	85 db                	test   %ebx,%ebx
  200d9e:	7e 4b                	jle    200deb <vfprintf+0x195>
  200da0:	b9 00 00 00 00       	mov    $0x0,%ecx
					digits[di] = '0'+(x%10);
  200da5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  200daa:	f7 eb                	imul   %ebx
  200dac:	c1 fa 02             	sar    $0x2,%edx
  200daf:	89 d8                	mov    %ebx,%eax
  200db1:	c1 f8 1f             	sar    $0x1f,%eax
  200db4:	29 c2                	sub    %eax,%edx
  200db6:	8d 04 92             	lea    (%edx,%edx,4),%eax
  200db9:	01 c0                	add    %eax,%eax
  200dbb:	29 c3                	sub    %eax,%ebx
  200dbd:	83 c3 30             	add    $0x30,%ebx
  200dc0:	88 5c 0c 0c          	mov    %bl,0xc(%esp,%ecx,1)
					x/=10;
  200dc4:	89 d3                	mov    %edx,%ebx
					di++;
  200dc6:	83 c1 01             	add    $0x1,%ecx
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  200dc9:	85 d2                	test   %edx,%edx
  200dcb:	7f d8                	jg     200da5 <vfprintf+0x14f>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  200dcd:	89 c8                	mov    %ecx,%eax
  200dcf:	83 e8 01             	sub    $0x1,%eax
  200dd2:	78 17                	js     200deb <vfprintf+0x195>
  200dd4:	8d 5c 0c 0b          	lea    0xb(%esp,%ecx,1),%ebx
					printer(digits[di]);
  200dd8:	83 ec 0c             	sub    $0xc,%esp
  200ddb:	0f be 03             	movsbl (%ebx),%eax
  200dde:	50                   	push   %eax
  200ddf:	ff d6                	call   *%esi
  200de1:	83 eb 01             	sub    $0x1,%ebx
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  200de4:	83 c4 10             	add    $0x10,%esp
  200de7:	39 fb                	cmp    %edi,%ebx
  200de9:	75 ed                	jne    200dd8 <vfprintf+0x182>
					printer(digits[di]);
				}
				XNEXT(pointer);
  200deb:	83 84 24 98 00 00 00 	addl   $0x4,0x98(%esp)
  200df2:	04 
  200df3:	eb 07                	jmp    200dfc <vfprintf+0x1a6>
				int x = XGET(pointer, int);
				if(x==-2147483648){
					printp(printer, "-2147483648");
					XNEXT(pointer);
					type = NONE;
					continue;
  200df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  200dfa:	eb 3f                	jmp    200e3b <vfprintf+0x1e5>
				//printer(*pointer);
				printer(XGET(pointer, char));
				XNEXT(pointer);
				i++;
			}
			type = NONE;
  200dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
					printer(digits[di]);
				}
				XNEXT(pointer);
				i++;
			}
			if(cur == 'c'){
  200e01:	80 7d 00 63          	cmpb   $0x63,0x0(%ebp)
  200e05:	75 34                	jne    200e3b <vfprintf+0x1e5>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
  200e07:	83 ec 0c             	sub    $0xc,%esp
  200e0a:	8b 84 24 a4 00 00 00 	mov    0xa4(%esp),%eax
  200e11:	0f be 00             	movsbl (%eax),%eax
  200e14:	50                   	push   %eax
  200e15:	ff d6                	call   *%esi
				XNEXT(pointer);
  200e17:	83 84 24 a8 00 00 00 	addl   $0x4,0xa8(%esp)
  200e1e:	04 
  200e1f:	83 c4 10             	add    $0x10,%esp
  200e22:	eb 17                	jmp    200e3b <vfprintf+0x1e5>
				i++;
			}
			type = NONE;
			continue;
		}
		if(type == NONE){
  200e24:	85 db                	test   %ebx,%ebx
  200e26:	75 13                	jne    200e3b <vfprintf+0x1e5>
			printer(cur);
  200e28:	83 ec 0c             	sub    $0xc,%esp
  200e2b:	0f be c0             	movsbl %al,%eax
  200e2e:	50                   	push   %eax
  200e2f:	ff d6                	call   *%esi
  200e31:	83 c4 10             	add    $0x10,%esp
  200e34:	eb 05                	jmp    200e3b <vfprintf+0x1e5>
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
		if(cur == '%'){
			type = READ;
  200e36:	bb 01 00 00 00       	mov    $0x1,%ebx
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  200e3b:	83 c5 01             	add    $0x1,%ebp
  200e3e:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
  200e42:	84 c0                	test   %al,%al
  200e44:	0f 85 36 fe ff ff    	jne    200c80 <vfprintf+0x2a>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
  200e4a:	83 c4 7c             	add    $0x7c,%esp
  200e4d:	5b                   	pop    %ebx
  200e4e:	5e                   	pop    %esi
  200e4f:	5f                   	pop    %edi
  200e50:	5d                   	pop    %ebp
  200e51:	c3                   	ret    

00200e52 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
  200e52:	83 ec 10             	sub    $0x10,%esp
	void **args = (void **)&ctl + 1;
	vfprintf(sys_printch, ctl, args);
  200e55:	8d 44 24 18          	lea    0x18(%esp),%eax
  200e59:	50                   	push   %eax
  200e5a:	ff 74 24 18          	pushl  0x18(%esp)
  200e5e:	68 17 0c 20 00       	push   $0x200c17
  200e63:	e8 ee fd ff ff       	call   200c56 <vfprintf>
}
  200e68:	83 c4 1c             	add    $0x1c,%esp
  200e6b:	c3                   	ret    
