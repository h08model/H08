#to   make fortran codes in crp/bin
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
OBJS    = main calc_crpyld.o main_ai calc_crpyld_ai.o
############################################################
# Suffix rules
############################################################
.f.o:
	$(FC) -c $(FCFLAGS) $<
############################################################
# Target settings
############################################################
TARGET1    = main
COMPONENT1 = calc_crpyld.o \
             $(DIRLIB)read_binary.o   $(DIRLIB)wrte_binary.o \
             $(DIRLIB)read_result.o   $(DIRLIB)wrte_bints2.o \
             $(DIRLIB)cgetfnt.o       $(DIRLIB)igetday.o \
             $(DIRLIB)igetdoy.o       $(DIRLIB)igetymd.o
TARGET2    = main_ai
COMPONENT2 = calc_crpyld_ai.o \
             $(DIRLIB)read_binary.o   $(DIRLIB)wrte_binary.o \
             $(DIRLIB)read_result.o   $(DIRLIB)wrte_bints2.o \
             $(DIRLIB)cgetfnt.o       $(DIRLIB)igetday.o \
             $(DIRLIB)igetdoy.o       $(DIRLIB)igetymd.o
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
