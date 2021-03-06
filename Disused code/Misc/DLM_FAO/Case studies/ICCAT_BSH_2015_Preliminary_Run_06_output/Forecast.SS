#C Preliminary North Atlantic Blue Shark SS3 model run 06
# for all year entries except rebuilder; enter either: actual year, -999 for styr, 0 for endyr, neg number for rel. endyr							
1	# Benchmarks: 0=skip; 1=calc F_spr,F_btgt,F_msy 						
2	# MSY: 1= set to F(SPR); 2=calc F(MSY); 3=set to F(Btgt); 4=set to F(endyr) 						
0.307868633	# SPR target (e.g. 0.40)						
#   D.C. notes 7/18/2015, SPRtarget is set equal to SPR_MER and used here as a proxy for SPR_MSY (see Brooks et al 2010) and can be interpreted as a proxy for the limit SPR_MSY reference point 							
0.235397214	# Biomass target (e.g. 0.40)						
# D.C. notes 7/18/2015 biomass target is set equal to (S_MER/S_0) is used here as a proxy for S_MSY/S_0 (see Brooks et al 2010) and can be interpreted as a proxy for the S_MSY limit reference point  							
#_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF (enter actual year, or values of 0 or -integer to be rel. endyr)							
-10	-1	-10	-1	-10	-1		
#  1996 2005 1996 2005 1996 2005 # after processing 							
1	#Bmark_relF_Basis: 1 = use year range; 2 = set relF same as forecast below						
#							
0	# Forecast: 0=none; 1=F(SPR); 2=F(MSY) 3=F(Btgt); 4=Ave F (uses first-last relF yrs); 5=input annual F scalar						
10	# N forecast years 						
0	# F scalar (only used for Do_Forecast==5)						
#_Fcast_years:  beg_selex, end_selex, beg_relF, end_relF  (enter actual year, or values of 0 or -integer to be rel. endyr)							
0	0	0	0				
#  1180631082 1667592815 7631713 1936290657 # after processing 							
1	# Control rule method (1=catch=f(SSB) west coast; 2=F=f(SSB) ) 						
0.4	# Control rule Biomass level for constant F (as frac of Bzero, e.g. 0.40)						
0.1	# Control rule Biomass level for no F (as frac of Bzero, e.g. 0.10) 						
0.75	# Control rule target as fraction of Flimit (e.g. 0.75) 						
3	#_N forecast loops (1-3) (fixed at 3 for now)						
3	#_First forecast loop with stochastic recruitment     						
0	#_Forecast loop control #3 (reserved for future bells&whistles) 						
0	 #_Forecast loop control #4 (reserved for future bells&whistles) 						
0	 #_Forecast loop control #5 (reserved for future bells&whistles) 						
2014	  #FirstYear for caps and allocations (should be after years with fixed inputs) 						
0.1	# stddev of log(realized catch/target catch) in forecast (set value>0.0 to cause active impl_error)						
0	# Do West Coast gfish rebuilder output (0/1) 						
2014	 # Rebuilder:  first year catch could have been set to zero (Ydecl)(-1 to set to 1999)						
-1	# Rebuilder:  year for current age structure (Yinit) (-1 to set to endyear+1)						
1	 # fleet relative F:  1=use first-last alloc year; 2=read seas(row) x fleet(col) below						
# Note that fleet allocation is used directly as average F if Do_Forecast=4 							
2	# basis for fcast catch tuning and for fcast catch caps and allocation  (2=deadbio; 3=retainbio; 5=deadnum; 6=retainnum)						
# Conditional input if relative F choice = 2							
# Fleet relative F:  rows are seasons, columns are fleets							
"#_Fleet:  #F1 F2 F3 F4 F5 
"							
#  0 0 0 0 0 							
#  0 0 0 0 0 							
#  0 0 0 0 0 							
#  0 0 0 0 0 							
# max totalcatch by fleet (-1 to have no max) must enter value for each fleet							
-1	-1	-1	-1	-1			
# max totalcatch by area (-1 to have no max); must enter value for each fleet 							
-1							
# fleet assignment to allocation group (enter group ID# for each fleet, 0 for not included in an alloc group)							
0	0	0	0	0			
#_Conditional on >1 allocation group							
# allocation fraction for each of: 0 allocation groups							
# no allocation groups							
0 # Number of forecast catch levels to input (else calc catch from forecast F) 							
2	# basis for input Fcast catch:  2=dead catch; 3=retained catch; 99=input Hrate(F) (units are from fleetunits; note new codes in SSV3.20)						
# Input fixed catch values							
#Year Seas Fleet Catch(or_F) 							
							
#							
999 # verify end of input 							
