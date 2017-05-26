library(DLMtool)

localDir <- "C:/Users/Adrian/Documents/GitHub" 
pkgpath <- file.path(localDir, "DLMtool")
dataDir <- file.path(pkgpath, "data")
RDir <- file.path(pkgpath, "R")

MSEobj <- runMSE(testOM) # for testing 
testOM2 <- testOM
testOM2@seed <- 101
MSEobj2 <- runMSE(testOM2) # for testing 


# --- Prob Spawning Biomass > 0.5 SBMSY ----
SB_SBMSY <- new("PM")
SB_SBMSY@Name <- "Spawning Biomass Relative to SBMSY"
SB_SBMSY@Description <- "Probability spawning biomass in last 5 years is above Ref * SBMSY"
SB_SBMSY@Ref <- 0.5 
SB_SBMSY@Stat <- "mean"
SB_SBMSY@Y1 <- -5
SB_SBMSY@Y2 <- NA
SB_SBMSY@Func <- function(MSEobj, PMobj) {
  var <- MSEobj@SSB/array(MSEobj@OM$SSBMSY, dim=dim(MSEobj@SSB))
  yrs <- ChkYrs(MSEobj, PMobj@Y1, PMobj@Y2)
  y1 <- yrs$y1
  y2 <- yrs$y2
  if (class(PMobj@Stat) == "character") Stat <- get(PMobj@Stat)
  if (class(PMobj@Stat) == "function") Stat <- PMobj@Stat
  apply(var[,,y1:y2, drop=FALSE]  >= PMobj@Ref, c(1,2), Stat)
}
SB_SBMSY@Label <- function(MSEobj, PMobj) MakeLab(MSEobj, PMobj)
SB_SBMSY@Var <- "SB_SBMSY"


SB_SBMSY@Func(MSEobj, SB_SBMSY)


# --- Prob Fishing Mortality > FMSY ----
F_FMSY <- new("PM")
F_FMSY@Name <- "Fishing Mortality"
F_FMSY@Description <- "Probability fishing mortality in last 5 years is below Ref * FMSY"
F_FMSY@Ref <- 1
F_FMSY@Stat <- "mean"
F_FMSY@Y1 <- -5
F_FMSY@Y2 <- NA
F_FMSY@Func <- function(MSEobj, PMobj) {
  yrs <- ChkYrs(MSEobj, PMobj@Y1, PMobj@Y2)
  y1 <- yrs$y1
  y2 <- yrs$y2
  if (class(PMobj@Stat) == "character") Stat <- get(PMobj@Stat)
  apply(MSEobj@F_FMSY[,,y1:y2, drop=FALSE]  <= PMobj@Ref, c(1,2), Stat)
}
F_FMSY@Label <- function(MSEobj, PMobj) MakeLab(MSEobj, PMobj)
F_FMSY@Var <- "F_FMSY"


F_FMSY@Func(MSEobj, F_FMSY)
F_FMSY@Label(MSEobj, F_FMSY)

xydf(MSEobj, SB_SBMSY, F_FMSY)

xydf(list(MSEobj, MSEobj2), SB_SBMSY, F_FMSY)

PM1 <- SB_SBMSY
PM2 <- F_FMSY


xydf <- function(MSEobj, PM1, PM2, MSEname=NULL, Can=NULL) {
  
  # add LRP TRP etc 
  
  lst <- list()
  if (is.null(MSEname)) MSEname <- 1:length(MSEobj)
  # Create a x,y data frame
  for (X in 1:length(MSEobj)) {
    if (class(MSEobj) == "MSE") MSE <- MSEobj
    if (class(MSEobj) == "list") MSE <- MSEobj[[X]]
    x <- apply(PM1@Func(MSE, PM1), 2, PM1@Stat)
    y <- apply(PM2@Func(MSE, PM2), 2, PM2@Stat)
    
    lst[[X]] <- data.frame(MP=MSE@MPs, x=x, y=y, MSE=MSEname[X])
  }
  DF <- do.call("rbind", lst)
  
  # add labels 
  out <- list()
  out$DF <- DF 
  if (class(PM1@Label) == "function") out$xlab <- PM1@Label(MSE, PM1)
  if (class(PM1@Label) == "character")  out$xlab <- PM1@Label
  if (class(PM2@Label) == "function")  out$ylab <- PM2@Label(MSE, PM1)
  if (class(PM2@Label) == "character")  out$ylab <- PM2@Label
  
  out
}



myPlot <- function(MSEobj, PM1, PM2, MSEname=NULL, Can=NULL) {
  

  
  F1a <- ggplot(DF, aes(x=x, y=y, label=MP)) + 
    facet_wrap(~MSE, ncol=3) + 
    geom_point(size=2) + 
    geom_label_repel(show.legend=FALSE) + 
    scale_x_continuous(breaks = seq(0, 1, by=0.2), limits=c(0,1)) +
    ylim(0,1.6) + 
    xlab(expression("Probability Biomass > 0.2 B"[0])) +
    ylab("Relative Yield") +
    scale_colour_discrete(guide = FALSE)  +
    theme_bw() +
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=14))
  
  F1a 
}




PMobj <- SB_SBMSY 
SB_SBMSY@Func(MSEobj, PMobj)







