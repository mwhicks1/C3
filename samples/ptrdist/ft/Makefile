PROJ_SRC_DIR = .

OBJS = Fheap.o ft.o item.o Fsanity.o graph.o
C3_OBJS = $(addprefix conv/,$(OBJS))
PROG = ft

RUN_OPTIONS +=  1500 100000
OUTPUT = OUT

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

$(C3_OBJS): $(addprefix conv/,Fheap.h Fsanity.h Fstruct.h graph.h item.h)

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG)

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
