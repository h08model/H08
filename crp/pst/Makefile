#to   make fortran codes in crp/bin
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
OBJS    = prog_crpcal prog_vwcnew prog_sumevp prog_vwf
############################################################
# Suffix rules
############################################################
.f.o:
	$(FC) -c $(FCFLAGS) $<
############################################################
# Target settings
############################################################
TARGET1    = prog_crpcal
COMPONENT1 = $(DIRLIB)read_binary.o   $(DIRLIB)wrte_binary.o
TARGET2    = prog_vwcnew
COMPONENT2 = $(DIRLIB)read_binary.o   $(DIRLIB)read_ascii2.o
TARGET3    = prog_sumevp
COMPONENT3 = $(DIRLIB)read_binary.o   $(DIRLIB)wrte_binary.o \
             $(DIRLIB)read_result.o   $(DIRLIB)cgetfnt.o \
             $(DIRLIB)igetdoy.o       $(DIRLIB)igetday.o
TARGET4    = prog_vwf
COMPONENT4 = $(DIRLIB)read_ascii2.o
TARGET5    = prog_vwcnew_new
COMPONENT5 = $(DIRLIB)read_binary.o   $(DIRLIB)read_ascii2.o
############################################################
# Compilation
############################################################
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) -o $@ $@.o $(COMPONENT2)
$(TARGET3) : $(TARGET3).o $(COMPONENT3)
	$(FC) -o $@ $@.o $(COMPONENT3)
$(TARGET4) : $(TARGET4).o $(COMPONENT4)
	$(FC) -o $@ $@.o $(COMPONENT4)
$(TARGET5) : $(TARGET5).o $(COMPONENT5)
	$(FC) -o $@ $@.o $(COMPONENT5)
all : $(OBJS)
clean : 
	rm -f *.o *~ temp*
