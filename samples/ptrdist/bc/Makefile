PROJ_SRC_DIR = .

PROG = bc
OBJS = scan.o util.o main.o number.o storage.o load.o execute.o bc.o global.o
STDIN_FILENAME = $(PROJ_SRC_DIR)/primes.b

CFLAGS = -I..

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS)

clean:
	$(RM) $(OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w primes.OUT FOO
	$(RM) FOO
