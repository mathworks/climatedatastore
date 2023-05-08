function writeBadgeJSONFile(label,message,color)

    arguments
        label (1,1) string
        message (1,1) string
        color (1,1) string {mustBeMember(color,["red","green","blue","orange","yellow"])}
    end
    outputDirectory = fullfile("reports","badge");
    if isempty(dir(outputDirectory))
        mkdir(outputDirectory)
    end
    badgeInfo = struct;
    badgeInfo.schemaVersion = 1;
    badgeInfo.label = label;
    badgeInfo.message = message;
    badgeInfo.color = color;
    badgeJSON = jsonencode(badgeInfo);

    name = strrep(label," ","_");
    fid = fopen(fullfile(outputDirectory,name + ".json"),"w");
    try
        fwrite(fid,badgeJSON);
    catch e
        fclose(fid);
        rethrow e
    end
    fclose(fid);
    
end
