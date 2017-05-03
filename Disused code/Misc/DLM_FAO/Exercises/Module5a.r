# ==============================================================================
# === DLMtool Exercise 5a: Advanced operating model specification ==============
# ==============================================================================
#
# In this Exercise we will look at some of the more advanced methods to specify 
# and modify an Operating Model. 
# 

 
# === Setup (only required if new R session) ===================================

library(DLMtool)  
setup()


# === Task 1 === Specifying historical effort trends  ==========================
#
# The trend in relative fishing effort in the historical years can be an 
# an important driver that determines the performance of different MPs.
# 

# Suppose that we know the fishery began 50 years ago, and fishing effort 
# increased slowly over the first decade, was relatively stable in the next two 
# decades at 1/4 of historical maximum, then increased dramatically over the 
# next 10 years.  We know that, while fishing effort stayed relatively constant 
# at this high level, there has been a general decline in fishing effort in 
# last 5 years down to about half of the historical high.

# This information can be included in the Operating Model by using the 
# 'ChooseEffort' function.  The 'ChooseEffort' function takes an existing 
# 'Fleet' object as its first argument, and allows the user to manually map out 
# the range for the historical trend in fishing effort.  The 'ChooseEffort' 
# function then returns the updated Fleet object.  

# Let's base our initial Fleet object on the 'Generic_fleet' object included in 
# DLMtool:

MyFleet <- Generic_fleet

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


# We can plot the bounds of the trends in relative fishing effort for both 
# the original and our updated Fleet objects:

par(mfrow=c(1,2), bty="l", las=1)
plot(c(0,Generic_fleet@nyears), c(0,1), type="n", xlab="Historical Years", 
    ylab="Relative fishing effort", main="Generic_fleet")
lines(Generic_fleet@EffYears*Generic_fleet@nyears, Generic_fleet@EffLower)
lines(Generic_fleet@EffYears*Generic_fleet@nyears, Generic_fleet@EffUpper)

plot(c(0,MyFleet@nyears), c(0,1), type="n", xlab="Years", ylab="", main="MyFleet")
lines(MyFleet@EffYears, MyFleet@EffLower)
lines(MyFleet@EffYears, MyFleet@EffUpper)

# You may notice that some of the slots in the 'MyFleet' object have been 
# updated. The 'EffLower', 'EffUpper', and 'EffYears' slots now contain the 
# bounds and year vertices that we mapped out using 'ChooseEffort':

MyFleet@EffLower
MyFleet@EffUpper

# Compare this to the original:

Generic_fleet@EffLower
Generic_fleet@EffUpper
Generic_fleet@EffYears

# This suggests that we can define the bounds on the historical fishing effort 
# by modifying the values in these slots.
 
# This can be useful for saving the values of the relative effort trajectories 
# which we mapped out using 'ChooseEffort'. For example, here we update the 
# relevant slots following the scenario outlined above: 

MyFleet@EffLower <- c(0, 0.2, 0.9, 0.9, 0.45)
MyFleet@EffUpper <- c(0, 0.25, 1, 1, 0.55)
MyFleet@EffYears <- c(1, 10, 21, 45, 50)


# We can see the difference in historical fishing effort when we plot the 
# two Fleet objects (you may need to expand the size of the plotting window):

plot(Generic_fleet, Albacore, 50)

plot(MyFleet, Albacore, 50)

# Note that we need to include a 'Stock' object when plotting a 'Fleet' object.
# We have also chosen to include 50 random samples so that we can see the 
# difference in the historical fishing effort more clearly.

# Does this different pattern of historical fishing effort have any impact on 
# the performance of the MPs?
# It is straightforward to answer this question by creating two operating models
# and running two MSEs.

# Specify the two OM objects (the only difference between the two is the 
# different historical fishing effort):

OM1 <- new("OM", Albacore, Generic_fleet, Generic_obs, Perfect_Imp, nsim=150)
OM2 <- new("OM", Albacore, MyFleet, Generic_obs, Perfect_Imp, nsim=150)

# Run the two MSEs using the different the two OMs:

MSE1 <- runMSE(OM1)
MSE2 <- runMSE(OM2)

# And finally, plot the results for each MSE:

NOAA_plot(MSE1)

