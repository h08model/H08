#to   compile source codes in riv/bin
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
OBJS    =  prog_RH prog_WFD prog_WFDEI ptwR2bin_f ptwRpR2bin_f prog_VPD
############################################################
#       Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FFLAGS} $<
.F.o:
	${FC} -c ${FFLAGS} -I${INC} $<
############################################################
# Online mode
############################################################
TARGET1    =   prog_GSWP2DDC
COMPONENT1 =   ${DIRLIB}read_binary.o ${DIRLIB}cgetfnt.o \
               ${DIRLIB}igetday.o     ${DIRLIB}wrte_binary.o
TARGET2    =   prog_GSWP2B1
COMPONENT2 =   ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
               ${DIRLIB}cgetfnt.o     ${DIRLIB}wrte_binary.o
TARGET3    =   prog_GSWP2B1_Albedo
COMPONENT3 =   ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
               ${DIRLIB}cgetfnt.o     ${DIRLIB}wrte_binary.o
TARGET4    =   prog_RH
COMPONENT4 =   ${DIRLIB}read_result.o ${DIRLIB}wrte_bints2.o \
               ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o     ${DIRLIB}conv_qatorh.o
TARGET5    =   prog_NCC
COMPONENT5 =   ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
               ${DIRLIB}cgetfnt.o     ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o
TARGET6    =   prog_K10
COMPONENT6 =   ${DIRLIB}wrte_binary.o ${DIRLIB}cgetfnt.o \
               ${DIRLIB}igetday.o     ${DIRLIB}igetymd.o \
               ${DIRLIB}wrte_bytswp.o \
               ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
               ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o
TARGET7    =   prog_WFDFUT
COMPONENT7 =   ${DIRLIB}wrte_bints2.o ${DIRLIB}read_binary.o \
               ${DIRLIB}read_asciiu.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o
TARGET8    =   prog_WFD_Albedo
COMPONENT8 =   ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}read_asciiu.o ${DIRLIB}read_i1l2xy.o \
               ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o
TARGET9    =   prog_WFD
COMPONENT9 =   ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o
TARGET10    =  prog_WFDEI
COMPONENT10 =  ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o
TARGET11    =  prog_ISIMIP
COMPONENT11 =  ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o
TARGET12    =  prog_LUH
COMPONENT12 =  ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o     ${DIRLIB}cgetfnt.o
TARGET13    =  prog_GSWP3
COMPONENT13 =  ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
               ${DIRLIB}cgetfnt.o     ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetymd.o     ${DIRLIB}igetday.o
TARGET14    =  ptwR2bin_f
COMPONENT14 =
TARGET15    =  ptwRpR2bin_f
COMPONENT15 =
TARGET16    =  prog_VPD
COMPONENT16 =  ${DIRLIB}read_result.o ${DIRLIB}wrte_bints2.o \
               ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
               ${DIRLIB}igetday.o     ${DIRLIB}conv_tarhtovpd.o
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
$(TARGET13) : $(TARGET13).o $(COMPONENT13)
	$(FC) -o $@ $@.o $(COMPONENT13)
$(TARGET14) : $(TARGET14).o $(COMPONENT14)
	$(FC) -o $@ $@.o $(COMPONENT14)
$(TARGET15) : $(TARGET15).o $(COMPONENT15)
	$(FC) -o $@ $@.o $(COMPONENT15)
$(TARGET16) : $(TARGET16).o $(COMPONENT16)
	$(FC) -o $@ $@.o $(COMPONENT16)
############################################################
# Commands
############################################################
all     : $(OBJS)
clean   : 
	rm -f *.o *~ temp*

