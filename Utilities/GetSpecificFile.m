% GetSpecificFile.m

% This function creates the paths of a specific file/folder type in a user
% selected main folder.

% Inputs:   
% path = the main directory selected using GetPath.m
% FileType = the coherent naming of the file
% FileExtension = the extension of the files you want (i.e. .fid or .img, ect.)

% Outputs:
% FileList = a cell with the paths of the detected files

% Usage example:
% path = GetPath;
% fileList = GetSpecificFile(path,'multislice13C_','*.fid');

function FileList = GetSpecificFile(path,FileType,FileExtension)

    list = dir([path.full '/' FileType FileExtension]);
    
    for k = 1:numel(list)
        
        FileList{k} = [path.full '/' list(k).name];
        
    end
    
    FileList = FileList';
    
end