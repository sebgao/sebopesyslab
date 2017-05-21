#include "common.h"
#include "lib/syscall.h"

void test_process_sem(){
	fork();
	fork();
	fork();

	//现在有8个进程了
	
	semaphore* sem = sys_sem_open(0, 2);//打开内核区的0号信号量	

	//每次只允许运行2个

	sys_sem_wait(sem);
	int i=0;
	for(; i<3; i++){
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(sem);
	exit();
}
semaphore sem;
void test_thread_sem(){
	sys_sem_wait(&sem);
	int i=0;
	for(; i<3; i++){
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(&sem);
	exit();
}
int main(){
	sys_sem_init(&sem, 2);
	int i=0;
	for (i = 0; i < 8; ++i)
	{
		thread(test_thread_sem, 0xeebfd000-i*0x1000);
	}
	while(1);
	//test_process_sem();
}