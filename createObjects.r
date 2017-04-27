
 
# Run this code to write files to DLMtool/data and create the 
# help manual files 

# Setup ----

# Set root directory 
localDir <- "C:/Users/Adrian/Documents/GitHub" 

library(DLMtool)

devpath <- file.path(localDir, "DLMDev")
source(file.path(devpath, "functions.r"))
pkgpath <- file.path(localDir, "DLMtool")
dataDir <- file.path(pkgpath, "data")

# Delete all files in DLMtool/data 
fls <- list.files(dataDir) 
file.remove(file.path(dataDir, fls))

# Create empty R files for roxygen code 
fileName <- "dataObjects.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', fileName)) # delete 
file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 

cat("# This file is automatically built by createObjects.r in DLMDev\n",
    "# Don't edit by hand!\n", 
	  "# \n\n", sep="", append=TRUE, 
    file=file.path(pkgpath, 'R/', fileName))  

# ---- Create Objects from CSVs ----

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


# ---- Create objects from Rdata files ---- 

# Create Imp Objects 
createIMObject()

# Create Operating Model Objects 
createOMObject()

# ---- Build OMs from existing CSVs ----

# GOM Stocks and Fleets 
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/GOM/Stock"))
fleets <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/GOM/Fleet"))
Source <- "http://sedarweb.org/sedar-49-assessment-process."
for (X in seq_along(stocks)) {
  Stock <- new("Stock", file.path(devpath, "OperatingModels/OMsToBuild/GOM/Stock", stocks[X]))
  ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), fleets))
  if (length(ind) == 1) {
    Fleet <- new("Fleet", file.path(devpath, "OperatingModels/OMsToBuild/GOM/Fleet", fleets[ind]))
  } 
  if (length(ind) > 1) stop("More than one fleet found!") 
  
  if (length(ind) < 1) Fleet <- Generic_fleet 
  
  createOM2(Stock, Fleet, Name="GOM", Source=Source)
}


# California 
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/California/Stock"))
fleets <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/California/Fleet"))
Source <- "CaliforniaHerring"
for (X in seq_along(stocks)) {
  Stock <- new("Stock", file.path(devpath, "OperatingModels/OMsToBuild/California/Stock", stocks[X]))
  ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), fleets))
  if (length(ind) == 1) {
    Fleet <- new("Fleet", file.path(devpath, "OperatingModels/OMsToBuild/California/Fleet", fleets[ind]))
  } 
  if (length(ind) > 1) stop("More than one fleet found!") 
  
  if (length(ind) < 1) Fleet <- Generic_fleet 
  
  createOM2(Stock, Fleet, Name="California", Source=Source)
}

# DFO 
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/DFO/Stock"))
fleets <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/DFO/Fleet"))
Source <- "DFO"
for (X in seq_along(stocks)) {
  Stock <- new("Stock", file.path(devpath, "OperatingModels/OMsToBuild/DFO/Stock", stocks[X]))
  ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), fleets))
  if (length(ind) == 1) {
    Fleet <- new("Fleet", file.path(devpath, "OperatingModels/OMsToBuild/DFO/Fleet", fleets[ind]))
  } 
  if (length(ind) > 1) stop("More than one fleet found!") 
  
  if (length(ind) < 1) Fleet <- Generic_fleet 
  
  createOM2(Stock, Fleet, Name="DFO", Source=Source)
}


# ---- Build OMs from SS ----

# SEDAR 31
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/SS/SEDAR 31"))

nsim <- 100
Source <- "SEDAR 31, 2014 update assessment"

for (x in seq_along(stocks))  
  createOM_SS(file.path(devpath, "OperatingModels/OMsToBuild/SS/SEDAR 31", stocks[x]), stocks[x], Source, nsim=nsim)


# ---- Build OMs from StochasticSRA ----

# BC 
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/StochasticSRA/BC"))

Dir <- file.path(devpath, "OperatingModels/OMsToBuild/StochasticSRA/BC", stocks[1])
setup()
nsim <- 100 
for (x in seq_along(stocks))  
  createOM_SRA(file.path(devpath, "OperatingModels/OMsToBuild/StochasticSRA/BC", stocks[x]), nsim=nsim)


# ---- Build OMs from Scripts ----
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/Scripts"))

for (x in seq_along(stocks)) {
  source(file.path(file.path(devpath, "OperatingModels/OMsToBuild/Scripts"), stocks[x], "Script.R"))
  Name <- strsplit(strsplit(OM@Name, ":")[[1]][2], "Fleet")[[1]]
  Name <- paste0(gsub('([[:punct:]])|\\s+','_',Name), "OM")
  assign(Name, OM)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("\nSaving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(OM)
  cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss,
      "\n#'  ", OM@Source,
      "\n#' \n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', fileName))   
}
  
# ---- Build OMs from iSCAM ----
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/iSCAM"))

for (x in seq_along(stocks)) {
  dir <- file.path(file.path(devpath, "OperatingModels/OMsToBuild/iSCAM"), stocks[x])
  Name <- stocks[x]
  temp <- iSCAM2DLM(dir, nsim=100)
  Name <- paste0(stocks[x], "_iSCAM")
  
  assign(Name, temp)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("\nSaving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(temp)
  cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss, " (built using iSCAM2DLM)",
      "\n#'  ", temp@Source,
      "\n#' \n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', fileName))   
  rm(temp)
}




# ---- Create MSE Objects ----
createMSEObject()
