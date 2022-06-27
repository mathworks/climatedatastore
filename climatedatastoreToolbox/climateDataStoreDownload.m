function [filePaths, citation] = climateDataStoreDownload(datasetName,datasetOptions,options)
%climateDataStoreDownload Get data from Copernicus Climate Data Store
% Download a data set from the Copernicus Climate Data Store. (https://cds.climate.copernicus.eu/cdsapp)
%
% Find your dataset at Climate Data Store and click on the "download data" tab.  Make your selections for the subset of data you want.  Click "show
% API request" at the bottom.
%
% [filePaths, citation] = climateDataStoreDownload(datasetName,datasetOptions) retrieves the data set with the name datasetName, and will also be used
% as the name of the directory or file downloaded files, with a date/time stamp added.  datasetOptions is a MATLAB structure matching the python
% structure shown when you choose "Show API request".  filePaths is string array of the files downloaded. The function returns FILEPATHS, a list of
% files downloaded.  The function also  returns citation, which is the correct citiation to use with the data retrieved.
%
% climateDataStoreDownload(...,Timeout Sets the maximum time in seconds to wait for a response.
% climateDataStoreDownload(...,DontExpandZIP=true Results that are ZIP files are not automatically expanded.
% climateDataStoreDownload(...,DontPromptForCredentials=true If no credentials are present, don't request them (intended for tests)
% 
% Downloading the files can take some time, depending on how large they are (I've had it take 30 minutes!).  You can check on the status of your
% request by visiting https://cds.climate.copernicus.eu/cdsapp#!/yourrequests.  For large requests, you may want to consider using
% climateDataStoreDownloadAsync, which queues a request and returns, allowing you to keep working.
%
% You must have:
%   * python 3.8 installed (https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe)
%   * the cdsapi python package (pip3 install cdsapi)
%   * Your credentials need to be in a .cdsapirc file in your user directory. See https://cds.climate.copernicus.eu/api-how-to for more info
%   * This function relies on the Python API to access the Copernicus Climate Data Store (CDS) (https://github.com/ecmwf/cdsapi) by the European
%     Centre for Medium-Range Weather Forecasts (ECMWF)
%
% Example: Sea Ice thickness (https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-ice-thickness)
%     datasetOptions.version = "1_0";
%     datasetOptions.variable = "all";
%     datasetOptions.satellite = "cryosat_2";
%     datasetOptions.cdr_type = ["cdr","icdr"]; 
%     datasetOptions.year = ["2011","2021"]; 
%     datasetOptions.month = "03";
%     downloadedFilePaths = climateDataStoreDownload('satellite-sea-ice-thickness',datasetOptions);
%
% See Also: climateDataStoreDownloadAsync

% Copyright 2021-2022 The MathWorks, Inc.

    arguments
        datasetName (1,1) string
        datasetOptions (1,1) struct
        options.DontExpandZIP (1,1) logical = false;
        options.DontPromptForCredentials (1,1) logical = false;
        options.Timeout (1,1) double = Inf;
        options.UseMocks (1,1) logical = false;
    end
  
    f = climateDataStoreDownloadFuture(datasetName, datasetOptions,options);
    f.wait(options.Timeout);
    if f.State == "failed"
        throwAsCaller(f.Error)
    end
    assert(f.State == "completed","climateDataStore:UnexpectedState","cdsRequestState should be complete, it's %s",f.State)

    filePaths = f.OutputArguments{1};
    citation = f.OutputArguments{2};
end
