# ========================================================================================
# === DLMtool IOTC Case study 2: Yellowfin tuna  =========================================
# ========================================================================================
#
# Here we use a data-rich assessment to populate an operating model to:
#
# -  Investigate a wide range of toolkit functionality
# -  Identify areas where the toolkit needs features
# -  Evaluate the potential for interim management my MP
# -  Evaluate data-rich harvest control rules
# -  Quantify value of information in this fishery management system


# === Setup (only required if new R session) =========================================

library(DLMtool)  
setup()

# Set the working directory and load some extras for this session ====================

setwd("C:/IOTC DLMtool/Case studies/Yellowfin_tuna_IO")

source("IOTC extras.R")


# = A === Operating model specification ==============================================

# - A1 --- Rip assessment estimates ----------------------------------------
#
# Using the function SS2DLM() you will extract MLE (best 
# estimates) of parameter values and variable such as 
# historical fishing mortality rate and fishery selectivity. 

# Use current directory to load SS data / outputs 

YFT = SS2DLM(getwd(), 96)  

# We now also add a seed to the operating model this ensures
# that results are exactly reproducible. 

YFT@seed = 1


# - A2 --- Add observation and implementation error -------------------------
#
# Future versions of SS2DLM will use fits of the assessment model to 
# parameterize the observation error model. For now we borrow the
# observation model Generic_obs from the testOM operating model. 

YFT = Replace(YFT, testOM,"Obs") # take generic observation model from testOM
YFT = Replace(YFT, testOM,"Imp") # take generic implementation 

# Now we have our OM lets name it

YFT@Name = "IOTC YFT 2014 from SS3"

# and add the primary source

YFT@Source = "A. Langley. 2015. IOTC-2015-WPTT17-30_-_YFT_SS3_Stock_Assessment.pdf"

# we should probably also save a copy

save(YFT,file = "YFT.Rdata")


# - A3 --- Add plausible levels of uncertainty to parameter estimates --------
# 
# The current stock assessment includes uncertainty in several 
# parameters and can generate uncertaint estimates in others
# for example the growth parameters:

YFT@Linf
YFT@K

# However the model assumes point value for other parameters
# that is not appropriate in MSE testing which is intended
# to explore credible levels of uncertainty. Such parameters 
# include natural mortality rate and variables such as
# current level of stock depletion:

YFT@D
YFT@M

# In the absence of an MCMC sample for these we impose ranges
# consistent with a mean of thes point values and a 95% 
# probability interval with a CV of 10% for M and 20% for
# depletion:

YFT@M = qlnorm(c(0.025,0.975),log(YFT@M[1]),0.1)
YFT@D = qlnorm(c(0.025,0.975),log(YFT@D[1]),0.2)

# Both of these ranges are arbitrary and should be based on 
# outputs of the assessment or modelling work based on
# other life history parameters (in the case of M) or
# evaluation of catch rate data, spatial extent of fishing
# and / or habitat analysis (in the case of D).
#
# This range in M is likely to be a compression of uncertainty.
# The range in D reflects the relative lack of reliability of
# CPUE indices of abundance (e.g. +/- 2% changes in catcha-
# bility. 


# - A4 --- Add realistic correlation among parameters --------------------
#
# Currently DLMtool does not have the functionality to use outputs
# of the SS assessment  to generate parameter cross correlation 
# (e.g. the covariance file).
#
# DLMtool also does not currently include features to use the 
# Bayesian posterior estimates from an MCMC file (an MCMC)
# (was not available for YFT anyway)
#
# Instead we take the uncertainty in current estimates of 
# growth parameters and M and impose correlation:

YFT = ForceCor(YFT)



# = B === Run a preliminary MSE =============================================
#
# - B1 --- List all available MPs and run the MSE for all---------------

MPs = c( avail('Output'), avail('Input'))

MPs = MPs[!grepl("BK",MPs) & !grepl("_ML", MPs) & !grepl("_CC", MPs)]


# !!!!!!! Takes ~ 20 minutes: You may want to load this !!!!!!!!
#
# prelimMSE = runMSE( YFT, MPs)
# save( prelimMSE, file = "PrelimMSE.Rdata" )
#
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
# We need a simple way of viewing our MSEs that have variable
# performance metrics and different target levels for 
# satisficing:

IOTC_plot = function( MSEobj, Bref = 0.75, Fref = 0.75,    # Reference levels for fractions of BMSY and FMSY
                              Bsat = 0.8, Fsat = 0.8,      # Satisficing lines plotted at these levels
                              Blow = 0.5, Flow = 0.5 ){    # The lower bound on the axes
  
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
YFTrob1@cpars$Dbias=runif(YFT@nsim,1.5,2) # Depletion / stock status is always
#                                           optimistic and 50-100% higher than 
#                                           in reality

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

YFTdata = SS2Data(getwd())
summary(YFTdata)

# - E2 --- Calculate available MPs and TACs for these -------------------------------

MPs<-Can(YFTdata)
MPs<-MPs[MPs%in%MPsel]

YFT_TAC<-TAC(YFTdata, MPs)
boxplot(YFT_TAC,ylim=c(0,100000))
abline(v=YFT_TAC@Ref,lty=2,lwd=2)


# - E3 --- Plot sensitivities ------------------------------------------------------

Sense(YFT_TAC,"IT5")




# = F === Test of harvest control rules =====================================================


# - F1 --- Initial Run --------------------------------------------------------

source('IOTC HCRs.R')

MPs<-c("HCR_2_2_1","HCR_2_4_1","HCR_2_5_1","HCR_1_4_1","HCR_2_4_5","HCR_2_4_15")

MSE_HCR<-runMSE(YFT,MPs)

IOTC_plot(MSE_HCR)

YFT = Replace(YFT, testOM,"Obs") # take generic observation model from testOM
YFT = Replace(YFT, testOM,"Imp") # take generic implementation 


Stock <- SubOM(YFT, "Stock")
Fleet <- SubOM(YFT, "Fleet")
Obs <- Imprecise_Biased
Imp <- Perfect_Imp

YFT1 <- new("OM", Stock, Fleet, Obs, Imp)


MSE_HCR1<-runMSE(YFT1,MPs)
IOTC_plot(MSE_HCR1)

YFT2 <- new("OM", Stock, Fleet, Perfect_Info, Imp)
MSE_HCR2<-runMSE(YFT2,MPs)
IOTC_plot(MSE_HCR2)

YFT3 <- new("OM", Stock, Fleet, Precise_Unbiased, Imp)
MSE_HCR3<-runMSE(YFT3,MPs)
IOTC_plot(MSE_HCR3)




# ===========================================================================================
# === End of YFT case study =================================================================
# ===========================================================================================


