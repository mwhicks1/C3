LEVEL = ../../..

PROG       = em3d
OBJS = args.o em3d.o main.o make_graph.o util.o
C3_OBJS = $(addprefix conv/,$(OBJS))

CFLAGS   = -DTORONTO -I..
LDFLAGS    = 

ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 256 250 35
else ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 3072 3000 750
else
RUN_OPTIONS = 1024 1000 125
OUTPUT = em3d.reference_output
endif

CHKCTOOLS = ~/checkedc/checkedc-clang/clang/tools/3c

ifdef C3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) $(LDFLAGS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): $(addprefix conv/, em3d.h make_graph.h util.h)

conv/%.c: %.c
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) $(CFLAGS) > $$P/$@)

conv/%.h: %.h
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) $(CFLAGS) > $$P/$@)

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
