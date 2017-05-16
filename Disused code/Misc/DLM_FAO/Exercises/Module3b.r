
# =====================================================================================
# === DLMtool Exercise 3b: Selecting MPs and other MSE outputs ========================
# =====================================================================================
#
# So far, every MSE we have undertaken has used the default Management Procedures.
# There are 5 default MPs and they are:
#
# AvC:        TAC set to average historical catches
# DCAC:       TAC set to Depletion-Corrected Average Catch (MacCall 2009)
# FMSYref:    reference MP where TAC is FMSY x current biomass known perfectly
# curE:       TAE set to current effort levels
# matlenlim:  size limit where the selectivity matches maturity at length
#
# Close to 100 MPs are included in the current version of DLMtool. These include
# output (TAC) control MPs and input control MPs (TAE, spatial and size limit)
# 
# In the first half of this set of exercises we will select a greater range of
# MPs for MSE testing. 
# 
# In the second half of these exercises will we learn how
# to check for convergence in the performance of these MPs and how to diagnose
# which data are deriving performance for these MPs. 



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1 === Selecting MPs for MSE testing ===================================
#
# For previous classes of DLMtool objects we used the avail() function to find
# what objects were available. You can use the same approach for DLMtool 
# MPs that are split into output control MPs (that set TACs) and input control
# MPs that set TAE, size limits or spatial closures.
#
# Finding these and looking up the help documentation for these is simple:

avail('Output')
avail('Input')
?DD
?MRreal

# To run an MSE using your own MP selection you have to add an argument to
# the runMSE function that is just a vector of the MPs names you wish to test.

myMPs<-c("MCD","SBT1","DBSRA","DD","IT5",                  # Output controls
         "DDes","EtargetLopt","ItargetE1","MRreal","DTe40")# Input controls


MSE3<-runMSE(testOM,MPs=myMPs)

NOAA_plot(MSE3)


# Q1.1  Which MPs performed the best?
#
# Q1.2  Which MPs were dominated?
#
# Q1.3  Suppose that this MSE was for a fishery you are involved in - which
#       MP would you choose for management. NOTE, read the documentation 
#       for the MP to make sure it is feasible in your fishery. 
#
# Q1.4  In Q1.3 were there any MPs you would not choose because they were 
#       not feasible? Why were they not considered feasible?



# === Task 2: Checking covergence of performance ==============================
# 
# In all of the MSE runs so far, unbenownst to you, just 48 simulations 
# have been used to test the MPs. That doesn't sound like a lot, but 
# what number of simulations is sufficient? 
#
# In many studies an arbitrary number of 1000 simulations are used, 
# presumably because it 'sounds like quite a lot'. But of course this 
# might be wasted computation. 
#
# When anserwing the question 'what number of simulations is enough', 
# a more principled answer is enough that your performance metrics 
# don't change as more simulations are undertaken - that there is 
# convergence in performance.
# 
# DLMtool contains functions for checking convergence of MSE 
# performance metrics. Here you use the function Converge()
# to see whether typical performance metrics have stabilized with
# additional simlulations:

Converge(MSE3)

# Converge either produces 1 or 2 plots. Each has 5 panels that
# are some typical performance metrics.
#
# The first plot shows the mean performance of all MPs as simulations
# are added. The second plot just shows MPs for which performance was 
# not stable by the final simulation (in this case simulation 48). 
#
# Look at the first of the two plots with many lines, one for each MP.
#
# You may notice that in the first 20 simulations, the absolute 
# performance of the MPs changes a lot but in many cases the lines are
# quite parallel and the ranking of the MPs is stable long before
# absolute performance is stable. 
#
# This phenomenon occurs because DLMtool deliberately samples identical
# future conditions for all MPs. 
#
# Since all MPs share the same future and are often vulnerable to the 
# same changes in mean simulated conditions (e.g. if you sampled a 
# simulation with high future productivity it would benefit all MPs 
# similarly) the ranking stabalizes quickly even when absolute 
# performance does not. This simulation design ensure that correct 
# MP selection can occur with the mininum of simulations. 
# 
# In this check of convergence three MPs nominally failed to converge
# and are highlighted in the second plot (MCD, DBSRA and IT5). 
#
# To conduct more simulations you can change a slot in the operating
# model, nsim: 

