# Make Cheat Sheets 

library(DLMtool)
library(tools)

db <- tools::Rd_db("DLMtool")

## Make Cheat Sheets for Classes ----
Classes <- grep("-class", names(db))

for (Class in Classes) {
temp <- db[[Class]]
   

tags <- tools:::RdTags(temp)
# Name ----
Name <- gsub("'", "", temp[[2]][[1]][1])

# Description ----
inds <- length(temp[[5]])
store <- NULL
for (X in 2:inds) {
  store <- append(store, (temp[[5]][[X]][1]))
}
Description <- trimws(gsub("\n", "", paste(store, "", collapse="")))


# Sections 
ind <- which(tags == "\\section")


# Slots ----
tt <- temp[[ind[1]]]
st <- lapply(tt[[2]], length)[[3]]
out <- matrix(NA, nrow=st, ncol=2)
stnum <- 2
index <- seq(from=stnum, by=3, to=st)
for (XX in seq_along(index)) {
  out[XX,1] <- tt[[2]][[3]][[index[XX]]][[1]][[1]][[1]][1]
  templength <- length(tt[[2]][[3]][[index[XX]]][[2]])
  store <- NULL
  for (X in 1:templength) {
    store <- append(store, tt[[2]][[3]][[index[XX]]][[2]][[X]][1])
  }  
  store <-  trimws(gsub("\n", "", paste(store, "", collapse="")))
  # if (nchar(store) > 80) {
  #   totchar <- nchar(store)
  #   tots <- totchar/80
  #   splocs <- gregexpr(pattern =' ', store)[[1]]
  #   if (sum(splocs > 70) > 1) {
  #     loc <- min(splocs[splocs > 70])
  #     locs <- seq(from=loc, by=80, to=nchar(store))
  #     store <- paste(read.fwf(textConnection(store), 
  #                  c(locs, nchar(store)), as.is = TRUE), collapse = "\n")
  #   }
  # }
  out[XX,2] <- store
}

out <- out[as.logical(apply(!apply(out, 1, is.na), 2, prod)),]



# Function call ----
Call <- NULL
if (length(ind) > 1) {
  inds <- length(temp[[ind[2]]][[2]])
  store <- NULL
  for (X in 2:inds) {
    store <- append(store, temp[[ind[2]]][[2]][[X]][1])
  }
  store <-  trimws(gsub("\n", "", paste(store, "", collapse="")))
  Call <- store
}



# Make Table ----
nrow <- 2 + length(Call) + nrow(out) + 2 
outmat <- matrix(NA, nrow=nrow, ncol=2)
outmat[1,] <- c("Name", Name)
outmat[2,] <- c("Description", Description)
ind <- 3 
if (length(Call) > 0) {
  outmat[ind,] <- c("Function call", Call)  
  ind <- 4
}
outmat[ind,] <- c("", "")
outmat[ind+1,] <- c("Slots", "")
ind <- ind+2
outmat[ind:(ind+nrow(out)-1), ] <- out




write.table(outmat, file=file.path("CheatSheets", paste0(Name, ".csv")), row.names=FALSE, 
          col.names=FALSE, sep=",")

}

# library(htmlTable)
# 
# 
# mytableout <- htmlTable(outmat[,2],
#           header =  c("Description"),
#           rnames = outmat[,1])
#   
# sink("mytable.html")
# print(mytableout,type="html",useViewer=TRUE)
# sink()



