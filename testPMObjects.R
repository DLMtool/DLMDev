library(DLMtool)
MSEobj <- runMSE(testOM)
# 
# setClass("PMobj", representation(Name = "character",  Description="character",  
#                                  Func = "function", Ref="numeric", Stat="character",
#                                  RP="numeric",  Y1="numeric", Y2="numeric", 
#                                  Label="label.class", extra="numeric"))


setClass("PMobj", representation(Prob='data.frame', Mean='numeric', Stat='array', 
                                 name = "character",  caption='character', 
                                 ref='numeric', RP='numeric', y1='numeric', y2='numeric', 
                                 MSEobj="MSE"))


NOAA_Rebuild <- function(MSEobj=NULL, name="NOAA Rebuilding (MSA)",
                         caption='B>BMSY', ref=0.5, RP=0.8, y1=1, y2=NULL) {
  y1 <- CheckYrs(MSEobj, y1, y2)[1]
  y2 <- CheckYrs(MSEobj, y1, y2)[2]
  PM <- MSEobj@B_BMSY[,,y1:y2] 

  out <- new("PMobj")
  if (!is.null(ref)) {
    out@Prob <- as.data.frame(apply(PM > ref, c(1,2), mean)) # nsim by nMP
    colnames(out@Prob) <- MSEobj@MPs
    out@Mean <- signif(apply(out@Prob, 2, mean),2)
  } 

  out@Stat <- PM # nsim by nMP by nyr
  out@name <- name 
  out@caption <- caption
  out@ref <- ref 
  out@RP <- RP 
  out@y1 <- y1 
  out@y2 <- y2 
  out@MSEobj <- MSEobj
  out 
}

DFO_Overfishing <- function(MSEobj=NULL, name="DFO_Overfishing ",
                         caption='F>FMSY', ref=1, RP=0.8, y1=1, y2=NULL) {
  y1 <- CheckYrs(MSEobj, y1, y2)[1]
  y2 <- CheckYrs(MSEobj, y1, y2)[2]
  PM <- MSEobj@F_FMSY[,,y1:y2] 
  
  out <- new("PMobj")
  if (!is.null(ref)) {
    out@Prob <- as.data.frame(apply(PM > ref, c(1,2), mean)) # nsim by nMP
    colnames(out@Prob) <- MSEobj@MPs
    out@Mean <- signif(apply(out@Prob, 2, mean),2)
  } 
  
  out@Stat <- PM # nsim by nMP by nyr
  out@name <- name 
  out@caption <- caption
  out@ref <- ref 
  out@RP <- RP 
  out@y1 <- y1 
  out@y2 <- y2 
  out@MSEobj <- MSEobj
  out 
}










setMethod("show", signature = (object="PMobj"), function(object) {
  cat(object@name)
  cat("\nYears: ", object@y1, "-", object@y2)
  # make caption 
  cap <- NULL
  if(is.character(object@caption)) {
    cap <- object@caption
    sign <- NULL
    trycap <- unlist(strsplit(cap, ">"))
    if (length(trycap) > 1) {
      sign <- ">"
      cap <- trycap
    } else {
      trycap <- unlist(strsplit(cap, "<"))
      if (length(trycap) > 1) {
        sign <- "<"
        cap <- trycap
      } 
    }
    if (!is.null(sign) && is.numeric(object@ref)) {
      if (object@ref != 1) cap <- paste(c(cap[1], sign, object@ref, cap[2]), collapse = " ")
      if (object@ref == 1) cap <- paste(c(cap[1], sign, cap[2]), collapse = " ")
    } else cap <- trycap
  }
  if (!is.null(cap)) cat("\n", cap)
  cat("\n")
  nMP <- object@MSEobj@nMPs
  nsim <- object@MSEobj@nsim
  nprint <- min(nsim, 10)
  df <- object@Prob[1:nprint,]
  if (nsim > (nprint+1)) {
    df <- rbind(df,
                rep(".", nMP+1),
                rep(".", nMP+1),
                rep(".", nMP+1),
                object@Prob[nprint+1,])
    rownames(df)[nrow(df)] <- nsim
  }
  print(df)
  
  cat("\nMean\n")
  print(object@Mean)
})

