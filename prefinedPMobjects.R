

# Modify to include a description later 


library(DLMtool)
library(DLMdata)

pms <- try(avail("PM"), silent=TRUE )
if (class(pms) =="try-error") pms <- NULL


localDir <- getwd()
pkgpath <- file.path(localDir, "../DLMtool")
dataDir <- file.path(pkgpath, "data")
RDir <- file.path(pkgpath, "R")

fileName <- "RoxyPMobj.r" # name of R script with roxygen 
file.remove(file.path(pkgpath, 'R/', fileName)) # delete 
file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 

cat("# This file is automatically built by prefinedPMobjects.r in DLMDev\n",
    "# Don't edit by hand!\n", 
    "# \n\n", sep="", append=TRUE, 
    file=file.path(pkgpath, 'R/', fileName))  


# Save the PM object to data directory and write Roxygen code 
saveWrite <- function(obj, dataDir=file.path(pkgpath, "data")) {
  name <- paste0(obj, ".RData")
  temp <- get(obj)
  assign(obj, temp)
  save(list=obj, file = file.path(dataDir, name), compress = "bzip2")
  
  # Write roxygen 
  chk <- file.exists(file.path(pkgpath, 'R/', fileName))
  if(!chk) file.create(file.path(pkgpath, 'R/', fileName)) # make empty file 
  clss <- class(get("SB_SB0"))
  cat("#'  ", obj, " Performance Metric Object",
      "\n#'", 
      "\n#'  An object of class ", clss,
      "\n#' \n",
      "'", obj, "'\n\n\n", sep="", append=TRUE, 
      file=file.path(pkgpath, 'R/', fileName))   
}



MSEobj <- testMSE 
PMobj <- SB_SB03

ChkYrs(MSEobj, PMobj)

ChkYrs <- function(MSEobj, PMobj) {
  y1 <- PMobj@Y1 
  y2 <- PMobj@Y2
  if (length(y2) == 0 || !is.finite(y2)) y2 <- MSEobj@proyears
  if (y2 > MSEobj@proyears) {
    y2 <- MSEobj@proyears
    warning("Y2 is greater than proyears. Defaulting to Y2 = proyears", call.=FALSE)
  }
  if (length(y1) == 0 || !is.finite(y1)) {
    y1 <- 1 
  } else {
    if (y1 < 0) y1 <- y2 - abs(y1) + 1 
    if (y1 == 0) y1 <- 1
  }
  if (y1 <= 0) {
    y1 <- 1
    warning("Y1 is negative. Defaulting to Y1 = 1", call.=FALSE)
  }
  if (y1 >= y2) {
    y1 <- y2 - 4 
    warning("Y1 is greater or equal to Y2. Defaulting to Y1 = Y2-4", call.=FALSE)
    
  }
  c(y1,y2)
}

# --- Spawning Biomass relative to SB0 ----
SB_SB0 <- new("PM")
SB_SB0@Name <- "Spawning Biomass Relative to SB0"
SB_SB0@Func <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB))
SB_SB0@Label <- bquote(italic("SB") * "/" * italic("SB"[0]))
saveWrite("SB_SB0")

# --- Spawning Biomass relative to SB0 over certain years ----
SB_SB02 <- new("PM")
SB_SB02@Name <- "Spawning Biomass Relative to SB0"
SB_SB02@Func <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  var <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB)) 
  var[,,y1:y2]
} 
SB_SB02@Label <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  bquote(italic("SB") * "/" * italic("SB"[0]) ~ "(Years" ~ .(y1) ~ "-" ~ .(y2) * ")")
}
saveWrite("SB_SB02")


# --- Spawning Biomass relative to SB0 over certain years ----
SB_SB03 <- new("PM")
SB_SB03@Name <- "Spawning Biomass Relative to SB0"
SB_SB03@Func <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  var <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB)) 
  if (length(PMobj@Ref) > 0) return(var[,,y1:y2] >= PMobj@Ref)
  if (length(PMobj@Ref) == 0) return(var[,,y1:y2])
} 
SB_SB03@Label <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  if (length(PMobj@Ref) > 0) {
    if (PMobj@Ref == 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ italic("SB"[0]) ~ "(Years" ~ .(y1) ~ "-" ~ .(y2) * ")"))
    if (PMobj@Ref != 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ .(PMobj@Ref) ~ italic("SB"[0]) ~ "(Years" ~ .(y1) ~ "-" ~ .(y2) * ")"))
  } else  return(bquote(italic("SB") * "/" * italic("SB"[0]) ~ "(Years" ~ .(y1) ~ "-" ~ .(y2) * ")"))
}
saveWrite("SB_SB03")


