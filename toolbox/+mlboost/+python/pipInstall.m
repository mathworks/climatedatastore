function installResult = pipInstall(packageName, option)
    %PIPINSTALL Install a Python package using pip
    %   INSTALLRESULT = mlboost.python.pipInstall(PACKAGENAME) installs the
    %   specified Python package using pip and returns the installation result.
    %
    %   INSTALLRESULT = mlboost.python.pipInstall(PACKAGENAME, 'Name', Value)
    %   specifies additional installation options using one or more name-value
    %   pair arguments.
    %
    %   Input arguments:
    %       PACKAGENAME - Name of the Python package to install (string)
    %
    %   Name-value pair arguments:
    %       'version'   - Specific version of the package to install (string)
    %       'upgrade'   - Whether to upgrade the package if already installed
    %       (logical)
    %
    %   Output:
    %       INSTALLRESULT - Installation result returned by pip (optional)
    %
    %   Example:
    %       pipInstall('numpy', 'version', '1.21.0', 'upgrade', true)
    %
    %   See also mlboost.python.pipCommand

    arguments
        % Name of the Python package to install
        packageName (1,1) string
        % Specific version of the package to install (optional)
        option.version (1,1) string = "";
        % Whether to upgrade the package if already installed (optional)
        option.upgrade (1,1) logical = false
    end

    % Build the pip command string based on input arguments Start with
    % "install" followed by the package name If a version is specified,
    % append it to the command If upgrade option is true, add the
    % "--upgrade" flag
    command = sprintf("install %s",packageName);
    if option.version ~= ""
        command = command + sprintf("==%s", option.version);
    end
    if option.upgrade
        command = command + " --upgrade";
    end

    % Execute the pip command using the mlboost.python.pipCommand
    % function and store the output in cmdout
    cmdout = mlboost.python.pipCommand(command);

    % If an output argument is requested, assign the command output to
    % installResult
    if nargout > 0
        installResult = cmdout;
    end

    % Construct the pip install command
    command = sprintf("install %s",packageName);
    if option.version ~= ""
        command = command + sprintf("==%s", option.version);
    end
    if option.upgrade
        command = command + " --upgrade";
    end

    cmdout = mlboost.python.pipCommand(command);

    if nargout > 0
        installResult = cmdout;
    end
end
