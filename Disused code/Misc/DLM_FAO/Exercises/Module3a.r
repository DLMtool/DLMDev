
# ====================================================================================
# === DLMtool Exercise 3a: Modifying operating models  ===============================
# ====================================================================================
# 
# The operating models of DLMtool now include a rather large number of slots.  
# These control the various aspects of the simulations and can be modified to
# match the specific conditions of a given fishery.
#
# In this excercise you will learn more about DLMtool operating models and how
# to customize these for a given fishery case study. 



# === Setup (only required if new R session) ====================================

library(DLMtool)  
setup()



# === Task 1: Loading objects from .csv files ===================================
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

Albacore<-new('Stock',"C:/DLM_FAO/Data/csvs/Albacore.csv")

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

ICCATobs<-new('Obs',"C:/DLM_FAO/Data/csvs/ICCATobs.csv")

Longline<-new('Fleet',"C:/DLM_FAO/Data/csvs/Longline.csv")

Overages<-new('Imp',"C:/DLM_FAO/Data/csvs/Overages.csv")


# === Task 1: Modify exisiting objects ==========================================
#
# Probably the most common way of specifying a DLMtool operating model is to
# copy an existing object and change various aspects of it. This ensures that
# there is a default entry for all required slots and that preliminary MSEs
# can therefore be run. 
#
# First, create a new operating model with default settings using some other
# Stock, Fleet, Observation objects:

myOM2 <- new("OM", Mackerel, FlatE_HDom, Imprecise_Unbiased, Perfect_Imp)

# now run the MSE and store the results in an object MSE1

MSE1 <- runMSE(myOM2)

# Now, for each of these objects, copy them and change some of their 
# attributes:

Mack2 <- Mackerel  # create a copy of Mackerel stock 

# Change the name of the Mackerel 

Mack2@Name <- "MackerelMod" # Change the name of the stock 

Mack2@M <- c(0.2, 0.35) # Change bounds of natural mortality 

Mack2@D <- c(0.05, 0.3) # Change current level of depletion 


## Task 3: Modify the Fleet Object by copying and modifying the built-in ####
# Fleet object 

MyFleet <- FlatE_HDom # copy the FlatE_HDom fleet object 

MyFleet@Name <- "Modified_Fleet" # Change the name 

MyFleet@nyears <- 80 # Increase the number of historical years

MyFleet@Esd <- c(0.2, 0.35) # Modify the bounds on inter-annual variability in fishing effort

MyFleet@Vmaxlen <- c(0.7, 1) # Increase vulnerability of large-sized individuals

## Task 4: Compare the original and modified Stock and Fleet Objects ####
plot(Mackerel, incVB=FALSE) 
plot(Mack2, incVB=FALSE)

plot(FlatE_HDom, Mackerel)
plot(MyFleet, Mack2)

## Task 5: Run another MSE with the newly created Stock and Fleet Objects ####
# (same Observation and Implementation)
myOM3 <- new("OM", Mack2, MyFleet, Imprecise_Unbiased, Perfect_Imp)
MSE3 <- runMSE(myOM3)

## Task 6: Compare the two MSEs using the plotting functions ####
# e.g.,
Tplot(MSE2)
Tplot(MSE3)

# Explore and compare MSEs using other plotting functions 
plotFun()

# Questions:
# a) How does the performance of the MPs differ between the two MSEs?
# b) What is driving this difference in performance for the MPs?



# Optional extras #####

## Task 7: Modify the Observation object using the same method as above and ####
# compare the performance of different MPs 

# Steps: 
# a) Modify Obs object
myObs <- Imprecise_Unbiased

# b) Create OM 
# c) Run MSE 
# d) Plot MSE results and compare with other MSE results 

# Questions:
# a) Which MPs benefit the most from better data?


## More Advanced ####

## Task 8: Use the 'ChooseEffort' function to sketch out bounds on trends in ####
# historical fishing effort 

MyFleet <- ChooseEffort(MyFleet)

# Note that the bounds on historical effort have now changed in the Fleet object 
MyFleet@EffLower
MyFleet@EffUpper

plot(MyFleet, Mack2)


## Task 9: Use the 'ChooseSelect' function to specify historical changes in ####
# selectivity
MyFleet <- ChooseSelect(MyFleet, Mack2)

# Note that the selectivity parameters have now changed in the Fleet object 

MyFleet@L5Lower
MyFleet@L5Upper 
MyFleet@LFSLower
MyFleet@LFSUpper
MyFleet@SelYears 
MyFleet@AbsSelYears

plot(MyFleet, Mack2)


## Most Advanced ####

# Task 10: Create a Stock object with cyclical recruitment patterns (see DLMtool documentation) ####
# and plot the Stock object to show sampled recruitment deviations

# Questions:
# a) Do phase shifts in recruitment impact the performance of the MPs similarly?

# b) 




# ADVANCED

## Create a new implementaiton error object and add catch overages, compare results for testOM
 # which MPs are affected the most strongly

## It is possible to prescribe operating model conditions that are not biologically possible. Find a way to break runMSE()