DFO_Overfishing(MSEobj)
NOAA_Rebuild(MSEobj)


object <- list(DFO_Overfishing, NOAA_Rebuild, NOAA_Rebuild)


testplot <- function(MSEobj, PMlist, ref=NULL) {
  if (class(PMlist) != 'list') stop("PMlist must be list of PM functions")
  
  nPMs <- length(PMlist) # make even
  if (nPMs %% 2 > 0) PMlist[[nPMs+1]] <- PMlist[[1]]
  nPMs <- length(PMlist)
  if (!is.null(ref)) ref <- rep(ref, 100)[1:nPMs]
  nplot <- nPMs/2
  for (xx in 1:nplot) {
    # calc x 
    
    # calc y 
    
    
    
    
  }
  
  
}

testplot(MSEobj, PMlist, caption="hi")



object



plot(MSEobj)













tt <- NOAA_Rebuild(MSEobj, Name="hi")



PMobj <- NOAA_Rebuild
tt <- function(PMobj) {
  PMobj(MSEobj)
  
}



CheckYrs <- function(MSEobj, y1, y2) {
  if (length(y2) == 0 || !is.finite(y2)) y2 <- MSEobj@proyears
  if (length(y1) == 0 || !is.finite(y1)) {
    y1 <- 1 
  } else {
    if (y1 < 0) y1 <- y2 - abs(y1) + 1 
    if (y1 == 0) y1 <- 1
  }
  if (y1 <= 0) {
    y1 <- 1
    warning("y1 is negative. Defaulting to y1 = 1", call.=FALSE)
  }
  if (y1 >= y2) {
    y1 <- y2 - 4 
    warning("y1 is greater or equal to y2. Defaulting to y1 = y2-4", call.=FALSE)
    
  }
  c(y1,y2)
}


  
  
  
  
PM <- new("PM")
PM


NOAA_Rebuild <- new("PM")


PM(NOAA_Rebuild)



SB_SB02 <- new("PM")
SB_SB02@Name <- "Spawning Biomass Relative to SB0"
SB_SB02@Func <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  var <- MSEobj@SSB / array(MSEobj@OM$SSB0, dim=dim(MSEobj@SSB)) 
  var[,,y1:y2]
} 
SB_SB02@Label <- function(MSEobj, PMobj) {
  y1 <- ChkYrs(MSEobj, PMobj)[1]
  y2 <- ChkYrs(MSEobj, PMobj)[2]
  bquote(italic("SB") * "/" * italic("SB"[0]) ~ "(Years" ~ .(y1) ~ "-" ~ .(y2) * ")")
}




# library(DLMtool)
# library(ggplot2)
# library(gridExtra)
# library(grid)
# library(ggrepel)
# 
# 
# setup()
# 
# MSEobj <- runMSE(testOM) # for testing 
# testOM2 <- testOM
# testOM2@seed <- 101
# MSEobj2 <- runMSE(testOM2) # for testing 
# 
# avail("PM")
# 
# PMtrade(pSB0, LTY, MSEobj)
# 
# PerfObj <- PMtrade(pAAVY, LTY, MSEobj)
# 
# 
# ggTrade(PMtrade(pAAVY, LTY, MSEobj))
# bsTrade(PMtrade(pAAVY, LTY, MSEobj))
# 
# Tplotnew(PerfObj)
# Tplotnew(PerfObj, pFun="bsTrade")
# 
# 
# Tplotnew(x=list(SB_SB0, SB_SBMSY, F_FMSY), y=Yield, MSEobj)
# Tplotnew(x=list(SB_SB0, SB_SBMSY, F_FMSY), y=Yield, MSEobj, pFun="bsTrade")
# 
# Tplotnew(x=SB_SB0, y=list(SB_SBMSY, SB_SBMSY, F_FMSY, F_FMSY), MSEobj)
# 
# Tplotnew(x=SB_SB0, y=list(SB_SBMSY, SB_SBMSY, F_FMSY), MSEobj, pFun="bsTrade")
# 

