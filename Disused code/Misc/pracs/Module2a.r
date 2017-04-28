
## Exercise 2a: An R script for installation and validating installation (~ 10 minutes) ####


# The aim of this exercise is to install the DLMtool package to your machine,
# load the package into R, and test that the package is working correctly on
# your machine.

## Task 1: Installing DLMtool from CRAN ####
# First you need to install the DLMtool package from the online repository. 
# Type the following command into the R console, or use the point-and-click 
# option in RStudio:

install.packages("DLMtool")

# A pop-up window may ask you to select a CRAN mirror to use. Select the 'Cloud'
# option (first on the list) or find the mirror that is the closest geographical
# distance to your location.

# NOTE: You only need to do this step for the first time you are using DLMtool
# on your machine. However, if the DLMtool package is updated you will need to
# repeat this step to download the latest version.


## Task 2: Loading the package ####
# Load the DLMtool package into the R session using the code shown in Lecture
# 2a. A message should appear in the R console alerting you that some dependant
# packages have also been loaded.

library("DLMtool")

## Task 3: Validating the installation####
# Type `Albacore` into the R console. 

Albacore

# `Albacore` is a built-in example Stock object in DLMtool. The R console should 
# fill with parameters for the Albacore stock. You may need to scroll up to see 
# them all. If you get an error message instead of the stock object in the R 
# console, there is a problem with your DLMtool installation. 
# Repeat the steps above, and if it still doesn't work, cry for help! 

# Try several other Stock objects to confirm that they are loaded correctly.
# Use the command `avail("Stock")` to print out all of the available 
# example stock objects in DLMtool.

avail("Stock")

# Repeat this with several of the Fleet objects built into DLMtool 
avail("Fleet")

## Task 4: Set up parallel processing ####
# Use the `setup()` function to set up parallel processing on your machine. A
# message should alert you that snowfall has  initialized parallel execution
# on a number of CPUs. You are now ready to start using DLMtool.
setup()

