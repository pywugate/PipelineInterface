# PipelineInterface

This Pipeline interface is used to preprocessing the data from Femtonics MESc/MES

There are several steps:
 
## Step0: Export OMETIFF 
No this function now, please use Femtonics softwares

## Step1: Convert OMETIFF to TIFF
Use BioFormats tools to read and save as uint16 tiff files.

Different colour channels and different planes will be seperated and saved.




***
#### *Important: if your data is not times seires, please skip Step 2 and 3*
***

## Step2: Registration by Non-Rigid Motion Correction 
We use NoRMCorre to register the data.
Please go to website and original article for more details

#### *Github:*

https://github.com/flatironinstitute/NoRMCorre

#### *Article:*

Eftychios A. Pnevmatikakis and Andrea Giovannucci, NoRMCorre: An online algorithm for piecewise rigid motion correction of calcium imaging data, Journal of Neuroscience Methods, vol. 291, pp 83-94, 2017; doi: https://doi.org/10.1016/j.jneumeth.2017.07.031


## Step3: Crop ROI
There are noise at the border after registration,
this step let you crop the data and reduce the noise
