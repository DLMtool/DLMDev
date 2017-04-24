
# ============ Diagnostic checks of DLMtool ================================================================================

library(DLMtool)
setup()

CHECKS<-new('list')



# --------- Implementation model checks ------------------------------------------

OM<-new('OM',Albacore)
MPs<-c("AvC","FMSYref","DCAC")

test1<-runMSEdev_imp(OM,MPs) # Base

OM@TACFrac<-c(1,1.2)
test2<-runMSEdev_imp(OM,MPs) # 20% overage

OM@TACFrac<-c(1.2,1.4)
test3<-runMSEdev_imp(OM,MPs) # 40% overage

OM@TACFrac<-c(0.8,1)
test4<-runMSEdev_imp(OM,MPs) # 20% underage

OM@TACSD<-c(0.4,0.5)
test5<-runMSEdev_imp(OM,MPs) # Implementation uncertainty

I1<-sum(NOAA_plot(test1)$PNOF>NOAA_plot(test2)$PNOF)==3 # Overage should be lower PNOF
I2<-sum(NOAA_plot(test2)$PNOF>NOAA_plot(test3)$PNOF)==3 # More overage should be even lower PNOF
I3<-sum(NOAA_plot(test4)$PNOF>NOAA_plot(test1)$PNOF)==3 # Underage should be higher PNOF
I4<-sum(NOAA_plot(test3)$VY>NOAA_plot(test5)$VY)==3     # Variability should be lower vY metric

CHECKS$Implementation<-data.frame(I1, I2, I3, I4)

CHECKS$Implementation