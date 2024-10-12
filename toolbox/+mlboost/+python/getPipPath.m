function pipPath = getPipPath()
    %GETPIPPATH Get the location of the pip3 executable
    %   pipPath = getPipPath() returns the full path to the pip3 executable
    %   using the Python environment information obtained from pyenv.
    %
    %   This function constructs the path to the pip3 executable, verifies its
    %   existence, and returns the full path. If the pip executable is not found,
    %   it throws an error.
    %
    %   Returns:
    %       getPipPath (string): Full path to the pip3 executable
    %
    %   Throws:
    %       mlboost:python:PIPNotFound: If the pip executable cannot be located
    %
    %   See Also:
    %       mlboost.python.getPythonPath, mlboost.python.pipCommand, mlboost.python.ensurepip
    
    % Get the Python environment
    pyEnv = pyenv;
    
    % Get the Python executable path
    pythonHomePath = pyEnv.Home;
    
    % Construct the pip3 executable path
    pythonScriptsPath = fullfile(pythonHomePath, "Scripts"); % Construct the path to the Scripts directory where pip is typically located
    pipPath = dir(fullfile(pythonScriptsPath,"pip3.*")); % Search for pip3 executable files in the Scripts directory
    pipPath = string({pipPath.name}); % Convert the found file names to a string array
    pipPath = pipPath(matches(pipPath,"pip3." + lettersPattern + textBoundary("end"))); % Filter the array to keep only valid pip3 executable names
    pipPath = fullfile(pythonScriptsPath,pipPath); % Construct the full path to the pip3 executable
    
    % Verify that the pip executable exists    
    if ~exist(pipPath, 'file')
        error('mlboost:python:PIPNotFound', 'Unable to locate pip executable.');
    end
end