SB_SB03@Ref <- numeric()
PM(MSEobj, SB_SB03)
PM(MSEobj, SB_SB03, "project")

type <- "project"
type <- "summary"
PMobj <- SB_SB03

PM <- function(MSEobj, PMobj, type=c("summary", "project"), MSEname=NULL, Can=NULL, Class=NULL) {
  type <- match.arg(type)
  
  out <- list()
  lst <- list()
  if (is.null(MSEname)) MSEname <- 1:length(MSEobj)
  if (class(MSEname) == "character") MSEname <- factor(MSEname, ordered=TRUE, levels=MSEname)
  
  for (X in 1:length(MSEobj)) {
    if (class(MSEobj) == "MSE") MSE <- MSEobj
    if (class(MSEobj) == "list") MSE <- MSEobj[[X]]
    if (class(PMobj@Label) == "function") label <- PMobj@Label(MSE, PMobj)
    if (class(PMobj@Label) != "function") label <- PMobj@Label
    if (is.null(Can)) Can <- rep(NA, MSE@nMPs)
    if (is.null(Class)) Class <- MPclass(MSE@MPs)
    if (class(Can) == "character")  Can <- MSE@MPs %in% Can 
    if (type == "summary") {
      if (length(PMobj@extra) > 0 ) val <- apply(PMobj@Func(MSE, PMobj), 2, get(PMobj@Stat), PMobj@extra)  
      if (length(PMobj@extra) == 0 ) val <- apply(PMobj@Func(MSE, PMobj), 2, get(PMobj@Stat))
      
      rp <- PMobj@Ref
      pass <- val > PMobj@Ref
      if (length(rp) == 0) rp <- NA
      if (length(pass) == 0) pass <- NA
      lst[[X]] <- data.frame(MP=MSE@MPs, val=val, rp=rp, pass=pass,
                             MSE=MSEname[X], Can=Can, Class=Class, 
                             stringsAsFactors = FALSE)
    }     
    if (type == "project") {
      val <- PMobj@Func(MSE, PMobj)
      if (is.logical(val)) { # probabilites
        lst[[X]] <- apply(val, c(2,3), mean)
      } else lst[[X]] <- val
    }
  }    
  
  if (type == "summary") {
    DF <- do.call("rbind", lst)
    class(out) <- "summary"
    if (length(PMobj@Ref) == 0) label <- bquote(.(simpleCap(PMobj@Stat)) ~ .(label))
  }
  if (type == "project") {
    DF <- lst
    
    temp <- lst[[1]]
    
    
    df0 <- as.data.frame.table(temp)
    levels(df0$Var1) <- 1:MSE@nsim
    levels(df0$Var2) <- MSE@MPs
    y1 <- ChkYrs(MSE, PMobj)[1]
    y2 <- ChkYrs(MSE, PMobj)[2]
    levels(df0$Var3) <- y1:y2
    
    DFout <- data.frame(MP=df0$Var2, sim=(df0$Var1), year=as.numeric(df0$Var3), val=df0$Freq)
    library(ggplot2)
    ggplot(DFout, aes(x=year, y=val, colour=sim)) +
      facet_grid(~MP) +
      geom_line() + ylab(label)
    
    library(dplyr)
    tt <- DFout %>% filter(MP=="AvC")
    ggplot(tt, aes(x=year, y=val, colour=sim)) +  geom_line()

    factor(df0$Var1, levels=1:MSE@nsim)
    
    dim(DF[[1]])
    
    
    
    names(DF) <- MSEname
    class(out) <- "project"
  }  

  out$Vals <- DF
  out$Label <- label
  out 
}

OM <- makePerf(testOM)
MSEobj <- runMSE(OM, MP="curE")

b0 <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB)) 
range(b0[,1,1])

b <- apply(MSEobj@SSB_hist, c(1,3), sum)

sim <- 1
mp <- 1
totb <- c(b[sim,], MSEobj@SSB[sim,mp,])
plot(totb/MSEobj@OM$SSB0[sim], type="l", ylim=c(0,2))
abline(v=MSEobj@nyears, lty=2)

totF <- cbind(apply(MSEobj@FM_hist, c(1,3), sum), MSEobj@F_FMSY[,mp,])
plot(totF[sim,], type="l", ylim=c(0,max(totF[sim,])))
abline(v=MSEobj@nyears, lty=2)



totb <- cbind(b, MSEobj@SSB[,mp,])

