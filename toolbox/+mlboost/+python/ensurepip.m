function ensurepip(option)
%ENSUREPIP Downloads and runs get-pip.py to ensure pip is installed
%
%   ensurepip() downloads and runs get-pip.py to install pip.
%
%   ensurepip(Name,Value) specifies additional options using one or more
%   name-value pair arguments:
%
%   'ShowSuccessMessage'  Logical value indicating whether to display a
%                         success message after installation. Default is false.
%
%   Example:
%      ensurepip('ShowSuccessMessage', true)
%
%   See also mlboost.python.getPythonExecutable, mlboost.python.getPipPath

    arguments
        option.ShowSuccessMessage (1,1) logical = false;
    end

    % Create a temporary directory
    tempDir = tempname;
    mkdir(tempDir);

    % Set up cleanup object to
    cleanupObj = onCleanup(@() rmdir(tempDir, 's'));

    % Download get-pip.py
    url = "https://bootstrap.pypa.io/get-pip.py";
    outputFile = fullfile(tempDir, "get-pip.py");
    websave(outputFile, url);

    % Run get-pip.py
    pythonExe = mlboost.python.getPythonExecutable();
    command = sprintf('"%s" "%s"', pythonExe, outputFile);

    [status, output] = system(command);

    if status == 0
        if option.ShowSuccessMessage
            successMessage = extract(string(output),"Successfully installed" + wildcardPattern(3,inf) + whitespaceBoundary("start"));
            disp(successMessage);
        end
    else
        error("mlboost:pipinstallfailed","Failed to install pip. Error: %s", output);
    end

    % Cleanup will be automatically performed when the function exits
end