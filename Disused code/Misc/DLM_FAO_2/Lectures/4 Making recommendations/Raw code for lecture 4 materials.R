# Lecture 4 series code

library(DLMtool)
setup()

# 4a ======

myfleet=Generic_fleet
myfleet@EffYears = c(1,    20,  50)
myfleet@EffUpper = c(0.05, 1,   0.3)
myfleet@EffLower = c(0.01, 0.7, 0.2)

plot(myfleet,Albacore)

myfleet = ChooseEffort(Generic_fleet)


Albacore@Linf
Albacore@K

Linf<-runif(1000,Albacore@Linf[1],Albacore@Linf[2])
K<-runif(1000,Albacore@K[1],Albacore@K[2])

myOM<-new('OM',Albacore, Generic_fleet, Generic_obs, Perfect_Imp)
      
ForceCor(Albacore,nsim=200)

testOM@nsim<-20
Sim=SRAsim(testOM,qmult=2)
CAA<-Sim$CAA
Chist<-Sim$Chist
testOM<-StochasticSRA(testOM,CAA,Chist,nsim=20,nits=2000)


# 4b =====

nyears<-10
nsim<-2
simData<-new('Data')
simData@Name <-"Some simulated data from an MSE"
simData@Year<-2000+(1:nyears)
simData@Cat<-round(exp(array(trlnorm(nsim*nyears,1,0.1)*rep(sin(1:nyears),each=nsim),c(nsim,nyears))),3)
simData@Ind<-round(array(trlnorm(nsim*nyears,1,0.1)*rep((nyears:1),each=nsim),c(nsim,nyears)),3)
simData@Ind<-round(simData@Ind/apply(simData@Ind,1,mean),3) 
simData@Rec<-round(array(trlnorm(nsim*nyears,1,0.1)*rep(seq(1,0.5,length.out=nyears),each=nsim),c(nsim,nyears)),3)
simData@t<-nyears
simData@AvC<-round(apply(simData@Cat,1,mean),3)
simData@Dt<-round(simData@Ind[,nyears]/simData@Ind[,1],3)
simData@Mort<-round(trlnorm(nsim,0.2,0.1),3)
simData@FMSY_M<-round(trlnorm(nsim,0.75,0.3),3)



HAC = function(x, Data, reps){
  muCat = 0.5*mean(Data@Cat[x, ])
  nyears = length(Data@Cat[x, ])
  StErr = Data@CV_Cat[x] / nyears^0.5
  rnorm(reps, muCat, StErr)
}

class(HAC)<-"Output"
environment(HAC)<-asNamespace("DLMtool")
sfExport("HAC")

Can(Cobia)
MPs<-Can(China_rockfish)
TACs<-TAC(China_rockfish)
boxplot(TACs)

myMSE<-runMSE(testOM,MPs<-c("DCAC","AvC","FMSYref","MCD","HAC"))

NOAA_plot(myMSE)


# 4c =======================


MLTarg = function(x, Data,...){
  currentYR = length(Data@Year)
  Effort=Data@ML[x, currentYR] / Data@L50[x]
  c(1,   Effort,   1, 1,   NA, NA)
}

Close1 = function(x, Data, ...){
  c(1,   1,   0, 1,   NA, NA)
}

SL95 = function(x, Data, ...){
  c(1,   1,   0, 1,   90, 100)
}


class(MLTarg) = class(Close1) = class(SL95) = 'Input'
environment(MLTarg) =  environment(MLTarg) =
  environment(SL95) = 'DLMtool'
sfExport(list=c('MLTarg','Close1','SL95'))

myOM<-new('OM',Albacore, Generic_fleet, Generic_obs, Perfect_Imp)
myMPs<-c("AvC","DD","FMSYref","DCAC","curE","MLTarg","Close1","SL95")
myMSE2<-runMSE(myOM,myMPs)

NOAA_plot(myMSE2)

# Example Input control - size limits 

plotEx <- function(Rec) {
  Linf <- 150 
  Lens <- 1:Linf 
  if (length(Rec@Rmaxlen) == 0) Rec@Rmaxlen <- 1 
  if (length(Rec@LR5) == 0) stop('Rec@LR5 missing value')
  if (length(Rec@LFR) == 0) stop('Rec@LFR missing value')
  
  srs <- (Linf - Rec@LFR) / ((-log(Rec@Rmaxlen,2))^0.5) 
  sls <- (Rec@LFR - Rec@LR5) /((-log(0.05,2))^0.5)
  sel <- getsel(1, lens=Lens, lfs=Rec@LFR, sls=sls, srs=srs)
  if (length(Rec@HS)>0) sel[Lens>Rec@HS] <- 0 
  
  plot(Lens, sel, type="l", xlab="Length",
       ylab="Retention", ylim=c(0,1), las=1, bty="l", xaxs="i", yaxs="i", lwd=2, xpd=NA, 
       cex.lab=1.25)
}

Rec <- new("InputRec")
Rec@LR5 <- 90
Rec@LFR <- 100

plotEx(Rec)


Rec <- new("InputRec")
Rec@LR5 <- 90
Rec@LFR <- 100
Rec@HS <- 120

plotEx(Rec)



Rec <- new("InputRec")
Rec@LR5 <- 90
Rec@LFR <- 100
Rec@Rmaxlen <- 0.5

plotEx(Rec)














