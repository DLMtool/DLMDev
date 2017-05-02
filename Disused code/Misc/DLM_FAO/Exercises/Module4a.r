# ==============================================================================
# === DLMtool Exercise 4a: Processing data  ====================================
# ==============================================================================
#
# The DLMtool package comes with an object class 'Data' which standardizes the 
# format of fishery data allowing multiple management procedures (methods) to 
# be applied to the same data. 
#
# Also standardized is the way in which MPs access the data in a Data object. 
#
# This Data object - MP relationship serves as the foundation for much of the 
# remaining DLMtool functionality so it is important become familiar with it. 

# In this set of exercises we will explore the pre-defined example Data objects 
# in the DLMtool package. We will look at how to import a Data object from a CSV
# file, as well as how to create a Data object in R. We will also learn how to
# identify which Management Procedures can be applied to our fishery Data object.



# === Setup (only required if new R session) ===================================

library(DLMtool)  
setup()




# === Task 1 === Explore the example Data objects in DLMtool ===================
# DLMtool has a number of built-in example fishery Data objects. For previous 
# classes of DLMtool objects we used the avail() function to find what objects 
# were available. 
#
# We can do exactly the same thing for objects of class 'Data':

avail('Data')

# The 'avail' function tells us how many objects of class 'Data' are loaded into 
# the R session. Currently, the only Data objects that are loaded are those 
# example data sets that have been included in DLMtool. 
#
# We will explore some properties of these Data objects in this section. 
# In the next task we will look at importing a Data object from a CSV file. 
#

# We will look at the first pre-defined data object 'Atlantic_mackerel'. Just like
# with the other objects, we can use the 'slotNames' function to explore the Data
# object:

slotNames(Atlantic_mackerel)

# You can see from the documentation that the `Data` object contains many slots, 
# and a lot of information can be stored in this object, including biological 
# parameters, fishery statistics such as time-series of catch, and past 
# management recommendations.
# 

# We will look through the first few slots in the Data object.
#
# The first slot 'Name' unsurprisingly contains the Name of the Fishery Data:

Atlantic_mackerel@Name 

# The second slot 'Year' contains the years corresponding to the fishery data:

Atlantic_mackerel@Year 

# The third slot 'Cat' contains the total catch data, where the catches correspond
# to the years in the 'Year' slot:

Atlantic_mackerel@Cat 

# Similarly, the fourth slot 'Ind' contains the index of abundance. Like 'Cat' 
# the 'Ind' slot is the same length as 'Year':

Atlantic_mackerel@Ind 

# Just like for the other objects in DLMtool, we can access the documentation 
# for all of the slots in the `Data` class by typing:

class?Data



# === Task 2 === Import Data from a formatted .csv file ========================
#
# Perhaps the easiest way to get fishery data into DLMtool for non-R users is to 
# populate a .csv file in the correct format.
#
# A number of example .csv files are available in the DLMtool. These CSVs files 
# are located in the installation directory of the DLMtool library on your machine. 
# The exact location of the files will vary between operating systems and machines.

# Probably the easiest way to understand the formatting is to open an example, 
# e.g. Simulation_1.csv in Excel or Notepad.

# We can locate the example data files using the `DLMDataDir` function: 

DLMDataDir()

# Navigate to this directory on your machine to access the example CSV data files
# and open one of the files (e.g. Simulation_1.csv) in Excel.

# Each row represents a data input and a guide to their names can be found in 
# the documentation for the Data object. 
# 
# In this iteration of DLMtool the formatting of the data is rather inflexible and has 
# to be done quite carefully.
# 
# Here are some rules to ensure MP compatibility:
#
#  - Catches are in weight and are the same unit as absolute abundance estimates
#
#  - Time series of catches, effort and corresponding years are identical in length
#    and do not contain NA values
#
#  - CAL_bins are the breakpoints of the catch-at-length classes and must therefore
#    be a vector that is 1 element longer than the number of columns in the catch-
#    at length frequency data. 
#
#  - Normalize time series of relative abundance indices to have a mean of 1
#  

# In this exercise we will import a CSV file into our R session. We will use one 
# of the example CSV data files that are included in DLMtool. You will note that 
# these have identical names to the pre-defined Data objects in DLMtool.


# We will import the 'Cobia' data file. Just like the other objects that we've 
# covered so far, we create a new object of class Data with the 'new' function. 
# We must tell the 'new' function the location of the CSV data file that we want 
# to import. If this file is not located, a warning message will alert us that 
# a blank Data object has been created instead.

# We must first define the location of the CSV file that we wish to import. 
# Because we are importing an example CSV file from the DLMtool package, we can 
# use the 'DLMDataDir' function:

Dir <- DLMDataDir("Cobia")

# Next we use the 'new' function and include the location of the CSV file as the 
# second argument to the function:

CobiaData <- new("Data", Dir)

CobiaData@Name 

# Remember that 'Cobia' was an example Data object included in DLMtool? We can 
# compare our newly imported Data object ('CobiaData') to the 'Cobia' Data object 
# in DLMtool (they should be identical):

Cobia@Cat 
CobiaData@Cat


Cobia@Ind
CobiaData@Ind 

# We can open the 'Cobia.csv' data file on you machine (located in 'Dir') and 
# comfirm that all the data from the CSV file has been correctly imported into R

# In this exercise we have imported a specially formatted CSV data file as a Data 
# object into DLMtool. In this case we have used a CSV data file that has been 
# included as an example in DLMtool. We could also create our own .csv file 
# (ensuring that it is formatted correctly) and populate it with our own fishery
# data. We will look at this in more detail in the optional exercises below.


