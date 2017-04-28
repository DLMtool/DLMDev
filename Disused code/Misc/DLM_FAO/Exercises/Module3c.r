## Exercise 3c: Custom performance metrics (~ 30 minutes) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

## Explore the MSE output using custom performance metrics ####

## Task 1: Create a new operating model with 200 simulations ####
OM <- new("OM", Albacore, Generic_fleet, Generic_obs, nsim=200)

# Choose some MPs to test in the MSE 
avail("Output") # list of built-in Output controls
avail("Input")  # list of built-in Input controls 

MPs <- c("AvC", "CC1", "DAAC", "DBSRA", "DD", "DCAC", "DepF", "DynF", "Fratio", "Islope1",
         "Itarget1", "DTe50", "ITe10", "matlenlim")

# Run the MSE 
MSE <- runMSE(OM, MPs)

slotNames(MSE) # Names of all the slots in the MSE object

## Task 2: Calculate the probability of biomass in final projection year being below BMSY for each MP ####
proyears <- MSE@proyears # number of projection years
nsim <- MSE@nsim # save out number of simulations (was set when we created OM)
B <- MSE@B_BMSY[,,proyears] # assign B/BMSY in final projection year to new variable 'B'
Bsum <- apply(B < 1, 2, sum) # calculate number of simulations where B < BMSY in last year 
pB <- Bsum/nsim * 100 # calculate proportion of simulations where B < BMSY and convert to percentage 

data.frame(MPs= MPs, P=pB) # Display the results as a table 

# Display projection plot and compare the results 
Pplot(MSE) 

# Note that we have only calculated the probability B<BMSY for the last projection year 


## Task 3: Calculate the average relative long-term yield for each MP ####
C <- MSE@C[,, (proyears-9):proyears] # write out catch for last 10 years of projection period

# We need to make the yield (C - catch) relative to a reference yield - highest expected yield fishing at a constant F
# Don't worry if the code looks confusing - this usually happens within the plotting or summary functions
refY <- array(MSE@OM$RefY, dim=c(nsim, MSE@nMPs, 10))
C <- C/refY # standardise catch 

avC <- apply(C, 2, mean) * 100 # calculate average relative yield for each MP and convert to percentage
avC <- round(avC, 2) # round to 2 places for convenience 

data.frame(MPs= MPs, P=pB, C=avC) # Display the results as a table 

# Tasks Below are Optional #####

## More Advanced ####

## Task 4: ####
# Create a scatter plot of probability B<BMSY versus average long-term yield (both calculated above)
# Label the points of the graph with the names of the MPs 

# Tip: you can use the 'plot' and 'text' functions

# Questions: 
# a) What patterns are shown in the plot?
# b) What are the implications for expected yield if there is a high probability that B<BMSY?  


# Task 4: Copy and modify the code from Task 1 to calculate the probability that 
#         the biomass in the final year is above 0.5BMSY and create summary plots 
#         of the performance metrics 



## Most Advanced Tasks ####
## Task 5: Calculate the average length of the catch for each MP ####

## Task 6: ####
# Calculate the probability that F is greater than FMSY for each MP (in last projection year)

## Task 7: ####
# Calculate average short-term yield (first 10 years) for each MP 

## Task 8: #### 
# Calculate the average inter-annual variability in yield for each MP 

## Task 9: ####
# Summarize all calculated performance metrics in a table, ordered by expected long-term yield 





