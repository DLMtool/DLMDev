
# R code for the  module 3 lectures

library(DLMtool)
setup()

myMPs = c("AvC","curE","DCAC","DD","MCD","SPMSY")

myOM = new('OM',Albacore,Generic_fleet,Generic_obs,Perfect_Imp)

plot(myOM)

myMSE = runMSE(myOM,myMPs)

NOAA_plot(myMSE)

Converge(myMSE)

myOM2<-myOM
myOM2@nsim<-152
myMSE2<-runMSE(myOM2,myMPs)

myMSE3<-Sub(myMSE2,MPs=c("MCD","SPMSY"))
VOI(myMSE3,ncomp=3)

SSB5<-apply(myMSE@B_BMSY>0.05,2,mean)

muSSB<-apply(myMSE@SSB,2,mean)
CrelMSY<-apply(myMSE@C/myMSE@OM$MSY,2,mean)

plot(muSSB,CrelMSY,col='white')
text(muSSB,CrelMSY,myMSE@MPs,col='blue')
