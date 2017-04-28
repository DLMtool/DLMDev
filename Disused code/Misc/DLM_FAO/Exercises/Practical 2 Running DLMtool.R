# =============  DLMtool Practical 2. Running DLMtool ======================================
# 
#
# ADD INTRO TEXT 



# = A === Installing DLMtool and validating installation  =================================
#
#
# - A1 --- Install the DLMtool package --------------------------------------
#
# Install the DLMtool package from the online repository (CRAN). 
#
# Type the following command into the R console (or use the point-and-click 
# option in RStudio):

install.packages("DLMtool")

# You only need to do this step for the first time you are using DLMtool on 
# your machine (or when a new version of DLMtool is released).

# - A2 --- Load the library -------------------------------------------------

library(DLMtool)

# - A3  --- Confirm version number ------------------------------------------
#
# Confirm the most recent version of DLMtool is installed:
#
packageVersion("DLMtool")


# - A4 --- Examine DLMtool objects ------------------------------------------
#
# `Albacore` is a built-in example Stock object in DLMtool.
# Type `Albacore` into the R console to dispaly the object:

Albacore 

# The R console should fill with parameters for the Albacore stock. You may 
# need to scroll up to see them all.

# - A5 --- Set up parallel processing ----------------------------------------
#
setup()

# - A6 --- Run a test MSE ----------------------------------------------------
#
testMSE <- runMSE() 

# Quick plot to check that MSE run was successful:
#
Tplot(testMSE)

# If a plot appears everything is working correctly and you are ready to start
# using DLMtool. 


# = B === A basic DLMtool run =============================================================
#
# A set of predefined Stock, Fleet, Observation and Implementation Error objects 
# are included in the DLMtool package.
# 
# - B1 --- Finding predefined objects: --------------------------------------
# 
# Use the `avail` function to find the built-in Stock, Fleet, Observation (Obs)
# and Implementation error (Imp) objects:
#
 
avail("Stock")
avail("Fleet")
avail("Obs")
avail("Imp")

# The Stock object contains slots that define ranges over which parameters of 
# the population dynamics model are sampled. 
#
# - B2 --- For example a range for natural mortality rate -------------------

Snapper@M

# So, in each simulation a value for natural mortality rate is sampled from a 
# uniform random distribution with between 0.07 and 0.11.
# 
# The Fleet object contains slots that define ranges over which parameters of 
# the fishing dynamics model are sampled. 
#
# - B3 --- For example: ----------------------------------------------------
# A range for the length at full selection relative to size of maturity:

Generic_fleet@LFS

# The Obs object contains parameters that control the precision and
# bias of observations of simulated properties.
#
# - B4 --- For example the imprecision of annual catch observations:

Imprecise_Biased@Cobs


# This is a range in imprecision expressed as a coefficient of variation, in 
# this case the standard deviation in log-normal error. A value per
# simulation is used to generate error across the time series of catches for
# each simulation. For example a low value of say 0.05 would produce 
# relatively precise catch observations across the time-series. 


# The Imp object contains parameters that control the degree of adherence to 
# management recommendations (Implementation error).
#
# - B5 --- For example the mean fraction of TAC taken (uniform distribution):

Perfect_Imp@TACFrac

REPLACE WITH A BETTER EXAMPLE 

# - B6 --- Help documentation is available for each of these classes e.g: ---

class?Stock


# - B7 --- Plotting the objects: --------------------------------------------
#
# Plot a 'Stock' object: (note there are multiple pages)
plot(Blue_shark)

# Plot a 'Fleet' object: (note that you must include a Stock object as well)
plot (IncE_Dom, Blue_shark)  

# Plot a Obs object:
plot(Imprecise_Biased)

# Plot a Imp object:
plot(Perfect_Imp)


# - B8 --- Build an operating model -----------------------------------------

sharkOM <- new("OM", Blue_shark, IncE_Dom, Imprecise_Unbiased, Perfect_Imp)

