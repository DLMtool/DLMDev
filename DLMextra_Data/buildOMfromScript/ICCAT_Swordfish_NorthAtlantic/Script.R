#---
#title: "Swordfish Stock Evaluation"
#author: "Alex Hanke"
#date: "November 22, 2016"
#output: word_document
#---

avail("Stock")
class?Stock
MyStock = Bluefin_tuna
  MyStock@ Name  =      "Swordfish"
  MyStock@ maxage =     15                     # FishBase
  MyStock@ R0    =      1000                   # guess
  MyStock@ M     =      0.2*c(0.8, 1.2)              # ICCAT manual * 95% PI with CV 10%
  MyStock@ Msd   =      c(0, 0.1)              # guess
  MyStock@ Mgrad =      c(-0.25, 0.25)         # guess
  MyStock@ h     =      c(0.4, 0.6)            # guess
  MyStock@ SRrel =      1
  MyStock@ Linf  =      c(266, 277)            # USA entry FishBase   
  #MyStock@ K     =      c(.07,.12)             # USA entry FishBase
   MyStock@ K     =      0.12*c(0.8,1.2)             # USA entry FishBase *95% PI with CV 10%
  MyStock@ t0    =      c(-3.94, -1.68)        # USA entry FishBase
 # MyStock@ Ksd    =     C(0, 0.025)            # guess
  MyStock@ Kgrad   =    c(-0.25, 0.25)         # guess
  MyStock@ Linfsd   =   c(0, 0.025)            # guess
  MyStock@ Linfgrad  =  c(-0.25, 0.25)         # guess 
  MyStock@ recgrad   =  c(-10, 10)             # not used in this version of DLM
  MyStock@ a         =  .00271                 # USA entry FishBase
  MyStock@ b         =  3.3                    # USA entry FishBase
  MyStock@ D         =  c(.3,.62)            # from 2011 assessment, adjusted down by 10% on upper bound
  MyStock@ Perr      =  c(0.2, 0.4)            # guess
 # MyStock@ Period    =  c(NA, NA)             # guess
 # MyStock@ Amplitude =  c(NA, NA)             # guess
  MyStock@ Size_area_1 = c(0.5, 0.5)           # guess not used 
  MyStock@ Frac_area_1 = c(0.5, 0.5)           # guess
  MyStock@ Prob_staying = c(0.5, 0.5)          # guess
  MyStock@ AC          = c(0.1, 0.9)           # guess
  MyStock@ L50         = c(156, 179)           # ICCAT manual
  MyStock@ L50_95      = c(50, 50)             # FishBase
  MyStock@ Source      =  "http://iccat.org/Documents/SCRS/Manual/CH2/2_1_9_SWO_ENG.pdf"

  
MyFleet = Generic_fleet
  MyFleet@ Name       = "SWO_fleet"
  MyFleet@ nyears     = 62             # 2012 assessment, 2011 terminal year
  MyFleet@ Spat_targ  = c(1, 1)        # guess not used
  MyFleet@ Esd        = c(0,0)         # 2011 assessment c(0.1, 0.4); set to zero as we provide effort ts
  MyFleet@ qinc       = c(-.1, .1)     # guess
  MyFleet@ qcv        = c(0.05, 0.1)   # guess
  MyFleet@ EffYears   = c(0, 0.3, 0.6, 1)    # guess ; use posterior estimates of F
  MyFleet@ EffLower   = c(0, 0.4, 0.4, 0.25) # guess
  MyFleet@ EffUpper   = c(0, 0.6, 0.6, 1)    # guess
  #MyFleet@ SelYears   = 0                # selectivity constant ; this part dedicated to time varying selectivity
  #MyFleet@ AbsSelYears= 0 
  MyFleet@ L5         = c(40, 50)         # guess
  MyFleet@ LFS        = c(60, 125)        # ICCAT Rec[13-02]
  MyFleet@ Vmaxlen    = c(.5, 1)          # guess
  # MyFleet@ L5Lower    = c(0)            # guess 
  # MyFleet@ L5Upper    = c(0)            # guess 
  # MyFleet@ LFSLower   = c(0)            # guess 
  # MyFleet@ LFSUpper   = c(0)            # guess 
  # MyFleet@ VmaxLower  = c(0)            # guess 
  # MyFleet@ VmaxUpper  = c(0)            # guess 
  MyFleet@ isRel      = "FALSE"          # guess

  
  MyFleet@ EffYears   = c(1950, 1960, 1970, 1975, 1980, 1981, 1984, 1989, 1996, 2001, 2005, 2008, 2011)    
  MyFleet@ EffLower   = c(0.05, 0.10, 0.10, 0.20, 0.30, 0.35, 0.50, 0.70, 0.85, 0.80, 0.65, 0.55, 0.45)    
  MyFleet@ EffUpper   = c(0.15, 0.20, 0.25, 0.35, 0.50, 0.55, 0.65, 0.80, 0.95, 0.90, 0.75, 0.65, 0.55)    
  

MyObs = Generic_obs
  MyObs@ Name      = "SWO_obs"
  MyObs@ Cobs      = c(0.1, 0.3)       # guess
  MyObs@ Cbiascv   = c(0.1)            # guess
  MyObs@ CAA_nsamp = c(100, 200)       # guess
  MyObs@ CAA_ESS   = c(25, 50)         # guess
  MyObs@ CAL_nsamp = c(100, 200)       # guess
  MyObs@ CAL_ESS   = c(25, 50)         # guess
  MyObs@ CALcv     = c(0.05, 0.15)     # guess
  MyObs@ Iobs      = c(0.1, 0.4)       # guess
  MyObs@ Mcv       = c(0.2)            # guess
  MyObs@ Kcv       = c(0.1)            # guess
  MyObs@ t0cv      = c(0.1)            # guess
  MyObs@ Linfcv    = c(0.05)           # guess
  MyObs@ LFCcv     = c(0.05)           # guess
  MyObs@ LFScv     = c(0.05)           # guess
  MyObs@ B0cv      = c(3)              # guess
  MyObs@ FMSYcv    = c(0.2)            # guess
  MyObs@ FMSY_Mcv  = c(0.2)            # guess
  MyObs@ BMSY_B0cv = c(0.2)            # guess
  MyObs@ rcv       = c(0.5)            # guess
  MyObs@ LenMcv    = c(0.1)            # guess
  MyObs@ Dbiascv   = c(0.5)            # guess
  MyObs@ Dcv       = c(0.05, 0.1)      # guess
  MyObs@ Btbias    = c(0.333, 3)       # guess
  MyObs@ Btcv      = c(0.2, 0.5)       # guess
  MyObs@ Fcurbiascv= c(0.5)            # guess
  MyObs@ Fcurcv    = c(0.5, 1)         # guess
  MyObs@ hcv       = c(0.2)            # guess
  MyObs@ Icv       = c(0.2)            # guess
  MyObs@ maxagecv  = c(0.1)            # guess
  MyObs@ beta      = c(0.5, 2)         # guess
  MyObs@ Reccv     = c(0.1, 0.3)       # guess
  MyObs@ Irefcv    = c(0.2)            # guess
  MyObs@ Crefcv    = c(0.2)            # guess
  MyObs@ Brefcv    = c(0.5)            # guess


OM <- new("OM", MyStock, MyFleet, MyObs, Perfect_Imp)
OM<-ForceCor(OM)
OM@Source<- "Author: Alex Hanke (DFO)  Assessment: http://iccat.org/Documents/SCRS/Manual/CH2/2_1_9_SWO_ENG.pdf"
            

