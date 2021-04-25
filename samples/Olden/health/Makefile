PROG     = health
SOURCES = args.c health.c list.c poisson.c
HDRS = health.h

CFLAGS = -DTORONTO
LDFLAGS  = -lm
C3 = ../../../_build/default/src/main.exe

FP_TOLERANCE = 0.001

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 11 90 1
else ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 8 15 1
else
RUN_OPTIONS = 9 20 1
OUTPUT = health.reference_output
ifeq ($(ARCH),XCore)
XCORE_TARGET_NEEDS_MEMORY := 64
endif
endif

include ../../Makefile.common
