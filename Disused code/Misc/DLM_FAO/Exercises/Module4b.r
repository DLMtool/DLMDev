# ==================================================================================
# === DLMtool Exercise 4b: Calculating management advice  ==========================
# ==================================================================================
#
# In the previous set of exercises we learned how to import Data objects in 
# DLMtool, and how to identify which MPs could be applied to our data. 
#
# In this set of exercises we will learn how to apply MPs to our Data object, 
# visualize and report the resulting management advice, and explore the 
# sensitivity of the management advice to the imported data. 



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1 === Apply an Output control MPs to Data  ============================
#
# For this exercise we will use the 'Atlantic_mackerel' example data object that
# in included in DLMtool. If you have time you can repeat these analyses with a 
# data object that is based on a fishery that you work on.

# A wide range of management procedures are available in DLMtool that set 
# total allowable catches. These are MPs of class 'Output' and can be listed
# using:

avail("Output")

# Suppose we wish to apply the 'Fratio' method to our data. We can first we use 
# the 'Can' function to determine if the 'Fratio' method can be applied to our 
# data object:

Can(Atlantic_mackerel)

# 'Fratio' is included in the output of the 'Can' function so we know that there
# are sufficient data.  
#
# Just like all the other functions in DLMtool, we can access the help file for 
# the 'Fratio' method by typing:

?Fratio

# We can use this same format to look at the help file for any MP in DLMtool.
#
# We can also inspect the code for an MP by typing the MP name in the R console:

Fratio

# The F ratio MP provdes a TAC recommendation that is the product of an 
# estimate of natural mortality rate (slot Mort) by an estimate of the ratio 
# of FMSY to M (slot FMSY_M) and current abundance (slot Abun). 
#
# For now ignore the line starting 'depends'. 
#
# You can probably see the the function trlnorm(). This takes nreps samples 
# from a lognormal distribution with a mean and CV; trlnorm(nreps, mean, CV).
#
# TACfilter() is a function that prevents TAC recommendations from being 
# below zero and removes outlier TAC samples greater than 5 standard 
# deviations from the mean. 
#
# All Output MPs can provide stochastic estimates of the TAC and therefore
# reps generally has to be quite large (e.g. reps=300) to provide 
# stable mean TAC recommendations.  
#
# Because both Data objects and Output methods are standardized, 
# all Output methods can be applied to all Data objects (though they may not 
# return a numeric value if insufficient data exists). 
#
# We can apply the 'Fratio' method to our data object:

Fratio(x=1, Atlantic_mackerel, reps=10)

# The first argument for all Management Procedure functions is `x`, which is the
# position in the `Data` object.  
#
# In MSE simulations there are many positions one for each simulation.During MSE 
# the value of `x` goes from 1 to the total number of simulations (`nsim`). 
#
# This means that it is easy to apply the same MP function simultaneously to many 
# different simulated data sets.
#
# However, when we are applying an MP to our actual fishery data we only have one 
# data set, and thus one position in the Data object. Therefore, when applying 
# an MP to our fishery Data object we must specify that 'x=1' as the first argument.
#
# The second argument to the 'Fratio' function is the Data object, in this case 
# the 'Atlantic_mackerel' data set.  The third argument 'reps=10' specifies that
# we wish to obtain 10 samples of the TAC recomendation.
#
# We could repeat the application of this MP with a larger number of samples by 
# increasing the value of the 'reps' argument:

TACs <- Fratio(x=1, Atlantic_mackerel, reps=10000)

# We have now generated 10,000 samples of the TAC recommendations from the Fratio
# method. We can plot the resulting distribution using the 'hist' function:

hist(TACs, col='gray', main="Distribution of recommended TAC", 
     xlab=paste0("TAC (", Atlantic_mackerel@Units, ")"))



# === Task 2 === Apply all Output control MPs to Data  =========================
# 
# In the previous exercise we applied a single MP to our Data object. It is also
# possible to apply several, or all available, Output control MPs to a Data object.
# 
# Typically you would use MSE to identify the MP (or perhaps MPs) that best meet 
# the management objectives for your fishery, and exclude those that are poor 
# candidates for management.
#
# In this example we will apply all the Output control MPs that can be applied 
# to our data set. 
#
# To do this we need to use the 'TAC' function. 
#
# We can see from the help documentation that the TAC function takes several 
# arguments:

