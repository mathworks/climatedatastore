%PIPSHOW Show information about installed Python packages
%   RESULT = mlboost.python.pipShow(PACKAGENAME) returns a struct containing information
%   about the specified Python package.
%
%   Input:
%       PACKAGENAME - A string specifying the name of the package to query
%
%   Output:
%       RESULT - A struct containing package information fields such as
%                Name, Version, Summary, Home-page, Author, etc.
%
%   This function uses the 'pip show' command to retrieve package
%   information and parses the output into a MATLAB struct.
%
%   Example:
%       info = mlboost.python.pipShow('cdsapi');
%       disp(info.Version);
%
%   See also mlboost.python.pipCommand
function result = pipShow(packageName)

    arguments
        packageName (1,1) string
    end

    % Call pip show on the specified package
    pipShowOutput = mlboost.python.pipCommand("show " + packageName);

    % Initialize the struct
    result = struct();

    % Split the output into lines and remove extra whitespace
    lines = strsplit(pipShowOutput, '\n');
    lines = strtrim(lines);
    lines(lines == "") = [];

    % Parse each line and add to struct
    for i = 1:length(lines)
        property = strtrim(extractBefore(lines(i),":"));
        value = strtrim(extractAfter(lines(i),":"));
        result.(matlab.lang.makeValidName(property)) = value;
    end
end
