function codecheckToolbox(rootDir)
    arguments
        rootDir (1,1) string  = pwd();
    end

    toolboxFileInfo = dir(fullfile(rootDir,"toolbox","**","*.m*"));
    filesToCheck = fullfile(string({toolboxFileInfo.folder}'),string({toolboxFileInfo.name}'));
    
    testFileInfo = dir(fullfile(rootDir,"tests","*.m"));
    filesToCheck = [filesToCheck;fullfile(string({testFileInfo.folder}'),string({testFileInfo.name}'))];

    testFileInfo = dir(fullfile(rootDir,"buildUtilities","*.m"));
    filesToCheck = [filesToCheck;fullfile(string({testFileInfo.folder}'),string({testFileInfo.name}'))];
    
    if isempty(filesToCheck)
        error("climatedatastore:codeissues","No files to check.")
    end

    if verLessThan('matlab','9.13')
        % Use the old check code before R2022b
        issues = checkcode(filesToCheck);
        issues = [issues{:}];
        issueCount = size(issues,1);
    else
        % Use the new code analyzer in R2022b and later
        issues = codeIssues(filesToCheck);
        issueCount = size(issues.Issues,1);
    end

    fprintf("checked %d files with %d issue(s).\n",numel(filesToCheck),issueCount)

    % Generate the JSON files for the shields in the readme.md
    switch issueCount
        case 0
            color = "green";
        case 1
            color = "yellow";
        otherwise
            color = "red";
    end
    writeBadgeJSONFile("code issues",string(issueCount), color)
    
    if issueCount ~= 0
        if verLessThan('matlab','9.13')
            % pre R2022b, run checkcode without a RHS argument to display issues
            checkcode(filesToCheck)
        else
            % R2022b and later, just display issues
            disp(issues)
        end
        error("climatedatastore:codeissues","Climate Data Toolbox requires all code check issues be resolved.")
    end
end

