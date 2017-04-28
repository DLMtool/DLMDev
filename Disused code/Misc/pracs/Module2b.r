## Exercise 2b: A basic DLMtool run (~ 15 minutes) ####

# Task 1: Finding Alternative Stock, Fleet, Observation (Obs), ####
# and Implementation (Imp) Error objects
# Use the `avail` function to find the built-in Stock, Fleet, Obs, and Imp
# objects. How many of each object type are built into DLMtool?

avail("Stock")
avail("Fleet")
avail("Obs")
avail("Imp")

## Task 2: Building an Operating Model ####
# Use the `new` function to build a operating model with Stock: `Blue_shark`,
# Fleet: `IncE_NDom`, Obs: `Imprecise_Unbiased`, Imp:'Perfect_Imp' and write the OM
# object to a variable called `myOM`.

myOM <- new("OM", Blue_shark, IncE_Dom, Imprecise_Unbiased, Perfect_Imp)

## Task 3: Plot the Stock, Fleet, Obs, and Imp objects ####
plot(Blue_shark) # plot Stock 
plot(IncE_Dom, Blue_shark)  # plot Fleet (note need to include the Stock object)
plot(Imprecise_Unbiased) # plot Obs 
plot(Perfect_Imp) # plot Imp 

# Examine the `myOM` object using the `plot.OM` function.
plot(myOM)

## Task 4: Run a Quick MSE ####
# Use the `runMSE` function to run a MSE using the following command:

myMSE <- runMSE(myOM) # run MSE with 'myOM'

## Task 4: Examine the MSE ####
# Use the `Tplot` function to examine performance and trade-offs in the MSE using pre-specified performance metrics. 
Tplot(myMSE)

# Questions:
# a) Which MP would you select as the best performing based on this plot?
# b) Which MP is the worst performing and unlikely to be selected?

# Task 5: Examine the MSE object using other plotting functions.

Tplot2(myMSE)
NOAA_plot(myMSE)
Pplot(myMSE)

# Tip: you can use the `plotFun()` function to print out DLMtool functions for plotting MSE objects.
plotFun()


# Tasks Below are Optional #####

## More Advanced #####

## Task 6: Explore the built-in Operating Model Objects  ####

# Use the 'avail' function to find a built-in OM object and examine it using the plotting function 

# Run a MSE using the built-in OM object 


## Most Advanced ####

## Task 7: SOMETHING FIENDISH ####



