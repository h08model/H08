#to   compile source codes in met/pst
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
include  ../../adm/Mkinclude
DIRLIB = ../../lib/
OBJS   = prog_koppen
############################################################
#
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
############################################################
#
############################################################
TARGET1    = prog_koppen
COMPONENT1 = ${DIRLIB}wrte_binary.o ${DIRLIB}read_binary.o \
             ${DIRLIB}igetday.o     ${DIRLIB}cgetfnt.o
############################################################
# make
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
$(TARGET6) : $(TARGET6).o $(COMPONENT6)
	$(FC) -o $@ $@.o $(COMPONENT6)
$(TARGET7) : $(TARGET7).o $(COMPONENT7)
	$(FC) -o $@ $@.o $(COMPONENT7)
############################################################
# commands
############################################################
all:    ${OBJS}
clean: 
	rm -f *.o *~ temp*


