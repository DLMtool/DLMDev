
library(DLMtool)


# Available Stock Objects 
avail("Stock")

Albacore


# Available Fleet Objects 
avail("Fleet")

Generic_Fleet


# Available Obs Objects 
avail("Obs")

Generic_Obs 


# Available Imp Objects 
avail("Imp")

Overages


# Import from CSV 
Albacore <- new("Stock", "../../Exercises/Data/CSV/Albacore.csv")

# changing input parameters
Albacore@M
Albacore@M <- c(0.3, 0.5)
Albacore@M

# Combine Objects into an Operating Model 
myOM <- new("OM", Albacore, Generic_Fleet, Generic_Obs, Overages)

slotNames(myOM)

# Plot the OM 
plot(myOM)

# Run an example MSE
myMSE <- runMSE(myOM, MPs = c('DCAC', 'DBSRA'))
Kplot(myMSE)


# Importing OM from Excel 
HakeOM <- XL2OM("../../Exercises/Data/Excel/Example_Chile_Hake")
slotNames(HakeOM)













