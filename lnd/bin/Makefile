#to     compile source code in lnd/bin
#on     2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
#	Macro (Basics)
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
DIRLND  = ../../lnd/bin/
DIRRIV  = ../../riv/bin/
DIRDAM  = ../../dam/bin/
DIRCPL  = ../../cpl/bin/
OBJS    = main main_new
############################################################
#	Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FCFLAGS} $<
.F.o:
	${FC} -c ${FCFLAGS} -I${INC} $<

# for parallel computing
#calc_leakyb.o: calc_leakyb.f
#	$(FC) -c ${FCFLAGS} -fopenmp ${INC} $< 
############################################################
#	Dependency
############################################################
TARGET1    = main
COMPONENT1 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
	     ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o
TARGET2    = main_new
COMPONENT2 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o
############################################################
#	Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) -o $@ $@.o $(COMPONENT1)
#	$(FC) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) -o $@ $@.o $(COMPONENT2)

all : $(OBJS)
clean :
	rm -f *.o *~ temp*

