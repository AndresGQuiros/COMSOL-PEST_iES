@echo off
Rem ###################################
Rem Some intermediate files are deleted.
Rem ###################################

del Data.csv > nul

Rem ###################################
Rem Pilot points interpolated.
Rem ###################################

fac2g < fac2g.in > nul

Rem ###################################
Rem Start MATLAB and runs COMSOL.
Rem ###################################

"C:\Program Files\Matlab_R2018a\bin\matlab.exe" -nodesktop -nosplash -wait -r Run_Inversion