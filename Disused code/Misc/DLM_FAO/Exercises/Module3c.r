
# =====================================================================================
# === DLMtool Exercise 3c: Custom performance analysis ================================
# =====================================================================================
#
# In the previous exercises you have used the runMSE() to conduct an MSE and 
# have stored your MSE runs in a series of objects (MSE1, MSE2, MSE3...). 
# 
# Using plotting techniques you have been able to vizualise the data stored in
# these MSE objects. 
#
# In this exercise you will find out more about where data are stored in 
# MSE objects which allows you to design your own performance metrics and
# conduct your own evalution of simulation conditions.
#
# Since we are dealing with R objects, data, arrays and such, this will be 
# one of the more 'programmy' of the exercises. Sorry! What's important
# however is that you know that these outputs exist, that they can be
# accessed and that you can come up with your own ways to interpret them.



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: Finding MSE data in an MSE object ==================================
# 
# First, lets create an example MSE object so that we can see what the
# MSE data look like.For a change, rather than build an operating model 
# from the component Stock, Fleet, Obs and Imp objects we are going to 
# search for a pre-built operating model (class OM).

avail('OM')

# Lets run an MSE for the default MPs using the Yellowfin tuna operating
# model:

SWO<-runMSE(Swordfish_OM)

# Similarly to other DLMtool objects you can find out more about MSE 
# objects like SWO using the built-in help documentation:

class?MSE

# Alternatively you can see a concise summary of names using:

slotNames(SWO)

# For example we can see that the MSE was run for 5 MPs

SWO@nMPs

# For a total of 50 projected years:

SWO@proyears

# and 48 simulations

SWO@nsim

# Two of the slots in an MSE object are tables containing the sampled
# observation error variables (biases, error in data) and the simulated 
# conditions of the operating models. You can get a glance at each of 
# these using the function head():

head(SWO@Obs)
head(SWO@OM)

# Let say you wanted to see what the distribution of sampled stock
# depletion levels (SSB today relative to SSB unfished) for the SWO 
# operating model looks like, you could use the R histogram function:

hist(SWO@OM$Depletion, col='blue')

# Here we can see the 48 simulations distributed between 30% and
# 65% of unfished spawning biomass (SSB0)
#
# Various time series data are also included in the MSE which are 
# specific to simulation, the MP that was used and the projected
# year. 
#
# For example the slot B_BMSY is the biomass relative to BMSY
# over the projection. If you wanted to plot this for a particular
# MP, say DCAC, you would first locate the MP number. The MSE
# object contains a record of the MPs that were run in the slot
# MPs:

SWO@MPs

# Here we can see that DCAC is the second MP of the 5 that were 
# run.
# 
# Looking at the help documentation we can see that the B_BMSY
# data are organised in order of simulation, MP and projected
# year. 
# 
# This is confirmed by checking the dimensions of the B_BMSY
# array:

dim(OM@B_BMSY)

# We can now extract the B/BMSY data for our particular MP
# DCAC (MP 2 of 5) and plot the trajectories:

DCAC_biomass<-SWO@B_BMSY[,2,]

DCAC_biomass<-t(DCAC_biomass) # transpose the matrix for plotting

matplot(DCAC_biomass,type='l')

# We can also superimpose a line representing the BMSY reference
# level

abline(h=1,col="#99999980",lwd=5,lty=2)

# Hopefully these examples are helping to illustrate why R is
# such a powerful environment for packaging something like
# DLMtool - the potential for customization is endless. 


# Q1.1  Try to produce a projection plot for F relative to FMSY
#       for the MP 'matlenlim' 



# === Task 2: Custom performance metrics ==================================
# 
# You may be irritated that so far your own idea of 'good 
# performance' has not been reflected in any of the existing
# MSE plots. 
#
# In this section we're going to interrogate the MSE object
# to make your own performance metrics.
# 
# For the purposes of this example you care about not dropping 
# below a depletion level of 80% BMSY and want high short-term
# economic yields (over the next 5 years).
#
# We've already seen the B_BMSY slot, we now have to summarize
# these data with respect to a reference level of 80%, 
# calculating the fraction, by MP, that dropped below this
# level. 
#
# Using the R function apply this is surprisingly easy:

P80<-apply(SWO@B_BMSY<0.8,2,sum)/(SWO@nsim*SWO@proyears)

# By MP (the second dimension of the B_BMSY array) we have 
# summed the instances where B_BMSY was less than 80%
# and divided them by the total number of simulations
# and projected years. This returns the fraction (interpreted 
# as a probability) of dropping below 80% of BMSY. 
#
# Since future catches are arranged in the same type of
# array:

dim(SWO@C)  # simulation x MP x projected year

# we can apply a similar apply funciton to calculate mean 
# expected yield over the first 5 years of the projection:

MY5<-apply(SWO@C[,,1:5],2,mean)

# The two custom performance metrics can now be plotted to 
# reveal the trade-off among MPs:

plot(P80,MY5,col='white',xlab="Prob. B < 0.8BMSY",
                         ylab="Expected Yield 5yr")

text(P80,MY5,SWO@MPs,col='blue')

# Its not a particularly attractive plotbut it reveals a
# clear trade-off between biological and economic metrics. 


# Q2.1 Produce a trade-off plot that reflects long-term 
#      economic interests (ie the last 5 years)
#
# Q2.2 How does the trade-off differ from the previous plot
#      that showed short term economic interests?
#
# Q2.3 Can you explain this difference and what does this 
#      mean in a hypothetical management situation?



# === Optional tasks ====================================================

# Task 3: do your own VOI analysis. What observation parameters
#         affected these new custom performance metrics?

# Task 4: organize your new performance metrics in a table and
#         save them to disk somewhere. See R help for two 
#         functions: cbind() and write.csv(). 



# === Advanced tasks ====================================================

# Task 5: reading the help documentation for VOI you realise that
#         you can send custom performance metrics to the VOI
#         function. Format your metrics correctly and use the 
#         standard VOI funciton to reveal VOI and CCU.


# Task 6: Calculate the average inter-annual variability in yield 
#         for each MP 



# ==================================================================================
# === End of Exercise 3c ===========================================================
# ==================================================================================





