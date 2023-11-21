#to   compile source code in dam/pre
#by   2010/08/23, hanasaki, NIES: H08ver1.0
############################################################
# Macro
############################################################
include  ../../adm/Mkinclude
DIRLIB = ../../lib/
DIRDAM = ../../dam/bin/
OBJS   = prog_damdem
############################################################
# Suffix rule
############################################################
.f.o:
	$(FC) -c $(FCFLAGS) $<
############################################################
# Dependency
############################################################
TARGET1    = prog_damdem
COMPONENT1 = ${DIRDAM}calc_damdem.f  \
             ${DIRLIB}read_binary.o  ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}cgetfnl.o      ${DIRLIB}cgetfnt.o
############################################################
# Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT1)
############################################################
# Macro
############################################################
all:    $(OBJS)
clean: 
	rm -f *.o *~ temp*

