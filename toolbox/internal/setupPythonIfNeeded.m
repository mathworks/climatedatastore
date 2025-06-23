function setupPythonIfNeeded()
    %setupPythonIfNeeded Check if python 3.10 is installed and configured.  If it's
    %not, download and install it

    % Python setup is only supported in R2022b and later 
    if verLessThan('matlab','9.9') || isMATLABReleaseOlderThan("R2022b") %#ok<VERLESSMATLAB> isMATLABReleaseOlderThan was introduced in R2020b / version 9.9
        error("setupPythonIfNeeded:unsupportedVersion","Only version R2022b and later are supported")
    end        

    % Check if MATLAB has python set up
    pythonInfo = pyenv;
    
    if pythonInfo.Version ~= ""
        % It's set up: return
        return
    end
    
    % Python is not set up, but it might be installed.  Check to see if it
    % is installed in any standard locations
    pythonVersionToLookFor = getSupportedPythonVersions();
    
    % Check for python executable in user directory (default install)
    pythonExecutable = locatePythonInstallations(getUserPythonDir(),pythonVersionToLookFor);
    
    if pythonExecutable == ""
        % Check for python executable in program files directory (all user install)
        pythonExecutable = locatePythonInstallations(getProgramFilesDir(),pythonVersionToLookFor);

        if pythonExecutable == ""
            % Trigger an install here
            
            webpath = "https://www.python.org/ftp/python/3.10.9/";
            filename = "python-3.10.9-amd64.exe";
            downloadPath = fullfile(tempdir,filename);
            installEXEPath = websave(downloadPath,webpath + filename);
            status = system(installEXEPath);
            if status ~= 0
                error("setupPythonIfNeeded:pythonNotInstalled",'Could not install python.  <a href="%s%s">Download and install version 3.10/a>',webpath,filename)
            end
            pythonExecutable = locatePythonInstallations(getUserPythonDir(),pythonVersionToLookFor);
            if pythonExecutable == ""
                pythonExecutable = locatePythonInstallations(getProgramFilesDir(),pythonVersionToLookFor);
                if pythonExecutable == ""
                    error("setupPythonIfNeeded:pythonNotInstalled",'Could not install python.  <a href="%s%s">Download and install version 3.10</a>',webpath,filename)
                end
            end
        end
    end
    
    pythonInfo = pyenv('Version', pythonExecutable);

    if pythonInfo.Version == ""
        % Python was not set up correctly
        error("setupPythonIfNeeded:unableToSetPythonVersion","Could not configure python for use.  See ""Configure Your System to Use Python"" in MATLAB documentation.")
    end
    
    function pythonVersion = getSupportedPythonVersions()
        % It would be better to get this info from the internet somewhere,
        % but for now....
        % This is based on
        % https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/python-compatibility.pdf
        if verLessThan('matlab','9.9') %#ok<VERLESSMATLAB>
            versionInfo = ver('matlab'); %#ok<VERMATLAB>
        else 
            % matlabRelease was introduced in R2020b
            versionInfo = matlabRelease();
            versionInfo = versionInfo.Release;
        end
        MATLABrelease = extract(string(versionInfo.Release),alphanumericBoundary + alphanumericsPattern + alphanumericBoundary);
        switch MATLABrelease
            case "R2025a"
                pythonVersion = ["3.9";"3.10";"3.11";"3.12"];
            case "R2024b"
                pythonVersion = ["3.9";"3.10";"3.11";"3.12"];
            case "R2024a"
                pythonVersion = ["3.9";"3.10";"3.11"];
            case "R2023b"
                pythonVersion = ["3.9";"3.10";"3.11"];
            case "R2023a"
                pythonVersion = ["3.8";"3.9";"3.10"];
            case "R2022b"
                pythonVersion = ["3.8";"3.9";"3.10"];
            otherwise
                % Lets assume 3.10 will work for a while
                pythonVersion = "3.10";
        end
    end

    function pythonDir = getUserPythonDir()
        [status, localAppDataPath] = system("echo %LOCALAPPDATA%");
        if status ~= 0
            error("setupPythonIfNeeded:cantGetProgramFiles","Cannot retreive location of user directory.")
        end
        localAppDataPath = strtrim(string(localAppDataPath));
        pythonDir = fullfile(localAppDataPath,"Programs","Python");

    end

    function pythonDir = getProgramFilesDir()
        [status, programFilesPath] = system("echo %PROGRAMFILES%");
        if status ~= 0
            error("setupPythonIfNeeded:cantGetProgramFiles","Cannot retreive location of program files directory.")
        end
        programFilesPath = strtrim(string(programFilesPath));
        pythonDir = fullfile(programFilesPath,"Python");
    end

    function pythonExecutable = locatePythonInstallations(pythonDir,pythonVersionToLookFor)
        % sort the version numbers and transform to directory names, newest
        % to oldest
        pythonVersion = sortrows(split(pythonVersionToLookFor,"."),[1 2],'descend');
        pythonDirNames = "Python" + pythonVersion(:,1) + pythonVersion(:,2);
        pythonExecutable = "";
        for iDir = 1:numel(pythonDirNames)
            % Go through supported releases, see if there's a python.exe at each location, going from
            % latest release
            pythonExecutable = fullfile(pythonDir,pythonDirNames(iDir),"python.exe");
            if exist(pythonExecutable,'file')
                return
            end
        end
    end
end

