#include "lib/common.h"
#include "lib/syscall.h"
#include "lib/serial.h"
#include "lib/video.h"
#include "lib/keyboard.h"
/*
#define SYS_INIT_CACHE	1100
#define SYS_CLEAR_VRAM	1101
#define SYS_FLUSH_VCACHE	1102
#define SYS_SET_PIXEL	1103
#define SYS_DRAW_TEXT1	1104
#define SYS_DRAW_RECT	1105
#define SYS_DRAW_NUMBER	1106
*/

void do_syscall(struct TrapFrame *tf) {
	switch(tf->eax) {
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
			//printk("1\n");
		break;
		case SYS_INIT_CACHE:
			initVCache();
		break;
		case SYS_CLEAR_VRAM:
			clearVRAM();
		break;
		case SYS_FLUSH_VCACHE:
			clearVRAM();
			flushVCache();
		break;
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
		break;
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
		break;
		/* The `add_irq_handle' system call is artificial. We use it to
		 * let user program register its interrupt handlers. But this is
		 * very dangerous in a real operating system. Therefore such a
		 * system call never exists in GNU/Linux.
		 */

	}
}