?TAC

# The first argument refers to the Data object, which must be specified for the 
# function to work.
#
# The second argument is optional, and is a list of MP names to apply to the Data 
# object. If this argument is not specified, the TAC function will apply all available
# Output control methods to the data object. This is what we will do in this 
# exercise:

TACs <- TAC(Atlantic_mackerel)  

# Note that the output of TAC is the same DLM_data object but with the TAC slot
# (the stochastic TAC samples) and MPs (the MPs that were used) now filled:

class(TACs)

# The 'TAC' slot now contains a matrix 100 rows x nMPs columns. 100 samples 
# (reps=100 in call to TAC above) of the recommended TAC for each of the MPs 
# that we ran:

TACs@TAC 

# The TAC function not only stored the TAC values in the slot @TAC but 
# also kept track of the MPs that were applied in the @MPs slot:

TACs@MPs

# We can plot the distribution of the recommended TAC for each method using the 
# either the 'plot' function in DLMtool:

plot(TACs)

# or the 'boxplot' function:

boxplot(TACs)

# Q2.1  Which MP has the highest recommended TAC?
#
# Q2.2  Does this result suggest this may be a good MP to manage this fishery?
#       Why or why not?
#
# Q2.3  Why do you think the TAC recommendations vary so much between the 
#       different MPs?
# 
# Q2.4  Why does the recommended TAC have a broad distribution for some MPs and 
#       narrow for others?



# === Task 3 === Apply all possible Input control MPs to Data  =================
#
# In the previous two exercises we applied Output controls to our Data object.
# Here we will look at applying Input controls. In this exercise we will learn 
# how to apply several Input MPs to the same data set.
#
# We could also follow the same steps outlined in Task 1 to apply a single Input 
# control MP to our data. 
#
# The first thing we will do is populate the 'MPeff' slot in our Data object:

Atlantic_mackerel@MPeff <- 1

# The purpose of this slot is to set the current level of fishing effort. Which
# by assigning a 1, we set to be in units of todays effort. 
#
# To run the Input control MPs we can use the 'Input' function:

Input(Atlantic_mackerel)

# The Input function returns a matrix with the MP names, and the recommendations
# from each MP. 
#
# We will cover the details of the Input control methods in more detail in the 
# next module where we look at developing our own methods. 
#
# The main thing to that this table shows us that 15 Input control MPs were 
# applied to our data, and the Input control methods return recommendations in 
# terms of Effort control, Spatial allocation, and size-selection regulations. 
#
# For example, the 'curE75' method recommends Effort is reduced to 75% of the 
# current level, while size-selection remains unchanged (selectivity parameters 
# = NA). The 'DDe' and 'DDe75' methods recommend a large decrease in fishing
# effort down to 1% of the current level. The 'DTe40' and 'DTe50' MPs recommend 
# a 10% reduction in fishing effort.
#
# The 'matlenlim', 'matlenlim2', 'minlenLopt1' and 'slotlim' methods all recommend
# changes to the size-selection curve, while leaving the other fishing effort and 
# spatial distribution unchanged. 
#
# Remember, you can access the help documentation for any MP by typing a question
# mark followed by the function name, e.g.,:

?DTe40

# Similarly, you can print out the function code by typing the function name 
# in the R console:

DTe40 



# === Task 4 === Run a sensitivity analysis on the TAC recomendations ==========
#
# For any MP applied to a Data object a generic sensivity function is 
# available that detects what inputs are applicable and then tests the
# sensitivity of TAC estimates to each input in turn.
#
# For example, suppose we wish to examine the sensitivity of the DCAC 
# MP for our Atlantic_mackerel Data object. We can use the 'Sense' function:

Atlantic_mackerel <- Sense(Atlantic_mackerel, "DCAC")

# The 'Sense' function writes the output back to the 'Atlantic_mackerel' Data 
# object, and produces a plot showing the sensitivity of the TAC recommendations 
# to the different data inputs.
#
# The variation assigned to each input determines the range of values over
# which sensitivity is evaluated. In this way the sensitivity test is 
# standardized to be commensurate with the uncertainty we ascribed to 
# each parameter. 
#
# In this case we can see that mean TAC recommendations from DCAC are 
# fairly linearly related to the level of depletion (slot Dt) over which
# sensitivity was tested.
#
# They do not however appear to tend to zero when depletion is close to 
# zero. We will examine this further by doing our own custom sensitivty
# test in later (optional) sections of this module. 
#
# We can repeat the sensitivity analysis for other MPs:

