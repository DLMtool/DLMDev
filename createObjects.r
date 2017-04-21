library(DLMtool)

rm(list=ls())
setwd("C:/Users/Adrian/Documents/GitHub/DLMDev")

pkgpath <- "C:/Users/Adrian/Documents/GitHub/DLMtool"
dataDir <- file.path(pkgpath, "data")

fls <- list.files(dataDir)
file.remove(file.path(dataDir, fls))

saveName <- list() # empty list  

# Create Stock Objects 
stocks <- list.files("Operating models/Stocks")
for (X in seq_along(stocks)) {
  name <- unlist(strsplit(stocks[X], ".csv"))
  temp <- new("Stock", paste0("Operating models/Stocks/", stocks[X]))
  assign(name, temp)
  saveName <- append(saveName, name)
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", 
        dataDir)	 
  save(list=name, file = path, compress = "bzip2", envir = parent.frame())
  rm(temp)
}

# Create Fleet Objects 
fleets <- list.files("Operating models/Fleets")
for (X in seq_along(fleets)) {
  name <- unlist(strsplit(fleets[X], ".csv"))
  temp <- new("Fleet", paste0("Operating models/Fleets/", fleets[X]))
  assign(name, temp)
  saveName <- append(saveName, name)
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", 
        dataDir)	 
  save(list=name, file = path, compress = "bzip2", envir = parent.frame())
  rm(temp)
}


# Create Observation Objects 
obs <- list.files("Operating models/Observation")
for (X in seq_along(obs)) {
  name <- unlist(strsplit(obs[X], ".csv"))
  temp <- new("Obs", paste0("Operating models/Observation/", obs[X]))
  assign(name, temp)
  saveName <- append(saveName, name)
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", 
        dataDir)	 
  save(list=name, file = path, compress = "bzip2", envir = parent.frame())
  rm(temp)
}

# Create Feasibility 
Fease <- list.files("Operating models/Fease")
for (X in seq_along(Fease)) {
  name <- unlist(strsplit(Fease[X], ".csv"))
  temp <- new("Fease", paste0("Operating models/Fease/", Fease[X]))
  assign(name, temp)
  saveName <- append(saveName, name)
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", 
        dataDir)	 
  save(list=name, file = path, compress = "bzip2", envir = parent.frame())
  rm(temp)
}

# Create Data Objects 
Data <- list.files("Operating models/Data")
for (X in seq_along(Data)) {
  name <- unlist(strsplit(Data[X], ".csv"))
  temp <- new("Data", paste0("Operating models/Data/", Data[X]))
  assign(name, temp)
  saveName <- append(saveName, name)
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
        " as ", paste(basename(path), collapse = ", "), " to ", 
        dataDir)	 
  save(list=name, file = path, compress = "bzip2", envir = parent.frame())
  rm(temp)
}



# Create OM Objects
name <- "testOM"  
temp <- new("OM", Albacore, Generic_fleet, Generic_obs)
assign(name, temp)
saveName <- append(saveName, name)
path <- file.path(dataDir, paste0(name, ".RData"))
message("Saving ", paste(name, collapse = ", "), 
      " as ", paste(basename(path), collapse = ", "), " to ", 
      dataDir)	 
save(list=name, file = path, compress = "bzip2", envir = parent.frame())
rm(temp)

# Create MSE Objects 
name <- "testMSE"
setup()
temp <- runMSEdev(testOM)
assign(name, temp)
saveName <- append(saveName, name)
path <- file.path(dataDir, paste0(name, ".RData"))
message("Saving ", paste(name, collapse = ", "), 
      " as ", paste(basename(path), collapse = ", "), " to ", 
      dataDir)	 
save(list=name, file = path, compress = "bzip2", envir = parent.frame())
rm(temp)


# Write roxygen file and save to DLMtool/R 
fileName <- "dataObjects.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', fileName))
file.create(file.path(pkgpath, 'R/', fileName))

for (X in 1:length(saveName)) {
    clss <- class(get(saveName[[X]]))
	Name <- saveName[[X]]
    cat("#'  ", Name, " ", clss,
      "\n#'", 
      "\n#'  An object of class ", clss, 
	  "\n#'\n",
	  '"', Name, '"\n\n\n', sep="", append=TRUE, 
	  file=file.path(pkgpath, 'R/', fileName))
}





