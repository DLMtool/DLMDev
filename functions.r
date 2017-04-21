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
    save(list=name, file = path, compress = "bzip2", envir = parent.frame())
    
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
  temp <- new("OM", Albacore, Generic_fleet, Generic_obs)
  save(temp, file=file.path(devpath, "OperatingModels", ObjectClass, "testOM.RData"))

  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    if (grepl("Rdata", fls[X])) name <- unlist(strsplit(fls[X], ".Rdata"))
    if (grepl("RData", fls[X])) name <- unlist(strsplit(fls[X], ".RData"))
    load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	temp <- get(name)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 
    save(list=name, file = path, compress = "bzip2", envir = parent.frame())
    
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
    load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	temp <- get(name)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 
    save(list=name, file = path, compress = "bzip2", envir = parent.frame())
    
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
  temp <- runMSEdev(testOM)
  save(temp, file=file.path(devpath, "OperatingModels", ObjectClass, "testOM.RData"))

  fls <- list.files(file.path(devpath, "OperatingModels/", ObjectClass))
  for (X in seq_along(fls)) {
    if (grepl("Rdata", fls[X])) name <- unlist(strsplit(fls[X], ".Rdata"))
    if (grepl("RData", fls[X])) name <- unlist(strsplit(fls[X], ".RData"))
    load(file.path(devpath, "OperatingModels/", ObjectClass, fls[X]))
	temp <- get(name)
    assign(name, temp)
    path <- file.path(dataDir, paste0(name, ".RData"))
    message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", 
          dataDir)	 
    save(list=name, file = path, compress = "bzip2", envir = parent.frame())
    
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


