#to   compile source codes in lnd/pre
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
include  ../../adm/Mkinclude
DIRLIB = ../../lib/
OBJS   = prog_pipnet
############################################################
#
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
############################################################
#
############################################################
TARGET1    = prog_pipnet
COMPONENT1 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET2    = prog_rivnum_CAMA
COMPONENT2 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o ${DIRLIB}sort_decord.o
TARGET3    = prog_urbcat_CAMA
COMPONENT3 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET4    = prog_gwr_fp
COMPONENT4 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
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
$(TARGET8) : $(TARGET8).o $(COMPONENT8)
	$(FC) -o $@ $@.o $(COMPONENT8)
$(TARGET9) : $(TARGET9).o $(COMPONENT9)
	$(FC) -o $@ $@.o $(COMPONENT9)
$(TARGET10) : $(TARGET10).o $(COMPONENT10)
	$(FC) -o $@ $@.o $(COMPONENT10)
############################################################
# commands
############################################################
all:    ${OBJS}
clean: 
	rm -f *.o *~ temp*


