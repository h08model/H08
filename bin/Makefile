############################################################
#to    compile files in bin
#by    2010/03/31, hanasaki: H08ver1.0
############################################################
# Macro
############################################################
include   ../adm/Mkinclude
DIRLIB  = ../lib
OBJS = htarray   htbin2list htcal     htcat      htcatchment \
       htcatts   htconv     htcreate  htcsv2txt  htdraw      \
       htdrawts  htedit     htformat  htgmtparam htid        \
       htidw     htl2xl2y   htlinear  htlist2bin htlsmtxt    \
       htmask    htmaskrplc htmath    htmean     htmeantxt  \
       htmettxt  htpercentile htplot  htplotts   htpoint    \
       htpointts htrank     htranktxt htstat     htstattxt   \
       htwind    htrs       htuscale  \
       httime    httimetxt  htuvwind htextract htstatlst \
       htcreatenc htputncts htcreatencfx htputncfx
############################################################
# Note
############################################################
# Done
#
# htarray    :  shiftone,upsidedownone 
# htcal      :  nofday
# htcat      :  hcat
# htcreate   :  createone
# htcreatenc :  createnc
# htedit     :  
# htformat   :  one2asc,one2xyz,asc2one,xyz2one
# htid       :  
# htlinear   :  cmap2one t1062one t422one t622one hlf2one hlf2one4 one2hlf 
# htlist2bin :  list2one
# htbin2list :  one2list
# htmask     :  findone maskone 
# htmath     :  addone,subone,mulone,divone,proone,ratone
# htmean     :  meanone 
# htmeantxt  :  
# htpoint    :  pointone
# htpointts  :  punchone
# htmaskrplc :  rplcone maskrplcone
# htstat     :  maxone,minone,sumone,aveone
# htstattxt  :  calctxt
# httime     :  three2dayone,six2dayone,day2monone,mon2yearone
# httimetxt  :  
# htcatchment:  catchone maskupone
# htmettxt   :  calc_bias__  calc_cc____ calc_delay_ 
# htlsmtxt   :  calc_lsma__  calc_lsmb__ 
# htrank     :  
#
# Suspended
#
# htpercentile  :  percentileone
# htzonal       :  one2ribbon  
# htpolygon     :  polyone
# htmetric      :  calc_ev____  calc_ns____ calc_re____
#                  calc_rmse__  calc_rmsemu calc_rmserm
# 
############################################################
# Suffix rule
############################################################
.f.o:
	$(FC) -c $(FFLAGS) $<
.F.o:
	$(FC) -c $(FFLAGS) ${INC} $<
.sh:
	cp $@.sh $@
	chmod 755 $@
############################################################
# Dependency
############################################################
TARGET1     = htcreate
COMPONENT1  = ${DIRLIB}/wrte_binary.o
TARGET2     = htmath
COMPONENT2  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/is_char.o
TARGET3     = htstat
COMPONENT3  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET4     = httime
COMPONENT4  = ${DIRLIB}/read_result.o ${DIRLIB}/wrte_bints2.o \
              ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
	      ${DIRLIB}/igetday.o
TARGET5     = htformat
COMPONENT5  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_bytswp.o ${DIRLIB}/wrte_bytswp.o \
              ${DIRLIB}/read_asciiu.o ${DIRLIB}/wrte_asciiu.o \
              ${DIRLIB}/read_ascii3.o ${DIRLIB}/wrte_ascii3.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o     \
              ${DIRLIB}/igeti0l.o     ${DIRLIB}/read_i1l2xy.o
TARGET6     = htarray
COMPONENT6  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r2tor1.o ${DIRLIB}/conv_r1tor2.o \
              ${DIRLIB}/igeti0l.o     \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o 
TARGET7     = htmask
COMPONENT7  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/igeti0l.o     
TARGET8     = htmaskrplc
COMPONENT8  = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/igeti0l.o     
TARGET9     = htpoint
COMPONENT9  = ${DIRLIB}/read_binary.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/igeti0l.o     \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET10    = htcal
COMPONENT10 = ${DIRLIB}/igetday.o
TARGET11    = htpointts
COMPONENT11 = ${DIRLIB}/igetday.o     ${DIRLIB}/igeti0l.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/read_result.o ${DIRLIB}/read_binary.o
TARGET12    = htmean
COMPONENT12 = ${DIRLIB}/igetday.o     ${DIRLIB}/igeti0l.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/read_result.o ${DIRLIB}/read_binary.o \
              ${DIRLIB}/cgetfnt.o     ${DIRLIB}/wrte_binary.o
