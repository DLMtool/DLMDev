#' Process csv and save as data object 
#' 
#' Create Object from CSV, save Object as RData file to DLMtool/data and add 
#' roxygen code to 'fileName'
#' CSVs files are stored in 'OperatingModels/OBJECT_CLASS'
#' 
#' @param ObjectClass Character object class 
#' @param fileName Name of the R file to write the roxygen code 
#' 
#' 
createDataObjs <- function(ObjectClass, fileName="dataObjects.r") {
  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    name <- unlist(strsplit(fls[X], ".csv"))
    temp <- new(ObjectClass, file.path(devpath, "OperatingModels", ObjectClass, fls[X]))
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 	
    save(list=name, file = path, compress = "bzip2")

	# Write roxygen 
	chk <- file.exists(file.path(pkgpath, 'R/', fileName))
	if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
	clss <- class(temp)
    cat("#'  ", name, " ", clss,
        "\n#'", 
        "\n#'  An object of class ", clss, 
  	  "\n#'\n",
  	  '"', name, '"\n\n\n', sep="", append=TRUE, 
  	  file=file.path(pkgpath, 'R/', fileName))  
    
    rm(temp)
  }
}

#' Process OM object and save as data object 
#' 
#' Read OM Object, save Object as RData file to DLMtool/data and add 
#' roxygen code to 'fileName'
#' CSVs files are stored in 'OperatingModels/OBJECT_CLASS'
#' 
#' @param ObjectClass Character object class - should be "OM"
#' @param fileName Name of the R file to write the roxygen code 
#' 
#'
createOMObject <- function(ObjectClass="OM", fileName="dataObjects.r") {
  # Create a test OM object 
  temp <- new("OM", Albacore, Generic_fleet, Generic_obs,  new("Imp"))
  save(temp, file=file.path(devpath, "OperatingModels", ObjectClass, "testOM.RData"))

  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    if (grepl("Rdata", fls[X])) name <- unlist(strsplit(fls[X], ".Rdata"))
    if (grepl("RData", fls[X])) name <- unlist(strsplit(fls[X], ".RData"))
    tt <- load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	  temp <- get(tt)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 
    save(list=name, file = path, compress = "bzip2")
    
	  # Write roxygen 
	  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
	  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
	  clss <- class(temp)
    cat("#'  ", name, " ", clss, 
        "\n#'", 
        "\n#'  An object of class ", clss, 
  	    "\n#'\n",
        '"', name, '"\n\n\n', sep="", append=TRUE, 
        file=file.path(pkgpath, 'R/', fileName))  
    
    rm(temp)
  }
}


createIMObject <- function(ObjectClass="Imp", fileName="dataObjects.r") {
  # Create a test IM object 
  temp <- new("Imp")
  save(temp, file=file.path(devpath, "OperatingModels", ObjectClass, "Perfect_Imp.RData"))

  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    if (grepl("Rdata", fls[X])) name <- unlist(strsplit(fls[X], ".Rdata"))
    if (grepl("RData", fls[X])) name <- unlist(strsplit(fls[X], ".RData"))
    tt <- load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	  temp <- get(tt)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 
    save(list=name, file = path, compress = "bzip2")
    
	# Write roxygen 
	chk <- file.exists(file.path(pkgpath, 'R/', fileName))
	if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
	clss <- class(temp)
  cat("#'  ", name, " ", clss, 
      "\n#'", 
      "\n#'  An object of class ", clss, 
      "\n#'\n",
      '"', name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', fileName))  
    
    rm(temp)
  }
}

createMSEObject <- function(ObjectClass="MSE", fileName="dataObjects.r") {
  # Create a test MSE object 
  setup()
  temp <- runMSE(new("OM", Albacore, Generic_fleet, Generic_obs,  new("Imp")))
  save(temp, file=file.path(devpath, "OperatingModels", ObjectClass, "testMSE.RData"))

  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    if (grepl("Rdata", fls[X])) name <- unlist(strsplit(fls[X], ".Rdata"))
    if (grepl("RData", fls[X])) name <- unlist(strsplit(fls[X], ".RData"))
    tt <- load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	temp <- get(tt)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 
    save(list=name, file = path, compress = "bzip2")
    
	# Write roxygen 
	chk <- file.exists(file.path(pkgpath, 'R/', fileName))
	if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
	clss <- class(temp)
    cat("#'  ", name, " ", clss,
        "\n#'", 
        "\n#'  An object of class ", clss, 
  	    "\n#'\n",
  	    '"', name, '"\n\n\n', sep="", append=TRUE, 
  	    file=file.path(pkgpath, 'R/', fileName))  
    
    rm(temp)
  }
}


createOM2 <- function(Stock, Fleet=Generic_fleet, Obs=Generic_obs, Imp=Perfect_Imp, Name="OM", Source=NULL, fileName="dataObjects.r") {
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
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(OM)
     cat("#'  ", Name, " ", clss,
         "\n#'", 
         "\n#'  An object of class ", clss, 
   	    "\n#'\n",
   	    '"', Name, '"\n\n\n', sep="", append=TRUE, 
   	    file=file.path(pkgpath, 'R/', fileName))  
     
  rm(OM)   
}

createOM_SS <- function(SSdir, Name=NULL, Source=NULL, Author = "No author provided", nsim=100, fileName="dataObjects.r") {
  
  temp <- SS2DLM(SSdir, nsim, Name=Name, Source=Source, Author=Author)
  Name <- paste0(temp@Name, "_SS")
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
         "\n#'  An object of class ", clss, " (from SS using SS2DLM)",
   	    "\n#'  ", temp@Source,
		"\n#' \n",
   	    '"', Name, '"\n\n\n', sep="", append=TRUE, 
   	    file=file.path(pkgpath, 'R/', fileName)) 
		
  rm(temp)	
}

createOM_SRA <- function(Dir, Imp=Perfect_Imp, nsim=nsim, nits=800, burnin=500, fileName="dataObjects.r") {
   
  fls <- list.files(Dir)
  Stock <- new("Stock", file.path(Dir, fls[grep("Stock", fls)]))
  Fleet <- new("Fleet", file.path(Dir, fls[grep("Fleet", fls)]))
  Obs <- new("Obs", file.path(Dir, fls[grep("Obs", fls)]))
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
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(temp)
     cat("#'  ", Name, " ", clss,
        "\n#'", 
        "\n#'  An object of class ", clss, " (built using StochasticSRA)",
   	    "\n#'  ", temp@Source,
		    "\n#' \n",
   	    '"', Name, '"\n\n\n', sep="", append=TRUE, 
   	    file=file.path(pkgpath, 'R/', fileName)) 
		
  rm(temp)	
}

