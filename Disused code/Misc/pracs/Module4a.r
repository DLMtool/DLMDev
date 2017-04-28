## Exercise 4a: Processing data (~ 30 minutes) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

# DLMtool has a number of example Data objects which can be used 
avail("Data") # available Data objects 

Can(Atlantic_mackerel) # example Can function on built-in data object 

## Task 1: Locate the example CSV Data files using the DLMDataDir() ####
DLMDataDir()
# Navigate to this directory on your machine and locate the CSV files 
# These are example CSVs that were used to build the Data objects in the DLMtool 


## Task 2: Load a data object from a CSV file ####
DatDir <- DLMDataDir("Atlantic_mackerel")
Data <- new("Data", DatDir)
Data@Name


Can(Data) # should be identical to line 6 above 

summary(Data) ## NEED TO ADD THIS 
plot(Data) # add switch - if TAC is present plot that 

## ADD MSG FOR CAN functions - sometimes take a while 


# Tasks Below are Optional #####

## More Advanced ####


## Task 3: ####
# Copy and modify the code from Task 2 to load the 'Cobia' Data object 
# and plot the Data object 

## Task 4: ####
# Find the lists of MPs that Can and Can't be run on the Data object

## Task 5: ####
# Find what additional Data is needed for the MPs that cannot be used


## Most Advanced ####

# Task 6: ####
# Create a blank Data object and populate it with simulated data created 
# by runMSE (tip: use the argument 'Hist=TRUE' to only simulate historical data.) 
# Populate the Observation error slots in the Data object and run all available MPs


