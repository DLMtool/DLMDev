# ========================================================================================
# === DLMtool IOTC Case study 2: Yellowfin tuna  =========================================
# ========================================================================================
#
# Here we use a data-rich assessment to populate an operating model to:
#
# -  Investigate a wide range of toolkit functionality
# -  Identify areas where the toolkit needs features
# -  Evaluate the potential for interim management my MP
# -  Quantify value of information in this fishery management system


# === Setup (only required if new R session) =========================================

library(DLMtool)  
setup()

# Set the working directory and load some extras for this session ====================

source("IOTC extras.R")
source("StochasticSRA_SL.R")



# = A === Operating model specification ==============================================

# - A1 --- Read stock object from file ----------------------------------------
#

LOT_Stock<-new('Stock',"DLMtool csv/LOT_Stock.csv")



# - A2 --- Read fleet object from file ----------------------------------------

LOT_Fleet<-new('Fleet',"DLMtool csv/LOT_Fleet.csv")
LOT_Fleet@Esd<-c(0.1,0.3)



# - A3 --- Build OM With Imprecise and Biased observations and perfect implementation

LOT<-new('OM',LOT_Stock,LOT_Fleet,Imprecise_Biased,Perfect_Imp)
LOT@Name = "IOTC longtail tuna 2015"

# and add the primary source

LOT@Source = "IOTC-2015-WPNT05-DATA13"

# we should probably also save a copy

save(LOT,file = "LOT.Rdata")



# - A3 --- Load the LOT data file and filter MPs by feasibility --------------------------
#
# Since we know that some data are not available are going to load the
# data file and only runMSE for those MPs that pass the Can function:

LOT_Data<-new("Data","DLMtool csv/LOT_Data.csv")
Feasible<-Can(LOT_Data)



# - A4 --- Condition the operating model on StochasticSRA --------------------------------
#
# Here we take the  simple ranges from the basic operating model and use 
# catch at age data by year and a annual catch history to produce 
# plausible operating model scenarios in the @cpars slot

dat<-read.csv("IOTC-2016-WPNT-DATA09-SFdata.csv") # read in the raw Catch at length data
CAL<-dat[,14:ncol(dat)]  # select only frequency by  length class
nl<-ncol(CAL)           

CALtab<-aggregate(as.vector(as.matrix(CAL)),by=list(rep(dat$Year,nl),rep(1:nl,each=nrow(CAL))),sum)
lengths<-rep(CALtab[,2],CALtab[,3])
hist(lengths,col='light blue',border='white')

muLinf<-mean(LOT@Linf)
muK<-mean(LOT@K)
mut0<-mean(LOT@t0)

CALtab<-CALtab[CALtab$x > 0 & CALtab[,2] <= muLinf,]
yr<-(CALtab[,1]-1950)+1
age<-((-log(1-CALtab[,2]/muLinf))/muK)+mut0
age<-ceiling(age)
CAAtab<-aggregate(CALtab$x,by=list(yr,age),sum)
ages<-rep(CAAtab[,2],CAAtab[,3])
hist(ages,breaks=unique(ages),col='orange',border='white')

CAA<-array(0,c(LOT@nyears,max(LOT@maxage, max(age))))
CAA[as.matrix(CAAtab[,1:2])]<-CAAtab[,3]
CAA<-CAA[,1:LOT@maxage]
Chist<-LOT_Data@Cat[1,]

LOT@nsim<-200
LOT_SRA<-StochasticSRA_SL(LOT,CAA,Chist,nits=2000,Umax=0.95)
plot(LOT_SRA)


# In some of these simulations the stock crashes and fishing mortality
# rates increase to very high levels.
#
# Assuming that depletion is greater than 5% we can strip out the
# cpars samples that were unrealistic. 

sims<-LOT_SRA@cpars$dep>0.05
LOT_SRA<-Strip_cpars(LOT_SRA,sims)
plot(LOT_SRA)
save(LOT_SRA,file="LOT_SRA.Rdata")





# = B === Run a preliminary MSE ======================================================================
#
# - B1 --- Preliminary MSE -----------------------------------------------------------------------
#
# We now run the first MSE for the MPs that were feasible given our data

LOTprelim<-runMSE(LOT_SRA,Feasible)


# - B2 --- Check Convergence ---------------------------------------------------------------------

Converge(LOTprelim)


# - B3 --- Plot results --------------------------------------------------------------------------

results<-IOTC_plot(LOTprelim,Bref=0.5,Fref=0.5,Bsat=0.6,Fsat=0.6,Blow=0,Flow=0)



# = D === Satisficing =================================================================================


cond<-results$PB>0.6 & results$LTY >0.6
satMPs=LOTprelim@MPs[cond]
LOT_MSE<-Sub(LOTprelim,MPs=LOTprelim@MPs[cond])
IOTC_plot(LOT_MSE,Bref=0.5,Fref=0.5,Bsat=0.6,Fsat=0.6,xlim=c(0.3,1),ylim=c(0.3,1))


# = C === Robustness ==================================================================================
#
# - C1 --- Implementation error - overages ------------------