NOAA_plot(MSE2)

# We can see that there is some difference in performance in some MPs and 
# less so with others. This speedy comparision of MSE results can be very useful 
# to determine the implications and importance alternative hypotheses or scenarios
# about the history of the fishery. It may be the case the trends in historical 
# fishing effort are controversial but the MSE results reveal that, the 
# performance of the MPs of interest are relatively unaffected by historical 
# effort. 

# Q1.1  Why does the 'curE' method (current effort) have a lower long-term 
#       yield and higher probablity of not overfishing in the second MSE?



# === Task 2 === Time varying selectivity  =====================================
#
# In many situations there have been changes in selectivity of the fishery 
# throughout the history of exploitation - either through the development of 
# different gears or changes to regulations.
#
# Suppose that we may knew there had been changes in the selectivity pattern 
# of the fishery over time. This information can be included in the Operating 
# Model by using the 'ChooseSelect' function.
#
# Like the 'ChooseEffort' function described above, the 'ChooseSelection'
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

# An interactive plot now appears where we must out the bounds for the length at 
# 5% selection (L5), the length at full selection (LFS), and the selectivity at 
# maximum length (Vmaxlen) for each year where selectivity has changed (here 
# 1968 [the first year], 1970, and 1990).

# Use the plot to map out some different selectivity curves for each year.

# Note that the first year (`FstYr`) must also be specified, and the 
# selectivity pattern is mapped for this year as well.

# When 'ChooseSelect' is used, the 'L5Lower', 'L5Upper', 'LFSLower', 'LFSUpper', 
# 'VmaxLower', 'VmaxUpper', and 'SelYears' slots are updated in the Fleet
# object. If these slots are populated, the values in the 'L5', 'LFS', and 
# 'Vmaxlen' slots are ignored in the operating model. 







# Similar to the 'ChooseEffort' function we can change the historical selectivity 
# by updating the relevant slots in the Fleet object. 

# For example, here we modify the time-varying selectivity slots for the three 
# years mentioned above with
#   - dome-shaped selectivity in the initial year
#   - change to non-dome shaped selectivity in third year of fishing
#   - increase in size of first capture in twenty second year of fishing

# First we specify the year indices for changes in selectivity:

MyFleet@SelYears <- c(1, 3, 22)

# Then we enter the lower and upper bounds for the length at 5% selection for 
# each of the year vertices:

MyFleet@L5Lower <- c(17.5, 20, 65)
MyFleet@L5Upper <- c(22.5, 25, 70)

# Next we enter the length at full selection for each of the year vertices:

MyFleet@LFSLower <- c(70, 75, 90)
MyFleet@LFSUpper <- c(77.5, 82.5, 95)

# Next we set the lower and upper bounds on the selectivity at maximum length,
# with dome-shaped selectivity in the first year, and asymptotic selectivity 
# after the 3rd year of fishing:

MyFleet@VmaxLower <- c(0.35, 0.95, 0.95)
MyFleet@VmaxUpper <- c(0.45, 1, 1)

# Finally we must indicate that the selectivity parameters are in absolute units
# (the same units as Linf used in the Stock object) and not the default option 
# of being relative to length of maturity:

MyFleet@isRel <- "FALSE"

# === Optional Task === Comparing MP performance ===============================
#
# If time allows you can create two new OM objects using the original and the 
# modified Fleet objects and run two MSEs to determine if this different pattern 
# of historical selectivity has any impact on the performance of the MPs





# === Task 3 === Preserving correlation among parameters =======================
#
# By default the MSE draws samples from a uniform distribution for each input 
# parameter. However, there are often cases where we may wish to preserve 
# correlation between different input parameters. A common example of 
# this is the von Bertalanffy growth parameters (Linf, K) which are often 
# found to be strongly correlated when estimated from growth data.  Furthermore,
# there is evidence that the natural mortality rate (M) is often correlated 
# with Linf and K.

# Let's create a OM object using the Sole Stock object, and the Generic_fleet,
# Generic_obs, Perfect_Imp, and 150 simulations:

OM <- new("OM", Sole, Generic_fleet, Generic_obs, Perfect_Imp, nsim=150)

# We can examine the interval for the von Bertalanffy growth parameters:

