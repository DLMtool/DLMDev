
# ==============================================================================
# === DLMtool Exercise 4a: Advanced operating model specification ==============
# ==============================================================================
#
# In this Exercise we will look at some of the more advanced methods to specify 
# and modify an Operating Model.
#
# We will learn how to include historical trends in fishing effort and time-
# varying selectivity in the Operating Model. 
# 
# In many settings analysts wish to include include correlated parameters in the
# MSE. In this exercise you will learn how to do this and investigate the impact
# that correlated parameters have on the performance of MPs in the MSE.
# 
# Finally, we will look at methods condition the OM object on fishery data or
# the output from a stock assessment.
#
 


# === Setup (only required if new R session) ===================================

library(DLMtool)  
setup()



# === Task 1 === Specifying historical effort trends  ==========================
#
# The trend in historical fishing effort can be an important driver of MP
# performance.
# 
# Suppose that we know the fishery began 50 years ago, and fishing effort 
# increased slowly over the first decade, was relatively stable in the next two 
# decades at 1/4 of historical maximum, then increased dramatically over the 
# next 10 years.  
#
# We also know that while fishing effort stayed relatively constant 
# at this high level, there has been a general decline in fishing effort in 
# last 5 years down to about half of the historical high.
#
# This information can be included in the Operating Model by using the 
# 'ChooseEffort' function.  The 'ChooseEffort' function takes an existing 
# 'Fleet' object as its first argument, and allows the user to manually map out 
# the range for the historical trend in fishing effort.  The 'ChooseEffort' 
# function then returns the updated Fleet object.  
#
# Let's base our initial Fleet object on the 'Generic_fleet' object included in 
# DLMtool:

MyFleet <- Generic_Fleet

# Next we will use the 'ChooseEffort' function to map out the relative fishing 
# effort over the last 50 years. 
# Use the 'ChooseEffort' to map the trend in historical relative fishing effort 
# outlined in the above scenario. Take note to:
#   - make sure fishing effort is zero in the first year (Year 0)
#   - increase effort in first ten years to around 1/4 of maximum level
#   - then increase to maximum level within 10 years and remain relatively
#       constant until last 5 years where it declines to about 1/2 of 
#       historical maximum.
#   - include bounds on the fishing effort for each the year vertices 

MyFleet <- ChooseEffort(MyFleet)

# You may notice that some of the slots in the 'MyFleet' object have been 
# updated. The 'EffLower', 'EffUpper', and 'EffYears' slots now contain the 
# bounds and year vertices that we drew using 'ChooseEffort':

MyFleet@EffLower
MyFleet@EffUpper

# Compare this to the original:

Generic_Fleet@EffLower
Generic_Fleet@EffUpper
Generic_Fleet@EffYears

# Rather than drawing effort we could just modify these slot directly. E.g: 

MyFleet@EffLower <- c(0, 0.2, 0.9, 0.9, 0.45)
MyFleet@EffUpper <- c(0, 0.25, 1, 1, 0.55)
MyFleet@EffYears <- c(1, 10, 21, 45, 50)

# We can see the difference in historical fishing effort when we plot the 
# two Fleet objects (you may need to expand the size of the plotting window):

plot(Generic_Fleet, Albacore, 50)

plot(MyFleet, Albacore, 50)

# Note that we need to include a 'Stock' object when plotting a 'Fleet' object.
# We have also chosen to include 50 random samples so that we can see the 
# difference in the historical fishing effort more clearly.

# Does this different pattern of historical fishing effort have any impact on 
# the performance of the MPs?
#
# It is straightforward to answer this question by creating two operating models
# and running two MSEs.
#
# Specify the two OM objects (the only difference between the two is the 
# different historical fishing effort):

OM1 <- new("OM", Albacore, Generic_Fleet, Generic_Obs, Perfect_Imp, nsim=150)

OM2 <- new("OM", Albacore, MyFleet, Generic_Obs, Perfect_Imp, nsim=150)

# Run the two MSEs using the different the two OMs:

MSE1 <- runMSE(OM1)

MSE2 <- runMSE(OM2)

# And finally, plot the results for each MSE:

NOAA_plot(MSE1)

NOAA_plot(MSE2)

# We can see that there is some difference in performance in some MPs and 
# less so with others. 
#
# This rapid comparision of MSE results can be very useful in determining the
# implications and importance of alternative hypotheses or scenarios. 
#
# It may be the case the trends in historical fishing effort are controversial
# but the MSE results reveal that the performance of the MPs of interest are 
# relatively unaffected by historical effort. 

# Q1.1  Why does the 'curE' method (current effort) have a lower long-term 
#       yield and higher probablity of not overfishing in the second MSE?



