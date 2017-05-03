
# R code for the  module 3 lectures


library(DLMtool)
setup()


myMPs = c("AvC","curE","DCAC","DD","MCD","SPMSY")

myOM = new('OM',Albacore,Generic_fleet,Generic_obs,Perfect_Imp)

myMSE = runMSE(myOM,myMPs)

NOAA_plot(myMSE)



plot(myOM)
