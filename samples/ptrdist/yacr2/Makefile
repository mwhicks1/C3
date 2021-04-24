PROJ_SRC_DIR = .

OBJS = assign.o hcg.o maze.o vcg.o channel.o main.o option.o
C3_OBJS = $(addprefix conv/,$(OBJS))
PROG = yacr2

RUN_OPTIONS += $(PROJ_SRC_DIR)/input2.in
OUTPUT = OUT

LEVEL = ../../..
CHKCTOOLS = ~/checkedc/checkedc-clang/clang/tools/3c

CFLAGS = -I.. -DTODD

ifdef C3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): conv/assign.h conv/hcg.h conv/option.h conv/vcg.h conv/channel.h conv/maze.h conv/types.h

conv/%.c: %.c
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) "$(CFLAGS)" > $$P/$@)

conv/%.h: %.h
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) "$(CFLAGS)" > $$P/$@)

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
