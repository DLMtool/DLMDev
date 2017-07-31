


Uses <- function(MP=NA, data=NULL) {
  options(warn=-1)
  if (class(MP) != 'character' && !is.na(MP)) stop("MP must be class 'character'", call.=FALSE)
  options(warn=1)
  if (all(is.na(MP))) MP <- c(avail("Output"), avail("Input"))
  if (!is.null(data)) MP <- c(avail("Output"), avail("Input"))
  val <- MP %in% c(avail("Output"), avail("Input"))
  if (all(!val)) stop("Invalid MPs: ", paste(MP[!val], ""), "\nNo valid MPs found", call.=FALSE)
  if (any(!val)) message("Ignoring invalid MPs: ", paste(MP[!val], ""))
  MP <- MP[val]
  
  out <- matrix(NA, nrow=length(MP), ncol=3)
  out[,1] <- MP
  out[,2] <- MPclass(MP)
    
  slotnams <- paste("Data@", slotNames("Data"), sep = "")
  for (mm in 1:length(MP)) {
    temp <- format(match.fun(MP[mm]))
    temp <- paste(temp[1:(length(temp))], collapse = " ")
    uses <- NULL
    for (j in 1:length(slotnams)) {
      if (grepl(slotnams[j], temp)) uses <- c(uses, slots[j])
    }
    out[mm,3] <- paste(uses[1:length(uses)], collapse = ", ")
  }
 
  colnames(out) <- c("MP", "Class", "Uses")
  
  if (!is.null(data)) {
    val <- data %in% slotNames("Data")
    if (all(!val)) stop("Invalid data: ", paste(data[!val], ""), "\nNo valid data found.\nValid data are: ", sort(paste(slotNames("Data"), "")), call.=FALSE)
    if (any(!val)) message("Ignoring invalid data: ", paste(data[!val], ""))
    data <- data[val]
    
    ind <- apply(do.call('cbind', lapply(data, grepl, x=out[,3])), 1, prod) > 0
    if (all(!ind)) return(message("No MPs found using: ", paste(data, "")))
    message("MPs using: ", paste(data, ""))
    print(out[ind,1:2])
    return(invisible(out))
    
  } else {
    return(out)  
  }
}

Uses("AvC")
Uses(c("AvC", "LBSPR_ItTAC"))


Uses('DCAC')


Uses(data=c("steep"))

uses <- Uses()
uses[,3]

lapply(strsplit(uses[3,3], split=","), trimws)


library(cluster)
library(factoextra)
str(USArrests)

slots <- slotNames('Data')

ignslots <- c("Name", "CV_", "Year", "Misc", "nareas", "Ref", "Ref_type", "Log", "params", 
              "OM", "TACs", "Obs", "TACbias", "Sense", "Units")

ind <- apply(do.call('cbind', lapply(ignslots, grepl, x=slots)), 1, sum) > 0
slots[!ind]
slots[ind]
valslots <- slots[!ind]
tempdat <- matrix(0, nrow=nrow(uses), ncol=length(valslots))
for (X in 1:nrow(uses)) {
  for (y in 1:length(valslots))
  if(grepl(valslots[y], uses[X,3])) tempdat[X,y] <- 1
}
colnames(tempdat) <- valslots 
rownames(tempdat) <- uses[,1]
tempdat <- as.data.frame(tempdat)


d = dist(tempdat, method = "binary")
hc = hclust(d, method="ward.D")
plot(hc)


democut<-cutree(hc,h=2)
plot(hc, labels = as.character(democut))


uses[democut == 1,]
uses[democut == 2,]
uses[democut == 3,]
uses[democut == 4,]
uses[democut == 5,]
uses[democut == 6,]
uses[democut == 7,]
uses[democut == 8,]


tt <-table(uses[,1],democut)
tt[order(tt[,1]),]
