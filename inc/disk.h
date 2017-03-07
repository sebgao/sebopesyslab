static inline void waitdisk(void)
{
    // wait for disk reaady
    while ((inb(0x1F7) & 0xC0) != 0x40)
        // do nothing;
}

static inline void readsect(void *dst, uint32_t offset)
{
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);     // count = 1
    outb(0x1F3, offset);    //address = offset | 0xe0000000
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE/4);
}