function buildToolbox(releaseType)

    arguments
        releaseType {mustBeTextScalar,mustBeMember(releaseType,["build","major","minor","patch"])} = "build"
    end

    if isMATLABReleaseOlderThan("R2022a")
        error("climatedatatoolbox:releaseFromLatest","While the toolbox supports earlier versions, it should be build on the latest.")
    end
    
    prj = currentProject;
    rootDir = prj.RootFolder;
    toolboxDir = fullfile(rootDir,"toolbox");

    % Check for code issues
    codecheckToolbox(rootDir);
    disp("code check complete.");

    % Run unit tests and capture code coverage
    testToolbox()
    % Update Badges for GitHub.com
    badgesforToolbox(rootDir)
    disp("test complete");

    % Generate HTML files
    gendocToolbox(toolboxDir)
    disp("documentation generation complete");
    
    % Package the toolbox in an MLTBX
    packageToolbox(releaseType);
    disp("packaging complete");
end