OM@Linf
OM@K 

# And natural mortality:

OM@M 

# By default, DLMtool will draw samples uniformly from within this range for 
# each parameter and assume that there is no correlation between them. 

# If we have information on the correlation structure between different input 
# parameters, it is possible include these correlations by adding them to the 
# 'cpars' slot in the OM object.

# At the moment the 'cpars' slot is an empty list, which indicates that there are 
# no custom parameters in this OM object 
 
OM@cpars 

# The 'ForceCor' function has been developed to determine typical correlations 
# among estimated parameters to generate realistic samples for natural mortality 
# rate (M), growth rate (K), average asymptotic length (Linf) and length at 50%
# maturity (L50).

# We can use this function to generate correlated samples of M, Linf, K, and L50:

CorOM <- ForceCor(OM)

# The 'ForceCor' function generates a plot which shows the original intervals
# for each parameter (blue shading) and the 150 correlated samples that were 
# generated (black dots) as well as the distribution of the samples for 
# each parameter (histograms).


# Note that the 'ForceCor' function returns an object of class OM. This is 
# identical to the original OM object that we provided it, with the exception
# that the 'cpars' slot is now populated with the correlated samples that were
# generated:

CorOM@cpars 

# We can display the names of the parameters in the 'cpars' slots:

names(CorOM@cpars)

# Note that the MSE will now ignore the parameters with these names in the 
# standard OM object, and use these correlated samples instead.


# We can now run a MSE both with and without the correlated samples and determine
# if it has a significant impact on the performance of the MPs:

MSE1 <- runMSE(OM)
MSE2 <- runMSE(CorOM)


NOAA_plot(MSE1)

NOAA_plot(MSE2)

# Based on this single plot it appears that in this case it appears that the 
# correlated growth and mortality parameters have had little impact on the 
# relative performance of the MPs.

# It is possible to include a range of other correlated parameters in the 'cpars'
# slot. We will examine this in more detail in the next two tasks.



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

StockRER <- new("Stock", "Exercises/Data/SRA/Stock_RER.csv")

StockRER@Name 

# This Stock object is based on the long-lived Rougheye Rockfish from British
# Columbia, Canada.

# Next we create an OM object. Here we are using Generic_fleet, Generic_obs, 
# Perfect_Imp, and 100 simulations:

OM <- new("OM", StockRER, Generic_fleet, Generic_obs, Perfect_Imp, nsim=100)

# To run the StochasticSRA analysis we need to import the CAA and Chist data, 
# and convert them to the correct format :

CAA <- as.matrix(read.csv("Exercises/Data/SRA/CAA.csv"))
Chist <- as.numeric(as.matrix(read.csv("Exercises/Data/SRA/Chist.csv")))

# And run the 'StochasticSRA' analysis (this may take some time):

OMSRA <- StochasticSRA(OM, CAA, Chist)

# The 'StochasticSRA' function has updated the 'cpars' slot with correlated 
# samples of several parameters including growth parameters, natural mortality, 
# selectivity parameters, recruitment deviations, and historical fishing effort:

names(OMSRA@cpars)

# We can examine some of the information contained in the 'cpars' slot by 
# plotting. For example, the estimated historical trends in fishing mortality:

matplot(t(OMSRA@cpars$Find), type="l")

# Or the correlation between fishing effort in the last historical year and 
# the current level of depletion:

plot(OMSRA@cpars$Find[,44], OMSRA@cpars$dep, xlab="Last year fishing effort", 
    ylab="Depletion")


# The OMSRA object with the correlated custom parameters derived from the 
# StochasticSRA analysis can then be used to run a MSE:

MSE <- runMSE(OMSRA)





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

OMSS <- SS2DLM(SSdir="Exercises/Data/SS/", Name="fromSS", nsim=100)

# Add a Implemention error object ?

OMSS@seed <- 1
plot(OMSS)

# The 'SS2DLM' function returns an object of class OM with the slots populated 
# from the MLE estimates in the SS3 model run:

# For example, the bounds of the natural mortality  

'cpars' slot 
# populated:

names(OMSS@cpars)

OMSS@M








# ==============================================================================
# === End of Exercise 5a =======================================================
# ==============================================================================





