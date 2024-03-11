#to   compile source code in riv/bin
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Macro
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
OBJS    = calc_outflw.o calc_spinup.o calc_humact.o main calc_humact_hyper.o \
		calc_outflw_ftcs.o calc_humact_ftcs.o main_ftcs
############################################################
# Suffix rule
############################################################
.f.o:
	$(FC) -c ${FFLAGS} $<
############################################################
# Dependency
############################################################
TARGET1    = main
COMPONENT1 = calc_outflw.o                   calc_spinup.o \
	     ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}read_result.o ${DIRLIB}wrte_bints2.o \
             ${DIRLIB}igetday.o
TARGET2    = main_ftcs
COMPONENT2 = calc_outflw_ftcs.o                   calc_spinup.o \
	     ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}read_result.o ${DIRLIB}wrte_bints2.o \
             ${DIRLIB}igetday.o
############################################################
# Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT2)
############################################################
# Macro
############################################################
all     : $(OBJS)
clean   : 
	rm -f *.o *~ temp*

