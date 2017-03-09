#define SECTSIZE    512

static inline void
waitdisk(void) {
    while((inb(0x1F7) & 0xC0) != 0x40);
}

static inline void
readsect(void *dst, int offset) {
    int i;
    waitdisk();
    outb(0x1F2, 1);
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);

    waitdisk();
    for (i = 0; i < SECTSIZE / 4; i ++) {
        ((int *)dst)[i] = inl(0x1F0);
    }
}

static inline void
readseg(unsigned char *pa, int count, int offset) {
    unsigned char *epa;
    epa = pa + count;
    pa -= offset % SECTSIZE;
    offset = (offset / SECTSIZE) + 1;
    for(; pa < epa; pa += SECTSIZE, offset ++)
        readsect(pa, offset);
}