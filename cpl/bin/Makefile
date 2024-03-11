#to     compile source code in cpl/bin
#on     2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
#	Macro (Basics)
############################################################
include   ../../adm/Mkinclude
DIRLIB  = ../../lib/
DIRLND  = ../../lnd/bin/
DIRRIV  = ../../riv/bin/
DIRDAM  = ../../dam/bin/
DIRCRP  = ../../crp/bin/
DIRCPL  = ../../cpl/bin/
OBJS    = main calc_irgapp_hyper.o main_hyper main_ftcs
############################################################
#	Macro (Settings)
############################################################
.f.o:
	$(FC) -c ${FCFLAGS} $<
.F.o:
	${FC} -c ${FCFLAGS} -I${INC} $<
############################################################
#	Dependency
############################################################
TARGET4    = main
COMPONENT4 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_bints3.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o \
             ${DIRCPL}calc_flgcrp.o ${DIRCPL}calc_irgapp.o \
             ${DIRLIB}igetdoy.o     ${DIRRIV}calc_humact.o \
             ${DIRDAM}calc_damdem.o ${DIRDAM}calc_resope.o \
             ${DIRLIB}cgetfnl.o     ${DIRCRP}calc_crpyld.o \
             ${DIRCPL}calc_watsrc.o
TARGETS    = main_new
COMPONENT5 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_bints3.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o \
             ${DIRCPL}calc_flgcrp.o ${DIRCPL}calc_irgapp_new.o \
             ${DIRLIB}igetdoy.o     ${DIRRIV}calc_humact_hyper.o \
             ${DIRDAM}calc_damdem.o ${DIRDAM}calc_resope_M12.o \
             ${DIRLIB}cgetfnl.o     ${DIRCRP}calc_crpyld.o \
             ${DIRCPL}calc_watsrc.o
TARGET3    = main.F18
COMPONENT3 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_bints3.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o \
             ${DIRCPL}calc_flgcrp.o ${DIRCPL}calc_irgapp_new.o \
             ${DIRLIB}igetdoy.o     ${DIRRIV}calc_humact_hyper.o \
             ${DIRDAM}calc_damdem.o ${DIRDAM}calc_resope_F18.o \
             ${DIRLIB}cgetfnl.o     ${DIRCRP}calc_crpyld.o \
             ${DIRCPL}calc_watsrc.o
TARGET2    = calc_irgapp_hyper
TARGET3    = main_hyper
COMPONENT3 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_bints3.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o \
             ${DIRCPL}calc_flgcrp.o ${DIRCPL}calc_irgapp_hyper.o \
             ${DIRLIB}igetdoy.o     ${DIRRIV}calc_humact_hyper.o \
             ${DIRDAM}calc_damdem.o ${DIRDAM}calc_resope_F18.o \
             ${DIRLIB}cgetfnl.o     ${DIRCRP}calc_crpyld.o \
             ${DIRCPL}calc_watsrc.o
TARGET4    = main_ftcs
COMPONENT4 = ${DIRLND}calc_leakyb.o ${DIRLND}calc_ts_nxt.o \
             ${DIRLIB}read_binary.o ${DIRLIB}wrte_binary.o \
             ${DIRLIB}read_result.o \
             ${DIRLIB}wrte_bints2.o ${DIRLIB}wrte_bints3.o \
             ${DIRLIB}igetday.o     ${DIRRIV}calc_spinup.o \
             ${DIRLIB}conv_rhtoqa.o ${DIRLIB}conv_rstors.o \
             ${DIRCPL}calc_flgcrp.o ${DIRCPL}calc_irgapp.o \
             ${DIRLIB}igetdoy.o     ${DIRRIV}calc_humact_ftcs.o \
             ${DIRDAM}calc_damdem.o ${DIRDAM}calc_resope.o \
             ${DIRLIB}cgetfnl.o     ${DIRCRP}calc_crpyld.o \
             ${DIRCPL}calc_watsrc.o
############################################################
#	Compilation
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

