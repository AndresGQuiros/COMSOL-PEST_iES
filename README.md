### Calibration of hydrogeophysical models developed in COMSOL using PEST and PEST++ via MATLAB.
The examples in this folder are ready to run the iterative Ensemble Smoother with an example shown in the manuscript.
Some modifications in the .pst file would be necessary to run PEST in GLM mode.

## Licensing
PEST (Doherty, 2020) is freely available in its dedicated webpage https://pesthomepage.org/.
PEST++ (White et al., 2020) is accessible and available in the US Geological Survey webpage https://www.usgs.gov/software/pest-parameter-estimation-code-optimized-large-environmental-models .

Licensing for COMSOL, LiveLink for Matlab and MATLAB are required. 

An example of the forward hydrogeophysical model is in the file .mph.

MATLAB Version 2018a was used in this work. To modify MATLAB version change "C:\Program Files\Matlab_R2018a\bin\matlab.exe" for the relevant version in the ProgramInversion.bat file. The archive Run_Inversion.m is used to communicate with COMSOL and to postprocess the results.

## Prepare some files

factors.dat and ppcov.mat files are necessary to run the inversion with pilot points (but are not included here because of its size >200 mb).

PPK2FAC and PPCOV funcionalities from the PEST GWutils suite are necessary. 
Run these applications before running the inversion using the relevant pilot point and structure files provided in this folder.


## Run the inversion
To launch the inversion first the comsol server must be initiated. 

Navigate to "C:\Program Files\COMSOL\COMSOL54\Multiphysics\bin\win64" (or the equivalent folder for your COMSOL version) and run
```
comsolmphserver -multi on
```
For parallel computing several servers must be open. 

The port for comsol connection is in the first line of the Run_Inversion.m file. Default is usually 2036. 
For parallel each subfolder will require a different Run_Inversion.m file with a differnt port number in the first line (or a try/catch command with multiple ports).

To run the iterative Ensemble Smoother with PEST++ from the working folder run
```
pestpp-ies inv_pcf.pst
```
To run PEST in GLM mode equivalent workflow is used using instead:
```
pest inv_pcf.pst
```
If the .exe files are not in the working folder they must be added to the System Path as explained in PEST/PEST++ manuals.
