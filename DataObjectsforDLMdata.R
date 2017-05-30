
# Run this code to write files to DLMdata/data 

# --- Setup ----
library(DLMtool)

localDir <- getwd() # Set root directory 
if (!grepl("/DLMDev", localDir)) stop("Working directory should be DLMDev")

fromData <- file.path(localDir, "DLMdata_Data")
pkgpath <- file.path(localDir, "../DLMdata")
dataDir <- file.path(pkgpath, "data")

# --- Create R file for roxygen code ----
RoxygenFile <- "Roxy_DataObjects.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', RoxygenFile)) # delete 
file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 

cat("# This file is automatically built by DataObjectsforDLMdata.r in DLMDev\n",
    "# Don't edit by hand!\n", 
    "# \n\n", sep="", append=TRUE, 
    file=file.path(pkgpath, 'R/', RoxygenFile)) 


# --- Delete all files in DLMtool/data ----
fls <- list.files(dataDir) 
file.remove(file.path(dataDir, fls))

# --- Copy Data Object Function ----
copyDataObject <- function(class, fromData, pkgpath) {
  ObjectDir <- file.path(fromData, class)
  fls1 <- list.files(ObjectDir)
  fls <- fls1[grepl(".RData", fls1) || grepl(".Rdata", fls1)]
  
  for (X in seq_along(fls)) {
    name <- unlist(strsplit(fls[X], ".RData"))
    name <- unlist(strsplit(name, ".Rdata"))
    temp <- try(readRDS(file.path(ObjectDir, fls[X])), silent=TRUE)
    if (class(temp) == "try-error") {
      tt <- load(file.path(ObjectDir, fls[X]))
      temp <- get(tt)
    } else  assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(Name, collapse = ", "), 
            " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 
    save(list=name, file = path, compress = "bzip2")
    
    # Write roxygen 
    chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
    if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
      cat("#'  ", name, " ", clss,
          "\n#'", 
          "\n#'  An object of class ", class, 
          "\n#'\n",
          '"', name, '"\n\n\n', sep="", append=TRUE, 
          file=file.path(pkgpath, 'R/', RoxygenFile)) 
  }    
}

  



# --- MSE Objects ---- 
library(DLMtool)
setup()
testMSE <- runMSE(testOM)
Name <- "testMSE"
path <- file.path(fromData, "MSE", paste0(Name, ".RData"))
saveRDS(testMSE, file = path, compress = "bzip2")

copyDataObject("MSE", fromData, pkgpath)



# --- OM Objects ----
copyDataObject("OM", fromData, pkgpath)


# --- Build OM Objects ----



## --- Build OM from CSV ----
createOM <- function(Stock, Fleet=Generic_fleet, Obs=Generic_obs, Imp=Perfect_Imp, 
                     Name="OM", Source=NULL, RoxygenFile) {
  OM <- new("OM", Stock, Fleet, Obs, Imp)
  if (!is.null(Source)) OM@Source <- Source
  Name <- paste0(Stock@Name, "_", Name)
  Name <- gsub('([[:punct:]])|\\s+','_',Name)
  assign(Name, OM)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("Saving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
  if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
  cat("#'  ", Name, " ", "OM",
      "\n#'", 
      "\n#'  An object of class OM", 
      "\n#'\n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', RoxygenFile))  
  
  rm(OM)   
}

# File structure is:
# DLMDev/DLMdata_Data/buildOMfromCSV
#   - region or agency (goes into Source)
#     - Stock, Fleet, Obs, Imp
# Fleet, Obs etc are matched by Stock name. If no match found a generic object is used 

region_agency <- list.files(file.path(fromData, "buildOMfromCSV"))

for (om in region_agency) {
  stocks <- list.files(file.path(fromData, "buildOMfromCSV", om, "Stock")) 
  fleets <- list.files(file.path(fromData, "buildOMfromCSV", om, "Fleet")) 
  obs <- list.files(file.path(fromData, "buildOMfromCSV", om, "Obs")) 
  imp <- list.files(file.path(fromData, "buildOMfromCSV", om, "Imp")) 
  Source <- om
  for (X in seq_along(stocks)) {
    # Stock
    Stock <- new("Stock", file.path(fromData, "buildOMfromCSV", om, "Stock", stocks[X]))
    # Fleet
    ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), fleets))
    if (length(ind) == 1) {
      Fleet <- new("Fleet", file.path(fromData, "buildOMfromCSV", om, "Fleet", fleets[ind]))
    } else Fleet <- Generic_fleet
    # Obs 
    ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), obs))
    if (length(ind) == 1) {
      Obs <- new("Obs", file.path(fromData, "buildOMfromCSV", om, "Obs", obs[ind]))
    } else Obs <- Generic_obs  
    # Imp 
    ind <- which(grepl(unlist(strsplit(stocks[X], ".csv")), imp))
    if (length(ind) == 1) {
      Imp <- new("Imp", file.path(fromData, "buildOMfromCSV", om, "Imp", imp[ind]))
    } else Imp <- Perfect_Imp  
    
    Name <- paste0(unlist(strsplit(stocks[X], ".csv")), "_OM")
    createOM(Stock, Fleet, Obs, Imp, Name=Name, Source, RoxygenFile)
  }
}

# --- Build from Script ----
region_agency <- list.files(file.path(fromData, "buildOMfromScript"))

