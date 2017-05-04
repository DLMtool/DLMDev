
# =====================================================================================
# === DLMtool Exercise 5b: Custom MPs - Output controls ===============================
# =====================================================================================
#
# A primary objective of DLMtool was to produce an extensible simulation/assessment 
# framework that allows users to develop and test their own MPs, and then compare 
# them with other MPs on a level playing field. 
#
# This objective is in response to the criticism that currently, MPs are developed 
# largely in isolation and tested by varying simulation frameworks that may (or may
# not) favor their respective MPs. Additionally, it is difficult to exactly 
# reproduce these simulation results as code is not readily availble or easily 
# applied.
#
# In this practical you will learn the basic structure of a DLMtool output control
# MP - (class Output) which is something that turns fishery data into a TAC
# recommendation. 
#
# Of the R coding that we have covered in these practicals, this is arguably the 
# most 'hacky'! However if coded in the right way, a new MP can become immediately
# available to all functions of the toolkit including MSE and TAC calculation 
# from real data. 
# 
# Hopefully this exercise will demonstrate that this is both easy and worthwhile!



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: the format of DLMtool simulated data ===============================
#
# In the module 4 exercises we examined the format of real data that can
# be used in DLMtool to generate management advice (TACs, effort etc).
#
# As we saw before, real data are stored in a class of objects 'Data'.
#
# The DLMtool MSE function generates simulated data and puts it in 
# exactly the same format as real data. This is highly desirable because
# it means that the same MP code that is tested in the MSE can then
# be used to make management recommendations. 
#
# If an MP is coded incorrectly it may catastrophically fail MSE
# testing and will therefore be excluded from use in management. 
#
# Lets examine an existing DLM_output MP to identify the MP data
# requirements. 

avail('Output')

# Since we've seen it used as a default MP in lots of the examples above,
# lets learn more about DCAC

?DCAC

# We can even see all the code for this MP by simply typing the name of
# the MP into the console (this is a fantastic advantage of using R -
# there is complete transparently about package functions):

DCAC

# "Crikey that looks complicated!" might be your first reaction. However
# This DLM_output function is easily demystified. Like all DLM_output 
# functions it has three arguments: x, Data and reps.
#
# The argument x is the position in the Data object. When real data
# are stored in a Data object, there is only one position - there 
# is only one real data set. 
#
# However in MSE we conduct many simulations and x refers to simulated
# data from simulation number x. 
#
# Any single parameters such as natural mortality rate (Mort) are a 
# vector (nsim long). See Data@Mort[x] in the DCAC code. 
#
# Any time series such as annual catches or relative abundance indices, 
# are a matrix of nsim rows and nyears columns.
# 
# A range of objects of class Data are available:

avail('Data')

# For simplicity lets use a Data object with just one simulation, 
# 'Simulation_1' and rename it 'Data'

Data<-Simulation_1

# Since there is only one simulation in this data set (1 position) we
# can now see a single value of natural mortality rate:

Data@Mort

# And a matrix of catches with only 1 row:

Data@Cat

# We could generate a single TAC recommendation from these data 
# using DCAC by specifying position 1 (there is only 1 simulation)
# and by setting reps=1 (we want a single mean DCAC TAC recommendation)

DCAC(x=1,Data,reps=1)

# If we wanted a stochastic estimate of the TAC we could increase
# the number of reps:

dev.off() #  reset plotting space
hist(DCAC(x=1,Data,reps=1000),xlab="TAC",ylab="Rel. Freq",col="blue")



# === Task 2: A constant catch MP ============================================
#
# We've now got a better idea of the anatomy of an MP. It is a function 
# that must accept three arguments:
# 
#  x: a simulation number 
#  Data: an object of class 'Data' 
#  reps: the MP can provide a sample of TACs 'reps' long. 
#
# Lets have a go at designing our own custom MP that can work with 
# DLMtool. We're going to try a '3rd highest catch' MP which was for
# a while an MP applied in the South Atlantic by US NOAA.
#
# We decide to call our function THC 

THC<-function(x, Data, reps){
  
  # Find the position of third highest catch
  
  THCpos<-order(DLM_data@Cat[x,],decreasing=T)[3]
  
  # Make this the mean TAC recommendation
  
  THCmu<-DLM_data@Cat[x,THCpos]
  
  # A sample of the THC is taken according to a fixed CV of 10% 
  
  trlnorm(reps, THCmu, 0.1) # this is a lognormal distribution
  
}

