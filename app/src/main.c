#include "common.h"
#include "lib/syscall.h"
#include "rnd.h"
/*
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
}*/
#define N 2
sem_t mutex;
sem_t empty;
sem_t full;
int index;
int buffer[N];

void insert_item(int item){
	buffer[index] = item;
	index ++;
}
int remove_item(){
	index --;
	return buffer[index];
}

void producer(){
	int item;
	while(1){
		sleep(1+rand()%5);
		item = rand()%10;
		printf("PRODUCER: %d produced!\n", item);
		sem_wait(&empty);
		sem_wait(&mutex);

		insert_item(item);

		printf("PRODUCER: %d sent, now %d space left!\n", item, N-index);

		sem_post(&mutex);
		sem_post(&full);
	}
}

void consumer(){
	int item;
	int asleep;
	while(1){
		printf("CONSUMER: ready to receive!\n");
		while(!sem_trywait(&full));
		while(!sem_trywait(&mutex));

		item = remove_item();

		sem_post(&mutex);
		sem_post(&empty);

		asleep = 1+rand()%15;
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
		sleep(asleep); //consume

	}
}
int main(){

	/*
	sem_init(&mutex, 1);
	sem_init(&empty, N);
	sem_init(&full,	0);
	index = 0;
	thread_t prod, cons;
	prod = thread(producer, NULL);
	cons = thread(consumer, NULL);
	thread_join(prod);
	thread_join(cons);

	printf("You should not see this, since the producer and consumer are sisyphean\n");
	*/
	int fd = fs_open("singer.txt", FS_RWC);
	char buf[300];
	fs_read(fd, buf, 300);
	printf("APP#READ singer.txt: %s\n", buf);

	char buf2[300];
	fs_lseek(fd, 0, SEEK_SET);
	strcpy(buf2, "你本来是英雄，直到变的，更加恐惧");
	fs_write(fd, buf2, 300);
	printf("APP#WRITE singer.txt: %s\n", buf2);

	exit();
}