#to   compile source codes in map/bin
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
include  ../../adm/Mkinclude
DIRLIB = ../../lib/
OBJS  = calc_rivnxl calc_rivseq calc_rivcen calc_rivara calc_rivnum calc_damgov calc_damalc prog_crptyp prog_crpint
############################################################
#
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
############################################################
#
############################################################
TARGET1    = calc_rivnxl
COMPONENT1 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}igetnxx.o     ${DIRLIB}igetnxy.o     \
             ${DIRLIB}conv_r1tor2.o \
             ${DIRLIB}igeti0l.o     ${DIRLIB}read_i1l2xy.o \
	     ${DIRLIB}read_asciiu.o \
             ${DIRLIB}rgetlon.o     ${DIRLIB}rgetlat.o \
	     ${DIRLIB}rgetlen.o
TARGET2    = calc_rivseq
COMPONENT2 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}igetnxx.o     ${DIRLIB}igetnxy.o     \
             ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o \
             ${DIRLIB}igeti0l.o     ${DIRLIB}read_i1l2xy.o \
	     ${DIRLIB}read_asciiu.o
#TARGET3    = calc_crpcal
#COMPONENT3 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
#	     ${DIRLIB}sort_decord.o
TARGET4    = calc_rivcen
COMPONENT4 = ${DIRLIB}read_binary.o ${DIRLIB}conv_r1toi2.o \
	     ${DIRLIB}rgetlat.o     ${DIRLIB}rgetlon.o \
	     ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o
TARGET5    = calc_rivara
COMPONENT5 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET6    = calc_damgrd
COMPONENT6 = ${DIRLIB}wrte_binary.o ${DIRLIB}read_asciiu.o \
	     ${DIRLIB}igeti0x.o     ${DIRLIB}igeti0y.o \
	     ${DIRLIB}igeti0l.o     ${DIRLIB}read_i1l2xy.o
TARGET7    = calc_damalc
COMPONENT7 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}cgetfnt.o     ${DIRLIB}cgetfnl.o
TARGET8    = calc_damgov
COMPONENT8 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}cgetfnl.o
TARGET9    = calc_rivnum
COMPONENT9 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
	     ${DIRLIB}rgetlon.o     ${DIRLIB}rgetlat.o \
	     ${DIRLIB}rgetara.o     ${DIRLIB}sort_decord.o \
             ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o
TARGET10    = calc_rivcol
COMPONENT10 =${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}conv_r1tor2.o ${DIRLIB}igeti0l.o \
             ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o
TARGET11    = prog_crptyp
COMPONENT11 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}sort_decord.o
TARGET12    = prog_crpint
COMPONENT12 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
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
$(TARGET11) : $(TARGET11).o $(COMPONENT11)
	$(FC) -o $@ $@.o $(COMPONENT11)
$(TARGET12) : $(TARGET12).o $(COMPONENT12)
	$(FC) -o $@ $@.o $(COMPONENT12)
############################################################
# commands
############################################################
all:    ${OBJS}
clean: 
	rm -f *.o *~ temp*


