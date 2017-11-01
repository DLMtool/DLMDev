
# Code for Lecture 6 series =================

library(DLMtool)
setup()

MSErob<-MSE_rob

# 6a robustness testing
Swordfish_OM@nsim=24
MPs<-c(avail('Output'),avail('Input'))
MPs<-MPs[!grepl("LBSPR",MPs)&!grepl("_ML",MPs)&!grepl("_CC",MPs)&!grepl("ref",MPs)]
MSEref = runMSE(Swordfish_OM, MPs)

save(MSEref, file="C:/Data/MSE_swo")
load(file="C:/Data/MSE_swo")

Perf = NOAA_plot(MSEref)
head(Perf)
cond = Perf$LTY > 70 & Perf$B50 > 80
cond
sum(cond)
MSEsat = Sub(MSEref, MPs = MSEref@MPs[cond])
NOAA_plot(MSEsat)

# 2% increase in fishing efficiency pa
SWOrob = Swordfish_OM
SWOrob@D = SWOrob@D/2 
SWOrob@beta = c(0.5, 0.5)
SWOrob@qcv = c(0.5, 0.5)
SWOrob@Irefcv = c(0.5, 0.5)
MSErob = runMSE(SWOrob, MSEsat@MPs)
NOAA_plot(MSErob)

x<-seq(1,0,length.out=100)
Hyperstable<-x^(1/3)
Hyperdeplete<-x^3
lwds<-2
plot(x,x,type='l',xlab="Real relative abundance",ylab="Index",lwd=lwds)
lines(x,Hyperstable,col="red",lwd=lwds)
lines(x,Hyperdeplete,col="blue",lwd=lwds)
legend('topleft',legend=c("Hyperstable (Beta = 1/3)","Proportional (Beta = 1)","Hyperdeplete (Beta = 3)"),text.col=c("red","black","blue"),bty='n')



# fishing efficiency
OM<-new('OM',Albacore,Generic_Fleet,Precise_Unbiased,Perfect_Imp)
OM@nsim=24
MPs<-c("DD","DDe","curE","curE75","LBSPR_ItTAC","LBSPR_ItEff",
       "Itarget1","ItargetE1","IT10","ITe10","IT5","ITe5",
       "LstepCC1","LstepCE1")
OM@qinc=c(0,0)
MSEnoinc<-runMSE(OM,MPs)
save(MSEnoinc,file="C:/Data/MSEnoinc")
NOAA_plot(MSEnoinc)

OMinc<-OM
OMinc@qinc<-c(1,1)
MSEinc<-runMSE(OMinc,MPs)
save(MSEinc,file="C:/Data/MSEinc")

OMinc2<-OM
OMinc2@qinc<-c(2,2)
MSEinc2<-runMSE(OMinc2,MPs)
save(MSEinc2,file="C:/Data/MSEinc2")

OMinc3<-OM
OMinc3@qinc<-c(3,3)
MSEinc3<-runMSE(OMinc3,MPs)
save(MSEinc3,file="C:/Data/MSEinc3")

OMinc05<-OM
OMinc05@qinc<-c(0.5,0.5)
MSEinc05<-runMSE(OMinc05,MPs)
save(MSEinc05,file="C:/Data/MSEinc05")

OMinc15<-OM
OMinc15@qinc<-c(1.5,1.5)
MSEinc15<-runMSE(OMinc15,MPs)
save(MSEinc15,file="C:/Data/MSEinc15")

OMinc25<-OM
OMinc25@qinc<-c(2.5,2.5)
MSEinc25<-runMSE(OMinc25,MPs)
save(MSEinc25,file="C:/Data/MSEinc25")

par(mai=c(1,1,0.05,0.05))
NOAA_plot(MSEnoinc,panel=F)
NOAA_plot(MSEinc05,panel=F)
NOAA_plot(MSEinc,panel=F)
NOAA_plot(MSEinc15,panel=F)
NOAA_plot(MSEinc2,panel=F)
NOAA_plot(MSEinc25,panel=F)
NOAA_plot(MSEinc3,panel=F)

# overages

OM_TAEover<-OM
OM_TAEover@EFrac<-c(1.2,1.2)
MSE_TAEover<-runMSE(OM_TAEover,MPs)
NOAA_plot(MSE_TAEover,panel=F)

OM_TACover<-OM
OM_TACover@TACFrac<-c(1.2,1.2)
OM_TACover<-runMSE(OM_TACover,MPs)
NOAA_plot(OM_TACover,panel=F)


# Lecture 6b: Ecosystem / climate
Yellowfin_Tuna_IO@Kgrad = c(-1,-0.5)

MPs<-c("DD","DDe","curE","curE75","LBSPR_ItTAC","LBSPR_ItEff",
       "Itarget1","ItargetE1","IT10","ITe10","IT5","ITe5",
       "LstepCC1","LstepCE1","matlenlim","slotlim","AvC")


YFT_MSE_CC<-runMSE(Yellowfin_Tuna_IO,MPs)
save(YFT_MSE_CC,file="C:/Data/YFT_MSE_CC")

Yellowfin_Tuna_IO@Kgrad = c(0, 0)

YFT_MSE_NC<-runMSE(Yellowfin_Tuna_IO,MPs)
save(YFT_MSE_NC,file="C:/Data/YFT_MSE_NC")


NOAA_plot(YFT_MSE_NC,panel=F)
NOAA_plot(YFT_MSE_CC,panel=F)

CR<-new('OM',Rockfish,Generic_Fleet, Generic_Obs, Perfect_Imp)
CR@Mgrad = c(0, 0)
MSECR <- runMSE(CR, MPs)
save(MSECR,file="C:/Data/MSECR")

CRM<-CR
CRM@Mgrad = c(2, 3)
MSECRM <- runMSE(CRM, MPs)
save(MSECRM,file="C:/Data/MSECRM")

NOAA_plot(MSECR, panel=F)
NOAA_plot(MSECRM, panel=F)

# Recruitment

SwordfishR1<-SwordfishR2<-Swordfish_OM

SwordfishR1@Amplitude<-c(0.5,0.6)
SwordfishR1@Period<-c(8,10)
SwordfishR1@Perr<-c(0,0)
Sword1 <- runMSE(SwordfishR1, MPs)
save(Sword1,file="C:/Data/Sword1")

SwordfishR2@Amplitude<-c(0.1,0.2)
SwordfishR2@Period<-c(18,20)
SwordfishR2@Perr<-c(0,0)
Sword2 <- runMSE(SwordfishR2, MPs)
save(Sword2,file="C:/Data/Sword2")

NOAA_plot(Sword1, panel=F)
NOAA_plot(Sword2, panel=F)

Swordfish_OM@Amplitude<-c(0.5,0.6)
Swordfish_OM@Period<-c(8,10)
Swordfish_OM@Perr<-c(0,0)
plot(Swordfish_OM)

Swordfish_OM@nsim<-3

plot(Swordfish_OM)

Swordfish_OM@Amplitude<-c(0.2,0.3)
Swordfish_OM@Period<-c(18,20)
Swordfish_OM@Perr<-c(0,0)
plot(Swordfish_OM)

plot(Swordfish_OM)
