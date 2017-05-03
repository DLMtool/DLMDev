
# ====================================================================================
# === DLMtool Exercise 6b: Time-varying parameters and ecosystem considerations ======
# ====================================================================================
#
# In a range of management settings there may be relative confidence over a
# range of operating model conditions. When MSE analysis is undertaken a 
# set of similarly performing MPs may be identified. 
#
# This opens up an opportunity for robustness testing where futher simulations
# are undertaken over less certain but potentially relevant conditions such
# as climate change or non-stationarity in stock productivity.
#
# The initial set of simulations are called the 'reference set'. The second
# set of simulations are referred to as the 'robustness set'. Robustness 
# testing allows for further discrimination of MPs and greater confidence 
# in a particular MP. 



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: run a reference MSE with good quality data  =========================
# 
# Here we use a bluefin stock object to conduct a reference MSE with a good 
# quality data model 'Precise_Unbiased'.

MPs<-c("Ltarget1","Ltarget4","Itarget4","HDAAC","Fratio","IT5", "IT10",
       "DDe","DD","matlenlim","MCD","ITM","TCPUE","TCPUE_e","AvC")

BFTref<-new('OM',Bluefin_tuna,       # Bluefin stock dynamics
                 Generic_fleet,      # A generic fleet
                 Precise_Unbiased,   # Good quality data
                 Perfect_Imp)        # Perfect adherence to management

Ref<-runMSE(BFTref, MPs=MPs, CheckMPs=T)

NOAA_plot(Ref)

# Q1.1  Which MP or MPs might you consider?


# === Task 2: run a robustness MSE with bad quality data  =========================
# 
# Here we use the same bluefin stock object to conduct a reference MSE with a  
# bad quality data model 'Imprecise_Biased'.


BFTrob<-new('OM',Bluefin_tuna,        # Bluefin stock dynamics (same)
                 Generic_fleet,       # A generic fleet (same)
                 Imprecise_Biased,    # Bad quality data
                 Perfect_Imp)         # Perfect adherence to managament

Ref<-runMSE(BFTref, MPs=MPs, CheckMPs=T)

NOAA_plot(Rob)


# Q2.1  How does the performance of the robustness set differ from 
#       that of the reference set?
#
# Q2.2  Which MPs showed the greatest disparity in performance?
#
# Q2.3  Have you changed your mind about the MP you might select in Q1.1
#       and if so, why?   



# === Task 3: catchability ==============================================
# 
# Now lets assume that there could be some changes in growth rate due
# to oceanographic conditions, that our view of stock level is optimistic
# and there could be phase-shifts in recruitment we are not accounting for.




# ==================================================================================
# === End of Exercise 5a ===========================================================
# ==================================================================================


