# IOTC HCRs

GHCR<-function(LRP=0.2,TRP=0.4,pow=1){
  
  rng<-TRP-LRP
  dep<-seq(0,1.5,length.out=100)
  
  condU<-dep>TRP
  condL<-dep<LRP
  
  adj<-rep(1,length(dep))
  
  adj[condU]<-1
  adj[condL]<-0
  
  cond<-!condU&!condL
  adj[cond]<-(dep[cond]-LRP)/rng
  adj[cond]<-adj[cond]^pow
  
  plot(dep,adj,type="l",col='blue')
  abline(v=c(TRP,LRP),lty=2,col='red')
 
}


HCR_2_2_1<-function(x,Data,reps,LRP=0.2,TRP=0.2,pow=1){

  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}

HCR_2_4_1<-function(x,Data,reps,LRP=0.2,TRP=0.4,pow=1){
  
  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}

HCR_2_5_1<-function(x,Data,reps,LRP=0.2,TRP=0.5,pow=1){
  
  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}

HCR_1_4_1<-function(x,Data,reps,LRP=0.1,TRP=0.4,pow=1){
  
  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}


HCR_2_4_5<-function(x,Data,reps,LRP=0.2,TRP=0.4,pow=5){
  
  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}

HCR_2_4_15<-function(x,Data,reps,LRP=0.2,TRP=0.4,pow=1/5){
  
  rng<-TRP-LRP 
  muCat<-(Data@Cref[x]/Data@Bref[x])*Data@Abun[x]
  Cat<-trlnorm(reps,muCat,0.01)
  if(Data@Dep[x]<LRP)Cat<-Cat/100000
  if(Data@Dep[x]>LRP&Data@Dep[x]<TRP)Cat=(Data@Dep[x]-LRP)/rng
  Cat
  
}

sfExport(list=c("HCR_2_2_1","HCR_2_4_1","HCR_2_5_1","HCR_1_4_1","HCR_2_4_5","HCR_2_4_15"))

class(HCR_2_2_1)<-class(HCR_2_4_1)<-class(HCR_2_5_1)<-class(HCR_1_4_1)<-class(HCR_2_4_5)<-class(HCR_2_4_15)<-"Output"

environment(HCR_2_2_1)<-environment(HCR_2_4_1)<-environment(HCR_2_5_1)<-environment(HCR_1_4_1)<-environment(HCR_2_4_5)<-environment(HCR_2_4_15)<-asNamespace('DLMtool')















