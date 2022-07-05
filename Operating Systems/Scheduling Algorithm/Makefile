CC=/usr/bin/gcc
CFLAGS=-I.

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: main

main: main.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)