# The generic function new() is used to generate an object of class 'OM' 
# (operating model) which simply concatenates the chosen Stock, Fleet, Obs 
# and Imp classes. 
#
# Again, help documentation is available at the prompt ----------------------

class?OM


# - B9 --- Running an MSE ---------------------------------------------------
#
# There are two phases to the MSE of DLMtool. The first recreates the 
# historical fishery (up to the time 'now') and attempts to match user-
# specified characteristics such as stock depletion and gradient in recent 
# fishing mortality rate. 
#
# In the first phase MSY reference points are calculated for the particular
# conditions 'now' (ie the last year of the historical simulation).
#
# The second phase projects the operating model forward using a given MP to 
# provide management advice. At the end of the second phase, all sampled 
# parameters, stock trajectories, fishing rates, and other data are stored 
# in an object of class 'MSE'. 
#
# We will run an MSE for the sharkOM operating model specfied in the
# previous section. 
#


# The number of simulations (nsim) and the number of historical (nyears) and
# projection (proyears) years are parameters in the 'OM' object.
#
# In this first MSE we only undertake 48 simulations to limit computing time:
sharkOM@nsim

# We have a 50 year historical time-period:
sharkOM@nyears 

# And we project the stock for 50 years: 
sharkOM@proyears

# Run the MSE (update management advice every four years (interval=4)):
sharkMSE<- runMSE(sharkOM, interval=4)

# By default the runMSE function includes five MPs. This is sufficient for 
# an example MSE (to limit computing time in this practical). In other 
# situations you would specify all of the MPs that you want to test.


# A number of standard functions are available for visualizing the MSE 
# results.
#
# - B10 --- Trade-off plots --------------------------------------------------

Tplot(sharkMSE)

# In each plot, performance over all simulations is plotted with respect
# to mean yields, probability of overfishing (F>FMSY), probability of
# overfished status (B<BMSY) and probability of biomass being below half and 
# 10 percent of BMSY (P50, P10).  
#
# The y-axis in these plots is 'relative yield'. This is yield over last 
# five years of the projection divided by reference yield. Reference yield 
# is the maximum yield that could be obtained in the last five years of the 
# projection from a fixed fishing rate strategy (pseudo FMSY). 
#
# Numerically optimizing for reference yield provides a useful metric of
# how well a particular MP performed, standardized to the conditions of 
# the particular simulation (e.g. starting depletion, future productivity
# etc.) 
#
# 
# Q1   Assuming that these metrics represent all relative performance 
#      considerations for this example, are there any MPs we can rule out?
#
#

# Examples of other trade-off plots:
Tplot2(sharkMSE)
TradePlot(sharkMSE)
NOAA_plot(sharkMSE)

# = C === Optional extras =================================================================


# - C1 --- Compare the MSE results from two different Stock objects ---------
#
# Compare the MSE results of butterfish and Rockfish life histories 
# (all other conditions the same)


# Q2   
#
#


# - C2 --- Compare the MSE results from two different Fleet objects----------
#
# Compare the MSE results of 2 or more fleets (all other conditions the same)


# Q3   
#
#

# - C3 --- Compare the MSE results from two Obs object  ---------------------
#
# Compare the MSE results of Perfect_Inf and Imprecise_Biased observation models 

# Q4  
#
#


# - C4 --- Explore the pre-defined Operating Model Objects ------------------
#
# Use the 'avail' function to find a built-in OM object and examine it using 
# the plotting functions

avail("OM")

# - C5 --- Run a MSE using a pre-defined OM object --------------------------




# = D === Advanced ========================================================================

# - D1 --- Create an operating model where all MPs perform well -------------
#
# Using the predefined Stock, Fleet and Obs objects, create an operating model
# where all MPs perform well


# - D2 --- Create an operating model where all MPs perform badly ------------
#
# Using the predefined Stock, Fleet and Obs objects, create an operating model
# where all MPs perform badly



# ====== End of Practical 1 === NEXT: Practical 2, Modifying operating models =============
