function retrieveFromCDS(name,options,zipfilePath)
% Utility function to isolate python code so that we don't trigger the
% python check until after python install checks are done.

% Copyright 2021 The MathWorks, Inc.
    c = py.cdsapi.Client();

    % Don't show the progress information
    c.quiet = true;
    c.progress = false;
    c.retrieve(name,options,zipfilePath);
end