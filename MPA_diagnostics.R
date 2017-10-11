
library(DLMtool)

setup()

OM <- testOM
OM@nsim <- 150

# 1 
OM@Frac_area_1 <- c(0.5, 0.5)
OM@Size_area_1 <- c(0.5, 0.5)
OM@Prob_staying <- c(0.99, 0.99)
test1 <- runMSE(OM, MPs=c("AvC", "MRreal"))
summary(test1)

# 2 
OM@Frac_area_1 <- c(0.5, 0.5)
OM@Size_area_1 <- c(0.2, 0.2)
test2 <- runMSE(OM, MPs=c("AvC", "MRreal"))
summary(test2)



# 3
OM@Frac_area_1 <- c(0.8, 0.8)
OM@Size_area_1 <- c(0.5, 0.5)
test3 <- runMSE(OM, MPs=c("AvC", "MRreal"))
summary(test3)


# 4
OM@Frac_area_1 <- c(0.2, 0.2)
OM@Size_area_1 <- c(0.5, 0.5)
test4 <- runMSE(OM, MPs=c("AvC", "MRreal"))
summary(test4)

Tplot(test1)
Tplot(test2)
Tplot(test3)
Tplot(test4)


summary(test1)
summary(test2)
summary(test3)
summary(test4)



test@OM$Size_area_1[1]
which.max(test@OM$Frac_area_1/test@OM$Size_area_1)

sim <- 32
yr <- 5
age <- OM@maxage

matplot(test@FM_hist[sim,age,,], type="b")



matplot(test@FM_hist[sim,age,,], type="l")
test@F_FMSY 


