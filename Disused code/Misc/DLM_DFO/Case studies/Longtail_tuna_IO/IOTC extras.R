
Strip_cpars<-function(OM,sims){
  
  for(i in 1:length(OM@cpars)){
    
    OM@nsim<-sum(sims)
    
    if(class(OM@cpars[[i]])=="matrix"){
      OM@cpars[[i]]<-OM@cpars[[i]][sims,]
    }else if(class(OM@cpars[[i]])=="array"){
      OM@cpars[[i]]<-OM@cpars[[i]][sims,,]
    }else{    
      OM@cpars[[i]]<-OM@cpars[[i]][sims]
    }

  }

  OM
  
}


IOTC_plot = function( MSEobj, Bref = 0.75, Fref = 0.75,    # Reference levels for fractions of BMSY and FMSY
                      Bsat = 0.8, Fsat = 0.8,      # Satisficing lines plotted at these levels
                      xlim=c(0,1.1), ylim=c(0,1.1) ){    # The lower bound on the axes
  
  cols = rep(makeTransparent(c("Black","Red","blue","green","orange")),99)
  yend = max(MSEobj@proyears) - (4:0)
  PB = apply(MSEobj@B_BMSY > Bref, 2, mean)
  LTY = apply(MSEobj@C[,,yend] / MSEobj@OM$RefY > Fref,2,mean)
  #xlim = range(PB) + c(-1,1) * sd(PB) * 0.25
  #ylim = range(LTY) + c(-1,1) * sd(LTY) * 0.25
  #if(xlim[1] < Blow) xlim[1] = Blow
  #if(ylim[1] < Flow) ylim[1] = Flow
  
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




# Some extra functions for IOTC case studies

VOI3<-function (MSEobj, ncomp = 3, nbins = 8, maxrow = 4, Ut = NA, 
              Utnam = "Utility", MPcex=1, lcex=1, cex.axis=0.9) 
{
  
  
  objnam <- deparse(substitute(MSEobj))
  nsim <- MSEobj@nsim
  if (is.na(Ut[1])) {
    Ut <- array(NA, c(nsim, MSEobj@nMPs))
    yind <- max(MSEobj@proyears - 4, 1):MSEobj@proyears
    RefYd <- MSEobj@OM$RefY
    for (mm in 1:MSEobj@nMPs) {
      Ut[, mm] <- apply(MSEobj@C[, mm, yind], 1, mean, 
                        na.rm = T)/RefYd * 100
    }
    Utnam <- "Long-term yield relative to MSY (%)"
  }
  MPs <- MSEobj@MPs
  nMPs <- MSEobj@nMPs
  onlycor <- c("RefY", "A", "MSY", "Linf", "t0", "OFLreal", 
               "Spat_targ")
  vargood <- (apply(MSEobj@OM, 2, sd)/(apply(MSEobj@OM, 2, 
                                             mean)^2)^0.5) > 0.005
  vargood[grep("qvar", names(MSEobj@OM))] <- FALSE
  MSEobj@OM <- MSEobj@OM[, which((!names(MSEobj@OM) %in% onlycor) & 
                                   vargood)]
  OMp <- apply(MSEobj@OM, 2, quantile, p = seq(0, 1, length.out = nbins + 
                                                 1), na.rm = TRUE)
  Obsp <- apply(MSEobj@Obs, 2, quantile, p = seq(0, 1, length.out = nbins + 
                                                   1), na.rm = TRUE)
  OMv <- array(NA, c(nMPs, ncol(MSEobj@OM), nbins))
  Obsv <- array(NA, c(nMPs, ncol(MSEobj@Obs), nbins))
  for (mm in 1:nMPs) {
    for (j in 1:nbins) {
      for (i in 1:ncol(MSEobj@OM)) {
        cond <- MSEobj@OM[, i] > OMp[j, i] & MSEobj@OM[, 
                                                       i] < OMp[j + 1, i]
        OMv[mm, i, j] <- mean(Ut[cond, mm], na.rm = T)
      }
      for (i in 1:ncol(MSEobj@Obs)) {
        cond <- MSEobj@Obs[, i] > Obsp[j, i] & MSEobj@Obs[, 
                                                          i] < Obsp[j + 1, i]
        Obsv[mm, i, j] <- mean(Ut[cond, mm], na.rm = T)
      }
    }
  }
  OMs <- apply(OMv, 1:2, sd, na.rm = T)
  OMstr <- array("", c(nMPs * 2, ncomp + 1))
  for (mm in 1:nMPs) {
    ind <- order(OMs[mm, ], decreasing = T)[1:ncomp]
    OMstr[1 + (mm - 1) * 2, 1] <- MPs[mm]
    OMstr[1 + (mm - 1) * 2, 2:(1 + ncomp)] <- names(MSEobj@OM[ind])
    OMstr[2 + (mm - 1) * 2, 2:(1 + ncomp)] <- round(OMs[mm, 
                                                        ind], 2)
  }
  OMstr <- data.frame(OMstr)
  names(OMstr) <- c("MP", 1:ncomp)
  slots <- c("Cat", "Cat", "AvC", "AvC", "CAA", "CAA", "CAL", 
             "CAL", "Ind", "Dep", "Dep", "Dt", "Dt", "Mort", "FMSY_M", 
             "SSBMSY_SSB0", "L50", "L95", "LFC", "LFS", "Abun", "Abun", 
             "vbK", "vbt0", "vbLinf", "Steep", "Iref", "Cref", "Bref", 
             "ML")
  Obsnam <- c("Cbias", "Csd", "Cbias", "Csd", "CAA_nsamp", 
              "CAA_ESS", "CAL_nsamp", "CAL_ESS", "Isd", "Dbias", "Derr", 
              "Dbias", "Derr", "Mbias", "FMSY_Mbias", "BMSY_B0bias", 
              "lenMbias", "lenMbias", "LFCbias", "LFSbias", "Abias", 
              "Aerr", "Kbias", "t0bias", "Linfbias", "hbias", "Irefbias", 
              "Crefbias", "Brefbias", "")
  Obss <- apply(Obsv, 1:2, sd, na.rm = T)
  Obsstr <- array("", c(nMPs * 2, ncomp + 1))
  for (mm in 1:nMPs) {
    relobs <- Obsnam[slots %in% unlist(strsplit(Required(MPs[mm])[, 
                                                                  2], split = ", "))]
    ind <- (1:ncol(MSEobj@Obs))[match(relobs, names(MSEobj@Obs))]
    pos <- names(MSEobj@Obs)[ind]
    maxy <- min(max(1, length(pos)), ncomp, na.rm = T)
    ind2 <- order(Obss[mm, ind], decreasing = T)[1:maxy]
    Obsstr[1 + (mm - 1) * 2, 1] <- MPs[mm]
    Obsstr[1 + (mm - 1) * 2, 2:(1 + maxy)] <- pos[ind2]
    Obsstr[2 + (mm - 1) * 2, 2:(1 + maxy)] <- round(Obss[mm, 
                                                         ind][ind2], 2)
  }
  Obsstr <- data.frame(Obsstr)
  names(Obsstr) <- c("MP", 1:ncomp)
  ncols <- 40
  colsse <- makeTransparent(rainbow(ncols, start = 0, end = 0.36), 
                            90)[ncols:1]
  minsd <- 0
  maxsd <- max(OMs, na.rm = T)
  coly <- ceiling(OMs/maxsd * ncols)
  mbyp <- split(1:nMPs, ceiling(1:nMPs/maxrow))
  ylimy = c(0, max(OMv, na.rm = T) * 1.2)
  for (pp in 1:length(mbyp)) {
    op <- par(mfrow = c(length(mbyp[[pp]]), ncomp), mai = c(0.15, 
                                                            0.1, 0.15, 0.05), omi = c(0.1, 0.9, 0.3, 0.05))
    for (mm in mbyp[[pp]]) {
      for (cc in 1:ncomp) {
        
        rind <- (mm - 1) * 2 + 1
        y <- Ut[, mm]
        cind <- match(OMstr[rind, 1 + cc], names(MSEobj@OM))
        x <- MSEobj@OM[, cind]
        plot(x, y, col = "white", axes = F, ylim = ylimy)
        axis(1, pretty(OMp[, cind]), pretty(OMp[, cind]), 
             cex.axis = cex.axis, padj = -0.5)
        abline(v = OMp[, cind], col = "#99999960")
        points(x, y, col = colsse[coly[mm, cind]], pch = 19, 
               cex = 0.8)
        x2 <- (OMp[1:nbins, cind] + OMp[2:(nbins + 1), 
                                        cind])/2
        y2 <- OMv[mm, cind, ]
        lines(x2, y2)
        legend("bottomright", legend = round(OMs[mm, 
                                                 cind], 2), bty = "n", cex = lcex)
        legend("topleft", legend = OMstr[rind, 1 + cc], 
               bty = "n", cex = lcex)
       
        if (cc == 1) {
          mtext(MPs[mm], 2, font = 2, outer = F, cex =MPcex, 
                line = 2)
          ytick <- pretty(seq(ylimy[1], ylimy[2] * 1.3, 
                              length.out = 10))
          axis(2, ytick, ytick, cex.axis = cex.axis)
        }
        
      }
    }
    mtext(Utnam, 2, outer = T, cex = 0.9, line = 3.5)
    mtext(paste("Operating model parameters: ", objnam, "@OM", 
                sep = ""), 3, outer = T, font = 2, cex = 0.9)
  }
  ylimy = c(0, max(Obsv, na.rm = T) * 1.2)
  minsd <- 0
  maxsd <- max(Obss)
  coly <- ceiling(Obss/maxsd * ncols)
  if (sum(is.na(Obsstr) | Obsstr == "") < (ncomp + 1) * nMPs * 
      2 - nMPs) {
    for (pp in 1:length(mbyp)) {
      op <- par(mfrow = c(length(mbyp[[pp]]), ncomp), mai = c(0.15, 
                                                              0.1, 0.15, 0.05), omi = c(0.1, 0.9, 0.3, 0.05))
      for (mm in mbyp[[pp]]) {
        rind <- (mm - 1) * 2 + 1
        npres <- sum(Obsstr[rind + 1, ] != "")
        for (cc in 1:ncomp) {
          if (!is.na(npres) & cc < (npres + 1)) {
            y <- Ut[, mm]
            cind <- match(Obsstr[rind, 1 + cc], names(MSEobj@Obs))
            x <- MSEobj@Obs[, cind]
            plot(x, y, col = "white", axes = F, ylim = ylimy)
            axis(1, pretty(Obsp[, cind]), pretty(Obsp[, 
                                                      cind]), cex.axis = cex.axis, padj = -0.5)
            abline(v = Obsp[, cind], col = "#99999960")
            points(x, y, col = colsse[coly[mm, cind]], 
                   pch = 19, cex = 0.8)
            x2 <- (Obsp[1:nbins, cind] + Obsp[2:(nbins + 
                                                   1), cind])/2
            y2 <- Obsv[mm, cind, ]
            lines(x2, y2)
            legend("bottomright", legend = round(Obss[mm, 
                                                      cind], 2), bty = "n", cex = lcex)
            legend("topleft", legend = Obsstr[rind, 1 + 
                                                cc], bty = "n", cex = lcex)
            if(grepl("bias",Obsstr[rind, 1 + cc]))abline(v=1,lty=2)
            
            if (cc == 1) {
              mtext(MPs[mm], 2, font = 2, outer = F, 
                    cex = MPcex, line = 2)
              ytick <- pretty(seq(ylimy[1], ylimy[2] * 
                                    1.3, length.out = 10))
              axis(2, ytick, ytick, cex.axis = cex.axis)
            }
          }
          else {
            plot(0, type = "n", axes = FALSE, ann = FALSE)
            if (cc == 1) {
              mtext(MPs[mm], 2, font = 2, outer = F, 
                    cex = MPcex, line = 2)
            }
          }
        }
      }
      mtext(Utnam, 2, outer = T, cex = 0.9, line = 3.5)
      mtext(paste("Observation model parameters: ", objnam, 
                  "@Obs", sep = ""), 3, outer = T, font = 2, cex = 0.9)
    }
  }
  par(op)
  list(OMstr, Obsstr)
}







SS2Data<-function(SSdir,Source="No source provided",length_timestep=NA,Name="",
                          Author="No author provided",printstats=F,verbose=T){
  
  message("-- Using function SS_output of package r4ss to extract data from SS file structure --")
  
  replist <- r4ss::SS_output(dir=SSdir, covar=F, ncols=1000, printstats=printstats, verbose=verbose)
  #replistB <- SS_output(dir="F:/Base",covar=F,ncols=1000,printstats=printstats,verbose=verbose)
  #replistY <- SS_output(dir="F:/Base3",covar=F,ncols=1000,printstats=printstats,verbose=verbose)
  
  message("-- End of r4ss operations --")
  
  GP <- replist$Growth_Parameters
  
  if(nrow(GP)>1){
    print(paste("Warning:", nrow(GP),"different sets of growth parameters were reported they look like this:"))
    print(GP)
    print("Only the first row of values was used here")
    print("")
  }
  
  Data <- new("Data") 

  # The trouble is that DLMtool is an annual model so if the SS model is seasonal we need to aggregate overseasons
  # The reason for the code immediately below (and length_timestep) is that some SS models just assume quarterly timesteps with no way of knowing this (other than maxage and M possibly)!
  if(is.na(length_timestep)){
    
    if((replist$endyr-replist$startyr+1)>100){
      nseas<-1/replist$seasduration[1] # too many  years for industrial fishing so assumes a quarterly model
    }else{
      nseas=1
    }
    
  }else{
    nseas<-1/length_timestep
  }
  
  nyears<-(replist$endyr-replist$startyr+1)/nseas
  Data@Year=(1:nyears)
  
  if(is.null(Name)){
    Data@Name=SSdir
  }else{
    Data@Name=Name
  }
  
  yind<-(1:nyears)*nseas
  yind2<-rep(1:nyears,each=nseas)
  
  
  
  cat<-rep(0,length(replist$timeseries$"obs_cat:_1"))
  for(i in 1:length(replist$timeseries)){
    if(grepl("obs_cat",names(replist$timeseries)[i]))cat<-cat+replist$timeseries[[i]]
    
  }
  if(nseas>1){
    
    ind<-rep(1:(length(cat)/nseas),nseas)
    cat2<-aggregate(cat,by=list(ind),sum)
    cat3<-cat2[1:length(yind2),2]
    cat4<-aggregate(cat3,by=list(yind2),sum)
  }
  
  Data@Cat <- matrix(cat4[,2],nrow=1)
  SSB<-replist$recruit$spawn_bio[1:(nyears*nseas)]
  SSB<-aggregate(SSB,by=list(yind2),mean)[,2]
  Ind<-SSB
  Ind<-Ind/mean(Ind)
  Data@Ind <- matrix(Ind,nrow=1) 
  rec<-replist$recruit$pred_recr
  rec<-rec[1:(nyears*nseas)]
  Recind<- aggregate(rec,by=list(yind2),mean)[,2]
  Recind<-Recind/mean(Recind)
  Data@Rec<-matrix(Recind,nrow=1)
  Data@t<-nyears
  Data@AvC<-mean(Data@Cat)
  Data@Dt<-Data@Dep<-Ind[nyears]/Ind[1]
  
  growdat<-getGpars(replist)
  growdat<-getGpars(replist)
  Data@MaxAge<-maxage<-ceiling(length(growdat$Age)/nseas)
  aind<-rep(1:maxage,each=nseas)[1:length(growdat$Age)]
  M<-aggregate(growdat$M,by=list(aind),mean)$x
  Wt<-aggregate(growdat$Wt_Mid,by=list(aind),mean)$x
  Mat<-aggregate(growdat$Age_Mat,by=list(aind),mean)$x
  
  surv<-c(1,exp(cumsum(-c(M[2:maxage]))))# currently M and survival ignore age 0 fish
  Data@Mort<-sum(M[2:maxage]*surv[2:maxage])/sum(surv[2:maxage])
  
  SSB0<-replist$derived_quants[replist$derived_quants$LABEL=="SSB_Unfished",2]
  
  Data@Bref<-replist$derived_quants[replist$derived_quants$LABEL=="SSB_MSY",2]
  Data@Cref<-replist$derived_quants[replist$derived_quants$LABEL=="TotYield_MSY",2]
  FMSY<-replist$derived_quants[replist$derived_quants$LABEL=="Fstd_MSY",2]*nseas
  Data@Iref<-Data@Ind[1]*Data@Bref/SSB[1]
  
  Data@FMSY_M=FMSY/Data@Mort
  Data@BMSY_B0<-Data@Bref/SSB0
  
  Data@Bref<-replist$derived_quants[replist$derived_quants$LABEL=="SSB_MSY",2]
  
  Len_age<-growdat$Len_Mid
  Mat_age<-growdat$Age_Mat
  
  Data@L50<-LinInterp(Mat_age,Len_age,0.5+1E-6)
  Data@L95<-LinInterp(Mat_age,Len_age,0.95)
 
  
  ages<-growdat$Age
  cols<-match(ages,names(replist$Z_at_age))
  F_at_age=t(replist$Z_at_age[,cols]-replist$M_at_age[,cols])
  F_at_age[nrow(F_at_age),]<-F_at_age[nrow(F_at_age)-1,]# ad-hoc mirroring to deal with SS missing predicitons of F in terminal age
  Ftab<-cbind(expand.grid(1:dim(F_at_age)[1],1:dim(F_at_age)[2]),as.vector(F_at_age))
  
  if(nseas>1){
    sumF<-aggregate(Ftab[,3],by=list(aind[Ftab[,1]],Ftab[,2]),mean,na.rm=T)
    sumF<-aggregate(sumF[,3],by=list(sumF[,1],yind2[sumF[,2]]),sum,na.rm=T)
  }else{
    sumF<-Ftab
  }
  
  sumF<-sumF[sumF[,2]<nyears,] # generic solution: delete partial observation of final F predictions in seasonal model (last season of last year is NA)
  V <- array(NA, dim = c(maxage, nyears)) 
  V[,1:(nyears-1)]<-sumF[,3] # for some reason SS doesn't predict F in final year
  
   
  Find<-apply(V,2,max,na.rm=T) # get apical F
  
  ind<-as.matrix(expand.grid(1:maxage,1:nyears))
  V[ind]<-V[ind]/Find[ind[,2]]
  
  # guess at length parameters # this is over ridden anyway
  ind<-((nyears-3)*nseas)+(0:((nseas*3)-1))
  muFage<-as.vector(apply(F_at_age[,ind],1,mean))
  Vuln<-muFage/max(muFage,na.rm=T)
  
  Data@LFC<-LinInterp(Vuln,Len_age,0.05,ascending=T,zeroint=T)                            # not used if V is in cpars
  Data@LFS<-Len_age[which.min((exp(Vuln)-exp(1.05))^2 * 1:length(Vuln))]  # not used if V is in cpars
   
  ages<-growdat$Age
  cols<-match(ages,names(replist$Z_at_age))
  
  
  cols<-match(ages,names(replist$catage))
  CAA=as.matrix(replist$catage[,cols])
  yr<-rep(replist$catage$Yr,dim(CAA)[2])
  age<-rep(ages,each=dim(CAA)[1])
  CAAagg<-aggregate(as.vector(CAA),by=list(yr,age),sum)
  CAAagg<-CAAagg[CAAagg[,2]!=0,]
  CAAagg<-CAAagg[CAAagg[,1]<=(nyears*nseas),]
  CAAagg<-CAAagg[CAAagg[,2]<=length(aind),]
  
  yind3<-yind2[CAAagg[,1]]
  aind3<-aind[CAAagg[,2]]
  
  CAA2<-aggregate(CAAagg[,3],by=list(yind3,aind3),sum)
  Data@CAA<-array(0,c(1,nyears,maxage))
  Data@CAA[as.matrix(cbind(rep(1,nrow(CAA2)),CAA2[,1:2]))]<-CAA2[,3]
  
  
  
  # CAL data
  Data@CAL_bins<-c(0,replist$lbins)
  
  Binno<-match(replist$lendbase$Bin,Data@CAL_bins)
  Yrno<-yind2[replist$lendbase$Yr]
  CALagg<-aggregate(replist$lendbase$Obs*replist$lendbase$N,by=list(Yrno,Binno),sum)
  Data@CAL<-array(0,c(1,nyears,length(Data@CAL_bins)))
  Data@CAL[as.matrix(cbind(rep(1,nrow(CALagg)),CALagg[,1:2]))]<-CALagg[,3]
  Data@CAL<-ceiling(Data@CAL)
  
  Data@ML<-matrix(apply(Data@CAL[1,,]*rep(Data@CAL_bins,each=nyears),1,mean),nrow=1)
  Data@ML[Data@ML==0]<-NA
  lcpos<-apply(Data@CAL[1,,],1,which.max)
  Data@Lc<-matrix(Data@CAL_bins[lcpos],nrow=1)
  Data@Lc[Data@Lc==0]<-NA
  
  Data@Lbar<-matrix(rep(NA,nyears),nrow=1)
  
  for(i in 1:nyears){
    if(!is.na(Data@Lc[i])){
      ind<-Data@CAL_bins>Data@Lc[i]
      Data@Lbar[1,i]<-mean(Data@CAL[1,i,ind]*Data@CAL_bins[ind])
    } 
  }
  
  Data@Abun<-Data@SpAbun<-SSB[nyears]
  
  Data@vbLinf=GP$Linf[1]
  Data@CV_vbLinf=GP$CVmax[1]
  Data@vbK=GP$K[1]*nseas
  Data@vbt0=GP$A_a_L0
  Data@wla=GP$WtLen1[1]
  Data@wlb=GP$WtLen2[1]
  SSBpR<-SSB[1]/rec[1]  
  hs<-mean(SRopt(100,SSB,rec,SSBpR,plot=F,type="BH"))
  Data@steep<-hs
  
  Data@Units<-""
  Data@Ref<-mean(replist$derived_quants[grepl("OFLCatch",replist$derived_quants$LABEL),2])
  Data@Ref_type = "OFL"
  Data@LHYear<-nyears
  Data@MPeff<-1
  Data@Log<-list(warning="This data was created by an alpha version of SS2Data and should not be trusted!")
  Data@Misc<-list(warning="This data was created by an alpha version of SS2Data and should not be trusted!")
  Data@Name<-"This data was created by an alpha version of SS2Data and should not be trusted!"
  
  Data@MPrec<-Data@Ref<-Data@Cat[1,nyears]
  #Data@Ref<-mean(replist$derived_quants[grepl("OFLCatch",replist$derived_quants$LABEL),2])
  Data@Ref_type = "Most recent annual catch"
  Data
  
}











