# PipelineInterface

This Pipeline interface is used to preprocessing the data from Femtonics MESc/MES.
- Features: 
 1. If you have two colour channels, channel 1 or channel 2 as dynamic (such as GCaMP) are both suitable.
 2. The parameters of registration will be saved.
 3. The size of cropped ROI will be saved and can be used in the future.
 4. *xy-t* and *xyz-t* data are suitable (step2 & 3 can be skipped for *xyz* data)

##### Snapshot of Pipeline Interface
![Pipeline Interface](photos/Pipeline.png)

# How to use:
1. Download the whole repos/zip file.
2. Download following tools
 - NoRMCorre from (https://github.com/flatironinstitute/NoRMCorre)
 - BioFormats for matlab (https://www.openmicroscopy.org/bio-formats/downloads/)
 - Multipage TIFF stack (https://www.mathworks.com/matlabcentral/fileexchange/35684-multipage-tiff-stack)
3. Add folder and subfolders into matlab path.
4. Run the *PipelineInterface.mlapp* in the PipelineInterface subfolder

# Outline of the pipeline, there are some steps as below:
 
## Step0: Export OMETIFF 
No this function now, please use Femtonics softwares

## Step1: Convert OMETIFF to TIFF
Use BioFormats tools to read and save as uint16 tiff files.

Different colour channels and different planes will be separated and saved.




***
## *Important: if your data is not times seires, please skip Step 2 and 3*
***

## Step2: Registration by Non-Rigid Motion Correction 
We use NoRMCorre to register the data.
Please go to website and original article for more details

##### Snapshot of Step2
![Step2](photos/Step2.png)

- *Github:*

https://github.com/flatironinstitute/NoRMCorre

- *Article:*

Eftychios A. Pnevmatikakis and Andrea Giovannucci, NoRMCorre: An online algorithm for piecewise rigid motion correction of calcium imaging data, Journal of Neuroscience Methods, vol. 291, pp 83-94, 2017; doi: https://doi.org/10.1016/j.jneumeth.2017.07.031


## Step3: Crop ROI
There are noise at the border after registration,
this step let you crop the data and reduce the noise

##### Snapshot of Step3
![Step3](photos/Step3.png)
