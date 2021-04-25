LEVEL = ../../..

SOURCES = args.c em3d.c main.c make_graph.c util.c
C3_HDRS = $(addprefix conv/, em3d.h make_graph.h util.h)
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG       = em3d
C3_PROG = $(PROG)_c3

CFLAGS   = -DTORONTO -I..
LDFLAGS    = 
C3 = ../../../_build/default/src/main.exe

ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 256 250 35
else ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 3072 3000 750
else
RUN_OPTIONS = 1024 1000 125
OUTPUT = em3d.reference_output
endif

.PRECIOUS: conv/%.c

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): $(C3_HDRS)

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(C3_HDRS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
