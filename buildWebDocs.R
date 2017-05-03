

# Generate website for DLMtool documentation

setwd("C:/Users/Adrian/Documents/GitHub/DLMDev")
source("pkgdown_functions.r")

setwd("C:/Users/Adrian/Documents/GitHub/DLMtool")
# devtools::install_github("hadley/pkgdown")
library(pkgdown)
library(DLMtool)
library(dplyr)
library(magrittr)
library(purrr)


# barplot.MSE <- barplot
# boxplot.MSE <- boxplot
# boxplot.Data <- boxplot 

defineCat <- function(func) {
  if (grepl("-", func) == FALSE) {
    class <- try(class(get(func)), silent=TRUE) 
    if (class(class) == "try-error") class <- "something" 
        
    if (class == "Output") {
	    if (grepl("ref", func)) return("Reference_Methods")
	    return("Output_Controls")
	  }
    if (class == "Input") return("Input_Controls")
    if (class != "Output" & class != "Input")  { # not a MP 
	  
	    # Operating Model
	    ## OM Input 
	    funs <- c("writeCSV", "OM_xl")
	    # if (func %in% funs) return("OM_Input")
	    
	    ## OM Setup 
	    funs <- c(funs, "ChooseEffort", "ChooseSelect", "SetRecruitCycle", "makePerf",
	              "ForceCor", "iSCAM2DLM", "Replace", "SubOM", "SS2DLM", "StochasticSRA")
	    if (func %in% funs) return("Operating_Model_Functions")
	    
	    ## run MSE 
	    funs <- c("runMSErobust", "runMSE")
	    if (func %in% funs) return("Run_MSE_Functions")
	    
	    # MSE Object #	    
	    ## MSE Plotting Functions 
	    funs <- plotFun(msg=FALSE)
	    funs <- c(funs, "barplot.MSE", "boxplot.MSE", "Converge", "checkMSE")
	    if (func %in% funs) return("MSE_Object_Plotting_Functions")
	    
	    ## MSE Object Functions 
	    funs <- c("Sub", "updateMSE", "MPStats", "joinMSE", "DOM")
	    if (func %in% funs) return("MSE_Object_Functions")
	    
	    # Data Object 
	    ## Available Methods
	    funs <- c("Can", "Cant", "Needed", "Fease", "Required")
	    if (func %in% funs) return("Available_Methods_and_Required_Data")
	    
	    ## Apply MP 
	    funs <- c("TAC", "Sam", "Input", "runInMP")
	    if (func %in% funs) return("Apply_Management_Procedures")
  
      ## Data Object Plotting Functions 	  
	    funs <- plotFun("Data", msg=FALSE)
	    funs <- c(funs, "boxplot.Data", "Sense")
	    if (func %in% funs) return("Fishery_Data_Plotting_Functions")
	    
	    # Other 
	    ## Estimation methods
	    funs <- c("ML2D", "L2A", "CSRA", "CSRAfunc")
	    if (func %in% funs) return("Estimation_Functions")	  
	    
	    ## Useful Misc
	    funs <- c("replic8", "plotFun", "NAor0", "KalmanFilter", "DLMDataDir", 
	    "avail", "Fease_xl", "setup")
	    if (func %in% funs) return("Other_Functions")	
	    
	    ## Other 
	    funs <- c("getq", "getmov", "getAFC", "LBSPR", "movfit",
	      "getAFC",  "qopt", "alphaconv", "betaconv", "cv", "getEffhist", "getFMSY",
		  "getFMSY2", "getFref", "getFref2", "getmov2", "getq2", "getroot", "mconv", 
		  "movfit_Rcpp", "optQ_cpp", "trlnorm", "TACfilter", "FMSYopt", "sdconv")
	    if (func %in% funs) return("Internal_Functions")
	    
	    if (class == "Stock") return("Stock_Objects")
	    if (class == "Fleet") return("Fleet_Objects")
	    if (class == "Obs") return("Obs_Objects")
	    if (class == "Imp") return("Imp_Objects")
	    if (class == "OM") return("OM_Objects")
	    if (class == "MSE") return("MSE_Objects")
	  } 
	
  } else {
    # Object Classes
	if(grepl("-class", func)) return("R_Object_Classes")	
    return("uncat")
  }
  return("uncat")
}


build_siteDLM()

