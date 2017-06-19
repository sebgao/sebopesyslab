#include "file.h"
#include "string.h"
#define SECT_SIZE 512

struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[SECT_SIZE];
FILE *disk;
void readBitmap(){
	int count;
	fseek(disk, LOC_BITMAP(), 0);
	for(count = 0; count < SC_BITMAP; count++){
		fread((uint8_t*)bitmap.mask+(count<<9), 1, SECT_SIZE, disk);
	}
}

void saveBitmap(){
	int count;
	fseek(disk, LOC_BITMAP(), 0);
	for(count = 0; count < SC_BITMAP; count++){
		fwrite((uint8_t*)bitmap.mask+(count<<9), 1, SECT_SIZE, disk);
	}
}
void readDir(int offset){
	fseek(disk, LOC_DIR(offset), 0);
	fread((uint8_t*)dir.entries, 1, SECT_SIZE, disk);
}
void saveDir(int offset){
	fseek(disk, LOC_DIR(offset), 0);
	fwrite((uint8_t*)dir.entries, 1, SECT_SIZE, disk);
}
void readINode(int offset){
	fseek(disk, LOC_INODE(offset), 0);
	fread((uint8_t*)inode.data_block_offsets, 1, SECT_SIZE, disk);
}
void saveINode(int offset){
	fseek(disk, LOC_INODE(offset), 0);
	fwrite((uint8_t*)inode.data_block_offsets,  1, SECT_SIZE,disk);
}
void readData(int offset){
	fseek(disk, LOC_DATA(offset), 0);
	fread(buffer, 1, SECT_SIZE, disk);
}
void writeData(int offset){
	//printf("%d\n", LOC_DATA(offset));
	fseek(disk, LOC_DATA(offset), 0);
	fwrite(buffer, 1, SECT_SIZE, disk);
}
int INodeAlloc(){
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
		int sec = LOC_INODE(i)>>9;
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			return i;
		}
	}
	return -1;
}
int dataAlloc(){
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
		int sec = LOC_DATA(i)>>9;
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			return i;
		}
	}
	return -1;
}
int main(int argc, char* argv[]){
	if(argc <= 2){
		printf("argument expected\n");
		return 0;
	}
	//printf("%s\n", argv[1]);
	//printf("%s\n", argv[2]);
	char file[30];
	char name[30];

	strcpy(file, argv[1]);
	strcpy(name, argv[2]);

	FILE *fp = fopen(file, "r");
	fseek(fp, 0, SEEK_END);
	uint32_t filesize = ftell(fp);
	rewind(fp);
	printf("FILESIZE: %d\n", filesize);
	disk = fopen("disk.bin", "r+");
	
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
			if(!strcmp(dir.entries[entry_offset].filename, name))
				goto OUT_OF_LOOP;
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	OUT_OF_LOOP:

	//printf("%d %d\n", dir_offset, dir.entries[entry_offset].file_size);
	readBitmap();
	int index_inode = INodeAlloc();

	dir.entries[entry_offset].inode_offset = index_inode;
	strcpy(dir.entries[entry_offset].filename, name);
	dir.entries[entry_offset].file_size = filesize;
	
	readINode(index_inode);
	memset(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	int offset = 0;

	while(offset < filesize){
		int read = fread(buffer, 1, SECT_SIZE, fp);
		if(read != SECT_SIZE){
			memset(buffer+read, 0, SECT_SIZE-read);
		}
		//printf("%s", buffer);
		int index_data = dataAlloc();
		//printf("%d\n", index_data);
		writeData(index_data);
		if(offset/SECT_SIZE < NR_BLOCKS)
			inode.data_block_offsets[offset/SECT_SIZE] = index_data;
		offset += SECT_SIZE;
	}
	saveINode(index_inode);
	saveBitmap();
	//printf("%d\n", INodeAlloc());
	//printf("%d\n", dataAlloc());
	saveDir(dir_offset);
	fclose(disk);
	fclose(fp);
	printf("copy success\n");
	return 0;
}
