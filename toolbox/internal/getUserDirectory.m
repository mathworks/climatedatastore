function directory = getUserDirectory()
%GETUSERDIRECTORY Get the current user directory, works on Windows, macOS, and Linux

% Copyright 2021 The MathWorks, Inc.
    if ispc
        % For Windows, use HOMEPATH
        [status, directory] = system("echo %HOMEDRIVE%%HOMEPATH%");
    else
        % For macOS/Linux, use HOME
        [status, directory] = system("echo $HOME");
    end
    
    if status ~= 0
        error("userDirectory:couldNotGetUserDirectory", "Could not retrieve user directory");
    end
    
    % Trim any whitespace and convert to string
    directory = strtrim(string(directory));
end
