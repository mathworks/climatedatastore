function newVersion = packageToolbox(releaseType)
% packageToolbox Package a new version of a toolbox. Package a new version
% of the toolbox based on the toolbox packaging (.prj) file in current
% working directory. MLTBX file is put in ./release directory. Version is
% automatically incremented.  You can optionally set RELEASETYPE to
% "major", "minor", or "patch" to update semantic version number
% appropriately.

% Copyright 2021 The MathWorks, Inc.
    arguments
        releaseType {mustBeTextScalar,mustBeMember(releaseType,["build","major","minor","patch"])} = "build"
    end

    outputDirectory = "release";

    % Look for the Toolbox packaging file in the current working directory
    tbxPackagingProjectFile = findTBXPackagingProjectFile(pwd);
    if tbxPackagingProjectFile == ""
        error("releaseToolbox:NoTbxPrjFound","No Toolbox Packaging Project found.")
    end
    newVersion = incrementMLTBXVersion(tbxPackagingProjectFile,releaseType);
    matlab.addons.toolbox.packageToolbox(tbxPackagingProjectFile);
    mltbxFile = findMLTBXFile(pwd);
    % Replace spaces with underscores to be GitHub friendly and move to releases directory
    [path,filename,ext] = fileparts(mltbxFile);
    newMltbxFilename = strrep(filename," ","_");
    if isempty(dir(outputDirectory))
        mkdir(outputDirectory)
    end
    movefile(mltbxFile,fullfile(path,outputDirectory,newMltbxFilename+ext));
    
    function tbxPackagingProjectFilename = findTBXPackagingProjectFile(directoryToSearch)
        % Unfortunately, Toolbox Packaging Projects and MATLAB projects both use the
        % .PRJ extension, and so we have to interrogate each one to see if
        % it a valid Toolbox Packaging Project.
        prjFiles  = dir(string(fullfile(directoryToSearch,"*.prj")));
        prjFiles  = fullfile(directoryToSearch,string({prjFiles.name}));
        tbxPackagingProjectFilename = "";
        for iPrjFile = 1:numel(prjFiles)
            try
                % try to get the version number, if it fails, try the next
                % one
                matlab.addons.toolbox.toolboxVersion(prjFiles(iPrjFile));
                tbxPackagingProjectFilename = prjFiles(iPrjFile);
                return
            catch
                tbxPackagingProjectFilename = "";
                return
            end
        end
    end

    function newVersion = incrementMLTBXVersion(packagingProjectFile, releaseType)
        oldVersion = string(matlab.addons.toolbox.toolboxVersion(packagingProjectFile));
        pat = digitsPattern;
        versionParts = extract(oldVersion,pat);
        if numel(versionParts) == 1
            versionParts(2) = "0";
        end
        if numel(versionParts) == 2
            versionParts(3) = "0";
        end
        if numel(versionParts) == 3
            versionParts(4) = "0";
        end
        
        switch lower(releaseType)
            case "major"
                versionParts(1) = string(str2double(versionParts(1)) + 1);
                versionParts(2) = "0";
                versionParts(3) = "0";
            case "minor"
                versionParts(2) = string(str2double(versionParts(2)) + 1);
                versionParts(3) = "0";
            case "patch"
                versionParts(3) = string(str2double(versionParts(3)) + 1);
        end
        versionParts(4) = string(str2double(versionParts(4)) + 1);
        newVersion = join(versionParts,".");
        matlab.addons.toolbox.toolboxVersion(packagingProjectFile,newVersion);    
    end
    
    function mltbxFilename = findMLTBXFile(directoryToSearch)
        % Unfortunately, Toolbox Packaging doesn't tell us the name of the MLTBX it created, so we have to search.
        mltbxFiles  = dir(string(fullfile(directoryToSearch,"*.mltbx")));
        mltbxFiles  = fullfile(directoryToSearch,string({mltbxFiles.name}));
        mltbxFilename = "";
        if ~isempty(mltbxFiles)
            mltbxFilename = mltbxFiles(1);
        end
    end
end 
