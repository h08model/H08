#to   make fortran codes in /dis/adm
#by   2010/03/31, hanasaki, NIES: H08ver1.0
######################################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib
OBJS    = main calc_resope.o calc_damdem.o calc_resope_hyper.o
############################################################
# Suffix rules
############################################################
.f.o:
	$(FC) -c $(FCFLAGS) $<
######################################################################
# Target settings
######################################################################
TARGET1    = main
COMPONENT1 = calc_resope.o \
             $(DIRLIB)/read_ascii4.o $(DIRLIB)/wrte_ascii4.o \
             $(DIRLIB)/len_trim.o \
             $(DIRLIB)/igetday.o
TARGET2    = calc_damdem
COMPONENT2 = ${DIRDAM}calc_damdem.f  \
             ${DIRLIB}read_binary.o  ${DIRLIB}wrte_binary.o \
             ${DIRLIB}cgetfnl.o      ${DIRLIB}cgetfnt.o
######################################################################
# Compilation
######################################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) -o $@ $@.o $(COMPONENT2)
all : $(OBJS)
clean :
	rm -f *.o *~ temp*