LOT_R1<-LOT
LOT_R1@TACFrac<-c(1,1.5)
LOT_R1@TACSD<-c(0,0)

LOTrob1<-runMSE(LOT_R1,satMPs)
IOTC_plot(LOTrob1,Bref=0.5,Fref=0.5,Bsat=0.6,Fsat=0.6,xlim=c(0.3,1),ylim=c(0.3,1))







LOT_Data@Dep = mean(LOT_SRA@cpars$dep)
LOT_Data@CV_Dep = sd(LOT_SRA@cpars$dep)/mean(LOT_SRA@cpars$dep)
LOT_Data@Abun = mean(LOT_SRA@cpars$SSB[,66])
LOT_Data@CV_Abun = sd(LOT_SRA@cpars$SSB[,66])/mean(LOT_SRA@cpars$SSB[,66])




# = B === Run a preliminary MSE =============================================
#
# - B1 --- List all available MPs and run the MSE for all---------------

MPs = c( avail('Output'), avail('Input'))

MPs = MPs[!grepl("BK",MPs) & !grepl("_ML", MPs) & !grepl("_CC", MPs)]


# !!!!!!! Takes ~ 15 minutes You may want to load this !!!!!!!!!
prelimMSE = runMSE( YFT, MPs)
save( prelimMSE, file = "PrelimMSE.Rdata" )
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


load( file = "PrelimMSE.Rdata" )


# - B2 --- Check convergence -------------------------------------------

Conv<-Converge( prelimMSE )

# All convergence diagnostics were satisfied with the exception of 
# B50 which experiences upticks as single simulations drop below
# 50% of BMSY. Since the rankings for this metric are stable, I'm
# going to ignore the warning and consider the results indicative. 


# - B3 --- Conduct initial satisficing --------------------------------- 
# 
# Here we will select MPs that can achieve:
#
# - over 90% long-term-yield (ie in over 90% of simulations yield
#   was higher than half FMSY)
#
# - over 90% Biomass > 50% BMSY (ie in over 90% of simulations
#   biomass was higher than half of BMSY)

Perf = NOAA_plot(prelimMSE)
cond = Perf$LTY > 90 & Perf$B50 > 90
sum(cond)
satMPs = prelimMSE@MPs[cond]

# Only 36 MPs passed satisficing requirements. 
#
# Lets create a new MSE object that is a subset of the 
# preliminary run 

MSE = Sub( prelimMSE, satMPs)


# - B4 --- Create a custom performance plot ----------------------------
#
# We need a simple way of viewing our MSEs with respect to the 
# satisficing requirements above:

IOTC_plot = function( MSEobj, Bref = 0.75, Fref = 0.75, 
                              Bsat = 0.8, Fsat = 0.8,
                              Blow = 0.5, Flow = 0.5 ){
  
  cols = rep(makeTransparent(c("Black","Red","blue","green","orange")),99)
  yend = max(MSEobj@proyears) - (4:0)
  PB = apply(MSEobj@B_BMSY > Bref, 2, mean)
  LTY = apply(MSEobj@C[,,yend] / MSEobj@OM$RefY > Fref,2,mean)
  xlim = range(PB) + c(-1,1) * sd(PB) * 0.25
  ylim = range(LTY) + c(-1,1) * sd(LTY) * 0.25
  if(xlim[1] < Blow) xlim[1] = Blow
  if(ylim[1] < Flow) ylim[1] = Flow
  
  plot(PB, LTY, col = "white", xlim=xlim, ylim=ylim, 
       xlab = paste0("Prob. biomass over ", round(Bref*100,1),"% of BMSY"),
       ylab = paste0("Prob. yield over ", round(Fref*100,1),"% of FMSY"),
       main = paste("MSE tradeoffs for:", MSEobj@Name))
  abline( v = c(0,1), col='#99999950', lwd = 2 )
  abline( h = c(0,1), col='#99999950', lwd = 2 )
  abline( v = Bsat, col = '#99999950', lwd = 2, lty = 2 )
  abline( h = Fsat, col = '#99999950', lwd = 2, lty = 2 )
  text( PB, LTY, MSEobj@MPs, col=cols, font=2)
  data.frame(PB,LTY,row.names=MSEobj@MPs)
  
}

#IOTC_plot(MSE, Bref = 0.5, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.55, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.6, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.65, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.7, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.75, Fref = 0.5, Bsat = 0.8, Fsat = 0.8)

#IOTC_plot(MSE)
#IOTC_plot(MSE, Bref = 0.75, Fref = 0.6, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.75, Fref = 0.65, Bsat = 0.8, Fsat = 0.8)
#IOTC_plot(MSE, Bref = 0.75, Fref = 0.7, Bsat = 0.8, Fsat = 0.8)
IOTC_plot(MSE, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)



# = C === Robustness testing ===================================================

# - C1 --- Indices --------------------------------------------------------
# 
# Stock assessments of highly migratory tunas often rely on CPUE indices
# of abundance. While these are often standardized to account for changes
# in fishing that may alter the catchability of gear (e.g. depth, bait,
# location, season) it is difficult to account for temporal shifts in
# catchabiliity driven by technology creep or subtle changes in targetting
# that are not documented. 
#
# We conduct a robustness test that assumes that there have been 2% 
# annual increases in fishing efficiency and that CPUE indices are 
# therefore flatter than they should be. 
#
# As the principal determinant of depletion for the assessment we assume
# that depletion is similarly affected:

