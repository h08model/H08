#to   compile source code in riv/pre
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Macro
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib
OBJS    = prog_clsest 
############################################################
# Suffix rule
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
############################################################
# Dependency
############################################################
TARGET1    = prog_clsest
COMPONENT1 = ${DIRLIB}/read_binary.o ${DIRLIB}/conv_r1tor2.o \
             ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
             ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
             ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET2    = prog_stnlst
COMPONENT2 = ${DIRLIB}/igetday.o
TARGET3    = prog_stnlow
COMPONENT3 = ${DIRLIB}/read_binary.o ${DIRLIB}/conv_r1tor2.o \
             ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
             ${DIRLIB}/igetnxx.o     ${DIRLIB}/igetnxy.o \
             ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
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

