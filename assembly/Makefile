# Makefile for compiling and running test.s with gcc

# Target to compile the assembly file
test: test.o
	gcc -z noexecstack -o test test.o

# Rule to assemble the assembly source file
test.o: test.s
	gcc -c -g -O0 test.s -o test.o

# Target to run the compiled program
run: test
	./test

# Clean up the generated files
clean:
	rm -f test.o test
