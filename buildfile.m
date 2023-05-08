function plan = buildfile()

    plan = buildplan(localfunctions);
    
    plan.DefaultTasks = "test";
    
    plan("package").Dependencies = "publishDoc";

    plan("publishDoc").Dependencies = "test";
    
    plan("test").Dependencies = "check";
end

function checkTask(context)
    % Temporarily add buildUtilities to the path (remove it at the end of the function)
    oldPath = addpath(fullfile(context.Plan.RootFolder,"buildUtilities"));
    raii = onCleanup(@()(path(oldPath)));
    
    codecheckToolbox(context.Plan.RootFolder);
end

function testTask(context)
    % Temporarily add buildUtilities to the path (remove it at the end of the function)
    oldPath = addpath(fullfile(context.Plan.RootFolder,"buildUtilities"));
    raii = onCleanup(@()(path(oldPath)));
    
    testToolbox()
end

function publishDocTask(context)
    % Generate HTML files

    % Temporarily add buildUtilities to the path (remove it at the end of the function)
    oldPath = addpath(fullfile(context.Plan.RootFolder,"buildUtilities"));
    raii = onCleanup(@()(path(oldPath)));

    gendocToolbox(context.Plan.RootFolder)
end

function packageTask(context)
    % Package the toolbox in an MLTBX, just incrementing build.  Note that GitHub action calls packageToolbox directly.

    % Temporarily add buildUtilities to the path (remove it at the end of the function)
    oldPath = addpath(fullfile(context.Plan.RootFolder,"buildUtilities"));
    raii = onCleanup(@()(path(oldPath)));

    packageToolbox("build")
end 
