
#=====================================================================================
# === DLMtool Exercise 5c: Custom MPs - Input controls ===============================
# ====================================================================================

# The previous exercise 5b looked at the anatomy of an output control MP and
# provided two examples of custom MPs. 
#
# In this exercise we shift focus to input controls (class 'Input') that are 
# quite different. Rather than prescribing a Total Allowable Catch, input 
# controls can either prescribe total allowable effort (TAE), a spatial control
# or a size limit.
#
# In this section we investigate some of the current DLMtool input controls 
# specify our own effort MPs, spatial controls and size limits.



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: the anatomy of an input control MP =================================
#
# Similarly to Output controls, input controls are functions that accept
# three arguments:
#
#  x: a simulation number 
#  Data: an object of class 'Data' 
#  reps: not currently used by input controls 
# 
# You can list the available input control MPs using the avail() function:

avail('Input')

# Lets take a look at the current effort MP:

curE

# As illustrated by curE, an Input control MP returns a vector of 6 numbers.
# These six numbers represent four characteristics:
#
#  Allocation
#  Effort
#  Spatial closure
#  Length Vulnerability
#
# Allocation is the first number and specifies how much fishing effort is
# reallocated given a spatial closure.
#
# Effort is a number presenting the fraction of current (todays) total 
# effort that is recommended (the TAE)
#
# Spatial is a vector 2 long (there are 2 areas in DLMtool models) that 
# is the fraction of todays effort by area.
#
# Vuln is a vector 2 long, where the first term represents the length at
# 5% vulnerability and the second number is the shortest length at 100%
# vulnerability.
#
# The curE MP does not include any spatial reductions in effort 
# (Spatial<-c(1,1)), therefore does not require spatial reallocation of
# effort (Allocate<-1) and keeps effort constant at current levels
# (Effort<-1). Since there are no specified changes to size limits
# the vulnerability parameters are not specified Vuln<-c(NA,NA).
#
# To highlight the difference examine spatial control MP 'MRreal' that 
# closes area 1 to fishing and reallocates fishing to the open area 2:

MRreal

# In contrast 'MRnoreal' does not reallocate fishing effort 

MRnoreal

# The MP 'matlenlim' only specifies the parameters of length 
# vulnerability using an estimate of length at 50% maturity (L50):

matlenlim



# === Task 2: Modify the TCPUE MP to provide effort advice ================
#
# Here we will copy and modify the code from exercise 5b to specify 
# a new version of the target catch per unit effort MP (TCPUE) from
# exercise 5b that provides effort recommendations:

TCPUE_e<-function(x,Data,reps){
  
  mc<-0.05                             # max change in TAC 
  frac<-0.3                            # target index is 30% of max
  nyears<-length(Data@Ind[x,])         # number of years of data
  
  smoothI<-smooth.spline(Data@Ind[x,]) # smoothed index  
  targetI<-max(smoothI$y)*frac         # target 
  
  currentI<-mean(Data@Ind[x,(nyears-2):nyears]) # current index
  
  ratio<-currentI/targetI              # ratio currentI/targetI
  
  if(ratio < (1 - mc)) ratio <- 1 - mc # if currentI < targetI
  if(ratio > (1 + mc)) ratio <- 1 + mc # if currentI > targetI
  
  TAE <- Data@MPeff[x] * ratio
  
  # no reallocation, new effort, no spatial, Vuln unchanged
  c(1,               TAE,        1,  1,      NA, NA)
  
}

# There have been surprisingly few changes to make TCPUE an input
# control MP that sets total allowable effort. 
#
#  We have had to use stored recommendations of effort in the 
#  Data@MPeff slot 
#
# and
#
#  The final line of the MP is now a vector where the second 
#  position is our new TAE recommendation.
#
# That is all. 
#
# The only other difference is that to make it DLMtool
# compatible we have to assign it a different class:

class(TCPUE_e)<-"Input"
environment(TCPUE_e)<-asNamespace('DLMtool')
sfExport("TCPUE_e")

