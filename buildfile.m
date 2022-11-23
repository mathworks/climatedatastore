function plan = buildfile()

    % Copyright 2022 The MathWorks, Inc.

    plan = buildplan(localfunctions);
    
    plan.DefaultTasks = "test";
    
    plan("package").Dependencies = "publishDoc";

    plan("publishDoc").Dependencies = "test";
    
    plan("test").Dependencies = "check";
end

function checkTask(context)
    codecheckToolbox(context.Plan.RootFolder);
end

function testTask(~)
    testToolbox()
end

function publishDocTask(context)
    % Generate HTML files
    gendocToolbox(context.Plan.RootFolder)
end

function packageTask(~)
    % Package the toolbox in an MLTBX, just incrementing build
    packageToolbox("build")
end 
