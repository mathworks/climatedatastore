function gendocToolbox(rootDir)

    arguments
        rootDir (1,1) string = pwd();
    end

    docDir = fullfile(rootDir,"toolbox","doc");
    htmlDir = fullfile(docDir,"html");
    mlxFileInfo = dir(fullfile(docDir,"*.mlx"));
    mlxFiles = string({mlxFileInfo.name}');
    for iFile = 1:size(mlxFiles,1)
        [~, filename] = fileparts(mlxFiles(iFile));
        export(fullfile(docDir,mlxFiles(iFile)),fullfile(htmlDir,filename + ".html"));
    end
end