# To recap that's just five lines of code: 

THC<-function(x, DLM_data, reps){
  THCpos<-order(DLM_data@Cat[x,],decreasing=T)[3]
  THCmu<-DLM_data@Cat[x,THCpos]
  trlnorm(reps, THCmu, 0.1)
}

# We can quickly test our new MP for the example Data object

THC(x=1,Data,reps=10)

# Now that we know it works, to make the function compatible with 
# the DLMtool package we have to do three additional things:
#
# 1  assign it the correct class (allowing DLMtool to 'see' it)
#
# 2  assign it the correct environment (allowing DLMtool to use it)
#
# 3  export it to the cluster for parallel computing
#
# Our MP provides TAC advice so it is of class 'Output':

class(THC)<-"Output"

# It is going to be used by DLMtool functions:

environment(THC)<-asNamespace('DLMtool')

# The cluster must be able to use it also:

sfExport("THC")

# In this R session, THC is now a part of DLMtool 

# Q2.1  Run an MSE that include several MPs including THC
#
# Q2.2  Plot the results of the MSE, how does THC compare?
#
# Q2.3  Conduct VOI analysis for THC, what observation
#       processes affect THC performance?
#
# Q2.4  What operating model conditions affected THC performance?



# === Task 3: a more complex MP ============================================
#
# The THC MP is simple and frankly not a great performer (depending
# on depletion, life-history, adherence to TAC recommendations).
#
# Let's innovate and create a brand new MP that could suit a catch-
# data-only stock like Indian Ocean Longtail tuna!
#
# It may be possible to choose a single fleet and establish a
# catch rate that is 'reasonable' or 'fairly productive' relative
# to current catch rates. This could be for example, 40% of the 
# highest catch rate observed for this fleet or, for example,
# 150% of current cpue levels.
#
# It is straightforward to design an MP that will aim for this 
# target index level by making adjustments to the TAC.
#
# We will call this MP TCPUE, short for target catch per unit
# effort:

TCPUE<-function(x,Data,reps){
  
  mc<-0.05                             # max change in TAC 
  frac<-0.3                            # target index is 30% of max
  nyears<-length(Data@Ind[x,])         # number of years of data
  
  smoothI<-smooth.spline(Data@Ind[x,]) # smoothed index  
  targetI<-max(smoothI$y)*frac         # target 
  
  currentI<-mean(Data@Ind[x,(nyears-2):nyears]) # current index
  
  ratio<-currentI/targetI              # ratio currentI/targetI
  
  if(ratio < (1 - mc)) ratio <- 1 - mc # if currentI < targetI
  if(ratio > (1 + mc)) ratio <- 1 + mc # if currentI > targetI
 
  TAC <- Data@MPrec[x] * ratio * 
         trlnorm(reps, 1, Data@CV_Ind[x])

}


# The TCPUE function simply decreases the past TAC (stored in
# in Data@MPrec) if the index is lower than the target and
# increases the TAC if the index is higher than the target.
#
# All that is left is to make it compatible with DLMtool:

class(TCPUE)<-"Output"
environment(TCPUE)<-asNamespace('DLMtool')
sfExport("TCPUE")

# Q3.1 Run an MSE for TCPUE and THC (among other MPs) - how does
#      their performance compare?
#
# Q3.2 What observation processes and operating model conditions
#      is TCPUE vulnerable to?



# === Optional Tasks ====================================================

# Task 4: There are a number of operating model parameters that can 
#         seriously degrade the quality of the index data used by
#         MPs such as TCPUE. These include 'qinc', 'qcv' and 'betas'.
#
#         Use help documentation to learn the meaning of these slots
#         and find out which most strongly determine TCPUE performance. 

# Task 5: Make a version of TCPUE that allows for greater change in TACs
#         among recommendations (the mc parameter).
#
#         How does the level of mc affect performance?
     
# Task 6: Make a version of TCPUE that aims for a different fraction of 
#         maximum index (frac parameter).
#
#         How does the level of frac affect performance?



# === Advanced Tasks ====================================================

# Task 7: Design an MP that makes a TAC recommendation that is the 
#         average of the TACs of other MPs.

# Task 8: Wrap runMSE() in an optimizer and find the 'best' values of
#         frac and mc for a given operating model and performance
#         metric.


# ==================================================================================
# === End of Exercise 5b ===========================================================
# ==================================================================================


