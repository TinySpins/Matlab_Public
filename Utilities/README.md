## Utilities
These are some utilities for Matlab, mostly for making specific tasks faster to perform.


### GetPath.m
This script can be used to easily get a directory path using the GUI.
The output path parameter is a struct containing the full path, directory name and parent directory name.

**Usage examples**

```matlab
path = GetPath;
```


### GetFiles.m
This script detects and saves the name or full path of every file/folder with a given extension in a folder tree - i.e. including files in subdirectories.

**Usage examples**

*For a main folder with name = '/The/Path/To/An_Example_Folder' and files with the '.dcm' extension*

```matlab
% If using a hardcoded path
fileList = GetFiles('The/Path/To/An_Example_Folder','*.dcm',1);

% If using GetPath
path = GetPath;
fileList = GetFiles(path.full,'*.dcm',1);
```

*For a list of subfolders with names =  
'/The/Path/To/An_Example_Folder/Folder_A1'  
'/The/Path/To/An_Example_Folder/Folder_A2'  
'/The/Path/To/An_Example_Folder/Folder_B1'  
'/The/Path/To/An_Example_Folder/Folder_B2'  
'/The/Path/To/An_Example_Folder/Other_Folder_A1'  
'/The/Path/To/An_Example_Folder/Other_Folder_A2'*

```matlab
% Use GetFiles.m with wildcard-based 'tags' to extract paths of specific subfolders (or files) based on the entire filename.
% The following extracts the two 'Other_Folder_A' subfolders while ignoring the rest.
tags = 'Other*A*';
fileList = GetFiles('/The/Path/To/An_Example_Folder',tags,1);
% Basically, a 'tag' is defined by a word followed by a Wildcard (*). 
% Exceptions are: wilcards (*) cannot be the first or last character in the 'tags' string.
```


### GetSpecificFile.m
This script can be used to easily get list of files in a main folder selected using GetPath based on the naming of the desired files. The scripts supports use of wildcards (*). The output is a cell containing the full path of the detected directory names.

**Usage examples**

*For a file or folder with name = '/The/Path/To/This_Is_An_Example_File.dcm'*

```matlab
% First part of filename and extension used.
path = GetPath;
fileList = GetSpecificFile(path,'This_Is_An_','*.dcm');

% If the path is not found using GetPath - the function uses path.full internally. First part of filename and extension used.
path.full = '/The/Path/To';
fileList = GetSpecificFile(path,'This_Is_An_','*.dcm');

% Part of filename and no extension used.
% Wrapping in wildcards (*) are necessary because we search for a part of the filename
% that does not include the beginning of the string.
path = GetPath;
fileList = GetSpecificFile(path,'*_Is_An_Example_*','');

% End part of filename and no extension used. The wildcard (*) is necessary because we
% search for a part of the filename that does not include the beginning of the string.
path = GetPath;
fileList = GetSpecificFile(path,'*_Example_File','');

% Part of filename and extension used. Wrapping in wildcards (*) are necessary because we
% search for a part of the filename that does not include the beginning of the string.
path = GetPath;
fileList = GetSpecificFile(path,'*_Is_An_Example_*','*.dcm');

% Part of filename and only part of extension used. Wrapping in wildcards (*) are
% necessary because we search for a part of the filename that does not include the
% beginning of the string.
path = GetPath;
fileList = GetSpecificFile(path,'*_Is_An_Example_*','*dc*');
```


### GetExt.m
This function detects file extensions in the selected folder path and outputs the most common string.

**Usage examples**

```matlab
path = GetPath;
ext = GetExt(path);
```
