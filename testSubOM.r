library(DLMtool)
Stock <- Albacore 
Fleet <- Generic_fleet
Obs <- Perfect_Info
Imp <- Perfect_Imp
tt <- new("OM", Stock, Fleet, Obs, Imp)
SubOM(tt, "Stock")@Name == Stock@Name 
SubOM(tt, "Fleet")@Name == Fleet@Name 
SubOM(tt, "Obs")@Name == Obs@Name 
SubOM(tt, "Imp")@Name == Imp@Name
class(tt) == "OM"
