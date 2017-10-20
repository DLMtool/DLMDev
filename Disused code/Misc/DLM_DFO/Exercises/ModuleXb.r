
# ====================================================================================
# === DLMtool Exercise Xb: Time-varying parameters and ecosystem considerations ======
# ====================================================================================
#
# Similarly to the observation processes and fishing efficiency changes 
# considered in excercise 6a, it may be desirable to test the robustness of 
# MPs over a range time-varying biological parameters (ie changes in growth
# due to climate change or recruitment regime shifts).



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: run the reference MSE ==============================================
# 
# Here we use the yellowfin operating models to conduct a reference MSE

MPs<-c("Ltarget1","Ltarget4","Itarget4","HDAAC","Fratio","IT5", "IT10",
       "DCAC","DCAC4010","Islope1","MCD","ITM","TCPUE","TCPUE_e","AvC")

SWOref<-Swordfish_OM

Ref<-runMSE(SWOref, MPs=MPs, CheckMPs=T)

NOAA_plot(Ref)

# Q1.1 Which MP or MPs might you consider?



# === Task 2: run the robustness MSE ==============================================
# 
# Now lets assume that there could be some changes in growth rate due
# to oceanographic conditions, that our view of stock level is optimistic
# and there could be phase-shifts in recruitment we are not accounting for.

SWOrob<-Swordfish_OM

SWOrob@Kgrad<-c(0,0.5)       # a negative % annual change in growth K
SWOrob@D<-SWOref@D/2         # current depletion could be actually half
SWOrob@Period<-c(15,25)      # 10-15 year productivity phase shifts
SWOrob@Amplitude<-c(0.1,0.3) # 10% - 30% changes in recruitment

Rob<-runMSE(SWOrob, MPs=MPs, CheckMPs=T)

NOAA_plot(Rob)

# Q2.1  How has absolute performance changed?
#
# Q2.2  How has the trade-off in NOAA_plot changed with the advent
#       of additional operating model uncertainty?
#
# Q2.3  Which MPs do well regardless?



# === Optional tasks ===============================================================
# 
# There are few other variables can can be time-varying in DLMtool operating models
# including
#
# Mgrad: gradients in natural mortality rate (disease,fewer/more numerous predators)
# Linfgrad: gradient in maximum length

# Task 3: Add changes in Mgrad and Linfgrad
# 
# Q3.1    How do these affect the performance picture of the reference MSE run?
#
# Q3.2    What additional time-varying parameters would be relevant to stocks
#         that you work on?


# ==================================================================================
# === End of Exercise Xb ===========================================================
# ==================================================================================


