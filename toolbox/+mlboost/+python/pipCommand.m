function commandOutput = pipCommand(pipArguments)
% Execute a pip command
% This function executes a pip command using the specified pip executable path.
%
% Syntax:
%   outputResult = pipCommand(pipArguments)
%
% Inputs:
%   pipArguments - A string containing the command for pip and its arguments
%
% Outputs:
%   outputResult - The output of the executed pip command
%
% Throws:
%   An error if no arguments are provided or if the pip command fails
%
% Example:
%   outputResult = pipCommand('install cdsapi')
%
% See also:
%   mlboost.python.getPipPath

    arguments
        pipArguments (1,1) string
    end

    % Combine the PIP command with the provided arguments
    fullCommand = sprintf('"%s" %s', mlboost.python.getPipPath(), pipArguments);

    % Execute the command using system
    [exitStatus, commandOutput] = system(fullCommand);
    commandOutput = string(commandOutput);

    % Check if the command was executed successfully
    if exitStatus ~= 0
        error("mlboost:pipCommandFailed","pip3 command ""%s"" failed: ""%s"" (exit code %d)", pipArguments, strtrim(commandOutput), exitStatus);
    end
end
