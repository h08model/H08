#to     compile source code in lnd/pst
#on     2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
#	Macro (Basics)
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
DIRRIV  = ../../riv/bin/
DIRDAM  = ../../ope/bin/
DIRCPL  = ../../cpl/bin/
OBJS    = prog_cwd
############################################################
#	Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FCFLAGS} $<
.F.o:
	${FC} -c ${FCFLAGS} -I${INC} $<
############################################################
#	Dependency
############################################################
TARGET1    = prog_cwd
COMPONENT1 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o ${DIRLIB}igetday.o
############################################################
#	Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) -o $@ $@.o $(COMPONENT2)
$(TARGET3) : $(TARGET3).o $(COMPONENT3)
	$(FC) -o $@ $@.o $(COMPONENT3)
all : $(OBJS)
clean : 
	rm -f *.o *~ temp*