matplot(t(totb/MSEobj@OM$SSB0), type="l")
abline(v=MSEobj@nyears)
range((totb/MSEobj@OM$SSB0)[,MSEobj@nyears+1])


# --- Probabiity Spawning Biomass is above Ref * SB0 ----
pSB0 <- new("PM")
pSB0@Name <- "Probability spawning biomass is above Ref * SB0"
pSB0@Ref <- 0.2 
pSB0@RP <- 0.8
pSB0@Func <- function(MSEobj, PMobj) MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB)) >= PMobj@Ref
pSB0@Label <- function(MSEobj, PMobj) {
  if (PMobj@Ref == 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ italic("SB"[0])))
  if (PMobj@Ref != 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ .(PMobj@Ref) ~ italic("SB"[0]))) 
}
saveWrite("pSB0")

# --- Spawning Biomass relative to SBMSY ----
SB_SBMSY <- new("PM")
SB_SBMSY@Name <- "Spawning Biomass Relative to SBMSY"
SB_SBMSY@Func <- function(MSEobj, PMobj) MSEobj@SSB/array(MSEobj@OM$SSBMSY, dim=dim(MSEobj@SSB))
SB_SBMSY@Label <- bquote(italic("SB") * "/" * italic("SB"[MSY]))
saveWrite("SB_SBMSY")


# --- Probabiity Spawning Biomass is above Ref * SBMSY ----
pSBMSY <- new("PM")
pSBMSY@Name <- "Probability spawning biomass is above Ref * SBMSY"
pSBMSY@Ref <- 0.5
pSBMSY@RP <- 0.8
pSBMSY@Func <- function(MSEobj, PMobj) MSEobj@SSB/array(MSEobj@OM$SSBMSY, dim=dim(MSEobj@SSB)) >= PMobj@Ref
pSBMSY@Label <- function(MSEobj, PMobj) {
  if (PMobj@Ref == 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ italic("SB"[MSY])))
  if (PMobj@Ref != 1) return(bquote("Prob." ~ italic("SB") ~ ">" ~ .(PMobj@Ref) ~ italic("SB"[MSY]))) 
}
saveWrite("pSBMSY")

# --- Relative Fishing Mortality  ----
F_FMSY <- new("PM")
F_FMSY@Name <- "Fishing Mortality relative to FMSY"
F_FMSY@Func <- function(MSEobj, PMobj) MSEobj@F_FMSY
F_FMSY@Label <- bquote("Fishing mortality relative to " ~ italic("F"[MSY]))  
saveWrite("F_FMSY")

# --- Prob Fishing Mortality > FMSY ----
pFMSY <- new("PM")
pFMSY@Name <- "Probability fishing mortality is below Ref * FMSY"
pFMSY@Ref <- 1
pFMSY@RP <- 0.5
pFMSY@Func <- function(MSEobj, PMobj) {
  apply(MSEobj@F_FMSY <= PMobj@Ref, c(1,2), mean)
}
pFMSY@Label <- function(MSEobj, PMobj) {
  if (PMobj@Ref == 1) return(bquote("Prob." ~ italic("F") ~ "<" ~ italic("F"[MSY])))
  if (PMobj@Ref != 1) return(bquote("Prob." ~ italic("F") ~ "<" ~ .(PMobj@Ref) ~ italic("F"[MSY])))
}
saveWrite("pFMSY")

# --- Yield relative to Reference Yield ----
Yield <- new("PM")
Yield@Name <- "Yield relative to Reference Yield"
Yield@Func <- function(MSEobj, PMobj) MSEobj@C / array(MSEobj@OM$RefY, dim=dim(MSEobj@C))
Yield@Label <- bquote("Yield / " ~italic("F"[MSY]) ~ "Yield")
saveWrite("Yield")


# --- Long-term Yield relative to Reference Yield ----
LTY <- new("PM")
LTY@Name <- "Long-Term Yield relative to Reference Yield"
LTY@Func <- function(MSEobj, PMobj) {
  y1 <- MSEobj@proyears - 4
  y2 <- MSEobj@proyears
  if (y1 < 1) y1 <- 1
  relY <-(MSEobj@C / array(MSEobj@OM$RefY, dim=dim(MSEobj@C)))
  relY[,,y1:y2]
}
LTY@Label <- bquote("Long-Term Yield / " ~italic("F"[MSY]) ~ "Yield")
saveWrite("LTY")


