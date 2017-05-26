library(DLMtool)
setup()
MSEobj <- runMSE(testOM)


test <- function(MSEobj, funs=list()) {
  for (X in 1:length(funs)) {
    if (class(funs[[X]])== "character") {
      obj <- get(funs[[X]])
    } else obj <- funs[[X]]  
    # do some checks on the PM object 
    
    print(apply(obj@Func(MSEobj), 2, obj@Stat))
  }
  
}

funs <- avail('PM')
test(MSEobj, list(funs))





file <- "C:/Users/Adrian/Desktop/test.csv"
SEDAR46 <- new("PM", file)




file <- "C:/Users/Adrian/Desktop/DFO_PM.csv"
DFO_PM <- new("PM", file)
save(DFO_PM, file = file.path(dataDir, "DFO_PM.RData"), compress = "bzip2")










PM3 <- new("PM", PM=data.frame(Var=c("F_FMSY", "B_B0", "F_FMSY", "SB_SB0"),
                        Stat=c("mean", "mean", "mean", "mean"),
                        Ref=c(NA, NA, NA, NA),
                        Y1=c(1,1,1,1),
                        Y2=rep(NA, 4),
                        Limit=c(rep(NA, 4))))



tt <- CalcPM(MSEobj, "F_FMSY", "prob", -10, ref=0.25)
tt

t2 <- Perform(MSEobj, SEDAR46)
t2 

left_join(t2@List[[1]]$dat, t2@List[[2]]$dat, by="MP")


slotNames(t2)





calcPM(MSEobj, "F_FMSY", "mean")

PMobj <- PM2
tt <- Perform(MSEobj, PM2)





Perform(MSEobj, SEDAR46)

PMobj <- SEDAR46 

Perform(MSEobj, SEDAR46)
doPerf <- Perform(MSEobj, SEDAR46)

PMobj 

plot.PM <- function(PMobj, MSEobj, xind=NULL, yind=NULL) {
  Perf <- Perform(MSEobj, SEDAR46)
  if (is.null(xind)) xind <- seq(1, to=nrow(PMobj@PM), by=2)
  if (is.null(yind)) yind <- seq(2, to=nrow(PMobj@PM), by=2)
  
  if (length(xind) < length(yind)) {
    xind <- rep(xind, length(yind))
    xind <- xind[1:length(yind)]
  }
  if (length(yind) < length(xind)) {
    yind <- rep(xind, length(xind))
    yind <- yind[1:length(xind)]    
  }
  
  PM <- PMobj@PM 
  nplots <- length(xind)
  lst <- vector("list", nplots)
  for (X in 1:nplots) {
    x <- subset(Perf, PM==xind[X])$Val
    y <- subset(Perf, PM==yind[X])$Val
    MP <- as.character(subset(Perf, PM==xind[X])$MP)
    xlimit <- subset(Perf, PM==xind[X])$Limit
    xpass <- subset(Perf, PM==xind[X])$Pass
    xstat <- subset(Perf, PM==xind[X])$Stat
    xsign <- subset(Perf, PM==xind[X])$Sign
    xvar  <- subset(Perf, PM==xind[X])$Var
    xref <- subset(Perf, PM==xind[X])$Ref
    xyears <- subset(Perf, PM==xind[X])$Years
    
    ylimit <- subset(Perf, PM==yind[X])$Limit
    ystat <- subset(Perf, PM==yind[X])$Stat
    ysign <- subset(Perf, PM==yind[X])$Sign
    yvar  <- subset(Perf, PM==yind[X])$Var
    yref <- subset(Perf, PM==yind[X])$Ref
    yyears <- subset(Perf, PM==yind[X])$Years
    ypass <- subset(Perf, PM==yind[X])$Pass 
    
    pass <- as.logical(xpass * ypass)
    if (all(is.na(ypass))) pass <- xpass
    if (all(is.na(xpass))) pass <- ypass
    # ADD CAN HERE 
    dat <- data.frame(x=x, y=y, MP=MP, xlimit=xlimit, ylimit=ylimit, xpass=xpass, 
                      ypass=ypass, pass=pass)
    
    lst[[X]]$dat <- dat
    lst[[X]]$xlab <- MakeAxLabel(xstat[X], xvar[X], xsign[X], xref[X], xyears[X])
    lst[[X]]$ylab <- MakeAxLabel(ystat[X], yvar[X], ysign[X], yref[X], yyears[X])
  }  
  
  lst

}


