function pipPackages = pipList()
    % Call pip freeze using mlboost.python.boost and parse the results
    % Returns a table of installed packages and their versions

    % Call pip freeze
    pipFreeze = mlboost.python.pipCommand("freeze");

    % Split the output into lines, remove empty lines
    lines = strtrim(splitlines(pipFreeze));
    lines(lines == "") = [];

    % Split each line into package name and version
    parts = split(lines, '==');

    % Create a table with the package name and version
    pipPackages = table(parts(:,1), parts(:,2), 'VariableNames', {'Package', 'Version'});
end