################################################################################
#
# Makefile for each test program
#
################################################################################

PWD         = $(shell pwd)
TOPDIR      = $(abspath ../../../../..)
TESTDIR     = ../../..

ifndef PREPDIR
PREPDIR     = ..
endif


# user-defined source files
CODE_DIR    = .
ORG_SRCS    =

# parameters for run
PPNAME      = NONE
INITNAME    = NONE
BINNAME     = scale-les
PPCONF      = NONE
INITCONF    = NONE
RUNCONF     = run.conf
TPROC       = 16

# required data (parameters,distributed files)
DATDIR      = "" 
DATPARAM    = ""
DATDISTS    = $(PREPDIR)/init/boundary,$(PREPDIR)/init/init_00000000000.000



# build, makedir, run, jobshell, allclean, clean is inside of common Makefile
include $(TESTDIR)/Makefile.common
