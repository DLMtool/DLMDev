
# ====================================================================================
# === DLMtool Exercise 2b: A basic DLMtool run =======================================
# ====================================================================================
#
# Is it possible, before applying management procedures (MPs) to real data, to 
# understand which are likely to perform the best, which should be avoided and 
# under what circumstances? 
#
# Is there a way to inform data collection in order to prioritize those data 
# sources that are most critical in determining performance? 
#
# What are the performance trade-offs of a particular management procedure?
#
# Management Strategy Evaluation aims to address these questions by embedding 
# the MPs in a closed-loop simulation, so called because the MP is linked to a
# simulated version of reality (the operating model) and management 
# recommendations feed back into the operating model allowing performance to be
# quantified, biases to be evaluated and value of information to be revealed.
#
# In this practical you construct an operating model by combining premade 
# Stock, Fleet, Observation and Implementation objects. 



# === Setup (only required if new R session) ====================================

library(DLMtool)  
setup()



# === Task 1: Finding premade objects for contructing operating models ==========
#
# DLMtool includes a number of premade objects that represent:
#
# stock types (Stock) e.g. depletion and life history
# fleet dynamics (Fleet) e.g. historical fishing pressure and selectivity 
# observation error (Obs) e.g. bias and error in historical catches
# implementation error (Imp) e.g. TAC overages
#
# This object-oriented framework is useful because it provides a template 
# for modifying operating models. For example you may want to borrow the 
# life-history characteristics of a similar species and change 
# certain parameters to suit a new stock.
#
# You can easily locate premade objects of these classes using the 
# availability function 'avail':

avail("Stock")
avail("Fleet")
avail("Obs")
avail("Imp")



# === Task 2: Building an Operating Model ======================================
#
# In DLMtool operating models can be created by 'glueing' together 
# component Stock, Fleet, Obs and Imp objects
#
# To build a new operating model use the new() function and combine the 
# following objects:
#
# Stock = Blue_shark
# Fleet = IncE_NDom
# Obs   = Imprecise_Unbiased
# Imp   = Perfect_Imp
#
# and assign the new OM object the name `myOM`.

myOM <- new("OM", Blue_shark, IncE_Dom, Imprecise_Unbiased, Perfect_Imp)



# === Task 3: Plot the Stock, Fleet, Obs, and Imp objects ======================
#
# You may now be wondering what kind of operating model you have just 
# built! 
#
# DLMtool has a number of plotting function for vizualizing the objects
# you have combined. This can be achieved using the generic command
# plot():

plot(Blue_shark)             # plot the Stock 
plot(IncE_Dom, Blue_shark)   # plot the Fleet dynamics
plot(Imprecise_Unbiased)     # plot Obs 
plot(Perfect_Imp)            # plot Imp 

# Alternatively you can do all of the above and a bit more if you apply
# the plot() function to your constructed operating model
windows()
plot(myOM)

# You may be now confused by a large number of plots that include
# names you do not understand. In most cases these plots refer to
# operating model parameters that are slots in the objects. You 
# can find out more about these objects and what the slots mean by using 
# the package documentation that comes built-in to DLMtool. 
#
# For example to learn more about objects of class Stock you can use 
# the questio nmark operator:

class?Stock



# === Task 4: Run a Quick MSE ===================================================
#
# Once an operating model is specified, an MSE can be run using the runMSE()
# function. There are lots of options for running an MSE, here we only 
# specify one argument, the operating model myOM and run the MSE with the 
# default settings:

myMSE <- runMSE(myOM) # run MSE with 'myOM'

# Similarly to objects, you can always find out more about DLMtool functions 
# like runMSE by using the question mark operator:

?runMSE



# === Task 5: Examine the MSE ===================================================
#
# DLMtool includes numerous ways to visualize the output of an MSE. Let's 
# take a look at a generic projection plot which shows what happened in 
# the MSE in terms of biomass and fishing rate, for each MP. 

