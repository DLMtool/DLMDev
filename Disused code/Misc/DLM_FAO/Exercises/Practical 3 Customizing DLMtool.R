# =============  DLMtool Practical 3. Customizing DLMtool =================================
# 
#
# ADD INTRO TEXT 

# = Prerequisites =========================================================================
#
# Initial set-up (only required if new R session)
#
library(DLMtool)  
setup() 

# = A=== Modifying Operating Models ======================================================
#

# - A1 --- Create a new OM and run MSE --------------------------------------
#

Mack <- new("OM", Mackerel, FlatE_HDom, Imprecise_Unbiased, Perfect_Imp)
MackMSE <- runMSE(Mack)


# - A2 --- Modify the Stock object ------------------------------------------
#
# First we create a copy of the pre-defined 'Mackerel' Stock object:

Mack2 <- Mackerel

# Then we modify some of the parameters by changing the values in the slots:
#
# Change the name of the stock
Mack2@Name <- "Mackerelish"  

# Change bounds of natural mortality 
Mack2@M <- c(0.2, 0.35) # 

# Change current level of depletion 
Mack2@D <- c(0.05, 0.3) 

# - A3 ---- Compare the original and modified Stock objects -----------------
# 
plot(Mackerel, incVB=FALSE) 
plot(Mack2, incVB=FALSE)


# - A4 --- Modify the Fleet object ------------------------------------------
#
# Now we will create a copy of the Fleet object (FlatE_HDom) and modify it 
# 

# Copy the FlatE_HDom fleet object:
MyFleet <- FlatE_HDom 

# Change the name:
MyFleet@Name <- "Non-Domed" 

# Increase the number of historical years:
MyFleet@nyears <- 80 

# Modify the bounds on inter-annual variability in fishing effort:
MyFleet@Esd <- c(0.2, 0.35)

# Increase vulnerability of large-sized individuals:
MyFleet@Vmaxlen <- c(0.99, 1) 

# - A5 --- Compare the original and modified Fleet objects ------------------
#

plot(FlatE_HDom, Mackerel)
plot(MyFleet, Mack2)


# - A6 --- Run another MSE with modified objects  ---------------------------
#

Mack2OM <- new("OM", Mack2, MyFleet, Imprecise_Unbiased, Perfect_Imp)
Mack2MSE <- runMSE(Mack2OM)


# - A7 --- Compare the MSEs -------------------------------------------------
#

Tplot(MackMSE)
Tplot(Mack2MSE)

# Questions:
# a) How does the performance of the MPs differ between the two MSEs?
# b) What is driving this difference in performance for the MPs?



# = B === Plotting the MSE output =========================================================
#

# - B1 --- Testing for convergence ------------------------------------------
#
Converge(Mack2MSE)

# Even though we only ran 48 simulations ....
# Usually would include many more ...


# - B2 --- Projection plots -------------------------------------------------
#

Pplot(Mack2MSE)

# Projection plots show the progression in F relative FMSY and B relative to
# BMSY over the 40 year proejction. Thse plots can be useful in diagnosing
# pathological MP behavior. 
#
# For example a quick look at the biomass projection for DCAC reveals that 
# all simulations starting below around 50% BMSY chronically decline. 
#

# - B3 --- Kobe plots -------------------------------------------------------
#

Kplot(Mack2MSE)

# Kobe plots show progression of a time series in the dimensions of B 
# relative to BMSY (x axis) and F relative to FMSY (y axis). The percentage
# of simulations ending in each quadrant is printed in the corners of the 
# plot. 


# - B4 --- Worm plots -------------------------------------------------------
#

wormplot(Mack2MSE)

# Wormplots show the likelihood of meeting biomass targets in future years
# For example, this plot shows the fraction of simulations in each year that
# are above 0.5BMSY for each MP. The green color indicates that biomass is above 
# 0.5BMSY in over 75% of the simulations. The red color shows the 
# years where less than 25% of the simulations were above 0.5BMSY.


# - B5 --- Other plots -------------------------------------------------------
#
# DLMtool includes a number of other functions for plotting MSE results.
# For example:
#

barplot(Mack2MSE)
boxplot(Mack2MSE)
Jplot(Mack2MSE)

# We will look at plotting MSE results in more detail when we cover developing 
# custom performance metrics in Section C.
#

# - B6 --- Value of Information plots ---------------------------------------
#

# ADD SOME DETAILS HERE 
VOI(Mack2MSE)

# Cost of current uncertainties 
VOI2(Mack2MSE) 




# = C === Custom performance metrics ======================================================
#
# We will run a MSE with an increased number of simulations and test a larger number
# of MPs. 
#
# We will then develop our own custom performance metrics and display these results
# in both tables and figures.
#

# - C1 --- Create a new operating model with 200 simulations ----------------
#
AlbOM <- new("OM", Albacore, Generic_fleet, Generic_obs, nsim=200)


# - C2 --- Choose some MPs to test in the MSE  ------------------------------
#

# 
# List of pre-defined Output controls:
avail("Output") 

# List of built-in Input controls 
#
avail("Input")  

# Remember, you can find help documentation for any function, for example:
#
?DCAC

# Define a list of MPs to test in the MSE:
#
MPs <- c("AvC", "CC1", "DAAC", "DBSRA", "DD", "DCAC", "DepF", "DynF", 
         "Fratio", "Islope1",  "Itarget1", "DTe50", "ITe10", "matlenlim")


# - C3 --- Run the MSE with the specified MPs -------------------------------
#
AlbMSE <- runMSE(AlbOM, MPs)

# This may take a few minutes to run because we have now included a greater 
# number of simulations, and are testing more MPs.
#

# - C4 --- Inspect the MSE object  ------------------------------------------
#
# First we will check that the MSE results have converged and are stable:
# 
Converge(AlbMSE)



# - C5 --- Calculate custom performance metrics -----------------------------
#
# Here we will calculate the probability of biomass in final projection year
# being below BMSY for each MP
#

# First we will create a variable  'B' that contains the ratio of B/BMSY for 
# the final projection year (proyears)

B <- AlbMSE@B_BMSY[,,AlbMSE@proyears] 

# Note that we have accessed the 'B_BMSY' slot in the 'AlbMSE' object. This 
# slot contains the values of B/BMSY for each simulation (200), MP (14), and
# each projection year (proyears = 50).
# 

# We can print the names of all the slots in the MSE objects by using the 
# 'slotNames' function:
#

slotNames(AlbMSE)

# We will look at the information contained in some of the other slots later
# in the exercise.
#

# We want to calculate the total number of simulations where biomass 
Bsum <- apply(B < 1, 2, sum) # calculate number of simulations where B < BMSY in last year 
pB <- Bsum/nsim * 100 # calculate proportion of simulations where B < BMSY and convert to percentage 

data.frame(MPs= MPs, P=pB) # Display the results as a table 

# Display projection plot and compare the results 
Pplot(MSE) 







