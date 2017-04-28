## Exercise 3a Modifying operating models (~ 1 hour) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

## Task 1: Create a new Operating Model object using a different Stock and ####
# Fleet and run another MSE 

myOM2 <- new("OM", Mackerel, FlatE_HDom, Imprecise_Unbiased, Perfect_Imp)

MSE2 <- runMSE(myOM2)

## Task 2: Modify the Stock Object by copying and modifying the built-in ####
# Stock object 

Mack2 <- Mackerel  # create a copy of Mackerel stock 

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



# Tasks Below are Optional #####

## Task 7: Modify the Observation object using the same method as above and ####
# compare the performance of different MPs 

# Steps: 
# a) Modify Obs object
myObs <- Imprecise_Unbiased

# b) Create OM 
# c) Run MSE 
# d) Plot MSE results and compare with other MSE results 

# Questions:
# a) What Observation parameters are most important for driving the performance 
#    of the DCAC method?

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
# a) Do phase shifts in recruitment impact the performance of the MPs?














