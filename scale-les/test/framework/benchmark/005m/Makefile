################################################################################
#
# Makefile for each test program
#
################################################################################

PWD         = $(shell pwd)
TOPDIR      = $(abspath ../../../../..)
TESTDIR     = ../../..
SYSDEP_DIR  = $(abspath ..)

# user-defined source files
CODE_DIR    = .
ORG_SRCS    =

# parameters for run
INITCONF    = init.conf
RUNCONF     = run.conf
TPROC       = 6

# required data (parameters,distributed files)
DATDIR      = ../../../data
DATPARAM    = rad/PARAG.29,rad/PARAPC.29,rad/VARDATA.RM29,rad/rad_o3_profs.txt
DATDISTS    =



# build, makedir, run, jobshell, allclean, clean is inside of common Makefile
include $(TESTDIR)/Makefile.common
