CC=gcc
CFLAGS=-I.
DEPS =
OBJ =
LIBS = -lm

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: main test1 test2 test3 test4 test5

clean:
	rm -f pj1 test1 test2 test3 test4 test5

main: main.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test1: test1.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test2: test2.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test3: test3.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test4: test4.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

test5: test5.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)