# --- Short-term Yield relative to Reference Yield ----
STY <- new("PM")
STY@Name <- "Short-Term Yield relative to Reference Yield"
STY@Func <- function(MSEobj, PMobj) {
  y1 <- 1 
  y2 <- 5
  if (MSEobj@proyears < 5) y2 <- MSEobj@proyears
  relY <-(MSEobj@C / array(MSEobj@OM$RefY, dim=dim(MSEobj@C)))
  relY[,,y1:y2]
}
STY@Label <- bquote("Short-Term Yield / " ~italic("F"[MSY]) ~ "Yield")
saveWrite("STY")

# --- Average Annual Variability in Yield ----
AAVY <- new("PM")
AAVY@Name <- "Average Annual Variablity in Yield"
AAVY@Func <- function(MSEobj, PMobj) {
  MSEobj@C[(!is.finite(MSEobj@C[, , , drop = FALSE]))] <- 0  # if catch is NAN or NA, make it 0
  MSEobj@C[MSEobj@C < 0.1] <- 0 # tiny catches go to zero
  y1 <- 1 
  y2 <- MSEobj@proyears
  ys1 <- y1:(y2-1)
  ys2 <- ys1+1
  apply(abs(MSEobj@C[,,ys1, drop=FALSE] - MSEobj@C[,,ys2, drop=FALSE]), c(1,2), mean, na.rm=TRUE)/
    apply(MSEobj@C[, ,y1:y2, drop=FALSE], c(1,2), mean, na.rm=TRUE) * 100
}
AAVY@Label <- "Average Annual Variability in Yield (%)"
saveWrite("AAVY")

# --- Probability AAVY is greater than Ref % ----
pAAVY <- new("PM")
pAAVY@Name <- "Probability AAVY is less than Ref %"
pAAVY@Ref <- 25
pAAVY@RP <- 0.8
pAAVY@Func <- function(MSEobj, PMobj) {
  MSEobj@C[(!is.finite(MSEobj@C[, , , drop = FALSE]))] <- 0  # if catch is NAN or NA, make it 0
  MSEobj@C[MSEobj@C < 0.1] <- 0 # tiny catches go to zero
  y1 <- 1 
  y2 <- MSEobj@proyears
  ys1 <- y1:(y2-1)
  ys2 <- ys1+1
  if (PMobj@Ref < 1) Ref <- PMobj@Ref * 100 
  if (PMobj@Ref > 1) Ref <- PMobj@Ref
  apply(abs(MSEobj@C[,,ys1, drop=FALSE] - MSEobj@C[,,ys2, drop=FALSE]), c(1,2), mean, na.rm=TRUE)/
    apply(MSEobj@C[, ,y1:y2, drop=FALSE], c(1,2), mean, na.rm=TRUE) * 100 <= Ref
}
pAAVY@Label <- function(MSEobj, PMobj) bquote("Prob." ~ italic("AAVY") ~ "<" ~ .(PMobj@Ref) * "%")
saveWrite("pAAVY")


# --- Average Annual Variability in Effort ----
AAVE <- new("PM")
AAVE@Name <- "Average Annual Variablity in Effort"
AAVE@Func <- function(MSEobj, PMobj) {
  y1 <- 1 
  y2 <- MSEobj@proyears
  ys1 <- y1:(y2-1)
  ys2 <- ys1+1
  apply(abs(MSEobj@Effort[,,ys1, drop=FALSE] - MSEobj@Effort[,,ys2, drop=FALSE]), c(1,2), mean)/
    apply(MSEobj@Effort[, ,y1:y2, drop=FALSE], c(1,2), mean)* 100
}
AAVE@Label <- "Average Annual Variability in Effort (%)"
saveWrite("AAVE")

# --- Probability AAVY is greater than Ref % ----
pAAVE <- new("PM")
pAAVE@Name <- "Probability AAVE is less than Ref %"
pAAVE@Ref <- 25
pAAVE@RP <- 0.8
pAAVE@Func <- function(MSEobj, PMobj) {
  y1 <- 1 
  y2 <- MSEobj@proyears
  ys1 <- y1:(y2-1)
  ys2 <- ys1+1
  if (PMobj@Ref < 1) Ref <- PMobj@Ref * 100 
  if (PMobj@Ref > 1) Ref <- PMobj@Ref
  apply(abs(MSEobj@Effort[,,ys1, drop=FALSE] - MSEobj@Effort[,,ys2, drop=FALSE]), c(1,2), mean)/
    apply(MSEobj@Effort[, ,y1:y2, drop=FALSE], c(1,2), mean)* 100 <= Ref
}
pAAVE@Label <- function(MSEobj, PMobj) bquote("Prob." ~ italic("AAVE") ~ "<" ~ .(PMobj@Ref) * "%")
saveWrite("pAAVE")

