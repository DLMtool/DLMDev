
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
temp <- new("OM", DLMtool::Albacore, DLMtool::Generic_Fleet, DLMtool::Generic_Obs,  
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


# --- Object Descriptions ----
slot_ripper<-function(filenam,slots){
  
  ns<-length(slots)
  sind<-rep(TRUE,ns)
  out<-readLines(filenam,skipNul=T)
  no<-length(out)
  out2<-data.frame(matrix(NA,ncol=2,nrow=ns))
  names(out2)<-c("Slot","Description")
  
  k=TRUE # Before slot text?
  ss<-0 # Slot counter
  
  for(i in 1:no){
    test<-scan(filenam,skip=i-1,what='character',nlines=1)
    nt<-length(test)
    if(nt>0)if(k & test[1]=="_\bS_\bl_\bo_\bt_\bs:")k=FALSE
    
    if(nt==0&!k){ # new slot?
      moretext=FALSE
      ss<-ss+1
    }
   
    if(!(nt==0|substr(test[1],1,1)=="_"|k)){ # text, not a header, after slot text starts
     
      if(test[1]%in%slots[sind]){
        sind[match(test[1],slots)]=FALSE
        
        out2[ss,1]<-test[1]
        out2[ss,2]<-paste(test[2:nt],collapse=" ")
        moretext=TRUE
      }else{
        bg <- 1 # max(2, length(test))
        if(moretext) out2[ss,2]<-paste(c(out2[ss,2],test[bg:nt]),collapse=" ")
        
      } 
    }
    
  }
  
  out2
  
}

getDescription <- function(class=c("Stock", "Fleet", "Obs", "Imp", "Data"), 
                           Rdloc='../DLMtool/man',
                           Outloc=NULL) {
  class <- match.arg(class)
  if (is.null(Outloc)) Outloc <- tempdir()
  
  rdloc <- paste0(file.path(Rdloc, class), "-class.Rd")
  outloc <- paste0(file.path(Outloc, class), "-class.txt")
  call <- paste("R CMD Rd2txt", rdloc, "-o", outloc)
  system(call)
  tt <- slot_ripper(paste0(file.path(Outloc, class), "-class.txt"), slotNames(class))
  name <- paste0(class, "Description")
  assign(name, tt)
  
  
  path <- file.path(dataDir, paste0(name, ".RData"))
  message("Saving ", paste(name, collapse = ", "), 
          " as ", paste(basename(path), collapse = ", "), " to ", dataDir)	 	
  save(list=name, file = path, compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', RoxygenFile))
  if(!chk) file.create(file.path(pkgpath, 'R/', RoxygenFile)) # make empty file 
 
  cat("#'  ", name, " ",
      "\n#'", 
      "\n#'  A data.frame with description of slots for class ", class,
      "\n#'\n",
      '"', name, '"\n\n\n', sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', RoxygenFile))  
  
  file.remove(paste0(file.path(Outloc, class), "-class.txt"))
  
  
}

Outloc <- tempdir()
getDescription("Stock", Outloc=Outloc)
getDescription("Fleet", Outloc=Outloc)
getDescription("Obs", Outloc=Outloc)
getDescription("Imp", Outloc=Outloc)
getDescription("Data", Outloc=Outloc)






