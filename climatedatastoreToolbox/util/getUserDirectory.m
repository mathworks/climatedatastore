function directory = getUserDirectory()
%GETUSERDIRECTORY Get the current user directory

% Copyright 2021 The MathWorks, Inc.
    [status, directory] = system("echo %HOMEPATH%");
    if status ~= 0
        error("userDirectory:couldNotGetUserDirectory","Could not retrieve user directory")
    end
    directory = strtrim(string(directory));
end

