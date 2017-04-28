## Exercise 3b: Plotting outputs (~ 30 minutes) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

## Task 1: Explore the MSE outputs using the plotting functions ####

# Optional: run a new MSE using a different Stock, Fleet, and Obs

# Trade-off plots 
Tplot(myMSE)
Tplot2(myMSE)
NOAA_plot(myMSE)
TradePlot(myMSE)

# Projection plots 
Pplot(myMSE)
Pplot2(myMSE)

# Kobe plot 
Kplot(myMSE)

# Other plots 
wormplot(myMSE)
barplot(myMSE)
boxplot(myMSE)
Jplot(myMSE)

# Questions: 



## Task 2: explore the Value of Information ####

VOI(myMSE)
VOI2(myMSE)


# Questions: 
# a) What Operating Model parameter is the AvC (Average Catch) method most sensitive to?
# b) Why do you think this is?
# c)


# Tasks Below are Optional #####

## More Advanced ####

##  Task 3: ####
# Many of the plotting functions have additional arguments to control various aspects 
# of the plots. Read the help documentation for a plotting function and use the 
# arguments to change (where applicable):
# a) the MPs that are plotted 
# b) the Performance Metrics that are used 
# c) the number of simulations that are plotted
# d) colors of lines and background
# e) anything else that can be controlled!


## Most Advanced ####
## Task 4: ####
# Create your own trade-off plot function for a MSE object (we might even add it to the package!)