TARGET13    = htlinear
COMPONENT13 = ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/wrte_binary.o ${DIRLIB}/read_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET14    = test_htlinear
COMPONENT14 = ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
              ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET15    = htmeantxt
COMPONENT15 = ${DIRLIB}/igetday.o \
              ${DIRLIB}/len_trim.o \
              ${DIRLIB}/read_ascii4.o ${DIRLIB}/wrte_ascii4.o
TARGET16    = httimetxt
COMPONENT16 = ${DIRLIB}/igetday.o \
              ${DIRLIB}/len_trim.o \
	      ${DIRLIB}/read_ascii4.o ${DIRLIB}/wrte_ascii4.o \
	      ${DIRLIB}/read_ascii5.o ${DIRLIB}/wrte_ascii5.o
TARGET17    = htedit
COMPONENT17 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/igeti0l.o     \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET18    = htid
COMPONENT18 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
              ${DIRLIB}/igeti0l.o     \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET19    = htstattxt
COMPONENT19 = ${DIRLIB}/read_ascii4.o ${DIRLIB}/igetday.o
TARGET20    = htlist2bin
COMPONENT20 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o
TARGET21    = htbin2list
COMPONENT21 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o
TARGET22    = htidw
COMPONENT22 = ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/rgetlen.o     ${DIRLIB}/sort_incord.o \
              ${DIRLIB}/wrte_binary.o ${DIRLIB}/read_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET23    = htcatchment
COMPONENT23 = ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/igetnxx.o     ${DIRLIB}/igetnxy.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o \
              ${DIRLIB}/wrte_binary.o ${DIRLIB}/read_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET24    = htmettxt
COMPONENT24 = ${DIRLIB}/read_ascii4.o \
              ${DIRLIB}/igetday.o     ${DIRLIB}/igetdoy.o
TARGET25    = htpercentile
COMPONENT25 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_result.o ${DIRLIB}/igetday.o
TARGET26    = htrank
COMPONENT26 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_result.o ${DIRLIB}/igetday.o \
              ${DIRLIB}/igeti0x.o     ${DIRLIB}/igeti0y.o \
              ${DIRLIB}/igeti0l.o     ${DIRLIB}/sort_decord.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET27    = htranktxt
COMPONENT27 = ${DIRLIB}/read_ascii4.o \
              ${DIRLIB}/igetday.o     ${DIRLIB}/sort_decord.o
TARGET28    = htcatts
COMPONENT28 = ${DIRLIB}/read_ascii4.o \
              ${DIRLIB}/igetday.o     ${DIRLIB}/is_char.o
TARGET29    = htcat
COMPONENT29 = ${DIRLIB}/read_ascii2.o
TARGET30    = htextract
COMPONENT30 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET31    = htuvwind
COMPONENT31 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o
TARGET32    = htl2xl2y
COMPONENT32 = ${DIRLIB}/wrte_asciiu.o
TARGET33    = htwind
COMPONENT33 = ${DIRLIB}/wrte_binary.o ${DIRLIB}/read_binary.o
TARGET34    = htrs
COMPONENT34 = ${DIRLIB}/wrte_binary.o ${DIRLIB}/read_binary.o \
              ${DIRLIB}/conv_rstors.o
TARGET35    = htimplant
COMPONENT35 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET36    = htcalmath
COMPONENT36 = ${DIRLIB}/igetday.o     ${DIRLIB}/igetdaymath.o
TARGET39    = htuscale
COMPONENT39 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/calc_uscale.o ${DIRLIB}/sort_decord.o
TARGET40    = htinlay
COMPONENT40 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o
TARGET41    = htborder
COMPONENT41 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/conv_r2tor1.o \
              ${DIRLIB}/read_i1l2xy.o ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o
TARGET42    = htpercentile2
COMPONENT42 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/read_result.o ${DIRLIB}/igetday.o
TARGET43    = ht2dto1d
COMPONENT43 = ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o
TARGET101   = htcreatenc
COMPONENT101= ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/igetday.o
TARGET102   = htputncts
COMPONENT102= ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/cgetfnt.o     ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/igetday.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/read_i1l2xy.o
TARGET103   = htcreatencfx
COMPONENT103= ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/rgetlon.o     ${DIRLIB}/rgetlat.o     \
              ${DIRLIB}/igetday.o
TARGET104   = htputncfx
COMPONENT104= ${DIRLIB}/read_binary.o ${DIRLIB}/wrte_binary.o \
              ${DIRLIB}/cgetfnt.o     ${DIRLIB}/read_asciiu.o \
              ${DIRLIB}/igetday.o \
              ${DIRLIB}/conv_r1tor2.o ${DIRLIB}/read_i1l2xy.o
