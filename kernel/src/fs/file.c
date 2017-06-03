#include "common.h"
#include <inc/types.h>
#include <inc/disk.h>
struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[BLOCK_SIZE];

void readBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
		readsect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}

void saveBitmap(){
	int count;
	for(count = 0; count < SC_BITMAP; count++){
		writesect(bitmap.mask+(count<<9), LOC_BITMAP()+(count<<9));
	}
}
void readDir(int offset){
	readsect(dir.entries, LOC_DIR(offset));
}
void saveDir(int offset){
	writesect(dir.entries, LOC_DIR(offset));
}
void readINode(int offset){
	readsect(inode.data_block_offsets, LOC_INODE(offset));
}
void saveINode(int offset){
	writesect(inode.data_block_offsets, LOC_INODE(offset));
}
void readData(int offset){
	readsect(buffer, LOC_DATA(offset));
}
void saveData(int offset){
	writesect(buffer, LOC_DATA(offset));
}
int INodeAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
		int sec = LOC_INODE(i);
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
}
int dataAlloc(){
	readBitmap();
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
		int sec = LOC_DATA(i);
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			saveBitmap();
			return i;
		}
	}
	return -1;
}

FILE_STREAM fs[NR_FILE_STREAM];

int fs_open_kr(char* filename){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
			//printk("%d %d", dir_offset, entry_offset);
			if(!strcmp(dir.entries[entry_offset].filename, filename))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;
	OUT_OF_LOOP:
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
			fs[i].used = 1;
			fs[i].file_size = dir.entries[entry_offset].file_size;
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
			//memset(fs[i].buffer, 0, BLOCK_SIZE>>2);
			//readINode(fs[i].inode_offset);
			//memcpy(fs[i].inode.data_block_offsets, inode.data_block_offsets, BLOCK_SIZE>>2);
			//printk("%s\n", fs[i].filename);
			return i;
		}
	}
	return -1;
	FAILURE:
	return -1;
}
void fs_read_base_kr(int fd, void* buf, int32_t len){
	FILE_STREAM *f = &fs[fd];
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
	uint32_t offset = 0;
	uint32_t D, R;
	D = f->offset >> 9;
	R = f->offset % BLOCK_SIZE;
	if(R + len > BLOCK_SIZE){
		readData(inode.data_block_offsets[D]);
		memcpy2(buf, buffer+R, BLOCK_SIZE-R);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
			D = f->offset >> 9;
			//printk("YYY:%d\n", D);
			readData(inode.data_block_offsets[D]);
			memcpy2(buf+offset, buffer, BLOCK_SIZE);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
		readData(inode.data_block_offsets[D]);
		memcpy2(buf+offset, buffer, len);
		f->offset += len;
	}else{
		readData(inode.data_block_offsets[D]);
		memcpy2(buf, buffer+R, len);
		f->offset += len;
	}

	/*while(len > BLOCK_SIZE){
		readINode(f->inode_offset);
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
int32_t fs_read_kr(int fd, void* buf, int32_t len){
	FILE_STREAM *f = &fs[fd];
	if(f->offset+len >= f->file_size){
		len = f->file_size-f->offset;
	}
	fs_read_base_kr(fd, buf, len);
	return len;
	
}
void fs_write_base_kr(int fd, void* buf, int32_t len){
	FILE_STREAM *f = &fs[fd];
	//uint32_t file_size = f->file_size;
	readINode(f->inode_offset);
	uint32_t offset = 0;
	uint32_t D, R;
	D = f->offset >> 9;
	R = f->offset % BLOCK_SIZE;
	if(R + len > BLOCK_SIZE){
		readData(inode.data_block_offsets[D]);
		memcpy2(buffer+R, buf, BLOCK_SIZE-R);
		saveData(inode.data_block_offsets[D]);
		f->offset += BLOCK_SIZE-R;
		offset += BLOCK_SIZE-R;
		len -= BLOCK_SIZE-R;
		//printk("??\n")
		while(len >= BLOCK_SIZE){
			D = f->offset >> 9;
			memcpy2(buffer, buf+offset, BLOCK_SIZE);
			saveData(inode.data_block_offsets[D]);
			len -= BLOCK_SIZE;
			f->offset += BLOCK_SIZE;
			offset += BLOCK_SIZE;
		}
		D = f->offset >> 9;
		readData(inode.data_block_offsets[D]);
		memcpy2(buffer, buf+offset, len);
		saveData(inode.data_block_offsets[D]);
		f->offset += len;
	}else{
		readData(inode.data_block_offsets[D]);
		memcpy2(buffer+R, buf, len);
		saveData(inode.data_block_offsets[D]);
		f->offset += len;
	}

	/*while(len > BLOCK_SIZE){
		readINode(f->inode_offset);
		D = f->offset >> 9;
		R = f->offset % 512;
		len -= BLOCK_SIZE;
		f->offset += BLOCK_SIZE;
	}*/
}
int32_t fs_write_kr(int fd, void* buf, int32_t len){
	FILE_STREAM *f = &fs[fd];
	int32_t D1, D2;
	readINode(f->inode_offset);
	D1 = f->offset >> 9;
	D2 = (f->offset + len) >> 9;
	D1 += 1;
	while(D1<=D2){
		inode.data_block_offsets[D1] = dataAlloc();
		D1 ++;
	}
	saveINode(f->inode_offset);
	if(f->offset + len> f->file_size)
		f->file_size = f->offset + len;
	fs_write_base_kr(fd, buf, len);
	return len;
	
}
void fs_lseek_kr(int fd, int32_t index){
	FILE_STREAM *f = &fs[fd];
	f->offset = index;
}
uint32_t fs_size_kr(int fd){
	FILE_STREAM *f = &fs[fd];
	return f->file_size;
}
int fs_close_kr(int fd){
	FILE_STREAM *f = &fs[fd];
	if(f->used){
		f->used = 0;
		return 0;
	}else
		return 1;
}
void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
	char magic[40];
	int len = fs_read_kr(fd, magic, 40);
	magic[len] = '\0';
	printk("%s\n", magic);
	
	//}
	/*for(i=0; i<NR_ENTRIES; i++){
		printk("%x\n", dir.entries[i].file_size);
		printk("%x\n", dir.entries[i].inode_offset);
		printk("%s\n", dir.entries[i].filename);
	}*/
}