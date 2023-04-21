% GetFiles.m

% This script detects and saves the name or full path of every file/folder
% with a given extension in a folder tree.

% Inputs:   
% path = the main directory to look in
% fileExtension = the extension of the files you want (i.e. .dcm or .img, ect.)
% appendFullPath = 1 writes out the full path, 0 writes out the filename

% Outputs:
% fileList = a cell with the names/paths of the detected files

% Usage example:
% fileList = GetFiles(MyFolder,'*.img',1);

function fileList = GetFiles(dirName, fileExtension, appendFullPath)

  dirData = dir([dirName '/' fileExtension]);      % Get the data for the current directory
  dirWithSubFolders = dir(dirName);
  dirIndex = [dirWithSubFolders.isdir];            % Find the index for directories
  fileList = {dirData.name}';                      % Get a list of the files
  if ~isempty(fileList)
    if appendFullPath
      fileList = cellfun(@(x) fullfile(dirName,x),...    % Prepend path to files
                       fileList,'UniformOutput',false);
    end
  end
  subDirs = {dirWithSubFolders(dirIndex).name};          % Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});            % Find index of subdirectories that are not '.' or '..'
  for iDir = find(validIndex)                            % Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});           % Get the subdirectory path
    fileList = [fileList; GetFiles(nextDir, fileExtension, appendFullPath)];  % Recursively call GetFiles
  end

end