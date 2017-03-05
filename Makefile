mbr.o: mbr.S
	gcc -m32 -o mbr.o -c mbr.S
mbr: mbr.o
	ld -m elf_i386 -e start -Ttext=0x7C00 -o mbr mbr.o
	objcopy --strip-all --only-section=.text --output-target=binary mbr mbr
	ruby mkmbr.rb mbr
run: mbr
	qemu-system-i386 mbr