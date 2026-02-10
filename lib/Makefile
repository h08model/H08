######################################################################
#to   make codes
#by   hanasaki, 20100331, NIES: H08 ver1.0
######################################################################
include ../adm/Mkinclude
.f.o:
	${FC} -c ${FFLAGS} $<
######################################################################
# Macro settings
######################################################################
DIRLIB = ../lib
OBJS =  cgetfnl.o     cgetfnt.o     \
        conv_qatorh.o conv_r1toi2.o conv_r1tor2.o \
        conv_r2tor1.o conv_rhtoqa.o conv_rstors.o \
        igetday.o     igetdoy.o     igeti0l.o     \
        igeti0x.o     igeti0y.o     igetnxx.o     igetnxy.o     \
        igetymd.o     is_char.o     len_trim.o    \
        read_ascii2.o read_ascii3.o read_ascii4.o read_asciiu.o \
        read_binary.o read_i1l2xy.o read_bytswp.o read_result.o \
        rgetara.o     rgetlat.o     rgetlen.o     rgetlon.o     \
        sort_decord.o sort_incord.o \
        wrte_ascii2.o wrte_ascii3.o wrte_ascii4.o wrte_asciiu.o \
        wrte_binary.o wrte_bints2.o wrte_bints3.o \
        wrte_bytswp.o calc_uscale.o read_ascii5.o wrte_ascii5.o \
	conv_tarhtovpd.o
######################################################################
#
######################################################################
cgetfnl.o     : len_trim.o
cgetfnt.o     : len_trim.o
igetdoy.o     : igetday.o
igetymd.o     : igetday.o
read_ascii3.o : igeti0x.o igeti0y.o  conv_r2tor1.o
read_i1l2xy.o :                      read_asciiu.o
read_result.o : len_trim.o igetday.o read_binary.o
wrte_ascii3.o : rgetlon.o  rgetlat.o conv_r1tor2.o
wrte_ascii4.o : len_trim.o igetday.o
wrte_bints2.o : len_trim.o igetday.o read_binary.o
wrte_bints3.o : len_trim.o igetday.o read_binary.o wrte_bints2.o

TARGET1 = test_function
TARGET1.SUB =  ${OBJS}
TARGET2 = test_qatorh
TARGET2.SUB =  ${DIRLIB}conv_qatorh.o ${DIRLIB}conv_rhtoqa.o
TARGET3 = test_io
TARGET3.SUB =  ${OBJS}
TARGET4 = test_result
TARGET4.SUB =  ${OBJS}
TARGET5 = test_is_char
TARGET5.SUB =  ${OBJS}
TARGET6 = test_getday
TARGET6.SUB =  ${DIRLIB}/igetday.o
TARGET7 = test_getdoy
TARGET7.SUB =  ${DIRLIB}/igetday.o \
               ${DIRLIB}/igetdoy.o ${DIRLIB}/igetymd.o
TARGET8 = test_binary
TARGET8.SUB =  ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
               ${DIRLIB}/read_little.o ${DIRLIB}/wrte_little.o
TARGET9 = test_i1l2xy
TARGET9.SUB =  ${DIRLIB}/read_asciiu.o ${DIRLIB}/read_i1l2xy.o
TARGET10 = test_bints2
TARGET10.SUB =  ${DIRLIB}/wrte_bints2.o ${DIRLIB}/igetday.o \
                ${DIRLIB}/wrte_binary.o
TARGET11 = test_tarhtovpd
TARGET11.SUB =  ${DIRLIB}/conv_tarhtovpd.o

${TARGET1} : ${TARGET1}.o ${TARGET1.SUB}
	${FC} $@.o ${TARGET1.SUB} ${FLFLAGS} -o $@
${TARGET2} : ${TARGET2}.o ${TARGET2.SUB}
	${FC} $@.o ${TARGET2.SUB} ${FLFLAGS} -o $@
${TARGET3} : ${TARGET3}.o ${TARGET3.SUB}
	${FC} $@.o ${TARGET3.SUB} ${FLFLAGS} -o $@
${TARGET4} : ${TARGET4}.o ${TARGET4.SUB}
	${FC} $@.o ${TARGET4.SUB} ${FLFLAGS} -o $@
${TARGET5} : ${TARGET5}.o ${TARGET5.SUB}
	${FC} $@.o ${TARGET5.SUB} ${FLFLAGS} -o $@
${TARGET6} : ${TARGET6}.o ${TARGET6.SUB}
	${FC} $@.o ${TARGET6.SUB} ${FLFLAGS} -o $@
${TARGET7} : ${TARGET7}.o ${TARGET7.SUB}
	${FC} $@.o ${TARGET7.SUB} ${FLFLAGS} -o $@
${TARGET8} : ${TARGET8}.o ${TARGET8.SUB}
	${FC} $@.o ${TARGET8.SUB} ${FLFLAGS} -o $@
${TARGET9} : ${TARGET9}.o ${TARGET9.SUB}
	${FC} $@.o ${TARGET9.SUB} ${FLFLAGS} -o $@
${TARGET10} : ${TARGET10}.o ${TARGET10.SUB}
	${FC} $@.o ${TARGET10.SUB} ${FLFLAGS} -o $@
${TARGET11} : ${TARGET11}.o ${TARGET11.SUB}
	${FC} $@.o ${TARGET11.SUB} ${FLFLAGS} -o $@
######################################################################
#
######################################################################
all: $(OBJS)
clean :
	rm -f *.o core *~ *trace temp*
