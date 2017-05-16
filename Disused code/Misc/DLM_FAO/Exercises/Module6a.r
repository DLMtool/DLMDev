
# ====================================================================================
# === DLMtool Exercise 6a: Robustness testing and MP selection =======================
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
# quality observation model 'Precise_Unbiased'.

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
# Here we use the same bluefin stock object to conduct a robustness test using
# bad quality observation model 'Imprecise_Biased'.


BFTrob<-new('OM',Bluefin_tuna,        # Bluefin stock dynamics (same)
                 Generic_fleet,       # A generic fleet (same)
                 Imprecise_Biased,    # Bad quality data
                 Perfect_Imp)         # Perfect adherence to managament

Rob<-runMSE(BFTrob, MPs=MPs, CheckMPs=T)

NOAA_plot(Rob)


# Q2.1  How does the performance of the robustness set differ from 
#       that of the reference set?
#
# Q2.2  Which MPs showed the greatest disparity in performance?
#
# Q2.3  Have you changed your mind about the MP you might select in Q1.1
#       and if so, why?   



# === Task 3: catchability changes ===============================================
# 
# A critical difference between management using TACs and TAEs is that few
# MPs that set TAEs account properly for changes in fishing efficiency and/or
# density-dependent catchability. 
#
# DLMtool version 4 is yet to include flexibility to account for density-
# dependent catchability changes (a critical flaw of effort control systems
# in some fishery management systems such as New England, USA). This 
# phenomenon can occur, for example, when there is range collapse at lower
# stock sizes allowing for more effective spatial targetting. 
# 
# DLMtool does however allow for the modelling of gradual increases / 
# decreases in catchability that allow fleets to catch a greater fraction of
# the stock per unit of effort over time (due to technology creep for example).
#
# Here we create a new robustness test and examine how catchability changes
# affect input and output control MPs. 

BFTrob2<-BFTref      # Copy the reference operating model

BFTrob2@qinc<-c(1,3) # Between 1 and 3 % increases in catchability per year

Rob2<-runMSE(BFTrob2, MPs=MPs, CheckMPs=T)

NOAA_plot(Rob2)

# Q3.1  Was it only input control MPs that were affected by the change in 
#       catchability? 
# 
# Q3.2  How substantial was the impact on performance?



# === Task 4: Implementation error ===============================================
# 
# To evaluate the affect imperfect adherence to management recommendations 
# we are going to add equal levels of mean overages in catches and effort.
#
# This is controlled via the Implementation error object class (class Imp)
#
# First we will copy and modify the Perfect_Imp object that produces no
# overages or discrepancies in either effort recommendations, TACs or
# size limits. 

Overages<-Perfect_Imp

Overages@TACFrac<-c(1.15, 1.25)  # between 15% and 25% overages in TACs
Overages@EFrac<-c(1.15, 1.25)    # between 15% and 25% overages in TAEs

BFTrob3<-new('OM',Bluefin_tuna,  # Bluefin stock dynamics (same)
            Generic_fleet,       # A generic fleet (same)
            Precise_Unbiased,    # Good quality data (same)
            Overages)            # 15% and 25% overages

Rob3<-runMSE(BFTrob3, MPs=MPs, CheckMPs=T)

NOAA_plot(Rob3)

# Q4.1  Were input and output control MPs affected similarly by the same
#       level of overages? 
# 
# Q4.2  Can you explain this result?
#
# Q4.3  Did overages always negatively affect performance of the MPs?
#
# Q4.4  Can you explain this result also?



# ==================================================================================
# === End of Exercise 6a ===========================================================
# ==================================================================================


