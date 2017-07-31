
# OM <- OM_xl(file.path("C:/Users/arhor/Dropbox/CAProject/CACaseStudies/OMs/OMTables.xlsx"), "RSU")
# Data <- new("Data", file.path("C:/Users/arhor/Dropbox/CAProject/CACaseStudies/DataObjects/RSU/RSU_data.csv"))

Turing <- function(OM, Data) {
  if (class(OM) != "OM") stop("OM must be class 'OM'")
  if (class(Data) != "Data") stop("Data must be class 'Data'")

  # if (length(Data@Year) != OM@nyears) {
  #   message("Note: length Data@Year (", length(Data@Year), ") is not of length OM@nyears (", OM@nyears, ") \nUsing last ", 
  #           length(Data@Year), " years of simulations")
  # } # fix this for when Data is longer than OM 
  # 
  
  nyr <- length(Data@Year)
  nyears <- OM@nyears <- length(Data@Year)

  
  sims <- sample(1:OM@nsim, 5)
  
  # What Data are available?
  DF <- data.frame(Data=c(
    "Index of Abundance", 
    "Total Catch", 
    "Recruitment Index",
    "Catch-at-Age",
    "Catch-at-Length"), 
    Slot = c("Ind", 
             "Cat",
             "Rec",
             "CAA",
             "CAL"),
    Available=FALSE,
    Real =0,
    stringsAsFactors = FALSE)
  
  for (r in 1:nrow(DF)) {
    if(!all(is.na(slot(Data, DF$Slot[r])))) DF$Available[r] <- TRUE
  }

  if (sum(DF$Available) == 0 ) {
    stop("No data found in slots: ", paste(DF$Slot, ""), call.=FALSE)
  } else {
    message("Data found in slots: ", paste(DF$Slot[DF$Available], ""))
  }
  
  # if length data exists, make sure length bins are the same
  if (DF$Available[DF$Slot == "CAL"]) { 
    CAL_bins <- Data@CAL_bins
    OM@cpars$CAL_bins <- CAL_bins
  }
  # Run historical simulations
  Hist <- runMSE(OM, Hist=TRUE)
  
  
  
  message("Plotting:")
  # Index of Abundance
  if (DF$Available[DF$Slot == "Ind"]) {
    message(DF$Data[DF$Slot == "Ind"])
    Ind <- Data@Ind[1,]
    ind <- which(!is.na(Ind))
    simInd <- t(Hist$Data@Ind[sims, ind])
    
    simInd <- simInd/matrix(apply(simInd, 2, mean), nrow=length(ind), ncol=length(sims), byrow=TRUE)
    allInd <- cbind(Ind[ind], simInd)
    ranIndex <- sample(1:ncol(allInd), ncol(allInd))
    allInd <- allInd[,ranIndex]
    DF$Real[DF$Slot == "Ind"] <- which(ranIndex == 1)
   
    par(mfrow=c(3,2), bty="l", mar=c(3,3,1,1), oma=c(2,2,1,0))
    for (X in 1:ncol(allInd)) {
      plot(Data@Year[ind],allInd[,X], type="l", ylim=c(0, max(allInd)), xlab="", ylab="", 
           axes=FALSE, xaxs="i", yaxs='i', lwd=2)
      if (X %in% c(5,6)) {
        axis(side=1)
      } else {
        axis(side=1, label=FALSE)
      }
      if (X %in% c(1,3,5)) {
        axis(side=2, las=1)
      } else {
        axis(side=2, label=FALSE)
      }
     
    }
    title(paste("Index of Abundance for last", length(ind), "years"), outer=TRUE)
  }
  
  # Total Catch 
  if (DF$Available[DF$Slot == "Cat"]) {
    message(DF$Data[DF$Slot == "Cat"])
    Cat <- Data@Cat[1,]
    ind <- which(!is.na(Cat))
    Cat[ind] <- Cat[ind]/mean(Cat[ind])
    simCat <- t(Hist$Data@Cat[sims,ind])
    simCat <- simCat/matrix(apply(simCat, 2, mean), nrow=length(ind), ncol=length(sims), byrow=TRUE)
    allCat <- cbind(Cat[ind], simCat)
    ranIndex <- sample(1:ncol(allCat), ncol(allCat))
    allCat <- allCat[,ranIndex]
    DF$Real[DF$Slot == "Cat"] <- which(ranIndex == 1)
    
    par(mfrow=c(3,2), bty="l", mar=c(3,3,1,1), oma=c(2,2,1,0))
    for (X in 1:ncol(allCat)) {
      plot(Data@Year[ind],allCat[,X], type="l", ylim=c(0, max(allCat)), xlab="", ylab="", 
           axes=FALSE, xaxs="i", yaxs='i', lwd=2)
      if (X %in% c(5,6)) {
        axis(side=1)
      } else {
        axis(side=1, label=FALSE)
      }
      if (X %in% c(1,3,5)) {
        axis(side=2, las=1)
      } else {
        axis(side=2, label=FALSE)
      }
      
    }
    title(paste("Catch Trends for last", length(ind), "years"), outer=TRUE)
  }  
  
  # Recruitment
  if (DF$Available[DF$Slot == "Rec"]) {
    message(DF$Data[DF$Slot == "Rec"])
    Rec <- Data@Rec[1,]
    ind <- which(!is.na(Rec))
    Rec[ind] <- Cat[ind]/mean(Rec[ind])
    simRec <- t(Hist$Data@Rec[sims,ind])
    simRec <- simRec/matrix(apply(simRect, 2, mean), nrow=length(ind), ncol=length(sims), byrow=TRUE)
    allRec <- cbind(Rec[ind], simRect)
    ranIndex <- sample(1:ncol(allRec), ncol(allRec))
    allRec <- allRec[,ranIndex]
    DF$Real[DF$Slot == "Rec"] <- which(ranIndex == 1)
    
    par(mfrow=c(3,2), bty="l", mar=c(3,3,1,1), oma=c(2,2,1,0))
    for (X in 1:ncol(allCat)) {
      plot(Data@Year[ind],allRec[,X], type="l", ylim=c(0, max(allRec)), xlab="", ylab="", 
           axes=FALSE, xaxs="i", yaxs='i', lwd=2)
      if (X %in% c(5,6)) {
        axis(side=1)
      } else {
        axis(side=1, label=FALSE)
      }
      if (X %in% c(1,3,5)) {
        axis(side=2, las=1)
      } else {
        axis(side=2, label=FALSE)
      }
      
    }
    title(paste("Recruitment Trends for last", length(ind), "years"), outer=TRUE)
  } 
   
  
  # Catch-at-age
  
  
  
  Data@CAA
  
  # Catch-at-Length
  if (DF$Available[DF$Slot == "CAL"]) {
    message(DF$Data[DF$Slot == "CAL"])
    CAL <- Data@CAL[1,,]
    LBins <- Data@CAL_bins
    BW <- LBins[2] - LBins[1]
    LMids <- seq(LBins[1] + BW*0.5, by=BW, length.out=length(LBins)-1)
    
    if (!all(Hist$Data@CAL_bins == LBins)) stop("Length bins of simulated and real data are not the same", call.=FALSE)
    
    simCAL <- Hist$Data@CAL[sims,ind]
    
    # need to match years
    
    
    
    ind <- which(!is.na(Rec))
    Rec[ind] <- Cat[ind]/mean(Rec[ind])
    simRec <- Hist$TSdata$Rec[ind,sims]
    simRec <- simRec/matrix(apply(simRect, 2, mean), nrow=length(ind), ncol=length(sims), byrow=TRUE)
    allRec <- cbind(Rec[ind], simRect)
    ranIndex <- sample(1:ncol(allRec), ncol(allRec))
    allRec <- allRec[,ranIndex]
    DF$Real[DF$Slot == "Rec"] <- which(ranIndex == 1)
    
    par(mfrow=c(3,2), bty="l", mar=c(3,3,1,1), oma=c(2,2,1,0))
    for (X in 1:ncol(allCat)) {
      plot(Data@Year[ind],allRec[,X], type="l", ylim=c(0, max(allRec)), xlab="", ylab="", 
           axes=FALSE, xaxs="i", yaxs='i', lwd=2)
      if (X %in% c(5,6)) {
        axis(side=1)
      } else {
        axis(side=1, label=FALSE)
      }
      if (X %in% c(1,3,5)) {
        axis(side=2, las=1)
      } else {
        axis(side=2, label=FALSE)
      }
      
    }
    title(paste("Recruitment Trends for last", length(ind), "years"), outer=TRUE)
  } 
  
  
  Data@CAL
  Data@CAL_bins
  slotNames(Data)
  
  
  
  
  Cat <- Hist$TSdata$Catch[(nyears-nyr+1):nyears,sims]
  meancat <- matrix(apply(Cat, 2, mean), nrow=nyr, ncol=length(sims), byrow=TRUE)
  Cat <- Cat/meancat
  Cat_d <- as.numeric(Data@Cat/mean(Data@Cat, na.rm=TRUE))
  
  Cat <- cbind(Cat, Cat_d)
  
  
  ind <- sample(1:ncol(Cat), ncol(Cat))
  Cat <- Cat[,ind]
  
  par(mfrow=c(3,2))
  for (X in 1:ncol(Cat)) plot(Cat[,X], type="l", ylim=c(0, max(Cat)))
 
  
  
  dim(Data@CAA)
  
  dim(Data@CAL)
  
  
  
  
  
}