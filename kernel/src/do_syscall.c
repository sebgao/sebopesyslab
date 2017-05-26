#include "common.h"
#include "serial.h"
#include "video.h"
#include "keyboard.h"
#include "process.h"
#include "semaphore.h"
#include "lib/syscall.h"


extern uint32_t tick();


void do_syscall(struct TrapFrame *tf) {
	//disable_interrupt();
	//printk("%d\n", tf->cs&0x3);
	switch(tf->eax) {
		case SYS_SEM_INIT:
			sem_init_kr((Semaphore*)tf->ebx, tf->ecx);
		break;
		case SYS_SEM_OPEN:
			tf->eax = (uint32_t)sem_open_kr(tf->ebx, tf->ecx);
		break;
		case SYS_SEM_POST:
			sem_post_kr((Semaphore*)tf->ebx);
		break;
		case SYS_SEM_WAIT:
			sem_wait_kr((Semaphore*)tf->ebx);
		break;
		case SYS_SEM_TRYWAIT:
			tf->eax = sem_trywait_kr((Semaphore*)tf->ebx);
		break;
		case SYS_SEM_CLOSE:
			sem_close_kr((Semaphore*)tf->ebx);
		break;
		case SYS_SEM_GET:
			tf->eax = sem_get_kr((Semaphore*)tf->ebx);
		break;
		case SYS_THREAD:
			thread_current(tf->ebx, tf->ecx, tf->edx);
		break;
		case SYS_JOIN:
			join_current(tf->ebx);
		break;
		case SYS_PID:
			tf->eax = current->pid;
		break;
		case SYS_PPID:
			tf->eax = current->ppid;
		break;
		case SYS_SLEEP:
			//printk("SLEEPING");
			current->ts = SLEEPING;
			current->timeslice = tf->ebx*200;
		break;
		case SYS_HANDOUT:
			current->ts = STOP;
		break;
		case SYS_EXIT:
			exit_current();
		break;
		case SYS_FORK:
			fork_current();
		break;
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
		case SYS_GET_TICK:
			tf->eax = tick();
			//printk("%d\n", tf->eax);
		break;
		/* The `add_irq_handle' system call is artificial. We use it to
		 * let user program register its interrupt handlers. But this is
		 * very dangerous in a real operating system. Therefore such a
		 * system call never exists in GNU/Linux.
		 */

	}
	//enable_interrupt();
}