YFTrob1 = YFT
YFTrob1@qinc = c(2,2) # 2% increase in fishing efficiency
YFTrob1@beta = c(0.5,0.5) # assuming one-way trip around a beta of 0.5
YFTrob1@D = YFT@D / 1.02^(YFT@nyears)
YFTrob1@Name = "Robustness test 1: 2% catchability inc"
YFTrob1@cpars$Dbias=runif(YFT@nsim,1.5,2)

# We now run the MSE for the satisficed MPs

MSErob1 = runMSE( YFTrob1, satMPs )
save( MSErob1, file="MSErob1.Rdata" )

par(mfrow=c(1,2))
IOTC_plot(MSE, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)
IOTC_plot(MSErob1, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)


# - C2 --- Recruitment compensation --------------------------------------
#
# A matter of some controversy in tuna modelling is estimation of the
# stock's recruitment compensation. In fisheries where there is 
# considerable variation in recruitment strength and recruitment is 
# a strong driver of spawning stock biomass, variability in stock 
# level masks the estimation of recruitment compensation and often
# biases it upwards (the mad scientist problem). 
#
# If you need high recruitment at low stock size to reach high
# stock sizes after which you need low recruitment to reach
# low stock sizes you have a pattern that infers high recruitment
# at low stock levels, - high recruitment compensation just due to 
# random recruitment. 
# 
# The current steepness estimates arising from the assessment
# are in the range of:

YFT@h

# Lets specify the half the range from the lower bound and evaluate MP
# robustness

YFTrob2 = YFT
YFTrob2@h = c(YFT@h[1],mean(YFT@h))
YFTrob2@Name = "Robustness test 2: recruitment comp"

MSErob2 = runMSE( YFTrob2, satMPs )
save( MSErob2, file="MSErob2.Rdata" )

par(mfrow=c(1,2))
IOTC_plot(MSE, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)
IOTC_plot(MSErob2, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)


# - C3 --- Natural mortality rate -----------------------------------------
#
# A primary source of uncertainty for short lived tunas is the rate
# of natural mortality. Here we evaluate robustness to assuming the
# lower half of the prior range:

YFTrob3 = YFT
YFTrob3@M = c(YFT@M[1],mean(YFT@M))
YFTrob3@Name = "Robustness test 3: M"

MSErob3 = runMSE( YFTrob3, satMPs )
save( MSErob3, file="MSErob3.Rdata" )

par(mfrow=c(1,2))
IOTC_plot(MSE, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)
IOTC_plot(MSErob3, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)


# - C4 --- Spatial assumptions --------------------------------------------
#
# The stock assessment estimates that YFT consist of two relatively
# discrete areas 1+2 (that are mixed) and 3+4 (that are mixed). 
# Currently the stock is highly viscous and has a probability of 
# individuals staying in a given area (1+2) or (3+4) of:

YFT@Prob_staying

# Lets relax this an assume that perhaps there is more spatial
# mixing than assessed perhaps due to spatial reporting rate
# issues or non-indicative CPUE indices that wrongly infer 
# differential  strong trends among these two areas. 

YFTrob4 = YFT
YFTrob4@Prob_staying = c(0.9,0.9)
YFTrob4@Name = "Robustness test 4: higher mixing"

MSErob4 = runMSE( YFTrob4, satMPs )
save( MSErob4, file="MSErob4.Rdata" )

par(mfrow=c(1,2))
IOTC_plot(MSE, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)
IOTC_plot(MSErob4, Bref = 0.75, Fref = 0.75, Bsat = 0.8, Fsat = 0.8)




# = D === Value of information and Cost of Current Uncertainties ============================
#
# A number of MPs that fared well in robustness testing we
# now subject to value of information analysis to better
# understand whether they could perform better with 
# better quality data. 

MPsel = c("DD4010","IT5","IT10","DAAC","minlenLopt1","DCAC","Itarget1","DBSRA","DD","MCD")
MSEvoi = Sub(MSE, MPs = MPsel)
VOI3(MSEvoi, ncomp=3, maxrow=4, lcex=1.2, cex.axis=1.05)


# = E === Population a real data object for YFT and calculate TACs ===========================
#
# - E1 --- Rip data from SS file structure -----------------------------------------
#
# Use a new custom function to rip data from the SS assessment into
# a valid DLMtool Data format

LOT_Data<-new("Data","DLMtool csv/LOT_Data.csv")


# - E2 --- Calculate available MPs and TACs for these -------------------------------

MPs<-Can(YFTdata)
MPs<-MPs[MPs%in%MPsel]

YFT_TAC<-TAC(YFTdata, MPs)

boxplot(YFT_TAC)
abline(v=YFT_TAC@Ref,lty=2,lwd=2)


# - E3 --- Plot sensitivities ------------------------------------------------------

Sense(YFT_TAC,"IT5")


# ===========================================================================================
# === End of YFT case study =================================================================
# ===========================================================================================