MakeLab <- function(MSEobj, PMobj) {
  yrs <- ChkYrs(MSEobj, PMobj@Y1, PMobj@Y2)
  years <- paste0(yrs[1], "-", yrs[2])
  StatText <- switch(PMobj@Stat,
                     "prob" = "Prob.",
                     "mean" = "Mean",
                     "median" = "Med.",
                     "sd" = "S.D.",
                     "max" = "Max.",
                     "min" = "Min.",
                     "var" = "Var.",
                     "quantile" = "Quant.",
                     "sum" = "Sum",
                     "statistic")
  RefText <- as.character(PMobj@Ref)
  if (is.na(RefText)) RefText <- NULL
  VarText <- switch(PMobj@Var,
                    "F_FMSY" = bquote(italic("F")*"/"*italic("F"[MSY])),
                    "SB_SB0" = bquote(italic("SB")*"/"*italic("SB"[0])),
                    "SB_SBMSY" = bquote(italic("SB")*"/"*italic("SB"[MSY])),
                    "B_BMSY" = bquote(italic("B")*"/"*italic("B"[MSY])),
                    "B_B0" = bquote(italic("B")*"/"*italic("B"[0])),
                    "Yield" = "Yield",
                    "AAVY" = "AAVY",
                    "AAVE" = "AAVE",
                    "something else")
  YearText <- paste0("(Years ", as.character(years), ")")
  lab <- bquote(atop(.(StatText) ~ .(VarText) ~ ">" ~ .(RefText), .(YearText)))
  lab  
}


if (VarText == "Yield") {
  lab <- bquote(atop(.(StatText) ~ .(VarText) ~ .(SignText) ~ .(RefText) ~ italic("F"[MSY]) ~
                       "Yield", .(YearText)))
  if (RefText == "1") lab <- bquote(atop(.(StatText) ~ .(VarText) ~ .(SignText) ~ "relative to" 
                                         ~ italic("F"[MSY]) ~ "Yield ", .(YearText)))
}






SB_BMSY


SB_BMSY@Ref <- 0.1
SB_BMSY@Func(MSEobj, SB_BMSY)






# Write Roxygen code 



# Save object to data directory
save(SB_BMSY, file = file.path(dataDir, "SB_BMSY.RData"), compress = "bzip2")




# --- Long-term Yield ----
LTY <- new("PM")
LTY@Name <- "Long-term Yield"
LTY@Description <- "Probability ..."
LTY@Ref <- 0.5 
LTY@Stat <- mean

LTY@Func <- function(MSEobj) {
  RelY <- MSEobj@C / array(MSEobj@OM$RefY, dim=dim(MSEobj@C))
  pyears <- MSEobj@proyears
  if (pyears > 4) y1 <- pyears - 4 
  if (pyears <= 4) y1 <- 1
  nyr <- length(y1:pyears)
  apply(RelY[,,y1:pyears, drop=FALSE]  > LTY@Ref, c(1,2), mean)
}
save(LTY, file = file.path(dataDir, "LTY.RData"), compress = "bzip2")


STY <- new("PM")
STY@Name <- "Short-term Yield"
STY@Description <- "Probability ..."
STY@Ref <- 0.5 
STY@Stat <- mean
STY@Func <- function(MSEobj) {
  RelY <- MSEobj@C / array(MSEobj@OM$RefY, dim=dim(MSEobj@C))
  pyears <- MSEobj@proyears
  y1 <- 1 
  if (pyears > 5) y2 <- 5
  if (pyears <= 5) y2 <- pyears
  nyr <- length(y1:y2)
  apply(RelY[,,y1:y2, drop=FALSE]  > STY@Ref, c(1,2), mean)
}
save(STY, file = file.path(dataDir, "STY.RData"), compress = "bzip2")




SB_B0 <- new("PM")
SB_B0@Name <- "Spawning Biomass Relative to SB0"
SB_B0@Description <- "Probability ..."
SB_B0@Ref <- 0.5 
SB_B0@Stat <- mean
SB_B0@Func <- function(MSEobj) {
  var <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB))
  pyears <- MSEobj@proyears
  if (pyears > 4) y1 <- pyears - 4 
  if (pyears <= 4) y1 <- 1
  apply(var[,,y1:pyears, drop=FALSE]  > SB_B0@Ref, c(1,2), mean)
}
save(SB_B0, file = file.path(dataDir, "SB_B0.RData"), compress = "bzip2")


# F_FMSY <- new("PM")
# F_FMSY@Name <- "Fishing Mortality Relative to FMSY"
# F_FMSY@Description <- "Probability of Overfishing..."
# F_FMSY@Ref <- 1 
# F_FMSY@Stat <- mean
# F_FMSY@Func <- function(MSEobj) {
#   var <- MSEobj@F_FMSY
#   pyears <- MSEobj@proyears
#   y1 <- 1 
#   if (pyears > 5) y2 <- 5
#   if (pyears <= 5) y2 <- pyears
#   nyr <- length(y1:y2)
#   apply(var[,,y1:y2, drop=FALSE]  < F_FMSY@Ref, c(1,2), mean)
# }
# save(F_FMSY, file = file.path(dataDir, "F_FMSY.RData"), compress = "bzip2")
# 
# 



#'  Long-Term Yield Peformance Metric Function
#'
#'  An object of class PM
#'
"LTY"

#'  Short-Term Yield Peformance Metric Function
#'
#'  An object of class PM
#'
"STY"

#'  Spawning Biomass Relative to SBMSY
#'
#'  An object of class PM
#'
"SB_BMSY"

#'  Spawning Biomass Relative to SB0
#'
#'  An object of class PM
#'
"SB_B0"

#'  Fishing Mortality Relative to FMSY
#'
#'  An object of class PM
#'
"F_FMSY"