# === Task 3 === Visualize some of the data ====================================
# 
# After importing a Data object we may wish to visualize the data. A generic 
# function 'summary' is available to visualize the data in a `Data` object:

# Let's take a look at some of the data in the 'Cobia' object:

summary(Cobia)

# We can do the same for the 'Atlantic_mackerel' Data object:

summary(Atlantic_mackerel)

# We can see that the 'summary' function generates a plot showing the catch data,
# the index of relative abundance, and distributions of some the parameters that
# are included in the Data object (e.g., von Bertalanffy growth parameters, M, 
# and depletion).



# === Task 4 === Determining which MPs can be applied to the Data object =======
#
# Different Management Procedures (MPs) require different data sources. Depending
# on what data we have available in our data set, we may only be able to run a 
# subset of the MPs included in DLMtool.  
# 

# Three functions are available to help users know what MPs can be applied
# to a given Data object. 

# The 'Can' function will display all of the available MPs that are able to be 
# applied to the Data object. 
# For example, we can identify all of the MPs that can be applied to the 'Cobia'
# Data object (note the 'Can' function may take a few seconds to run):

Can(Cobia) 

# We can see that over 25 MPs can be applied to the Cobia data set. However, there 
# are almost 100 MPs included in DLMtool, and this result suggests that many MPs 
# cannot be applied to this data. 
#
# We can use the 'Cant' function to determine which MPs cannot be applied:

Cant(Cobia)

# The Cant function list all of the MPs that cannot be applied to the data set, 
# and provides a brief message why these methods failed.

# The final function 'Needed' can be used to identify which additional data are 
# required before the remaining MPs can be applied to the data object:

Needed(Cobia)

# The 'Needed' function returns a list of the MPs that cannot be applied to the 
# current data set, together with the names of the data slots that need to be 
# populated in order for it to be possible to apply these MPs.

# We can consult the documentation on the 'Data' object for more information on 
# each of these slots.

class?Data




# === Task 5 === Populating a `Data` Object in R ===============================
#
# Many fisheries analysts use R as a data-processing tool and may also have 
# fishery data available to them in an R session.
# 
# In this Section we generate a blank Data object and fill in some of the 
# data slots. 
#

# First we create a blank Data object named 'Madeup':

Madeup <- new('Data')                             #  Create a blank DLM object

# Next we will some of the slots with some made-up data:

Madeup@Name <- 'Madeup'                           #  Name it
Madeup@Cat <- matrix(20:11*rlnorm(10,0,0.2),nrow=1) #  Generate fake catch data
Madeup@Units <- "Million metric tonnes"           #  State units of catch
Madeup@AvC <- mean(Madeup@Cat)                    #  Average catches for time t (DCAC)
Madeup@t <- ncol(Madeup@Cat)                      #  No. yrs for Av. catch (DCAC)
Madeup@Dt <- 0.5                                  #  Depletion over time t (DCAC)
Madeup@Dep <- 0.5                                 #  Depletion relative to unfished 
Madeup@vbK <- 0.2                                 #  VB maximum growth rate
Madeup@vbt0 <- (-0.5)                             #  VB theoretical age at zero length
Madeup@vbLinf <- 200                              #  VB maximum length
Madeup@Mort <- 0.1                                #  Natural mortality rate
Madeup@Abun <- 200                                #  Current abundance
Madeup@FMSY_M <- 0.75                             #  Ratio of FMSY/M
Madeup@L50 <- 100                                 #  Length at 50% maturity
Madeup@L95 <- 120                                 #  Length at 95% maturity
Madeup@BMSY_B0 <- 0.35                            #  BMSY relative to unfished


# Note that in order to be compatible with Output and Input MPs, the
# object must have a position for each input. For vectors this it is OK to 
# use a single value (ie one position) as this is considered the first 
# position of a vector (of nsim long potentially). 
#
# However time-series data are matrices npositions (nsims rows) with columns
# matching the number of years of data. So in this case our made up catch
# data Madeup@Cat is assigned a matrix with only one row. Its annoying
# but if we don't do this DLMtool MPs will return an error when they look for
# row one of the matrix and they won't be listed with the Can() function
# and hence that data entry won't be compatible with DLMtool.


# Let's check what MPs can and cannot be applied to our fictional data set:

Can(Madeup)
Cant(Madeup)
Needed(Madeup)


# In this set of exercises we have examined the contents of the Data object class.
# We have also seen how to import Data objects from a specially formatted CSV 
# file, as well as created and populated our own Data object in R. Finally, we 
# used the 'Can', 'Cant', and 'Needed' functions to determine which MPs can be 
# applied to our data, which MPs cannot be applied, and what additional data is 
# required in order to run those MPs.
# 
# In the next set of exercises we will apply MPs to our Data objects, plot the 
# output of the MPs, and examine the sensitivity of the MPs to the different input 
# data. 

# If you have extra time and are looking for additional challenges you can 
# complete the optional exercises below. 

# === Optional tasks ===========================================================


# === Task 6 === Import a Data object from a CSV file ==========================
#
# Create a blank CSV data file and populate it your own data for a fishery that 
# you work with. Import the CSV file from the new location, and use the 'summary' function to 
# visualize your modified data. Use the 'Can', 'Cant', and 'Needed' functions to 
# determine which MPs can be run on your modified data set.


# === Task 7 === Determining which MPs can be applied to the Data object =======
# 
# Create a blank Data object and populate it with simulated data created 
# by runMSE (tip: use the argument 'Hist=TRUE' to only simulate historical data.) 
# Populate the Observation error slots in the Data object and visualize the data 
# object.


# ==============================================================================
# === End of Exercise 4a =======================================================
# ==============================================================================