Tplotnew <- function(x, y=NULL, MSEobj=NULL, MSEname=NULL, Can=NULL, Class=NULL, 
                     pFun=c("ggTrade", "bsTrade")) {
  pout <- list() # list of data to plot
  if (class(x) == "list" & is.null(y)) {
    if (!all(unlist(lapply(x, class)) == "PM")) stop("List must be objects of class 'PM'")
    if (length(x) < 2) stop("List must be greater than length 1")
    grid <- expand.grid(1:length(x), 1:length(x))
    grid <- grid[grid[,2] != grid[,1],]
    pgrid <- apply(grid, 2, unique)
    nplot <- nrow(pgrid)
    Xs <- x 
    Ys <- x 
    for (pp in 1:nplot) {
      pout[[pp]] <- PMtrade(Xs[[pgrid[pp,2]]], Ys[[pgrid[pp,1]]], MSEobj, MSEname, Can, Class)
    }
  } 
  if (class(x) == "list" & class(y) == "PM") {
    if (!all(unlist(lapply(x, class)) == "PM")) stop("List must be objects of class 'PM'")
    if (length(x) < 2) stop("List must be greater than length 1")
    nplot <- length(x)
    for (pp in 1:nplot) {
      pout[[pp]] <- PMtrade(x[[pp]], y, MSEobj, MSEname, Can, Class)
    }
  } 
  if (class(y) == "list" & class(x) == "PM") {
    if (!all(unlist(lapply(y, class)) == "PM")) stop("List must be objects of class 'PM'")
    if (length(y) < 2) stop("List must be greater than length 1")
    nplot <- length(y)
    for (pp in 1:nplot) {
      pout[[pp]] <- PMtrade(x, y[[pp]], MSEobj, MSEname, Can, Class)
    }
  }  
  if (class(x) == "list" & class(y) == "list") {
    if (!all(unlist(lapply(x, class)) == "PM")) stop("List must be objects of class 'PM'")
    if (!all(unlist(lapply(y, class)) == "PM")) stop("List must be objects of class 'PM'")
    if (length(x) < 2) stop("List must be greater than length 1")
    if (length(y) < 2) stop("List must be greater than length 1")
    Xs <- rep(1:length(x), 100)
    Ys <- rep(1:length(y), 100)
    Ys <- Ys[1:length(Xs)]
    ind <- max(length(x), length(y))
    grid <- data.frame(Xs=Xs, Ys=Ys)[1:ind,]
    for (pp in 1:nplot) {
      xx <- x[[grid[pp,1]]]
      yy <- y[[grid[pp,2]]]
      pout[[pp]] <- PMtrade(xx, yy, MSEobj, MSEname, Can, Class)
    }
  }
  
  if (class(x) == "PMtrade")  pout[[1]] <- x 
  if (class(x) == "PM" & class(y) == "PM") pout[[1]] <- PMtrade(x, y, MSEobj, MSEname, Can, Class)
  
  nplot <- length(pout)
  nrow <- floor(sqrt(nplot))
  ncol <- ceiling(nplot/nrow)
  plots <- list()
  if (length(pFun) > 1) pFun <- pFun[1]
  if (pFun == "ggTrade") { # ggplot
    if (length(pout) == 1) {
      return(ggTrade(pout[[1]]))
    } else {
      pmat <- matrix(1:nplot, nrow=nrow, ncol=ncol)
      for (pp in 1:length(pout)) {
        temp <- ggTrade(pout[[pp]])
        plots[[pp]] <- temp
      } 
      return(grid_arrange_shared_legend(plots, nrow=nrow, ncol=ncol))
    }
  } else { # base graphics plot 
    test <- try(get(pFun), silent=TRUE)
    if (class(test) == "try-error") stop("Function 'pFun' not found", call.=FALSE)
    old.par <- par(no.readonly = TRUE)
    par(mfrow=c(nrow, ncol))
    for (pp in 1:length(pout)) get(pFun)(pout[[pp]])
    on.exit(par(old.par))
  }
}
  
  
bsTrade <- function(PerfObj) {
  if (class(PerfObj) != "PMtrade") stop("Argument to function must be class 'PMtrade'", call.=FALSE)
  DF <- PerfObj$DF
  DF$col <- "black"
  if (length(unique(DF$MSE)) > 1) { #more than 1 MSE 
    MSEs <- unique(DF$MSE)
    cols <- RColorBrewer::brewer.pal(length(MSEs), "Dark2")
    DF$col <- cols[match(DF$MSE, MSEs)]
  }
  Xlab <- PerfObj$xlab
  Ylab <- PerfObj$ylab

  xmin <- min(0, min(DF$x))
  xmax <- max(1, max(DF$x))
  xlim <- c(xmin, xmax)
  ymax <- max(1, max(DF$y))
  ymin <- min(0, min(DF$y))
  ylim <- c(ymin, ymax)  
  
  classes <- unique(DF$Class)
  pch1 <- 15
  pchs <- seq(from=pch1, by=1, to=pch1+length(classes))
  
  DF$pch <- pchs[match(DF$Class, classes)]
  DF$pos <- rep(1:4, nrow(DF))[1:nrow(DF)]
  plot(xlim, ylim, type="n", axes=FALSE, ylab="", xlab="")
  points(DF$x, DF$y, pch=DF$pch, col=DF$col)
  text(DF$x, DF$y, DF$MP, xpd=NA, pos=DF$pos, col=DF$col)
  axis(side=1)
  mtext(side=1, Xlab, line=3)
  axis(side=2)
  mtext(side=2, Ylab, line=3)
  
  # add legend etc 
}





