function codecheckToolbox(rootDir)
    arguments
        rootDir (1,1) string  = pwd();
    end

    toolboxFileInfo = dir(fullfile(rootDir,"climatedatastoreToolbox","**","*.m*"));
    filesToCheck = fullfile(string({toolboxFileInfo.folder}'),string({toolboxFileInfo.name}'));
    
    testFileInfo = dir(fullfile(rootDir,"test","*.m"));
    filesToCheck = [filesToCheck;fullfile(string({testFileInfo.folder}'),string({testFileInfo.name}'))];

    testFileInfo = dir(fullfile(rootDir,"buildutil","*.m"));
    filesToCheck = [filesToCheck;fullfile(string({testFileInfo.folder}'),string({testFileInfo.name}'))];
    
    if isempty(filesToCheck)
        error("climatedatastore:codeissues","No files to check.")
    end
    issues = checkcode(filesToCheck);
    issues = [issues{:}];
    issueCount = size(issues,1);

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
        checkcode(filesToCheck)
        error("climatedatastore:codeissues","Climate Data Toolbox requires all code check issues be resolved.")
    end
end

