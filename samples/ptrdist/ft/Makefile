PROJ_SRC_DIR = .

SOURCES = Fheap.c ft.c item.c Fsanity.c graph.c
C3_HDRS = $(addprefix conv/,Fheap.h Fsanity.h Fstruct.h graph.h item.h)
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG = ft
C3_PROG = $(PROG)_c3

RUN_OPTIONS +=  1500 100000
OUTPUT = OUT

.PRECIOUS: conv/%.c

C3 = ../../../_build/default/src/main.exe
CFLAGS = -I..

all: test

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

$(C3_OBJS): $(C3_HDRS)

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): 

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(C3_HDRS) $(PROG) 

test: $(PROG) $(C3_PROG)
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