testOM@nsim<-100

# You also have to change the random seed of the operating model so 
# that you get a new set of simulations (we want new simulations
# because we are about to use joinMSE(), see below)

testOM@seed<-2

# Now run the new MSE


myMPs<-c("MCD","DBSRA","DBSRA4010")# 

MSE4<-runMSE(testOM,MPs=myMPs)

Converge(MSE4)

# Now the x-axis runs to 100 and all MPs are deemed to have converged.
#
# Note that you can also 'glue' together MSE objects that have the same 
# operating model and MPs to get more simulations:

MSE5<-joinMSE(list(MSE3,MSE4))

Converge(MSE5)


#  Q2.1  Given that convergence never occurs exactly, what threshold
#        would be sufficient in your applications and why? 
#
#  Q2.2  Can you think of a more principled test of convergence than
#        the 'within 2%' criteria of Converge()?



# === Task 3: Value of information analysis =======================================
#
# In the MSE we are simulating data quality using the observation error 
# model (class Obs). For example some simulations may have biased catches 
# and imprecise catches. 
#
# Since for each of these simulations we also have performance metrics,
# we can track which observation processes are driving performance and
# to what extent. 
# 
# DLMtool includes a series of Value-Of-Information functions. Try this
# for our new MSE object MSE5:

VOI(MSE5,ncomp=3,maxrow=5)

# VOI produces a multipanel plot where each row corresponds to an MP and 
# each column is an observation variable. The VOI function automatically
# identifies those observation variables most strongly related to 
# performance and plots them in order of importance (left-most column 
# is the most strongly correlated). The color of the points reflects 
# the strength of the correlation. 


# Q3.1  The top-left panel of the second to last plot shows the most 
#       important observation variable for the MP MCD. This is the 
#       variable Dbias which is the simulated bias in estiamtes of 
#       current stock depletion. 
#       
#       What does the shape of this VOI curve tell you about the 
#       asymmetry in risk of underestimating stock level (Dbias < 1) 
#       versus overestimating stock level (Dbias > 1)
#
# Q3.2  Why is the row of VOI plots blank for the MP 'MRreal'? 
#
# Q3.3  If you were to use DBSRA for managing this case study, 
#       what is the relative importance of improving the accuracy of
#       depletion information (Dbias) as opposed to natural mortality
#       rate (Mbias)?



# === Task 4: Cost of current uncertainties =====================================
#
# Similarly to value of information analysis, the cost of current 
# uncertainties (CCU) looks at how performance is determined by the
# sampled conditions of the operating model. 
#
# In VOI analysis we are looking for how errors and biases in 
# observed data drive performance. In cost of current 
# uncertainties we ask how uncertainty in operating model parameters 
# relates to performance. In other words what aspects about a fishery
# do we need to know better to improve management performance? 
# 
# When we used the VOI function above we actually produced the CCU
# plots first. If you cycle back through the plots you can see them.
# They are the plots titled 'Operating model parameters:'


# Q4.1  Looking at the plot that shows CCU for DDes, EtargetLopt,
#       ItargetE1, MRreal and DTe40, which condition of the 
#       operating model is most strongly determining performance?
#
# Q4.2  Linfgrad is the mean gradient in maximum size (Linf). Can 
#       you explain why negative gradients in Linf lead to lower
#       yields?



# === Optional tasks ===========================================================

# Task 5: another way of conducting value of information analysis or
#         cost of current uncertainties analysis is to change one
#         operating model parameter at a time and re-run the MSE then
#         examine overall performance. E.g. do two MSEs one for high 
#         levels of Dbias and one with low levels of Dbias.
# 

# Q5.1   Do this alternative VOI / CCU method for a variable that was 
#        important in the examples above. Do the MSE results 
#        corroborate the result from the methods above that use a 
#        single MSE analysis?
#
# Q5.2   How is this alternative form of VOI analysis fundamentally
#        different (hint: would you still have picked the same MPs
#        in both of these MSEs)?



# ==================================================================================
# === End of Exercise 3b ===========================================================
# ==================================================================================



