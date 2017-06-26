#include "common.h"
#include <inc/types.h>
#include <inc/disk.h>
#include "process.h"
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
			//printk("FN: %s\n", dir.entries[entry_offset].filename);
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
			//printk("$%d %d$\n", fs[i].file_size, fs[i].inode_offset);
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
			fs[i].dir_offset = dir_offset;
			fs[i].entry_offset = entry_offset;
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
	if(len == 0)
		return -1;
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
	if(f->file_size == 0){
		readINode(f->inode_offset);
		inode.data_block_offsets[0] = dataAlloc();
		saveINode(f->inode_offset);
		f->file_size = len>512?512:len;
		//printk("legal high %d\n", f->file_size);
	}
	
	if(f->offset + len > f->file_size){
		readINode(f->inode_offset);
		D1 = f->offset >> 9;
		D2 = (f->offset + len) >> 9;
		D1 += 1;
		while(D1<=D2){
			inode.data_block_offsets[D1] = dataAlloc();
			D1 ++;
		}
		saveINode(f->inode_offset);
		f->file_size = f->offset + len;
	};
	readDir(f->dir_offset);
	dir.entries[f->entry_offset].file_size = f->file_size;
	saveDir(f->dir_offset);
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
void some(){

}
int fs_create_kr(char* name){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
			if(dir.entries[entry_offset].inode_offset == -1)
				goto OUT_OF_LOOP;
		}
		dir_offset ++;
	}
	goto FAILURE;
	
	//FILE_STREAM *f;
	int i=0;

	OUT_OF_LOOP:
	some();
	//printk("##%d\n", entry_offset);
	int index_inode = INodeAlloc();
	//printk("##%d\n", index_inode);
	dir.entries[entry_offset].inode_offset = index_inode;
	strcpy(dir.entries[entry_offset].filename, name);
	//printk("##%s\n", name);
	//printk("##%s\n", dir.entries[entry_offset].filename);
	dir.entries[entry_offset].file_size = 0;
	
	saveDir(dir_offset);

	readINode(index_inode);
	memset2(inode.data_block_offsets, 0xFF, sizeof(inode.data_block_offsets));
	saveINode(index_inode);
	for(i=0; i<NR_FILE_STREAM; i++){
		if(fs[i].used == 0){
			fs[i].used = 1;
			fs[i].file_size = dir.entries[entry_offset].file_size;
			strcpy(fs[i].filename, dir.entries[entry_offset].filename);
			fs[i].inode_offset = dir.entries[entry_offset].inode_offset;
			//printk("%d\n", dir.entries[entry_offset].inode_offset);
			fs[i].offset = 0;
			fs[i].dir_offset = dir_offset;
			fs[i].entry_offset = entry_offset;
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

int fs_open_md(char *pathname, int flags){
	int fd = fs_open_kr(pathname);
	if(fd == -1 && flags >= 1 ){
		fd = fs_create_kr(pathname);
	};
	if(flags == 2){
		fs[fd].file_size = 0;
	}
	//printk("step 1\n");
	return fd;
};
int fs_read_md(int fd, void *buf, int len){
	return fs_read_kr(fd, buf, len);
};
int fs_write_md(int fd, void *buf, int len){
	return fs_write_kr(fd, buf, len);
};
int fs_lseek_md(int fd, int offset, int whence){
	FILE_STREAM *f = &fs[fd];
	int32_t index = 0;
	if(whence == 0){
		index = offset;
	}else if(whence == 1){
		index = f->offset + offset;
	}else if(whence == 2){
		index = f->file_size + offset;
	}
	fs_lseek_kr(fd, index);
	return index;
};
int fs_close_md(int fd){
	return fs_close_kr(fd);
};

int fs_open_port(char *pathname, int flags){
	int fd = fs_open_md(pathname, flags);
	if(fd == -1)
		return -1;
	int i = 0;
	for(i = 0; i<FCBMAX; i++){
		if(current->fcb[i].fd_kr == -1)
			break;
	}
	current->fcb[i].fd_kr = fd;
	return i;
};
int fs_read_port(int fd, void *buf, int len){
	if(fd == -1)
		return -1;
	return fs_read_md(current->fcb[fd].fd_kr, buf, len);
};
int fs_write_port(int fd, void *buf, int len){
	if(fd == -1)
		return -1;
	return fs_write_md(current->fcb[fd].fd_kr, buf, len);
};
int fs_lseek_port(int fd, int offset, int whence){
	if(fd == -1)
		return -1;
	return fs_lseek_md(current->fcb[fd].fd_kr, offset, whence);
};
int fs_close_port(int fd){
	if(fd == -1)
		return -1;
	int ret = fs_close_md(current->fcb[fd].fd_kr);
	current->fcb[fd].fd_kr = -1;
	return ret;
};

void fs_ls_kr(uint32_t mask){
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);
		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
			if(dir.entries[entry_offset].inode_offset != -1){
				struct dirent *entry = &dir.entries[entry_offset];
				if((mask & 0x02) == 0 && entry->filename[0] == '.')continue;
				if((mask & 0x01) == 0){
					printk("%s\n", entry->filename);
				}
				else{
					//printk("%d %d\n", mask, mask&0x04);
					if((mask & 0x04) != 0){
						//printk("miaomiaomiao");
						int size = entry->file_size;
						if(size < 1024){
							//printk("b!");
							printk("%d\t%s\n", size, entry->filename);
							continue;
						}
						size /= 1024;
						if(size < 1024){
							//printk("k!");
							printk("%dK\t%s\n", size, entry->filename);
							continue;
						}
						size /= 1024;
						if(size < 1024){
							//printk("m!");
							printk("%dM\t%s\n", size, entry->filename);
							continue;
						}
					}else{
						printk("%d\t%s\n", entry->file_size, entry->filename);
					}
				}
			}
		}
		dir_offset ++;
	}
}

void init_fs(){
	//readDir(0);
	int i=0;
	for(i=0; i< NR_FILE_STREAM; i++){
		fs[i].used = 0;
	}
	int fd = fs_open_kr("test.txt");
	char magic[80];
	
	fs_read_kr(fd, magic, 80);
	fs_close_kr(fd);
	printk("%s\n", magic);
}