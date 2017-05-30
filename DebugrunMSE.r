library(DLMtool)

if (!exists("MPs")) MPs <- "matlenlim" # c("FMSYref", "curE")
if (!exists("proyears")) proyears <- 28
if (!exists("interval")) interval <- 1
if (!exists("pstar")) pstar <- 0.5
if (!exists("maxF")) maxF <- 0.8
if (!exists("timelimit")) timelimit <- 1
if (!exists("reps")) reps <- 1
if (!exists("cpars")) cpars <- NULL
if (!exists("CheckMPs")) CheckMPs <- FALSE
if (!exists("Hist")) Hist <- FALSE
if (!exists("ntrials")) ntrials <- 50
if (!exists("fracD")) fracD <- 0.05

if (!exists("OM")) OM <- new("OM", Albacore, Generic_fleet, Perfect_Info, Perfect_Imp)

MPs <- "DDes"

test <- runMSE(Rougheye_Rockfish_BC, MP="DDes")

sum(is.na(test@F_FMSY))

OM <- new("OM", Albacore, Generic_fleet, Perfect_Info, Perfect_Imp)
OM <- makePerf(OM)
test <- runMSE(OM, MP="FMSYref", interval=2)

test@F_FMSY[1,,40:50]