# === Task 2 === Time varying selectivity  =====================================
#
# In many situations there have been changes in selectivity of the fishery 
# throughout the history of exploitation - either through the development of 
# different gears or changes to regulations.
#
# Suppose that we knew there had been changes in the selectivity pattern 
# of the fishery over time. This information can be included in the Operating 
# Model by using the 'ChooseSelect' function.
#
# Like the 'ChooseEffort' function described above, the 'ChooseSelect'
# function takes a Fleet object as the first argument, and returns an updated 
# Fleet object.
#
# Suppose that the fishery began in 1968, and the selectivity pattern changed 
# in 1970 and then again in 1990, perhaps because of changes in fishing 
# regulations.  These change points in the selectivity curve can be mapped by 
# the following command:

MyFleet <- ChooseSelect(MyFleet, Albacore, FstYr=1968, SelYears=c(1970, 1990))

# A message in the R console alerts us that we must input the last historical 
# year. This is used to calculate the number of historical years.
#
# Type the current year (2017 at time of writing) into the console and press 
# 'Enter'
#
# An interactive plot now appears where we must out the bounds for the length at 
# 5% selection (L5), the length at full selection (LFS), and the selectivity at 
# maximum length (Vmaxlen) for each year where selectivity has changed (here 
# 1968 [the first year], 1970, and 1990).
#
# Note that the two dashed vertical lines labelled 'L50' represent the range of
# values for length at 50% maturity. 
#
# Use the plot to map out some different selectivity curves for each year.
#
# When 'ChooseSelect' is used, the 'L5Lower', 'L5Upper', 'LFSLower', 'LFSUpper', 
# 'VmaxLower', 'VmaxUpper', and 'SelYears' slots are updated in the Fleet
# object. If these slots are populated, the values in the 'L5', 'LFS', and 
# 'Vmaxlen' slots are ignored in the operating model. 
#
# Similarly to the 'ChooseEffort' function we can change the historical 
# selectivity by updating the relevant slots in the Fleet object. 



# === Task 3 === Preserving correlation among parameters =======================
#
# By default the MSE draws samples from a uniform distribution for each input 
# parameter. However, there are often cases where we may wish to preserve 
# correlation between different input parameters. 
#
# A common example of this is correlation among the von Bertalanffy growth 
# parameters (Linf, K) which like the intercept and slope in linear regression
# analyis are often found to be strongly negatively correlated when estimated 
# from growth data. 
#
#
# Let's create a OM object using the Sole Stock object, and the Generic_fleet,
# Generic_obs, Perfect_Imp, and 150 simulations:

OM <- new("OM", Sole, Generic_Fleet, Generic_Obs, Perfect_Imp, nsim=150)

# We can examine the interval for the von Bertalanffy growth parameters:

OM@Linf
OM@K 

# And natural mortality:

OM@M 

# By default, DLMtool will draw samples uniformly from within this range for 
# each parameter and assume that there is no correlation between them. 
#
# If we have information on the correlation structure between different input 
# parameters, it is possible include sampled parameters that maintaing these 
# correlations by adding them to the 'cpars' (custom parameters) slot in the 
# OM object.
#
# At the moment the 'cpars' slot is an empty list, which indicates that there are 
# no custom parameters in this OM object 

OM@cpars 

# The 'ForceCor' function has been developed to force typical correlations 
# among estimated parameters to generate realistic samples for natural mortality 
# rate (M), growth rate (K), average asymptotic length (Linf) and length at 50%
# maturity (L50).
#
# We can use this function to generate correlated samples of M, Linf, K, and L50:

CorOM <- ForceCor(OM)

# The 'ForceCor' function generates a plot which shows the original intervals
# for each parameter (blue shading) and the 150 correlated samples that were 
# generated (black dots) as well as the distribution of the samples for 
# each parameter (histograms).
#
# Note that the 'ForceCor' function returns an object of class OM. This is 
# identical to the original OM object that we provided it, with the exception
# that the 'cpars' slot is now populated with the correlated samples that were
# generated:

CorOM@cpars 

# We can display the names of the parameters in the 'cpars' slots:

names(CorOM@cpars)

# Note that the MSE will now ignore the parameters with these names in the 
# standard OM object, and use these correlated samples instead.
#
# We can now run a MSE both with and without the correlated samples and determine
# if it has a significant impact on the performance of the MPs:

MSE1 <- runMSE(OM)

MSE2 <- runMSE(CorOM)

NOAA_plot(MSE1)

NOAA_plot(MSE2)

# Based on this single plot it appears that in this case the correlated growth
# and mortality parameters have had a small impact on the relative performance of
# the MPs. This is a fairly typical result, it doesn't however stop many 
# assessment scientists from insisting that correlated growth parameters are vital
# in determining the results of MSEs!
#
# It is possible to include a range of other correlated parameters in the 'cpars'
# slot. The DLMtool manuscript includes greater detail on this (in the Help folder)
# We will examine this in more detail in the next two tasks.



