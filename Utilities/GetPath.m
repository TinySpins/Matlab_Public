% GetPath.m

% This script gets the path of a folder by user selection through the file
% browser GUI. The path variable contains the folder name, the full path and the parent
% directory.

% path.folder = folder name
% path.full = full path
% path.parent = parent dir path

function path = GetPath

directory_name = uigetdir;
[pathstr,DataSetName,ext] = fileparts(directory_name);

path.folder = DataSetName;
path.full = directory_name;
path.parent = pathstr;

end
