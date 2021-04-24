PROJ_SRC_DIR = .

SOURCES = KS-2.c KS-1.c
C3_HDRS = conv/KS.h
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG = ks
C3_PROG = $(PROG)_c3

RUN_OPTIONS += $(PROJ_SRC_DIR)/KL-4.in
OUTPUT = ks.reference_output

C3 = ../../../_build/default/src/main.exe
CFLAGS = -I..

.PRECIOUS: conv/%.c

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

$(C3_OBJS): $(C3_HDRS)

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): 

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(C3_HDRS) $(PROG)

test: $(PROG) $(C3_PROG)
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
