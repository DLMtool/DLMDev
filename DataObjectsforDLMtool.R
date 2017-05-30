
# Run this code to write files to DLMtool/data and create the 
# help manual files 

# --- Setup ----
library(DLMtool)

localDir <- getwd() # Set root directory 
if (!grepl("/DLMDev", localDir)) stop("Working directory should be DLMDev")

fromData <- file.path(localDir, "DLMtool_Data")
pkgpath <- file.path(localDir, "../DLMtool")
dataDir <- file.path(pkgpath, "data")


# --- Create R file for roxygen code ----
RoxygenFile <- "Roxy_DataObjects.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', RoxygenFile)) # delete 
file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 

cat("# This file is automatically built by DataObjectsforDLMtool.r in DLMDev\n",
    "# Don't edit by hand!\n", 
    "# \n\n", sep="", append=TRUE, 
    file=file.path(pkgpath, 'R/', RoxygenFile)) 


# --- Delete all files in DLMtool/data ----
fls <- list.files(dataDir) 
file.remove(file.path(dataDir, fls))


createDatafromCSV <- function(ObjectClass, fromData, pkgpath, RoxygenFile) {
  ObjectDir <- file.path(fromData, ObjectClass)
  fls <- list.files(ObjectDir)
  fls <- fls[grepl(".csv", fls)]
  for (X in seq_along(fls)) {
    name <- unlist(strsplit(fls[X], ".csv"))
    temp <- new(ObjectClass, file.path(ObjectDir, fls[X]))
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
            " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 	
    save(list=name, file = path, compress = "bzip2")
    
    # Write roxygen 
    chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
    if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
    clss <- class(temp)
    cat("#'  ", name, " ", clss,
        "\n#'", 
        "\n#'  An object of class ", clss, 
        "\n#'\n",
        '"', name, '"\n\n\n', sep="", append=TRUE, 
        file=file.path(pkgpath, 'R/', RoxygenFile))  
    
    rm(temp)
  }
}


# --- Stock Objects ----
createDatafromCSV("Stock", fromData, pkgpath, RoxygenFile)

# --- Fleet Objects ----
createDatafromCSV("Fleet", fromData, pkgpath, RoxygenFile)

# --- Obs Objects ----
createDatafromCSV("Obs", fromData, pkgpath, RoxygenFile)

# --- Imp Objects ----
createDatafromCSV("Imp", fromData, pkgpath, RoxygenFile)

# --- Fease Objects ----
createDatafromCSV("Fease", fromData, pkgpath, RoxygenFile)


# --- Data Objects ----
createDatafromCSV("Data", fromData, pkgpath, RoxygenFile)

# copy data files to inst directory 
ObjectDir <- file.path(fromData, "Data")
fls <- list.files(ObjectDir)
fls <- fls[grepl(".csv", fls)]
file.copy(from=file.path(ObjectDir, fls), to=file.path(pkgpath, "inst", fls), overwrite=TRUE)


# --- Test OM ---- 
name <- "testOM"
temp <- new("OM", DLMtool::Albacore, DLMtool::Generic_fleet, DLMtool::Generic_obs,  
            DLMtool::Perfect_Imp)
assign(name, temp)
path <- file.path(dataDir, paste0(name, ".RData"))
message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 	
save(list=name, file = path, compress = "bzip2")
# Write roxygen 
chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
clss <- class(temp)
cat("#'  ", name, " ", clss,
    "\n#'", 
    "\n#'  An object of class ", clss, 
    "\n#'\n",
    '"', name, '"\n\n\n', sep="", append=TRUE, 
    file=file.path(pkgpath, 'R/', RoxygenFile))  

rm(temp)
