
# Raw code for lecture series 4

library(DLMtool)
setup()

DLMDataDir()

Pacific_WM<-new('Data',DLMDataDir('Cobia'))
Pacific_WM@Name<-"Pacific white marlin"

Pacific_WM_csv<-DLMDataDir('Cobia')

Pacific_WM<-new('Data',"C:/Data/Pacific_WM.csv")

myData = new('Data')
myData@Year = 2008:2017
myData@Cat = matrix(
                c(3.36,4.29,4.11,4.63,3.03,3.77,4.01,3.25,2.89,2.87),
                                                                    nrow=1)
myData@Dep= 0.33
myData@CV_Dep = 0.2

Somedata<-new('Data',DLMDataDir('Simulation_1'))

Can(Pacific_WM)

Cant(Pacific_WM)

Needed(Pacific_WM)

TACs <- TAC(Pacific_WM)  
MPs<-TACs@MPs
cond<-!grepl("Comp",MPs)&!grepl("4010",MPs)&!grepl("_CC",MPs)&!grepl("_ML",MPs)&!grepl("BK",MPs)&!grepl("Islope",MPs)
TACs@MPs<-TACs@MPs[cond]
TACs@TAC<-array(TACs@TAC[cond,,],c(sum(cond),100,1))

plot(TACs,maxlines=8)

Inputs<-Input(Pacific_WM)
Sense1<-Sense(Pacific_WM,"DCAC")




