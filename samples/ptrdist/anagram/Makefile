PROJ_SRC_DIR = .
PROG = anagram
OBJS = anagram.o
RUN_OPTIONS = $(PROJ_SRC_DIR)/words 2
STDIN_FILENAME = $(PROJ_SRC_DIR)/input.OUT

CFLAGS = -I..

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS)

clean:
	$(RM) $(OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