for (om in region_agency) {
  fls <- list.files(file.path(fromData, "buildOMfromScript", om))
  scripts <- fls[grepl(".R", fls) | grepl(".r", fls)]
  suppressWarnings(rm(OM))
  for (x in seq_along(scripts)) {
    source(file.path(fromData, "buildOMfromScript", om, scripts[x]))
    Name <- strsplit(strsplit(OM@Name, ":")[[1]][2], "Fleet")[[1]]
    Name <- paste0(gsub('([[:punct:]])|\\s+','_',Name), "OM")
    assign(Name, OM)
    path <- file.path(dataDir, paste0(Name, ".RData"))
    message("\nSaving ", paste(Name, collapse = ", "), 
            " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
    save(list=Name, file = path, compress = "bzip2")
    
    # Write roxygen 
    chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
    if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
    clss <- class(OM)
    cat("#'  ", Name, " ", clss,
        "\n#'", 
        "\n#'  An object of class ", clss,
        "\n#'  ", OM@Source,
        "\n#' \n",
        '"', Name, '"\n\n\n', sep="", append=TRUE, 
        file=file.path(pkgpath, 'R/', RoxygenFile))  
  }
}


# --- Build OM from SS ---- 
createOM_SS <- function(SSdir, Name=NULL, Source=NULL, Author = "No author provided", 
                        nsim=100, RoxygenFile) {
  
  temp <- SS2DLM(SSdir, nsim, Name=Name, Source=Source, Author=Author)
  Name <- paste0(temp@Name, "_SS")
  assign(Name, temp)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("\nSaving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
  if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
  clss <- class(temp)
  cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss, " (from SS using SS2DLM)",
      "\n#'  ", temp@Source,
      "\n#' \n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', RoxygenFile)) 
  
  rm(temp)	
}

region_agency <- list.files(file.path(fromData, "buildOMfromSS"))

for (om in region_agency) {
  stocks <- list.files(file.path(fromData, "buildOMfromSS", om))
  for (x in seq_along(stocks))  {
    SSdir <- file.path(fromData, "buildOMfromSS", om, stocks[x]) 
    Name <- stocks[x]
    Source <- om
    Author <- om
    createOM_SS(SSdir, Name, Source, Author, nsim=100, RoxygenFile)
  }
}    

# --- Build OM from iSCAM ----   
createOM_iSCAM <- function(iSCAMdir, Name=NULL, Source=NULL, Author = "No author provided", 
                        nsim=100, proyears=50, RoxygenFile) {
  
  temp <- iSCAM2DLM(iSCAMdir, nsim=nsim, proyears=proyears, Name=Name, Source=Source,
                    Author=Author)
  Name <- paste0(temp@Name, "_SS")
  assign(Name, temp)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("\nSaving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
  if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
  clss <- class(temp)
  cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss, " (from iSCAM using iSCAM2DLM)",
      "\n#'  ", temp@Source,
      "\n#' \n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', RoxygenFile)) 
  
  rm(temp)	
}


region_agency <- list.files(file.path(fromData, "buildOMfromiSCAM"))

for (om in region_agency) {
  stocks <- list.files(file.path(fromData, "buildOMfromiSCAM", om))
  for (x in seq_along(stocks))  {
    iSCAMdir <- file.path(fromData, "buildOMfromiSCAM", om, stocks[x]) 
    Name <- stocks[x]
    Source <- om
    Author <- om
    createOM_iSCAM(iSCAMdir, Name, Source, Author, nsim=100, proyears=50, RoxygenFile=RoxygenFile)
  }
} 

# --- Build OM from Stochastic SRA ---- 
createOM_SRA <- function(Dir, nsim=nsim, nits=800, burnin=500, RoxygenFile) {
  
  fls <- list.files(Dir)
  Stock <- new("Stock", file.path(Dir, fls[grep("Stock", fls)]))
  Fleet <- new("Fleet", file.path(Dir, fls[grep("Fleet", fls)]))
  
  obsfile <- file.path(Dir, fls[grep("Obs", fls)])
  if (length(obsfile) > 1) {
    Obs <- new("Obs", obsfile)
  } else Obs <- Generic_obs
  
  impfile <- file.path(Dir, fls[grep("Imp", fls)])
  if (length(impfile) > 1) {
    Imp <- new("Imp", impfile)  
  } else Imp <- Perfect_Imp
  
  CAA <- as.matrix(read.csv(file.path(Dir, fls[grep("CAA", fls)])))
  Chist <- as.numeric(as.matrix(read.csv(file.path(Dir, fls[grep("Chist", fls)]), header=FALSE)))
  
  OM <- new("OM", Stock, Fleet, Obs, Imp)
  temp <- StochasticSRA(OM, CAA, Chist, ploty=FALSE, burnin=burnin, nsim=nsim, nits=nits)
  
  Name <- paste0(Stock@Name, "_SRA")
  Name <- gsub('([[:punct:]])|\\s+','_',Name)
  assign(Name, temp)
  path <- file.path(dataDir, paste0(Name, ".RData"))
  message("\nSaving ", paste(Name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir, "\n")	 
  save(list=Name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
  if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
  clss <- class(temp)
  cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss, " (built using StochasticSRA)",
      "\n#'  ", temp@Source,
      "\n#' \n",
      '"', Name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', RoxygenFile)) 
  
  rm(temp)	
}

region_agency <- list.files(file.path(fromData, "buildOMfromStochasticSRA"))
for (om in region_agency) {
  stocks <- list.files(file.path(fromData, "buildOMfromStochasticSRA", om))
  for (x in seq_along(stocks))  {
    Dir <- file.path(fromData, "buildOMfromStochasticSRA", om, stocks[x]) 
    createOM_SRA(Dir, 100, RoxygenFile=RoxygenFile)
  }
} 



# ---- Create Test MSE for dev purposes only ----

# setup()
# testOM@nsim <- 200
# st <- Sys.time()
# BigMSE <- runMSE(testOM, MPs=c(avail("Output"), avail("Input")))
# save(BigMSE, file=file.path(devpath, "BigMSE.RData"))
# elapse <- Sys.time() - st 
# elapse
