Atlantic_mackerel <- Sense(Atlantic_mackerel, "DCAC4010")

# Q4.1  What data is DCAC4010 most sensitive to? 
#
# Q4.2  How is the sensitivity of DCAC4010 different to DCAC and can you
#       explain this (see the help file for details)?

Atlantic_mackerel <- Sense(Atlantic_mackerel, "SPMSY")

# Q4.3  Is this method sensitive to the data? What are the implications 
#       of the wide, relatively flat distribution of recommended TACs for this 
#       method?




# === Optional tasks ===========================================================
#
# If there is enough time you can continue to explore the sensitivity of MPs 
# to different input parameters using some more advanced features of DLMtool.
#

# === Task 5 === Examine sensitivity of MP to input parameter ==================

# First we will create multiple positions in our Data objet using the 'replic8'
# function:

newMack <- replic8(Atlantic_mackerel,50)

# replic8() produces multiple positions in a DLM_data object that have 
# the same data allowing the user to evalute the effect on TACs of inputs 
# varying input levels in isolation. In this case we've created a new
# DLM_data object with 50 positions each identical to the 
# Atlantic_mackerel object.
#

# Lets delve further into this issue in which DCAC provides TAC values 
# that tend to some positive value as stock depletion tends to zero.
#

# We assign a sequence of depletion values to the @Dt slot:

newMack@Dt <- seq(0.001,0.5,length.out=50)

# Next we calculate TAC samples for all positions:

TACr <- sapply(1:50, DCAC, newMack, reps=200)

# Note that when you apply a method to more than one position (in this
# case 50 positions) you don't recieve a vector of TAC recommentations 
# reps long, you get a matrix of reps rows and 50 columns. 

# Finally, we plot TAC recommendations of DCAC against depletion:

dev.off()
plot(newMack@Dt, apply(TACr,2,mean,na.rm=T), type="l", ylim=c(0,9))

matplot(newMack@Dt,t(apply(TACr,2,quantile,p=c(0.05,0.5,0.95),na.rm=T)),type='l',
        ylim=c(0,13))

# These plots appear to confirm the findings of the first sensitivity
# analysis. 
#
# More advanced users may want to do their own sensitivity testing across
# more than one dimension at a time to do this you can also use the 
# replic8() function




# === Task 6 === Examine sensitivity of MP to two input parameters =============

# Create multiple identical positions in the Data object

dm <- 30
newMack <- replic8(Atlantic_mackerel,dm*dm)

# Create scenarios for depletion and natural mortality rate (Mort)

Dts <- seq(0.001, newMack@Dt[1]*2, length.out=dm)
Morts <- seq(newMack@Mort[1]/2, newMack@Mort[1]*2, length.out=dm)

scenarios <- expand.grid(Dts,Morts)

newMack@Dt <- scenarios[,1]
newMack@Mort <- scenarios[,2]

# Use parallel processing (sfSpply) to calculate TACs:

TACr <- sfSapply(1:(dm*dm),DCAC,newMack,reps=200)

# Note that when you apply a method to more than one position (in this
# case 1:(dm*dm) positions) you don't recieve a vector of TAC rec-
# ommentations reps long, you get a matrix of reps rows and (dm * dm) 
# columns:

dim(TACr)



# Calculate mean TAC for each scenario

muTACr <- apply(TACr, 2, mean, na.rm=T)

# Create a cntour plot of TAC sensitivity WRT Mort and Dt 

dev.off()
filled.contour(Dts, Morts, matrix(muTACr,nrow=dm),
               col=heat.colors(20), #levels=15,
               xlab="Dt (depletion over time t)", 
               ylab = "Mort (natural mortality rate over time t)",
               main="TAC sensitivity plot")

# Q6.1  What does this tell us about DCAC? 
#
# Q6.2  When would you recommend the use of DCAC? 
#


# ==============================================================================
# === End of Exercise 4b =======================================================
# ==============================================================================
