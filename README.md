# Calibration of hydrogeophysical models developed in COMSOL using PEST++ via MATLAB.

AndrésGonzález-Quirós & Jean-ChristopheComte
Hydrogeophysical model calibration and uncertainty analysis via full integration of PEST/PEST++ and COMSOL
Environmental Modelling & Software, 105183
https://doi.org/10.1016/j.envsoft.2021.105183

The examples in this folder are ready to run the iterative Ensemble Smoother with an example shown in the manuscript.

COMSOL 5.4 (or higher) and MATLAB with appropriate licensing are required (see below).


## Licensing
**PEST** (Doherty, 2020) is freely available in its dedicated webpage https://pesthomepage.org/.
**PEST++** (White et al., 2020) is accessible and available in the US Geological Survey webpage https://www.usgs.gov/software/pest-parameter-estimation-code-optimized-large-environmental-models .

Licensing for COMSOL (ACDC, Darcy's flow and LiveLink for Matlab) and MATLAB are required. For parallelization a COMSOL Floating Network license is necessary.

An example of the forward hydrogeophysical model with the necessary input and output files is in the file 0_Model_Base.mph.

MATLAB Version 2018a was used in this work. To work with other MATLAB version change "C:\Program Files\Matlab_R2018a\bin\matlab.exe" for the relevant version in the *ProgramInversion.bat* file. The archive *Run_Coupled_FWD.m* is used to communicate with COMSOL, run the forward model, postprocess the results and extract the relevant files required by PEST++.  



## Prepare some files

*factors.dat* and *ppcov.mat* files are necessary to run the inversion with pilot points (but are not included here because of its size >200 mb).

**PPK2FACG** and **PPCOV** funcionalities (included in this repository) from the PEST GWutils suite are necessary. Run these applications before running the inversion using the relevant pilot point and structure files provided in this folder.

Run **PPK2FACG** to compute the kriging factors using the *PP.pts* file, the *zone.xyz* nodal file and the *struct.dat* structure file provided. See p. 191 of the PEST GW data utilities Part B document. Name *factors.dat* as interpolation factors file. These will be used by the **FAC2G** utility during the inversion and the details are in the *fac2g.in* file.

A covariance file is required by pestpp-ies. To generate the covariance matrix with the structure file provided it is necessary to run **PPCOV**. See p. 191 of the PEST GW data utilities Part B document. Use as output name *ppcov.mat*. This will be used in the *param.unc* file and then added to the PEST control file options [++ parcov(param.unc)].



## Run PEST with COMSOL

### Initialise the COMSOL server
To launch the process first the comsol server must be initiated. 

Navigate to "C:\Program Files\COMSOL\COMSOL54\Multiphysics\bin\win64" (or the equivalent folder for your COMSOL version) and run
```
comsolmphserver -multi on
```

The port for comsol connection is in the first line of the *Run_Coupled_FWD.m* file. Default is usually 2036. If open another port the first line must be modified  

```
mphstart(2036)
```


### RUN PEST++

Finally, to run the iterative Ensemble Smoother with PEST++ from the working folder run
```
pestpp-ies inv_pcf.pst
```

The .exe files necessary to run this example are provided. If they are not in the working folder they must be added to the System Path as explained in PEST/PEST++ manuals.


### Parallelization

Create subfolders (agents) with the relevant files copied in them.

For parallelization several COMSOL servers must be open and each subfolder will require the *Run_Coupled_FWD.m* file with the relevant port number in the first line (or a try/catch command with multiple ports).

Check your hostname in the CMD.
```
>hostname
#YOUR_HOST_NAME#
```

In the main folder launch the master
```
pestpp-ies inv_pcf.pst /h :4004
```

From each subfolder launch the agents
```
pestpp-ies inv_pcf.pst /h #YOUR_HOST_NAME#:4004
```


# CONTACT

If you find any problems with the files or need any clarification contact 

andres.quiros@abdn.ac.uk 
or 
andresgquiros@gmail.com



-------------------------------------------------------------------------------

To run PEST in GLM mode use instead 
```
pest inv_pcf.pst
```
but note that different options in the pest control file are necessary (see the PEST manual).
