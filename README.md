### Calibration of hydrogeophysical models developed in COMSOL using PEST and PEST++ via MATLAB.
The examples in this folder are ready to run the iterative Ensemble Smoother with an example shown in the manuscript.
Some modifications in the .pst file would be necessary to run PEST in GLM mode.

## Licensing
PEST (Doherty, 2020) is freely available in its dedicated webpage https://pesthomepage.org/.
PEST++ (White et al., 2020) is accessible and available in the US Geological Survey webpage https://www.usgs.gov/software/pest-parameter-estimation-code-optimized-large-environmental-models .

Licensing for COMSOL, LiveLink for Matlab and MATLAB are required. 

An example of the forward hydrogeophysical model is in the file .mph.

MATLAB Version 2018a was used in this work. To modify MATLAB version change "C:\Program Files\Matlab_R2018a\bin\matlab.exe" for the relevant version in the ProgramInversion.bat file. The archive Run_Inversion.m is used to communicate with COMSOL and to postprocess the results. FAC2G PEST funcionality must be included in folder or added to the system path.

## Prepare some files

factors.dat and ppcov.mat files are necessary to run the inversion with pilot points (but are not included here because of its size >200 mb).

**PPK2FACG** and **PPCOV** funcionalities from the PEST GWutils suite are necessary. Run these applications before running the inversion using the relevant pilot point and structure files provided in this folder.

Run **PPK2FACG** to compute the kriging factors using the PP.pts file, the zone.xyz nodal file and the struct.dat structure file provided. See p. 191 of the PEST GW data utilities Part B document. Name factors.dat as interpolation factors file. These will be used by the FAC2G utility during the inversion and the details are in the fac2g.in file.

A covariance file is required by pestpp-ies. To generate the covariance matrix with the structure file provided it is necessary to run **PPCOV**. See p. 191 of the PEST GW data utilities Part B document. Use as output name ppcov.mat. This will be used in the param.unc file and then added to the PEST control file options [++ parcov(param.unc)].


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


-------------------------------------------------------------------------------

To run PEST in GLM mode  use instead but note that different options in the pest control file are necessary (see the PEST manual).
```
pest inv_pcf.pst
```
The .exe files necessary to run this example are provided. If they are not in the working folder they must be added to the System Path as explained in PEST/PEST++ manuals.
