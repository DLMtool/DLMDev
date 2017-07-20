
# ============ Diagnostic checks of DLMtool ================================================================================

library(DLMtool)
setup()

works<-function(x)class(try(x,silent=T))!="try-error"

CHECKS<-new('list')   # Master check list

# ================ OBJECTS ==========================================================================

# --------- Implementation error model checks ------------------------------------------

# --- Output imp -----------------------

OM<-new('OM',Albacore)
OM@seed<-runif(1)
MPs<-c("AvC","FMSYref","DCAC")
nMPs<-length(MPs)

test1<-runMSE(OM,MPs) # Base


OM@TACFrac<-c(1,1.2)
test2<-runMSE(OM,MPs) # 20% overage

OM@TACFrac<-c(1.2,1.4)
test3<-runMSE(OM,MPs) # 40% overage

OM@TACFrac<-c(0.8,1)
test4<-runMSE(OM,MPs) # 20% underage

OM@TACSD<-c(0.4,0.5)
test5<-runMSE(OM,MPs) # Implementation uncertainty

I1<-sum(NOAA_plot(test1)$PNOF>NOAA_plot(test2)$PNOF)==nMPs # Overage should be lower PNOF
I2<-sum(NOAA_plot(test2)$PNOF>NOAA_plot(test3)$PNOF)==nMPs # More overage should be even lower PNOF
I3<-sum(NOAA_plot(test4)$PNOF>NOAA_plot(test1)$PNOF)==nMPs # Underage should be higher PNOF
I4<-sum(NOAA_plot(test3)$VY>NOAA_plot(test5)$VY)==nMPs     # Variability should be lower VY metric
I5 <- sum(NOAA_plot(test1)$B50>NOAA_plot(test2)$B50)==nMPs # Prob Biomass should be higher
I6 <- sum(NOAA_plot(test2)$B50>NOAA_plot(test3)$B50)==nMPs # Prob Biomass should be higher
I7 <- sum(NOAA_plot(test4)$B50>NOAA_plot(test1)$B50)==nMPs # Prob Biomass should be higher
CHECKS$Imp_output<-data.frame(I1, I2, I3, I4, I5, I6, I7)





# --- Size limitimp -------------------

OM<-new('OM',Albacore)
OM@seed<-runif(1)
MPs<-c("matlenlim","matlenlim2")
nMPs<-length(MPs)

test1<-runMSE(OM,MPs)

OM@SizeLimFrac<-c(1.2,1.2)

test2<-runMSE(OM,MPs)

I5<-sum(NOAA_plot(test1)$PNOF>NOAA_plot(test2)$PNOF)==nMPs

CHECKS$Imp_size<-data.frame(I5)


# --- Effort imp ----------------------


# --------- Observation model checks ---------------------------------------------


# --------- Stock model checks ---------------------------------------------------


# --------- Fleet model checks ----------------------------------------------------




# --------- Prebuilt OM checks ----------------------------------------------------


OMs<-avail('OM')
nOMs<-length(OMs)

PB_OM_plot<-data.frame(matrix(FALSE,nrow=1,ncol=nOMs))
for(i in 1:nOMs)  PB_OM_plot[1,i]<-works(plot(get(OMs[i])))
CHECKS$PB_OM_plot<-PB_OM_plot

PB_OM_runMSE<-data.frame(matrix(FALSE,nrow=1,ncol=nOMs))
for(i in 1:nOMs)  PB_OM_runMSE[1,i]<-works(runMSE(get(OMs[i])))
CHECKS$PB_OM_runMSE<-PB_OM_runMSE



# ============== OM FUNCTIONS ========================================================


# ---------- Run MSE -------------------------------------------------------------


runMSEs<-data.frame(matrix(TRUE,nrow=1,ncol=4))
Butterfish@D<-c(0.01,0.05)
ButterLow<-try(runMSE(new('OM',Butterfish,Generic_fleet,Generic_obs,Perfect_Imp)),silent=T)
if(class(ButterLow)=="try-error")runMSEs[1,1]<-FALSE

Butterfish@D<-c(0.8,1)
ButterHigh<-try(runMSE(new('OM',Butterfish,Generic_fleet,Generic_obs,Perfect_Imp)),silent=T)
if(class(ButterHigh)=="try-error")runMSEs[1,2]<-FALSE

Canary_Rockfish_BC_DFO@D<-c(0.01,0.05)
CanaryLow<-try(runMSE(Canary_Rockfish_BC_DFO),silent=T)
if(class(CanaryLow)=="try-error")runMSEs[1,3]<-FALSE

Canary_Rockfish_BC_DFO@D<-c(0.5,0.7)
CanaryHigh<-try(runMSE(Canary_Rockfish_BC_DFO),silent=T)
if(class(CanaryHigh)=="try-error")runMSEs[1,4]<-FALSE

CHECKS$runMSEs<-runMSEs

exMSE<-list(ButterLow,ButterHigh,CanaryLow,CanaryHigh)

# ---------- Misc ----------------------------------------------------------------

# sub
# replace



# ============== OM FUNCTIONS ========================================================



# ============== MPs =================================================================

# --------- Reference MP checks --------------------------------------------------


# --------- 

# ============== plotting functions ==================================================


# ---- plotting of OMs -----------------------------------------


OMs<-avail('OM')
nOMs<-length(OMs)

# Tplot
Plot_DFOhist<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nOMs) Plot_DFOhist[i]<-works(DFO_hist(get(OMs[i])))
CHECKS$Plot_DFOhist<-Plot_DFOhist


# ---- plotting of MSEs ---------------------------------------

nMSE<-length(exMSE) # using butter and canary example OMs

# Tplot
Plot_Tplot<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nMSE) Plot_Tplot[i]<-works(Tplot(exMSE[[i]]))
CHECKS$Plot_Tplot<-Plot_Tplot

# Pplot                                     
Plot_Pplot<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nMSE) Plot_Pplot[i]<-works(Pplot(exMSE[[i]]))
CHECKS$Plot_Pplot<-Plot_Pplot

# Kplot                                     
Plot_Kplot<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nMSE) Plot_Kplot[i]<-works(Kplot(exMSE[[i]]))
CHECKS$Plot_Kplot<-Plot_Kplot

# Kplot                                     
Plot_NOAAplot<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nMSE) Plot_NOAAplot[i]<-works(NOAA_plot(exMSE[[i]]))
CHECKS$Plot_NOAAplot<-Plot_NOAAplot

# DFO_proj                                     
Plot_DFOproj<-data.frame(matrix(FALSE,nrow=1,ncol=nOM))
for(i in 1:nMSE) Plot_DFOproj[i]<-works(DFO_proj(exMSE[[i]]))
CHECKS$Plot_NOAAplot<-Plot_DFOproj[i]



# mega MSE

# w/wo parallel

# mp diversity

# sub function replace


# =========== CHECK diagnostics ========================

nerrs<-function(x)sum(!x)
cursory<-lapply(CHECKS,nerrs)

if(sum(unlist(cursory))==0){
  message("!!! ALL CHECKS PASSED !!!")
}else{
  message(paste("problems with:", names(CHECKS)[as.numeric(unlist(cursory))>0]))
}






