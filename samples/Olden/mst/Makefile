PROG       = mst
SOURCES = args.c makegraph.c hash.c main.c
HDRS = hash.h mst.h

CFLAGS   = -DTORONTO
LDFLAGS    =
C3 = ../../../_build/default/src/main.exe -c

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 10000
else
RUN_OPTIONS = 1000
endif
OUTPUT = mst.reference_output

include ../../Makefile.common

