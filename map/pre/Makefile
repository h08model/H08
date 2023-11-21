#to   compile source codes in map/pre
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
include  ../../adm/Mkinclude
DIRLIB = ../../lib/
OBJS   = prog_grdara prog_damgrd prog_map_M08 prog_map_AQUASTAT prog_riv_WATCH prog_map_C05_nat prog_map_C05_pop prog_map_lcan prog_one2hlf prog_map_K14 prog_frcgw prog_map_cstlin prog_map_IGRAC prog_map_pop_KYUSYU prog_map_cities_KYUSYU prog_map_NIAES_KYUSYU prog_map_arafrc_KYUSYU prog_map_ind_KYUSYU prog_map_lcan2 prog_map_cities_code_KYUSYU prog_map_cities_B_KYUSYU prog_map_etopo
############################################################
#
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
############################################################
#
############################################################
TARGET1    = prog_map_lcan
COMPONENT1 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
              ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o \
              ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
              ${DIRLIB}rgetlon.o     ${DIRLIB}rgetlat.o \
              ${DIRLIB}rgetlen.o     ${DIRLIB}igeti0l.o
TARGET2    = prog_grdara
COMPONENT2 = ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
             ${DIRLIB}rgetlon.o     ${DIRLIB}rgetlat.o     \
             ${DIRLIB}rgetara.o     ${DIRLIB}conv_r2tor1.o \
             ${DIRLIB}wrte_binary.o
TARGET3    = prog_one2hlf
COMPONENT3 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
              ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o \
              ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o
TARGET4    = prog_map_K14
COMPONENT4 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o 
TARGET5    = prog_frcgw
COMPONENT5 = ${DIRLIB}read_ascii2.o ${DIRLIB}wrte_ascii2.o
TARGET6    = prog_damgrd
COMPONENT6 = ${DIRLIB}wrte_binary.o ${DIRLIB}read_asciiu.o \
             ${DIRLIB}igeti0x.o     ${DIRLIB}igeti0y.o \
             ${DIRLIB}igeti0l.o     ${DIRLIB}read_i1l2xy.o \
             ${DIRLIB}read_binary.o
TARGET7    = prog_map_C05_pop
COMPONENT7 = ${DIRLIB}wrte_binary.o ${DIRLIB}conv_r2tor1.o \
             ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
             ${DIRLIB}calc_uscale.o ${DIRLIB}sort_decord.o
TARGET8    = prog_map_C05_nat
COMPONENT8 = ${DIRLIB}wrte_binary.o ${DIRLIB}conv_r2tor1.o \
             ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
             ${DIRLIB}sort_decord.o ${DIRLIB}calc_uscale.o 
TARGET9    = prog_map_M08
COMPONENT9 = ${DIRLIB}wrte_binary.o ${DIRLIB}conv_r2tor1.o \
             ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
             ${DIRLIB}sort_decord.o ${DIRLIB}calc_uscale.o \
             ${DIRLIB}read_binary.o ${DIRLIB}conv_r1tor2.o
TARGET10    = prog_riv_WATCH
COMPONENT10 = ${DIRLIB}wrte_binary.o
TARGET11    = prog_map_H10
COMPONENT11 = ${DIRLIB}read_ascii2.o ${DIRLIB}wrte_ascii2.o
TARGET12    = prog_hlf2one
COMPONENT12 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
              ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o \
              ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o
TARGET16    = prog_map_cstlin
COMPONENT16 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
              ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
              ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o
TARGET17    = prog_map_arafrc_KYUSYU
COMPONENT17 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o
TARGET18    = prog_map_lcan2
COMPONENT18 = ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
              ${DIRLIB}conv_r1tor2.o ${DIRLIB}conv_r2tor1.o \
              ${DIRLIB}read_i1l2xy.o ${DIRLIB}read_asciiu.o \
              ${DIRLIB}rgetlon.o     ${DIRLIB}rgetlat.o \
              ${DIRLIB}rgetlen.o     ${DIRLIB}igeti0l.o
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
$(TARGET16) : $(TARGET16).o $(COMPONENT16)
	$(FC) -o $@ $@.o $(COMPONENT16)
$(TARGET17) : $(TARGET17).o $(COMPONENT17)
	$(FC) -o $@ $@.o $(COMPONENT17)
$(TARGET18) : $(TARGET18).o $(COMPONENT18)
	$(FC) -o $@ $@.o $(COMPONENT18)
############################################################
# commands
############################################################
all:    ${OBJS}
clean: 
	rm -f *.o *~ temp*