ggTrade <- function(PerfObj) {
  if (class(PerfObj) != "PMtrade") stop("Argument to function must be class 'PMtrade'", call.=FALSE)
  DF <- PerfObj$DF
  Xlab <- PerfObj$xlab
  Ylab <- PerfObj$ylab
  AES <- aes(x=x, y=y, label=MP)
  if (!all(DF$Class == FALSE)) AES <- aes(x=x, y=y, label=MP, shape=Class)
  if (!all(DF$Can == FALSE) &&  all(!is.na(DF$Can))) AES <- aes(x=x, y=y, label=MP, shape=Class, color=Can)
  
  p1 <- ggplot(DF, AES) + 
    geom_point(size=2) + 
    geom_label_repel(show.legend=FALSE) + 
    # scale_colour_discrete(guide = FALSE)  +
    theme_bw() +
    # theme(axis.line = element_line(colour = "black"),
    #       panel.grid.major = element_blank(),
    #       panel.grid.minor = element_blank(),
    #       panel.border = element_blank(),
    #       panel.background = element_blank()) +
    expand_limits(y=c(0,1), x=c(0,1)) + 
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=14)) +
    xlab(Xlab) + ylab(Ylab) 
  
  nmse <- length(unique(DF$MSE))
  if (nmse > 1) {
    DF$MSE <- factor(DF$MSE, ordered=TRUE, levels=unique(DF$MSE))
    p1 <- p1 + facet_wrap(~MSE, ncol=nmse) 
  }
  
  p1 
}


grid_arrange_shared_legend <- function(plotlist, ncol = length(list(...)), nrow = 1, position = c("bottom", "right")) {
  
  # plots <- list(...)

  position <- match.arg(position)
  g <- ggplotGrob(plotlist[[1]] + theme(legend.position = position))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  lwidth <- sum(legend$width)
  gl <- lapply(plotlist, function(x) x + theme(legend.position="none"))
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(position,
                     "bottom" = arrangeGrob(do.call(arrangeGrob, gl),
                                            legend,
                                            ncol = 1,
                                            heights = unit.c(unit(1, "npc") - lheight, lheight)),
                     "right" = arrangeGrob(do.call(arrangeGrob, gl),
                                           legend,
                                           ncol = 2,
                                           widths = unit.c(unit(1, "npc") - lwidth, lwidth)))
  
  grid.newpage()
  grid.draw(combined)
  
  # return gtable invisibly
  invisible(combined)
  
}












