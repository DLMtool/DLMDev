
# ====================================================================================
# === DLMtool Exercise Xc: Other Useful Functions ====================================
# ====================================================================================
#
# Here is a condensed list of some additional and handy DLMtool functions


# === Setup (only required if new R session) =================================

library(DLMtool)  
setup()
DLMextra()
library(DLMextra)



myMSE<-runMSE()                                 # create a demo MSE
Tplot(myMSE)


# === Subsetting =============================================================

MSE_DCAC_AvC<-Sub(myMSE, MPs=c("DCAC","AvC"))   # subset MSE object by MP
Tplot(MSE_DCAC_AvC)

MSE_5_20<-Sub(myMSE, sims= 5:20)   # subset MSE object by simulation number
Tplot(MSE_5_20)

ripped_Stock<-SubOM(hakeOM,"Stock") # create a Stock object from a complete OM
ripped_Imp<-SubOM(hakeOM,"Imp")     # create an Imp object from a complete OM




# === OM maniputation ========================================================

Swordfish_OM_perf<-makePerf(Swordfish_OM) # remove all observation and process error
Swordfish_OM@Cobs
Swordfish_OM_perf@Cobs  # now no catch observation error

# Replace the fleet dynamics of Lane snapper with those of lesser amberjack 
LS_LaneSnapper_OM2<-Replace(LS_LaneSnapper_OM, LAJ_LesserAmberjack_OM, "Fleet")
LS_LaneSnapper_OM@EffUpper
LS_LaneSnapper_OM2@EffUpper



# === Data manipulation =====================================================



# ==================================================================================
# === End of Exercise Xc ===========================================================
# ==================================================================================


