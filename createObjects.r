# 
# 

library(DLMtool)

localDir <- "C:/Users/Adrian/Documents/GitHub"


devpath <- file.path(localDir, "DLMDev")

pkgpath <- file.path(localDir, "DLMtool")
dataDir <- file.path(pkgpath, "data")

# Delete all files in DLMtool/data 
fls <- list.files(dataDir) 
file.remove(file.path(dataDir, fls))

# Create empty R files for roxygen code 
fileName <- "dataObjects.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', fileName)) # delete 
file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 

# Create Stock Objects 
createDataObjs("Stock")

# Create Fleet Objects 
createDataObjs("Fleet")

# Create Obs Objects 
createDataObjs("Obs")

# Create Feasibility 
createDataObjs("Fease")

# Create Data Objects 
createDataObjs("Data")

# Create Operating Model Objects 
createOMObject()

# Create Imp Objects 
createIMObject()

# Create MSE Objects 
createMSEObject()








