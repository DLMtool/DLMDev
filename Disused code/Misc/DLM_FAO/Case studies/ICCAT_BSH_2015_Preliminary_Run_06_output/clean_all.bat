:: Example of a DOS batch file to clean up SS3 output files after a crashed SS3 run (and/or before starting a new model run in the same directory)

del ss3*.r0*
del ss3*.p0*
del ss3*.b0*
del ss3*.bar
del ss3*.cor
del ss3*.eva
del ss3*.log
del ss3*.par
del ss3*.rep
del ss3*.std
del *.sso
del *.ss_new
del *.bak
del admodel.*
del eigv.rpt
del fmin.log
del variance
del runnumber.ss
del .R*
del SS_plots*.*