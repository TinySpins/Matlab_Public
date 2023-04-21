% GetDicom.m

% This function imports a series of MRI Dicom images to Matlab from a 
% specified folder. The function only works for Dicom files.

% Inputs: 
% path = full path to the Dicom series folder/directory using GetPath.m

% Outputs:
% data = Dicom image data
% info = Dicom info

% Usage example:
% [data,info] = GetDicom(path)

function [data,info] = GetDicom(path)  % GetData(path,fileType)    
    
    % Look for .dcm files in the path
    disp('// Looking for .dcm files in path.')
    dirData = dir([path.full '/*' '.dcm']); 
    
    % Import and read files
    disp('// Importing .dcm files in path.')

    for k = 1:length(dirData)
        info{k} = dicominfo([path.full '/' dirData(k).name]);
           
        % Check if there are slopes and intersects
        ping = 1;
        try
            RI = info{k}.RescaleIntercept;
            RS = info{k}.RescaleSlope;
            if k == 1
                disp('// Found Rescale Slope and Intercept Dicom attributes for this dataset.')
            end
        catch me
            ping = 0; % no slope/intersept
            if k == 1
                disp('// No Rescale Slope or Intercept Dicom attributes were found for this dataset.')
            end
        end
        
        % Apply slope and intersect if avalible
        if ping == 1
            if k == 1
                disp('// Rescale Slope and Intercept modifiers were applied.')
            end
            mod_data(:,:,k) = RS .* double(dicomread(info{k})) + RI;
        else
            if k == 1
                disp('// No Rescale Slope or Intercept modifiers were applied.')
            end
            mod_data(:,:,k) = double(dicomread(info{k}));
        end
            
    end
    
    % Output
    data = mod_data;

end