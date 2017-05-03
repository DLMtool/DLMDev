
# =====================================================================================
# === DLMtool Exercise 3a: Modifying operating models  ================================
# =====================================================================================
# 
# The operating models of DLMtool include a rather large number of slots. These 
# control the various aspects of the simulations and can be modified to match the 
# specific conditions of a given fishery.
#
# In this excercise you will learn more about DLMtool operating models and how
# to customize them for a given fishery case study. 



# === Setup (only required if new R session) =====================================

library(DLMtool)  
setup()



# === Task 1: Loading objects from .csv files ====================================
#
# One of the most tractable and easy-to-understand ways of populating 
# operating models is to load the Stock, Fleet, Obs and Imp objects from 
# .csv files.
#
# These are essentially excel tables in which have a row for each entry of 
# these objects. The good thing about using .csv files is that the file acts
# dated record of what was specified and they are easy to examine on most
# computers. 
#
# The data folder for this workshop contains examples of .csv files for stock, 
# fleet and observation models. 
#
# You can take a look at one of these "Data/Object_csvs/Bluefin_tuna.csv"
#
# To convert this .csv to a DLMtool object is relatively simple you just have
# to specify the location of the file:

Albacore<-new('Stock',"D:/DLM_FAO/Exercises/Data/CSV/Albacore.csv")

# Each fow of the csv is a slot in the stock object e.g natural mortality
# rate:

Albacore@M

# You can list all the slots in an object using 

slotNames(Albacore)

# And can find out more about what these slots represent by using the help
# documentation for objects of class Stock:

class?Stock

# In most cases these slots reflect the upper and lower bounds of a 
# random uniform distribution e.g. M sampled between 0.35 and 0.45
# 
# Don't worry, DLMtool allows you to specify any type of model for sampling
# operating model parameters and will preserve complex cross-correlations
# among these if you wish. We will cover these features in a later 
# exercise.
#
# Similarly to Stocks objects, Fleets, Obs and Imp objects can be read from
# csv files. E.g:

ICCATobs<-new('Obs',"D:/DLM_FAO/Exercises/Data/CSV/ICCATobs.csv")

Longline<-new('Fleet',"D:/DLM_FAO/Exercises/Data/CSV/Longline.csv")

Overages<-new('Imp',"D:/DLM_FAO/Exercises/Data/CSV/Overages.csv")



# === Task 2: Modify existing objects ============================================
#
# Probably the most commonly used approach to specifying DLMtool operating 
# models is to copy an existing object and change various aspects of it. 
# This ensures that there is a default entry for all required slots and that
# preliminary MSEs can therefore be run. 
#
# First, as a reference, create a new operating model with default settings 
# using Stock, Fleet, Obs and Imp objects:

myOM1 <- new("OM", Mackerel, FlatE_HDom, Imprecise_Unbiased, Perfect_Imp)

# Run the MSE and store the results in an object MSE1:

MSE1 <- runMSE(myOM1)

# Now, for each of these objects, copy them and change some of their 
# attributes:

Mack2 <- Mackerel  

# Change the name of the Mackerel 

Mack2@Name <- "MackerelMod"  # Change the name of the stock 
Mack2@M <- c(0.2, 0.35)      # Higher natural mortality 
Mack2@D <- c(0.05, 0.3)      # More uncertaint level of current stock depletion 

# Now do the same with the 'Flat trend in effort - heavy dome-
# shaped selectivity' fleet type FlatE_HDom:

Fleet2 <- FlatE_HDom 
Fleet2@Name <- "Modified_Fleet" 
Fleet2@nyears <- 80          # Increase the number of historical fishery years
Fleet2@Esd <- c(0.1, 0.2)    # Less inter-annual variability in fishing effort
Fleet2@Vmaxlen <- c(0.7, 1)  # Increase vulnerability of large-sized individuals

# Using the plot command, compare the original and modified Objects:

plot(Mackerel, incVB=FALSE) 
plot(Mack2, incVB=FALSE)

plot(FlatE_HDom, Mackerel)
plot(Fleet2, Mack2)

# Create a new operating model from the modified Stock and fleet objects and 
# rerun the MSE storing the new MSE outputs in an object MSE2:

myOM2 <- new("OM", Mack2, Fleet2, Imprecise_Unbiased, Perfect_Imp)
MSE2 <- runMSE(myOM2)



# === Task 3 Compare MSE results for the default and modified operating models ====
#
# Now that two MSEs have been run it is instructive to compare results.
#
# Looking at the help documentation for NOAA_plot:

?NOAA_plot

# We can see an argument 'panel' which allows us to make plots in sequence
#
# That means that we can create a four panel plot (2 x 2) and visualize the 
# results of the two MSEs together

par(mfrow=c(2,2))
NOAA_plot(MSE1,panel=F)
mtext('Top row of panels is MSE1',3,outer=T,line=-1.5)
NOAA_plot(MSE2,panel=F)
mtext('Bottom row of panels is MSE2',1,outer=T,line=-1)


# Q3.1  How does absolute performance of the MPs differ between the two MSEs?
#
# Q3.2  How does the pattern in MP performance vary among the two MSEs?
#
# Q3.3  Are any MPs 'dominated' with respect to all metrics and can therefore
#       be discarded?
#
# Q3.4  What are the prevalent trade-offs - what compromises are managers
#       facing?



# === Optional tasks ============================================================

# Task 7: Modify the Perfect_Info observation error model to have 
# potentially high biases in reported catches. Similarly to above
# run a comparative MSE. 
#
# Q7  Which MPs are most affected by increasing biases in reported
#     catches?


# Task 8: Run two comparative MSEs for 2 observation error models,
# Imprecise_Biased and Precise_Unbiased. 
#
# Q8.1  What is the potential value of better quality data for the 
#       various MPs?
#
# Q8.2  Has data quality affected all MPs equally?


# Task 9: Create a new implementation error object and add catch
# overages. Compare MSE results for an operating model with 
# perfect implementation error. 


# === Advanced tasks ===========================================================

# Task 10: It is possible to prescribe operating model conditions 
# (historical simulation conditions) that are not possible. Find 
# a way to break runMSE()


# Task 11: Find out which operating model parameter is most 
# influential in determining the performance of all of the 
# MPs in the toolkit


# ==================================================================================
# === End of Exercise 3a ===========================================================
# ==================================================================================