# An MSE can now be run for the TCPUE and TCPUE_e MPs

MSE7<-runMSE(testOM,MPs=c("TCPUE","TCPUE_e"))


# Q2.1  Examine MSE7 with NOAA_plot() 
#       Does one MP consistently outperform the other?

# Q2.2  NOAA_plot implies that TCPUE_e overfishes more
#       whilst having a fractionally low likelihood of
#       dropping below half of BMSY. How is this possible?

# Q2.3  How does the VOI analysis differ for the TCPUE and 
#       TCPUE_e MPs?



# === Task 3: Evaluating spatial closure MPs ============================
# 
# In this section we specify a number of spatial closure MPs that
# reallocate effort from the closed area to the open area.
#
# It is first necessary to understand a little about how DLMtool
# simulates spatial population structure. 
#
# DLMtool is currently a 2-box model, ie the population exists 
# in two homogeneous areas.
#
# Currently there are two operating model slots that control 
# the distribution and mixing of fish among these areas.
#
# To investigate what these do lets look at the operating model 
# for Atlantic swordfish, 'Swordfish_OM"

SWO<-Swordfish_OM

# The slot Frac_area_1 controls the fraction of total habitat
# included in area 1.

SWO@Frac_area_1

# The slot Prob_staying is the probability that individuals 
# remain in area 1 between years. 
#
# Lets say we wish for around 80% - 85% of fish to stay in 
# area 1 and for area 1 to be around 20-25% of the total habitat
# here is how we would specify that:

SWO@Prob_staying<-c(0.8, 0.85)
SWO@Frac_area_1<-c(0.20, 0.25)


# DLMtool uses these slots to sample combinations of these
# parameters. For each parameter combination there is only one
# movement model that satisfies the parameters.
#
# We can now evaluate the success of closing area 1 for this
# range of stock mixing.
# 
# There is already an input MP that completely closes area 1
# and reallocates the effort: 'MRreal'. Lets design a couple 
# more that offer lesser reductions in effort in area 1 - 
# perhaps reflecting a seasonal closure.

# 75% reduction in area 1 effort:

MRreal75<-function(x,Data,reps){

  Allocate <- 1         # Full reallocation of area 1 effort
  Effort <- 1           # Current effort
  Spatial <- c(0.75, 1) # 75% reduction in area 1
  Vuln <- rep(NA, 2)    # no change in vulnerability
  c(Allocate, Effort, Spatial, Vuln)
  
}

class(MRreal75)<-"Input"
environment(MRreal75)<-asNamespace('DLMtool')
sfExport("MRreal75")

# 50% reduction in area 1 effort:

MRreal50<-function(x,Data,reps){
  
  Allocate <- 1         # Full reallocation of area 1 effort
  Effort <- 1           # Current effort
  Spatial <- c(0.50, 1) # 50% reduction in area 1
  Vuln <- rep(NA, 2)    # no change in vulnerability
  c(Allocate, Effort, Spatial, Vuln)
  
}

class(MRreal50)<-"Input"
environment(MRreal50)<-asNamespace('DLMtool')
sfExport("MRreal50")

# We can now see how well these MPs work in MSE analysis:

MSE8<-runMSE(SWO,MPs=c("MRreal","MRreal75","MRreal50"))

NOAA_plot(MSE8)

# Q3.1  How differently dot the MPs perform?

# Q3.2  How viscous does the stock have to be before
#       the closure MPs perform appreciably differently?
#       (ie increase the values in SWO@Prob_staying)

# Q3.3  What does this tell us about the likely 
#       efficacy of spatial closures for highly 
#       migratory mixed stocks?


# === Optional tasks ================================================

# Task 4: As Q3.2 but instead of changing Prob_staying
#         try modifying the size of the closure using
#         Frac_area_1


# ==================================================================================
# === End of Exercise 5c ===========================================================
# ==================================================================================



