function gendocToolbox(rootDir)
%GENDOCTOOLBOX Summary of this function goes here
%   Detailed explanation goes here
    arguments
        rootDir (1,1) string = pwd();
    end

    docDir = fullfile(rootDir,"climatedatastoreToolbox","doc");
    htmlDir = fullfile(docDir,"html");
    mlxFileInfo = dir(fullfile(docDir,"*.mlx"));
    mlxFiles = string({mlxFileInfo.name}');
    for iFile = 1:size(mlxFiles,1)
        [~, filename] = fileparts(mlxFiles(iFile));
        export(mlxFiles(iFile),fullfile(htmlDir,filename + ".html"));
    end
end