############################################################
# Compilation
############################################################
$(TARGET0) : $(TARGET0).o $(COMPONENT0)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT0)
$(TARGET1) : $(TARGET1).o $(COMPONENT1)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT1)
$(TARGET2) : $(TARGET2).o $(COMPONENT2)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT2)
$(TARGET3) : $(TARGET3).o $(COMPONENT3)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT3)
$(TARGET4) : $(TARGET4).o $(COMPONENT4)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT4)
$(TARGET5) : $(TARGET5).o $(COMPONENT5)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT5)
$(TARGET6) : $(TARGET6).o $(COMPONENT6)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT6)
$(TARGET7) : $(TARGET7).o $(COMPONENT7)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT7)
$(TARGET8) : $(TARGET8).o $(COMPONENT8)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT8)
$(TARGET9) : $(TARGET9).o $(COMPONENT9)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT9)
$(TARGET10) : $(TARGET10).o $(COMPONENT10)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT10)
$(TARGET11) : $(TARGET11).o $(COMPONENT11)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT11)
$(TARGET12) : $(TARGET12).o $(COMPONENT12)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT12)
$(TARGET13) : $(TARGET13).o $(COMPONENT13)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT13)
$(TARGET14) : $(TARGET14).o $(COMPONENT14)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT14)
$(TARGET15) : $(TARGET15).o $(COMPONENT15)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT15)
$(TARGET16) : $(TARGET16).o $(COMPONENT16)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT16)
$(TARGET17) : $(TARGET17).o $(COMPONENT17)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT17)
$(TARGET18) : $(TARGET18).o $(COMPONENT18)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT18)
$(TARGET19) : $(TARGET19).o $(COMPONENT19)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT19)
$(TARGET20) : $(TARGET20).o $(COMPONENT20)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT20)
$(TARGET21) : $(TARGET21).o $(COMPONENT21)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT21)
$(TARGET22) : $(TARGET22).o $(COMPONENT22)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT22)
$(TARGET23) : $(TARGET23).o $(COMPONENT23)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT23)
$(TARGET24) : $(TARGET24).o $(COMPONENT24)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT24)
$(TARGET25) : $(TARGET25).o $(COMPONENT25)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT25)
$(TARGET26) : $(TARGET26).o $(COMPONENT26)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT26)
$(TARGET27) : $(TARGET27).o $(COMPONENT27)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT27)
$(TARGET28) : $(TARGET28).o $(COMPONENT28)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT28)
$(TARGET29) : $(TARGET29).o $(COMPONENT29)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT29)
$(TARGET30) : $(TARGET30).o $(COMPONENT30)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT30)
$(TARGET31) : $(TARGET31).o $(COMPONENT31)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT31)
$(TARGET32) : $(TARGET32).o $(COMPONENT32)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT32)
$(TARGET33) : $(TARGET33).o $(COMPONENT33)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT33)
$(TARGET34) : $(TARGET34).o $(COMPONENT34)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT34)
$(TARGET35) : $(TARGET35).o $(COMPONENT35)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT35)
$(TARGET36) : $(TARGET36).o $(COMPONENT36)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT36)
$(TARGET37) : $(TARGET37).o $(COMPONENT37)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT37)
$(TARGET38) : $(TARGET38).o $(COMPONENT38)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT38)
$(TARGET39) : $(TARGET39).o $(COMPONENT39)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT39)
$(TARGET40) : $(TARGET40).o $(COMPONENT40)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT40)
$(TARGET41) : $(TARGET41).o $(COMPONENT41)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT41)
$(TARGET42) : $(TARGET42).o $(COMPONENT42)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT42)
$(TARGET43) : $(TARGET43).o $(COMPONENT43)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT43)
$(TARGET44) : $(TARGET44).o $(COMPONENT44)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT44)
$(TARGET100) : $(TARGET100).o $(COMPONENT100)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT100) ${LIB} ${INC}
$(TARGET101) : $(TARGET101).o $(COMPONENT101)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT101) ${LIB} ${INC}
$(TARGET102) : $(TARGET102).o $(COMPONENT102)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT102) ${LIB} ${INC}
$(TARGET103) : $(TARGET103).o $(COMPONENT103)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT103) ${LIB} ${INC}
$(TARGET104) : $(TARGET104).o $(COMPONENT104)
	$(FC) $(FFLAGS) -o $@ $@.o $(COMPONENT104) ${LIB} ${INC}
############################################################
# Macro
############################################################
clean:
	rm -f *.o core *~ temp*
veryclean:
	rm -f *.o core *~ temp* $(OBJS)
all:    $(OBJS)
