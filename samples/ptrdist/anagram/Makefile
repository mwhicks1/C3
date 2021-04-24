PROJ_SRC_DIR = .

PROG = anagram
SOURCES = anagram.c
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG = anagram
C3_PROG = $(PROG)_c3

RUN_OPTIONS = $(PROJ_SRC_DIR)/words 2
STDIN_FILENAME = $(PROJ_SRC_DIR)/input.OUT

C3 = ../../../_build/default/src/main.exe
CFLAGS = -I..

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

.PRECIOUS: conv/%.c

conv/%.c: %.c
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(PROG) 

test:  $(PROG) $(C3_PROG)
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
