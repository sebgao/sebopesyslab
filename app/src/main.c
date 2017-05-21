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
	for(; i<2; i++){
		sleep(1);
		printf("TASK#%d, %d!\n", getpid(), i);
	}
	sys_sem_post(sem);
	exit();
}
semaphore sem;
void test_thread_sem(){
	sys_sem_wait(&sem);
	int i=0;
	for(; i<2; i++){
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(&sem);
	exit();
}
int main(){
	sys_sem_init(&sem, 3);
	int i=0;
	for (i = 0; i < 15; ++i)
	{
		int pid = thread(test_thread_sem, 0xeebfd000-i*0x1000);
		printf("%d created!\n", pid);
	}
	for(i=3; i<18; i++){
		sys_join(i);
	}
	//sys_join(3);
	sys_sem_close(&sem);
	//sleep(40);
	printf("All taskes are done!\n");
	exit();
	while(1);
	//test_process_sem();
}