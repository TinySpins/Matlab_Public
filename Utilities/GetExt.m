% GetExt.m

% This function detects file extensions in the selected folder path and 
% outputs the most common string.

function ext = GetExt(path)
    
    files = dir(path.full);
    
    for k = 1:length(files)
        [pathstr,name,ext_log{k}] = fileparts(files(k).name);
        if length(ext_log{k}) <= 1      % i extension is '.' remove it
            ext_log{k} = [];
        end      
    end
    
    extensions =  ext_log(~cellfun('isempty',ext_log));   % remove empty cell entries and exit
    extension_types = unique(extensions)
    extension_ocurrances = cellfun(@(x) sum(ismember(extensions,x)),extension_types,'un',0);
    [max_size, max_index] = max(cellfun('size', extension_ocurrances, 1));
    ext = extension_types{max_index};
    
end