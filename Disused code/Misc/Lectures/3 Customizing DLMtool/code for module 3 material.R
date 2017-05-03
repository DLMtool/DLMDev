
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




