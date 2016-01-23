#  Copyright 2016 Iceberg OS
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

#/=============================================================================
#/ ■ Makefile
#/-----------------------------------------------------------------------------
#/   GENERAL 
#/=============================================================================

CC=clang++ -m32
CCLD=ld -melf_i386
ARCH=i686

C_SOURCES = $(shell find . -name "*.cpp")
C_OBJECTS = $(patsubst %.cpp, %.o, $(C_SOURCES))
S_SOURCES = $(shell find . -name "*.asm")
S_OBJECTS = $(patsubst %.asm, %.o, $(S_SOURCES))

C_FLAGS = -c -Wall -m32 -ggdb -nostdinc -fno-builtin -fno-stack-protector -IDrivers/${ARCH} -O2
LD_FLAGS = -T scripts/kernel.ld -m elf_i386 -lgcc
ASM_FLAGS = -f elf32 -g -F stabs

all: mine.bin
run: all
	qemu-system-i386 -kernel mine.bin
debug: all
	qemu-system-i386 -kernel mine.bin -gdb tcp::1234 -S &
	sleep 1 # gdb要等qemu就绪
	cgdb -x gdbinit
clean:
	rm -f ${C_OBJECTS} ${S_OBJECTS} mine.bin
.PHONY: all run clean

.cpp.o: .c
	@echo 编译C++代码文件 $< ...
	$(CC) $(C_FLAGS) $< -o $@

${S_OBJECTS}: ${S_SOURCES}
	@echo 编译nasm汇编文件 $< ...
	nasm $(ASM_FLAGS) $<
	
mine.bin: ${C_OBJECTS} ${S_OBJECTS}
	${CCLD} -g -T scripts/linker.ld -o mine.bin -O2 -nostdlib $^

