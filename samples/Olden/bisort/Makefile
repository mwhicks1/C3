SOURCES = args.c bitonic.c
HDRS = node.h proc.h
PROG     = bisort

CFLAGS = -DTORONTO
LDFLAGS  = -lm
C3 = ../../../_build/default/src/main.exe -c

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 40000000
HASH_PROGRAM_OUTPUT = 1
else
RUN_OPTIONS = 700000
OUTPUT = bisort.reference_output
endif

include ../../Makefile.common
