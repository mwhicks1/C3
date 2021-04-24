PROJ_SRC_DIR = .
LEVEL = ../../..

OBJS = Fheap.o ft.o item.o Fsanity.o graph.o
C3_OBJS = $(addprefix conv/,$(OBJS))
PROG = ft

RUN_OPTIONS +=  1500 100000
OUTPUT = OUT

CHKCTOOLS = ~/checkedc/checkedc-clang/clang/tools/3c

CFLAGS = -I..

ifdef C3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

conv/Fheap.c conv/Fsanity.c: conv/Fstruct.h
conv/Fheap.c conv/Fsanity.c conv/ft.c: conv/Fheap.h
conv/ft.c conv/graph.c: conv/graph.h
conv/item.c: conv/item.h
conv/Fheap.h: conv/item.h
conv/item.h: conv/graph.h

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
