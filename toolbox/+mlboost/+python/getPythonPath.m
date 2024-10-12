%GETPYTHONPATH Get the Python executable path
%   pythonPath = getPythonPath() returns the full path to the Python
%   executable currently used by MATLAB.
%
%   This function uses the pyenv command to retrieve information about the
%   Python environment and extracts the path to the Python executable.
%
%   Returns:
%       pythonPath - A string containing the full path to the Python executable
function pythonPath = getPythonPath()
    % Get the Python executable path using pyenv
    pyEnv = pyenv;
    pythonPath = pyEnv.Executable;
end
