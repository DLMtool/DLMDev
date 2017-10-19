
# R code for the  module 2 lectures

library(DLMtool)
setup()

myOM=new('OM',Rockfish,Generic_fleet,Generic_obs,Perfect_Imp)

plot(myOM)

myMSE = runMSE(myOM, MPs=c('DCAC', 'DBSRA'))

Tplot2(myMSE)

?OM_xl


