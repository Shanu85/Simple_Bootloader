compile:
	nasm bootloader.asm -f bin -o bootloader.bin
run: compile
	qemu-system-x86_64 bootloader.bin
