:: Example of a DOS batch file to Run SS3 from a DOS command line window
:: #SS3 is compiled in ADMB. Optional ADMB command Line Options are defined below (e.g., admb-11.2_manual.pdf Chapter 12)
:: #-nox don’t show vector and gradient values in function minimizer screen
:: #-cbs N set CMPDIF_BUFFER_SIZE TO N
:: #-gbs N set GRADSTACK_BUFFER_SIZE TO N
:: #-ams N set arrmblsize to n (ARRAY_MEMBLOCK_SIZE)
:: #-maxfn N set maximum number of function eval’s to N
:: #-nohess option if you don’t wish to calculate the Hessian. 

SS3safe_Win64.exe -nox -cbs 1000000000 -gbs 1000000000 -ams 80000000 %1 %2 %3 %4
