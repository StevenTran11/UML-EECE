CC=/usr/bin/gcc
CFLAGS=-I. -pthread

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: main test

main: main.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test: test.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)