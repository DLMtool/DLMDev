## Exercise 4b: Calculating management advice (~ 40 minutes) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

## Task 1: Run available Output control MPs on the Data object ####
# Here we will run all available Output controls 
# Typically you would use MSE to select the MSE that best meets the 
# management objectives for the fishery

Data <- new("Data", DLMDataDir("Atlantic_mackerel"))
TACs <- TAC(Data) # Run all available Output controls 

# Plot the distribution of recommended TACs 
plot(TACs) 
boxplot(TACs)

# Questions: 
# a) What MP has the highest recommended TAC? 
# b) Does this suggest it is a good MP to manage the fishery?
# c) Why do you think the TAC recommendation varies so much between methods?


## Task 2: Run available Input control MPs ####
Inputs <- Input(Data)

Inputs # Display the recomendations from Input controls 

# The recommendations from Input control methods are not so easy to display visually 

# Questions: 

## Task 3: Run a sensitivity analysis on the TAC recomendations for some MPs ####
Sense(TACs, "DBSRA4010")

# Question: What data is DBSRA4010 most sensitive to? Given what you know about 
#           DBSRA4010 method (see the help file for details), does this result make 
#           sense?

Sense(TACs, "MCD")
Sense(TACs, "MCD4010")

# Question: How do these two methods differ? Is this difference visible in the 
#           sensitivity plot?

Sense(TACs, "SPMSY")
# Question: Is this method sensitive to the data? What are the implications 
#           of the wide, relatively flat distribution of recommended TACs?


# Tasks Below are Optional #####

## More Advanced ####

## Most Advanced ####