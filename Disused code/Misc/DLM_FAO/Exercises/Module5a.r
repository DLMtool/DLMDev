## Exercise 5a: Advanced operating model specification	(~ 30 minutes) ####

## Initial set-up (only required if new R session) ####
library(DLMtool)  
setup() 

## Task 1: ####




## More Advanced ####

## Task 8: Use the 'ChooseEffort' function to sketch out bounds on trends in ####
# historical fishing effort 

MyFleet <- ChooseEffort(MyFleet)

# Note that the bounds on historical effort have now changed in the Fleet object 
MyFleet@EffLower
MyFleet@EffUpper

plot(MyFleet, Mack2)





## Task 9: Use the 'ChooseSelect' function to specify historical changes in ####
# selectivity
MyFleet <- ChooseSelect(MyFleet, Mack2)

# Note that the selectivity parameters have now changed in the Fleet object 

MyFleet@L5Lower
MyFleet@L5Upper 
MyFleet@LFSLower
MyFleet@LFSUpper
MyFleet@SelYears 
MyFleet@AbsSelYears

plot(MyFleet, Mack2)



-	Time varying selectivity / age dependent M
-	Preserving correlation among estimated growth parameters (what difference?)	
-	CatchCompSRA() function and interpreting outputs



## Tasks Below are Optional #####

## More Advanced ####

## Most Advanced ####