dat <- lst[[1]]
plot(dat$dat$x, dat$dat$y, xlab=dat$xlab, ylab=dat$ylab)


MakeAxLabel <- function(stat, var, sign, ref, years) {
  StatText <- switch(as.character(stat),
                     "prob" = "Prob.",
                     "mean" = "Mean",
                     "median" = "Med.",
                     "sd" = "S.D.",
                     "max" = "Max.",
                     "min" = "Min.",
                     "var" = "Var.",
                     "quantile" = "Quant.")
  SignText <- as.character(sign)
  if (!is.null(SignText)) if(is.na(SignText)) SignText <- NULL
  if (!is.null(SignText) && SignText != "<" && SignText != ">") SignText <- NULL
  RefText <- as.character(ref)
  if (is.na(RefText)) RefText <- NULL
  VarText <- switch(as.character(var),
                    "F_FMSY" = bquote(italic("F")*"/"*italic("F"[MSY])),
                    "SB_SB0" = bquote(italic("SB")*"/"*italic("SB"[0])),
                    "SB_SBMSY" = bquote(italic("SB")*"/"*italic("SB"[MSY])),
                    "B_BMSY" = bquote(italic("B")*"/"*italic("B"[MSY])),
                    "B_B0" = bquote(italic("B")*"/"*italic("B"[0])),
                    "Yield" = "Yield",
                    "AAVY" = "AAVY",
                    "AAVE" = "AAVE")
  YearText <- paste0("(Years ", as.character(years), ")")
  listvars <- list(StatText, VarText, SignText, RefText, YearText)
  bquote(.(StatText) ~ .(VarText) ~ .(SignText) ~ .(RefText) ~ .(YearText))
  
}






cat(cat(StatText, VarText, SignText, RefText, YearText), ":\n\n", sep="")


xs <- seq(from=1, to=nrow(PMobj), by=2)
ys <- seq(from=2, to=nrow(PMobj), by=2)
nplots <- length(xs)
lst <- list()







myperf <- Perform(MSEobj, PMobj)



PM1 
PM2 
PM3 


library(tidyr)
library(dplyr)

MSEobj2 <- runMSE(testOM, Hist=TRUE)
NOAA_plot(MSEobj)
# PMobj <- read.csv("C:/Users/Adrian/Desktop/test.csv", stringsAsFactors = FALSE)
myperf <- Perform(MSEobj, PMobj)
# just do one plot and return the object - wrapper code can decide what to do with it

# Base plotting
# record number of years and make intelligent axis labels
# ggplot
ggplot(dat, aes_q(x=as.name(names(dat)[2]), y=as.name(names(dat)[3])))  + geom_point() +
 xlim(0,1) + ylim(0,1)
data <- filter(myperf, (var=="B_B0" & stat=="prob") | var == "Yield")
x <- data %>% filter(var == "B_B0" & stat=="prob") %>% group_by(MP) %>% summarise(x=mean(val))
y <- data %>% filter(var == "Yield") %>% group_by(MP) %>% summarise(y=mean(val))
dat <- left_join(x,y, by="MP")
g <- ggplot(dat, aes(x, y))  + geom_point() + xlim(0,1) + ylim(0,1)
g
data %>% group_by(MP, var) %>% summarise(mean(val))
dat <- data.frame(MP=data$MP[data$var=="B_B0"], x=data$val[data$var=="B_B0"],
                 y=data$val[data$var=="Yield"])
tt <- calcPM(MSEobj, var=vars[i], stat=stats[i], y1=y1[i], y2=y2[i])
tt



myPerf <- Perform(MSEobj, f)
library(ggplot2)
ggplot(myPerf, aes())
calcPM(MSEobj, "B_B0", "median", -10)
calcPM(MSEobj, "Yield", "median", 1, 5)
calcPM(MSEobj, "Yield", "mean", 1, 5)
calcPM(MSEobj, "Yield", "mean", -5)
calcPM(MSEobj, "AAVY", ref=0.15)
calcPM(MSEobj, "AAVE", "mean", y1=1, y2=15)


#'  Example Performance Metrics Stock
#'
#'  An example performance metric object 
#'
"ExamplePM"
