################################################################################
#
# Makefile for each test program
#
################################################################################

PWD         = $(shell pwd)
TOPDIR      = $(abspath ../../../../..)
TESTDIR     = ../../..

# for build
index      = 500m40x800x2
precision  = real8
dynamics   = heve
tracer     = kessler
sfcflx     = const
turbulence = dummy
radiation  = mstrnx

# for run
INITCONF  = init.conf
RUNCONF   = run.conf
TPROC     = 6

# build, makedir, run, jobshell, allclean, clean is inside of common Makefile
include $(TESTDIR)/Makefile.common
