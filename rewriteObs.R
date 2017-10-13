# rename csvs
library(readr)
dir <- 'C:/Users/Adrian/Documents/GitHub/DLMDev/DLMtool_Data/Obs'
fls <- list.files(dir, pattern='.csv')

ob.old <- c('Btbias', 
            'Icv', 
            'Dcv',
            'Btcv',
            'Mcv',
            'Kcv',
            't0cv',
            'Linfcv',
            'LFCcv',
            'LFScv',
            'FMSYcv',
            'FMSY_Mcv',
            'BMSY_B0cv',
            'LenMcv',
            'hcv',
            'Irefcv',
            'Brefcv',
            'Crefcv',
            'Reccv')
ob.new <- c('Btbiascv', 
            'Ibiascv', 
            'Dobs',
            'Btobs',
            'Mbiascv',
            'Kbiascv',
            't0biascv',
            'Linfbiascv',
            'LFCbiascv',
            'LFSbiascv',
            'FMSYbiascv',
            'FMSY_Mbiascv',
            'BMSY_B0biascv',
            'LenMbiascv',
            'hbiascv',
            'Irefbiascv',
            'Brefbiascv',
            'Crefbiascv',
            'Recbiascv')

for (fl in fls) {
  
  tt <- read_csv(file.path(dir, fl), na="")
  for (x in seq_along(ob.old)) tt[tt[,1] == ob.old[x],1] <- ob.new[x]
  write_csv(tt, file.path(dir, fl), na="")
  
}

dir <- 'C:/Users/Adrian/Documents/GitHub/DLMDev/DLMextra_Data/buildOMfromCSV/DFO/Obs'
fls <- list.files(dir, pattern='.csv')

for (fl in fls) {
  
  tt <- read_csv(file.path(dir, fl), na="")
  for (x in seq_along(ob.old)) tt[tt[,1] == ob.old[x],1] <- ob.new[x]
  write_csv(tt, file.path(dir, fl), na="")
  
}



# Imp 
imp.old <- c('EFrac','ESD')
imp.new <- c('TAEFrac', "TAESD")