function [filePaths, citation] = climateDataStoreDownload(name,options)
%climateDataStoreDownload Get data from Copernicus Climate Data Store
% Download a data set from the Copernicus Climate Data Store.
% (https://cds.climate.copernicus.eu/cdsapp)
%
% Find your dataset at Climate Data Store and click on the "download data"
% tab.  Make your selections for the subset of data you want.  Click "show
% API request" at the bottom.  
%
% NAME is the name of the data set to retrieve, and will also be used as
% the name of the directory to put the downloaded files in.  OPTIONS is a
% MATLAB structure matching the python structure shown when you choose
% "Show API request".  The data files are downloaded, and the function
% returns FILEPATHS, a list of files downloaded.  In addition, the function
% provides CITATION, which is the correct citiation to use with the data
% retrieved.
% 
% Downloading the files can take some time, depending on how large they are.
%
% Notes:
% * You must have:
%   * python 3.8 installed
%     (https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe)
%   * the cdsapi python package (pip3 install cdsapi)
%   * Your credentials need to be in a .cdsapirc file in your user
%     directory. See https://cds.climate.copernicus.eu/api-how-to for more info
% * This function relies on the Python API to access the Copernicus Climate
%   Data Store (CDS) (https://github.com/ecmwf/cdsapi) by the European Centre
%   for Medium-Range Weather Forecasts (ECMWF)
%
% Example: Sea Ice thickness
% (https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-ice-thickness)
% options.version = "1_0";
% options.variable = "all";
% options.satellite = "cryosat_2";
% options.cdr_type = ["cdr","icdr"]; 
% options.year = ["2011","2021"]; 
% options.month = "03";
% downloadedFilePaths = climateDataStoreDownload('satellite-sea-ice-thickness',options);

% Copyright 2021 The MathWorks, Inc.

    validateattributes(name,{'string','char'},{'scalartext'});
    validateattributes(options,'struct',{'scalar'});

    % Diagnostics
    setupPythonIfNeeded();
    setupCDSAPIIfNeeded();
  
    

    % Convert the structure from strings to char and cellstr.
    options = makeStringsChars(options);

    % Force download option to ZIP
    options.format = 'zip';

    zipfilePath = string(tempname) + ".zip";
    
    retrieveFromCDS(name,options,zipfilePath);

    filePaths = string(unzip(zipfilePath,name)');
    citation = "Generated using Copernicus Climate Change Service information " + string(datetime('now','Format','y'));

    % Delete the temporary ZIP file
    delete(zipfilePath);
end

function theStruct = makeStringsChars(theStruct)
    fields = string(fieldnames(theStruct));
    for iField = 1:numel(fields)
        if isstring(theStruct.(fields(iField)))
            if isscalar(theStruct.(fields(iField)))
                % Convert scalar strings to char
                theStruct.(fields(iField)) = char(theStruct.(fields(iField)));
            else
                % Convert string arrays to cell array of chars
                theStruct.(fields(iField)) = cellstr(theStruct.(fields(iField)));
            end
        end
    end
end
