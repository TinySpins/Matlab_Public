## Dicom
These are some scripts for using Dicom (.dcm) files in Matlab, mostly for making specific tasks faster to perform.


### GetDicomHeader.m
This script can be used to easily get specific attributes from a dicom (.dcm) header, or just load the entire header. For specific attributes, this script is faster than looping over the dicominfo Matlab function.

**Usage examples**

*For a Dicom image located at /the/path/to/the/dicomfile.dcm*

```matlab
path = '/the/path/to/the/dicomfile.dcm';
attributes = {'RepetitionTime','FlipAngle'};
info = GetDicomHeader(path, attributes)

path = '/the/path/to/the/dicomfile.dcm';
attributes = {'all'};
info = GetDicomHeader(path, attributes)
```


### GetDicom.m
This script can be used to easily import a series of Dicom files (.dcm) into Matlab.

**Usage examples**

*For a series of Dicom images located in /the/path/to/the/Dicom/Series*

```matlab
path = GetPath; % Select the 'Series' directory containing the .dcm files.
[data,info] = GetDicom(path);
```