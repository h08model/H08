#to   make fortran codes in crp/pre
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib
OBJS    = prog_FAOSTAT   prog_FAOSTAT_read \
          prog_TRADESTAT prog_TRADESTAT_mean prog_yldgrz
############################################################
# Suffix rules
############################################################
.f.o:
	$(FC) -c $(FCFLAGS) $<
.sh:
	cp $@.sh $@
	chmod 755 $@
############################################################
# Target settings
############################################################
TARGET1    = prog_FAOSTAT
COMPONENT1 = ${DIRLIB}/cgetfnt.o ${DIRLIB}/cgetfnl.o 
TARGET2    = prog_yldgrz
COMPONENT2 = ${DIRLIB}/read_binary.o   ${DIRLIB}/wrte_binary.o
############################################################
# Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) -o $@ $@.o $(COMPONENT2)
all : $(OBJS)
clean : 
	rm -f *.o *~ temp*
