function codecheckToolbox(toolboxDir)
    arguments
        toolboxDir (1,1) string  = pwd();
    end

    fileInfo = dir(fullfile(toolboxDir,"*.m"));
    filesToCheck = fullfile(string({fileInfo.folder}'),string({fileInfo.name}'));
    issues = checkcode(filesToCheck);
    issues = [issues{:}];
    issueCount = size(issues,1);

    % Generate the JSON files for the shields in the readme.md
    if issueCount == 0
        color = "green";
    else
        color = "red";
    end
    writeBadgeJSONFile("code issues",string(issueCount), color)
    
    if issueCount ~= 0
        checkcode(filesToCheck)
        error("climatedatastore:codeissues","Climate Data Toolbox requires all code check issues be resolved.")
    end
end

