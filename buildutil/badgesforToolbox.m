function badgesforToolbox(rootDir)
    %BADGESFORTOOLBOX Take the test reports from the runs against multiple releases, and gnerate the "Tested with" badge
    arguments
        rootDir (1,1) string  = pwd();
    end
    
    releasesTestedWith = "";
    % Go through the R2* directories and extract the failed test info
    releaseDirectoryInfo = dir(fullfile(rootDir,"report"));
    % Select only folders
    releaseDirectoryInfo = releaseDirectoryInfo([releaseDirectoryInfo.isdir]);
    % with a name like R2*
    releaseDirectoryInfo = releaseDirectoryInfo(startsWith(string({releaseDirectoryInfo.name}),"R2","IgnoreCase",true));
    % go through the directories and check if tests passed
    for iReleaseDirectoryInfo = 1:numel(releaseDirectoryInfo)
        releaseName = string(releaseDirectoryInfo(iReleaseDirectoryInfo).name);
        testresultsFilename = fullfile(releaseDirectoryInfo(iReleaseDirectoryInfo).folder,releaseName,"test-results.xml");
        % Read the test results file
        testResults = readstruct(testresultsFilename);
        % If no tests failed, errors, or were skipped, then add it to the list
        if testResults.testsuite.errorsAttribute == 0 && testResults.testsuite.failuresAttribute == 0 && testResults.testsuite.skippedAttribute == 0
            if releasesTestedWith ~= ""
                % Insert the seperator between released after the first one
                releasesTestedWith = releasesTestedWith + " | ";
            end
            releasesTestedWith = releasesTestedWith + releaseName;
        end
    end
    if releasesTestedWith ~= ""
        writeBadgeJSONFile("tested with", releasesTestedWith, "blue")
    end
end

