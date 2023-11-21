#to     compile source code in cpl/pst
#on     2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
#       Macro (Basics)
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
DIRLND  = ../../lnd/bin/
DIRRIV  = ../../riv/bin/
DIRDAM  = ../../dam/bin/
DIRCPL  = ../../cpl/bin/
OBJS    = comm_watbal
############################################################
#       Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FCFLAGS} $<
.F.o:
	${FC} -c ${FCFLAGS} -I${INC} $<
.sh:
	cp $@.sh $@
	chmod 755 $@
############################################################
#       Dependency
############################################################
TARGET1    = 
COMPONENT1 = 
TARGET2    = 
COMPONENT2 = 
TARGET3    = 
COMPONENT3 = 
############################################################
#       Compilation
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
