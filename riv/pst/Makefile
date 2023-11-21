#to   compile source code in riv/bin
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Macro
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
OBJS    = prog_envout prog_flddro
############################################################
# Suffix rule
############################################################
.f.o:
	$(FC) -c ${FFLAGS} $<
############################################################
# Dependency
############################################################
TARGET1    = prog_envout
COMPONENT1 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}igetday.o     ${DIRLIB}cgetfnt.o
TARGET2    = prog_flddro
COMPONENT2 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}igetday.o     ${DIRLIB}cgetfnt.o
TARGET3    = prog_JSHWR2011
COMPONENT3 = ${DIRLIB}read_ascii4.o ${DIRLIB}sort_decord.o \
             ${DIRLIB}igetday.o     
############################################################
# Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT2)
$(TARGET3) : $(TARGET3).o $(COMPONENT3)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT3)
############################################################
# Macro
############################################################
all     : $(OBJS)
clean   : 
	rm -f *.o *~ temp*

