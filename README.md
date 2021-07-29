The files in this repository are ready for calibration of hydrogeophysical model developed in COMSOL using PEST and PEST++.

PEST (Doherty, 2020) is freely available in its dedicated webpage https://pesthomepage.org/.
PEST++ (White et al., 2020) is accessible and available in the US Geological Survey webpage https://www.usgs.gov/software/pest-parameter-estimation-code-optimized-large-environmental-models .

Licensing for COMSOL, LiveLink for Matlab and MATLAB are required. 

For MATLAB Version 2018a wa used in this work. To modify MATLAB version change "C:\Program Files\Matlab_R2018a\bin\matlab.exe" for the relevant version in the ProgramInversion.bat file. 

To launch the inversion first the comsol server must be initiated. Navigate to "C:\Program Files\COMSOL\COMSOL54\Multiphysics\bin\win64" (or the equivalent folder for your COMSOL version) and run
```
comsolmphserver -multi on
```
For parallel computing several servers must be open.

To run PEST or PEST++ from the working folder run
```
pest inv_pcf.pst
```
or

```
pestpp-ies inv_pcf.pst
```
