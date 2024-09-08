function newVersion = packageToolbox(releaseType, versionString)
% packageToolbox Package a new version of a toolbox. Package a new version
% of the toolbox based on the toolbox packaging (.prj) file in current
% working directory. MLTBX file is put in ./release directory. 
%
% packageToolbox() Build is automatically incremented.  
%
% packageTookbox(releaseType) RELEASETYPE  can be "major", "minor", or "patch" 
% to update semantic version number appropriately.  Build (fourth elecment in 
% semantic versioning) is always updated automatically.
%
% packageTookbox('specific',versionString) VERSIONSTRING is a string containing
% the specific 3 part semantic version (i.e. "2.3.4") to use.

    arguments
        releaseType {mustBeTextScalar,mustBeMember(releaseType,["build","major","minor","patch","specific"])} = "build"
        versionString {mustBeTextScalar} = "";
    end

    outputDirectory = "release";

    % Look for the Toolbox packaging file in the current working directory
    tbxPackagingProjectFile = findTBXPackagingProjectFile(pwd);
    if tbxPackagingProjectFile == ""
        error("releaseToolbox:NoTbxPrjFound","No Toolbox Packaging Project found.")
    end

    % GitHub issue #11.  Toolbox packaging from GitHub action does not put <toolboxdir>/internal and <toolboxdir>/doc on the path.
    previouspath = addpath(fullfile(pwd,"toolbox","internal"),...
            fullfile(pwd,"toolbox","doc"));

    newVersion = updateMLTBXVersion(tbxPackagingProjectFile,releaseType, versionString);
    matlab.addons.toolbox.packageToolbox(tbxPackagingProjectFile);

    % Revert path changes
    path(previouspath);

    mltbxFile = findMLTBXFile(pwd);
    % Replace spaces with underscores to be GitHub friendly and move to releases directory
    [filepath,filename,ext] = fileparts(mltbxFile);
    newMltbxFilename = strrep(filename," ","_");
    if isempty(dir(outputDirectory))
        mkdir(outputDirectory)
    end
    movefile(mltbxFile,fullfile(filepath,outputDirectory,newMltbxFilename+ext));
    
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
            catch %#ok<CTCH> 
                tbxPackagingProjectFilename = "";
                break
            end
        end
    end

    function newVersion = updateMLTBXVersion(packagingProjectFile, releaseType, versionString)
        oldVersion = string(matlab.addons.toolbox.toolboxVersion(packagingProjectFile));
        pat = digitsPattern;
        versionParts = extract(oldVersion,pat);
        if numel(versionParts) == 1 %#ok<ISCL> Using numel == 1 for symmetry
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
            case "specific"        
                if startsWith(versionString,"v")
                    % if there's a "v" at the front, which is common in github, remove it
                    versionString = extractAfter(versionString,1);
                end
                newVersionParts = extract(versionString,pat);
                if any(size(newVersionParts) ~= [3 1])
                    error("releaseToolbox:versionMustBe3part","VersionString must be a 3 part semantic version (i.e. ""1.2.3"").")
                end
                versionParts(1) = newVersionParts(1);
                versionParts(2) = newVersionParts(2);
                versionParts(3) = newVersionParts(3);
        end
        % Always increment the build number
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
