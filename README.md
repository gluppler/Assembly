## Assembly Portfolio
My journey into learning Arm64 Assembly and x86 Assembly.

### How to compile and run
nasm -f elf64 -o example.o example.asm

### Without C Libraries/Functions
ld -o example example.o

### With C Libraries/Functions
gcc -o program program.o -no-pie -lc

### Run
./example