Pplot(myMSE)

# Each column of this plot shows the simulated fishing rate relative to FMSY 
# and the biomass relative to BMSY for a different management procedure.
#
# In this MSE, 5 default MPs were evaluated over 50 projected years into 
# the future:
#
# AvC      Average historical catches are used as TAC
# DCAC     Depletion-Corrected Average Catch (MacCall 2009)
# FMSYref  Fishing at FMSY with perfect knowledge of current biomass
# curE     Fishing at current effort levels
#
# Pplot includes some aggregate performance metrics in the panels such as 
# the probabilty of overfishing (POF) and the magnitude of yield relative 
# to FMSY fishing.
#
# Similarly to objects and functions, you can learn about MPs using the 
# help documentation:

?DCAC


# Q5.1  Comment on the patterns in the projections for F/FMSY and B/BMSY
#
# Q5.2  What stands out about the biomass projections for AvC and DCAC?
#
# Q5.3  Can you guess why FMSYref projections are not perfectly on the
#       line at F/FMSY = 1?
#
# Q5.4  Excluding FMSYref, what MP would you chose for management and why?



# === Task 6: Investigate other MSE visualization options =======================
# 
# Other plotting options aim to aggregate the results of these 
# projections and summarize performance to more easily select 
# appropriate MPs.
#
# Here is the generic plot used by NOAA for stocks in the Caribbean and 
# Gulf of Mexico:

NOAA_plot(myMSE)

# For simplicity these trade-off plots are organized such that top-right
# is better and bottom left is worse. The NOAA_plot includes four 
# performance metrics:
#
# Probability of not overfishing (PNOF): the fraction of simulations where
#                                       F < FMSY
#
# Long term yield (LTY): the fraction of simulations obtaining more than
#                        50% of FMSY yield
#
# Probability of biomass over half BMSY: fraction of simulation where 
#                                       B > BMSY
#
# Probility Average Annual Variability in Yield (AAVY) was less than 15%


# Q6.1 In terms of Prob. of not overfishing and long term yield, are there
#      any MPs than can be excluded from consideration and why? 
#
# Q6.2 Describe the trade-off between probability of not overfishing and
#      long-term yield for matlenlim and DCAC
#
# Q6.3 Why do you think it might be better to phrase performance in terms
#      of the likelihood of exceeded a value, rather than the mean value
#      (e.g. Probability Yield over half FMSY yield rather than mean
#       yield)?



# === Task 7: Investigate other MSE visualization options ======================
# 
# There are many other MSE plots you can explore:
# 
# Tplot:     a generic trade-off plot
# Kplot:     a Kobe plot by MP
# Splot:     a Kobe plot by MP for the final projected year
# wormplot:  a rebuilding plot
# boxplot:   a boxplot showing the distributions of performance by MP


# Q7.1  Are there any of these plots that you find particularly useful?
#
# Q7.2  What additional diagnostics / outputs would be desirable in 
#       your management setting?
 

# TIP: You can use `plotFun()` to print out all theDLMtool functions that  
# plot MSE objects.

plotFun()



# === Optional Tasks =========================================================== 

# Task 8: Use the 'avail' function to find a built-in OM object
#         and examine it using the plotting function 

# Task 9: Run a MSE using the built-in OM object and summarize results

# Task 10: Compare the MSE results of butterfish and Rockfish Stock types 

# Task 11: Compare the MSE results of 2 or more Fleets types

# Task 12: Compare the MSE results of Perfect_Inf and Imprecise_Biased
#          observation models 



# === Advanced Tasks ===========================================================

# Task 13: Using the default Stock, Fleet and Obs objects, create an 
#          operating model where all MPs perform well

# Task 14: Using the default Stock, Fleet and Obs objects, create an 
#          operating model where all MPs perform badly



# ==================================================================================
# === End of Exercise 2b ===========================================================
# ==================================================================================

