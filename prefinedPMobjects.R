library(DLMtool)

localDir <- "C:/Users/Adrian/Documents/GitHub" 
pkgpath <- file.path(localDir, "DLMtool")
dataDir <- file.path(pkgpath, "data")
RDir <- file.path(pkgpath, "R")

MSEobj <- runMSE(testOM) # for testing 



# --- Spawning Biomass Relative to SBMSY ----
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
  apply(var[,,y1:y2, drop=FALSE]  >= PMobj@Ref, c(1,2), Stat)
}
SB_SBMSY@Label <- function(PMobj, MSEobj) MakeLab(PMobj, MSEobj)
SB_SBMSY@Var <- "SB_SBMSY"



PMobj <- SB_SBMSY 
SB_SBMSY@Func(MSEobj, PMobj)



MakeLab <- function(PMobj, MSEobj) {
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


switch("test",
                   "prob" = "Prob.",
                   "mean" = "Mean",
                   "median" = "Med.",
                   "sd" = "S.D.",
                   "max" = "Max.",
                   "min" = "Min.",
                   "var" = "Var.",
                   "quantile" = "Quant.",
                   "sum" = "Sum",
       "function")




SB_BMSY

attributes(SB_BMSY2)


SB_BMSY@Ref <- 0.1
SB_BMSY@Func(MSEobj, SB_BMSY)




setMethod("show", signature(object = "PM"), function(object) {
  print(object)
})


call("SB_BMSY2")



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
