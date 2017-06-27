# =====================================================================================================================
# plot DLMtool downloads and timeline

install.packages("cranlogs")
install.packages("ggplot2")

library(cranlogs)
library(ggplot2)

start <- as.Date('2014-09-14') # Launch
today <- as.Date('2017-06-24') #Sys.time()) # Today #as.Date('2015-14-4') # Today

prel<-as.Date(c('2014-09-14','2015-05-20','2015-08-29','2016-2-15','2016-7-15','2017-3-1','2017-4-10'   ,'2017-5-25'))
vnam<-c(        "1.34",     "1.35",       "2.1",       "3.1",      "3.2",      "3.3",      "4.1",      "4.2")
intervals<-c(prel,today)
intervals<-1+prel+(intervals[2:(1+length(prel))]-intervals[1:length(prel)])/2

out<-cran_downloads(packages = 'DLMtool',  from = start, to = today)
out<-out[!(out$count==0|out$count>200),]
cumcount<-cumsum(out$count)
out<-cbind(out,cumcount)
names(out)<-c("Date","Count","Package","CumCount")

scaler<-max(out$Count)/max(out$CumCount)

dat<-data.frame(x=as.numeric(out$Date),y=out$Count)
ply<-data.frame(Date=out$Date,y=predict(loess(y~x,dat,degree=2)))

ncols<-1000
colsse<-rainbow(ncols,start=0,end=0.36)[ncols:1]
coly<-colsse[ceiling(ncols*(((out$Count+0.01)/max(out$Count))^0.3))]

coly2<-colsse[ceiling(ncols*(((ply$y+0.01)/max(out$Count))^0.3))]


par(mar=c(5,5,3,5))

plot(out$Date,out$Count,col="white",pch=19,xlab="Date",ylab="Downloads per day",main="DLMtool package downloads 2014 - 2017")

abline(v=prel,col="dark grey",lty=2)
text(intervals,rep(max(out$Count)*0.943,length(intervals)),vnam,font=2,col="dark grey",cex=0.8)

for(i in 2:length(ply$y))lines(c(out$Date[i-1],out$Date[i]),c(ply$y[i-1],ply$y[i]),col=coly2[i],lwd=3)

points(out$Date,out$Count,col=coly,pch=19)
lines(out$Date,out$CumCount*scaler,col='#0000ff80',lwd=2.5)

a4<-pretty(seq(0,max(out$CumCount),length.out=10))

axis(4,at=a4*scaler,a4,col='blue',col.ticks='blue',col.axis='blue')
mtext("Total downloads",4,col='blue',line=2.9,font=2)






# ===================================================================================================================
#  number of MPs in the very latest development version (GitHUB)

install.packages('devtools')
library(devtools)
dev_mode(on=F) # use development version from GitHub
install_github("adrianhordyk/DLMtooldev") # Install dev package from GitHub  to R-dev location on local machine
library(DLMtool, lib.loc="C:/~/R-dev") # load local dev version

ni<-length(avail('DLM_input'))
no<-length(avail('DLM_output'))

print(paste("Total number of MPs: ",ni+no," (",ni," input control and ",no," output control)",sep=""))


  