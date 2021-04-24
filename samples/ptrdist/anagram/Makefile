PROJ_SRC_DIR = .
PROG = anagram
OBJS = anagram.o
C3_OBJS = $(addprefix conv/,$(OBJS))
RUN_OPTIONS = $(PROJ_SRC_DIR)/words 2
STDIN_FILENAME = $(PROJ_SRC_DIR)/input.OUT
C3 = ../../../_build/default/src/main.exe

CFLAGS = -I..

ifdef DOC3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

conv/%.c: %.c
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