# === Task 4 === Conditioning OM by SRA ========================================
#
# Sometimes it is possible to use existing data to generate realistic samples of 
# operating model parameters. For example, if a time-series of catch-at-age (CAA)
# exists, together with a time-series of historical catches (Chist), it may be 
# possible to use a stock-reduction analysis (SRA) to determine a range of fishing
# mortality rates and estimates of depletion that correspond to these data.
#
# The 'StochasticSRA' function can be used to generate correlated samples of 
# stock depletion (D), selectivity parameters (L5, LFS) and historical fishing 
# effort. This function takes an OM object, together with CAA and Chist data and
# returns an OM object with the 'cpars' slot updated.

# A Stock object, CAA, and Chist data are provided in the Exercises/Data/SRA 
# directory.

# First we create a new Stock object by importing the CSV:

StockRER <- new("Stock", "D:/DLM_DFO/Exercises/Data/SRA/Stock_RER.csv")

StockRER@Name 

# This Stock object is based on the long-lived Rougheye Rockfish from British
# Columbia, Canada.
#
# Next we create an OM object. Here we are using Generic_fleet, Generic_obs 
# and Perfect_Imp:

OM <- new("OM", StockRER, Generic_Fleet, Generic_Obs, Perfect_Imp)

# To run the StochasticSRA analysis we need to import the CAA and Chist data, 
# and convert them to the correct format :

CAA <- as.matrix(read.csv("D:/DLM_DFO/Exercises/Data/SRA/CAA.csv"))
Chist <- as.numeric(as.matrix(read.csv("D:/DLM_DFO/Exercises/Data/SRA/Chist.csv")))

# And run the 'StochasticSRA' analysis (this may take some time):

OMSRA <- StochasticSRA(OM, CAA, Chist, nits = 2000)

# The 'StochasticSRA' function has updated the 'cpars' slot with correlated 
# samples of several parameters including growth parameters, natural mortality, 
# selectivity parameters, recruitment deviations, and historical fishing effort:

names(OMSRA@cpars)

# We can examine some of the information contained in the 'cpars' slot by 
# plotting. For example, the estimated historical trends in fishing mortality:

matplot(t(OMSRA@cpars$Find), type="l", ylab="Apical Fishing mortality rate")

# Or the correlation between fishing mortality rate in the last historical year
# and the current level of depletion:

plot(OMSRA@cpars$Find[,44], OMSRA@cpars$dep, xlab="Last year fishing rate", 
     ylab="Depletion")


# The OMSRA object with the correlated custom parameters derived from the 
# StochasticSRA analysis can then be used to run a MSE:

MSE <- runMSE(OMSRA)

# Q4.1  What is the difference in MSE results between rockfish OMs that 
#       include/exclude custom parameters (tip: you can use new('list') to
#       generate a blank list in @cpars) 



# === Task 5 === Conditioning OM by SS =========================================
#
# There may also be cases where stock assessment has been carried out and we wish 
# to use this information to populate our OM object. DLMtool includes a function
# 'SS2DLM' which reads in the files from a fitted SS3 model to populate the 
# various slots of an operating model with the MLE parameter estimates.
#
# Here we will look at an example from a SS3 model that has been fitted to 
# Yellowfin Tuna from the Indian Ocean:

# We use the 'SS2DLM' function, and specify:
#   - the location of the directory containing the SS3 files
#   - a name for the Name slot in the OM object 
#   - the number of simulations we wish to include 

SSout <- SS2DLM(SSdir = "D:/DLM_DFO/Exercises/Data/SS/", Name = "fromSS", nsim = 100)

# The 'SS2DLM' function returns an object of class OM with the slots populated 
# from the MLE estimates in the SS3 model run.

# For example, the range of the von Bertalanffy parameters:

SSout@Linf 
SSout@K 

# The 'SS2DLM' function also provides samples of some correlated parameters and
# populates the 'cpars' slots:

str(SSout@cpars)

# There are a couple of small issues with the OM object generated by SS2DLM 
# (these will be fixed in the next version of DLMtool). We need to do a little 
# bit of tweaking to make a valid OM object: 

Stock <- SubOM(SSout, "Stock")
Fleet <- SubOM(SSout, "Fleet")
Obs <- SubOM(SSout, "Obs")
Imp <- Perfect_Imp

SSOM <- new("OM", Stock, Fleet, Obs, Imp, nsim=SSout@nsim)
SSOM@hcv <- 0
SSOM@cpars <- SSout@cpars


# The SSOM variable is now a OM object populated with the parameters estimates
# and correlated parameters from the Ss3 output.

# We can examine the OM object generated from the SS output using the 'plot'
# function:

plot(SSOM)

# And we can run a MSE using the OM object created by 'SS2DLM':

MSE <- runMSE(SSOM)

NOAA_plot(MSE)


# Q5.1  Examine SSOM using the plot function. Are there any parts of the 
#       operating model that you think are too certain and do not reflect
#       credible ranges of uncertainty?


# ==============================================================================
# === End of Exercise 4a =======================================================
# ==============================================================================





