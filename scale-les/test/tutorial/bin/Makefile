################################################################################
#
# Makefile for each test program
#
################################################################################

PWD         = $(shell pwd)
TOPDIR      = $(abspath ../../../..)
TESTDIR     = ../..

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
TPROC       = 36

# required data (parameters,distributed files)
DATDIR      = ../../data
DATPARAM    = rad/PARAG.29,rad/PARAPC.29,rad/VARDATA.RM29,rad/cira.nc,rad/MIPAS/day.atm,rad/MIPAS/equ.atm,rad/MIPAS/sum.atm,rad/MIPAS/win.atm,land/param.bucket.conf
DATDISTS    = $(PREPDIR)/pp/topo_d01,$(PREPDIR)/pp/landuse_d01,$(PREPDIR)/init/boundary_d01,$(PREPDIR)/init/init_d01_00010368000.000



# build, makedir, run, jobshell, allclean, clean is inside of common Makefile
include $(TESTDIR)/Makefile.common
