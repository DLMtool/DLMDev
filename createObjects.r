
 
# Run this code to write files to DLMtool/data and create the 
# help manual files 

# Set to root directory for DLMtool and DLMDev 
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

# Create Imp Objects 
createIMObject()

# Create Operating Model Objects 
createOMObject()

# Build OMs from existing CSVs

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


# Build OMs from SS 

# SEDAR 31
stocks <- list.files(file.path(devpath, "OperatingModels/OMsToBuild/SS/SEDAR 31"))

x <- 1 
nsim <- 100
Source <- "SEDAR 31, 2014 update assessment"
SSdir <- file.path(devpath, "OperatingModels/OMsToBuild/SS/SEDAR 31", stocks[x])
createOM_SS <- function(SSdir, Source=NULL, Author = "No author provided") {
  
  temp <- SS2DLM(SSdir, nsim, Name=stocks[x], Source=Source, Author=Author, fileName="dataObjects.r")
  

  Name <- temp@Name
  assign(Name, temp)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("Saving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 
  save(list=Name, file = path, compress = "bzip2")
     
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(OM)
     cat("#'  ", Name, " ", clss,
         "\n#'", 
         "\n#'  An object of class ", clss, "(from SS using SS2DLM)",
   	    "\n#'  ", temp@Source, "\n",
		"\n#' \n",
   	    '"', Name, '"\n\n\n', sep="", append=TRUE, 
   	    file=file.path(pkgpath, 'R/', fileName)) 
		
		

 grepl("SS2DLM", attributes(temp)$build)
  
  temp@Source
temp@Name
attributes(testOM)$build

}


#'  Red_Snapper_GOM OM
#'
#'  Gulf of Mexico Red Snapper (from SS using SS2DLM)(SEDAR 31, 2014 update assessment), an object of class OM
"Red_Snapper_GOM"




# Create MSE Objects 
createMSEObject()



#'  Yellowfin_Tuna_IO OM
#'
#'  Indian Ocean Yellowfin tuna, an object of class OM
#'
"Yellowfin_Tuna_IO"


#'  Red_Snapper_GOM OM
#'
#'  Gulf of Mexico Red Snapper (from SS using SS2DLM)(SEDAR 31, 2014 update assessment), an object of class OM
"Red_Snapper_GOM"

#'  Rougheye_Rockfish_BC OM
#'
#'  British Columbia Rougheye Rockfish (using StochasticSRA) 
"Rougheye_Rockfish_BC"

#'  Canary_Rockfish_BC OM
#'
#'  British Columbia Canary Rockfish 
"Canary_Rockfish_BC"






