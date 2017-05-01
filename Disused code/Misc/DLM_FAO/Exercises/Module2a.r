# ====================================================================================
# === DLMtool Exercise 2a: R script for installation and validating installation  ====
# ====================================================================================
#
# The aim of this exercise is to install the DLMtool package to your machine,
# load the package into R, and test that the package is working correctly on
# your machine.



# === Task 1: install R ========================================================
# 
# The statistical language that DLMtool is written in is R. It is the defacto 
# language for scientific analysis and includes a fantastic array of functions
# for data manipulation, analysis and graphing. It also has a centralized 
# repository for packages and a standardized system for providing help 
# documentation. 
#
# You can download and install the latest version of R using the following
# link:

#   https://cran.biotools.fr/bin/windows/base/R-3.4.0-win.exe

# Choose to install with default options.


# === Task 2: install RStudio ==================================================
# 
# To use R functions (like those included in DLMtool), you are going to be
# writing text into an R console. It follows that you need a text editor.
# The easiest to use is probably RStudio which is kept up to date and has
# plenty of flexibility.
#
# You can download and install the latest version of R using the following
# link:

#   https://download1.rstudio.org/RStudio-1.0.143.exe

# Choose to install with the default options. 


# === Task 3: Installing DLMtool from CRAN =====================================
#
# You will need to install the DLMtool package from the online repository. 
# Type the following command into the R console

install.packages("DLMtool")

# A pop-up window may ask you to select a CRAN mirror to use. Select the 'Cloud'
# option (first on the list) or find the mirror that is the closest geographical
# distance to your location.

# NOTE: You only need to do this step for the first time you are using DLMtool
# on your machine. However, if the DLMtool package is updated you will need to
# repeat this step to download the latest version.


# === Task 4: Loading the package ===============================================
#
# Load the DLMtool package into the R session using the code shown in Lecture
# 2a. A message should appear in the R console alerting you that some dependant
# packages have also been loaded.

library("DLMtool")


# === Task 5: Validating the installation =======================================
#
# Here we will make sure that the most recent version of DLMtool was installed 
# correctly and is working correctly.

# Check the version is correct and the most current (v4.1)

packageVersion("DLMtool")

# Make sure that you have access to the data of the package by examining a stock
# object named 'Albacore':

Albacore

# `Albacore` is a built-in example Stock object in DLMtool. The R console should 
# fill with parameters for the Albacore stock. You may need to scroll up to see 
# them all. If you get an error message instead of the stock object in the R 
# console, there is a problem with your DLMtool installation. 
# Repeat the steps above, and if it still doesn't work, ask for help! 


# === Task 6: Set up parallel processing ========================================
#
# A lot of DLMtool functionality is computationally intensive. DLMtool is 
# designed to be multi-threaded and use all of the computing power available.
# It is desirable to set this up before running DLMtool commands as it may 
# speed up processing time considerably, for example ~3 x faster on a quad-
# core computer. 

# to set up your computer to use all the processing cores available use the 
# `setup()` function. 

setup()

# A message should alert you that snowfall has initialized parallel execution
# on a number of CPUs. You are now ready to start using DLMtool.


# === Task 7: Do a comprehensive test of DLMtool functionality ==================
# 
# Probably the most complex thing you will do with DLMtool is run a
# Management Strategy Evaluation (MSE). The package automatically loads an 
# operating model object for testing this called 'testOM'. You can test the 
# MSE functionality using the runMSE function:

test<-runMSE(testOM)

# This should initiate a set of processing steps ending with the line
# "5/5 Running MSE for matlenlim".

# If you see this output you have successfully installed DLMtool and 
# are ready to run the other practicals in this series. Well done!



# ==================================================================================
# === End of Exercise ==============================================================
# ==================================================================================


