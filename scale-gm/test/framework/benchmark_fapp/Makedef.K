#
# ------ FOR K computer -----
#

##### for computation

FFLAGS_FAST  = -Kfast,parallel,ocl,preex,array_private,noalias=s,mfunc=1 \
               -Qi -Qt -X03 -Ncompdisp -Koptmsg=1 -Cpp                   \
               -x-                                                       \
               -Ksimd                                                    \
               -Kauto,threadsafe

FFLAGS_AGGRESSIVE = $(FFLAGS_FAST)  \
                   -Kautoobjstack   \
                   -Ktemparraystack \
                   -Kinstance=8     \
                   -Kswp_strong

# note: Kauto,threadsafe,autoobjstack,temparraystack depends on the stacksize.
# If you find the segmentation fault error, please check.

FFLAGS_DEBUG = -O0                                                       \
               -Qi -Qt -X03 -v03s -v03d -v03o -Ncompdisp -Koptmsg=1 -Cpp \
               -Ec -Eg -Ha -He -Hf -Ho -Hs -Hu -Hx -Ncheck_global        \
               -DDEBUG

# Performance monitor
# disable
#PERF_MONIT = -Ntl_notrt -U_FIPP_ -U_FAPP_ -U_FINEPA_
# fipp
#PERF_MONIT = -Ntl_trt -D_FIPP_ -U_FAPP_ -U_FINEPA_
# fapp
PERF_MONIT = -Ntl_trt -U_FIPP_ -D_FAPP_ -U_FINEPA_
# fine PA
#PERF_MONIT = -Ntl_trt -U_FIPP_ -U_FAPP_ -D_FINEPA_

# RDMA
# disable
RDMA = -U_USE_RDMA
# enable
#RDMA = -D_USE_RDMA

# Single precision
#FFLAGS += -DSINGLE

FC     = mpifrtpx

FFLAGS_DYN ?= $(FFLAGS) -Knoprefetch,loop_nofission,loop_nofusion,nounroll,parallel_strong -Ksimd=2
#FFLAGS_DYN ?= $(FFLAGS)

MODDIROPT ?= -M

CC     = mpifccpx
CFLAGS_FAST  = -Kfast,parallel,ocl,preex,array_private,region_extension,restp=all -Ksimd
CFLAGS_DEBUG = -O0

CFLAGS = $(CFLAGS_FAST) $(PERF_MONIT) $(RDMA)
#CFLAGS = $(CFLAGS_DEBUG) $(PERF_MONIT) $(RDMA)

LD      = $(FC)
LDFLAGS = $(FFLAGS)

###### NetCDF library
NETCDF_INCLUDE ?= -I/opt/aics/netcdf/k-serial-noszip/include
NETCDF_LIBS    ?= -L/opt/aics/netcdf/k-serial-noszip/lib-static -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz -lm

###### Lapack
LAPACK_LIBS    ?= -SSL2

##### for frontend
INSTALL = install
AR      = ar
ARFLAGS = r
RANLIB  = ranlib
JOBSUB  = pjsub
