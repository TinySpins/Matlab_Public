% GetDicomHeader.m

% This script reads the dicom header of a .dcm file and outputs the desired
% attributes. These can be specified as a list. Alternatively, the entire
% dicom header can be the output (this can be rather slow).

% Input
% path = the direct path to the dicom file, i.e. /path/to/my/dicomfile.dcm
% attributes = a list of desired dicom attributes, or the entire header
% attributes should be defined as {'all'} to load the entire header
% or {'RepetitionTime','FlipAngle'} to load attributes in list mode.

% Output
% A struct with fields defined by the defined attributes

function output = GetDicomHeader(path, attributes)

if strcmp('all', attributes)
    % If attributes has attribute all ('all')
    mode = 'all';
else
    % If attributes has one or more entries
    mode = 'list';
end

switch mode
    
    case 'list'
        % convert the file to an object (faster than dicomread)
        obj = images.internal.dicom.DICOMFile(path);
        
        % loop over the defined attributes
        for k = 1:length(attributes)
            attrib = obj.getAttributeByName(attributes{k});
            name = attributes{k};
            info.(name) = attrib;
        end
        
    case 'all'
        info = dicominfo(path);
end

output = info;

end