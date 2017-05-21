#include "common.h"
#include "lib/syscall.h"

int share = 0;

void fun(){
	while(1){
		sleep(1);
		share ++;
		int esp;
		printf("Hello this is thread#%d! %d! %x\n", getpid(), share, &esp);
	}
}

int main(){
	fork();
	fork();
	thread(fun, 0xeebfd000-0x1000);
	while(1){
		sleep(2);
		int esp;
		printf("Hello, this is APP#%d! %d! %x\n", getpid(), share, &esp);
		yield();
	}
}